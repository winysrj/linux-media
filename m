Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBQEVtpY004319
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 09:31:55 -0500
Received: from mail-ew0-f33.google.com (mail-ew0-f33.google.com
	[209.85.219.33])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBQEVgO6022359
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 09:31:42 -0500
Received: by ewy14 with SMTP id 14so1551629ewy.3
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 06:31:42 -0800 (PST)
Message-ID: <2ac79fa40812260631r7f34d2a5nc49233866d010047@mail.gmail.com>
Date: Fri, 26 Dec 2008 21:31:41 +0700
From: "=?UTF-8?Q?Nam_Ph=E1=BA=A1m_Th=C3=A0nh?=" <phamthanhnam.ptn@gmail.com>
To: mchehab@infradead.org, hverkuil@xs4all.nl
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_110088_6551156.1230301901952"
Cc: video4linux-list@redhat.com
Subject: [PATCH] Add support for Avermedia AVerTV GO 007 FM Plus (1461:f31d)
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

------=_Part_110088_6551156.1230301901952
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all
I've tested carefully this patch on 4 cards (one is mine and 3 other
cards from 3 different stores (I can borrow them freely)) with kernel
2.6.27. I don't need any additional configuration, just patch the
module, reboot and they work (auto detected). TV, radio, sound, infrared
remote, S-Video, Line... almost work perfectly.
So, please add this support to make it easy for me and to help many
people in the world who have this TV card.
Best regards.

diff -ur 2c6835aaa8ea linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134    2008-12-22
17:54:05.000000000 +0700
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134    2008-12-22
19:33:06.000000000 +0700
@@ -152,3 +152,4 @@
 151 -> ADS Tech Instant HDTV                    [1421:0380]
 152 -> Asus Tiger Rev:1.00                      [1043:4857]
 153 -> Kworld Plus TV Analog Lite PCI           [17de:7128]
+154 -> Avermedia AVerTV GO 007 FM Plus          [1461:f31d]
diff -ur 2c6835aaa8ea linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c    2008-12-22
17:54:05.000000000 +0700
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c    2008-12-23
16:23:35.000000000 +0700
@@ -4682,6 +4682,38 @@
             .amux = 2,
         },
     },
