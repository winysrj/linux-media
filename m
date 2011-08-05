Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:59559 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1HEVj0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 17:39:26 -0400
Date: Fri, 5 Aug 2011 23:39:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/6 v5] V4L: sh-mobile-ceu-camera: prepare to support multi-size
 buffers
In-Reply-To: <Pine.LNX.4.64.1108050933020.26715@axis700.grange>
Message-ID: <Pine.LNX.4.64.1108052337141.26715@axis700.grange>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
 <Pine.LNX.4.64.1108050933020.26715@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare the sh_mobile_ceu_camera friver to support the new
VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF ioctl()s. The .queue_setup()
vb2 operation must be able to handle buffer sizes, provided by the
caller, and the .buf_prepare() operation must not use the currently
configured frame format for its operation.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v5: fix error handling in .buf_queue(), correct buffer accounting.

 drivers/media/video/sh_mobile_ceu_camera.c |  116 +++++++++++++++++-----------
 1 files changed, 71 insertions(+), 45 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 583d771..6a39f9b 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -90,7 +90,6 @@
 struct sh_mobile_ceu_buffer {
 	struct vb2_buffer vb; /* v4l buffer must be first */
 	struct list_head queue;
-	enum v4l2_mbus_pixelcode code;
 };
 
 struct sh_mobile_ceu_dev {
@@ -100,7 +99,8 @@ struct sh_mobile_ceu_dev {
 
 	unsigned int irq;
 	void __iomem *base;
-	unsigned long video_limit;
+	size_t video_limit;
+	size_t buf_total;
 
 	spinlock_t lock;		/* Protects video buffer lists */
 	struct list_head capture;
@@ -192,6 +192,12 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
 /*
  *  Videobuf operations
  */
+
+/*
+ * .queue_setup() is called to check, whether the driver can accept the
+ *		  requested number of buffers and to fill in plane sizes
+ *		  for the current frame format if required
+ */
 static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned int sizes[], void *alloc_ctxs[])
@@ -199,25 +205,34 @@ static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 	struct soc_camera_device *icd = container_of(vq, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
+	size_t size;
+
+	if (!sizes[0] || !*num_planes) {
+		/* Called from VIDIOC_REQBUFS or in compatibility mode */
+		int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
 						icd->current_fmt->host_fmt);
+		if (bytes_per_line < 0)
+			return bytes_per_line;
 
-	if (bytes_per_line < 0)
-		return bytes_per_line;
+		sizes[0] = bytes_per_line * icd->user_height;
 
-	*num_planes = 1;
+		*num_planes = 1;
+	}
 
-	pcdev->sequence = 0;
-	sizes[0] = bytes_per_line * icd->user_height;
 	alloc_ctxs[0] = pcdev->alloc_ctx;
 
+	if (!vq->num_buffers)
+		pcdev->sequence = 0;
+
 	if (!*count)
 		*count = 2;
 
-	if (pcdev->video_limit) {
-		if (PAGE_ALIGN(sizes[0]) * *count > pcdev->video_limit)
-			*count = pcdev->video_limit / PAGE_ALIGN(sizes[0]);
-	}
+	size = PAGE_ALIGN(sizes[0]) * *count;
+
+	if (pcdev->video_limit &&
+	    size + pcdev->buf_total > pcdev->video_limit)
+		*count = (pcdev->video_limit - pcdev->buf_total) /
+			PAGE_ALIGN(sizes[0]);
 
 	dev_dbg(icd->parent, "count=%d, size=%u\n", *count, sizes[0]);
 
@@ -330,23 +345,40 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 
 static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 {
+	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
+
+	/* Added list head initialization on alloc */
+	WARN(!list_empty(&buf->queue), "Buffer %p on queue!\n", vb);
+
+	return 0;
+}
+
+static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
+{
 	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
-	struct sh_mobile_ceu_buffer *buf;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
+	unsigned long size;
 	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
 						icd->current_fmt->host_fmt);
-	unsigned long size;
 
 	if (bytes_per_line < 0)
-		return bytes_per_line;
+		goto error;
+
+	size = icd->user_height * bytes_per_line;
 
-	buf = to_ceu_vb(vb);
+	if (vb2_plane_size(vb, 0) < size) {
+		dev_err(icd->parent, "Buffer #%d too small (%lu < %lu)\n",
+			vb->v4l2_buf.index, vb2_plane_size(vb, 0), size);
+		goto error;
+	}
+
+	vb2_set_plane_payload(vb, 0, size);
 
 	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
 		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
 
-	/* Added list head initialization on alloc */
-	WARN(!list_empty(&buf->queue), "Buffer %p on queue!\n", vb);
-
 #ifdef DEBUG
 	/*
 	 * This can be useful if you want to see if we actually fill
@@ -356,31 +388,6 @@ static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 		memset(vb2_plane_vaddr(vb, 0), 0xaa, vb2_get_plane_payload(vb, 0));
 #endif
 
-	BUG_ON(NULL == icd->current_fmt);
-
-	size = icd->user_height * bytes_per_line;
-
-	if (vb2_plane_size(vb, 0) < size) {
-		dev_err(icd->parent, "Buffer too small (%lu < %lu)\n",
-			vb2_plane_size(vb, 0), size);
-		return -ENOBUFS;
-	}
-
-	vb2_set_plane_payload(vb, 0, size);
-
-	return 0;
-}
-
-static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
-{
-	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
-
-	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
-		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
-
 	spin_lock_irq(&pcdev->lock);
 	list_add_tail(&buf->queue, &pcdev->capture);
 
@@ -394,6 +401,11 @@ static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 		sh_mobile_ceu_capture(pcdev);
 	}
 	spin_unlock_irq(&pcdev->lock);
+
+	return;
+
+error:
+	vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 }
 
 static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
@@ -418,11 +430,23 @@ static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 	if (buf->queue.next)
 		list_del_init(&buf->queue);
 
+	pcdev->buf_total -= PAGE_ALIGN(vb2_plane_size(vb, 0));
+	dev_dbg(icd->parent, "%s() %zu bytes buffers\n", __func__,
+		pcdev->buf_total);
+
 	spin_unlock_irq(&pcdev->lock);
 }
 
 static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb, u32 fourcc)
 {
+	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+
+	pcdev->buf_total += PAGE_ALIGN(vb2_plane_size(vb, 0));
+	dev_dbg(icd->parent, "%s() %zu bytes buffers\n", __func__,
+		pcdev->buf_total);
+
 	/* This is for locking debugging only */
 	INIT_LIST_HEAD(&to_ceu_vb(vb)->queue);
 	return 0;
@@ -524,6 +548,8 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 
 	pm_runtime_get_sync(ici->v4l2_dev.dev);
 
+	pcdev->buf_total = 0;
+
 	ret = sh_mobile_ceu_soft_reset(pcdev);
 
 	csi2_sd = find_csi2(pcdev);
@@ -1670,7 +1696,7 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 		image_mode = false;
 	}
 
-	dev_info(dev, "S_FMT(pix=0x%x, fld 0x%x, code 0x%x, %ux%u)\n", pixfmt, mf.field, mf.code,
+	dev_geo(dev, "S_FMT(pix=0x%x, fld 0x%x, code 0x%x, %ux%u)\n", pixfmt, mf.field, mf.code,
 		pix->width, pix->height);
 
 	dev_geo(dev, "4: request camera output %ux%u\n", mf.width, mf.height);
-- 
1.7.2.5

