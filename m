Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <BLU116-W13E3E5DA492C7A08D36C3FC2470@phx.gbl>
Content-Type: multipart/mixed;
	boundary="_dc785209-79a6-48e9-935b-4aae60c38efa_"
From: dabby bentam <db260179@hotmail.com>
To: <video4linux-list@redhat.com>, <linux-dvb@linuxtv.org>
Date: Fri, 26 Sep 2008 22:13:55 +0000
MIME-Version: 1.0
Subject: [linux-dvb] [PATCH] saa7134: add support for Tv(working config),
 radio and analog audio in on the Hauppauge HVR-1110
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <video4linux-list@redhat.com>

--_dc785209-79a6-48e9-935b-4aae60c38efa_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


This patch fixes the Analog TV tuning issue and adds support of the Radio f=
eature.

It resolves the S-Video and Composite Audio In - FIXME (sound redirect stil=
l required via sox etc)

[   30.263288] saa7133[0]: subsystem: 0070:6701=2C board: Hauppauge WinTV-H=
VR1110 DVB-T/Hybrid [card=3D104=2Cautodetected]
[   30.263297] saa7133[0]: board init: gpio is 6400000
[   30.384637] input: HVR 1110 as /devices/virtual/input/input6
[   30.427939] ir-kbd-i2c: HVR 1110 detected at i2c-2/2-0071/ir0 [saa7133[0=
]]
[   30.474512] saa7133[0]: i2c eeprom 00: 70 00 01 67 54 20 1c 00 43 43 a9 =
1c 55 d2 b2 92
[   30.474521] saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff =
ff ff ff ff ff
[   30.474527] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 =
aa ff ff ff ff
[   30.474532] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   30.474537] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 60 ff =
ff ff ff ff ff
[   30.474542] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00
[   30.474547] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00
[   30.474552] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00
[   30.474557] saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 b0 16 35 =
f0 73 05 29 00
[   30.474562] saa7133[0]: i2c eeprom 90: 84 08 00 06 cb 05 01 00 94 48 89 =
72 07 70 73 09
[   30.474568] saa7133[0]: i2c eeprom a0: 23 5f 73 0a fc 72 72 0b 2f 72 0e =
01 72 0f 03 72
[   30.474573] saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 79 43 00 00 00 00 =
00 00 00 00 00
[   30.474578] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00
[   30.474583] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00
[   30.474588] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00
[   30.474593] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00
[   30.474602] tveeprom 2-0050: Hauppauge model 67019=2C rev B4B4=2C serial=
# 3479216
[   30.474605] tveeprom 2-0050: MAC address is 00-0D-FE-35-16-B0
[   30.474607] tveeprom 2-0050: tuner model is Philips 8275A (idx 114=2C ty=
pe 4)
[   30.474609] tveeprom 2-0050: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(=
L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
[   30.474612] tveeprom 2-0050: audio processor is SAA7131 (idx 41)
[   30.474614] tveeprom 2-0050: decoder processor is SAA7131 (idx 35)
[   30.474616] tveeprom 2-0050: has radio=2C has IR receiver=2C has IR tran=
smitter
[   30.474618] saa7133[0]: hauppauge eeprom: model=3D67019
[   31.047409] tuner 2-004b: chip found @ 0x96 (saa7133[0])
[   31.090707] tda8290 2-004b: setting tuner address to 61
[   31.183556] tuner 2-004b: type set to tda8290+75a
[   31.226853] tda8290 2-004b: setting tuner address to 61
[   31.320122] tuner 2-004b: type set to tda8290+75a
[   31.322302] saa7133[0]: registered device video0 [v4l2]
[   31.322321] saa7133[0]: registered device vbi0
[   31.322336] saa7133[0]: registered device radio0
[   31.323774] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
[   31.323777] ACPI: PCI Interrupt 0000:00:05.0[B] -> Link [AAZA] -> GSI 22=
 (level=2C low) -> IRQ 22
[   31.323995] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   31.556834] saa7134 ALSA driver for DMA sound loaded
[   31.556868] saa7133[0]/alsa: saa7133[0] at 0xfb010000 irq 16 registered =
as card -2
[   32.040025] DVB: registering new adapter (saa7133[0])
[   32.040031] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   32.099943] tda1004x: setting up plls for 48MHz sampling clock
[   32.356492] tda1004x: found firmware revision 20 -- ok


Signed-off-by: dabby bentam=20
_________________________________________________________________
Get all your favourite content with the slick new MSN Toolbar - FREE
http://clk.atdmt.com/UKM/go/111354027/direct/01/=

--_dc785209-79a6-48e9-935b-4aae60c38efa_
Content-Type: text/x-diff
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="hvr-1110.patch"

