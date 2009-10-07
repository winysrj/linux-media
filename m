Return-path: <linux-media-owner@vger.kernel.org>
Received: from web31006.mail.mud.yahoo.com ([68.142.200.169]:28680 "HELO
	web31006.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758483AbZJGOYA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Oct 2009 10:24:00 -0400
Message-ID: <219994.55411.qm@web31006.mail.mud.yahoo.com>
Date: Wed, 7 Oct 2009 07:23:22 -0700 (PDT)
From: =?iso-8859-1?Q?S=E9rgio_Fortier?= <sergiofortier@yahoo.com.br>
Subject: EvolutePC TvWay+ USB ISDB-Tb remote control support
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1310136187-1254925402=:55411"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0-1310136187-1254925402=:55411
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Patch for EvolutePC TvWay+ USB ISDB-Tb remote control support.=0A=0A=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
diff -r b40a02b54719 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c=0A--=
- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c    Tue Oct 06 15:15:1=
0 2009 -0300=0A+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c    T=
ue Oct 06 19:03:09 2009 -0300=0A@@ -926,12 +926,25 @@=0A =0A     { 0x8618, =
KEY_RECORD },=0A     { 0x861a, KEY_STOP },=0A-};=0A =0A+    /* Key codes fo=
r the EvolutePC TVWay+ remote (proto NEC) */=0A+    { 0x7a00, KEY_MENU },  =
=0A+    { 0x7a01, KEY_RECORD }, =0A+    { 0x7a02, KEY_PLAY },=0A+    { 0x7a=
03, KEY_STOP },=0A+    { 0x7a10, KEY_CHANNELUP },=0A+    { 0x7a11, KEY_CHAN=
NELDOWN },=0A+    { 0x7a12, KEY_VOLUMEUP },=0A+    { 0x7a13, KEY_VOLUMEDOWN=
 },=0A+    { 0x7a40, KEY_POWER },=0A+    { 0x7a41, KEY_MUTE },=0A+};     =
=0A+       =0A /* STK7700P: Hauppauge Nova-T Stick, AVerMedia Volar */=0A s=
tatic struct dibx000_agc_config stk7700p_7000m_mt2060_agc_config =3D {=0A  =
   BAND_UHF | BAND_VHF,       // band_caps=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0ASigned-off-by: Sergio C Fortier <sergiofortier@y=
ahoo.com.br>=0A=0ARegards,=0A=0A=0A      __________________________________=
__________________________________________________=0AVeja quais s=E3o os as=
suntos do momento no Yahoo! +Buscados=0Ahttp://br.maisbuscados.yahoo.com
--0-1310136187-1254925402=:55411
Content-Type: application/octet-stream; name="tvway_remote.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="tvway_remote.patch"

ZGlmZiAtciBiNDBhMDJiNTQ3MTkgbGludXgvZHJpdmVycy9tZWRpYS9kdmIv
ZHZiLXVzYi9kaWIwNzAwX2RldmljZXMuYwotLS0gYS9saW51eC9kcml2ZXJz
L21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCVR1ZSBPY3Qg
MDYgMTU6MTU6MTAgMjAwOSAtMDMwMAorKysgYi9saW51eC9kcml2ZXJzL21l
ZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCVR1ZSBPY3QgMDYg
MTk6MDM6MDkgMjAwOSAtMDMwMApAQCAtOTI2LDEyICs5MjYsMjUgQEAKIAog
CXsgMHg4NjE4LCBLRVlfUkVDT1JEIH0sCiAJeyAweDg2MWEsIEtFWV9TVE9Q
IH0sCi19OwogCisJLyogS2V5IGNvZGVzIGZvciB0aGUgRXZvbHV0ZVBDIFRW
V2F5KyByZW1vdGUgKHByb3RvIE5FQykgKi8KKwl7IDB4N2EwMCwgS0VZX01F
TlUgfSwgIAorCXsgMHg3YTAxLCBLRVlfUkVDT1JEIH0sIAorCXsgMHg3YTAy
LCBLRVlfUExBWSB9LAorCXsgMHg3YTAzLCBLRVlfU1RPUCB9LAorCXsgMHg3
YTEwLCBLRVlfQ0hBTk5FTFVQIH0sCisJeyAweDdhMTEsIEtFWV9DSEFOTkVM
RE9XTiB9LAorCXsgMHg3YTEyLCBLRVlfVk9MVU1FVVAgfSwKKwl7IDB4N2Ex
MywgS0VZX1ZPTFVNRURPV04gfSwKKwl7IDB4N2E0MCwgS0VZX1BPV0VSIH0s
CisJeyAweDdhNDEsIEtFWV9NVVRFIH0sCit9OyAgICAgCisgICAgICAgCiAv
KiBTVEs3NzAwUDogSGF1cHBhdWdlIE5vdmEtVCBTdGljaywgQVZlck1lZGlh
IFZvbGFyICovCiBzdGF0aWMgc3RydWN0IGRpYngwMDBfYWdjX2NvbmZpZyBz
dGs3NzAwcF83MDAwbV9tdDIwNjBfYWdjX2NvbmZpZyA9IHsKIAlCQU5EX1VI
RiB8IEJBTkRfVkhGLCAgICAgICAvLyBiYW5kX2NhcHMK

--0-1310136187-1254925402=:55411--
