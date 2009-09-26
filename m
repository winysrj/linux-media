Return-path: <linux-media-owner@vger.kernel.org>
Received: from web31002.mail.mud.yahoo.com ([68.142.200.165]:27727 "HELO
	web31002.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751800AbZIZU4O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 16:56:14 -0400
Message-ID: <94949.68456.qm@web31002.mail.mud.yahoo.com>
Date: Sat, 26 Sep 2009 13:49:37 -0700 (PDT)
From: =?iso-8859-1?Q?S=E9rgio_Fortier?= <sergiofortier@yahoo.com.br>
Subject: EvolutePC TvWay+ USB ISDB-Tb fullseg device support
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1572355505-1253998177=:68456"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0-1572355505-1253998177=:68456
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Patch for EvolutePC TvWay+ USB ISDB-Tb fullseg device support=0A=0A=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
diff -r 6b7617d4a0be linux/drivers/media/dvb/dvb-usb/dib0700_devices.c=0A--=
- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c    Sat Sep 26 13:45:0=
3 2009 -0300=0A+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c    S=
at Sep 26 17:18:45 2009 -0300=0A@@ -1917,6 +1917,7 @@=0A    { USB_DEVICE(US=
B_VID_DIBCOM,    USB_PID_DIBCOM_STK807XPVR) },=0A    { USB_DEVICE(USB_VID_D=
IBCOM,    USB_PID_DIBCOM_STK807XP) },=0A    { USB_DEVICE(USB_VID_PIXELVIEW,=
 USB_PID_PIXELVIEW_SBTVD) },=0A+    { USB_DEVICE(USB_VID_EVOLUTEPC, USB_PID=
_TVWAY_PLUS) },=0A    { 0 }        /* Terminating entry */=0A};=0AMODULE_DE=
VICE_TABLE(usb, dib0700_usb_id_table);=0A@@ -2422,7 +2423,7 @@=0A          =
  },=0A        },=0A=0A-        .num_device_descs =3D 2,=0A+        .num_de=
vice_descs =3D 3,=0A        .devices =3D {=0A            {   "DiBcom STK807=
xP reference design",=0A                { &dib0700_usb_id_table[62], NULL }=
,=0A@@ -2432,6 +2433,10 @@=0A                { &dib0700_usb_id_table[63], N=
ULL },=0A                { NULL },=0A            },=0A+            {   "Evo=
lutePC TVWay+",=0A+                { &dib0700_usb_id_table[64], NULL },=0A+=
                { NULL },=0A+            },=0A        },=0A=0A        .rc_i=
nterval      =3D DEFAULT_RC_INTERVAL,=0Adiff -r 6b7617d4a0be linux/drivers/=
media/dvb/dvb-usb/dvb-usb-ids.h=0A--- a/linux/drivers/media/dvb/dvb-usb/dvb=
-usb-ids.h    Sat Sep 26 13:45:03 2009 -0300=0A+++ b/linux/drivers/media/dv=
b/dvb-usb/dvb-usb-ids.h    Sat Sep 26 17:18:45 2009 -0300=0A@@ -61,6 +61,7 =
@@=0A#define USB_VID_XTENSIONS            0x1ae7=0A#define USB_VID_HUMAX_CO=
EX            0x10b9=0A#define USB_VID_774                0x7a69=0A+#define=
 USB_VID_EVOLUTEPC            0x1e59=0A=0A/* Product IDs */=0A#define USB_P=
ID_ADSTECH_USB2_COLD            0xa333=0A@@ -276,5 +277,6 @@=0A#define USB_=
PID_DVB_T_USB_STICK_HIGH_SPEED_COLD        0x5000=0A#define USB_PID_DVB_T_U=
SB_STICK_HIGH_SPEED_WARM        0x5001=0A#define USB_PID_FRIIO_WHITE       =
         0x0001=0A+#define USB_PID_TVWAY_PLUS                0x0002=0A=0A#e=
ndif=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0ASigned-of=
f-by: S=E9rgio C Fortier <sergiofortier@yahoo.com.br>=0A=0ARegards,=0A=0A=
=0A=0A      _______________________________________________________________=
_____________________=0AVeja quais s=E3o os assuntos do momento no Yahoo! +=
Buscados=0Ahttp://br.maisbuscados.yahoo.com
--0-1572355505-1253998177=:68456
Content-Type: text/x-patch; name="tvwayplus.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="tvwayplus.patch"

