Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GFqqpn032370
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 11:52:52 -0400
Received: from mail9.dslextreme.com (mail9.dslextreme.com [66.51.199.94])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2GFqKxd024920
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 11:52:20 -0400
Mime-Version: 1.0 (Apple Message framework v624)
In-Reply-To: <200803161254.28025.peter.missel@onlinehome.de>
References: <20050806200358.12455.qmail@web60322.mail.yahoo.com>
	<pan.2008.03.16.07.45.13.220467@gimpelevich.san-francisco.ca.us>
	<200803161254.28025.peter.missel@onlinehome.de>
Message-Id: <cfbe4ae12b756df6c951bdb8218917aa@gimpelevich.san-francisco.ca.us>
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Date: Sun, 16 Mar 2008 08:52:12 -0700
To: video4linux-list@redhat.com
Subject: [PATCH] Re: LifeVideo To-Go Cardbus, tuner problems
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0963738008=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--===============0963738008==
Content-Type: multipart/signed; micalg=sha1; boundary=Apple-Mail-118--257734037;
	protocol="application/pkcs7-signature"


--Apple-Mail-118--257734037
Content-Type: multipart/mixed;
	boundary=Apple-Mail-117--257734494


--Apple-Mail-117--257734494
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=UTF-8;
	format=flowed

On Mar 16, 2008, at 4:54 AM, Peter Missel wrote:

> I'd rather add autodetection for this card into the code.
>
> Can you please give us the usual details - card name as shown on the=20=

> box, card
> connectivity (please list connectors, dongles, adapters and=20
> accessories that
> came with it), card ID details as shown from the saa7134 driver =
loading
> and/or an lspci -vx command?
>
> Thanks!
>
> regards,
> Peter

Card: LifeView=C2=AE LifeVideo To-Go
Connectors: Two, one for a dongle, the other for RF in. =46rom the PDF=20=

manual:
> AV Cable: Connect the AV Cable to the 9-pin connector of the LifeVideo=20=

> To-Go
> S-Video: S-Video input for external devices like VCRs or camcorders
> Audio (L): Connects to the left audio channel of an external audio=20
> device
> Audio (R): Connects to the right audio channel of an external audio=20
> device
> Video In: Composite video input for external devices like VCRs or=20
> camcorders
> TV Antenna: Connects to your home antenna or cable for Analog TV
Package contents, from the manual:
> =E2=80=A2 LifeVideo To-Go card
> =E2=80=A2 NTSC connection adapter
> =E2=80=A2 PAL connection adapter
> =E2=80=A2 AV-Cable
> =E2=80=A2 Portable TV antenna
> =E2=80=A2 Installation CD-ROM with User Manual
> =E2=80=A2 Quick Installation Guide
> =E2=80=A2 Software CD-ROM with Ulead DVD MovieFactory & Ulead =
VideoStudio

Rather than paste dmesg and/or lspci output, I have made a patch and=20
attached it.
--=20
"No gnu's is good gnu's."   --Gary Gnu, "The Great Space Coaster"


--Apple-Mail-117--257734494
Content-Transfer-Encoding: 7bit
Content-Type: application/text; x-mac-type=54455854; x-unix-mode=0644;
	name="lvtg.diff"
Content-Disposition: attachment;
	filename=lvtg.diff

Signed-off by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
diff -ru v4l-dvb-2e9a92dbe2be/linux/drivers/media/video/saa7134/saa7134-cards.c v4l-dvb-lvtg/linux/drivers/media/video/saa7134/saa7134-cards.c
--- v4l-dvb-2e9a92dbe2be/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Mar 16 08:14:12 2008
+++ v4l-dvb-lvtg/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Mar 16 08:38:08 2008
@@ -5141,19 +5141,19 @@
 		.subvendor    = 0x4e42,
 		.subdevice    = 0x3502,
 		.driver_data  = SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS,
