Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:52201 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaLROtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 09:49:49 -0500
Message-ID: <1418914186.22813.16.camel@xylophone.i.decadent.org.uk>
Subject: [RFC PATCH 3/5] media: rcar_vin: Fix race condition terminating
 stream
From: Ben Hutchings <ben.hutchings@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 18 Dec 2014 14:49:46 +0000
In-Reply-To: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ian Molton <ian.molton@codethink.co.uk>

This patch fixes a race condition whereby a frame being captured may generate an
 interrupt between requesting capture to halt and freeing buffers.

This condition is exposed by the earlier patch that explicitly calls
vb2_buffer_done() during stop streaming.

The solution is to wait for capture to finish prior to finalising these buffers.

Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |   43 +++++++++++++++++---------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 7069176..b234e57 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -458,6 +458,29 @@ error:
 	vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 }
 
+/*
+ * Wait for capture to stop and all in-flight buffers to be finished with by
+ * the video hardware. This must be called under &priv->lock
+ *
+ */
+static void rcar_vin_wait_stop_streaming(struct rcar_vin_priv *priv)
+{
+	while (priv->state != STOPPED) {
+
+		/* issue stop if running */
+		if (priv->state == RUNNING)
+			rcar_vin_request_capture_stop(priv);
+
+		/* wait until capturing has been stopped */
+		if (priv->state == STOPPING) {
+			priv->request_to_stop = true;
+			spin_unlock_irq(&priv->lock);
+			wait_for_completion(&priv->capture_stop);
+			spin_lock_irq(&priv->lock);
+		}
+	}
+}
+
 static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
 {
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
@@ -465,7 +488,6 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
 	struct rcar_vin_priv *priv = ici->priv;
 	unsigned int i;
 	int buf_in_use = 0;
-
 	spin_lock_irq(&priv->lock);
 
 	/* Is the buffer in use by the VIN hardware? */
@@ -477,20 +499,8 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
 	}
 
 	if (buf_in_use) {
-		while (priv->state != STOPPED) {
-
-			/* issue stop if running */
-			if (priv->state == RUNNING)
-				rcar_vin_request_capture_stop(priv);
-
-			/* wait until capturing has been stopped */
-			if (priv->state == STOPPING) {
-				priv->request_to_stop = true;
-				spin_unlock_irq(&priv->lock);
-				wait_for_completion(&priv->capture_stop);
-				spin_lock_irq(&priv->lock);
-			}
-		}
+		rcar_vin_wait_stop_streaming(priv);
+
 		/*
 		 * Capturing has now stopped. The buffer we have been asked
 		 * to release could be any of the current buffers in use, so
@@ -520,12 +530,15 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
 
 	spin_lock_irq(&priv->lock);
 
+	rcar_vin_wait_stop_streaming(priv);
+
 	for (i = 0; i < vq->num_buffers; ++i)
 		if (vq->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
 			vb2_buffer_done(vq->bufs[i], VB2_BUF_STATE_ERROR);
 
 	list_for_each_safe(buf_head, tmp, &priv->capture)
 		list_del_init(buf_head);
+
 	spin_unlock_irq(&priv->lock);
 }
 
-- 
1.7.10.4