ZGlmZiAtciA2Yjc2MTdkNGEwYmUgbGludXgvZHJpdmVycy9tZWRpYS9kdmIv
ZHZiLXVzYi9kaWIwNzAwX2RldmljZXMuYwotLS0gYS9saW51eC9kcml2ZXJz
L21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCVNhdCBTZXAg
MjYgMTM6NDU6MDMgMjAwOSAtMDMwMAorKysgYi9saW51eC9kcml2ZXJzL21l
ZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCVNhdCBTZXAgMjYg
MTc6MTg6NDUgMjAwOSAtMDMwMApAQCAtMTkxNyw2ICsxOTE3LDcgQEAKIAl7
IFVTQl9ERVZJQ0UoVVNCX1ZJRF9ESUJDT00sICAgIFVTQl9QSURfRElCQ09N
X1NUSzgwN1hQVlIpIH0sCiAJeyBVU0JfREVWSUNFKFVTQl9WSURfRElCQ09N
LCAgICBVU0JfUElEX0RJQkNPTV9TVEs4MDdYUCkgfSwKIAl7IFVTQl9ERVZJ
Q0UoVVNCX1ZJRF9QSVhFTFZJRVcsIFVTQl9QSURfUElYRUxWSUVXX1NCVFZE
KSB9LAorCXsgVVNCX0RFVklDRShVU0JfVklEX0VWT0xVVEVQQywgVVNCX1BJ
RF9UVldBWV9QTFVTKSB9LAogCXsgMCB9CQkvKiBUZXJtaW5hdGluZyBlbnRy
eSAqLwogfTsKIE1PRFVMRV9ERVZJQ0VfVEFCTEUodXNiLCBkaWIwNzAwX3Vz
Yl9pZF90YWJsZSk7CkBAIC0yNDIyLDcgKzI0MjMsNyBAQAogCQkJfSwKIAkJ
fSwKIAotCQkubnVtX2RldmljZV9kZXNjcyA9IDIsCisJCS5udW1fZGV2aWNl
X2Rlc2NzID0gMywKIAkJLmRldmljZXMgPSB7CiAJCQl7ICAgIkRpQmNvbSBT
VEs4MDd4UCByZWZlcmVuY2UgZGVzaWduIiwKIAkJCQl7ICZkaWIwNzAwX3Vz
Yl9pZF90YWJsZVs2Ml0sIE5VTEwgfSwKQEAgLTI0MzIsNiArMjQzMywxMCBA
QAogCQkJCXsgJmRpYjA3MDBfdXNiX2lkX3RhYmxlWzYzXSwgTlVMTCB9LAog
CQkJCXsgTlVMTCB9LAogCQkJfSwKKwkJCXsgICAiRXZvbHV0ZVBDIFRWV2F5
KyIsCisJCQkJeyAmZGliMDcwMF91c2JfaWRfdGFibGVbNjRdLCBOVUxMIH0s
CisJCQkJeyBOVUxMIH0sCisJCQl9LAogCQl9LAogCiAJCS5yY19pbnRlcnZh
bCAgICAgID0gREVGQVVMVF9SQ19JTlRFUlZBTCwKZGlmZiAtciA2Yjc2MTdk
NGEwYmUgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNi
LWlkcy5oCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2Iv
ZHZiLXVzYi1pZHMuaAlTYXQgU2VwIDI2IDEzOjQ1OjAzIDIwMDkgLTAzMDAK
KysrIGIvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNi
LWlkcy5oCVNhdCBTZXAgMjYgMTc6MTg6NDUgMjAwOSAtMDMwMApAQCAtNjEs
NiArNjEsNyBAQAogI2RlZmluZSBVU0JfVklEX1hURU5TSU9OUwkJCTB4MWFl
NwogI2RlZmluZSBVU0JfVklEX0hVTUFYX0NPRVgJCQkweDEwYjkKICNkZWZp
bmUgVVNCX1ZJRF83NzQJCQkJMHg3YTY5CisjZGVmaW5lIFVTQl9WSURfRVZP
TFVURVBDCQkJMHgxZTU5CiAKIC8qIFByb2R1Y3QgSURzICovCiAjZGVmaW5l
IFVTQl9QSURfQURTVEVDSF9VU0IyX0NPTEQJCQkweGEzMzMKQEAgLTI3Niw1
ICsyNzcsNiBAQAogI2RlZmluZSBVU0JfUElEX0RWQl9UX1VTQl9TVElDS19I
SUdIX1NQRUVEX0NPTEQJCTB4NTAwMAogI2RlZmluZSBVU0JfUElEX0RWQl9U
X1VTQl9TVElDS19ISUdIX1NQRUVEX1dBUk0JCTB4NTAwMQogI2RlZmluZSBV
U0JfUElEX0ZSSUlPX1dISVRFCQkJCTB4MDAwMQorI2RlZmluZSBVU0JfUElE
X1RWV0FZX1BMVVMJCQkJMHgwMDAyCiAKICNlbmRpZgo=

--0-1572355505-1253998177=:68456--
