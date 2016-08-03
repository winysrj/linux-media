Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33616 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbcHCSEI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 14:04:08 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v4 8/8] media: adv7180: enable lock/unlock interrupts
Date: Wed,  3 Aug 2016 11:03:50 -0700
Message-Id: <1470247430-11168-9-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable the SD lock/unlock interrupts and send V4L2_EVENT_SRC_CH_LOCK_STATUS
in the interrupt handler on a detected lock/unlock.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

---

v4: no changes
v3: no changes

v2:
- last version of this patch was based on the old reverted autodetect
  code. This version now only enables the interrupt and sends the
  event in the interrupt handler.
---
 drivers/media/i2c/adv7180.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index abdc519..d017b05 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -874,19 +874,29 @@ static const struct v4l2_subdev_ops adv7180_ops = {
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
 	}
 	mutex_unlock(&state->mutex);
@@ -1287,7 +1297,9 @@ static int init_device(struct adv7180_state *state)
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

