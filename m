Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44791 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933419Ab2J3MQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 08:16:51 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so112185eek.19
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2012 05:16:51 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, fabio.estevam@freescale.com,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 3/4] media: mx2_camera: Remove 'buf_cleanup' callback.
Date: Tue, 30 Oct 2012 13:16:34 +0100
Message-Id: <1351599395-16833-4-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
References: <1351599395-16833-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All necessary tasks to end the streaming properly are
already implemented in mx2_stop_streaming() and nothing
remains to be done in this callback.

Furthermore, it only included debug messages so it can
be removed.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/platform/soc_camera/mx2_camera.c |   34 ------------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index bf1178c..8202cb9 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -551,39 +551,6 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
-static void mx2_videobuf_release(struct vb2_buffer *vb)
-{
-#ifdef DEBUG
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct mx2_camera_dev *pcdev = ici->priv;
-	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
-
-	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
-		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
-
-	switch (buf->state) {
-	case MX2_STATE_ACTIVE:
-		dev_info(icd->parent, "%s (active)\n", __func__);
-		break;
-	case MX2_STATE_QUEUED:
-		dev_info(icd->parent, "%s (queued)\n", __func__);
-		break;
-	default:
-		dev_info(icd->parent, "%s (unknown) %d\n", __func__,
-				buf->state);
-		break;
-	}
-#endif
-
-	/*
-	 * FIXME: implement forced termination of active buffers for mx27 and
-	 * mx27 eMMA, so that the user won't get stuck in an uninterruptible
-	 * state. This requires a specific handling for each of the these DMA
-	 * types.
-	 */
-}
-
 static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
 		int bytesperline)
 {
@@ -814,7 +781,6 @@ static struct vb2_ops mx2_videobuf_ops = {
 	.queue_setup	 = mx2_videobuf_setup,
 	.buf_prepare	 = mx2_videobuf_prepare,
 	.buf_queue	 = mx2_videobuf_queue,
-	.buf_cleanup	 = mx2_videobuf_release,
 	.start_streaming = mx2_start_streaming,
 	.stop_streaming	 = mx2_stop_streaming,
 };
-- 
1.7.9.5

