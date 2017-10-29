Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:44905 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751792AbdJ2U6i (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:58:38 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Andy Walls <awalls.cx18@gmail.com>
Subject: [PATCH 06/28] media: i2c: enable i2c IR for hardware which isn't HD-PVR
Date: Sun, 29 Oct 2017 20:58:37 +0000
Message-Id: <8b0a5d261a8bab2c44e7b1d551fa7001e4268a66.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a fix for commit 329d88da4df9 ("[media] media: i2c: Don't export
ir-kbd-i2c module alias") that stopped the module from being loaded
automagically.

The problems described only affect the HD-PVR, so it should not affect
other hardware; also if the module happens to be loaded, the i2c IR
part of the HD-PVR will be enabled anyway.

Fixes: 329d88da4df9 ("[media] media: i2c: Don't export ir-kbd-i2c module alias")

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/i2c/ir-kbd-i2c.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index b656c8ec31ca..919c4a4e6007 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -63,6 +63,9 @@
 #define FLAG_TX		1
 #define FLAG_HDPVR	2
 
+static bool enable_hdpvr;
+module_param(enable_hdpvr, bool, 0644);
+
 static int get_key_haup_common(struct IR_i2c *ir, enum rc_proto *protocol,
 			       u32 *scancode, u8 *ptoggle, int size)
 {
@@ -726,6 +729,11 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	unsigned short addr = client->addr;
 	int err;
 
+	if ((id->driver_data & FLAG_HDPVR) && !enable_hdpvr) {
+		dev_err(&client->dev, "IR for HDPVR is known to cause problems during recording, use enable_hdpvr modparam to enable\n");
+		return -ENODEV;
+	}
+
 	ir = devm_kzalloc(&client->dev, sizeof(*ir), GFP_KERNEL);
 	if (!ir)
 		return -ENOMEM;
@@ -925,6 +933,7 @@ static const struct i2c_device_id ir_kbd_id[] = {
 	{ "ir_z8f0811_hdpvr", FLAG_TX | FLAG_HDPVR },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, ir_kbd_id);
 
 static struct i2c_driver ir_kbd_driver = {
 	.driver = {
-- 
2.13.6
