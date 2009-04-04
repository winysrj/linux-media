Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:39839 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZDDM1v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 08:27:51 -0400
Date: Sat, 4 Apr 2009 14:27:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Andy Walls <awalls@radix.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH 2/6] ir-kbd-i2c: Don't use i2c_client.name for our own needs
Message-ID: <20090404142742.2a304354@hyperion.delvare>
In-Reply-To: <20090404142427.6e81f316@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the standard device driver binding model, the name field of
struct i2c_client is used to match devices to their drivers, so we
must stop using it for internal purposes. Define a separate field
in struct IR_i2c as a replacement, and use it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/video/cx231xx/cx231xx-input.c |    2 +-
 linux/drivers/media/video/em28xx/em28xx-cards.c   |    6 +++---
 linux/drivers/media/video/em28xx/em28xx-input.c   |    2 +-
 linux/drivers/media/video/ir-kbd-i2c.c            |    5 +++--
 linux/drivers/media/video/saa7134/saa7134-input.c |   12 ++++++------
 linux/include/media/ir-kbd-i2c.h                  |    1 +
 6 files changed, 15 insertions(+), 13 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/cx231xx/cx231xx-input.c	2009-03-13 09:59:49.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/cx231xx/cx231xx-input.c	2009-04-03 19:02:28.000000000 +0200
