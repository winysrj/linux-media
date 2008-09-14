Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8EKr09c008437
	for <video4linux-list@redhat.com>; Sun, 14 Sep 2008 16:53:01 -0400
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8EKqkWp031775
	for <video4linux-list@redhat.com>; Sun, 14 Sep 2008 16:52:47 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>
Content-Type: multipart/mixed; boundary="=-6c4kXGrectKa2W3roF+W"
Date: Sun, 14 Sep 2008 22:49:14 +0200
Message-Id: <1221425354.4258.25.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org
Subject: [PATCH] - saa7134: add support for the triple Asus Tiger 3in1
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


--=-6c4kXGrectKa2W3roF+W
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

after looking it up, all rants about the 80 columns restriction seem to
be in vain. After changing the card's name it are now "only" seven new
lines in the tiny DVB-T/DVB-S switch function.

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:02:08.0, rev: 209, irq: 18, latency: 32, mmio: 0xfdef7000
saa7133[0]: subsystem: 1043:4878, board: Asus Tiger 3in1 [card=147,autodetected]
saa7133[0]: board init: gpio is 200000
tuner' 2-004b: chip found @ 0x96 (saa7133[0])
saa7133[0]: i2c eeprom 00: 43 10 78 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d7 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 28 00 c2 96 16 03 02 c0 1c ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c scan: found device @ 0x10  [???]
saa7133[0]: i2c scan: found device @ 0x16  [???]
saa7133[0]: i2c scan: found device @ 0x1c  [???]
saa7133[0]: i2c scan: found device @ 0x96  [???]
saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
tda829x 2-004b: setting tuner address to 61
tda829x 2-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0

DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Philips TDA10086 DVB-S)...

The board init gpio is 0x0, 0x200000 is from previously unloading with
antenna_switch = 1.

It needs firmware for the tda10046 and analog sound needs saa7134-alsa.

I have support for one more board and need to fix the first revision of
the Asus Tiger DVB-T hybrid. DVB-T currently hangs on the male radio
antenna input, also some small other stuff.

Please report any issues with this patch, the next are depending on this
one.

Cheers,
Hermann

saa7134: add support for the triple Asus Tiger 3in1

Signed-off-by: Hermann Pitton <hermann-pitton@arcor.de>


diff -r ff052010c4cb linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Sep 07 14:46:44 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Sep 14 20:55:26 2008 +0200
@@ -4448,6 +4448,36 @@
 		/* no DVB support for now */
 		/* .mpeg           = SAA7134_MPEG_DVB, */
 	},
+	[SAA7134_BOARD_ASUSTeK_TIGER_3IN1] = {
+		.name           = "Asus Tiger 3in1",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tuner_config   = 2,
+		.gpiomask       = 1 << 21,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp,
+			.vmux = 0,
+			.amux = LINE2,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x0200000,
+		},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -5470,6 +5500,12 @@
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xf636,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_M103,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1043,
+		.subdevice    = 0x4878, /* REV:1.02G */
+		.driver_data  = SAA7134_BOARD_ASUSTeK_TIGER_3IN1,
 	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
@@ -6105,6 +6141,14 @@
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
 		break;
 	}
+	case SAA7134_BOARD_ASUSTeK_TIGER_3IN1:
+	{
+		u8 data[] = { 0x3c, 0x33, 0x60};
+		struct i2c_msg msg = {.addr = 0x0b, .flags = 0, .buf = data,
+							.len = sizeof(data)};
+		i2c_transfer(&dev->i2c_adap, &msg, 1);
+		break;
+	}
 	case SAA7134_BOARD_FLYDVB_TRIO:
 	{
 		u8 data[] = { 0x3c, 0x33, 0x62};
diff -r ff052010c4cb linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sun Sep 07 14:46:44 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sun Sep 14 20:55:26 2008 +0200
@@ -794,6 +794,20 @@
 	.gpio_config   = TDA10046_GP01_I,
 	.if_freq       = TDA10046_FREQ_045,
 	.i2c_gate      = 0x42,
+	.tuner_address = 0x61,
+	.antenna_switch = 1,
+	.request_firmware = philips_tda1004x_request_firmware
+};
+
+static struct tda1004x_config asus_tiger_3in1_config = {
+	.demod_address = 0x0b,
+	.invert        = 1,
+	.invert_oclk   = 0,
+	.xtal_freq     = TDA10046_XTAL_16M,
+	.agc_config    = TDA10046_AGC_TDA827X,
+	.gpio_config   = TDA10046_GP11_I,
+	.if_freq       = TDA10046_FREQ_045,
+	.i2c_gate      = 0x4b,
 	.tuner_address = 0x61,
 	.antenna_switch = 1,
 	.request_firmware = philips_tda1004x_request_firmware
@@ -1304,6 +1318,31 @@
 						&dev->i2c_adap);
 		attach_xc3028 = 1;
 		break;
