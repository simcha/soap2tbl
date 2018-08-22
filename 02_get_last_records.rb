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

  response = client.call(:get_last_records, message: { obj_id_list: [int: obj_id]})
  if response.body[:get_last_records_response][:get_last_records_result]
    obj_list = response.body[:get_last_records_response][:get_last_records_result][:logistic_db_rec_data]
    all_statuses << obj_list
  else
    puts "Empty"
  end
end

CSV.open("last_records.csv", "wb", headers: all_statuses.first.keys, :write_headers => true) do |csv|
  all_statuses.each do |obj|
    csv << obj.values
  end
end
