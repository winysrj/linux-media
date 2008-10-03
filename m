Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m931v9NK003233
	for <video4linux-list@redhat.com>; Thu, 2 Oct 2008 21:57:09 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m931uvJU002402
	for <video4linux-list@redhat.com>; Thu, 2 Oct 2008 21:56:57 -0400
Received: by nf-out-0910.google.com with SMTP id d3so552127nfc.21
	for <video4linux-list@redhat.com>; Thu, 02 Oct 2008 18:56:57 -0700 (PDT)
Date: Fri, 3 Oct 2008 11:58:00 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Message-ID: <20081003115800.4fd0b95e@glory.loctelecom.ru>
In-Reply-To: <1221700383.2658.12.camel@pc10.localdom.local>
References: <1221425354.4258.25.camel@pc10.localdom.local>
	<20080915162628.48059200@glory.loctelecom.ru>
	<1221507473.2715.31.camel@pc10.localdom.local>
	<20080916152750.6e8fffad@glory.loctelecom.ru>
	<1221700383.2658.12.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: DVB-T card H6 of Beholder
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

Hi All.

This is my simple patch for the Beholder H6 card. Not for main tree, for discuss only.

diff -r 6032ecd6ad7e linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Aug 30 11:07:04 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Oct 02 06:28:13 2008 +1000
@@ -4427,26 +4427,25 @@
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.tda9887_conf   = TDA9887_PRESENT,
-		.inputs         = {{
-			.name = name_tv,
-			.vmux = 3,
-			.amux = TV,
-			.tv   = 1,
-		}, {
-			.name = name_comp1,
-			.vmux = 1,
-			.amux = LINE1,
-		}, {
-			.name = name_svideo,
-			.vmux = 8,
-			.amux = LINE1,
-		} },
-		.radio = {
-			.name = name_radio,
-			.amux = LINE2,
-		},
-		/* no DVB support for now */
-		/* .mpeg           = SAA7134_MPEG_DVB, */
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
 	},
 };
 
@@ -5853,6 +5852,7 @@
 	case SAA7134_BOARD_BEHOLD_M6:
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
+	case SAA7134_BOARD_BEHOLD_H6:
 		dev->has_remote = SAA7134_REMOTE_I2C;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A169_B:

diff -r 6032ecd6ad7e linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sat Aug 30 11:07:04 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Oct 02 06:28:13 2008 +1000
@@ -48,6 +48,8 @@
 #include "isl6405.h"
 #include "lnbp21.h"
 #include "tuner-simple.h"
+
+#include "zl10353.h"
 
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
@@ -838,6 +840,115 @@
 	.if_freq       = TDA10046_FREQ_045,
 	.tuner_address = 0x61,
 	.request_firmware = philips_tda1004x_request_firmware
