Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from dd16712.kasserver.com ([85.13.137.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vdr@helmutauer.de>) id 1JPjW4-0005Af-CD
	for linux-dvb@linuxtv.org; Thu, 14 Feb 2008 20:13:04 +0100
Received: from [192.168.178.120] (p508116F1.dip0.t-ipconnect.de
	[80.129.22.241])
	by dd16712.kasserver.com (Postfix) with ESMTP id 81834180F4E06
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2008 20:13:04 +0100 (CET)
Message-ID: <47B492BE.809@helmutauer.de>
Date: Thu, 14 Feb 2008 20:13:02 +0100
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------080409040406000002040007"
Subject: [linux-dvb] Support for Samsung SMT7020
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------080409040406000002040007
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello List

The attached patch (written by Dirk Herrendoerfer) adds support for the 
builtin tuner of the samsung smt7020 box ( based on an Intel830 board ).
It would be fine to see this one inside the v4l tree.

-- 
Helmut Auer, helmut@helmutauer.de 


--------------080409040406000002040007
Content-Type: text/x-patch;
 name="SMT-dvb.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="SMT-dvb.diff"

diff -purN v4l-dvb.orig/linux/drivers/media/video/cx88/cx88-cards.c v4l-dvb/linux/drivers/media/video/cx88/cx88-cards.c
--- v4l-dvb.orig/linux/drivers/media/video/cx88/cx88-cards.c	2007-02-17 23:27:22.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/cx88/cx88-cards.c	2007-03-14 13:45:08.000000000 +0100
@@ -1362,6 +1362,19 @@ struct cx88_board cx88_boards[] = {
 		/* fixme: Add radio support */
 		.mpeg           = CX88_MPEG_DVB | CX88_MPEG_BLACKBIRD,
 	},
+	[CX88_BOARD_SAMSUNG_SMT_7020] = {
+		.name		= "Samsung SMT 7020 DVB-S",
+		.tuner_type	= TUNER_ABSENT,
+		.radio_type	= UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.input		= {{
+			.type	= CX88_VMUX_DVB,
+			.vmux	= 0,
+		}},
+		.mpeg           = CX88_MPEG_DVB,
+	},
+	
 };
 const unsigned int cx88_bcount = ARRAY_SIZE(cx88_boards);
 
@@ -1664,6 +1677,14 @@ struct cx88_subid cx88_subids[] = {
 		.subvendor = 0x0070,
 		.subdevice = 0x1402,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR3000,
+	},{
+		.subvendor = 0x18ac,
+		.subdevice = 0xdc00,
+		.card      = CX88_BOARD_SAMSUNG_SMT_7020,
+	},{
+		.subvendor = 0x18ac,
+		.subdevice = 0xdccd,
+		.card      = CX88_BOARD_SAMSUNG_SMT_7020,
 	},{
 		.subvendor = 0x1461,                
 const unsigned int cx88_idcount = ARRAY_SIZE(cx88_subids);
@@ -1955,6 +1973,12 @@ void cx88_card_setup(struct cx88_core *c
 						core->name, i);
 		}
 		break;
+	case CX88_BOARD_SAMSUNG_SMT_7020:
+		cx_set(MO_GP0_IO, 0x008989FF);
+		//cx_set(MO_GP3_IO, 0x00000000);
+		printk("!!Samsung RESET done.\n");
+		break;
+		
 	}
 	if (cx88_boards[core->board].radio.type == CX88_RADIO)
 		core->has_radio = 1;
diff -purN v4l-dvb.orig/linux/drivers/media/video/cx88/cx88-dvb.c v4l-dvb/linux/drivers/media/video/cx88/cx88-dvb.c
--- v4l-dvb.orig/linux/drivers/media/video/cx88/cx88-dvb.c	2007-02-17 23:27:22.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/cx88/cx88-dvb.c	1988-01-01 00:51:29.000000000 +0100
@@ -46,6 +46,7 @@
 #include "lgh06xf.h"
 #include "nxt200x.h"
 #include "cx24123.h"
+#include "stv0299.h"
 #include "isl6421.h"
 
 MODULE_DESCRIPTION("driver for cx2388x based DVB cards");
@@ -443,6 +444,187 @@ static struct cx24123_config kworld_dvbs
 	.lnb_polarity  = 1,
 };
 
