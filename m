Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60208 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab2ECHZH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 03:25:07 -0400
Received: by bkcji2 with SMTP id ji2so1075592bkc.19
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 00:25:06 -0700 (PDT)
Message-ID: <4FA232CE.8010404@gmail.com>
Date: Thu, 03 May 2012 09:25:02 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: gennarone@gmail.com, Zdenek Styblik <stybla@turnovfree.net>,
	fermio.kll@hotmail.com, julianjm@gmail.com,
	thomas.mair86@googlemail.com, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH v2] add support for DeLOCK-USB-2.0-DVB-T-Receiver-61744
References: <4F9E5D91.30503@gmail.com> <1335800374-22012-2-git-send-email-thomas.mair86@googlemail.com> <4F9F8752.40609@gmail.com>
In-Reply-To: <4F9F8752.40609@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030400080705000002000502"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030400080705000002000502
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


[ …]

Hi there,

These two patches - 'dvb-usb-ids-v2-rtl2832-fc0012.patch' and
'rtl28xxu-v2-rtl2832-fc0012.patch' adds nine devices based on FC0012
tuner, altogether eleven.
Gianluca, please inform forum fellows to test&reply.
Zdenek, fermio - there is a note on
http://wiki.zeratul.org/doku.php?id=linux:v4l:realtek:start at
"Other DVB-T Sticks" regarding 'af4d:a803' device.
Is it based on RTL2832 with FC0012 tuner?

Julian, Thomas, Antii
cheers mates!
;)
poma

ps.
modinfo dvb_usb_rtl28xxu
filename:
/lib/modules/3.3.2-6.fc16.x86_64/kernel/drivers/media/dvb/dvb-usb/dvb-usb-rtl28xxu.ko
license:        GPL
author:         Thomas Mair <thomas.mair86@googlemail.com>
author:         Antti Palosaari <crope@iki.fi>
description:    Realtek RTL28xxU DVB USB driver
alias:          usb:v1F4DpD803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpC803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD399d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD395d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD394d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD393d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD39Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0458p707Fd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2838d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpB803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp00A9d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14AAp0161d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v14AAp0160d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2831d*dc*dsc*dp*ic*isc*ip*
depends:        dvb-usb,rtl2830,rc-core
vermagic:       3.3.2-6.fc16.x86_64 SMP mod_unload
parm:           debug:set debugging level (int)
parm:           adapter_nr:DVB adapter numbers (array of short)


--------------030400080705000002000502
Content-Type: text/x-patch;
 name="dvb-usb-ids-v2-rtl2832-fc0012.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dvb-usb-ids-v2-rtl2832-fc0012.patch"

--- dvb-usb-ids.h.bcp	2012-05-03 05:28:38.261673063 +0200
+++ dvb-usb-ids.h	2012-05-03 07:07:41.510306992 +0200
@@ -129,10 +129,12 @@
 #define USB_PID_E3C_EC168_3				0xfffb
 #define USB_PID_E3C_EC168_4				0x1001
 #define USB_PID_E3C_EC168_5				0x1002
+#define USB_PID_EZCAP_EZTV646				0x2838
 #define USB_PID_FREECOM_DVBT				0x0160
 #define USB_PID_FREECOM_DVBT_2				0x0161
 #define USB_PID_UNIWILL_STK7700P			0x6003
 #define USB_PID_GENIUS_TVGO_DVB_T03			0x4012
+#define USB_PID_GENIUS_TVGO_DVB_T03_2			0x707f
 #define USB_PID_GRANDTEC_DVBT_USB_COLD			0x0fa0
 #define USB_PID_GRANDTEC_DVBT_USB_WARM			0x0fa1
 #define USB_PID_GTEK					0xb803
@@ -146,6 +148,9 @@
 #define USB_PID_KWORLD_395U_2				0xe39b
 #define USB_PID_KWORLD_395U_3				0xe395
 #define USB_PID_KWORLD_395U_4				0xe39a
