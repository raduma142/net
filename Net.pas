Program Net;

uses
  System.Net, System.Net.Sockets, System.Text;

//Server  
procedure Start_server();
begin
  var serverPort: integer;
  
  write('PORT --> ');
  readln(serverPort);
  
  var serverAddress: IPAddress;
  var server: TcpListener;
  
  serverAddress := IPAddress.Any;
  server := new TcpListener(serverAddress, serverPort);
  server.Start();
  
  writeln('SERVER IN ', Dns.GetHostByName(Dns.GetHostName));
  
  var connection: TcpClient;
  
  while True do
  begin
    connection := server.AcceptTcpClient();
    
    write(connection.Client.RemoteEndPoint.ToString());
    
    var serverStream: NetworkStream := connection.GetStream;
    var bufferSize: integer := 256;
    var serverBuffer: array of byte;
    
    SetLength(serverBuffer, bufferSize);
    
    var bytesRead: integer;
    
    bytesRead := serverStream.Read(serverBuffer, 0, bufferSize);
    
    var message: string;
    
    message := Encoding.UTF8.GetString(serverBuffer, 0, bytesRead);
    
    writeln(' --> ', message);
  end;
  
end;

//Client
procedure Start_client();
begin
  var host: string;
  var port: integer;
  var client: TcpClient;
  
  write('HOST -->');
  readln(host);
  write('PORT -->');
  readln(port);
  
  var clientStream: NetworkStream;
  var message: string;
  
  while True do
  begin
  
    client := new TcpClient(host, port);
  
    write('MESSAGE --> ');
    readln(message);
    
    clientStream := client.GetStream;
    
    var clientBuffer: array of byte;
    
    clientBuffer := Encoding.UTF8.GetBytes(message);
    
    clientStream.Write(clientBuffer, 0, Length(clientBuffer));
    writeln('Sended!');
    
    clientStream.Close();
    client.Close();
    
  end;
  
end;

begin
  var a: char;
  write('Net 0.1; Server (S), Client (C) --> ');
  readln(a);
  if a = 'C' then Start_client()
  else Start_server();
end.