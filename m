Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:61774 "EHLO
	xk120" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753044AbbAPPdT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 10:33:19 -0500
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Subject: [PATCH 1/2] media: rcar_vin: Fix race condition terminating stream
Date: Fri, 16 Jan 2015 15:14:26 +0000
Message-Id: <1421421267-886-2-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ian Molton <ian.molton@codethink.co.uk>

The potential for a race condition exists where frame capture may
generate an interrupt between requesting the capture process halt
and freeing buffers.

Introduce rcar_vin_wait_stop_streaming() and call it in appropriate
places so we ensure capturing has finished where this is critical.

Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |   41 +++++++++++++++++---------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 8d8438b..89c409b 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -458,6 +458,28 @@ error:
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
@@ -524,8 +534,11 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
 	struct list_head *buf_head, *tmp;
 
 	spin_lock_irq(&priv->lock);
+
+	rcar_vin_wait_stop_streaming(priv);
 	list_for_each_safe(buf_head, tmp, &priv->capture)
 		list_del_init(buf_head);
+
 	spin_unlock_irq(&priv->lock);
 }
 
-- 
1.7.10.4

