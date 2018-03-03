Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:51573 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752305AbeCCUvS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 15:51:18 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 10/11] media: em28xx-input: fix most coding style issues
Date: Sat,  3 Mar 2018 17:51:11 -0300
Message-Id: <a8c51d680f9bb9c50c02e74b7dcf415f82b900b2.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a number of coding style issues at em28xx-input.
Fix most of them, by using checkpatch in strict mode to point
for it.

Automatic fixes were made with --fix-inplace, but those
were complemented by manual work.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-input.c | 121 +++++++++++++++++++-------------
 1 file changed, 74 insertions(+), 47 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index c7afcf67ccc5..eb2ec0384b69 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -37,15 +37,15 @@ MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
 
 #define MODULE_NAME "em28xx"
 
-#define dprintk( fmt, arg...) do {					\
+#define dprintk(fmt, arg...) do {					\
 	if (ir_debug)							\
 		dev_printk(KERN_DEBUG, &ir->dev->intf->dev,		\
 			   "input: %s: " fmt, __func__, ## arg);	\
 } while (0)
 
-/**********************************************************
- Polling structure used by em28xx IR's
- **********************************************************/
+/*
+ * Polling structure used by em28xx IR's
+ */
 
 struct em28xx_ir_poll_result {
 	unsigned int toggle_bit:1;
@@ -72,12 +72,12 @@ struct em28xx_IR {
 
 	int  (*get_key_i2c)(struct i2c_client *ir, enum rc_proto *protocol,
 			    u32 *scancode);
-	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
+	int  (*get_key)(struct em28xx_IR *ir, struct em28xx_ir_poll_result *r);
 };
 
-/**********************************************************
- I2C IR based get keycodes - should be used with ir-kbd-i2c
- **********************************************************/
+/*
+ * I2C IR based get keycodes - should be used with ir-kbd-i2c
+ */
 
 static int em28xx_get_key_terratec(struct i2c_client *i2c_dev,
 				   enum rc_proto *protocol, u32 *scancode)
@@ -85,11 +85,13 @@ static int em28xx_get_key_terratec(struct i2c_client *i2c_dev,
 	unsigned char b;
 
 	/* poll IR chip */
-	if (1 != i2c_master_recv(i2c_dev, &b, 1))
+	if (i2c_master_recv(i2c_dev, &b, 1) != 1)
 		return -EIO;
 
-	/* it seems that 0xFE indicates that a button is still hold
-	   down, while 0xff indicates that no button is hold down. */
+	/*
+	 * it seems that 0xFE indicates that a button is still hold
+	 * down, while 0xff indicates that no button is hold down.
+	 */
 
 	if (b == 0xff)
 		return 0;
@@ -141,7 +143,7 @@ static int em28xx_get_key_pinnacle_usb_grey(struct i2c_client *i2c_dev,
 
 	/* poll IR chip */
 
-	if (3 != i2c_master_recv(i2c_dev, buf, 3))
+	if (i2c_master_recv(i2c_dev, buf, 3) != 3)
 		return -EIO;
 
 	if (buf[0] != 0x00)
@@ -158,18 +160,28 @@ static int em28xx_get_key_winfast_usbii_deluxe(struct i2c_client *i2c_dev,
 {
 	unsigned char subaddr, keydetect, key;
 
-	struct i2c_msg msg[] = { { .addr = i2c_dev->addr, .flags = 0, .buf = &subaddr, .len = 1},
-				 { .addr = i2c_dev->addr, .flags = I2C_M_RD, .buf = &keydetect, .len = 1} };
+	struct i2c_msg msg[] = {
+		{
+			.addr = i2c_dev->addr,
+			.flags = 0,
+			.buf = &subaddr, .len = 1
+		}, {
+			.addr = i2c_dev->addr,
+			.flags = I2C_M_RD,
+			.buf = &keydetect,
+			.len = 1
+		}
+	};
 
 	subaddr = 0x10;
-	if (2 != i2c_transfer(i2c_dev->adapter, msg, 2))
+	if (i2c_transfer(i2c_dev->adapter, msg, 2) != 2)
 		return -EIO;
 	if (keydetect == 0x00)
 		return 0;
 
 	subaddr = 0x00;
 	msg[1].buf = &key;
-	if (2 != i2c_transfer(i2c_dev->adapter, msg, 2))
+	if (i2c_transfer(i2c_dev->adapter, msg, 2) != 2)
 		return -EIO;
 	if (key == 0x00)
 		return 0;
@@ -179,9 +191,9 @@ static int em28xx_get_key_winfast_usbii_deluxe(struct i2c_client *i2c_dev,
 	return 1;
 }
 
-/**********************************************************
- Poll based get keycode functions
- **********************************************************/
+/*
+ * Poll based get keycode functions
+ */
 
 /* This is for the em2860/em2880 */
 static int default_polling_getkey(struct em28xx_IR *ir,
@@ -191,8 +203,9 @@ static int default_polling_getkey(struct em28xx_IR *ir,
 	int rc;
 	u8 msg[3] = { 0, 0, 0 };
 
-	/* Read key toggle, brand, and key code
-	   on registers 0x45, 0x46 and 0x47
+	/*
+	 * Read key toggle, brand, and key code
+	 * on registers 0x45, 0x46 and 0x47
 	 */
 	rc = dev->em28xx_read_reg_req_len(dev, 0, EM28XX_R45_IR,
 					  msg, sizeof(msg));
@@ -233,8 +246,9 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 	int rc;
 	u8 msg[5] = { 0, 0, 0, 0, 0 };
 
-	/* Read key toggle, brand, and key code
-	   on registers 0x51-55
+	/*
+	 * Read key toggle, brand, and key code
+	 * on registers 0x51-55
 	 */
 	rc = dev->em28xx_read_reg_req_len(dev, 0, EM2874_R51_IR,
 					  msg, sizeof(msg));
@@ -290,9 +304,9 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 	return 0;
 }
 
-/**********************************************************
- Polling code for em28xx
- **********************************************************/
+/*
+ * Polling code for em28xx
+ */
 
 static int em28xx_i2c_ir_handle_key(struct em28xx_IR *ir)
 {
@@ -343,11 +357,14 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 
 		if (ir->dev->chip_id == CHIP_ID_EM2874 ||
 		    ir->dev->chip_id == CHIP_ID_EM2884)
-			/* The em2874 clears the readcount field every time the
-			   register is read.  The em2860/2880 datasheet says that it
-			   is supposed to clear the readcount, but it doesn't.  So with
-			   the em2874, we are looking for a non-zero read count as
-			   opposed to a readcount that is incrementing */
+			/*
+			 * The em2874 clears the readcount field every time the
+			 * register is read.  The em2860/2880 datasheet says
+			 * that it is supposed to clear the readcount, but it
+			 * doesn't. So with the em2874, we are looking for a
+			 * non-zero read count as opposed to a readcount
+			 * that is incrementing
+			 */
 			ir->last_readcount = 0;
 		else
 			ir->last_readcount = poll_result.read_count;
@@ -472,15 +489,18 @@ static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_proto)
 static int em28xx_probe_i2c_ir(struct em28xx *dev)
 {
 	int i = 0;
-	/* Leadtek winfast tv USBII deluxe can find a non working IR-device */
-	/* at address 0x18, so if that address is needed for another board in */
-	/* the future, please put it after 0x1f. */
+	/*
+	 * Leadtek winfast tv USBII deluxe can find a non working IR-device
+	 * at address 0x18, so if that address is needed for another board in
+	 * the future, please put it after 0x1f.
+	 */
 	const unsigned short addr_list[] = {
 		 0x1f, 0x30, 0x47, I2C_CLIENT_END
 	};
 
 	while (addr_list[i] != I2C_CLIENT_END) {
-		if (i2c_probe_func_quick_read(&dev->i2c_adap[dev->def_i2c_bus], addr_list[i]) == 1)
+		if (i2c_probe_func_quick_read(&dev->i2c_adap[dev->def_i2c_bus],
+					      addr_list[i]) == 1)
 			return addr_list[i];
 		i++;
 	}
@@ -488,9 +508,9 @@ static int em28xx_probe_i2c_ir(struct em28xx *dev)
 	return -ENODEV;
 }
 
-/**********************************************************
- Handle buttons
- **********************************************************/
+/*
+ * Handle buttons
+ */
 
 static void em28xx_query_buttons(struct work_struct *work)
 {
@@ -511,7 +531,9 @@ static void em28xx_query_buttons(struct work_struct *work)
 		j = 0;
 		while (dev->board.buttons[j].role >= 0 &&
 		       dev->board.buttons[j].role < EM28XX_NUM_BUTTON_ROLES) {
-			const struct em28xx_button *button = &dev->board.buttons[j];
+			const struct em28xx_button *button;
+
+			button = &dev->board.buttons[j];
 
 			/* Check if button uses the current address */
 			if (button->reg_r != dev->button_polling_addresses[i]) {
@@ -647,6 +669,7 @@ static void em28xx_init_buttons(struct em28xx *dev)
 		/* Add read address to list of polling addresses */
 		if (addr_new) {
 			unsigned int index = dev->num_button_polling_addresses;
+
 			dev->button_polling_addresses[index] = button->reg_r;
 			dev->num_button_polling_addresses++;
 		}
@@ -675,7 +698,7 @@ static void em28xx_shutdown_buttons(struct em28xx *dev)
 	/* Clear polling addresses list */
 	dev->num_button_polling_addresses = 0;
 	/* Deregister input devices */
-	if (dev->sbutton_input_dev != NULL) {
+	if (dev->sbutton_input_dev) {
 		dev_info(&dev->intf->dev, "Deregistering snapshot button\n");
 		input_unregister_device(dev->sbutton_input_dev);
 		dev->sbutton_input_dev = NULL;
@@ -712,7 +735,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 		}
 	}
 
-	if (dev->board.ir_codes == NULL && !dev->board.has_ir_i2c) {
+	if (!dev->board.ir_codes && !dev->board.has_ir_i2c) {
 		/* No remote control support */
 		dev_warn(&dev->intf->dev,
 			 "Remote control support is not available for this card.\n");
@@ -762,7 +785,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 			goto error;
 		}
 
-		ir->i2c_client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
+		ir->i2c_client = kzalloc(sizeof(*ir->i2c_client), GFP_KERNEL);
 		if (!ir->i2c_client)
 			goto error;
 		ir->i2c_client->adapter = &ir->dev->i2c_adap[dev->def_i2c_bus];
@@ -879,9 +902,11 @@ static int em28xx_ir_suspend(struct em28xx *dev)
 	if (ir)
 		cancel_delayed_work_sync(&ir->work);
 	cancel_delayed_work_sync(&dev->buttons_query_work);
-	/* is canceling delayed work sufficient or does the rc event
-	   kthread needs stopping? kthread is stopped in
-	   ir_raw_event_unregister() */
+	/*
+	 * is canceling delayed work sufficient or does the rc event
+	 * kthread needs stopping? kthread is stopped in
+	 * ir_raw_event_unregister()
+	 */
 	return 0;
 }
 
@@ -893,8 +918,10 @@ static int em28xx_ir_resume(struct em28xx *dev)
 		return 0;
 
 	dev_info(&dev->intf->dev, "Resuming input extension\n");
-	/* if suspend calls ir_raw_event_unregister(), the should call
-	   ir_raw_event_register() */
+	/*
+	 * if suspend calls ir_raw_event_unregister(), the should call
+	 * ir_raw_event_register()
+	 */
 	if (ir)
 		schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 	if (dev->num_button_polling_addresses)
-- 
2.14.3
