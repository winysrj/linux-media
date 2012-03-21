Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57771 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab2CULDL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 07:03:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 2/9] soc_camera: Use soc_camera_device::sizeimage to compute buffer sizes
Date: Wed, 21 Mar 2012 12:03:21 +0100
Message-Id: <1332327808-6056-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of computing the buffer size manually in the videobuf queue
setup and buffer prepare callbacks, use the previously negotiated
soc_camera_device::sizeimage value.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/atmel-isi.c            |   17 +++--------------
 drivers/media/video/mx1_camera.c           |   14 ++------------
 drivers/media/video/mx2_camera.c           |   14 ++------------
 drivers/media/video/mx3_camera.c           |   20 +++++++++-----------
 drivers/media/video/omap1_camera.c         |   14 ++------------
 drivers/media/video/pxa_camera.c           |   14 ++------------
 drivers/media/video/sh_mobile_ceu_camera.c |   25 +++++++++----------------
 7 files changed, 29 insertions(+), 89 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index ec3f6a0..d58491b 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -260,7 +260,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 	unsigned long size;
-	int ret, bytes_per_line;
+	int ret;
 
 	/* Reset ISI */
 	ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
@@ -271,13 +271,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	/* Disable all interrupts */
 	isi_writel(isi, ISI_INTDIS, ~0UL);
 
-	bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-						icd->current_fmt->host_fmt);
-
-	if (bytes_per_line < 0)
-		return bytes_per_line;
-
-	size = bytes_per_line * icd->user_height;
+	size = icd->sizeimage;
 
 	if (!*nbuffers || *nbuffers > MAX_BUFFER_NUM)
 		*nbuffers = MAX_BUFFER_NUM;
@@ -316,13 +310,8 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	struct atmel_isi *isi = ici->priv;
 	unsigned long size;
 	struct isi_dma_desc *desc;
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-						icd->current_fmt->host_fmt);
-
-	if (bytes_per_line < 0)
-		return bytes_per_line;
 
-	size = bytes_per_line * icd->user_height;
+	size = icd->sizeimage;
 
 	if (vb2_plane_size(vb, 0) < size) {
 		dev_err(icd->parent, "%s data will not fit into plane (%lu < %lu)\n",
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 055d11d..4296a83 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -126,13 +126,8 @@ static int mx1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 			      unsigned int *size)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-						icd->current_fmt->host_fmt);
 
-	if (bytes_per_line < 0)
-		return bytes_per_line;
-
-	*size = bytes_per_line * icd->user_height;
+	*size = icd->sizeimage;
 
 	if (!*count)
 		*count = 32;
@@ -171,11 +166,6 @@ static int mx1_videobuf_prepare(struct videobuf_queue *vq,
 	struct soc_camera_device *icd = vq->priv_data;
 	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
 	int ret;
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-						icd->current_fmt->host_fmt);
-
-	if (bytes_per_line < 0)
-		return bytes_per_line;
 
 	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
@@ -202,7 +192,7 @@ static int mx1_videobuf_prepare(struct videobuf_queue *vq,
 		vb->state	= VIDEOBUF_NEEDS_INIT;
 	}
 
-	vb->size = bytes_per_line * vb->height;
+	vb->size = icd->sizeimage;
 	if (0 != vb->baddr && vb->bsize < vb->size) {
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 77f8dde..091f2e1 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -505,15 +505,10 @@ static int mx2_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 			      unsigned int *size)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-			icd->current_fmt->host_fmt);
 
 	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, *size);
 
-	if (bytes_per_line < 0)
-		return bytes_per_line;
-
-	*size = bytes_per_line * icd->user_height;
+	*size = icd->sizeimage;
 
 	if (0 == *count)
 		*count = 32;
@@ -548,16 +543,11 @@ static int mx2_videobuf_prepare(struct videobuf_queue *vq,
 {
 	struct soc_camera_device *icd = vq->priv_data;
 	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-			icd->current_fmt->host_fmt);
 	int ret = 0;
 
 	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
-	if (bytes_per_line < 0)
-		return bytes_per_line;
-
 #ifdef DEBUG
 	/*
 	 * This can be useful if you want to see if we actually fill
@@ -577,7 +567,7 @@ static int mx2_videobuf_prepare(struct videobuf_queue *vq,
 		vb->state	= VIDEOBUF_NEEDS_INIT;
 	}
 
-	vb->size = bytes_per_line * vb->height;
+	vb->size = icd->sizeimage;
 	if (vb->baddr && vb->bsize < vb->size) {
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 7452277..f8ce875 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -199,8 +199,6 @@ static int mx3_videobuf_setup(struct vb2_queue *vq,
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
-	int bytes_per_line;
-	unsigned int height;
 
 	if (!mx3_cam->idmac_channel[0])
 		return -EINVAL;
@@ -208,21 +206,21 @@ static int mx3_videobuf_setup(struct vb2_queue *vq,
 	if (fmt) {
 		const struct soc_camera_format_xlate *xlate = soc_camera_xlate_by_fourcc(icd,
 								fmt->fmt.pix.pixelformat);
+		int bytes_per_line;
+
 		if (!xlate)
 			return -EINVAL;
+
 		bytes_per_line = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
 							 xlate->host_fmt);
-		height = fmt->fmt.pix.height;
+		if (bytes_per_line < 0)
+			return bytes_per_line;
+
+		sizes[0] = bytes_per_line * fmt->fmt.pix.height;
 	} else {
 		/* Called from VIDIOC_REQBUFS or in compatibility mode */
-		bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-						icd->current_fmt->host_fmt);
-		height = icd->user_height;
+		sizes[0] = icd->sizeimage;
 	}
