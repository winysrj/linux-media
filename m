Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59537 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab0HQR4M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Aug 2010 13:56:12 -0400
Received: by ywh1 with SMTP id 1so2619665ywh.19
        for <linux-media@vger.kernel.org>; Tue, 17 Aug 2010 10:56:12 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 Aug 2010 10:56:12 -0700
Message-ID: <AANLkTi=dRSDj5W4LsYkNmLEERkWYCHsFuwePeDuXruyU@mail.gmail.com>
Subject: [PATCH] gp8psk: Add support for the Genpix Skywalker-2
From: VDR User <user.vdr@gmail.com>
To: Alan Nisota <alannisota@gmail.com>,
	"mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e640d3d22538a9048e08aa32
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

--0016e640d3d22538a9048e08aa32
Content-Type: text/plain; charset=ISO-8859-1

gp8psk: Add support for the Genpix Skywalker-2 per user requests.

Patched against v4l-dvb hg ab433502e041 tip.  Should patch fine
against git as well.

Signed-off-by: Derek Kelly <user.vdr@gmail.com>
----------
diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
2010-08-17 09:53:27.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
2010-08-17 10:38:48.000000000 -0700
@@ -267,6 +267,7 @@
 #define USB_PID_GENPIX_8PSK_REV_2                      0x0202
 #define USB_PID_GENPIX_SKYWALKER_1                     0x0203
 #define USB_PID_GENPIX_SKYWALKER_CW3K                  0x0204
+#define USB_PID_GENPIX_SKYWALKER_2                     0x0206
 #define USB_PID_SIGMATEK_DVB_110                       0x6610
 #define USB_PID_MSI_DIGI_VOX_MINI_II                   0x1513
 #define USB_PID_MSI_DIGIVOX_DUO                                0x8801
diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk.c
v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk.c
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk.c
2010-08-17 09:53:27.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk.c    2010-08-17
10:42:33.000000000 -0700
@@ -227,6 +227,7 @@ static struct usb_device_id gp8psk_usb_t
            { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_WARM) },
            { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_2) },
            { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_1) },
+           { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_2) },
 /*         { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_CW3K) }, */
            { 0 },
 };
@@ -258,7 +259,7 @@ static struct dvb_usb_device_properties

        .generic_bulk_ctrl_endpoint = 0x01,

