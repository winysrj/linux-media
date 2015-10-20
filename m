Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:36122 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbbJTRIi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2015 13:08:38 -0400
Received: by lbcao8 with SMTP id ao8so20194696lbc.3
        for <linux-media@vger.kernel.org>; Tue, 20 Oct 2015 10:08:36 -0700 (PDT)
Received: from [192.168.100.28] (a88-115-254-86.elisa-laajakaista.fi. [88.115.254.86])
        by smtp.gmail.com with ESMTPSA id r194sm685513lfg.5.2015.10.20.10.08.35
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Oct 2015 10:08:35 -0700 (PDT)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Alberto Mardegan <mardy@users.sourceforge.net>
Subject: Trying to get Terratec Cinergy T XS to work
Message-ID: <56267512.6080207@users.sourceforge.net>
Date: Tue, 20 Oct 2015 20:08:34 +0300
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020902050502020501050003"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020902050502020501050003
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi all!
  I own a USB DVB-T receiver, Terratec Cinergy T XS, (0ccd:0043) which
as far as I can tell from google searches used to work with the old
"em28xx-new" driver.

I've downloaded the old driver from
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/460636/comments/2

and tried to modify the current media_tree drivers accordingly (please
see the attached patch), but I get an error when initializing the frontend:

=====================
Oct 20 19:33:20 mapperone kernel: [25479.846347] usb 2-1.1: new
high-speed USB device number 6 using ehci-pci
Oct 20 19:33:20 mapperone kernel: [25479.951208] usb 2-1.1: New USB
device found, idVendor=0ccd, idProduct=0043
Oct 20 19:33:20 mapperone kernel: [25479.951215] usb 2-1.1: New USB
device strings: Mfr=2, Product=1, SerialNumber=0
Oct 20 19:33:20 mapperone kernel: [25479.951220] usb 2-1.1: Product:
Cinergy T USB XS
Oct 20 19:33:20 mapperone kernel: [25479.951223] usb 2-1.1:
Manufacturer: TerraTec Electronic GmbH
Oct 20 19:33:20 mapperone mtp-probe: checking bus 2, device 6:
"/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1"
Oct 20 19:33:20 mapperone mtp-probe: bus: 2, device: 6 was not an MTP device
Oct 20 19:33:20 mapperone kernel: [25479.982735] em28xx: New device
TerraTec Electronic GmbH Cinergy T USB XS @ 480 Mbps (0ccd:0043,
interface 0, class 0)
Oct 20 19:33:20 mapperone kernel: [25479.982739] em28xx: Video interface
0 found: isoc
Oct 20 19:33:20 mapperone kernel: [25479.982740] em28xx: DVB interface 0
found: isoc
Oct 20 19:33:20 mapperone kernel: [25479.982859] em28xx: chip ID is em2870
Oct 20 19:33:20 mapperone kernel: [25480.110080] em2870 #0: EEPROM ID =
1a eb 67 95, EEPROM hash = 0x084c44df
Oct 20 19:33:20 mapperone kernel: [25480.110085] em2870 #0: EEPROM info:
Oct 20 19:33:20 mapperone kernel: [25480.110087] em2870 #0: 	No audio on
board.
Oct 20 19:33:20 mapperone kernel: [25480.110089] em2870 #0: 	500mA max power
Oct 20 19:33:20 mapperone kernel: [25480.110092] em2870 #0: 	Table at
offset 0x06, strings=0x246a, 0x348e, 0x0000
Oct 20 19:33:20 mapperone kernel: [25480.110096] em2870 #0: Identified
as Terratec Cinergy T XS (card=43)
Oct 20 19:33:20 mapperone kernel: [25480.110099] em2870 #0: analog set
to isoc mode.
Oct 20 19:33:20 mapperone kernel: [25480.110101] em2870 #0: dvb set to
isoc mode.
Oct 20 19:33:20 mapperone kernel: [25480.110149] usbcore: registered new
interface driver em28xx
Oct 20 19:33:20 mapperone kernel: [25480.113975] em2870 #0: Registering
V4L2 extension
Oct 20 19:33:20 mapperone kernel: [25480.118352] Chip ID is not zero. It
is not a TEA5767
Oct 20 19:33:20 mapperone kernel: [25480.118361] tuner 7-0060: Tuner -1
found with type(s) Radio TV.
Oct 20 19:33:20 mapperone kernel: [25480.118390] xc2028 7-0060: creating
new instance
Oct 20 19:33:20 mapperone kernel: [25480.118397] xc2028 7-0060: type set
to XCeive xc2028/xc3028 tuner
Oct 20 19:33:20 mapperone kernel: [25480.118453] xc2028 7-0060: Loading
80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Oct 20 19:33:21 mapperone kernel: [25480.166568] xc2028 7-0060: Loading
firmware for type=BASE (1), id 0000000000000000.
Oct 20 19:33:22 mapperone kernel: [25481.248675] xc2028 7-0060: Loading
firmware for type=(0), id 000000000000b700.
Oct 20 19:33:22 mapperone kernel: [25481.266071] SCODE (20000000), id
000000000000b700:
Oct 20 19:33:22 mapperone kernel: [25481.266078] xc2028 7-0060: Loading
SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Oct 20 19:33:22 mapperone kernel: [25481.270699] xc2028 7-0060:
Incorrect readback of firmware version.
Oct 20 19:33:22 mapperone kernel: [25481.371524] xc2028 7-0060: Loading
firmware for type=BASE (1), id 0000000000000000.
Oct 20 19:33:23 mapperone kernel: [25482.449292] xc2028 7-0060: Loading
firmware for type=(0), id 000000000000b700.
Oct 20 19:33:23 mapperone kernel: [25482.466803] SCODE (20000000), id
000000000000b700:
Oct 20 19:33:23 mapperone kernel: [25482.466811] xc2028 7-0060: Loading
SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Oct 20 19:33:23 mapperone kernel: [25482.471431] xc2028 7-0060:
Incorrect readback of firmware version.
Oct 20 19:33:23 mapperone kernel: [25482.572622] xc2028 7-0060: Loading
firmware for type=BASE (1), id 0000000000000000.
Oct 20 19:33:24 mapperone kernel: [25483.650635] xc2028 7-0060: Loading
firmware for type=(0), id 000000000000b700.
Oct 20 19:33:24 mapperone kernel: [25483.667777] SCODE (20000000), id
000000000000b700:
Oct 20 19:33:24 mapperone kernel: [25483.667784] xc2028 7-0060: Loading
SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Oct 20 19:33:24 mapperone kernel: [25483.672770] xc2028 7-0060:
Incorrect readback of firmware version.
Oct 20 19:33:24 mapperone kernel: [25483.773478] xc2028 7-0060: Loading
firmware for type=BASE (1), id 0000000000000000.
Oct 20 19:33:25 mapperone kernel: [25484.851617] xc2028 7-0060: Loading
firmware for type=(0), id 000000000000b700.
Oct 20 19:33:25 mapperone kernel: [25484.869042] SCODE (20000000), id
000000000000b700:
Oct 20 19:33:25 mapperone kernel: [25484.869050] xc2028 7-0060: Loading
SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Oct 20 19:33:25 mapperone kernel: [25484.873894] xc2028 7-0060:
Incorrect readback of firmware version.
Oct 20 19:33:25 mapperone kernel: [25484.974459] xc2028 7-0060: Loading
firmware for type=BASE (1), id 0000000000000000.
Oct 20 19:33:26 mapperone kernel: [25486.048343] xc2028 7-0060: Loading
firmware for type=(0), id 000000000000b700.
Oct 20 19:33:26 mapperone kernel: [25486.065594] SCODE (20000000), id
000000000000b700:
Oct 20 19:33:26 mapperone kernel: [25486.065603] xc2028 7-0060: Loading
SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Oct 20 19:33:26 mapperone kernel: [25486.070111] xc2028 7-0060:
Incorrect readback of firmware version.
Oct 20 19:33:27 mapperone kernel: [25486.171441] xc2028 7-0060: Loading
firmware for type=BASE (1), id 0000000000000000.
Oct 20 19:33:28 mapperone kernel: [25487.249074] xc2028 7-0060: Loading
firmware for type=(0), id 000000000000b700.
Oct 20 19:33:28 mapperone kernel: [25487.266062] SCODE (20000000), id
000000000000b700:
Oct 20 19:33:28 mapperone kernel: [25487.266071] xc2028 7-0060: Loading
SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Oct 20 19:33:28 mapperone kernel: [25487.270473] xc2028 7-0060:
Incorrect readback of firmware version.
Oct 20 19:33:28 mapperone kernel: [25487.372459] xc2028 7-0060: Loading
firmware for type=BASE (1), id 0000000000000000.
Oct 20 19:33:29 mapperone kernel: [25488.450426] xc2028 7-0060: Loading
firmware for type=(0), id 000000000000b700.
Oct 20 19:33:29 mapperone kernel: [25488.467550] SCODE (20000000), id
000000000000b700:
Oct 20 19:33:29 mapperone kernel: [25488.467559] xc2028 7-0060: Loading
SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Oct 20 19:33:29 mapperone kernel: [25488.472077] xc2028 7-0060:
Incorrect readback of firmware version.
Oct 20 19:33:29 mapperone kernel: [25488.573395] xc2028 7-0060: Loading
firmware for type=BASE (1), id 0000000000000000.
Oct 20 19:33:30 mapperone kernel: [25489.651157] xc2028 7-0060: Loading
firmware for type=(0), id 000000000000b700.
Oct 20 19:33:30 mapperone kernel: [25489.668147] SCODE (20000000), id
000000000000b700:
Oct 20 19:33:30 mapperone kernel: [25489.668156] xc2028 7-0060: Loading
SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Oct 20 19:33:30 mapperone kernel: [25489.672651] xc2028 7-0060:
Incorrect readback of firmware version.
Oct 20 19:33:30 mapperone kernel: [25489.774369] xc2028 7-0060: Loading
firmware for type=BASE (1), id 0000000000000000.
Oct 20 19:33:31 mapperone kernel: [25490.848007] xc2028 7-0060: Loading
firmware for type=(0), id 000000000000b700.
Oct 20 19:33:31 mapperone kernel: [25490.864749] SCODE (20000000), id
000000000000b700:
Oct 20 19:33:31 mapperone kernel: [25490.864758] xc2028 7-0060: Loading
SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Oct 20 19:33:31 mapperone kernel: [25490.869146] xc2028 7-0060:
Incorrect readback of firmware version.
Oct 20 19:33:31 mapperone kernel: [25490.993349] em2870 #0: V4L2 video
device registered as video0
Oct 20 19:33:31 mapperone kernel: [25490.993355] em2870 #0: V4L2
extension successfully initialized
Oct 20 19:33:31 mapperone kernel: [25490.993359] em28xx: Registered
(Em28xx v4l2 Extension) extension
Oct 20 19:33:31 mapperone kernel: [25490.998127] em2870 #0: Binding DVB
extension
Oct 20 19:33:31 mapperone kernel: [25491.027059] zl10353_read_register:
readreg error (reg=127, ret==-6)
Oct 20 19:33:31 mapperone kernel: [25491.027380] mt352_read_register:
readreg error (reg=127, ret==-6)
Oct 20 19:33:31 mapperone kernel: [25491.027395] em2870 #0: /2: dvb
frontend not attached. Can't attach xc3028
Oct 20 19:33:31 mapperone kernel: [25491.027410] em28xx: Registered
(Em28xx dvb Extension) extension
=====================

