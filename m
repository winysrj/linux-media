Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9JNAY00015452
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 19:10:34 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9JNAFu3008505
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 19:10:15 -0400
Received: by ug-out-1314.google.com with SMTP id o38so422838ugd.13
	for <video4linux-list@redhat.com>; Sun, 19 Oct 2008 16:10:15 -0700 (PDT)
Message-ID: <208cbae30810191610s74b0dbeejef57ffd3d43cc3a4@mail.gmail.com>
Date: Mon, 20 Oct 2008 03:10:13 +0400
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: video4linux-list@redhat.com, "Tobias Lorenz" <tobias.lorenz@gmx.net>,
	"Mauro Carvalho Chehab" <mchehab@redhat.com>,
	"Douglas Schilling Landgraf" <dougsland@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_140417_11431958.1224457813768"
Cc: 
Subject: [PATCH] radio-si470x: add support for kworld usb-radio
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

------=_Part_140417_11431958.1224457813768
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello, all

Few days ago i bought usb-radio, produced by KWorld.
It's called KWorld USB FM Radio SnapMusic Mobile 700 (FM700).
Link on the site:
http://www.kworld-global.com/main/prod_in.aspx?mnuid=1306&modid=10&pcid=74&ifid=17&prodid=106
(if link isn't work may be it's better to find it on the site or google it)

There is chip in there named "silabs something", so i tried to add
support in Tobias' driver radio-si470x. Have success. Works fine with
kradio and gnomeradio under 2.6.27-git5 kernel. Thanks Tobias for
consideration.
(Tobias, if you want that patch change version of driver just ask and
i can re-make the patch)

I think it's not critical right now, i used "arecord -D hw:2,0 -r96000
-c2 -f S16_LE | artsdsp aplay -B -" and periodically get "underrun"
messages:
tux ~ # arecord -D hw:2,0 -r96000 -c2 -f S16_LE | artsdsp aplay -B -
Recording WAVE 'stdin' : Signed 16 bit Little Endian, Rate 96000 Hz, Stereo
Playing WAVE 'stdin' : Signed 16 bit Little Endian, Rate 96000 Hz, Stereo
underrun!!! (at least 12480.157 ms long)
underrun!!! (at least 1009.733 ms long)
underrun!!! (at least 752.946 ms long)
underrun!!! (at least 1009.364 ms long)
underrun!!! (at least 1008.390 ms long)
underrun!!! (at least 757.369 ms long)
...

So, we have two patches. Patches attached to letter. Patch that
touches HID-subsystem is created to be applied against -git tree on
kernel.org.

1)
radio-si470x: add support for kworld usb radio

This patch add support for new device named KWorld USB FM Radio
SnapMusic Mobile 700 (FM700).
And changes few lines in comments.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

2)
HID: Don't allow KWorld radio fm700 be handled by usb hid drivers

This device is already handled by radio-si470x driver, and we
therefore want usbhid to ignore it.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

-- 
Best regards, Klimov Alexey

------=_Part_140417_11431958.1224457813768
Content-Type: application/octet-stream;
	name=radio-si470x-add-support-kworld.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmi9wxp10
Content-Disposition: attachment; filename=radio-si470x-add-support-kworld.patch

ZGlmZiAtciA0N2E1MzY3MzQyOWIgbGludXgvZHJpdmVycy9tZWRpYS9yYWRpby9yYWRpby1zaTQ3
MHguYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL3JhZGlvL3JhZGlvLXNpNDcweC5jCU1vbiBP
Y3QgMjAgMDE6Mzk6NDggMjAwOCArMDQwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL3JhZGlv
L3JhZGlvLXNpNDcweC5jCU1vbiBPY3QgMjAgMDI6Mjg6MTQgMjAwOCArMDQwMApAQCAtNCw2ICs0
LDcgQEAKICAqICBEcml2ZXIgZm9yIFVTQiByYWRpb3MgZm9yIHRoZSBTaWxpY29uIExhYnMgU2k0
NzB4IEZNIFJhZGlvIFJlY2VpdmVyczoKICAqICAgLSBTaWxpY29uIExhYnMgVVNCIEZNIFJhZGlv
IFJlZmVyZW5jZSBEZXNpZ24KICAqICAgLSBBRFMvVGVjaCBGTSBSYWRpbyBSZWNlaXZlciAoZm9y
bWVybHkgSW5zdGFudCBGTSBNdXNpYykgKFJEWC0xNTUtRUYpCisgKiAgIC0gS1dvcmxkIFVTQiBG
TSBSYWRpbyBTbmFwTXVzaWMgTW9iaWxlIDcwMCAoRk03MDApCiAgKgogICogIENvcHlyaWdodCAo
YykgMjAwOCBUb2JpYXMgTG9yZW56IDx0b2JpYXMubG9yZW56QGdteC5uZXQ+CiAgKgpAQCAtMTA1
LDYgKzEwNiw5IEBACiAgKgkJLSBhZmMgaW5kaWNhdGlvbgogICoJCS0gbW9yZSBzYWZldHkgY2hl
Y2tzLCBsZXQgc2k0NzB4X2dldF9mcmVxIHJldHVybiBlcnJubwogICoJCS0gdmlkaW9jIGJlaGF2
aW9yIGNvcnJlY3RlZCBhY2NvcmRpbmcgdG8gdjRsMiBzcGVjCisgKiAyMDA4LTEwLTIwCUFsZXhl
eSBLbGltb3YgPGtsaW1vdi5saW51eEBnbWFpbC5jb20+CisgKiAJCS0gYWRkIHN1cHBvcnQgZm9y
IEtXb3JsZCBVU0IgRk0gUmFkaW8gRk03MDAKKyAqIAkJLSBibGFja2xpc3RlZCBLV29ybGQgcmFk
aW8gaW4gaGlkLWNvcmUuYyBhbmQgaGlkLWlkcy5oCiAgKgogICogVG9EbzoKICAqIC0gYWRkIGZp
cm13YXJlIGRvd25sb2FkL3VwZGF0ZSBzdXBwb3J0CkBAIC0xNDYsNiArMTUwLDggQEAKIAl7IFVT
Ql9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKDB4MTBjNCwgMHg4MThhLCBVU0JfQ0xBU1NfSElE
LCAwLCAwKSB9LAogCS8qIEFEUy9UZWNoIEZNIFJhZGlvIFJlY2VpdmVyIChmb3JtZXJseSBJbnN0
YW50IEZNIE11c2ljKSAqLwogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oMHgwNmUx
LCAweGExNTUsIFVTQl9DTEFTU19ISUQsIDAsIDApIH0sCisJLyogS1dvcmxkIFVTQiBGTSBSYWRp
byBTbmFwTXVzaWMgTW9iaWxlIDcwMCAoRk03MDApICovCisJeyBVU0JfREVWSUNFX0FORF9JTlRF
UkZBQ0VfSU5GTygweDFiODAsIDB4ZDcwMCwgVVNCX0NMQVNTX0hJRCwgMCwgMCkgfSwKIAkvKiBU
ZXJtaW5hdGluZyBlbnRyeSAqLwogCXsgfQogfTsK
------=_Part_140417_11431958.1224457813768
Content-Type: application/octet-stream; name=radio-kworld-fm700-hidquirks.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmi9y26u1
Content-Disposition: attachment;
 filename=radio-kworld-fm700-hidquirks.patch

