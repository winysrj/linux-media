Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:26468 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441AbcHHTb0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2016 15:31:26 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 06/14] media: platform: pxa_camera: trivial move of functions
Date: Mon,  8 Aug 2016 21:30:44 +0200
Message-Id: <1470684652-16295-7-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the functions in the file to be regrouped into meaningful blocks :
 1. pxa camera core handling functions, manipulating the herdware
 2. videobuf2 functions, dealing with video buffers
 3. video ioctl (vidioc) related functions
 4. driver probing, removal, suspend and resume

This patch doesn't modify a single line of code.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 475 +++++++++++++------------
 1 file changed, 242 insertions(+), 233 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 6b6b654c8872..f3767415c128 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -540,239 +540,6 @@ out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
-static void pxa_buffer_cleanup(struct pxa_buffer *buf)
-{
-	int i;
-
-	for (i = 0; i < 3 && buf->descs[i]; i++) {
-		dmaengine_desc_free(buf->descs[i]);
-		kfree(buf->sg[i]);
-		buf->descs[i] = NULL;
-		buf->sg[i] = NULL;
-		buf->sg_len[i] = 0;
-		buf->plane_sizes[i] = 0;
-	}
-	buf->nb_planes = 0;
-}
-
-static int pxa_buffer_init(struct pxa_camera_dev *pcdev,
-			   struct pxa_buffer *buf)
-{
-	struct vb2_buffer *vb = &buf->vbuf.vb2_buf;
-	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
-	int nb_channels = pcdev->channels;
-	int i, ret = 0;
-	unsigned long size = vb2_plane_size(vb, 0);
-
-	switch (nb_channels) {
-	case 1:
-		buf->plane_sizes[0] = size;
-		break;
-	case 3:
-		buf->plane_sizes[0] = size / 2;
-		buf->plane_sizes[1] = size / 4;
-		buf->plane_sizes[2] = size / 4;
-		break;
-	default:
-		return -EINVAL;
-	};
-	buf->nb_planes = nb_channels;
-
-	ret = sg_split(sgt->sgl, sgt->nents, 0, nb_channels,
-		       buf->plane_sizes, buf->sg, buf->sg_len, GFP_KERNEL);
-	if (ret < 0) {
-		dev_err(pcdev_to_dev(pcdev),
-			"sg_split failed: %d\n", ret);
-		return ret;
-	}
-	for (i = 0; i < nb_channels; i++) {
-		ret = pxa_init_dma_channel(pcdev, buf, i,
-					   buf->sg[i], buf->sg_len[i]);
-		if (ret) {
-			pxa_buffer_cleanup(buf);
-			return ret;
-		}
-	}
-	INIT_LIST_HEAD(&buf->queue);
-
-	return ret;
-}
-
-static void pxac_vb2_cleanup(struct vb2_buffer *vb)
-{
-	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s(vb=%p)\n", __func__, vb);
-	pxa_buffer_cleanup(buf);
-}
-
-static void pxac_vb2_queue(struct vb2_buffer *vb)
-{
-	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s(vb=%p) nb_channels=%d size=%lu active=%p\n",
-		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0),
-		pcdev->active);
-
-	list_add_tail(&buf->queue, &pcdev->capture);
-
-	pxa_dma_add_tail_buf(pcdev, buf);
-}
-
-/*
- * Please check the DMA prepared buffer structure in :
- *   Documentation/video4linux/pxa_camera.txt
- * Please check also in pxa_camera_check_link_miss() to understand why DMA chain
- * modification while DMA chain is running will work anyway.
- */
-static int pxac_vb2_prepare(struct vb2_buffer *vb)
-{
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
-	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
-	int ret = 0;
-
-	switch (pcdev->channels) {
-	case 1:
-	case 3:
-		vb2_set_plane_payload(vb, 0, icd->sizeimage);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s (vb=%p) nb_channels=%d size=%lu\n",
-		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0));
-
-	WARN_ON(!icd->current_fmt);
-
-#ifdef DEBUG
-	/*
-	 * This can be useful if you want to see if we actually fill
-	 * the buffer with something
-	 */
-	for (i = 0; i < vb->num_planes; i++)
-		memset((void *)vb2_plane_vaddr(vb, i),
-		       0xaa, vb2_get_plane_payload(vb, i));
-#endif
-
-	/*
-	 * I think, in buf_prepare you only have to protect global data,
-	 * the actual buffer is yours
-	 */
-	buf->inwork = 0;
-	pxa_videobuf_set_actdma(pcdev, buf);
-
-	return ret;
-}
-
-static int pxac_vb2_init(struct vb2_buffer *vb)
-{
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
-	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s(nb_channels=%d)\n",
-		__func__, pcdev->channels);
-
-	return pxa_buffer_init(pcdev, buf);
-}
-
-static int pxac_vb2_queue_setup(struct vb2_queue *vq,
-				unsigned int *nbufs,
-				unsigned int *num_planes, unsigned int sizes[],
-				void *alloc_ctxs[])
-{
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
-	int size = icd->sizeimage;
-
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "%s(vq=%p nbufs=%d num_planes=%d size=%d)\n",
-		__func__, vq, *nbufs, *num_planes, size);
-	/*
-	 * Called from VIDIOC_REQBUFS or in compatibility mode For YUV422P
-	 * format, even if there are 3 planes Y, U and V, we reply there is only
-	 * one plane, containing Y, U and V data, one after the other.
-	 */
-	if (*num_planes)
-		return sizes[0] < size ? -EINVAL : 0;
-
-	*num_planes = 1;
-	switch (pcdev->channels) {
-	case 1:
-	case 3:
-		sizes[0] = size;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	alloc_ctxs[0] = pcdev->alloc_ctx;
-	if (!*nbufs)
-		*nbufs = 1;
-
-	return 0;
-}
-
-static int pxac_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
-{
-	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
-
-	dev_dbg(pcdev_to_dev(pcdev), "%s(count=%d) active=%p\n",
-		__func__, count, pcdev->active);
-
-	if (!pcdev->active)
-		pxa_camera_start_capture(pcdev);
-
-	return 0;
-}
-
-static void pxac_vb2_stop_streaming(struct vb2_queue *vq)
-{
-	vb2_wait_for_all_buffers(vq);
-}
-
-static struct vb2_ops pxac_vb2_ops = {
-	.queue_setup		= pxac_vb2_queue_setup,
-	.buf_init		= pxac_vb2_init,
-	.buf_prepare		= pxac_vb2_prepare,
-	.buf_queue		= pxac_vb2_queue,
-	.buf_cleanup		= pxac_vb2_cleanup,
-	.start_streaming	= pxac_vb2_start_streaming,
-	.stop_streaming		= pxac_vb2_stop_streaming,
-	.wait_prepare		= vb2_ops_wait_prepare,
-	.wait_finish		= vb2_ops_wait_finish,
-};
-
-static int pxa_camera_init_videobuf2(struct vb2_queue *vq,
-				     struct soc_camera_device *icd)
-{
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
-	int ret;
-
-	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
-	vq->drv_priv = pcdev;
-	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	vq->buf_struct_size = sizeof(struct pxa_buffer);
-
-	vq->ops = &pxac_vb2_ops;
-	vq->mem_ops = &vb2_dma_sg_memops;
-
-	ret = vb2_queue_init(vq);
-	dev_dbg(pcdev_to_dev(pcdev),
-		 "vb2_queue_init(vq=%p): %d\n", vq, ret);
-
-	return ret;
-}
-
 static u32 mclk_get_divisor(struct platform_device *pdev,
 			    struct pxa_camera_dev *pcdev)
 {
@@ -1054,6 +821,245 @@ static void pxa_camera_setup_cicr(struct soc_camera_device *icd,
 	__raw_writel(cicr0, pcdev->base + CICR0);
 }
 
+/*
+ * Videobuf2 section
+ */
+static void pxa_buffer_cleanup(struct pxa_buffer *buf)
+{
+	int i;
+
+	for (i = 0; i < 3 && buf->descs[i]; i++) {
+		dmaengine_desc_free(buf->descs[i]);
+		kfree(buf->sg[i]);
+		buf->descs[i] = NULL;
+		buf->sg[i] = NULL;
+		buf->sg_len[i] = 0;
+		buf->plane_sizes[i] = 0;
+	}
+	buf->nb_planes = 0;
+}
+
+static int pxa_buffer_init(struct pxa_camera_dev *pcdev,
+			   struct pxa_buffer *buf)
+{
+	struct vb2_buffer *vb = &buf->vbuf.vb2_buf;
+	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
+	int nb_channels = pcdev->channels;
+	int i, ret = 0;
+	unsigned long size = vb2_plane_size(vb, 0);
+
+	switch (nb_channels) {
+	case 1:
+		buf->plane_sizes[0] = size;
+		break;
+	case 3:
+		buf->plane_sizes[0] = size / 2;
+		buf->plane_sizes[1] = size / 4;
+		buf->plane_sizes[2] = size / 4;
+		break;
+	default:
+		return -EINVAL;
+	};
+	buf->nb_planes = nb_channels;
+
+	ret = sg_split(sgt->sgl, sgt->nents, 0, nb_channels,
+		       buf->plane_sizes, buf->sg, buf->sg_len, GFP_KERNEL);
+	if (ret < 0) {
+		dev_err(pcdev_to_dev(pcdev),
+			"sg_split failed: %d\n", ret);
+		return ret;
+	}
+	for (i = 0; i < nb_channels; i++) {
+		ret = pxa_init_dma_channel(pcdev, buf, i,
+					   buf->sg[i], buf->sg_len[i]);
+		if (ret) {
+			pxa_buffer_cleanup(buf);
+			return ret;
+		}
+	}
+	INIT_LIST_HEAD(&buf->queue);
+
+	return ret;
+}
+
+static void pxac_vb2_cleanup(struct vb2_buffer *vb)
+{
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(vb=%p)\n", __func__, vb);
+	pxa_buffer_cleanup(buf);
+}
+
+static void pxac_vb2_queue(struct vb2_buffer *vb)
+{
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(vb=%p) nb_channels=%d size=%lu active=%p\n",
+		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0),
+		pcdev->active);
+
+	list_add_tail(&buf->queue, &pcdev->capture);
+
+	pxa_dma_add_tail_buf(pcdev, buf);
+}
+
+/*
+ * Please check the DMA prepared buffer structure in :
+ *   Documentation/video4linux/pxa_camera.txt
+ * Please check also in pxa_camera_check_link_miss() to understand why DMA chain
+ * modification while DMA chain is running will work anyway.
+ */
+static int pxac_vb2_prepare(struct vb2_buffer *vb)
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
+	int ret = 0;
+
+	switch (pcdev->channels) {
+	case 1:
+	case 3:
+		vb2_set_plane_payload(vb, 0, icd->sizeimage);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s (vb=%p) nb_channels=%d size=%lu\n",
+		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0));
+
+	WARN_ON(!icd->current_fmt);
+
+#ifdef DEBUG
+	/*
+	 * This can be useful if you want to see if we actually fill
+	 * the buffer with something
+	 */
+	for (i = 0; i < vb->num_planes; i++)
+		memset((void *)vb2_plane_vaddr(vb, i),
+		       0xaa, vb2_get_plane_payload(vb, i));
+#endif
+
+	/*
+	 * I think, in buf_prepare you only have to protect global data,
+	 * the actual buffer is yours
+	 */
+	buf->inwork = 0;
+	pxa_videobuf_set_actdma(pcdev, buf);
+
+	return ret;
+}
+
+static int pxac_vb2_init(struct vb2_buffer *vb)
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
+	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(nb_channels=%d)\n",
+		__func__, pcdev->channels);
+
+	return pxa_buffer_init(pcdev, buf);
+}
+
+static int pxac_vb2_queue_setup(struct vb2_queue *vq,
+				unsigned int *nbufs,
+				unsigned int *num_planes, unsigned int sizes[],
+				void *alloc_ctxs[])
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
+	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
+	int size = icd->sizeimage;
+
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "%s(vq=%p nbufs=%d num_planes=%d size=%d)\n",
+		__func__, vq, *nbufs, *num_planes, size);
+	/*
+	 * Called from VIDIOC_REQBUFS or in compatibility mode For YUV422P
+	 * format, even if there are 3 planes Y, U and V, we reply there is only
+	 * one plane, containing Y, U and V data, one after the other.
+	 */
+	if (*num_planes)
+		return sizes[0] < size ? -EINVAL : 0;
+
+	*num_planes = 1;
+	switch (pcdev->channels) {
+	case 1:
+	case 3:
+		sizes[0] = size;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	alloc_ctxs[0] = pcdev->alloc_ctx;
+	if (!*nbufs)
+		*nbufs = 1;
+
+	return 0;
+}
+
+static int pxac_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
+
+	dev_dbg(pcdev_to_dev(pcdev), "%s(count=%d) active=%p\n",
+		__func__, count, pcdev->active);
+
+	if (!pcdev->active)
+		pxa_camera_start_capture(pcdev);
+
+	return 0;
+}
+
+static void pxac_vb2_stop_streaming(struct vb2_queue *vq)
+{
+	vb2_wait_for_all_buffers(vq);
+}
+
+static struct vb2_ops pxac_vb2_ops = {
+	.queue_setup		= pxac_vb2_queue_setup,
+	.buf_init		= pxac_vb2_init,
+	.buf_prepare		= pxac_vb2_prepare,
+	.buf_queue		= pxac_vb2_queue,
+	.buf_cleanup		= pxac_vb2_cleanup,
+	.start_streaming	= pxac_vb2_start_streaming,
+	.stop_streaming		= pxac_vb2_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+static int pxa_camera_init_videobuf2(struct vb2_queue *vq,
+				     struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	int ret;
+
+	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	vq->drv_priv = pcdev;
+	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	vq->buf_struct_size = sizeof(struct pxa_buffer);
+
+	vq->ops = &pxac_vb2_ops;
+	vq->mem_ops = &vb2_dma_sg_memops;
+
+	ret = vb2_queue_init(vq);
+	dev_dbg(pcdev_to_dev(pcdev),
+		 "vb2_queue_init(vq=%p): %d\n", vq, ret);
+
+	return ret;
+}
+
+/*
+ * Video ioctls section
+ */
 static int pxa_camera_set_bus_param(struct soc_camera_device *icd)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
@@ -1497,6 +1503,9 @@ static int pxa_camera_querycap(struct soc_camera_host *ici,
 	return 0;
 }
 
+/*
+ * Driver probe, remove, suspend and resume operations
+ */
 static int pxa_camera_suspend(struct device *dev)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(dev);
-- 
2.1.4

