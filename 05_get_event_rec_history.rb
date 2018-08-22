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

  response = client.call(:get_event_rec_history, message: {
      obj_id: obj_id,
      start_time: '2017-05-01T00:00:00+00:00',
      stop_time: '2017-12-01T00:00:00+00:00'
    })
  if response.body[:get_event_rec_history_response][:get_event_rec_history_result]
    obj_list = response.body[:get_event_rec_history_response][:get_event_rec_history_result][:logistic_db_event_rec_data]

    # when one object is returned no Array is serounding the Hash
    obj_list = [obj_list] if obj_list.is_a? Hash
    # some object is seam to be missing
    obj_list.each{|obj| obj['orginal_obj_id'] = obj_id}
    all_statuses += obj_list
  else
    puts "Empty"
  end

end

CSV.open("event_rec_history.csv", "wb", headers: all_statuses.first.keys, :write_headers => true) do |csv|
  all_statuses.each do |obj|
    csv << obj.values
  end
end