+#define USB_PID_KWORLD_D393				0xd393
+#define USB_PID_KWORLD_D395				0xd395
+#define USB_PID_KWORLD_D399				0xd399
 #define USB_PID_KWORLD_MC810				0xc810
 #define USB_PID_KWORLD_PC160_2T				0xc160
 #define USB_PID_KWORLD_PC160_T				0xc161
@@ -209,6 +214,7 @@
 #define USB_PID_HAUPPAUGE_NOVA_TD_STICK_52009		0x5200
 #define USB_PID_HAUPPAUGE_TIGER_ATSC			0xb200
 #define USB_PID_HAUPPAUGE_TIGER_ATSC_B210		0xb210
+#define USB_PID_HU394					0xd394
 #define USB_PID_AVERMEDIA_EXPRESS			0xb568
 #define USB_PID_AVERMEDIA_VOLAR				0xa807
 #define USB_PID_AVERMEDIA_VOLAR_2			0xb808
@@ -265,11 +271,13 @@
 #define USB_PID_PCTV_400E				0x020f
 #define USB_PID_PCTV_450E				0x0222
 #define USB_PID_PCTV_452E				0x021f
+#define USB_PID_PROLECTRIX_DV107669			0xd803
 #define USB_PID_REALTEK_RTL2831U			0x2831
 #define USB_PID_REALTEK_RTL2832U			0x2832
 #define USB_PID_TECHNOTREND_CONNECT_S2_3600		0x3007
 #define USB_PID_TECHNOTREND_CONNECT_S2_3650_CI		0x300a
 #define USB_PID_NEBULA_DIGITV				0x0201
+#define USB_PID_NOT_ONLY_LV5TDELUXE			0xc803
 #define USB_PID_DVICO_BLUEBIRD_LGDT			0xd820
 #define USB_PID_DVICO_BLUEBIRD_LG064F_COLD		0xd500
 #define USB_PID_DVICO_BLUEBIRD_LG064F_WARM		0xd501
@@ -345,6 +353,7 @@
 #define USB_PID_FRIIO_WHITE				0x0001
 #define USB_PID_TVWAY_PLUS				0x0002
 #define USB_PID_SVEON_STV20				0xe39d
+#define USB_PID_SVEON_STV20_2				0xd39d
 #define USB_PID_SVEON_STV22				0xe401
 #define USB_PID_SVEON_STV22_IT9137			0xe411
 #define USB_PID_AZUREWAVE_AZ6027			0x3275

--------------030400080705000002000502
Content-Type: text/x-patch;
 name="rtl28xxu-v2-rtl2832-fc0012.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl28xxu-v2-rtl2832-fc0012.patch"

--- rtl28xxu.c.bcp	2012-05-03 06:44:32.958461395 +0200
+++ rtl28xxu.c	2012-05-03 08:11:57.463559065 +0200
@@ -1052,6 +1052,15 @@
 	RTL2831U_14AA_0161,
 	RTL2832U_0CCD_00A9,
 	RTL2832U_1F4D_B803,
+	RTL2832U_0BDA_2838,
+	RTL2832U_0458_707F,
+	RTL2832U_1B80_D39D,
+	RTL2832U_1B80_D393,
+	RTL2832U_1B80_D394,
+	RTL2832U_1B80_D395,
+	RTL2832U_1B80_D399,
+	RTL2832U_1F4D_C803,
+	RTL2832U_1F4D_D803,
 };
 
 static struct usb_device_id rtl28xxu_table[] = {
@@ -1068,6 +1077,24 @@
 		USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_BLACK)},
 	[RTL2832U_1F4D_B803] = {
 		USB_DEVICE(USB_VID_GTEK, USB_PID_GTEK)},
