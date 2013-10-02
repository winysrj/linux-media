Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41389 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3JBXzo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 19:55:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: devel@driverdev.osuosl.org
Cc: linux-media@vger.kernel.org,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 4/6] v4l: omap4iss: Add support for OMAP4 camera interface - IPIPE(IF)
Date: Thu,  3 Oct 2013 01:55:31 +0200
Message-Id: <1380758133-16866-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1380758133-16866-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1380758133-16866-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sergio Aguirre <sergio.a.aguirre@gmail.com>

This adds a very simplistic driver to utilize the CSI2A interface inside
the ISS subsystem in OMAP4, and dump the data to memory.

Check Documentation/video4linux/omap4_camera.txt for details.

This commit adds the IPIPEIF and IPIPE processing blocks support.

Signed-off-by: Sergio Aguirre <sergio.a.aguirre@gmail.com>

[Port the driver to v3.12-rc3, including the following changes
- Don't include plat/ headers
- Don't use cpu_is_omap44xx() macro
- Don't depend on EXPERIMENTAL
- Fix s_crop operation prototype
- Update link_notify prototype
- Rename media_entity_remote_source to media_entity_remote_pad]

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_ipipe.c   | 581 ++++++++++++++++++
 drivers/staging/media/omap4iss/iss_ipipe.h   |  67 +++
 drivers/staging/media/omap4iss/iss_ipipeif.c | 847 +++++++++++++++++++++++++++
 drivers/staging/media/omap4iss/iss_ipipeif.h |  92 +++
 4 files changed, 1587 insertions(+)
 create mode 100644 drivers/staging/media/omap4iss/iss_ipipe.c
 create mode 100644 drivers/staging/media/omap4iss/iss_ipipe.h
 create mode 100644 drivers/staging/media/omap4iss/iss_ipipeif.c
 create mode 100644 drivers/staging/media/omap4iss/iss_ipipeif.h

diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
new file mode 100644
index 0000000..fc38a5c5
--- /dev/null
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -0,0 +1,581 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - ISP IPIPE module
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+
+#include "iss.h"
+#include "iss_regs.h"
+#include "iss_ipipe.h"
+
+static struct v4l2_mbus_framefmt *
+__ipipe_get_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_fh *fh,
+		  unsigned int pad, enum v4l2_subdev_format_whence which);
+
+static const unsigned int ipipe_fmts[] = {
+	V4L2_MBUS_FMT_SGRBG10_1X10,
+	V4L2_MBUS_FMT_SRGGB10_1X10,
+	V4L2_MBUS_FMT_SBGGR10_1X10,
+	V4L2_MBUS_FMT_SGBRG10_1X10,
+};
+
+/*
+ * ipipe_print_status - Print current IPIPE Module register values.
+ * @ipipe: Pointer to ISS ISP IPIPE device.
+ *
+ * Also prints other debug information stored in the IPIPE module.
+ */
+#define IPIPE_PRINT_REGISTER(iss, name)\
+	dev_dbg(iss->dev, "###IPIPE " #name "=0x%08x\n", \
+		readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_##name))
+
+static void ipipe_print_status(struct iss_ipipe_device *ipipe)
+{
+	struct iss_device *iss = to_iss_device(ipipe);
+
+	dev_dbg(iss->dev, "-------------IPIPE Register dump-------------\n");
+
+	IPIPE_PRINT_REGISTER(iss, SRC_EN);
+	IPIPE_PRINT_REGISTER(iss, SRC_MODE);
+	IPIPE_PRINT_REGISTER(iss, SRC_FMT);
+	IPIPE_PRINT_REGISTER(iss, SRC_COL);
+	IPIPE_PRINT_REGISTER(iss, SRC_VPS);
+	IPIPE_PRINT_REGISTER(iss, SRC_VSZ);
+	IPIPE_PRINT_REGISTER(iss, SRC_HPS);
+	IPIPE_PRINT_REGISTER(iss, SRC_HSZ);
+	IPIPE_PRINT_REGISTER(iss, GCK_MMR);
+	IPIPE_PRINT_REGISTER(iss, YUV_PHS);
+
+	dev_dbg(iss->dev, "-----------------------------------------------\n");
+}
+
+/*
+ * ipipe_enable - Enable/Disable IPIPE.
+ * @enable: enable flag
+ *
+ */
+static void ipipe_enable(struct iss_ipipe_device *ipipe, u8 enable)
+{
+	struct iss_device *iss = to_iss_device(ipipe);
+
+	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_EN) &
+		~IPIPE_SRC_EN_EN) |
+		enable ? IPIPE_SRC_EN_EN : 0,
+		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_EN);
+}
+
+/* -----------------------------------------------------------------------------
+ * Format- and pipeline-related configuration helpers
+ */
+
+static void ipipe_configure(struct iss_ipipe_device *ipipe)
+{
+	struct iss_device *iss = to_iss_device(ipipe);
+	struct v4l2_mbus_framefmt *format;
+
+	/* IPIPE_PAD_SINK */
+	format = &ipipe->formats[IPIPE_PAD_SINK];
+
+	/* NOTE: Currently just supporting pipeline IN: RGB, OUT: YUV422 */
+	writel(IPIPE_SRC_FMT_RAW2YUV,
+		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_FMT);
+
+	/* Enable YUV444 -> YUV422 conversion */
+	writel(IPIPE_YUV_PHS_LPF,
+		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_YUV_PHS);
+
+	writel(0, iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_VPS);
+	writel(0, iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_HPS);
+	writel((format->height - 2) & IPIPE_SRC_VSZ_MASK,
+		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_VSZ);
+	writel((format->width - 1) & IPIPE_SRC_HSZ_MASK,
+		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_HSZ);
+
+	/* Ignore ipipeif_wrt signal, and operate on-the-fly.  */
+	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_MODE) &
+		~(IPIPE_SRC_MODE_WRT | IPIPE_SRC_MODE_OST),
+		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_MODE);
+
+	/* HACK: Values tuned for Ducati SW (OV) */
+	writel(IPIPE_SRC_COL_EE_B |
+		IPIPE_SRC_COL_EO_GB |
+		IPIPE_SRC_COL_OE_GR |
+		IPIPE_SRC_COL_OO_R,
+		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_COL);
+
+	/* IPIPE_PAD_SOURCE_VP */
+	format = &ipipe->formats[IPIPE_PAD_SOURCE_VP];
+	/* Do nothing? */
+
+	omap4iss_isp_enable_interrupts(iss);
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev operations
+ */
+
+/*
+ * ipipe_set_stream - Enable/Disable streaming on the IPIPE module
+ * @sd: ISP IPIPE V4L2 subdevice
+ * @enable: Enable/disable stream
+ */
+static int ipipe_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
+	struct iss_device *iss = to_iss_device(ipipe);
+	int ret = 0;
+
+	if (ipipe->state == ISS_PIPELINE_STREAM_STOPPED) {
+		if (enable == ISS_PIPELINE_STREAM_STOPPED)
+			return 0;
+
+		omap4iss_isp_subclk_enable(iss, OMAP4_ISS_ISP_SUBCLK_IPIPE);
+
+		/* Enable clk_arm_g0 */
+		writel(IPIPE_GCK_MMR_REG,
+			iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_GCK_MMR);
+
+		/* Enable clk_pix_g[3:0] */
+		writel(IPIPE_GCK_PIX_G3 |
+			IPIPE_GCK_PIX_G2 |
+			IPIPE_GCK_PIX_G1 |
+			IPIPE_GCK_PIX_G0,
+			iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_GCK_PIX);
+	}
+
+	switch (enable) {
+	case ISS_PIPELINE_STREAM_CONTINUOUS:
+
+		ipipe_configure(ipipe);
+		ipipe_print_status(ipipe);
+
+		atomic_set(&ipipe->stopping, 0);
+		ipipe_enable(ipipe, 1);
+		break;
+
+	case ISS_PIPELINE_STREAM_STOPPED:
+		if (ipipe->state == ISS_PIPELINE_STREAM_STOPPED)
+			return 0;
+		if (omap4iss_module_sync_idle(&sd->entity, &ipipe->wait,
+					      &ipipe->stopping))
+			dev_dbg(iss->dev, "%s: module stop timeout.\n",
+				sd->name);
+
+		ipipe_enable(ipipe, 0);
+		omap4iss_isp_disable_interrupts(iss);
+		omap4iss_isp_subclk_disable(iss, OMAP4_ISS_ISP_SUBCLK_IPIPE);
+		break;
+	}
+
+	ipipe->state = enable;
+	return ret;
+}
+
+static struct v4l2_mbus_framefmt *
+__ipipe_get_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_fh *fh,
+		  unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(fh, pad);
+	else
+		return &ipipe->formats[pad];
+}
+
+/*
+ * ipipe_try_format - Try video format on a pad
+ * @ipipe: ISS IPIPE device
+ * @fh : V4L2 subdev file handle
+ * @pad: Pad number
+ * @fmt: Format
+ */
+static void
+ipipe_try_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_fh *fh,
+		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
+		enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_mbus_framefmt *format;
+	unsigned int width = fmt->width;
+	unsigned int height = fmt->height;
+	unsigned int i;
+
+	switch (pad) {
+	case IPIPE_PAD_SINK:
+		for (i = 0; i < ARRAY_SIZE(ipipe_fmts); i++) {
+			if (fmt->code == ipipe_fmts[i])
+				break;
+		}
+
+		/* If not found, use SGRBG10 as default */
+		if (i >= ARRAY_SIZE(ipipe_fmts))
+			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+
+		/* Clamp the input size. */
+		fmt->width = clamp_t(u32, width, 1, 8192);
+		fmt->height = clamp_t(u32, height, 1, 8192);
+		fmt->colorspace = V4L2_COLORSPACE_SRGB;
+		break;
+
+	case IPIPE_PAD_SOURCE_VP:
+		format = __ipipe_get_format(ipipe, fh, IPIPE_PAD_SINK, which);
+		memcpy(fmt, format, sizeof(*fmt));
+
+		fmt->code = V4L2_MBUS_FMT_UYVY8_1X16;
+		fmt->width = clamp_t(u32, width, 32, fmt->width);
+		fmt->height = clamp_t(u32, height, 32, fmt->height);
+		fmt->colorspace = V4L2_COLORSPACE_JPEG;
+		break;
+	}
+
+	fmt->field = V4L2_FIELD_NONE;
+}
+
+/*
+ * ipipe_enum_mbus_code - Handle pixel format enumeration
+ * @sd     : pointer to v4l2 subdev structure
+ * @fh : V4L2 subdev file handle
+ * @code   : pointer to v4l2_subdev_mbus_code_enum structure
+ * return -EINVAL or zero on success
+ */
+static int ipipe_enum_mbus_code(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_mbus_code_enum *code)
+{
+	switch (code->pad) {
+	case IPIPE_PAD_SINK:
+		if (code->index >= ARRAY_SIZE(ipipe_fmts))
+			return -EINVAL;
+
+		code->code = ipipe_fmts[code->index];
+		break;
+
+	case IPIPE_PAD_SOURCE_VP:
+		/* FIXME: Forced format conversion inside IPIPE ? */
+		if (code->index != 0)
+			return -EINVAL;
+
+		code->code = V4L2_MBUS_FMT_UYVY8_1X16;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ipipe_enum_frame_size(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt format;
+
+	if (fse->index != 0)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = 1;
+	format.height = 1;
+	ipipe_try_format(ipipe, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->min_width = format.width;
+	fse->min_height = format.height;
+
+	if (format.code != fse->code)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = -1;
+	format.height = -1;
+	ipipe_try_format(ipipe, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->max_width = format.width;
+	fse->max_height = format.height;
+
+	return 0;
+}
+
+/*
+ * ipipe_get_format - Retrieve the video format on a pad
+ * @sd : ISP IPIPE V4L2 subdevice
+ * @fh : V4L2 subdev file handle
+ * @fmt: Format
+ *
+ * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
+ * to the format type.
+ */
+static int ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __ipipe_get_format(ipipe, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	fmt->format = *format;
+	return 0;
+}
+
+/*
+ * ipipe_set_format - Set the video format on a pad
+ * @sd : ISP IPIPE V4L2 subdevice
+ * @fh : V4L2 subdev file handle
+ * @fmt: Format
+ *
+ * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
+ * to the format type.
+ */
+static int ipipe_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __ipipe_get_format(ipipe, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	ipipe_try_format(ipipe, fh, fmt->pad, &fmt->format, fmt->which);
+	*format = fmt->format;
+
+	/* Propagate the format from sink to source */
+	if (fmt->pad == IPIPE_PAD_SINK) {
+		format = __ipipe_get_format(ipipe, fh, IPIPE_PAD_SOURCE_VP,
+					   fmt->which);
+		*format = fmt->format;
+		ipipe_try_format(ipipe, fh, IPIPE_PAD_SOURCE_VP, format,
+				fmt->which);
+	}
+
+	return 0;
+}
+
+static int ipipe_link_validate(struct v4l2_subdev *sd, struct media_link *link,
+				 struct v4l2_subdev_format *source_fmt,
+				 struct v4l2_subdev_format *sink_fmt)
+{
+	/* Check if the two ends match */
+	if (source_fmt->format.width != sink_fmt->format.width ||
+	    source_fmt->format.height != sink_fmt->format.height)
+		return -EPIPE;
+
+	if (source_fmt->format.code != sink_fmt->format.code)
+		return -EPIPE;
+
+	return 0;
+}
+
+/*
+ * ipipe_init_formats - Initialize formats on all pads
+ * @sd: ISP IPIPE V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values. If fh is not NULL, try
+ * formats are initialized on the file handle. Otherwise active formats are
+ * initialized on the device.
+ */
+static int ipipe_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_subdev_format format;
+
+	memset(&format, 0, sizeof(format));
+	format.pad = IPIPE_PAD_SINK;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.width = 4096;
+	format.format.height = 4096;
+	ipipe_set_format(sd, fh, &format);
+
+	return 0;
+}
+
+/* V4L2 subdev video operations */
+static const struct v4l2_subdev_video_ops ipipe_v4l2_video_ops = {
+	.s_stream = ipipe_set_stream,
+};
+
+/* V4L2 subdev pad operations */
+static const struct v4l2_subdev_pad_ops ipipe_v4l2_pad_ops = {
+	.enum_mbus_code = ipipe_enum_mbus_code,
+	.enum_frame_size = ipipe_enum_frame_size,
+	.get_fmt = ipipe_get_format,
+	.set_fmt = ipipe_set_format,
+	.link_validate = ipipe_link_validate,
+};
+
+/* V4L2 subdev operations */
+static const struct v4l2_subdev_ops ipipe_v4l2_ops = {
+	.video = &ipipe_v4l2_video_ops,
+	.pad = &ipipe_v4l2_pad_ops,
+};
+
+/* V4L2 subdev internal operations */
+static const struct v4l2_subdev_internal_ops ipipe_v4l2_internal_ops = {
+	.open = ipipe_init_formats,
+};
+
+/* -----------------------------------------------------------------------------
+ * Media entity operations
+ */
+
+/*
+ * ipipe_link_setup - Setup IPIPE connections
+ * @entity: IPIPE media entity
+ * @local: Pad at the local end of the link
+ * @remote: Pad at the remote end of the link
+ * @flags: Link flags
+ *
+ * return -EINVAL or zero on success
+ */
+static int ipipe_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
+	struct iss_device *iss = to_iss_device(ipipe);
+
+	switch (local->index | media_entity_type(remote->entity)) {
+	case IPIPE_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* Read from IPIPEIF. */
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			ipipe->input = IPIPE_INPUT_NONE;
+			break;
+		}
+
+		if (ipipe->input != IPIPE_INPUT_NONE)
+			return -EBUSY;
+
+		if (remote->entity == &iss->ipipeif.subdev.entity)
+			ipipe->input = IPIPE_INPUT_IPIPEIF;
+
+		break;
+
+	case IPIPE_PAD_SOURCE_VP | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* Send to RESIZER */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (ipipe->output & ~IPIPE_OUTPUT_VP)
+				return -EBUSY;
+			ipipe->output |= IPIPE_OUTPUT_VP;
+		} else {
+			ipipe->output &= ~IPIPE_OUTPUT_VP;
+		}
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* media operations */
+static const struct media_entity_operations ipipe_media_ops = {
+	.link_setup = ipipe_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+/*
+ * ipipe_init_entities - Initialize V4L2 subdev and media entity
+ * @ipipe: ISS ISP IPIPE module
+ *
+ * Return 0 on success and a negative error code on failure.
+ */
+static int ipipe_init_entities(struct iss_ipipe_device *ipipe)
+{
+	struct v4l2_subdev *sd = &ipipe->subdev;
+	struct media_pad *pads = ipipe->pads;
+	struct media_entity *me = &sd->entity;
+	int ret;
+
+	ipipe->input = IPIPE_INPUT_NONE;
+
+	v4l2_subdev_init(sd, &ipipe_v4l2_ops);
+	sd->internal_ops = &ipipe_v4l2_internal_ops;
+	strlcpy(sd->name, "OMAP4 ISS ISP IPIPE", sizeof(sd->name));
+	sd->grp_id = 1 << 16;	/* group ID for iss subdevs */
+	v4l2_set_subdevdata(sd, ipipe);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	pads[IPIPE_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[IPIPE_PAD_SOURCE_VP].flags = MEDIA_PAD_FL_SOURCE;
+
+	me->ops = &ipipe_media_ops;
+	ret = media_entity_init(me, IPIPE_PADS_NUM, pads, 0);
+	if (ret < 0)
+		return ret;
+
+	ipipe_init_formats(sd, NULL);
+
+	return 0;
+}
+
+void omap4iss_ipipe_unregister_entities(struct iss_ipipe_device *ipipe)
+{
+	media_entity_cleanup(&ipipe->subdev.entity);
+
+	v4l2_device_unregister_subdev(&ipipe->subdev);
+}
+
+int omap4iss_ipipe_register_entities(struct iss_ipipe_device *ipipe,
+	struct v4l2_device *vdev)
+{
+	int ret;
+
+	/* Register the subdev and video node. */
+	ret = v4l2_device_register_subdev(vdev, &ipipe->subdev);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
+	omap4iss_ipipe_unregister_entities(ipipe);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * ISP IPIPE initialisation and cleanup
+ */
+
+/*
+ * omap4iss_ipipe_init - IPIPE module initialization.
+ * @iss: Device pointer specific to the OMAP4 ISS.
+ *
+ * TODO: Get the initialisation values from platform data.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int omap4iss_ipipe_init(struct iss_device *iss)
+{
+	struct iss_ipipe_device *ipipe = &iss->ipipe;
+
+	ipipe->state = ISS_PIPELINE_STREAM_STOPPED;
+	init_waitqueue_head(&ipipe->wait);
+
+	return ipipe_init_entities(ipipe);
+}
+
+/*
+ * omap4iss_ipipe_cleanup - IPIPE module cleanup.
+ * @iss: Device pointer specific to the OMAP4 ISS.
+ */
+void omap4iss_ipipe_cleanup(struct iss_device *iss)
+{
+	/* FIXME: are you sure there's nothing to do? */
+}
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.h b/drivers/staging/media/omap4iss/iss_ipipe.h
new file mode 100644
index 0000000..c22d904
--- /dev/null
+++ b/drivers/staging/media/omap4iss/iss_ipipe.h
@@ -0,0 +1,67 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - ISP IPIPE module
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef OMAP4_ISS_IPIPE_H
+#define OMAP4_ISS_IPIPE_H
+
+#include "iss_video.h"
+
+enum ipipe_input_entity {
+	IPIPE_INPUT_NONE,
+	IPIPE_INPUT_IPIPEIF,
+};
+
+#define IPIPE_OUTPUT_VP		(1 << 0)
+
+/* Sink and source IPIPE pads */
+#define IPIPE_PAD_SINK				0
+#define IPIPE_PAD_SOURCE_VP			1
+#define IPIPE_PADS_NUM				2
+
+/*
+ * struct iss_ipipe_device - Structure for the IPIPE module to store its own
+ *			    information
+ * @subdev: V4L2 subdevice
+ * @pads: Sink and source media entity pads
+ * @formats: Active video formats
+ * @input: Active input
+ * @output: Active outputs
+ * @error: A hardware error occurred during capture
+ * @state: Streaming state
+ * @wait: Wait queue used to stop the module
+ * @stopping: Stopping state
+ */
+struct iss_ipipe_device {
+	struct v4l2_subdev subdev;
+	struct media_pad pads[IPIPE_PADS_NUM];
+	struct v4l2_mbus_framefmt formats[IPIPE_PADS_NUM];
+
+	enum ipipe_input_entity input;
+	unsigned int output;
+	unsigned int error;
+
+	enum iss_pipeline_stream_state state;
+	wait_queue_head_t wait;
+	atomic_t stopping;
+};
+
+struct iss_device;
+
+int omap4iss_ipipe_register_entities(struct iss_ipipe_device *ipipe,
+	struct v4l2_device *vdev);
+void omap4iss_ipipe_unregister_entities(struct iss_ipipe_device *ipipe);
+
+int omap4iss_ipipe_init(struct iss_device *iss);
+void omap4iss_ipipe_cleanup(struct iss_device *iss);
+
+#endif	/* OMAP4_ISS_IPIPE_H */
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
new file mode 100644
index 0000000..acc6005
--- /dev/null
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -0,0 +1,847 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - ISP IPIPEIF module
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+
+#include "iss.h"
+#include "iss_regs.h"
+#include "iss_ipipeif.h"
+
+static struct v4l2_mbus_framefmt *
+__ipipeif_get_format(struct iss_ipipeif_device *ipipeif, struct v4l2_subdev_fh *fh,
+		  unsigned int pad, enum v4l2_subdev_format_whence which);
+
+static const unsigned int ipipeif_fmts[] = {
+	V4L2_MBUS_FMT_SGRBG10_1X10,
+	V4L2_MBUS_FMT_SRGGB10_1X10,
+	V4L2_MBUS_FMT_SBGGR10_1X10,
+	V4L2_MBUS_FMT_SGBRG10_1X10,
+	V4L2_MBUS_FMT_UYVY8_1X16,
+	V4L2_MBUS_FMT_YUYV8_1X16,
+};
+
+/*
+ * ipipeif_print_status - Print current IPIPEIF Module register values.
+ * @ipipeif: Pointer to ISS ISP IPIPEIF device.
+ *
+ * Also prints other debug information stored in the IPIPEIF module.
+ */
+#define IPIPEIF_PRINT_REGISTER(iss, name)\
+	dev_dbg(iss->dev, "###IPIPEIF " #name "=0x%08x\n", \
+		readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_##name))
+
+#define ISIF_PRINT_REGISTER(iss, name)\
+	dev_dbg(iss->dev, "###ISIF " #name "=0x%08x\n", \
+		readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_##name))
+
+#define ISP5_PRINT_REGISTER(iss, name)\
+	dev_dbg(iss->dev, "###ISP5 " #name "=0x%08x\n", \
+		readl(iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_##name))
+
+static void ipipeif_print_status(struct iss_ipipeif_device *ipipeif)
+{
+	struct iss_device *iss = to_iss_device(ipipeif);
+
+	dev_dbg(iss->dev, "-------------IPIPEIF Register dump-------------\n");
+
+	IPIPEIF_PRINT_REGISTER(iss, CFG1);
+	IPIPEIF_PRINT_REGISTER(iss, CFG2);
+
+	ISIF_PRINT_REGISTER(iss, SYNCEN);
+	ISIF_PRINT_REGISTER(iss, CADU);
+	ISIF_PRINT_REGISTER(iss, CADL);
+	ISIF_PRINT_REGISTER(iss, MODESET);
+	ISIF_PRINT_REGISTER(iss, CCOLP);
+	ISIF_PRINT_REGISTER(iss, SPH);
+	ISIF_PRINT_REGISTER(iss, LNH);
+	ISIF_PRINT_REGISTER(iss, LNV);
+	ISIF_PRINT_REGISTER(iss, VDINT0);
+	ISIF_PRINT_REGISTER(iss, HSIZE);
+
+	ISP5_PRINT_REGISTER(iss, SYSCONFIG);
+	ISP5_PRINT_REGISTER(iss, CTRL);
+	ISP5_PRINT_REGISTER(iss, IRQSTATUS(0));
+	ISP5_PRINT_REGISTER(iss, IRQENABLE_SET(0));
+	ISP5_PRINT_REGISTER(iss, IRQENABLE_CLR(0));
+
+	dev_dbg(iss->dev, "-----------------------------------------------\n");
+}
+
+static void ipipeif_write_enable(struct iss_ipipeif_device *ipipeif, u8 enable)
+{
+	struct iss_device *iss = to_iss_device(ipipeif);
+
+	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SYNCEN) &
+		~ISIF_SYNCEN_DWEN) |
+		enable ? ISIF_SYNCEN_DWEN : 0,
+		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SYNCEN);
+}
+
+/*
+ * ipipeif_enable - Enable/Disable IPIPEIF.
+ * @enable: enable flag
+ *
+ */
+static void ipipeif_enable(struct iss_ipipeif_device *ipipeif, u8 enable)
+{
+	struct iss_device *iss = to_iss_device(ipipeif);
+
+	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SYNCEN) &
+		~ISIF_SYNCEN_SYEN) |
+		enable ? ISIF_SYNCEN_SYEN : 0,
+		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SYNCEN);
+}
+
+/* -----------------------------------------------------------------------------
+ * Format- and pipeline-related configuration helpers
+ */
+
+/*
+ * ipipeif_set_outaddr - Set memory address to save output image
+ * @ipipeif: Pointer to ISP IPIPEIF device.
+ * @addr: 32-bit memory address aligned on 32 byte boundary.
+ *
+ * Sets the memory address where the output will be saved.
+ */
+static void ipipeif_set_outaddr(struct iss_ipipeif_device *ipipeif, u32 addr)
+{
+	struct iss_device *iss = to_iss_device(ipipeif);
+
+	/* Save address splitted in Base Address H & L */
+	writel((addr >> (16 + 5)) & ISIF_CADU_MASK,
+		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_CADU);
+	writel((addr >> 5) & ISIF_CADL_MASK,
+		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_CADL);
+}
+
+static void ipipeif_configure(struct iss_ipipeif_device *ipipeif)
+{
+	struct iss_device *iss = to_iss_device(ipipeif);
+	struct v4l2_mbus_framefmt *format;
+	u32 isif_ccolp = 0;
+
+	omap4iss_configure_bridge(iss, ipipeif->input);
+
+	/* IPIPEIF_PAD_SINK */
+	format = &ipipeif->formats[IPIPEIF_PAD_SINK];
+
+	/* IPIPEIF with YUV422 input from ISIF */
+	writel(readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_CFG1) &
+		~(IPIPEIF_CFG1_INPSRC1_MASK | IPIPEIF_CFG1_INPSRC2_MASK),
+		iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_CFG1);
+
+	/* Select ISIF/IPIPEIF input format */
+	switch (format->code) {
+	case V4L2_MBUS_FMT_UYVY8_1X16:
+	case V4L2_MBUS_FMT_YUYV8_1X16:
+		writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_MODESET) &
+			~(ISIF_MODESET_CCDMD |
+			  ISIF_MODESET_INPMOD_MASK |
+			  ISIF_MODESET_CCDW_MASK)) |
+			ISIF_MODESET_INPMOD_YCBCR16,
+			iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_MODESET);
+
+		writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_CFG2) &
+			~IPIPEIF_CFG2_YUV8) |
+			IPIPEIF_CFG2_YUV16,
+			iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_CFG2);
+
+		break;
+	case V4L2_MBUS_FMT_SGRBG10_1X10:
+		isif_ccolp = ISIF_CCOLP_CP0_F0_GR |
+			ISIF_CCOLP_CP1_F0_R |
+			ISIF_CCOLP_CP2_F0_B |
+			ISIF_CCOLP_CP3_F0_GB;
+		goto cont_raw;
+	case V4L2_MBUS_FMT_SRGGB10_1X10:
+		isif_ccolp = ISIF_CCOLP_CP0_F0_R |
+			ISIF_CCOLP_CP1_F0_GR |
+			ISIF_CCOLP_CP2_F0_GB |
+			ISIF_CCOLP_CP3_F0_B;
+		goto cont_raw;
+	case V4L2_MBUS_FMT_SBGGR10_1X10:
+		isif_ccolp = ISIF_CCOLP_CP0_F0_B |
+			ISIF_CCOLP_CP1_F0_GB |
+			ISIF_CCOLP_CP2_F0_GR |
+			ISIF_CCOLP_CP3_F0_R;
+		goto cont_raw;
+	case V4L2_MBUS_FMT_SGBRG10_1X10:
+		isif_ccolp = ISIF_CCOLP_CP0_F0_GB |
+			ISIF_CCOLP_CP1_F0_B |
+			ISIF_CCOLP_CP2_F0_R |
+			ISIF_CCOLP_CP3_F0_GR;
+cont_raw:
+		writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_CFG2) &
+			~IPIPEIF_CFG2_YUV16),
+			iss->regs[OMAP4_ISS_MEM_ISP_IPIPEIF] + IPIPEIF_CFG2);
+
+		writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_MODESET) &
+			~(ISIF_MODESET_CCDMD |
+			  ISIF_MODESET_INPMOD_MASK |
+			  ISIF_MODESET_CCDW_MASK)) |
+			ISIF_MODESET_INPMOD_RAW | ISIF_MODESET_CCDW_2BIT,
+			iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_MODESET);
+
+		writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_CGAMMAWD) &
+			~ISIF_CGAMMAWD_GWDI_MASK) |
+			ISIF_CGAMMAWD_GWDI_BIT11,
+			iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_CGAMMAWD);
+
+		/* Set RAW Bayer pattern */
+		writel(isif_ccolp,
+			iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_CCOLP);
+		break;
+	}
+
+	writel(0 & ISIF_SPH_MASK, iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SPH);
+	writel((format->width - 1) & ISIF_LNH_MASK,
+		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_LNH);
+	writel((format->height - 1) & ISIF_LNV_MASK,
+		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_LNV);
+
+	/* Generate ISIF0 on the last line of the image */
+	writel(format->height - 1,
+		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_VDINT0);
+
+	/* IPIPEIF_PAD_SOURCE_ISIF_SF */
+	format = &ipipeif->formats[IPIPEIF_PAD_SOURCE_ISIF_SF];
+
+	writel((ipipeif->video_out.bpl_value >> 5) & ISIF_HSIZE_HSIZE_MASK,
+		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_HSIZE);
+
+	/* IPIPEIF_PAD_SOURCE_VP */
+	/* Do nothing? */
+
+	omap4iss_isp_enable_interrupts(iss);
+}
+
+/* -----------------------------------------------------------------------------
+ * Interrupt handling
+ */
+
+static void ipipeif_isr_buffer(struct iss_ipipeif_device *ipipeif)
+{
+	struct iss_buffer *buffer;
+
+	ipipeif_write_enable(ipipeif, 0);
+
+	buffer = omap4iss_video_buffer_next(&ipipeif->video_out);
+	if (buffer == NULL)
+		return;
+
+	ipipeif_set_outaddr(ipipeif, buffer->iss_addr);
+
+	ipipeif_write_enable(ipipeif, 1);
+}
+
+/*
+ * ipipeif_isif0_isr - Handle ISIF0 event
+ * @ipipeif: Pointer to ISP IPIPEIF device.
+ *
+ * Executes LSC deferred enablement before next frame starts.
+ */
+static void ipipeif_isif0_isr(struct iss_ipipeif_device *ipipeif)
+{
+	struct iss_pipeline *pipe =
+			     to_iss_pipeline(&ipipeif->subdev.entity);
+	if (pipe->do_propagation)
+		atomic_inc(&pipe->frame_number);
+
+	if (ipipeif->output & IPIPEIF_OUTPUT_MEMORY)
+		ipipeif_isr_buffer(ipipeif);
+}
+
+/*
+ * omap4iss_ipipeif_isr - Configure ipipeif during interframe time.
+ * @ipipeif: Pointer to ISP IPIPEIF device.
+ * @events: IPIPEIF events
+ */
+void omap4iss_ipipeif_isr(struct iss_ipipeif_device *ipipeif, u32 events)
+{
+	if (omap4iss_module_sync_is_stopping(&ipipeif->wait, &ipipeif->stopping))
+		return;
+
+	if (events & ISP5_IRQ_ISIF0)
+		ipipeif_isif0_isr(ipipeif);
+}
+
+/* -----------------------------------------------------------------------------
+ * ISP video operations
+ */
+
+static int ipipeif_video_queue(struct iss_video *video, struct iss_buffer *buffer)
+{
+	struct iss_ipipeif_device *ipipeif = container_of(video,
+				struct iss_ipipeif_device, video_out);
+
+	if (!(ipipeif->output & IPIPEIF_OUTPUT_MEMORY))
+		return -ENODEV;
+
+	ipipeif_set_outaddr(ipipeif, buffer->iss_addr);
+
+	/*
+	 * If streaming was enabled before there was a buffer queued
+	 * or underrun happened in the ISR, the hardware was not enabled
+	 * and DMA queue flag ISS_VIDEO_DMAQUEUE_UNDERRUN is still set.
+	 * Enable it now.
+	 */
+	if (video->dmaqueue_flags & ISS_VIDEO_DMAQUEUE_UNDERRUN) {
+		if (ipipeif->output & IPIPEIF_OUTPUT_MEMORY)
+			ipipeif_write_enable(ipipeif, 1);
+		ipipeif_enable(ipipeif, 1);
+		iss_video_dmaqueue_flags_clr(video);
+	}
+
+	return 0;
+}
+
+static const struct iss_video_operations ipipeif_video_ops = {
+	.queue = ipipeif_video_queue,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev operations
+ */
+
+#define IPIPEIF_DRV_SUBCLK_MASK	(OMAP4_ISS_ISP_SUBCLK_IPIPEIF |\
+				 OMAP4_ISS_ISP_SUBCLK_ISIF)
+/*
+ * ipipeif_set_stream - Enable/Disable streaming on the IPIPEIF module
+ * @sd: ISP IPIPEIF V4L2 subdevice
+ * @enable: Enable/disable stream
+ */
+static int ipipeif_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct iss_device *iss = to_iss_device(ipipeif);
+	struct iss_video *video_out = &ipipeif->video_out;
+	int ret = 0;
+
+	if (ipipeif->state == ISS_PIPELINE_STREAM_STOPPED) {
+		if (enable == ISS_PIPELINE_STREAM_STOPPED)
+			return 0;
+
+		omap4iss_isp_subclk_enable(iss, IPIPEIF_DRV_SUBCLK_MASK);
+	}
+
+	switch (enable) {
+	case ISS_PIPELINE_STREAM_CONTINUOUS:
+
+		ipipeif_configure(ipipeif);
+		ipipeif_print_status(ipipeif);
+
+		/*
+		 * When outputting to memory with no buffer available, let the
+		 * buffer queue handler start the hardware. A DMA queue flag
+		 * ISS_VIDEO_DMAQUEUE_QUEUED will be set as soon as there is
+		 * a buffer available.
+		 */
+		if (ipipeif->output & IPIPEIF_OUTPUT_MEMORY &&
+		    !(video_out->dmaqueue_flags & ISS_VIDEO_DMAQUEUE_QUEUED))
+			break;
+
+		atomic_set(&ipipeif->stopping, 0);
+		if (ipipeif->output & IPIPEIF_OUTPUT_MEMORY)
+			ipipeif_write_enable(ipipeif, 1);
+		ipipeif_enable(ipipeif, 1);
+		iss_video_dmaqueue_flags_clr(video_out);
+		break;
+
+	case ISS_PIPELINE_STREAM_STOPPED:
+		if (ipipeif->state == ISS_PIPELINE_STREAM_STOPPED)
+			return 0;
+		if (omap4iss_module_sync_idle(&sd->entity, &ipipeif->wait,
+					      &ipipeif->stopping))
+			dev_dbg(iss->dev, "%s: module stop timeout.\n",
+				sd->name);
+
+		if (ipipeif->output & IPIPEIF_OUTPUT_MEMORY)
+			ipipeif_write_enable(ipipeif, 0);
+		ipipeif_enable(ipipeif, 0);
+		omap4iss_isp_disable_interrupts(iss);
+		omap4iss_isp_subclk_disable(iss, IPIPEIF_DRV_SUBCLK_MASK);
+		iss_video_dmaqueue_flags_clr(video_out);
+		break;
+	}
+
+	ipipeif->state = enable;
+	return ret;
+}
+
+static struct v4l2_mbus_framefmt *
+__ipipeif_get_format(struct iss_ipipeif_device *ipipeif, struct v4l2_subdev_fh *fh,
+		  unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(fh, pad);
+	else
+		return &ipipeif->formats[pad];
+}
+
+/*
+ * ipipeif_try_format - Try video format on a pad
+ * @ipipeif: ISS IPIPEIF device
+ * @fh : V4L2 subdev file handle
+ * @pad: Pad number
+ * @fmt: Format
+ */
+static void
+ipipeif_try_format(struct iss_ipipeif_device *ipipeif, struct v4l2_subdev_fh *fh,
+		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
+		enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_mbus_framefmt *format;
+	unsigned int width = fmt->width;
+	unsigned int height = fmt->height;
+	unsigned int i;
+
+	switch (pad) {
+	case IPIPEIF_PAD_SINK:
+		/* TODO: If the IPIPEIF output formatter pad is connected directly
+		 * to the resizer, only YUV formats can be used.
+		 */
+		for (i = 0; i < ARRAY_SIZE(ipipeif_fmts); i++) {
+			if (fmt->code == ipipeif_fmts[i])
+				break;
+		}
+
+		/* If not found, use SGRBG10 as default */
+		if (i >= ARRAY_SIZE(ipipeif_fmts))
+			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+
+		/* Clamp the input size. */
+		fmt->width = clamp_t(u32, width, 1, 8192);
+		fmt->height = clamp_t(u32, height, 1, 8192);
+		break;
+
+	case IPIPEIF_PAD_SOURCE_ISIF_SF:
+		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SINK, which);
+		memcpy(fmt, format, sizeof(*fmt));
+
+		/* The data formatter truncates the number of horizontal output
+		 * pixels to a multiple of 16. To avoid clipping data, allow
+		 * callers to request an output size bigger than the input size
+		 * up to the nearest multiple of 16.
+		 */
+		fmt->width = clamp_t(u32, width, 32, (fmt->width + 15) & ~15);
+		fmt->width &= ~15;
+		fmt->height = clamp_t(u32, height, 32, fmt->height);
+		break;
+
+	case IPIPEIF_PAD_SOURCE_VP:
+		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SINK, which);
+		memcpy(fmt, format, sizeof(*fmt));
+
+		fmt->width = clamp_t(u32, width, 32, fmt->width);
+		fmt->height = clamp_t(u32, height, 32, fmt->height);
+		break;
+	}
+
+	/* Data is written to memory unpacked, each 10-bit or 12-bit pixel is
+	 * stored on 2 bytes.
+	 */
+	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	fmt->field = V4L2_FIELD_NONE;
+}
+
+/*
+ * ipipeif_enum_mbus_code - Handle pixel format enumeration
+ * @sd     : pointer to v4l2 subdev structure
+ * @fh : V4L2 subdev file handle
+ * @code   : pointer to v4l2_subdev_mbus_code_enum structure
+ * return -EINVAL or zero on success
+ */
+static int ipipeif_enum_mbus_code(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	switch (code->pad) {
+	case IPIPEIF_PAD_SINK:
+		if (code->index >= ARRAY_SIZE(ipipeif_fmts))
+			return -EINVAL;
+
+		code->code = ipipeif_fmts[code->index];
+		break;
+
+	case IPIPEIF_PAD_SOURCE_ISIF_SF:
+	case IPIPEIF_PAD_SOURCE_VP:
+		/* No format conversion inside IPIPEIF */
+		if (code->index != 0)
+			return -EINVAL;
+
+		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SINK,
+					      V4L2_SUBDEV_FORMAT_TRY);
+
+		code->code = format->code;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ipipeif_enum_frame_size(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt format;
+
+	if (fse->index != 0)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = 1;
+	format.height = 1;
+	ipipeif_try_format(ipipeif, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->min_width = format.width;
+	fse->min_height = format.height;
+
+	if (format.code != fse->code)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = -1;
+	format.height = -1;
+	ipipeif_try_format(ipipeif, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->max_width = format.width;
+	fse->max_height = format.height;
+
+	return 0;
+}
+
+/*
+ * ipipeif_get_format - Retrieve the video format on a pad
+ * @sd : ISP IPIPEIF V4L2 subdevice
+ * @fh : V4L2 subdev file handle
+ * @fmt: Format
+ *
+ * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
+ * to the format type.
+ */
+static int ipipeif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __ipipeif_get_format(ipipeif, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	fmt->format = *format;
+	return 0;
+}
+
+/*
+ * ipipeif_set_format - Set the video format on a pad
+ * @sd : ISP IPIPEIF V4L2 subdevice
+ * @fh : V4L2 subdev file handle
+ * @fmt: Format
+ *
+ * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
+ * to the format type.
+ */
+static int ipipeif_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __ipipeif_get_format(ipipeif, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	ipipeif_try_format(ipipeif, fh, fmt->pad, &fmt->format, fmt->which);
+	*format = fmt->format;
+
+	/* Propagate the format from sink to source */
+	if (fmt->pad == IPIPEIF_PAD_SINK) {
+		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SOURCE_ISIF_SF,
+					   fmt->which);
+		*format = fmt->format;
+		ipipeif_try_format(ipipeif, fh, IPIPEIF_PAD_SOURCE_ISIF_SF, format,
+				fmt->which);
+
+		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SOURCE_VP,
+					   fmt->which);
+		*format = fmt->format;
+		ipipeif_try_format(ipipeif, fh, IPIPEIF_PAD_SOURCE_VP, format,
+				fmt->which);
+	}
+
+	return 0;
+}
+
+static int ipipeif_link_validate(struct v4l2_subdev *sd, struct media_link *link,
+				 struct v4l2_subdev_format *source_fmt,
+				 struct v4l2_subdev_format *sink_fmt)
+{
+	/* Check if the two ends match */
+	if (source_fmt->format.width != sink_fmt->format.width ||
+	    source_fmt->format.height != sink_fmt->format.height)
+		return -EPIPE;
+
+	if (source_fmt->format.code != sink_fmt->format.code)
+		return -EPIPE;
+
+	return 0;
+}
+
+/*
+ * ipipeif_init_formats - Initialize formats on all pads
+ * @sd: ISP IPIPEIF V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values. If fh is not NULL, try
+ * formats are initialized on the file handle. Otherwise active formats are
+ * initialized on the device.
+ */
+static int ipipeif_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_subdev_format format;
+
+	memset(&format, 0, sizeof(format));
+	format.pad = IPIPEIF_PAD_SINK;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.width = 4096;
+	format.format.height = 4096;
+	ipipeif_set_format(sd, fh, &format);
+
+	return 0;
+}
+
+/* V4L2 subdev video operations */
+static const struct v4l2_subdev_video_ops ipipeif_v4l2_video_ops = {
+	.s_stream = ipipeif_set_stream,
+};
+
+/* V4L2 subdev pad operations */
+static const struct v4l2_subdev_pad_ops ipipeif_v4l2_pad_ops = {
+	.enum_mbus_code = ipipeif_enum_mbus_code,
+	.enum_frame_size = ipipeif_enum_frame_size,
+	.get_fmt = ipipeif_get_format,
+	.set_fmt = ipipeif_set_format,
+	.link_validate = ipipeif_link_validate,
+};
+
+/* V4L2 subdev operations */
+static const struct v4l2_subdev_ops ipipeif_v4l2_ops = {
+	.video = &ipipeif_v4l2_video_ops,
+	.pad = &ipipeif_v4l2_pad_ops,
+};
+
+/* V4L2 subdev internal operations */
+static const struct v4l2_subdev_internal_ops ipipeif_v4l2_internal_ops = {
+	.open = ipipeif_init_formats,
+};
+
+/* -----------------------------------------------------------------------------
+ * Media entity operations
+ */
+
+/*
+ * ipipeif_link_setup - Setup IPIPEIF connections
+ * @entity: IPIPEIF media entity
+ * @local: Pad at the local end of the link
+ * @remote: Pad at the remote end of the link
+ * @flags: Link flags
+ *
+ * return -EINVAL or zero on success
+ */
+static int ipipeif_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct iss_device *iss = to_iss_device(ipipeif);
+
+	switch (local->index | media_entity_type(remote->entity)) {
+	case IPIPEIF_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* Read from the sensor CSI2a or CSI2b. */
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			ipipeif->input = IPIPEIF_INPUT_NONE;
+			break;
+		}
+
+		if (ipipeif->input != IPIPEIF_INPUT_NONE)
+			return -EBUSY;
+
+		if (remote->entity == &iss->csi2a.subdev.entity)
+			ipipeif->input = IPIPEIF_INPUT_CSI2A;
+		else if (remote->entity == &iss->csi2b.subdev.entity)
+			ipipeif->input = IPIPEIF_INPUT_CSI2B;
+
+		break;
+
+	case IPIPEIF_PAD_SOURCE_ISIF_SF | MEDIA_ENT_T_DEVNODE:
+		/* Write to memory */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (ipipeif->output & ~IPIPEIF_OUTPUT_MEMORY)
+				return -EBUSY;
+			ipipeif->output |= IPIPEIF_OUTPUT_MEMORY;
+		} else {
+			ipipeif->output &= ~IPIPEIF_OUTPUT_MEMORY;
+		}
+		break;
+
+	case IPIPEIF_PAD_SOURCE_VP | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* Send to IPIPE/RESIZER */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (ipipeif->output & ~IPIPEIF_OUTPUT_VP)
+				return -EBUSY;
+			ipipeif->output |= IPIPEIF_OUTPUT_VP;
+		} else {
+			ipipeif->output &= ~IPIPEIF_OUTPUT_VP;
+		}
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* media operations */
+static const struct media_entity_operations ipipeif_media_ops = {
+	.link_setup = ipipeif_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+/*
+ * ipipeif_init_entities - Initialize V4L2 subdev and media entity
+ * @ipipeif: ISS ISP IPIPEIF module
+ *
+ * Return 0 on success and a negative error code on failure.
+ */
+static int ipipeif_init_entities(struct iss_ipipeif_device *ipipeif)
+{
+	struct v4l2_subdev *sd = &ipipeif->subdev;
+	struct media_pad *pads = ipipeif->pads;
+	struct media_entity *me = &sd->entity;
+	int ret;
+
+	ipipeif->input = IPIPEIF_INPUT_NONE;
+
+	v4l2_subdev_init(sd, &ipipeif_v4l2_ops);
+	sd->internal_ops = &ipipeif_v4l2_internal_ops;
+	strlcpy(sd->name, "OMAP4 ISS ISP IPIPEIF", sizeof(sd->name));
+	sd->grp_id = 1 << 16;	/* group ID for iss subdevs */
+	v4l2_set_subdevdata(sd, ipipeif);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	pads[IPIPEIF_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[IPIPEIF_PAD_SOURCE_ISIF_SF].flags = MEDIA_PAD_FL_SOURCE;
+	pads[IPIPEIF_PAD_SOURCE_VP].flags = MEDIA_PAD_FL_SOURCE;
+
+	me->ops = &ipipeif_media_ops;
+	ret = media_entity_init(me, IPIPEIF_PADS_NUM, pads, 0);
+	if (ret < 0)
+		return ret;
+
+	ipipeif_init_formats(sd, NULL);
+
+	ipipeif->video_out.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ipipeif->video_out.ops = &ipipeif_video_ops;
+	ipipeif->video_out.iss = to_iss_device(ipipeif);
+	ipipeif->video_out.capture_mem = PAGE_ALIGN(4096 * 4096) * 3;
+	ipipeif->video_out.bpl_alignment = 32;
+	ipipeif->video_out.bpl_zero_padding = 1;
+	ipipeif->video_out.bpl_max = 0x1ffe0;
+
+	ret = omap4iss_video_init(&ipipeif->video_out, "ISP IPIPEIF");
+	if (ret < 0)
+		return ret;
+
+	/* Connect the IPIPEIF subdev to the video node. */
+	ret = media_entity_create_link(&ipipeif->subdev.entity, IPIPEIF_PAD_SOURCE_ISIF_SF,
+			&ipipeif->video_out.video.entity, 0, 0);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+void omap4iss_ipipeif_unregister_entities(struct iss_ipipeif_device *ipipeif)
+{
+	media_entity_cleanup(&ipipeif->subdev.entity);
+
+	v4l2_device_unregister_subdev(&ipipeif->subdev);
+	omap4iss_video_unregister(&ipipeif->video_out);
+}
+
+int omap4iss_ipipeif_register_entities(struct iss_ipipeif_device *ipipeif,
+	struct v4l2_device *vdev)
+{
+	int ret;
+
+	/* Register the subdev and video node. */
+	ret = v4l2_device_register_subdev(vdev, &ipipeif->subdev);
+	if (ret < 0)
+		goto error;
+
+	ret = omap4iss_video_register(&ipipeif->video_out, vdev);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
+	omap4iss_ipipeif_unregister_entities(ipipeif);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * ISP IPIPEIF initialisation and cleanup
+ */
+
+/*
+ * omap4iss_ipipeif_init - IPIPEIF module initialization.
+ * @iss: Device pointer specific to the OMAP4 ISS.
+ *
+ * TODO: Get the initialisation values from platform data.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int omap4iss_ipipeif_init(struct iss_device *iss)
+{
+	struct iss_ipipeif_device *ipipeif = &iss->ipipeif;
+
+	ipipeif->state = ISS_PIPELINE_STREAM_STOPPED;
+	init_waitqueue_head(&ipipeif->wait);
+
+	return ipipeif_init_entities(ipipeif);
+}
+
+/*
+ * omap4iss_ipipeif_cleanup - IPIPEIF module cleanup.
+ * @iss: Device pointer specific to the OMAP4 ISS.
+ */
+void omap4iss_ipipeif_cleanup(struct iss_device *iss)
+{
+	/* FIXME: are you sure there's nothing to do? */
+}
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.h b/drivers/staging/media/omap4iss/iss_ipipeif.h
new file mode 100644
index 0000000..cbdccb9
--- /dev/null
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.h
@@ -0,0 +1,92 @@
+/*
+ * TI OMAP4 ISS V4L2 Driver - ISP IPIPEIF module
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ *
+ * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef OMAP4_ISS_IPIPEIF_H
+#define OMAP4_ISS_IPIPEIF_H
+
+#include "iss_video.h"
+
+enum ipipeif_input_entity {
+	IPIPEIF_INPUT_NONE,
+	IPIPEIF_INPUT_CSI2A,
+	IPIPEIF_INPUT_CSI2B
+};
+
+#define IPIPEIF_OUTPUT_MEMORY		(1 << 0)
+#define IPIPEIF_OUTPUT_VP		(1 << 1)
+
+/* Sink and source IPIPEIF pads */
+#define IPIPEIF_PAD_SINK			0
+#define IPIPEIF_PAD_SOURCE_ISIF_SF		1
+#define IPIPEIF_PAD_SOURCE_VP			2
+#define IPIPEIF_PADS_NUM			3
+
+/*
+ * struct iss_ipipeif_device - Structure for the IPIPEIF module to store its own
+ *			    information
+ * @subdev: V4L2 subdevice
+ * @pads: Sink and source media entity pads
+ * @formats: Active video formats
+ * @input: Active input
+ * @output: Active outputs
+ * @video_out: Output video node
+ * @error: A hardware error occurred during capture
+ * @alaw: A-law compression enabled (1) or disabled (0)
+ * @lpf: Low pass filter enabled (1) or disabled (0)
+ * @obclamp: Optical-black clamp enabled (1) or disabled (0)
+ * @fpc_en: Faulty pixels correction enabled (1) or disabled (0)
+ * @blcomp: Black level compensation configuration
+ * @clamp: Optical-black or digital clamp configuration
+ * @fpc: Faulty pixels correction configuration
+ * @lsc: Lens shading compensation configuration
+ * @update: Bitmask of controls to update during the next interrupt
+ * @shadow_update: Controls update in progress by userspace
+ * @syncif: Interface synchronization configuration
+ * @vpcfg: Video port configuration
+ * @underrun: A buffer underrun occurred and a new buffer has been queued
+ * @state: Streaming state
+ * @lock: Serializes shadow_update with interrupt handler
+ * @wait: Wait queue used to stop the module
+ * @stopping: Stopping state
+ * @ioctl_lock: Serializes ioctl calls and LSC requests freeing
+ */
+struct iss_ipipeif_device {
+	struct v4l2_subdev subdev;
+	struct media_pad pads[IPIPEIF_PADS_NUM];
+	struct v4l2_mbus_framefmt formats[IPIPEIF_PADS_NUM];
+
+	enum ipipeif_input_entity input;
+	unsigned int output;
+	struct iss_video video_out;
+	unsigned int error;
+
+	enum iss_pipeline_stream_state state;
+	wait_queue_head_t wait;
+	atomic_t stopping;
+};
+
+struct iss_device;
+
+int omap4iss_ipipeif_init(struct iss_device *iss);
+void omap4iss_ipipeif_cleanup(struct iss_device *iss);
+int omap4iss_ipipeif_register_entities(struct iss_ipipeif_device *ipipeif,
+	struct v4l2_device *vdev);
+void omap4iss_ipipeif_unregister_entities(struct iss_ipipeif_device *ipipeif);
+
+int omap4iss_ipipeif_busy(struct iss_ipipeif_device *ipipeif);
+void omap4iss_ipipeif_isr(struct iss_ipipeif_device *ipipeif, u32 events);
+void omap4iss_ipipeif_restore_context(struct iss_device *iss);
+void omap4iss_ipipeif_max_rate(struct iss_ipipeif_device *ipipeif,
+	unsigned int *max_rate);
+
+#endif	/* OMAP4_ISS_IPIPEIF_H */
-- 
1.8.1.5

