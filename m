Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:37476 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753833AbaGHJlh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 05:41:37 -0400
From: Ian Molton <ian.molton@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: linux-kernel@lists.codethink.co.uk, ian.molton@codethink.co.uk,
	g.liakhovetski@gmx.de, m.chehab@samsung.com,
	vladimir.barinov@cogentembedded.com, magnus.damm@gmail.com,
	horms@verge.net.au, linux-sh@vger.kernel.org
Subject: [PATCH 4/4] media: rcar_vin: Clean up rcar_vin_irq
Date: Tue,  8 Jul 2014 10:41:14 +0100
Message-Id: <1404812474-7627-5-git-send-email-ian.molton@codethink.co.uk>
In-Reply-To: <1404812474-7627-1-git-send-email-ian.molton@codethink.co.uk>
References: <1404812474-7627-1-git-send-email-ian.molton@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch makes the rcar_vin IRQ handler a little more readable.

Removes an else clause, and simplifies the buffer handling.

Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
Reviewed-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index aeda4e2..a8d2785 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -554,7 +554,6 @@ static irqreturn_t rcar_vin_irq(int irq, void *data)
 	struct rcar_vin_priv *priv = data;
 	u32 int_status;
 	bool can_run = false, hw_stopped;
-	int slot;
 	unsigned int handled = 0;
 
 	spin_lock(&priv->lock);
@@ -573,17 +572,22 @@ static irqreturn_t rcar_vin_irq(int irq, void *data)
 	hw_stopped = !(ioread32(priv->base + VNMS_REG) & VNMS_CA);
 
 	if (!priv->request_to_stop) {
+		struct vb2_buffer **q_entry = priv->queue_buf;
+		struct vb2_buffer *vb;
+
 		if (is_continuous_transfer(priv))
-			slot = (ioread32(priv->base + VNMS_REG) &
-				VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
-		else
-			slot = 0;
+			q_entry += (ioread32(priv->base + VNMS_REG) &
+					VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
+
+		vb = *q_entry;
+
+		vb->v4l2_buf.field = priv->field;
+		vb->v4l2_buf.sequence = priv->sequence++;
+		do_gettimeofday(&vb->v4l2_buf.timestamp);
+
+		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 
-		priv->queue_buf[slot]->v4l2_buf.field = priv->field;
-		priv->queue_buf[slot]->v4l2_buf.sequence = priv->sequence++;
-		do_gettimeofday(&priv->queue_buf[slot]->v4l2_buf.timestamp);
-		vb2_buffer_done(priv->queue_buf[slot], VB2_BUF_STATE_DONE);
-		priv->queue_buf[slot] = NULL;
+		*q_entry = NULL;
 
 		if (priv->state != STOPPING)
 			can_run = rcar_vin_fill_hw_slot(priv);
-- 
1.9.1