+	case SAA7134_BOARD_ASUSTeK_TIGER_3IN1:
+		if (!use_frontend) {     /* terrestrial */
+			if (configure_tda827x_fe(dev, &asus_tiger_3in1_config,
+							&tda827x_cfg_2) < 0)
+				goto dettach_frontend;
+		} else {  		/* satellite */
+			dev->dvb.frontend = dvb_attach(tda10086_attach,
+						&flydvbs, &dev->i2c_adap);
+			if (dev->dvb.frontend) {
+				if (dvb_attach(tda826x_attach,
+						dev->dvb.frontend, 0x60,
+						&dev->i2c_adap, 0) == NULL) {
+					wprintk("%s: Asus Tiger 3in1, no "
+						"tda826x found!\n", __func__);
+					goto dettach_frontend;
+				}
+				if (dvb_attach(lnbp21_attach, dev->dvb.frontend,
+						&dev->i2c_adap, 0, 0) == NULL) {
+					wprintk("%s: Asus Tiger 3in1, no lnbp21"
+						" found!\n", __func__);
+					goto dettach_frontend;
+				}
+			}
+		}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r ff052010c4cb linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Sep 07 14:46:44 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Sun Sep 14 20:55:26 2008 +0200
@@ -270,6 +270,7 @@
 #define SAA7134_BOARD_BEHOLD_M6_EXTRA    144
 #define SAA7134_BOARD_AVERMEDIA_M103    145
 #define SAA7134_BOARD_ASUSTeK_P7131_ANALOG 146
+#define SAA7134_BOARD_ASUSTeK_TIGER_3IN1   147
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8


--=-6c4kXGrectKa2W3roF+W
Content-Disposition: inline; filename=saa7134-asus_tiger_3in1-support.patch
Content-Type: text/x-patch; name=saa7134-asus_tiger_3in1-support.patch;
	charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r ff052010c4cb linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Sep 07 14:46:44 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Sep 14 20:55:26 2008 +0200
@@ -4448,6 +4448,36 @@
 		/* no DVB support for now */
 		/* .mpeg           = SAA7134_MPEG_DVB, */
 	},
+	[SAA7134_BOARD_ASUSTeK_TIGER_3IN1] = {
+		.name           = "Asus Tiger 3in1",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tuner_config   = 2,
+		.gpiomask       = 1 << 21,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp,
+			.vmux = 0,
+			.amux = LINE2,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x0200000,
+		},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -5470,6 +5500,12 @@
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xf636,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_M103,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1043,
+		.subdevice    = 0x4878, /* REV:1.02G */
+		.driver_data  = SAA7134_BOARD_ASUSTeK_TIGER_3IN1,
 	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
@@ -6105,6 +6141,14 @@
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
 		break;
 	}
+	case SAA7134_BOARD_ASUSTeK_TIGER_3IN1:
+	{
+		u8 data[] = { 0x3c, 0x33, 0x60};
+		struct i2c_msg msg = {.addr = 0x0b, .flags = 0, .buf = data,
+							.len = sizeof(data)};
+		i2c_transfer(&dev->i2c_adap, &msg, 1);
+		break;
+	}
 	case SAA7134_BOARD_FLYDVB_TRIO:
 	{
 		u8 data[] = { 0x3c, 0x33, 0x62};
diff -r ff052010c4cb linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sun Sep 07 14:46:44 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sun Sep 14 20:55:26 2008 +0200
@@ -794,6 +794,20 @@
 	.gpio_config   = TDA10046_GP01_I,
 	.if_freq       = TDA10046_FREQ_045,
 	.i2c_gate      = 0x42,
+	.tuner_address = 0x61,
+	.antenna_switch = 1,
+	.request_firmware = philips_tda1004x_request_firmware
+};
+
+static struct tda1004x_config asus_tiger_3in1_config = {
+	.demod_address = 0x0b,
+	.invert        = 1,
+	.invert_oclk   = 0,
+	.xtal_freq     = TDA10046_XTAL_16M,
+	.agc_config    = TDA10046_AGC_TDA827X,
+	.gpio_config   = TDA10046_GP11_I,
+	.if_freq       = TDA10046_FREQ_045,
+	.i2c_gate      = 0x4b,
 	.tuner_address = 0x61,
 	.antenna_switch = 1,
 	.request_firmware = philips_tda1004x_request_firmware
@@ -1304,6 +1318,31 @@
 						&dev->i2c_adap);
 		attach_xc3028 = 1;
 		break;
+	case SAA7134_BOARD_ASUSTeK_TIGER_3IN1:
+		if (!use_frontend) {     /* terrestrial */
+			if (configure_tda827x_fe(dev, &asus_tiger_3in1_config,
+							&tda827x_cfg_2) < 0)
+				goto dettach_frontend;
+		} else {  		/* satellite */
+			dev->dvb.frontend = dvb_attach(tda10086_attach,
+						&flydvbs, &dev->i2c_adap);
+			if (dev->dvb.frontend) {
+				if (dvb_attach(tda826x_attach,
+						dev->dvb.frontend, 0x60,
+						&dev->i2c_adap, 0) == NULL) {
+					wprintk("%s: Asus Tiger 3in1, no "
+						"tda826x found!\n", __func__);
+					goto dettach_frontend;
+				}
+				if (dvb_attach(lnbp21_attach, dev->dvb.frontend,
+						&dev->i2c_adap, 0, 0) == NULL) {
+					wprintk("%s: Asus Tiger 3in1, no lnbp21"
+						" found!\n", __func__);
+					goto dettach_frontend;
+				}
+			}
+		}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r ff052010c4cb linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Sep 07 14:46:44 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Sun Sep 14 20:55:26 2008 +0200
@@ -270,6 +270,7 @@
 #define SAA7134_BOARD_BEHOLD_M6_EXTRA    144
 #define SAA7134_BOARD_AVERMEDIA_M103    145
 #define SAA7134_BOARD_ASUSTeK_P7131_ANALOG 146
+#define SAA7134_BOARD_ASUSTeK_TIGER_3IN1   147
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8

--=-6c4kXGrectKa2W3roF+W
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-6c4kXGrectKa2W3roF+W--
