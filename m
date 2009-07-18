Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44865 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576AbZGRVeJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2009 17:34:09 -0400
Received: from compute2.internal (compute2.internal [10.202.2.42])
	by out1.messagingengine.com (Postfix) with ESMTP id D32E23B1A31
	for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 17:34:08 -0400 (EDT)
Received: from localhost.localdomain (ool-457b4d55.dyn.optonline.net [69.123.77.85])
	by mail.messagingengine.com (Postfix) with ESMTPSA id 979A49E89
	for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 17:34:08 -0400 (EDT)
Received: from acano by localhost.localdomain with local (Exim 4.69)
	(envelope-from <acano@fastmail.fm>)
	id 1MSHY4-0002Ix-Cj
	for linux-media@vger.kernel.org; Sat, 18 Jul 2009 17:34:28 -0400
Date: Sat, 18 Jul 2009 17:34:28 -0400
From: acano@fastmail.fm
To: linux-media@vger.kernel.org
Subject: [PATCH] em28xx:  kworld 340u
Message-ID: <20090718213428.GA8854@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

support for kworld 340u.  8vsb and qam256 work, qam64 untested.


--liOOAslEiF7prFVr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="2009-07-18-01-kworld-340u.patch"

diff -r 27ddf3fe0ed9 linux/drivers/media/dvb/frontends/lgdt3304.c
--- a/linux/drivers/media/dvb/frontends/lgdt3304.c	Wed Jun 17 04:38:12 2009 +0000
+++ b/linux/drivers/media/dvb/frontends/lgdt3304.c	Sat Jul 18 17:21:13 2009 -0400
@@ -110,9 +110,30 @@ static int lgdt3304_soft_Reset(struct dv
 	return 0;
 }
 
