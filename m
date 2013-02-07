Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:48165 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756261Ab3BGMGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Feb 2013 07:06:21 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [REVIEW PATCH V4 10/12] [media] marvell-ccic: add soc_camera support for marvell-ccic driver
Date: Thu,  7 Feb 2013 20:04:45 +0800
Message-Id: <1360238687-15768-11-git-send-email-twang13@marvell.com>
In-Reply-To: <1360238687-15768-1-git-send-email-twang13@marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the soc_camera mode support in marvell-ccic driver.
It also removes the old mode for maintaining single mode in the future.

Signed-off-by: Libin Yang <lbyang@marvell.com>
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 drivers/media/platform/Makefile                  |    4 +-
 drivers/media/platform/marvell-ccic/Kconfig      |    6 +-
 drivers/media/platform/marvell-ccic/mcam-core.c  | 1084 +++++++---------------
 drivers/media/platform/marvell-ccic/mcam-core.h  |   27 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c |   73 +-
 include/media/mmp-camera.h                       |    5 +
 6 files changed, 402 insertions(+), 797 deletions(-)

diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 4817d28..1a345c8 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -11,8 +11,6 @@ obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
 obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
 
 obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
-obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
-obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
 
 obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
@@ -43,6 +41,8 @@ obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 
 obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
+obj-$(CONFIG_VIDEO_CAFE_CCIC)		+= marvell-ccic/
+obj-$(CONFIG_VIDEO_MMP_CAMERA)		+= marvell-ccic/
 
 obj-y	+= davinci/
 
diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index bf739e3..7fa3c62 100755
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -10,14 +10,14 @@ config VIDEO_CAFE_CCIC
 	  generation OLPC systems.
 
 config VIDEO_MMP_CAMERA
-	tristate "Marvell Armada 610 integrated camera controller support"
+	tristate "Marvell Armada integrated camera controller support"
 	depends on ARCH_MMP && I2C && VIDEO_V4L2
-	select VIDEO_OV7670
 	select I2C_GPIO
+	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_DMA_SG
 	---help---
 	  This is a Video4Linux2 driver for the integrated camera
-	  controller found on Marvell Armada 610 application
+	  controller found on Marvell Armada application
 	  processors (and likely beyond).  This is the controller found
 	  in OLPC XO 1.75 systems.
 
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index b668f2b..16ba045 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -24,10 +24,11 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
-#include <media/ov7670.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-dma-sg.h>
+#include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 
 #include "mcam-core.h"
 
@@ -99,84 +100,38 @@ MODULE_PARM_DESC(buffer_mode,
 #define CF_FRAME_SOF2	 9
 
 #define sensor_call(cam, o, f, args...) \
-	v4l2_subdev_call(cam->sensor, o, f, ##args)
-
-static struct mcam_format_struct {
-	__u8 *desc;
-	__u32 pixelformat;
-	int bpp;   /* Bytes per pixel */
-	bool planar;
-	enum v4l2_mbus_pixelcode mbus_code;
-} mcam_formats[] = {
-	{
-		.desc		= "YUYV 4:2:2",
-		.pixelformat	= V4L2_PIX_FMT_YUYV,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
-		.bpp		= 2,
-		.planar		= false,
-	},
-	{
-		.desc		= "UYVY 4:2:2",
-		.pixelformat	= V4L2_PIX_FMT_UYVY,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
-		.bpp		= 2,
-		.planar		= false,
-	},
-	{
-		.desc		= "YUV 4:2:2 PLANAR",
-		.pixelformat	= V4L2_PIX_FMT_YUV422P,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
-		.bpp		= 2,
-		.planar		= true,
-	},
-	{
-		.desc		= "YUV 4:2:0 PLANAR",
-		.pixelformat	= V4L2_PIX_FMT_YUV420,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
-		.bpp		= 2,
-		.planar		= true,
-	},
+	v4l2_subdev_call(soc_camera_to_subdev(cam->icd), o, f, ##args)
+
+static const struct soc_mbus_pixelfmt mcam_formats[] = {
 	{
-		.desc		= "YVU 4:2:0 PLANAR",
-		.pixelformat	= V4L2_PIX_FMT_YVU420,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
-		.bpp		= 2,
-		.planar		= true,
+		.fourcc = V4L2_PIX_FMT_UYVY,
+		.name = "YUV422PACKED",
+		.bits_per_sample = 8,
+		.packing = SOC_MBUS_PACKING_2X8_PADLO,
+		.order = SOC_MBUS_ORDER_LE,
 	},
 	{
-		.desc		= "RGB 444",
-		.pixelformat	= V4L2_PIX_FMT_RGB444,
-		.mbus_code	= V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
-		.bpp		= 2,
-		.planar		= false,
+		.fourcc = V4L2_PIX_FMT_YUV422P,
+		.name = "YUV422PLANAR",
+		.bits_per_sample = 8,
+		.packing = SOC_MBUS_PACKING_2X8_PADLO,
+		.order = SOC_MBUS_ORDER_LE,
 	},
 	{
-		.desc		= "RGB 565",
-		.pixelformat	= V4L2_PIX_FMT_RGB565,
-		.mbus_code	= V4L2_MBUS_FMT_RGB565_2X8_LE,
-		.bpp		= 2,
-		.planar		= false,
+		.fourcc = V4L2_PIX_FMT_YUV420,
+		.name = "YUV420PLANAR",
+		.bits_per_sample = 12,
+		.packing = SOC_MBUS_PACKING_NONE,
+		.order = SOC_MBUS_ORDER_LE,
 	},
 	{
-		.desc		= "Raw RGB Bayer",
-		.pixelformat	= V4L2_PIX_FMT_SBGGR8,
-		.mbus_code	= V4L2_MBUS_FMT_SBGGR8_1X8,
-		.bpp		= 1,
-		.planar		= false,
+		.fourcc = V4L2_PIX_FMT_YVU420,
+		.name = "YVU420PLANAR",
+		.bits_per_sample = 12,
+		.packing = SOC_MBUS_PACKING_NONE,
+		.order = SOC_MBUS_ORDER_LE,
 	},
 };
-#define N_MCAM_FMTS ARRAY_SIZE(mcam_formats)
-
-static struct mcam_format_struct *mcam_find_format(u32 pixelformat)
-{
-	unsigned i;
-
-	for (i = 0; i < N_MCAM_FMTS; i++)
-		if (mcam_formats[i].pixelformat == pixelformat)
-			return mcam_formats + i;
-	/* Not found? Then return the first format. */
-	return mcam_formats;
-}
 
 /*
  * The default format we use until somebody says otherwise.
@@ -507,10 +462,23 @@ static inline int mcam_check_dma_buffers(struct mcam_camera *cam)
 
 static bool mcam_fmt_is_planar(__u32 pfmt)
 {
-	struct mcam_format_struct *f;
-
-	f = mcam_find_format(pfmt);
-	return f->planar;
+	switch (pfmt) {
+	case V4L2_PIX_FMT_YVU410:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_YYUV:
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+		return false;
+	case V4L2_PIX_FMT_YVU420:	/* Need check here */
+	case V4L2_PIX_FMT_YUV420:	/* Need check here */
+	case V4L2_PIX_FMT_YUV422P:
+	case V4L2_PIX_FMT_NV12M:
+	case V4L2_PIX_FMT_YUV420M:
+		return true;
+	default:
+		return false;
+	}
 }
 
 /*
@@ -827,31 +795,6 @@ static void mcam_ctlr_irq_disable(struct mcam_camera *cam)
 	mcam_reg_clear_bit(cam, REG_IRQMASK, FRAMEIRQS);
 }
 
-
-
-static void mcam_ctlr_init(struct mcam_camera *cam)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	/*
-	 * Make sure it's not powered down.
-	 */
-	mcam_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
-	/*
-	 * Turn off the enable bit.  It sure should be off anyway,
-	 * but it's good to be sure.
-	 */
-	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
-	/*
-	 * Clock the sensor appropriately.  Controller clock should
-	 * be 48MHz, sensor "typical" value is half that.
-	 */
-	mcam_reg_write_mask(cam, REG_CLKCTRL, 2, CLK_DIV_MASK);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-}
-
-
 /*
  * Stop the controller, and don't return until we're really sure that no
  * further DMA is going on.
@@ -926,43 +869,6 @@ static int __mcam_cam_reset(struct mcam_camera *cam)
 }
 
 /*
- * We have found the sensor on the i2c.  Let's try to have a
- * conversation.
- */
-static int mcam_cam_init(struct mcam_camera *cam)
-{
-	struct v4l2_dbg_chip_ident chip;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	if (cam->state != S_NOTREADY)
-		cam_warn(cam, "Cam init with device in funky state %d",
-				cam->state);
-	ret = __mcam_cam_reset(cam);
-	if (ret)
-		goto out;
-	chip.ident = V4L2_IDENT_NONE;
-	chip.match.type = V4L2_CHIP_MATCH_I2C_ADDR;
-	chip.match.addr = cam->sensor_addr;
-	ret = sensor_call(cam, core, g_chip_ident, &chip);
-	if (ret)
-		goto out;
-	cam->sensor_type = chip.ident;
-	if (cam->sensor_type != V4L2_IDENT_OV7670) {
-		cam_err(cam, "Unsupported sensor type 0x%x", cam->sensor_type);
-		ret = -EINVAL;
-		goto out;
-	}
-/* Get/set parameters? */
-	ret = 0;
-	cam->state = S_IDLE;
-out:
-	mcam_ctlr_power_down(cam);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-/*
  * Configure the sensor to match the parameters we have.  Caller should
  * hold s_mutex
  */
@@ -1050,7 +956,7 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
 		unsigned int *num_planes, unsigned int sizes[],
 		void *alloc_ctxs[])
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	struct mcam_camera *cam = vq_to_mcam(vq);
 	unsigned int minbufs = (cam->buffer_mode == B_DMA_CONTIG) ? 3 : 2;
 
 	sizes[0] = cam->pix_format.sizeimage;
@@ -1066,14 +972,17 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
 static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = vq_to_mcam(vb->vb2_queue);
 	struct v4l2_pix_format *fmt = &cam->pix_format;
 	unsigned long flags;
 	int start;
 	dma_addr_t dma_handle;
+	unsigned long size;
 	u32 pixel_count = fmt->width * fmt->height;
 
 	spin_lock_irqsave(&cam->dev_lock, flags);
+	size = vb2_plane_size(vb, 0);
+	vb2_set_plane_payload(vb, 0, size);
 	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
 	BUG_ON(!dma_handle);
 	start = (cam->state == S_BUFWAIT) && !list_empty(&cam->buffers);
@@ -1112,14 +1021,14 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
  */
 static void mcam_vb_wait_prepare(struct vb2_queue *vq)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	struct mcam_camera *cam = vq_to_mcam(vq);
 
 	mutex_unlock(&cam->s_mutex);
 }
 
 static void mcam_vb_wait_finish(struct vb2_queue *vq)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	struct mcam_camera *cam = vq_to_mcam(vq);
 
 	mutex_lock(&cam->s_mutex);
 }
