wifi.setmode(wifi.SOFTAP);

wifi.ap.config({ssid="test",pwd="12345678"});

if srv~=nil then
  srv:close()
end
srv=net.createServer(net.TCP) 

function Sendfile(connection, filename)
    
        
        local bytesRemaining = file.list()[filename]
        local chunkSize = 512
        local fileHandle = file.open(filename)
        while bytesRemaining > 0 do
            local bytesToRead = 0
            if bytesRemaining > chunkSize then bytesToRead = chunkSize else bytesToRead = bytesRemaining end
            local chunk = fileHandle:read(bytesToRead)
            connection:send(chunk)
            bytesRemaining = bytesRemaining - #chunk
            print(filename .. ": Sent "..#chunk.. " bytes, " .. bytesRemaining .. " to go.")
            chunk = nil
            collectgarbage()
        end
        fileHandle:close()
        fileHandle = nil
        collectgarbage()
end



srv:listen(80,function(conn) 
    conn:on("receive", function(client,request)
        Sendfile(conn,"index.html");
        client:close();
        collectgarbage();
    end)
end)