ZGlmZiAtciBhYTNlNWNjMWQ4MzMgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9zYWE3MTM0L3Nh
YTcxMzQtY2FyZHMuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxMzQvc2Fh
NzEzNC1jYXJkcy5jCVdlZCBTZXAgMjQgMTA6MDA6MzcgMjAwOCArMDIwMAorKysgYi9saW51eC9k
cml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxMzQvc2FhNzEzNC1jYXJkcy5jCUZyaSBTZXAgMjYgMjI6
MzE6MDggMjAwOCArMDEwMApAQCAtMzI5OSw2ICszMjk5LDcgQEAKIAl9LAogCVtTQUE3MTM0X0JP
QVJEX0hBVVBQQVVHRV9IVlIxMTEwXSA9IHsKIAkJLyogVGhvbWFzIEdlbnR5IDx0b21sb2hhdmVA
Z21haWwuY29tPiAqLworICAgICAgICAgICAgICAgIC8qIERhdmlkIEJlbnRoYW0gPGRiMjYwMTc5
QGhvdG1haWwuY29tPiAqLwogCQkubmFtZSAgICAgICAgICAgPSAiSGF1cHBhdWdlIFdpblRWLUhW
UjExMTAgRFZCLVQvSHlicmlkIiwKIAkJLmF1ZGlvX2Nsb2NrICAgID0gMHgwMDE4N2RlNywKIAkJ
LnR1bmVyX3R5cGUgICAgID0gVFVORVJfUEhJTElQU19UREE4MjkwLApAQCAtMzMwNywyMyArMzMw
OCwyNiBAQAogCQkucmFkaW9fYWRkciAgICAgPSBBRERSX1VOU0VULAogCQkudHVuZXJfY29uZmln
ICAgPSAxLAogCQkubXBlZyAgICAgICAgICAgPSBTQUE3MTM0X01QRUdfRFZCLAotCQkuaW5wdXRz
ICAgICAgICAgPSB7ewotCQkJLm5hbWUgPSBuYW1lX3R2LAotCQkJLnZtdXggPSAxLAotCQkJLmFt
dXggPSBUViwKLQkJCS50diAgID0gMSwKLQkJfSx7Ci0JCQkubmFtZSAgID0gbmFtZV9jb21wMSwK
LQkJCS52bXV4ICAgPSAzLAotCQkJLmFtdXggICA9IExJTkUyLCAvKiBGSVhNRTogYXVkaW8gZG9l
c24ndCB3b3JrIG9uIHN2aWRlby9jb21wb3NpdGUgKi8KLQkJfSx7Ci0JCQkubmFtZSAgID0gbmFt
ZV9zdmlkZW8sCi0JCQkudm11eCAgID0gOCwKLQkJCS5hbXV4ICAgPSBMSU5FMiwgLyogRklYTUU6
IGF1ZGlvIGRvZXNuJ3Qgd29yayBvbiBzdmlkZW8vY29tcG9zaXRlICovCi0JCX19LAotCQkucmFk
aW8gPSB7Ci0JCQkubmFtZSA9IG5hbWVfcmFkaW8sCi0JCQkuYW11eCAgID0gVFYsCisgICAgICAg
ICAgICAgICAgLmdwaW9tYXNrICAgICAgID0gMHgwMjAwMTAwLAorCQkuaW5wdXRzICAgICAgICAg
PSB7eworCQkJLm5hbWUgPSBuYW1lX3R2LAorCQkJLnZtdXggPSAxLAorCQkJLmFtdXggPSBUViwK
KwkJCS50diAgID0gMSwKKyAgICAgICAgICAgICAgICAgICAgICAgIC5ncGlvID0gMHgwMDAwMTAw
LAorCQl9LCB7CisJCQkubmFtZSAgID0gbmFtZV9jb21wMSwKKwkJCS52bXV4ICAgPSAzLAorCQkJ
LmFtdXggICA9IExJTkUxLCAKKwkJfSwgeworCQkJLm5hbWUgICA9IG5hbWVfc3ZpZGVvLAorCQkJ
LnZtdXggICA9IDgsCisJCQkuYW11eCAgID0gTElORTEsIAorCQl9IH0sCisJCS5yYWRpbyA9IHsK
KwkJCS5uYW1lID0gbmFtZV9yYWRpbywKKwkJCS5hbXV4ICAgPSBUViwKKyAgICAgICAgICAgICAg
ICAgICAgICAgIC5ncGlvID0gMHgwMjAwMTAwLAogCQl9LAogCX0sCiAJW1NBQTcxMzRfQk9BUkRf
Q0lORVJHWV9IVF9QQ01DSUFdID0gewo=

--_dc785209-79a6-48e9-935b-4aae60c38efa_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--_dc785209-79a6-48e9-935b-4aae60c38efa_--
