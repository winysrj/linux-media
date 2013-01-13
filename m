Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:35134 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3AMOU1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 09:20:27 -0500
Received: by mail-ea0-f178.google.com with SMTP id a14so970135eaa.9
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 06:20:26 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/7] em28xx: get rid of the dependency on module ir-kbd-i2c
Date: Sun, 13 Jan 2013 15:20:41 +0100
Message-Id: <1358086845-6989-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1358086845-6989-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1358086845-6989-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We already have the key polling functions and the polling infrastructure in
em28xx-input, so we can easily get rid of the dependency on module ir-kbd-i2c.
For maximum safety, do not touch the key reporting mechanism for those devices.
Code size could be improved further but would have minor peformance impacts.

Tested with device "Terratec Cinergy 200 USB" (EM2800_BOARD_TERRATEC_CINERGY_200)

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c |  220 +++++++++++++++++++------------
 drivers/media/usb/em28xx/em28xx.h       |    3 -
 2 Dateien geändert, 135 Zeilen hinzugefügt(+), 88 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index edcd697..a8f3636 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -62,13 +62,17 @@ struct em28xx_IR {
 	char name[32];
 	char phys[32];
 
-	/* poll external decoder */
+	/* poll decoder */
 	int polling;
 	struct delayed_work work;
 	unsigned int full_code:1;
 	unsigned int last_readcount;
 	u64 rc_type;
 
+	/* external device (if used) */
+	struct i2c_client *i2c_dev;
+
+	int  (*get_key_i2c)(struct i2c_client *, u32 *, u32 *);
 	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
 };
 
