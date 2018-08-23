require 'savon'
require 'csv'
class String
  def to_underscore!
    gsub!(/(.)([A-Z])/,'\1_\2')
    downcase!
  end
  def to_underscore
    dup.tap { |s| s.to_underscore! }
  end
end

all_statuses = []

CSV.foreach("obj_list.csv", headers: :first_row) do |obj|
  obj_id = obj['obj_id']
  puts obj_id
  client = Savon.client(basic_auth: [ARGV[0], ARGV[1]],wsdl: "http://monitoring.pl/s115/LogisticWebService/LogisticWebService.asmx?wsdl")

  response = client.call(:get_obj_periodic_status, message: {
      obj_ids: [int: obj_id],
      start_time: '2017-05-01T00:00:00+00:00',
      stop_time: '2017-12-01T00:00:00+00:00',
      track_options: [{track_options: {key:'' , value: ''}}]
    })
  if response.body[:get_obj_periodic_status_response][:get_obj_periodic_status_result]
    obj_list = response.body[:get_obj_periodic_status_response][:get_obj_periodic_status_result][:obj_periodic_status]
    #multiplikujemy dane do statusów
    status_list = obj_list[:obj_statuses]
    status_list = [status_list] if status_list.is_a? Hash
    status_list.each do |status_parent|
      status = status_parent[:obj_status]
      status << {key: 'DateTime', value: obj_list[:date_time]}
      #convert strange arry to proper hash
      obj_list2 = status.map{|elem|[elem[:key].to_underscore,elem[:value]]}
      obj_hash = Hash[obj_list2]
      obj_hash["obj_id"] = obj_id
      all_statuses << obj_hash
    end
  else
    puts "Empty"
  end

end

CSV.open("obj_periodic_status.csv", "wb", headers: all_statuses.first.keys, :write_headers => true) do |csv|
  all_statuses.each do |obj|
    csv << obj.values
  end
end
