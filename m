Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54933 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab2CZNPe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 09:15:34 -0400
Received: by gghe5 with SMTP id e5so3752730ggh.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 06:15:34 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media@vger.kernel.org, mchehab@infradead.org
Cc: rsalvaterra@gmail.com, crope@iki.fi, gennarone@gmail.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 4/5] em28xx: Change scope of em28xx-input local functions to static
Date: Mon, 26 Mar 2012 10:13:34 -0300
Message-Id: <1332767615-24218-4-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1332767615-24218-1-git-send-email-elezegarcia@gmail.com>
References: <1332767615-24218-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This functions are no longer used from another file,
so they should be declared as static.
Also is it necessary to move some of them before they
are used, since they are no longer header-declared.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-input.c |  184 +++++++++++++++--------------
 drivers/media/video/em28xx/em28xx.h       |   17 ---
 2 files changed, 93 insertions(+), 108 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index 0a58ba8..2496625 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -80,7 +80,7 @@ struct em28xx_IR {
  I2C IR based get keycodes - should be used with ir-kbd-i2c
  **********************************************************/
 
-int em28xx_get_key_terratec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int em28xx_get_key_terratec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 {
 	unsigned char b;
 
@@ -108,7 +108,7 @@ int em28xx_get_key_terratec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	return 1;
 }
 
-int em28xx_get_key_em_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int em28xx_get_key_em_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 {
 	unsigned char buf[2];
 	u16 code;
@@ -157,7 +157,7 @@ int em28xx_get_key_em_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	return 1;
 }
 
-int em28xx_get_key_pinnacle_usb_grey(struct IR_i2c *ir, u32 *ir_key,
+static int em28xx_get_key_pinnacle_usb_grey(struct IR_i2c *ir, u32 *ir_key,
 				     u32 *ir_raw)
 {
 	unsigned char buf[3];
@@ -179,7 +179,8 @@ int em28xx_get_key_pinnacle_usb_grey(struct IR_i2c *ir, u32 *ir_key,
 	return 1;
 }
 
-int em28xx_get_key_winfast_usbii_deluxe(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int em28xx_get_key_winfast_usbii_deluxe(struct IR_i2c *ir, u32 *ir_key,
+					u32 *ir_raw)
 {
 	unsigned char subaddr, keydetect, key;
 
@@ -387,7 +388,7 @@ int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 rc_type)
 	return rc;
 }
 
-void em28xx_register_i2c_ir(struct em28xx *dev)
+static void em28xx_register_i2c_ir(struct em28xx *dev)
 {
 	/* Leadtek winfast tv USBII deluxe can find a non working IR-device */
 	/* at address 0x18, so if that address is needed for another board in */
@@ -431,6 +432,93 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
 	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list, NULL);
 }
 
+/**********************************************************
+ Handle Webcam snapshot button
+ **********************************************************/
+
+static void em28xx_query_sbutton(struct work_struct *work)
+{
+	/* Poll the register and see if the button is depressed */
+	struct em28xx *dev =
+		container_of(work, struct em28xx, sbutton_query_work.work);
+	int ret;
+
+	ret = em28xx_read_reg(dev, EM28XX_R0C_USBSUSP);
+
+	if (ret & EM28XX_R0C_USBSUSP_SNAPSHOT) {
+		u8 cleared;
+		/* Button is depressed, clear the register */
+		cleared = ((u8) ret) & ~EM28XX_R0C_USBSUSP_SNAPSHOT;
+		em28xx_write_regs(dev, EM28XX_R0C_USBSUSP, &cleared, 1);
+
+		/* Not emulate the keypress */
+		input_report_key(dev->sbutton_input_dev, EM28XX_SNAPSHOT_KEY,
+				 1);
+		/* Now unpress the key */
+		input_report_key(dev->sbutton_input_dev, EM28XX_SNAPSHOT_KEY,
+				 0);
+	}
+
+	/* Schedule next poll */
+	schedule_delayed_work(&dev->sbutton_query_work,
+			      msecs_to_jiffies(EM28XX_SBUTTON_QUERY_INTERVAL));
+}
+
+static void em28xx_register_snapshot_button(struct em28xx *dev)
+{
+	struct input_dev *input_dev;
+	int err;
+
+	em28xx_info("Registering snapshot button...\n");
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		em28xx_errdev("input_allocate_device failed\n");
+		return;
+	}
+
+	usb_make_path(dev->udev, dev->snapshot_button_path,
+		      sizeof(dev->snapshot_button_path));
+	strlcat(dev->snapshot_button_path, "/sbutton",
+		sizeof(dev->snapshot_button_path));
+	INIT_DELAYED_WORK(&dev->sbutton_query_work, em28xx_query_sbutton);
+
+	input_dev->name = "em28xx snapshot button";
+	input_dev->phys = dev->snapshot_button_path;
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
+	set_bit(EM28XX_SNAPSHOT_KEY, input_dev->keybit);
+	input_dev->keycodesize = 0;
+	input_dev->keycodemax = 0;
+	input_dev->id.bustype = BUS_USB;
+	input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
+	input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
+	input_dev->id.version = 1;
+	input_dev->dev.parent = &dev->udev->dev;
+
+	err = input_register_device(input_dev);
+	if (err) {
+		em28xx_errdev("input_register_device failed\n");
+		input_free_device(input_dev);
+		return;
+	}
+
+	dev->sbutton_input_dev = input_dev;
+	schedule_delayed_work(&dev->sbutton_query_work,
+			      msecs_to_jiffies(EM28XX_SBUTTON_QUERY_INTERVAL));
+	return;
+
+}
+
+static void em28xx_deregister_snapshot_button(struct em28xx *dev)
+{
+	if (dev->sbutton_input_dev != NULL) {
+		em28xx_info("Deregistering snapshot button\n");
+		cancel_delayed_work_sync(&dev->sbutton_query_work);
+		input_unregister_device(dev->sbutton_input_dev);
+		dev->sbutton_input_dev = NULL;
+	}
+	return;
+}
+
 int em28xx_ir_init(struct em28xx *dev)
 {
 	struct em28xx_IR *ir;
@@ -530,89 +618,3 @@ int em28xx_ir_fini(struct em28xx *dev)
 	return 0;
 }
 
-/**********************************************************
- Handle Webcam snapshot button
- **********************************************************/
-
-static void em28xx_query_sbutton(struct work_struct *work)
-{
-	/* Poll the register and see if the button is depressed */
-	struct em28xx *dev =
-		container_of(work, struct em28xx, sbutton_query_work.work);
-	int ret;
-
-	ret = em28xx_read_reg(dev, EM28XX_R0C_USBSUSP);
-
-	if (ret & EM28XX_R0C_USBSUSP_SNAPSHOT) {
-		u8 cleared;
-		/* Button is depressed, clear the register */
-		cleared = ((u8) ret) & ~EM28XX_R0C_USBSUSP_SNAPSHOT;
-		em28xx_write_regs(dev, EM28XX_R0C_USBSUSP, &cleared, 1);
-
-		/* Not emulate the keypress */
-		input_report_key(dev->sbutton_input_dev, EM28XX_SNAPSHOT_KEY,
-				 1);
-		/* Now unpress the key */
-		input_report_key(dev->sbutton_input_dev, EM28XX_SNAPSHOT_KEY,
-				 0);
-	}
-
-	/* Schedule next poll */
-	schedule_delayed_work(&dev->sbutton_query_work,
-			      msecs_to_jiffies(EM28XX_SBUTTON_QUERY_INTERVAL));
-}
-
-void em28xx_register_snapshot_button(struct em28xx *dev)
-{
-	struct input_dev *input_dev;
-	int err;
-
-	em28xx_info("Registering snapshot button...\n");
-	input_dev = input_allocate_device();
-	if (!input_dev) {
-		em28xx_errdev("input_allocate_device failed\n");
-		return;
-	}
-
-	usb_make_path(dev->udev, dev->snapshot_button_path,
-		      sizeof(dev->snapshot_button_path));
-	strlcat(dev->snapshot_button_path, "/sbutton",
-		sizeof(dev->snapshot_button_path));
-	INIT_DELAYED_WORK(&dev->sbutton_query_work, em28xx_query_sbutton);
-
-	input_dev->name = "em28xx snapshot button";
-	input_dev->phys = dev->snapshot_button_path;
-	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
-	set_bit(EM28XX_SNAPSHOT_KEY, input_dev->keybit);
-	input_dev->keycodesize = 0;
-	input_dev->keycodemax = 0;
-	input_dev->id.bustype = BUS_USB;
-	input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
-	input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
-	input_dev->id.version = 1;
-	input_dev->dev.parent = &dev->udev->dev;
-
-	err = input_register_device(input_dev);
-	if (err) {
-		em28xx_errdev("input_register_device failed\n");
-		input_free_device(input_dev);
-		return;
-	}
-
-	dev->sbutton_input_dev = input_dev;
-	schedule_delayed_work(&dev->sbutton_query_work,
-			      msecs_to_jiffies(EM28XX_SBUTTON_QUERY_INTERVAL));
-	return;
-
-}
-
-void em28xx_deregister_snapshot_button(struct em28xx *dev)
-{
-	if (dev->sbutton_input_dev != NULL) {
-		em28xx_info("Deregistering snapshot button\n");
-		cancel_delayed_work_sync(&dev->sbutton_query_work);
-		input_unregister_device(dev->sbutton_input_dev);
-		dev->sbutton_input_dev = NULL;
-	}
-	return;
-}
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 2ae6815..75630a6 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -715,7 +715,6 @@ extern void em28xx_card_setup(struct em28xx *dev);
 extern struct em28xx_board em28xx_boards[];
 extern struct usb_device_id em28xx_id_table[];
 extern const unsigned int em28xx_bcount;
-void em28xx_register_i2c_ir(struct em28xx *dev);
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
 void em28xx_release_resources(struct em28xx *dev);
 
@@ -723,27 +722,11 @@ void em28xx_release_resources(struct em28xx *dev);
 
 #ifdef CONFIG_VIDEO_EM28XX_RC
 
-int em28xx_get_key_terratec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw);
-int em28xx_get_key_em_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw);
-int em28xx_get_key_pinnacle_usb_grey(struct IR_i2c *ir, u32 *ir_key,
-				     u32 *ir_raw);
-int em28xx_get_key_winfast_usbii_deluxe(struct IR_i2c *ir, u32 *ir_key,
-				     u32 *ir_raw);
-void em28xx_register_snapshot_button(struct em28xx *dev);
-void em28xx_deregister_snapshot_button(struct em28xx *dev);
-
 int em28xx_ir_init(struct em28xx *dev);
 int em28xx_ir_fini(struct em28xx *dev);
 
 #else
 
-#define em28xx_get_key_terratec			NULL
-#define em28xx_get_key_em_haup			NULL
-#define em28xx_get_key_pinnacle_usb_grey	NULL
-#define em28xx_get_key_winfast_usbii_deluxe	NULL
-
-static inline void em28xx_register_snapshot_button(struct em28xx *dev) {}
-static inline void em28xx_deregister_snapshot_button(struct em28xx *dev) {}
 static inline int em28xx_ir_init(struct em28xx *dev) { return 0; }
 static inline int em28xx_ir_fini(struct em28xx *dev) { return 0; }
 
-- 
1.7.3.4

