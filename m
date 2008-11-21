Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from utm.netup.ru ([193.203.36.250])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <aospan@netup.ru>) id 1L3TJ2-0007nm-P0
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 11:32:09 +0100
Received: from alkaloid.netup (unknown [10.1.2.137])
	by utm.netup.ru (Postfix) with ESMTP id 2DD961F7B85
	for <linux-dvb@linuxtv.org>; Fri, 21 Nov 2008 13:32:10 +0300 (MSK)
From: Abylai Ospan <aospan@netup.ru>
To: linux-dvb@linuxtv.org
Date: Fri, 21 Nov 2008 13:31:48 +0300
Message-Id: <1227263508.4090.1011.camel@alkaloid.netup.ru>
Mime-Version: 1.0
Subject: [linux-dvb] Development of Linux driver for Dual DVB-S2-CI PCI-E x1
	starts
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0814458341=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0814458341==
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-CnoyTMRCn6SotkR4LbRk"


--=-CnoyTMRCn6SotkR4LbRk
Content-Type: multipart/alternative; boundary="=-to55XRquGjxC00t/JpYV"


--=-to55XRquGjxC00t/JpYV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello,

We have designed NetUP Dual DVB-S2-CI PCI-E x1 card. A short
description=20
is available in wiki -
http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_S2_CI
Now we have started the work on the driver for Linux. The following=20
components used in this card already have their code for Linux
published:
Conexant CX23885
STM STV6110A

We are working on the code for the following components:
Dual demodulator STM STV0900BAB
Dual LNB STM LNBH24
SCM CiMax SP2

The resulting code will be published under GPL after receiving=20
permissions from IC vendors.

--=20
Abylai Ospan <aospan@netup.ru>
NetUP Inc.

--=-to55XRquGjxC00t/JpYV
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; CHARSET=3DUTF-8">
  <META NAME=3D"GENERATOR" CONTENT=3D"GtkHTML/3.9.92">
</HEAD>
<BODY>
Hello,<BR>
<BR>
<TT>We have designed NetUP Dual DVB-S2-CI PCI-E x1 card. A short descriptio=
n </TT><BR>
<TT>is available in wiki - <A HREF=3D"http://linuxtv.org/wiki/index.php/Net=
UP_Dual_DVB_S2_CI">http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_S2_CI</=
A></TT><BR>
<TT>Now we have started the work on the driver for Linux. The following </T=
T><BR>
<TT>components used in this card already have their code for Linux publishe=
d:</TT><BR>
<TT>Conexant CX23885</TT><BR>
<TT>STM STV6110A</TT><BR>
<BR>
<TT>We are working on the code for the following components:</TT><BR>
<TT>Dual demodulator STM STV0900BAB</TT><BR>
<TT>Dual LNB STM LNBH24</TT><BR>
<TT>SCM CiMax SP2</TT><BR>
<BR>
<TT>The resulting code will be published under GPL after receiving </TT><BR=
>
<TT>permissions from IC vendors.</TT><BR>
<BR>
<TABLE CELLSPACING=3D"0" CELLPADDING=3D"0" WIDTH=3D"100%">
<TR>
<TD>
-- <BR>
Abylai Ospan &lt;<A HREF=3D"mailto:aospan@netup.ru">aospan@netup.ru</A>&gt;=
<BR>
NetUP Inc.
</TD>
</TR>
</TABLE>
</BODY>
</HTML>

--=-to55XRquGjxC00t/JpYV--

