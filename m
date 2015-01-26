Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:54278 "EHLO
	xk120" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753100AbbAZRIq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 12:08:46 -0500
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/2] media: rcar_vin: move buffer management to .stop_streaming handler
Date: Mon, 26 Jan 2015 17:08:40 +0000
Message-Id: <1422292120-30496-3-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1422292120-30496-1-git-send-email-william.towle@codethink.co.uk>
References: <1422292120-30496-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit moves the "buffer in use" logic from the .buf_cleanup
handler into .stop_streaming, based on advice that this is its
proper logical home.

By ensuring the list of pointers in priv->queue_buf[] is managed
as soon as possible, we avoid warnings concerning buffers in ACTIVE
state when the system cleans up after streaming stops. This fixes a
problem with modification of buffers after their content has been
cleared for passing to userspace.

After the refactoring, the buf_init and buf_cleanup functions were
found to contain only initialisation/release steps as are carried out
elsewhere if omitted; these functions and references were removed.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |   62 ++++++--------------------
 1 file changed, 13 insertions(+), 49 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 89c409b..aa25a3b 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -480,72 +480,36 @@ static void rcar_vin_wait_stop_streaming(struct rcar_vin_priv *priv)
 	}
 }
 
-static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
+static void rcar_vin_stop_streaming(struct vb2_queue *vq)
 {
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
-	unsigned int i;
-	int buf_in_use = 0;
+	struct list_head *buf_head, *tmp;
+	int i;
 
 	spin_lock_irq(&priv->lock);
+	rcar_vin_wait_stop_streaming(priv);
 
-	/* Is the buffer in use by the VIN hardware? */
 	for (i = 0; i < MAX_BUFFER_NUM; i++) {
-		if (priv->queue_buf[i] == vb) {
-			buf_in_use = 1;
-			break;
-		}
-	}
-
-	if (buf_in_use) {
-		rcar_vin_wait_stop_streaming(priv);
-
-		/*
-		 * Capturing has now stopped. The buffer we have been asked
-		 * to release could be any of the current buffers in use, so
-		 * release all buffers that are in use by HW
-		 */
-		for (i = 0; i < MAX_BUFFER_NUM; i++) {
-			if (priv->queue_buf[i]) {
-				vb2_buffer_done(priv->queue_buf[i],
+		if (priv->queue_buf[i]) {
+			vb2_buffer_done(priv->queue_buf[i],
 					VB2_BUF_STATE_ERROR);
-				priv->queue_buf[i] = NULL;
-			}
+			priv->queue_buf[i] = NULL;
 		}
-	} else {
-		list_del_init(to_buf_list(vb));
 	}
 
-	spin_unlock_irq(&priv->lock);
-}
-
-static int rcar_vin_videobuf_init(struct vb2_buffer *vb)
-{
-	INIT_LIST_HEAD(to_buf_list(vb));
-	return 0;
-}
-
-static void rcar_vin_stop_streaming(struct vb2_queue *vq)
-{
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct rcar_vin_priv *priv = ici->priv;
-	struct list_head *buf_head, *tmp;
-
-	spin_lock_irq(&priv->lock);
-
-	rcar_vin_wait_stop_streaming(priv);
-	list_for_each_safe(buf_head, tmp, &priv->capture)
+	list_for_each_safe(buf_head, tmp, &priv->capture) {
+		vb2_buffer_done(&list_entry(buf_head,
+					struct rcar_vin_buffer, list)->vb,
+				VB2_BUF_STATE_ERROR);
 		list_del_init(buf_head);
-
+	}
 	spin_unlock_irq(&priv->lock);
 }
 
 static struct vb2_ops rcar_vin_vb2_ops = {
 	.queue_setup	= rcar_vin_videobuf_setup,
-	.buf_init	= rcar_vin_videobuf_init,
-	.buf_cleanup	= rcar_vin_videobuf_release,
 	.buf_queue	= rcar_vin_videobuf_queue,
 	.stop_streaming	= rcar_vin_stop_streaming,
 	.wait_prepare	= soc_camera_unlock,
-- 
1.7.10.4

