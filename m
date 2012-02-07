Return-path: <linux-media-owner@vger.kernel.org>
Received: from charon.podzimek.org ([83.240.118.45]:39893 "EHLO podzimek.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab2BGFKH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Feb 2012 00:10:07 -0500
Message-ID: <4F30B22B.9050708@podzimek.org>
Date: Tue, 07 Feb 2012 06:10:03 +0100
From: Andrej Podzimek <andrej@podzimek.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="=_charon-12597-1328591404-0001-2"
To: gennarone@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: AverTV Volar HD PRO
References: <4F2F145C.6000405@podzimek.org> <4F2F3BE1.7030801@gmail.com>
In-Reply-To: <4F2F3BE1.7030801@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_charon-12597-1328591404-0001-2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

>> Hello,
>>
>> this USB stick (07ca:a835) used to work fine with the 3.0 and 3.1 kern=
el
>> series, using one of the howtos in this thread:
>> http://forum.ubuntu-it.org/index.php/topic,384436.msg3370690.html
>>
>> However, there were some build errors with my current kernel 3.2.4, so=
 I
>> tried to update the entire media tree instead, as described here:
>> http://git.linuxtv.org/media_build.git
>>
>> Unfortunately, the device doesn't work. These are the dmesg messages
>> that appear after plugging the receiver in:
>>
>>
>> Surprisingly, the tda18218 module doesn't load automatically (I guess =
it
>> should) and loading it manually doesn't help. So the device doesn't ge=
t
>> initialized at all and there are no messages about firmware loading.
>> (The firmware file is in /lib/firmware, of course.)
>>
>> Is it possible to make the device work somehow? The receiver worked fi=
ne
>> with older kernels (using the howto from ubuntu-it.org linked above) a=
nd
>> the remote controller was usable as well.
>>
>
> Hi Andrej,
> here you can find an updated version of the af9035 patch:
>
> http://openpli.git.sourceforge.net/git/gitweb.cgi?p=3Dopenpli/openembed=
ded;a=3Dblob_plain;f=3Drecipes/linux/linux-etxx00/dvb-usb-af9035.patch;hb=
=3DHEAD
>
> There are several improvements, including support for newer kernels (3.=
2
> and 3.3) as well as the current media_build tree.
> I also added the missing "select" directives for the tda18218 and
> mxl5007T tuners, so the modules auto-loads correctly now.
>
> In this version there is no remote support.
>
> Please let me know if it works fine for you.
>
> Regards,
> Gianluca

Hi Gianluca,

the tuner seems to work now. I applied the patch directly to the 3.2.5 ke=
rnel, without using the media_build tree. (Is this the correct approach?)=
 Unlike the previous versions of the driver, this one does not keep the t=
uner hot when inactive. (There must have been a power management issue th=
at is already resolved.)

This is what I see in dmesg:

	usb 3-1.2: new high-speed USB device number 9 using ehci_hcd
	dvb-usb: found a 'Avermedia AverTV Volar HD & HD PRO (A835)' in cold sta=
te, will try to load a firmware
	dvb-usb: downloading firmware from file 'dvb-usb-af9035-01.fw'
	dvb-usb: found a 'Avermedia AverTV Volar HD & HD PRO (A835)' in warm sta=
te.
	dvb-usb: will pass the complete MPEG2 transport stream to the software d=
emuxer.
	DVB: registering new adapter (Avermedia AverTV Volar HD & HD PRO (A835))=

	af9033: firmware version: LINK:11.15.10.0 OFDM:5.48.10.0
	DVB: registering adapter 0 frontend 0 (Afatech AF9033 DVB-T)...
	tda18218: NXP TDA18218HN successfully identified.
	dvb-usb: Avermedia AverTV Volar HD & HD PRO (A835) successfully initiali=
zed and connected.
	usbcore: registered new interface driver dvb_usb_af9035

However, there are still some glitches. Sometimes the initialization fail=
s:

	usb 3-1.2: new high-speed USB device number 8 using ehci_hcd
	dvb-usb: found a 'Avermedia AverTV Volar HD & HD PRO (A835)' in cold sta=
te, will try to load a firmware
	dvb-usb: downloading firmware from file 'dvb-usb-af9035-01.fw'
	af9035: bulk message failed:-71 (6/0)
	af9035: firmware download failed:-71
	dvb_usb_af9035: probe of 3-1.2:1.0 failed with error -71

