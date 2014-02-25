Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2095 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaBYJs4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 04:48:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv1 PATCH 05/14] vb2: change result code of buf_finish to void
Date: Tue, 25 Feb 2014 10:48:18 +0100
Message-Id: <1393321707-9749-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393321707-9749-1-git-send-email-hverkuil@xs4all.nl>
References: <1393321707-9749-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The buf_finish op should always work, so change the return type to void.
Update the few drivers that use it. Note that buf_finish can be called
both when the DMA is streaming and when it isn't (during queue_cancel).
Update drivers to check that where appropriate.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pawel Osciak <pawel@osciak.com>
Reviewed-by: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/parport/bw-qcam.c                 |  6 ++++--
 drivers/media/pci/sta2x11/sta2x11_vip.c         |  7 +++----
 drivers/media/platform/marvell-ccic/mcam-core.c |  3 +--
 drivers/media/usb/pwc/pwc-if.c                  | 16 +++++++++-------
 drivers/media/usb/uvc/uvc_queue.c               |  6 +++---
 drivers/media/v4l2-core/videobuf2-core.c        |  6 +-----
 drivers/staging/media/go7007/go7007-v4l2.c      |  3 +--
 include/media/videobuf2-core.h                  |  2 +-
 8 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/media/parport/bw-qcam.c b/drivers/media/parport/bw-qcam.c
index d12bd33..8d69bfb 100644
--- a/drivers/media/parport/bw-qcam.c
+++ b/drivers/media/parport/bw-qcam.c
@@ -667,13 +667,16 @@ static void buffer_queue(struct vb2_buffer *vb)
 	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 }
 
-static int buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish(struct vb2_buffer *vb)
 {
 	struct qcam *qcam = vb2_get_drv_priv(vb->vb2_queue);
 	void *vbuf = vb2_plane_vaddr(vb, 0);
 	int size = vb->vb2_queue->plane_sizes[0];
 	int len;
 
+	if (!vb2_is_streaming(vb->vb2_queue))
+		return;
+
 	mutex_lock(&qcam->lock);
 	parport_claim_or_block(qcam->pdev);
 
@@ -691,7 +694,6 @@ static int buffer_finish(struct vb2_buffer *vb)
 	if (len != size)
 		vb->state = VB2_BUF_STATE_ERROR;
 	vb2_set_plane_payload(vb, 0, len);
-	return 0;
 }
 
 static struct vb2_ops qcam_video_qops = {
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index e5cfb6c..bb11443 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -327,7 +327,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	}
 	spin_unlock(&vip->lock);
 }
-static int buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish(struct vb2_buffer *vb)
 {
 	struct sta2x11_vip *vip = vb2_get_drv_priv(vb->vb2_queue);
 	struct vip_buffer *vip_buf = to_vip_buffer(vb);
@@ -337,9 +337,8 @@ static int buffer_finish(struct vb2_buffer *vb)
 	list_del_init(&vip_buf->list);
 	spin_unlock(&vip->lock);
 
-	vip_active_buf_next(vip);
-
-	return 0;
+	if (vb2_is_streaming(vb->vb2_queue))
+		vip_active_buf_next(vip);
 }
 
 static int start_streaming(struct vb2_queue *vq, unsigned int count)
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 32fab30..8b34c48 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1238,7 +1238,7 @@ static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int mcam_vb_sg_buf_finish(struct vb2_buffer *vb)
+static void mcam_vb_sg_buf_finish(struct vb2_buffer *vb)
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
 	struct sg_table *sg_table = vb2_dma_sg_plane_desc(vb, 0);
@@ -1246,7 +1246,6 @@ static int mcam_vb_sg_buf_finish(struct vb2_buffer *vb)
 	if (sg_table)
 		dma_unmap_sg(cam->dev, sg_table->sgl,
 				sg_table->nents, DMA_FROM_DEVICE);
-	return 0;
 }
 
 static void mcam_vb_sg_buf_cleanup(struct vb2_buffer *vb)
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index abf365a..b9c9f10 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -614,17 +614,19 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int buffer_finish(struct vb2_buffer *vb)
+static void buffer_finish(struct vb2_buffer *vb)
 {
 	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
 	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
 
-	/*
-	 * Application has called dqbuf and is getting back a buffer we've
-	 * filled, take the pwc data we've stored in buf->data and decompress
-	 * it into a usable format, storing the result in the vb2_buffer
-	 */
-	return pwc_decompress(pdev, buf);
+	if (vb->state == VB2_BUF_STATE_DONE) {
+		/*
+		 * Application has called dqbuf and is getting back a buffer we've
+		 * filled, take the pwc data we've stored in buf->data and decompress
+		 * it into a usable format, storing the result in the vb2_buffer
+		 */
+		pwc_decompress(pdev, buf);
+	}
 }
 
 static void buffer_cleanup(struct vb2_buffer *vb)
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index cd962be..db5984e 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -104,15 +104,15 @@ static void uvc_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 }
 
-static int uvc_buffer_finish(struct vb2_buffer *vb)
+static void uvc_buffer_finish(struct vb2_buffer *vb)
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
 	struct uvc_streaming *stream =
 			container_of(queue, struct uvc_streaming, queue);
 	struct uvc_buffer *buf = container_of(vb, struct uvc_buffer, buf);
 
-	uvc_video_clock_update(stream, &vb->v4l2_buf, buf);
-	return 0;
+	if (vb2_is_streaming(vb->vb2_queue))
+		uvc_video_clock_update(stream, &vb->v4l2_buf, buf);
 }
 
 static void uvc_wait_prepare(struct vb2_queue *vq)
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 8f1578b..59bfd85 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1783,11 +1783,7 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool n
 	if (ret < 0)
 		return ret;
 
-	ret = call_vb_qop(vb, buf_finish, vb);
-	if (ret) {
-		dprintk(1, "dqbuf: buffer finish failed\n");
-		return ret;
-	}
+	call_vb_qop(vb, buf_finish, vb);
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_DONE:
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index edc52e2..3a01576 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -470,7 +470,7 @@ static int go7007_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static int go7007_buf_finish(struct vb2_buffer *vb)
+static void go7007_buf_finish(struct vb2_buffer *vb)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct go7007 *go = vb2_get_drv_priv(vq);
@@ -483,7 +483,6 @@ static int go7007_buf_finish(struct vb2_buffer *vb)
 			V4L2_BUF_FLAG_PFRAME);
 	buf->flags |= frame_type_flag;
 	buf->field = V4L2_FIELD_NONE;
-	return 0;
 }
 
 static int go7007_start_streaming(struct vb2_queue *q, unsigned int count)
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index f04eb28..f443ce0 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -311,7 +311,7 @@ struct vb2_ops {
 
 	int (*buf_init)(struct vb2_buffer *vb);
 	int (*buf_prepare)(struct vb2_buffer *vb);
-	int (*buf_finish)(struct vb2_buffer *vb);
+	void (*buf_finish)(struct vb2_buffer *vb);
 	void (*buf_cleanup)(struct vb2_buffer *vb);
 
 	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
-- 
1.9.0

