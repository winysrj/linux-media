Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:62839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab1DAINU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2011 04:13:20 -0400
Date: Fri, 1 Apr 2011 10:13:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH/RFC 4/4] V4L: sh_mobile_ceu_camera: support multi-size
 video-buffers
In-Reply-To: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
Message-ID: <Pine.LNX.4.64.1104011012210.9530@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With this patch it is possible to prequeue buffers of different sizes
in the driver and switch between them by just stopping streaming,
setting a new format, queuing the suitable buffers and re-starting the
streaming escaping the need to allocate buffers on this time-critical
path.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |  104 ++++++++++++++++++++++++----
 1 files changed, 91 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index d1446ad..3245fff 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -100,6 +100,7 @@ struct sh_mobile_ceu_dev {
 	unsigned int irq;
 	void __iomem *base;
 	unsigned long video_limit;
+	unsigned long buf_total;
 
 	spinlock_t lock;		/* Protects video buffer lists */
 	struct list_head capture;
@@ -215,38 +216,110 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
 /*
  *  Videobuf operations
  */
-static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
+
+/*
+ * .queue_add() can be called in two situations:
+ * (1)	to add a new buffer set. In this case create->count is the number of
+ *	buffers to be added, *count == 0. We have to return the number of
+ *	added buffers in *count.
+ * (2)	to try to adjust the number of buffers down. In this case create->count
+ *	is the (smaller) number of buffers, that the caller wants to have, and
+ *	*count is the number of buffers, that we actually allocated in step (1)
+ *	above. If the smaller create->count is still sufficient for us, we have
+ *	to adjust our internal configuration and return *count = create->count.
+ */
+static int sh_mobile_ceu_videobuf_add(struct vb2_queue *vq,
+			struct v4l2_create_buffers *create,
 			unsigned int *count, unsigned int *num_planes,
 			unsigned long sizes[], void *alloc_ctxs[])
 {
 	struct soc_camera_device *icd = container_of(vq, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-						icd->current_fmt->host_fmt);
+	const struct soc_camera_format_xlate *xlate = soc_camera_xlate_by_fourcc(icd,
+						create->format.fmt.pix.pixelformat);
+	const struct soc_mbus_pixelfmt *fmt;
+	int bytes_per_line;
+	ssize_t size;
+
+	if (!xlate)
+		return -ENOENT;
 
+	fmt = xlate->host_fmt;
+
+	/* fmt must be != NULL */
+	bytes_per_line = soc_mbus_bytes_per_line(create->format.fmt.pix.width, fmt);
 	if (bytes_per_line < 0)
 		return bytes_per_line;
 
+	if (create->count < 2)
+		create->count = 2;
+
 	*num_planes = 1;
 
-	pcdev->sequence = 0;
-	sizes[0] = bytes_per_line * icd->user_height;
+	if (!pcdev->buf_total)
+		pcdev->sequence = 0;
+	/* Ignore possible user-provided size, we cannot use it */
+	sizes[0] = bytes_per_line * create->format.fmt.pix.height;
 	alloc_ctxs[0] = pcdev->alloc_ctx;
 
-	if (!*count)
-		*count = 2;
+	size = PAGE_ALIGN(sizes[0]) * (create->count - *count);
+
+	if (pcdev->video_limit &&
+	    pcdev->buf_total + size > pcdev->video_limit) {
+		/* This can only be entered in case (1) in the above comment */
+		unsigned int cnt = (pcdev->video_limit - pcdev->buf_total) /
+			PAGE_ALIGN(sizes[0]);
+
+		/*
+		 * Normally *count would be 0 here, but add it anyway in case
+		 * someone decides to call this function to increase the number
+		 * of buffers from != 0
+		 */
+		if (cnt + *count < 2)
+			return -ENOBUFS;
 
-	if (pcdev->video_limit) {
-		if (PAGE_ALIGN(sizes[0]) * *count > pcdev->video_limit)
-			*count = pcdev->video_limit / PAGE_ALIGN(sizes[0]);
+		size = PAGE_ALIGN(sizes[0]) * cnt;
+		*count += cnt;
+	} else {
+		*count = create->count;
 	}
 
-	dev_dbg(icd->dev.parent, "count=%d, size=%lu\n", *count, sizes[0]);
+	pcdev->buf_total += size;
+
+	dev_dbg(icd->dev.parent, "count=%d, size=%lu, fmt=0x%x\n",
+		*count, sizes[0], fmt->fourcc);
 
 	return 0;
 }
 
+static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
+			unsigned int *count, unsigned int *num_planes,
+			unsigned long sizes[], void *alloc_ctxs[])
+{
+	struct soc_camera_device *icd = container_of(vq, struct soc_camera_device, vb2_vidq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+	struct v4l2_create_buffers create = {
+		.count = *count,
+		.format.fmt.pix = {
+			.width = icd->user_width,
+			.height = icd->user_height,
+			.pixelformat = icd->current_fmt->host_fmt->fourcc,
+		},
+	};
+
+	if (vq->num_buffers)
+		/* The core failed to allocate the required number of buffers */
+		*count = pcdev->buf_total / PAGE_ALIGN(sizes[0]);
+	else
+		*count = 0;
+
+	/* Normal allocation */
+	return sh_mobile_ceu_videobuf_add(vq, &create, count, num_planes, sizes,
+					  alloc_ctxs);
+}
+
 #define CEU_CETCR_MAGIC 0x0317f313 /* acknowledge magical interrupt sources */
 #define CEU_CETCR_IGRW (1 << 4) /* prohibited register access interrupt bit */
 #define CEU_CEIER_CPEIE (1 << 0) /* one-frame capture end interrupt */
@@ -371,8 +444,8 @@ static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 	size = icd->user_height * bytes_per_line;
 
 	if (vb2_plane_size(vb, 0) < size) {
-		dev_err(icd->dev.parent, "Buffer too small (%lu < %lu)\n",
-			vb2_plane_size(vb, 0), size);
+		dev_err(icd->dev.parent, "Buffer #%d too small (%lu < %lu)\n",
+			vb->v4l2_buf.index, vb2_plane_size(vb, 0), size);
 		return -ENOBUFS;
 	}
 
@@ -424,6 +497,8 @@ static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 	/* Doesn't hurt also if the list is empty */
 	list_del_init(&buf->queue);
 
+	pcdev->buf_total -= vb2_plane_size(vb, 0);
+
 	spin_unlock_irq(&pcdev->lock);
 }
 
@@ -455,6 +530,7 @@ static int sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
 
 static struct vb2_ops sh_mobile_ceu_videobuf_ops = {
 	.queue_setup	= sh_mobile_ceu_videobuf_setup,
+	.queue_add	= sh_mobile_ceu_videobuf_add,
 	.buf_prepare	= sh_mobile_ceu_videobuf_prepare,
 	.buf_queue	= sh_mobile_ceu_videobuf_queue,
 	.buf_cleanup	= sh_mobile_ceu_videobuf_release,
@@ -515,6 +591,8 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 
 	pm_runtime_get_sync(ici->v4l2_dev.dev);
 
+	pcdev->buf_total = 0;
+
 	ret = sh_mobile_ceu_soft_reset(pcdev);
 	if (!ret)
 		pcdev->icd = icd;
-- 
1.7.2.5

