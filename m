Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:39174 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab3AMOUd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 09:20:33 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so1611690eek.32
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 06:20:32 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 6/7] em28xx: i2c RC devices: minor code size and memory usage optimization
Date: Sun, 13 Jan 2013 15:20:44 +0100
Message-Id: <1358086845-6989-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1358086845-6989-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1358086845-6989-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set up the i2c_client locally in em28xx_i2c_ir_handle_key().

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c |   43 ++++++++++++-------------------
 1 Datei geändert, 16 Zeilen hinzugefügt(+), 27 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index f4d0df8..2a49cc1 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -69,8 +69,8 @@ struct em28xx_IR {
 	unsigned int last_readcount;
 	u64 rc_type;
 
-	/* external device (if used) */
-	struct i2c_client *i2c_dev;
+	/* i2c slave address of external device (if used) */
+	u16 i2c_dev_addr;
 
 	int  (*get_key_i2c)(struct i2c_client *, u32 *);
 	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
@@ -282,8 +282,12 @@ static int em28xx_i2c_ir_handle_key(struct em28xx_IR *ir)
 {
 	static u32 ir_key;
 	int rc;
+	struct i2c_client client;
+ 
+	client.adapter = &ir->dev->i2c_adap;
+	client.addr = ir->i2c_dev_addr;
 
-	rc = ir->get_key_i2c(ir->i2c_dev, &ir_key);
+	rc = ir->get_key_i2c(&client, &ir_key);
 	if (rc < 0) {
 		dprintk("ir->get_key_i2c() failed: %d\n", rc);
 		return rc;
@@ -354,7 +358,7 @@ static int em28xx_ir_start(struct rc_dev *rc)
 {
 	struct em28xx_IR *ir = rc->priv;
 
-	if (ir->i2c_dev) /* external i2c device */
+	if (ir->i2c_dev_addr) /* external i2c device */
 		INIT_DELAYED_WORK(&ir->work, em28xx_i2c_ir_work);
 	else /* internal device */
 		INIT_DELAYED_WORK(&ir->work, em28xx_ir_work);
@@ -454,10 +458,9 @@ static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
 	}
 }
 
-static struct i2c_client * em28xx_probe_i2c_ir(struct em28xx *dev)
+static int em28xx_probe_i2c_ir(struct em28xx *dev)
 {
 	int i = 0;
-	struct i2c_client *i2c_dev = NULL;
 	/* Leadtek winfast tv USBII deluxe can find a non working IR-device */
 	/* at address 0x18, so if that address is needed for another board in */
 	/* the future, please put it after 0x1f. */
@@ -466,21 +469,12 @@ static struct i2c_client * em28xx_probe_i2c_ir(struct em28xx *dev)
 	};
 
 	while (addr_list[i] != I2C_CLIENT_END) {
-		if (i2c_probe_func_quick_read(&dev->i2c_adap, addr_list[i]) == 1) {
-			i2c_dev = kzalloc(sizeof(*i2c_dev), GFP_KERNEL);
-			if (i2c_dev)  {
-				i2c_dev->addr = addr_list[i];
-				i2c_dev->adapter = &dev->i2c_adap;
-				/* NOTE: as long as we don't register the device
-				 * at the i2c subsystem, no other fields need to
-				 * be set up */
-			}
-			break;
-		}
+		if (i2c_probe_func_quick_read(&dev->i2c_adap, addr_list[i]) == 1)
+			return addr_list[i];
 		i++;
 	}
 
-	return i2c_dev;
+	return -ENODEV;
 }
 
 /**********************************************************
@@ -576,14 +570,14 @@ static int em28xx_ir_init(struct em28xx *dev)
 	struct rc_dev *rc;
 	int err = -ENOMEM;
 	u64 rc_type;
-	struct i2c_client *i2c_rc_dev = NULL;
+	u16 i2c_rc_dev_addr = 0;
 
 	if (dev->board.has_snapshot_button)
 		em28xx_register_snapshot_button(dev);
 
 	if (dev->board.has_ir_i2c) {
-		i2c_rc_dev = em28xx_probe_i2c_ir(dev);
-		if (!i2c_rc_dev) {
+		i2c_rc_dev_addr = em28xx_probe_i2c_ir(dev);
+		if (!i2c_rc_dev_addr) {
 			dev->board.has_ir_i2c = 0;
 			em28xx_warn("No i2c IR remote control device found.\n");
 			return -ENODEV;
@@ -636,7 +630,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 			goto error;
 		}
 
-		ir->i2c_dev = i2c_rc_dev;
+		ir->i2c_dev_addr = i2c_rc_dev_addr;
 	} else {	/* internal device */
 		switch (dev->chip_id) {
 		case CHIP_ID_EM2860:
@@ -692,8 +686,6 @@ static int em28xx_ir_init(struct em28xx *dev)
 	return 0;
 
 error:
-	if (ir && ir->i2c_dev)
-		kfree(ir->i2c_dev);
 	dev->ir = NULL;
 	rc_free_device(rc);
 	kfree(ir);
@@ -713,9 +705,6 @@ static int em28xx_ir_fini(struct em28xx *dev)
 	if (ir->rc)
 		rc_unregister_device(ir->rc);
 
-	if (ir->i2c_dev)
-		kfree(ir->i2c_dev);
-
 	/* done */
 	kfree(ir);
 	dev->ir = NULL;
-- 
1.7.10.4