@@ -1129,9 +1038,12 @@ static void mcam_vb_wait_finish(struct vb2_queue *vq)
  */
 static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	struct mcam_camera *cam = vq_to_mcam(vq);
 	unsigned int frame;
 
+	if (count < 2)
+		return -EINVAL;
+
 	if (cam->state != S_IDLE) {
 		INIT_LIST_HEAD(&cam->buffers);
 		return -EINVAL;
@@ -1161,7 +1073,7 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	struct mcam_camera *cam = vq_to_mcam(vq);
 	unsigned long flags;
 
 	if (cam->state == S_BUFWAIT) {
@@ -1172,6 +1084,7 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 	if (cam->state != S_STREAMING)
 		return -EINVAL;
 	mcam_ctlr_stop_dma(cam);
+	cam->state = S_IDLE;
 	/*
 	 * Reset the CCIC PHY after stopping streaming,
 	 * otherwise, the CCIC may be unstable.
@@ -1207,7 +1120,7 @@ static const struct vb2_ops mcam_vb2_ops = {
 static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = vq_to_mcam(vb->vb2_queue);
 	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
 
 	mvb->dma_desc = dma_alloc_coherent(cam->dev,
@@ -1223,7 +1136,7 @@ static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
 static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = vq_to_mcam(vb->vb2_queue);
 	struct vb2_dma_sg_desc *sgd = vb2_dma_sg_plane_desc(vb, 0);
 	struct mcam_dma_desc *desc = mvb->dma_desc;
 	struct scatterlist *sg;
@@ -1243,7 +1156,7 @@ static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 
 static int mcam_vb_sg_buf_finish(struct vb2_buffer *vb)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = vq_to_mcam(vb->vb2_queue);
 	struct vb2_dma_sg_desc *sgd = vb2_dma_sg_plane_desc(vb, 0);
 
 	dma_unmap_sg(cam->dev, sgd->sglist, sgd->num_pages, DMA_FROM_DEVICE);
@@ -1252,7 +1165,7 @@ static int mcam_vb_sg_buf_finish(struct vb2_buffer *vb)
 
 static void mcam_vb_sg_buf_cleanup(struct vb2_buffer *vb)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = vq_to_mcam(vb->vb2_queue);
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
 	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
 
@@ -1276,581 +1189,351 @@ static const struct vb2_ops mcam_vb2_sg_ops = {
 
 #endif /* MCAM_MODE_DMA_SG */
 
-static int mcam_setup_vb2(struct mcam_camera *cam)
-{
-	struct vb2_queue *vq = &cam->vb_queue;
-
-	memset(vq, 0, sizeof(*vq));
-	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	vq->drv_priv = cam;
-	INIT_LIST_HEAD(&cam->buffers);
-	switch (cam->buffer_mode) {
-	case B_DMA_CONTIG:
-#ifdef MCAM_MODE_DMA_CONTIG
-		vq->ops = &mcam_vb2_ops;
-		vq->mem_ops = &vb2_dma_contig_memops;
-		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
-		vq->io_modes = VB2_MMAP | VB2_USERPTR;
-		cam->dma_setup = mcam_ctlr_dma_contig;
-		cam->frame_complete = mcam_dma_contig_done;
-#endif
-		break;
-	case B_DMA_SG:
-#ifdef MCAM_MODE_DMA_SG
-		vq->ops = &mcam_vb2_sg_ops;
-		vq->mem_ops = &vb2_dma_sg_memops;
-		vq->io_modes = VB2_MMAP | VB2_USERPTR;
-		cam->dma_setup = mcam_ctlr_dma_sg;
-		cam->frame_complete = mcam_dma_sg_done;
-#endif
-		break;
-	case B_VMALLOC:
-#ifdef MCAM_MODE_VMALLOC
-		tasklet_init(&cam->s_tasklet, mcam_frame_tasklet,
-				(unsigned long) cam);
-		vq->ops = &mcam_vb2_ops;
-		vq->mem_ops = &vb2_vmalloc_memops;
-		vq->buf_struct_size = sizeof(struct mcam_vb_buffer);
-		vq->io_modes = VB2_MMAP;
-		cam->dma_setup = mcam_ctlr_dma_vmalloc;
-		cam->frame_complete = mcam_vmalloc_done;
-#endif
-		break;
-	}
-	return vb2_queue_init(vq);
-}
-
-static void mcam_cleanup_vb2(struct mcam_camera *cam)
-{
-	vb2_queue_release(&cam->vb_queue);
-#ifdef MCAM_MODE_DMA_CONTIG
-	if (cam->buffer_mode == B_DMA_CONTIG)
-		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
-#endif
-}
-
-
-/* ---------------------------------------------------------------------- */
-/*
- * The long list of V4L2 ioctl() operations.
- */
-
-static int mcam_vidioc_streamon(struct file *filp, void *priv,
-		enum v4l2_buf_type type)
+static int mcam_camera_add_device(struct soc_camera_device *icd)
 {
-	struct mcam_camera *cam = filp->private_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mcam_camera *mcam = ici->priv;
 	int ret;
 
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_streamon(&cam->vb_queue, type);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_streamoff(struct file *filp, void *priv,
-		enum v4l2_buf_type type)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_streamoff(&cam->vb_queue, type);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_reqbufs(struct file *filp, void *priv,
-		struct v4l2_requestbuffers *req)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_reqbufs(&cam->vb_queue, req);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_querybuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_querybuf(&cam->vb_queue, buf);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-static int mcam_vidioc_qbuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
+	if (mcam->icd)
+		return -EBUSY;
 
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_qbuf(&cam->vb_queue, buf);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
+	mcam->frame_state.frames = 0;
+	mcam->frame_state.singles = 0;
+	mcam->frame_state.delivered = 0;
+
+	mcam->pll1 = devm_clk_get(mcam->dev, "pll1");
+	if (IS_ERR_OR_NULL(mcam->pll1) && mcam->dphy[2] == 0) {
+		cam_err(mcam, "Could not get pll1 clock\n");
+		if (IS_ERR(mcam->pll1)) {
+			mcam->pll1 = NULL;
+			return PTR_ERR(mcam->pll1);
+		} else
+			return -EINVAL;
+	}
 
-static int mcam_vidioc_dqbuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
+	mcam->flags = 0;
+	mcam->icd = icd;
+	mcam->state = S_IDLE;
+	mcam_ctlr_power_up(mcam);
+	mcam_ctlr_stop(mcam);
+	mcam_set_config_needed(mcam, 1);
+	mcam_reg_write(mcam, REG_CTRL1, C1_RESERVED | C1_DMAPOSTED);
+	mcam_reg_write(mcam, REG_CLKCTRL,
+				(mcam->mclk_src << 29) | mcam->mclk_div);
+	cam_dbg(mcam, "camera: set sensor mclk = %dMHz\n", mcam->mclk_min);
+	/*
+	 * Need sleep 1ms to wait for CCIC stable
+	 */
+	usleep_range(1000, 2000);
 
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_dqbuf(&cam->vb_queue, buf, filp->f_flags & O_NONBLOCK);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
+	/*
+	 * Mask all interrupts.
+	 */
+	mcam_reg_write(mcam, REG_IRQMASK, 0);
+	ret = sensor_call(mcam, core, init, 0);
+	/*
+	 * When sensor_call return -ENOIOCTLCMD,
+	 * means No ioctl command
+	 */
+	if ((ret < 0) && (ret != -ENOIOCTLCMD) && (ret != -ENODEV)) {
+		dev_err(icd->parent,
+			"camera: Failed to initialize subdev: %d\n", ret);
+		return ret;
+	}
+	return 0;
 }
 
-
-
-static int mcam_vidioc_queryctrl(struct file *filp, void *priv,
-		struct v4l2_queryctrl *qc)
+static void mcam_camera_remove_device(struct soc_camera_device *icd)
 {
-	struct mcam_camera *cam = priv;
-	int ret;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mcam_camera *mcam = ici->priv;
 
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, core, queryctrl, qc);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
+	BUG_ON(icd != mcam->icd);
+	cam_dbg(mcam, "Release %d frames, %d singles, %d delivered\n",
+			mcam->frame_state.frames, mcam->frame_state.singles,
+			mcam->frame_state.delivered);
+	mcam_config_mipi(mcam, 0);
+	mcam_ctlr_power_down(mcam);
+	mcam->icd = NULL;
 }
 
-
-static int mcam_vidioc_g_ctrl(struct file *filp, void *priv,
-		struct v4l2_control *ctrl)
+static int mcam_camera_set_fmt(struct soc_camera_device *icd,
+					struct v4l2_format *f)
 {
-	struct mcam_camera *cam = priv;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mcam_camera *mcam = ici->priv;
+	const struct soc_camera_format_xlate *xlate = NULL;
+	struct v4l2_mbus_framefmt mf;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
 
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, core, g_ctrl, ctrl);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_s_ctrl(struct file *filp, void *priv,
-		struct v4l2_control *ctrl)
-{
-	struct mcam_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, core, s_ctrl, ctrl);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int mcam_vidioc_querycap(struct file *file, void *priv,
-		struct v4l2_capability *cap)
-{
-	strcpy(cap->driver, "marvell_ccic");
-	strcpy(cap->card, "marvell_ccic");
-	cap->version = 1;
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
-	return 0;
-}
-
-
-static int mcam_vidioc_enum_fmt_vid_cap(struct file *filp,
-		void *priv, struct v4l2_fmtdesc *fmt)
-{
-	if (fmt->index >= N_MCAM_FMTS)
+	cam_dbg(mcam, "camera: set_fmt: %c, width = %u, height = %u\n",
+			pix->pixelformat, pix->width, pix->height);
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate) {
+		cam_err(mcam, "camera: format: %c not found\n",
+				pix->pixelformat);
 		return -EINVAL;
-	strlcpy(fmt->description, mcam_formats[fmt->index].desc,
-			sizeof(fmt->description));
-	fmt->pixelformat = mcam_formats[fmt->index].pixelformat;
-	return 0;
-}
-
-static int mcam_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
-		struct v4l2_format *fmt)
-{
-	struct mcam_camera *cam = priv;
-	struct mcam_format_struct *f;
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-	struct v4l2_mbus_framefmt mbus_fmt;
-	int ret;
-
-	f = mcam_find_format(pix->pixelformat);
-	pix->pixelformat = f->pixelformat;
-	v4l2_fill_mbus_format(&mbus_fmt, pix, f->mbus_code);
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, try_mbus_fmt, &mbus_fmt);
-	mutex_unlock(&cam->s_mutex);
-	v4l2_fill_pix_format(pix, &mbus_fmt);
-	switch (f->pixelformat) {
-	case V4L2_PIX_FMT_YUV420:
-	case V4L2_PIX_FMT_YVU420:
-		pix->bytesperline = pix->width * 3 / 2;
-		break;
-	default:
-		pix->bytesperline = pix->width * f->bpp;
-		break;
 	}