--=-CnoyTMRCn6SotkR4LbRk
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIII+zCCAtgw
ggJBoAMCAQICEEf5NcoAij4WFnhfx2J/HGswDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDEwNjE5MDgzMloXDTA5MDEwNTE5MDgz
MlowQTEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEeMBwGCSqGSIb3DQEJARYPYW9z
cGFuQG5ldHVwLnJ1MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwfpBZg/xd7dCopdQ
lDYlHBMMMDRtkY7hrF4ysMuZThYEidFTRYNGgtYdANRJCbvpvXEKcwN+2gfsyG0sQ8mEtrqzISaE
mw7llvFuz+i5+8ZXD0CUjN/mqhelnV0+Xu6TscDmopL5FRXwUqBdWD2nWuEvYiaLXkMjFRca7Lo+
jY+QE9mAech9MIOIxjohVYaVYgUA2IrjCpDD7p/OThQn9Rh5NXvXnF7vH95M7Nlp1VehPy0i5UGK
bIyp+NfnaPGHweWvLCvaKgzPDMkmzMylAleDFeYxmLbkDKl+3ar5nS/l/2nNwwlldSSBx7mssoQb
FiIe6lUAPG6heYqn6UPwoQIDAQABoywwKjAaBgNVHREEEzARgQ9hb3NwYW5AbmV0dXAucnUwDAYD
VR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQBjekEk+Hd9B7rs+y2PtK6vl6AEQsa+oEl2oHlJ
8p6B6WGU5ycHwJNhaEhqvRUK1AaDjWetBShuiVA54k7mwiyIpqh9ZTAeJ1qfUpoKQeBW3ZgNCKUp
SrTSQBHwiKxNbAHnK4uzOde9foMN5u8RqIbXhmGZmYw+3mRMJsvjJ0m/ijCCAtgwggJBoAMCAQIC
EEf5NcoAij4WFnhfx2J/HGswDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoT
HFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBG
cmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDEwNjE5MDgzMloXDTA5MDEwNTE5MDgzMlowQTEfMB0G
A1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEeMBwGCSqGSIb3DQEJARYPYW9zcGFuQG5ldHVw
LnJ1MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwfpBZg/xd7dCopdQlDYlHBMMMDRt
kY7hrF4ysMuZThYEidFTRYNGgtYdANRJCbvpvXEKcwN+2gfsyG0sQ8mEtrqzISaEmw7llvFuz+i5
+8ZXD0CUjN/mqhelnV0+Xu6TscDmopL5FRXwUqBdWD2nWuEvYiaLXkMjFRca7Lo+jY+QE9mAech9
MIOIxjohVYaVYgUA2IrjCpDD7p/OThQn9Rh5NXvXnF7vH95M7Nlp1VehPy0i5UGKbIyp+NfnaPGH
weWvLCvaKgzPDMkmzMylAleDFeYxmLbkDKl+3ar5nS/l/2nNwwlldSSBx7mssoQbFiIe6lUAPG6h
eYqn6UPwoQIDAQABoywwKjAaBgNVHREEEzARgQ9hb3NwYW5AbmV0dXAucnUwDAYDVR0TAQH/BAIw
ADANBgkqhkiG9w0BAQUFAAOBgQBjekEk+Hd9B7rs+y2PtK6vl6AEQsa+oEl2oHlJ8p6B6WGU5ycH
wJNhaEhqvRUK1AaDjWetBShuiVA54k7mwiyIpqh9ZTAeJ1qfUpoKQeBW3ZgNCKUpSrTSQBHwiKxN
bAHnK4uzOde9foMN5u8RqIbXhmGZmYw+3mRMJsvjJ0m/ijCCAz8wggKooAMCAQICAQ0wDQYJKoZI
hvcNAQEFBQAwgdExCzAJBgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0ZXJuIENhcGUxEjAQBgNVBAcT
CUNhcGUgVG93bjEaMBgGA1UEChMRVGhhd3RlIENvbnN1bHRpbmcxKDAmBgNVBAsTH0NlcnRpZmlj
YXRpb24gU2VydmljZXMgRGl2aXNpb24xJDAiBgNVBAMTG1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFp
bCBDQTErMCkGCSqGSIb3DQEJARYccGVyc29uYWwtZnJlZW1haWxAdGhhd3RlLmNvbTAeFw0wMzA3
MTcwMDAwMDBaFw0xMzA3MTYyMzU5NTlaMGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUg
Q29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwg
SXNzdWluZyBDQTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAxKY8VXNV+065yplaHmjAdQRw
nd/p/6Me7L3N9VvyGna9fww6YfK/Uc4B1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FWy688Cwfn8R+R
NiQqE88r1fOCdz0Dviv+uxg+B79AgAJk16emu59l0cUqVIUPSAR/p7bRPGEEQB5kGXJgt/sCAwEA
AaOBlDCBkTASBgNVHRMBAf8ECDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwu
dGhhd3RlLmNvbS9UaGF3dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3JsMAsGA1UdDwQEAwIBBjApBgNV
HREEIjAgpB4wHDEaMBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0xMzgwDQYJKoZIhvcNAQEFBQADgYEA
SIzRUIPqCy7MDaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYfqi2fNi/A9BxQIJNwPP2t4WFiw9k6GX6E
sZkbAMUaC4J0niVQlGLH2ydxVyWN3amcOY6MIE9lX5Xa9/eH1sYITq726jTlEBpbNU1341YheILc
IRk13iSx0x1G/11fZU8xggMQMIIDDAIBATB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3
dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1h
aWwgSXNzdWluZyBDQQIQR/k1ygCKPhYWeF/HYn8cazAJBgUrDgMCGgUAoIIBbzAYBgkqhkiG9w0B
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wODExMjExMDMxNDhaMCMGCSqGSIb3DQEJ
BDEWBBT3WDZeZaSqWQqxPr2d6vxhDRbf2TCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJa
QTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3Rl
IFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEEf5NcoAij4WFnhfx2J/HGswgYcGCyqGSIb3
DQEJEAILMXigdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0
eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEEf5
NcoAij4WFnhfx2J/HGswDQYJKoZIhvcNAQEBBQAEggEAMH8fcZdaABsW3jfNBWlFggMy5U+uwmGt
rxNxgrlcgFX3j8v5FitEW2zaURFT7fBmL50+UdCQu9Z2Jvjt9oAK5ZvcYc7o/fwlhUXfGNCRKmbS
j0NJXUq+0vLD03gQOXWNrurjZDqiki4C1H2bhnsKk38bTbh4PnuPt0Akck6k1oZ0vTxOLAcgEXna
ys0eO72sIEwrp/bcyLR+xu8oztQD2aJIoaCOU18+Z4a2Ts3NFmxW3mXbG7Q2r/riVId+qedcYnOu
Id4gDSxzh+/lenxyGaPyHfY32Lh4XvLwlHcducYOGPvWACMewikEJH0mTW0tb5JRUjp1Tq+EEa27
0+6XqQAAAAAAAA==


--=-CnoyTMRCn6SotkR4LbRk--



--===============0814458341==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0814458341==--
