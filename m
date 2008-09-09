Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m89Mgr6M023297
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 18:42:53 -0400
Received: from mail-in-07.arcor-online.net (mail-in-07.arcor-online.net
	[151.189.21.47])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m89Mgdil026272
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 18:42:39 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="=-oJwvdHNvls72Ysad1HMb"
Date: Wed, 10 Sep 2008 00:39:11 +0200
Message-Id: <1220999951.2770.16.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: 
Subject: Triple Asus TIGER_3IN1, first support so far
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


--=-oJwvdHNvls72Ysad1HMb
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Hi Folks,

this afternoon I found the above card in my mailbox and since then I was
on it.

Analog TV, radio, DVB-T and DVB-S works.

Currently it needs firmware for the tda10046, it obviously has an LNA
and the two MPC2 like internal connectors on the board are not yet
investigated.

If someone has it in an original box, testing on composite and s-video
inputs would be helpful.

You also need to use saa7134-alsa for analog TV and radio.

For switching to DVB-S, most easiest is to put
"options saa7134-dvb use_frontend=1 debug=1" into /etc/modprobe.conf,
then "depmod -a" and reload the drivers.

Mauro or Hartmut, I'm too tired now to clean up the code in saa7134-dvb,
so wait for further patches.

But this one is signed off so far for being already functional.
Signed-off-by: Hermann Pitton <hermann.pitton@arcor.de>

Happy testing.

Cheers,
Hermann



--=-oJwvdHNvls72Ysad1HMb
Content-Disposition: inline;
	filename=asus_3in1_fully_working-unclean-code-second.patch
Content-Type: text/x-patch;
	name=asus_3in1_fully_working-unclean-code-second.patch;
	charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r ff052010c4cb linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Sep 07 14:46:44 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Sep 09 23:42:00 2008 +0200
@@ -4448,6 +4448,44 @@
 		/* no DVB support for now */
 		/* .mpeg           = SAA7134_MPEG_DVB, */
 	},
+	[SAA7134_BOARD_ASUSTeK_TIGER_3IN1] = {
+		.name           = "ASUSTeK Tiger 3in1",
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
+			.gpio = 0x0000000,
+		}, {
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE2,
+			.gpio = 0x0200000,
+		}, {
+			.name = name_comp2,
+			.vmux = 0,
+			.amux = LINE2,
+			.gpio = 0x0200000,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+			.gpio = 0x0200000,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x0200000,
+		},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -5470,6 +5508,12 @@
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xf636,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_M103,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1043,
+		.subdevice    = 0x4878,
+		.driver_data  = SAA7134_BOARD_ASUSTeK_TIGER_3IN1,
 	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
@@ -6105,6 +6149,13 @@
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
 		break;
 	}
+	case SAA7134_BOARD_ASUSTeK_TIGER_3IN1:
+	{
+		u8 data[] = { 0x3c, 0x33, 0x60};
+		struct i2c_msg msg = {.addr=0x0b, .flags=0, .buf=data, .len = sizeof(data)};
+		i2c_transfer(&dev->i2c_adap, &msg, 1);
+		break;
+	}
 	case SAA7134_BOARD_FLYDVB_TRIO:
 	{
 		u8 data[] = { 0x3c, 0x33, 0x62};
diff -r ff052010c4cb linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sun Sep 07 14:46:44 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue Sep 09 23:42:01 2008 +0200
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
@@ -1304,6 +1318,27 @@
 						&dev->i2c_adap);
 		attach_xc3028 = 1;
 		break;
+	case SAA7134_BOARD_ASUSTeK_TIGER_3IN1:
+		if (!use_frontend) {     /* terrestrial */
+			if (configure_tda827x_fe(dev, &asus_tiger_3in1_config,
+						&tda827x_cfg_2) < 0)
+				goto dettach_frontend;
+		} else {  		/* satellite */
+			dev->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs, &dev->i2c_adap);
+		if (dev->dvb.frontend) {
+			if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x60,
+					&dev->i2c_adap, 0) == NULL) {
+				wprintk("%s: No tda826x found!\n", __func__);
+				goto dettach_frontend;
+			}
+			if (dvb_attach(lnbp21_attach, dev->dvb.frontend,
+					&dev->i2c_adap, 0, 0) == NULL) {
+				wprintk("%s: No lnbp21 found!\n", __func__);
+				goto dettach_frontend;
+			}
+		}
+	}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r ff052010c4cb linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Sep 07 14:46:44 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Sep 09 23:42:01 2008 +0200
@@ -270,6 +270,7 @@
 #define SAA7134_BOARD_BEHOLD_M6_EXTRA    144
 #define SAA7134_BOARD_AVERMEDIA_M103    145
 #define SAA7134_BOARD_ASUSTeK_P7131_ANALOG 146
+#define SAA7134_BOARD_ASUSTeK_TIGER_3IN1   147
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8

--=-oJwvdHNvls72Ysad1HMb
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-oJwvdHNvls72Ysad1HMb--