Unloading the dvb-t modules manually and re-plugging the tuner resolves t=
his. Furthermore, I had two kernel panics today. :-( They seem to occur w=
hen the DVB-T signal is poor for a long time. Unfortunately, I didn't hav=
e netconsole set up.

An attempt to scan channels in Kaffeine always fails before the progress =
bar reaches 20% and lots of messages like this appear in dmesg:

	af9035: recv bulk message failed:-110
	af9033: I2C read failed reg:0047
	af9035: recv bulk message failed:-110
	af9033: I2C read failed reg:0047
	af9035: recv bulk message failed:-110
	af9033: I2C read failed reg:0045
	af9035: recv bulk message failed:-110
	af9033: I2C read failed reg:0048
	af9035: recv bulk message failed:-110
	af9033: I2C read failed reg:0047
	af9035: recv bulk message failed:-110
	af9033: I2C read failed reg:002c
	af9035: recv bulk message failed:-110
	af9033: I2C read failed reg:0047
	af9035: recv bulk message failed:-110
	af9033: I2C read failed reg:0048

Fortunately, I have another DVB-T tuner (dvb_usb_af9015, MSI DigiVox Mini=
 II V3) that scans channels just fine, so I used that one to obtain the l=
ist of channels. Once you have a list of channels, watching TV with the A=
verTV Volar HD PRO (dvb_usb_af9035) seems to work fine.

Andrej


--=_charon-12597-1328591404-0001-2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: Elektronický podpis S/MIME

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIWDDCC
BjQwggQcoAMCAQICASAwDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDI1NVoXDTE3MTAyNDIxMDI1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMsohUWcASz7GfKrpTOM
KqANy9BV7V0igWdGxA8IU77L3aTxErQ+fcxtDYZ36Z6GH0YFn7fq5RADteP0AYzrCA+EQTfi
8q1+kA3m0nwtwXG94M5sIqsvs7lRP1aycBke/s5g9hJHryZ2acScnzczjBCAo7X1v5G3yw8M
DP2m2RCye0KfgZ4nODerZJVzhAlOD9YejvAXZqHksw56HzElVIoYSZ3q4+RJuPXXfIoyby+Y
2m1E+YzX5iCZXBx05gk6MKAW1vaw4/v2OOLy6FZH3XHHtOkzUreG//CsFnB9+uaYSlR65cdG
zTsmoIK8WH1ygoXhRBm98SD7Hf/r3FELNvUCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBSuVYNv7DHKufcd+q9rMfPIHeOsuzAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBADqp
Jw3I07QWke9plNBpxUxcffc7nUrIQpJHDci91DFG7fVhHRkMZ1J+BKg5UNUxIFJ2Z9B90Mic
c/NXcs7kPBRdn6XGO/vPc87Y6R+cWS9Nc9+fp3Enmsm94OxOwI9wn8qnr/6o3mD4noP9Jphw
UPTXwHovjavRnhUQHLfo/i2NG0XXgTHXS2Xm0kVUozXqpYpAdumMiB/vezj1QHQJDmUdPYMc
p+reg9901zkyT3fDW/ivJVv6pWtkh6Pw2ytZT7mvg7YhX3V50Nv860cV11mocUVcqBLv0gcT
+HBDYtbuvexNftwNQKD5193A7zN4vG7CTYkXxytSjKuXrpEatEiFPxWgb84nVj25SU5q/r1X
hwby6mLhkbaXslkVtwEWT3Van49rKjlK4XrUKYYWtnfzq6aSak5u0Vpxd1rY79tWhD3EdCvO
hNz/QplNa+VkIsrcp7+8ZhP1l1b2U6MaxIVteuVMD3X0vziIwr7jxYae9FZjbxlpUemqXjcC
0QaFfN7qI0JsQMALL7iGRBg7K0CoOBzECdD3fuZil5kU/LP9cr1BK31U0Uy651bFnAMMMkqh
AChIbn0ei72VnbpSsrrSdF0BAGYQ8vyHae5aCg+H75dVCV33K6FuxZrf09yTz+Vx/PkdRUYk
XmZz/OTfyJXsUOUXrym6KvI2rYpccSk5MIIGyjCCBbKgAwIBAgICC0YwDQYJKoZIhvcNAQEF
BQAwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJT
ZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBD
bGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTAeFw0xMDA5MjcwMDQ4NTZa
Fw0xMjA5MjcwOTU2MjhaMIHCMSAwHgYDVQQNExcyNjQzNTYtVXpwMjgycUhIdGJDYjVkMzEL
MAkGA1UEBhMCQ1oxFTATBgNVBAgTDFpsaW5za3kgS3JhajENMAsGA1UEBxMEWmxpbjEtMCsG
A1UECxMkU3RhcnRDb20gVmVyaWZpZWQgQ2VydGlmaWNhdGUgTWVtYmVyMRgwFgYDVQQDEw9B
bmRyZWogUG9kemltZWsxIjAgBgkqhkiG9w0BCQEWE2FuZHJlakBwb2R6aW1lay5vcmcwggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCuV1E4S+VpLLg5f08+DbZeXsYKK/OK4Fxu
uQf5K328gDJ58NveR920dP8nU1GVANhOsMVDdxkzYnu+Jybj+67rsrN0AX/XiZ2aXVvWmtZG
JRPchHALBu3zC42Fl9rp0aRDfvgS45YNVf7lgIS5+vkYweuSRnLlFi072vdq+CU4jVkHYX1n
nplvjaRLs3Z5sQTs6P6kV5DBqPanP8Hh3eC7rBf5zsbAOLLbqI3/fcKX6ylrm4VYhNvxcPo/
pqhv0SnIPGf3QoSvn726DW2aHzfcp2WXiaaPMC/lkrSJUWfGwGr5XVM3/Y1bqiIi84vFMgcJ
8LUx1iLzwcwLU9pBkXjLAgMBAAGjggL8MIIC+DAJBgNVHRMEAjAAMAsGA1UdDwQEAwIEsDAd
BgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwHQYDVR0OBBYEFPcZIS+eaYpk8EbOkSWn
se2ahXsXMB8GA1UdIwQYMBaAFK5Vg2/sMcq59x36r2sx88gd46y7MB4GA1UdEQQXMBWBE2Fu
ZHJlakBwb2R6aW1lay5vcmcwggFCBgNVHSAEggE5MIIBNTCCATEGCysGAQQBgbU3AQICMIIB
IDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5LnBkZjA0Bggr
BgEFBQcCARYoaHR0cDovL3d3dy5zdGFydHNzbC5jb20vaW50ZXJtZWRpYXRlLnBkZjCBtwYI
KwYBBQUHAgIwgaowFBYNU3RhcnRDb20gTHRkLjADAgEBGoGRTGltaXRlZCBMaWFiaWxpdHks
IHNlZSBzZWN0aW9uICpMZWdhbCBMaW1pdGF0aW9ucyogb2YgdGhlIFN0YXJ0Q29tIENlcnRp
ZmljYXRpb24gQXV0aG9yaXR5IFBvbGljeSBhdmFpbGFibGUgYXQgaHR0cDovL3d3dy5zdGFy
dHNzbC5jb20vcG9saWN5LnBkZjBjBgNVHR8EXDBaMCugKaAnhiVodHRwOi8vd3d3LnN0YXJ0
c3NsLmNvbS9jcnR1Mi1jcmwuY3JsMCugKaAnhiVodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9j
cnR1Mi1jcmwuY3JsMIGOBggrBgEFBQcBAQSBgTB/MDkGCCsGAQUFBzABhi1odHRwOi8vb2Nz
cC5zdGFydHNzbC5jb20vc3ViL2NsYXNzMi9jbGllbnQvY2EwQgYIKwYBBQUHMAKGNmh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFzczIuY2xpZW50LmNhLmNydDAjBgNV
HRIEHDAahhhodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS8wDQYJKoZIhvcNAQEFBQADggEBAIQj
bUQ4zvWEpdE0UdtYVp6ZXzp/ECzXIyXpKiFmE1F5r89zmEymgWhRkF/SoncC8XLY/OzKylOy
pmEE7CgjetUmWBlqkqLjHiTsVczjfEWZT+ShAt1A8NLUl9uvzMVNUHH4rrEP4v3L4zUzslf4
RxCBMi4JmfzRiNLESkAY0PT01Q+uDAn+/02fnOpsStp/kxFIC6fXV+GSog5GWqQCLf3c36S9
cSwC1EkDQKLNDMV+YsU1jjFa1a1FgkZq04jMM7yzyADyR8L30JzKClFBuswFoFnd/MyCg1eE
/sDrzTVdiD5+VLSTE9K5sFsR8RQJU4c1ybhMB3IrBh6Ej03w8P4wggkCMIIE6qADAgECAgEB
MA0GCSqGSIb3DQEBDQUAMIGkMRswGQYDVQQDDBJQb2R6aW1layBTZWNvbmQgQ0ExCzAJBgNV
BAYTAkNaMRcwFQYDVQQIDA5abMOtbnNrw70ga3JhajEOMAwGA1UEBwwFWmzDrW4xFTATBgNV
BAoMDHBvZHppbWVrLm9yZzEVMBMGA1UECwwMcG9kemltZWsub3JnMSEwHwYJKoZIhvcNAQkB
FhJhZG1pbkBwb2R6aW1lay5vcmcwHhcNMTExMTEyMDczMjM2WhcNMTIxMTExMDczMjM2WjCB
ojELMAkGA1UEBhMCQ1oxFzAVBgNVBAgMDlpsw61uc2vDvSBrcmFqMQ4wDAYDVQQHDAVabMOt
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
khV+UlxOMPyLvC+TUvyd9o0rnxz/Do4AAAAAAAA=
--=_charon-12597-1328591404-0001-2--