+#if 0
+static void print_regs(struct dvb_frontend *fe)
+{
+	int r050a;
+	int r011b;
+	int r011c;
+	int r0001;
+
+	r050a = lgdt3304_i2c_read_reg(fe, 0x050a);
+	r011b = lgdt3304_i2c_read_reg(fe, 0x011b);
+	r011c = lgdt3304_i2c_read_reg(fe, 0x011c);
+	r0001 = lgdt3304_i2c_read_reg(fe, 0x0001);
+
+	/*dprintk("read snr\n"); */
+	printk("050a: %x  011b: %x  011c: %x  0001: %x\n", r050a, r011b, r011c, r0001);
+	/*printk("011b :  0x%x\n", r011b); */
+	/*printk("011c :  0x%x\n", r011c); */
+}
+#endif
+
 static int lgdt3304_set_parameters(struct dvb_frontend *fe, struct dvb_frontend_parameters *param) {
 	int err = 0;
 
+#if 0
 	static __u8 lgdt3304_vsb8_data[] = {
 		/* 16bit  , 8bit */
 		/* regs   , val  */
@@ -138,14 +159,49 @@ static int lgdt3304_set_parameters(struc
 		0x03, 0x14, 0xe1,
 		0x05, 0x0e, 0x5b,
 	};
+#endif
 
+	/* tested with kworld atsc 340u */
+	static __u8 lgdt3304_vsb8_data[] = {
+		0x00, 0x00, 0x03,
+		0x00, 0x0d, 0x02,
+		0x00, 0x0e, 0x02,
+		0x00, 0x12, 0x32,
+		0x00, 0x13, 0xc4,
+		0x01, 0x12, 0x17,
+		0x01, 0x13, 0x15,
+		0x01, 0x14, 0x18,
+		0x01, 0x15, 0xff,
+		0x01, 0x16, 0xbc,
+		0x02, 0x14, 0x67,
+		0x04, 0x24, 0x8d,
+		0x04, 0x27, 0x12,
+		0x04, 0x28, 0x4f,
+		0x03, 0x08, 0x80,
+		0x03, 0x09, 0x00,
+		0x03, 0x0d, 0x14,
+		0x03, 0x0e, 0x1c,
+		0x03, 0x14, 0xe1,
+		/* 0x00, 0x02, 0x9b, */
+		/* 0x00, 0x02, 0x9a, */
+		0x01, 0x06, 0x4f,
+		0x01, 0x07, 0x0c,
+		0x01, 0x08, 0xac,
+		0x01, 0x09, 0xba,
+		0x01, 0x26, 0xf9,
+		0x00, 0x0d, 0x82,
+		0x05, 0x0e, 0x5b,
+		0x05, 0x0e, 0x5b,
+	};
+
+#if 0
 	/* not yet tested .. */
 	static __u8 lgdt3304_qam64_data[] = {
 		/* 16bit  , 8bit */
 		/* regs   , val  */
 		0x00, 0x00, 0x18,
 		0x00, 0x0d, 0x02,
-		//0x00, 0x0e, 0x02,
+		/*0x00, 0x0e, 0x02, */
 		0x00, 0x12, 0x2a,
 		0x00, 0x13, 0x00,
 		0x03, 0x14, 0xe3,
@@ -156,6 +212,7 @@ static int lgdt3304_set_parameters(struc
 		0x03, 0x0b, 0x9b,
 		0x05, 0x0e, 0x5b,
 	};
+#endif
 
 #if 0
 	/* not yet tested */
@@ -178,41 +235,10 @@ static int lgdt3304_set_parameters(struc
 	};
 #endif
 
-	/* tested with KWorld a340 */
+	/* tested with Kworld 340u */
 	static __u8 lgdt3304_qam256_data[] = {
 		/* 16bit  , 8bit */
 		/* regs   , val  */
-		0x00, 0x00, 0x01,  //0x19,
-		0x00, 0x12, 0x2a,
-		0x00, 0x13, 0x80,
-		0x00, 0x0d, 0x02,
-		0x03, 0x14, 0xe3,
-
-		0x03, 0x0e, 0x1c,
-		0x03, 0x08, 0x66,
-		0x03, 0x09, 0x66,
-		0x03, 0x0a, 0x08,
-		0x03, 0x0b, 0x9b,
-
-		0x03, 0x0d, 0x14,
-		//0x05, 0x0e, 0x5b,
-		0x01, 0x06, 0x4a,
-		0x01, 0x07, 0x3d,
-		0x01, 0x08, 0x70,
-		0x01, 0x09, 0xa3,
-
-		0x05, 0x04, 0xfd,
-
-		0x00, 0x0d, 0x82,
-
-		0x05, 0x0e, 0x5b,
-
-		0x05, 0x0e, 0x5b,
-
-		0x00, 0x02, 0x9a,
-
-		0x00, 0x02, 0x9b,
-
 		0x00, 0x00, 0x01,
 		0x00, 0x12, 0x2a,
 		0x00, 0x13, 0x80,
@@ -236,6 +262,8 @@ static int lgdt3304_set_parameters(struc
 		0x00, 0x0d, 0x82,
 
 		0x05, 0x0e, 0x5b,
+
+		0x05, 0x0e, 0x5b,
 	};
 
 	struct lgdt3304_state *state = fe->demodulator_priv;
@@ -246,8 +274,11 @@ static int lgdt3304_set_parameters(struc
 					sizeof(lgdt3304_vsb8_data));
 			break;
 		case QAM_64:
+			printk("%s qam64 not tested yet\n", __func__);
+#if 0
 			err = i2c_write_demod_bytes(fe, lgdt3304_qam64_data,
 					sizeof(lgdt3304_qam64_data));
+#endif
 			break;
 		case QAM_256:
 			err = i2c_write_demod_bytes(fe, lgdt3304_qam256_data,
@@ -283,15 +314,37 @@ static int lgdt3304_sleep(struct dvb_fro
 }
 
 
+/*
+ 050a: 6f  011b: 4  011c: 7   , WABC+
+
+050a: 0x0d  generates dvbtraffic
+
+*/
+
 static int lgdt3304_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct lgdt3304_state *state = fe->demodulator_priv;
+	/*int r050a; */
 	int r011d;
 	int qam_lck;
 
 	*status = 0;
 	dprintk("lgdt read status\n");
 
+	/*print_regs(fe); */
+
+	/* 60, e0, 61, 67, 63 */
+	/*
+030610:                1c 03 lgdt3304  >>>  01 1d
+030611:                R05_I2C_STATUS       00
+030612:                1c 02 lgdt3304       e0
+030613:                R05_I2C_STATUS       00
+030614:                1c 03 lgdt3304  >>>  04 09
+030615:                R05_I2C_STATUS       00
+030616:                1c 02 lgdt3304       07
+	*/
+
+	/*r050a = lgdt3304_i2c_read_reg(fe, 0x050a); */
 	r011d = lgdt3304_i2c_read_reg(fe, 0x011d);
 
 	dprintk("%02x\n", r011d);
@@ -308,7 +361,14 @@ static int lgdt3304_read_status(struct d
 		break;
 	case QAM_64:
 	case QAM_256:
+		/*
+                   0x78,    0x7f
+                   0x78,    0x7b,   0x7f
+                   0x79
+                   0x78 -- all 0 signal
+		*/
 		qam_lck = r011d & 0x7;
+#if 1        /* orig */
 		switch(qam_lck) {
 			case 0x0: dprintk("Unlock\n");
 				  break;
@@ -323,9 +383,53 @@ static int lgdt3304_read_status(struct d
 				  *status |= FE_HAS_SIGNAL;
 				  break;
 		}
+#endif
+
+#if 0   /****************/
+		switch (qam_lck) {
+		case 0x0:
+			dprintk("Unlock\n");
+			break;
+		case 0x4:
+			dprintk("1st Lock in acquisition state\n");
+			break;
+		case 0x6:
+			dprintk("2nd Lock in acquisition state\n");
+			break;
+		case 0x7:
+			dprintk("Final Lock in good reception state\n");
+			*status |= FE_HAS_CARRIER;
+			/**status |= FE_HAS_LOCK; */
+			*status |= FE_HAS_SYNC;
+			*status |= FE_HAS_SIGNAL;
+
+			if (r050a == 0x6f  ||  r050a == 0x5f) {  /* also 0x5f generates dvb traffic */
+				*status |= FE_HAS_LOCK;
+			}
+			break;
+		}
+#endif
+
+#if 0  /****************/
+		if (qam_lck & 0x1) {
+			*status |= FE_HAS_SIGNAL;
+		}
+		if (qam_lck & 0x2) {
+			*status |= FE_HAS_CARRIER;
+		}
+		if (qam_lck & 0x4) {
+			*status |= FE_HAS_SYNC;
+		}
+		if (qam_lck & 0x7) {
+			if (1) {  /*(r050a == 0x6f  ||  r050a == 0x5f) {  // these genereate output with dvbtraffic */
+				*status |= FE_HAS_LOCK;
+			}
+		}
+#endif
+
 		break;
 	default:
-		printk("%s unhandled modulation\n", __func__);
+		printk("%s unhandled modulation %d\n", __func__, state->current_modulation);
 	}
 
 
@@ -334,19 +438,89 @@ static int lgdt3304_read_status(struct d
 
 static int lgdt3304_read_ber(struct dvb_frontend *fe, __u32 *ber)
 {
-	dprintk("read ber\n");
+	//int r011c;
+
+	//dprintk("read ber\n");
+	//r011c = lgdt3304_i2c_read_reg(fe, 0x011c);
+	//*ber = r011c;
+
+	*ber = 0;
+
+	return 0;
+}
+
+static int lgdt3304_read_signal_strength(struct dvb_frontend *fe, __u16 *strength)
+{
+	//int r050a;
+	//dprintk("read snr\n");
+	//print_regs(fe);
+	//r050a = lgdt3304_i2c_read_reg(fe, 0x050a);
+	//*strength = r050a;
+	*strength = 0xffff;
+
 	return 0;
 }
 
 static int lgdt3304_read_snr(struct dvb_frontend *fe, __u16 *snr)
 {
+	//int r011b;
+	//int r011c;
+
 	dprintk("read snr\n");
+
+	//print_regs(fe);
+
+	//r011b = lgdt3304_i2c_read_reg(fe, 0x011b);
+	//r011c = lgdt3304_i2c_read_reg(fe, 0x011c);
+
+	//*snr = 0xffff - ((r011b << 8) | r011c);
+	//*snr = r011b;
+	*snr = 0xffff;
+
+	/*
+002658:                1c 03 lgdt3304  >>>  05 0a
+002659:                R05_I2C_STATUS       00
+002660:                1c 02 lgdt3304       6f
+002661:                R05_I2C_STATUS       00
+002662:                1c 03 lgdt3304  >>>  01 1b
+###  002663:  ISOCH_TRANSFER - (not parsed)
+002664:                R05_I2C_STATUS       00
+002665:                1c 02 lgdt3304       00
+002666:                R05_I2C_STATUS       00
+002667:                1c 03 lgdt3304  >>>  01 1c
+002668:                R05_I2C_STATUS       00
+002669:                1c 02 lgdt3304       b9
+002670:                R05_I2C_STATUS       00
+
+2008-04-16 09:02:00.381 ERROR PropSet->Set() failed... hr=80070492
+2008-04-16 09:02:01.013 VERBOSE ServiceID: -1, PMT PID: -1, VPID: -1, APID: -1
+2008-04-16 09:02:01.013 VERBOSE SubmitTuningRequest() complete
+2008-04-16 09:02:01.013 VERBOSE ScanTransponder@2
+2008-04-16 09:02:01.117 VERBOSE ScanTransponder@2
+2008-04-16 09:02:01.154 VERBOSE locked=1 present=1 strength=35250 quality=89
+2008-04-16 09:02:01.155 VERBOSE ScanTransponder@4
+2008-04-16 09:02:01.155 VERBOSE ScanTransponder@5
+2008-04-16 09:02:01.155 VERBOSE ScanTransponder@6
+2008-04-16 09:02:01.155 VERBOSE locked=1 present=1 strength=35250 quality=89
+2008-04-16 09:02:01.156 VERBOSE SIGNAL???
+2008-04-16 09:02:01.156 VERBOSE ScanTransponder finished
+
+	*/
+
 	return 0;
 }
 
 static int lgdt3304_read_ucblocks(struct dvb_frontend *fe, __u32 *ucblocks)
 {
-	dprintk("read ucblocks\n");
+	//int r011d;
+
+	//dprintk("read ucblocks\n");
+	//r011d = lgdt3304_i2c_read_reg(fe, 0x011d);
+
+	//*ucblocks = r011d;
+
+	*ucblocks = 0;
+
 	return 0;
 }
 
@@ -365,11 +539,14 @@ static struct dvb_frontend_ops demod_lgd
 		.frequency_stepsize = 62500,
 		.symbol_rate_min = 5056941,
 		.symbol_rate_max = 10762000,
-		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
+		//.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
+		//FIXME add QAM_64 when tested
+		.caps = FE_CAN_QAM_256 | FE_CAN_8VSB,
 	},
 	.init = lgdt3304_init,
 	.sleep = lgdt3304_sleep,
 	.set_frontend = lgdt3304_set_parameters,
+	.read_signal_strength = lgdt3304_read_signal_strength,
 	.read_snr = lgdt3304_read_snr,
 	.read_ber = lgdt3304_read_ber,
 	.read_status = lgdt3304_read_status,
diff -r 27ddf3fe0ed9 linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Wed Jun 17 04:38:12 2009 +0000
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Sat Jul 18 17:21:13 2009 -0400
@@ -1594,6 +1594,16 @@ struct em28xx_board em28xx_boards[] = {
 			.gpio     = evga_indtube_analog,
 		} },
 	},
+	[EM2870_BOARD_KWORLD_340U] = {
+		.name         = "KWorld ATSC 340U",
+		.tuner_type   = TUNER_ABSENT,  /* ok ...  its a Philips TDA18271 */
+		.has_dvb      = 1,
+		/*
+		  .input           = { {
+			.type     = EM28XX_VMUX_DVB,
+			}, },
+		*/
+	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
@@ -1709,6 +1719,8 @@ struct usb_device_id em28xx_id_table[] =
 			.driver_info = EM2820_BOARD_IODATA_GVMVP_SZ },
 	{ USB_DEVICE(0xeb1a, 0x50a6),
 			.driver_info = EM2860_BOARD_GADMEI_UTV330 },
+	{ USB_DEVICE(0x1b80, 0xa340),
+			.driver_info = EM2870_BOARD_KWORLD_340U  },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
@@ -2038,6 +2050,20 @@ void em28xx_pre_card_setup(struct em28xx
 		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
 		msleep(70);
 		break;
+	case EM2870_BOARD_KWORLD_340U:
+		em28xx_write_regs(dev, EM28XX_R0F_XCLK, "\x07", 1);  /* protocol? */
+		em28xx_write_regs(dev, EM28XX_R06_I2C_CLK, "\x4c", 1);
+		em28xx_write_regs(dev, 0x08, "\xfe", 1);
+		em28xx_write_regs(dev, 0x08, "\xde", 1);
+		em28xx_write_regs(dev, 0x08, "\xfe", 1);
+
+		em28xx_write_regs(dev, 0x08, "\xfd", 1);
+		em28xx_write_regs(dev, 0x08  /* wtf 0x04*/ , "\xff", 1);
+		em28xx_write_regs(dev, 0x08, "\xfd", 1);
+		em28xx_write_regs(dev, 0x08  /* wtf 0x04 */, "\xff", 1);
+		em28xx_write_regs(dev, 0x08, "\xfd", 1);
+
+		break;
 	}
 
 	em28xx_gpio_set(dev, dev->board.tuner_gpio);
diff -r 27ddf3fe0ed9 linux/drivers/media/video/em28xx/em28xx-dvb.c
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c	Wed Jun 17 04:38:12 2009 +0000
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c	Sat Jul 18 17:21:13 2009 -0400
@@ -30,10 +30,12 @@
 #include "tuner-simple.h"
 
 #include "lgdt330x.h"
+#include "lgdt3304.h"
 #include "zl10353.h"
 #include "s5h1409.h"
 #include "mt352.h"
 #include "mt352_priv.h" /* FIXME */
+#include "tda18271.h"
 
 MODULE_DESCRIPTION("driver for em28xx based DVB cards");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
@@ -230,6 +232,10 @@ static struct lgdt330x_config em2880_lgd
 	.demod_chip = LGDT3303,
 };
 
+static struct lgdt3304_config lgdt3304_atsc_config = {
+        .i2c_address = 0x0e
+};
+
 static struct zl10353_config em28xx_zl10353_with_xc3028 = {
 	.demod_address = (0x1e >> 1),
 	.no_tuner = 1,
@@ -261,6 +267,9 @@ static struct drx397xD_config em28xx_drx
 };
 #endif
 
+static struct tda18271_config em28xx_tda18271_config = {
+};
+
 static int mt352_terratec_xs_init(struct dvb_frontend *fe)
 {
 	/* Values extracted from a USB trace of the Terratec Windows driver */
@@ -550,6 +559,12 @@ static int dvb_init(struct em28xx *dev)
 		}
 		break;
 #endif
+	case EM2870_BOARD_KWORLD_340U:
+		dvb->frontend = dvb_attach(lgdt3304_attach,
+					   &lgdt3304_atsc_config,
+                       &dev->i2c_adap);
+		dvb_attach(tda18271_attach, dvb->frontend, 0x60, &dev->i2c_adap, &em28xx_tda18271_config);
+		break;
 	default:
 		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card"
 				" isn't supported yet\n",
diff -r 27ddf3fe0ed9 linux/drivers/media/video/em28xx/em28xx-i2c.c
--- a/linux/drivers/media/video/em28xx/em28xx-i2c.c	Wed Jun 17 04:38:12 2009 +0000
+++ b/linux/drivers/media/video/em28xx/em28xx-i2c.c	Sat Jul 18 17:21:13 2009 -0400
@@ -494,6 +494,7 @@ static char *i2c_devs[128] = {
 	[0xc2 >> 1] = "tuner (analog)",
 	[0xc4 >> 1] = "tuner (analog)",
 	[0xc6 >> 1] = "tuner (analog)",
+	[0x1c >> 1] = "lgdt3304",
 };
 
 /*
diff -r 27ddf3fe0ed9 linux/drivers/media/video/em28xx/em28xx.h
--- a/linux/drivers/media/video/em28xx/em28xx.h	Wed Jun 17 04:38:12 2009 +0000
+++ b/linux/drivers/media/video/em28xx/em28xx.h	Sat Jul 18 17:21:13 2009 -0400
@@ -109,6 +109,7 @@
 #define EM2882_BOARD_KWORLD_ATSC_315U		  69
 #define EM2882_BOARD_EVGA_INDTUBE		  70
 #define EM2820_BOARD_SILVERCREST_WEBCAM           71
+#define EM2870_BOARD_KWORLD_340U			72
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4

--liOOAslEiF7prFVr--
