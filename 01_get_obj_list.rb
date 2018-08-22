require 'savon'
require 'csv'

client = Savon.client(basic_auth: [ARGV[0], ARGV[1]],wsdl: "http://monitoring.pl/s115/LogisticWebService/LogisticWebService.asmx?wsdl")
puts client.operations
response = client.call(:get_obj_list, message: { criterion: ""})

obj_list = response.body[:get_obj_list_response][:get_obj_list_result][:logistic_db_obj_data]
CSV.open("obj_list.csv", "wb", headers: obj_list.first.keys, :write_headers => true) do |csv|
  obj_list.each do |obj|
    csv << obj.values
  end
end
