Return-path: <mchehab@pedra>
Received: from nm10-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.242]:23152
	"HELO nm10-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752707Ab1FVKgf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 06:36:35 -0400
Received: by iyb12 with SMTP id 12so552158iyb.19
        for <linux-media@vger.kernel.org>; Wed, 22 Jun 2011 03:36:31 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 22 Jun 2011 12:36:31 +0200
Message-ID: <BANLkTimY_RKO4TxSu5GQo84_7VCMjLEFDg@mail.gmail.com>
Subject: Sveon stv22 patches
From: David <reality_es@yahoo.es>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=90e6ba6e9026b7f55204a64a8a63
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--90e6ba6e9026b7f55204a64a8a63
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Again:

The patches for sveon stv22 are done, the first test seems to be ok ,
tdt tv working , remote working, tests with ubuntu and custom kernel
3.0.0.rc4 , software tvheadend and xbmc tvlive frontend.

The console output is:

usb 5-1.4: new high speed USB device number 13 using ehci_hcd
dvb-usb: found a 'Sveon STV22 Dual USB DVB-T Tuner HDTV ' in cold
state, will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
dvb-usb: found a 'Sveon STV22 Dual USB DVB-T Tuner HDTV ' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demu=
xer.
DVB: registering new adapter (Sveon STV22 Dual USB DVB-T Tuner HDTV )
af9013: firmware version:5.1.0.0
DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
MXL5005S: Attached at address 0xc6
dvb-usb: will pass the complete MPEG2 transport stream to the software demu=
xer.
DVB: registering new adapter (Sveon STV22 Dual USB DVB-T Tuner HDTV )
af9013: found a 'Afatech AF9013 DVB-T' in warm state.
af9013: firmware version:5.1.0.0
DVB: registering adapter 1 frontend 0 (Afatech AF9013 DVB-T)...
MXL5005S: Attached at address 0xc6
Registered IR keymap rc-msi-digivox-iii
input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.7/usb5/5-1/5-1.4/rc/rc2/input11
rc2: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.7/usb5/5-1/5-1.4/rc/rc2
dvb-usb: schedule remote query interval to 500 msecs.
dvb-usb: Sveon STV22 Dual USB DVB-T Tuner HDTV  successfully
initialized and connected.
usbcore: registered new interface driver dvb_usb_af9015


Thanks for your time

Emilio David Diaus L=F3pez

--90e6ba6e9026b7f55204a64a8a63
Content-Type: text/x-patch; charset=US-ASCII; name="af9015.c.diff"
Content-Disposition: attachment; filename="af9015.c.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gp856ts90

LS0tIC4vYWY5MDE1LmMJMjAxMS0wNi0yMiAxMjowNToyOC4wMDAwMDAwMDAgKzAyMDAKKysrIC4v
ZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9hZjkwMTUuYwkyMDExLTA2LTIxIDEyOjM5OjQ0Ljk0
NDg3NDAyMSArMDIwMApAQCAtNzQ5LDggKzc0OSw2IEBACiAJCVJDX01BUF9BWlVSRVdBVkVfQURf
VFU3MDAgfSwKIAl7IChVU0JfVklEX01TSV8yIDw8IDE2KSArIFVTQl9QSURfTVNJX0RJR0lfVk9Y
X01JTklfSUlJLAogCQlSQ19NQVBfTVNJX0RJR0lWT1hfSUlJIH0sCi0JeyAoVVNCX1ZJRF9LV09S
TERfMiA8PCAxNikgKyBVU0JfUElEX1NWRU9OX1NUVjIyLAotCQlSQ19NQVBfTVNJX0RJR0lWT1hf
SUlJIH0sCiAJeyAoVVNCX1ZJRF9MRUFEVEVLIDw8IDE2KSArIFVTQl9QSURfV0lORkFTVF9EVFZf
RE9OR0xFX0dPTEQsCiAJCVJDX01BUF9MRUFEVEVLX1kwNEcwMDUxIH0sCiAJeyAoVVNCX1ZJRF9B
VkVSTUVESUEgPDwgMTYpICsgVVNCX1BJRF9BVkVSTUVESUFfVk9MQVJfWCwKQEAgLTEzMTEsNyAr
MTMwOSw2IEBACiAJCVVTQl9QSURfVEVSUkFURUNfQ0lORVJHWV9UX1NUSUNLX0RVQUxfUkMpfSwK
IC8qIDM1ICove1VTQl9ERVZJQ0UoVVNCX1ZJRF9BVkVSTUVESUEsIFVTQl9QSURfQVZFUk1FRElB
X0E4NTBUKX0sCiAJe1VTQl9ERVZJQ0UoVVNCX1ZJRF9HVEVLLCAgICAgIFVTQl9QSURfVElOWVRX
SU5fMyl9LAotCXtVU0JfREVWSUNFKFVTQl9WSURfS1dPUkxEXzIsICBVU0JfUElEX1NWRU9OX1NU
VjIyKX0sCiAJezB9LAogfTsKIE1PRFVMRV9ERVZJQ0VfVEFCTEUodXNiLCBhZjkwMTVfdXNiX3Rh
YmxlKTsKQEAgLTE2NTIsMTEgKzE2NDksNiBAQAogCQkJCS53YXJtX2lkcyA9IHtOVUxMfSwKIAkJ
CX0sCiAJCQl7Ci0JCQkJLm5hbWUgPSAiU3Zlb24gU1RWMjIgRHVhbCBVU0IgRFZCLVQgVHVuZXIg
SERUViAiLAotCQkJCS5jb2xkX2lkcyA9IHsmYWY5MDE1X3VzYl90YWJsZVszN10sIE5VTEx9LAot
CQkJCS53YXJtX2lkcyA9IHtOVUxMfSwKLQkJCX0sCi0JCQl7CiAJCQkJLm5hbWUgPSAiTGVhZHRl
ayBXaW5GYXN0IERUVjIwMDBEUyIsCiAJCQkJLmNvbGRfaWRzID0geyZhZjkwMTVfdXNiX3RhYmxl
WzI5XSwgTlVMTH0sCiAJCQkJLndhcm1faWRzID0ge05VTEx9LAo=
--90e6ba6e9026b7f55204a64a8a63
Content-Type: text/x-patch; charset=US-ASCII; name="dvb-usb-ids.h.diff"
Content-Disposition: attachment; filename="dvb-usb-ids.h.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gp85b2101