+    [SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS] = {
+        .name           = "Avermedia AVerTV GO 007 FM Plus",
+        .audio_clock    = 0x00187de7,
+        .tuner_type     = TUNER_PHILIPS_TDA8290,
+        .radio_type     = UNSET,
+        .tuner_addr    = ADDR_UNSET,
+        .radio_addr    = ADDR_UNSET,
+        .gpiomask       = 0x00300003,
+        /* .gpiomask       = 0x8c240003, */
+        .inputs         = {{
+            .name = name_tv,
+            .vmux = 1,
+            .amux = TV,
+            .tv   = 1,
+            .gpio = 0x01,
+        },{
+            .name = name_svideo,
+            .vmux = 6,
+            .amux = LINE1,
+            .gpio = 0x02,
+        }},
+        .radio = {
+            .name = name_radio,
+            .amux = TV,
+            .gpio = 0x00300001,
+        },
+        .mute = {
+            .name = name_mute,
+            .amux = TV,
+            .gpio = 0x01,
+        },
+    },
 };

 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -5741,6 +5773,13 @@
         .subdevice    = 0x7128,
         .driver_data  = SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG,
     }, {
+        .vendor       = PCI_VENDOR_ID_PHILIPS,
+        .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+        .subvendor    = 0x1461, /* Avermedia Technologies Inc */
+        .subdevice    = 0xf31d,
+        .driver_data  = SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS,
+
+    }, {
         /* --- boards without eeprom + subsystem ID --- */
         .vendor       = PCI_VENDOR_ID_PHILIPS,
         .device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -6029,6 +6068,7 @@
     case SAA7134_BOARD_GENIUS_TVGO_A11MCE:
     case SAA7134_BOARD_REAL_ANGEL_220:
     case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
+    case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
         dev->has_remote = SAA7134_REMOTE_GPIO;
         break;
     case SAA7134_BOARD_FLYDVBS_LR300:
diff -ur 2c6835aaa8ea linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h    2008-12-22
17:54:05.000000000 +0700
+++ b/linux/drivers/media/video/saa7134/saa7134.h    2008-12-22
19:07:32.000000000 +0700
@@ -277,6 +277,7 @@
 #define SAA7134_BOARD_ADS_INSTANT_HDTV_PCI  151
 #define SAA7134_BOARD_ASUSTeK_TIGER         152
 #define SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG 153
+#define SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS 154

 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
diff -ur 2c6835aaa8ea linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c    2008-12-22
17:54:05.000000000 +0700
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c    2008-12-23
08:25:28.000000000 +0700
@@ -449,6 +449,7 @@
     case SAA7134_BOARD_AVERMEDIA_STUDIO_507:
     case SAA7134_BOARD_AVERMEDIA_GO_007_FM:
     case SAA7134_BOARD_AVERMEDIA_M102:
+    case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
         ir_codes     = ir_codes_avermedia;
         mask_keycode = 0x0007C8;
         mask_keydown = 0x000010;

Signed-off-by: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>

------=_Part_110088_6551156.1230301901952
Content-Type: text/x-patch; name=AverTVGO007FMPlus.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fp6xx97q
Content-Disposition: attachment; filename=AverTVGO007FMPlus.patch

ZGlmZiAtdXIgMmM2ODM1YWFhOGVhIGxpbnV4L0RvY3VtZW50YXRpb24vdmlkZW80bGludXgvQ0FS
RExJU1Quc2FhNzEzNAotLS0gYS9saW51eC9Eb2N1bWVudGF0aW9uL3ZpZGVvNGxpbnV4L0NBUkRM
SVNULnNhYTcxMzQJMjAwOC0xMi0yMiAxNzo1NDowNS4wMDAwMDAwMDAgKzA3MDAKKysrIGIvbGlu
dXgvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9DQVJETElTVC5zYWE3MTM0CTIwMDgtMTItMjIg
MTk6MzM6MDYuMDAwMDAwMDAwICswNzAwCkBAIC0xNTIsMyArMTUyLDQgQEAKIDE1MSAtPiBBRFMg
VGVjaCBJbnN0YW50IEhEVFYgICAgICAgICAgICAgICAgICAgIFsxNDIxOjAzODBdCiAxNTIgLT4g
QXN1cyBUaWdlciBSZXY6MS4wMCAgICAgICAgICAgICAgICAgICAgICBbMTA0Mzo0ODU3XQogMTUz
IC0+IEt3b3JsZCBQbHVzIFRWIEFuYWxvZyBMaXRlIFBDSSAgICAgICAgICAgWzE3ZGU6NzEyOF0K
KzE1NCAtPiBBdmVybWVkaWEgQVZlclRWIEdPIDAwNyBGTSBQbHVzICAgICAgICAgIFsxNDYxOmYz
MWRdCmRpZmYgLXVyIDJjNjgzNWFhYThlYSBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcx
MzQvc2FhNzEzNC1jYXJkcy5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vc2FhNzEz
NC9zYWE3MTM0LWNhcmRzLmMJMjAwOC0xMi0yMiAxNzo1NDowNS4wMDAwMDAwMDAgKzA3MDAKKysr
IGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9zYWE3MTM0L3NhYTcxMzQtY2FyZHMuYwkyMDA4
LTEyLTIzIDE2OjIzOjM1LjAwMDAwMDAwMCArMDcwMApAQCAtNDY4Miw2ICs0NjgyLDM4IEBACiAJ
CQkuYW11eCA9IDIsCiAJCX0sCiAJfSwKKwlbU0FBNzEzNF9CT0FSRF9BVkVSTUVESUFfR09fMDA3
X0ZNX1BMVVNdID0geworCQkubmFtZSAgICAgICAgICAgPSAiQXZlcm1lZGlhIEFWZXJUViBHTyAw
MDcgRk0gUGx1cyIsCisJCS5hdWRpb19jbG9jayAgICA9IDB4MDAxODdkZTcsCisJCS50dW5lcl90
eXBlICAgICA9IFRVTkVSX1BISUxJUFNfVERBODI5MCwKKwkJLnJhZGlvX3R5cGUgICAgID0gVU5T
RVQsCisJCS50dW5lcl9hZGRyCT0gQUREUl9VTlNFVCwKKwkJLnJhZGlvX2FkZHIJPSBBRERSX1VO
U0VULAorCQkuZ3Bpb21hc2sgICAgICAgPSAweDAwMzAwMDAzLAorCQkvKiAuZ3Bpb21hc2sgICAg
ICAgPSAweDhjMjQwMDAzLCAqLworCQkuaW5wdXRzICAgICAgICAgPSB7eworCQkJLm5hbWUgPSBu
YW1lX3R2LAorCQkJLnZtdXggPSAxLAorCQkJLmFtdXggPSBUViwKKwkJCS50diAgID0gMSwKKwkJ
CS5ncGlvID0gMHgwMSwKKwkJfSx7CisJCQkubmFtZSA9IG5hbWVfc3ZpZGVvLAorCQkJLnZtdXgg
PSA2LAorCQkJLmFtdXggPSBMSU5FMSwKKwkJCS5ncGlvID0gMHgwMiwKKwkJfX0sCisJCS5yYWRp
byA9IHsKKwkJCS5uYW1lID0gbmFtZV9yYWRpbywKKwkJCS5hbXV4ID0gVFYsCisJCQkuZ3BpbyA9
IDB4MDAzMDAwMDEsCisJCX0sCisJCS5tdXRlID0geworCQkJLm5hbWUgPSBuYW1lX211dGUsCisJ
CQkuYW11eCA9IFRWLAorCQkJLmdwaW8gPSAweDAxLAorCQl9LAorCX0sCiB9OwogCiBjb25zdCB1
bnNpZ25lZCBpbnQgc2FhNzEzNF9iY291bnQgPSBBUlJBWV9TSVpFKHNhYTcxMzRfYm9hcmRzKTsK
QEAgLTU3NDEsNiArNTc3MywxMyBAQAogCQkuc3ViZGV2aWNlICAgID0gMHg3MTI4LAogCQkuZHJp
dmVyX2RhdGEgID0gU0FBNzEzNF9CT0FSRF9LV09STERfUExVU19UVl9BTkFMT0csCiAJfSwgewor
CQkudmVuZG9yICAgICAgID0gUENJX1ZFTkRPUl9JRF9QSElMSVBTLAorCQkuZGV2aWNlICAgICAg
ID0gUENJX0RFVklDRV9JRF9QSElMSVBTX1NBQTcxMzMsCisJCS5zdWJ2ZW5kb3IgICAgPSAweDE0
NjEsIC8qIEF2ZXJtZWRpYSBUZWNobm9sb2dpZXMgSW5jICovCisJCS5zdWJkZXZpY2UgICAgPSAw
eGYzMWQsCisJCS5kcml2ZXJfZGF0YSAgPSBTQUE3MTM0X0JPQVJEX0FWRVJNRURJQV9HT18wMDdf
Rk1fUExVUywKKworCX0sIHsKIAkJLyogLS0tIGJvYXJkcyB3aXRob3V0IGVlcHJvbSArIHN1YnN5
c3RlbSBJRCAtLS0gKi8KIAkJLnZlbmRvciAgICAgICA9IFBDSV9WRU5ET1JfSURfUEhJTElQUywK
IAkJLmRldmljZSAgICAgICA9IFBDSV9ERVZJQ0VfSURfUEhJTElQU19TQUE3MTM0LApAQCAtNjAy
OSw2ICs2MDY4LDcgQEAKIAljYXNlIFNBQTcxMzRfQk9BUkRfR0VOSVVTX1RWR09fQTExTUNFOgog
CWNhc2UgU0FBNzEzNF9CT0FSRF9SRUFMX0FOR0VMXzIyMDoKIAljYXNlIFNBQTcxMzRfQk9BUkRf
S1dPUkxEX1BMVVNfVFZfQU5BTE9HOgorCWNhc2UgU0FBNzEzNF9CT0FSRF9BVkVSTUVESUFfR09f
MDA3X0ZNX1BMVVM6CiAJCWRldi0+aGFzX3JlbW90ZSA9IFNBQTcxMzRfUkVNT1RFX0dQSU87CiAJ
CWJyZWFrOwogCWNhc2UgU0FBNzEzNF9CT0FSRF9GTFlEVkJTX0xSMzAwOgpkaWZmIC11ciAyYzY4
MzVhYWE4ZWEgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9zYWE3MTM0L3NhYTcxMzQuaAotLS0g
YS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxMzQvc2FhNzEzNC5oCTIwMDgtMTItMjIg
MTc6NTQ6MDUuMDAwMDAwMDAwICswNzAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8v
c2FhNzEzNC9zYWE3MTM0LmgJMjAwOC0xMi0yMiAxOTowNzozMi4wMDAwMDAwMDAgKzA3MDAKQEAg
LTI3Nyw2ICsyNzcsNyBAQAogI2RlZmluZSBTQUE3MTM0X0JPQVJEX0FEU19JTlNUQU5UX0hEVFZf
UENJICAxNTEKICNkZWZpbmUgU0FBNzEzNF9CT0FSRF9BU1VTVGVLX1RJR0VSICAgICAgICAgMTUy
CiAjZGVmaW5lIFNBQTcxMzRfQk9BUkRfS1dPUkxEX1BMVVNfVFZfQU5BTE9HIDE1MworI2RlZmlu
ZSBTQUE3MTM0X0JPQVJEX0FWRVJNRURJQV9HT18wMDdfRk1fUExVUyAxNTQKIAogI2RlZmluZSBT
QUE3MTM0X01BWEJPQVJEUyAzMgogI2RlZmluZSBTQUE3MTM0X0lOUFVUX01BWCA4CmRpZmYgLXVy
IDJjNjgzNWFhYThlYSBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxMzQvc2FhNzEzNC1p
bnB1dC5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vc2FhNzEzNC9zYWE3MTM0LWlu
cHV0LmMJMjAwOC0xMi0yMiAxNzo1NDowNS4wMDAwMDAwMDAgKzA3MDAKKysrIGIvbGludXgvZHJp
dmVycy9tZWRpYS92aWRlby9zYWE3MTM0L3NhYTcxMzQtaW5wdXQuYwkyMDA4LTEyLTIzIDA4OjI1
OjI4LjAwMDAwMDAwMCArMDcwMApAQCAtNDQ5LDYgKzQ0OSw3IEBACiAJY2FzZSBTQUE3MTM0X0JP
QVJEX0FWRVJNRURJQV9TVFVESU9fNTA3OgogCWNhc2UgU0FBNzEzNF9CT0FSRF9BVkVSTUVESUFf
R09fMDA3X0ZNOgogCWNhc2UgU0FBNzEzNF9CT0FSRF9BVkVSTUVESUFfTTEwMjoKKwljYXNlIFNB
QTcxMzRfQk9BUkRfQVZFUk1FRElBX0dPXzAwN19GTV9QTFVTOgogCQlpcl9jb2RlcyAgICAgPSBp
cl9jb2Rlc19hdmVybWVkaWE7CiAJCW1hc2tfa2V5Y29kZSA9IDB4MDAwN0M4OwogCQltYXNrX2tl
eWRvd24gPSAweDAwMDAxMDsKClNpZ25lZC1vZmYtYnk6IFBoYW0gVGhhbmggTmFtIDxwaGFtdGhh
bmhuYW0ucHRuQGdtYWlsLmNvbT4K
------=_Part_110088_6551156.1230301901952
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_110088_6551156.1230301901952--
