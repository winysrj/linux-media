Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:51235 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab0FGTcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 15:32:36 -0400
Subject: [PATCH 4/8] ir-core: partially convert ir-kbd-i2c.c to not use
	ir-functions.c
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Date: Mon, 07 Jun 2010 21:32:33 +0200
Message-ID: <20100607193233.21236.11164.stgit@localhost.localdomain>
In-Reply-To: <20100607192830.21236.69701.stgit@localhost.localdomain>
References: <20100607192830.21236.69701.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Partially convert drivers/media/video/ir-kbd-i2c.c to
not use ir-functions.c

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/video/ir-kbd-i2c.c |   14 ++++----------
 include/media/ir-kbd-i2c.h       |    2 +-
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 29d4397..27ae8bb 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -47,7 +47,7 @@
 #include <linux/i2c-id.h>
 #include <linux/workqueue.h>
 
-#include <media/ir-common.h>
+#include <media/ir-core.h>
 #include <media/ir-kbd-i2c.h>
 
 /* ----------------------------------------------------------------------- */
@@ -272,11 +272,8 @@ static void ir_key_poll(struct IR_i2c *ir)
 		return;
 	}
 
-	if (0 == rc) {
-		ir_input_nokey(ir->input, &ir->ir);
-	} else {
-		ir_input_keydown(ir->input, &ir->ir, ir_key);
-	}
+	if (rc)
+		ir_keydown(ir->input, ir_key, 0);
 }
 
 static void ir_work(struct work_struct *work)
@@ -439,10 +436,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		 dev_name(&client->dev));
 
 	/* init + register input device */
-	err = ir_input_init(input_dev, &ir->ir, ir_type);
-	if (err < 0)
-		goto err_out_free;
-
+	ir->ir_type = ir_type;
 	input_dev->id.bustype = BUS_I2C;
 	input_dev->name       = ir->name;
 	input_dev->phys       = ir->phys;
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index 0506e45..5e96d7a 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -11,7 +11,7 @@ struct IR_i2c {
 	struct i2c_client      *c;
 	struct input_dev       *input;
 	struct ir_input_state  ir;
-
+	u64                    ir_type;
 	/* Used to avoid fast repeating */
 	unsigned char          old;
 

