Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36669 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751666AbdJ2U61 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:58:27 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 03/28] media: rc: i2c: only poll if the rc device is opened
Date: Sun, 29 Oct 2017 20:58:25 +0000
Message-Id: <8993198484d3288550dea524ef60e2d2b0161598.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lirc_zilog driver only polls the device if the lirc chardev
is opened; do the same with the rc-core driver.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/i2c/ir-kbd-i2c.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 1b8cd1b75bfb..22f32717638a 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -298,6 +298,22 @@ static void ir_work(struct work_struct *work)
 	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling_interval));
 }
 
+static int ir_open(struct rc_dev *dev)
+{
+	struct IR_i2c *ir = dev->priv;
+
+	schedule_delayed_work(&ir->work, 0);
+
+	return 0;
+}
+
+static void ir_close(struct rc_dev *dev)
+{
+	struct IR_i2c *ir = dev->priv;
+
+	cancel_delayed_work_sync(&ir->work);
+}
+
 /* ----------------------------------------------------------------------- */
 
 static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
@@ -441,6 +457,9 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	rc->input_phys       = ir->phys;
 	rc->device_name	     = name;
 	rc->dev.parent       = &client->dev;
+	rc->priv             = ir;
+	rc->open             = ir_open;
+	rc->close            = ir_close;
 
 	/*
 	 * Initialize the other fields of rc_dev
@@ -450,14 +469,12 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (!rc->driver_name)
 		rc->driver_name = KBUILD_MODNAME;
 
+	INIT_DELAYED_WORK(&ir->work, ir_work);
+
 	err = rc_register_device(rc);
 	if (err)
 		goto err_out_free;
 
-	/* start polling via eventd */
-	INIT_DELAYED_WORK(&ir->work, ir_work);
-	schedule_delayed_work(&ir->work, 0);
-
 	return 0;
 
  err_out_free:
-- 
2.13.6
