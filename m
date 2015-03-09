Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:59117 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572AbbCIVYS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:24:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 13/18] marvell-ccic: correctly requeue buffers
Date: Mon,  9 Mar 2015 22:22:18 +0100
Message-Id: <1425936143-5658-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If start_streaming fails or stop_streaming is called, then all queued
buffers need to be given back to vb2.

This prevents vb2 from calling WARN_ON when it detects that this is not
done correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 39 ++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 6b7b38b..0d94696 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -607,6 +607,7 @@ static void mcam_dma_contig_done(struct mcam_camera *cam, int frame)
 
 	if (!test_bit(CF_SINGLE_BUFFER, &cam->flags)) {
 		cam->frame_state.delivered++;
+		cam->vb_bufs[frame] = NULL;
 		mcam_buffer_done(cam, frame, &buf->vb_buf);
 	}
 	mcam_set_contig_buffer(cam, frame);
@@ -1106,6 +1107,30 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 		mcam_read_setup(cam);
 }
 
+static void mcam_vb_requeue_bufs(struct vb2_queue *vq,
+				 enum vb2_buffer_state state)
+{
+	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	struct mcam_vb_buffer *buf, *node;
+	unsigned long flags;
+	unsigned i;
+
+	spin_lock_irqsave(&cam->dev_lock, flags);
+	list_for_each_entry_safe(buf, node, &cam->buffers, queue) {
+		vb2_buffer_done(&buf->vb_buf, state);
+		list_del(&buf->queue);
+	}
+	for (i = 0; i < MAX_DMA_BUFS; i++) {
+		buf = cam->vb_bufs[i];
+
+		if (buf) {
+			vb2_buffer_done(&buf->vb_buf, state);
+			cam->vb_bufs[i] = NULL;
+		}
+	}
+	spin_unlock_irqrestore(&cam->dev_lock, flags);
+}
+
 /*
  * These need to be called with the mutex held from vb2
  */
@@ -1113,9 +1138,10 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
 	unsigned int frame;
+	int ret;
 
 	if (cam->state != S_IDLE) {
-		INIT_LIST_HEAD(&cam->buffers);
+		mcam_vb_requeue_bufs(vq, VB2_BUF_STATE_QUEUED);
 		return -EINVAL;
 	}
 	cam->frame_state.frames = 0;
@@ -1141,13 +1167,15 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 	for (frame = 0; frame < cam->nbufs; frame++)
 		clear_bit(CF_FRAME_SOF0 + frame, &cam->flags);
 
-	return mcam_read_setup(cam);
+	ret = mcam_read_setup(cam);
+	if (ret)
+		mcam_vb_requeue_bufs(vq, VB2_BUF_STATE_QUEUED);
+	return ret;
 }
 
 static void mcam_vb_stop_streaming(struct vb2_queue *vq)
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
-	unsigned long flags;
 
 	cam_dbg(cam, "stop_streaming: %d frames, %d singles, %d delivered\n",
 			cam->frame_state.frames, cam->frame_state.singles,
@@ -1170,9 +1198,7 @@ static void mcam_vb_stop_streaming(struct vb2_queue *vq)
 	 * VB2 reclaims the buffers, so we need to forget
 	 * about them.
 	 */
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	INIT_LIST_HEAD(&cam->buffers);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
+	mcam_vb_requeue_bufs(vq, VB2_BUF_STATE_ERROR);
 }
 
 
@@ -1786,7 +1812,6 @@ int mccic_register(struct mcam_camera *cam)
 	mcam_set_config_needed(cam, 1);
 	cam->pix_format = mcam_def_pix_format;
 	cam->mbus_code = mcam_def_mbus_code;
-	INIT_LIST_HEAD(&cam->buffers);
 	mcam_ctlr_init(cam);
 
 	/*
-- 
2.1.4

