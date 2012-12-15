Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:35143 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733Ab2LOJ77 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 04:59:59 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [PATCH V3 11/15] [media] marvell-ccic: add soc_camera support in mcam core
Date: Sat, 15 Dec 2012 17:58:00 +0800
Message-Id: <1355565484-15791-12-git-send-email-twang13@marvell.com>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the soc_camera support in mcam core.

It creates the file mcam-core-soc.c and mcam-core-soc.h
to support soc_camera in mcam core.

To use the soc_camera feature, platform driver, such as mmp-driver.c,
should also be modified.

Signed-off-by: Libin Yang <lbyang@marvell.com>
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 drivers/media/platform/marvell-ccic/Makefile       |    2 +
 .../media/platform/marvell-ccic/mcam-core-soc.c    |  416 ++++++++++++++++++++
 .../media/platform/marvell-ccic/mcam-core-soc.h    |   19 +
 drivers/media/platform/marvell-ccic/mcam-core.c    |    2 +-
 drivers/media/platform/marvell-ccic/mcam-core.h    |   31 ++
 include/media/mmp-camera.h                         |    3 +
 6 files changed, 472 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/marvell-ccic/mcam-core-soc.c
 create mode 100644 drivers/media/platform/marvell-ccic/mcam-core-soc.h

diff --git a/drivers/media/platform/marvell-ccic/Makefile b/drivers/media/platform/marvell-ccic/Makefile
index 595ebdf..b3e87d4 100755
--- a/drivers/media/platform/marvell-ccic/Makefile
+++ b/drivers/media/platform/marvell-ccic/Makefile
@@ -4,3 +4,5 @@ cafe_ccic-y := cafe-driver.o mcam-core.o
 obj-$(CONFIG_VIDEO_MMP_CAMERA) += mmp_camera_standard.o
 mmp_camera_standard-y := mmp-driver.o mcam-core.o mcam-core-standard.o
 
