Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:42109 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270Ab0ANQ1o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 11:27:44 -0500
Received: from mail-in-20-z2.arcor-online.net (mail-in-20-z2.arcor-online.net [151.189.8.85])
	by mx.arcor.de (Postfix) with ESMTP id 46F4D35672E
	for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 17:27:41 +0100 (CET)
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net [151.189.21.49])
	by mail-in-20-z2.arcor-online.net (Postfix) with ESMTP id EEC99108252
	for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 17:27:40 +0100 (CET)
Received: from [192.168.2.102] (dslb-094-222-026-034.pools.arcor-ip.net [94.222.26.34])
	(Authenticated sender: stefan.ringel@arcor.de)
	by mail-in-09.arcor-online.net (Postfix) with ESMTPA id F16CE1AF6DE
	for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 17:27:37 +0100 (CET)
Message-ID: <4B4F45E9.5050905@arcor.de>
Date: Thu, 14 Jan 2010 17:27:21 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy Hybrid XE (TM6010 Mediachip)
Content-Type: multipart/mixed;
 boundary="------------010006010705000401080105"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010006010705000401080105
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

I have bug-fix (tm6000.patch) my first problem, so that it loads the
tuner and demodulator (message). But I cannot find digital channels. It
was wrong with the tuner (xc3028) or demodulator (zl10353)? Under
windows xp it found digital channels (region Germany Berlin).

-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------010006010705000401080105
Content-Type: text/x-patch;
 name="tm6000.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tm6000.patch"

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 59fb505..334dea9 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -32,7 +32,7 @@
 #include "tm6000.h"
 #include "tm6000-regs.h"
 #include "tuner-xc2028.h"
-#include "tuner-xc5000.h"
+#include "xc5000.h"
 
 #define TM6000_BOARD_UNKNOWN			0
 #define TM5600_BOARD_GENERIC			1
@@ -44,6 +44,10 @@
 #define TM6000_BOARD_FREECOM_AND_SIMILAR	7
 #define TM6000_BOARD_ADSTECH_MINI_DUAL_TV	8
 #define TM6010_BOARD_HAUPPAUGE_900H		9
+#define TM6010_BOARD_BEHOLD_WANDER		10
+#define TM6010_BOARD_BEHOLD_VOYAGER		11
+#define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE	12
+
 
 #define TM6000_MAXBOARDS        16
 static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };
@@ -208,7 +212,21 @@ struct tm6000_board tm6000_boards[] = {
 		},
 		.gpio_addr_tun_reset = TM6000_GPIO_2,
 	},
-
+	[TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE] = {
+		.name         = "Terratec Cinergy Hybrid XE",
+		.tuner_type   = TUNER_XC2028, /* has a XC3028 */
+		.tuner_addr   = 0xc2 >> 1,
+		.demod_addr   = 0x1e >> 1,
+		.type         = TM6010,
+		.caps = {
+			.has_tuner    = 1,
+			.has_dvb      = 1,
+			.has_zl10353  = 1,
+			.has_eeprom   = 1,
+			.has_remote   = 1,
+		},
+		.gpio_addr_tun_reset = TM6000_GPIO_2,
+	}
 };
 
 /* table of devices that work with this driver */
@@ -221,6 +239,7 @@ struct usb_device_id tm6000_id_table [] = {
 	{ USB_DEVICE(0x2040, 0x6600), .driver_info = TM6010_BOARD_HAUPPAUGE_900H },
 	{ USB_DEVICE(0x6000, 0xdec0), .driver_info = TM6010_BOARD_BEHOLD_WANDER },
 	{ USB_DEVICE(0x6000, 0xdec1), .driver_info = TM6010_BOARD_BEHOLD_VOYAGER },
+	{ USB_DEVICE(0x0ccd, 0x0086), .driver_info = TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE },
 	{ },
 };
 
@@ -305,12 +324,14 @@ static void tm6000_config_tuner (struct tm6000_core *dev)
 		ctl.mts   = 1;
 		ctl.read_not_reliable = 1;
 		ctl.msleep = 10;
-
+		ctl.demod = XC3028_FE_ZARLINK456;
+		
 		xc2028_cfg.tuner = TUNER_XC2028;
 		xc2028_cfg.priv  = &ctl;
 
 		switch(dev->model) {
 		case TM6010_BOARD_HAUPPAUGE_900H:
+		case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
 			ctl.fname = "xc3028L-v36.fw";
 			break;
 		default:
@@ -402,6 +423,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 		}
 #endif
 	}
+	return 0;
 
 err2:
 	v4l2_device_unregister(&dev->v4l2_dev);
@@ -465,7 +487,7 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 	}
 
 	/* Create and initialize dev struct */
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(*(dev)), GFP_KERNEL);
 	if (dev == NULL) {
 		printk ("tm6000" ": out of memory!\n");
 		usb_put_dev(usbdev);
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index d41af1d..74f9348 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -394,7 +394,15 @@ struct reg_init tm6010_init_tab[] = {
 	{ REQ_07_SET_GET_AVREG, 0x3f, 0x00 },
 
 	{ REQ_05_SET_GET_USBREG, 0x18, 0x00 },
-
+	
+	/* additional from Terratec Cinergy Hybrid XE */
+	{ REQ_07_SET_GET_AVREG, 0xdc, 0xaa },
+	{ REQ_07_SET_GET_AVREG, 0xdd, 0x30 },
+	{ REQ_07_SET_GET_AVREG, 0xde, 0x20 },
+	{ REQ_07_SET_GET_AVREG, 0xdf, 0xd0 },
+	{ REQ_04_EN_DISABLE_MCU_INT, 0x02, 0x00 },
+	{ REQ_07_SET_GET_AVREG, 0xd8, 0x2f },
+	
 	/* set remote wakeup key:any key wakeup */
 	{ REQ_07_SET_GET_AVREG,  0xe5,  0xfe },
 	{ REQ_07_SET_GET_AVREG,  0xda,  0xff },
@@ -404,6 +412,7 @@ int tm6000_init (struct tm6000_core *dev)
 {
 	int board, rc=0, i, size;
 	struct reg_init *tab;
+	u8 buf[40];
 
 	if (dev->dev_type == TM6010) {
 		tab = tm6010_init_tab;
@@ -424,61 +433,129 @@ int tm6000_init (struct tm6000_core *dev)
 		}
 	}
 
-	msleep(5); /* Just to be conservative */
-
-	/* Check board version - maybe 10Moons specific */
-	board=tm6000_get_reg16 (dev, 0x40, 0, 0);
-	if (board >=0) {
-		printk (KERN_INFO "Board version = 0x%04x\n",board);
-	} else {
-		printk (KERN_ERR "Error %i while retrieving board version\n",board);
-	}
-
+	/* hack */
 	if (dev->dev_type == TM6010) {
-		/* Turn xceive 3028 on */
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_3, 0x01);
-		msleep(11);
-	}
-
-	/* Reset GPIO1 and GPIO4. */
-	for (i=0; i< 2; i++) {
-		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					dev->tuner_reset_gpio, 0x00);
-		if (rc<0) {
-			printk (KERN_ERR "Error %i doing GPIO1 reset\n",rc);
-			return rc;
-		}
-
-		msleep(10); /* Just to be conservative */
-		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-					dev->tuner_reset_gpio, 0x01);
-		if (rc<0) {
-			printk (KERN_ERR "Error %i doing GPIO1 reset\n",rc);
-			return rc;
-		}
-
-		msleep(10);
-		rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 0);
-		if (rc<0) {
-			printk (KERN_ERR "Error %i doing GPIO4 reset\n",rc);
-			return rc;
-		}
-
-		msleep(10);
-		rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 1);
-		if (rc<0) {
-			printk (KERN_ERR "Error %i doing GPIO4 reset\n",rc);
-			return rc;
-		}
-
-		if (!i) {
-			rc=tm6000_get_reg16(dev, 0x40,0,0);
-			if (rc>=0) {
-				printk ("board=%d\n", rc);
+		
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_4, 0);
+		msleep(15);
+				
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_1, 0);
+	
+		msleep(50);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_1, 1);
+		
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x0e, 0x0010, 0x4400, buf, 2);
+		
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x10, 0xf432, 0x0000, buf, 2);
+	
+		msleep(15);
+		buf[0] = 0x12;
+		buf[1] = 0x34;
+		tm6000_read_write_usb (dev, 0x40, 0x10, 0xf432, 0x0000, buf, 2);
+	
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x10, 0xf432, 0x0000, buf, 2);
+	
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x10, 0x0032, 0x0000, buf, 2);
+
+		msleep(15);
+		buf[0] = 0x00;
+		buf[1] = 0x01;
+		tm6000_read_write_usb (dev, 0x40, 0x10, 0xf332, 0x0000, buf, 2);
+	
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x10, 0x00c0, 0x0000, buf, 39);
+	
+		msleep(15);
+		buf[0] = 0x00;
+		buf[1] = 0x00;
+		tm6000_read_write_usb (dev, 0x40, 0x10, 0xf332, 0x0000, buf, 2);
+	
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x10, 0x7f1f, 0x0000, buf, 2);
+//		printk(KERN_INFO "buf %#x %#x \n", buf[0], buf [1]);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_4, 1);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+	    			TM6010_GPIO_0, 1);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_7, 0);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_5, 1);
+	
+		msleep(15);
+	
+		for (i=0; i< size; i++) {
+			rc= tm6000_set_reg (dev, tab[i].req, tab[i].reg, tab[i].val);
+			if (rc<0) {
+				printk (KERN_ERR "Error %i while setting req %d, "
+						 "reg %d to value %d\n", rc,
+						 tab[i].req,tab[i].reg, tab[i].val);
+				return rc;
 			}
 		}
+			
+		msleep(15);
+	
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_4, 0);
+		msleep(15);
+
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_1, 0);
+	
+		msleep(50);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_1, 1);
+		
+		msleep(15);
+		tm6000_read_write_usb (dev, 0xc0, 0x0e, 0x00c2, 0x0008, buf, 2);
+//		printk(KERN_INFO "buf %#x %#x \n", buf[0], buf[1]);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_2, 1);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_2, 0);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_2, 1);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_2, 1);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_2, 0);
+		msleep(15);
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				TM6010_GPIO_2, 1);
+		msleep(15);
 	}
+	/* hack end */
+	
+	msleep(5); /* Just to be conservative */
 
+	/* Check board version - maybe 10Moons specific */
+	if (dev->dev_type == TM5600) {
+		 board=tm6000_get_reg16 (dev, 0x40, 0, 0);
+		if (board >=0) {
+			printk (KERN_INFO "Board version = 0x%04x\n",board);
+		} else {
+			printk (KERN_ERR "Error %i while retrieving board version\n",board);
+		}
+	}
+	
 	msleep(50);
 
 	return 0;
diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index e900d6d..2059a26 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -30,7 +30,11 @@
 
 #include "tuner-xc2028.h"
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
+static void tm6000_urb_received(struct urb *urb, struct pt_regs *ptregs)
+#else
 static void tm6000_urb_received(struct urb *urb)
