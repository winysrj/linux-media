Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:43734 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaIWOKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 10:10:39 -0400
Message-ID: <1411481434.4050.16.camel@collabora.co.uk>
Subject: Re: [PATCH] [media] s5p-mfc: Use decode status instead of display
 status on MFCv5
From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Arun Kumar K' <arun.kk@samsung.com>,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	'Daniel Drake' <drake@endlessm.com>
Date: Tue, 23 Sep 2014 16:10:34 +0200
In-Reply-To: <085901cfd736$6ae349c0$40a9dd40$%debski@samsung.com>
References: <1411390322-25212-1-git-send-email-sjoerd.simons@collabora.co.uk>
	 <085901cfd736$6ae349c0$40a9dd40$%debski@samsung.com>
Content-Type: multipart/signed; micalg="sha-1"; protocol="application/x-pkcs7-signature";
	boundary="=-YhcPQtbd0XoseixdC3UV"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-YhcPQtbd0XoseixdC3UV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Kamil,


On Tue, 2014-09-23 at 15:58 +0200, Kamil Debski wrote:
> > Commit 90c0ae50097 changed how the frame_type of a decoded frame
> > gets determined, by switching from the get_dec_frame_type to
> > get_disp_frame_type operation. Unfortunately it seems that on MFC v5
> > the
> > result of get_disp_frame_type is always 0 (no display) when decoding
> > (tested with H264), resulting in no frame ever being output from the
> > decoder.
>=20
> Could you tell me which firmware version do you use (date)?

I'm using the firmware version as included in
http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/

Unfortunately there is no specific version information included about
the firmware. The commit that added it is fb5cda9c70277f6 dated Nov 28
17:43:06 2012 +0530, so that at least gives some information about the
time-frame.


--=20
Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Collabora Ltd.