+
+
+static u8 samsung_smt_7020_inittab[] = {
+		 0x01, 0x15,
+	     0x02, 0x00,
+	     0x03, 0x00,
+	     0x04, 0x7D,
+	     0x05, 0x0F,
+	     0x06, 0x02,
+	     0x07, 0x00,
+	     0x08, 0x60,
+	     
+	     0x0A, 0xC2,
+	     0x0B, 0x00,
+	     
+	     0x0C, 0x01,
+	     
+	     0x0D, 0x81,
+	     0x0E, 0x44,
+	     0x0F, 0x09,
+	     0x10, 0x3C,
+	     0x11, 0x84,
+	     0x12, 0xDA,
+	     0x13, 0x99,
+	     0x14, 0x8D,
+	     0x15, 0xCE,
+	     0x16, 0xE8,
+	     0x17, 0x43,
+	     0x18, 0x1C,
+	     0x19, 0x1B,
+	     0x1A, 0x1D,
+	     
+	     0x1C, 0x12,
+	     
+	     0x1D, 0x00,
+	     0x1E, 0x00,
+	     
+	     0x1F, 0x00,
+	     0x20, 0x00,
+	     0x21, 0x00,
+	     
+	     0x22, 0x00,
+	     0x23, 0x00,
+	     
+	     0x28, 0x02,
+	     
+	     0x29, 0x28,
+	     0x2A, 0x14,
+	     0x2B, 0x0F,
+	     0x2C, 0x09,
+	     0x2D, 0x05,
+	     
+	     0x31, 0x1F,
+	     0x32, 0x19,
+	     0x33, 0xFC,
+	     0x34, 0x13,
+	     0xff, 0xff,
+};
+
+
+static int samsung_smt_7020_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
+{
+	struct cx8802_dev *dev= fe->dvb->priv;
+	u8 buf[4];
+	u32 div;
+	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = buf, .len = sizeof(buf) };
+
+//	printk("!!Samsung samsung_tuner_set_params() freq: %d\n",params->frequency);
+
+	div = params->frequency / 125;
+	
+	buf[0] = (div >> 8) & 0x7f;
+	buf[1] = div & 0xff;
+	buf[2] = 0x84;  /* 0xC4 */
+	buf[3] = 0x00;
+	
+	if (params->frequency < 1500000) buf[3] |= 0x10;
+	
+	if (fe->ops.i2c_gate_ctrl)
+	        fe->ops.i2c_gate_ctrl(fe, 1);
+
+	if ((i2c_transfer(&dev->core->i2c_adap, &msg, 1)) != 1) {
+	        return -EIO;
+	}
+
+//	printk("!!Samsung samsung_tuner_set_params() OK.\n");
+	return 0;
+}
+
+static int samsung_smt_7020_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
+{
+	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx88_core *core = dev->core;
+
+	cx_set(MO_GP0_IO, 0x0800);
+	
+	switch (tone) {
+	case SEC_TONE_ON:
+//		printk("!!Samsung samsung_set_tone() ON OK.\n");
+		cx_set(MO_GP0_IO, 0x08);
+		break;
+	case SEC_TONE_OFF:
+//		printk("!!Samsung samsung_set_tone() OFF OK.\n");
+		cx_clear(MO_GP0_IO, 0x08);
+		break;
+	default:
+		return -EINVAL;
+	}
+	
+	return 0;
+}
+
+static int samsung_smt_7020_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+{
+	struct cx8802_dev *dev= fe->dvb->priv;
+	struct cx88_core *core = dev->core;
+	
+	u8 data;
+	//struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
+	struct i2c_msg msg = {	.addr = 8, .flags = 0,
+				.buf = &data,
+				.len = sizeof(data) };
+
+	cx_set(MO_GP0_IO, 0x8000);
+
+	switch(voltage) {
+	case SEC_VOLTAGE_OFF:
+		break;
+	case SEC_VOLTAGE_13:
+		data = ISL6421_EN1;
+		cx_clear(MO_GP0_IO, 0x80);
+//		printk("!!Samsung samsung_set_voltage() 13V OK.\n");
+		break;
+	case SEC_VOLTAGE_18:
+		data = ISL6421_EN1;
+		cx_set(MO_GP0_IO, 0x80);
+//		printk("!!Samsung samsung_set_voltage() 18V OK.\n");
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	return (i2c_transfer(&dev->core->i2c_adap, &msg, 1) == 1) ? 0 : -EIO;
+}
+
+static int samsung_smt_7020_stv0299_set_symbol_rate(struct dvb_frontend *fe, u32 srate, u32 ratio)
+{
+	u8 aclk = 0;
+	u8 bclk = 0;
+
+//	printk("!!Samsung samsung_tuner_set_symbol_rate() srate:%d ratio:%d\n",srate,ratio);
+    if (srate < 1500000) { aclk = 0xb7; bclk = 0x47; }
+    else if (srate < 3000000) { aclk = 0xb7; bclk = 0x4b; }
+    else if (srate < 7000000) { aclk = 0xb7; bclk = 0x4f; }
+    else if (srate < 14000000) { aclk = 0xb7; bclk = 0x53; }
+    else if (srate < 30000000) { aclk = 0xb6; bclk = 0x53; }
+    else if (srate < 45000000) { aclk = 0xb4; bclk = 0x51; }
+
+	
+    stv0299_writereg (fe, 0x13, aclk);
+    stv0299_writereg (fe, 0x14, bclk);
+    stv0299_writereg (fe, 0x1f, (ratio >> 16) & 0xff);
+    stv0299_writereg (fe, 0x20, (ratio >>  8) & 0xff);
+    stv0299_writereg (fe, 0x21, (ratio      ) & 0xf0);
+
+	return 0;
+}
+
+
+static struct stv0299_config samsung_stv0299_config = {
+	.demod_address = 0x68,
+	.inittab = samsung_smt_7020_inittab, 
+	.mclk = 88000000UL,
+	.invert = 0,
+	.skip_reinit = 0,
+	.lock_output = STV0229_LOCKOUTPUT_LK,
+	.volt13_op0_op1 = STV0299_VOLT13_OP1,
+	.min_delay_ms = 100,
+	.set_symbol_rate = samsung_smt_7020_stv0299_set_symbol_rate,
+};
+
 static int dvb_register(struct cx8802_dev *dev)
 {
 	/* init struct videobuf_dvb */
@@ -711,6 +893,34 @@ static int dvb_register(struct cx8802_de
 				   &dev->core->i2c_adap, &dvb_pll_fmd1216me);
 		}
 		break;
+	case CX88_BOARD_SAMSUNG_SMT_7020:
+		dev->ts_gen_cntrl = 0x08;
+		{
+		struct cx88_core *core = dev->core;
+
+		cx_set(MO_GP0_IO, 0x0101);
+
+		cx_clear(MO_GP0_IO, 0x01);
+		mdelay(100);
+		cx_set(MO_GP0_IO, 0x01);
+		mdelay(200);
+		
+		//cx_clear(MO_GP0_IO, 0x0088);
+			
+		dev->dvb.frontend = dvb_attach(stv0299_attach,
+					       &samsung_stv0299_config,
+					       &dev->core->i2c_adap);
+		if (dev->dvb.frontend) {
+			dev->dvb.frontend->ops.tuner_ops.set_params = samsung_smt_7020_tuner_set_params;
+			dev->dvb.frontend->tuner_priv = &dev->core->i2c_adap;
+			dev->dvb.frontend->ops.set_voltage  = samsung_smt_7020_set_voltage;
+			dev->dvb.frontend->ops.set_tone = samsung_smt_7020_set_tone;
+			
+//			printk("!!Samsung INIT done.\n");
+		}
+		}
+		break;
+
 	default:
 		printk("%s: The frontend of your DVB/ATSC card isn't supported yet\n",
 		       dev->core->name);
diff -purN v4l-dvb.orig/linux/drivers/media/video/cx88/cx88-mpeg.c v4l-dvb/linux/drivers/media/video/cx88/cx88-mpeg.c
--- v4l-dvb.orig/linux/drivers/media/video/cx88/cx88-mpeg.c	2007-02-17 23:27:22.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/cx88/cx88-mpeg.c	1988-01-01 00:51:52.000000000 +0100
@@ -98,6 +98,9 @@ static int cx8802_start_dma(struct cx880
 		case CX88_BOARD_PCHDTV_HD5500:
 			cx_write(TS_SOP_STAT, 1<<13);
 			break;
+		case CX88_BOARD_SAMSUNG_SMT_7020:
+			cx_write(TS_SOP_STAT, 0x00);
+			break;
 		case CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1:
 		case CX88_BOARD_HAUPPAUGE_NOVASE2_S1:
 			cx_write(MO_PINMUX_IO, 0x88); /* Enable MPEG parallel IO and video signal pins */
diff -purN v4l-dvb.orig/linux/drivers/media/video/cx88/cx88.h v4l-dvb/linux/drivers/media/video/cx88/cx88.h
--- v4l-dvb.orig/linux/drivers/media/video/cx88/cx88.h	2007-02-17 23:27:22.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/cx88/cx88.h	1988-01-01 01:04:05.000000000 +0100
@@ -212,6 +212,7 @@ extern struct sram_channel cx88_sram_cha
 #define CX88_BOARD_HAUPPAUGE_HVR1300       56
 #define CX88_BOARD_ADSTECH_PTV_390         57
 #define CX88_BOARD_PINNACLE_PCTV_HD_800i   58
+#define CX88_BOARD_SAMSUNG_SMT_7020        59
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,

--------------080409040406000002040007
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------080409040406000002040007--
