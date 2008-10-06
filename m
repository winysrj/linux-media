Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <d.belimov@gmail.com>) id 1KmehJ-0000nE-P7
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 03:15:43 +0200
Received: by nf-out-0910.google.com with SMTP id g13so995156nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 05 Oct 2008 18:15:37 -0700 (PDT)
Date: Mon, 6 Oct 2008 11:16:50 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <20081006111650.71bb42ab@glory.loctelecom.ru>
In-Reply-To: <1221700383.2658.12.camel@pc10.localdom.local>
References: <1221425354.4258.25.camel@pc10.localdom.local>
	<20080915162628.48059200@glory.loctelecom.ru>
	<1221507473.2715.31.camel@pc10.localdom.local>
	<20080916152750.6e8fffad@glory.loctelecom.ru>
	<1221700383.2658.12.camel@pc10.localdom.local>
Mime-Version: 1.0
Subject: [linux-dvb] DVB-T card H6 of Beholder
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi All.

I try wrote support the Beholder's DVB-T H6 card. 
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

I write this patch same as SAA7134_BOARD_MD7134, SAA7134_BOARD_ASUS_EUROPA2_HYBRID.

The zl10353 want write data to zl10353 chip but wrote it to tuner. This is dmesg with i2c_debug=1

Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:02:00.0, rev: 209, irq: 16, latency: 32, mmio: 0xe0002000
saa7133[0]: subsystem: 5ace:6290, board: Beholder BeholdTV H6 [card=142,autodetected]
saa7133[0]: board init: gpio is 800000
saa7133[0]: i2c xfer: < a0 00 >
saa7133[0]: i2c xfer: < a1 =ce =5a =90 =62 =54 =20 =00 =00 =00 =00 =00 =00 =00 =00 =00 =01
 =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
 =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ae =01 =00 =00 =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=42 =54 =56 =30 =30 =30 =30 =ff =ff =ff =ff =ff =ff =ff =ff =ff >
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
saa7133[0]: i2c xfer: < 20 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 86 >
saa7133[0]: i2c xfer: < 86 00 >
saa7133[0]: i2c xfer: < 87 =10 =10 =10 =10 =10 =10 =10 =10 >
tuner' 0-0043: chip found @ 0x86 (saa7133[0])
tda9887 0-0043: creating new instance
tda9887 0-0043: tda988[5/6/7] found
saa7133[0]: i2c xfer: < 86 00 c0 00 00 >
tuner' i2c attach [addr=0x43,client=tuner']
saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 96 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c0 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c2 >
tuner' 0-0061: chip found @ 0xc2 (saa7133[0])
tuner' i2c attach [addr=0x61,client=tuner']
saa7133[0]: i2c xfer: < c4 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c6 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c8 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < ca ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < cc ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < ce ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d0 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d2 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d4 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d6 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d8 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < da ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < dc ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < de ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c2 0b dc 9c 60 >
saa7133[0]: i2c xfer: < c2 0b dc 86 54 >
saa7133[0]: i2c xfer: < c3 =30 >
tuner-simple 0-0061: creating new instance
tuner-simple 0-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
saa7133[0]: i2c xfer: < 86 00 00 00 00 >
saa7133[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7133[0]: i2c xfer: < 86 00 c2 00 00 >
saa7133[0]: i2c xfer: < 86 00 00 00 00 >
saa7133[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7133[0]: i2c xfer: < 86 00 00 00 00 >
saa7133[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7133[0]: i2c xfer: < f5 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < e3 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 5b >
ir-kbd-i2c i2c attach [addr=0x2d,client=i2c IR (SAA713x rem]
ir-kbd-i2c i2c IR detected ().
input: BeholdTV as /class/input/input7
ir-kbd-i2c: BeholdTV detected at i2c-0/0-002d/ir0 [saa7133[0]]
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7133[0]: i2c xfer: < 86 00 20 00 00 >
saa7133[0]: i2c xfer: < c2 9c 60 85 54 >
saa7133[0]: i2c xfer: < 86 00 20 00 00 >
saa7133[0]: i2c xfer: < c2 1b 6f 86 52 >
DEBUG: zl10353_read_register start
Read from 0xF dev, 0x7F reg
saa7133[0]: i2c xfer: < 1e 7f [fd quirk] < 1f =14 >
DEBUG: zl10353_read_register stop
zl10353_i2c_gate_ctrl 
DEBUG: zl10353_single_write start
write data into 0xF dev, 0x62 reg, 0x1A val
saa7133[0]: i2c xfer: < 1e 62 1a >
DEBUG: zl10353_single_write stop
saa7133[0]: i2c xfer: < c3 ERROR: ARB_LOST
tuner-simple 0-0061: unable to probe Philips FMD1216ME MK3 Hybrid Tuner, proceeding anyway.zl10353_i2c_gate_ctrl 
DEBUG: zl10353_single_write start
write data into 0xF dev, 0x62 reg, 0xA val
saa7133[0]: i2c xfer: < 1e ERROR: BUSY
zl10353: write to reg 62 failed (err = -5)!
tuner-simple 0-0061: attaching existing instance
tuner-simple 0-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
zl10353_init start 
DEBUG: zl10353_read_register start
Read from 0xF dev, 0x50 reg
saa7133[0]: i2c xfer: < 1e ERROR: ST_ERR
zl10353_read_register: readreg error (reg=80, ret==-5)
DEBUG: zl10353_write start
DEBUG: zl10353_single_write start
write data into 0xF dev, 0x50 reg, 0x3 val
saa7133[0]: i2c xfer: < 1e ERROR: BUSY
zl10353: write to reg 50 failed (err = -5)!
zl10353_init stop
zl10353_sleep start
DEBUG: zl10353_write start
DEBUG: zl10353_single_write start
write data into 0xF dev, 0x50 reg, 0xC val
saa7133[0]: i2c xfer: < 1e ERROR: ST_ERR
zl10353: write to reg 50 failed (err = -5)!
zl10353_sleep stop
zl10353_i2c_gate_ctrl 
DEBUG: zl10353_single_write start
write data into 0xF dev, 0x62 reg, 0x1A val
saa7133[0]: i2c xfer: < 1e ERROR: BUSY
zl10353: write to reg 62 failed (err = -5)!
saa7133[0]: i2c xfer: < c2 ERROR: ST_ERR
saa7133[0]: i2c xfer: < 86 ERROR: BUSY
tda9887 0-0043: i2c i/o error: rc == -5 (should be 4)
saa7133[0]: i2c xfer: < c2 ERROR: ST_ERR
saa7133[0]: i2c xfer: < 86 ERROR: BUSY
tda9887 0-0043: i2c i/o error: rc == -5 (should be 4)
saa7133[0]: i2c xfer: < c2 ERROR: ST_ERR
tuner-simple 0-0061: i2c i/o error: rc == -5 (should be 4)
saa7133[0]: i2c xfer: < 86 ERROR: BUSY
tda9887 0-0043: i2c i/o error: rc == -5 (should be 4)
saa7133[0]: i2c xfer: < c2 ERROR: ST_ERR
saa7133[0]: i2c xfer: < 86 ERROR: BUSY
tda9887 0-0043: i2c i/o error: rc == -5 (should be 4)
saa7133[0]: i2c xfer: < c2 ERROR: ST_ERR
tuner-simple 0-0061: i2c i/o error: rc == -5 (should be 4)
saa7133[0]: i2c xfer: < 86 ERROR: BUSY
tda9887 0-0043: i2c i/o error: rc == -5 (should be 4)
saa7133[0]: i2c xfer: < c2 ERROR: ST_ERR
tda9887 0-0043: destroying instance
tuner-simple 0-0061: destroying instance

When I set comments to this part.

+		if (dev->dvb.frontend) {
+			dvb_attach(simple_tuner_attach, dev->dvb.frontend,
+				   &dev->i2c_adap, 0x61,
+				   TUNER_PHILIPS_FMD1216ME_MK3);
+		}

Communication ZL10353 driver with ZL10353 chip is OK, but card in not tunnable.

Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:02:00.0, rev: 209, irq: 16, latency: 32, mmio: 0xe0002000
saa7133[0]: subsystem: 5ace:6290, board: Beholder BeholdTV H6 [card=142,autodetected]
saa7133[0]: board init: gpio is 800000
saa7133[0]: i2c xfer: < a0 00 >
saa7133[0]: i2c xfer: < a1 =ce =5a =90 =62 =54 =20 =00 =00 =00 =00 =00 =00 =00 =00 =00 =01 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ae =01 =00 =00 =ff =ff =ff
 =ff =ff =ff =ff =ff =ff =ff =ff =ff =42 =54 =56 =30 =30 =30 =30 =ff =ff =ff =ff =ff =ff =ff =ff =ff >
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
saa7133[0]: i2c xfer: < 20 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 86 >
saa7133[0]: i2c xfer: < 86 00 >
saa7133[0]: i2c xfer: < 87 =10 =10 =10 =10 =10 =10 =10 =10 >
tuner' 0-0043: chip found @ 0x86 (saa7133[0])
tda9887 0-0043: creating new instance
tda9887 0-0043: tda988[5/6/7] found
saa7133[0]: i2c xfer: < 86 00 c0 00 00 >
tuner' i2c attach [addr=0x43,client=tuner']
saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 96 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c0 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c2 >
tuner' 0-0061: chip found @ 0xc2 (saa7133[0])
tuner' i2c attach [addr=0x61,client=tuner']
saa7133[0]: i2c xfer: < c4 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c6 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c8 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < ca ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < cc ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < ce ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d0 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d2 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d4 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d6 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d8 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < da ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < dc ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < de ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c2 0b dc 9c 60 >
saa7133[0]: i2c xfer: < c2 0b dc 86 54 >
saa7133[0]: i2c xfer: < c3 =30 >
tuner-simple 0-0061: creating new instance
tuner-simple 0-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
saa7133[0]: i2c xfer: < 86 00 00 00 00 >
saa7133[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7133[0]: i2c xfer: < 86 00 c2 00 00 >
saa7133[0]: i2c xfer: < 86 00 00 00 00 >
saa7133[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7133[0]: i2c xfer: < 86 00 00 00 00 >
saa7133[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7133[0]: i2c xfer: < f5 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < e3 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 5b >
ir-kbd-i2c i2c attach [addr=0x2d,client=i2c IR (SAA713x rem]
ir-kbd-i2c i2c IR detected ().
input: BeholdTV as /class/input/input8
ir-kbd-i2c: BeholdTV detected at i2c-0/0-002d/ir0 [saa7133[0]]
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7133[0]: i2c xfer: < 86 00 20 00 00 >
saa7133[0]: i2c xfer: < c2 9c 60 85 54 >
saa7133[0]: i2c xfer: < 86 00 20 00 00 >
saa7133[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7133[0]: i2c xfer: < 86 00 20 00 00 >
saa7133[0]: i2c xfer: < c2 9c 60 85 54 >
saa7133[0]: i2c xfer: < 86 00 20 00 00 >
saa7133[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7133[0]: i2c xfer: < 86 00 20 00 00 >
saa7133[0]: i2c xfer: < c2 9c 60 85 54 >
DEBUG: zl10353_read_register start
Read from 0xF dev, 0x7F reg
saa7133[0]: i2c xfer: < 1e 7f [fd quirk] < 1f =14 >
DEBUG: zl10353_read_register stop
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
zl10353_init start 
DEBUG: zl10353_read_register start
Read from 0xF dev, 0x50 reg
saa7133[0]: i2c xfer: < 1e 50 [fd quirk] < 1f =0c >
DEBUG: zl10353_read_register stop
DEBUG: zl10353_write start
DEBUG: zl10353_single_write start
write data into 0xF dev, 0x50 reg, 0x3 val
saa7133[0]: i2c xfer: < 1e 50 03 >
DEBUG: zl10353_single_write stop
DEBUG: zl10353_single_write start
write data into 0xF dev, 0x51 reg, 0x44 val
saa7133[0]: i2c xfer: < 1e 51 44 >
DEBUG: zl10353_single_write stop
DEBUG: zl10353_single_write start
write data into 0xF dev, 0x52 reg, 0x46 val
saa7133[0]: i2c xfer: < 1e 52 46 >
DEBUG: zl10353_single_write stop
DEBUG: zl10353_single_write start
write data into 0xF dev, 0x53 reg, 0x15 val
saa7133[0]: i2c xfer: < 1e 53 15 >
DEBUG: zl10353_single_write stop
DEBUG: zl10353_single_write start
write data into 0xF dev, 0x54 reg, 0xF val
saa7133[0]: i2c xfer: < 1e 54 0f >
DEBUG: zl10353_single_write stop
DEBUG: zl10353_write stop
zl10353_init stop
zl10353_sleep start
DEBUG: zl10353_write start
DEBUG: zl10353_single_write start
write data into 0xF dev, 0x50 reg, 0xC val
saa7133[0]: i2c xfer: < 1e 50 0c >
DEBUG: zl10353_single_write stop
DEBUG: zl10353_single_write start
write data into 0xF dev, 0x51 reg, 0x44 val
saa7133[0]: i2c xfer: < 1e 51 44 >
DEBUG: zl10353_single_write stop
DEBUG: zl10353_write stop
zl10353_sleep stop
saa7133[0]: i2c xfer: < 86 00 a0 00 00 >
saa7133[0]: i2c xfer: < c2 07 ac 80 19 >
saa7133[0]: i2c xfer: < 86 00 a0 00 00 >
saa7133[0]: i2c xfer: < c2 9c 60 85 54 >

Have you any suggestion?

With my best regards, Dmitry.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
