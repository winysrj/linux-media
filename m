Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34035 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751666AbdJ2U6X (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:58:23 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 01/28] media: rc: i2c: set parent of rc device and improve name
Date: Sun, 29 Oct 2017 20:58:21 +0000
Message-Id: <035cee19aef712aa088427d169c39b9a7b6bc5ae.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the parent set for the rc device, the messages clearly state
that it is attached via i2c. The additional printk is unnecessary.

So these are the old messages:

rc rc1: i2c IR (Hauppauge WinTV PVR-150 as /devices/virtual/rc/rc1
ir-kbd-i2c: i2c IR (Hauppauge WinTV PVR-150 detected at i2c-10/10-0071/ir0 [ivtv i2c driver #0]

Now we simply get:

rc rc1: Hauppauge WinTV PVR-150 as /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/i2c-10/10-0071/rc/rc1

Note that we no longer copy the name. I've checked all call sites
to verfiy this is not a problem.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/i2c/ir-kbd-i2c.c            | 11 +++--------
 drivers/media/pci/saa7134/saa7134-input.c |  3 ++-
 include/media/i2c/ir-kbd-i2c.h            |  1 -
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 8b5f7d0435e4..27e36f45286c 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -439,12 +439,9 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		goto err_out_free;
 	}
 
-	/* Sets name */
-	snprintf(ir->name, sizeof(ir->name), "i2c IR (%s)", name);
 	ir->ir_codes = ir_codes;
 
-	snprintf(ir->phys, sizeof(ir->phys), "%s/%s/ir0",
-		 dev_name(&adap->dev),
+	snprintf(ir->phys, sizeof(ir->phys), "%s/%s", dev_name(&adap->dev),
 		 dev_name(&client->dev));
 
 	/*
@@ -453,7 +450,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 */
 	rc->input_id.bustype = BUS_I2C;
 	rc->input_phys       = ir->phys;
-	rc->device_name	     = ir->name;
+	rc->device_name	     = name;
+	rc->dev.parent       = &client->dev;
 
 	/*
 	 * Initialize the other fields of rc_dev
@@ -467,9 +465,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (err)
 		goto err_out_free;
 
-	printk(MODULE_NAME ": %s detected at %s [%s]\n",
-	       ir->name, ir->phys, adap->name);
-
 	/* start polling via eventd */
 	INIT_DELAYED_WORK(&ir->work, ir_work);
 	schedule_delayed_work(&ir->work, 0);
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 9337e4615519..965098e74c64 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -43,7 +43,8 @@ MODULE_PARM_DESC(pinnacle_remote, "Specify Pinnacle PCTV remote: 0=coloured, 1=g
 	} while (0)
 #define ir_dbg(ir, fmt, arg...) do { \
 	if (ir_debug) \
-		printk(KERN_DEBUG pr_fmt("ir %s: " fmt), ir->name, ## arg); \
+		printk(KERN_DEBUG pr_fmt("ir %s: " fmt), ir->rc->device_name, \
+		       ## arg); \
 	} while (0)
 
 /* Helper function for raw decoding at GPIO16 or GPIO18 */
diff --git a/include/media/i2c/ir-kbd-i2c.h b/include/media/i2c/ir-kbd-i2c.h
index ac8c55617a79..092ab44da7e0 100644
--- a/include/media/i2c/ir-kbd-i2c.h
+++ b/include/media/i2c/ir-kbd-i2c.h
@@ -18,7 +18,6 @@ struct IR_i2c {
 	u32                    polling_interval; /* in ms */
 
 	struct delayed_work    work;
-	char                   name[32];
 	char                   phys[32];
 	int                    (*get_key)(struct IR_i2c *ir,
 					  enum rc_proto *protocol,
-- 
2.13.6