+obj-$(CONFIG_VIDEO_MMP_SOC_CAMERA) += mmp_camera_soc.o
+mmp_camera_soc-y := mmp-driver.o mcam-core.o mcam-core-soc.o
diff --git a/drivers/media/platform/marvell-ccic/mcam-core-soc.c b/drivers/media/platform/marvell-ccic/mcam-core-soc.c
new file mode 100644
index 0000000..9016dc6
--- /dev/null
+++ b/drivers/media/platform/marvell-ccic/mcam-core-soc.c
@@ -0,0 +1,416 @@
+/*
+ * The Marvell camera soc core.	 This device appears in a number of settings,
+ * so it needs platform-specific support outside of the core.
+ *
+ * Copyright (C) 2009-2012 Marvell International Ltd.
+ *
+ * Author: Libin Yang <lbyang@marvell.com>
+ *         Albert Wang <twang13@marvell.com>
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/soc_camera.h>
+#include <media/soc_mediabus.h>
+#include <linux/clk.h>
+
+#include "mcam-core.h"
+#include "mcam-core-soc.h"
+
+static const enum v4l2_mbus_pixelcode mcam_def_mbus_code =
+					V4L2_MBUS_FMT_YUYV8_2X8;
+
+static const struct soc_mbus_pixelfmt mcam_formats[] = {
+	{
+		.fourcc	= V4L2_PIX_FMT_UYVY,
+		.name = "YUV422PACKED",
+		.bits_per_sample = 8,
+		.packing = SOC_MBUS_PACKING_2X8_PADLO,
+		.order = SOC_MBUS_ORDER_LE,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_YUV422P,
+		.name = "YUV422PLANAR",
+		.bits_per_sample = 8,
+		.packing = SOC_MBUS_PACKING_2X8_PADLO,
+		.order = SOC_MBUS_ORDER_LE,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_YUV420,
+		.name = "YUV420PLANAR",
+		.bits_per_sample = 12,
+		.packing = SOC_MBUS_PACKING_NONE,
+		.order = SOC_MBUS_ORDER_LE,
+	},
+	{
+		.fourcc = V4L2_PIX_FMT_YVU420,
+		.name = "YVU420PLANAR",
+		.bits_per_sample = 12,
+		.packing = SOC_MBUS_PACKING_NONE,
+		.order = SOC_MBUS_ORDER_LE,
+	},
+};
+
+static int mcam_camera_add_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mcam_camera *mcam = ici->priv;
+	int ret;
+
+	if (mcam->icd)
+		return -EBUSY;
+
+	mcam->frame_complete = mcam_dma_contig_done;
+	mcam->frame_state.frames = 0;
+	mcam->frame_state.singles = 0;
+	mcam->frame_state.delivered = 0;
+
+	mcam->pll1 = devm_clk_get(mcam->dev, "pll1");
+	if (IS_ERR(mcam->pll1)) {
+		cam_err(mcam, "Could not get pll1 clock\n");
+		return PTR_ERR(mcam->pll1);
+	}
+
+	mcam->flags = 0;
+	mcam->icd = icd;
+	mcam->state = S_IDLE;
+	mcam->dma_setup = mcam_ctlr_dma_contig;
+	mcam_ctlr_power_up(mcam);
+	mcam_ctlr_stop(mcam);
+	mcam_set_config_needed(mcam, 1);
+	mcam_reg_write(mcam, REG_CTRL1,
+				   C1_RESERVED | C1_DMAPOSTED);
+	mcam_reg_write(mcam, REG_CLKCTRL,
+		(mcam->mclk_src << 29) | mcam->mclk_div);
+	cam_dbg(mcam, "camera: set sensor mclk = %dMHz\n", mcam->mclk_min);
+	/*
+	 * Need sleep 1ms to wait for CCIC stable
+	 * This is a workround for OV5640 MIPI
+	 * TODO: Fix me in the future
+	 */
+	usleep_range(1000, 2000);
+
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
+
+	return 0;
+}
+
+static void mcam_camera_remove_device(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mcam_camera *mcam = ici->priv;
+
+	BUG_ON(icd != mcam->icd);
+	cam_dbg(mcam, "Release %d frames, %d singles, %d delivered\n",
+		mcam->frame_state.frames, mcam->frame_state.singles,
+		mcam->frame_state.delivered);
+	mcam_config_mipi(mcam, 0);
+	mcam_ctlr_power_down(mcam);
+	mcam->icd = NULL;
+}
+
+static int mcam_camera_set_fmt(struct soc_camera_device *icd,
+			struct v4l2_format *f)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mcam_camera *mcam = ici->priv;
+	const struct soc_camera_format_xlate *xlate = NULL;
+	struct v4l2_mbus_framefmt mf;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	int ret;
+
+	cam_dbg(mcam, "camera: set_fmt: %c, width = %u, height = %u\n",
+		pix->pixelformat, pix->width, pix->height);
+	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
+	if (!xlate) {
+		cam_err(mcam, "camera: format: %c not found\n",
+			pix->pixelformat);
+		return -EINVAL;
+	}
+
+	mf.width = pix->width;
+	mf.height = pix->height;
+	mf.field = V4L2_FIELD_NONE;
+	mf.colorspace = pix->colorspace;
+	mf.code = xlate->code;
+
+	ret = sensor_call(mcam, video, s_mbus_fmt, &mf);
+	if (ret < 0) {
+		cam_err(mcam, "camera: set_fmt failed %d\n", __LINE__);
+		return ret;
+	}
+
+	if (mf.code != xlate->code) {
+		cam_err(mcam, "camera: wrong code %s %d\n", __func__, __LINE__);
+		return -EINVAL;
+	}
+
+	pix->width = mf.width;
+	pix->height = mf.height;
+	pix->field = mf.field;
+	pix->colorspace = mf.colorspace;
+	mcam->pix_format.sizeimage = pix->sizeimage;
+	icd->current_fmt = xlate;
+
+	memcpy(&(mcam->pix_format), pix, sizeof(struct v4l2_pix_format));
+	mcam_ctlr_image(mcam);
+	mcam_set_config_needed(mcam, 1);
+
+	return ret;
+}
+
+static int mcam_camera_try_fmt(struct soc_camera_device *icd,
+			struct v4l2_format *f)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mcam_camera *mcam = ici->priv;
+	const struct soc_camera_format_xlate *xlate;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_mbus_framefmt mf;
+	__u32 pixfmt = pix->pixelformat;
+	int ret;
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate) {
+		/* using default fmt and try again*/
+		/* to be verified */
+		memcpy(pix, &mcam_def_pix_format,
+			sizeof(struct v4l2_pix_format));
+	}
+
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate) {
+		/* it seems something really bad happens */
+		cam_err(mcam, "camera: format: %c not found\n",
+			pix->pixelformat);
+		return -EINVAL;
+	}
+
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
+
+	/*
+	 * limit to sensor capabilities
+	 */
+	mf.width = pix->width;
+	mf.height = pix->height;
+	mf.field = V4L2_FIELD_NONE;
+	mf.colorspace = pix->colorspace;
+	mf.code = xlate->code;
+
+	ret = sensor_call(mcam, video, try_mbus_fmt, &mf);
+	if (ret < 0)
+		return ret;
+
+	pix->width = mf.width;
+	pix->height = mf.height;
+	pix->colorspace = mf.colorspace;
+
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
+
+	return ret;
+}
+
+static int mcam_camera_init_videobuf(struct vb2_queue *q,
+			struct soc_camera_device *icd)
+{
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_USERPTR | VB2_MMAP;
+	q->drv_priv = icd;
+	q->ops = &mcam_vb2_ops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->buf_struct_size = sizeof(struct mcam_vb_buffer);
+
+	return vb2_queue_init(q);
+}
+
+static unsigned int mcam_camera_poll(struct file *file, poll_table *pt)
+{
+	struct soc_camera_device *icd = file->private_data;
+
+	return vb2_poll(&icd->vb2_vidq, file, pt);
+}
+
+static int mcam_camera_querycap(struct soc_camera_host *ici,
+			struct v4l2_capability *cap)
+{
+	struct mcam_camera *mcam = ici->priv;
+
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	strcpy(cap->card, mcam->card_name);
+	strcpy(cap->driver, "marvell_ccic");
+
+	return 0;
+}
+
+static int mcam_camera_set_bus_param(struct soc_camera_device *icd)
+{
+	return 0;
+}
+
+static int mcam_camera_get_formats(struct soc_camera_device *icd, u32 idx,
+			struct soc_camera_format_xlate	*xlate)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	struct mcam_camera *mcam = ici->priv;
+	enum v4l2_mbus_pixelcode code;
+	const struct soc_mbus_pixelfmt *fmt;
+	int formats = 0, ret, i;
+
+	ret = sensor_call(mcam, video, enum_mbus_fmt, idx, &code);
+	if (ret < 0)
+		/*
+		 * No more formats
+		 */
+		return 0;
+
+	fmt = soc_mbus_get_fmtdesc(code);
+	if (!fmt) {
+		cam_err(mcam, "camera: Invalid format #%u: %d\n", idx, code);
+		return 0;
+	}
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
+		}
+		return formats;
+	case V4L2_MBUS_FMT_JPEG_1X8:
+		if (xlate)
+			cam_dbg(mcam, "camera: Providing format: %s\n",
+				fmt->name);
+		break;
+	default:
+		/*
+		 * camera controller can not support
+		 * this format, which might supported by the sensor
+		 */
+		cam_warn(mcam, "camera: Not support fmt: %s\n", fmt->name);
+		return 0;
+	}
+
+	formats++;
+	if (xlate) {
+		xlate->host_fmt = fmt;
+		xlate->code = code;
+		xlate++;
+	}
+
+	return formats;
+}
+
+struct soc_camera_host_ops mcam_soc_camera_host_ops = {
+	.owner		= THIS_MODULE,
+	.add		= mcam_camera_add_device,
+	.remove		= mcam_camera_remove_device,
+	.set_fmt	= mcam_camera_set_fmt,
+	.try_fmt	= mcam_camera_try_fmt,
+	.init_videobuf2	= mcam_camera_init_videobuf,
+	.poll		= mcam_camera_poll,
+	.querycap	= mcam_camera_querycap,
+	.set_bus_param	= mcam_camera_set_bus_param,
+	.get_formats	= mcam_camera_get_formats,
+};
+
+int mcam_soc_camera_host_register(struct mcam_camera *mcam)
+{
+	mcam->soc_host.drv_name = "mmp-camera";
+	mcam->soc_host.ops = &mcam_soc_camera_host_ops;
+	mcam->soc_host.priv = mcam;
+	mcam->soc_host.v4l2_dev.dev = mcam->dev;
+	mcam->soc_host.nr = mcam->ccic_id;
+	return soc_camera_host_register(&mcam->soc_host);
+}
+
+int mccic_register(struct mcam_camera *cam)
+{
+	int ret;
+
+	cam->buffer_mode = B_DMA_contig;
+	/*
+	 * Validate the requested buffer mode.
+	 */
+	if (!mcam_buffer_mode_supported(cam->buffer_mode)) {
+		cam_err(cam, "marvell-cam: buffer mode %d unsupported\n",
+				cam->buffer_mode);
+		return -EINVAL;
+	}
+
+	cam->vb_alloc_ctx =
+		vb2_dma_contig_init_ctx(cam->dev);
+	if (IS_ERR(cam->vb_alloc_ctx))
+		return PTR_ERR(cam->vb_alloc_ctx);
+
+	mutex_init(&cam->s_mutex);
+	cam->state = S_NOTREADY;
+	mcam_set_config_needed(cam, 1);
+	cam->pix_format = mcam_def_pix_format;
+	cam->mbus_code = mcam_def_mbus_code;
+	INIT_LIST_HEAD(&cam->buffers);
+
+	ret = mcam_soc_camera_host_register(cam);
+	if (ret) {
+		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
+		cam->vb_alloc_ctx = NULL;
+	}
+	return ret;
+}
+
+void mccic_shutdown(struct mcam_camera *cam)
+{
+	struct soc_camera_host *soc_host = &cam->soc_host;
+	/*
+	 * If we have no users (and we really, really should have no
+	 * users) the device will already be powered down.  Trying to
+	 * take it down again will wedge the machine, which is frowned
+	 * upon.
+	 */
+	if (cam->users > 0) {
+		cam_warn(cam, "Removing a device with users!\n");
+		mcam_ctlr_power_down(cam);
+	}
+	vb2_queue_release(&cam->vb_queue);
+	soc_camera_host_unregister(soc_host);
+	vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
+	cam->vb_alloc_ctx = NULL;
+}
diff --git a/drivers/media/platform/marvell-ccic/mcam-core-soc.h b/drivers/media/platform/marvell-ccic/mcam-core-soc.h
new file mode 100644
index 0000000..fbdaa5d
--- /dev/null
+++ b/drivers/media/platform/marvell-ccic/mcam-core-soc.h
@@ -0,0 +1,19 @@
+/*
+ * Marvell camera core structures.
+ *
+ * Copyright (C) 2009-2012 Marvell International Ltd.
+ *
+ * Author: Libin Yang <lbyang@marvell.com>
+ *         Albert Wang <twang13@marvell.com>
+ *
+ */
+extern const struct vb2_ops mcam_vb2_ops;
+
+void mcam_ctlr_power_up(struct mcam_camera *cam);
+void mcam_ctlr_power_down(struct mcam_camera *cam);
+void mcam_dma_contig_done(struct mcam_camera *cam, int frame);
+void mcam_ctlr_stop(struct mcam_camera *cam);
+int mcam_config_mipi(struct mcam_camera *mcam, int enable);
+void mcam_ctlr_image(struct mcam_camera *cam);
+void mcam_set_config_needed(struct mcam_camera *cam, int needed);
+void mcam_ctlr_dma_contig(struct mcam_camera *cam);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index dccc573..97b40db 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -154,7 +154,7 @@ static void mcam_ctlr_start(struct mcam_camera *cam)
 	mcam_reg_set_bit(cam, REG_CTRL0, C0_ENABLE);
 }
 