@@ -76,12 +80,13 @@ struct em28xx_IR {
  I2C IR based get keycodes - should be used with ir-kbd-i2c
  **********************************************************/
 
-static int em28xx_get_key_terratec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int em28xx_get_key_terratec(struct i2c_client *i2c_dev,
+				   u32 *ir_key, u32 *ir_raw)
 {
 	unsigned char b;
 
 	/* poll IR chip */
-	if (1 != i2c_master_recv(ir->c, &b, 1))
+	if (1 != i2c_master_recv(i2c_dev, &b, 1))
 		return -EIO;
 
 	/* it seems that 0xFE indicates that a button is still hold
@@ -100,14 +105,15 @@ static int em28xx_get_key_terratec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	return 1;
 }
 
-static int em28xx_get_key_em_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int em28xx_get_key_em_haup(struct i2c_client *i2c_dev,
+				  u32 *ir_key, u32 *ir_raw)
 {
 	unsigned char buf[2];
 	u16 code;
 	int size;
 
 	/* poll IR chip */
-	size = i2c_master_recv(ir->c, buf, sizeof(buf));
+	size = i2c_master_recv(i2c_dev, buf, sizeof(buf));
 
 	if (size != 2)
 		return -EIO;
@@ -144,14 +150,14 @@ static int em28xx_get_key_em_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	return 1;
 }
 
-static int em28xx_get_key_pinnacle_usb_grey(struct IR_i2c *ir, u32 *ir_key,
-				     u32 *ir_raw)
+static int em28xx_get_key_pinnacle_usb_grey(struct i2c_client *i2c_dev,
+					    u32 *ir_key, u32 *ir_raw)
 {
 	unsigned char buf[3];
 
 	/* poll IR chip */
 
-	if (3 != i2c_master_recv(ir->c, buf, 3))
+	if (3 != i2c_master_recv(i2c_dev, buf, 3))
 		return -EIO;
 
 	if (buf[0] != 0x00)
@@ -163,24 +169,24 @@ static int em28xx_get_key_pinnacle_usb_grey(struct IR_i2c *ir, u32 *ir_key,
 	return 1;
 }
 
-static int em28xx_get_key_winfast_usbii_deluxe(struct IR_i2c *ir, u32 *ir_key,
-					u32 *ir_raw)
+static int em28xx_get_key_winfast_usbii_deluxe(struct i2c_client *i2c_dev,
+					       u32 *ir_key, u32 *ir_raw)
 {
 	unsigned char subaddr, keydetect, key;
 
-	struct i2c_msg msg[] = { { .addr = ir->c->addr, .flags = 0, .buf = &subaddr, .len = 1},
+	struct i2c_msg msg[] = { { .addr = i2c_dev->addr, .flags = 0, .buf = &subaddr, .len = 1},
 
-				{ .addr = ir->c->addr, .flags = I2C_M_RD, .buf = &keydetect, .len = 1} };
+				{ .addr = i2c_dev->addr, .flags = I2C_M_RD, .buf = &keydetect, .len = 1} };
 
 	subaddr = 0x10;
-	if (2 != i2c_transfer(ir->c->adapter, msg, 2))
+	if (2 != i2c_transfer(i2c_dev->adapter, msg, 2))
 		return -EIO;
 	if (keydetect == 0x00)
 		return 0;
 
 	subaddr = 0x00;
 	msg[1].buf = &key;
-	if (2 != i2c_transfer(ir->c->adapter, msg, 2))
+	if (2 != i2c_transfer(i2c_dev->adapter, msg, 2))
 		return -EIO;
 	if (key == 0x00)
 		return 0;
@@ -280,6 +286,24 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
  Polling code for em28xx
  **********************************************************/
 
+static int em28xx_i2c_ir_handle_key(struct em28xx_IR *ir)
+{
+	static u32 ir_key, ir_raw;
+	int rc;
+
+	rc = ir->get_key_i2c(ir->i2c_dev, &ir_key, &ir_raw);
+	if (rc < 0) {
+		dprintk("ir->get_key_i2c() failed: %d\n", rc);
+		return rc;
+	}
+
+	if (rc) {
+		dprintk("%s: keycode = 0x%04x\n", __func__, ir_key);
+		rc_keydown(ir->rc, ir_key, 0);
+	}
+	return 0;
+}
+
 static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 {
 	int result;
@@ -288,7 +312,7 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 	/* read the registers containing the IR status */
 	result = ir->get_key(ir, &poll_result);
 	if (unlikely(result < 0)) {
-		dprintk("ir->get_key() failed %d\n", result);
+		dprintk("ir->get_key() failed: %d\n", result);
 		return;
 	}
 
@@ -318,6 +342,14 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 	}
 }
 
+static void em28xx_i2c_ir_work(struct work_struct *work)
+{
+	struct em28xx_IR *ir = container_of(work, struct em28xx_IR, work.work);
+
+	em28xx_i2c_ir_handle_key(ir);
+	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
+}
+
 static void em28xx_ir_work(struct work_struct *work)
 {
 	struct em28xx_IR *ir = container_of(work, struct em28xx_IR, work.work);
@@ -330,7 +362,10 @@ static int em28xx_ir_start(struct rc_dev *rc)
 {
 	struct em28xx_IR *ir = rc->priv;
 
-	INIT_DELAYED_WORK(&ir->work, em28xx_ir_work);
+	if (ir->i2c_dev) /* external i2c device */
+		INIT_DELAYED_WORK(&ir->work, em28xx_i2c_ir_work);
+	else /* internal device */
+		INIT_DELAYED_WORK(&ir->work, em28xx_ir_work);
 	schedule_delayed_work(&ir->work, 0);
 
 	return 0;
@@ -427,49 +462,33 @@ static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
 	}
 }
 
-static void em28xx_register_i2c_ir(struct em28xx *dev)
+static struct i2c_client * em28xx_probe_i2c_ir(struct em28xx *dev)
 {
+	int i = 0;
+	struct i2c_client *i2c_dev = NULL;
 	/* Leadtek winfast tv USBII deluxe can find a non working IR-device */
 	/* at address 0x18, so if that address is needed for another board in */
 	/* the future, please put it after 0x1f. */
-	struct i2c_board_info info;
 	const unsigned short addr_list[] = {
 		 0x1f, 0x30, 0x47, I2C_CLIENT_END
 	};
 
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	memset(&dev->init_data, 0, sizeof(dev->init_data));
-	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
-
-	/* detect & configure */
-	switch (dev->model) {
-	case EM2800_BOARD_TERRATEC_CINERGY_200:
-	case EM2820_BOARD_TERRATEC_CINERGY_250:
-		dev->init_data.ir_codes = RC_MAP_EM_TERRATEC;
-		dev->init_data.get_key = em28xx_get_key_terratec;
-		dev->init_data.name = "Terratec Cinergy 200/250";
-		break;
-	case EM2820_BOARD_PINNACLE_USB_2:
-		dev->init_data.ir_codes = RC_MAP_PINNACLE_GREY;
-		dev->init_data.get_key = em28xx_get_key_pinnacle_usb_grey;
-		dev->init_data.name = "Pinnacle USB2";
-		break;
-	case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
-		dev->init_data.ir_codes = RC_MAP_HAUPPAUGE;
-		dev->init_data.get_key = em28xx_get_key_em_haup;
-		dev->init_data.name = "WinTV USB2";
-		dev->init_data.type = RC_BIT_RC5;
-		break;
-	case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
-		dev->init_data.ir_codes = RC_MAP_WINFAST_USBII_DELUXE;
-		dev->init_data.get_key = em28xx_get_key_winfast_usbii_deluxe;
-		dev->init_data.name = "Winfast TV USBII Deluxe";
-		break;
+	while (addr_list[i] != I2C_CLIENT_END) {
+		if (i2c_probe_func_quick_read(&dev->i2c_adap, addr_list[i]) == 1) {
+			i2c_dev = kzalloc(sizeof(*i2c_dev), GFP_KERNEL);
+			if (i2c_dev)  {
+				i2c_dev->addr = addr_list[i];
+				i2c_dev->adapter = &dev->i2c_adap;
+				/* NOTE: as long as we don't register the device
+				 * at the i2c subsystem, no other fields need to
+				 * be set up */
+			}
+			break;
+		}
+		i++;
 	}
 
-	if (dev->init_data.name)
-		info.platform_data = &dev->init_data;
-	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list, NULL);
+	return i2c_dev;
 }
 
 /**********************************************************
@@ -565,19 +584,21 @@ static int em28xx_ir_init(struct em28xx *dev)
 	struct rc_dev *rc;
 	int err = -ENOMEM;
 	u64 rc_type;
+	struct i2c_client *i2c_rc_dev = NULL;
 
 	if (dev->board.has_snapshot_button)
 		em28xx_register_snapshot_button(dev);
 
 	if (dev->board.has_ir_i2c) {
-		em28xx_register_i2c_ir(dev);
-#if defined(CONFIG_MODULES) && defined(MODULE)
-		request_module("ir-kbd-i2c");
-#endif
-		return 0;
+		i2c_rc_dev = em28xx_probe_i2c_ir(dev);
+		if (!i2c_rc_dev) {
+			dev->board.has_ir_i2c = 0;
+			em28xx_warn("No i2c IR remote control device found.\n");
+			return -ENODEV;
+		}
 	}
 
-	if (dev->board.ir_codes == NULL) {
+	if (dev->board.ir_codes == NULL && !dev->board.has_ir_i2c) {
 		/* No remote control support */
 		em28xx_warn("Remote control support is not available for "
 				"this card.\n");
@@ -594,45 +615,70 @@ static int em28xx_ir_init(struct em28xx *dev)
 	dev->ir = ir;
 	ir->rc = rc;
 
-	/*
-	 * em2874 supports more protocols. For now, let's just announce
-	 * the two protocols that were already tested
-	 */
-	rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
 	rc->priv = ir;
-	rc->change_protocol = em28xx_ir_change_protocol;
 	rc->open = em28xx_ir_start;
 	rc->close = em28xx_ir_stop;
 
-	switch (dev->chip_id) {
-	case CHIP_ID_EM2860:
-	case CHIP_ID_EM2883:
-		rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
-		ir->get_key = default_polling_getkey;
-		break;
-	case CHIP_ID_EM2884:
-	case CHIP_ID_EM2874:
-	case CHIP_ID_EM28174:
-		ir->get_key = em2874_polling_getkey;
-		rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC | RC_BIT_RC6_0;
-		break;
-	default:
-		err = -ENODEV;
-		goto error;
+	if (dev->board.has_ir_i2c) {	/* external i2c device */
+		switch (dev->model) {
+		case EM2800_BOARD_TERRATEC_CINERGY_200:
+		case EM2820_BOARD_TERRATEC_CINERGY_250:
+			rc->map_name = RC_MAP_EM_TERRATEC;
+			ir->get_key_i2c = em28xx_get_key_terratec;
+			break;
+		case EM2820_BOARD_PINNACLE_USB_2:
+			rc->map_name = RC_MAP_PINNACLE_GREY;
+			ir->get_key_i2c = em28xx_get_key_pinnacle_usb_grey;
+			break;
+		case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
+			rc->map_name = RC_MAP_HAUPPAUGE;
+			ir->get_key_i2c = em28xx_get_key_em_haup;
+			rc->allowed_protos = RC_BIT_RC5;
+			break;
+		case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
+			rc->map_name = RC_MAP_WINFAST_USBII_DELUXE;
+			ir->get_key_i2c = em28xx_get_key_winfast_usbii_deluxe;
+			break;
+		default:
+			err = -ENODEV;
+			goto error;
+		}
+
+		ir->i2c_dev = i2c_rc_dev;
+	} else {	/* internal device */
+		switch (dev->chip_id) {
+		case CHIP_ID_EM2860:
+		case CHIP_ID_EM2883:
+			rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
+			ir->get_key = default_polling_getkey;
+			break;
+		case CHIP_ID_EM2884:
+		case CHIP_ID_EM2874:
+		case CHIP_ID_EM28174:
+			ir->get_key = em2874_polling_getkey;
+			rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC |
+					     RC_BIT_RC6_0;
+			break;
+		default:
+			err = -ENODEV;
+			goto error;
+		}
+
+		rc->change_protocol = em28xx_ir_change_protocol;
+		rc->map_name = dev->board.ir_codes;
+
+		/* By default, keep protocol field untouched */
+		rc_type = RC_BIT_UNKNOWN;
+		err = em28xx_ir_change_protocol(rc, &rc_type);
+		if (err)
+			goto error;
 	}
 
-	/* By default, keep protocol field untouched */
-	rc_type = RC_BIT_UNKNOWN;
-	err = em28xx_ir_change_protocol(rc, &rc_type);
-	if (err)
-		goto error;
-
 	/* This is how often we ask the chip for IR information */
 	ir->polling = 100; /* ms */
 
 	/* init input device */
-	snprintf(ir->name, sizeof(ir->name), "em28xx IR (%s)",
-						dev->name);
+	snprintf(ir->name, sizeof(ir->name), "em28xx IR (%s)", dev->name);
 
 	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
@@ -644,7 +690,6 @@ static int em28xx_ir_init(struct em28xx *dev)
 	rc->input_id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
 	rc->input_id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
 	rc->dev.parent = &dev->udev->dev;
-	rc->map_name = dev->board.ir_codes;
 	rc->driver_name = MODULE_NAME;
 
 	/* all done */
@@ -655,6 +700,8 @@ static int em28xx_ir_init(struct em28xx *dev)
 	return 0;
 
 error:
+	if (ir && ir->i2c_dev)
+		kfree(ir->i2c_dev);
 	dev->ir = NULL;
 	rc_free_device(rc);
 	kfree(ir);
@@ -674,6 +721,9 @@ static int em28xx_ir_fini(struct em28xx *dev)
 	if (ir->rc)
 		rc_unregister_device(ir->rc);
 
+	if (ir->i2c_dev)
+		kfree(ir->i2c_dev);
+
 	/* done */
 	kfree(ir);
 	dev->ir = NULL;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 2aa4b84..5f0b2c5 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -640,9 +640,6 @@ struct em28xx {
 	struct delayed_work sbutton_query_work;
 
 	struct em28xx_dvb *dvb;
-
-	/* I2C keyboard data */
-	struct IR_i2c_init_data init_data;
 };
 
 struct em28xx_ops {
-- 
1.7.10.4