+	[RTL2832U_0BDA_2838] = {
+		USB_DEVICE(USB_VID_REALTEK, USB_PID_EZCAP_EZTV646)},
+	[RTL2832U_0458_707F] = {
+		USB_DEVICE(USB_VID_KYE, USB_PID_GENIUS_TVGO_DVB_T03_2)},
+	[RTL2832U_1B80_D39D] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20_2)},
+	[RTL2832U_1B80_D393] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_D393)},
+	[RTL2832U_1B80_D394] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_HU394)},
+	[RTL2832U_1B80_D395] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_D395)},
+	[RTL2832U_1B80_D399] = {
+		USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_D399)},
+	[RTL2832U_1F4D_C803] = {
+		USB_DEVICE(USB_VID_GTEK, USB_PID_NOT_ONLY_LV5TDELUXE)},
+	[RTL2832U_1F4D_D803] = {
+		USB_DEVICE(USB_VID_GTEK, USB_PID_PROLECTRIX_DV107669)},
 	{} /* terminating entry */
 };
 
@@ -1181,7 +1208,7 @@
 
 		.i2c_algo = &rtl28xxu_i2c_algo,
 
-		.num_device_descs = 2,
+		.num_device_descs = 11,
 		.devices = {
 			{
 				.name = "Terratec Cinergy T Stick Black",
@@ -1195,6 +1222,60 @@
 					&rtl28xxu_table[RTL2832U_1F4D_B803],
 				},
 			},
+			{
+				.name = "EzCAP EzTV646",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_0BDA_2838],
+				},
+			},
+			{
+				.name = "Genius TVGo DVB-T03 2",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_0458_707F],
+				},
+			},
+			{
+				.name = "Sveon STV20 2",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_1B80_D39D],
+				},
+			},
+			{
+				.name = "DVB-T TV Stick D393",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_1B80_D393],
+				},
+			},
+			{
+				.name = "DIKOM USB-DVBT HD - HU394",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_1B80_D394],
+				},
+			},
+			{
+				.name = "DVB-T TV Stick D395",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_1B80_D395],
+				},
+			},
+			{
+				.name = "DVB-T TV Stick D399",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_1B80_D399],
+				},
+			},
+			{
+				.name = "Not Only TV DVB-T USB DELUXE LV5TDELUXE",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_1F4D_C803],
+				},
+			},
+			{
+				.name = "PROlectrix USB DVB-T & DAB Dongle DV107669",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_1F4D_D803],
+				},
+			},
 		}
 	},
 

--------------030400080705000002000502
Content-Type: text/plain; charset=UTF-8;
 name="vid-pid-rtl2832-fc0012.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="vid-pid-rtl2832-fc0012.txt"

