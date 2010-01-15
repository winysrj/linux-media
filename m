Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:44190 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756568Ab0AOJl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 04:41:26 -0500
Message-ID: <4B503830.7060804@arcor.de>
Date: Fri, 15 Jan 2010 10:41:04 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: dheitmueller@kernellabs.com
CC: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy Hybrid XE (TM6010 Mediachip)
Content-Type: multipart/mixed;
 boundary="------------060402050300040404090608"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060402050300040404090608
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

I have bug-fix (tm6000.patch) my first problem, so that it loads the
tuner and demodulator (message). But I cannot find digital channels. It
was wrong with the tuner (xc3028) or demodulator (zl10353)? Under
windows xp it found digital channels (region Germany Berlin).


-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------060402050300040404090608
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

--------------060402050300040404090608--