--=-YhcPQtbd0XoseixdC3UV
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIUzDCCBsIw
ggWqoAMCAQICEAoE3yF0XU0rjOozcgUAUOkwDQYJKoZIhvcNAQEFBQAwZTELMAkGA1UEBhMCVVMx
FTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEkMCIGA1UE
AxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4XDTA2MTExMDAwMDAwMFoXDTIxMTExMDAw
MDAwMFowYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3
LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0xMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6IItmfnKwkKVpYBzQHDSnlZUXKnE0kEGj8kz/E1FkVyB
n+0snPgWWd+etSQVwpi5tHdJ3InECtqvy15r7a2wcTHrzzpADEZNk+yLejYIA6sMNP4YSYL+x8cx
SIB8HqIPkg5QycaH6zY/2DDD/6b3+6LNb3Mj/qxWBZDwMiEWicZwiPkFl32jx0PdAug7Pe2xQaPt
P77blUjE7h6z8rwMK5nQxl0SQoHhg26Ccz8mSxSQrllmCsSNvtLOBq6thG9IhJtPQLnxTPKvmPv2
zkBdXPao8S+v7Iki8msYZbHBc63X8djPHgp0XEK4aH631XcKJ1Z8D2KkPzIUYJX9BwSiCQIDAQAB
o4IDbzCCA2swDgYDVR0PAQH/BAQDAgGGMDsGA1UdJQQ0MDIGCCsGAQUFBwMBBggrBgEFBQcDAgYI
KwYBBQUHAwMGCCsGAQUFBwMEBggrBgEFBQcDCDCCAcYGA1UdIASCAb0wggG5MIIBtQYLYIZIAYb9
bAEDAAQwggGkMDoGCCsGAQUFBwIBFi5odHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9zc2wtY3BzLXJl
cG9zaXRvcnkuaHRtMIIBZAYIKwYBBQUHAgIwggFWHoIBUgBBAG4AeQAgAHUAcwBlACAAbwBmACAA
dABoAGkAcwAgAEMAZQByAHQAaQBmAGkAYwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0AGUAcwAg
AGEAYwBjAGUAcAB0AGEAbgBjAGUAIABvAGYAIAB0AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMA
UAAvAEMAUABTACAAYQBuAGQAIAB0AGgAZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkAIABB
AGcAcgBlAGUAbQBlAG4AdAAgAHcAaABpAGMAaAAgAGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkA
dAB5ACAAYQBuAGQAIABhAHIAZQAgAGkAbgBjAG8AcgBwAG8AcgBhAHQAZQBkACAAaABlAHIAZQBp
AG4AIABiAHkAIAByAGUAZgBlAHIAZQBuAGMAZQAuMA8GA1UdEwEB/wQFMAMBAf8wfQYIKwYBBQUH
AQEEcTBvMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wRwYIKwYBBQUHMAKG
O2h0dHA6Ly93d3cuZGlnaWNlcnQuY29tL0NBQ2VydHMvRGlnaUNlcnRBc3N1cmVkSURSb290Q0Eu
Y3J0MIGBBgNVHR8EejB4MDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRB
c3N1cmVkSURSb290Q0EuY3JsMDqgOKA2hjRodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNl
cnRBc3N1cmVkSURSb290Q0EuY3JsMB0GA1UdDgQWBBQVABIrE5iymQftHt+ivlcNK2cCzTAfBgNV
HSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzANBgkqhkiG9w0BAQUFAAOCAQEAhGFOQR64dgQq
tbbvj/JVhbldVv4KmObkvWWKfUAp0/yxXUX9OrgqWzNLJFzNubTkc61hXXatdDOKZtUjr0wfcm5F
2XVAu6I7z41JL8BBsOIpo1E4Q1CZFKwzBjViiX13qVIH5WwgV7aBum+8s8KU7XYCgNl8zoWoHOzH
Q0pLsVfPcs7f9SU8yyJP/Z9S0TfLCLs4PuDVPm95Ca1bfDGzdzXD5GP5aAqYB+dGOHeE0j6XvAqg
qKwlT0RukeHSWq9r7zAcjaNEQrMQiyP61+Y1dDesz+urWB/JiCP/NtQH6jRqR+qdlWyeKU9T7eMr
lSBOKs+WYHr4LIDwlVLOKZaBYjCCBv8wggXnoAMCAQICEA2fwUKNhvkL8dN88tUFvVwwDQYJKoZI
hvcNAQEFBQAwYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQ
d3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0xMB4XDTE0
MDIxNzAwMDAwMFoXDTE1MDMxMjEyMDAwMFowgaQxCzAJBgNVBAYTAkdCMRcwFQYDVQQIEw5DYW1i
cmlkZ2VzaGlyZTESMBAGA1UEBxMJQ2FtYnJpZGdlMRYwFAYDVQQKEw1Db2xsYWJvcmEgTHRkMQow
CAYDVQQLEwExMRYwFAYDVQQDEw1Tam9lcmQgU2ltb25zMSwwKgYJKoZIhvcNAQkBFh1zam9lcmQu
c2ltb25zQGNvbGxhYm9yYS5jby51azCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN4Q
EHeW1NbogMVZpHedG7o509/L4VBhqQd8j8JViWd+yvLlxOBw/gY+7ioHMatrQY2VvY6QOLle2Xqs
CDvELcXMxwyFpBC0Ia+CVE+5pF+0IMuVkGIL1T8LHeKZYeRP+uFXtmWzas12hsMILNRmK7Q5PACm
+v/6HFn111hLKkANBtRHIRiDbFQOiluNeR2bq+ck1y2+X//SGumA1XZFdCB/1VcRJXDdFnYdU3j/
RkoiGggo3MSq3mJ6yV7sqzk04fTLFvfL0KadCMauputeGBybEiFAt6rCm5TkyUqoDOTU07byOEXO
M32EGeYeV515RzARTpOSE9sdmRq0jNNAqGsCAwEAAaOCA2wwggNoMB8GA1UdIwQYMBaAFBUAEisT
mLKZB+0e36K+Vw0rZwLNMB0GA1UdDgQWBBRaTG8RXMDSFO5XcrjqYs/YDlmqSDAoBgNVHREEITAf
gR1zam9lcmQuc2ltb25zQGNvbGxhYm9yYS5jby51azAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMH0GA1UdHwR2MHQwOKA2oDSGMmh0dHA6Ly9jcmwzLmRpZ2lj
ZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRENBLTEuY3JsMDigNqA0hjJodHRwOi8vY3JsNC5kaWdp
Y2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURDQS0xLmNybDCCAcUGA1UdIASCAbwwggG4MIIBtAYK
YIZIAYb9bAQBAjCCAaQwOgYIKwYBBQUHAgEWLmh0dHA6Ly93d3cuZGlnaWNlcnQuY29tL3NzbC1j
cHMtcmVwb3NpdG9yeS5odG0wggFkBggrBgEFBQcCAjCCAVYeggFSAEEAbgB5ACAAdQBzAGUAIABv
AGYAIAB0AGgAaQBzACAAQwBlAHIAdABpAGYAaQBjAGEAdABlACAAYwBvAG4AcwB0AGkAdAB1AHQA
ZQBzACAAYQBjAGMAZQBwAHQAYQBuAGMAZQAgAG8AZgAgAHQAaABlACAARABpAGcAaQBDAGUAcgB0
ACAAQwBQAC8AQwBQAFMAIABhAG4AZAAgAHQAaABlACAAUgBlAGwAeQBpAG4AZwAgAFAAYQByAHQA
eQAgAEEAZwByAGUAZQBtAGUAbgB0ACAAdwBoAGkAYwBoACAAbABpAG0AaQB0ACAAbABpAGEAYgBp
AGwAaQB0AHkAIABhAG4AZAAgAGEAcgBlACAAaQBuAGMAbwByAHAAbwByAGEAdABlAGQAIABoAGUA
cgBlAGkAbgAgAGIAeQAgAHIAZQBmAGUAcgBlAG4AYwBlAC4wdwYIKwYBBQUHAQEEazBpMCQGCCsG
AQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQQYIKwYBBQUHMAKGNWh0dHA6Ly9jYWNl
cnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRENBLTEuY3J0MAwGA1UdEwEB/wQCMAAw
DQYJKoZIhvcNAQEFBQADggEBAAc8CwXSms3RbIx+bhxFsGQoN+RpHtjnPvMPPAobv7rxdhQPPz+N
6h3hpVzegeW2XhyZVC8MT0U6uWXrk+1uQUAXrJEG+W2X8yTEoHDS/SCF/POOsj/ekaDuNE9JJB/9
cspoa4W+W8pX1sRurBDFHL0DBudUQ1PgvTSLPOHtfKQpu4gRb2u8KpJermp/IvPLImX9xSCbYKQM
2L0wbpStFIYdyKCKuXuQxOX3BdBKLCFvcIDE6hjj3UpOlThCbeul2Tz5jARCfRK4OUxnXyb/Tp5j
tshIAa2ZMGaTH9ApeY7P6C2ONF+Mh5yV/raWXOnJ9dEg6/sXcbdiieqzLKYBIgQwggb/MIIF56AD
AgECAhANn8FCjYb5C/HTfPLVBb1cMA0GCSqGSIb3DQEBBQUAMGIxCzAJBgNVBAYTAlVTMRUwEwYD
VQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERp
Z2lDZXJ0IEFzc3VyZWQgSUQgQ0EtMTAeFw0xNDAyMTcwMDAwMDBaFw0xNTAzMTIxMjAwMDBaMIGk
MQswCQYDVQQGEwJHQjEXMBUGA1UECBMOQ2FtYnJpZGdlc2hpcmUxEjAQBgNVBAcTCUNhbWJyaWRn
ZTEWMBQGA1UEChMNQ29sbGFib3JhIEx0ZDEKMAgGA1UECxMBMTEWMBQGA1UEAxMNU2pvZXJkIFNp
bW9uczEsMCoGCSqGSIb3DQEJARYdc2pvZXJkLnNpbW9uc0Bjb2xsYWJvcmEuY28udWswggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDeEBB3ltTW6IDFWaR3nRu6OdPfy+FQYakHfI/CVYln
fsry5cTgcP4GPu4qBzGra0GNlb2OkDi5Xtl6rAg7xC3FzMcMhaQQtCGvglRPuaRftCDLlZBiC9U/
Cx3imWHkT/rhV7Zls2rNdobDCCzUZiu0OTwApvr/+hxZ9ddYSypADQbURyEYg2xUDopbjXkdm6vn
JNctvl//0hrpgNV2RXQgf9VXESVw3RZ2HVN4/0ZKIhoIKNzEqt5iesle7Ks5NOH0yxb3y9CmnQjG
rqbrXhgcmxIhQLeqwpuU5MlKqAzk1NO28jhFzjN9hBnmHledeUcwEU6TkhPbHZkatIzTQKhrAgMB
AAGjggNsMIIDaDAfBgNVHSMEGDAWgBQVABIrE5iymQftHt+ivlcNK2cCzTAdBgNVHQ4EFgQUWkxv
EVzA0hTuV3K46mLP2A5ZqkgwKAYDVR0RBCEwH4Edc2pvZXJkLnNpbW9uc0Bjb2xsYWJvcmEuY28u
dWswDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMEBggrBgEFBQcDAjB9BgNVHR8E
djB0MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURDQS0x
LmNybDA4oDagNIYyaHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEQ0Et
MS5jcmwwggHFBgNVHSAEggG8MIIBuDCCAbQGCmCGSAGG/WwEAQIwggGkMDoGCCsGAQUFBwIBFi5o
dHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9zc2wtY3BzLXJlcG9zaXRvcnkuaHRtMIIBZAYIKwYBBQUH
AgIwggFWHoIBUgBBAG4AeQAgAHUAcwBlACAAbwBmACAAdABoAGkAcwAgAEMAZQByAHQAaQBmAGkA
YwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0AGUAcwAgAGEAYwBjAGUAcAB0AGEAbgBjAGUAIABv
AGYAIAB0AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMAUAAvAEMAUABTACAAYQBuAGQAIAB0AGgA
ZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkAIABBAGcAcgBlAGUAbQBlAG4AdAAgAHcAaABp
AGMAaAAgAGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkAdAB5ACAAYQBuAGQAIABhAHIAZQAgAGkA
bgBjAG8AcgBwAG8AcgBhAHQAZQBkACAAaABlAHIAZQBpAG4AIABiAHkAIAByAGUAZgBlAHIAZQBu
AGMAZQAuMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQu
Y29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
cmVkSURDQS0xLmNydDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4IBAQAHPAsF0prN0WyM
fm4cRbBkKDfkaR7Y5z7zDzwKG7+68XYUDz8/jeod4aVc3oHltl4cmVQvDE9FOrll65PtbkFAF6yR
Bvltl/MkxKBw0v0ghfzzjrI/3pGg7jRPSSQf/XLKaGuFvlvKV9bEbqwQxRy9AwbnVENT4L00izzh
7XykKbuIEW9rvCqSXq5qfyLzyyJl/cUgm2CkDNi9MG6UrRSGHcigirl7kMTl9wXQSiwhb3CAxOoY
491KTpU4Qm3rpdk8+YwEQn0SuDlMZ18m/06eY7bISAGtmTBmkx/QKXmOz+gtjjRfjIeclf62llzp
yfXRIOv7F3G3YonqsyymASIEMYIDEDCCAwwCAQEwdjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMM
RGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2Vy
dCBBc3N1cmVkIElEIENBLTECEA2fwUKNhvkL8dN88tUFvVwwCQYFKw4DAhoFAKCCAW8wGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTIzMTQxMDM0WjAjBgkqhkiG
9w0BCQQxFgQUJQRfH4pOVEGP1jr4BX0KSgkbcvcwgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UE
BhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEh
MB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0xAhANn8FCjYb5C/HTfPLVBb1cMIGHBgsq
hkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcG
A1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0x
AhANn8FCjYb5C/HTfPLVBb1cMA0GCSqGSIb3DQEBAQUABIIBALeAWi6aw1+FQ7HWNIf6K+81/bHn
wRY8FI4f5E+QkPIfMwLhGY2DD+Kp0wZs+DPhOxCmIfzvUS5ZNxH2fiIo+99ZDv1oLY51gEoRg31X
Ri9JDOjhcleEs//wSFiDsFNta7AylYr0XwM70wR/FDoFPgtRR5n5izk2D6TSrZCfyQFsU5URFNWC
NIiXuBmwC8efWw/IOGO539EhyBQASJsV7pmyqdFW72gwY0yEsQjP/EeFQPxdgarAwYh45f5YVgzL
YK45Antl8AbkyUM5D5IhQ5mK+gREUYTEgdY8Raygn3ML38DeLs6tl5C4GyJgyo5FhWaVf5hQHXH6
XI9pubwR8QgAAAAAAAA=


--=-YhcPQtbd0XoseixdC3UV--