-	pix->sizeimage = pix->height * pix->bytesperline;
-	return ret;
-}
 
-static int mcam_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
-		struct v4l2_format *fmt)
-{
-	struct mcam_camera *cam = priv;
-	struct mcam_format_struct *f;
-	int ret;
+	mf.width = pix->width;
+	mf.height = pix->height;
+	mf.field = V4L2_FIELD_NONE;
+	mf.colorspace = pix->colorspace;
+	mf.code = xlate->code;
 
-	/*
-	 * Can't do anything if the device is not idle
-	 * Also can't if there are streaming buffers in place.
-	 */
-	if (cam->state != S_IDLE || cam->vb_queue.num_buffers > 0)
-		return -EBUSY;
+	ret = sensor_call(mcam, video, s_mbus_fmt, &mf);
+	if (ret < 0) {
+		cam_err(mcam, "camera: set_fmt failed %d\n", __LINE__);
+		return ret;
+	}
 
-	f = mcam_find_format(fmt->fmt.pix.pixelformat);
+	if (mf.code != xlate->code) {
+		cam_err(mcam, "camera: wrong code %s %d\n", __func__, __LINE__);
+		return -EINVAL;
+	}
 
-	/*
-	 * See if the formatting works in principle.
-	 */
-	ret = mcam_vidioc_try_fmt_vid_cap(filp, priv, fmt);
-	if (ret)
-		return ret;
-	/*
-	 * Now we start to change things for real, so let's do it
-	 * under lock.
-	 */
-	mutex_lock(&cam->s_mutex);
-	cam->pix_format = fmt->fmt.pix;
-	cam->mbus_code = f->mbus_code;
+	pix->width = mf.width;
+	pix->height = mf.height;
+	pix->field = mf.field;
+	pix->colorspace = mf.colorspace;
+	mcam->pix_format.sizeimage = pix->sizeimage;
+	icd->current_fmt = xlate;
 
+	memcpy(&(mcam->pix_format), pix, sizeof(struct v4l2_pix_format));
+	mcam_ctlr_image(mcam);
 	/*
 	 * Make sure we have appropriate DMA buffers.
 	 */
-	if (cam->buffer_mode == B_VMALLOC) {
-		ret = mcam_check_dma_buffers(cam);
+	if (mcam->buffer_mode == B_VMALLOC) {
+		ret = mcam_check_dma_buffers(mcam);
 		if (ret)
 			goto out;
 	}
-	mcam_set_config_needed(cam, 1);
+	mcam_set_config_needed(mcam, 1);
 out:
-	mutex_unlock(&cam->s_mutex);
 	return ret;
 }
 
-/*
- * Return our stored notion of how the camera is/should be configured.
- * The V4l2 spec wants us to be smarter, and actually get this from
- * the camera (and not mess with it at open time).  Someday.
- */
-static int mcam_vidioc_g_fmt_vid_cap(struct file *filp, void *priv,
-		struct v4l2_format *f)
+static int mcam_camera_try_fmt(struct soc_camera_device *icd,
+					struct v4l2_format *f)
 {
-	struct mcam_camera *cam = priv;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mcam_camera *mcam = ici->priv;
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_mbus_framefmt mf;
+	__u32 pixfmt = pix->pixelformat;
+	int ret;
 
-	f->fmt.pix = cam->pix_format;
-	return 0;
-}
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate) {
+		/* using default fmt and try again*/
+		/* to be verified */
+		memcpy(pix, &mcam_def_pix_format,
+			   sizeof(struct v4l2_pix_format));
+	}
 
