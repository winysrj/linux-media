Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-096.synserver.de ([212.40.185.96]:1098 "EHLO
	smtp-out-014.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751578AbaCGQOJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Mar 2014 11:14:09 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 5/7] [media] adv7180: Use threaded IRQ instead of IRQ + workqueue
Date: Fri,  7 Mar 2014 17:14:31 +0100
Message-Id: <1394208873-23260-5-git-send-email-lars@metafoo.de>
In-Reply-To: <1394208873-23260-1-git-send-email-lars@metafoo.de>
References: <1394208873-23260-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The proper way to handle IRQs that need to be able to sleep in their IRQ handler
is to use a threaded IRQ.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 98a3ff1..c750aae 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -123,7 +123,6 @@
 struct adv7180_state {
 	struct v4l2_ctrl_handler ctrl_hdl;
 	struct v4l2_subdev	sd;
-	struct work_struct	work;
 	struct mutex		mutex; /* mutual excl. when accessing chip */
 	int			irq;
 	v4l2_std_id		curr_norm;
@@ -449,10 +448,9 @@ static const struct v4l2_subdev_ops adv7180_ops = {
 	.video = &adv7180_video_ops,
 };
 
-static void adv7180_work(struct work_struct *work)
+static irqreturn_t adv7180_irq(int irq, void *devid)
 {
-	struct adv7180_state *state = container_of(work, struct adv7180_state,
-						   work);
+	struct adv7180_state *state = devid;
 	struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
 	u8 isr3;
 
@@ -468,17 +466,6 @@ static void adv7180_work(struct work_struct *work)
 		__adv7180_status(client, NULL, &state->curr_norm);
 	mutex_unlock(&state->mutex);
 
-	enable_irq(state->irq);
-}
-
-static irqreturn_t adv7180_irq(int irq, void *devid)
-{
-	struct adv7180_state *state = devid;
-
-	schedule_work(&state->work);
-
-	disable_irq_nosync(state->irq);
-
 	return IRQ_HANDLED;
 }
 
@@ -533,8 +520,8 @@ static int init_device(struct i2c_client *client, struct adv7180_state *state)
 
 	/* register for interrupts */
 	if (state->irq > 0) {
-		ret = request_irq(state->irq, adv7180_irq, 0, KBUILD_MODNAME,
-				  state);
+		ret = request_threaded_irq(state->irq, NULL, adv7180_irq,
+					   IRQF_ONESHOT, KBUILD_MODNAME, state);
 		if (ret)
 			return ret;
 
@@ -598,7 +585,6 @@ static int adv7180_probe(struct i2c_client *client,
 	}
 
 	state->irq = client->irq;
-	INIT_WORK(&state->work, adv7180_work);
 	mutex_init(&state->mutex);
 	state->autodetect = true;
 	state->input = 0;
@@ -626,17 +612,8 @@ static int adv7180_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct adv7180_state *state = to_state(sd);
 
-	if (state->irq > 0) {
+	if (state->irq > 0)
 		free_irq(client->irq, state);
-		if (cancel_work_sync(&state->work)) {
-			/*
-			 * Work was pending, therefore we need to enable
-			 * IRQ here to balance the disable_irq() done in the
-			 * interrupt handler.
-			 */
-			enable_irq(state->irq);
-		}
-	}
 
 	v4l2_device_unregister_subdev(sd);
 	adv7180_exit_controls(state);
-- 
1.8.0