+#endif
 {
 	int ret;
 	struct tm6000_core* dev = urb->context;
@@ -191,13 +195,16 @@ int tm6000_dvb_attach_frontend(struct tm6000_core *dev)
 
 	if(dev->caps.has_zl10353) {
 		struct zl10353_config config =
-				    {.demod_address = dev->demod_addr >> 1,
+				    {.demod_address = dev->demod_addr,
 				     .no_tuner = 1,
+				     .parallel_ts = 1,
+				     .if2 = 45600,
 // 				     .input_frequency = 0x19e9,
 // 				     .r56_agc_targets =  0x1c,
 				    };
 
-		dvb->frontend = pseudo_zl10353_attach(dev, &config,
+//		dvb->frontend = pseudo_zl10353_attach(dev, &config,
+		dvb->frontend = dvb_attach (zl10353_attach, &config,
 							   &dev->i2c_adap);
 	}
 	else {
diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 4da10f5..9653f00 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -86,6 +86,13 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 				msgs[i].len == 1 ? 0 : msgs[i].buf[1],
 				msgs[i + 1].buf, msgs[i + 1].len);
 			i++;
+			msleep(15);
+			if ((dev->dev_type == TM6010) && (addr == 0xc2)) {
+				tm6000_set_reg(dev, 0x32, 0,0);
+				msleep(10);
+				tm6000_set_reg(dev, 0x33, 0,0);
+				msleep(10);
+			}
 			if (i2c_debug >= 2)
 				for (byte = 0; byte < msgs[i].len; byte++)
 					printk(" %02x", msgs[i].buf[byte]);
@@ -99,6 +106,13 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 				REQ_16_SET_GET_I2C_WR1_RDN,
 				addr | msgs[i].buf[0] << 8, 0,
 				msgs[i].buf + 1, msgs[i].len - 1);
+			msleep(15);
+			if ((dev->dev_type == TM6010) && (addr == 0xc2)) {
+				tm6000_set_reg(dev, 0x32, 0,0);
+				msleep(10);
+				tm6000_set_reg(dev, 0x33, 0,0);
+				msleep(10);
+			}
 		}
 		if (i2c_debug >= 2)
 			printk("\n");
@@ -198,7 +212,7 @@ static struct i2c_algorithm tm6000_algo = {
 
 static struct i2c_adapter tm6000_adap_template = {
 	.owner = THIS_MODULE,
-	.class = I2C_CLASS_TV_ANALOG,
+	.class = I2C_CLASS_TV_ANALOG | I2C_CLASS_TV_DIGITAL,
 	.name = "tm6000",
 	.id = I2C_HW_B_TM6000,
 	.algo = &tm6000_algo,

--------------010006010705000401080105
Content-Type: text/plain;
 name="messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="messages"

Jan 14 17:06:47 linux-v5dy kernel: [  201.202647] tm6000 v4l2 driver version 0.0.1 loaded
Jan 14 17:06:47 linux-v5dy kernel: [  201.202709] tm6000 1-9:1.0: usb_probe_interface
Jan 14 17:06:47 linux-v5dy kernel: [  201.202715] tm6000 1-9:1.0: usb_probe_interface - got id
Jan 14 17:06:47 linux-v5dy kernel: [  201.203769] tm6000: alt 0, interface 0, class 255
Jan 14 17:06:47 linux-v5dy kernel: [  201.203774] tm6000: alt 0, interface 0, class 255
Jan 14 17:06:47 linux-v5dy kernel: [  201.203779] tm6000: Bulk IN endpoint: 0x82 (max size=512 bytes)
Jan 14 17:06:47 linux-v5dy kernel: [  201.203783] tm6000: alt 0, interface 0, class 255
Jan 14 17:06:47 linux-v5dy kernel: [  201.203786] tm6000: alt 1, interface 0, class 255
Jan 14 17:06:47 linux-v5dy kernel: [  201.203791] tm6000: ISOC IN endpoint: 0x81 (max size=3072 bytes)
Jan 14 17:06:47 linux-v5dy kernel: [  201.203795] tm6000: alt 1, interface 0, class 255
Jan 14 17:06:47 linux-v5dy kernel: [  201.203799] tm6000: alt 1, interface 0, class 255
Jan 14 17:06:47 linux-v5dy kernel: [  201.203803] tm6000: alt 2, interface 0, class 255
Jan 14 17:06:47 linux-v5dy kernel: [  201.203807] tm6000: alt 2, interface 0, class 255
Jan 14 17:06:47 linux-v5dy kernel: [  201.203811] tm6000: alt 2, interface 0, class 255
Jan 14 17:06:47 linux-v5dy kernel: [  201.203815] tm6000: alt 3, interface 0, class 255
Jan 14 17:06:47 linux-v5dy kernel: [  201.203819] tm6000: alt 3, interface 0, class 255
Jan 14 17:06:47 linux-v5dy kernel: [  201.203823] tm6000: alt 3, interface 0, class 255
Jan 14 17:06:47 linux-v5dy kernel: [  201.203827] tm6000: New video device @ 480 Mbps (0ccd:0086, ifnum 0)
Jan 14 17:06:47 linux-v5dy kernel: [  201.203831] tm6000: Found Terratec Cinergy Hybrid XE
Jan 14 17:06:49 linux-v5dy kernel: [  203.033030] tm6000 #0: i2c eeprom 00: 42 59 54 45 12 01 00 02 00 00 00 40 cd 0c 86 00  BYTE.......@....
Jan 14 17:06:49 linux-v5dy kernel: [  203.145028] tm6000 #0: i2c eeprom 10: 01 00 10 20 40 01 02 03 48 79 62 72 69 64 2d 55  ... @...Hybrid-U
Jan 14 17:06:50 linux-v5dy kernel: [  203.257031] tm6000 #0: i2c eeprom 20: 53 42 ff ff ff ff ff ff ff ff ff ff ff ff ff ff  SB..............
Jan 14 17:06:50 linux-v5dy kernel: [  203.369028] tm6000 #0: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
Jan 14 17:06:50 linux-v5dy kernel: [  203.481030] tm6000 #0: i2c eeprom 40: 24 00 43 00 69 00 6e 00 65 00 72 00 67 00 79 00  $.C.i.n.e.r.g.y.
Jan 14 17:06:50 linux-v5dy kernel: [  203.593030] tm6000 #0: i2c eeprom 50: 20 00 48 00 79 00 62 00 72 00 69 00 64 00 20 00   .H.y.b.r.i.d. .
Jan 14 17:06:50 linux-v5dy kernel: [  203.705023] tm6000 #0: i2c eeprom 60: 58 00 45 00 ff ff ff ff ff ff 08 03 32 00 2e 00  X.E.........2...
Jan 14 17:06:50 linux-v5dy kernel: [  203.817027] tm6000 #0: i2c eeprom 70: 30 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff  0...............
Jan 14 17:06:50 linux-v5dy kernel: [  203.929035] tm6000 #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
Jan 14 17:06:50 linux-v5dy kernel: [  204.041028] tm6000 #0: i2c eeprom 90: ff ff ff ff 1a 03 30 00 30 00 30 00 38 00 43 00  ......0.0.0.8.C.
Jan 14 17:06:50 linux-v5dy kernel: [  204.153027] tm6000 #0: i2c eeprom a0: 41 00 31 00 32 00 33 00 34 00 35 00 36 00 ff ff  A.1.2.3.4.5.6...
Jan 14 17:06:51 linux-v5dy kernel: [  204.266028] tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
Jan 14 17:06:51 linux-v5dy kernel: [  204.378029] tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
Jan 14 17:06:51 linux-v5dy kernel: [  204.490027] tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
Jan 14 17:06:51 linux-v5dy kernel: [  204.602028] tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
Jan 14 17:06:51 linux-v5dy kernel: [  204.714027] tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
Jan 14 17:06:51 linux-v5dy kernel: [  204.819028]   ................
Jan 14 17:06:51 linux-v5dy kernel: [  204.820589] Trident TVMaster TM5600/TM6000 USB2 board (Load status: 0)
Jan 14 17:06:51 linux-v5dy kernel: [  204.821610] tm6000: open called (dev=video1)
Jan 14 17:06:51 linux-v5dy kernel: [  204.840330] tuner 9-0061: Setting mode_mask to 0x0e
Jan 14 17:06:51 linux-v5dy kernel: [  204.840338] tuner 9-0061: chip found @ 0xc2 (tm6000 #0)
Jan 14 17:06:51 linux-v5dy kernel: [  204.840344] tuner 9-0061: tuner 0x61: Tuner type absent
Jan 14 17:06:51 linux-v5dy kernel: [  204.840355] tuner 9-0061: Calling set_type_addr for type=71, addr=0x61, mode=0x06, config=0x00
Jan 14 17:06:51 linux-v5dy kernel: [  204.840360] tuner 9-0061: defining GPIO callback
Jan 14 17:06:51 linux-v5dy kernel: [  204.840686] xc2028: Xcv2028/3028 init called!
Jan 14 17:06:51 linux-v5dy kernel: [  204.840691] xc2028 9-0061: creating new instance
Jan 14 17:06:51 linux-v5dy kernel: [  204.840697] xc2028 9-0061: type set to XCeive xc2028/xc3028 tuner
Jan 14 17:06:51 linux-v5dy kernel: [  204.840702] tuner 9-0061: type set to Xceive XC3028
Jan 14 17:06:51 linux-v5dy kernel: [  204.840708] tuner 9-0061: tm6000 #0 tuner I2C addr 0xc2 with type 71 used for 0x0e
Jan 14 17:06:51 linux-v5dy kernel: [  204.840713] Setting firmware parameters for xc2028
Jan 14 17:06:51 linux-v5dy kernel: [  204.840718] xc2028 9-0061: xc2028_set_config called
Jan 14 17:06:51 linux-v5dy kernel: [  204.840724] tuner 9-0061: switching to v4l2
Jan 14 17:06:51 linux-v5dy kernel: [  204.840729] tuner 9-0061: tv freq set to 400.00
Jan 14 17:06:51 linux-v5dy kernel: [  204.840734] xc2028 9-0061: xc2028_set_analog_freq called
Jan 14 17:06:51 linux-v5dy kernel: [  204.840740] xc2028 9-0061: generic_set_freq called
Jan 14 17:06:51 linux-v5dy kernel: [  204.840745] xc2028 9-0061: should set frequency 400000 kHz
Jan 14 17:06:51 linux-v5dy kernel: [  204.840749] xc2028 9-0061: check_firmware called
Jan 14 17:06:51 linux-v5dy kernel: [  204.840753] xc2028 9-0061: load_all_firmwares called
Jan 14 17:06:51 linux-v5dy kernel: [  204.840758] xc2028 9-0061: Reading firmware xc3028L-v36.fw
Jan 14 17:06:51 linux-v5dy kernel: [  204.840764] usb 1-9: firmware: requesting xc3028L-v36.fw
Jan 14 17:06:51 linux-v5dy kernel: [  204.884546] xc2028 9-0061: Loading 81 firmware images from xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
Jan 14 17:06:51 linux-v5dy kernel: [  204.884568] xc2028 9-0061: Reading firmware type BASE F8MHZ (3), id 0, size=9144.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884599] xc2028 9-0061: Reading firmware type BASE F8MHZ MTS (7), id 0, size=9030.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884627] xc2028 9-0061: Reading firmware type BASE FM (401), id 0, size=9054.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884653] xc2028 9-0061: Reading firmware type BASE FM INPUT1 (c01), id 0, size=9068.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884679] xc2028 9-0061: Reading firmware type BASE (1), id 0, size=9132.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884705] xc2028 9-0061: Reading firmware type BASE MTS (5), id 0, size=9006.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884720] xc2028 9-0061: Reading firmware type (0), id 7, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884726] xc2028 9-0061: Reading firmware type MTS (4), id 7, size=169.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884733] xc2028 9-0061: Reading firmware type (0), id 7, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884739] xc2028 9-0061: Reading firmware type MTS (4), id 7, size=169.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884746] xc2028 9-0061: Reading firmware type (0), id 7, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884751] xc2028 9-0061: Reading firmware type MTS (4), id 7, size=169.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884758] xc2028 9-0061: Reading firmware type (0), id 7, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884764] xc2028 9-0061: Reading firmware type MTS (4), id 7, size=169.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884770] xc2028 9-0061: Reading firmware type (0), id e0, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884776] xc2028 9-0061: Reading firmware type MTS (4), id e0, size=169.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884783] xc2028 9-0061: Reading firmware type (0), id e0, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884789] xc2028 9-0061: Reading firmware type MTS (4), id e0, size=169.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884795] xc2028 9-0061: Reading firmware type (0), id 200000, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884801] xc2028 9-0061: Reading firmware type MTS (4), id 200000, size=169.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884808] xc2028 9-0061: Reading firmware type (0), id 4000000, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884814] xc2028 9-0061: Reading firmware type MTS (4), id 4000000, size=169.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884826] xc2028 9-0061: Reading firmware type D2633 DTV6 ATSC (10030), id 0, size=149.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884834] xc2028 9-0061: Reading firmware type D2620 DTV6 QAM (68), id 0, size=149.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884842] xc2028 9-0061: Reading firmware type D2633 DTV6 QAM (70), id 0, size=149.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884850] xc2028 9-0061: Reading firmware type D2620 DTV7 (88), id 0, size=149.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884858] xc2028 9-0061: Reading firmware type D2633 DTV7 (90), id 0, size=149.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884865] xc2028 9-0061: Reading firmware type D2620 DTV78 (108), id 0, size=149.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884872] xc2028 9-0061: Reading firmware type D2633 DTV78 (110), id 0, size=149.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884880] xc2028 9-0061: Reading firmware type D2620 DTV8 (208), id 0, size=149.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884887] xc2028 9-0061: Reading firmware type D2633 DTV8 (210), id 0, size=149.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884895] xc2028 9-0061: Reading firmware type FM (400), id 0, size=135.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884901] xc2028 9-0061: Reading firmware type (0), id 10, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884907] xc2028 9-0061: Reading firmware type MTS (4), id 10, size=169.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884914] xc2028 9-0061: Reading firmware type (0), id 400000, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884920] xc2028 9-0061: Reading firmware type (0), id 800000, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884926] xc2028 9-0061: Reading firmware type (0), id 8000, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884933] xc2028 9-0061: Reading firmware type LCD (1000), id 8000, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884940] xc2028 9-0061: Reading firmware type LCD NOGD (3000), id 8000, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884947] xc2028 9-0061: Reading firmware type MTS (4), id 8000, size=169.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884954] xc2028 9-0061: Reading firmware type (0), id b700, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884960] xc2028 9-0061: Reading firmware type LCD (1000), id b700, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884969] xc2028 9-0061: Reading firmware type LCD NOGD (3000), id b700, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884977] xc2028 9-0061: Reading firmware type (0), id 2000, size=161.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884983] xc2028 9-0061: Reading firmware type MTS (4), id b700, size=169.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884989] xc2028 9-0061: Reading firmware type MTS LCD (1004), id b700, size=169.
Jan 14 17:06:51 linux-v5dy kernel: [  204.884997] xc2028 9-0061: Reading firmware type MTS LCD NOGD (3004), id b700, size=169.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885037] xc2028 9-0061: Reading firmware type SCODE HAS_IF_3280 (60000000), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885045] xc2028 9-0061: Reading firmware type SCODE HAS_IF_3300 (60000000), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885053] xc2028 9-0061: Reading firmware type SCODE HAS_IF_3440 (60000000), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885061] xc2028 9-0061: Reading firmware type SCODE HAS_IF_3460 (60000000), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885069] xc2028 9-0061: Reading firmware type DTV6 ATSC OREN36 SCODE HAS_IF_3800 (60210020), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885080] xc2028 9-0061: Reading firmware type SCODE HAS_IF_4000 (60000000), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885088] xc2028 9-0061: Reading firmware type DTV6 ATSC TOYOTA388 SCODE HAS_IF_4080 (60410020), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885098] xc2028 9-0061: Reading firmware type SCODE HAS_IF_4200 (60000000), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885106] xc2028 9-0061: Reading firmware type MONO SCODE HAS_IF_4320 (60008000), id 8000, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885119] xc2028 9-0061: Reading firmware type SCODE HAS_IF_4450 (60000000), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885131] xc2028 9-0061: Reading firmware type MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id b700, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885143] xc2028 9-0061: Reading firmware type DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4560 (62000300), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885169] xc2028 9-0061: Reading firmware type LCD NOGD IF SCODE HAS_IF_4600 (60023000), id 8000, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885194] xc2028 9-0061: Reading firmware type DTV6 QAM DTV7 ZARLINK456 SCODE HAS_IF_4760 (620000e0), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885222] xc2028 9-0061: Reading firmware type SCODE HAS_IF_4940 (60000000), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885241] xc2028 9-0061: Reading firmware type DTV78 DTV8 DIBCOM52 SCODE HAS_IF_5200 (61000300), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885267] xc2028 9-0061: Reading firmware type SCODE HAS_IF_5260 (60000000), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885284] xc2028 9-0061: Reading firmware type MONO SCODE HAS_IF_5320 (60008000), id 7, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885304] xc2028 9-0061: Reading firmware type DTV7 DTV8 DIBCOM52 CHINA SCODE HAS_IF_5400 (65000280), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885332] xc2028 9-0061: Reading firmware type DTV6 ATSC OREN538 SCODE HAS_IF_5580 (60110020), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885358] xc2028 9-0061: Reading firmware type SCODE HAS_IF_5640 (60000000), id 7, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885375] xc2028 9-0061: Reading firmware type SCODE HAS_IF_5740 (60000000), id 7, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885393] xc2028 9-0061: Reading firmware type SCODE HAS_IF_5900 (60000000), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885410] xc2028 9-0061: Reading firmware type MONO SCODE HAS_IF_6000 (60008000), id 4c000f0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885431] xc2028 9-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ SCODE HAS_IF_6200 (68050060), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885461] xc2028 9-0061: Reading firmware type SCODE HAS_IF_6240 (60000000), id 10, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885478] xc2028 9-0061: Reading firmware type MONO SCODE HAS_IF_6320 (60008000), id 200000, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885499] xc2028 9-0061: Reading firmware type SCODE HAS_IF_6340 (60000000), id 200000, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885517] xc2028 9-0061: Reading firmware type MONO SCODE HAS_IF_6500 (60008000), id 40000e0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885538] xc2028 9-0061: Reading firmware type DTV6 ATSC ATI638 SCODE HAS_IF_6580 (60090020), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885563] xc2028 9-0061: Reading firmware type SCODE HAS_IF_6600 (60000000), id e0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885580] xc2028 9-0061: Reading firmware type MONO SCODE HAS_IF_6680 (60008000), id e0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885600] xc2028 9-0061: Reading firmware type DTV6 ATSC TOYOTA794 SCODE HAS_IF_8140 (60810020), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885625] xc2028 9-0061: Reading firmware type SCODE HAS_IF_8200 (60000000), id 0, size=192.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885651] xc2028 9-0061: Firmware files loaded.
Jan 14 17:06:51 linux-v5dy kernel: [  204.885658] xc2028 9-0061: checking firmware, user requested type=MTS (4), id 0000000000000100, scode_tbl (0), scode_nr 0
Jan 14 17:06:51 linux-v5dy kernel: [  205.160048] xc2028 9-0061: load_firmware called
Jan 14 17:06:51 linux-v5dy kernel: [  205.160055] xc2028 9-0061: seek_firmware called, want type=BASE MTS (5), id 0000000000000000.
Jan 14 17:06:51 linux-v5dy kernel: [  205.160064] xc2028 9-0061: Found firmware for type=BASE MTS (5), id 0000000000000000.
Jan 14 17:06:51 linux-v5dy kernel: [  205.160072] xc2028 9-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
Jan 14 17:06:52 linux-v5dy kernel: [  205.434029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 02 19 e0 00 07 f5 d4 00 c4 f0 d6 ae
Jan 14 17:06:52 linux-v5dy kernel: [  205.503026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c6 10 d5 f5 c5 7a e0 04 07 d8 d4 01
Jan 14 17:06:52 linux-v5dy kernel: [  205.573025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c4 f0 d6 51 c6 02 d5 99 c5 a3 e0 04
Jan 14 17:06:52 linux-v5dy kernel: [  205.643035] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d4 03 c4 f0 d6 04 d5 87 c5 06
Jan 14 17:06:52 linux-v5dy kernel: [  205.713029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 04 07 d8 d4 04 c4 f0 d6 00 d5 1f
Jan 14 17:06:52 linux-v5dy kernel: [  205.783027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c5 2c e0 04 07 d8 d4 05 c4 f0 d6 00
Jan 14 17:06:52 linux-v5dy kernel: [  205.853028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c6 06 d5 00 c5 40 e0 04 07 d8 d4 06
Jan 14 17:06:52 linux-v5dy kernel: [  205.923027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c4 f0 d6 80 d5 cd c5 20 e0 04 07 d8
Jan 14 17:06:52 linux-v5dy kernel: [  205.993025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d4 07 c4 f0 d6 00 c6 c0 d5 05 c5 2f
Jan 14 17:06:52 linux-v5dy kernel: [  206.063027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 04 07 d8 d4 09 c4 f0 d6 c0 c6 42
Jan 14 17:06:52 linux-v5dy kernel: [  206.133027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 67 c5 3c e0 04 07 d8 d4 0f c4 f0
Jan 14 17:06:52 linux-v5dy kernel: [  206.203029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d6 3f c6 c0 d5 11 c5 11 e0 04 07 d8
Jan 14 17:06:53 linux-v5dy kernel: [  206.273025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d4 06 c4 f0 d6 00 c6 24 d5 0e c5 2e
Jan 14 17:06:53 linux-v5dy kernel: [  206.343026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 04 07 d8 d4 ff c4 ff f4 09 d4 0f
Jan 14 17:06:53 linux-v5dy kernel: [  206.413027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c4 70 e0 04 07 e7 86 69 86 69 a2 61
Jan 14 17:06:53 linux-v5dy kernel: [  206.483025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d4 06 c4 f0 d6 00 c6 24 d5 c0 c5 20
Jan 14 17:06:53 linux-v5dy kernel: [  206.553025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 04 07 d8 d4 ff c4 ff f4 09 d4 0f
Jan 14 17:06:53 linux-v5dy kernel: [  206.623039] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c4 70 e0 04 07 e7 86 69 86 69 12 62
Jan 14 17:06:53 linux-v5dy kernel: [  206.693026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 98 21 f8 05 02 88 f2 0d d8 80 4c 28
Jan 14 17:06:53 linux-v5dy kernel: [  206.763025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f8 05 02 94 e0 00 07 82 d4 0e c4 f0
Jan 14 17:06:53 linux-v5dy kernel: [  206.833025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d6 00 d5 00 e0 04 07 d8 d0 01 c0 70
Jan 14 17:06:53 linux-v5dy kernel: [  206.903028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 00 07 e7 d3 0f 71 23 f1 01 04 7f
Jan 14 17:06:53 linux-v5dy kernel: [  206.973025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d0 60 d1 00 c1 40 d2 0b 00 02 f0 1c
Jan 14 17:06:53 linux-v5dy kernel: [  207.043025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a0 03 d1 00 f0 1c d0 01 d1 03 d2 03
Jan 14 17:06:53 linux-v5dy kernel: [  207.113025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 e0 00 07 bf d4 9e a4 45 d5 10
Jan 14 17:06:53 linux-v5dy kernel: [  207.183025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c5 01 f4 5c d5 40 c5 0b a4 43 f4 5c
Jan 14 17:06:54 linux-v5dy kernel: [  207.253025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 00 c3 f0 d5 d6 d4 00 e0 03 07 d8
Jan 14 17:06:54 linux-v5dy kernel: [  207.323026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 f0 d5 03 c5 19 d4 01 e0 03
Jan 14 17:06:54 linux-v5dy kernel: [  207.393025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d3 03 c3 f0 d5 00 d4 00 e0 03
Jan 14 17:06:54 linux-v5dy kernel: [  207.463025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d3 04 c3 f0 d5 00 d4 00 e0 03
Jan 14 17:06:54 linux-v5dy kernel: [  207.533025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d3 05 c3 f0 d5 00 d4 00 e0 03
Jan 14 17:06:54 linux-v5dy kernel: [  207.603032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d3 06 c3 f0 d5 00 d4 00 e0 03
Jan 14 17:06:54 linux-v5dy kernel: [  207.673025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d3 07 c3 f0 d5 00 d4 00 e0 03
Jan 14 17:06:54 linux-v5dy kernel: [  207.743027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d3 09 c3 f0 d5 00 d4 00 e0 03
Jan 14 17:06:54 linux-v5dy kernel: [  207.813026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d3 0e c3 f0 d5 00 d4 00 e0 03
Jan 14 17:06:54 linux-v5dy kernel: [  207.883025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d3 0f c3 f0 d5 00 d4 00 e0 03
Jan 14 17:06:54 linux-v5dy kernel: [  207.953025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d6 14 f6 09 d0 ff c0 03 d1 54
Jan 14 17:06:54 linux-v5dy kernel: [  208.023025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 f0 d5 03 c5 99 d4 01 c4 f0
Jan 14 17:06:54 linux-v5dy kernel: [  208.093025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 03 07 d8 d6 14 f6 09 d3 01 c3 70
Jan 14 17:06:54 linux-v5dy kernel: [  208.163027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 03 07 e7 2c c0 84 46 d2 00 c2 42
Jan 14 17:06:55 linux-v5dy kernel: [  208.233026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 34 42 f5 18 e0 04 05 c9 f1 4c a1 13
Jan 14 17:06:55 linux-v5dy kernel: [  208.303025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 00 c5 19 d4 01 d3 01 c3 f0 e0 03
Jan 14 17:06:55 linux-v5dy kernel: [  208.373034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d6 14 f6 09 d5 00 c5 99 d4 01
Jan 14 17:06:55 linux-v5dy kernel: [  208.443026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 f0 e0 03 07 d8 d6 14 f6 09
Jan 14 17:06:55 linux-v5dy kernel: [  208.513025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 70 e0 03 07 e7 2c c0 84 46
Jan 14 17:06:55 linux-v5dy kernel: [  208.583032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d2 00 c2 40 34 42 f5 18 e0 04 05 c9
Jan 14 17:06:55 linux-v5dy kernel: [  208.653033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f1 4c a1 13 d5 23 c5 19 d4 02 c4 f0
Jan 14 17:06:55 linux-v5dy kernel: [  208.723027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 f0 e0 03 07 d8 d6 14 f6 09
Jan 14 17:06:55 linux-v5dy kernel: [  208.793026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 23 c5 99 d4 02 c4 f0 d3 01 c3 f0
Jan 14 17:06:55 linux-v5dy kernel: [  208.863026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 03 07 d8 d6 14 f6 09 d3 01 c3 70
Jan 14 17:06:55 linux-v5dy kernel: [  208.933025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 03 07 e7 2c c0 84 46 d2 00 c2 42
Jan 14 17:06:55 linux-v5dy kernel: [  209.003025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 34 42 f5 18 e0 04 05 c9 f1 4c a1 13
Jan 14 17:06:55 linux-v5dy kernel: [  209.073025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 20 c5 19 d4 02 d3 01 c3 f0 e0 03
Jan 14 17:06:55 linux-v5dy kernel: [  209.143025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d6 14 f6 09 d5 20 c5 99 d4 02
Jan 14 17:06:55 linux-v5dy kernel: [  209.213025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 f0 e0 03 07 d8 d6 14 f6 09
Jan 14 17:06:56 linux-v5dy kernel: [  209.283028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 70 e0 03 07 e7 2c c0 84 46
Jan 14 17:06:56 linux-v5dy kernel: [  209.353033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d2 00 c2 42 34 42 f5 18 e0 04 05 c9
Jan 14 17:06:56 linux-v5dy kernel: [  209.423026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f1 4c a1 13 d5 23 c5 19 d4 03 c4 f0
Jan 14 17:06:56 linux-v5dy kernel: [  209.493025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 f0 e0 03 07 d8 d6 14 f6 09
Jan 14 17:06:56 linux-v5dy kernel: [  209.563025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 23 c5 99 d4 03 c4 f0 d3 01 c3 f0
Jan 14 17:06:56 linux-v5dy kernel: [  209.633026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 03 07 d8 d6 14 f6 09 d3 01 c3 70
Jan 14 17:06:56 linux-v5dy kernel: [  209.703028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 03 07 e7 2c c0 84 46 d2 00 c2 42
Jan 14 17:06:56 linux-v5dy kernel: [  209.773025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 34 42 f5 18 e0 04 05 c9 f1 4c a1 13
Jan 14 17:06:56 linux-v5dy kernel: [  209.843026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 20 c5 19 d4 03 d3 01 c3 f0 e0 03
Jan 14 17:06:56 linux-v5dy kernel: [  209.913026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d6 14 f6 09 d5 20 c5 99 d4 03
Jan 14 17:06:56 linux-v5dy kernel: [  209.983026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 f0 e0 03 07 d8 d6 14 f6 09
Jan 14 17:06:56 linux-v5dy kernel: [  210.053026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 70 e0 03 07 e7 2c c0 84 46
Jan 14 17:06:56 linux-v5dy kernel: [  210.123026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d2 00 c2 42 34 42 f5 18 e0 04 05 c9
Jan 14 17:06:56 linux-v5dy kernel: [  210.193027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f1 4c a1 13 d5 23 c5 19 d4 04 c4 f0
Jan 14 17:06:57 linux-v5dy kernel: [  210.263028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 f0 e0 03 07 d8 d6 14 f6 09
Jan 14 17:06:57 linux-v5dy kernel: [  210.333032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 23 c5 99 d4 04 c4 f0 d3 01 c3 f0
Jan 14 17:06:57 linux-v5dy kernel: [  210.403025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 03 07 d8 d6 14 f6 09 d3 01 c3 70
Jan 14 17:06:57 linux-v5dy kernel: [  210.473026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 03 07 e7 2c c0 84 46 d2 00 c2 42
Jan 14 17:06:57 linux-v5dy kernel: [  210.543025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 34 42 f5 18 e0 04 05 c9 f1 4c a1 13
Jan 14 17:06:57 linux-v5dy kernel: [  210.613026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 20 c5 19 d4 04 d3 01 c3 f0 e0 03
Jan 14 17:06:57 linux-v5dy kernel: [  210.683026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d6 14 f6 09 d5 20 c5 99 d4 04
Jan 14 17:06:57 linux-v5dy kernel: [  210.753025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 f0 e0 03 07 d8 d6 14 f6 09
Jan 14 17:06:57 linux-v5dy kernel: [  210.823025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 70 e0 03 07 e7 2c c0 84 46
Jan 14 17:06:57 linux-v5dy kernel: [  210.893025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d2 00 c2 42 34 42 f5 18 e0 04 05 c9
Jan 14 17:06:57 linux-v5dy kernel: [  210.963025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f1 4c a1 13 d5 23 c5 19 d4 05 c4 f0
Jan 14 17:06:57 linux-v5dy kernel: [  211.033025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 f0 e0 03 07 d8 d6 14 f6 09
Jan 14 17:06:57 linux-v5dy kernel: [  211.103025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 23 c5 99 d4 05 c4 f0 d3 01 c3 f0
Jan 14 17:06:57 linux-v5dy kernel: [  211.173025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 03 07 d8 d6 14 f6 09 d3 01 c3 70
Jan 14 17:06:58 linux-v5dy kernel: [  211.243025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 03 07 e7 2c c0 84 46 d2 00 c2 42
Jan 14 17:06:58 linux-v5dy kernel: [  211.313035] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 34 42 f5 18 e0 04 05 c9 f1 4c a1 13
Jan 14 17:06:58 linux-v5dy kernel: [  211.383025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 20 c5 19 d4 05 d3 01 c3 f0 e0 03
Jan 14 17:06:58 linux-v5dy kernel: [  211.453025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d6 14 f6 09 d5 20 c5 99 d4 05
Jan 14 17:06:58 linux-v5dy kernel: [  211.523025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 f0 e0 03 07 d8 d6 14 f6 09
Jan 14 17:06:58 linux-v5dy kernel: [  211.593027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 70 e0 03 07 e7 2c c0 84 46
Jan 14 17:06:58 linux-v5dy kernel: [  211.663026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d2 00 c2 42 34 42 f5 18 e0 04 05 c9
Jan 14 17:06:58 linux-v5dy kernel: [  211.733026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f1 4c a1 13 d5 23 c5 19 d4 06 c4 f0
Jan 14 17:06:58 linux-v5dy kernel: [  211.803025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 f0 e0 03 07 d8 d6 14 f6 09
Jan 14 17:06:58 linux-v5dy kernel: [  211.873025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 23 c5 99 d4 06 c4 f0 d3 01 c3 f0
Jan 14 17:06:58 linux-v5dy kernel: [  211.943025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 03 07 d8 d6 14 f6 09 d3 01 c3 70
Jan 14 17:06:58 linux-v5dy kernel: [  212.013025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 03 07 e7 2c c0 84 46 d2 00 c2 42
Jan 14 17:06:58 linux-v5dy kernel: [  212.083025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 34 42 f5 18 e0 04 05 c9 f1 4c a1 13
Jan 14 17:06:58 linux-v5dy kernel: [  212.153025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 20 c5 19 d4 06 d3 01 c3 f0 e0 03
Jan 14 17:06:59 linux-v5dy kernel: [  212.223025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 d6 14 f6 09 d5 20 c5 99 d4 06
Jan 14 17:06:59 linux-v5dy kernel: [  212.293036] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 f0 e0 03 07 d8 d6 14 f6 09
Jan 14 17:06:59 linux-v5dy kernel: [  212.363025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 c3 70 e0 03 07 e7 2c c0 84 46
Jan 14 17:06:59 linux-v5dy kernel: [  212.433025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d2 00 c2 42 34 42 f5 18 e0 04 05 c9
Jan 14 17:06:59 linux-v5dy kernel: [  212.503025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f1 4c a1 13 d5 00 d4 00 d3 01 c3 f0
Jan 14 17:06:59 linux-v5dy kernel: [  212.573025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 03 07 d8 ec af d1 54 d2 a0 f1 2c
Jan 14 17:06:59 linux-v5dy kernel: [  212.643025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a1 13 d2 90 c2 01 f1 2c a1 13 d2 44
Jan 14 17:06:59 linux-v5dy kernel: [  212.713028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c2 01 f1 2c a1 13 d2 dc c2 02 f1 2c
Jan 14 17:06:59 linux-v5dy kernel: [  212.783026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a1 13 d2 3c c2 02 f1 2c a1 13 d2 58
Jan 14 17:06:59 linux-v5dy kernel: [  212.853025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c2 04 f1 2c a1 13 d2 2c c2 03 f1 2c
Jan 14 17:06:59 linux-v5dy kernel: [  212.923025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a1 13 d2 3c c2 06 f1 2c a1 13 d2 88
Jan 14 17:06:59 linux-v5dy kernel: [  212.993025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c2 04 f1 2c a1 13 d2 04 c2 09 f1 2c
Jan 14 17:06:59 linux-v5dy kernel: [  213.063025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a1 13 d2 d0 c2 06 f1 2c a1 13 d2 20
Jan 14 17:06:59 linux-v5dy kernel: [  213.133025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c2 0d f1 2c a1 13 d5 0e d6 00 d7 03
Jan 14 17:06:59 linux-v5dy kernel: [  213.203027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d8 0e e0 05 07 bf d5 0f d6 12 d7 14
Jan 14 17:07:00 linux-v5dy kernel: [  213.273031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 05 07 a3 d6 0e d7 0e e0 05 07 a3
Jan 14 17:07:00 linux-v5dy kernel: [  213.343027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 ff c5 ff f5 09 d5 01 c5 80 d6 02
Jan 14 17:07:00 linux-v5dy kernel: [  213.413028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 05 07 d8 d4 0f c4 f0 d5 01 c5 01
Jan 14 17:07:00 linux-v5dy kernel: [  213.483025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d6 30 c6 40 e0 07 07 16 87 7c d8 bc
Jan 14 17:07:00 linux-v5dy kernel: [  213.553025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f8 7c 1e eb e0 04 07 d8 d0 00 d1 16
Jan 14 17:07:00 linux-v5dy kernel: [  213.623025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d2 16 d3 01 e0 00 07 bf d0 01 d1 07
Jan 14 17:07:00 linux-v5dy kernel: [  213.693025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d2 08 d3 00 e0 00 07 bf e0 04 07 a8
Jan 14 17:07:00 linux-v5dy kernel: [  213.763030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d4 00 c4 a0 f4 09 d0 00 e0 00 07 bf
Jan 14 17:07:00 linux-v5dy kernel: [  213.833033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 04 07 a8 d4 0f c4 f0 d5 fe c5 fe
Jan 14 17:07:00 linux-v5dy kernel: [  213.903025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d6 30 c6 40 e0 07 07 16 87 7c 1e eb
Jan 14 17:07:00 linux-v5dy kernel: [  213.973025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 04 07 d8 c6 c0 e0 04 07 d8 d4 ff
Jan 14 17:07:00 linux-v5dy kernel: [  214.043027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c4 ff f4 09 d4 0f c4 70 e0 04 07 e7
Jan 14 17:07:00 linux-v5dy kernel: [  214.113027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a da ff 27 6e 2d 5a 88 5f 88 83 87 78
Jan 14 17:07:00 linux-v5dy kernel: [  214.183027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a da 8e aa a7 fa 7c aa a9 fa 8c aa a9
Jan 14 17:07:01 linux-v5dy kernel: [  214.253033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a fa 9c d4 0f c4 f0 d5 fe c5 fe d6 3f
Jan 14 17:07:01 linux-v5dy kernel: [  214.323025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c6 c0 d6 30 c6 40 e0 07 07 16 87 7c
Jan 14 17:07:01 linux-v5dy kernel: [  214.393087] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 1e eb e0 04 07 d8 d0 01 e0 00 07 bf
Jan 14 17:07:01 linux-v5dy kernel: [  214.463027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d0 01 d1 16 d2 16 d3 01 e0 00 07 bf
Jan 14 17:07:01 linux-v5dy kernel: [  214.533027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 04 07 a8 d2 60 a2 23 f1 28 a2 23
Jan 14 17:07:01 linux-v5dy kernel: [  214.603028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f0 28 d2 00 d4 00 d3 00 d5 04 e0 06
Jan 14 17:07:01 linux-v5dy kernel: [  214.673025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 38 02 26 04 48 03 37 b5 52 f5 05
Jan 14 17:07:01 linux-v5dy kernel: [  214.743025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 05 2f 82 29 84 49 83 39 25 43 24 23
Jan 14 17:07:01 linux-v5dy kernel: [  214.813027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d2 60 a2 23 f2 1c a2 23 f2 0c d7 70
Jan 14 17:07:01 linux-v5dy kernel: [  214.883027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c7 0d a6 41 e0 06 07 1d d6 bd f6 7c
Jan 14 17:07:01 linux-v5dy kernel: [  214.953027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d7 0a c7 0b a6 41 e0 06 07 1d d6 be
Jan 14 17:07:01 linux-v5dy kernel: [  215.023025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f6 7c d7 51 c7 0a a6 41 e0 06 07 1d
Jan 14 17:07:01 linux-v5dy kernel: [  215.093025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d6 bf f6 7c d0 d3 c0 01 d1 e0 c1 01
Jan 14 17:07:01 linux-v5dy kernel: [  215.163027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 32 04 a2 23 82 23 33 15 a3 33 83 33
Jan 14 17:07:02 linux-v5dy kernel: [  215.233036] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d6 80 14 26 26 44 86 6f 18 46 d6 ba
Jan 14 17:07:02 linux-v5dy kernel: [  215.303028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f6 8c d6 80 14 26 26 44 86 6f 18 46
Jan 14 17:07:02 linux-v5dy kernel: [  215.373026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d9 03 29 89 99 9e 98 86 19 89 a9 97
Jan 14 17:07:02 linux-v5dy kernel: [  215.443026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 89 92 a8 90 d6 41 c6 24 f8 01 05 79
Jan 14 17:07:02 linux-v5dy kernel: [  215.513027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 06 69 d8 bb f8 6c d6 80 14 26 26 44
Jan 14 17:07:02 linux-v5dy kernel: [  215.583027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 86 6f 18 46 d9 0c 29 89 99 9e d6 12
Jan 14 17:07:02 linux-v5dy kernel: [  215.653027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 28 86 98 8e 09 89 f9 0d a9 9f a9 9b
Jan 14 17:07:02 linux-v5dy kernel: [  215.723026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d7 0f 4c 97 56 7d 26 96 46 87 d7 08
Jan 14 17:07:02 linux-v5dy kernel: [  215.793026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d8 0b d9 04 e0 06 07 bf d6 80 14 26
Jan 14 17:07:02 linux-v5dy kernel: [  215.863027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 26 44 86 6f 18 46 d9 06 29 89 99 9e
Jan 14 17:07:02 linux-v5dy kernel: [  215.933027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a b9 9c f9 0d d7 0f 4c 97 56 7d 29 96
Jan 14 17:07:02 linux-v5dy kernel: [  216.003035] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 49 87 a7 90 26 97 d7 18 d8 1b d9 05
Jan 14 17:07:02 linux-v5dy kernel: [  216.073026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 06 07 bf d5 0e c5 70 e0 05 07 e7
Jan 14 17:07:02 linux-v5dy kernel: [  216.143025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 87 74 87 7f 87 7f d5 01 f7 01 05 b9
Jan 14 17:07:02 linux-v5dy kernel: [  216.213033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 02 b7 76 f7 01 05 b9 d5 00 d6 0c
Jan 14 17:07:03 linux-v5dy kernel: [  216.283029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d7 0d d8 0e e0 05 07 bf d5 00 d6 0e
Jan 14 17:07:03 linux-v5dy kernel: [  216.353027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d7 0e d8 0e e0 05 07 a3 d6 12 d7 14
Jan 14 17:07:03 linux-v5dy kernel: [  216.423029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 05 07 bf ed d5 d2 00 c2 13 33 12
Jan 14 17:07:03 linux-v5dy kernel: [  216.493025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 04 13 15 13 5c c0 5d 0d 23 cd f3 05
Jan 14 17:07:03 linux-v5dy kernel: [  216.563027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 05 d4 a0 11 f0 02 f0 0e f0 0e e0 00
Jan 14 17:07:03 linux-v5dy kernel: [  216.633027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 f9 e0 00 07 f5 f0 0e ee 36 f0 0a
Jan 14 17:07:03 linux-v5dy kernel: [  216.703027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a fb 08 f9 18 ba 9a b6 62 1c b6 1c 8a
Jan 14 17:07:03 linux-v5dy kernel: [  216.773027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f6 18 f8 01 06 1b fb 01 06 4a b9 92
Jan 14 17:07:03 linux-v5dy kernel: [  216.843025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f9 05 05 ef da 13 f8 28 fa 84 bb b2
Jan 14 17:07:03 linux-v5dy kernel: [  216.913026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a fb 01 06 4a bb b8 fb 01 06 1f d7 00
Jan 14 17:07:03 linux-v5dy kernel: [  216.983035] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c7 94 f7 78 d9 00 c9 ff 19 79 f9 01
Jan 14 17:07:03 linux-v5dy kernel: [  217.053027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 06 4c d7 00 c7 d0 f9 78 d8 00 f7 8c
Jan 14 17:07:03 linux-v5dy kernel: [  217.123027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f9 05 06 1b d8 12 f8 88 f2 8c a8 83
Jan 14 17:07:03 linux-v5dy kernel: [  217.193027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d9 00 f8 9c da 10 fa a8 a8 83 f8 ac
Jan 14 17:07:04 linux-v5dy kernel: [  217.263027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d8 00 d7 00 c7 64 f7 8c d8 11 f8 88
Jan 14 17:07:04 linux-v5dy kernel: [  217.333029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f4 8c d8 00 c8 8c d9 01 f8 9c f0 06
Jan 14 17:07:04 linux-v5dy kernel: [  217.403027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f0 02 d9 13 fa 98 f2 ac ee 0e d8 00
Jan 14 17:07:04 linux-v5dy kernel: [  217.473027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d7 00 c7 60 f7 8c d8 0e f8 88 f4 8c
Jan 14 17:07:04 linux-v5dy kernel: [  217.543025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d8 0f f8 88 f2 8c a8 83 d9 00 f8 9c
Jan 14 17:07:04 linux-v5dy kernel: [  217.613025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a da 0d fa a8 a8 83 f8 ac d8 00 c8 8c
Jan 14 17:07:04 linux-v5dy kernel: [  217.683027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d9 05 f8 9c f0 06 f0 02 d9 00 c9 ac
Jan 14 17:07:04 linux-v5dy kernel: [  217.753027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d8 0c fa 80 f9 ac d9 00 c9 08 d7 00
Jan 14 17:07:04 linux-v5dy kernel: [  217.823027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c7 34 f7 9c c9 38 d7 00 c7 44 f7 9c
Jan 14 17:07:04 linux-v5dy kernel: [  217.893027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c9 20 d7 00 c7 48 f7 9c d8 15 f2 8c
Jan 14 17:07:04 linux-v5dy kernel: [  217.963032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f0 06 ee 4b f0 0a d7 15 d8 00 c8 30
Jan 14 17:07:04 linux-v5dy kernel: [  218.033025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f8 7c d7 00 c7 98 f6 78 d8 1a f8 6c
Jan 14 17:07:04 linux-v5dy kernel: [  218.103027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d8 00 c8 ac da 20 f8 ac d9 20 da 0a
Jan 14 17:07:04 linux-v5dy kernel: [  218.173027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a ca f0 f9 ac a9 93 da 14 ca d7 f9 ac
Jan 14 17:07:05 linux-v5dy kernel: [  218.243033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a9 93 da 11 ca f7 f9 ac a9 93 da 15
Jan 14 17:07:05 linux-v5dy kernel: [  218.313025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a ca d7 f9 ac a9 93 da 00 ca d8 f9 ac
Jan 14 17:07:05 linux-v5dy kernel: [  218.383026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a9 93 da 30 ca c8 f9 ac a9 93 da 7c
Jan 14 17:07:05 linux-v5dy kernel: [  218.453027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a ca f8 f9 ac a9 93 da 00 ca d7 f9 ac
Jan 14 17:07:05 linux-v5dy kernel: [  218.524032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a9 93 da 94 ca c7 f9 ac a9 93 da 78
Jan 14 17:07:05 linux-v5dy kernel: [  218.594030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a ca f7 f9 ac a9 93 da 00 ca d8 f9 ac
Jan 14 17:07:05 linux-v5dy kernel: [  218.664026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a9 93 da 98 ca c8 f9 ac a9 93 da 88
Jan 14 17:07:05 linux-v5dy kernel: [  218.734025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a ca f9 f9 ac a9 93 da 9c ca f8 f9 ac
Jan 14 17:07:05 linux-v5dy kernel: [  218.804027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a9 93 da 00 ca da f9 ac a9 93 da 00
Jan 14 17:07:05 linux-v5dy kernel: [  218.874029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a ca db f9 ac a9 93 da 64 ca cb f9 ac
Jan 14 17:07:05 linux-v5dy kernel: [  218.944033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a9 93 da ac ca fb f9 ac a9 93 da ff
Jan 14 17:07:05 linux-v5dy kernel: [  219.014025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a ca d8 f9 ac a9 93 da 07 ca c8 f9 ac
Jan 14 17:07:05 linux-v5dy kernel: [  219.084025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a9 93 da 6c ca 26 f9 ac a9 93 da 7c
Jan 14 17:07:05 linux-v5dy kernel: [  219.154025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a ca f6 f9 ac a9 93 da 63 ca a6 f9 ac
Jan 14 17:07:06 linux-v5dy kernel: [  219.224027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a9 93 da 6c ca 26 f9 ac a9 93 da 9c
Jan 14 17:07:06 linux-v5dy kernel: [  219.294027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a ca f6 f9 ac a9 93 da 63 ca a6 f9 ac
Jan 14 17:07:06 linux-v5dy kernel: [  219.364026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a9 93 da 15 ca d7 f9 ac a9 93 da 67
Jan 14 17:07:06 linux-v5dy kernel: [  219.434025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a ca 17 f9 ac a9 93 da 01 ca f7 f9 ac
Jan 14 17:07:06 linux-v5dy kernel: [  219.504025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a9 93 da 43 f9 ac a9 93 da 72 ca b7
Jan 14 17:07:06 linux-v5dy kernel: [  219.574026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f9 ac a9 93 da 01 ca f7 f9 ac a9 93
Jan 14 17:07:06 linux-v5dy kernel: [  219.644025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a da 43 f9 ac a9 93 da 06 ca f0 f9 ac
Jan 14 17:07:06 linux-v5dy kernel: [  219.714026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a9 93 da 42 ca e8 f9 ac a9 93 da ec
Jan 14 17:07:06 linux-v5dy kernel: [  219.784026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a ca d7 f9 ac a9 93 da ff ca c7 f9 ac
Jan 14 17:07:06 linux-v5dy kernel: [  219.854025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a9 93 da 11 ca f7 f9 ac a9 93 da ff
Jan 14 17:07:06 linux-v5dy kernel: [  219.924034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a ca ef f9 ac f7 7c d8 00 d7 00 c7 64
Jan 14 17:07:06 linux-v5dy kernel: [  219.994025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f7 8c d7 14 f7 11 ee 4a f0 0e 44 dc
Jan 14 17:07:06 linux-v5dy kernel: [  220.064025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f4 05 07 13 d4 01 7f c4 7c 1c 13 43
Jan 14 17:07:06 linux-v5dy kernel: [  220.134025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 61 13 a2 31 6c cd b2 22 a4 20 f4 05
Jan 14 17:07:06 linux-v5dy kernel: [  220.204027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 06 a1 01 d4 0f 14 43 60 04 70 04
Jan 14 17:07:07 linux-v5dy kernel: [  220.274025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a a4 33 71 14 ef 15 a1 01 d0 00 f0 02
Jan 14 17:07:07 linux-v5dy kernel: [  220.344025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d0 01 c0 70 e0 00 07 e7 d1 0f 70 21
Jan 14 17:07:07 linux-v5dy kernel: [  220.414028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f0 02 83 03 a5 31 d4 58 c4 4f e0 04
Jan 14 17:07:07 linux-v5dy kernel: [  220.484025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 06 fd 22 14 34 15 85 3f e0 04 06 fd
Jan 14 17:07:07 linux-v5dy kernel: [  220.554025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 82 29 82 29 02 24 d1 22 11 12 d6 00
Jan 14 17:07:07 linux-v5dy kernel: [  220.624025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 4f e1 d8 01 17 87 21 17 d6 10 4f e1
Jan 14 17:07:07 linux-v5dy kernel: [  220.694025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f7 05 07 37 d1 1f f0 02 d0 00 d1 02
Jan 14 17:07:07 linux-v5dy kernel: [  220.764025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a e0 00 07 45 d1 00 d2 01 e0 01 07 45
Jan 14 17:07:07 linux-v5dy kernel: [  220.834025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d2 01 d3 02 e0 02 07 45 f0 02 d3 00
Jan 14 17:07:07 linux-v5dy kernel: [  220.904033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c3 c0 d4 00 d5 0f d6 00 e0 03 07 bf
Jan 14 17:07:07 linux-v5dy kernel: [  220.974025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 c6 c3 10 d4 10 d5 1f d6 00 e0 03
Jan 14 17:07:07 linux-v5dy kernel: [  221.044025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 bf e0 03 07 a8 d3 c6 c3 10 87 1e
Jan 14 17:07:07 linux-v5dy kernel: [  221.114025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 87 76 1f f7 87 0e 87 7c 1f f7 d4 10
Jan 14 17:07:07 linux-v5dy kernel: [  221.184025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d5 1f d6 00 e0 03 07 bf e0 03 07 a8
Jan 14 17:07:08 linux-v5dy kernel: [  221.254025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 10 c3 27 f3 09 d3 01 d4 1f d5 1f
Jan 14 17:07:08 linux-v5dy kernel: [  221.324026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d6 00 e0 03 07 bf e0 03 07 a8 d3 10
Jan 14 17:07:08 linux-v5dy kernel: [  221.394025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c3 27 f3 09 d3 00 c3 70 e0 03 07 e7
Jan 14 17:07:08 linux-v5dy kernel: [  221.464026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 ff c3 03 2c 4f d3 00 d4 1f d5 1f
Jan 14 17:07:08 linux-v5dy kernel: [  221.534025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d6 00 e0 03 07 bf e0 03 07 a8 f0 02
Jan 14 17:07:08 linux-v5dy kernel: [  221.604025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d0 00 d1 2c e0 00 07 d4 f0 02 a4 43
Jan 14 17:07:08 linux-v5dy kernel: [  221.674025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f4 0d d7 01 2d cb d6 10 5e 0e f6 01
Jan 14 17:07:08 linux-v5dy kernel: [  221.744025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 96 d6 10 16 06 67 76 65 56 1f f7
Jan 14 17:07:08 linux-v5dy kernel: [  221.814025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 3f f5 ef 9a 67 70 65 50 1e e7 3e e5
Jan 14 17:07:08 linux-v5dy kernel: [  221.884032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 17 10 55 dc 85 52 b5 52 00 05 84 43
Jan 14 17:07:08 linux-v5dy kernel: [  221.954025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f7 05 07 89 f0 02 e0 00 07 bf e0 04
Jan 14 17:07:08 linux-v5dy kernel: [  222.024025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 a8 f0 02 d0 60 f1 08 d6 00 c6 f0
Jan 14 17:07:08 linux-v5dy kernel: [  222.094025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d3 01 d2 10 a0 03 f7 08 a0 03 f8 08
Jan 14 17:07:08 linux-v5dy kernel: [  222.164025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 24 df f4 01 07 b7 e0 06 07 d8 a6 63
Jan 14 17:07:09 linux-v5dy kernel: [  222.234026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 81 13 b2 22 f2 05 07 ae d0 60 f0 1c
Jan 14 17:07:09 linux-v5dy kernel: [  222.304026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f0 02 aa 01 a6 11 a7 21 d4 60 f5 48
Jan 14 17:07:09 linux-v5dy kernel: [  222.374025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a db 01 6b b3 15 5f f4 5c a4 43 8b 32
Jan 14 17:07:09 linux-v5dy kernel: [  222.445033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 04 4b f8 48 a4 43 f9 48 e0 06 07 87
Jan 14 17:07:09 linux-v5dy kernel: [  222.515031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f4 9c b4 42 f4 8c f0 02 c0 80 e0 00
Jan 14 17:07:09 linux-v5dy kernel: [  222.585026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 d8 f0 02 f0 0a d3 00 c3 9c f3 1c
Jan 14 17:07:09 linux-v5dy kernel: [  222.655026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c3 a0 f3 2c c3 a4 f3 0c d3 00 c3 a8
Jan 14 17:07:09 linux-v5dy kernel: [  222.725025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f3 38 f3 01 07 e0 f0 06 f0 02 f0 0a
Jan 14 17:07:09 linux-v5dy kernel: [  222.795025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a d2 00 c2 a4 f2 0c c2 a8 f1 28 f1 01
Jan 14 17:07:09 linux-v5dy kernel: [  222.865033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 07 ec c2 9c f1 28 c2 a0 f2 28 f0 06
Jan 14 17:07:09 linux-v5dy kernel: [  222.935025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a f0 02 d1 00 c1 98 f1 0c f0 02 d1 00
Jan 14 17:07:09 linux-v5dy kernel: [  223.005025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a c1 94 f0 18 c1 98 f1 18 f0 02 ed dc
Jan 14 17:07:09 linux-v5dy kernel: [  223.075025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 90 00 88 00 30 00 34 00 24 00 6c 00
Jan 14 17:07:09 linux-v5dy kernel: [  223.145025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:09 linux-v5dy kernel: [  223.215025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 05 dd 3d d7 00 15 00 1a 0a 19 00 1e
Jan 14 17:07:10 linux-v5dy kernel: [  223.285028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 47 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:10 linux-v5dy kernel: [  223.355025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:10 linux-v5dy kernel: [  223.425025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:10 linux-v5dy kernel: [  223.495025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:10 linux-v5dy kernel: [  223.565025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:10 linux-v5dy kernel: [  223.635025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:10 linux-v5dy kernel: [  223.705023] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:10 linux-v5dy kernel: [  223.775025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:10 linux-v5dy kernel: [  223.845032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:10 linux-v5dy kernel: [  223.915025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:10 linux-v5dy kernel: [  223.985029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:10 linux-v5dy kernel: [  224.055026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 a0 01 76 01 38 02 c0 02 30 04 20
Jan 14 17:07:10 linux-v5dy kernel: [  224.125025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 03 60 06 5c 04 bc 09 60 07 9c 0d 70
Jan 14 17:07:10 linux-v5dy kernel: [  224.195026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a ff ff 7a f5 10 ae 70 a5 22 7c 00 00
Jan 14 17:07:11 linux-v5dy kernel: [  224.265027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 1e 17 00 04 2c 5f 00 00 03 00
Jan 14 17:07:11 linux-v5dy kernel: [  224.335025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 06 00 27 c5 21 f0 16 27 c0 00 00 00
Jan 14 17:07:11 linux-v5dy kernel: [  224.405025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 3c 67 42 c0 00 00 00 00 00 00
Jan 14 17:07:11 linux-v5dy kernel: [  224.475025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 07 0e
Jan 14 17:07:11 linux-v5dy kernel: [  224.545025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 1c fe fe 80 3f 00 00 00 00 00 00
Jan 14 17:07:11 linux-v5dy kernel: [  224.615026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 01 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:11 linux-v5dy kernel: [  224.685025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 30 00 30
Jan 14 17:07:11 linux-v5dy kernel: [  224.755025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 0c 08 30 00 00 00 30 00 02 00 21
Jan 14 17:07:11 linux-v5dy kernel: [  224.825032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 0c 00 04 00 21 00 00 00 2b
Jan 14 17:07:11 linux-v5dy kernel: [  224.895025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 01 00 00 00 00 00 00 00 46 03 00
Jan 14 17:07:11 linux-v5dy kernel: [  224.965025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 0a 00 2c 00 00 00 00
Jan 14 17:07:11 linux-v5dy kernel: [  225.035025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 50 00 b0 00 00 00 00 03 0a 03 a9
Jan 14 17:07:11 linux-v5dy kernel: [  225.105025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 08 00 04 00 0f 00 08 00 0e 00 00
Jan 14 17:07:11 linux-v5dy kernel: [  225.175025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:12 linux-v5dy kernel: [  225.245026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 2a 00 00 00 00 00 00 00 00 00 00 00 00
Jan 14 17:07:12 linux-v5dy kernel: [  225.315026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=3: 2a 00 00
Jan 14 17:07:12 linux-v5dy kernel: [  225.385025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 02 02
Jan 14 17:07:12 linux-v5dy kernel: [  225.455026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 02 03
Jan 14 17:07:12 linux-v5dy kernel: [  225.525025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 00 8c
Jan 14 17:07:12 linux-v5dy kernel: [  225.595034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 00 00 00 00
Jan 14 17:07:12 linux-v5dy kernel: [  225.766034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ff 00 00 fb
Jan 14 17:07:12 linux-v5dy kernel: [  225.835025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 07 bd
Jan 14 17:07:12 linux-v5dy kernel: [  225.905025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f1 05 01 a3
Jan 14 17:07:12 linux-v5dy kernel: [  225.975025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 80 02 b8 04
Jan 14 17:07:12 linux-v5dy kernel: [  226.045025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 01 01 14
Jan 14 17:07:12 linux-v5dy kernel: [  226.115025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b2 08 f2 01
Jan 14 17:07:12 linux-v5dy kernel: [  226.185025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 14 b2 2c
Jan 14 17:07:13 linux-v5dy kernel: [  226.255026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b2 2c f2 01
Jan 14 17:07:13 linux-v5dy kernel: [  226.325025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 12 d2 00
Jan 14 17:07:13 linux-v5dy kernel: [  226.395025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c2 40 12 02
Jan 14 17:07:13 linux-v5dy kernel: [  226.465032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 05 01 a3
Jan 14 17:07:13 linux-v5dy kernel: [  226.535026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 06 b6
Jan 14 17:07:13 linux-v5dy kernel: [  226.605029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e9 a3 e0 00
Jan 14 17:07:13 linux-v5dy kernel: [  226.675027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 05 da e0 01
Jan 14 17:07:13 linux-v5dy kernel: [  226.745026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 b9 f0 12
Jan 14 17:07:13 linux-v5dy kernel: [  226.815026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 07 bd
Jan 14 17:07:13 linux-v5dy kernel: [  226.885026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 00 f2 01
Jan 14 17:07:13 linux-v5dy kernel: [  226.955025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 00 fd f8 01
Jan 14 17:07:13 linux-v5dy kernel: [  227.025025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 58 d3 86
Jan 14 17:07:13 linux-v5dy kernel: [  227.095026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 1c d3 89
Jan 14 17:07:13 linux-v5dy kernel: [  227.165025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 1c d3 0c
Jan 14 17:07:14 linux-v5dy kernel: [  227.235026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 60 03 0c cf
Jan 14 17:07:14 linux-v5dy kernel: [  227.305026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 0d d3 85
Jan 14 17:07:14 linux-v5dy kernel: [  227.375026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 0c e0 01
Jan 14 17:07:14 linux-v5dy kernel: [  227.445032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 b9 e0 01
Jan 14 17:07:14 linux-v5dy kernel: [  227.515025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 05 96 e0 00
Jan 14 17:07:14 linux-v5dy kernel: [  227.585025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 c7 a1 31
Jan 14 17:07:14 linux-v5dy kernel: [  227.655025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 03 04 d3
Jan 14 17:07:14 linux-v5dy kernel: [  227.725025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 0f e0 00
Jan 14 17:07:14 linux-v5dy kernel: [  227.795027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 05 27 e0 00
Jan 14 17:07:14 linux-v5dy kernel: [  227.865025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 02 eb d0 87
Jan 14 17:07:14 linux-v5dy kernel: [  227.935025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 08 d1 01
Jan 14 17:07:14 linux-v5dy kernel: [  228.005025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2d dc f1 05
Jan 14 17:07:14 linux-v5dy kernel: [  228.075025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 94 d0 28
Jan 14 17:07:14 linux-v5dy kernel: [  228.145025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c1 13 f1 09
Jan 14 17:07:14 linux-v5dy kernel: [  228.215025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 02 07 89
Jan 14 17:07:15 linux-v5dy kernel: [  228.285028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 01 01 48
Jan 14 17:07:15 linux-v5dy kernel: [  228.355026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b0 02 f0 05
Jan 14 17:07:15 linux-v5dy kernel: [  228.425033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 3d d0 00
Jan 14 17:07:15 linux-v5dy kernel: [  228.495025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e9 49 d0 01
Jan 14 17:07:15 linux-v5dy kernel: [  228.565026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 00 e0 00
Jan 14 17:07:15 linux-v5dy kernel: [  228.635025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 01 f0 01
Jan 14 17:07:15 linux-v5dy kernel: [  228.705033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 55 b0 02
Jan 14 17:07:15 linux-v5dy kernel: [  228.775025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 01 01 2c
Jan 14 17:07:15 linux-v5dy kernel: [  228.845025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b0 02 f0 01
Jan 14 17:07:15 linux-v5dy kernel: [  228.915026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 55 e9 a3
Jan 14 17:07:15 linux-v5dy kernel: [  228.985025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 06 bb
Jan 14 17:07:15 linux-v5dy kernel: [  229.055030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e9 68 d3 87
Jan 14 17:07:15 linux-v5dy kernel: [  229.125026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 0c d3 88
Jan 14 17:07:15 linux-v5dy kernel: [  229.195027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 1c e0 00
Jan 14 17:07:16 linux-v5dy kernel: [  229.265028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 92 e0 01
Jan 14 17:07:16 linux-v5dy kernel: [  229.335026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 b6 e0 01
Jan 14 17:07:16 linux-v5dy kernel: [  229.405032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 b9 f0 12
Jan 14 17:07:16 linux-v5dy kernel: [  229.475025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 01 07 b9
Jan 14 17:07:16 linux-v5dy kernel: [  229.545025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 05 96
Jan 14 17:07:16 linux-v5dy kernel: [  229.615025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e9 2c d0 10
Jan 14 17:07:16 linux-v5dy kernel: [  229.685025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 28 e0 02
Jan 14 17:07:16 linux-v5dy kernel: [  229.755026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 05 9e f2 01
Jan 14 17:07:16 linux-v5dy kernel: [  229.825025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 8a e0 02
Jan 14 17:07:16 linux-v5dy kernel: [  229.895025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 89 d5 28
Jan 14 17:07:16 linux-v5dy kernel: [  229.965025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 23 21 03 35
Jan 14 17:07:16 linux-v5dy kernel: [  230.035025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a4 53 24 42
Jan 14 17:07:16 linux-v5dy kernel: [  230.105026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 11 34 d4 01
Jan 14 17:07:16 linux-v5dy kernel: [  230.175025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 93 11 e0 03
Jan 14 17:07:17 linux-v5dy kernel: [  230.245026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 01 f3 01
Jan 14 17:07:17 linux-v5dy kernel: [  230.315026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 7f b3 32
Jan 14 17:07:17 linux-v5dy kernel: [  230.385032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 01 01 2c
Jan 14 17:07:17 linux-v5dy kernel: [  230.455025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 05 01 8e
Jan 14 17:07:17 linux-v5dy kernel: [  230.525025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 02 07 d1
Jan 14 17:07:17 linux-v5dy kernel: [  230.595027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c3 06 5f ef
Jan 14 17:07:17 linux-v5dy kernel: [  230.665025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c4 09 5c c2
Jan 14 17:07:17 linux-v5dy kernel: [  230.735026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2f f4 f3 05
Jan 14 17:07:17 linux-v5dy kernel: [  230.805026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 8e e0 02
Jan 14 17:07:17 linux-v5dy kernel: [  230.875025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 05 ef d0 05
Jan 14 17:07:17 linux-v5dy kernel: [  230.945026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e9 3d b0 02
Jan 14 17:07:17 linux-v5dy kernel: [  231.015025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 01 01 94
Jan 14 17:07:17 linux-v5dy kernel: [  231.085026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 02 02 8b
Jan 14 17:07:17 linux-v5dy kernel: [  231.155026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e9 9a d0 10
Jan 14 17:07:18 linux-v5dy kernel: [  231.225026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 89 f3 38
Jan 14 17:07:18 linux-v5dy kernel: [  231.295026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d2 01 e0 02
Jan 14 17:07:18 linux-v5dy kernel: [  231.365033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 05 27 d2 87
Jan 14 17:07:18 linux-v5dy kernel: [  231.435025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 28 d3 01
Jan 14 17:07:18 linux-v5dy kernel: [  231.505025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2f fe f3 01
Jan 14 17:07:18 linux-v5dy kernel: [  231.575025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 6a c2 ff
Jan 14 17:07:18 linux-v5dy kernel: [  231.645025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 09 e9 8e
Jan 14 17:07:18 linux-v5dy kernel: [  231.715026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 04 07 b9
Jan 14 17:07:18 linux-v5dy kernel: [  231.785025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 0e f0 0e
Jan 14 17:07:18 linux-v5dy kernel: [  231.855025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 07 bd
Jan 14 17:07:18 linux-v5dy kernel: [  231.925027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 01 7d cd
Jan 14 17:07:18 linux-v5dy kernel: [  231.995025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b2 1e f2 01
Jan 14 17:07:18 linux-v5dy kernel: [  232.065025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 02 0d b2 22
Jan 14 17:07:18 linux-v5dy kernel: [  232.135032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 00 f2 01
Jan 14 17:07:18 linux-v5dy kernel: [  232.205027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 e8 b2 22
Jan 14 17:07:19 linux-v5dy kernel: [  232.275025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 01 01 e7
Jan 14 17:07:19 linux-v5dy kernel: [  232.345039] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b2 22 f2 01
Jan 14 17:07:19 linux-v5dy kernel: [  232.415028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 df b2 22
Jan 14 17:07:19 linux-v5dy kernel: [  232.485025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 01 01 dc
Jan 14 17:07:19 linux-v5dy kernel: [  232.555025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b2 22 f2 01
Jan 14 17:07:19 linux-v5dy kernel: [  232.625025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 d9 b2 22
Jan 14 17:07:19 linux-v5dy kernel: [  232.695025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 01 01 d6
Jan 14 17:07:19 linux-v5dy kernel: [  232.765025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b2 22 f2 01
Jan 14 17:07:19 linux-v5dy kernel: [  232.835025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 cf b2 22
Jan 14 17:07:19 linux-v5dy kernel: [  232.905025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 01 01 cb
Jan 14 17:07:19 linux-v5dy kernel: [  232.975025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 80 0a 80 0b
Jan 14 17:07:19 linux-v5dy kernel: [  233.045025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 08 ea 0f
Jan 14 17:07:19 linux-v5dy kernel: [  233.115032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 07 df
Jan 14 17:07:19 linux-v5dy kernel: [  233.185025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 0d ea 0f
Jan 14 17:07:20 linux-v5dy kernel: [  233.255026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 b9 f1 18
Jan 14 17:07:20 linux-v5dy kernel: [  233.325026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 92 11 3c de
Jan 14 17:07:20 linux-v5dy kernel: [  233.395026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 82 22 3c ce
Jan 14 17:07:20 linux-v5dy kernel: [  233.465025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ea 0f d0 36
Jan 14 17:07:20 linux-v5dy kernel: [  233.535025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c0 20 ea 0f
Jan 14 17:07:20 linux-v5dy kernel: [  233.605025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 d4 c0 0b
Jan 14 17:07:20 linux-v5dy kernel: [  233.675069] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ea 0f e0 00
Jan 14 17:07:20 linux-v5dy kernel: [  233.745025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 d1 ea 0f
Jan 14 17:07:20 linux-v5dy kernel: [  233.815025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 03 c0 40
Jan 14 17:07:20 linux-v5dy kernel: [  233.885025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 07 c3
Jan 14 17:07:20 linux-v5dy kernel: [  233.955025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 80 1a 80 0b
Jan 14 17:07:20 linux-v5dy kernel: [  234.025025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b0 02 ea 0f
Jan 14 17:07:20 linux-v5dy kernel: [  234.095032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 03 d7 05
Jan 14 17:07:20 linux-v5dy kernel: [  234.165030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c7 60 e0 07
Jan 14 17:07:21 linux-v5dy kernel: [  234.235026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 c3 aa 71
Jan 14 17:07:21 linux-v5dy kernel: [  234.305026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 0a 07 c3
Jan 14 17:07:21 linux-v5dy kernel: [  234.375025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 74 d7 d5 10
Jan 14 17:07:21 linux-v5dy kernel: [  234.445025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 15 45 f5 01
Jan 14 17:07:21 linux-v5dy kernel: [  234.515025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 01 f6 b6 46
Jan 14 17:07:21 linux-v5dy kernel: [  234.585025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e9 f9 74 c7
Jan 14 17:07:21 linux-v5dy kernel: [  234.655025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 0d 06 45
Jan 14 17:07:21 linux-v5dy kernel: [  234.725026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 8b b8 74 f7
Jan 14 17:07:21 linux-v5dy kernel: [  234.795025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 84 42 15 64
Jan 14 17:07:21 linux-v5dy kernel: [  234.865025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 0d 22 57
Jan 14 17:07:21 linux-v5dy kernel: [  234.935025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 82 25 d3 0b
Jan 14 17:07:21 linux-v5dy kernel: [  235.005025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 02 23 d3 40
Jan 14 17:07:21 linux-v5dy kernel: [  235.075032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 5f fe 22 23
Jan 14 17:07:21 linux-v5dy kernel: [  235.145025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a3 20 22 23
Jan 14 17:07:21 linux-v5dy kernel: [  235.215025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 b9 f3 38
Jan 14 17:07:22 linux-v5dy kernel: [  235.285029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a3 34 22 23
Jan 14 17:07:22 linux-v5dy kernel: [  235.355025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 70 21 ea 0f
Jan 14 17:07:22 linux-v5dy kernel: [  235.425025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 07 f4
Jan 14 17:07:22 linux-v5dy kernel: [  235.495025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 07 b9
Jan 14 17:07:22 linux-v5dy kernel: [  235.565025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 0e ea 64
Jan 14 17:07:22 linux-v5dy kernel: [  235.635025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 0a fb 08
Jan 14 17:07:22 linux-v5dy kernel: [  235.705023] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 18 ba 9a
Jan 14 17:07:22 linux-v5dy kernel: [  235.775025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b6 62 1c b6
Jan 14 17:07:22 linux-v5dy kernel: [  235.845025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 1c 8a f6 18
Jan 14 17:07:22 linux-v5dy kernel: [  235.915025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 01 02 49
Jan 14 17:07:22 linux-v5dy kernel: [  235.985025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fb 01 02 78
Jan 14 17:07:22 linux-v5dy kernel: [  236.055032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b9 92 f9 05
Jan 14 17:07:22 linux-v5dy kernel: [  236.125025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 02 25 da 13
Jan 14 17:07:22 linux-v5dy kernel: [  236.195027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 28 fa 84
Jan 14 17:07:23 linux-v5dy kernel: [  236.265028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: bb b2 fb 01
Jan 14 17:07:23 linux-v5dy kernel: [  236.335025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 02 78 bb b8
Jan 14 17:07:23 linux-v5dy kernel: [  236.405025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fb 01 02 4d
Jan 14 17:07:23 linux-v5dy kernel: [  236.475025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 00 c7 d0
Jan 14 17:07:23 linux-v5dy kernel: [  236.545025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 78 d8 00
Jan 14 17:07:23 linux-v5dy kernel: [  236.615029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 8c f9 05
Jan 14 17:07:23 linux-v5dy kernel: [  236.685027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 02 49 d8 12
Jan 14 17:07:23 linux-v5dy kernel: [  236.755025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 88 f2 8c
Jan 14 17:07:23 linux-v5dy kernel: [  236.825025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a8 83 d9 00
Jan 14 17:07:23 linux-v5dy kernel: [  236.895025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 9c da 10
Jan 14 17:07:23 linux-v5dy kernel: [  236.965025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fa a8 a8 83
Jan 14 17:07:23 linux-v5dy kernel: [  237.035032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 ac d8 00
Jan 14 17:07:23 linux-v5dy kernel: [  237.105026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 00 c7 64
Jan 14 17:07:23 linux-v5dy kernel: [  237.175026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 8c d8 11
Jan 14 17:07:24 linux-v5dy kernel: [  237.245026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 88 f4 8c
Jan 14 17:07:24 linux-v5dy kernel: [  237.315027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d8 00 c8 8c
Jan 14 17:07:24 linux-v5dy kernel: [  237.385026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d9 01 f8 9c
Jan 14 17:07:24 linux-v5dy kernel: [  237.455026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 06 f0 02
Jan 14 17:07:24 linux-v5dy kernel: [  237.525026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d9 13 fa 98
Jan 14 17:07:24 linux-v5dy kernel: [  237.595027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 ac ea 3c
Jan 14 17:07:24 linux-v5dy kernel: [  237.665025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d8 00 d7 00
Jan 14 17:07:24 linux-v5dy kernel: [  237.735025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c7 60 f7 8c
Jan 14 17:07:24 linux-v5dy kernel: [  237.805025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d8 0e f8 88
Jan 14 17:07:24 linux-v5dy kernel: [  237.875025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f4 8c d8 0f
Jan 14 17:07:24 linux-v5dy kernel: [  237.945025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 88 f2 8c
Jan 14 17:07:24 linux-v5dy kernel: [  238.015032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a8 83 d9 00
Jan 14 17:07:24 linux-v5dy kernel: [  238.085025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 9c da 0d
Jan 14 17:07:24 linux-v5dy kernel: [  238.155025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fa a8 a8 83
Jan 14 17:07:25 linux-v5dy kernel: [  238.225026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 ac d8 00
Jan 14 17:07:25 linux-v5dy kernel: [  238.295025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c8 8c d9 05
Jan 14 17:07:25 linux-v5dy kernel: [  238.365025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 9c f0 06
Jan 14 17:07:25 linux-v5dy kernel: [  238.435025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 d9 00
Jan 14 17:07:25 linux-v5dy kernel: [  238.505025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c9 ac d8 0c
Jan 14 17:07:25 linux-v5dy kernel: [  238.575025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fa 80 f9 ac
Jan 14 17:07:25 linux-v5dy kernel: [  238.645114] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d9 00 c9 08
Jan 14 17:07:25 linux-v5dy kernel: [  238.715026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 00 c7 34
Jan 14 17:07:25 linux-v5dy kernel: [  238.785026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 9c c9 38
Jan 14 17:07:25 linux-v5dy kernel: [  238.855025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 00 c7 44
Jan 14 17:07:25 linux-v5dy kernel: [  238.925025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 9c c9 20
Jan 14 17:07:25 linux-v5dy kernel: [  238.995032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 00 c7 48
Jan 14 17:07:25 linux-v5dy kernel: [  239.065025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 9c d8 15
Jan 14 17:07:25 linux-v5dy kernel: [  239.135025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 8c f0 06
Jan 14 17:07:25 linux-v5dy kernel: [  239.205027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ea 79 f0 0e
Jan 14 17:07:26 linux-v5dy kernel: [  239.275030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 00 d0 b3
Jan 14 17:07:26 linux-v5dy kernel: [  239.345026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a0 03 f2 08
Jan 14 17:07:26 linux-v5dy kernel: [  239.415028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 05 02 89
Jan 14 17:07:26 linux-v5dy kernel: [  239.485025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a0 05 f2 08
Jan 14 17:07:26 linux-v5dy kernel: [  239.555025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 05 02 89
Jan 14 17:07:26 linux-v5dy kernel: [  239.625025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a0 05 f2 08
Jan 14 17:07:26 linux-v5dy kernel: [  239.695025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 01 02 8a
Jan 14 17:07:26 linux-v5dy kernel: [  239.765033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 01 f0 02
Jan 14 17:07:26 linux-v5dy kernel: [  239.835025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 02 7b
Jan 14 17:07:26 linux-v5dy kernel: [  239.905025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f1 05 02 d3
Jan 14 17:07:26 linux-v5dy kernel: [  239.975031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b0 12 d1 01
Jan 14 17:07:26 linux-v5dy kernel: [  240.045025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 03 fd
Jan 14 17:07:26 linux-v5dy kernel: [  240.115025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 12 d7 01
Jan 14 17:07:26 linux-v5dy kernel: [  240.185025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 06 07 76
Jan 14 17:07:27 linux-v5dy kernel: [  240.255025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c7 0a f7 09
Jan 14 17:07:27 linux-v5dy kernel: [  240.325025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 71 e0 06
Jan 14 17:07:27 linux-v5dy kernel: [  240.395025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 76 d0 00
Jan 14 17:07:27 linux-v5dy kernel: [  240.465025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 04 d3 8e
Jan 14 17:07:27 linux-v5dy kernel: [  240.535025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a8 51 f6 38
Jan 14 17:07:27 linux-v5dy kernel: [  240.605025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a7 01 e0 06
Jan 14 17:07:27 linux-v5dy kernel: [  240.675025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 c5 f5 38
Jan 14 17:07:27 linux-v5dy kernel: [  240.745032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a3 33 f8 38
Jan 14 17:07:27 linux-v5dy kernel: [  240.815025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a3 37 1a 85
Jan 14 17:07:27 linux-v5dy kernel: [  240.885025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b8 62 1c 8a
Jan 14 17:07:27 linux-v5dy kernel: [  240.955025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: aa 63 1d a5
Jan 14 17:07:27 linux-v5dy kernel: [  241.025025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 29 89 f9 01
Jan 14 17:07:27 linux-v5dy kernel: [  241.095025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 02 b2 f6 05
Jan 14 17:07:27 linux-v5dy kernel: [  241.165025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 02 b7 a0 03
Jan 14 17:07:28 linux-v5dy kernel: [  241.235025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 08 f2 05
Jan 14 17:07:28 linux-v5dy kernel: [  241.305026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 02 e6 ea 9f
Jan 14 17:07:28 linux-v5dy kernel: [  241.375025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a1 03 d7 00
Jan 14 17:07:28 linux-v5dy kernel: [  241.445025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 18 f2 05
Jan 14 17:07:28 linux-v5dy kernel: [  241.515025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 02 c8 a9 51
Jan 14 17:07:28 linux-v5dy kernel: [  241.585025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 38 a8 11
Jan 14 17:07:28 linux-v5dy kernel: [  241.655025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 07 03 c5
Jan 14 17:07:28 linux-v5dy kernel: [  241.725033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f5 38 12 67
Jan 14 17:07:28 linux-v5dy kernel: [  241.795025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 05 02 c8
Jan 14 17:07:28 linux-v5dy kernel: [  241.865025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a1 13 a3 39
Jan 14 17:07:28 linux-v5dy kernel: [  241.935025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ea b9 25 77
Jan 14 17:07:28 linux-v5dy kernel: [  242.005025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 62 d8 01
Jan 14 17:07:28 linux-v5dy kernel: [  242.075025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 18 82 24 02
Jan 14 17:07:28 linux-v5dy kernel: [  242.145025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 44 18 23 12
Jan 14 17:07:28 linux-v5dy kernel: [  242.215026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 43 08 e0 03
Jan 14 17:07:29 linux-v5dy kernel: [  242.285031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 36 ea e6
Jan 14 17:07:29 linux-v5dy kernel: [  242.355025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 00 f0 3c
Jan 14 17:07:29 linux-v5dy kernel: [  242.425026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b0 02 f1 08
Jan 14 17:07:29 linux-v5dy kernel: [  242.495025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 8e d3 04
Jan 14 17:07:29 linux-v5dy kernel: [  242.565025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 40 13 f3 08
Jan 14 17:07:29 linux-v5dy kernel: [  242.635025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 32 f0 3c
Jan 14 17:07:29 linux-v5dy kernel: [  242.705022] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 01 04 49
Jan 14 17:07:29 linux-v5dy kernel: [  242.775025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 02 7b
Jan 14 17:07:29 linux-v5dy kernel: [  242.845025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f1 05 02 8b
Jan 14 17:07:29 linux-v5dy kernel: [  242.915025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 0f e0 01
Jan 14 17:07:29 linux-v5dy kernel: [  242.985025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 04 2c e0 00
Jan 14 17:07:29 linux-v5dy kernel: [  243.055025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 02 7b f1 05
Jan 14 17:07:29 linux-v5dy kernel: [  243.125025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 02 8b f0 02
Jan 14 17:07:29 linux-v5dy kernel: [  243.195027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 00 d2 9f
Jan 14 17:07:30 linux-v5dy kernel: [  243.265027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 b4 d4 03
Jan 14 17:07:30 linux-v5dy kernel: [  243.335030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 00 c1 10
Jan 14 17:07:30 linux-v5dy kernel: [  243.405025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 1c f3 0c
Jan 14 17:07:30 linux-v5dy kernel: [  243.475025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 29 a3 35
Jan 14 17:07:30 linux-v5dy kernel: [  243.545025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b4 42 f4 05
Jan 14 17:07:30 linux-v5dy kernel: [  243.615025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 02 f1 d0 00
Jan 14 17:07:30 linux-v5dy kernel: [  243.685074] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d2 8e d6 0c
Jan 14 17:07:30 linux-v5dy kernel: [  243.755025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 00 d7 00
Jan 14 17:07:30 linux-v5dy kernel: [  243.825025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f4 28 84 45
Jan 14 17:07:30 linux-v5dy kernel: [  243.895025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 84 44 b3 28
Jan 14 17:07:30 linux-v5dy kernel: [  243.965025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 38 a3 23
Jan 14 17:07:30 linux-v5dy kernel: [  244.035026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f5 38 a9 11
Jan 14 17:07:30 linux-v5dy kernel: [  244.105025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: da 00 e0 09
Jan 14 17:07:30 linux-v5dy kernel: [  244.175025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 04 49 d9 0f
Jan 14 17:07:31 linux-v5dy kernel: [  244.245026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 09 04 2c
Jan 14 17:07:31 linux-v5dy kernel: [  244.315025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 09 05 ef
Jan 14 17:07:31 linux-v5dy kernel: [  244.385029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c9 0a f9 09
Jan 14 17:07:31 linux-v5dy kernel: [  244.455026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b9 92 da 00
Jan 14 17:07:31 linux-v5dy kernel: [  244.525025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 09 03 fd
Jan 14 17:07:31 linux-v5dy kernel: [  244.595027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a9 41 aa 11
Jan 14 17:07:31 linux-v5dy kernel: [  244.665032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b3 28 fb 38
Jan 14 17:07:31 linux-v5dy kernel: [  244.735025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 09 03 c5
Jan 14 17:07:31 linux-v5dy kernel: [  244.805025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 44 69 07 79
Jan 14 17:07:31 linux-v5dy kernel: [  244.875025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 5e 54 27 7a
Jan 14 17:07:31 linux-v5dy kernel: [  244.945025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: da 00 4f a9
Jan 14 17:07:31 linux-v5dy kernel: [  245.015025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 17 7f aa 40
Jan 14 17:07:31 linux-v5dy kernel: [  245.085025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 27 7a 27 79
Jan 14 17:07:31 linux-v5dy kernel: [  245.155025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 01 03 28
Jan 14 17:07:32 linux-v5dy kernel: [  245.225026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 4c a7 91
Jan 14 17:07:32 linux-v5dy kernel: [  245.295027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: eb 04 9a 41
Jan 14 17:07:32 linux-v5dy kernel: [  245.365025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 10 0e 97 13
Jan 14 17:07:32 linux-v5dy kernel: [  245.435026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 27 7f 2f f0
Jan 14 17:07:32 linux-v5dy kernel: [  245.505026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 05 02 f8
Jan 14 17:07:32 linux-v5dy kernel: [  245.575026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 29 d6 04
Jan 14 17:07:32 linux-v5dy kernel: [  245.645032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a1 13 ba 18
Jan 14 17:07:32 linux-v5dy kernel: [  245.715026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fa 05 02 fd
Jan 14 17:07:32 linux-v5dy kernel: [  245.785025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 d4 04
Jan 14 17:07:32 linux-v5dy kernel: [  245.855025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: db 8e d7 b3
Jan 14 17:07:32 linux-v5dy kernel: [  245.925025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 19 01 f9 01
Jan 14 17:07:32 linux-v5dy kernel: [  245.995025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 b3 99 91
Jan 14 17:07:32 linux-v5dy kernel: [  246.065025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 01 03 78
Jan 14 17:07:32 linux-v5dy kernel: [  246.135025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 4b 14 f6 b8
Jan 14 17:07:32 linux-v5dy kernel: [  246.205028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a5 b3 f9 58
Jan 14 17:07:33 linux-v5dy kernel: [  246.275025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 19 96 f9 05
Jan 14 17:07:33 linux-v5dy kernel: [  246.345025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 4d a1 13
Jan 14 17:07:33 linux-v5dy kernel: [  246.415028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 5d 10 2d 92
Jan 14 17:07:33 linux-v5dy kernel: [  246.485025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 01 03 36
Jan 14 17:07:33 linux-v5dy kernel: [  246.555025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 04 eb 36
Jan 14 17:07:33 linux-v5dy kernel: [  246.625034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a7 79 f7 1c
Jan 14 17:07:33 linux-v5dy kernel: [  246.695026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a7 73 a5 b5
Jan 14 17:07:33 linux-v5dy kernel: [  246.766026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 58 f7 8c
Jan 14 17:07:33 linux-v5dy kernel: [  246.836025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 13 19 02
Jan 14 17:07:33 linux-v5dy kernel: [  246.906025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 01 03 6b
Jan 14 17:07:33 linux-v5dy kernel: [  246.976025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 99 27 f9 05
Jan 14 17:07:33 linux-v5dy kernel: [  247.046025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 6b b7 76
Jan 14 17:07:33 linux-v5dy kernel: [  247.116025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 2c a5 55
Jan 14 17:07:33 linux-v5dy kernel: [  247.186025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 58 a5 55
Jan 14 17:07:34 linux-v5dy kernel: [  247.256026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 58 19 89
Jan 14 17:07:34 linux-v5dy kernel: [  247.326027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 5e 69 ba a2
Jan 14 17:07:34 linux-v5dy kernel: [  247.396026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 1b 96 49 ba
Jan 14 17:07:34 linux-v5dy kernel: [  247.466026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 9a 91 29 9a
Jan 14 17:07:34 linux-v5dy kernel: [  247.536026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 0d a7 73
Jan 14 17:07:34 linux-v5dy kernel: [  247.606032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 9c 08 89
Jan 14 17:07:34 linux-v5dy kernel: [  247.676026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 99 07 f9 05
Jan 14 17:07:34 linux-v5dy kernel: [  247.746026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 b3 d7 b3
Jan 14 17:07:34 linux-v5dy kernel: [  247.816025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 0c db 8e
Jan 14 17:07:34 linux-v5dy kernel: [  247.886026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 4b 04 f6 b8
Jan 14 17:07:34 linux-v5dy kernel: [  247.956025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a5 b5 f9 58
Jan 14 17:07:34 linux-v5dy kernel: [  248.026025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 06 03 b4
Jan 14 17:07:34 linux-v5dy kernel: [  248.096025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: eb b3 4b 04
Jan 14 17:07:34 linux-v5dy kernel: [  248.166025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 b8 f6 05
Jan 14 17:07:35 linux-v5dy kernel: [  248.236026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 83 a0 03
Jan 14 17:07:35 linux-v5dy kernel: [  248.306025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 5d 01 2d 92
Jan 14 17:07:35 linux-v5dy kernel: [  248.376032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 01 03 36
Jan 14 17:07:35 linux-v5dy kernel: [  248.446025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 04 eb 36
Jan 14 17:07:35 linux-v5dy kernel: [  248.516025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 0c a5 b5
Jan 14 17:07:35 linux-v5dy kernel: [  248.586032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 58 f8 0d
Jan 14 17:07:35 linux-v5dy kernel: [  248.656025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a7 73 f7 8c
Jan 14 17:07:35 linux-v5dy kernel: [  248.726025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 03 19 12
Jan 14 17:07:35 linux-v5dy kernel: [  248.796025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 01 03 a3
Jan 14 17:07:35 linux-v5dy kernel: [  248.866025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 99 27 f9 05
Jan 14 17:07:35 linux-v5dy kernel: [  248.936025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 a3 a7 73
Jan 14 17:07:35 linux-v5dy kernel: [  249.006025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 2c a5 55
Jan 14 17:07:35 linux-v5dy kernel: [  249.076025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 58 a5 55
Jan 14 17:07:35 linux-v5dy kernel: [  249.146025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 58 19 89
Jan 14 17:07:36 linux-v5dy kernel: [  249.216021] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b5 52 fa 58
Jan 14 17:07:36 linux-v5dy kernel: [  249.286029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 16 a6 5e 69
Jan 14 17:07:36 linux-v5dy kernel: [  249.356033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ba a2 1b 96
Jan 14 17:07:36 linux-v5dy kernel: [  249.426025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 49 ba 9a 91
Jan 14 17:07:36 linux-v5dy kernel: [  249.496029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 29 9a a7 73
Jan 14 17:07:36 linux-v5dy kernel: [  249.566025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 9c 08 89
Jan 14 17:07:36 linux-v5dy kernel: [  249.636025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 99 17 f9 05
Jan 14 17:07:36 linux-v5dy kernel: [  249.706026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 b3 d7 b3
Jan 14 17:07:36 linux-v5dy kernel: [  249.776027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a7 79 f7 1c
Jan 14 17:07:36 linux-v5dy kernel: [  249.846025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: db 8e 4b 14
Jan 14 17:07:36 linux-v5dy kernel: [  249.916026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 b8 a5 b3
Jan 14 17:07:36 linux-v5dy kernel: [  249.986026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fa 58 a5 b5
Jan 14 17:07:36 linux-v5dy kernel: [  250.056025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 58 16 a6
Jan 14 17:07:36 linux-v5dy kernel: [  250.126025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 06 03 b4
Jan 14 17:07:36 linux-v5dy kernel: [  250.196027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 94 21
Jan 14 17:07:37 linux-v5dy kernel: [  250.266028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 84 42 b4 42
Jan 14 17:07:37 linux-v5dy kernel: [  250.336032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 22 42 a5 31
Jan 14 17:07:37 linux-v5dy kernel: [  250.406025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f5 0d 05 53
Jan 14 17:07:37 linux-v5dy kernel: [  250.476026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 5e d2 5f d0
Jan 14 17:07:37 linux-v5dy kernel: [  250.546026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 1f fa f7 01
Jan 14 17:07:37 linux-v5dy kernel: [  250.616025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 ba a1 13
Jan 14 17:07:37 linux-v5dy kernel: [  250.686025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f5 0d 25 54
Jan 14 17:07:37 linux-v5dy kernel: [  250.756025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f1 5c f0 02
Jan 14 17:07:37 linux-v5dy kernel: [  250.826025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 00 5e 32
Jan 14 17:07:37 linux-v5dy kernel: [  250.896025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 1e 0a 5e 3a
Jan 14 17:07:37 linux-v5dy kernel: [  250.966025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a9 13 d2 9e
Jan 14 17:07:37 linux-v5dy kernel: [  251.036025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 00 d7 00
Jan 14 17:07:37 linux-v5dy kernel: [  251.106025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 1d d3 f4 28
Jan 14 17:07:37 linux-v5dy kernel: [  251.176025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 23 fb 28
Jan 14 17:07:38 linux-v5dy kernel: [  251.246026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 23 f3 28
Jan 14 17:07:38 linux-v5dy kernel: [  251.316034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 23 f6 28
Jan 14 17:07:38 linux-v5dy kernel: [  251.386025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 83 36 86 66
Jan 14 17:07:38 linux-v5dy kernel: [  251.456025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 33 b3 36 b6
Jan 14 17:07:38 linux-v5dy kernel: [  251.526025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 83 36 33 b3
Jan 14 17:07:38 linux-v5dy kernel: [  251.596027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 5c f4 43 ce
Jan 14 17:07:38 linux-v5dy kernel: [  251.666025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b9 92 f7 01
Jan 14 17:07:38 linux-v5dy kernel: [  251.736025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 e4 d6 f2
Jan 14 17:07:38 linux-v5dy kernel: [  251.806025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c6 03 4e ca
Jan 14 17:07:38 linux-v5dy kernel: [  251.876025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 1f f6 10 03
Jan 14 17:07:38 linux-v5dy kernel: [  251.946026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 23 94 73
Jan 14 17:07:38 linux-v5dy kernel: [  252.016025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 23 34 a7 73
Jan 14 17:07:38 linux-v5dy kernel: [  252.086025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 05 03 cd
Jan 14 17:07:38 linux-v5dy kernel: [  252.156026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b2 2e fb 28
Jan 14 17:07:39 linux-v5dy kernel: [  252.226026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f5 05 03 f5
Jan 14 17:07:39 linux-v5dy kernel: [  252.296038] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 23 3a f3 01
Jan 14 17:07:39 linux-v5dy kernel: [  252.366025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 f5 c4 70
Jan 14 17:07:39 linux-v5dy kernel: [  252.436026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 3b 4b f2 bc
Jan 14 17:07:39 linux-v5dy kernel: [  252.506025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ab b3 c5 10
Jan 14 17:07:39 linux-v5dy kernel: [  252.576025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 4e 5b 2a 1a
Jan 14 17:07:39 linux-v5dy kernel: [  252.646025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fa 01 03 fc
Jan 14 17:07:39 linux-v5dy kernel: [  252.716025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 bc f0 02
Jan 14 17:07:39 linux-v5dy kernel: [  252.786025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 05 07 f4
Jan 14 17:07:39 linux-v5dy kernel: [  252.856025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 0f c7 70
Jan 14 17:07:39 linux-v5dy kernel: [  252.926025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 07 07 c3
Jan 14 17:07:39 linux-v5dy kernel: [  252.996025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 ff 22 d7
Jan 14 17:07:39 linux-v5dy kernel: [  253.066025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 24 c7 83 8f
Jan 14 17:07:39 linux-v5dy kernel: [  253.136025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 83 33 82 28
Jan 14 17:07:39 linux-v5dy kernel: [  253.206027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 8e a7 77
Jan 14 17:07:40 linux-v5dy kernel: [  253.276035] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 78 42 80
Jan 14 17:07:40 linux-v5dy kernel: [  253.346026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a7 79 f8 78
Jan 14 17:07:40 linux-v5dy kernel: [  253.416028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 43 80 a7 79
Jan 14 17:07:40 linux-v5dy kernel: [  253.486025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 78 44 80
Jan 14 17:07:40 linux-v5dy kernel: [  253.556025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 9e 98 21
Jan 14 17:07:40 linux-v5dy kernel: [  253.626025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 22 28 20 01
Jan 14 17:07:40 linux-v5dy kernel: [  253.696030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 01 04 1d
Jan 14 17:07:40 linux-v5dy kernel: [  253.766025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 68 d8 07
Jan 14 17:07:40 linux-v5dy kernel: [  253.836025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 42 78 82 27
Jan 14 17:07:40 linux-v5dy kernel: [  253.906025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 2c a6 69
Jan 14 17:07:40 linux-v5dy kernel: [  253.976025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 3c a6 69
Jan 14 17:07:40 linux-v5dy kernel: [  254.046025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 4c a6 69
Jan 14 17:07:40 linux-v5dy kernel: [  254.116025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 5c d7 08
Jan 14 17:07:40 linux-v5dy kernel: [  254.186025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c7 20 e0 07
Jan 14 17:07:41 linux-v5dy kernel: [  254.256032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 c3 88 83
Jan 14 17:07:41 linux-v5dy kernel: [  254.326025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a6 63 f6 8c
Jan 14 17:07:41 linux-v5dy kernel: [  254.396025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 d6 bc
Jan 14 17:07:41 linux-v5dy kernel: [  254.466025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 68 d3 0f
Jan 14 17:07:41 linux-v5dy kernel: [  254.536025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c3 f0 d4 01
Jan 14 17:07:41 linux-v5dy kernel: [  254.606030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c4 01 d5 38
Jan 14 17:07:41 linux-v5dy kernel: [  254.676025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c5 40 1d da
Jan 14 17:07:41 linux-v5dy kernel: [  254.746026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 03 07 7a
Jan 14 17:07:41 linux-v5dy kernel: [  254.816026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c5 c0 1d d0
Jan 14 17:07:41 linux-v5dy kernel: [  254.886025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 03 07 7a
Jan 14 17:07:41 linux-v5dy kernel: [  254.956026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 12 d7 01
Jan 14 17:07:41 linux-v5dy kernel: [  255.026026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 06 07 76
Jan 14 17:07:41 linux-v5dy kernel: [  255.096025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c4 14 f4 09
Jan 14 17:07:41 linux-v5dy kernel: [  255.166025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 71 e0 06
Jan 14 17:07:42 linux-v5dy kernel: [  255.236032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 76 d4 fe
Jan 14 17:07:42 linux-v5dy kernel: [  255.306026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c4 fe e0 03
Jan 14 17:07:42 linux-v5dy kernel: [  255.376026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 7a f0 02
Jan 14 17:07:42 linux-v5dy kernel: [  255.446025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d2 e3 c2 22
Jan 14 17:07:42 linux-v5dy kernel: [  255.516025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 5b c3 0b
Jan 14 17:07:42 linux-v5dy kernel: [  255.586025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f1 0d a4 1f
Jan 14 17:07:42 linux-v5dy kernel: [  255.656025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a4 4b f4 01
Jan 14 17:07:42 linux-v5dy kernel: [  255.726026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 04 56 33 32
Jan 14 17:07:42 linux-v5dy kernel: [  255.796026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 83 34 b4 42
Jan 14 17:07:42 linux-v5dy kernel: [  255.866025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ec 50 d4 08
Jan 14 17:07:42 linux-v5dy kernel: [  255.936025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c4 20 e0 04
Jan 14 17:07:42 linux-v5dy kernel: [  256.006032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 c3 83 33
Jan 14 17:07:42 linux-v5dy kernel: [  256.076025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 85 53 33 35
Jan 14 17:07:42 linux-v5dy kernel: [  256.146025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 83 39 d2 11
Jan 14 17:07:43 linux-v5dy kernel: [  256.216033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 02 07 76
Jan 14 17:07:43 linux-v5dy kernel: [  256.286026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d2 8e f3 28
Jan 14 17:07:43 linux-v5dy kernel: [  256.356025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 12 4f f3
Jan 14 17:07:43 linux-v5dy kernel: [  256.426025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 03 d6 aa
Jan 14 17:07:43 linux-v5dy kernel: [  256.496025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 05 07 57
Jan 14 17:07:43 linux-v5dy kernel: [  256.566035] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d4 2a 4e c3
Jan 14 17:07:43 linux-v5dy kernel: [  256.636026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 1e 4f f3
Jan 14 17:07:43 linux-v5dy kernel: [  256.706037] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 87 72 07 76
Jan 14 17:07:43 linux-v5dy kernel: [  256.776027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 ed e0 05
Jan 14 17:07:43 linux-v5dy kernel: [  256.846025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 57 4f 3c
Jan 14 17:07:43 linux-v5dy kernel: [  256.916025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d4 0f 27 74
Jan 14 17:07:43 linux-v5dy kernel: [  256.986032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 02 d6 74
Jan 14 17:07:43 linux-v5dy kernel: [  257.056025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 94 01 f4 01
Jan 14 17:07:43 linux-v5dy kernel: [  257.126025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 04 bf a2 29
Jan 14 17:07:43 linux-v5dy kernel: [  257.196027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 94 03 f4 05
Jan 14 17:07:44 linux-v5dy kernel: [  257.266028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 04 a5 f3 28
Jan 14 17:07:44 linux-v5dy kernel: [  257.336027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 83 33 d4 01
Jan 14 17:07:44 linux-v5dy kernel: [  257.406025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 97 35 f7 01
Jan 14 17:07:44 linux-v5dy kernel: [  257.476026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 04 85 b3 36
Jan 14 17:07:44 linux-v5dy kernel: [  257.546025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 08 d6 11
Jan 14 17:07:44 linux-v5dy kernel: [  257.616026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 05 07 57
Jan 14 17:07:44 linux-v5dy kernel: [  257.686025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 3f f8 d6 55
Jan 14 17:07:44 linux-v5dy kernel: [  257.756026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 05 07 57
Jan 14 17:07:44 linux-v5dy kernel: [  257.826025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 97 3b f7 01
Jan 14 17:07:44 linux-v5dy kernel: [  257.896025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 04 91 b3 3c
Jan 14 17:07:44 linux-v5dy kernel: [  257.966032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 3f f8 d5 03
Jan 14 17:07:44 linux-v5dy kernel: [  258.036026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 77 e0 05
Jan 14 17:07:44 linux-v5dy kernel: [  258.106026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 57 d8 8d
Jan 14 17:07:44 linux-v5dy kernel: [  258.176025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f4 88 d8 ae
Jan 14 17:07:45 linux-v5dy kernel: [  258.262032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 08 87 94 43
Jan 14 17:07:45 linux-v5dy kernel: [  258.332033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 84 42 08 84
Jan 14 17:07:45 linux-v5dy kernel: [  258.402034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 88 d6 52
Jan 14 17:07:45 linux-v5dy kernel: [  258.472026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 05 07 3b
Jan 14 17:07:45 linux-v5dy kernel: [  258.542025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a7 31 d5 06
Jan 14 17:07:45 linux-v5dy kernel: [  258.612025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 9c ec bf
Jan 14 17:07:45 linux-v5dy kernel: [  258.682025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 29 f3 28
Jan 14 17:07:45 linux-v5dy kernel: [  258.752026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 87 35 d5 0e
Jan 14 17:07:45 linux-v5dy kernel: [  258.822025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 98 94 05
Jan 14 17:07:45 linux-v5dy kernel: [  258.892025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f4 01 04 bf
Jan 14 17:07:45 linux-v5dy kernel: [  258.962025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a2 29 f7 28
Jan 14 17:07:45 linux-v5dy kernel: [  259.032025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 83 75 b3 36
Jan 14 17:07:45 linux-v5dy kernel: [  259.102025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 94 31 23 34
Jan 14 17:07:45 linux-v5dy kernel: [  259.172025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f4 01 04 b9
Jan 14 17:07:46 linux-v5dy kernel: [  259.242026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d4 03 2f f8
Jan 14 17:07:46 linux-v5dy kernel: [  259.312026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d4 0c 07 74
Jan 14 17:07:46 linux-v5dy kernel: [  259.382032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 0e d6 da
Jan 14 17:07:46 linux-v5dy kernel: [  259.452025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 05 07 57
Jan 14 17:07:46 linux-v5dy kernel: [  259.522025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a7 31 d6 75
Jan 14 17:07:46 linux-v5dy kernel: [  259.592025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 05 07 57
Jan 14 17:07:46 linux-v5dy kernel: [  259.662025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 86 53 d4 00
Jan 14 17:07:46 linux-v5dy kernel: [  259.732029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c4 f0 1c ca
Jan 14 17:07:46 linux-v5dy kernel: [  259.802026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d8 60 a8 83
Jan 14 17:07:46 linux-v5dy kernel: [  259.872025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 86 62 08 86
Jan 14 17:07:46 linux-v5dy kernel: [  259.942025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f5 88 a8 83
Jan 14 17:07:46 linux-v5dy kernel: [  260.012025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 88 e0 04
Jan 14 17:07:46 linux-v5dy kernel: [  260.082025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 7a d2 11
Jan 14 17:07:46 linux-v5dy kernel: [  260.152025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 83 18 e0 02
Jan 14 17:07:47 linux-v5dy kernel: [  260.222025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 76 f0 02
Jan 14 17:07:47 linux-v5dy kernel: [  260.292025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d2 54 f5 28
Jan 14 17:07:47 linux-v5dy kernel: [  260.362032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 16 50 5d d0
Jan 14 17:07:47 linux-v5dy kernel: [  260.432025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 40 65 a3 2f
Jan 14 17:07:47 linux-v5dy kernel: [  260.502025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a3 39 f5 38
Jan 14 17:07:47 linux-v5dy kernel: [  260.572025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 16 50 5d 0d
Jan 14 17:07:47 linux-v5dy kernel: [  260.642025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 40 65 b2 22
Jan 14 17:07:47 linux-v5dy kernel: [  260.712032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 00 a2 25
Jan 14 17:07:47 linux-v5dy kernel: [  260.782025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a1 13 f4 28
Jan 14 17:07:47 linux-v5dy kernel: [  260.852025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 4d 0c f5 05
Jan 14 17:07:47 linux-v5dy kernel: [  260.922025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 04 e0 b2 22
Jan 14 17:07:47 linux-v5dy kernel: [  260.992025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 28 d5 01
Jan 14 17:07:47 linux-v5dy kernel: [  261.062025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 86 4f 7d e9
Jan 14 17:07:47 linux-v5dy kernel: [  261.132025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 10 15 65
Jan 14 17:07:47 linux-v5dy kernel: [  261.202024] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 74 45 73 35
Jan 14 17:07:48 linux-v5dy kernel: [  261.272025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 70 05 20 00
Jan 14 17:07:48 linux-v5dy kernel: [  261.342034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 23 33 24 44
Jan 14 17:07:48 linux-v5dy kernel: [  261.412025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 80 0f 83 3f
Jan 14 17:07:48 linux-v5dy kernel: [  261.482025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 84 4f 15 40
Jan 14 17:07:48 linux-v5dy kernel: [  261.552025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 16 43 23 53
Jan 14 17:07:48 linux-v5dy kernel: [  261.622025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 24 60 d5 09
Jan 14 17:07:48 linux-v5dy kernel: [  261.692025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 00 c0 40
Jan 14 17:07:48 linux-v5dy kernel: [  261.762026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 82 03 36 04
Jan 14 17:07:48 linux-v5dy kernel: [  261.832025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 5e e3 86 62
Jan 14 17:07:48 linux-v5dy kernel: [  261.902027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b6 62 26 62
Jan 14 17:07:48 linux-v5dy kernel: [  261.972025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 10 06 82 23
Jan 14 17:07:48 linux-v5dy kernel: [  262.042025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b5 52 f5 05
Jan 14 17:07:48 linux-v5dy kernel: [  262.112026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 04 fe c5 72
Jan 14 17:07:48 linux-v5dy kernel: [  262.182025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 36 05 c5 01
Jan 14 17:07:49 linux-v5dy kernel: [  262.252025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 65 86 6f
Jan 14 17:07:49 linux-v5dy kernel: [  262.322036] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 80 65 a7 11
Jan 14 17:07:49 linux-v5dy kernel: [  262.392025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 02 d6 20
Jan 14 17:07:49 linux-v5dy kernel: [  262.462026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 05 07 57
Jan 14 17:07:49 linux-v5dy kernel: [  262.532025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 8d f3 1c
Jan 14 17:07:49 linux-v5dy kernel: [  262.602027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 67 51 a7 79
Jan 14 17:07:49 linux-v5dy kernel: [  262.672025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 87 77 d5 06
Jan 14 17:07:49 linux-v5dy kernel: [  262.743026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 37 e0 05
Jan 14 17:07:49 linux-v5dy kernel: [  262.813025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 57 a7 01
Jan 14 17:07:49 linux-v5dy kernel: [  262.883025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 02 d6 fc
Jan 14 17:07:49 linux-v5dy kernel: [  262.953025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 05 07 57
Jan 14 17:07:49 linux-v5dy kernel: [  263.023025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 87 09 d5 03
Jan 14 17:07:49 linux-v5dy kernel: [  263.093025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 10 e0 05
Jan 14 17:07:49 linux-v5dy kernel: [  263.163027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 57 f0 02
Jan 14 17:07:50 linux-v5dy kernel: [  263.233026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 8b f3 58
Jan 14 17:07:50 linux-v5dy kernel: [  263.303034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b2 02 f2 01
Jan 14 17:07:50 linux-v5dy kernel: [  263.373026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 05 41 b7 14
Jan 14 17:07:50 linux-v5dy kernel: [  263.443025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 0c d6 b0
Jan 14 17:07:50 linux-v5dy kernel: [  263.513025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 05 07 57
Jan 14 17:07:50 linux-v5dy kernel: [  263.583025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c2 05 37 12
Jan 14 17:07:50 linux-v5dy kernel: [  263.653025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 0d d6 b4
Jan 14 17:07:50 linux-v5dy kernel: [  263.723026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 05 07 57
Jan 14 17:07:50 linux-v5dy kernel: [  263.793025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d2 68 33 12
Jan 14 17:07:50 linux-v5dy kernel: [  263.863025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a7 31 d5 0d
Jan 14 17:07:50 linux-v5dy kernel: [  263.933027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 cf e0 05
Jan 14 17:07:50 linux-v5dy kernel: [  264.003025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 3b c5 27
Jan 14 17:07:50 linux-v5dy kernel: [  264.073026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f5 09 b0 02
Jan 14 17:07:50 linux-v5dy kernel: [  264.143025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 06 c5 70
Jan 14 17:07:50 linux-v5dy kernel: [  264.213025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 05 07 c3
Jan 14 17:07:51 linux-v5dy kernel: [  264.283037] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 85 73 86 75
Jan 14 17:07:51 linux-v5dy kernel: [  264.353025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d4 01 2d d8
Jan 14 17:07:51 linux-v5dy kernel: [  264.423027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2e e8 d4 0f
Jan 14 17:07:51 linux-v5dy kernel: [  264.493025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 4c c3 26 64
Jan 14 17:07:51 linux-v5dy kernel: [  264.563025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 94 31 25 54
Jan 14 17:07:51 linux-v5dy kernel: [  264.633025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 13 35 03 36
Jan 14 17:07:51 linux-v5dy kernel: [  264.703026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 1f e9 95 21
Jan 14 17:07:51 linux-v5dy kernel: [  264.773030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 1d f9 20 05
Jan 14 17:07:51 linux-v5dy kernel: [  264.843029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 01 05 5d
Jan 14 17:07:51 linux-v5dy kernel: [  264.913025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 22 27 a3 33
Jan 14 17:07:51 linux-v5dy kernel: [  264.983025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 13 37 84 39
Jan 14 17:07:51 linux-v5dy kernel: [  265.053032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 13 34 ed 39
Jan 14 17:07:51 linux-v5dy kernel: [  265.123025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 10 ed d5 8b
Jan 14 17:07:51 linux-v5dy kernel: [  265.193027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f5 3c f0 02
Jan 14 17:07:52 linux-v5dy kernel: [  265.263035] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d8 01 2d 18
Jan 14 17:07:52 linux-v5dy kernel: [  265.333026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 8b 92 0b b9
Jan 14 17:07:52 linux-v5dy kernel: [  265.403025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b6 34 16 6b
Jan 14 17:07:52 linux-v5dy kernel: [  265.473025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 8b 19 2f b8
Jan 14 17:07:52 linux-v5dy kernel: [  265.543025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: da 08 d7 12
Jan 14 17:07:52 linux-v5dy kernel: [  265.613025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 47 ab 07 79
Jan 14 17:07:52 linux-v5dy kernel: [  265.683025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 73 0a 67
Jan 14 17:07:52 linux-v5dy kernel: [  265.753025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 8a a3 d2 80
Jan 14 17:07:52 linux-v5dy kernel: [  265.823025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d4 01 d5 10
Jan 14 17:07:52 linux-v5dy kernel: [  265.893025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 05 5a 85 5b
Jan 14 17:07:52 linux-v5dy kernel: [  265.963025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2a 52 aa a5
Jan 14 17:07:52 linux-v5dy kernel: [  266.033032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 8a a5 5c a6
Jan 14 17:07:52 linux-v5dy kernel: [  266.103025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 5d 7a 2c 89
Jan 14 17:07:52 linux-v5dy kernel: [  266.173025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: da 85 f2 a8
Jan 14 17:07:53 linux-v5dy kernel: [  266.243026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 01 05 80
Jan 14 17:07:53 linux-v5dy kernel: [  266.313025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d8 00 f2 0d
Jan 14 17:07:53 linux-v5dy kernel: [  266.383025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 80 02 23
Jan 14 17:07:53 linux-v5dy kernel: [  266.453025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 13 32 09 38
Jan 14 17:07:53 linux-v5dy kernel: [  266.523025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2a 52 8a a4
Jan 14 17:07:53 linux-v5dy kernel: [  266.593025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 16 a0 f9 05
Jan 14 17:07:53 linux-v5dy kernel: [  266.663025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 05 91 a9 60
Jan 14 17:07:53 linux-v5dy kernel: [  266.733025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d8 01 89 92
Jan 14 17:07:53 linux-v5dy kernel: [  266.803025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 19 89 db 00
Jan 14 17:07:53 linux-v5dy kernel: [  266.873025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: cb 01 46 9b
Jan 14 17:07:53 linux-v5dy kernel: [  266.943025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 86 62 06 68
Jan 14 17:07:53 linux-v5dy kernel: [  267.013032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: da 8c fa 6c
Jan 14 17:07:53 linux-v5dy kernel: [  267.083023] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 d0 16
Jan 14 17:07:53 linux-v5dy kernel: [  267.153025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 0c e0 00
Jan 14 17:07:54 linux-v5dy kernel: [  267.223025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 76 d0 b9
Jan 14 17:07:54 linux-v5dy kernel: [  267.293027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 00 f0 1c
Jan 14 17:07:54 linux-v5dy kernel: [  267.363025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 c1 ff
Jan 14 17:07:54 linux-v5dy kernel: [  267.433025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d2 06 c2 60
Jan 14 17:07:54 linux-v5dy kernel: [  267.503025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 02 07 c3
Jan 14 17:07:54 linux-v5dy kernel: [  267.573025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 00 c3 fb
Jan 14 17:07:54 linux-v5dy kernel: [  267.643025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 4d 3c d3 64
Jan 14 17:07:54 linux-v5dy kernel: [  267.713027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c3 f8 4e c3
Jan 14 17:07:54 linux-v5dy kernel: [  267.783026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 20 de d2 0a
Jan 14 17:07:54 linux-v5dy kernel: [  267.853025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c2 20 e0 02
Jan 14 17:07:54 linux-v5dy kernel: [  267.923025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 c3 83 33
Jan 14 17:07:54 linux-v5dy kernel: [  267.993032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d4 ff 4c c3
Jan 14 17:07:54 linux-v5dy kernel: [  268.063025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 00 13 34
Jan 14 17:07:54 linux-v5dy kernel: [  268.133025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d2 26 c2 80
Jan 14 17:07:54 linux-v5dy kernel: [  268.203027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 02 07 7a
Jan 14 17:07:55 linux-v5dy kernel: [  268.273025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d2 03 c2 40
Jan 14 17:07:55 linux-v5dy kernel: [  268.343025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 02 07 c3
Jan 14 17:07:55 linux-v5dy kernel: [  268.413025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 82 3a 82 2d
Jan 14 17:07:55 linux-v5dy kernel: [  268.483025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d8 07 c8 01
Jan 14 17:07:55 linux-v5dy kernel: [  268.553025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 15 82 f5 01
Jan 14 17:07:55 linux-v5dy kernel: [  268.623025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 05 c8 d8 39
Jan 14 17:07:55 linux-v5dy kernel: [  268.693026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c8 01 15 82
Jan 14 17:07:55 linux-v5dy kernel: [  268.763025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f5 01 05 c8
Jan 14 17:07:55 linux-v5dy kernel: [  268.833025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d2 00 a2 29
Jan 14 17:07:55 linux-v5dy kernel: [  268.903025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d8 0b 73 38
Jan 14 17:07:55 linux-v5dy kernel: [  268.973032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d8 0a 64 48
Jan 14 17:07:55 linux-v5dy kernel: [  269.043025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 84 4b 07 34
Jan 14 17:07:55 linux-v5dy kernel: [  269.113025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 18 72 f8 01
Jan 14 17:07:55 linux-v5dy kernel: [  269.183025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 05 d9 b8 78
Jan 14 17:07:56 linux-v5dy kernel: [  269.253026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b1 12 f1 01
Jan 14 17:07:56 linux-v5dy kernel: [  269.323026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 05 d9 28 80
Jan 14 17:07:56 linux-v5dy kernel: [  269.393025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f8 05 05 9f
Jan 14 17:07:56 linux-v5dy kernel: [  269.463025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 e0 00
Jan 14 17:07:56 linux-v5dy kernel: [  269.533025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 b9 c2 ff
Jan 14 17:07:56 linux-v5dy kernel: [  269.603027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f2 09 d3 00
Jan 14 17:07:56 linux-v5dy kernel: [  269.673025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 2b e0 01
Jan 14 17:07:56 linux-v5dy kernel: [  269.743026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 76 d1 00
Jan 14 17:07:56 linux-v5dy kernel: [  269.813025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c1 f0 d0 0e
Jan 14 17:07:56 linux-v5dy kernel: [  269.883030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 01 07 7a
Jan 14 17:07:56 linux-v5dy kernel: [  269.953033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b0 02 a1 13
Jan 14 17:07:56 linux-v5dy kernel: [  270.023025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 05 05 e5
Jan 14 17:07:56 linux-v5dy kernel: [  270.093025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 23 e0 01
Jan 14 17:07:56 linux-v5dy kernel: [  270.163025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 7a f0 02
Jan 14 17:07:57 linux-v5dy kernel: [  270.233025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 01 d0 02
Jan 14 17:07:57 linux-v5dy kernel: [  270.303025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 07 76
Jan 14 17:07:57 linux-v5dy kernel: [  270.373025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 03 e0 00
Jan 14 17:07:57 linux-v5dy kernel: [  270.443025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 76 f0 02
Jan 14 17:07:57 linux-v5dy kernel: [  270.513025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 87 f0 08
Jan 14 17:07:57 linux-v5dy kernel: [  270.583025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 81 0f d2 02
Jan 14 17:07:57 linux-v5dy kernel: [  270.653025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2d de f1 0d
Jan 14 17:07:57 linux-v5dy kernel: [  270.723026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a1 13 d0 82
Jan 14 17:07:57 linux-v5dy kernel: [  270.793025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 1c f0 02
Jan 14 17:07:57 linux-v5dy kernel: [  270.863025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 02 07 df
Jan 14 17:07:57 linux-v5dy kernel: [  270.933034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 70 44 fe
Jan 14 17:07:57 linux-v5dy kernel: [  271.003025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 0d 45 ef
Jan 14 17:07:57 linux-v5dy kernel: [  271.073025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2d c9 2c c5
Jan 14 17:07:57 linux-v5dy kernel: [  271.143025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 01 06 33
Jan 14 17:07:57 linux-v5dy kernel: [  271.213025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 02 07 df
Jan 14 17:07:58 linux-v5dy kernel: [  271.283029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 0a 5f d3
Jan 14 17:07:58 linux-v5dy kernel: [  271.353026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 01 06 21
Jan 14 17:07:58 linux-v5dy kernel: [  271.423028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f5 0d 5e 3d
Jan 14 17:07:58 linux-v5dy kernel: [  271.493025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 01 06 21
Jan 14 17:07:58 linux-v5dy kernel: [  271.563025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 0a 5f d8
Jan 14 17:07:58 linux-v5dy kernel: [  271.633025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: db 01 f7 01
Jan 14 17:07:58 linux-v5dy kernel: [  271.703028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 2a f5 0d
Jan 14 17:07:58 linux-v5dy kernel: [  271.773026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 5e c9 fb 0d
Jan 14 17:07:58 linux-v5dy kernel: [  271.843026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 01 06 2a
Jan 14 17:07:58 linux-v5dy kernel: [  271.913032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 00 ee 4d
Jan 14 17:07:58 linux-v5dy kernel: [  271.983025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: da 89 f9 a8
Jan 14 17:07:58 linux-v5dy kernel: [  272.053025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 82 f0 08
Jan 14 17:07:58 linux-v5dy kernel: [  272.123025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2b 30 09 9b
Jan 14 17:07:58 linux-v5dy kernel: [  272.193027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fa 9c d0 01
Jan 14 17:07:59 linux-v5dy kernel: [  272.263027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ee 4d da 83
Jan 14 17:07:59 linux-v5dy kernel: [  272.333026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f5 a8 05 5b
Jan 14 17:07:59 linux-v5dy kernel: [  272.403025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fa 5c d4 15
Jan 14 17:07:59 linux-v5dy kernel: [  272.473026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 04 07 76
Jan 14 17:07:59 linux-v5dy kernel: [  272.543025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 02 ee 4d
Jan 14 17:07:59 linux-v5dy kernel: [  272.613026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: da 86 f3 a8
Jan 14 17:07:59 linux-v5dy kernel: [  272.683032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: da 89 f1 01
Jan 14 17:07:59 linux-v5dy kernel: [  272.753026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 3c a9 31
Jan 14 17:07:59 linux-v5dy kernel: [  272.823025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fa 9c d0 01
Jan 14 17:07:59 linux-v5dy kernel: [  272.893032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ee 4d f9 a8
Jan 14 17:07:59 linux-v5dy kernel: [  272.963025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: db 30 47 d3
Jan 14 17:07:59 linux-v5dy kernel: [  273.033025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 46 3d f7 05
Jan 14 17:07:59 linux-v5dy kernel: [  273.103025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 49 f6 01
Jan 14 17:07:59 linux-v5dy kernel: [  273.173025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 4a da b9
Jan 14 17:08:00 linux-v5dy kernel: [  273.243025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: db 01 fa bc
Jan 14 17:08:00 linux-v5dy kernel: [  273.313027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 01 ee 33
Jan 14 17:08:00 linux-v5dy kernel: [  273.383026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fb 0d 09 3b
Jan 14 17:08:00 linux-v5dy kernel: [  273.453025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fa 9c d0 01
Jan 14 17:08:00 linux-v5dy kernel: [  273.523025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 8b 38
Jan 14 17:08:00 linux-v5dy kernel: [  273.593025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 16 0b ab 60
Jan 14 17:08:00 linux-v5dy kernel: [  273.663032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fb 05 06 54
Jan 14 17:08:00 linux-v5dy kernel: [  273.733026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 0d d4 84
Jan 14 17:08:00 linux-v5dy kernel: [  273.806736] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f4 48 8a 29
Jan 14 17:08:00 linux-v5dy kernel: [  273.876045] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: db 03 2f ab
Jan 14 17:08:00 linux-v5dy kernel: [  273.946027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a9 b6 f9 05
Jan 14 17:08:00 linux-v5dy kernel: [  274.016027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 63 a9 b4
Jan 14 17:08:00 linux-v5dy kernel: [  274.086025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 05 06 67
Jan 14 17:08:00 linux-v5dy kernel: [  274.156025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: db 00 d5 00
Jan 14 17:08:01 linux-v5dy kernel: [  274.226027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c5 01 ee 69
Jan 14 17:08:01 linux-v5dy kernel: [  274.296027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 00 d9 c0
Jan 14 17:08:01 linux-v5dy kernel: [  274.366027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fb 98 ee 69
Jan 14 17:08:01 linux-v5dy kernel: [  274.436025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 00 db 70
Jan 14 17:08:01 linux-v5dy kernel: [  274.506025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 46 b4 d9 85
Jan 14 17:08:01 linux-v5dy kernel: [  274.576025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 98 2a 69
Jan 14 17:08:01 linux-v5dy kernel: [  274.646027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 9a ae 06 6a
Jan 14 17:08:01 linux-v5dy kernel: [  274.716029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b4 42 f4 05
Jan 14 17:08:01 linux-v5dy kernel: [  274.786029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 77 d7 00
Jan 14 17:08:01 linux-v5dy kernel: [  274.856033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c7 08 17 75
Jan 14 17:08:01 linux-v5dy kernel: [  274.926025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 17 76 ee 78
Jan 14 17:08:01 linux-v5dy kernel: [  274.996030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 17 65 d9 00
Jan 14 17:08:01 linux-v5dy kernel: [  275.066028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c9 02 09 95
Jan 14 17:08:01 linux-v5dy kernel: [  275.136027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 09 9b da 8c
Jan 14 17:08:01 linux-v5dy kernel: [  275.206027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: fa a8 db 01
Jan 14 17:08:02 linux-v5dy kernel: [  275.276026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2f ba 9a a2
Jan 14 17:08:02 linux-v5dy kernel: [  275.346028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 19 9a da 00
Jan 14 17:08:02 linux-v5dy kernel: [  275.416027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ca 08 16 a9
Jan 14 17:08:02 linux-v5dy kernel: [  275.486027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 47 9b d9 08
Jan 14 17:08:02 linux-v5dy kernel: [  275.556025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 09 79 88 99
Jan 14 17:08:02 linux-v5dy kernel: [  275.626032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 89 88 15 97
Jan 14 17:08:02 linux-v5dy kernel: [  275.696033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d9 81 f9 5c
Jan 14 17:08:02 linux-v5dy kernel: [  275.766027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d9 83 f9 8c
Jan 14 17:08:02 linux-v5dy kernel: [  275.836035] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 15 e0 07
Jan 14 17:08:02 linux-v5dy kernel: [  275.906025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 76 fb 01
Jan 14 17:08:02 linux-v5dy kernel: [  275.976025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 9e d9 08
Jan 14 17:08:02 linux-v5dy kernel: [  276.046027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 09 69 88 99
Jan 14 17:08:02 linux-v5dy kernel: [  276.116027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 89 88 15 96
Jan 14 17:08:02 linux-v5dy kernel: [  276.186027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d9 81 f9 5c
Jan 14 17:08:03 linux-v5dy kernel: [  276.256026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a7 75 e0 07
Jan 14 17:08:03 linux-v5dy kernel: [  276.326024] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 7a d7 87
Jan 14 17:08:03 linux-v5dy kernel: [  276.396025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 78 d8 09
Jan 14 17:08:03 linux-v5dy kernel: [  276.466027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 77 78 88 b6
Jan 14 17:08:03 linux-v5dy kernel: [  276.536044] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 17 7c d6 1d
Jan 14 17:08:03 linux-v5dy kernel: [  276.606048] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 06 07 76
Jan 14 17:08:03 linux-v5dy kernel: [  276.676029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 d6 82
Jan 14 17:08:03 linux-v5dy kernel: [  276.746035] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 68 a6 63
Jan 14 17:08:03 linux-v5dy kernel: [  276.816027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 08 04 07
Jan 14 17:08:03 linux-v5dy kernel: [  276.886028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 84 49 f6 05
Jan 14 17:08:03 linux-v5dy kernel: [  276.956036] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 b3 03 41
Jan 14 17:08:03 linux-v5dy kernel: [  277.026166] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d8 01 ee b5
Jan 14 17:08:03 linux-v5dy kernel: [  277.096142] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 13 41 d8 00
Jan 14 17:08:03 linux-v5dy kernel: [  277.166025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 d0 00
Jan 14 17:08:04 linux-v5dy kernel: [  277.236022] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 2c e0 00
Jan 14 17:08:04 linux-v5dy kernel: [  277.306028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 76 f0 02
Jan 14 17:08:04 linux-v5dy kernel: [  277.376026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 2c d1 01
Jan 14 17:08:04 linux-v5dy kernel: [  277.446028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 07 76
Jan 14 17:08:04 linux-v5dy kernel: [  277.516030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 16 d1 12
Jan 14 17:08:04 linux-v5dy kernel: [  277.586041] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 07 76
Jan 14 17:08:04 linux-v5dy kernel: [  277.656027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 b9 d1 02
Jan 14 17:08:04 linux-v5dy kernel: [  277.726028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 1c f0 02
Jan 14 17:08:04 linux-v5dy kernel: [  277.796029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 89 f0 08
Jan 14 17:08:04 linux-v5dy kernel: [  277.866027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 b2 f1 18
Jan 14 17:08:04 linux-v5dy kernel: [  277.936028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d2 87 f2 28
Jan 14 17:08:04 linux-v5dy kernel: [  278.006027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 03 05 f7
Jan 14 17:08:04 linux-v5dy kernel: [  278.076029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 06 a8
Jan 14 17:08:04 linux-v5dy kernel: [  278.146026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 80 c6 01
Jan 14 17:08:05 linux-v5dy kernel: [  278.216025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 5f 3e 88 82
Jan 14 17:08:05 linux-v5dy kernel: [  278.286028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 87 d5 08
Jan 14 17:08:05 linux-v5dy kernel: [  278.356027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 76 e0 05
Jan 14 17:08:05 linux-v5dy kernel: [  278.426028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 57 d7 bc
Jan 14 17:08:05 linux-v5dy kernel: [  278.496025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f7 78 f7 05
Jan 14 17:08:05 linux-v5dy kernel: [  278.566033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 ef d6 40
Jan 14 17:08:05 linux-v5dy kernel: [  278.636027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c6 0b d8 89
Jan 14 17:08:05 linux-v5dy kernel: [  278.706036] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 5f 3e f7 05
Jan 14 17:08:05 linux-v5dy kernel: [  278.776028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 eb d8 86
Jan 14 17:08:05 linux-v5dy kernel: [  278.846025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 60 c6 09
Jan 14 17:08:05 linux-v5dy kernel: [  278.916025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 5f 3e f7 05
Jan 14 17:08:05 linux-v5dy kernel: [  278.986027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 06 eb d8 02
Jan 14 17:08:05 linux-v5dy kernel: [  279.056027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 0a d7 81
Jan 14 17:08:05 linux-v5dy kernel: [  279.126027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 06 07 57
Jan 14 17:08:05 linux-v5dy kernel: [  279.196027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a7 21 a9 41
Jan 14 17:08:06 linux-v5dy kernel: [  279.266027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a6 01 e0 06
Jan 14 17:08:06 linux-v5dy kernel: [  279.336028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 05 61 a4 81
Jan 14 17:08:06 linux-v5dy kernel: [  279.406027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d9 82 4d 49
Jan 14 17:08:06 linux-v5dy kernel: [  279.476027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 8a 29 db 01
Jan 14 17:08:06 linux-v5dy kernel: [  279.546032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2f ab ab b3
Jan 14 17:08:06 linux-v5dy kernel: [  279.616032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 29 b9 d8 19
Jan 14 17:08:06 linux-v5dy kernel: [  279.686063] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c8 80 e0 08
Jan 14 17:08:06 linux-v5dy kernel: [  279.756028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 7a d8 82
Jan 14 17:08:06 linux-v5dy kernel: [  279.826027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 18 48 a5 85
Jan 14 17:08:06 linux-v5dy kernel: [  279.896028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 1c d7 30
Jan 14 17:08:06 linux-v5dy kernel: [  279.966025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 06 07 57
Jan 14 17:08:06 linux-v5dy kernel: [  280.036025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f5 05 07 12
Jan 14 17:08:06 linux-v5dy kernel: [  280.106030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d8 00 d7 ee
Jan 14 17:08:06 linux-v5dy kernel: [  280.176027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 06 07 3b
Jan 14 17:08:07 linux-v5dy kernel: [  280.246027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 1d d7 42
Jan 14 17:08:07 linux-v5dy kernel: [  280.316025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 06 07 3b
Jan 14 17:08:07 linux-v5dy kernel: [  280.386025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ef 1b d8 0f
Jan 14 17:08:07 linux-v5dy kernel: [  280.456027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 1d d7 42
Jan 14 17:08:07 linux-v5dy kernel: [  280.526034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 06 07 3b
Jan 14 17:08:07 linux-v5dy kernel: [  280.596028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 1c d7 ee
Jan 14 17:08:07 linux-v5dy kernel: [  280.666025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 06 07 3b
Jan 14 17:08:07 linux-v5dy kernel: [  280.736025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 06 4e
Jan 14 17:08:07 linux-v5dy kernel: [  280.806027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d9 01 2d 92
Jan 14 17:08:07 linux-v5dy kernel: [  280.876028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 01 07 3a
Jan 14 17:08:07 linux-v5dy kernel: [  280.946027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 8a 29 db 03
Jan 14 17:08:07 linux-v5dy kernel: [  281.016026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2f ab a9 b6
Jan 14 17:08:07 linux-v5dy kernel: [  281.086026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f9 05 07 2a
Jan 14 17:08:07 linux-v5dy kernel: [  281.156027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: da 32 ca 04
Jan 14 17:08:08 linux-v5dy kernel: [  281.226027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ef 2c da 00
Jan 14 17:08:08 linux-v5dy kernel: [  281.296028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ca 04 89 54
Jan 14 17:08:08 linux-v5dy kernel: [  281.366025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 09 9a db 00
Jan 14 17:08:08 linux-v5dy kernel: [  281.436025] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: da 0f ca a0
Jan 14 17:08:08 linux-v5dy kernel: [  281.506033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 0a 07 7a
Jan 14 17:08:08 linux-v5dy kernel: [  281.577027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d7 08 7b 97
Jan 14 17:08:08 linux-v5dy kernel: [  281.647029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 0a 07 7a
Jan 14 17:08:08 linux-v5dy kernel: [  281.717030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 6b 97 e0 0a
Jan 14 17:08:08 linux-v5dy kernel: [  281.787029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 7a f0 02
Jan 14 17:08:08 linux-v5dy kernel: [  281.857029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 07 57
Jan 14 17:08:08 linux-v5dy kernel: [  281.927029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 03 07 40
Jan 14 17:08:08 linux-v5dy kernel: [  281.997029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 d0 60
Jan 14 17:08:08 linux-v5dy kernel: [  282.067029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f1 08 d4 00
Jan 14 17:08:08 linux-v5dy kernel: [  282.138031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c4 f0 d2 10
Jan 14 17:08:08 linux-v5dy kernel: [  282.208031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a0 03 f5 08
Jan 14 17:08:09 linux-v5dy kernel: [  282.278029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a0 03 f6 08
Jan 14 17:08:09 linux-v5dy kernel: [  282.348029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 01 2f df
Jan 14 17:08:09 linux-v5dy kernel: [  282.418059] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 01 07 4f
Jan 14 17:08:09 linux-v5dy kernel: [  282.489061] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 04 07 7a
Jan 14 17:08:09 linux-v5dy kernel: [  282.559033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a4 43 81 13
Jan 14 17:08:09 linux-v5dy kernel: [  282.629033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b2 22 f2 05
Jan 14 17:08:09 linux-v5dy kernel: [  282.699031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 45 d0 60
Jan 14 17:08:09 linux-v5dy kernel: [  282.769029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 1c f0 02
Jan 14 17:08:09 linux-v5dy kernel: [  282.839028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 60 f4 38
Jan 14 17:08:09 linux-v5dy kernel: [  282.909168] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 85 03 d6 01
Jan 14 17:08:09 linux-v5dy kernel: [  282.979034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 66 65 1c ca
Jan 14 17:08:09 linux-v5dy kernel: [  283.049034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 4c a3 33
Jan 14 17:08:09 linux-v5dy kernel: [  283.119028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 03 30 f4 38
Jan 14 17:08:09 linux-v5dy kernel: [  283.189125] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a9 23 f9 0d
Jan 14 17:08:10 linux-v5dy kernel: [  283.259033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 0f 2d 1d
Jan 14 17:08:10 linux-v5dy kernel: [  283.329029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 88 19 d6 01
Jan 14 17:08:10 linux-v5dy kernel: [  283.400027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 27 d6 66 65
Jan 14 17:08:10 linux-v5dy kernel: [  283.470058] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 67 75 1c ca
Jan 14 17:08:10 linux-v5dy kernel: [  283.540030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 3c cb 16 85
Jan 14 17:08:10 linux-v5dy kernel: [  283.610029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 57 c5 87 72
Jan 14 17:08:10 linux-v5dy kernel: [  283.680029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: b7 72 05 57
Jan 14 17:08:10 linux-v5dy kernel: [  283.750030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 89 93 f6 05
Jan 14 17:08:10 linux-v5dy kernel: [  283.820029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 66 f3 4c
Jan 14 17:08:10 linux-v5dy kernel: [  283.890029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 c0 80
Jan 14 17:08:10 linux-v5dy kernel: [  283.960029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 07 7a
Jan 14 17:08:10 linux-v5dy kernel: [  284.030030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 f0 0a
Jan 14 17:08:10 linux-v5dy kernel: [  284.100029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 00 c3 9c
Jan 14 17:08:10 linux-v5dy kernel: [  284.170029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 1c c3 a0
Jan 14 17:08:11 linux-v5dy kernel: [  284.240029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 2c c3 a4
Jan 14 17:08:11 linux-v5dy kernel: [  284.310029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 0c d3 00
Jan 14 17:08:11 linux-v5dy kernel: [  284.380029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c3 a8 f3 38
Jan 14 17:08:11 linux-v5dy kernel: [  284.450037] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 01 07 82
Jan 14 17:08:11 linux-v5dy kernel: [  284.520029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 06 f0 02
Jan 14 17:08:11 linux-v5dy kernel: [  284.590028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d0 02 c0 20
Jan 14 17:08:11 linux-v5dy kernel: [  284.660028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 00 07 c3
Jan 14 17:08:11 linux-v5dy kernel: [  284.730029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d2 03 2d de
Jan 14 17:08:11 linux-v5dy kernel: [  284.800030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 80 13 2c cd
Jan 14 17:08:11 linux-v5dy kernel: [  284.870031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 d6 bb
Jan 14 17:08:11 linux-v5dy kernel: [  284.940031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f6 68 d4 01
Jan 14 17:08:11 linux-v5dy kernel: [  285.010029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2d 4c d2 67
Jan 14 17:08:11 linux-v5dy kernel: [  285.080030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c2 3c d3 c0
Jan 14 17:08:11 linux-v5dy kernel: [  285.150029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c3 02 f1 01
Jan 14 17:08:12 linux-v5dy kernel: [  285.220033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 9f a2 61
Jan 14 17:08:12 linux-v5dy kernel: [  285.290034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 80 c3 8d
Jan 14 17:08:12 linux-v5dy kernel: [  285.360029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 09 c1 f0
Jan 14 17:08:12 linux-v5dy kernel: [  285.430030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 01 07 7a
Jan 14 17:08:12 linux-v5dy kernel: [  285.500029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 bd f4 68
Jan 14 17:08:12 linux-v5dy kernel: [  285.570029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d4 01 81 03
Jan 14 17:08:12 linux-v5dy kernel: [  285.640029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 2d 4d f1 01
Jan 14 17:08:12 linux-v5dy kernel: [  285.710028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 ad d6 bf
Jan 14 17:08:12 linux-v5dy kernel: [  285.780030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f4 68 ef af
Jan 14 17:08:12 linux-v5dy kernel: [  285.850029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d6 bd f4 68
Jan 14 17:08:12 linux-v5dy kernel: [  285.920032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f4 68 d2 0e
Jan 14 17:08:12 linux-v5dy kernel: [  285.990033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 40 e0 02
Jan 14 17:08:12 linux-v5dy kernel: [  286.060034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 57 d0 60
Jan 14 17:08:12 linux-v5dy kernel: [  286.130030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 ff c1 fd
Jan 14 17:08:12 linux-v5dy kernel: [  286.200037] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 1c f0 02
Jan 14 17:08:13 linux-v5dy kernel: [  286.270029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 00 c1 98
Jan 14 17:08:13 linux-v5dy kernel: [  286.340028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f1 0c f0 02
Jan 14 17:08:13 linux-v5dy kernel: [  286.410036] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 00 c1 94
Jan 14 17:08:13 linux-v5dy kernel: [  286.480028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 18 c1 98
Jan 14 17:08:13 linux-v5dy kernel: [  286.550029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f1 18 f0 02
Jan 14 17:08:13 linux-v5dy kernel: [  286.620027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 0a d2 00
Jan 14 17:08:13 linux-v5dy kernel: [  286.690044] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c2 a4 f2 0c
Jan 14 17:08:13 linux-v5dy kernel: [  286.760031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c2 a8 f1 28
Jan 14 17:08:13 linux-v5dy kernel: [  286.830029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f1 01 07 c8
Jan 14 17:08:13 linux-v5dy kernel: [  286.900027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c2 9c f1 28
Jan 14 17:08:13 linux-v5dy kernel: [  286.974028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c2 a0 f2 28
Jan 14 17:08:13 linux-v5dy kernel: [  287.044033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 06 f0 02
Jan 14 17:08:13 linux-v5dy kernel: [  287.114029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d2 08 c2 08
Jan 14 17:08:13 linux-v5dy kernel: [  287.184051] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d3 0b c3 20
Jan 14 17:08:14 linux-v5dy kernel: [  287.254034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: e0 03 07 c3
Jan 14 17:08:14 linux-v5dy kernel: [  287.324032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 94 48 00 24
Jan 14 17:08:14 linux-v5dy kernel: [  287.395032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d5 85 f5 58
Jan 14 17:08:14 linux-v5dy kernel: [  287.465225] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 26 05 96 6e
Jan 14 17:08:14 linux-v5dy kernel: [  287.535046] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 10 06 f0 02
Jan 14 17:08:14 linux-v5dy kernel: [  287.606035] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d1 82 f1 18
Jan 14 17:08:14 linux-v5dy kernel: [  287.676030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f1 0d d2 86
Jan 14 17:08:14 linux-v5dy kernel: [  287.746030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f3 28 d2 89
Jan 14 17:08:14 linux-v5dy kernel: [  287.816030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f5 28 d6 01
Jan 14 17:08:14 linux-v5dy kernel: [  287.886029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c6 20 e0 06
Jan 14 17:08:14 linux-v5dy kernel: [  287.956029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 c3 87 78
Jan 14 17:08:14 linux-v5dy kernel: [  288.026029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 97 7c a2 71
Jan 14 17:08:14 linux-v5dy kernel: [  288.096029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: d4 81 f8 48
Jan 14 17:08:14 linux-v5dy kernel: [  288.166031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 17 78 10 35
Jan 14 17:08:15 linux-v5dy kernel: [  288.236029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 40 71 a1 71
Jan 14 17:08:15 linux-v5dy kernel: [  288.306029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: f0 02 d0 09
Jan 14 17:08:15 linux-v5dy kernel: [  288.376037] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: c0 20 e0 00
Jan 14 17:08:15 linux-v5dy kernel: [  288.446036] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 07 c3 d4 08
Jan 14 17:08:15 linux-v5dy kernel: [  288.516031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 0e d4 63 14
Jan 14 17:08:15 linux-v5dy kernel: [  288.586030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 0f f4 11 23
Jan 14 17:08:15 linux-v5dy kernel: [  288.656030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 80 14 f0 02
Jan 14 17:08:15 linux-v5dy kernel: [  288.726029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: ea 12 90 00
Jan 14 17:08:15 linux-v5dy kernel: [  288.796029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 88 00 30 00
Jan 14 17:08:15 linux-v5dy kernel: [  288.866028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 34 00 24 00
Jan 14 17:08:15 linux-v5dy kernel: [  288.936031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 6c 00 00 00
Jan 14 17:08:15 linux-v5dy kernel: [  289.006029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 00 00 00 00
Jan 14 17:08:15 linux-v5dy kernel: [  289.076029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 00 00 00 00
Jan 14 17:08:15 linux-v5dy kernel: [  289.146029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 00 00 02 13
Jan 14 17:08:16 linux-v5dy kernel: [  289.216026] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 39 a7 00 15
Jan 14 17:08:16 linux-v5dy kernel: [  289.286031] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 00 24 08 fb
Jan 14 17:08:16 linux-v5dy kernel: [  289.356040] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 00 28 00 51
Jan 14 17:08:16 linux-v5dy kernel: [  289.426029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 00 00 00 00
Jan 14 17:08:16 linux-v5dy kernel: [  289.507027] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 20 00 00 00
Jan 14 17:08:16 linux-v5dy kernel: [  289.577036] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 12 39
Jan 14 17:08:16 linux-v5dy kernel: [  289.647029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=11: 0c 80 f0 f7 3e 75 c1 8a e4 02 00
Jan 14 17:08:16 linux-v5dy kernel: [  289.717029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=7: 05 0f ee aa 5f ea 90
Jan 14 17:08:16 linux-v5dy kernel: [  289.787029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=11: 06 00 0a 4d 8c f2 d8 cf 30 79 9f
Jan 14 17:08:16 linux-v5dy kernel: [  289.857029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 0b 0d a4 6c
Jan 14 17:08:16 linux-v5dy kernel: [  289.927029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 0a 01 67 24 40 08 c3 20 10 64 3c fa f7
Jan 14 17:08:16 linux-v5dy kernel: [  289.997029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 0a e1 0c 2c
Jan 14 17:08:16 linux-v5dy kernel: [  290.067029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 09 0b
Jan 14 17:08:16 linux-v5dy kernel: [  290.137029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 10 13
Jan 14 17:08:16 linux-v5dy kernel: [  290.207029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 16 12
Jan 14 17:08:17 linux-v5dy kernel: [  290.277034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 1f 02
Jan 14 17:08:17 linux-v5dy kernel: [  290.347030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 21 02
Jan 14 17:08:17 linux-v5dy kernel: [  290.417034] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 01 02
Jan 14 17:08:17 linux-v5dy kernel: [  290.487029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 2b 10
Jan 14 17:08:17 linux-v5dy kernel: [  290.557102] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 02 02
Jan 14 17:08:17 linux-v5dy kernel: [  290.627029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 02 03
Jan 14 17:08:17 linux-v5dy kernel: [  290.697030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 00 8c
Jan 14 17:08:17 linux-v5dy kernel: [  290.767030] xc2028 9-0061: Load init1 firmware, if exists
Jan 14 17:08:17 linux-v5dy kernel: [  290.767036] xc2028 9-0061: load_firmware called
Jan 14 17:08:17 linux-v5dy kernel: [  290.767040] xc2028 9-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
Jan 14 17:08:17 linux-v5dy kernel: [  290.767053] xc2028 9-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
Jan 14 17:08:17 linux-v5dy kernel: [  290.767062] xc2028 9-0061: load_firmware called
Jan 14 17:08:17 linux-v5dy kernel: [  290.767066] xc2028 9-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
Jan 14 17:08:17 linux-v5dy kernel: [  290.767075] xc2028 9-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
Jan 14 17:08:17 linux-v5dy kernel: [  290.767084] xc2028 9-0061: load_firmware called
Jan 14 17:08:17 linux-v5dy kernel: [  290.767088] xc2028 9-0061: seek_firmware called, want type=MTS (4), id 0000000000000100.
Jan 14 17:08:17 linux-v5dy kernel: [  290.767097] xc2028 9-0061: Found firmware for type=MTS (4), id 000000000000b700.
Jan 14 17:08:17 linux-v5dy kernel: [  290.767103] xc2028 9-0061: Loading firmware for type=MTS (4), id 000000000000b700.
Jan 14 17:08:17 linux-v5dy kernel: [  290.767111] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 80 01 00 00
Jan 14 17:08:17 linux-v5dy kernel: [  290.837029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 00 cc 20 06
Jan 14 17:08:17 linux-v5dy kernel: [  290.907029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 2b 1a
Jan 14 17:08:17 linux-v5dy kernel: [  290.977029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 2b 1b
Jan 14 17:08:17 linux-v5dy kernel: [  291.047029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=12: 14 01 1b 19 b5 29 ab 09 55 44 05 65
Jan 14 17:08:17 linux-v5dy kernel: [  291.117029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=12: 13 18 08 00 00 6c 18 16 8c 49 2a ab
Jan 14 17:08:17 linux-v5dy kernel: [  291.187029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=13: 0d 01 4b 03 97 55 c7 d7 00 a1 eb 8f 5c
Jan 14 17:08:18 linux-v5dy kernel: [  291.257029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=10: 1a 00 00 16 8a 40 00 00 00 20
Jan 14 17:08:18 linux-v5dy kernel: [  291.327030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 2d 01
Jan 14 17:08:18 linux-v5dy kernel: [  291.397029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 18 00
Jan 14 17:08:18 linux-v5dy kernel: [  291.467029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=12: 1b 0d 86 51 d2 35 a4 92 a5 b5 25 65
Jan 14 17:08:18 linux-v5dy kernel: [  291.537036] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 1d 00
Jan 14 17:08:18 linux-v5dy kernel: [  291.607030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=7: 0f 00 29 56 b0 00 b6
Jan 14 17:08:18 linux-v5dy kernel: [  291.677029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 20 00
Jan 14 17:08:18 linux-v5dy kernel: [  291.747029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=12: 1e 09 02 5b 6c 00 4b 81 56 46 69 0b
Jan 14 17:08:18 linux-v5dy kernel: [  291.817030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 22 32
Jan 14 17:08:18 linux-v5dy kernel: [  291.887029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 23 0a
Jan 14 17:08:18 linux-v5dy kernel: [  291.957029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=9: 25 00 09 90 09 06 64 02 41
Jan 14 17:08:18 linux-v5dy kernel: [  292.027029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 26 cc
Jan 14 17:08:18 linux-v5dy kernel: [  292.097029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 29 40
Jan 14 17:08:18 linux-v5dy kernel: [  292.167030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 21 03
Jan 14 17:08:19 linux-v5dy kernel: [  292.237030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 00 8c
Jan 14 17:08:19 linux-v5dy kernel: [  292.307033] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 00 00 00 00
Jan 14 17:08:19 linux-v5dy kernel: [  292.377029] xc2028 9-0061: Trying to load scode 0
Jan 14 17:08:19 linux-v5dy kernel: [  292.377035] xc2028 9-0061: load_scode called
Jan 14 17:08:19 linux-v5dy kernel: [  292.377039] xc2028 9-0061: seek_firmware called, want type=MTS SCODE (20000004), id 000000000000b700.
Jan 14 17:08:19 linux-v5dy kernel: [  292.377050] xc2028 9-0061: Found firmware for type=MTS SCODE (20000004), id 000000000000b700.
Jan 14 17:08:19 linux-v5dy kernel: [  292.377058] xc2028 9-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
Jan 14 17:08:19 linux-v5dy kernel: [  292.377073] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: a0 00 00 00
Jan 14 17:08:19 linux-v5dy kernel: [  292.447029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=12: 1e 09 02 5b 6c 00 4b 81 56 46 69 0b
Jan 14 17:08:19 linux-v5dy kernel: [  292.517036] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 00 8c
Jan 14 17:08:19 linux-v5dy kernel: [  292.587028] xc2028 9-0061: xc2028_get_reg 0004 called
Jan 14 17:08:19 linux-v5dy kernel: [  292.587034] tm6000 #0 at tm6000_i2c_xfer: write nonstop addr=0xc2 len=2: 00 04
Jan 14 17:08:19 linux-v5dy kernel: [  292.587041] tm6000 #0 at tm6000_i2c_xfer: ; joined to read stop len=2: 20 36
Jan 14 17:08:19 linux-v5dy kernel: [  292.658028] xc2028 9-0061: xc2028_get_reg 0008 called
Jan 14 17:08:19 linux-v5dy kernel: [  292.658034] tm6000 #0 at tm6000_i2c_xfer: write nonstop addr=0xc2 len=2: 00 08
Jan 14 17:08:19 linux-v5dy kernel: [  292.658041] tm6000 #0 at tm6000_i2c_xfer: ; joined to read stop len=2: 0b d4
Jan 14 17:08:19 linux-v5dy kernel: [  292.729030] xc2028 9-0061: Device is Xceive 3028 version 2.0, firmware version 3.6
Jan 14 17:08:19 linux-v5dy kernel: [  292.729037] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 00 00
Jan 14 17:08:19 linux-v5dy kernel: [  292.799030] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 80 02 00 00
Jan 14 17:08:19 linux-v5dy kernel: [  292.934029] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 00 00 64 00
Jan 14 17:08:19 linux-v5dy kernel: [  293.105043] xc2028 9-0061: divisor= 00 00 64 00 (freq=400.000)
Jan 14 17:08:19 linux-v5dy kernel: [  293.105052] tuner 9-0061: tv freq set to 193.25
Jan 14 17:08:19 linux-v5dy kernel: [  293.105057] xc2028 9-0061: xc2028_set_analog_freq called
Jan 14 17:08:19 linux-v5dy kernel: [  293.105063] xc2028 9-0061: generic_set_freq called
Jan 14 17:08:19 linux-v5dy kernel: [  293.105068] xc2028 9-0061: should set frequency 193250 kHz
Jan 14 17:08:19 linux-v5dy kernel: [  293.105072] xc2028 9-0061: check_firmware called
Jan 14 17:08:19 linux-v5dy kernel: [  293.105076] xc2028 9-0061: checking firmware, user requested type=MTS (4), id 0000000000000100, scode_tbl (0), scode_nr 0
Jan 14 17:08:19 linux-v5dy kernel: [  293.105087] xc2028 9-0061: BASE firmware not changed.
Jan 14 17:08:19 linux-v5dy kernel: [  293.105091] xc2028 9-0061: Std-specific firmware already loaded.
Jan 14 17:08:19 linux-v5dy kernel: [  293.105096] xc2028 9-0061: SCODE firmware already loaded.
Jan 14 17:08:19 linux-v5dy kernel: [  293.105100] xc2028 9-0061: xc2028_get_reg 0004 called
Jan 14 17:08:19 linux-v5dy kernel: [  293.105106] tm6000 #0 at tm6000_i2c_xfer: write nonstop addr=0xc2 len=2: 00 04
Jan 14 17:08:19 linux-v5dy kernel: [  293.105112] tm6000 #0 at tm6000_i2c_xfer: ; joined to read stop len=2: 20 36
Jan 14 17:08:19 linux-v5dy kernel: [  293.175036] xc2028 9-0061: xc2028_get_reg 0008 called
Jan 14 17:08:19 linux-v5dy kernel: [  293.175042] tm6000 #0 at tm6000_i2c_xfer: write nonstop addr=0xc2 len=2: 00 08
Jan 14 17:08:19 linux-v5dy kernel: [  293.175049] tm6000 #0 at tm6000_i2c_xfer: ; joined to read stop len=2: 0b d4
Jan 14 17:08:19 linux-v5dy kernel: [  293.246031] xc2028 9-0061: Device is Xceive 3028 version 2.0, firmware version 3.6
Jan 14 17:08:20 linux-v5dy kernel: [  293.246038] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=2: 00 00
Jan 14 17:08:20 linux-v5dy kernel: [  293.316032] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 80 02 00 00
Jan 14 17:08:20 linux-v5dy kernel: [  293.451028] tm6000 #0 at tm6000_i2c_xfer: write stop addr=0xc2 len=4: 00 00 30 50
Jan 14 17:08:20 linux-v5dy kernel: [  293.622045] xc2028 9-0061: divisor= 00 00 30 50 (freq=193.250)
Jan 14 17:08:20 linux-v5dy kernel: [  293.622357] tm6000 #0 at tm6000_i2c_xfer: write nonstop addr=0x1e len=1: 7f
Jan 14 17:08:20 linux-v5dy kernel: [  293.622363] tm6000 #0 at tm6000_i2c_xfer: ; joined to read stop len=1: 14
Jan 14 17:08:20 linux-v5dy kernel: [  293.645030] DVB: registering new adapter (Trident TVMaster 6000 DVB-T)
Jan 14 17:08:20 linux-v5dy kernel: [  293.645038] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
Jan 14 17:08:20 linux-v5dy kernel: [  293.645501] xc2028: Xcv2028/3028 init called!
Jan 14 17:08:20 linux-v5dy kernel: [  293.645508] xc2028 9-0061: attaching existing instance
Jan 14 17:08:20 linux-v5dy kernel: [  293.645514] xc2028 9-0061: type set to XCeive xc2028/xc3028 tuner
Jan 14 17:08:20 linux-v5dy kernel: [  293.645519] tm6000: XC2028/3028 asked to be attached to frontend!
Jan 14 17:08:20 linux-v5dy kernel: [  293.646069] usbcore: registered new interface driver tm6000

--------------010006010705000401080105--
