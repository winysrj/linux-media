Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:47010 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbZDDM3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 08:29:48 -0400
Date: Sat, 4 Apr 2009 14:29:39 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Andy Walls <awalls@radix.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH 4/6] ir-kbd-i2c: Use initialization data
Message-ID: <20090404142939.7322b41e@hyperion.delvare>
In-Reply-To: <20090404142427.6e81f316@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For specific boards, pass initialization data to ir-kbd-i2c instead
of modifying the settings after the device is initialized. This is
more efficient and easier to read.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/video/cx231xx/cx231xx-cards.c |   14 ---
 linux/drivers/media/video/cx231xx/cx231xx-i2c.c   |   29 ------
 linux/drivers/media/video/cx231xx/cx231xx.h       |    1 
 linux/drivers/media/video/em28xx/em28xx-cards.c   |   31 +++----
 linux/drivers/media/video/em28xx/em28xx-i2c.c     |   22 -----
 linux/drivers/media/video/em28xx/em28xx.h         |    1 
 linux/drivers/media/video/ir-kbd-i2c.c            |   12 ++
 linux/drivers/media/video/saa7134/saa7134-i2c.c   |   28 ------
 linux/drivers/media/video/saa7134/saa7134-input.c |   88 ++++++++++-----------
 linux/drivers/media/video/saa7134/saa7134.h       |    1 
 linux/include/media/ir-kbd-i2c.h                  |    7 +
 11 files changed, 76 insertions(+), 158 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/cx231xx/cx231xx-cards.c	2009-04-04 09:20:21.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/cx231xx/cx231xx-cards.c	2009-04-04 09:20:23.000000000 +0200
@@ -282,20 +282,6 @@ static void cx231xx_config_tuner(struct
 }
 
 /* ----------------------------------------------------------------------- */
