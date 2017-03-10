Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33890 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755137AbdCJEyq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 23:54:46 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v5 26/39] media: imx: Add VDIC subdev driver
Date: Thu,  9 Mar 2017 20:53:06 -0800
Message-Id: <1489121599-23206-27-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a media entity subdevice driver for the i.MX Video De-Interlacing
or Combining Block. So far this entity does not implement the Combining
function but only motion compensated deinterlacing. Video frames are
received from the CSI and are routed to the IC PRPVF entity.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/Makefile         |   1 +
 drivers/staging/media/imx/imx-media-vdic.c | 952 +++++++++++++++++++++++++++++
 2 files changed, 953 insertions(+)
 create mode 100644 drivers/staging/media/imx/imx-media-vdic.c

diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
index c054490..1f01520 100644
--- a/drivers/staging/media/imx/Makefile
+++ b/drivers/staging/media/imx/Makefile
@@ -4,5 +4,6 @@ imx-media-common-objs := imx-media-utils.o imx-media-fim.o
 obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media.o
 obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-common.o
 obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-capture.o
+obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-vdic.o
 
 obj-$(CONFIG_VIDEO_IMX_CSI) += imx-media-csi.o
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
new file mode 100644
index 0000000..0e7c24c
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -0,0 +1,952 @@
+/*
+ * V4L2 Deinterlacer Subdev for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2017 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/timer.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mc.h>
+#include <media/v4l2-subdev.h>
+#include <media/imx.h>
+#include "imx-media.h"
+
+/*
+ * This subdev implements two different video pipelines:
+ *
+ * CSI -> VDIC
+ *
+ * In this pipeline, the CSI sends a single interlaced field F(n-1)
+ * directly to the VDIC (and optionally the following field F(n)
+ * can be sent to memory via IDMAC channel 13). This pipeline only works
+ * in VDIC's high motion mode, which only requires a single field for
+ * processing. The other motion modes (low and medium) require three
+ * fields, so this pipeline does not work in those modes. Also, it is
+ * not clear how this pipeline can deal with the various field orders
+ * (sequential BT/TB, interlaced BT/TB).
+ *
+ * MEM -> CH8,9,10 -> VDIC
+ *
+ * In this pipeline, previous field F(n-1), current field F(n), and next
+ * field F(n+1) are transferred to the VDIC via IDMAC channels 8,9,10.
+ * These memory buffers can come from a video output or mem2mem device.
+ * All motion modes are supported by this pipeline.
+ *
+ * The "direct" CSI->VDIC pipeline requires no DMA, but it can only be
+ * used in high motion mode.
+ */
+
+struct vdic_priv;
+
+struct vdic_pipeline_ops {
+	int (*setup)(struct vdic_priv *priv);
+	void (*start)(struct vdic_priv *priv);
+	void (*stop)(struct vdic_priv *priv);
+	void (*disable)(struct vdic_priv *priv);
+};
+
+/*
+ * Min/Max supported width and heights.
+ */
+#define MIN_W       176
+#define MIN_H       144
+#define MAX_W_VDIC  968
+#define MAX_H_VDIC 2048
+#define W_ALIGN    4 /* multiple of 16 pixels */
+#define H_ALIGN    1 /* multiple of 2 lines */
+#define S_ALIGN    1 /* multiple of 2 */
+
+struct vdic_priv {
+	struct device        *dev;
+	struct ipu_soc       *ipu;
+	struct imx_media_dev *md;
+	struct v4l2_subdev   sd;
+	struct media_pad pad[VDIC_NUM_PADS];
+	int ipu_id;
+
+	/* lock to protect all members below */
+	struct mutex lock;
+
+	/* IPU units we require */
+	struct ipu_vdi *vdi;
+
+	int active_input_pad;
+
+	struct ipuv3_channel *vdi_in_ch_p; /* F(n-1) transfer channel */
+	struct ipuv3_channel *vdi_in_ch;   /* F(n) transfer channel */
+	struct ipuv3_channel *vdi_in_ch_n; /* F(n+1) transfer channel */
+
+	/* pipeline operations */
+	struct vdic_pipeline_ops *ops;
+
+	/* current and previous input buffers indirect path */
+	struct imx_media_buffer *curr_in_buf;
+	struct imx_media_buffer *prev_in_buf;
+
+	/*
+	 * translated field type, input line stride, and field size
+	 * for indirect path
+	 */
+	u32 fieldtype;
+	u32 in_stride;
+	u32 field_size;
+
+	/* the source (a video device or subdev) */
+	struct media_entity *src;
+	/* the sink that will receive the progressive out buffers */
+	struct v4l2_subdev *sink_sd;
+
+	struct v4l2_mbus_framefmt format_mbus[VDIC_NUM_PADS];
+	const struct imx_media_pixfmt *cc[VDIC_NUM_PADS];
+	struct v4l2_fract frame_interval;
+
+	/* the video device at IDMAC input pad */
+	struct imx_media_video_dev *vdev;
+
+	bool csi_direct;  /* using direct CSI->VDIC->IC pipeline */
+
+	/* motion select control */
+	struct v4l2_ctrl_handler ctrl_hdlr;
+	enum ipu_motion_sel motion;
+
+	bool stream_on; /* streaming is on */
+};
+
+static void vdic_put_ipu_resources(struct vdic_priv *priv)
+{
+	if (!IS_ERR_OR_NULL(priv->vdi_in_ch_p))
+		ipu_idmac_put(priv->vdi_in_ch_p);
+	priv->vdi_in_ch_p = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->vdi_in_ch))
+		ipu_idmac_put(priv->vdi_in_ch);
+	priv->vdi_in_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->vdi_in_ch_n))
+		ipu_idmac_put(priv->vdi_in_ch_n);
+	priv->vdi_in_ch_n = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->vdi))
+		ipu_vdi_put(priv->vdi);
+	priv->vdi = NULL;
+}
+
+static int vdic_get_ipu_resources(struct vdic_priv *priv)
+{
+	int ret, err_chan;
+
+	priv->ipu = priv->md->ipu[priv->ipu_id];
+
+	priv->vdi = ipu_vdi_get(priv->ipu);
+	if (IS_ERR(priv->vdi)) {
+		v4l2_err(&priv->sd, "failed to get VDIC\n");
+		ret = PTR_ERR(priv->vdi);
+		goto out;
+	}
+
+	if (!priv->csi_direct) {
+		priv->vdi_in_ch_p = ipu_idmac_get(priv->ipu,
+						  IPUV3_CHANNEL_MEM_VDI_PREV);
+		if (IS_ERR(priv->vdi_in_ch_p)) {
+			err_chan = IPUV3_CHANNEL_MEM_VDI_PREV;
+			ret = PTR_ERR(priv->vdi_in_ch_p);
+			goto out_err_chan;
+		}
+
+		priv->vdi_in_ch = ipu_idmac_get(priv->ipu,
+						IPUV3_CHANNEL_MEM_VDI_CUR);
+		if (IS_ERR(priv->vdi_in_ch)) {
+			err_chan = IPUV3_CHANNEL_MEM_VDI_CUR;
+			ret = PTR_ERR(priv->vdi_in_ch);
+			goto out_err_chan;
+		}
+
+		priv->vdi_in_ch_n = ipu_idmac_get(priv->ipu,
+						  IPUV3_CHANNEL_MEM_VDI_NEXT);
+		if (IS_ERR(priv->vdi_in_ch_n)) {
+			err_chan = IPUV3_CHANNEL_MEM_VDI_NEXT;
+			ret = PTR_ERR(priv->vdi_in_ch_n);
+			goto out_err_chan;
+		}
+	}
+
+	return 0;
+
+out_err_chan:
+	v4l2_err(&priv->sd, "could not get IDMAC channel %u\n", err_chan);
+out:
+	vdic_put_ipu_resources(priv);
+	return ret;
+}
+
+/*
+ * This function is currently unused, but will be called when the
+ * output/mem2mem device at the IDMAC input pad sends us a new
+ * buffer. It kicks off the IDMAC read channels to bring in the
+ * buffer fields from memory and begin the conversions.
+ */
+static void __maybe_unused prepare_vdi_in_buffers(struct vdic_priv *priv,
+						  struct imx_media_buffer *curr)
+{
+	dma_addr_t prev_phys, curr_phys, next_phys;
+	struct imx_media_buffer *prev;
+	struct vb2_buffer *curr_vb, *prev_vb;
+	u32 fs = priv->field_size;
+	u32 is = priv->in_stride;
+
+	/* current input buffer is now previous */
+	priv->prev_in_buf = priv->curr_in_buf;
+	priv->curr_in_buf = curr;
+	prev = priv->prev_in_buf ? priv->prev_in_buf : curr;
+
+	prev_vb = &prev->vbuf.vb2_buf;
+	curr_vb = &curr->vbuf.vb2_buf;
+
+	switch (priv->fieldtype) {
+	case V4L2_FIELD_SEQ_TB:
+		prev_phys = vb2_dma_contig_plane_dma_addr(prev_vb, 0);
+		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + fs;
+		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
+		break;
+	case V4L2_FIELD_SEQ_BT:
+		prev_phys = vb2_dma_contig_plane_dma_addr(prev_vb, 0) + fs;
+		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
+		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + fs;
+		break;
+	case V4L2_FIELD_INTERLACED_BT:
+		prev_phys = vb2_dma_contig_plane_dma_addr(prev_vb, 0) + is;
+		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
+		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + is;
+		break;
+	default:
+		/* assume V4L2_FIELD_INTERLACED_TB */
+		prev_phys = vb2_dma_contig_plane_dma_addr(prev_vb, 0);
+		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + is;
+		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
+		break;
+	}
+
+	ipu_cpmem_set_buffer(priv->vdi_in_ch_p, 0, prev_phys);
+	ipu_cpmem_set_buffer(priv->vdi_in_ch,   0, curr_phys);
+	ipu_cpmem_set_buffer(priv->vdi_in_ch_n, 0, next_phys);
+
+	ipu_idmac_select_buffer(priv->vdi_in_ch_p, 0);
+	ipu_idmac_select_buffer(priv->vdi_in_ch, 0);
+	ipu_idmac_select_buffer(priv->vdi_in_ch_n, 0);
+}
+
+static int setup_vdi_channel(struct vdic_priv *priv,
+			     struct ipuv3_channel *channel,
+			     dma_addr_t phys0, dma_addr_t phys1)
+{
+	struct imx_media_video_dev *vdev = priv->vdev;
+	unsigned int burst_size;
+	struct ipu_image image;
+	int ret;
+
+	ipu_cpmem_zero(channel);
+
+	memset(&image, 0, sizeof(image));
+	image.pix = vdev->fmt.fmt.pix;
+	/* one field to VDIC channels */
+	image.pix.height /= 2;
+	image.rect.width = image.pix.width;
+	image.rect.height = image.pix.height;
+	image.phys0 = phys0;
+	image.phys1 = phys1;
+
+	ret = ipu_cpmem_set_image(channel, &image);
+	if (ret)
+		return ret;
+
+	burst_size = (image.pix.width & 0xf) ? 8 : 16;
+	ipu_cpmem_set_burstsize(channel, burst_size);
+
+	ipu_cpmem_set_axi_id(channel, 1);
+
+	ipu_idmac_set_double_buffer(channel, false);
+
+	return 0;
+}
+
+static int vdic_setup_direct(struct vdic_priv *priv)
+{
+	/* set VDIC to receive from CSI for direct path */
+	ipu_fsu_link(priv->ipu, IPUV3_CHANNEL_CSI_DIRECT,
+		     IPUV3_CHANNEL_CSI_VDI_PREV);
+
+	return 0;
+}
+
+static void vdic_start_direct(struct vdic_priv *priv)
+{
+}
+
+static void vdic_stop_direct(struct vdic_priv *priv)
+{
+}
+
+static void vdic_disable_direct(struct vdic_priv *priv)
+{
+	ipu_fsu_unlink(priv->ipu, IPUV3_CHANNEL_CSI_DIRECT,
+		       IPUV3_CHANNEL_CSI_VDI_PREV);
+}
+
+static int vdic_setup_indirect(struct vdic_priv *priv)
+{
+	struct v4l2_mbus_framefmt *infmt;
+	const struct imx_media_pixfmt *incc;
+	int in_size, ret;
+
+	infmt = &priv->format_mbus[VDIC_SINK_PAD_IDMAC];
+	incc = priv->cc[VDIC_SINK_PAD_IDMAC];
+
+	in_size = (infmt->width * incc->bpp * infmt->height) >> 3;
+
+	/* 1/2 full image size */
+	priv->field_size = in_size / 2;
+	priv->in_stride = incc->planar ?
+		infmt->width : (infmt->width * incc->bpp) >> 3;
+
+	priv->prev_in_buf = NULL;
+	priv->curr_in_buf = NULL;
+
+	priv->fieldtype = infmt->field;
+
+	/* init the vdi-in channels */
+	ret = setup_vdi_channel(priv, priv->vdi_in_ch_p, 0, 0);
+	if (ret)
+		return ret;
+	ret = setup_vdi_channel(priv, priv->vdi_in_ch, 0, 0);
+	if (ret)
+		return ret;
+	return setup_vdi_channel(priv, priv->vdi_in_ch_n, 0, 0);
+}
+
+static void vdic_start_indirect(struct vdic_priv *priv)
+{
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->vdi_in_ch_p);
+	ipu_idmac_enable_channel(priv->vdi_in_ch);
+	ipu_idmac_enable_channel(priv->vdi_in_ch_n);
+}
+
+static void vdic_stop_indirect(struct vdic_priv *priv)
+{
+	/* disable channels */
+	ipu_idmac_disable_channel(priv->vdi_in_ch_p);
+	ipu_idmac_disable_channel(priv->vdi_in_ch);
+	ipu_idmac_disable_channel(priv->vdi_in_ch_n);
+}
+
+static void vdic_disable_indirect(struct vdic_priv *priv)
+{
+}
+
+static struct vdic_pipeline_ops direct_ops = {
+	.setup = vdic_setup_direct,
+	.start = vdic_start_direct,
+	.stop = vdic_stop_direct,
+	.disable = vdic_disable_direct,
+};
+
+static struct vdic_pipeline_ops indirect_ops = {
+	.setup = vdic_setup_indirect,
+	.start = vdic_start_indirect,
+	.stop = vdic_stop_indirect,
+	.disable = vdic_disable_indirect,
+};
+
+static int vdic_start(struct vdic_priv *priv)
+{
+	struct v4l2_mbus_framefmt *infmt;
+	int ret;
+
+	infmt = &priv->format_mbus[priv->active_input_pad];
+
+	priv->ops = priv->csi_direct ? &direct_ops : &indirect_ops;
+
+	ret = vdic_get_ipu_resources(priv);
+	if (ret)
+		return ret;
+
+	/*
+	 * init the VDIC.
+	 *
+	 * note we don't give infmt->code to ipu_vdi_setup(). The VDIC
+	 * only supports 4:2:2 or 4:2:0, and this subdev will only
+	 * negotiate 4:2:2 at its sink pads.
+	 */
+	ipu_vdi_setup(priv->vdi, MEDIA_BUS_FMT_UYVY8_2X8,
+		      infmt->width, infmt->height);
+	ipu_vdi_set_field_order(priv->vdi, V4L2_STD_UNKNOWN, infmt->field);
+	ipu_vdi_set_motion(priv->vdi, priv->motion);
+
+	ret = priv->ops->setup(priv);
+	if (ret)
+		goto out_put_ipu;
+
+	ipu_vdi_enable(priv->vdi);
+
+	priv->ops->start(priv);
+
+	return 0;
+
+out_put_ipu:
+	vdic_put_ipu_resources(priv);
+	return ret;
+}
+
+static void vdic_stop(struct vdic_priv *priv)
+{
+	priv->ops->stop(priv);
+	ipu_vdi_disable(priv->vdi);
+	priv->ops->disable(priv);
+
+	vdic_put_ipu_resources(priv);
+}
+
+/*
+ * V4L2 subdev operations.
+ */
+
+static int vdic_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vdic_priv *priv = container_of(ctrl->handler,
+					      struct vdic_priv, ctrl_hdlr);
+	enum ipu_motion_sel motion;
+	int ret = 0;
+
+	mutex_lock(&priv->lock);
+
+	switch (ctrl->id) {
+	case V4L2_CID_DEINTERLACING_MODE:
+		motion = ctrl->val;
+		if (motion != priv->motion) {
+			/* can't change motion control mid-streaming */
+			if (priv->stream_on) {
+				ret = -EBUSY;
+				goto out;
+			}
+			priv->motion = motion;
+		}
+		break;
+	default:
+		v4l2_err(&priv->sd, "Invalid control\n");
+		ret = -EINVAL;
+	}
+
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops vdic_ctrl_ops = {
+	.s_ctrl = vdic_s_ctrl,
+};
+
+static const char * const vdic_ctrl_motion_menu[] = {
+	"No Motion Compensation",
+	"Low Motion",
+	"Medium Motion",
+	"High Motion",
+};
+
+static int vdic_init_controls(struct vdic_priv *priv)
+{
+	struct v4l2_ctrl_handler *hdlr = &priv->ctrl_hdlr;
+	int ret;
+
+	v4l2_ctrl_handler_init(hdlr, 1);
+
+	v4l2_ctrl_new_std_menu_items(hdlr, &vdic_ctrl_ops,
+				     V4L2_CID_DEINTERLACING_MODE,
+				     HIGH_MOTION, 0, HIGH_MOTION,
+				     vdic_ctrl_motion_menu);
+
+	priv->sd.ctrl_handler = hdlr;
+
+	if (hdlr->error) {
+		ret = hdlr->error;
+		goto out_free;
+	}
+
+	v4l2_ctrl_handler_setup(hdlr);
+	return 0;
+
+out_free:
+	v4l2_ctrl_handler_free(hdlr);
+	return ret;
+}
+
+static int vdic_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	mutex_lock(&priv->lock);
+
+	if (!priv->src || !priv->sink_sd) {
+		ret = -EPIPE;
+		goto out;
+	}
+
+	dev_dbg(priv->dev, "stream %s\n", enable ? "ON" : "OFF");
+
+	if (enable && !priv->stream_on)
+		ret = vdic_start(priv);
+	else if (!enable && priv->stream_on)
+		vdic_stop(priv);
+
+	if (!ret)
+		priv->stream_on = enable;
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int vdic_enum_mbus_code(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->pad >= VDIC_NUM_PADS)
+		return -EINVAL;
+
+	if (code->pad == VDIC_SINK_PAD_IDMAC)
+		return imx_media_enum_format(NULL, &code->code, code->index,
+					     false, false);
+
+	return imx_media_enum_ipu_format(NULL, &code->code, code->index, false);
+}
+
+static struct v4l2_mbus_framefmt *
+__vdic_get_fmt(struct vdic_priv *priv, struct v4l2_subdev_pad_config *cfg,
+	       unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(&priv->sd, cfg, pad);
+	else
+		return &priv->format_mbus[pad];
+}
+
+static int vdic_get_fmt(struct v4l2_subdev *sd,
+			struct v4l2_subdev_pad_config *cfg,
+			struct v4l2_subdev_format *sdformat)
+{
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *fmt;
+	int ret = 0;
+
+	if (sdformat->pad >= VDIC_NUM_PADS)
+		return -EINVAL;
+
+	mutex_lock(&priv->lock);
+
+	fmt = __vdic_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
+	if (!fmt) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	sdformat->format = *fmt;
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int vdic_set_fmt(struct v4l2_subdev *sd,
+			struct v4l2_subdev_pad_config *cfg,
+			struct v4l2_subdev_format *sdformat)
+{
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+	const struct imx_media_pixfmt *cc;
+	struct v4l2_mbus_framefmt *infmt;
+	int ret = 0;
+	u32 code;
+
+	if (sdformat->pad >= VDIC_NUM_PADS)
+		return -EINVAL;
+
+	mutex_lock(&priv->lock);
+
+	if (priv->stream_on) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W_VDIC,
+			      W_ALIGN, &sdformat->format.height,
+			      MIN_H, MAX_H_VDIC, H_ALIGN, S_ALIGN);
+
+	switch (sdformat->pad) {
+	case VDIC_SRC_PAD_DIRECT:
+		infmt = __vdic_get_fmt(priv, cfg, priv->active_input_pad,
+				       sdformat->which);
+
+		cc = imx_media_find_ipu_format(0, sdformat->format.code, false);
+		if (!cc) {
+			imx_media_enum_ipu_format(NULL, &code, 0, false);
+			cc = imx_media_find_ipu_format(0, code, false);
+			sdformat->format.code = cc->codes[0];
+		}
+
+		sdformat->format.width = infmt->width;
+		sdformat->format.height = infmt->height;
+		/* output is always progressive! */
+		sdformat->format.field = V4L2_FIELD_NONE;
+		break;
+	case VDIC_SINK_PAD_IDMAC:
+	case VDIC_SINK_PAD_DIRECT:
+		if (sdformat->pad == VDIC_SINK_PAD_DIRECT) {
+			cc = imx_media_find_ipu_format(0, sdformat->format.code,
+						       false);
+			if (!cc) {
+				imx_media_enum_ipu_format(NULL, &code, 0,
+							  false);
+				cc = imx_media_find_ipu_format(0, code, false);
+				sdformat->format.code = cc->codes[0];
+			}
+		} else {
+			cc = imx_media_find_format(0, sdformat->format.code,
+						   false, false);
+			if (!cc) {
+				imx_media_enum_format(NULL, &code, 0,
+						      false, false);
+				cc = imx_media_find_format(0, code,
+							   false, false);
+				sdformat->format.code = cc->codes[0];
+			}
+		}
+
+		/* input must be interlaced! Choose SEQ_TB if not */
+		if (!V4L2_FIELD_HAS_BOTH(sdformat->format.field))
+			sdformat->format.field = V4L2_FIELD_SEQ_TB;
+		break;
+	default:
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
+		cfg->try_fmt = sdformat->format;
+	} else {
+		priv->format_mbus[sdformat->pad] = sdformat->format;
+		priv->cc[sdformat->pad] = cc;
+	}
+
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int vdic_g_frame_interval(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_frame_interval *fi)
+{
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+
+	mutex_lock(&priv->lock);
+	fi->interval = priv->frame_interval;
+	mutex_unlock(&priv->lock);
+
+	return 0;
+}
+
+static int vdic_s_frame_interval(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_frame_interval *fi)
+{
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+
+	mutex_lock(&priv->lock);
+
+	/* Output pads mirror active input pad, no limits on input pads */
+	if (fi->pad == VDIC_SRC_PAD_DIRECT)
+		fi->interval = priv->frame_interval;
+
+	priv->frame_interval = fi->interval;
+
+	mutex_unlock(&priv->lock);
+
+	return 0;
+}
+
+static int vdic_link_setup(struct media_entity *entity,
+			    const struct media_pad *local,
+			    const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_subdev *remote_sd;
+	int ret = 0;
+
+	dev_dbg(priv->dev, "link setup %s -> %s", remote->entity->name,
+		local->entity->name);
+
+	mutex_lock(&priv->lock);
+
+	if (local->flags & MEDIA_PAD_FL_SOURCE) {
+		if (!is_media_entity_v4l2_subdev(remote->entity)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		remote_sd = media_entity_to_v4l2_subdev(remote->entity);
+
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (priv->sink_sd) {
+				ret = -EBUSY;
+				goto out;
+			}
+			priv->sink_sd = remote_sd;
+		} else {
+			priv->sink_sd = NULL;
+		}
+
+		goto out;
+	}
+
+	/* this is a sink pad */
+
+	if (flags & MEDIA_LNK_FL_ENABLED) {
+		if (priv->src) {
+			ret = -EBUSY;
+			goto out;
+		}
+	} else {
+		priv->src = NULL;
+		goto out;
+	}
+
+	if (local->index == VDIC_SINK_PAD_IDMAC) {
+		struct imx_media_video_dev *vdev = priv->vdev;
+
+		if (!is_media_entity_v4l2_video_device(remote->entity)) {
+			ret = -EINVAL;
+			goto out;
+		}
+		if (!vdev) {
+			ret = -ENODEV;
+			goto out;
+		}
+
+		priv->csi_direct = false;
+	} else {
+		if (!is_media_entity_v4l2_subdev(remote->entity)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		remote_sd = media_entity_to_v4l2_subdev(remote->entity);
+
+		/* direct pad must connect to a CSI */
+		if (!(remote_sd->grp_id & IMX_MEDIA_GRP_ID_CSI) ||
+		    remote->index != CSI_SRC_PAD_DIRECT) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		priv->csi_direct = true;
+	}
+
+	priv->src = remote->entity;
+	/* record which input pad is now active */
+	priv->active_input_pad = local->index;
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int vdic_link_validate(struct v4l2_subdev *sd,
+			      struct media_link *link,
+			      struct v4l2_subdev_format *source_fmt,
+			      struct v4l2_subdev_format *sink_fmt)
+{
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+	int ret;
+
+	ret = v4l2_subdev_link_validate_default(sd, link,
+						source_fmt, sink_fmt);
+	if (ret)
+		return ret;
+
+	ret = v4l2_subdev_link_validate_frame_interval(link);
+	if (ret)
+		return ret;
+
+	mutex_lock(&priv->lock);
+
+	if (priv->csi_direct && priv->motion != HIGH_MOTION) {
+		v4l2_err(&priv->sd,
+			 "direct CSI pipeline requires high motion\n");
+		ret = -EINVAL;
+	}
+
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+/*
+ * retrieve our pads parsed from the OF graph by the media device
+ */
+static int vdic_registered(struct v4l2_subdev *sd)
+{
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+	int i, ret;
+	u32 code;
+
+	/* get media device */
+	priv->md = dev_get_drvdata(sd->v4l2_dev->dev);
+
+	for (i = 0; i < VDIC_NUM_PADS; i++) {
+		priv->pad[i].flags = (i == VDIC_SRC_PAD_DIRECT) ?
+			MEDIA_PAD_FL_SOURCE : MEDIA_PAD_FL_SINK;
+
+		code = 0;
+		if (i != VDIC_SINK_PAD_IDMAC)
+			imx_media_enum_ipu_format(NULL, &code, 0, true);
+
+		/* set a default mbus format  */
+		ret = imx_media_init_mbus_fmt(&priv->format_mbus[i],
+					      640, 480, code, V4L2_FIELD_NONE,
+					      &priv->cc[i]);
+		if (ret)
+			return ret;
+	}
+
+	/* init default frame interval */
+	priv->frame_interval.numerator = 1;
+	priv->frame_interval.denominator = 30;
+
+	priv->active_input_pad = VDIC_SINK_PAD_DIRECT;
+
+	ret = vdic_init_controls(priv);
+	if (ret)
+		return ret;
+
+	ret = media_entity_pads_init(&sd->entity, VDIC_NUM_PADS, priv->pad);
+	if (ret)
+		v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
+
+	return ret;
+}
+
+static void vdic_unregistered(struct v4l2_subdev *sd)
+{
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+
+	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
+}
+
+static struct v4l2_subdev_pad_ops vdic_pad_ops = {
+	.enum_mbus_code = vdic_enum_mbus_code,
+	.get_fmt = vdic_get_fmt,
+	.set_fmt = vdic_set_fmt,
+	.link_validate = vdic_link_validate,
+};
+
+static struct v4l2_subdev_video_ops vdic_video_ops = {
+	.s_stream = vdic_s_stream,
+	.g_frame_interval = vdic_g_frame_interval,
+	.s_frame_interval = vdic_s_frame_interval,
+};
+
+static struct media_entity_operations vdic_entity_ops = {
+	.link_setup = vdic_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static struct v4l2_subdev_ops vdic_subdev_ops = {
+	.video = &vdic_video_ops,
+	.pad = &vdic_pad_ops,
+};
+
+static struct v4l2_subdev_internal_ops vdic_internal_ops = {
+	.registered = vdic_registered,
+	.unregistered = vdic_unregistered,
+};
+
+static int imx_vdic_probe(struct platform_device *pdev)
+{
+	struct imx_media_internal_sd_platformdata *pdata;
+	struct vdic_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, &priv->sd);
+	priv->dev = &pdev->dev;
+
+	pdata = priv->dev->platform_data;
+	priv->ipu_id = pdata->ipu_id;
+
+	v4l2_subdev_init(&priv->sd, &vdic_subdev_ops);
+	v4l2_set_subdevdata(&priv->sd, priv);
+	priv->sd.internal_ops = &vdic_internal_ops;
+	priv->sd.entity.ops = &vdic_entity_ops;
+	priv->sd.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
+	priv->sd.dev = &pdev->dev;
+	priv->sd.owner = THIS_MODULE;
+	priv->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	/* get our group id */
+	priv->sd.grp_id = pdata->grp_id;
+	strncpy(priv->sd.name, pdata->sd_name, sizeof(priv->sd.name));
+
+	mutex_init(&priv->lock);
+
+	ret = v4l2_async_register_subdev(&priv->sd);
+	if (ret)
+		goto free;
+
+	return 0;
+free:
+	mutex_destroy(&priv->lock);
+	return ret;
+}
+
+static int imx_vdic_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+
+	v4l2_info(sd, "Removing\n");
+
+	v4l2_async_unregister_subdev(sd);
+	mutex_destroy(&priv->lock);
+	media_entity_cleanup(&sd->entity);
+
+	return 0;
+}
+
+static const struct platform_device_id imx_vdic_ids[] = {
+	{ .name = "imx-ipuv3-vdic" },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, imx_vdic_ids);
+
+static struct platform_driver imx_vdic_driver = {
+	.probe = imx_vdic_probe,
+	.remove = imx_vdic_remove,
+	.id_table = imx_vdic_ids,
+	.driver = {
+		.name = "imx-ipuv3-vdic",
+	},
+};
+module_platform_driver(imx_vdic_driver);
+
+MODULE_DESCRIPTION("i.MX VDIC subdev driver");
+MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:imx-ipuv3-vdic");
-- 
2.7.4