-/*
- * We only have one input - the sensor - so minimize the nonsense here.
- */
-static int mcam_vidioc_enum_input(struct file *filp, void *priv,
-		struct v4l2_input *input)
-{
-	if (input->index != 0)
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate) {
+		/* it seems something really bad happens */
+		cam_err(mcam, "camera: format: %c not found\n",
+				pix->pixelformat);
 		return -EINVAL;
+	}
 
-	input->type = V4L2_INPUT_TYPE_CAMERA;
-	input->std = V4L2_STD_ALL; /* Not sure what should go here */
-	strcpy(input->name, "Camera");
-	return 0;
-}
-
-static int mcam_vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	*i = 0;
-	return 0;
-}
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
 
-static int mcam_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
-{
-	if (i != 0)
-		return -EINVAL;
-	return 0;
-}
-
-/* from vivi.c */
-static int mcam_vidioc_s_std(struct file *filp, void *priv, v4l2_std_id *a)
-{
-	return 0;
-}
+	/*
+	 * limit to sensor capabilities
+	 */
+	mf.width = pix->width;
+	mf.height = pix->height;
+	mf.field = V4L2_FIELD_NONE;
+	mf.colorspace = pix->colorspace;
+	mf.code = xlate->code;
 
-/*
- * G/S_PARM.  Most of this is done by the sensor, but we are
- * the level which controls the number of read buffers.
- */
-static int mcam_vidioc_g_parm(struct file *filp, void *priv,
-		struct v4l2_streamparm *parms)
-{
-	struct mcam_camera *cam = priv;
-	int ret;
+	ret = sensor_call(mcam, video, try_mbus_fmt, &mf);
+	if (ret < 0)
+		return ret;
 
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, g_parm, parms);
-	mutex_unlock(&cam->s_mutex);
-	parms->parm.capture.readbuffers = n_dma_bufs;
-	return ret;
-}
+	pix->width = mf.width;
+	pix->height = mf.height;
+	pix->colorspace = mf.colorspace;
 
-static int mcam_vidioc_s_parm(struct file *filp, void *priv,
-		struct v4l2_streamparm *parms)
-{
-	struct mcam_camera *cam = priv;
-	int ret;
+	switch (mf.field) {
+	case V4L2_FIELD_ANY:
+	case V4L2_FIELD_NONE:
+		pix->field = V4L2_FIELD_NONE;
+		break;
+	default:
+		cam_warn(mcam, "cam: Field type %d unsupported.\n", mf.field);
+		pix->field = V4L2_FIELD_NONE;
+		break;
+	}
 
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, s_parm, parms);
-	mutex_unlock(&cam->s_mutex);
-	parms->parm.capture.readbuffers = n_dma_bufs;
 	return ret;
 }
 