+};
+
+#if 0
+static int behold_h6_tuner_set_params(struct dvb_frontend* fe,
+					   struct dvb_frontend_parameters* params)
+{
+	struct saa7134_dev *dev = fe->dvb->priv;
+	u8 addr = 0x61;
+	u8 tuner_buf[4];
+	struct i2c_msg tuner_msg = {.addr = addr,.flags = 0,.buf = tuner_buf,.len =
+			sizeof(tuner_buf) };
+	int tuner_frequency = 0;
+	u8 band, cp, opmode, filter;
+
+	printk("DEBUG: behold_h6_tuner_set_params\n");
+
+	/* determine band */
+	if (params->frequency < 48250000)
+		return -EINVAL;
+	else if (params->frequency < 160000000)
+		band = 1;
+	else if (params->frequency < 442000000)
+		band = 2;
+	else if (params->frequency < 863000000)
+		band = 4;
+	else
+		return -EINVAL;
+
+	/* determine charge pump */
+	switch (band) {
+	case 1:
+		if (params->frequency < 142000000){
+			cp = 0;
+			opmode = 0x07;
+		}
+		else {
+			cp = 1;
+			opmode = 0x06;
+		}
+		break;
+	case 2:
+		cp = 0;
+		if (params->frequency < 328000000){
+			opmode = 0x06;
+		}
+		else {
+			opmode = 0x07;
+		}
+		break;
+	case 4:
+		if (params->frequency < 638000000){
+			cp = 0;
+			opmode = 0x06;
+		}
+		else if (params->frequency < 846000000) {
+			cp = 0;
+			opmode = 0x07;
+		} else {
+			cp = 1;
+			opmode = 0x06;
+		}
+		break;
+	default:
+		break;
+	}
+
+	/* setup PLL filter */
+	switch (params->u.ofdm.bandwidth) {
+	case BANDWIDTH_6_MHZ:
+		filter = 0;
+		break;
+
+	case BANDWIDTH_7_MHZ:
+		filter = 0;
+		break;
+
+	case BANDWIDTH_8_MHZ:
+		filter = 1;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	/* calculate divisor
+	 * ((36166000+((1000000/6)/2)) + Finput)/(1000000/6)
+	 */
+	tuner_frequency = (((params->frequency / 1000) * 6) + 217496) / 1000;
+
+	/* setup tuner buffer */
+	tuner_buf[0] = (tuner_frequency >> 8) & 0x7f;
+	tuner_buf[1] = tuner_frequency & 0xff;
+	tuner_buf[2] = 0xca;
+	tuner_buf[3] = (cp << 5) | (filter << 3) | band;
+
+	if (i2c_transfer(addr, &tuner_msg, 1) != 1) {
+		wprintk("could not write to tuner at addr: 0x%02x\n",
+			addr << 1);
+		return -EIO;
+	}
+	msleep(1);
+	return 0;
+}
+#endif
+
+static struct zl10353_config behold_h6_config = {
+	.demod_address = 0x1e>>1,
+	.no_tuner      = 1,
+	.parallel_ts   = 1,
 };
 
 /* ==================================================================
@@ -1304,6 +1415,16 @@
 						&dev->i2c_adap);
 		attach_xc3028 = 1;
 		break;
+	case SAA7134_BOARD_BEHOLD_H6:
+		dev->dvb.frontend = dvb_attach(zl10353_attach,
+						&behold_h6_config,
+						&dev->i2c_adap);
+		if (dev->dvb.frontend) {
+			dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+				   &dev->i2c_adap, 0x61,
+				   TUNER_PHILIPS_FMD1216ME_MK3);
+		}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;

In the dmesg file I see

Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:02:00.0, rev: 209, irq: 16, latency: 32, mmio: 0xe0002000
saa7133[0]: subsystem: 5ace:6290, board: Beholder BeholdTV H6 [card=142,autodetected]
saa7133[0]: board init: gpio is 800000
saa7133[0]: i2c eeprom 00: ce 5a 90 62 54 20 00 00 00 00 00 00 00 00 00 01
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ae 01 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
tuner' 0-0043: chip found @ 0x86 (saa7133[0])
tda9887 0-0043: creating new instance
tda9887 0-0043: tda988[5/6/7] found
tuner' 0-0061: chip found @ 0xc2 (saa7133[0])
tuner-simple 0-0061: creating new instance
tuner-simple 0-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
input: BeholdTV as /class/input/input7
ir-kbd-i2c: BeholdTV detected at i2c-0/0-002d/ir0 [saa7133[0]]
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
tuner-simple 0-0061: unable to probe Philips FMD1216ME MK3 Hybrid Tuner, proceeding anyway.zl10353: write to reg 62 failed (err = -5)!
tuner-simple 0-0061: attaching existing instance
tuner-simple 0-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
zl10353_read_register: readreg error (reg=80, ret==-5)
zl10353: write to reg 50 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
tda9887 0-0043: i2c i/o error: rc == -5 (should be 4)
tuner-simple 0-0061: i2c i/o error: rc == -5 (should be 4)
tda9887 0-0043: i2c i/o error: rc == -5 (should be 4)
zl10353_read_register: readreg error (reg=80, ret==-5)
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353_read_register: readreg error (reg=10, ret==-5)
zl10353_read_register: readreg error (reg=11, ret==-5)
zl10353_read_register: readreg error (reg=16, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353_read_register: readreg error (reg=10, ret==-5)
zl10353_read_register: readreg error (reg=11, ret==-5)
zl10353_read_register: readreg error (reg=16, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353_read_register: readreg error (reg=10, ret==-5)
zl10353_read_register: readreg error (reg=11, ret==-5)
zl10353_read_register: readreg error (reg=16, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353_read_register: readreg error (reg=10, ret==-5)
zl10353_read_register: readreg error (reg=11, ret==-5)
zl10353_read_register: readreg error (reg=16, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353_read_register: readreg error (reg=10, ret==-5)
zl10353_read_register: readreg error (reg=11, ret==-5)
zl10353_read_register: readreg error (reg=16, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353_read_register: readreg error (reg=10, ret==-5)
zl10353_read_register: readreg error (reg=11, ret==-5)
zl10353_read_register: readreg error (reg=16, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353_read_register: readreg error (reg=10, ret==-5)
zl10353_read_register: readreg error (reg=11, ret==-5)
zl10353_read_register: readreg error (reg=16, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353_read_register: readreg error (reg=10, ret==-5)
zl10353_read_register: readreg error (reg=11, ret==-5)
zl10353_read_register: readreg error (reg=16, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353_read_register: readreg error (reg=10, ret==-5)
zl10353_read_register: readreg error (reg=11, ret==-5)
zl10353_read_register: readreg error (reg=16, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353_read_register: readreg error (reg=10, ret==-5)
zl10353_read_register: readreg error (reg=11, ret==-5)
zl10353_read_register: readreg error (reg=16, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353_read_register: readreg error (reg=10, ret==-5)
zl10353_read_register: readreg error (reg=11, ret==-5)
zl10353_read_register: readreg error (reg=16, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353_read_register: readreg error (reg=10, ret==-5)
zl10353_read_register: readreg error (reg=11, ret==-5)
zl10353_read_register: readreg error (reg=16, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353_read_register: readreg error (reg=6, ret==-5)
zl10353: write to reg 55 failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg ea failed (err = -5)!
zl10353: write to reg 56 failed (err = -5)!
zl10353: write to reg 5e failed (err = -5)!
zl10353: write to reg 5c failed (err = -5)!
zl10353: write to reg 64 failed (err = -5)!
zl10353: write to reg 65 failed (err = -5)!
zl10353: write to reg 66 failed (err = -5)!
zl10353: write to reg 6c failed (err = -5)!
zl10353: write to reg 6d failed (err = -5)!
zl10353: write to reg 6e failed (err = -5)!
zl10353: write to reg 6f failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 5f failed (err = -5)!
zl10353: write to reg 71 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 62 failed (err = -5)!
zl10353: write to reg 50 failed (err = -5)!

I write this patch same as SAA7134_BOARD_MD7134, SAA7134_BOARD_ASUS_EUROPA2_HYBRID.

The zl10353 want write data to zl10353 chip but wrote it to tuner.

Have you any suggestion?

With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
