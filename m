Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933410Ab0DHThi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Apr 2010 15:37:38 -0400
Date: Thu, 8 Apr 2010 16:37:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/8] V4L/DVB: em28xx: fix a regression caused by the rc-map
 changes
Message-ID: <20100408163717.4042660e@pedra>
In-Reply-To: <cover.1270754989.git.mchehab@redhat.com>
References: <cover.1270754989.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch that adds the rc-map changes didn't take into account that an
a table with IR_TYPE_UNKNOWN would make change_protocol to return -EINVAL.

As this function is fundamental to initialize some data, including a
callback to the getkey function, this caused the driver to stop working,
hanging the machine most of the times.

The fix were simply to add a handler for the IR type, but, to avoid further
issues, explicitly call change_protocol and handle the error before
initializing the IR. Also, let input_dev to start/stop IR handling,
after the opening of the input device.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index 3200f48..dffd026 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -361,14 +361,20 @@ static void em28xx_ir_work(struct work_struct *work)
 	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 }
 
-static void em28xx_ir_start(struct em28xx_IR *ir)
+static int em28xx_ir_start(void *priv)
 {
+	struct em28xx_IR *ir = priv;
+
 	INIT_DELAYED_WORK(&ir->work, em28xx_ir_work);
 	schedule_delayed_work(&ir->work, 0);
+
+	return 0;
 }
 
-static void em28xx_ir_stop(struct em28xx_IR *ir)
+static void em28xx_ir_stop(void *priv)
 {
+	struct em28xx_IR *ir = priv;
+
 	cancel_delayed_work_sync(&ir->work);
 }
 
@@ -388,7 +394,7 @@ int em28xx_ir_change_protocol(void *priv, u64 ir_type)
 		dev->board.xclk &= ~EM28XX_XCLK_IR_RC5_MODE;
 		ir_config = EM2874_IR_NEC;
 		ir->full_code = 1;
-	} else
+	} else if (ir_type != IR_TYPE_UNKNOWN)
 		rc = -EINVAL;
 
 	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
@@ -441,6 +447,13 @@ int em28xx_ir_init(struct em28xx *dev)
 	ir->props.allowed_protos = IR_TYPE_RC5 | IR_TYPE_NEC;
 	ir->props.priv = ir;
 	ir->props.change_protocol = em28xx_ir_change_protocol;
+	ir->props.open = em28xx_ir_start;
+	ir->props.close = em28xx_ir_stop;
+
+	/* By default, keep protocol field untouched */
+	err = em28xx_ir_change_protocol(ir, IR_TYPE_UNKNOWN);
+	if (err)
+		goto err_out_free;
 
 	/* This is how often we ask the chip for IR information */
 	ir->polling = 100; /* ms */
@@ -467,7 +480,6 @@ int em28xx_ir_init(struct em28xx *dev)
 	input_dev->dev.parent = &dev->udev->dev;
 
 
-	em28xx_ir_start(ir);
 
 	/* all done */
 	err = ir_input_register(ir->input, dev->board.ir_codes,
@@ -477,7 +489,6 @@ int em28xx_ir_init(struct em28xx *dev)
 
 	return 0;
  err_out_stop:
-	em28xx_ir_stop(ir);
 	dev->ir = NULL;
  err_out_free:
 	kfree(ir);
-- 
1.6.6.1


