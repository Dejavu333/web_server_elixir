
#!MODULES
defmodule SimpleClient  # A simple TCP client that connects to a server and sends a request to the server.
do
  #?MODULE ATTRIBUTES
  @host :localhost
  @port 8080

  #?METHODS
  #*SENDS DATA TO THE SERVER
  def send_data(data) do  # Connect to the server using the connect() function, send a request to the server using the send() function, and read the server's response using the recv() function.

    #ß STEP 1: Connect to the server
    {:ok, connecting_socket} = :gen_tcp.connect(@host, @port,
                    [
                      {:active, :false},
                      {:mode, :binary},
                      {:packet, :line}
                    ]
    )

    #ß STEP 2: Send a request to the server
    :ok = :gen_tcp.send(connecting_socket, data)

    #ß STEP 3: Read the server's response
    case :gen_tcp.recv(connecting_socket, 0) do
      {:ok, line} ->
        IO.puts ~s(Client got: "#{String.trim line}")
        :ok = :gen_tcp.close(connecting_socket)

      {:error, :closed} -> IO.puts("Server closed connecting_socket.")

    end
  end # def send_data ends
end # module SimpleClient ends
