Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:52220 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaLROt5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 09:49:57 -0500
Message-ID: <1418914193.22813.17.camel@xylophone.i.decadent.org.uk>
Subject: [RFC PATCH 4/5] media: rcar_vin: Clean up rcar_vin_irq
From: Ben Hutchings <ben.hutchings@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 18 Dec 2014 14:49:53 +0000
In-Reply-To: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ian Molton <ian.molton@codethink.co.uk>

This patch makes the rcar_vin IRQ handler a little more readable.

Removes an else clause, and simplifies the buffer handling.

Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
Reviewed-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index b234e57..20dbedf 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -557,7 +557,6 @@ static irqreturn_t rcar_vin_irq(int irq, void *data)
 	struct rcar_vin_priv *priv = data;
 	u32 int_status;
 	bool can_run = false, hw_stopped;
-	int slot;
 	unsigned int handled = 0;
 
 	spin_lock(&priv->lock);
@@ -576,17 +575,22 @@ static irqreturn_t rcar_vin_irq(int irq, void *data)
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
1.7.10.4