-       .num_device_descs = 3,
+       .num_device_descs = 4,
        .devices = {
                { .name = "Genpix 8PSK-to-USB2 Rev.1 DVB-S receiver",
                  .cold_ids = { &gp8psk_usb_table[0], NULL },
@@ -272,10 +273,14 @@ static struct dvb_usb_device_properties
                  .cold_ids = { NULL },
                  .warm_ids = { &gp8psk_usb_table[3], NULL },
                },
+               { .name = "Genpix SkyWalker-2 DVB-S receiver",
+                 .cold_ids = { NULL },
+                 .warm_ids = { &gp8psk_usb_table[4], NULL },
+               },
 #if 0
                { .name = "Genpix SkyWalker-CW3K DVB-S receiver",
                  .cold_ids = { NULL },
-                 .warm_ids = { &gp8psk_usb_table[4], NULL },
+                 .warm_ids = { &gp8psk_usb_table[5], NULL },
                },
 #endif
                { NULL },

--0016e640d3d22538a9048e08aa32
Content-Type: application/octet-stream; name="gp8psk-add_skywalker-2.diff"
Content-Disposition: attachment; filename="gp8psk-add_skywalker-2.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gcz1siwr0

ZGlmZiAtcHJ1TiB2NGwtZHZiLm9yaWcvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9k
dmItdXNiLWlkcy5oIHY0bC1kdmIvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmIt
dXNiLWlkcy5oCi0tLSB2NGwtZHZiLm9yaWcvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVz
Yi9kdmItdXNiLWlkcy5oCTIwMTAtMDgtMTcgMDk6NTM6MjcuMDAwMDAwMDAwIC0wNzAwCisrKyB2
NGwtZHZiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaAkyMDEw
LTA4LTE3IDEwOjM4OjQ4LjAwMDAwMDAwMCAtMDcwMApAQCAtMjY3LDYgKzI2Nyw3IEBACiAjZGVm
aW5lIFVTQl9QSURfR0VOUElYXzhQU0tfUkVWXzIJCQkweDAyMDIKICNkZWZpbmUgVVNCX1BJRF9H
RU5QSVhfU0tZV0FMS0VSXzEJCQkweDAyMDMKICNkZWZpbmUgVVNCX1BJRF9HRU5QSVhfU0tZV0FM
S0VSX0NXM0sJCQkweDAyMDQKKyNkZWZpbmUgVVNCX1BJRF9HRU5QSVhfU0tZV0FMS0VSXzIJCQkw
eDAyMDYKICNkZWZpbmUgVVNCX1BJRF9TSUdNQVRFS19EVkJfMTEwCQkJMHg2NjEwCiAjZGVmaW5l
IFVTQl9QSURfTVNJX0RJR0lfVk9YX01JTklfSUkJCQkweDE1MTMKICNkZWZpbmUgVVNCX1BJRF9N
U0lfRElHSVZPWF9EVU8JCQkJMHg4ODAxCmRpZmYgLXBydU4gdjRsLWR2Yi5vcmlnL2xpbnV4L2Ry
aXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZ3A4cHNrLmMgdjRsLWR2Yi9saW51eC9kcml2ZXJzL21l
ZGlhL2R2Yi9kdmItdXNiL2dwOHBzay5jCi0tLSB2NGwtZHZiLm9yaWcvbGludXgvZHJpdmVycy9t
ZWRpYS9kdmIvZHZiLXVzYi9ncDhwc2suYwkyMDEwLTA4LTE3IDA5OjUzOjI3LjAwMDAwMDAwMCAt
MDcwMAorKysgdjRsLWR2Yi9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2dwOHBzay5j
CTIwMTAtMDgtMTcgMTA6NDI6MzMuMDAwMDAwMDAwIC0wNzAwCkBAIC0yMjcsNiArMjI3LDcgQEAg
c3RhdGljIHN0cnVjdCB1c2JfZGV2aWNlX2lkIGdwOHBza191c2JfdAogCSAgICB7IFVTQl9ERVZJ
Q0UoVVNCX1ZJRF9HRU5QSVgsIFVTQl9QSURfR0VOUElYXzhQU0tfUkVWXzFfV0FSTSkgfSwKIAkg
ICAgeyBVU0JfREVWSUNFKFVTQl9WSURfR0VOUElYLCBVU0JfUElEX0dFTlBJWF84UFNLX1JFVl8y
KSB9LAogCSAgICB7IFVTQl9ERVZJQ0UoVVNCX1ZJRF9HRU5QSVgsIFVTQl9QSURfR0VOUElYX1NL
WVdBTEtFUl8xKSB9LAorCSAgICB7IFVTQl9ERVZJQ0UoVVNCX1ZJRF9HRU5QSVgsIFVTQl9QSURf
R0VOUElYX1NLWVdBTEtFUl8yKSB9LAogLyoJICAgIHsgVVNCX0RFVklDRShVU0JfVklEX0dFTlBJ
WCwgVVNCX1BJRF9HRU5QSVhfU0tZV0FMS0VSX0NXM0spIH0sICovCiAJICAgIHsgMCB9LAogfTsK
QEAgLTI1OCw3ICsyNTksNyBAQCBzdGF0aWMgc3RydWN0IGR2Yl91c2JfZGV2aWNlX3Byb3BlcnRp
ZXMKIAogCS5nZW5lcmljX2J1bGtfY3RybF9lbmRwb2ludCA9IDB4MDEsCiAKLQkubnVtX2Rldmlj
ZV9kZXNjcyA9IDMsCisJLm51bV9kZXZpY2VfZGVzY3MgPSA0LAogCS5kZXZpY2VzID0gewogCQl7
IC5uYW1lID0gIkdlbnBpeCA4UFNLLXRvLVVTQjIgUmV2LjEgRFZCLVMgcmVjZWl2ZXIiLAogCQkg
IC5jb2xkX2lkcyA9IHsgJmdwOHBza191c2JfdGFibGVbMF0sIE5VTEwgfSwKQEAgLTI3MiwxMCAr
MjczLDE0IEBAIHN0YXRpYyBzdHJ1Y3QgZHZiX3VzYl9kZXZpY2VfcHJvcGVydGllcwogCQkgIC5j
b2xkX2lkcyA9IHsgTlVMTCB9LAogCQkgIC53YXJtX2lkcyA9IHsgJmdwOHBza191c2JfdGFibGVb
M10sIE5VTEwgfSwKIAkJfSwKKwkJeyAubmFtZSA9ICJHZW5waXggU2t5V2Fsa2VyLTIgRFZCLVMg
cmVjZWl2ZXIiLAorCQkgIC5jb2xkX2lkcyA9IHsgTlVMTCB9LAorCQkgIC53YXJtX2lkcyA9IHsg
JmdwOHBza191c2JfdGFibGVbNF0sIE5VTEwgfSwKKwkJfSwKICNpZiAwCiAJCXsgLm5hbWUgPSAi
R2VucGl4IFNreVdhbGtlci1DVzNLIERWQi1TIHJlY2VpdmVyIiwKIAkJICAuY29sZF9pZHMgPSB7
IE5VTEwgfSwKLQkJICAud2FybV9pZHMgPSB7ICZncDhwc2tfdXNiX3RhYmxlWzRdLCBOVUxMIH0s
CisJCSAgLndhcm1faWRzID0geyAmZ3A4cHNrX3VzYl90YWJsZVs1XSwgTlVMTCB9LAogCQl9LAog
I2VuZGlmCiAJCXsgTlVMTCB9LAo=
--0016e640d3d22538a9048e08aa32--
