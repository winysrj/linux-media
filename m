Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36257 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaHOSPx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Aug 2014 14:15:53 -0400
Received: by mail-lb0-f181.google.com with SMTP id 10so2251003lbg.12
        for <linux-media@vger.kernel.org>; Fri, 15 Aug 2014 11:15:51 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx-input: i2c IR decoders: improve i2c_client handling
Date: Fri, 15 Aug 2014 20:16:58 +0200
Message-Id: <1408126618-4043-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using a temporary stack allocated i2c_client in em28xx_i2c_ir_handle_key(),
allocate/free the i2c_client at module init/uninit and hook it into struct em28xx_IR
(if the device has an i2c IR decoder).
This reduces the frame size of function em28xx_i2c_ir_handle_key() and speeds
it up a bit.
Also make sure that all fields of struct i2c_client are initialized properly.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index ed843bd..962446a 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -71,8 +71,7 @@ struct em28xx_IR {
 	unsigned int last_readcount;
 	u64 rc_type;
 
-	/* i2c slave address of external device (if used) */
-	u16 i2c_dev_addr;
+	struct i2c_client *i2c_client;
 
 	int  (*get_key_i2c)(struct i2c_client *ir, enum rc_type *protocol, u32 *scancode);
 	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
@@ -294,16 +293,11 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 
 static int em28xx_i2c_ir_handle_key(struct em28xx_IR *ir)
 {
-	struct em28xx *dev = ir->dev;
 	static u32 scancode;
 	enum rc_type protocol;
 	int rc;
-	struct i2c_client client;
-
-	client.adapter = &ir->dev->i2c_adap[dev->def_i2c_bus];
-	client.addr = ir->i2c_dev_addr;
 
-	rc = ir->get_key_i2c(&client, &protocol, &scancode);
+	rc = ir->get_key_i2c(ir->i2c_client, &protocol, &scancode);
 	if (rc < 0) {
 		dprintk("ir->get_key_i2c() failed: %d\n", rc);
 		return rc;
@@ -361,7 +355,7 @@ static void em28xx_ir_work(struct work_struct *work)
 {
 	struct em28xx_IR *ir = container_of(work, struct em28xx_IR, work.work);
 
-	if (ir->i2c_dev_addr) /* external i2c device */
+	if (ir->i2c_client) /* external i2c device */
 		em28xx_i2c_ir_handle_key(ir);
 	else /* internal device */
 		em28xx_ir_handle_key(ir);
@@ -756,7 +750,13 @@ static int em28xx_ir_init(struct em28xx *dev)
 			goto error;
 		}
 
-		ir->i2c_dev_addr = i2c_rc_dev_addr;
+		ir->i2c_client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
+		if (!ir->i2c_client)
+			goto error;
+		ir->i2c_client->adapter = &ir->dev->i2c_adap[dev->def_i2c_bus];
+		ir->i2c_client->addr = i2c_rc_dev_addr;
+		ir->i2c_client->flags = 0;
+		/* NOTE: all other fields of i2c_client are unused */
 	} else {	/* internal device */
 		switch (dev->chip_id) {
 		case CHIP_ID_EM2860:
@@ -815,6 +815,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 	return 0;
 
 error:
+	kfree(ir->i2c_client);
 	dev->ir = NULL;
 	rc_free_device(rc);
 	kfree(ir);
@@ -841,6 +842,8 @@ static int em28xx_ir_fini(struct em28xx *dev)
 	if (ir->rc)
 		rc_unregister_device(ir->rc);
 
+	kfree(ir->i2c_client);
+
 	/* done */
 	kfree(ir);
 	dev->ir = NULL;
-- 
1.8.4.5

