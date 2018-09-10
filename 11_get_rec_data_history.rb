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
  client = Savon.client(basic_auth: [ARGV[0], ARGV[1]],wsdl: "http://monitoring.pl/s8/LogisticWebService/LogisticWebService.asmx?wsdl")

  response = client.call(:get_rec_data_history, message: {
      obj_id: obj_id,
      start_time: '2018-08-01T00:00:00+00:00',
      stop_time: '2018-09-01T23:59:00+00:00',
    })
   # puts response.body
   if response.body[:get_rec_data_history_response][:get_rec_data_history_result]
     obj_list = response.body[:get_rec_data_history_response][:get_rec_data_history_result][:logistic_db_rec_data]
     all_statuses << obj_list
   else
     puts "Empty"
   end
end

 CSV.open("rec_data_history.csv", "wb", headers: all_statuses.first.keys, :write_headers => true) do |csv|
   all_statuses.each do |obj|
     csv << obj.values
   end
 end