@@ -37,7 +37,7 @@ MODULE_PARM_DESC(ir_debug, "enable debug
 
 #define i2cdprintk(fmt, arg...) \
 	if (ir_debug) { \
-		printk(KERN_DEBUG "%s/ir: " fmt, ir->c.name , ## arg); \
+		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
 	}
 
 #define dprintk(fmt, arg...) \
--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx-cards.c	2009-04-03 14:18:26.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx-cards.c	2009-04-03 18:56:40.000000000 +0200
@@ -1921,19 +1921,19 @@ void em28xx_set_ir(struct em28xx *dev, s
 	case (EM2820_BOARD_TERRATEC_CINERGY_250):
 		ir->ir_codes = ir_codes_em_terratec;
 		ir->get_key = em28xx_get_key_terratec;
-		snprintf(ir->c.name, sizeof(ir->c.name),
+		snprintf(ir->name, sizeof(ir->name),
 			 "i2c IR (EM28XX Terratec)");
 		break;
 	case (EM2820_BOARD_PINNACLE_USB_2):
 		ir->ir_codes = ir_codes_pinnacle_grey;
 		ir->get_key = em28xx_get_key_pinnacle_usb_grey;
-		snprintf(ir->c.name, sizeof(ir->c.name),
+		snprintf(ir->name, sizeof(ir->name),
 			 "i2c IR (EM28XX Pinnacle PCTV)");
 		break;
 	case (EM2820_BOARD_HAUPPAUGE_WINTV_USB_2):
 		ir->ir_codes = ir_codes_hauppauge_new;
 		ir->get_key = em28xx_get_key_em_haup;
-		snprintf(ir->c.name, sizeof(ir->c.name),
+		snprintf(ir->name, sizeof(ir->name),
 			 "i2c IR (EM2840 Hauppauge)");
 		break;
 	case (EM2820_BOARD_MSI_VOX_USB_2):
--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx-input.c	2009-03-13 09:59:49.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx-input.c	2009-04-03 18:56:40.000000000 +0200
@@ -41,7 +41,7 @@ MODULE_PARM_DESC(ir_debug, "enable debug
 
 #define i2cdprintk(fmt, arg...) \
 	if (ir_debug) { \
-		printk(KERN_DEBUG "%s/ir: " fmt, ir->c.name , ## arg); \
+		printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg); \
 	}
 
 #define dprintk(fmt, arg...) \
--- v4l-dvb.orig/linux/drivers/media/video/ir-kbd-i2c.c	2009-03-13 09:59:49.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/ir-kbd-i2c.c	2009-04-03 18:56:40.000000000 +0200
@@ -346,6 +346,7 @@ static int ir_attach(struct i2c_adapter
 
 	ir->c.adapter = adap;
 	ir->c.addr    = addr;
+	snprintf(ir->c.name, sizeof(ir->c.name), "ir-kbd");
 
 	i2c_set_clientdata(&ir->c, ir);
 
@@ -419,7 +420,7 @@ static int ir_attach(struct i2c_adapter
 	}
 
 	/* Sets name */
-	snprintf(ir->c.name, sizeof(ir->c.name), "i2c IR (%s)", name);
+	snprintf(ir->name, sizeof(ir->name), "i2c IR (%s)", name);
 	ir->ir_codes = ir_codes;
 
 	/* register i2c device
@@ -444,7 +445,7 @@ static int ir_attach(struct i2c_adapter
 	/* init + register input device */
 	ir_input_init(input_dev, &ir->ir, ir_type, ir->ir_codes);
 	input_dev->id.bustype = BUS_I2C;
-	input_dev->name       = ir->c.name;
+	input_dev->name       = ir->name;
 	input_dev->phys       = ir->phys;
 
 	err = input_register_device(ir->input);
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-input.c	2009-03-01 16:09:10.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c	2009-04-03 18:56:40.000000000 +0200
@@ -60,7 +60,7 @@ MODULE_PARM_DESC(disable_other_ir, "disa
 #define dprintk(fmt, arg...)	if (ir_debug) \
 	printk(KERN_DEBUG "%s/ir: " fmt, dev->name , ## arg)
 #define i2cdprintk(fmt, arg...)    if (ir_debug) \
-	printk(KERN_DEBUG "%s/ir: " fmt, ir->c.name , ## arg)
+	printk(KERN_DEBUG "%s/ir: " fmt, ir->name , ## arg)
 
 /* Helper functions for RC5 and NEC decoding at GPIO16 or GPIO18 */
 static int saa7134_rc5_irq(struct saa7134_dev *dev);
@@ -693,7 +693,7 @@ void saa7134_set_i2c_ir(struct saa7134_d
 	switch (dev->board) {
 	case SAA7134_BOARD_PINNACLE_PCTV_110i:
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
-		snprintf(ir->c.name, sizeof(ir->c.name), "Pinnacle PCTV");
+		snprintf(ir->name, sizeof(ir->name), "Pinnacle PCTV");
 		if (pinnacle_remote == 0) {
 			ir->get_key   = get_key_pinnacle_color;
 			ir->ir_codes = ir_codes_pinnacle_color;
@@ -703,17 +703,17 @@ void saa7134_set_i2c_ir(struct saa7134_d
 		}
 		break;
 	case SAA7134_BOARD_UPMOST_PURPLE_TV:
-		snprintf(ir->c.name, sizeof(ir->c.name), "Purple TV");
+		snprintf(ir->name, sizeof(ir->name), "Purple TV");
 		ir->get_key   = get_key_purpletv;
 		ir->ir_codes  = ir_codes_purpletv;
 		break;
 	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
-		snprintf(ir->c.name, sizeof(ir->c.name), "MSI TV@nywhere Plus");
+		snprintf(ir->name, sizeof(ir->name), "MSI TV@nywhere Plus");
 		ir->get_key  = get_key_msi_tvanywhere_plus;
 		ir->ir_codes = ir_codes_msi_tvanywhere_plus;
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
-		snprintf(ir->c.name, sizeof(ir->c.name), "HVR 1110");
+		snprintf(ir->name, sizeof(ir->name), "HVR 1110");
 		ir->get_key   = get_key_hvr1110;
 		ir->ir_codes  = ir_codes_hauppauge_new;
 		break;
@@ -722,7 +722,7 @@ void saa7134_set_i2c_ir(struct saa7134_d
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
-		snprintf(ir->c.name, sizeof(ir->c.name), "BeholdTV");
+		snprintf(ir->name, sizeof(ir->name), "BeholdTV");
 		ir->get_key   = get_key_beholdm6xx;
 		ir->ir_codes  = ir_codes_behold;
 		break;
--- v4l-dvb.orig/linux/include/media/ir-kbd-i2c.h	2009-03-13 09:59:49.000000000 +0100
+++ v4l-dvb/linux/include/media/ir-kbd-i2c.h	2009-04-03 18:56:40.000000000 +0200
@@ -15,6 +15,7 @@ struct IR_i2c {
 	unsigned char          old;
 
 	struct delayed_work    work;
+	char                   name[32];
 	char                   phys[32];
 	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
 };

-- 
Jean Delvare
