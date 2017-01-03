Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33408 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966119AbdACU6F (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 15:58:05 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        p.zabel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 12/19] media: imx: Add SMFC subdev driver
Date: Tue,  3 Jan 2017 12:57:22 -0800
Message-Id: <1483477049-19056-13-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a media entity subdevice driver for the i.MX Sensor Multi-FIFO
Controller module. Video frames are received from the CSI and can
be routed to various sinks including the i.MX Image Converter for
scaling, color-space conversion, motion compensated deinterlacing,
and image rotation.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/Makefile   |   1 +
 drivers/staging/media/imx/imx-smfc.c | 739 +++++++++++++++++++++++++++++++++++
 2 files changed, 740 insertions(+)
 create mode 100644 drivers/staging/media/imx/imx-smfc.c

diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
index 133672a..3559d7b 100644
--- a/drivers/staging/media/imx/Makefile
+++ b/drivers/staging/media/imx/Makefile
@@ -5,4 +5,5 @@ obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media.o
 obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-common.o
 
 obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-csi.o
+obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-smfc.o
 
diff --git a/drivers/staging/media/imx/imx-smfc.c b/drivers/staging/media/imx/imx-smfc.c
new file mode 100644
index 0000000..565048c
--- /dev/null
+++ b/drivers/staging/media/imx/imx-smfc.c
@@ -0,0 +1,739 @@
+/*
+ * V4L2 Capture SMFC Subdev for Freescale i.MX5/6 SOC
+ *
+ * This subdevice handles capture of raw/unconverted video frames
+ * from the CSI, directly to memory via the Sensor Multi-FIFO Controller.
+ *
+ * Copyright (c) 2012-2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+#include <media/imx.h>
+#include "imx-media.h"
+
+/*
+ * Min/Max supported width and heights.
+ *
+ * We allow planar output from the SMFC, so we have to align
+ * output width by 16 pixels to meet IDMAC alignment requirements,
+ * which also means input width must have the same alignment.
+ */
+#define MIN_W       176
+#define MIN_H       144
+#define MAX_W      8192
+#define MAX_H      4096
+#define W_ALIGN    4 /* multiple of 16 pixels */
+#define H_ALIGN    1 /* multiple of 2 lines */
+#define S_ALIGN    1 /* multiple of 2 */
+
+#define SMFC_NUM_PADS 2
+
+struct imx_smfc_priv {
+	struct device        *dev;
+	struct ipu_soc       *ipu;
+	struct imx_media_dev *md;
+	struct v4l2_subdev   sd;
+	struct media_pad pad[SMFC_NUM_PADS];
+	int ipu_id;
+	int smfc_id;
+	int input_pad;
+	int output_pad;
+
+	struct ipuv3_channel *smfc_ch;
+	struct ipu_smfc *smfc;
+
+	struct v4l2_mbus_framefmt format_mbus[SMFC_NUM_PADS];
+	const struct imx_media_pixfmt *cc[SMFC_NUM_PADS];
+
+	struct v4l2_mbus_config sensor_mbus_cfg;
+
+	/* the dma buffer ring to send to sink */
+	struct imx_media_dma_buf_ring *out_ring;
+	struct imx_media_dma_buf *next;
+
+	int ipu_buf_num;  /* ipu double buffer index: 0-1 */
+
+	/* the sink that will receive the dma buffers */
+	struct v4l2_subdev *sink_sd;
+	struct v4l2_subdev *src_sd;
+
+	/*
+	 * the CSI id and mipi virtual channel number at
+	 * link validate
+	 */
+	int csi_id;
+	int vc_num;
+
+	/* the attached sensor at stream on */
+	struct imx_media_subdev *sensor;
+
+	spinlock_t irqlock;
+	struct timer_list eof_timeout_timer;
+	int eof_irq;
+	int nfb4eof_irq;
+
+	bool stream_on; /* streaming is on */
+	bool last_eof;  /* waiting for last EOF at stream off */
+	struct completion last_eof_comp;
+};
+
+static void imx_smfc_put_ipu_resources(struct imx_smfc_priv *priv)
+{
+	if (!IS_ERR_OR_NULL(priv->smfc_ch))
+		ipu_idmac_put(priv->smfc_ch);
+	priv->smfc_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->smfc))
+		ipu_smfc_put(priv->smfc);
+	priv->smfc = NULL;
+}
+
+static int imx_smfc_get_ipu_resources(struct imx_smfc_priv *priv)
+{
+	int ch_num, ret;
+
+	priv->ipu = priv->md->ipu[priv->ipu_id];
+
+	ch_num = IPUV3_CHANNEL_CSI0 + priv->smfc_id;
+
+	priv->smfc = ipu_smfc_get(priv->ipu, ch_num);
+	if (IS_ERR(priv->smfc)) {
+		v4l2_err(&priv->sd, "failed to get SMFC\n");
+		ret = PTR_ERR(priv->smfc);
+		goto out;
+	}
+
+	priv->smfc_ch = ipu_idmac_get(priv->ipu, ch_num);
+	if (IS_ERR(priv->smfc_ch)) {
+		v4l2_err(&priv->sd, "could not get IDMAC channel %u\n", ch_num);
+		ret = PTR_ERR(priv->smfc_ch);
+		goto out;
+	}
+
+	return 0;
+out:
+	imx_smfc_put_ipu_resources(priv);
+	return ret;
+}
+
+static irqreturn_t imx_smfc_eof_interrupt(int irq, void *dev_id)
+{
+	struct imx_smfc_priv *priv = dev_id;
+	struct imx_media_dma_buf *done, *next;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->irqlock, flags);
+
+	if (priv->last_eof) {
+		complete(&priv->last_eof_comp);
+		priv->last_eof = false;
+		goto unlock;
+	}
+
+	/* inform CSI of this EOF so it can monitor frame intervals */
+	v4l2_subdev_call(priv->src_sd, core, interrupt_service_routine,
+			 0, NULL);
+
+	done = imx_media_dma_buf_get_active(priv->out_ring);
+	/* give the completed buffer to the sink  */
+	if (!WARN_ON(!done))
+		imx_media_dma_buf_done(done, IMX_MEDIA_BUF_STATUS_DONE);
+
+	/* priv->next buffer is now the active one */
+	imx_media_dma_buf_set_active(priv->next);
+
+	/* bump the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
+
+	if (ipu_idmac_buffer_is_ready(priv->smfc_ch, priv->ipu_buf_num))
+		ipu_idmac_clear_buffer(priv->smfc_ch, priv->ipu_buf_num);
+
+	/* get next queued buffer */
+	next = imx_media_dma_buf_get_next_queued(priv->out_ring);
+
+	ipu_cpmem_set_buffer(priv->smfc_ch, priv->ipu_buf_num, next->phys);
+	ipu_idmac_select_buffer(priv->smfc_ch, priv->ipu_buf_num);
+
+	/* toggle IPU double-buffer index */
+	priv->ipu_buf_num ^= 1;
+	priv->next = next;
+
+unlock:
+	spin_unlock_irqrestore(&priv->irqlock, flags);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t imx_smfc_nfb4eof_interrupt(int irq, void *dev_id)
+{
+	struct imx_smfc_priv *priv = dev_id;
+	static const struct v4l2_event ev = {
+		.type = V4L2_EVENT_IMX_NFB4EOF,
+	};
+
+	v4l2_err(&priv->sd, "NFB4EOF\n");
+
+	v4l2_subdev_notify_event(&priv->sd, &ev);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * EOF timeout timer function.
+ */
+static void imx_smfc_eof_timeout(unsigned long data)
+{
+	struct imx_smfc_priv *priv = (struct imx_smfc_priv *)data;
+	static const struct v4l2_event ev = {
+		.type = V4L2_EVENT_IMX_EOF_TIMEOUT,
+	};
+
+	v4l2_err(&priv->sd, "EOF timeout\n");
+
+	v4l2_subdev_notify_event(&priv->sd, &ev);
+}
+
+/* init the SMFC IDMAC channel */
+static void imx_smfc_setup_channel(struct imx_smfc_priv *priv)
+{
+	struct v4l2_mbus_framefmt *infmt, *outfmt;
+	struct imx_media_dma_buf *buf0, *buf1;
+	unsigned int burst_size;
+	struct ipu_image image;
+	bool passthrough;
+
+	infmt = &priv->format_mbus[priv->input_pad];
+	outfmt = &priv->format_mbus[priv->output_pad];
+
+	ipu_cpmem_zero(priv->smfc_ch);
+
+	imx_media_mbus_fmt_to_ipu_image(&image, outfmt);
+
+	buf0 = imx_media_dma_buf_get_next_queued(priv->out_ring);
+	imx_media_dma_buf_set_active(buf0);
+	buf1 = imx_media_dma_buf_get_next_queued(priv->out_ring);
+	priv->next = buf1;
+
+	image.phys0 = buf0->phys;
+	image.phys1 = buf1->phys;
+	ipu_cpmem_set_image(priv->smfc_ch, &image);
+
+	burst_size = (outfmt->width & 0xf) ? 8 : 16;
+
+	ipu_cpmem_set_burstsize(priv->smfc_ch, burst_size);
+
+	/*
+	 * If the sensor uses 16-bit parallel CSI bus, we must handle
+	 * the data internally in the IPU as 16-bit generic, aka
+	 * passthrough mode.
+	 */
+	passthrough = (priv->sensor_mbus_cfg.type != V4L2_MBUS_CSI2 &&
+		       priv->sensor->sensor_ep.bus.parallel.bus_width >= 16);
+
+	if (passthrough)
+		ipu_cpmem_set_format_passthrough(priv->smfc_ch, 16);
+
+	/*
+	 * Set the channel for the direct CSI-->memory via SMFC
+	 * use-case to very high priority, by enabling the watermark
+	 * signal in the SMFC, enabling WM in the channel, and setting
+	 * the channel priority to high.
+	 *
+	 * Refer to the i.mx6 rev. D TRM Table 36-8: Calculated priority
+	 * value.
+	 *
+	 * The WM's are set very low by intention here to ensure that
+	 * the SMFC FIFOs do not overflow.
+	 */
+	ipu_smfc_set_watermark(priv->smfc, 0x02, 0x01);
+	ipu_cpmem_set_high_priority(priv->smfc_ch);
+	ipu_idmac_enable_watermark(priv->smfc_ch, true);
+	ipu_cpmem_set_axi_id(priv->smfc_ch, 0);
+	ipu_idmac_lock_enable(priv->smfc_ch, 8);
+
+	burst_size = ipu_cpmem_get_burstsize(priv->smfc_ch);
+	burst_size = passthrough ?
+		(burst_size >> 3) - 1 : (burst_size >> 2) - 1;
+
+	ipu_smfc_set_burstsize(priv->smfc, burst_size);
+
+	if (outfmt->field == V4L2_FIELD_NONE &&
+	    (V4L2_FIELD_HAS_BOTH(infmt->field) ||
+	     infmt->field == V4L2_FIELD_ALTERNATE))
+		ipu_cpmem_interlaced_scan(priv->smfc_ch,
+					  image.pix.bytesperline);
+
+	ipu_idmac_set_double_buffer(priv->smfc_ch, true);
+}
+
+static void imx_smfc_unsetup(struct imx_smfc_priv *priv)
+{
+	ipu_idmac_disable_channel(priv->smfc_ch);
+	ipu_smfc_disable(priv->smfc);
+}
+
+static void imx_smfc_setup(struct imx_smfc_priv *priv)
+{
+	imx_smfc_setup_channel(priv);
+
+	ipu_cpmem_dump(priv->smfc_ch);
+	ipu_dump(priv->ipu);
+
+	ipu_smfc_enable(priv->smfc);
+
+	/* set buffers ready */
+	ipu_idmac_select_buffer(priv->smfc_ch, 0);
+	ipu_idmac_select_buffer(priv->smfc_ch, 1);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->smfc_ch);
+}
+
+static int imx_smfc_start(struct imx_smfc_priv *priv)
+{
+	int ret;
+
+	if (!priv->sensor) {
+		v4l2_err(&priv->sd, "no sensor attached\n");
+		return -EINVAL;
+	}
+
+	ret = imx_smfc_get_ipu_resources(priv);
+	if (ret)
+		return ret;
+
+	ipu_smfc_map_channel(priv->smfc, priv->csi_id, priv->vc_num);
+
+	/* ask the sink for the buffer ring */
+	ret = v4l2_subdev_call(priv->sink_sd, core, ioctl,
+			       IMX_MEDIA_REQ_DMA_BUF_SINK_RING,
+			       &priv->out_ring);
+	if (ret)
+		goto out_put_ipu;
+
+	priv->ipu_buf_num = 0;
+
+	/* init EOF completion waitq */
+	init_completion(&priv->last_eof_comp);
+	priv->last_eof = false;
+
+	imx_smfc_setup(priv);
+
+	priv->nfb4eof_irq = ipu_idmac_channel_irq(priv->ipu,
+						 priv->smfc_ch,
+						 IPU_IRQ_NFB4EOF);
+	ret = devm_request_irq(priv->dev, priv->nfb4eof_irq,
+			       imx_smfc_nfb4eof_interrupt, 0,
+			       "imx-smfc-nfb4eof", priv);
+	if (ret) {
+		v4l2_err(&priv->sd,
+			 "Error registering NFB4EOF irq: %d\n", ret);
+		goto out_unsetup;
+	}
+
+	priv->eof_irq = ipu_idmac_channel_irq(priv->ipu, priv->smfc_ch,
+					      IPU_IRQ_EOF);
+
+	ret = devm_request_irq(priv->dev, priv->eof_irq,
+			       imx_smfc_eof_interrupt, 0,
+			       "imx-smfc-eof", priv);
+	if (ret) {
+		v4l2_err(&priv->sd,
+			 "Error registering eof irq: %d\n", ret);
+		goto out_free_nfb4eof_irq;
+	}
+
+	/* start the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
+
+	return 0;
+
+out_free_nfb4eof_irq:
+	devm_free_irq(priv->dev, priv->nfb4eof_irq, priv);
+out_unsetup:
+	imx_smfc_unsetup(priv);
+out_put_ipu:
+	imx_smfc_put_ipu_resources(priv);
+	return ret;
+}
+
+static void imx_smfc_stop(struct imx_smfc_priv *priv)
+{
+	unsigned long flags;
+	int ret;
+
+	/* mark next EOF interrupt as the last before stream off */
+	spin_lock_irqsave(&priv->irqlock, flags);
+	priv->last_eof = true;
+	spin_unlock_irqrestore(&priv->irqlock, flags);
+
+	/*
+	 * and then wait for interrupt handler to mark completion.
+	 */
+	ret = wait_for_completion_timeout(
+		&priv->last_eof_comp, msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
+	if (ret == 0)
+		v4l2_warn(&priv->sd, "wait last EOF timeout\n");
+
+	devm_free_irq(priv->dev, priv->eof_irq, priv);
+	devm_free_irq(priv->dev, priv->nfb4eof_irq, priv);
+
+	imx_smfc_unsetup(priv);
+
+	/* cancel the EOF timeout timer */
+	del_timer_sync(&priv->eof_timeout_timer);
+
+	priv->out_ring = NULL;
+
+	/* inform sink that the buffer ring can now be freed */
+	v4l2_subdev_call(priv->sink_sd, core, ioctl,
+			 IMX_MEDIA_REL_DMA_BUF_SINK_RING, 0);
+
+	imx_smfc_put_ipu_resources(priv);
+}
+
+static int imx_smfc_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct imx_smfc_priv *priv = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	if (!priv->src_sd || !priv->sink_sd)
+		return -EPIPE;
+
+	v4l2_info(sd, "stream %s\n", enable ? "ON" : "OFF");
+
+	if (enable && !priv->stream_on)
+		ret = imx_smfc_start(priv);
+	else if (!enable && priv->stream_on)
+		imx_smfc_stop(priv);
+
+	if (!ret)
+		priv->stream_on = enable;
+	return ret;
+}
+
+static int imx_smfc_enum_mbus_code(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct imx_smfc_priv *priv = v4l2_get_subdevdata(sd);
+
+	if (code->pad >= SMFC_NUM_PADS)
+		return -EINVAL;
+
+	return imx_media_enum_format(&code->code, code->index,
+				     true, code->pad == priv->output_pad);
+}
+
+static int imx_smfc_get_fmt(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *sdformat)
+{
+	struct imx_smfc_priv *priv = v4l2_get_subdevdata(sd);
+
+	if (sdformat->pad >= SMFC_NUM_PADS)
+		return -EINVAL;
+
+	sdformat->format = priv->format_mbus[sdformat->pad];
+
+	return 0;
+}
+
+static int imx_smfc_set_fmt(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *sdformat)
+{
+	struct imx_smfc_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *infmt, *outfmt;
+	const struct imx_media_pixfmt *cc, *incc;
+	bool allow_planar;
+	u32 code;
+
+	if (sdformat->pad >= SMFC_NUM_PADS)
+		return -EINVAL;
+
+	if (priv->stream_on)
+		return -EBUSY;
+
+	infmt = &priv->format_mbus[priv->input_pad];
+	outfmt = &priv->format_mbus[priv->output_pad];
+	allow_planar = (sdformat->pad == priv->output_pad);
+
+	cc = imx_media_find_format(0, sdformat->format.code,
+				   true, allow_planar);
+	if (!cc) {
+		imx_media_enum_format(&code, 0, true, false);
+		cc = imx_media_find_format(0, code, true, false);
+		sdformat->format.code = cc->codes[0];
+	}
+
+	v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
+			      W_ALIGN, &sdformat->format.height,
+			      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
+
+	if (sdformat->pad == priv->output_pad) {
+		incc = priv->cc[priv->input_pad];
+		sdformat->format.width = infmt->width;
+		sdformat->format.height = infmt->height;
+		if (sdformat->format.field != V4L2_FIELD_NONE)
+			sdformat->format.field = infmt->field;
+		if (cc->cs != incc->cs) {
+			sdformat->format.code = infmt->code;
+			cc = imx_media_find_format(0, sdformat->format.code,
+						   true, false);
+		}
+	}
+
+	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
+		cfg->try_fmt = sdformat->format;
+	} else {
+		priv->format_mbus[sdformat->pad] = sdformat->format;
+		priv->cc[sdformat->pad] = cc;
+	}
+
+	return 0;
+}
+
+static int imx_smfc_link_setup(struct media_entity *entity,
+			       const struct media_pad *local,
+			       const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct imx_smfc_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_subdev *remote_sd;
+
+	dev_dbg(priv->dev, "link setup %s -> %s", remote->entity->name,
+		local->entity->name);
+
+	remote_sd = media_entity_to_v4l2_subdev(remote->entity);
+
+	if (local->flags & MEDIA_PAD_FL_SOURCE) {
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (priv->sink_sd)
+				return -EBUSY;
+			priv->sink_sd = remote_sd;
+		} else {
+			priv->sink_sd = NULL;
+		}
+
+		return 0;
+	}
+
+	if (flags & MEDIA_LNK_FL_ENABLED) {
+		if (priv->src_sd)
+			return -EBUSY;
+		priv->src_sd = remote_sd;
+	} else {
+		priv->src_sd = NULL;
+		return 0;
+	}
+
+	/* must attach to CSI source */
+	if (!(priv->src_sd->grp_id & IMX_MEDIA_GRP_ID_CSI))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int imx_smfc_link_validate(struct v4l2_subdev *sd,
+				  struct media_link *link,
+				  struct v4l2_subdev_format *source_fmt,
+				  struct v4l2_subdev_format *sink_fmt)
+{
+	struct imx_smfc_priv *priv = v4l2_get_subdevdata(sd);
+	int ret;
+
+	ret = v4l2_subdev_link_validate_default(sd, link, source_fmt, sink_fmt);
+	if (ret)
+		return ret;
+
+	switch (priv->src_sd->grp_id) {
+	case IMX_MEDIA_GRP_ID_CSI0:
+		priv->csi_id = 0;
+		break;
+	case IMX_MEDIA_GRP_ID_CSI1:
+		priv->csi_id = 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	priv->sensor = __imx_media_find_sensor(priv->md, &priv->sd.entity);
+	if (IS_ERR(priv->sensor)) {
+		v4l2_err(&priv->sd, "no sensor attached\n");
+		ret = PTR_ERR(priv->sensor);
+		priv->sensor = NULL;
+		return ret;
+	}
+
+	ret = v4l2_subdev_call(priv->sensor->sd, video, g_mbus_config,
+			       &priv->sensor_mbus_cfg);
+	if (ret)
+		return ret;
+
+	priv->vc_num = 0;
+	if (priv->sensor_mbus_cfg.type == V4L2_MBUS_CSI2) {
+		/* see NOTE in imx-csi.c */
+#if 0
+		priv->vc_num = imx_media_find_mipi_csi2_channel(
+			priv->md, &priv->sd.entity);
+		if (priv->vc_num < 0)
+			return vc_num;
+#endif
+	}
+
+	return 0;
+}
+
+/*
+ * retrieve our pads parsed from the OF graph by the media device
+ */
+static int imx_smfc_registered(struct v4l2_subdev *sd)
+{
+	struct imx_smfc_priv *priv = v4l2_get_subdevdata(sd);
+	struct imx_media_subdev *imxsd;
+	struct imx_media_pad *pad;
+	int i;
+
+	/* get media device */
+	priv->md = dev_get_drvdata(sd->v4l2_dev->dev);
+
+	imxsd = imx_media_find_subdev_by_sd(priv->md, sd);
+	if (IS_ERR(imxsd))
+		return PTR_ERR(imxsd);
+
+	if (imxsd->num_sink_pads != 1 || imxsd->num_src_pads != 1)
+		return -EINVAL;
+
+	for (i = 0; i < SMFC_NUM_PADS; i++) {
+		pad = &imxsd->pad[i];
+		priv->pad[i] = pad->pad;
+		if (priv->pad[i].flags & MEDIA_PAD_FL_SINK)
+			priv->input_pad = i;
+		else
+			priv->output_pad = i;
+
+		/* set a default mbus format  */
+		imx_media_init_mbus_fmt(&priv->format_mbus[i],
+					640, 480, 0, V4L2_FIELD_NONE,
+					&priv->cc[i]);
+	}
+
+	return media_entity_pads_init(&sd->entity, SMFC_NUM_PADS, priv->pad);
+}
+
+static struct media_entity_operations imx_smfc_entity_ops = {
+	.link_setup = imx_smfc_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static struct v4l2_subdev_video_ops imx_smfc_video_ops = {
+	.s_stream = imx_smfc_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops imx_smfc_pad_ops = {
+	.enum_mbus_code = imx_smfc_enum_mbus_code,
+	.get_fmt = imx_smfc_get_fmt,
+	.set_fmt = imx_smfc_set_fmt,
+	.link_validate = imx_smfc_link_validate,
+};
+
+static struct v4l2_subdev_ops imx_smfc_subdev_ops = {
+	.video = &imx_smfc_video_ops,
+	.pad = &imx_smfc_pad_ops,
+};
+
+static struct v4l2_subdev_internal_ops imx_smfc_internal_ops = {
+	.registered = imx_smfc_registered,
+};
+
+static int imx_smfc_probe(struct platform_device *pdev)
+{
+	struct imx_media_internal_sd_platformdata *pdata;
+	struct imx_smfc_priv *priv;
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
+	init_timer(&priv->eof_timeout_timer);
+	priv->eof_timeout_timer.data = (unsigned long)priv;
+	priv->eof_timeout_timer.function = imx_smfc_eof_timeout;
+	spin_lock_init(&priv->irqlock);
+
+	v4l2_subdev_init(&priv->sd, &imx_smfc_subdev_ops);
+	v4l2_set_subdevdata(&priv->sd, priv);
+	priv->sd.internal_ops = &imx_smfc_internal_ops;
+	priv->sd.entity.ops = &imx_smfc_entity_ops;
+	/* FIXME: this the right function? */
+	priv->sd.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
+	priv->sd.dev = &pdev->dev;
+	priv->sd.owner = THIS_MODULE;
+	priv->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
+	/* get our group id and SMFC id */
+	priv->sd.grp_id = pdata->grp_id;
+	priv->smfc_id = (pdata->grp_id >> IMX_MEDIA_GRP_ID_SMFC_BIT) - 1;
+	strncpy(priv->sd.name, pdata->sd_name, sizeof(priv->sd.name));
+
+	return v4l2_async_register_subdev(&priv->sd);
+}
+
+static int imx_smfc_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct imx_smfc_priv *priv = container_of(sd, struct imx_smfc_priv, sd);
+
+	v4l2_async_unregister_subdev(&priv->sd);
+	media_entity_cleanup(&priv->sd.entity);
+	v4l2_device_unregister_subdev(sd);
+
+	return 0;
+}
+
+static const struct platform_device_id imx_smfc_ids[] = {
+	{ .name = "imx-ipuv3-smfc" },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, imx_smfc_ids);
+
+static struct platform_driver imx_smfc_driver = {
+	.probe = imx_smfc_probe,
+	.remove = imx_smfc_remove,
+	.id_table = imx_smfc_ids,
+	.driver = {
+		.name = "imx-ipuv3-smfc",
+		.owner = THIS_MODULE,
+	},
+};
+module_platform_driver(imx_smfc_driver);
+
+MODULE_DESCRIPTION("i.MX SMFC subdev driver");
+MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:imx-ipuv3-smfc");
-- 
2.7.4