-void cx231xx_set_ir(struct cx231xx *dev, struct IR_i2c *ir)
-{
-	/* detect & configure */
-	switch (dev->model) {
-
-	case CX231XX_BOARD_CNXT_RDE_250:
-		break;
-	case CX231XX_BOARD_CNXT_RDU_250:
-		break;
-	default:
-		break;
-	}
-}
-
 void cx231xx_card_setup(struct cx231xx *dev)
 {
 
--- v4l-dvb.orig/linux/drivers/media/video/cx231xx/cx231xx-i2c.c	2009-04-04 09:20:18.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/cx231xx/cx231xx-i2c.c	2009-04-04 09:20:23.000000000 +0200
@@ -424,34 +424,6 @@ static u32 functionality(struct i2c_adap
 	return I2C_FUNC_SMBUS_EMUL | I2C_FUNC_I2C;
 }
 
-/*
- * attach_inform()
- * gets called when a device attaches to the i2c bus
- * does some basic configuration
- */
-static int attach_inform(struct i2c_client *client)
-{
-	struct cx231xx_i2c *bus = i2c_get_adapdata(client->adapter);
-	struct cx231xx *dev = bus->dev;
-
-	switch (client->addr << 1) {
-	case 0x8e:
-		{
-			struct IR_i2c *ir = i2c_get_clientdata(client);
-			dprintk1(1, "attach_inform: IR detected (%s).\n",
-				 ir->phys);
-			cx231xx_set_ir(dev, ir);
-			break;
-		}
-		break;
-
-	default:
-		break;
-	}
-
-	return 0;
-}
-
 static struct i2c_algorithm cx231xx_algo = {
 	.master_xfer = cx231xx_i2c_xfer,
 	.functionality = functionality,
@@ -465,7 +437,6 @@ static struct i2c_adapter cx231xx_adap_t
 	.name = "cx231xx",
 	.id = I2C_HW_B_CX231XX,
 	.algo = &cx231xx_algo,
-	.client_register = attach_inform,
 };
 
 static struct i2c_client cx231xx_client_template = {
--- v4l-dvb.orig/linux/drivers/media/video/cx231xx/cx231xx.h	2009-04-04 09:20:18.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/cx231xx/cx231xx.h	2009-04-04 09:20:23.000000000 +0200
@@ -747,7 +747,6 @@ extern void cx231xx_card_setup(struct cx
 extern struct cx231xx_board cx231xx_boards[];
 extern struct usb_device_id cx231xx_id_table[];
 extern const unsigned int cx231xx_bcount;
-void cx231xx_set_ir(struct cx231xx *dev, struct IR_i2c *ir);
 int cx231xx_tuner_callback(void *ptr, int component, int command, int arg);
 
 /* Provided by cx231xx-input.c */
--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx-cards.c	2009-04-04 09:20:21.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx-cards.c	2009-04-04 09:54:59.000000000 +0200
@@ -1907,6 +1907,7 @@ static int em28xx_hint_board(struct em28
 void em28xx_register_i2c_ir(struct em28xx *dev)
 {
 	struct i2c_board_info info;
+	struct IR_i2c_init_data init_data;
 	const unsigned short addr_list[] = {
 		 0x30, 0x47, I2C_CLIENT_END
 	};
@@ -1915,12 +1916,9 @@ void em28xx_register_i2c_ir(struct em28x
 		return;
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
+	memset(&init_data, 0, sizeof(struct IR_i2c_init_data));
 	strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
-	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
-}
 
-void em28xx_set_ir(struct em28xx *dev, struct IR_i2c *ir)
-{
 	/* detect & configure */
 	switch (dev->model) {
 	case (EM2800_BOARD_UNKNOWN):
@@ -1929,22 +1927,19 @@ void em28xx_set_ir(struct em28xx *dev, s
 		break;
 	case (EM2800_BOARD_TERRATEC_CINERGY_200):
 	case (EM2820_BOARD_TERRATEC_CINERGY_250):
-		ir->ir_codes = ir_codes_em_terratec;
-		ir->get_key = em28xx_get_key_terratec;
-		snprintf(ir->name, sizeof(ir->name),
-			 "i2c IR (EM28XX Terratec)");
+		init_data.ir_codes = ir_codes_em_terratec;
+		init_data.get_key = em28xx_get_key_terratec;
+		init_data.name = "i2c IR (EM28XX Terratec)";
 		break;
 	case (EM2820_BOARD_PINNACLE_USB_2):
-		ir->ir_codes = ir_codes_pinnacle_grey;
-		ir->get_key = em28xx_get_key_pinnacle_usb_grey;
-		snprintf(ir->name, sizeof(ir->name),
-			 "i2c IR (EM28XX Pinnacle PCTV)");
+		init_data.ir_codes = ir_codes_pinnacle_grey;
+		init_data.get_key = em28xx_get_key_pinnacle_usb_grey;
+		init_data.name = "i2c IR (EM28XX Pinnacle PCTV)";
 		break;
 	case (EM2820_BOARD_HAUPPAUGE_WINTV_USB_2):
-		ir->ir_codes = ir_codes_hauppauge_new;
-		ir->get_key = em28xx_get_key_em_haup;
-		snprintf(ir->name, sizeof(ir->name),
-			 "i2c IR (EM2840 Hauppauge)");
+		init_data.ir_codes = ir_codes_hauppauge_new;
+		init_data.get_key = em28xx_get_key_em_haup;
+		init_data.name = "i2c IR (EM2840 Hauppauge)";
 		break;
 	case (EM2820_BOARD_MSI_VOX_USB_2):
 		break;
@@ -1955,6 +1950,10 @@ void em28xx_set_ir(struct em28xx *dev, s
 	case (EM2800_BOARD_GRABBEEX_USB2800):
 		break;
 	}
+
+	if (init_data.name)
+		info.platform_data = &init_data;
+	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
 }
 
 void em28xx_card_setup(struct em28xx *dev)
--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx-i2c.c	2009-04-04 09:20:21.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx-i2c.c	2009-04-04 09:20:23.000000000 +0200
@@ -451,27 +451,6 @@ static u32 functionality(struct i2c_adap
 	return I2C_FUNC_SMBUS_EMUL;
 }
 
-/*
- * attach_inform()
- * gets called when a device attaches to the i2c bus
- * does some basic configuration
- */
-static int attach_inform(struct i2c_client *client)
-{
-	struct em28xx *dev = client->adapter->algo_data;
-	struct IR_i2c *ir = i2c_get_clientdata(client);
-
-	switch (client->addr << 1) {
-	case 0x60:
-	case 0x8e:
-		dprintk1(1, "attach_inform: IR detected (%s).\n", ir->phys);
-		em28xx_set_ir(dev, ir);
-		break;
-	}
-
-	return 0;
-}
-
 static struct i2c_algorithm em28xx_algo = {
 	.master_xfer   = em28xx_i2c_xfer,
 	.functionality = functionality,
@@ -488,7 +467,6 @@ static struct i2c_adapter em28xx_adap_te
 	.name = "em28xx",
 	.id = I2C_HW_B_EM28XX,
 	.algo = &em28xx_algo,
-	.client_register = attach_inform,
 };
 
 static struct i2c_client em28xx_client_template = {
--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx.h	2009-04-04 09:20:21.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx.h	2009-04-04 09:20:23.000000000 +0200
@@ -649,7 +649,6 @@ extern struct em28xx_board em28xx_boards
 extern struct usb_device_id em28xx_id_table[];
 extern const unsigned int em28xx_bcount;
 void em28xx_register_i2c_ir(struct em28xx *dev);
-void em28xx_set_ir(struct em28xx *dev, struct IR_i2c *ir);
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
 void em28xx_release_resources(struct em28xx *dev);
 
--- v4l-dvb.orig/linux/drivers/media/video/ir-kbd-i2c.c	2009-04-04 09:20:21.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/ir-kbd-i2c.c	2009-04-04 09:20:23.000000000 +0200
@@ -307,7 +307,7 @@ static void ir_work(struct work_struct *
 static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	IR_KEYTAB_TYPE *ir_codes = NULL;
-	char *name;
+	const char *name;
 	int ir_type;
 	struct IR_i2c *ir;
 	struct input_dev *input_dev;
@@ -395,6 +395,16 @@ static int ir_probe(struct i2c_client *c
 		goto err_out_free;
 	}
 
+	/* Let the caller override settings */
+	if (client->dev.platform_data) {
+		const struct IR_i2c_init_data *init_data =
+						client->dev.platform_data;
+
+		ir_codes = init_data->ir_codes;
+		name = init_data->name;
+		ir->get_key = init_data->get_key;
+	}
+
 	/* Sets name */
 	snprintf(ir->name, sizeof(ir->name), "i2c IR (%s)", name);
 	ir->ir_codes = ir_codes;
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-i2c.c	2009-04-04 09:20:21.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-i2c.c	2009-04-04 09:53:26.000000000 +0200
@@ -326,33 +326,6 @@ static u32 functionality(struct i2c_adap
 	return I2C_FUNC_SMBUS_EMUL;
 }
 
-static int attach_inform(struct i2c_client *client)
-{
-	struct saa7134_dev *dev = client->adapter->algo_data;
-
-	d1printk( "%s i2c attach [addr=0x%x,client=%s]\n",
-		client->driver->driver.name, client->addr, client->name);
-
-	/* Am I an i2c remote control? */
-
-	switch (client->addr) {
-		case 0x7a:
-		case 0x47:
-		case 0x71:
-		case 0x2d:
-		case 0x30:
-		{
-			struct IR_i2c *ir = i2c_get_clientdata(client);
-			d1printk("%s i2c IR detected (%s).\n",
-				 client->driver->driver.name, ir->phys);
-			saa7134_set_i2c_ir(dev,ir);
-			break;
-		}
-	}
-
-	return 0;
-}
-
 static struct i2c_algorithm saa7134_algo = {
 	.master_xfer   = saa7134_i2c_xfer,
 	.functionality = functionality,
@@ -369,7 +342,6 @@ static struct i2c_adapter saa7134_adap_t
 	.name          = "saa7134",
 	.id            = I2C_HW_SAA7134,
 	.algo          = &saa7134_algo,
-	.client_register = attach_inform,
 };
 
 static struct i2c_client saa7134_client_template = {
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-input.c	2009-04-04 09:20:21.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c	2009-04-04 10:07:49.000000000 +0200
@@ -685,6 +685,7 @@ void saa7134_input_fini(struct saa7134_d
 void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 {
 	struct i2c_board_info info;
+	struct IR_i2c_init_data init_data;
 	const unsigned short addr_list[] = {
 		0x7a, 0x47, 0x71, 0x2d,
 		I2C_CLIENT_END
@@ -722,7 +723,49 @@ void saa7134_probe_i2c_ir(struct saa7134
 	}
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
+	memset(&init_data, 0, sizeof(struct IR_i2c_init_data));
 	strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
+
+	switch (dev->board) {
+	case SAA7134_BOARD_PINNACLE_PCTV_110i:
+	case SAA7134_BOARD_PINNACLE_PCTV_310i:
+		init_data.name = "Pinnacle PCTV";
+		if (pinnacle_remote == 0) {
+			init_data.get_key = get_key_pinnacle_color;
+			init_data.ir_codes = ir_codes_pinnacle_color;
+		} else {
+			init_data.get_key = get_key_pinnacle_grey;
+			init_data.ir_codes = ir_codes_pinnacle_grey;
+		}
+		break;
+	case SAA7134_BOARD_UPMOST_PURPLE_TV:
+		init_data.name = "Purple TV";
+		init_data.get_key = get_key_purpletv;
+		init_data.ir_codes = ir_codes_purpletv;
+		break;
+	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
+		init_data.name = "MSI TV@nywhere Plus";
+		init_data.get_key = get_key_msi_tvanywhere_plus;
+		init_data.ir_codes = ir_codes_msi_tvanywhere_plus;
+		break;
+	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
+		init_data.name = "HVR 1110";
+		init_data.get_key = get_key_hvr1110;
+		init_data.ir_codes = ir_codes_hauppauge_new;
+		break;
+	case SAA7134_BOARD_BEHOLD_607_9FM:
+	case SAA7134_BOARD_BEHOLD_M6:
+	case SAA7134_BOARD_BEHOLD_M63:
+	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
+	case SAA7134_BOARD_BEHOLD_H6:
+		init_data.name = "BeholdTV";
+		init_data.get_key = get_key_beholdm6xx;
+		init_data.ir_codes = ir_codes_behold;
+		break;
+	}
+
+	if (init_data.name)
+		info.platform_data = &init_data;
 	client = i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
 	if (client)
 		return;
@@ -750,51 +793,6 @@ void saa7134_probe_i2c_ir(struct saa7134
 	}
 }
 
-void saa7134_set_i2c_ir(struct saa7134_dev *dev, struct IR_i2c *ir)
-{
-	switch (dev->board) {
-	case SAA7134_BOARD_PINNACLE_PCTV_110i:
-	case SAA7134_BOARD_PINNACLE_PCTV_310i:
-		snprintf(ir->name, sizeof(ir->name), "Pinnacle PCTV");
-		if (pinnacle_remote == 0) {
-			ir->get_key   = get_key_pinnacle_color;
-			ir->ir_codes = ir_codes_pinnacle_color;
-		} else {
-			ir->get_key   = get_key_pinnacle_grey;
-			ir->ir_codes = ir_codes_pinnacle_grey;
-		}
-		break;
-	case SAA7134_BOARD_UPMOST_PURPLE_TV:
-		snprintf(ir->name, sizeof(ir->name), "Purple TV");
-		ir->get_key   = get_key_purpletv;
-		ir->ir_codes  = ir_codes_purpletv;
-		break;
-	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
-		snprintf(ir->name, sizeof(ir->name), "MSI TV@nywhere Plus");
-		ir->get_key  = get_key_msi_tvanywhere_plus;
-		ir->ir_codes = ir_codes_msi_tvanywhere_plus;
-		break;
-	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
-		snprintf(ir->name, sizeof(ir->name), "HVR 1110");
-		ir->get_key   = get_key_hvr1110;
-		ir->ir_codes  = ir_codes_hauppauge_new;
-		break;
-	case SAA7134_BOARD_BEHOLD_607_9FM:
-	case SAA7134_BOARD_BEHOLD_M6:
-	case SAA7134_BOARD_BEHOLD_M63:
-	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
-	case SAA7134_BOARD_BEHOLD_H6:
-		snprintf(ir->name, sizeof(ir->name), "BeholdTV");
-		ir->get_key   = get_key_beholdm6xx;
-		ir->ir_codes  = ir_codes_behold;
-		break;
-	default:
-		dprintk("Shouldn't get here: Unknown board %x for I2C IR?\n",dev->board);
-		break;
-	}
-
-}
-
 static int saa7134_rc5_irq(struct saa7134_dev *dev)
 {
 	struct card_ir *ir = dev->remote;
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134.h	2009-04-04 09:20:21.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h	2009-04-04 09:51:36.000000000 +0200
@@ -792,7 +792,6 @@ int  saa7134_input_init1(struct saa7134_
 void saa7134_input_fini(struct saa7134_dev *dev);
 void saa7134_input_irq(struct saa7134_dev *dev);
 void saa7134_probe_i2c_ir(struct saa7134_dev *dev);
-void saa7134_set_i2c_ir(struct saa7134_dev *dev, struct IR_i2c *ir);
 void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir);
 void saa7134_ir_stop(struct saa7134_dev *dev);
 
--- v4l-dvb.orig/linux/include/media/ir-kbd-i2c.h	2009-04-04 09:20:21.000000000 +0200
+++ v4l-dvb/linux/include/media/ir-kbd-i2c.h	2009-04-04 09:20:23.000000000 +0200
@@ -19,4 +19,11 @@ struct IR_i2c {
 	char                   phys[32];
 	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
 };
+
+/* Passed when instantiating an ir-kbd i2c device */
+struct IR_i2c_init_data {
+	IR_KEYTAB_TYPE         *ir_codes;
+	const char             *name;
+	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
+};
 #endif

-- 
Jean Delvare
