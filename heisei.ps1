#投稿先インスタンスのドメイン
$domain = "mstdn-workers.com"

#アクセストークン write権限必要
$token = "xxxxxxxxxx"

#現在時刻から平成終了日時までの期間を取得
$now = Get-Date
$span = New-TimeSpan $now "2019/4/30 23:59:59"

#投稿テキスト整形
$text = "現在の時刻：" + $now + "`
平成終了まで`
・" + [Math]::Truncate($span.TotalDays).toString("#,#")  + "日`
・" + [Math]::Truncate($span.TotalHours).toString("#,#") + "時間`
・" + [Math]::Truncate($span.TotalMinutes).toString("#,#") + "分`
・" + [Math]::Truncate($span.TotalSeconds).toString("#,#") + "秒"

#toot API URL
$tootUri = "https://" + $domain + "/api/v1/statuses"

#TLS1.2対応
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#toot
$header = @{"Authorization" = "Bearer " + $token}
$toot = @{"status" = $text;"visibility" = "private"}
Invoke-RestMethod -Uri $tootUri -Headers $header -Method Post -Body $toot -ContentType "application/x-www-form-urlencoded" > $null
if(!$?)
{
    Write-Host "ERROR：トゥート失敗"
}