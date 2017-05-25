Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34906 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423170AbdEYAbA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 20:31:00 -0400
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
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v7 22/34] media: imx: Add CSI subdev driver
Date: Wed, 24 May 2017 17:29:37 -0700
Message-Id: <1495672189-29164-23-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a media entity subdevice for the i.MX Camera
Sensor Interface module.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

- Added support for negotiation of frame intervals.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

- Fixed cropping rectangle negotiation at input and output pads.
- Added support for /2 downscaling, if the output pad dimension(s)
  are 1/2 the crop dimension(s) at csi_setup() time.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/Kconfig         |   14 +
 drivers/staging/media/imx/Makefile        |    2 +
 drivers/staging/media/imx/imx-media-csi.c | 1498 +++++++++++++++++++++++++++++
 3 files changed, 1514 insertions(+)
 create mode 100644 drivers/staging/media/imx/imx-media-csi.c

diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
index 62a3c34..e27ad6d 100644
--- a/drivers/staging/media/imx/Kconfig
+++ b/drivers/staging/media/imx/Kconfig
@@ -4,3 +4,17 @@ config VIDEO_IMX_MEDIA
 	---help---
 	  Say yes here to enable support for video4linux media controller
 	  driver for the i.MX5/6 SOC.
+
+if VIDEO_IMX_MEDIA
+menu "i.MX5/6 Media Sub devices"
+
+config VIDEO_IMX_CSI
+	tristate "i.MX5/6 Camera Sensor Interface driver"
+	depends on VIDEO_IMX_MEDIA && VIDEO_DEV && I2C
+	select VIDEOBUF2_DMA_CONTIG
+	default y
+	---help---
+	  A video4linux camera sensor interface driver for i.MX5/6.
+
+endmenu
+endif
diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
index 4606a3a..c054490 100644
--- a/drivers/staging/media/imx/Makefile
+++ b/drivers/staging/media/imx/Makefile
@@ -4,3 +4,5 @@ imx-media-common-objs := imx-media-utils.o imx-media-fim.o
 obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media.o
 obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-common.o
 obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-capture.o