-	if (bytes_per_line < 0)
-		return bytes_per_line;
-
-	sizes[0] = bytes_per_line * height;
 
 	alloc_ctxs[0] = mx3_cam->alloc_ctx;
 
@@ -274,7 +272,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
 
 	BUG_ON(bytes_per_line <= 0);
 
-	new_size = bytes_per_line * icd->user_height;
+	new_size = icd->sizeimage;
 
 	if (vb2_plane_size(vb, 0) < new_size) {
 		dev_err(icd->parent, "Buffer #%d too small (%lu < %zu)\n",
diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index c20f5ec..addab76 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -206,15 +206,10 @@ static int omap1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 		unsigned int *size)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-			icd->current_fmt->host_fmt);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
 
-	if (bytes_per_line < 0)
-		return bytes_per_line;
-
-	*size = bytes_per_line * icd->user_height;
+	*size = icd->sizeimage;
 
 	if (!*count || *count < OMAP1_CAMERA_MIN_BUF_COUNT(pcdev->vb_mode))
 		*count = OMAP1_CAMERA_MIN_BUF_COUNT(pcdev->vb_mode);
@@ -256,15 +251,10 @@ static int omap1_videobuf_prepare(struct videobuf_queue *vq,
 {
 	struct soc_camera_device *icd = vq->priv_data;
 	struct omap1_cam_buf *buf = container_of(vb, struct omap1_cam_buf, vb);
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-			icd->current_fmt->host_fmt);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
 	int ret;
 
-	if (bytes_per_line < 0)
-		return bytes_per_line;
-
 	WARN_ON(!list_empty(&vb->queue));
 
 	BUG_ON(NULL == icd->current_fmt);
@@ -281,7 +271,7 @@ static int omap1_videobuf_prepare(struct videobuf_queue *vq,
 		vb->state  = VIDEOBUF_NEEDS_INIT;
 	}
 
-	vb->size = bytes_per_line * vb->height;
+	vb->size = icd->sizeimage;
 
 	if (vb->baddr && vb->bsize < vb->size) {
 		ret = -EINVAL;
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 0bd7da2..26013df 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -241,15 +241,10 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 			      unsigned int *size)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-						icd->current_fmt->host_fmt);
-
-	if (bytes_per_line < 0)
-		return bytes_per_line;
 
 	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, *size);
 
-	*size = bytes_per_line * icd->user_height;
+	*size = icd->sizeimage;
 
 	if (0 == *count)
 		*count = 32;
@@ -435,11 +430,6 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 	int ret;
 	int size_y, size_u = 0, size_v = 0;
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-						icd->current_fmt->host_fmt);
-
-	if (bytes_per_line < 0)
-		return bytes_per_line;
 
 	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
@@ -474,7 +464,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 		vb->state	= VIDEOBUF_NEEDS_INIT;
 	}
 
-	vb->size = bytes_per_line * vb->height;
+	vb->size = icd->sizeimage;
 	if (0 != vb->baddr && vb->bsize < vb->size) {
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index f854d85..f5aa369 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -206,27 +206,25 @@ static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
 	struct soc_camera_device *icd = container_of(vq, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	int bytes_per_line;
-	unsigned int height;
 
 	if (fmt) {
 		const struct soc_camera_format_xlate *xlate = soc_camera_xlate_by_fourcc(icd,
 								fmt->fmt.pix.pixelformat);
+		int bytes_per_line;
+
 		if (!xlate)
 			return -EINVAL;
+
 		bytes_per_line = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
 							 xlate->host_fmt);
-		height = fmt->fmt.pix.height;
+		if (bytes_per_line < 0)
+			return bytes_per_line;
+
+		sizes[0] = bytes_per_line * fmt->fmt.pix.height;
 	} else {
 		/* Called from VIDIOC_REQBUFS or in compatibility mode */
-		bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-						icd->current_fmt->host_fmt);
-		height = icd->user_height;
+		sizes[0] = icd->sizeimage;
 	}
-	if (bytes_per_line < 0)
-		return bytes_per_line;
-
-	sizes[0] = bytes_per_line * height;
 
 	alloc_ctxs[0] = pcdev->alloc_ctx;
 
@@ -373,13 +371,8 @@ static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
 	unsigned long size;
-	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
-						icd->current_fmt->host_fmt);
-
-	if (bytes_per_line < 0)
-		goto error;
 
-	size = icd->user_height * bytes_per_line;
+	size = icd->sizeimage;
 
 	if (vb2_plane_size(vb, 0) < size) {
 		dev_err(icd->parent, "Buffer #%d too small (%lu < %lu)\n",
-- 
1.7.3.4

