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

  response = client.call(:get_obj_history_status, message: { obj_id: obj_id})
  if response.body[:get_obj_history_status_response][:get_obj_history_status_result]
    obj_list = response.body[:get_obj_history_status_response][:get_obj_history_status_result][:obj_status]
    #convert strange arry to proper hash
    obj_list2 = obj_list.map{|elem|[elem[:key].to_underscore,elem[:value]]}
    obj_hash = Hash[obj_list2]
    obj_hash["obj_id"] = obj_id
    all_statuses << obj_hash
  else
    puts "Empty"
  end
end

CSV.open("obj_history_status.csv", "wb", headers: all_statuses.first.keys, :write_headers => true) do |csv|
  all_statuses.each do |obj|
    csv << obj.values
  end
end