+
+obj-$(CONFIG_VIDEO_IMX_CSI) += imx-media-csi.o
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
new file mode 100644
index 0000000..b9416ea6
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -0,0 +1,1498 @@
+/*
+ * V4L2 Capture CSI Subdev for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2014-2017 Mentor Graphics Inc.
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
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-mc.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-subdev.h>
+#include <media/videobuf2-dma-contig.h>
+#include <video/imx-ipu-v3.h>
+#include <media/imx.h>
+#include "imx-media.h"
+
+/*
+ * Min/Max supported width and heights.
+ *
+ * We allow planar output, so we have to align width by 16 pixels
+ * to meet IDMAC alignment requirements.
+ *
+ * TODO: move this into pad format negotiation, if capture device
+ * has not requested planar formats, we should allow 8 pixel
+ * alignment.
+ */
+#define MIN_W       176
+#define MIN_H       144
+#define MAX_W      4096
+#define MAX_H      4096
+#define W_ALIGN    4 /* multiple of 16 pixels */
+#define H_ALIGN    1 /* multiple of 2 lines */
+#define S_ALIGN    1 /* multiple of 2 */
+
+struct csi_priv {
+	struct device *dev;
+	struct ipu_soc *ipu;
+	struct imx_media_dev *md;
+	struct v4l2_subdev sd;
+	struct media_pad pad[CSI_NUM_PADS];
+	/* the video device at IDMAC output pad */
+	struct imx_media_video_dev *vdev;
+	struct imx_media_fim *fim;
+	int csi_id;
+	int smfc_id;
+
+	/* lock to protect all members below */
+	struct mutex lock;
+
+	int active_output_pad;
+
+	struct ipuv3_channel *idmac_ch;
+	struct ipu_smfc *smfc;
+	struct ipu_csi *csi;
+
+	struct v4l2_mbus_framefmt format_mbus[CSI_NUM_PADS];
+	const struct imx_media_pixfmt *cc[CSI_NUM_PADS];
+	struct v4l2_fract frame_interval;
+	struct v4l2_rect crop;
+
+	/* active vb2 buffers to send to video dev sink */
+	struct imx_media_buffer *active_vb2_buf[2];
+	struct imx_media_dma_buf underrun_buf;
+
+	int ipu_buf_num;  /* ipu double buffer index: 0-1 */
+
+	/* the sink for the captured frames */
+	struct media_entity *sink;
+	enum ipu_csi_dest dest;
+	/* the source subdev */
+	struct v4l2_subdev *src_sd;
+
+	/* the mipi virtual channel number at link validate */
+	int vc_num;
+
+	/* the attached sensor at stream on */
+	struct imx_media_subdev *sensor;
+
+	spinlock_t irqlock; /* protect eof_irq handler */
+	struct timer_list eof_timeout_timer;
+	int eof_irq;
+	int nfb4eof_irq;
+
+	struct v4l2_ctrl_handler ctrl_hdlr;
+
+	int power_count;  /* power counter */
+	int stream_count; /* streaming counter */
+	bool last_eof;   /* waiting for last EOF at stream off */
+	bool nfb4eof;    /* NFB4EOF encountered during streaming */
+	struct completion last_eof_comp;
+};
+
+static inline struct csi_priv *sd_to_dev(struct v4l2_subdev *sdev)
+{
+	return container_of(sdev, struct csi_priv, sd);
+}
+
+static void csi_idmac_put_ipu_resources(struct csi_priv *priv)
+{
+	if (!IS_ERR_OR_NULL(priv->idmac_ch))
+		ipu_idmac_put(priv->idmac_ch);
+	priv->idmac_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->smfc))
+		ipu_smfc_put(priv->smfc);
+	priv->smfc = NULL;
+}
+
+static int csi_idmac_get_ipu_resources(struct csi_priv *priv)
+{
+	int ch_num, ret;
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
+	priv->idmac_ch = ipu_idmac_get(priv->ipu, ch_num);
+	if (IS_ERR(priv->idmac_ch)) {
+		v4l2_err(&priv->sd, "could not get IDMAC channel %u\n",
+			 ch_num);
+		ret = PTR_ERR(priv->idmac_ch);
+		goto out;
+	}
+
+	return 0;
+out:
+	csi_idmac_put_ipu_resources(priv);
+	return ret;
+}
+
+static void csi_vb2_buf_done(struct csi_priv *priv)
+{
+	struct imx_media_video_dev *vdev = priv->vdev;
+	struct imx_media_buffer *done, *next;
+	struct vb2_buffer *vb;
+	dma_addr_t phys;
+
+	done = priv->active_vb2_buf[priv->ipu_buf_num];
+	if (done) {
+		vb = &done->vbuf.vb2_buf;
+		vb->timestamp = ktime_get_ns();
+		vb2_buffer_done(vb, priv->nfb4eof ?
+				VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+	}
+
+	priv->nfb4eof = false;
+
+	/* get next queued buffer */
+	next = imx_media_capture_device_next_buf(vdev);
+	if (next) {
+		phys = vb2_dma_contig_plane_dma_addr(&next->vbuf.vb2_buf, 0);
+		priv->active_vb2_buf[priv->ipu_buf_num] = next;
+	} else {
+		phys = priv->underrun_buf.phys;
+		priv->active_vb2_buf[priv->ipu_buf_num] = NULL;
+	}
+
+	if (ipu_idmac_buffer_is_ready(priv->idmac_ch, priv->ipu_buf_num))
+		ipu_idmac_clear_buffer(priv->idmac_ch, priv->ipu_buf_num);
+
+	ipu_cpmem_set_buffer(priv->idmac_ch, priv->ipu_buf_num, phys);
+}
+
+static irqreturn_t csi_idmac_eof_interrupt(int irq, void *dev_id)
+{
+	struct csi_priv *priv = dev_id;
+
+	spin_lock(&priv->irqlock);
+
+	if (priv->last_eof) {
+		complete(&priv->last_eof_comp);
+		priv->last_eof = false;
+		goto unlock;
+	}
+
+	if (priv->fim) {
+		struct timespec cur_ts;
+
+		ktime_get_ts(&cur_ts);
+		/* call frame interval monitor */
+		imx_media_fim_eof_monitor(priv->fim, &cur_ts);
+	}
+
+	csi_vb2_buf_done(priv);
+
+	/* select new IPU buf */
+	ipu_idmac_select_buffer(priv->idmac_ch, priv->ipu_buf_num);
+	/* toggle IPU double-buffer index */
+	priv->ipu_buf_num ^= 1;
+
+	/* bump the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
+
+unlock:
+	spin_unlock(&priv->irqlock);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t csi_idmac_nfb4eof_interrupt(int irq, void *dev_id)
+{
+	struct csi_priv *priv = dev_id;
+
+	spin_lock(&priv->irqlock);
+
+	/*
+	 * this is not an unrecoverable error, just mark
+	 * the next captured frame with vb2 error flag.
+	 */
+	priv->nfb4eof = true;
+
+	v4l2_err(&priv->sd, "NFB4EOF\n");
+
+	spin_unlock(&priv->irqlock);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * EOF timeout timer function. This is an unrecoverable condition
+ * without a stream restart.
+ */
+static void csi_idmac_eof_timeout(unsigned long data)
+{
+	struct csi_priv *priv = (struct csi_priv *)data;
+	struct imx_media_video_dev *vdev = priv->vdev;
+
+	v4l2_err(&priv->sd, "EOF timeout\n");
+
+	/* signal a fatal error to capture device */
+	imx_media_capture_device_error(vdev);
+}
+
+static void csi_idmac_setup_vb2_buf(struct csi_priv *priv, dma_addr_t *phys)
+{
+	struct imx_media_video_dev *vdev = priv->vdev;
+	struct imx_media_buffer *buf;
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		buf = imx_media_capture_device_next_buf(vdev);
+		if (buf) {
+			priv->active_vb2_buf[i] = buf;
+			phys[i] = vb2_dma_contig_plane_dma_addr(
+				&buf->vbuf.vb2_buf, 0);
+		} else {
+			priv->active_vb2_buf[i] = NULL;
+			phys[i] = priv->underrun_buf.phys;
+		}
+	}
+}
+
+static void csi_idmac_unsetup_vb2_buf(struct csi_priv *priv,
+				      enum vb2_buffer_state return_status)
+{
+	struct imx_media_buffer *buf;
+	int i;
+
+	/* return any remaining active frames with return_status */
+	for (i = 0; i < 2; i++) {
+		buf = priv->active_vb2_buf[i];
+		if (buf) {
+			struct vb2_buffer *vb = &buf->vbuf.vb2_buf;
+
+			vb->timestamp = ktime_get_ns();
+			vb2_buffer_done(vb, return_status);
+		}
+	}
+}
+
+/* init the SMFC IDMAC channel */
+static int csi_idmac_setup_channel(struct csi_priv *priv)
+{
+	struct imx_media_video_dev *vdev = priv->vdev;
+	struct v4l2_of_endpoint *sensor_ep;
+	struct v4l2_mbus_framefmt *infmt;
+	unsigned int burst_size;
+	struct ipu_image image;
+	dma_addr_t phys[2];
+	bool passthrough;
+	int ret;
+
+	infmt = &priv->format_mbus[CSI_SINK_PAD];
+	sensor_ep = &priv->sensor->sensor_ep;
+
+	ipu_cpmem_zero(priv->idmac_ch);
+
+	memset(&image, 0, sizeof(image));
+	image.pix = vdev->fmt.fmt.pix;
+	image.rect.width = image.pix.width;
+	image.rect.height = image.pix.height;
+
+	csi_idmac_setup_vb2_buf(priv, phys);
+
+	image.phys0 = phys[0];
+	image.phys1 = phys[1];
+
+	ret = ipu_cpmem_set_image(priv->idmac_ch, &image);
+	if (ret)
+		goto unsetup_vb2;
+
+	burst_size = (image.pix.width & 0xf) ? 8 : 16;
+
+	ipu_cpmem_set_burstsize(priv->idmac_ch, burst_size);
+
+	/*
+	 * If the sensor uses 16-bit parallel CSI bus, we must handle
+	 * the data internally in the IPU as 16-bit generic, aka
+	 * passthrough mode.
+	 */
+	passthrough = (sensor_ep->bus_type != V4L2_MBUS_CSI2 &&
+		       sensor_ep->bus.parallel.bus_width >= 16);
+
+	if (passthrough)
+		ipu_cpmem_set_format_passthrough(priv->idmac_ch, 16);
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
+	ipu_cpmem_set_high_priority(priv->idmac_ch);
+	ipu_idmac_enable_watermark(priv->idmac_ch, true);
+	ipu_cpmem_set_axi_id(priv->idmac_ch, 0);
+
+	burst_size = passthrough ?
+		(burst_size >> 3) - 1 : (burst_size >> 2) - 1;
+
+	ipu_smfc_set_burstsize(priv->smfc, burst_size);
+
+	if (image.pix.field == V4L2_FIELD_NONE &&
+	    V4L2_FIELD_HAS_BOTH(infmt->field))
+		ipu_cpmem_interlaced_scan(priv->idmac_ch,
+					  image.pix.bytesperline);
+
+	ipu_idmac_set_double_buffer(priv->idmac_ch, true);
+
+	return 0;
+
+unsetup_vb2:
+	csi_idmac_unsetup_vb2_buf(priv, VB2_BUF_STATE_QUEUED);
+	return ret;
+}
+
+static void csi_idmac_unsetup(struct csi_priv *priv,
+			      enum vb2_buffer_state state)
+{
+	ipu_idmac_disable_channel(priv->idmac_ch);
+	ipu_smfc_disable(priv->smfc);
+
+	csi_idmac_unsetup_vb2_buf(priv, state);
+}
+
+static int csi_idmac_setup(struct csi_priv *priv)
+{
+	int ret;
+
+	ret = csi_idmac_setup_channel(priv);
+	if (ret)
+		return ret;
+
+	ipu_cpmem_dump(priv->idmac_ch);
+	ipu_dump(priv->ipu);
+
+	ipu_smfc_enable(priv->smfc);
+
+	/* set buffers ready */
+	ipu_idmac_select_buffer(priv->idmac_ch, 0);
+	ipu_idmac_select_buffer(priv->idmac_ch, 1);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->idmac_ch);
+
+	return 0;
+}
+
+static int csi_idmac_start(struct csi_priv *priv)
+{
+	struct imx_media_video_dev *vdev = priv->vdev;
+	struct v4l2_pix_format *outfmt;
+	int ret;
+
+	ret = csi_idmac_get_ipu_resources(priv);
+	if (ret)
+		return ret;
+
+	ipu_smfc_map_channel(priv->smfc, priv->csi_id, priv->vc_num);
+
+	outfmt = &vdev->fmt.fmt.pix;
+
+	ret = imx_media_alloc_dma_buf(priv->md, &priv->underrun_buf,
+				      outfmt->sizeimage);
+	if (ret)
+		goto out_put_ipu;
+
+	priv->ipu_buf_num = 0;
+
+	/* init EOF completion waitq */
+	init_completion(&priv->last_eof_comp);
+	priv->last_eof = false;
+	priv->nfb4eof = false;
+
+	ret = csi_idmac_setup(priv);
+	if (ret) {
+		v4l2_err(&priv->sd, "csi_idmac_setup failed: %d\n", ret);
+		goto out_free_dma_buf;
+	}
+
+	priv->nfb4eof_irq = ipu_idmac_channel_irq(priv->ipu,
+						 priv->idmac_ch,
+						 IPU_IRQ_NFB4EOF);
+	ret = devm_request_irq(priv->dev, priv->nfb4eof_irq,
+			       csi_idmac_nfb4eof_interrupt, 0,
+			       "imx-smfc-nfb4eof", priv);
+	if (ret) {
+		v4l2_err(&priv->sd,
+			 "Error registering NFB4EOF irq: %d\n", ret);
+		goto out_unsetup;
+	}
+
+	priv->eof_irq = ipu_idmac_channel_irq(priv->ipu, priv->idmac_ch,
+					      IPU_IRQ_EOF);
+
+	ret = devm_request_irq(priv->dev, priv->eof_irq,
+			       csi_idmac_eof_interrupt, 0,
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
+	csi_idmac_unsetup(priv, VB2_BUF_STATE_QUEUED);
+out_free_dma_buf:
+	imx_media_free_dma_buf(priv->md, &priv->underrun_buf);
+out_put_ipu:
+	csi_idmac_put_ipu_resources(priv);
+	return ret;
+}
+
+static void csi_idmac_stop(struct csi_priv *priv)
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
+	csi_idmac_unsetup(priv, VB2_BUF_STATE_ERROR);
+
+	imx_media_free_dma_buf(priv->md, &priv->underrun_buf);
+
+	/* cancel the EOF timeout timer */
+	del_timer_sync(&priv->eof_timeout_timer);
+
+	csi_idmac_put_ipu_resources(priv);
+}
+
+/* Update the CSI whole sensor and active windows */
+static int csi_setup(struct csi_priv *priv)
+{
+	struct v4l2_mbus_framefmt *infmt, *outfmt;
+	struct v4l2_mbus_config sensor_mbus_cfg;
+	struct v4l2_of_endpoint *sensor_ep;
+	struct v4l2_mbus_framefmt if_fmt;
+
+	infmt = &priv->format_mbus[CSI_SINK_PAD];
+	outfmt = &priv->format_mbus[priv->active_output_pad];
+	sensor_ep = &priv->sensor->sensor_ep;
+
+	/* compose mbus_config from sensor endpoint */
+	sensor_mbus_cfg.type = sensor_ep->bus_type;
+	sensor_mbus_cfg.flags = (sensor_ep->bus_type == V4L2_MBUS_CSI2) ?
+		sensor_ep->bus.mipi_csi2.flags :
+		sensor_ep->bus.parallel.flags;
+
+	/*
+	 * we need to pass input sensor frame to CSI interface, but
+	 * with translated field type from output format
+	 */
+	if_fmt = *infmt;
+	if_fmt.field = outfmt->field;
+
+	ipu_csi_set_window(priv->csi, &priv->crop);
+
+	ipu_csi_set_downsize(priv->csi,
+			     priv->crop.width == 2 * outfmt->width,
+			     priv->crop.height == 2 * outfmt->height);
+
+	ipu_csi_init_interface(priv->csi, &sensor_mbus_cfg, &if_fmt);
+
+	ipu_csi_set_dest(priv->csi, priv->dest);
+
+	ipu_csi_dump(priv->csi);
+
+	return 0;
+}
+
+static int csi_start(struct csi_priv *priv)
+{
+	u32 bad_frames = 0;
+	int ret;
+
+	if (!priv->sensor) {
+		v4l2_err(&priv->sd, "no sensor attached\n");
+		return -EINVAL;
+	}
+
+	ret = v4l2_subdev_call(priv->sensor->sd, sensor,
+			       g_skip_frames, &bad_frames);
+	if (!ret && bad_frames) {
+		struct v4l2_fract *fi = &priv->frame_interval;
+		u32 delay_usec;
+
+		/*
+		 * This sensor has bad frames when it is turned on,
+		 * add a delay to avoid them before enabling the CSI
+		 * hardware. Especially for sensors with a bt.656 interface,
+		 * any shifts in the SAV/EAV sync codes will cause the CSI
+		 * to lose vert/horiz sync.
+		 */
+		delay_usec = DIV_ROUND_UP_ULL(
+			(u64)USEC_PER_SEC * fi->numerator * bad_frames,
+			fi->denominator);
+		usleep_range(delay_usec, delay_usec + 1000);
+	}
+
+	if (priv->dest == IPU_CSI_DEST_IDMAC) {
+		ret = csi_idmac_start(priv);
+		if (ret)
+			return ret;
+	}
+
+	ret = csi_setup(priv);
+	if (ret)
+		goto idmac_stop;
+
+	/* start the frame interval monitor */
+	if (priv->fim && priv->dest == IPU_CSI_DEST_IDMAC)
+		imx_media_fim_set_stream(priv->fim, &priv->frame_interval,
+					 true);
+
+	ret = ipu_csi_enable(priv->csi);
+	if (ret) {
+		v4l2_err(&priv->sd, "CSI enable error: %d\n", ret);
+		goto fim_off;
+	}
+
+	return 0;
+
+fim_off:
+	if (priv->fim && priv->dest == IPU_CSI_DEST_IDMAC)
+		imx_media_fim_set_stream(priv->fim, &priv->frame_interval,
+					 false);
+idmac_stop:
+	if (priv->dest == IPU_CSI_DEST_IDMAC)
+		csi_idmac_stop(priv);
+	return ret;
+}
+
+static void csi_stop(struct csi_priv *priv)
+{
+	if (priv->dest == IPU_CSI_DEST_IDMAC) {
+		csi_idmac_stop(priv);
+
+		/* stop the frame interval monitor */
+		if (priv->fim)
+			imx_media_fim_set_stream(priv->fim,
+						 &priv->frame_interval,
+						 false);
+	}
+
+	ipu_csi_disable(priv->csi);
+}
+
+/*
+ * V4L2 subdev operations.
+ */
+
+static int csi_g_frame_interval(struct v4l2_subdev *sd,
+				struct v4l2_subdev_frame_interval *fi)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+
+	mutex_lock(&priv->lock);
+	fi->interval = priv->frame_interval;
+	mutex_unlock(&priv->lock);
+
+	return 0;
+}
+
+static int csi_s_frame_interval(struct v4l2_subdev *sd,
+				struct v4l2_subdev_frame_interval *fi)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+
+	mutex_lock(&priv->lock);
+
+	/* Output pads mirror active input pad, no limits on input pads */
+	if (fi->pad == CSI_SRC_PAD_IDMAC || fi->pad == CSI_SRC_PAD_DIRECT)
+		fi->interval = priv->frame_interval;
+
+	priv->frame_interval = fi->interval;
+
+	mutex_unlock(&priv->lock);
+
+	return 0;
+}
+
+static int csi_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	mutex_lock(&priv->lock);
+
+	if (!priv->src_sd || !priv->sink) {
+		ret = -EPIPE;
+		goto out;
+	}
+
+	/*
+	 * enable/disable streaming only if stream_count is
+	 * going from 0 to 1 / 1 to 0.
+	 */
+	if (priv->stream_count != !enable)
+		goto update_count;
+
+	if (enable) {
+		/* upstream must be started first, before starting CSI */
+		ret = v4l2_subdev_call(priv->src_sd, video, s_stream, 1);
+		ret = (ret && ret != -ENOIOCTLCMD) ? ret : 0;
+		if (ret)
+			goto out;
+
+		dev_dbg(priv->dev, "stream ON\n");
+		ret = csi_start(priv);
+		if (ret) {
+			v4l2_subdev_call(priv->src_sd, video, s_stream, 0);
+			goto out;
+		}
+	} else {
+		dev_dbg(priv->dev, "stream OFF\n");
+		/* CSI must be stopped first, then stop upstream */
+		csi_stop(priv);
+		v4l2_subdev_call(priv->src_sd, video, s_stream, 0);
+	}
+
+update_count:
+	priv->stream_count += enable ? 1 : -1;
+	WARN_ON(priv->stream_count < 0);
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int csi_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	mutex_lock(&priv->lock);
+
+	/*
+	 * If the power count is modified from 0 to != 0 or from != 0 to 0,
+	 * update the power state.
+	 */
+	if (priv->power_count == !on) {
+		if (priv->fim && priv->dest == IPU_CSI_DEST_IDMAC) {
+			ret = imx_media_fim_set_power(priv->fim, on);
+			if (ret)
+				goto out;
+		}
+	}
+
+	/* Update the power count. */
+	priv->power_count += on ? 1 : -1;
+	WARN_ON(priv->power_count < 0);
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int csi_link_setup(struct media_entity *entity,
+			  const struct media_pad *local,
+			  const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_subdev *remote_sd;
+	int ret = 0;
+
+	dev_dbg(priv->dev, "link setup %s -> %s\n", remote->entity->name,
+		local->entity->name);
+
+	mutex_lock(&priv->lock);
+
+	if (local->flags & MEDIA_PAD_FL_SINK) {
+		if (!is_media_entity_v4l2_subdev(remote->entity)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		remote_sd = media_entity_to_v4l2_subdev(remote->entity);
+
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (priv->src_sd) {
+				ret = -EBUSY;
+				goto out;
+			}
+			priv->src_sd = remote_sd;
+		} else {
+			priv->src_sd = NULL;
+		}
+
+		goto out;
+	}
+
+	/* this is a source pad */
+
+	if (flags & MEDIA_LNK_FL_ENABLED) {
+		if (priv->sink) {
+			ret = -EBUSY;
+			goto out;
+		}
+	} else {
+		v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
+		v4l2_ctrl_handler_init(&priv->ctrl_hdlr, 0);
+		priv->sink = NULL;
+		goto out;
+	}
+
+	/* record which output pad is now active */
+	priv->active_output_pad = local->index;
+
+	/* set CSI destination */
+	if (local->index == CSI_SRC_PAD_IDMAC) {
+		if (!is_media_entity_v4l2_video_device(remote->entity)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (priv->fim) {
+			ret = imx_media_fim_add_controls(priv->fim);
+			if (ret)
+				goto out;
+		}
+
+		priv->dest = IPU_CSI_DEST_IDMAC;
+	} else {
+		if (!is_media_entity_v4l2_subdev(remote->entity)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		remote_sd = media_entity_to_v4l2_subdev(remote->entity);
+		switch (remote_sd->grp_id) {
+		case IMX_MEDIA_GRP_ID_VDIC:
+			priv->dest = IPU_CSI_DEST_VDIC;
+			break;
+		case IMX_MEDIA_GRP_ID_IC_PRP:
+			priv->dest = IPU_CSI_DEST_IC;
+			break;
+		default:
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	priv->sink = remote->entity;
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int csi_link_validate(struct v4l2_subdev *sd,
+			     struct media_link *link,
+			     struct v4l2_subdev_format *source_fmt,
+			     struct v4l2_subdev_format *sink_fmt)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_of_endpoint *sensor_ep;
+	struct imx_media_subdev *sensor;
+	bool is_csi2;
+	int ret;
+
+	ret = v4l2_subdev_link_validate_default(sd, link,
+						source_fmt, sink_fmt);
+	if (ret)
+		return ret;
+
+	sensor = __imx_media_find_sensor(priv->md, &priv->sd.entity);
+	if (IS_ERR(sensor)) {
+		v4l2_err(&priv->sd, "no sensor attached\n");
+		return PTR_ERR(priv->sensor);
+	}
+
+	mutex_lock(&priv->lock);
+
+	priv->sensor = sensor;
+	sensor_ep = &priv->sensor->sensor_ep;
+	is_csi2 = (sensor_ep->bus_type == V4L2_MBUS_CSI2);
+
+	if (is_csi2) {
+		int vc_num = 0;
+		/*
+		 * NOTE! It seems the virtual channels from the mipi csi-2
+		 * receiver are used only for routing by the video mux's,
+		 * or for hard-wired routing to the CSI's. Once the stream
+		 * enters the CSI's however, they are treated internally
+		 * in the IPU as virtual channel 0.
+		 */
+#if 0
+		mutex_unlock(&priv->lock);
+		vc_num = imx_media_find_mipi_csi2_channel(priv->md,
+							  &priv->sd.entity);
+		if (vc_num < 0)
+			return vc_num;
+		mutex_lock(&priv->lock);
+#endif
+		ipu_csi_set_mipi_datatype(priv->csi, vc_num,
+					  &priv->format_mbus[CSI_SINK_PAD]);
+	}
+
+	/* select either parallel or MIPI-CSI2 as input to CSI */
+	ipu_set_csi_src_mux(priv->ipu, priv->csi_id, is_csi2);
+
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static struct v4l2_mbus_framefmt *
+__csi_get_fmt(struct csi_priv *priv, struct v4l2_subdev_pad_config *cfg,
+	      unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(&priv->sd, cfg, pad);
+	else
+		return &priv->format_mbus[pad];
+}
+
+static struct v4l2_rect *
+__csi_get_crop(struct csi_priv *priv, struct v4l2_subdev_pad_config *cfg,
+	       enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_crop(&priv->sd, cfg, CSI_SINK_PAD);
+	else
+		return &priv->crop;
+}
+
+static void csi_try_crop(struct csi_priv *priv,
+			 struct v4l2_rect *crop,
+			 struct v4l2_subdev_pad_config *cfg,
+			 struct v4l2_mbus_framefmt *infmt,
+			 struct imx_media_subdev *sensor)
+{
+	struct v4l2_of_endpoint *sensor_ep;
+
+	sensor_ep = &sensor->sensor_ep;
+
+	crop->width = min_t(__u32, infmt->width, crop->width);
+	if (crop->left + crop->width > infmt->width)
+		crop->left = infmt->width - crop->width;
+	/* adjust crop left/width to h/w alignment restrictions */
+	crop->left &= ~0x3;
+	crop->width &= ~0x7;
+
+	/*
+	 * FIXME: not sure why yet, but on interlaced bt.656,
+	 * changing the vertical cropping causes loss of vertical
+	 * sync, so fix it to NTSC/PAL active lines. NTSC contains
+	 * 2 extra lines of active video that need to be cropped.
+	 */
+	if (sensor_ep->bus_type == V4L2_MBUS_BT656 &&
+	    (V4L2_FIELD_HAS_BOTH(infmt->field) ||
+	     infmt->field == V4L2_FIELD_ALTERNATE)) {
+		crop->height = infmt->height;
+		crop->top = (infmt->height == 480) ? 2 : 0;
+	} else {
+		crop->height = min_t(__u32, infmt->height, crop->height);
+		if (crop->top + crop->height > infmt->height)
+			crop->top = infmt->height - crop->height;
+	}
+}
+
+static int csi_enum_mbus_code(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	const struct imx_media_pixfmt *incc;
+	struct v4l2_mbus_framefmt *infmt;
+	int ret = 0;
+
+	mutex_lock(&priv->lock);
+
+	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, code->which);
+	incc = imx_media_find_mbus_format(infmt->code, CS_SEL_ANY, true);
+
+	switch (code->pad) {
+	case CSI_SINK_PAD:
+		ret = imx_media_enum_mbus_format(&code->code, code->index,
+						 CS_SEL_ANY, true);
+		break;
+	case CSI_SRC_PAD_DIRECT:
+	case CSI_SRC_PAD_IDMAC:
+		if (incc->bayer) {
+			if (code->index != 0) {
+				ret = -EINVAL;
+				goto out;
+			}
+			code->code = infmt->code;
+		} else {
+			u32 cs_sel = (incc->cs == IPUV3_COLORSPACE_YUV) ?
+				CS_SEL_YUV : CS_SEL_RGB;
+			ret = imx_media_enum_ipu_format(&code->code,
+							code->index,
+							cs_sel);
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int csi_get_fmt(struct v4l2_subdev *sd,
+		       struct v4l2_subdev_pad_config *cfg,
+		       struct v4l2_subdev_format *sdformat)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *fmt;
+	int ret = 0;
+
+	if (sdformat->pad >= CSI_NUM_PADS)
+		return -EINVAL;
+
+	mutex_lock(&priv->lock);
+
+	fmt = __csi_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
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
+static void csi_try_fmt(struct csi_priv *priv,
+			struct imx_media_subdev *sensor,
+			struct v4l2_subdev_pad_config *cfg,
+			struct v4l2_subdev_format *sdformat,
+			struct v4l2_rect *crop,
+			const struct imx_media_pixfmt **cc)
+{
+	const struct imx_media_pixfmt *incc;
+	struct v4l2_mbus_framefmt *infmt;
+	u32 code;
+
+	switch (sdformat->pad) {
+	case CSI_SRC_PAD_DIRECT:
+	case CSI_SRC_PAD_IDMAC:
+		infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD,
+				      sdformat->which);
+		incc = imx_media_find_mbus_format(infmt->code,
+						  CS_SEL_ANY, true);
+
+		if (sdformat->format.width < crop->width * 3 / 4)
+			sdformat->format.width = crop->width / 2;
+		else
+			sdformat->format.width = crop->width;
+
+		if (sdformat->format.height < crop->height * 3 / 4)
+			sdformat->format.height = crop->height / 2;
+		else
+			sdformat->format.height = crop->height;
+
+		if (incc->bayer) {
+			sdformat->format.code = infmt->code;
+			*cc = incc;
+		} else {
+			u32 cs_sel = (incc->cs == IPUV3_COLORSPACE_YUV) ?
+				CS_SEL_YUV : CS_SEL_RGB;
+
+			*cc = imx_media_find_ipu_format(sdformat->format.code,
+							cs_sel);
+			if (!*cc) {
+				imx_media_enum_ipu_format(&code, 0, cs_sel);
+				*cc = imx_media_find_ipu_format(code, cs_sel);
+				sdformat->format.code = (*cc)->codes[0];
+			}
+		}
+
+		if (sdformat->pad == CSI_SRC_PAD_DIRECT ||
+		    sdformat->format.field != V4L2_FIELD_NONE)
+			sdformat->format.field = infmt->field;
+
+		/*
+		 * translate V4L2_FIELD_ALTERNATE to SEQ_TB or SEQ_BT
+		 * depending on input height (assume NTSC top-bottom
+		 * order if 480 lines, otherwise PAL bottom-top order).
+		 */
+		if (sdformat->format.field == V4L2_FIELD_ALTERNATE) {
+			sdformat->format.field =  (infmt->height == 480) ?
+				V4L2_FIELD_SEQ_TB : V4L2_FIELD_SEQ_BT;
+		}
+		break;
+	case CSI_SINK_PAD:
+		v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
+				      W_ALIGN, &sdformat->format.height,
+				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
+		crop->left = 0;
+		crop->top = 0;
+		crop->width = sdformat->format.width;
+		crop->height = sdformat->format.height;
+		csi_try_crop(priv, crop, cfg, &sdformat->format, sensor);
+
+		*cc = imx_media_find_mbus_format(sdformat->format.code,
+						 CS_SEL_ANY, true);
+		if (!*cc) {
+			imx_media_enum_mbus_format(&code, 0,
+						   CS_SEL_ANY, false);
+			*cc = imx_media_find_mbus_format(code,
+							CS_SEL_ANY, false);
+			sdformat->format.code = (*cc)->codes[0];
+		}
+		break;
+	}
+}
+
+static int csi_set_fmt(struct v4l2_subdev *sd,
+		       struct v4l2_subdev_pad_config *cfg,
+		       struct v4l2_subdev_format *sdformat)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct imx_media_video_dev *vdev = priv->vdev;
+	const struct imx_media_pixfmt *cc;
+	struct imx_media_subdev *sensor;
+	struct v4l2_pix_format vdev_fmt;
+	struct v4l2_mbus_framefmt *fmt;
+	struct v4l2_rect *crop;
+	int ret = 0;
+
+	if (sdformat->pad >= CSI_NUM_PADS)
+		return -EINVAL;
+
+	sensor = imx_media_find_sensor(priv->md, &priv->sd.entity);
+	if (IS_ERR(sensor)) {
+		v4l2_err(&priv->sd, "no sensor attached\n");
+		return PTR_ERR(sensor);
+	}
+
+	mutex_lock(&priv->lock);
+
+	if (priv->stream_count > 0) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	crop = __csi_get_crop(priv, cfg, sdformat->which);
+
+	csi_try_fmt(priv, sensor, cfg, sdformat, crop, &cc);
+
+	fmt = __csi_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
+	*fmt = sdformat->format;
+
+	if (sdformat->pad == CSI_SINK_PAD) {
+		int pad;
+
+		/* propagate format to source pads */
+		for (pad = CSI_SINK_PAD + 1; pad < CSI_NUM_PADS; pad++) {
+			const struct imx_media_pixfmt *outcc;
+			struct v4l2_mbus_framefmt *outfmt;
+			struct v4l2_subdev_format format;
+
+			format.pad = pad;
+			format.which = sdformat->which;
+			format.format = sdformat->format;
+			csi_try_fmt(priv, sensor, cfg, &format, crop, &outcc);
+
+			outfmt = __csi_get_fmt(priv, cfg, pad, sdformat->which);
+			*outfmt = format.format;
+
+			if (sdformat->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+				priv->cc[pad] = outcc;
+		}
+	}
+
+	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY)
+		goto out;
+
+	priv->cc[sdformat->pad] = cc;
+
+	/* propagate IDMAC output pad format to capture device */
+	imx_media_mbus_fmt_to_pix_fmt(&vdev_fmt,
+				      &priv->format_mbus[CSI_SRC_PAD_IDMAC],
+				      priv->cc[CSI_SRC_PAD_IDMAC]);
+	mutex_unlock(&priv->lock);
+	imx_media_capture_device_set_format(vdev, &vdev_fmt);
+
+	return 0;
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int csi_get_selection(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_selection *sel)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *infmt;
+	struct v4l2_rect *crop;
+	int ret = 0;
+
+	if (sel->pad >= CSI_NUM_PADS || sel->pad == CSI_SINK_PAD)
+		return -EINVAL;
+
+	mutex_lock(&priv->lock);
+
+	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sel->which);
+	crop = __csi_get_crop(priv, cfg, sel->which);
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = infmt->width;
+		sel->r.height = infmt->height;
+		break;
+	case V4L2_SEL_TGT_CROP:
+		sel->r = *crop;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int csi_set_selection(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_selection *sel)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *infmt;
+	struct imx_media_subdev *sensor;
+	struct v4l2_rect *crop;
+	int pad, ret = 0;
+
+	if (sel->pad >= CSI_NUM_PADS ||
+	    sel->pad == CSI_SINK_PAD ||
+	    sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
+	sensor = imx_media_find_sensor(priv->md, &priv->sd.entity);
+	if (IS_ERR(sensor)) {
+		v4l2_err(&priv->sd, "no sensor attached\n");
+		return PTR_ERR(sensor);
+	}
+
+	mutex_lock(&priv->lock);
+
+	if (priv->stream_count > 0) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	infmt = __csi_get_fmt(priv, cfg, CSI_SINK_PAD, sel->which);
+	crop = __csi_get_crop(priv, cfg, sel->which);
+
+	/*
+	 * Modifying the crop rectangle always changes the format on the source
+	 * pad. If the KEEP_CONFIG flag is set, just return the current crop
+	 * rectangle.
+	 */
+	if (sel->flags & V4L2_SEL_FLAG_KEEP_CONFIG) {
+		sel->r = priv->crop;
+		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
+			*crop = sel->r;
+		goto out;
+	}
+
+	csi_try_crop(priv, &sel->r, cfg, infmt, sensor);
+
+	*crop = sel->r;
+
+	/* Update the source pad formats */
+	for (pad = CSI_SINK_PAD + 1; pad < CSI_NUM_PADS; pad++) {
+		struct v4l2_mbus_framefmt *outfmt;
+
+		outfmt = __csi_get_fmt(priv, cfg, pad, sel->which);
+		outfmt->width = crop->width;
+		outfmt->height = crop->height;
+	}
+
+out:
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
+static int csi_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+			       struct v4l2_event_subscription *sub)
+{
+	if (sub->type != V4L2_EVENT_IMX_FRAME_INTERVAL_ERROR)
+		return -EINVAL;
+	if (sub->id != 0)
+		return -EINVAL;
+
+	return v4l2_event_subscribe(fh, sub, 0, NULL);
+}
+
+static int csi_unsubscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+				 struct v4l2_event_subscription *sub)
+{
+	return v4l2_event_unsubscribe(fh, sub);
+}
+
+/*
+ * retrieve our pads parsed from the OF graph by the media device
+ */
+static int csi_registered(struct v4l2_subdev *sd)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	int i, ret;
+	u32 code;
+
+	/* get media device */
+	priv->md = dev_get_drvdata(sd->v4l2_dev->dev);
+
+	/* get handle to IPU CSI */
+	priv->csi = ipu_csi_get(priv->ipu, priv->csi_id);
+	if (IS_ERR(priv->csi)) {
+		v4l2_err(&priv->sd, "failed to get CSI%d\n", priv->csi_id);
+		return PTR_ERR(priv->csi);
+	}
+
+	for (i = 0; i < CSI_NUM_PADS; i++) {
+		priv->pad[i].flags = (i == CSI_SINK_PAD) ?
+			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
+
+		code = 0;
+		if (i != CSI_SINK_PAD)
+			imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
+
+		/* set a default mbus format  */
+		ret = imx_media_init_mbus_fmt(&priv->format_mbus[i],
+					      640, 480, code, V4L2_FIELD_NONE,
+					      &priv->cc[i]);
+		if (ret)
+			goto put_csi;
+	}
+
+	/* init default frame interval */
+	priv->frame_interval.numerator = 1;
+	priv->frame_interval.denominator = 30;
+
+	priv->fim = imx_media_fim_init(&priv->sd);
+	if (IS_ERR(priv->fim)) {
+		ret = PTR_ERR(priv->fim);
+		goto put_csi;
+	}
+
+	ret = media_entity_pads_init(&sd->entity, CSI_NUM_PADS, priv->pad);
+	if (ret)
+		goto free_fim;
+
+	ret = imx_media_capture_device_register(priv->vdev);
+	if (ret)
+		goto free_fim;
+
+	ret = imx_media_add_video_device(priv->md, priv->vdev);
+	if (ret)
+		goto unreg;
+
+	return 0;
+unreg:
+	imx_media_capture_device_unregister(priv->vdev);
+free_fim:
+	if (priv->fim)
+		imx_media_fim_free(priv->fim);
+put_csi:
+	ipu_csi_put(priv->csi);
+	return ret;
+}
+
+static void csi_unregistered(struct v4l2_subdev *sd)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+
+	imx_media_capture_device_unregister(priv->vdev);
+
+	if (priv->fim)
+		imx_media_fim_free(priv->fim);
+
+	if (!IS_ERR_OR_NULL(priv->csi))
+		ipu_csi_put(priv->csi);
+}
+
+static const struct media_entity_operations csi_entity_ops = {
+	.link_setup = csi_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static const struct v4l2_subdev_core_ops csi_core_ops = {
+	.s_power = csi_s_power,
+	.subscribe_event = csi_subscribe_event,
+	.unsubscribe_event = csi_unsubscribe_event,
+};
+
+static const struct v4l2_subdev_video_ops csi_video_ops = {
+	.g_frame_interval = csi_g_frame_interval,
+	.s_frame_interval = csi_s_frame_interval,
+	.s_stream = csi_s_stream,
+};
+
+static const struct v4l2_subdev_pad_ops csi_pad_ops = {
+	.enum_mbus_code = csi_enum_mbus_code,
+	.get_fmt = csi_get_fmt,
+	.set_fmt = csi_set_fmt,
+	.get_selection = csi_get_selection,
+	.set_selection = csi_set_selection,
+	.link_validate = csi_link_validate,
+};
+
+static const struct v4l2_subdev_ops csi_subdev_ops = {
+	.core = &csi_core_ops,
+	.video = &csi_video_ops,
+	.pad = &csi_pad_ops,
+};
+
+static const struct v4l2_subdev_internal_ops csi_internal_ops = {
+	.registered = csi_registered,
+	.unregistered = csi_unregistered,
+};
+
+static int imx_csi_probe(struct platform_device *pdev)
+{
+	struct ipu_client_platformdata *pdata;
+	struct pinctrl *pinctrl;
+	struct csi_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, &priv->sd);
+	priv->dev = &pdev->dev;
+
+	ret = dma_set_coherent_mask(priv->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
+
+	/* get parent IPU */
+	priv->ipu = dev_get_drvdata(priv->dev->parent);
+
+	/* get our CSI id */
+	pdata = priv->dev->platform_data;
+	priv->csi_id = pdata->csi;
+	priv->smfc_id = (priv->csi_id == 0) ? 0 : 2;
+
+	init_timer(&priv->eof_timeout_timer);
+	priv->eof_timeout_timer.data = (unsigned long)priv;
+	priv->eof_timeout_timer.function = csi_idmac_eof_timeout;
+	spin_lock_init(&priv->irqlock);
+
+	v4l2_subdev_init(&priv->sd, &csi_subdev_ops);
+	v4l2_set_subdevdata(&priv->sd, priv);
+	priv->sd.internal_ops = &csi_internal_ops;
+	priv->sd.entity.ops = &csi_entity_ops;
+	priv->sd.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
+	priv->sd.dev = &pdev->dev;
+	priv->sd.of_node = pdata->of_node;
+	priv->sd.owner = THIS_MODULE;
+	priv->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
+	priv->sd.grp_id = priv->csi_id ?
+		IMX_MEDIA_GRP_ID_CSI1 : IMX_MEDIA_GRP_ID_CSI0;
+	imx_media_grp_id_to_sd_name(priv->sd.name, sizeof(priv->sd.name),
+				    priv->sd.grp_id, ipu_get_num(priv->ipu));
+
+	priv->vdev = imx_media_capture_device_init(&priv->sd,
+						   CSI_SRC_PAD_IDMAC);
+	if (IS_ERR(priv->vdev))
+		return PTR_ERR(priv->vdev);
+
+	v4l2_ctrl_handler_init(&priv->ctrl_hdlr, 0);
+	priv->sd.ctrl_handler = &priv->ctrl_hdlr;
+
+	/*
+	 * The IPUv3 driver did not assign an of_node to this
+	 * device. As a result, pinctrl does not automatically
+	 * configure our pin groups, so we need to do that manually
+	 * here, after setting this device's of_node.
+	 */
+	priv->dev->of_node = pdata->of_node;
+	pinctrl = devm_pinctrl_get_select_default(priv->dev);
+
+	mutex_init(&priv->lock);
+
+	ret = v4l2_async_register_subdev(&priv->sd);
+	if (ret)
+		goto free;
+
+	return 0;
+free:
+	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
+	mutex_destroy(&priv->lock);
+	imx_media_capture_device_remove(priv->vdev);
+	return ret;
+}
+
+static int imx_csi_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct csi_priv *priv = sd_to_dev(sd);
+
+	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
+	mutex_destroy(&priv->lock);
+	imx_media_capture_device_remove(priv->vdev);
+	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+
+	return 0;
+}
+
+static const struct platform_device_id imx_csi_ids[] = {
+	{ .name = "imx-ipuv3-csi" },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, imx_csi_ids);
+
+static struct platform_driver imx_csi_driver = {
+	.probe = imx_csi_probe,
+	.remove = imx_csi_remove,
+	.id_table = imx_csi_ids,
+	.driver = {
+		.name = "imx-ipuv3-csi",
+	},
+};
+module_platform_driver(imx_csi_driver);
+
+MODULE_DESCRIPTION("i.MX CSI subdev driver");
+MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:imx-ipuv3-csi");
-- 
2.7.4
