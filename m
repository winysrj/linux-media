Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:59814 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755625AbdCKLXg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 06:23:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv5 07/16] atmel-isi: remove dependency of the soc-camera framework
Date: Sat, 11 Mar 2017 12:23:19 +0100
Message-Id: <20170311112328.11802-8-hverkuil@xs4all.nl>
In-Reply-To: <20170311112328.11802-1-hverkuil@xs4all.nl>
References: <20170311112328.11802-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch converts the atmel-isi driver from a soc-camera driver to a driver
that is stand-alone.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/soc_camera/Kconfig     |    3 +-
 drivers/media/platform/soc_camera/atmel-isi.c | 1209 +++++++++++++++----------
 2 files changed, 714 insertions(+), 498 deletions(-)

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index 86d74788544f..a37ec91b026e 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -29,9 +29,8 @@ config VIDEO_SH_MOBILE_CEU
 
 config VIDEO_ATMEL_ISI
 	tristate "ATMEL Image Sensor Interface (ISI) support"
-	depends on VIDEO_DEV && SOC_CAMERA
+	depends on VIDEO_V4L2 && OF && HAS_DMA
 	depends on ARCH_AT91 || COMPILE_TEST
-	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This module makes the ATMEL Image Sensor Interface available
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 46de657c3e6d..a6d60c2e207d 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -22,18 +22,22 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
-
-#include <media/soc_camera.h>
-#include <media/drv-intf/soc_mediabus.h>
+#include <linux/of.h>
+
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-of.h>
 #include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-image-sizes.h>
 
 #include "atmel-isi.h"
 
-#define MAX_BUFFER_NUM			32
 #define MAX_SUPPORT_WIDTH		2048
 #define MAX_SUPPORT_HEIGHT		2048
-#define VID_LIMIT_BYTES			(16 * 1024 * 1024)
 #define MIN_FRAME_RATE			15
 #define FRAME_INTERVAL_MILLI_SEC	(1000 / MIN_FRAME_RATE)
 
@@ -65,9 +69,37 @@ struct frame_buffer {
 	struct list_head list;
 };
 
+struct isi_graph_entity {
+	struct device_node *node;
+
+	struct v4l2_async_subdev asd;
+	struct v4l2_subdev *subdev;
+};
+
+/*
+ * struct isi_format - ISI media bus format information
+ * @fourcc:		Fourcc code for this format
+ * @mbus_code:		V4L2 media bus format code.
+ * @bpp:		Bytes per pixel (when stored in memory)
+ * @swap:		Byte swap configuration value
+ * @support:		Indicates format supported by subdev
+ * @skip:		Skip duplicate format supported by subdev
+ */
+struct isi_format {
+	u32	fourcc;
+	u32	mbus_code;
+	u8	bpp;
+	u32	swap;
+
+	bool	support;
+	bool	skip;
+};
+
+
 struct atmel_isi {
 	/* Protects the access of variables shared with the ISR */
-	spinlock_t			lock;
+	spinlock_t			irqlock;
+	struct device			*dev;
 	void __iomem			*regs;
 
 	int				sequence;
@@ -76,7 +108,7 @@ struct atmel_isi {
 	struct fbd			*p_fb_descriptors;
 	dma_addr_t			fb_descriptors_phys;
 	struct				list_head dma_desc_head;
-	struct isi_dma_desc		dma_desc[MAX_BUFFER_NUM];
+	struct isi_dma_desc		dma_desc[VIDEO_MAX_FRAME];
 	bool				enable_preview_path;
 
 	struct completion		complete;
@@ -90,9 +122,22 @@ struct atmel_isi {
 	struct list_head		video_buffer_list;
 	struct frame_buffer		*active;
 
-	struct soc_camera_host		soc_host;
+	struct v4l2_device		v4l2_dev;
+	struct video_device		*vdev;
+	struct v4l2_async_notifier	notifier;
+	struct isi_graph_entity		entity;
+	struct v4l2_format		fmt;
+
+	struct isi_format		**user_formats;
+	unsigned int			num_user_formats;
+	const struct isi_format		*current_fmt;
+
+	struct mutex			lock;
+	struct vb2_queue		queue;
 };
 
+#define notifier_to_isi(n) container_of(n, struct atmel_isi, notifier)
+
 static void isi_writel(struct atmel_isi *isi, u32 reg, u32 val)
 {
 	writel(val, isi->regs + reg);
@@ -102,107 +147,46 @@ static u32 isi_readl(struct atmel_isi *isi, u32 reg)
 	return readl(isi->regs + reg);
 }
 
-static u32 setup_cfg2_yuv_swap(struct atmel_isi *isi,
-		const struct soc_camera_format_xlate *xlate)
-{
-	if (xlate->host_fmt->fourcc == V4L2_PIX_FMT_YUYV) {
-		/* all convert to YUYV */
-		switch (xlate->code) {
-		case MEDIA_BUS_FMT_VYUY8_2X8:
-			return ISI_CFG2_YCC_SWAP_MODE_3;
-		case MEDIA_BUS_FMT_UYVY8_2X8:
-			return ISI_CFG2_YCC_SWAP_MODE_2;
-		case MEDIA_BUS_FMT_YVYU8_2X8:
-			return ISI_CFG2_YCC_SWAP_MODE_1;
-		}
-	} else if (xlate->host_fmt->fourcc == V4L2_PIX_FMT_RGB565) {
-		/*
-		 * Preview path is enabled, it will convert UYVY to RGB format.
-		 * But if sensor output format is not UYVY, we need to set
-		 * YCC_SWAP_MODE to convert it as UYVY.
-		 */
-		switch (xlate->code) {
-		case MEDIA_BUS_FMT_VYUY8_2X8:
-			return ISI_CFG2_YCC_SWAP_MODE_1;
-		case MEDIA_BUS_FMT_YUYV8_2X8:
-			return ISI_CFG2_YCC_SWAP_MODE_2;
-		case MEDIA_BUS_FMT_YVYU8_2X8:
-			return ISI_CFG2_YCC_SWAP_MODE_3;
-		}
-	}
-
-	/*
-	 * By default, no swap for the codec path of Atmel ISI. So codec
-	 * output is same as sensor's output.
-	 * For instance, if sensor's output is YUYV, then codec outputs YUYV.
-	 * And if sensor's output is UYVY, then codec outputs UYVY.
-	 */
-	return ISI_CFG2_YCC_SWAP_DEFAULT;
-}
+static struct isi_format isi_formats[] = {
+	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_YUYV8_2X8,
+	  2, ISI_CFG2_YCC_SWAP_DEFAULT, false },
+	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_YVYU8_2X8,
+	  2, ISI_CFG2_YCC_SWAP_MODE_1, false },
+	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_UYVY8_2X8,
+	  2, ISI_CFG2_YCC_SWAP_MODE_2, false },
+	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_VYUY8_2X8,
+	  2, ISI_CFG2_YCC_SWAP_MODE_3, false },
+	{ V4L2_PIX_FMT_RGB565, MEDIA_BUS_FMT_YUYV8_2X8,
+	  2, ISI_CFG2_YCC_SWAP_MODE_2, false },
+};
 