As you can see, in my patch I added a couple of printk to
zl10353_init(), but I don't see them in the logs (while I can definitely
see that my em28xx driver is otherwise being used, as with the official
one I don't even see the "zl10353_read_register" line). Can someone
please guide me to debug the issue?

I found an old post to this ML where a user reports a very similar log
file, but without replies:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg13180.html

Any suggestions on what I could try?

Ciao,
  Alberto

-- 
http://blog.mardy.it <- geek in un lingua international!

--------------020902050502020501050003
Content-Type: text/x-patch;
 name="em28xx.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="em28xx.diff"

diff --git a/drivers/media/dvb-frontends/zl10353.c b/drivers/media/dvb-fr=
ontends/zl10353.c
index ef9764a..b7558b2 100644
--- a/drivers/media/dvb-frontends/zl10353.c
+++ b/drivers/media/dvb-frontends/zl10353.c
@@ -572,12 +572,14 @@ static int zl10353_init(struct dvb_frontend *fe)
 	/* Do a "hard" reset if not already done */
 	if (zl10353_read_register(state, 0x50) !=3D zl10353_reset_attach[1] ||
 	    zl10353_read_register(state, 0x51) !=3D zl10353_reset_attach[2]) {
+		printk("zl10353: performing reset\n");
 		zl10353_write(fe, zl10353_reset_attach,
 				   sizeof(zl10353_reset_attach));
 		if (debug_regs)
 			zl10353_dump_regs(fe);
 	}
