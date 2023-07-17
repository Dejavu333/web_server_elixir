
#!MODULES
# A simple TCP server that listens for a client to connect and then echoes back what the client sends to the server.
defmodule SimpleServer
do
  #?MODULE ATTRIBUTES
  @port 8080

  #?METHODS
  #*STARTS THE SERVER
  def start_tcp_server  # Start the server using the accept_loop() function to listen for a client to connect and then handle the client's request using the handle_client() function.
  do
    #ß STEP 1: Listen for a client to connect
    {:ok, binding_socket} = :gen_tcp.listen(@port,
                    [
                      {:mode, :binary},   # Received data is delivered as a string (v. a list)

                      {:active, :false},  # Data sent to the connecting_socket will not be
                                          # placed in the process mailbox, so you can't
                                          # use a receive block to read it.  Instead
                                          # you must call recv() to read data directly
                                          # from the connecting_socket.

                      {:packet, :line},   # recv() will read from the connecting_socket until
                                          # a newline is encountered, then return.
                                          # If a newline is not read from the connecting_socket,
                                          # recv() will hang until it reads a newline
                                          # from the connecting_socket.

                      {:reuseaddr, true}  # Allows you to immediately restart the server
                                          # with the same port, rather than waiting
                                          # for the system to clean up and free up
                                          # the port.
                    ]
    )
    IO.puts "Listening on port #{@port}...."

    #ß STEP 2: Accept client connections
    accept_loop(binding_socket)
  end

  #*ACCEPTS CLIENT CONNECTIONS
  defp accept_loop(binding_socket)
  do
    {:ok, handling_socket} = :gen_tcp.accept(binding_socket) # handling_socket is created with the same options as binding_socket
    handle_client(handling_socket)
    accept_loop(binding_socket)
  end

  #*HANDLES THE CLIENT'S REQUEST
  defp handle_client(handling_socket)
  do

    #ß STEP 3: Read the client's request
    {:ok,line} = :gen_tcp.recv(handling_socket, 0) # Do not specify the number
                                                   # of bytes to read, instead write 0
                                                   # to indicate that the :packet option
                                                   # will take care of how many bytes to read.
    #ß STEP 4: Send a response to the client
    IO.write("Server received: #{line}")
    :gen_tcp.send(handling_socket, "HTTP/1.1 200 OK\nContent-Type: text/html\n\nServer received: #{line}") #line has a "\n" on the end
  end
end # module SimpleServer ends


#!MODULES
defmodule SimpleClient
do
  #?MODULE ATTRIBUTES
  @host :localhost
  @port 8080

  #?METHODS
  #*SENDS DATA TO THE SERVER
  def send_data do # A simple TCP client that connects to a server and sends a request to the server.

    #ß STEP 1: Connect to the server
    {:ok, connecting_socket} = :gen_tcp.connect(@host, @port,
                    [
                      {:active, :false},
                      {:mode, :binary},
                      {:packet, :line}
                    ]
    )

    #ß STEP 2: Send a request to the server
    :ok = :gen_tcp.send(connecting_socket, "Hi server!\n")

    #ß STEP 3: Read the server's response
    case :gen_tcp.recv(connecting_socket, 0) do
      {:ok, line} ->
        IO.puts ~s(Client got: "#{String.trim line}")
        :ok = :gen_tcp.close(connecting_socket)

      {:error, :closed} -> IO.puts("Server closed connecting_socket.")
    end
  end
end # module SimpleClient ends