-static void configure_geometry(struct atmel_isi *isi, u32 width,
-		u32 height, const struct soc_camera_format_xlate *xlate)
+static void configure_geometry(struct atmel_isi *isi)
 {
-	u32 cfg2, psize;
-	u32 fourcc = xlate->host_fmt->fourcc;
+	u32 cfg2 = 0, psize;
+	u32 fourcc = isi->current_fmt->fourcc;
 
 	isi->enable_preview_path = fourcc == V4L2_PIX_FMT_RGB565 ||
 				   fourcc == V4L2_PIX_FMT_RGB32;
 
 	/* According to sensor's output format to set cfg2 */
-	switch (xlate->code) {
-	default:
-	/* Grey */
-	case MEDIA_BUS_FMT_Y8_1X8:
-		cfg2 = ISI_CFG2_GRAYSCALE | ISI_CFG2_COL_SPACE_YCbCr;
-		break;
-	/* YUV */
-	case MEDIA_BUS_FMT_VYUY8_2X8:
-	case MEDIA_BUS_FMT_UYVY8_2X8:
-	case MEDIA_BUS_FMT_YVYU8_2X8:
-	case MEDIA_BUS_FMT_YUYV8_2X8:
-		cfg2 = ISI_CFG2_COL_SPACE_YCbCr |
-				setup_cfg2_yuv_swap(isi, xlate);
-		break;
-	/* RGB, TODO */
-	}
+	cfg2 = isi->current_fmt->swap;
 
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
 	/* Set width */
-	cfg2 |= ((width - 1) << ISI_CFG2_IM_HSIZE_OFFSET) &
+	cfg2 |= ((isi->fmt.fmt.pix.width - 1) << ISI_CFG2_IM_HSIZE_OFFSET) &
 			ISI_CFG2_IM_HSIZE_MASK;
 	/* Set height */
-	cfg2 |= ((height - 1) << ISI_CFG2_IM_VSIZE_OFFSET)
+	cfg2 |= ((isi->fmt.fmt.pix.height - 1) << ISI_CFG2_IM_VSIZE_OFFSET)
 			& ISI_CFG2_IM_VSIZE_MASK;
 	isi_writel(isi, ISI_CFG2, cfg2);
 
 	/* No down sampling, preview size equal to sensor output size */
-	psize = ((width - 1) << ISI_PSIZE_PREV_HSIZE_OFFSET) &
+	psize = ((isi->fmt.fmt.pix.width - 1) << ISI_PSIZE_PREV_HSIZE_OFFSET) &
 		ISI_PSIZE_PREV_HSIZE_MASK;
-	psize |= ((height - 1) << ISI_PSIZE_PREV_VSIZE_OFFSET) &
+	psize |= ((isi->fmt.fmt.pix.height - 1) << ISI_PSIZE_PREV_VSIZE_OFFSET) &
 		ISI_PSIZE_PREV_VSIZE_MASK;
 	isi_writel(isi, ISI_PSIZE, psize);
 	isi_writel(isi, ISI_PDECF, ISI_PDECF_NO_SAMPLING);
-
-	return;
-}
-
-static bool is_supported(struct soc_camera_device *icd,
-		const u32 pixformat)
-{
-	switch (pixformat) {
-	/* YUV, including grey */
-	case V4L2_PIX_FMT_GREY:
-	case V4L2_PIX_FMT_YUYV:
-	case V4L2_PIX_FMT_UYVY:
-	case V4L2_PIX_FMT_YVYU:
-	case V4L2_PIX_FMT_VYUY:
-	/* RGB */
-	case V4L2_PIX_FMT_RGB565:
-		return true;
-	default:
-		return false;
-	}
 }
 
 static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
@@ -214,6 +198,7 @@ static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 		list_del_init(&buf->list);
 		vbuf->vb2_buf.timestamp = ktime_get_ns();
 		vbuf->sequence = isi->sequence++;
+		vbuf->field = V4L2_FIELD_NONE;
 		vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
 	}
 
@@ -247,7 +232,7 @@ static irqreturn_t isi_interrupt(int irq, void *dev_id)
 	u32 status, mask, pending;
 	irqreturn_t ret = IRQ_NONE;
 
-	spin_lock(&isi->lock);
+	spin_lock(&isi->irqlock);
 
 	status = isi_readl(isi, ISI_STATUS);
 	mask = isi_readl(isi, ISI_INTMASK);
@@ -267,7 +252,7 @@ static irqreturn_t isi_interrupt(int irq, void *dev_id)
 			ret = atmel_isi_handle_streaming(isi);
 	}
 
-	spin_unlock(&isi->lock);
+	spin_unlock(&isi->irqlock);
 	return ret;
 }
 