-	}, {
+	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x1822, /*Twinhan Technology Co. Ltd*/
 		.subdevice    = 0x0022,
 		.driver_data  = SAA7134_BOARD_TWINHAN_DTV_DVB_3056,
-	}, {
+	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x16be,
 		.subdevice    = 0x0010, /* Medion version CTX953_V.1.4.3 */
 		.driver_data  = SAA7134_BOARD_CREATIX_CTX953,
-	}, {
+	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x1462, /* MSI */
@@ -5165,25 +5165,43 @@
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xf436,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_CARDBUS_506,
-	}, {
+	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xf936,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_A16D,
-	}, {
+	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xa836,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_M115,
-	}, {
+	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x185b,
 		.subdevice    = 0xc900,
 		.driver_data  = SAA7134_BOARD_VIDEOMATE_T750,
-	}, {
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = 0x5169,
+		.subdevice    = 0x1502, /* possible variant of below */
+		.driver_data  = SAA7134_BOARD_FLYTVPLATINUM_MINI,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5169,
+		.subdevice    = 0x1502, /* LifeView LifeVideo To-Go */
+		.driver_data  = SAA7134_BOARD_FLYTVPLATINUM_MINI,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
+		.subvendor    = 0x5169,
+		.subdevice    = 0x1502, /* possible variant of above */
+		.driver_data  = SAA7134_BOARD_FLYTVPLATINUM_MINI,
+	},{
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,

--Apple-Mail-117--257734494--

--Apple-Mail-118--257734037
Content-Transfer-Encoding: base64
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Disposition: attachment;
	filename=smime.p7s

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGTTCCAwYw
ggJvoAMCAQICEBDAn4gnWUUrGUQfb8V+HHgwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDgxNDIxNDI0MFoXDTA4MDgxMzIxNDI0
MFowWDEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjE1MDMGCSqGSIb3DQEJARYmZGFu
aWVsQGdpbXBlbGV2aWNoLnNhbi1mcmFuY2lzY28uY2EudXMwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQC1tNDJEtPQwKpOCFm7pKuWBM6JcmS6UFAMEYkPx+x3yrVmgOCyTF2grHmX5+4M
B1QCN2JHgv3Ui6TXF82F7YSNCBHUagmiZlFKTaiv1cPgUbuKWZ0bndsL83qY6gbpqevfdKrvbM9j
Rru/wT4RnrSU7uzBCcBEMMHZ8QjdnG5BlWkjxaiWM/OpqlI4HypEKEpE1PYMsgPl6OC6amlYlNBm
Yyi03YuR50PAD+i7mw94WTyn7wWkTmgjBUMKuJlkybuUhWGiAheYZmE4cUQJgngRRraWQoYynPIY
tSbasNKryiJAvm1o4++4bgTaR/H2gCUeCBJQaaUIkRrhyO4zbJChAgMBAAGjQzBBMDEGA1UdEQQq
MCiBJmRhbmllbEBnaW1wZWxldmljaC5zYW4tZnJhbmNpc2NvLmNhLnVzMAwGA1UdEwEB/wQCMAAw
DQYJKoZIhvcNAQEFBQADgYEAcRGo2Rl+WJ+DoVDg/gTpcruGaHnMPBsQ4/0d12+k5aV3aH+pu2tz
6lFtKJSM2gTYloELHlIffhkYQcb/Eu/R9utBj3lHoweCPHDAmPxfd2jvHY/aAtM9qvtFN5Ue/5mq
c6VdAl2tWmHynZyaxwp7yn+pS+iwExCNyx5E1mxVFGQwggM/MIICqKADAgECAgENMA0GCSqGSIb3
DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBlMRIwEAYDVQQHEwlD
YXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9DZXJ0aWZpY2F0
aW9uIFNlcnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwg
Q0ExKzApBgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20wHhcNMDMwNzE3
MDAwMDAwWhcNMTMwNzE2MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENv
bnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElz
c3VpbmcgQ0EwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVzVftOucqZWh5owHUEcJ3f
6f+jHuy9zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuvPAsH5/EfkTYk
KhPPK9Xzgnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBlyYLf7AgMBAAGj
gZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsLnRo
YXd0ZS5jb20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMCAQYwKQYDVR0R
BCIwIKQeMBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEBBQUAA4GBAEiM
0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9reFhYsPZOhl+hLGZ
GwDFGguCdJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo05RAaWzVNd+NWIXiC3CEZ
Nd4ksdMdRv9dX2VPMYIDEDCCAwwCAQEwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3Rl
IENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWls
IElzc3VpbmcgQ0ECEBDAn4gnWUUrGUQfb8V+HHgwCQYFKw4DAhoFAKCCAW8wGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDgwMzE2MTU1MjEyWjAjBgkqhkiG9w0BCQQx
FgQUW04buYzlSFiBWVVKKWKbZsgWyMQwgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAQwJ+IJ1lFKxlEH2/Ffhx4MIGHBgsqhkiG9w0B
CRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkp
IEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAQwJ+I
J1lFKxlEH2/Ffhx4MA0GCSqGSIb3DQEBAQUABIIBADAYf+6+unBvdMP88L1IkfYgx8DE7xu1C40v
Oth+9G8p1QsnkkO99+7FU1DrvHkdSOn20xHEl9LwITeXHEGr3a5ivVJxKV4zuRMmO08txMT+MxoU
rvSrBJTH+kLtZ+lENqoYs14+arbJAZPNkubgTNEXxY+HuIBhQ0ZXOTgu0jCmN5SKoK2oEyynVl1W
FL3c4zkkXMalh9v6m88oH8L8FtSC9yCfCIhYj6Zmtjxe0YKFFln8Wc3xrYQ7DQtIeCqFoDyLMzHa
mR17Kkq68lvqVPyRXUs76L6PAjxKelgLlo3kz40MsayKtaEPm66ZVZP0/XUaQgjt+kYvSwDsCUFs
wKoAAAAAAAA=

--Apple-Mail-118--257734037--


--===============0963738008==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0963738008==--
