Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54815 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbbLDWFl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 17:05:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] vivid: Add support for the dma-contig memory allocator
Date: Sat,  5 Dec 2015 00:05:48 +0200
Message-Id: <1449266748-22317-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To test buffer sharing with devices that require contiguous memory
buffers the dma-contig allocator is required. Support it and make the
allocator selectable through a module parameter. Support for the two
memory allocators can also be individually selected at compile-time to
avoid bloating the kernel with an unneeded allocator.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vivid/Kconfig         | 21 ++++++++++++-
 drivers/media/platform/vivid/vivid-core.c    | 44 ++++++++++++++++++++++++----
 drivers/media/platform/vivid/vivid-core.h    |  1 +
 drivers/media/platform/vivid/vivid-sdr-cap.c |  3 ++
 drivers/media/platform/vivid/vivid-vbi-cap.c |  2 ++
 drivers/media/platform/vivid/vivid-vbi-out.c |  1 +
 drivers/media/platform/vivid/vivid-vid-cap.c |  9 ++----
 drivers/media/platform/vivid/vivid-vid-out.c |  9 ++----
 8 files changed, 72 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index 0885e93ad436..ddfec721c08c 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -6,7 +6,7 @@ config VIDEO_VIVID
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select VIDEOBUF2_VMALLOC
+	select VIDEO_VIVID_MEM_VMALLOC if !VIDEO_VIVID_MEM_DMA_CONTIG
 	default n
 	---help---
 	  Enables a virtual video driver. This driver emulates a webcam,
@@ -28,3 +28,22 @@ config VIDEO_VIVID_MAX_DEVS
 	---help---
 	  This allows you to specify the maximum number of devices supported
 	  by the vivid driver.
+
+config VIDEO_VIVID_MEM_DMA_CONTIG
+	bool "Enable DMA-CONTIG Memory Type"
+	depends on VIDEO_VIVID
+	select VIDEOBUF2_DMA_CONTIG
+	default n
+	---help---
+	  Enable support for the DMA-CONTIG videobuf2 memory allocator. Say Y
+	  here if you want to test buffer sharing with devices that require
+	  contiguous memory buffers. When in doubt, say N.
+
+config VIDEO_VIVID_MEM_VMALLOC
+	bool "Enable VMALLOC Memory Type"
+	depends on VIDEO_VIVID
+	select VIDEOBUF2_VMALLOC
+	default y
+	---help---
+	  Enable support for the VMALLOC videobuf2 memory allocator. This is the
+	  default memory allocator for the vivid driver. When in doubt, say Y.
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index f57ff1101e74..d526144151fc 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -29,6 +29,7 @@
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 #include <linux/v4l2-dv-timings.h>
+#include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-ioctl.h>
@@ -150,6 +151,16 @@ static bool no_error_inj;
 module_param(no_error_inj, bool, 0444);
 MODULE_PARM_DESC(no_error_inj, " if set disable the error injecting controls");
 