@@ -305,26 +290,21 @@ static int queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], struct device *alloc_devs[])
 {
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct atmel_isi *isi = ici->priv;
+	struct atmel_isi *isi = vb2_get_drv_priv(vq);
 	unsigned long size;
 
-	size = icd->sizeimage;
+	size = isi->fmt.fmt.pix.sizeimage;
 
-	if (!*nbuffers || *nbuffers > MAX_BUFFER_NUM)
-		*nbuffers = MAX_BUFFER_NUM;
-
-	if (size * *nbuffers > VID_LIMIT_BYTES)
-		*nbuffers = VID_LIMIT_BYTES / size;
+	/* Make sure the image size is large enough. */
+	if (*nplanes)
+		return sizes[0] < size ? -EINVAL : 0;
 
 	*nplanes = 1;
 	sizes[0] = size;
 
-	isi->sequence = 0;
 	isi->active = NULL;
 
-	dev_dbg(icd->parent, "%s, count=%d, size=%ld\n", __func__,
+	dev_dbg(isi->dev, "%s, count=%d, size=%ld\n", __func__,
 		*nbuffers, size);
 
 	return 0;
@@ -344,17 +324,15 @@ static int buffer_init(struct vb2_buffer *vb)
 static int buffer_prepare(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
 	struct frame_buffer *buf = container_of(vbuf, struct frame_buffer, vb);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct atmel_isi *isi = ici->priv;
+	struct atmel_isi *isi = vb2_get_drv_priv(vb->vb2_queue);
 	unsigned long size;
 	struct isi_dma_desc *desc;
 
-	size = icd->sizeimage;
+	size = isi->fmt.fmt.pix.sizeimage;
 
 	if (vb2_plane_size(vb, 0) < size) {
-		dev_err(icd->parent, "%s data will not fit into plane (%lu < %lu)\n",
+		dev_err(isi->dev, "%s data will not fit into plane (%lu < %lu)\n",
 				__func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
 	}
@@ -363,7 +341,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 	if (!buf->p_dma_desc) {
 		if (list_empty(&isi->dma_desc_head)) {
-			dev_err(icd->parent, "Not enough dma descriptors.\n");
+			dev_err(isi->dev, "Not enough dma descriptors.\n");
 			return -EINVAL;
 		} else {
 			/* Get an available descriptor */
@@ -387,9 +365,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 static void buffer_cleanup(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct atmel_isi *isi = ici->priv;
+	struct atmel_isi *isi = vb2_get_drv_priv(vb->vb2_queue);
 	struct frame_buffer *buf = container_of(vbuf, struct frame_buffer, vb);
 
 	/* This descriptor is available now and we add to head list */
@@ -409,7 +385,7 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 	/* Check if already in a frame */
 	if (!isi->enable_preview_path) {
 		if (isi_readl(isi, ISI_STATUS) & ISI_CTRL_CDC) {
-			dev_err(isi->soc_host.icd->parent, "Already in frame handling.\n");
+			dev_err(isi->dev, "Already in frame handling.\n");
 			return;
 		}
 
@@ -443,13 +419,11 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 static void buffer_queue(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct atmel_isi *isi = ici->priv;
+	struct atmel_isi *isi = vb2_get_drv_priv(vb->vb2_queue);
 	struct frame_buffer *buf = container_of(vbuf, struct frame_buffer, vb);
 	unsigned long flags = 0;
 
-	spin_lock_irqsave(&isi->lock, flags);
+	spin_lock_irqsave(&isi->irqlock, flags);
 	list_add_tail(&buf->list, &isi->video_buffer_list);
 
 	if (isi->active == NULL) {
@@ -457,60 +431,83 @@ static void buffer_queue(struct vb2_buffer *vb)
 		if (vb2_is_streaming(vb->vb2_queue))
 			start_dma(isi, buf);
 	}
-	spin_unlock_irqrestore(&isi->lock, flags);
+	spin_unlock_irqrestore(&isi->irqlock, flags);
 }
 
 static int start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct atmel_isi *isi = ici->priv;
+	struct atmel_isi *isi = vb2_get_drv_priv(vq);
+	struct frame_buffer *buf, *node;
 	int ret;
 
-	pm_runtime_get_sync(ici->v4l2_dev.dev);
+	/* Enable stream on the sub device */
+	ret = v4l2_subdev_call(isi->entity.subdev, video, s_stream, 1);
+	if (ret && ret != -ENOIOCTLCMD) {
+		dev_err(isi->dev, "stream on failed in subdev\n");
+		goto err_start_stream;
+	}
+
+	pm_runtime_get_sync(isi->dev);
 
 	/* Reset ISI */
 	ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
 	if (ret < 0) {
-		dev_err(icd->parent, "Reset ISI timed out\n");
-		pm_runtime_put(ici->v4l2_dev.dev);
-		return ret;
+		dev_err(isi->dev, "Reset ISI timed out\n");
+		goto err_reset;
 	}
 	/* Disable all interrupts */
 	isi_writel(isi, ISI_INTDIS, (u32)~0UL);
 
-	configure_geometry(isi, icd->user_width, icd->user_height,
-				icd->current_fmt);
+	isi->sequence = 0;
+	configure_geometry(isi);
 
-	spin_lock_irq(&isi->lock);
+	spin_lock_irq(&isi->irqlock);
 	/* Clear any pending interrupt */
 	isi_readl(isi, ISI_STATUS);
 
-	if (count)
-		start_dma(isi, isi->active);
-	spin_unlock_irq(&isi->lock);
+	start_dma(isi, isi->active);
+	spin_unlock_irq(&isi->irqlock);
 
 	return 0;
+
+err_reset:
+	pm_runtime_put(isi->dev);
+	v4l2_subdev_call(isi->entity.subdev, video, s_stream, 0);
+
+err_start_stream:
+	spin_lock_irq(&isi->irqlock);
+	isi->active = NULL;
+	/* Release all active buffers */
+	list_for_each_entry_safe(buf, node, &isi->video_buffer_list, list) {
+		list_del_init(&buf->list);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
+	}
+	spin_unlock_irq(&isi->irqlock);
+
+	return ret;
 }
 
 /* abort streaming and wait for last buffer */
 static void stop_streaming(struct vb2_queue *vq)
 {
-	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct atmel_isi *isi = ici->priv;
+	struct atmel_isi *isi = vb2_get_drv_priv(vq);
 	struct frame_buffer *buf, *node;
 	int ret = 0;
 	unsigned long timeout;
 
-	spin_lock_irq(&isi->lock);
+	/* Disable stream on the sub device */
+	ret = v4l2_subdev_call(isi->entity.subdev, video, s_stream, 0);
+	if (ret && ret != -ENOIOCTLCMD)
+		dev_err(isi->dev, "stream off failed in subdev\n");
+
+	spin_lock_irq(&isi->irqlock);
 	isi->active = NULL;
 	/* Release all active buffers */
 	list_for_each_entry_safe(buf, node, &isi->video_buffer_list, list) {
 		list_del_init(&buf->list);
 		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
-	spin_unlock_irq(&isi->lock);
+	spin_unlock_irq(&isi->irqlock);
 
 	if (!isi->enable_preview_path) {
 		timeout = jiffies + FRAME_INTERVAL_MILLI_SEC * HZ;
@@ -520,7 +517,7 @@ static void stop_streaming(struct vb2_queue *vq)
 			msleep(1);
 
 		if (time_after(jiffies, timeout))
-			dev_err(icd->parent,
+			dev_err(isi->dev,
 				"Timeout waiting for finishing codec request\n");
 	}
 
@@ -531,9 +528,9 @@ static void stop_streaming(struct vb2_queue *vq)
 	/* Disable ISI and wait for it is done */
 	ret = atmel_isi_wait_status(isi, WAIT_ISI_DISABLE);
 	if (ret < 0)
-		dev_err(icd->parent, "Disable ISI timed out\n");
+		dev_err(isi->dev, "Disable ISI timed out\n");
 
-	pm_runtime_put(ici->v4l2_dev.dev);
+	pm_runtime_put(isi->dev);
 }
 
 static const struct vb2_ops isi_video_qops = {
@@ -548,380 +545,257 @@ static const struct vb2_ops isi_video_qops = {
 	.wait_finish		= vb2_ops_wait_finish,
 };
 
-/* ------------------------------------------------------------------
-	SOC camera operations for the device
-   ------------------------------------------------------------------*/
-static int isi_camera_init_videobuf(struct vb2_queue *q,
-				     struct soc_camera_device *icd)
+static int isi_g_fmt_vid_cap(struct file *file, void *priv,
+			      struct v4l2_format *fmt)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct atmel_isi *isi = video_drvdata(file);
 
-	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	q->io_modes = VB2_MMAP;
-	q->drv_priv = icd;
-	q->buf_struct_size = sizeof(struct frame_buffer);
-	q->ops = &isi_video_qops;
-	q->mem_ops = &vb2_dma_contig_memops;
-	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	q->lock = &ici->host_lock;
-	q->dev = ici->v4l2_dev.dev;
+	*fmt = isi->fmt;
 
-	return vb2_queue_init(q);
+	return 0;
 }
 
-static int isi_camera_set_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+static struct isi_format *find_format_by_fourcc(struct atmel_isi *isi,
+						 unsigned int fourcc)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	const struct soc_camera_format_xlate *xlate;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
+	unsigned int num_formats = isi->num_user_formats;
+	struct isi_format *fmt;
+	unsigned int i;
+
+	for (i = 0; i < num_formats; i++) {
+		fmt = isi->user_formats[i];
+		if (fmt->fourcc == fourcc)
+			return fmt;
+	}
+
+	return NULL;
+}
+
+static int isi_try_fmt(struct atmel_isi *isi, struct v4l2_format *f,
+			struct isi_format **current_fmt)
+{
+	struct isi_format *isi_fmt;
+	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
+	struct v4l2_subdev_pad_config pad_cfg;
 	struct v4l2_subdev_format format = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.which = V4L2_SUBDEV_FORMAT_TRY,
 	};
-	struct v4l2_mbus_framefmt *mf = &format.format;
 	int ret;
 
-	/* check with atmel-isi support format, if not support use YUYV */
-	if (!is_supported(icd, pix->pixelformat))
-		pix->pixelformat = V4L2_PIX_FMT_YUYV;
-
-	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
-	if (!xlate) {
-		dev_warn(icd->parent, "Format %x not found\n",
-			 pix->pixelformat);
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	}
 
-	dev_dbg(icd->parent, "Plan to set format %dx%d\n",
-			pix->width, pix->height);
+	isi_fmt = find_format_by_fourcc(isi, pixfmt->pixelformat);
+	if (!isi_fmt) {
+		isi_fmt = isi->user_formats[isi->num_user_formats - 1];
+		pixfmt->pixelformat = isi_fmt->fourcc;
+	}
 
-	mf->width	= pix->width;
-	mf->height	= pix->height;
-	mf->field	= pix->field;
-	mf->colorspace	= pix->colorspace;
-	mf->code	= xlate->code;
+	/* Limit to Atmel ISC hardware capabilities */
+	if (pixfmt->width > MAX_SUPPORT_WIDTH)
+		pixfmt->width = MAX_SUPPORT_WIDTH;
+	if (pixfmt->height > MAX_SUPPORT_HEIGHT)
+		pixfmt->height = MAX_SUPPORT_HEIGHT;
 
-	ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &format);
+	v4l2_fill_mbus_format(&format.format, pixfmt, isi_fmt->mbus_code);
+	ret = v4l2_subdev_call(isi->entity.subdev, pad, set_fmt,
+			       &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
-	if (mf->code != xlate->code)
-		return -EINVAL;
+	v4l2_fill_pix_format(pixfmt, &format.format);
 
-	pix->width		= mf->width;
-	pix->height		= mf->height;
-	pix->field		= mf->field;
-	pix->colorspace		= mf->colorspace;
-	icd->current_fmt	= xlate;
+	pixfmt->field = V4L2_FIELD_NONE;
+	pixfmt->bytesperline = pixfmt->width * isi_fmt->bpp;
+	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
 
-	dev_dbg(icd->parent, "Finally set format %dx%d\n",
-		pix->width, pix->height);
+	if (current_fmt)
+		*current_fmt = isi_fmt;
 
-	return ret;
+	return 0;
 }
 
-static int isi_camera_try_fmt(struct soc_camera_device *icd,
-			      struct v4l2_format *f)
+static int isi_set_fmt(struct atmel_isi *isi, struct v4l2_format *f)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	const struct soc_camera_format_xlate *xlate;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_subdev_pad_config pad_cfg;
 	struct v4l2_subdev_format format = {
-		.which = V4L2_SUBDEV_FORMAT_TRY,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
-	struct v4l2_mbus_framefmt *mf = &format.format;
-	u32 pixfmt = pix->pixelformat;
+	struct isi_format *current_fmt;
 	int ret;
 
-	/* check with atmel-isi support format, if not support use YUYV */
-	if (!is_supported(icd, pix->pixelformat))
-		pix->pixelformat = V4L2_PIX_FMT_YUYV;
-
-	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
-	if (pixfmt && !xlate) {
-		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
-		return -EINVAL;
-	}
-
-	/* limit to Atmel ISI hardware capabilities */
-	if (pix->height > MAX_SUPPORT_HEIGHT)
-		pix->height = MAX_SUPPORT_HEIGHT;
-	if (pix->width > MAX_SUPPORT_WIDTH)
-		pix->width = MAX_SUPPORT_WIDTH;
-
-	/* limit to sensor capabilities */
-	mf->width	= pix->width;
-	mf->height	= pix->height;
-	mf->field	= pix->field;
-	mf->colorspace	= pix->colorspace;
-	mf->code	= xlate->code;
+	ret = isi_try_fmt(isi, f, &current_fmt);
+	if (ret)
+		return ret;
 
-	ret = v4l2_subdev_call(sd, pad, set_fmt, &pad_cfg, &format);
+	v4l2_fill_mbus_format(&format.format, &f->fmt.pix,
+			      current_fmt->mbus_code);
+	ret = v4l2_subdev_call(isi->entity.subdev, pad,
+			       set_fmt, NULL, &format);
 	if (ret < 0)
 		return ret;
 
-	pix->width	= mf->width;
-	pix->height	= mf->height;
-	pix->colorspace	= mf->colorspace;
+	isi->fmt = *f;
+	isi->current_fmt = current_fmt;
 
-	switch (mf->field) {
-	case V4L2_FIELD_ANY:
-		pix->field = V4L2_FIELD_NONE;
-		break;
-	case V4L2_FIELD_NONE:
-		break;
-	default:
-		dev_err(icd->parent, "Field type %d unsupported.\n",
-			mf->field);
-		ret = -EINVAL;
-	}
-
-	return ret;
+	return 0;
 }
 
-static const struct soc_mbus_pixelfmt isi_camera_formats[] = {
-	{
-		.fourcc			= V4L2_PIX_FMT_YUYV,
-		.name			= "Packed YUV422 16 bit",
-		.bits_per_sample	= 8,
-		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
-		.order			= SOC_MBUS_ORDER_LE,
-		.layout			= SOC_MBUS_LAYOUT_PACKED,
-	},
-	{
-		.fourcc			= V4L2_PIX_FMT_RGB565,
-		.name			= "RGB565",
-		.bits_per_sample	= 8,
-		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
-		.order			= SOC_MBUS_ORDER_LE,
-		.layout			= SOC_MBUS_LAYOUT_PACKED,
-	},
-};
-
-/* This will be corrected as we get more formats */
-static bool isi_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
+static int isi_s_fmt_vid_cap(struct file *file, void *priv,
+			      struct v4l2_format *f)
 {
-	return	fmt->packing == SOC_MBUS_PACKING_NONE ||
-		(fmt->bits_per_sample == 8 &&
-		 fmt->packing == SOC_MBUS_PACKING_2X8_PADHI) ||
-		(fmt->bits_per_sample > 8 &&
-		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
+	struct atmel_isi *isi = video_drvdata(file);
+
+	if (vb2_is_streaming(&isi->queue))
+		return -EBUSY;
+
+	return isi_set_fmt(isi, f);
 }
 
-#define ISI_BUS_PARAM (V4L2_MBUS_MASTER |	\
-		V4L2_MBUS_HSYNC_ACTIVE_HIGH |	\
-		V4L2_MBUS_HSYNC_ACTIVE_LOW |	\
-		V4L2_MBUS_VSYNC_ACTIVE_HIGH |	\
-		V4L2_MBUS_VSYNC_ACTIVE_LOW |	\
-		V4L2_MBUS_PCLK_SAMPLE_RISING |	\
-		V4L2_MBUS_PCLK_SAMPLE_FALLING |	\
-		V4L2_MBUS_DATA_ACTIVE_HIGH)
-
-static int isi_camera_try_bus_param(struct soc_camera_device *icd,
-				    unsigned char buswidth)
+static int isi_try_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct atmel_isi *isi = ici->priv;
-	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
-	unsigned long common_flags;
-	int ret;
-
-	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
-	if (!ret) {
-		common_flags = soc_mbus_config_compatible(&cfg,
-							  ISI_BUS_PARAM);
-		if (!common_flags) {
-			dev_warn(icd->parent,
-				 "Flags incompatible: camera 0x%x, host 0x%x\n",
-				 cfg.flags, ISI_BUS_PARAM);
-			return -EINVAL;
-		}
-	} else if (ret != -ENOIOCTLCMD) {
-		return ret;
-	}
+	struct atmel_isi *isi = video_drvdata(file);
 
-	if ((1 << (buswidth - 1)) & isi->width_flags)
-		return 0;
-	return -EINVAL;
+	return isi_try_fmt(isi, f, NULL);
 }
 
-
-static int isi_camera_get_formats(struct soc_camera_device *icd,
-				  unsigned int idx,
-				  struct soc_camera_format_xlate *xlate)
+static int isi_enum_fmt_vid_cap(struct file *file, void  *priv,
+				struct v4l2_fmtdesc *f)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	int formats = 0, ret, i, n;
-	/* sensor format */
-	struct v4l2_subdev_mbus_code_enum code = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-		.index = idx,
-	};
-	/* soc camera host format */
-	const struct soc_mbus_pixelfmt *fmt;
+	struct atmel_isi *isi = video_drvdata(file);
 
-	ret = v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
-	if (ret < 0)
-		/* No more formats */
-		return 0;
-
-	fmt = soc_mbus_get_fmtdesc(code.code);
-	if (!fmt) {
-		dev_err(icd->parent,
-			"Invalid format code #%u: %d\n", idx, code.code);
-		return 0;
-	}
+	if (f->index >= isi->num_user_formats)
+		return -EINVAL;
 
-	/* This also checks support for the requested bits-per-sample */
-	ret = isi_camera_try_bus_param(icd, fmt->bits_per_sample);
-	if (ret < 0) {
-		dev_err(icd->parent,
-			"Fail to try the bus parameters.\n");
-		return 0;
-	}
+	f->pixelformat = isi->user_formats[f->index]->fourcc;
+	return 0;
+}
 
-	switch (code.code) {
-	case MEDIA_BUS_FMT_UYVY8_2X8:
-	case MEDIA_BUS_FMT_VYUY8_2X8:
-	case MEDIA_BUS_FMT_YUYV8_2X8:
-	case MEDIA_BUS_FMT_YVYU8_2X8:
-		n = ARRAY_SIZE(isi_camera_formats);
-		formats += n;
-		for (i = 0; xlate && i < n; i++, xlate++) {
-			xlate->host_fmt	= &isi_camera_formats[i];
-			xlate->code	= code.code;
-			dev_dbg(icd->parent, "Providing format %s using code %d\n",
-				xlate->host_fmt->name, xlate->code);
-		}
-		break;
-	default:
-		if (!isi_camera_packing_supported(fmt))
-			return 0;
-		if (xlate)
-			dev_dbg(icd->parent,
-				"Providing format %s in pass-through mode\n",
-				fmt->name);
-	}
+static int isi_querycap(struct file *file, void *priv,
+			struct v4l2_capability *cap)
+{
+	strlcpy(cap->driver, "atmel-isi", sizeof(cap->driver));
+	strlcpy(cap->card, "Atmel Image Sensor Interface", sizeof(cap->card));
+	strlcpy(cap->bus_info, "platform:isi", sizeof(cap->bus_info));
+	return 0;
+}
 
-	/* Generic pass-through */
-	formats++;
-	if (xlate) {
-		xlate->host_fmt	= fmt;
-		xlate->code	= code.code;
-		xlate++;
-	}
+static int isi_enum_input(struct file *file, void *priv,
+			   struct v4l2_input *i)
+{
+	if (i->index != 0)
+		return -EINVAL;
 
-	return formats;
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	strlcpy(i->name, "Camera", sizeof(i->name));
+	return 0;
 }
 
-static int isi_camera_add_device(struct soc_camera_device *icd)
+static int isi_g_input(struct file *file, void *priv, unsigned int *i)
 {
-	dev_dbg(icd->parent, "Atmel ISI Camera driver attached to camera %d\n",
-		 icd->devnum);
+	*i = 0;
+	return 0;
+}
 
+static int isi_s_input(struct file *file, void *priv, unsigned int i)
+{
+	if (i > 0)
+		return -EINVAL;
 	return 0;
 }
 
-static void isi_camera_remove_device(struct soc_camera_device *icd)
+static int isi_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 {
-	dev_dbg(icd->parent, "Atmel ISI Camera driver detached from camera %d\n",
-		 icd->devnum);
+	struct atmel_isi *isi = video_drvdata(file);
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	a->parm.capture.readbuffers = 2;
+	return v4l2_subdev_call(isi->entity.subdev, video, g_parm, a);
 }
 
-static unsigned int isi_camera_poll(struct file *file, poll_table *pt)
+static int isi_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 {
-	struct soc_camera_device *icd = file->private_data;
+	struct atmel_isi *isi = video_drvdata(file);
 
-	return vb2_poll(&icd->vb2_vidq, file, pt);
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	a->parm.capture.readbuffers = 2;
+	return v4l2_subdev_call(isi->entity.subdev, video, s_parm, a);
 }
 
-static int isi_camera_querycap(struct soc_camera_host *ici,
-			       struct v4l2_capability *cap)
+static int isi_enum_framesizes(struct file *file, void *fh,
+			       struct v4l2_frmsizeenum *fsize)
 {
-	strcpy(cap->driver, "atmel-isi");
-	strcpy(cap->card, "Atmel Image Sensor Interface");
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	struct atmel_isi *isi = video_drvdata(file);
+	const struct isi_format *isi_fmt;
+	struct v4l2_subdev_frame_size_enum fse = {
+		.index = fsize->index,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	int ret;
+
+	isi_fmt = find_format_by_fourcc(isi, fsize->pixel_format);
+	if (!isi_fmt)
+		return -EINVAL;
+
+	fse.code = isi_fmt->mbus_code;
+
+	ret = v4l2_subdev_call(isi->entity.subdev, pad, enum_frame_size,
+			       NULL, &fse);
+	if (ret)
+		return ret;
+
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width = fse.max_width;
+	fsize->discrete.height = fse.max_height;
 
 	return 0;
 }
 
-static int isi_camera_set_bus_param(struct soc_camera_device *icd)
+static int isi_enum_frameintervals(struct file *file, void *fh,
+				    struct v4l2_frmivalenum *fival)
 {
-	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	struct atmel_isi *isi = ici->priv;
-	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
-	unsigned long common_flags;
+	struct atmel_isi *isi = video_drvdata(file);
+	const struct isi_format *isi_fmt;
+	struct v4l2_subdev_frame_interval_enum fie = {
+		.index = fival->index,
+		.width = fival->width,
+		.height = fival->height,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
 	int ret;
-	u32 cfg1 = 0;
 
-	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
-	if (!ret) {
-		common_flags = soc_mbus_config_compatible(&cfg,
-							  ISI_BUS_PARAM);
-		if (!common_flags) {
-			dev_warn(icd->parent,
-				 "Flags incompatible: camera 0x%x, host 0x%x\n",
-				 cfg.flags, ISI_BUS_PARAM);
-			return -EINVAL;
-		}
-	} else if (ret != -ENOIOCTLCMD) {
+	isi_fmt = find_format_by_fourcc(isi, fival->pixel_format);
+	if (!isi_fmt)
+		return -EINVAL;
+
+	fie.code = isi_fmt->mbus_code;
+
+	ret = v4l2_subdev_call(isi->entity.subdev, pad,
+			       enum_frame_interval, NULL, &fie);
+	if (ret)
 		return ret;
-	} else {
-		common_flags = ISI_BUS_PARAM;
-	}
-	dev_dbg(icd->parent, "Flags cam: 0x%x host: 0x%x common: 0x%lx\n",
-		cfg.flags, ISI_BUS_PARAM, common_flags);
-
-	/* Make choises, based on platform preferences */
-	if ((common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH) &&
-	    (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)) {
-		if (isi->pdata.hsync_act_low)
-			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_HIGH;
-		else
-			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_LOW;
-	}
 
-	if ((common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH) &&
-	    (common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)) {
-		if (isi->pdata.vsync_act_low)
-			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_HIGH;
-		else
-			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_LOW;
-	}
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete = fie.interval;
 
-	if ((common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING) &&
-	    (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)) {
-		if (isi->pdata.pclk_act_falling)
-			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_RISING;
-		else
-			common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_FALLING;
-	}
+	return 0;
+}
 
-	cfg.flags = common_flags;
-	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
-	if (ret < 0 && ret != -ENOIOCTLCMD) {
-		dev_dbg(icd->parent, "camera s_mbus_config(0x%lx) returned %d\n",
-			common_flags, ret);
-		return ret;
-	}
+static void isi_camera_set_bus_param(struct atmel_isi *isi)
+{
+	u32 cfg1 = 0;
 
 	/* set bus param for ISI */
-	if (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+	if (isi->pdata.hsync_act_low)
 		cfg1 |= ISI_CFG1_HSYNC_POL_ACTIVE_LOW;
-	if (common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+	if (isi->pdata.vsync_act_low)
 		cfg1 |= ISI_CFG1_VSYNC_POL_ACTIVE_LOW;
-	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+	if (isi->pdata.pclk_act_falling)
 		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
-
-	dev_dbg(icd->parent, "vsync active %s, hsync active %s, sampling on pix clock %s edge\n",
-		common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? "low" : "high",
-		common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? "low" : "high",
-		common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING ? "falling" : "rising");
-
 	if (isi->pdata.has_emb_sync)
 		cfg1 |= ISI_CFG1_EMB_SYNC;
 	if (isi->pdata.full_mode)
@@ -930,50 +804,19 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 	cfg1 |= ISI_CFG1_THMASK_BEATS_16;
 
 	/* Enable PM and peripheral clock before operate isi registers */
-	pm_runtime_get_sync(ici->v4l2_dev.dev);
+	pm_runtime_get_sync(isi->dev);
 
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
 	isi_writel(isi, ISI_CFG1, cfg1);
 
-	pm_runtime_put(ici->v4l2_dev.dev);
-
-	return 0;
+	pm_runtime_put(isi->dev);
 }
 
-static struct soc_camera_host_ops isi_soc_camera_host_ops = {
-	.owner		= THIS_MODULE,
-	.add		= isi_camera_add_device,
-	.remove		= isi_camera_remove_device,
-	.set_fmt	= isi_camera_set_fmt,
-	.try_fmt	= isi_camera_try_fmt,
-	.get_formats	= isi_camera_get_formats,
-	.init_videobuf2	= isi_camera_init_videobuf,
-	.poll		= isi_camera_poll,
-	.querycap	= isi_camera_querycap,
-	.set_bus_param	= isi_camera_set_bus_param,
-};
-
 /* -----------------------------------------------------------------------*/
-static int atmel_isi_remove(struct platform_device *pdev)
-{
-	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
-	struct atmel_isi *isi = container_of(soc_host,
-					struct atmel_isi, soc_host);
-
-	soc_camera_host_unregister(soc_host);
-	dma_free_coherent(&pdev->dev,
-			sizeof(struct fbd) * MAX_BUFFER_NUM,
-			isi->p_fb_descriptors,
-			isi->fb_descriptors_phys);
-	pm_runtime_disable(&pdev->dev);
-
-	return 0;
-}
-
 static int atmel_isi_parse_dt(struct atmel_isi *isi,
 			struct platform_device *pdev)
 {
-	struct device_node *np= pdev->dev.of_node;
+	struct device_node *np = pdev->dev.of_node;
 	struct v4l2_of_endpoint ep;
 	int err;
 
@@ -1021,13 +864,335 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
 	return 0;
 }
 
+static int isi_open(struct file *file)
+{
+	struct atmel_isi *isi = video_drvdata(file);
+	struct v4l2_subdev *sd = isi->entity.subdev;
+	int ret;
+
+	if (mutex_lock_interruptible(&isi->lock))
+		return -ERESTARTSYS;
+
+	ret = v4l2_fh_open(file);
+	if (ret < 0)
+		goto unlock;
+
+	if (!v4l2_fh_is_singular_file(file))
+		goto fh_rel;
+
+	ret = v4l2_subdev_call(sd, core, s_power, 1);
+	if (ret < 0 && ret != -ENOIOCTLCMD)
+		goto fh_rel;
+
+	ret = isi_set_fmt(isi, &isi->fmt);
+	if (ret)
+		v4l2_subdev_call(sd, core, s_power, 0);
+fh_rel:
+	if (ret)
+		v4l2_fh_release(file);
+unlock:
+	mutex_unlock(&isi->lock);
+	return ret;
+}
+
+static int isi_release(struct file *file)
+{
+	struct atmel_isi *isi = video_drvdata(file);
+	struct v4l2_subdev *sd = isi->entity.subdev;
+	bool fh_singular;
+	int ret;
+
+	mutex_lock(&isi->lock);
+
+	fh_singular = v4l2_fh_is_singular_file(file);
+
+	ret = _vb2_fop_release(file, NULL);
+
+	if (fh_singular)
+		v4l2_subdev_call(sd, core, s_power, 0);
+
+	mutex_unlock(&isi->lock);
+
+	return ret;
+}
+
+static const struct v4l2_ioctl_ops isi_ioctl_ops = {
+	.vidioc_querycap		= isi_querycap,
+
+	.vidioc_try_fmt_vid_cap		= isi_try_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= isi_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap		= isi_s_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_cap	= isi_enum_fmt_vid_cap,
+
+	.vidioc_enum_input		= isi_enum_input,
+	.vidioc_g_input			= isi_g_input,
+	.vidioc_s_input			= isi_s_input,
+
+	.vidioc_g_parm			= isi_g_parm,
+	.vidioc_s_parm			= isi_s_parm,
+	.vidioc_enum_framesizes		= isi_enum_framesizes,
+	.vidioc_enum_frameintervals	= isi_enum_frameintervals,
+
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+};
+
+static const struct v4l2_file_operations isi_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= video_ioctl2,
+	.open		= isi_open,
+	.release	= isi_release,
+	.poll		= vb2_fop_poll,
+	.mmap		= vb2_fop_mmap,
+	.read		= vb2_fop_read,
+};
+
+static int isi_set_default_fmt(struct atmel_isi *isi)
+{
+	struct v4l2_format f = {
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+		.fmt.pix = {
+			.width		= VGA_WIDTH,
+			.height		= VGA_HEIGHT,
+			.field		= V4L2_FIELD_NONE,
+			.pixelformat	= isi->user_formats[0]->fourcc,
+		},
+	};
+	int ret;
+
+	ret = isi_try_fmt(isi, &f, NULL);
+	if (ret)
+		return ret;
+	isi->current_fmt = isi->user_formats[0];
+	isi->fmt = f;
+	return 0;
+}
+
+static struct isi_format *find_format_by_code(unsigned int code, int *index)
+{
+	struct isi_format *fmt = &isi_formats[0];
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(isi_formats); i++) {
+		if (fmt->mbus_code == code && !fmt->support && !fmt->skip) {
+			*index = i;
+			return fmt;
+		}
+
+		fmt++;
+	}
+
+	return NULL;
+}
+
+static int isi_formats_init(struct atmel_isi *isi)
+{
+	struct isi_format *fmt;
+	struct v4l2_subdev *subdev = isi->entity.subdev;
+	int num_fmts = 0, i, j;
+	struct v4l2_subdev_mbus_code_enum mbus_code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+
+	fmt = &isi_formats[0];
+
+	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
+	       NULL, &mbus_code)) {
+		fmt = find_format_by_code(mbus_code.code, &i);
+		if (!fmt) {
+			mbus_code.index++;
+			continue;
+		}
+
+		fmt->support = true;
+		for (i = 0; i < ARRAY_SIZE(isi_formats); i++)
+			if (isi_formats[i].fourcc == fmt->fourcc &&
+			    !isi_formats[i].support)
+				isi_formats[i].skip = true;
+		num_fmts++;
+	}
+
+	if (!num_fmts)
+		return -ENXIO;
+
+	isi->num_user_formats = num_fmts;
+	isi->user_formats = devm_kcalloc(isi->dev,
+					 num_fmts, sizeof(struct isi_format *),
+					 GFP_KERNEL);
+	if (!isi->user_formats) {
+		dev_err(isi->dev, "could not allocate memory\n");
+		return -ENOMEM;
+	}
+
+	fmt = &isi_formats[0];
+	for (i = 0, j = 0; i < ARRAY_SIZE(isi_formats); i++) {
+		if (fmt->support)
+			isi->user_formats[j++] = fmt;
+
+		fmt++;
+	}
+	isi->current_fmt = isi->user_formats[0];
+
+	return 0;
+}
+
+static int isi_graph_notify_complete(struct v4l2_async_notifier *notifier)
+{
+	struct atmel_isi *isi = notifier_to_isi(notifier);
+	int ret;
+
+	isi->vdev->ctrl_handler	= isi->entity.subdev->ctrl_handler;
+	ret = isi_formats_init(isi);
+	if (ret) {
+		dev_err(isi->dev, "No supported mediabus format found\n");
+		return ret;
+	}
+	isi_camera_set_bus_param(isi);
+
+	ret = isi_set_default_fmt(isi);
+	if (ret) {
+		dev_err(isi->dev, "Could not set default format\n");
+		return ret;
+	}
+
+	ret = video_register_device(isi->vdev, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		dev_err(isi->dev, "Failed to register video device\n");
+		return ret;
+	}
+
+	dev_dbg(isi->dev, "Device registered as %s\n",
+		video_device_node_name(isi->vdev));
+	return 0;
+}
+
+static void isi_graph_notify_unbind(struct v4l2_async_notifier *notifier,
+				     struct v4l2_subdev *sd,
+				     struct v4l2_async_subdev *asd)
+{
+	struct atmel_isi *isi = notifier_to_isi(notifier);
+
+	dev_dbg(isi->dev, "Removing %s\n", video_device_node_name(isi->vdev));
+
+	/* Checks internaly if vdev have been init or not */
+	video_unregister_device(isi->vdev);
+}
+
+static int isi_graph_notify_bound(struct v4l2_async_notifier *notifier,
+				   struct v4l2_subdev *subdev,
+				   struct v4l2_async_subdev *asd)
+{
+	struct atmel_isi *isi = notifier_to_isi(notifier);
+
+	dev_dbg(isi->dev, "subdev %s bound\n", subdev->name);
+
+	isi->entity.subdev = subdev;
+
+	return 0;
+}
+
+static int isi_graph_parse(struct atmel_isi *isi, struct device_node *node)
+{
+	struct device_node *remote;
+	struct device_node *ep = NULL;
+	int ret = 0;
+
+	while (1) {
+		ep = of_graph_get_next_endpoint(node, ep);
+		if (!ep)
+			break;
+
+		if (ret) {
+			dev_err(isi->dev,
+				"More then one subdev found in graph\n");
+			of_node_put(ep);
+			return -EINVAL;
+		}
+
+		remote = of_graph_get_remote_port_parent(ep);
+		if (!remote) {
+			of_node_put(ep);
+			return -EINVAL;
+		}
+
+		/* Remote node to connect */
+		isi->entity.node = remote;
+		isi->entity.asd.match_type = V4L2_ASYNC_MATCH_OF;
+		isi->entity.asd.match.of.node = remote;
+		ret++;
+	}
+
+	return ret;
+}
+
+static int isi_graph_init(struct atmel_isi *isi)
+{
+	struct v4l2_async_subdev **subdevs = NULL;
+	int ret;
+
+	/* Parse the graph to extract a list of subdevice DT nodes. */
+	ret = isi_graph_parse(isi, isi->dev->of_node);
+	if (ret < 0) {
+		dev_err(isi->dev, "Graph parsing failed\n");
+		goto done;
+	}
+
+	if (!ret) {
+		dev_err(isi->dev, "No subdev found in graph\n");
+		goto done;
+	}
+
+	/* Register the subdevices notifier. */
+	subdevs = devm_kzalloc(isi->dev, sizeof(*subdevs), GFP_KERNEL);
+	if (subdevs == NULL) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	subdevs[0] = &isi->entity.asd;
+
+	isi->notifier.subdevs = subdevs;
+	isi->notifier.num_subdevs = 1;
+	isi->notifier.bound = isi_graph_notify_bound;
+	isi->notifier.unbind = isi_graph_notify_unbind;
+	isi->notifier.complete = isi_graph_notify_complete;
+
+	ret = v4l2_async_notifier_register(&isi->v4l2_dev, &isi->notifier);
+	if (ret < 0) {
+		dev_err(isi->dev, "Notifier registration failed\n");
+		goto done;
+	}
+
+	ret = 0;
+
+done:
+	if (ret < 0) {
+		v4l2_async_notifier_unregister(&isi->notifier);
+		of_node_put(isi->entity.node);
+	}
+
+	return ret;
+}
+
+
 static int atmel_isi_probe(struct platform_device *pdev)
 {
 	int irq;
 	struct atmel_isi *isi;
+	struct vb2_queue *q;
 	struct resource *regs;
 	int ret, i;
-	struct soc_camera_host *soc_host;
 
 	isi = devm_kzalloc(&pdev->dev, sizeof(struct atmel_isi), GFP_KERNEL);
 	if (!isi) {
@@ -1044,20 +1209,65 @@ static int atmel_isi_probe(struct platform_device *pdev)
 		return ret;
 
 	isi->active = NULL;
-	spin_lock_init(&isi->lock);
+	isi->dev = &pdev->dev;
+	mutex_init(&isi->lock);
+	spin_lock_init(&isi->irqlock);
 	INIT_LIST_HEAD(&isi->video_buffer_list);
 	INIT_LIST_HEAD(&isi->dma_desc_head);
 
+	q = &isi->queue;
+
+	/* Initialize the top-level structure */
+	ret = v4l2_device_register(&pdev->dev, &isi->v4l2_dev);
+	if (ret)
+		return ret;
+
+	isi->vdev = video_device_alloc();
+	if (isi->vdev == NULL) {
+		ret = -ENOMEM;
+		goto err_vdev_alloc;
+	}
+
+	/* video node */
+	isi->vdev->fops = &isi_fops;
+	isi->vdev->v4l2_dev = &isi->v4l2_dev;
+	isi->vdev->queue = &isi->queue;
+	strlcpy(isi->vdev->name, KBUILD_MODNAME, sizeof(isi->vdev->name));
+	isi->vdev->release = video_device_release;
+	isi->vdev->ioctl_ops = &isi_ioctl_ops;
+	isi->vdev->lock = &isi->lock;
+	isi->vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+		V4L2_CAP_READWRITE;
+	video_set_drvdata(isi->vdev, isi);
+
+	/* buffer queue */
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_READ | VB2_DMABUF;
+	q->lock = &isi->lock;
+	q->drv_priv = isi;
+	q->buf_struct_size = sizeof(struct frame_buffer);
+	q->ops = &isi_video_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->min_buffers_needed = 2;
+	q->dev = &pdev->dev;
+
+	ret = vb2_queue_init(q);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to initialize VB2 queue\n");
+		goto err_vb2_queue;
+	}
 	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
-				sizeof(struct fbd) * MAX_BUFFER_NUM,
+				sizeof(struct fbd) * VIDEO_MAX_FRAME,
 				&isi->fb_descriptors_phys,
 				GFP_KERNEL);
 	if (!isi->p_fb_descriptors) {
 		dev_err(&pdev->dev, "Can't allocate descriptors!\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_dma_alloc;
 	}
 
-	for (i = 0; i < MAX_BUFFER_NUM; i++) {
+	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
 		isi->dma_desc[i].p_fbd = isi->p_fb_descriptors + i;
 		isi->dma_desc[i].fbd_phys = isi->fb_descriptors_phys +
 					i * sizeof(struct fbd);
@@ -1089,41 +1299,49 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	}
 	isi->irq = irq;
 
-	soc_host		= &isi->soc_host;
-	soc_host->drv_name	= "isi-camera";
-	soc_host->ops		= &isi_soc_camera_host_ops;
-	soc_host->priv		= isi;
-	soc_host->v4l2_dev.dev	= &pdev->dev;
-	soc_host->nr		= pdev->id;
+	ret = isi_graph_init(isi);
+	if (ret < 0)
+		goto err_req_irq;
 
 	pm_suspend_ignore_children(&pdev->dev, true);
 	pm_runtime_enable(&pdev->dev);
-
-	ret = soc_camera_host_register(soc_host);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to register soc camera host\n");
-		goto err_register_soc_camera_host;
-	}
+	platform_set_drvdata(pdev, isi);
 	return 0;
 
-err_register_soc_camera_host:
-	pm_runtime_disable(&pdev->dev);
 err_req_irq:
 err_ioremap:
 	dma_free_coherent(&pdev->dev,
-			sizeof(struct fbd) * MAX_BUFFER_NUM,
+			sizeof(struct fbd) * VIDEO_MAX_FRAME,
 			isi->p_fb_descriptors,
 			isi->fb_descriptors_phys);
+err_dma_alloc:
+err_vb2_queue:
+	video_device_release(isi->vdev);
+err_vdev_alloc:
+	v4l2_device_unregister(&isi->v4l2_dev);
 
 	return ret;
 }
 
+static int atmel_isi_remove(struct platform_device *pdev)
+{
+	struct atmel_isi *isi = platform_get_drvdata(pdev);
+
+	dma_free_coherent(&pdev->dev,
+			sizeof(struct fbd) * VIDEO_MAX_FRAME,
+			isi->p_fb_descriptors,
+			isi->fb_descriptors_phys);
+	pm_runtime_disable(&pdev->dev);
+	v4l2_async_notifier_unregister(&isi->notifier);
+	v4l2_device_unregister(&isi->v4l2_dev);
+
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static int atmel_isi_runtime_suspend(struct device *dev)
 {
-	struct soc_camera_host *soc_host = to_soc_camera_host(dev);
-	struct atmel_isi *isi = container_of(soc_host,
-					struct atmel_isi, soc_host);
+	struct atmel_isi *isi = dev_get_drvdata(dev);
 
 	clk_disable_unprepare(isi->pclk);
 
@@ -1131,9 +1349,7 @@ static int atmel_isi_runtime_suspend(struct device *dev)
 }
 static int atmel_isi_runtime_resume(struct device *dev)
 {
-	struct soc_camera_host *soc_host = to_soc_camera_host(dev);
-	struct atmel_isi *isi = container_of(soc_host,
-					struct atmel_isi, soc_host);
+	struct atmel_isi *isi = dev_get_drvdata(dev);
 
 	return clk_prepare_enable(isi->pclk);
 }
@@ -1151,15 +1367,16 @@ static const struct of_device_id atmel_isi_of_match[] = {
 MODULE_DEVICE_TABLE(of, atmel_isi_of_match);
 
 static struct platform_driver atmel_isi_driver = {
-	.remove		= atmel_isi_remove,
 	.driver		= {
 		.name = "atmel_isi",
 		.of_match_table = of_match_ptr(atmel_isi_of_match),
 		.pm	= &atmel_isi_dev_pm_ops,
 	},
+	.probe		= atmel_isi_probe,
+	.remove		= atmel_isi_remove,
 };
 
-module_platform_driver_probe(atmel_isi_driver, atmel_isi_probe);
+module_platform_driver(atmel_isi_driver);
 
 MODULE_AUTHOR("Josh Wu <josh.wu@atmel.com>");
 MODULE_DESCRIPTION("The V4L2 driver for Atmel Linux");
-- 
2.11.0
