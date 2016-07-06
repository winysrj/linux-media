Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35486 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbcGFXOY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:14:24 -0400
Received: by mail-pa0-f66.google.com with SMTP id dx3so104264pab.2
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:14:24 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 10/11] media: adv7180: enable lock/unlock interrupts
Date: Wed,  6 Jul 2016 16:00:03 -0700
Message-Id: <1467846004-12731-11-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable the SD lock/unlock interrupts and send V4L2_EVENT_SRC_CH_LOCK_STATUS
in the interrupt handler on a detected lock/unlock. Keep track of current
input lock status with state->curr_status.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/i2c/adv7180.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index f76a0e7..4c2623f 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -216,6 +216,7 @@ struct adv7180_state {
 	int			irq;
 	struct gpio_desc	*pwdn_gpio;
 	v4l2_std_id		curr_norm;
+	u32			curr_status; /* lock status */
 	bool			autodetect;
 	bool			bt656_4; /* use bt.656-4 standard for NTSC */
 	bool			powered;
@@ -422,7 +423,12 @@ static int adv7180_g_input_status(struct v4l2_subdev *sd, u32 *status)
 	if (ret)
 		return ret;
 
-	ret = __adv7180_status(state, status, NULL);
+	/* when we are interrupt driven we know the input lock status */
+	if (!state->autodetect || state->irq > 0)
+		*status = state->curr_status;
+	else
+		ret = __adv7180_status(state, status, NULL);
+
 	mutex_unlock(&state->mutex);
 	return ret;
 }
@@ -437,7 +443,7 @@ static int adv7180_program_std(struct adv7180_state *state)
 		if (ret < 0)
 			return ret;
 
-		__adv7180_status(state, NULL, &state->curr_norm);
+		__adv7180_status(state, &state->curr_status, &state->curr_norm);
 	} else {
 		ret = v4l2_std_to_adv7180(state->curr_norm);
 		if (ret < 0)
@@ -872,23 +878,34 @@ static const struct v4l2_subdev_ops adv7180_ops = {
 static irqreturn_t adv7180_irq(int irq, void *devid)
 {
 	struct adv7180_state *state = devid;
-	u8 isr3;
+	u8 isr1, isr3;
 
 	mutex_lock(&state->mutex);
+	isr1 = adv7180_read(state, ADV7180_REG_ISR1);
 	isr3 = adv7180_read(state, ADV7180_REG_ISR3);
 	/* clear */
+	adv7180_write(state, ADV7180_REG_ICR1, isr1);
 	adv7180_write(state, ADV7180_REG_ICR3, isr3);
 
-	if (isr3 & ADV7180_IRQ3_AD_CHANGE) {
-		static const struct v4l2_event src_ch = {
+	if ((isr3 & ADV7180_IRQ3_AD_CHANGE) ||
+	    (isr1 & (ADV7180_IRQ1_LOCK | ADV7180_IRQ1_UNLOCK))) {
+		static struct v4l2_event src_ch = {
 			.type = V4L2_EVENT_SOURCE_CHANGE,
-			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
 		};
 
+		if (isr3 & ADV7180_IRQ3_AD_CHANGE)
+			src_ch.u.src_change.changes |=
+				V4L2_EVENT_SRC_CH_RESOLUTION;
+
+		if (isr1 & (ADV7180_IRQ1_LOCK | ADV7180_IRQ1_UNLOCK))
+			src_ch.u.src_change.changes |=
+				V4L2_EVENT_SRC_CH_LOCK_STATUS;
+
 		v4l2_subdev_notify_event(&state->sd, &src_ch);
 
 		if (state->autodetect)
-			__adv7180_status(state, NULL, &state->curr_norm);
+			__adv7180_status(state, &state->curr_status,
+					 &state->curr_norm);
 	}
 
 	mutex_unlock(&state->mutex);
@@ -1335,7 +1352,9 @@ static int init_device(struct adv7180_state *state)
 		if (ret < 0)
 			goto out_unlock;
 
-		ret = adv7180_write(state, ADV7180_REG_IMR1, 0);
+		/* enable lock/unlock interrupts */
+		ret = adv7180_write(state, ADV7180_REG_IMR1,
+				    ADV7180_IRQ1_LOCK | ADV7180_IRQ1_UNLOCK);
 		if (ret < 0)
 			goto out_unlock;
 
-- 
1.9.1