-static void mcam_ctlr_stop(struct mcam_camera *cam)
+void mcam_ctlr_stop(struct mcam_camera *cam)
 {
 	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
 }
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 4670c49..57442e0 100755
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
@@ -32,8 +34,13 @@
 #error One of the videobuf buffer modes must be selected in the config
 #endif
 
+#ifdef CONFIG_VIDEO_MRVL_SOC_CAMERA
+#define sensor_call(cam, o, f, args...) \
+	v4l2_subdev_call(soc_camera_to_subdev(cam->icd), o, f, ##args)
+#else
 #define sensor_call(cam, o, f, args...) \
 	v4l2_subdev_call(cam->sensor, o, f, ##args)
+#endif
 
 /*
  * Debugging and related.
@@ -102,6 +109,10 @@ struct mcam_frame_state {
  */
 #define NR_MCAM_CLK 4
 struct mcam_camera {
+#ifdef CONFIG_VIDEO_MRVL_SOC_CAMERA
+	struct soc_camera_host soc_host;
+	struct soc_camera_device *icd;
+#endif
 	/*
 	 * These fields should be set by the platform code prior to
 	 * calling mcam_register().
@@ -115,6 +126,11 @@ struct mcam_camera {
 	short int use_smbus;	/* SMBUS or straight I2c? */
 	enum mcam_buffer_mode buffer_mode;
 
+	int mclk_min;
+	int mclk_src;
+	int mclk_div;
+	char *card_name;
+
 	int ccic_id;
 	enum v4l2_mbus_type bus_type;
 	/* MIPI support */
@@ -258,10 +274,20 @@ static inline void mcam_reg_set_bit(struct mcam_camera *cam,
 	mcam_reg_write_mask(cam, reg, val, val);
 }
 
+#ifdef CONFIG_VIDEO_MRVL_SOC_CAMERA
+static inline struct mcam_camera *get_mcam(struct vb2_queue *vq)
+{
+	struct soc_camera_device *icd = container_of(vq,
+					struct soc_camera_device, vb2_vidq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	return ici->priv;
+}
+#else
 static inline struct mcam_camera *get_mcam(struct vb2_queue *vq)
 {
 	return vb2_get_drv_priv(vq);
 }
+#endif
 
 /*
  * Functions for use by platform code.
@@ -273,6 +299,9 @@ void mccic_shutdown(struct mcam_camera *cam);
 void mccic_suspend(struct mcam_camera *cam);
 int mccic_resume(struct mcam_camera *cam);
 #endif
+#ifdef CONFIG_VIDEO_MRVL_SOC_CAMERA
+int mcam_soc_camera_host_register(struct mcam_camera *mcam);
+#endif
 
 /*
  * Register definitions for the m88alp01 camera interface.  Offsets in bytes
@@ -377,6 +406,7 @@ int mccic_resume(struct mcam_camera *cam);
 /* Bits below C1_444ALPHA are not present in Cafe */
 #define REG_CTRL1	0x40	/* Control 1 */
 #define	  C1_CLKGATE	  0x00000001	/* Sensor clock gate */
+#define   C1_RESERVED	  0x0000003c	/* Reserved and shouldn't be changed */
 #define   C1_DESC_ENA	  0x00000100	/* DMA descriptor enable */
 #define   C1_DESC_3WORD   0x00000200	/* Three-word descriptors used */
 #define	  C1_444ALPHA	  0x00f00000	/* Alpha field in RGB444 */
@@ -387,6 +417,7 @@ int mccic_resume(struct mcam_camera *cam);
 #define	  C1_DMAB_MASK	  0x06000000
 #define	  C1_TWOBUFS	  0x08000000	/* Use only two DMA buffers */
 #define	  C1_PWRDWN	  0x10000000	/* Power down */
+#define   C1_DMAPOSTED	  0x40000000	/* DMA Posted Select */
 
 #define REG_CTRL3	0x1ec	/* CCIC parallel mode */
 #define REG_CLKCTRL	0x88	/* Clock control */
diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
index c339d43..9968031 100755
--- a/include/media/mmp-camera.h
+++ b/include/media/mmp-camera.h
@@ -8,6 +8,9 @@ struct mmp_camera_platform_data {
 	int sensor_power_gpio;
 	int sensor_reset_gpio;
 	enum v4l2_mbus_type bus_type;
+	int mclk_min;
+	int mclk_src;
+	int mclk_div;
 	/*
 	 * MIPI support
 	 */
-- 
1.7.9.5

