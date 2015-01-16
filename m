Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:50009 "EHLO
	xk120" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754879AbbAPQXF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 11:23:05 -0500
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/2] media: rcar_vin: move buffer management to .stop_streaming handler
Date: Fri, 16 Jan 2015 16:22:59 +0000
Message-Id: <1421425379-1858-3-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1421425379-1858-1-git-send-email-william.towle@codethink.co.uk>
References: <1421425379-1858-1-git-send-email-william.towle@codethink.co.uk>
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

Signed-off-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |   47 +++++++++-----------------
 1 file changed, 16 insertions(+), 31 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 89c409b..022fa9d 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -485,37 +485,10 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
-	unsigned int i;
-	int buf_in_use = 0;
 
 	spin_lock_irq(&priv->lock);
 
-	/* Is the buffer in use by the VIN hardware? */
-	for (i = 0; i < MAX_BUFFER_NUM; i++) {
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
-					VB2_BUF_STATE_ERROR);
-				priv->queue_buf[i] = NULL;
-			}
-		}
-	} else {
-		list_del_init(to_buf_list(vb));
-	}
+	list_del_init(to_buf_list(vb));
 
 	spin_unlock_irq(&priv->lock);
 }
@@ -532,13 +505,25 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
 	struct list_head *buf_head, *tmp;
+	int i;
 
 	spin_lock_irq(&priv->lock);
-
 	rcar_vin_wait_stop_streaming(priv);
-	list_for_each_safe(buf_head, tmp, &priv->capture)
-		list_del_init(buf_head);
 
+	for (i = 0; i < MAX_BUFFER_NUM; i++) {
+		if (priv->queue_buf[i]) {
+			vb2_buffer_done(priv->queue_buf[i],
+					VB2_BUF_STATE_ERROR);
+			priv->queue_buf[i] = NULL;
+		}
+	}
+
+	list_for_each_safe(buf_head, tmp, &priv->capture) {
+		vb2_buffer_done(&list_entry(buf_head,
+					struct rcar_vin_buffer, list)->vb,
+				VB2_BUF_STATE_ERROR);
+		list_del_init(buf_head);
+	}
 	spin_unlock_irq(&priv->lock);
 }
 
-- 
1.7.10.4

