
#!IMPORT MODULES
Code.require_file("client.ex")

#!SEND DATA TO THE SERVER

defmodule Program
do
  def loopfunc() do
    IO.write("Enter a message: ")
    message = IO.gets("")
    SimpleClient.send_data(message)
    loopfunc()
  end
end

Program.loopfunc()