-static int mcam_vidioc_g_chip_ident(struct file *file, void *priv,
-		struct v4l2_dbg_chip_ident *chip)
+static int mcam_camera_init_videobuf(struct vb2_queue *q,
+					struct soc_camera_device *icd)
 {
-	struct mcam_camera *cam = priv;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mcam_camera *cam = ici->priv;
 
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	if (v4l2_chip_match_host(&chip->match)) {
-		chip->ident = cam->chip_id;
-		return 0;
+	memset(q, 0, sizeof(*q));
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->drv_priv = icd;
+	INIT_LIST_HEAD(&cam->buffers);
+	q->buf_struct_size = sizeof(struct mcam_vb_buffer);
+	switch (cam->buffer_mode) {
+	case B_DMA_CONTIG:
+#ifdef MCAM_MODE_DMA_CONTIG
+		q->ops = &mcam_vb2_ops;
+		q->mem_ops = &vb2_dma_contig_memops;
+		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
+		q->io_modes = VB2_MMAP | VB2_USERPTR;
+		cam->dma_setup = mcam_ctlr_dma_contig;
+		cam->frame_complete = mcam_dma_contig_done;
+#endif
+		break;
+	case B_DMA_SG:
+#ifdef MCAM_MODE_DMA_SG
+		q->ops = &mcam_vb2_sg_ops;
+		q->mem_ops = &vb2_dma_sg_memops;
+		q->io_modes = VB2_MMAP | VB2_USERPTR;
+		cam->dma_setup = mcam_ctlr_dma_sg;
+		cam->frame_complete = mcam_dma_sg_done;
+#endif
+		break;
+	case B_VMALLOC:
+#ifdef MCAM_MODE_VMALLOC
+		tasklet_init(&cam->s_tasklet, mcam_frame_tasklet,
+						(unsigned long) cam);
+		q->ops = &mcam_vb2_ops;
+		q->mem_ops = &vb2_vmalloc_memops;
+		q->io_modes = VB2_MMAP;
+		cam->dma_setup = mcam_ctlr_dma_vmalloc;
+		cam->frame_complete = mcam_vmalloc_done;
+#endif
+		break;
 	}
-	return sensor_call(cam, core, g_chip_ident, chip);
+	return vb2_queue_init(q);
 }
 
-static int mcam_vidioc_enum_framesizes(struct file *filp, void *priv,
-		struct v4l2_frmsizeenum *sizes)
+static unsigned int mcam_camera_poll(struct file *file, poll_table *pt)
 {
-	struct mcam_camera *cam = priv;
-	int ret;
+	struct soc_camera_device *icd = file->private_data;
 
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, enum_framesizes, sizes);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
+	return vb2_poll(&icd->vb2_vidq, file, pt);
 }
 
-static int mcam_vidioc_enum_frameintervals(struct file *filp, void *priv,
-		struct v4l2_frmivalenum *interval)
+static int mcam_camera_querycap(struct soc_camera_host *ici,
+				struct v4l2_capability *cap)
 {
-	struct mcam_camera *cam = priv;
-	int ret;
+	struct mcam_camera *mcam = ici->priv;
 
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, enum_frameintervals, interval);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int mcam_vidioc_g_register(struct file *file, void *priv,
-		struct v4l2_dbg_register *reg)
-{
-	struct mcam_camera *cam = priv;
+	strcpy(cap->card, mcam->card_name);
+	strcpy(cap->driver, "marvell_ccic");
 
-	if (v4l2_chip_match_host(&reg->match)) {
-		reg->val = mcam_reg_read(cam, reg->reg);
-		reg->size = 4;
-		return 0;
-	}
-	return sensor_call(cam, core, g_register, reg);
+	return 0;
 }
 
-static int mcam_vidioc_s_register(struct file *file, void *priv,
-		struct v4l2_dbg_register *reg)
+static int mcam_camera_set_bus_param(struct soc_camera_device *icd)
 {
-	struct mcam_camera *cam = priv;
-
-	if (v4l2_chip_match_host(&reg->match)) {
-		mcam_reg_write(cam, reg->reg, reg->val);
-		return 0;
-	}
-	return sensor_call(cam, core, s_register, reg);
+	return 0;
 }
-#endif
-
-static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
-	.vidioc_querycap	= mcam_vidioc_querycap,
-	.vidioc_enum_fmt_vid_cap = mcam_vidioc_enum_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap	= mcam_vidioc_try_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap	= mcam_vidioc_s_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap	= mcam_vidioc_g_fmt_vid_cap,
-	.vidioc_enum_input	= mcam_vidioc_enum_input,
-	.vidioc_g_input		= mcam_vidioc_g_input,
-	.vidioc_s_input		= mcam_vidioc_s_input,
-	.vidioc_s_std		= mcam_vidioc_s_std,
-	.vidioc_reqbufs		= mcam_vidioc_reqbufs,
-	.vidioc_querybuf	= mcam_vidioc_querybuf,
-	.vidioc_qbuf		= mcam_vidioc_qbuf,
-	.vidioc_dqbuf		= mcam_vidioc_dqbuf,
-	.vidioc_streamon	= mcam_vidioc_streamon,
-	.vidioc_streamoff	= mcam_vidioc_streamoff,
-	.vidioc_queryctrl	= mcam_vidioc_queryctrl,
-	.vidioc_g_ctrl		= mcam_vidioc_g_ctrl,
-	.vidioc_s_ctrl		= mcam_vidioc_s_ctrl,
-	.vidioc_g_parm		= mcam_vidioc_g_parm,
-	.vidioc_s_parm		= mcam_vidioc_s_parm,
-	.vidioc_enum_framesizes = mcam_vidioc_enum_framesizes,
-	.vidioc_enum_frameintervals = mcam_vidioc_enum_frameintervals,
-	.vidioc_g_chip_ident	= mcam_vidioc_g_chip_ident,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register	= mcam_vidioc_g_register,
-	.vidioc_s_register	= mcam_vidioc_s_register,
-#endif
-};
 