CjBiZGE6MjgzOAoqVVNCX1ZJRF9SRUFMVEVLCTB4MGJkYQpVU0JfUElEX0VaQ0FQX0VaVFY2
NDYJMHgyODM4CkV6Q0FQIEV6VFY2NDYKaHR0cDovL3d3dy5zemZvcndhcmR2aWRlby5jb20v
cHJvZHVjdC9Qcm9fMThfNy5odG1sCmh0dHA6Ly91YnVudHVmb3J1bXMub3JnL3Nob3d0aHJl
YWQucGhwP3Q9MTUzMjkzNApSVEwyODMyVV8wQkRBXzI4MzgKCgowY2NkOjAwYTkKKlVTQl9W
SURfVEVSUkFURUMJCQkweDBjY2QKKlVTQl9QSURfVEVSUkFURUNfQ0lORVJHWV9UX1NUSUNL
X0JMQUNLCTB4MDBhOQpURVJSQVRFQyBDaW5lcmd5IFQgU3RpY2sgQmxhY2sgLSAiUmV2LjEi
Cmh0dHA6Ly9saW51eC50ZXJyYXRlYy5kZS90dl9lbi5odG1sCmh0dHA6Ly93d3cudGVycmF0
ZWMubmV0L2VuL3Byb2R1Y3RzL0NpbmVyZ3lfVF9TdGlja19CbGFja18xMDc2MTEuaHRtbAoq
UlRMMjgzMlVfMENDRF8wMEE5CgowNDU4OjcwN2YKKlVTQl9WSURfS1lFCQkJMHgwNDU4ClVT
Ql9QSURfR0VOSVVTX1RWR09fRFZCX1QwM18yCTB4NzA3ZgpHZW5pdXMgVFZHbyBEVkItVDAz
IC0gIlZlci5CIgpodHRwOi8vd3d3LmxpbnV4dHYub3JnL3dpa2kvaW5kZXgucGhwL0dlbml1
c19UVkdvX0RWQi1UMDMKaHR0cDovL3d3dy5hYmNsaW51eHUuY3ovaGFyZHdhcmUvcHJpZGF2
bmUta2FydHkvdGVsZXZpem5pLWthcnR5L2R2Yi10L3VzYi9nZW5pdXMtdHZnby1kdmItdDAz
LWh3LXotMjAxMQpSVEwyODMyVV8wNDU4XzcwN0YKCgoxYjgwOmQzOWQKKlVTQl9WSURfS1dP
UkxEXzIJMHgxYjgwClVTQl9QSURfU1ZFT05fU1RWMjBfMgkweGQzOWQKU3Zlb24gU1RWMjAK
aHR0cDovL3d3dy5zdmVvbi5jb20vZmljaGFTVFYyMC5odG1sCmh0dHBzOi8vZ2l0aHViLmNv
bS9hbWJyb3NhL0RWQi1SZWFsdGVrLVJUTDI4MzJVLTIuMi4yLTEwdHVuZXItbW9kX2tlcm5l
bC0zLjAuMC9pc3N1ZXMvNApSVEwyODMyVV8xQjgwX0QzOUQKCgoxYjgwOmQzOTMKKlVTQl9W
SURfS1dPUkxEXzIJMHgxYjgwClVTQl9QSURfS1dPUkxEX0QzOTMJMHhkMzkzCkFyZGF0YSBN
eVZpc2lvbiBEVkItVCBUVgpodHRwOi8vd3d3LmFyZGF0YS5wbC90dW5lci10ZWxld2l6eWpu
eS1hcmRhdGEtbXl2aXNpb24tZHZiLXQtdHYKR2lnYWJ5dGUgVTczMDAgVVNCIERWQi1UCmh0
dHA6Ly93d3cuZ2lnYWJ5dGUuY29tL3Byb2R1Y3RzL3Byb2R1Y3QtcGFnZS5hc3B4P3BpZD0z
NDkzI3NwCmh0dHA6Ly93aWtpLnplcmF0dWwub3JnL2Rva3UucGhwP2lkPWxpbnV4OnY0bDpy
ZWFsdGVrOmdpZ2FieXRlLXU3MzAwLXVzYi1kdmItdC10dW5lcgpOSUxPWCBEVkItVCBTdGlj
ayBOMTUKaHR0cDovL3dpa2kuemVyYXR1bC5vcmcvZG9rdS5waHA/aWQ9bGludXg6djRsOnJl
YWx0ZWs6bmlsb3gtZHZiLXRfc3RpY2tfbjE1ClR3aW50ZWNoIFVULTMwIFVTQjIuMCBEVkIt
VCBTdGljayB3aXRoIEZNIFJhZGlvCmh0dHA6Ly93d3cudHdpbnRlY2gzZC5jb20vcHJvZHVj
dHNfZmVhdHVyZXMuYXNwP251bT0zMDAKUlRMMjgzMlVfMUI4MF9EMzkzCgoKMWI4MDpkMzk0
CipVU0JfVklEX0tXT1JMRF8yCTB4MWI4MApVU0JfUElEX0hVMzk0CQkweGQzOTQKRElLT00g
VVNCLURWQlQgSEQKaHR0cDovL3R3aXR0ZXIuY29tLyMhL3NwaW44Nzcvc3RhdHVzLzE4ODI2
NTUwODQwMTk3OTM5MgpodHRwOi8veGdhenphLmFsdGVydmlzdGEub3JnL0xpbnV4L0RWQi9k
aWtvbV9kdmJ0LkpQRwpSVEwyODMyVV8xQjgwX0QzOTQKCgoxYjgwOmQzOTUKKlVTQl9WSURf
S1dPUkxEXzIJMHgxYjgwClVTQl9QSURfS1dPUkxEX0QzOTUJMHhkMzk1Ck1heE1lZGlhIEhV
Mzk0LVQgVVNCIERWQi1UIE11bHRpIChGTSwgREFCLCBEQUIrKQpodHRwOi8vd3d3Lm1heG1l
ZGlhdGVrLmNvbS9wZC1wYWdlL0RWQi1UX1VTQi5odG0KUEVBSyBIYXJkd2FyZSAxMDI1NjlB
R1BLIERWQi1UIERpZ2l0YWwgVFYgVVNCIFN0aWNrCmh0dHA6Ly91YnVudHVmb3J1bXMub3Jn
L3Nob3d0aHJlYWQucGhwP3Q9MTY3ODA5NApSVEwyODMyVV8xQjgwX0QzOTUKCgoxYjgwOmQz
OTkKRFZCLVQgVFYgU3RpY2sgRDM5OQoqVVNCX1ZJRF9LV09STERfMgkweDFiODAKVVNCX1BJ
RF9LV09STERfRDM5OQkweGQzOTkKaHR0cDovL3VidW50dWZvcnVtcy5vcmcvc2hvd3RocmVh
ZC5waHA/dD0xNjc4MDk0JnBhZ2U9MgpSVEwyODMyVV8xQjgwX0QzOTkKCgoxZjRkOmI4MDMK
KlVTQl9WSURfR1RFSwkweDFmNGQKKlVTQl9QSURfR1RFSwkweGI4MDMKRGVMT0NLIFVTQiAy
LjAgRFZCLVQgUmVjZWl2ZXIgNjE3NDQKaHR0cDovL3d3dy5kZWxvY2suY29tL3Byb2R1a3Rl
L2dydXBwZW4vTXVsdGltZWRpYS9EZWxvY2tfVVNCXzIwX0RWQi1UX1JlY2VpdmVyXzYxNzQ0
Lmh0bWwKRy1UZWsgVDgwMyAKTXlHaWNhIFQ4MDMgRFZCLVQgVVNCIFRWIFN0aWNrCmh0dHA6
Ly93d3cubXlnaWNhLmNvbS9wcm9kdWN0LmFzcD9pZD0xNDkKKlJUTDI4MzJVXzFGNERfQjgw
MwoKCjFmNGQ6YzgwMwoqVVNCX1ZJRF9HVEVLCQkJMHgxZjRkClVTQl9QSURfTk9UX09OTFlf
TFY1VERFTFVYRQkweGM4MDMKTGlmZVZpZXcvTm90IE9ubHkgVFYgRFZCLVQgVVNCIERFTFVY
RSBMVjVUREVMVVhFCmh0dHA6Ly9ub3Rvbmx5dHYubmV0L3BfbHY1dGRlbHV4ZS5odG1sClJU
TDI4MzJVXzFGNERfQzgwMwoKCjFmNGQ6ZDgwMwoqVVNCX1ZJRF9HVEVLCQkJMHgxZjRkClVT
Ql9QSURfUFJPTEVDVFJJWF9EVjEwNzY2OQkweGQ4MDMKUFJPbGVjdHJpeCBVU0IgRFZCLVQg
JiBEQUIgRG9uZ2xlIERWMTA3NjY5Cmh0dHA6Ly93d3cucmVkZGl0LmNvbS91c2VyL0dyYWhh
bU0yNDIKUlRMMjgzMlVfMUY0RF9EODAzCgoKaHR0cHM6Ly9naXRodWIuY29tL3RtYWlyL0RW
Qi1SZWFsdGVrLVJUTDI4MzJVLTIuMi4yLTEwdHVuZXItbW9kX2tlcm5lbC0zLjAuMC9ibG9i
L21hc3Rlci9SRUFETUUKaHR0cDovL3d3dy5yZWRkaXQuY29tL3IvUlRMU0RSL2NvbW1lbnRz
L3M2ZGRvL3J0bHNkcl9jb21wYXRpYmlsaXR5X2xpc3RfdjJfd29ya19pbl9wcm9ncmVzcy8K
Cgo=
--------------030400080705000002000502--