ZGlmZiAtciA0N2E1MzY3MzQyOWIgbGludXgvZHJpdmVycy9oaWQvaGlkLWNvcmUuYwotLS0gYS9s
aW51eC9kcml2ZXJzL2hpZC9oaWQtY29yZS5jCU1vbiBPY3QgMjAgMDE6Mzk6NDggMjAwOCArMDQw
MAorKysgYi9saW51eC9kcml2ZXJzL2hpZC9oaWQtY29yZS5jCU1vbiBPY3QgMjAgMDE6NTY6MjAg
MjAwOCArMDQwMApAQCAtMTI2NCw2ICsxMjY0LDcgQEAKIAl7IEhJRF9VU0JfREVWSUNFKFVTQl9W
RU5ET1JfSURfREVMTCwgVVNCX0RFVklDRV9JRF9ERUxMX1NLODExNSkgfSwKIAl7IEhJRF9VU0Jf
REVWSUNFKFVTQl9WRU5ET1JfSURfRVpLRVksIFVTQl9ERVZJQ0VfSURfQlRDXzgxOTMpIH0sCiAJ
eyBISURfVVNCX0RFVklDRShVU0JfVkVORE9SX0lEX0dZUkFUSU9OLCBVU0JfREVWSUNFX0lEX0dZ
UkFUSU9OX1JFTU9URSkgfSwKKwl7IEhJRF9VU0JfREVWSUNFKFVTQl9WRU5ET1JfSURfS1dPUkxE
LCBVU0JfREVWSUNFX0lEX0tXT1JMRF9SQURJT19GTTcwMCkgfSwKIAl7IEhJRF9VU0JfREVWSUNF
KFVTQl9WRU5ET1JfSURfTEFCVEVDLCBVU0JfREVWSUNFX0lEX0xBQlRFQ19XSVJFTEVTU19LRVlC
T0FSRCkgfSwKIAl7IEhJRF9VU0JfREVWSUNFKFVTQl9WRU5ET1JfSURfTE9HSVRFQ0gsIFVTQl9E
RVZJQ0VfSURfTVgzMDAwX1JFQ0VJVkVSKSB9LAogCXsgSElEX1VTQl9ERVZJQ0UoVVNCX1ZFTkRP
Ul9JRF9MT0dJVEVDSCwgVVNCX0RFVklDRV9JRF9TNTEwX1JFQ0VJVkVSKSB9LApkaWZmIC1yIDQ3
YTUzNjczNDI5YiBsaW51eC9kcml2ZXJzL2hpZC9oaWQtaWRzLmgKLS0tIGEvbGludXgvZHJpdmVy
cy9oaWQvaGlkLWlkcy5oCU1vbiBPY3QgMjAgMDE6Mzk6NDggMjAwOCArMDQwMAorKysgYi9saW51
eC9kcml2ZXJzL2hpZC9oaWQtaWRzLmgJTW9uIE9jdCAyMCAwMTo1NjoyMCAyMDA4ICswNDAwCkBA
IC0yNDgsNiArMjQ4LDkgQEAKICNkZWZpbmUgVVNCX1ZFTkRPUl9JRF9LQkdFQVIJCTB4MDg0ZQog
I2RlZmluZSBVU0JfREVWSUNFX0lEX0tCR0VBUl9KQU1TVFVESU8JMHgxMDAxCiAKKyNkZWZpbmUg
VVNCX1ZFTkRPUl9JRF9LV09STEQJCTB4MWI4MAorI2RlZmluZSBVU0JfREVWSUNFX0lEX0tXT1JM
RF9SQURJT19GTTcwMAkweGQ3MDAKKwogI2RlZmluZSBVU0JfVkVORE9SX0lEX0xBQlRFQwkJMHgx
MDIwCiAjZGVmaW5lIFVTQl9ERVZJQ0VfSURfTEFCVEVDX1dJUkVMRVNTX0tFWUJPQVJECTB4MDAw
NgogCg==
------=_Part_140417_11431958.1224457813768
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_140417_11431958.1224457813768--