=20
+	printk("zl10353: init complete\n");
 	return 0;
 }
=20
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/=
em28xx/em28xx-cards.c
index 3940046..1a77050 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -1045,9 +1045,11 @@ struct em28xx_board em28xx_boards[] =3D {
=20
 	[EM2870_BOARD_TERRATEC_XS] =3D {
 		.name         =3D "Terratec Cinergy T XS",
-		.valid        =3D EM28XX_BOARD_NOT_VALIDATED,
+		/*.valid        =3D EM28XX_BOARD_NOT_VALIDATED,*/
 		.tuner_type   =3D TUNER_XC2028,
 		.tuner_gpio   =3D default_tuner_gpio,
+		.has_dvb      =3D 1,
+		.dvb_gpio     =3D default_digital,
 	},
 	[EM2870_BOARD_TERRATEC_XS_MT2060] =3D {
 		.name         =3D "Terratec Cinergy T XS (MT2060)",
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em=
28xx/em28xx-dvb.c
index 357be76..b94b903 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1121,6 +1121,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			goto out_free;
 		}
 		break;
+	case EM2870_BOARD_TERRATEC_XS:
 	case EM2880_BOARD_TERRATEC_HYBRID_XS:
 	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
 	case EM2881_BOARD_PINNACLE_HYBRID_PRO:

--------------020902050502020501050003--