LS0tIC4vZHZiLXVzYi1pZHMuaAkyMDExLTA2LTE4IDExOjQ4OjIyLjAwMDAwMDAwMCArMDIwMAor
KysgLi9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2R2Yi11c2ItaWRzLmgJMjAxMS0wNi0yMSAx
MjozOTo0NS4wMTc4NzMxMDggKzAyMDAKQEAgLTEyOCw3ICsxMjgsNiBAQAogI2RlZmluZSBVU0Jf
UElEX0lOVEVMX0NFOTUwMAkJCQkweDk1MDAKICNkZWZpbmUgVVNCX1BJRF9LV09STERfMzk5VQkJ
CQkweGUzOTkKICNkZWZpbmUgVVNCX1BJRF9LV09STERfMzk5VV8yCQkJCTB4ZTQwMAotI2RlZmlu
ZSBVU0JfUElEX1NWRU9OX1NUVjIyCQkJCTB4ZTQwMQogI2RlZmluZSBVU0JfUElEX0tXT1JMRF8z
OTVVCQkJCTB4ZTM5NgogI2RlZmluZSBVU0JfUElEX0tXT1JMRF8zOTVVXzIJCQkJMHhlMzliCiAj
ZGVmaW5lIFVTQl9QSURfS1dPUkxEXzM5NVVfMwkJCQkweGUzOTUK
--90e6ba6e9026b7f55204a64a8a63
Content-Type: text/x-patch; charset=US-ASCII; name="rc-map.h.diff"
Content-Disposition: attachment; filename="rc-map.h.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gp85b6v32

LS0tIC4vcmMtbWFwLmgJMjAxMS0wNi0yMSAxMToxNjo1NS4wMDAwMDAwMDAgKzAyMDAKKysrIC4v
aW5jbHVkZS9tZWRpYS9yYy1tYXAuaAkyMDExLTA2LTIxIDEyOjQxOjM0LjExNDUwOTIxNCArMDIw
MApAQCAtMTMwLDcgKzEzMCw2IEBACiAjZGVmaW5lIFJDX01BUF9SQzZfTUNFICAgICAgICAgICAg
ICAgICAgICJyYy1yYzYtbWNlIgogI2RlZmluZSBSQ19NQVBfUkVBTF9BVURJT18yMjBfMzJfS0VZ
UyAgICAicmMtcmVhbC1hdWRpby0yMjAtMzIta2V5cyIKICNkZWZpbmUgUkNfTUFQX1NUUkVBTVpB
UCAgICAgICAgICAgICAgICAgInJjLXN0cmVhbXphcCIKLSNkZWZpbmUgUkNfTUFQX1NWRU9OX1NU
VjIyCQkgInJjLW1zaS1kaWdpdm94LWlpaSIKICNkZWZpbmUgUkNfTUFQX1RCU19ORUMgICAgICAg
ICAgICAgICAgICAgInJjLXRicy1uZWMiCiAjZGVmaW5lIFJDX01BUF9URUNITklTQVRfVVNCMiAg
ICAgICAgICAgICJyYy10ZWNobmlzYXQtdXNiMiIKICNkZWZpbmUgUkNfTUFQX1RFUlJBVEVDX0NJ
TkVSR1lfWFMgICAgICAgInJjLXRlcnJhdGVjLWNpbmVyZ3kteHMiCg==
--90e6ba6e9026b7f55204a64a8a63--