-/* ---------------------------------------------------------------------- */
-/*
- * Our various file operations.
- */
-static int mcam_v4l_open(struct file *filp)
+static int mcam_camera_get_formats(struct soc_camera_device *icd, u32 idx,
+					struct soc_camera_format_xlate  *xlate)
 {
-	struct mcam_camera *cam = video_drvdata(filp);
-	int ret = 0;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mcam_camera *mcam = ici->priv;
+	enum v4l2_mbus_pixelcode code;
+	const struct soc_mbus_pixelfmt *fmt;
+	int formats = 0, ret, i;
 
-	filp->private_data = cam;
+	ret = sensor_call(mcam, video, enum_mbus_fmt, idx, &code);
+	if (ret < 0)
+		/*
+		 * No more formats
+		 */
+		return 0;
 
-	cam->frame_state.frames = 0;
-	cam->frame_state.singles = 0;
-	cam->frame_state.delivered = 0;
-	mutex_lock(&cam->s_mutex);
-	if (cam->users == 0) {
-		ret = mcam_setup_vb2(cam);
-		if (ret)
-			goto out;
-		mcam_ctlr_power_up(cam);
-		__mcam_cam_reset(cam);
-		mcam_set_config_needed(cam, 1);
+	fmt = soc_mbus_get_fmtdesc(code);
+	if (!fmt) {
+		cam_err(mcam, "camera: Invalid format #%u: %d\n", idx, code);
+		return 0;
 	}
-	(cam->users)++;
-	if (cam->bus_type == V4L2_MBUS_CSI2) {
-		cam->pll1 = devm_clk_get(cam->dev, "pll1");
-		if (IS_ERR_OR_NULL(cam->pll1) && cam->dphy[2] == 0) {
-			cam_err(cam, "Could not get pll1 clock\n");
-			if (IS_ERR(cam->pll1))
-				ret = PTR_ERR(cam->pll1);
-			else
-				ret = -EINVAL;
+
+	switch (code) {
+	/*
+	 * Refer to mbus_fmt struct
+	 */
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		/*
+		 * Add support for YUV420 and YUV422P
+		 */
+		formats = ARRAY_SIZE(mcam_formats);
+		if (xlate) {
+			for (i = 0; i < ARRAY_SIZE(mcam_formats); i++) {
+				xlate->host_fmt = &mcam_formats[i];
+				xlate->code = code;
+				xlate++;
+			}
 		}
+		return formats;
+	case V4L2_MBUS_FMT_JPEG_1X8:
+		if (xlate)
+			cam_dbg(mcam, "camera: Providing format: %s\n",
+					fmt->name);
+		break;
+	default:
+		/*
+		 * camera controller can not support
+		 * this format, which might supported by the sensor
+		 */
+		cam_warn(mcam, "camera: Not support fmt: %s\n", fmt->name);
+		return 0;
 	}
-out:
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
 
-
-static int mcam_v4l_release(struct file *filp)
-{
-	struct mcam_camera *cam = filp->private_data;
-
-	cam_dbg(cam, "Release, %d frames, %d singles, %d delivered\n",
-			cam->frame_state.frames, cam->frame_state.singles,
-			cam->frame_state.delivered);
-	mutex_lock(&cam->s_mutex);
-	(cam->users)--;
-	if (cam->users == 0) {
-		mcam_ctlr_stop_dma(cam);
-		mcam_cleanup_vb2(cam);
-		mcam_config_mipi(cam, 0);
-		mcam_ctlr_power_down(cam);
-		if (cam->buffer_mode == B_VMALLOC && alloc_bufs_at_read)
-			mcam_free_dma_bufs(cam);
-	}
-	if (cam->bus_type == V4L2_MBUS_CSI2) {
-		devm_clk_put(cam->dev, cam->pll1);
-		cam->pll1 = NULL;
+	formats++;
+	if (xlate) {
+		xlate->host_fmt = fmt;
+		xlate->code = code;
+		xlate++;
 	}
-	mutex_unlock(&cam->s_mutex);
-	return 0;
-}
-
-static ssize_t mcam_v4l_read(struct file *filp,
-		char __user *buffer, size_t len, loff_t *pos)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_read(&cam->vb_queue, buffer, len, pos,
-			filp->f_flags & O_NONBLOCK);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-
-static unsigned int mcam_v4l_poll(struct file *filp,
-		struct poll_table_struct *pt)
-{
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_poll(&cam->vb_queue, filp, pt);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
+	return formats;
+}
+
+struct soc_camera_host_ops mcam_soc_camera_host_ops = {
+	.owner			= THIS_MODULE,
+	.add			= mcam_camera_add_device,
+	.remove			= mcam_camera_remove_device,
+	.set_fmt		= mcam_camera_set_fmt,
+	.try_fmt		= mcam_camera_try_fmt,
+	.init_videobuf2		= mcam_camera_init_videobuf,
+	.poll			= mcam_camera_poll,
+	.querycap		= mcam_camera_querycap,
+	.set_bus_param		= mcam_camera_set_bus_param,
+	.get_formats		= mcam_camera_get_formats,
+};
 
-static int mcam_v4l_mmap(struct file *filp, struct vm_area_struct *vma)
+int mcam_soc_camera_host_register(struct mcam_camera *mcam)
 {
-	struct mcam_camera *cam = filp->private_data;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = vb2_mmap(&cam->vb_queue, vma);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
+	mcam->soc_host.drv_name = "mmp-camera";
+	mcam->soc_host.ops = &mcam_soc_camera_host_ops;
+	mcam->soc_host.priv = mcam;
+	mcam->soc_host.v4l2_dev.dev = mcam->dev;
+	mcam->soc_host.nr = mcam->ccic_id;
+	return soc_camera_host_register(&mcam->soc_host);
 }
 
-
-
-static const struct v4l2_file_operations mcam_v4l_fops = {
-	.owner = THIS_MODULE,
-	.open = mcam_v4l_open,
-	.release = mcam_v4l_release,
-	.read = mcam_v4l_read,
-	.poll = mcam_v4l_poll,
-	.mmap = mcam_v4l_mmap,
-	.unlocked_ioctl = video_ioctl2,
-};
-
-
-/*
- * This template device holds all of those v4l2 methods; we
- * clone it for specific real devices.
- */
-static struct video_device mcam_v4l_template = {
-	.name = "mcam",
-	.tvnorms = V4L2_STD_NTSC_M,
-	.current_norm = V4L2_STD_NTSC_M,  /* make mplayer happy */
-
-	.fops = &mcam_v4l_fops,
-	.ioctl_ops = &mcam_v4l_ioctl_ops,
-	.release = video_device_release_empty,
-};
-
 /* ---------------------------------------------------------------------- */
 /*
  * Interrupt handler stuff
@@ -1925,51 +1608,29 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
 	return handled;
 }
 
-/* ---------------------------------------------------------------------- */
-/*
- * Registration and such.
- */
-static struct ov7670_config sensor_cfg = {
-	/*
-	 * Exclude QCIF mode, because it only captures a tiny portion
-	 * of the sensor FOV
-	 */
-	.min_width = 320,
-	.min_height = 240,
-};
-
-
 int mccic_register(struct mcam_camera *cam)
 {
-	struct i2c_board_info ov7670_info = {
-		.type = "ov7670",
-		.addr = 0x42 >> 1,
-		.platform_data = &sensor_cfg,
-	};
 	int ret;
 
+	if (buffer_mode >= 0)
+		cam->buffer_mode = buffer_mode;
 	/*
 	 * Validate the requested buffer mode.
 	 */
-	if (buffer_mode >= 0)
-		cam->buffer_mode = buffer_mode;
-	if (cam->buffer_mode == B_DMA_SG &&
-			cam->chip_id == V4L2_IDENT_CAFE) {
-		printk(KERN_ERR "marvell-cam: Cafe can't do S/G I/O, "
-			"attempting vmalloc mode instead\n");
-		cam->buffer_mode = B_VMALLOC;
-	}
 	if (!mcam_buffer_mode_supported(cam->buffer_mode)) {
-		printk(KERN_ERR "marvell-cam: buffer mode %d unsupported\n",
+		cam_err(cam, "marvell-cam: buffer mode %d unsupported\n",
 				cam->buffer_mode);
 		return -EINVAL;
 	}
-	/*
-	 * Register with V4L
-	 */
-	ret = v4l2_device_register(cam->dev, &cam->v4l2_dev);
-	if (ret)
-		return ret;
+
+#ifdef MCAM_MODE_DMA_CONTIG
+	if (cam->buffer_mode == B_DMA_CONTIG) {
+		cam->vb_alloc_ctx =
+			vb2_dma_contig_init_ctx(cam->dev);
+		if (IS_ERR(cam->vb_alloc_ctx))
+			return PTR_ERR(cam->vb_alloc_ctx);
+	}
+#endif
 
 	mutex_init(&cam->s_mutex);
 	cam->state = S_NOTREADY;
@@ -1977,56 +1638,20 @@ int mccic_register(struct mcam_camera *cam)
 	cam->pix_format = mcam_def_pix_format;
 	cam->mbus_code = mcam_def_mbus_code;
 	INIT_LIST_HEAD(&cam->buffers);
-	mcam_ctlr_init(cam);
-
-	/*
-	 * Try to find the sensor.
-	 */
-	sensor_cfg.clock_speed = cam->clock_speed;
-	sensor_cfg.use_smbus = cam->use_smbus;
-	cam->sensor_addr = ov7670_info.addr;
-	cam->sensor = v4l2_i2c_new_subdev_board(&cam->v4l2_dev,
-			cam->i2c_adapter, &ov7670_info, NULL);
-	if (cam->sensor == NULL) {
-		ret = -ENODEV;
-		goto out_unregister;
-	}
-
-	ret = mcam_cam_init(cam);
-	if (ret)
-		goto out_unregister;
-	/*
-	 * Get the v4l2 setup done.
-	 */
-	mutex_lock(&cam->s_mutex);
-	cam->vdev = mcam_v4l_template;
-	cam->vdev.debug = 0;
-	cam->vdev.v4l2_dev = &cam->v4l2_dev;
-	ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
-	if (ret)
-		goto out;
-	video_set_drvdata(&cam->vdev, cam);
-
-	/*
-	 * If so requested, try to get our DMA buffers now.
-	 */
-	if (cam->buffer_mode == B_VMALLOC && !alloc_bufs_at_read) {
-		if (mcam_alloc_dma_bufs(cam, 1))
-			cam_warn(cam, "Unable to alloc DMA buffers at load"
-					" will try again later.");
+	ret = mcam_soc_camera_host_register(cam);
+#ifdef MCAM_MODE_DMA_CONTIG
+	if ((cam->buffer_mode == B_DMA_CONTIG) && ret) {
+		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
+		cam->vb_alloc_ctx = NULL;
 	}
-
-out:
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-out_unregister:
-	v4l2_device_unregister(&cam->v4l2_dev);
+#endif
 	return ret;
 }
 
 
 void mccic_shutdown(struct mcam_camera *cam)
 {
+	struct soc_camera_host *soc_host = &cam->soc_host;
 	/*
 	 * If we have no users (and we really, really should have no
 	 * users) the device will already be powered down.  Trying to
@@ -2037,11 +1662,14 @@ void mccic_shutdown(struct mcam_camera *cam)
 		cam_warn(cam, "Removing a device with users!\n");
 		mcam_ctlr_power_down(cam);
 	}
-	vb2_queue_release(&cam->vb_queue);
-	if (cam->buffer_mode == B_VMALLOC)
-		mcam_free_dma_bufs(cam);
-	video_unregister_device(&cam->vdev);
-	v4l2_device_unregister(&cam->v4l2_dev);
+
+	soc_camera_host_unregister(soc_host);
+#ifdef MCAM_MODE_DMA_CONTIG
+	if (cam->buffer_mode == B_DMA_CONTIG) {
+		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
+		cam->vb_alloc_ctx = NULL;
+	}
+#endif
 }
 
 /*
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 4cb68e0..12af7d2 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -10,6 +10,8 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf2-core.h>
+#include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 
 /*
  * Create our own symbols for the supported buffer modes, but, for now,
@@ -91,6 +93,8 @@ struct mcam_frame_state {
  *          dev_lock is also required for access to device registers.
  */
 struct mcam_camera {
+	struct soc_camera_host soc_host;
+	struct soc_camera_device *icd;
 	/*
 	 * These fields should be set by the platform code prior to
 	 * calling mcam_register().
@@ -104,6 +108,10 @@ struct mcam_camera {
 	short int use_smbus;	/* SMBUS or straight I2c? */
 	enum mcam_buffer_mode buffer_mode;
 
+	int mclk_min;
+	int mclk_src;
+	int mclk_div;
+	char *card_name;
 	int ccic_id;
 	enum v4l2_mbus_type bus_type;
 	/* MIPI support */
@@ -133,15 +141,8 @@ struct mcam_camera {
 	int users;			/* How many open FDs */
 
 	struct mcam_frame_state frame_state;	/* Frame state counter */
-	/*
-	 * Subsystem structures.
-	 */
-	struct video_device vdev;
-	struct v4l2_subdev *sensor;
-	unsigned short sensor_addr;
 
 	/* Videobuf2 stuff */
-	struct vb2_queue vb_queue;
 	struct list_head buffers;	/* Available frames */
 
 	unsigned int nbufs;		/* How many are alloc'd */
@@ -166,7 +167,6 @@ struct mcam_camera {
 	void (*frame_complete)(struct mcam_camera *cam, unsigned int frame);
 
 	/* Current operating parameters */
-	u32 sensor_type;		/* Currently ov7670 only */
 	struct v4l2_pix_format pix_format;
 	enum v4l2_mbus_pixelcode mbus_code;
 
@@ -216,6 +216,14 @@ static inline void mcam_reg_set_bit(struct mcam_camera *cam,
 	mcam_reg_write_mask(cam, reg, val, val);
 }
 
+static inline struct mcam_camera *vq_to_mcam(struct vb2_queue *vq)
+{
+	struct soc_camera_device *icd = container_of(vq,
+					struct soc_camera_device, vb2_vidq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	return ici->priv;
+}
+
 /*
  * Functions for use by platform code.
  */
@@ -258,6 +266,7 @@ int mccic_resume(struct mcam_camera *cam);
 #define   IMGP_YP_MASK	  0x00003ffc	/* Y pitch field */
 #define	  IMGP_UVP_SHFT	  18		/* UV pitch (planar) */
 #define   IMGP_UVP_MASK   0x3ffc0000
+/* Bits below IRQ_TWSI* are not present in mmp */
 #define REG_IRQSTATRAW	0x28	/* RAW IRQ Status */
 #define   IRQ_EOF0	  0x00000001	/* End of frame 0 */
 #define   IRQ_EOF1	  0x00000002	/* End of frame 1 */
@@ -333,6 +342,7 @@ int mccic_resume(struct mcam_camera *cam);
 /* Bits below C1_444ALPHA are not present in Cafe */
 #define REG_CTRL1	0x40	/* Control 1 */
 #define	  C1_CLKGATE	  0x00000001	/* Sensor clock gate */
+#define   C1_RESERVED	  0x0000003c	/* Reserved and shouldn't be changed */
 #define   C1_DESC_ENA	  0x00000100	/* DMA descriptor enable */
 #define   C1_DESC_3WORD   0x00000200	/* Three-word descriptors used */
 #define	  C1_444ALPHA	  0x00f00000	/* Alpha field in RGB444 */
@@ -343,6 +353,7 @@ int mccic_resume(struct mcam_camera *cam);
 #define	  C1_DMAB_MASK	  0x06000000
 #define	  C1_TWOBUFS	  0x08000000	/* Use only two DMA buffers */
 #define	  C1_PWRDWN	  0x10000000	/* Power down */
+#define   C1_DMAPOSTED	  0x40000000    /* DMA Posted Select */
 
 #define REG_CLKCTRL	0x88	/* Clock control */
 #define	  CLK_DIV_MASK	  0x0000ffff	/* Upper bits RW "reserved" */
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 732af16..3d5db24 100755
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -28,6 +28,10 @@
 #include <linux/list.h>
 #include <linux/pm.h>
 #include <linux/clk.h>
+#include <linux/regulator/consumer.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
 
 #include "mcam-core.h"
 
@@ -140,23 +144,13 @@ static void mmpcam_power_up_ctlr(struct mmp_camera *cam)
 static void mmpcam_power_up(struct mcam_camera *mcam)
 {
 	struct mmp_camera *cam = mcam_to_cam(mcam);
-	struct mmp_camera_platform_data *pdata;
+
 /*
  * Turn on power and clocks to the controller.
  */
 	mmpcam_power_up_ctlr(cam);
-/*
- * Provide power to the sensor.
- */
 	mcam_reg_write(mcam, REG_CLKCTRL, 0x60000002);
-	pdata = cam->pdev->dev.platform_data;
-	gpio_set_value(pdata->sensor_power_gpio, 1);
-	mdelay(5);
 	mcam_reg_clear_bit(mcam, REG_CTRL1, 0x10000000);
-	gpio_set_value(pdata->sensor_reset_gpio, 0); /* reset is active low */
-	mdelay(5);
-	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
-	mdelay(5);
 
 	mcam_clk_enable(mcam);
 }
@@ -164,18 +158,12 @@ static void mmpcam_power_up(struct mcam_camera *mcam)
 static void mmpcam_power_down(struct mcam_camera *mcam)
 {
 	struct mmp_camera *cam = mcam_to_cam(mcam);
-	struct mmp_camera_platform_data *pdata;
+
 /*
  * Turn off clocks and set reset lines
  */
 	iowrite32(0, cam->power_regs + REG_CCIC_DCGCR);
 	iowrite32(0, cam->power_regs + REG_CCIC_CRCR);
-/*
- * Shut down the sensor.
- */
-	pdata = cam->pdev->dev.platform_data;
-	gpio_set_value(pdata->sensor_power_gpio, 0);
-	gpio_set_value(pdata->sensor_reset_gpio, 0);
 
 	mcam_clk_disable(mcam);
 }
@@ -349,6 +337,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&cam->devlist);
 
 	mcam = &cam->mcam;
+	spin_lock_init(&mcam->dev_lock);
 	mcam->plat_power_up = mmpcam_power_up;
 	mcam->plat_power_down = mmpcam_power_down;
 	mcam->ctlr_reset = mcam_ctlr_reset;
@@ -356,6 +345,11 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->dev = &pdev->dev;
 	mcam->use_smbus = 0;
 	mcam->ccic_id = pdev->id;
+	mcam->card_name = pdata->name;
+	mcam->mclk_min = pdata->mclk_min;
+	mcam->mclk_src = pdata->mclk_src;
+	mcam->mclk_div = pdata->mclk_div;
+	mcam->chip_id = pdata->chip_id;
 	mcam->bus_type = pdata->bus_type;
 	mcam->dphy = pdata->dphy;
 	/* mosetly it won't happen. dphy is an array in pdata, but in case .. */
@@ -364,9 +358,9 @@ static int mmpcam_probe(struct platform_device *pdev)
 
 	mcam->mipi_enabled = 0;
 	mcam->lane = pdata->lane;
-	mcam->chip_id = V4L2_IDENT_ARMADA610;
-	mcam->buffer_mode = B_DMA_SG;
-	spin_lock_init(&mcam->dev_lock);
+	/* set B_DMA_CONTIG as default */
+	mcam->buffer_mode = B_DMA_CONTIG;
+	INIT_LIST_HEAD(&mcam->buffers);
 	/*
 	 * Get our I/O memory.
 	 */
@@ -398,41 +392,10 @@ static int mmpcam_probe(struct platform_device *pdev)
 	ret = mcam_init_clk(mcam, pdata);
 	if (ret)
 		return ret;
-	/*
-	 * Find the i2c adapter.  This assumes, of course, that the
-	 * i2c bus is already up and functioning.
-	 */
-	mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
-	if (mcam->i2c_adapter == NULL) {
-		dev_err(&pdev->dev, "No i2c adapter\n");
-		return -ENODEV;
-	}
-	/*
-	 * Sensor GPIO pins.
-	 */
-	ret = devm_gpio_request(&pdev->dev, pdata->sensor_power_gpio,
-					"cam-power");
-	if (ret) {
-		dev_err(&pdev->dev, "Can't get sensor power gpio %d",
-				pdata->sensor_power_gpio);
-		return ret;
-	}
-	gpio_direction_output(pdata->sensor_power_gpio, 0);
-	ret = devm_gpio_request(&pdev->dev, pdata->sensor_reset_gpio,
-					"cam-reset");
-	if (ret) {
-		dev_err(&pdev->dev, "Can't get sensor reset gpio %d",
-				pdata->sensor_reset_gpio);
-		return ret;
-	}
-	gpio_direction_output(pdata->sensor_reset_gpio, 0);
-	/*
-	 * Power the device up and hand it off to the core.
-	 */
-	mmpcam_power_up(mcam);
+
 	ret = mccic_register(mcam);
 	if (ret)
-		goto out_power_down;
+		return ret;
 	/*
 	 * Finally, set up our IRQ now that the core is ready to
 	 * deal with it.
@@ -452,8 +415,6 @@ static int mmpcam_probe(struct platform_device *pdev)
 
 out_unregister:
 	mccic_shutdown(mcam);
-out_power_down:
-	mmpcam_power_down(mcam);
 	return ret;
 }
 
diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
index 813efe2..513d846 100755
--- a/include/media/mmp-camera.h
+++ b/include/media/mmp-camera.h
@@ -7,7 +7,12 @@ struct mmp_camera_platform_data {
 	struct platform_device *i2c_device;
 	int sensor_power_gpio;
 	int sensor_reset_gpio;
+	char name[16];
 	enum v4l2_mbus_type bus_type;
+	int mclk_min;
+	int mclk_src;
+	int mclk_div;
+	int chip_id;
 	/*
 	 * MIPI support
 	 */
-- 
1.7.9.5