+enum memory_type {
+	VIVID_MEM_VMALLOC,
+	VIVID_MEM_DMA_CONTIG,
+};
+
+static unsigned memory_type;
+module_param(memory_type, uint, 0444);
+MODULE_PARM_DESC(memory_type, " memory type, default is vmalloc,\n"
+			      "\t\t    0 == vmalloc, 1 == dma-contig");
+
 static struct vivid_dev *vivid_devs[VIVID_MAX_DEVS];
 
 const struct v4l2_rect vivid_min_rect = {
@@ -634,6 +645,10 @@ static void vivid_dev_release(struct v4l2_device *v4l2_dev)
 {
 	struct vivid_dev *dev = container_of(v4l2_dev, struct vivid_dev, v4l2_dev);
 
+	if (memory_type == VIVID_MEM_DMA_CONTIG &&
+	    IS_ENABLED(CONFIG_VIDEO_VIVID_DMA_CONTIG))
+		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
+
 	vivid_free_controls(dev);
 	v4l2_device_unregister(&dev->v4l2_dev);
 	vfree(dev->scaled_line);
@@ -659,6 +674,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	struct vivid_dev *dev;
 	struct video_device *vfd;
 	struct vb2_queue *q;
+	const struct vb2_mem_ops *vb2_memops;
 	unsigned node_type = node_types[inst];
 	v4l2_std_id tvnorms_cap = 0, tvnorms_out = 0;
 	int ret;
@@ -1026,6 +1042,24 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	INIT_LIST_HEAD(&dev->sdr_cap_active);
 
 	/* start creating the vb2 queues */
+	if (memory_type == VIVID_MEM_DMA_CONTIG &&
+	    IS_ENABLED(CONFIG_VIDEO_VIVID_DMA_CONTIG)) {
+		ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+		if (ret)
+			goto unreg_dev;
+
+		vb2_memops = &vb2_dma_contig_memops;
+		dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	} else if (memory_type == VIVID_MEM_VMALLOC &&
+		   IS_ENABLED(CONFIG_VIDEO_VIVID_VMALLOC)) {
+		vb2_memops = &vb2_vmalloc_memops;
+	} else {
+		dev_err(&pdev->dev, "unsupported memory type %u\n",
+			memory_type);
+		ret = -EINVAL;
+		goto unreg_dev;
+	}
+
 	if (dev->has_vid_cap) {
 		/* initialize vid_cap queue */
 		q = &dev->vb_vid_cap_q;
@@ -1035,7 +1069,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_cap_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vb2_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
@@ -1054,7 +1088,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_out_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vb2_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
@@ -1073,7 +1107,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_cap_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vb2_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
@@ -1092,7 +1126,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_out_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vb2_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
@@ -1110,7 +1144,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_sdr_cap_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vb2_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 8;
 		q->lock = &dev->mutex;
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 55b304a705d5..22be49c5d5eb 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -157,6 +157,7 @@ struct vivid_dev {
 	struct v4l2_ctrl_handler	ctrl_hdl_sdr_cap;
 	spinlock_t			slock;
 	struct mutex			mutex;
+	void				*alloc_ctx;
 
 	/* capabilities */
 	u32				vid_cap_caps;
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 082c401764ce..595501d96550 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -217,9 +217,12 @@ static int sdr_cap_queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned *nbuffers, unsigned *nplanes,
 		       unsigned sizes[], void *alloc_ctxs[])
 {
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+
 	/* 2 = max 16-bit sample returned */
 	sizes[0] = SDR_CAP_SAMPLES_PER_BUF * 2;
 	*nplanes = 1;
+	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index e903d023e9df..afb880fb7d5f 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -156,6 +156,8 @@ static int vbi_cap_queue_setup(struct vb2_queue *vq, const void *parg,
 		*nbuffers = 2 - vq->num_buffers;
 
 	*nplanes = 1;
+	alloc_ctxs[0] = dev->alloc_ctx;
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 75c5709f938e..8ff5a41b9a0f 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -46,6 +46,7 @@ static int vbi_out_queue_setup(struct vb2_queue *vq, const void *parg,
 		*nbuffers = 2 - vq->num_buffers;
 
 	*nplanes = 1;
+	alloc_ctxs[0] = dev->alloc_ctx;
 	return 0;
 }
 
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index d9cb609b7381..305cf1b8b141 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -156,14 +156,11 @@ static int vid_cap_queue_setup(struct vb2_queue *vq, const void *parg,
 
 	*nplanes = buffers;
 
-	/*
-	 * videobuf2-vmalloc allocator is context-less so no need to set
-	 * alloc_ctxs array.
-	 */
-
 	dprintk(dev, 1, "%s: count=%d\n", __func__, *nbuffers);
-	for (p = 0; p < buffers; p++)
+	for (p = 0; p < buffers; p++) {
+		alloc_ctxs[p] = dev->alloc_ctx;
 		dprintk(dev, 1, "%s: size[%u]=%u\n", __func__, p, sizes[p]);
+	}
 
 	return 0;
 }
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index b77acb6a7013..36eb2a3c8c55 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -97,14 +97,11 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const void *parg,
 
 	*nplanes = planes;
 
-	/*
-	 * videobuf2-vmalloc allocator is context-less so no need to set
-	 * alloc_ctxs array.
-	 */
-
 	dprintk(dev, 1, "%s: count=%d\n", __func__, *nbuffers);
-	for (p = 0; p < planes; p++)
+	for (p = 0; p < planes; p++) {
+		alloc_ctxs[p] = dev->alloc_ctx;
 		dprintk(dev, 1, "%s: size[%u]=%u\n", __func__, p, sizes[p]);
+	}
 	return 0;
 }
 
-- 
Regards,

Laurent Pinchart

