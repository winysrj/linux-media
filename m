Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49243 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751666AbdJ2U6Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:58:25 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 02/28] media: rc: i2c: use dev_dbg rather hand-rolled debug
Date: Sun, 29 Oct 2017 20:58:23 +0000
Message-Id: <1ff1e5386e75cd946c39089ab3ca229883770cc3.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the dev_dbg dynamic infrastructure instead of rolling our own custom
debug logic.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/i2c/ir-kbd-i2c.c | 61 +++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 36 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 27e36f45286c..1b8cd1b75bfb 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -46,18 +46,6 @@
 #include <media/rc-core.h>
 #include <media/i2c/ir-kbd-i2c.h>
 
-/* ----------------------------------------------------------------------- */
-/* insmod parameters                                                       */
-
-static int debug;
-module_param(debug, int, 0644);    /* debug level (0,1,2) */
-
-
-#define MODULE_NAME "ir-kbd-i2c"
-#define dprintk(level, fmt, arg...)	if (debug >= level) \
-	printk(KERN_DEBUG MODULE_NAME ": " fmt , ## arg)
-
-/* ----------------------------------------------------------------------- */
 
 static int get_key_haup_common(struct IR_i2c *ir, enum rc_proto *protocol,
 			       u32 *scancode, u8 *ptoggle, int size)
@@ -96,7 +84,8 @@ static int get_key_haup_common(struct IR_i2c *ir, enum rc_proto *protocol,
 		if (!range)
 			code += 64;
 
-		dprintk(1, "ir hauppauge (rc5): s%d r%d t%d dev=%d code=%d\n",
+		dev_dbg(&ir->rc->dev,
+			"ir hauppauge (rc5): s%d r%d t%d dev=%d code=%d\n",
 			start, range, toggle, dev, code);
 
 		*protocol = RC_PROTO_RC5;
@@ -113,13 +102,15 @@ static int get_key_haup_common(struct IR_i2c *ir, enum rc_proto *protocol,
 			*ptoggle = (dev & 0x80) != 0;
 			*protocol = RC_PROTO_RC6_MCE;
 			dev &= 0x7f;
-			dprintk(1, "ir hauppauge (rc6-mce): t%d vendor=%d dev=%d code=%d\n",
-						*ptoggle, vendor, dev, code);
+			dev_dbg(&ir->rc->dev,
+				"ir hauppauge (rc6-mce): t%d vendor=%d dev=%d code=%d\n",
+				*ptoggle, vendor, dev, code);
 		} else {
 			*ptoggle = 0;
 			*protocol = RC_PROTO_RC6_6A_32;
-			dprintk(1, "ir hauppauge (rc6-6a-32): vendor=%d dev=%d code=%d\n",
-							vendor, dev, code);
+			dev_dbg(&ir->rc->dev,
+				"ir hauppauge (rc6-6a-32): vendor=%d dev=%d code=%d\n",
+				vendor, dev, code);
 		}
 
 		*scancode = RC_SCANCODE_RC6_6A(vendor, dev, code);
@@ -162,7 +153,7 @@ static int get_key_pixelview(struct IR_i2c *ir, enum rc_proto *protocol,
 
 	/* poll IR chip */
 	if (1 != i2c_master_recv(ir->c, &b, 1)) {
-		dprintk(1,"read error\n");
+		dev_dbg(&ir->rc->dev, "read error\n");
 		return -EIO;
 	}
 
@@ -179,13 +170,12 @@ static int get_key_fusionhdtv(struct IR_i2c *ir, enum rc_proto *protocol,
 
 	/* poll IR chip */
 	if (4 != i2c_master_recv(ir->c, buf, 4)) {
-		dprintk(1,"read error\n");
+		dev_dbg(&ir->rc->dev, "read error\n");
 		return -EIO;
 	}
 
-	if(buf[0] !=0 || buf[1] !=0 || buf[2] !=0 || buf[3] != 0)
-		dprintk(2, "%s: 0x%2x 0x%2x 0x%2x 0x%2x\n", __func__,
-			buf[0], buf[1], buf[2], buf[3]);
+	if (buf[0] != 0 || buf[1] != 0 || buf[2] != 0 || buf[3] != 0)
+		dev_dbg(&ir->rc->dev, "%s: %*ph\n", __func__, 4, buf);
 
 	/* no key pressed or signal from other ir remote */
 	if(buf[0] != 0x1 ||  buf[1] != 0xfe)
@@ -204,7 +194,7 @@ static int get_key_knc1(struct IR_i2c *ir, enum rc_proto *protocol,
 
 	/* poll IR chip */
 	if (1 != i2c_master_recv(ir->c, &b, 1)) {
-		dprintk(1,"read error\n");
+		dev_dbg(&ir->rc->dev, "read error\n");
 		return -EIO;
 	}
 
@@ -212,7 +202,7 @@ static int get_key_knc1(struct IR_i2c *ir, enum rc_proto *protocol,
 	   down, while 0xff indicates that no button is hold
 	   down. 0xfe sequences are sometimes interrupted by 0xFF */
 
-	dprintk(2,"key %02x\n", b);
+	dev_dbg(&ir->rc->dev, "key %02x\n", b);
 
 	if (b == 0xff)
 		return 0;
@@ -237,7 +227,7 @@ static int get_key_avermedia_cardbus(struct IR_i2c *ir, enum rc_proto *protocol,
 				  .buf = &key, .len = 1} };
 	subaddr = 0x0d;
 	if (2 != i2c_transfer(ir->c->adapter, msg, 2)) {
-		dprintk(1, "read error\n");
+		dev_dbg(&ir->rc->dev, "read error\n");
 		return -EIO;
 	}
 
@@ -247,18 +237,17 @@ static int get_key_avermedia_cardbus(struct IR_i2c *ir, enum rc_proto *protocol,
 	subaddr = 0x0b;
 	msg[1].buf = &keygroup;
 	if (2 != i2c_transfer(ir->c->adapter, msg, 2)) {
-		dprintk(1, "read error\n");
+		dev_dbg(&ir->rc->dev, "read error\n");
 		return -EIO;
 	}
 
 	if (keygroup == 0xff)
 		return 0;
 
-	dprintk(1, "read key 0x%02x/0x%02x\n", key, keygroup);
+	dev_dbg(&ir->rc->dev, "read key 0x%02x/0x%02x\n", key, keygroup);
 	if (keygroup < 2 || keygroup > 4) {
-		/* Only a warning */
-		dprintk(1, "warning: invalid key group 0x%02x for key 0x%02x\n",
-								keygroup, key);
+		dev_warn(&ir->rc->dev, "warning: invalid key group 0x%02x for key 0x%02x\n",
+			 keygroup, key);
 	}
 	key |= (keygroup & 1) << 6;
 
@@ -279,15 +268,15 @@ static int ir_key_poll(struct IR_i2c *ir)
 	u8 toggle;
 	int rc;
 
-	dprintk(3, "%s\n", __func__);
+	dev_dbg(&ir->rc->dev, "%s\n", __func__);
 	rc = ir->get_key(ir, &protocol, &scancode, &toggle);
 	if (rc < 0) {
-		dprintk(2,"error\n");
+		dev_warn(&ir->rc->dev, "error %d\n", rc);
 		return rc;
 	}
 
 	if (rc) {
-		dprintk(1, "%s: proto = 0x%04x, scancode = 0x%08x\n",
+		dev_dbg(&ir->rc->dev, "%s: proto = 0x%04x, scancode = 0x%08x\n",
 			__func__, protocol, scancode);
 		rc_keydown(ir->rc, protocol, scancode, toggle);
 	}
@@ -433,8 +422,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	/* Make sure we are all setup before going on */
 	if (!name || !ir->get_key || !rc_proto || !ir_codes) {
-		dprintk(1, ": Unsupported device at address 0x%02x\n",
-			addr);
+		dev_warn(&client->dev, "Unsupported device at address 0x%02x\n",
+			 addr);
 		err = -ENODEV;
 		goto err_out_free;
 	}
@@ -459,7 +448,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	rc->map_name       = ir->ir_codes;
 	rc->allowed_protocols = rc_proto;
 	if (!rc->driver_name)
-		rc->driver_name = MODULE_NAME;
+		rc->driver_name = KBUILD_MODNAME;
 
 	err = rc_register_device(rc);
 	if (err)
-- 
2.13.6
