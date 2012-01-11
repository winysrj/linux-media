Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756692Ab2AKAWP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 19:22:15 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0B0MFsU002336
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 19:22:15 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/6] [media] cx231xx-input: stop polling if the device got removed.
Date: Tue, 10 Jan 2012 22:20:22 -0200
Message-Id: <1326241226-6734-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326241226-6734-1-git-send-email-mchehab@redhat.com>
References: <1326241226-6734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the device got removed, stops polling it. Also, un-registers
it at input/evdev, as it won't work anymore. We can't free the
IR structure yet, as the ir_remove method will be called later.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/cx231xx/cx231xx-input.c |    6 +++++-
 drivers/media/video/ir-kbd-i2c.c            |   17 +++++++++++++----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
index 45e14ca..8a75a90 100644
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ b/drivers/media/video/cx231xx/cx231xx-input.c
@@ -27,12 +27,16 @@
 static int get_key_isdbt(struct IR_i2c *ir, u32 *ir_key,
 			 u32 *ir_raw)
 {
+	int	rc;
 	u8	cmd, scancode;
 
 	dev_dbg(&ir->rc->input_dev->dev, "%s\n", __func__);
 
 		/* poll IR chip */
-	if (1 != i2c_master_recv(ir->c, &cmd, 1))
+	rc = i2c_master_recv(ir->c, &cmd, 1);
+	if (rc < 0)
+		return rc;
+	if (rc != 1)
 		return -EIO;
 
 	/* it seems that 0xFE indicates that a button is still hold
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 3ab875d..37d0c20 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -244,7 +244,7 @@ static int get_key_avermedia_cardbus(struct IR_i2c *ir,
 
 /* ----------------------------------------------------------------------- */
 
-static void ir_key_poll(struct IR_i2c *ir)
+static int ir_key_poll(struct IR_i2c *ir)
 {
 	static u32 ir_key, ir_raw;
 	int rc;
@@ -253,20 +253,28 @@ static void ir_key_poll(struct IR_i2c *ir)
 	rc = ir->get_key(ir, &ir_key, &ir_raw);
 	if (rc < 0) {
 		dprintk(2,"error\n");
-		return;
+		return rc;
 	}
 
 	if (rc) {
 		dprintk(1, "%s: keycode = 0x%04x\n", __func__, ir_key);
 		rc_keydown(ir->rc, ir_key, 0);
 	}
+	return 0;
 }
 
 static void ir_work(struct work_struct *work)
 {
+	int rc;
 	struct IR_i2c *ir = container_of(work, struct IR_i2c, work.work);
 
-	ir_key_poll(ir);
+	rc = ir_key_poll(ir);
+	if (rc == -ENODEV) {
+		rc_unregister_device(ir->rc);
+		ir->rc = NULL;
+		return;
+	}
+
 	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling_interval));
 }
 
@@ -446,7 +454,8 @@ static int ir_remove(struct i2c_client *client)
 	cancel_delayed_work_sync(&ir->work);
 
 	/* unregister device */
-	rc_unregister_device(ir->rc);
+	if (ir->rc)
+		rc_unregister_device(ir->rc);
 
 	/* free memory */
 	kfree(ir);
-- 
1.7.7.5

