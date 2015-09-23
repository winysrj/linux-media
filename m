Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6882 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbbIWBag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 21:30:36 -0400
From: Bryan Wu <pengw@nvidia.com>
To: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<treding@nvidia.com>
CC: <ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<davidw@nvidia.com>, <gfitzer@nvidia.com>, <bmurthyv@nvidia.com>,
	<linux-tegra@vger.kernel.org>
Subject: [PATCH 1/3] [media] v4l: tegra: Add NVIDIA Tegra VI driver
Date: Tue, 22 Sep 2015 18:30:32 -0700
Message-ID: <1442971834-2721-2-git-send-email-pengw@nvidia.com>
In-Reply-To: <1442971834-2721-1-git-send-email-pengw@nvidia.com>
References: <1442971834-2721-1-git-send-email-pengw@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NVIDIA Tegra processor contains a powerful Video Input (VI) hardware
controller which can support up to 6 MIPI CSI camera sensors.

This patch adds a V4L2 media controller and capture driver to support
Tegra VI hardware. It's verified with Tegra built-in test pattern
generator.

Signed-off-by: Bryan Wu <pengw@nvidia.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/Kconfig               |   1 +
 drivers/media/platform/Makefile              |   2 +
 drivers/media/platform/tegra/Kconfig         |  10 +
 drivers/media/platform/tegra/Makefile        |   3 +
 drivers/media/platform/tegra/tegra-channel.c | 767 +++++++++++++++++++++++++++
 drivers/media/platform/tegra/tegra-core.c    | 254 +++++++++
 drivers/media/platform/tegra/tegra-core.h    | 162 ++++++
 drivers/media/platform/tegra/tegra-csi.c     | 572 ++++++++++++++++++++
 drivers/media/platform/tegra/tegra-vi.c      | 583 ++++++++++++++++++++
 drivers/media/platform/tegra/tegra-vi.h      | 209 ++++++++
 10 files changed, 2563 insertions(+)
 create mode 100644 drivers/media/platform/tegra/Kconfig
 create mode 100644 drivers/media/platform/tegra/Makefile
 create mode 100644 drivers/media/platform/tegra/tegra-channel.c
 create mode 100644 drivers/media/platform/tegra/tegra-core.c
 create mode 100644 drivers/media/platform/tegra/tegra-core.h
 create mode 100644 drivers/media/platform/tegra/tegra-csi.c
 create mode 100644 drivers/media/platform/tegra/tegra-vi.c
 create mode 100644 drivers/media/platform/tegra/tegra-vi.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f6bed19..553867f 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -119,6 +119,7 @@ source "drivers/media/platform/exynos4-is/Kconfig"
 source "drivers/media/platform/s5p-tv/Kconfig"
 source "drivers/media/platform/am437x/Kconfig"
 source "drivers/media/platform/xilinx/Kconfig"
+source "drivers/media/platform/tegra/Kconfig"
 
 endif # V4L_PLATFORM_DRIVERS
 
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 114f9ab..426e0e4 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -52,4 +52,6 @@ obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
 
 obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
 
+obj-$(CONFIG_VIDEO_TEGRA)		+= tegra/
+
 ccflags-y += -I$(srctree)/drivers/media/i2c
diff --git a/drivers/media/platform/tegra/Kconfig b/drivers/media/platform/tegra/Kconfig
new file mode 100644
index 0000000..54c0e7a
--- /dev/null
+++ b/drivers/media/platform/tegra/Kconfig
@@ -0,0 +1,10 @@
+config VIDEO_TEGRA
+	tristate "NVIDIA Tegra Video Input Driver"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
+	depends on TEGRA_HOST1X
+	select VIDEOBUF2_DMA_CONTIG
+	---help---
+	  Driver for Video Input (VI) controller found on NVIDIA Tegra SoC.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called tegra-video.
diff --git a/drivers/media/platform/tegra/Makefile b/drivers/media/platform/tegra/Makefile
new file mode 100644
index 0000000..18a1c16
--- /dev/null
+++ b/drivers/media/platform/tegra/Makefile
@@ -0,0 +1,3 @@
+tegra-video-objs += tegra-core.o tegra-csi.o tegra-vi.o tegra-channel.o
+
+obj-$(CONFIG_VIDEO_TEGRA) += tegra-video.o
diff --git a/drivers/media/platform/tegra/tegra-channel.c b/drivers/media/platform/tegra/tegra-channel.c
new file mode 100644
index 0000000..735bb40
--- /dev/null
+++ b/drivers/media/platform/tegra/tegra-channel.c
@@ -0,0 +1,767 @@
+/*
+ * NVIDIA Tegra Video Input Device
+ *
+ * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Author: Bryan Wu <pengw@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/atomic.h>
+#include <linux/bitmap.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/host1x.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/lcm.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include <soc/tegra/pmc.h>
+
+#include "tegra-vi.h"
+
+#define TEGRA_VI_SYNCPT_WAIT_TIMEOUT			200
+
+/* VI registers */
+#define TEGRA_VI_CFG_VI_INCR_SYNCPT			0x000
+#define   VI_CFG_VI_INCR_SYNCPT_COND(x)			(((x) & 0xff) << 8)
+#define   VI_CSI_PP_LINE_START(port)			(4 + (port) * 4)
+#define   VI_CSI_PP_FRAME_START(port)			(5 + (port) * 4)
+#define   VI_CSI_MW_REQ_DONE(port)			(6 + (port) * 4)
+#define   VI_CSI_MW_ACK_DONE(port)			(7 + (port) * 4)
+
+#define TEGRA_VI_CFG_VI_INCR_SYNCPT_CNTRL		0x004
+#define TEGRA_VI_CFG_VI_INCR_SYNCPT_ERROR		0x008
+#define TEGRA_VI_CFG_CTXSW				0x020
+#define TEGRA_VI_CFG_INTSTATUS				0x024
+#define TEGRA_VI_CFG_PWM_CONTROL			0x038
+#define TEGRA_VI_CFG_PWM_HIGH_PULSE			0x03c
+#define TEGRA_VI_CFG_PWM_LOW_PULSE			0x040
+#define TEGRA_VI_CFG_PWM_SELECT_PULSE_A			0x044
+#define TEGRA_VI_CFG_PWM_SELECT_PULSE_B			0x048
+#define TEGRA_VI_CFG_PWM_SELECT_PULSE_C			0x04c
+#define TEGRA_VI_CFG_PWM_SELECT_PULSE_D			0x050
+#define TEGRA_VI_CFG_VGP1				0x064
+#define TEGRA_VI_CFG_VGP2				0x068
+#define TEGRA_VI_CFG_VGP3				0x06c
+#define TEGRA_VI_CFG_VGP4				0x070
+#define TEGRA_VI_CFG_VGP5				0x074
+#define TEGRA_VI_CFG_VGP6				0x078
+#define TEGRA_VI_CFG_INTERRUPT_MASK			0x08c
+#define TEGRA_VI_CFG_INTERRUPT_TYPE_SELECT		0x090
+#define TEGRA_VI_CFG_INTERRUPT_POLARITY_SELECT		0x094
+#define TEGRA_VI_CFG_INTERRUPT_STATUS			0x098
+#define TEGRA_VI_CFG_VGP_SYNCPT_CONFIG			0x0ac
+#define TEGRA_VI_CFG_VI_SW_RESET			0x0b4
+#define TEGRA_VI_CFG_CG_CTRL				0x0b8
+#define   VI_CG_2ND_LEVEL_EN				0x1
+#define TEGRA_VI_CFG_VI_MCCIF_FIFOCTRL			0x0e4
+#define TEGRA_VI_CFG_TIMEOUT_WCOAL_VI			0x0e8
+#define TEGRA_VI_CFG_DVFS				0x0f0
+#define TEGRA_VI_CFG_RESERVE				0x0f4
+#define TEGRA_VI_CFG_RESERVE_1				0x0f8
+
+/* CSI registers */
+#define TEGRA_VI_CSI_BASE(x)				(0x100 + (x) * 0x100)
+
+#define TEGRA_VI_CSI_SW_RESET				0x000
+#define TEGRA_VI_CSI_SINGLE_SHOT			0x004
+#define   SINGLE_SHOT_CAPTURE				0x1
+#define TEGRA_VI_CSI_SINGLE_SHOT_STATE_UPDATE		0x008
+#define TEGRA_VI_CSI_IMAGE_DEF				0x00c
+#define   BYPASS_PXL_TRANSFORM_OFFSET			24
+#define   IMAGE_DEF_FORMAT_OFFSET			16
+#define   IMAGE_DEF_DEST_MEM				0x1
+#define TEGRA_VI_CSI_RGB2Y_CTRL				0x010
+#define TEGRA_VI_CSI_MEM_TILING				0x014
+#define TEGRA_VI_CSI_IMAGE_SIZE				0x018
+#define   IMAGE_SIZE_HEIGHT_OFFSET			16
+#define TEGRA_VI_CSI_IMAGE_SIZE_WC			0x01c
+#define TEGRA_VI_CSI_IMAGE_DT				0x020
+#define TEGRA_VI_CSI_SURFACE0_OFFSET_MSB		0x024
+#define TEGRA_VI_CSI_SURFACE0_OFFSET_LSB		0x028
+#define TEGRA_VI_CSI_SURFACE1_OFFSET_MSB		0x02c
+#define TEGRA_VI_CSI_SURFACE1_OFFSET_LSB		0x030
+#define TEGRA_VI_CSI_SURFACE2_OFFSET_MSB		0x034
+#define TEGRA_VI_CSI_SURFACE2_OFFSET_LSB		0x038
+#define TEGRA_VI_CSI_SURFACE0_BF_OFFSET_MSB		0x03c
+#define TEGRA_VI_CSI_SURFACE0_BF_OFFSET_LSB		0x040
+#define TEGRA_VI_CSI_SURFACE1_BF_OFFSET_MSB		0x044
+#define TEGRA_VI_CSI_SURFACE1_BF_OFFSET_LSB		0x048
+#define TEGRA_VI_CSI_SURFACE2_BF_OFFSET_MSB		0x04c
+#define TEGRA_VI_CSI_SURFACE2_BF_OFFSET_LSB		0x050
+#define TEGRA_VI_CSI_SURFACE0_STRIDE			0x054
+#define TEGRA_VI_CSI_SURFACE1_STRIDE			0x058
+#define TEGRA_VI_CSI_SURFACE2_STRIDE			0x05c
+#define TEGRA_VI_CSI_SURFACE_HEIGHT0			0x060
+#define TEGRA_VI_CSI_ISPINTF_CONFIG			0x064
+#define TEGRA_VI_CSI_ERROR_STATUS			0x084
+#define TEGRA_VI_CSI_ERROR_INT_MASK			0x088
+#define TEGRA_VI_CSI_WD_CTRL				0x08c
+#define TEGRA_VI_CSI_WD_PERIOD				0x090
+
+/* Channel registers */
+static void tegra_channel_write(struct tegra_channel *chan,
+				unsigned int addr, u32 val)
+{
+	writel(val, chan->vi->iomem + addr);
+}
+
+/* CSI registers */
+static void csi_write(struct tegra_channel *chan, unsigned int addr, u32 val)
+{
+	writel(val, chan->csi + addr);
+}
+
+static u32 csi_read(struct tegra_channel *chan, unsigned int addr)
+{
+	return readl(chan->csi + addr);
+}
+
+/* CSI channel IO Rail IDs */
+static const int tegra_io_rail_csi_ids[] = {
+	TEGRA_IO_RAIL_CSIA,
+	TEGRA_IO_RAIL_CSIB,
+	TEGRA_IO_RAIL_CSIC,
+	TEGRA_IO_RAIL_CSID,
+	TEGRA_IO_RAIL_CSIE,
+	TEGRA_IO_RAIL_CSIF,
+};
+
+void tegra_channel_fmts_bitmap_init(struct tegra_channel *chan,
+				    struct tegra_vi_graph_entity *entity)
+{
+	int ret, index;
+	struct v4l2_subdev *subdev = entity->subdev;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+
+	bitmap_zero(chan->fmts_bitmap, MAX_FORMAT_NUM);
+
+	while (1) {
+		ret = v4l2_subdev_call(subdev, pad, enum_mbus_code,
+				       NULL, &code);
+		if (ret < 0)
+			/* no more formats */
+			break;
+
+		index = tegra_core_get_idx_by_code(code.code);
+		if (index >= 0)
+			bitmap_set(chan->fmts_bitmap, index, 1);
+
+		code.index++;
+	}
+}
+
+/* -----------------------------------------------------------------------------
+ * Tegra channel frame setup and capture operations */
+
+static int tegra_channel_capture_setup(struct tegra_channel *chan)
+{
+	u32 height = chan->format.height;
+	u32 width = chan->format.width;
+	u32 format = chan->fmtinfo->img_fmt;
+	u32 data_type = chan->fmtinfo->img_dt;
+	u32 word_count = tegra_core_get_word_count(width, chan->fmtinfo);
+
+	csi_write(chan, TEGRA_VI_CSI_ERROR_STATUS, 0xFFFFFFFF);
+	csi_write(chan, TEGRA_VI_CSI_IMAGE_DEF,
+		  ((chan->vi->pg_mode ? 1 : 0) << BYPASS_PXL_TRANSFORM_OFFSET) |
+		  (format << IMAGE_DEF_FORMAT_OFFSET) |
+		  IMAGE_DEF_DEST_MEM);
+	csi_write(chan, TEGRA_VI_CSI_IMAGE_DT, data_type);
+	csi_write(chan, TEGRA_VI_CSI_IMAGE_SIZE_WC, word_count);
+	csi_write(chan, TEGRA_VI_CSI_IMAGE_SIZE,
+		  (height << IMAGE_SIZE_HEIGHT_OFFSET) | width);
+	return 0;
+}
+
+static void tegra_channel_capture_error(struct tegra_channel *chan)
+{
+	u32 val;
+
+	val = csi_read(chan, TEGRA_VI_CSI_ERROR_STATUS);
+	dev_err(&chan->video.dev, "TEGRA_VI_CSI_ERROR_STATUS 0x%08x\n", val);
+}
+
+static int tegra_channel_capture_frame(struct tegra_channel *chan,
+				       struct tegra_channel_buffer *buf)
+{
+	struct vb2_buffer *vb = &buf->buf;
+	int err = 0;
+	u32 thresh, value, frame_start;
+	int bytes_per_line = chan->format.bytesperline;
+
+	/* Program buffer address by using surface 0 */
+	csi_write(chan, TEGRA_VI_CSI_SURFACE0_OFFSET_MSB, 0x0);
+	csi_write(chan, TEGRA_VI_CSI_SURFACE0_OFFSET_LSB, buf->addr);
+	csi_write(chan, TEGRA_VI_CSI_SURFACE0_STRIDE, bytes_per_line);
+
+	/* Program syncpoint */
+	frame_start = VI_CSI_PP_FRAME_START(chan->port);
+	value = VI_CFG_VI_INCR_SYNCPT_COND(frame_start) |
+		host1x_syncpt_id(chan->sp);
+	tegra_channel_write(chan, TEGRA_VI_CFG_VI_INCR_SYNCPT, value);
+
+	csi_write(chan, TEGRA_VI_CSI_SINGLE_SHOT, SINGLE_SHOT_CAPTURE);
+
+	/* Use syncpoint to wake up */
+	thresh = host1x_syncpt_incr_max(chan->sp, 1);
+	err = host1x_syncpt_wait(chan->sp, thresh,
+				 TEGRA_VI_SYNCPT_WAIT_TIMEOUT, &value);
+	if (err) {
+		dev_err(&chan->video.dev, "frame start syncpt timeout!\n");
+		tegra_channel_capture_error(chan);
+	}
+
+	/* Captured one frame */
+	vb->v4l2_buf.sequence = chan->sequence++;
+	vb->v4l2_buf.field = V4L2_FIELD_NONE;
+	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
+	vb2_set_plane_payload(vb, 0, chan->format.sizeimage);
+	vb2_buffer_done(vb, err < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
+
+	return err;
+}
+
+static int tegra_channel_kthread_capture(void *data)
+{
+	struct tegra_channel *chan = data;
+	struct tegra_channel_buffer *buf;
+
+	set_freezable();
+
+	while (1) {
+		try_to_freeze();
+		wait_event_interruptible(chan->wait,
+					 !list_empty(&chan->capture) ||
+					 kthread_should_stop());
+		if (kthread_should_stop())
+			break;
+
+		spin_lock(&chan->queued_lock);
+		if (list_empty(&chan->capture)) {
+			spin_unlock(&chan->queued_lock);
+			continue;
+		}
+
+		buf = list_entry(chan->capture.next,
+				 struct tegra_channel_buffer, queue);
+		list_del_init(&buf->queue);
+		spin_unlock(&chan->queued_lock);
+
+		tegra_channel_capture_frame(chan, buf);
+	}
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * videobuf2 queue operations
+ */
+
+static int
+tegra_channel_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+			  unsigned int *nbuffers, unsigned int *nplanes,
+			  unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct tegra_channel *chan = vb2_get_drv_priv(vq);
+
+	/* Make sure the image size is large enough. */
+	if (fmt && fmt->fmt.pix.sizeimage < chan->format.sizeimage)
+		return -EINVAL;
+
+	*nplanes = 1;
+
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : chan->format.sizeimage;
+	alloc_ctxs[0] = chan->alloc_ctx;
+
+	return 0;
+}
+
+static int tegra_channel_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct tegra_channel *chan = vb2_get_drv_priv(vb->vb2_queue);
+	struct tegra_channel_buffer *buf = to_tegra_channel_buffer(vb);
+
+	buf->chan = chan;
+	buf->addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+	return 0;
+}
+
+static void tegra_channel_buffer_queue(struct vb2_buffer *vb)
+{
+	struct tegra_channel *chan = vb2_get_drv_priv(vb->vb2_queue);
+	struct tegra_channel_buffer *buf = to_tegra_channel_buffer(vb);
+
+	/* Put buffer into the capture queue */
+	spin_lock(&chan->queued_lock);
+	list_add_tail(&buf->queue, &chan->capture);
+	spin_unlock(&chan->queued_lock);
+
+	/* Wait up kthread for capture */
+	wake_up_interruptible(&chan->wait);
+}
+
+static int tegra_channel_set_stream(struct tegra_channel *chan, bool on)
+{
+	struct media_entity *entity;
+	struct media_pad *pad = &chan->pad;
+	struct v4l2_subdev *subdev;
+	int ret = 0;
+
+	entity = &chan->video.entity;
+
+	while (1) {
+		pad = media_entity_remote_pad(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		entity = pad->entity;
+		subdev = media_entity_to_v4l2_subdev(entity);
+		subdev->host_priv = chan;
+		ret = v4l2_subdev_call(subdev, video, s_stream, on);
+		if (on && ret < 0 && ret != -ENOIOCTLCMD)
+			return ret;
+	}
+	return ret;
+}
+
+/* Return all queued buffers back to videobuf2 */
+static void tegra_channel_queued_buf_done(struct tegra_channel *chan,
+					  enum vb2_buffer_state state)
+{
+	struct tegra_channel_buffer *buf, *nbuf;
+
+	spin_lock(&chan->queued_lock);
+	list_for_each_entry_safe(buf, nbuf, &chan->capture, queue) {
+		vb2_buffer_done(&buf->buf, state);
+		list_del(&buf->queue);
+	}
+	spin_unlock(&chan->queued_lock);
+}
+
+static int tegra_channel_start_streaming(struct vb2_queue *vq, u32 count)
+{
+	struct tegra_channel *chan = vb2_get_drv_priv(vq);
+	struct media_pipeline *pipe = chan->video.entity.pipe;
+	int ret = 0;
+
+	/* The first open then turn on power*/
+	if (atomic_add_return(1, &chan->vi->power_on_refcnt) == 1) {
+		tegra_vi_power_on(chan->vi);
+
+		usleep_range(5, 100);
+		tegra_channel_write(chan, TEGRA_VI_CFG_CG_CTRL,
+				    VI_CG_2ND_LEVEL_EN);
+		usleep_range(10, 15);
+	}
+
+	/* Disable DPD */
+	ret = tegra_io_rail_power_on(chan->io_id);
+	if (ret < 0) {
+		dev_err(&chan->video.dev,
+			"failed to power on CSI rail: %d\n", ret);
+		goto error_power_on;
+	}
+
+	/* Clean up status */
+	csi_write(chan, TEGRA_VI_CSI_ERROR_STATUS, 0xFFFFFFFF);
+
+	ret = media_entity_pipeline_start(&chan->video.entity, pipe);
+	if (ret < 0)
+		goto error_pipeline_start;
+
+	/* Start the pipeline. */
+	ret = tegra_channel_set_stream(chan, true);
+	if (ret < 0)
+		goto error_set_stream;
+
+	/* Note: Program VI registers after TPG, sensors and CSI streaming */
+	ret = tegra_channel_capture_setup(chan);
+	if (ret < 0)
+		goto error_capture_setup;
+
+	chan->sequence = 0;
+
+	/* Start kthread to capture data to buffer */
+	chan->kthread_capture = kthread_run(tegra_channel_kthread_capture, chan,
+					    chan->video.name);
+	if (!IS_ERR(chan->kthread_capture))
+		return 0;
+
+	dev_err(&chan->video.dev, "failed to start kthread for capture!\n");
+	ret = PTR_ERR(chan->kthread_capture);
+
+error_capture_setup:
+	tegra_channel_set_stream(chan, false);
+error_set_stream:
+	media_entity_pipeline_stop(&chan->video.entity);
+error_pipeline_start:
+	tegra_io_rail_power_off(chan->io_id);
+error_power_on:
+	tegra_channel_queued_buf_done(chan, VB2_BUF_STATE_QUEUED);
+	return ret;
+}
+
+static void tegra_channel_stop_streaming(struct vb2_queue *vq)
+{
+	struct tegra_channel *chan = vb2_get_drv_priv(vq);
+	u32 thresh, value, mw_ack_done;
+	int err;
+
+	/* Stop the kthread for capture */
+	kthread_stop(chan->kthread_capture);
+	chan->kthread_capture = NULL;
+
+	/* Program syncpoint */
+	mw_ack_done = VI_CSI_MW_ACK_DONE(chan->port);
+	value = VI_CFG_VI_INCR_SYNCPT_COND(mw_ack_done) |
+		host1x_syncpt_id(chan->sp);
+	tegra_channel_write(chan, TEGRA_VI_CFG_VI_INCR_SYNCPT, value);
+
+	/* Use syncpoint to wake up */
+	thresh = host1x_syncpt_incr_max(chan->sp, 1);
+	err = host1x_syncpt_wait(chan->sp, thresh,
+			TEGRA_VI_SYNCPT_WAIT_TIMEOUT, &value);
+	if (err)
+		dev_err(&chan->video.dev, "MW_ACK_DONE syncpoint time out!\n");
+
+	media_entity_pipeline_stop(&chan->video.entity);
+
+	tegra_channel_set_stream(chan, false);
+
+	tegra_io_rail_power_off(chan->io_id);
+
+	/* The last release then turn off power */
+	if (atomic_dec_and_test(&chan->vi->power_on_refcnt))
+		tegra_vi_power_off(chan->vi);
+
+	tegra_channel_queued_buf_done(chan, VB2_BUF_STATE_ERROR);
+}
+
+static const struct vb2_ops tegra_channel_queue_qops = {
+	.queue_setup = tegra_channel_queue_setup,
+	.buf_prepare = tegra_channel_buffer_prepare,
+	.buf_queue = tegra_channel_buffer_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.start_streaming = tegra_channel_start_streaming,
+	.stop_streaming = tegra_channel_stop_streaming,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 ioctls
+ */
+
+static int
+tegra_channel_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
+
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	strlcpy(cap->driver, "tegra-video", sizeof(cap->driver));
+	strlcpy(cap->card, chan->video.name, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s:%u",
+		 dev_name(chan->vi->dev), chan->port);
+
+	return 0;
+}
+
+static int
+tegra_channel_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *f)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
+	unsigned int index = 0, i;
+	unsigned long *fmts_bitmap = NULL;
+
+	if (chan->vi->pg_mode)
+		fmts_bitmap = chan->vi->tpg_fmts_bitmap;
+	else
+		fmts_bitmap = chan->fmts_bitmap;
+
+	if (f->index > bitmap_weight(fmts_bitmap, MAX_FORMAT_NUM) - 1)
+		return -EINVAL;
+
+	for (i = 0; i < f->index + 1; i++, index++)
+		index = find_next_bit(fmts_bitmap, MAX_FORMAT_NUM, index);
+
+	f->pixelformat = tegra_core_get_fourcc_by_idx(index - 1);
+
+	return 0;
+}
+
+static int tegra_channel_get_format(struct file *file, void *fh,
+				    struct v4l2_format *format)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
+
+	format->fmt.pix = chan->format;
+
+	return 0;
+}
+
+static void
+__tegra_channel_try_format(struct tegra_channel *chan,
+			   struct v4l2_pix_format *pix,
+			   const struct tegra_video_format **fmtinfo)
+{
+	const struct tegra_video_format *info;
+	unsigned int min_width;
+	unsigned int max_width;
+	unsigned int min_bpl;
+	unsigned int max_bpl;
+	unsigned int width;
+	unsigned int align;
+	unsigned int bpl;
+
+	/* Retrieve format information and select the default format if the
+	 * requested format isn't supported.
+	 */
+	info = tegra_core_get_format_by_fourcc(pix->pixelformat);
+	if (!info)
+		info = tegra_core_get_format_by_fourcc(TEGRA_VF_DEF);
+
+	pix->pixelformat = info->fourcc;
+	/* Change this when start adding interlace format support */
+	pix->field = V4L2_FIELD_NONE;
+
+	/* The transfer alignment requirements are expressed in bytes. Compute
+	 * the minimum and maximum values, clamp the requested width and convert
+	 * it back to pixels.
+	 */
+	align = lcm(chan->align, info->bpp);
+	min_width = roundup(TEGRA_MIN_WIDTH, align);
+	max_width = rounddown(TEGRA_MAX_WIDTH, align);
+	width = roundup(pix->width * info->bpp, align);
+
+	pix->width = clamp(width, min_width, max_width) / info->bpp;
+	pix->height = clamp(pix->height, TEGRA_MIN_HEIGHT, TEGRA_MAX_HEIGHT);
+
+	/* Clamp the requested bytes per line value. If the maximum bytes per
+	 * line value is zero, the module doesn't support user configurable line
+	 * sizes. Override the requested value with the minimum in that case.
+	 */
+	min_bpl = pix->width * info->bpp;
+	max_bpl = rounddown(TEGRA_MAX_WIDTH, chan->align);
+	bpl = roundup(pix->bytesperline, chan->align);
+
+	pix->bytesperline = clamp(bpl, min_bpl, max_bpl);
+	pix->sizeimage = pix->bytesperline * pix->height;
+	pix->colorspace = chan->format.colorspace;
+
+	if (fmtinfo)
+		*fmtinfo = info;
+}
+
+static int tegra_channel_try_format(struct file *file, void *fh,
+				    struct v4l2_format *format)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
+
+	__tegra_channel_try_format(chan, &format->fmt.pix, NULL);
+
+	return 0;
+}
+
+static int tegra_channel_set_format(struct file *file, void *fh,
+				    struct v4l2_format *format)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
+	const struct tegra_video_format *info;
+
+	if (vb2_is_busy(&chan->queue))
+		return -EBUSY;
+
+	__tegra_channel_try_format(chan, &format->fmt.pix, &info);
+
+	chan->format = format->fmt.pix;
+	chan->fmtinfo = info;
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops tegra_channel_ioctl_ops = {
+	.vidioc_querycap		= tegra_channel_querycap,
+	.vidioc_enum_fmt_vid_cap	= tegra_channel_enum_format,
+	.vidioc_g_fmt_vid_cap		= tegra_channel_get_format,
+	.vidioc_s_fmt_vid_cap		= tegra_channel_set_format,
+	.vidioc_try_fmt_vid_cap		= tegra_channel_try_format,
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 file operations
+ */
+
+static const struct v4l2_file_operations tegra_channel_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= video_ioctl2,
+	.open		= v4l2_fh_open,
+	.release	= vb2_fop_release,
+	.read		= vb2_fop_read,
+	.poll		= vb2_fop_poll,
+	.mmap		= vb2_fop_mmap,
+};
+
+int tegra_channel_init(struct tegra_vi *vi, unsigned int port)
+{
+	int ret;
+	struct tegra_channel *chan  = &vi->chans[port];
+
+	chan->vi = vi;
+	chan->port = port;
+
+	/* Init channel register base */
+	chan->csi = vi->iomem + TEGRA_VI_CSI_BASE(port);
+
+	/* VI Channel is 64 bytes alignment */
+	chan->align = 64;
+	chan->io_id = tegra_io_rail_csi_ids[chan->port];
+	mutex_init(&chan->video_lock);
+	INIT_LIST_HEAD(&chan->capture);
+	init_waitqueue_head(&chan->wait);
+	spin_lock_init(&chan->queued_lock);
+
+	/* Init video format */
+	chan->fmtinfo = tegra_core_get_format_by_fourcc(TEGRA_VF_DEF);
+	chan->format.pixelformat = chan->fmtinfo->fourcc;
+	chan->format.colorspace = V4L2_COLORSPACE_SRGB;
+	chan->format.field = V4L2_FIELD_NONE;
+	chan->format.width = TEGRA_DEF_WIDTH;
+	chan->format.height = TEGRA_DEF_HEIGHT;
+	chan->format.bytesperline = chan->format.width * chan->fmtinfo->bpp;
+	chan->format.sizeimage = chan->format.bytesperline *
+				    chan->format.height;
+
+	/* Initialize the media entity... */
+	chan->pad.flags = MEDIA_PAD_FL_SINK;
+
+	ret = media_entity_init(&chan->video.entity, 1, &chan->pad, 0);
+	if (ret < 0)
+		return ret;
+
+	/* ... and the video node... */
+	chan->video.fops = &tegra_channel_fops;
+	chan->video.v4l2_dev = &vi->v4l2_dev;
+	chan->video.queue = &chan->queue;
+	snprintf(chan->video.name, sizeof(chan->video.name), "%s-%s-%u",
+		 dev_name(vi->dev), "output", port);
+	chan->video.vfl_type = VFL_TYPE_GRABBER;
+	chan->video.vfl_dir = VFL_DIR_RX;
+	chan->video.release = video_device_release_empty;
+	chan->video.ioctl_ops = &tegra_channel_ioctl_ops;
+	chan->video.lock = &chan->video_lock;
+
+	video_set_drvdata(&chan->video, chan);
+
+	/* Init host1x interface */
+	INIT_LIST_HEAD(&chan->client.list);
+	chan->client.dev = chan->vi->dev;
+
+	ret = host1x_client_register(&chan->client);
+	if (ret < 0) {
+		dev_err(chan->vi->dev, "failed to register host1x client: %d\n",
+			ret);
+		ret = -ENODEV;
+		goto host1x_register_error;
+	}
+
+	chan->sp = host1x_syncpt_request(chan->client.dev,
+					 HOST1X_SYNCPT_HAS_BASE);
+	if (!chan->sp) {
+		dev_err(chan->vi->dev, "failed to request host1x syncpoint\n");
+		ret = -ENOMEM;
+		goto host1x_sp_error;
+	}
+
+	/* ... and the buffers queue... */
+	chan->alloc_ctx = vb2_dma_contig_init_ctx(&chan->video.dev);
+	if (IS_ERR(chan->alloc_ctx)) {
+		dev_err(chan->vi->dev, "failed to init vb2 buffer\n");
+		ret = -ENOMEM;
+		goto vb2_init_error;
+	}
+
+	chan->queue.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	chan->queue.io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
+	chan->queue.lock = &chan->video_lock;
+	chan->queue.drv_priv = chan;
+	chan->queue.buf_struct_size = sizeof(struct tegra_channel_buffer);
+	chan->queue.ops = &tegra_channel_queue_qops;
+	chan->queue.mem_ops = &vb2_dma_contig_memops;
+	chan->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
+				   | V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
+	ret = vb2_queue_init(&chan->queue);
+	if (ret < 0) {
+		dev_err(chan->vi->dev, "failed to initialize VB2 queue\n");
+		goto vb2_queue_error;
+	}
+
+	ret = video_register_device(&chan->video, VFL_TYPE_GRABBER, -1);
+	if (ret < 0) {
+		dev_err(&chan->video.dev, "failed to register video device\n");
+		goto video_register_error;
+	}
+
+	return 0;
+
+video_register_error:
+	vb2_queue_release(&chan->queue);
+vb2_queue_error:
+	vb2_dma_contig_cleanup_ctx(chan->alloc_ctx);
+vb2_init_error:
+	host1x_syncpt_free(chan->sp);
+host1x_sp_error:
+	host1x_client_unregister(&chan->client);
+host1x_register_error:
+	media_entity_cleanup(&chan->video.entity);
+	return ret;
+}
+
+int tegra_channel_cleanup(struct tegra_channel *chan)
+{
+	video_unregister_device(&chan->video);
+
+	vb2_queue_release(&chan->queue);
+	vb2_dma_contig_cleanup_ctx(chan->alloc_ctx);
+
+	host1x_syncpt_free(chan->sp);
+	host1x_client_unregister(&chan->client);
+
+	media_entity_cleanup(&chan->video.entity);
+
+	return 0;
+}
diff --git a/drivers/media/platform/tegra/tegra-core.c b/drivers/media/platform/tegra/tegra-core.c
new file mode 100644
index 0000000..450f78d
--- /dev/null
+++ b/drivers/media/platform/tegra/tegra-core.c
@@ -0,0 +1,254 @@
+/*
+ * NVIDIA Tegra Video Input Device Driver Core Helpers
+ *
+ * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Author: Bryan Wu <pengw@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include "tegra-core.h"
+
+const struct tegra_video_format tegra_video_formats[] = {
+	/* RAW 6: TODO */
+
+	/* RAW 7: TODO */
+
+	/* RAW 8 */
+	{
+		TEGRA_VF_RAW8,
+		8,
+		MEDIA_BUS_FMT_SRGGB8_1X8,
+		1,
+		TEGRA_IMAGE_FORMAT_T_L8,
+		TEGRA_IMAGE_DT_RAW8,
+		V4L2_PIX_FMT_SRGGB8,
+	},
+	{
+		TEGRA_VF_RAW8,
+		8,
+		MEDIA_BUS_FMT_SGRBG8_1X8,
+		1,
+		TEGRA_IMAGE_FORMAT_T_L8,
+		TEGRA_IMAGE_DT_RAW8,
+		V4L2_PIX_FMT_SGRBG8,
+	},
+	{
+		TEGRA_VF_RAW8,
+		8,
+		MEDIA_BUS_FMT_SGBRG8_1X8,
+		1,
+		TEGRA_IMAGE_FORMAT_T_L8,
+		TEGRA_IMAGE_DT_RAW8,
+		V4L2_PIX_FMT_SGBRG8,
+	},
+	{
+		TEGRA_VF_RAW8,
+		8,
+		MEDIA_BUS_FMT_SBGGR8_1X8,
+		1,
+		TEGRA_IMAGE_FORMAT_T_L8,
+		TEGRA_IMAGE_DT_RAW8,
+		V4L2_PIX_FMT_SBGGR8,
+	},
+
+	/* RAW 10 */
+	{
+		TEGRA_VF_RAW10,
+		10,
+		MEDIA_BUS_FMT_SRGGB10_1X10,
+		2,
+		TEGRA_IMAGE_FORMAT_T_R16_I,
+		TEGRA_IMAGE_DT_RAW10,
+		V4L2_PIX_FMT_SRGGB10,
+	},
+	{
+		TEGRA_VF_RAW10,
+		10,
+		MEDIA_BUS_FMT_SGRBG10_1X10,
+		2,
+		TEGRA_IMAGE_FORMAT_T_R16_I,
+		TEGRA_IMAGE_DT_RAW10,
+		V4L2_PIX_FMT_SGRBG10,
+	},
+	{
+		TEGRA_VF_RAW10,
+		10,
+		MEDIA_BUS_FMT_SGBRG10_1X10,
+		2,
+		TEGRA_IMAGE_FORMAT_T_R16_I,
+		TEGRA_IMAGE_DT_RAW10,
+		V4L2_PIX_FMT_SGBRG10,
+	},
+	{
+		TEGRA_VF_RAW10,
+		10,
+		MEDIA_BUS_FMT_SBGGR10_1X10,
+		2,
+		TEGRA_IMAGE_FORMAT_T_R16_I,
+		TEGRA_IMAGE_DT_RAW10,
+		V4L2_PIX_FMT_SBGGR10,
+	},
+
+	/* RAW 12 */
+	{
+		TEGRA_VF_RAW12,
+		12,
+		MEDIA_BUS_FMT_SRGGB12_1X12,
+		2,
+		TEGRA_IMAGE_FORMAT_T_R16_I,
+		TEGRA_IMAGE_DT_RAW12,
+		V4L2_PIX_FMT_SRGGB12,
+	},
+	{
+		TEGRA_VF_RAW12,
+		12,
+		MEDIA_BUS_FMT_SGRBG12_1X12,
+		2,
+		TEGRA_IMAGE_FORMAT_T_R16_I,
+		TEGRA_IMAGE_DT_RAW12,
+		V4L2_PIX_FMT_SGRBG12,
+	},
+	{
+		TEGRA_VF_RAW12,
+		12,
+		MEDIA_BUS_FMT_SGBRG12_1X12,
+		2,
+		TEGRA_IMAGE_FORMAT_T_R16_I,
+		TEGRA_IMAGE_DT_RAW12,
+		V4L2_PIX_FMT_SGBRG12,
+	},
+	{
+		TEGRA_VF_RAW12,
+		12,
+		MEDIA_BUS_FMT_SBGGR12_1X12,
+		2,
+		TEGRA_IMAGE_FORMAT_T_R16_I,
+		TEGRA_IMAGE_DT_RAW12,
+		V4L2_PIX_FMT_SBGGR12,
+	},
+
+	/* RGB888 */
+	{
+		TEGRA_VF_RGB888,
+		24,
+		MEDIA_BUS_FMT_RGB888_1X32_PADHI,
+		4,
+		TEGRA_IMAGE_FORMAT_T_A8B8G8R8,
+		TEGRA_IMAGE_DT_RGB888,
+		V4L2_PIX_FMT_RGB32,
+	},
+};
+
+/* -----------------------------------------------------------------------------
+ * Helper functions
+ */
+
+/**
+ * tegra_core_get_fourcc_by_idx - get fourcc of a tegra_video format
+ * @index: array index of the tegra_video_formats
+ *
+ * Return: fourcc code
+ */
+u32 tegra_core_get_fourcc_by_idx(unsigned int index)
+{
+	return tegra_video_formats[index].fourcc;
+}
+
+/**
+ * tegra_core_get_word_count - Calculate word count
+ * @frame_width: number of pixels per line
+ * @fmt: Tegra Video format struct which has BPP information
+ *
+ * Return: word count number
+ */
+u32 tegra_core_get_word_count(unsigned int frame_width,
+			      const struct tegra_video_format *fmt)
+{
+	return frame_width * fmt->width / 8;
+}
+
+/**
+ * tegra_core_get_idx_by_code - Retrieve index for a media bus code
+ * @code: the format media bus code
+ *
+ * Return: a index to the format information structure corresponding to the
+ * given V4L2 media bus format @code, or -1 if no corresponding format can
+ * be found.
+ */
+int tegra_core_get_idx_by_code(unsigned int code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(tegra_video_formats); ++i) {
+		if (tegra_video_formats[i].code == code)
+			return i;
+	}
+
+	return -1;
+}
+
+/**
+ * tegra_core_get_format_by_code - Retrieve format information for a media
+ * bus code
+ * @code: the format media bus code
+ *
+ * Return: a pointer to the format information structure corresponding to the
+ * given V4L2 media bus format @code, or NULL if no corresponding format can
+ * be found.
+ */
+const struct tegra_video_format *
+tegra_core_get_format_by_code(unsigned int code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(tegra_video_formats); ++i) {
+		if (tegra_video_formats[i].code == code)
+			return &tegra_video_formats[i];
+	}
+
+	return NULL;
+}
+
+/**
+ * tegra_core_get_format_by_fourcc - Retrieve format information for a 4CC
+ * @fourcc: the format 4CC
+ *
+ * Return: a pointer to the format information structure corresponding to the
+ * given V4L2 format @fourcc, or NULL if no corresponding format can be
+ * found.
+ */
+const struct tegra_video_format *tegra_core_get_format_by_fourcc(u32 fourcc)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(tegra_video_formats); ++i) {
+		if (tegra_video_formats[i].fourcc == fourcc)
+			return &tegra_video_formats[i];
+	}
+
+	return NULL;
+}
+
+/**
+ * tegra_core_bytes_per_line - Calculate bytes per line in one frame
+ * @width: frame width
+ * @align: number of alignment bytes
+ * @fmt: Tegra Video format
+ *
+ * Simply calcualte the bytes_per_line and if it's not aligned it
+ * will be padded to alignment boundary.
+ */
+u32 tegra_core_bytes_per_line(unsigned int width, unsigned int align,
+			      const struct tegra_video_format *fmt)
+{
+	return roundup(width * fmt->bpp, align);
+}
diff --git a/drivers/media/platform/tegra/tegra-core.h b/drivers/media/platform/tegra/tegra-core.h
new file mode 100644
index 0000000..834e195
--- /dev/null
+++ b/drivers/media/platform/tegra/tegra-core.h
@@ -0,0 +1,162 @@
+/*
+ * NVIDIA Tegra Video Input Device Driver Core Helpers
+ *
+ * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Author: Bryan Wu <pengw@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __TEGRA_CORE_H__
+#define __TEGRA_CORE_H__
+
+#include <media/v4l2-subdev.h>
+
+/* Minimum and maximum width and height common to Tegra video input device. */
+#define TEGRA_MIN_WIDTH		32U
+#define TEGRA_MAX_WIDTH		7680U
+#define TEGRA_MIN_HEIGHT	32U
+#define TEGRA_MAX_HEIGHT	7680U
+
+/* 1080p resolution as default resolution for test pattern generator */
+#define TEGRA_DEF_WIDTH		1920
+#define TEGRA_DEF_HEIGHT	1080
+
+#define TEGRA_VF_DEF		V4L2_PIX_FMT_RGB32
+
+/*
+ * These go into the TEGRA_VI_CSI_n_IMAGE_DEF registers bits 23:16
+ * Output pixel memory format for the VI channel.
+ */
+enum tegra_image_format {
+	TEGRA_IMAGE_FORMAT_T_L8 = 16,
+
+	TEGRA_IMAGE_FORMAT_T_R16_I = 32,
+	TEGRA_IMAGE_FORMAT_T_B5G6R5,
+	TEGRA_IMAGE_FORMAT_T_R5G6B5,
+	TEGRA_IMAGE_FORMAT_T_A1B5G5R5,
+	TEGRA_IMAGE_FORMAT_T_A1R5G5B5,
+	TEGRA_IMAGE_FORMAT_T_B5G5R5A1,
+	TEGRA_IMAGE_FORMAT_T_R5G5B5A1,
+	TEGRA_IMAGE_FORMAT_T_A4B4G4R4,
+	TEGRA_IMAGE_FORMAT_T_A4R4G4B4,
+	TEGRA_IMAGE_FORMAT_T_B4G4R4A4,
+	TEGRA_IMAGE_FORMAT_T_R4G4B4A4,
+
+	TEGRA_IMAGE_FORMAT_T_A8B8G8R8 = 64,
+	TEGRA_IMAGE_FORMAT_T_A8R8G8B8,
+	TEGRA_IMAGE_FORMAT_T_B8G8R8A8,
+	TEGRA_IMAGE_FORMAT_T_R8G8B8A8,
+	TEGRA_IMAGE_FORMAT_T_A2B10G10R10,
+	TEGRA_IMAGE_FORMAT_T_A2R10G10B10,
+	TEGRA_IMAGE_FORMAT_T_B10G10R10A2,
+	TEGRA_IMAGE_FORMAT_T_R10G10B10A2,
+
+	TEGRA_IMAGE_FORMAT_T_A8Y8U8V8 = 193,
+	TEGRA_IMAGE_FORMAT_T_V8U8Y8A8,
+
+	TEGRA_IMAGE_FORMAT_T_A2Y10U10V10 = 197,
+	TEGRA_IMAGE_FORMAT_T_V10U10Y10A2,
+	TEGRA_IMAGE_FORMAT_T_Y8_U8__Y8_V8,
+	TEGRA_IMAGE_FORMAT_T_Y8_V8__Y8_U8,
+	TEGRA_IMAGE_FORMAT_T_U8_Y8__V8_Y8,
+	TEGRA_IMAGE_FORMAT_T_T_V8_Y8__U8_Y8,
+
+	TEGRA_IMAGE_FORMAT_T_T_Y8__U8__V8_N444 = 224,
+	TEGRA_IMAGE_FORMAT_T_Y8__U8V8_N444,
+	TEGRA_IMAGE_FORMAT_T_Y8__V8U8_N444,
+	TEGRA_IMAGE_FORMAT_T_Y8__U8__V8_N422,
+	TEGRA_IMAGE_FORMAT_T_Y8__U8V8_N422,
+	TEGRA_IMAGE_FORMAT_T_Y8__V8U8_N422,
+	TEGRA_IMAGE_FORMAT_T_Y8__U8__V8_N420,
+	TEGRA_IMAGE_FORMAT_T_Y8__U8V8_N420,
+	TEGRA_IMAGE_FORMAT_T_Y8__V8U8_N420,
+	TEGRA_IMAGE_FORMAT_T_X2Lc10Lb10La10,
+	TEGRA_IMAGE_FORMAT_T_A2R6R6R6R6R6,
+};
+
+/*
+ * These go into the TEGRA_VI_CSI_n_CSI_IMAGE_DT registers bits 7:0
+ * Input data type of VI channel.
+ */
+enum tegra_image_dt {
+	TEGRA_IMAGE_DT_YUV420_8 = 24,
+	TEGRA_IMAGE_DT_YUV420_10,
+
+	TEGRA_IMAGE_DT_YUV420CSPS_8 = 28,
+	TEGRA_IMAGE_DT_YUV420CSPS_10,
+	TEGRA_IMAGE_DT_YUV422_8,
+	TEGRA_IMAGE_DT_YUV422_10,
+	TEGRA_IMAGE_DT_RGB444,
+	TEGRA_IMAGE_DT_RGB555,
+	TEGRA_IMAGE_DT_RGB565,
+	TEGRA_IMAGE_DT_RGB666,
+	TEGRA_IMAGE_DT_RGB888,
+
+	TEGRA_IMAGE_DT_RAW6 = 40,
+	TEGRA_IMAGE_DT_RAW7,
+	TEGRA_IMAGE_DT_RAW8,
+	TEGRA_IMAGE_DT_RAW10,
+	TEGRA_IMAGE_DT_RAW12,
+	TEGRA_IMAGE_DT_RAW14,
+};
+
+/* Supported CSI to VI Data Formats */
+enum tegra_vf_code {
+	TEGRA_VF_RAW6 = 0,
+	TEGRA_VF_RAW7,
+	TEGRA_VF_RAW8,
+	TEGRA_VF_RAW10,
+	TEGRA_VF_RAW12,
+	TEGRA_VF_RAW14,
+	TEGRA_VF_EMBEDDED8,
+	TEGRA_VF_RGB565,
+	TEGRA_VF_RGB555,
+	TEGRA_VF_RGB888,
+	TEGRA_VF_RGB444,
+	TEGRA_VF_RGB666,
+	TEGRA_VF_YUV422,
+	TEGRA_VF_YUV420,
+	TEGRA_VF_YUV420_CSPS,
+};
+
+/**
+ * struct tegra_video_format - Tegra video format description
+ * @vf_code: video format code
+ * @width: format width in bits per component
+ * @code: media bus format code
+ * @bpp: bytes per pixel (when stored in memory)
+ * @img_fmt: image format
+ * @img_dt: image data type
+ * @fourcc: V4L2 pixel format FCC identifier
+ * @description: format description, suitable for userspace
+ */
+struct tegra_video_format {
+	enum tegra_vf_code vf_code;
+	unsigned int width;
+	unsigned int code;
+	unsigned int bpp;
+	enum tegra_image_format img_fmt;
+	enum tegra_image_dt img_dt;
+	u32 fourcc;
+};
+
+u32 tegra_core_get_fourcc_by_idx(unsigned int index);
+u32 tegra_core_get_word_count(unsigned int frame_width,
+			      const struct tegra_video_format *fmt);
+int tegra_core_get_idx_by_code(unsigned int code);
+const struct tegra_video_format *tegra_core_get_format_by_code(unsigned int
+							       code);
+const struct tegra_video_format *tegra_core_get_format_by_fourcc(u32 fourcc);
+u32 tegra_core_bytes_per_line(unsigned int width, unsigned int align,
+			      const struct tegra_video_format *fmt);
+int tegra_core_enum_mbus_code(struct v4l2_subdev *subdev,
+			struct v4l2_subdev_pad_config *cfg,
+			struct v4l2_subdev_mbus_code_enum *code);
+int tegra_core_enum_frame_size(struct v4l2_subdev *subdev,
+			 struct v4l2_subdev_pad_config *cfg,
+			 struct v4l2_subdev_frame_size_enum *fse);
+#endif
diff --git a/drivers/media/platform/tegra/tegra-csi.c b/drivers/media/platform/tegra/tegra-csi.c
new file mode 100644
index 0000000..7b85c57
--- /dev/null
+++ b/drivers/media/platform/tegra/tegra-csi.c
@@ -0,0 +1,572 @@
+/*
+ * NVIDIA Tegra CSI Device
+ *
+ * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Author: Bryan Wu <pengw@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/gpio/consumer.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_graph.h>
+#include <linux/platform_device.h>
+
+#include <media/media-entity.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-ctrls.h>
+
+#include "tegra-vi.h"
+
+/* CSI Pixel Parser registers: Starts from 0x838, offset 0x0 */
+#define TEGRA_CSI_INPUT_STREAM_CONTROL                  0x000
+#define   CSI_SKIP_PACKET_THRESHOLD_OFFSET		16
+
+#define TEGRA_CSI_PIXEL_STREAM_CONTROL0                 0x004
+#define   CSI_PP_PACKET_HEADER_SENT			(0x1 << 4)
+#define   CSI_PP_DATA_IDENTIFIER_ENABLE			(0x1 << 5)
+#define   CSI_PP_WORD_COUNT_SELECT_HEADER		(0x1 << 6)
+#define   CSI_PP_CRC_CHECK_ENABLE			(0x1 << 7)
+#define   CSI_PP_WC_CHECK				(0x1 << 8)
+#define   CSI_PP_OUTPUT_FORMAT_STORE			(0x3 << 16)
+#define   CSI_PP_HEADER_EC_DISABLE			(0x1 << 27)
+#define   CSI_PPA_PAD_FRAME_NOPAD			(0x2 << 28)
+
+#define TEGRA_CSI_PIXEL_STREAM_CONTROL1                 0x008
+#define   CSI_PP_TOP_FIELD_FRAME_OFFSET			0
+#define   CSI_PP_TOP_FIELD_FRAME_MASK_OFFSET		4
+
+#define TEGRA_CSI_PIXEL_STREAM_GAP                      0x00c
+#define   PP_FRAME_MIN_GAP_OFFSET			16
+
+#define TEGRA_CSI_PIXEL_STREAM_PP_COMMAND               0x010
+#define   CSI_PP_ENABLE					0x1
+#define   CSI_PP_DISABLE				0x2
+#define   CSI_PP_RST					0x3
+#define   CSI_PP_SINGLE_SHOT_ENABLE			(0x1 << 2)
+#define   CSI_PP_START_MARKER_FRAME_MAX_OFFSET		12
+
+#define TEGRA_CSI_PIXEL_STREAM_EXPECTED_FRAME           0x014
+#define TEGRA_CSI_PIXEL_PARSER_INTERRUPT_MASK           0x018
+#define TEGRA_CSI_PIXEL_PARSER_STATUS                   0x01c
+#define TEGRA_CSI_CSI_SW_SENSOR_RESET                   0x020
+
+/* CSI PHY registers */
+#define TEGRA_CSI_PHY_CIL_COMMAND                       0x0d0
+#define   CSI_A_PHY_CIL_ENABLE				0x1
+#define   CSI_B_PHY_CIL_ENABLE				(0x1 << 8)
+
+/* CSI CIL registers: Starts from 0x92c, offset 0xF4 */
+#define TEGRA_CSI_CIL_OFFSET				0x0f4
+
+#define TEGRA_CSI_CIL_PAD_CONFIG0                       0x000
+#define   BRICK_CLOCK_A_4X				(0x1 << 16)
+#define   BRICK_CLOCK_B_4X				(0x2 << 16)
+#define TEGRA_CSI_CIL_PAD_CONFIG1                       0x004
+#define TEGRA_CSI_CIL_PHY_CONTROL                       0x008
+#define TEGRA_CSI_CIL_INTERRUPT_MASK                    0x00c
+#define TEGRA_CSI_CIL_STATUS                            0x010
+#define TEGRA_CSI_CILX_STATUS                           0x014
+#define TEGRA_CSI_CIL_ESCAPE_MODE_COMMAND               0x018
+#define TEGRA_CSI_CIL_ESCAPE_MODE_DATA                  0x01c
+#define TEGRA_CSI_CIL_SW_SENSOR_RESET                   0x020
+
+/* CSI Pattern Generator registers: Starts from 0x9c4, offset 0x18c */
+#define TEGRA_CSI_TPG_OFFSET				0x18c
+
+#define TEGRA_CSI_PATTERN_GENERATOR_CTRL		0x000
+#define   PG_MODE_OFFSET				2
+#define   PG_ENABLE					0x1
+
+#define TEGRA_CSI_PG_BLANK				0x004
+#define TEGRA_CSI_PG_PHASE				0x008
+#define TEGRA_CSI_PG_RED_FREQ				0x00c
+#define   PG_RED_VERT_INIT_FREQ_OFFSET			16
+#define   PG_RED_HOR_INIT_FREQ_OFFSET			0
+
+#define TEGRA_CSI_PG_RED_FREQ_RATE			0x010
+#define TEGRA_CSI_PG_GREEN_FREQ				0x014
+#define   PG_GREEN_VERT_INIT_FREQ_OFFSET		16
+#define   PG_GREEN_HOR_INIT_FREQ_OFFSET			0
+
+#define TEGRA_CSI_PG_GREEN_FREQ_RATE			0x018
+#define TEGRA_CSI_PG_BLUE_FREQ				0x01c
+#define   PG_BLUE_VERT_INIT_FREQ_OFFSET			16
+#define   PG_BLUE_HOR_INIT_FREQ_OFFSET			0
+
+#define TEGRA_CSI_PG_BLUE_FREQ_RATE			0x020
+#define TEGRA_CSI_PG_AOHDR				0x024
+
+#define TEGRA_CSI_DPCM_CTRL_A				0xa2c
+#define TEGRA_CSI_DPCM_CTRL_B				0xa30
+
+/* Other CSI registers: Starts from 0xa44, offset 0x20c */
+#define TEGRA_CSI_STALL_COUNTER				0x20c
+#define TEGRA_CSI_CSI_READONLY_STATUS			0x210
+#define TEGRA_CSI_CSI_SW_STATUS_RESET			0x214
+#define TEGRA_CSI_CLKEN_OVERRIDE			0x218
+#define TEGRA_CSI_DEBUG_CONTROL				0x21c
+#define TEGRA_CSI_DEBUG_COUNTER_0			0x220
+#define TEGRA_CSI_DEBUG_COUNTER_1			0x224
+#define TEGRA_CSI_DEBUG_COUNTER_2			0x228
+
+
+/* CSIA to CSIB register offset */
+#define TEGRA_CSI_PORT_OFFSET	0x34
+
+/* Each CSI has 2 ports, CSI_A and CSI_B */
+#define TEGRA_CSI_PORTS_NUM	2
+
+/* Each port has one source pad and one sink pad */
+#define TEGRA_CSI_PADS_NUM	4
+
+enum tegra_csi_port_num {
+	PORT_A = 0,
+	PORT_B = 1,
+};
+
+struct tegra_csi_port {
+	void __iomem *pixel_parser;
+	void __iomem *cil;
+	void __iomem *tpg;
+
+	/* One pair of sink/source pad has one format */
+	struct v4l2_mbus_framefmt format;
+	const struct tegra_video_format *core_format;
+	unsigned int lanes;
+
+	enum tegra_csi_port_num num;
+};
+
+struct tegra_csi_device {
+	struct v4l2_subdev subdev;
+	struct device *dev;
+	void __iomem *iomem;
+	struct clk *clk;
+
+	struct tegra_csi_port ports[TEGRA_CSI_PORTS_NUM];
+	struct media_pad pads[TEGRA_CSI_PADS_NUM];
+};
+
+static inline struct tegra_csi_device *to_csi(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct tegra_csi_device, subdev);
+}
+
+static void csi_write(struct tegra_csi_device *csi, unsigned int addr, u32 val)
+{
+	writel(val, csi->iomem + addr);
+}
+
+static u32 csi_read(struct tegra_csi_device *csi, unsigned int addr)
+{
+	return readl(csi->iomem + addr);
+}
+
+/* Pixel parser registers accessors */
+static void pp_write(struct tegra_csi_port *port, u32 addr, u32 val)
+{
+	writel(val, port->pixel_parser + addr);
+}
+
+static u32 pp_read(struct tegra_csi_port *port, u32 addr)
+{
+	return readl(port->pixel_parser + addr);
+}
+
+/* CSI CIL registers accessors */
+static void cil_write(struct tegra_csi_port *port, u32 addr, u32 val)
+{
+	writel(val, port->cil + addr);
+}
+
+static u32 cil_read(struct tegra_csi_port *port, u32 addr)
+{
+	return readl(port->cil + addr);
+}
+
+/* Test pattern generator registers accessor */
+static void tpg_write(struct tegra_csi_port *port, unsigned int addr, u32 val)
+{
+	writel(val, port->tpg + addr);
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Video Operations
+ */
+
+static int tegra_csi_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	struct tegra_csi_device *csi = to_csi(subdev);
+	struct tegra_channel *chan = subdev->host_priv;
+	enum tegra_csi_port_num port_num = (chan->port & 1) ? PORT_B : PORT_A;
+	struct tegra_csi_port *port = &csi->ports[port_num];
+	int ret;
+
+	if (enable) {
+		/* Start CIL clock */
+		ret = clk_set_rate(csi->clk, 102000000);
+		if (ret)
+			dev_err(csi->dev, "failed to set cil clk rate!\n");
+
+		ret = clk_prepare_enable(csi->clk);
+		if (ret) {
+			dev_err(csi->dev, "failed to enable cil clk!\n");
+			return ret;
+		}
+
+		csi_write(csi, TEGRA_CSI_CLKEN_OVERRIDE, 0);
+
+		/* Clean up status */
+		pp_write(port, TEGRA_CSI_PIXEL_PARSER_STATUS, 0xFFFFFFFF);
+		cil_write(port, TEGRA_CSI_CIL_STATUS, 0xFFFFFFFF);
+		cil_write(port, TEGRA_CSI_CILX_STATUS, 0xFFFFFFFF);
+
+		cil_write(port, TEGRA_CSI_CIL_INTERRUPT_MASK, 0x0);
+
+		/* CIL PHY registers setup */
+		cil_write(port, TEGRA_CSI_CIL_PAD_CONFIG0, 0x0);
+		cil_write(port, TEGRA_CSI_CIL_PHY_CONTROL, 0xA);
+
+		/*
+		 * The CSI unit provides for connection of up to six cameras in
+		 * the system and is organized as three identical instances of
+		 * two MIPI support blocks, each with a separate 4-lane
+		 * interface that can be configured as a single camera with 4
+		 * lanes or as a dual camera with 2 lanes available for each
+		 * camera.
+		 */
+		if (port->lanes == 4) {
+			struct tegra_csi_port *port_a = &csi->ports[PORT_A];
+			struct tegra_csi_port *port_b = &csi->ports[PORT_B];
+
+			cil_write(port_a, TEGRA_CSI_CIL_PAD_CONFIG0,
+				  BRICK_CLOCK_A_4X);
+			cil_write(port_b, TEGRA_CSI_CIL_INTERRUPT_MASK, 0x0);
+			cil_write(port_a, TEGRA_CSI_CIL_PHY_CONTROL, 0xA);
+			cil_write(port_b, TEGRA_CSI_CIL_PHY_CONTROL, 0xA);
+			csi_write(csi, TEGRA_CSI_PHY_CIL_COMMAND,
+				  CSI_A_PHY_CIL_ENABLE | CSI_B_PHY_CIL_ENABLE);
+		} else {
+			u32 val = csi_read(csi, TEGRA_CSI_PHY_CIL_COMMAND);
+
+			val |= (port->num == PORT_A) ? CSI_A_PHY_CIL_ENABLE :
+				CSI_B_PHY_CIL_ENABLE;
+			csi_write(csi, TEGRA_CSI_PHY_CIL_COMMAND, val);
+		}
+
+		/* CSI pixel parser registers setup */
+		pp_write(port, TEGRA_CSI_PIXEL_STREAM_PP_COMMAND,
+			 (0xF << CSI_PP_START_MARKER_FRAME_MAX_OFFSET) |
+			 CSI_PP_SINGLE_SHOT_ENABLE | CSI_PP_RST);
+		pp_write(port, TEGRA_CSI_PIXEL_PARSER_INTERRUPT_MASK, 0x0);
+		pp_write(port, TEGRA_CSI_PIXEL_STREAM_CONTROL0,
+			 CSI_PP_PACKET_HEADER_SENT |
+			 CSI_PP_DATA_IDENTIFIER_ENABLE |
+			 CSI_PP_WORD_COUNT_SELECT_HEADER |
+			 CSI_PP_CRC_CHECK_ENABLE |  CSI_PP_WC_CHECK |
+			 CSI_PP_OUTPUT_FORMAT_STORE |
+			 CSI_PP_HEADER_EC_DISABLE | CSI_PPA_PAD_FRAME_NOPAD |
+			 (port->num & 1));
+		pp_write(port, TEGRA_CSI_PIXEL_STREAM_CONTROL1,
+			 (0x1 << CSI_PP_TOP_FIELD_FRAME_OFFSET) |
+			 (0x1 << CSI_PP_TOP_FIELD_FRAME_MASK_OFFSET));
+		pp_write(port, TEGRA_CSI_PIXEL_STREAM_GAP,
+			 0x14 << PP_FRAME_MIN_GAP_OFFSET);
+		pp_write(port, TEGRA_CSI_PIXEL_STREAM_EXPECTED_FRAME, 0x0);
+		pp_write(port, TEGRA_CSI_INPUT_STREAM_CONTROL,
+			 (0x3f << CSI_SKIP_PACKET_THRESHOLD_OFFSET) |
+			 (port->lanes - 1));
+
+		/* Test Pattern Generator setup */
+		if (chan->vi->pg_mode) {
+			tpg_write(port, TEGRA_CSI_PATTERN_GENERATOR_CTRL,
+				  ((chan->vi->pg_mode - 1) << PG_MODE_OFFSET) |
+				  PG_ENABLE);
+			tpg_write(port, TEGRA_CSI_PG_PHASE, 0x0);
+			tpg_write(port, TEGRA_CSI_PG_RED_FREQ,
+				  (0x10 << PG_RED_VERT_INIT_FREQ_OFFSET) |
+				  (0x10 << PG_RED_HOR_INIT_FREQ_OFFSET));
+			tpg_write(port, TEGRA_CSI_PG_RED_FREQ_RATE, 0x0);
+			tpg_write(port, TEGRA_CSI_PG_GREEN_FREQ,
+				  (0x10 << PG_GREEN_VERT_INIT_FREQ_OFFSET) |
+				  (0x10 << PG_GREEN_HOR_INIT_FREQ_OFFSET));
+			tpg_write(port, TEGRA_CSI_PG_GREEN_FREQ_RATE, 0x0);
+			tpg_write(port, TEGRA_CSI_PG_BLUE_FREQ,
+				  (0x10 << PG_BLUE_VERT_INIT_FREQ_OFFSET) |
+				  (0x10 << PG_BLUE_HOR_INIT_FREQ_OFFSET));
+			tpg_write(port, TEGRA_CSI_PG_BLUE_FREQ_RATE, 0x0);
+		}
+
+		pp_write(port, TEGRA_CSI_PIXEL_STREAM_PP_COMMAND,
+			 (0xF << CSI_PP_START_MARKER_FRAME_MAX_OFFSET) |
+			 CSI_PP_SINGLE_SHOT_ENABLE | CSI_PP_ENABLE);
+	} else {
+		u32 val = pp_read(port, TEGRA_CSI_PIXEL_PARSER_STATUS);
+
+		dev_dbg(csi->dev, "TEGRA_CSI_PIXEL_PARSER_STATUS 0x%08x\n",
+			val);
+
+		val = cil_read(port, TEGRA_CSI_CIL_STATUS);
+		dev_dbg(csi->dev, "TEGRA_CSI_CIL_STATUS 0x%08x\n", val);
+
+		val = cil_read(port, TEGRA_CSI_CILX_STATUS);
+		dev_dbg(csi->dev, "TEGRA_CSI_CILX_STATUS 0x%08x\n", val);
+
+#ifdef DEBUG
+		val = csi_read(csi, TEGRA_CSI_DEBUG_COUNTER_0);
+		dev_err(&csi->dev, "TEGRA_CSI_DEBUG_COUNTER_0 0x%08x\n", val);
+#endif
+
+		pp_write(port, TEGRA_CSI_PIXEL_STREAM_PP_COMMAND,
+			 (0xF << CSI_PP_START_MARKER_FRAME_MAX_OFFSET) |
+			 CSI_PP_DISABLE);
+
+		clk_disable_unprepare(csi->clk);
+	}
+
+	return 0;
+}
+
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Pad Operations
+ */
+
+static struct v4l2_mbus_framefmt *
+__tegra_csi_get_pad_format(struct tegra_csi_device *csi,
+			   struct v4l2_subdev_pad_config *cfg,
+			   unsigned int pad, u32 which)
+{
+	enum tegra_csi_port_num port_num = pad < 2 ? PORT_A : PORT_B;
+
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_format(&csi->subdev, cfg, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &csi->ports[port_num].format;
+	default:
+		return NULL;
+	}
+}
+
+static int tegra_csi_get_format(struct v4l2_subdev *subdev,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_format *fmt)
+{
+	struct tegra_csi_device *csi = to_csi(subdev);
+
+	fmt->format = *__tegra_csi_get_pad_format(csi, cfg,
+						  fmt->pad, fmt->which);
+	return 0;
+}
+
+static int tegra_csi_set_format(struct v4l2_subdev *subdev,
+			   struct v4l2_subdev_pad_config *cfg,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct tegra_csi_device *csi = to_csi(subdev);
+	struct v4l2_mbus_framefmt *__format;
+	enum tegra_csi_port_num port_num = fmt->pad < 2 ? PORT_A : PORT_B;
+
+	__format = __tegra_csi_get_pad_format(csi, cfg, fmt->pad, fmt->which);
+	if (__format)
+		csi->ports[port_num].format = *__format;
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Operations
+ */
+static struct v4l2_subdev_video_ops tegra_csi_video_ops = {
+	.s_stream = tegra_csi_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops tegra_csi_pad_ops = {
+	.get_fmt		= tegra_csi_get_format,
+	.set_fmt		= tegra_csi_set_format,
+};
+
+static struct v4l2_subdev_ops tegra_csi_ops = {
+	.video  = &tegra_csi_video_ops,
+	.pad    = &tegra_csi_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * Media Operations
+ */
+
+static const struct media_entity_operations tegra_csi_media_ops = {
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+/* -----------------------------------------------------------------------------
+ * Platform Device Driver
+ */
+
+static int tegra_csi_parse_of(struct tegra_csi_device *csi)
+{
+	struct device_node *node = csi->dev->of_node;
+	struct device_node *ports;
+	struct device_node *port;
+	struct device_node *ep;
+	unsigned int lanes, num, id, pad_num;
+	int ret;
+
+	ports = of_get_child_by_name(node, "ports");
+	if (ports == NULL)
+		ports = node;
+
+	for_each_child_of_node(ports, port) {
+		if (!port->name || of_node_cmp(port->name, "port"))
+			continue;
+
+		ret = of_property_read_u32(port, "reg", &num);
+		if (ret < 0)
+			continue;
+		csi->ports[num].num = num;
+
+		for_each_child_of_node(port, ep) {
+			if (!ep->name || of_node_cmp(ep->name, "endpoint"))
+				continue;
+
+			/* Get endpoint id in current port */
+			ret = of_property_read_u32(ep, "reg", &id);
+			if (ret < 0)
+				continue;
+
+			/*
+			 * Initialize V4L2 subdevice and media entity.
+			 * Pad numbers depend on the ID of endpoint.
+			 */
+			pad_num = (num & 1) * 2 + id;
+			csi->pads[pad_num].flags = id ? MEDIA_PAD_FL_SOURCE :
+						   MEDIA_PAD_FL_SINK;
+
+			/* Get number of data lanes for the first endpoint */
+			if (id == 0) {
+				ret = of_property_read_u32(ep, "bus-width",
+							   &lanes);
+				if (ret < 0)
+					lanes = 4;
+				csi->ports[num].lanes = lanes;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int tegra_csi_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct v4l2_subdev *subdev;
+	struct tegra_csi_device *csi;
+	int ret, i;
+
+	csi = devm_kzalloc(&pdev->dev, sizeof(*csi), GFP_KERNEL);
+	if (!csi)
+		return -ENOMEM;
+
+	csi->dev = &pdev->dev;
+
+	ret = tegra_csi_parse_of(csi);
+	if (ret < 0)
+		return ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	csi->iomem = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(csi->iomem))
+		return PTR_ERR(csi->iomem);
+
+	csi->clk = devm_clk_get(&pdev->dev, "cil");
+	if (IS_ERR(csi->clk)) {
+		dev_err(&pdev->dev, "Failed to get cil clock\n");
+		return PTR_ERR(csi->clk);
+	}
+
+	/* Initialize V4L2 subdevice and media entity */
+	subdev = &csi->subdev;
+	v4l2_subdev_init(subdev, &tegra_csi_ops);
+	subdev->dev = &pdev->dev;
+	strlcpy(subdev->name, dev_name(&pdev->dev), sizeof(subdev->name));
+	v4l2_set_subdevdata(subdev, csi);
+	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	subdev->entity.ops = &tegra_csi_media_ops;
+
+	for (i = 0; i < TEGRA_CSI_PORTS_NUM; i++) {
+		/* Initialize the default format */
+		csi->ports[i].format.code = TEGRA_VF_DEF;
+		csi->ports[i].format.field = V4L2_FIELD_NONE;
+		csi->ports[i].format.colorspace = V4L2_COLORSPACE_SRGB;
+		csi->ports[i].format.width = TEGRA_DEF_WIDTH;
+		csi->ports[i].format.height = TEGRA_DEF_HEIGHT;
+
+		/* Initialize port register bases */
+		csi->ports[i].pixel_parser = csi->iomem +
+			(i & 1) * TEGRA_CSI_PORT_OFFSET;
+		csi->ports[i].cil = csi->iomem + TEGRA_CSI_CIL_OFFSET +
+			(i & 1) * TEGRA_CSI_PORT_OFFSET;
+		csi->ports[i].tpg = csi->iomem + TEGRA_CSI_TPG_OFFSET +
+			(i & 1) * TEGRA_CSI_PORT_OFFSET;
+
+		csi->ports[i].num = i;
+	}
+
+	/* Initialize media entity */
+	ret = media_entity_init(&subdev->entity, ARRAY_SIZE(csi->pads),
+			csi->pads, 0);
+	if (ret < 0)
+		return ret;
+
+	platform_set_drvdata(pdev, csi);
+
+	ret = v4l2_async_register_subdev(subdev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to register subdev\n");
+		goto error;
+	}
+
+	return 0;
+
+error:
+	media_entity_cleanup(&subdev->entity);
+	return ret;
+}
+
+static int tegra_csi_remove(struct platform_device *pdev)
+{
+	struct tegra_csi_device *csi = platform_get_drvdata(pdev);
+	struct v4l2_subdev *subdev = &csi->subdev;
+
+	v4l2_async_unregister_subdev(subdev);
+	media_entity_cleanup(&subdev->entity);
+	return 0;
+}
+
+static const struct of_device_id tegra_csi_of_id_table[] = {
+	{ .compatible = "nvidia,tegra210-csi" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, tegra_csi_of_id_table);
+
+static struct platform_driver tegra_csi_driver = {
+	.driver = {
+		.name		= "tegra-csi",
+		.of_match_table	= tegra_csi_of_id_table,
+	},
+	.probe			= tegra_csi_probe,
+	.remove			= tegra_csi_remove,
+};
+module_platform_driver(tegra_csi_driver);
+
+MODULE_AUTHOR("Bryan Wu <pengw@nvidia.com>");
+MODULE_DESCRIPTION("NVIDIA Tegra CSI Device Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/tegra/tegra-vi.c b/drivers/media/platform/tegra/tegra-vi.c
new file mode 100644
index 0000000..4d66124
--- /dev/null
+++ b/drivers/media/platform/tegra/tegra-vi.c
@@ -0,0 +1,583 @@
+/*
+ * NVIDIA Tegra Video Input Device
+ *
+ * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Author: Bryan Wu <pengw@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_graph.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/reset.h>
+#include <linux/slab.h>
+
+#include <media/media-device.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
+
+#include <soc/tegra/pmc.h>
+
+#include "tegra-vi.h"
+
+/* In TPG mode, VI only support 2 formats */
+static void vi_tpg_fmts_bitmap_init(struct tegra_vi *vi)
+{
+	int index;
+
+	bitmap_zero(vi->tpg_fmts_bitmap, MAX_FORMAT_NUM);
+
+	index = tegra_core_get_idx_by_code(MEDIA_BUS_FMT_SRGGB10_1X10);
+	bitmap_set(vi->tpg_fmts_bitmap, index, 1);
+
+	index = tegra_core_get_idx_by_code(MEDIA_BUS_FMT_RGB888_1X32_PADHI);
+	bitmap_set(vi->tpg_fmts_bitmap, index, 1);
+}
+
+/*
+ * Control Config
+ */
+
+static const char *const vi_pattern_strings[] = {
+	"Disabled",
+	"Black/White Direct Mode",
+	"Color Patch Mode",
+};
+
+static int vi_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct tegra_vi *vi = container_of(ctrl->handler, struct tegra_vi,
+					   ctrl_handler);
+	switch (ctrl->id) {
+	case V4L2_CID_TEST_PATTERN:
+		vi->pg_mode = ctrl->val;
+		break;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops vi_ctrl_ops = {
+	.s_ctrl	= vi_s_ctrl,
+};
+
+/* -----------------------------------------------------------------------------
+ * Media Controller and V4L2
+ */
+
+static void tegra_vi_v4l2_cleanup(struct tegra_vi *vi)
+{
+	v4l2_ctrl_handler_free(&vi->ctrl_handler);
+	v4l2_device_unregister(&vi->v4l2_dev);
+	media_device_unregister(&vi->media_dev);
+}
+
+static int tegra_vi_v4l2_init(struct tegra_vi *vi)
+{
+	int ret;
+
+	vi->media_dev.dev = vi->dev;
+	strlcpy(vi->media_dev.model, "NVIDIA Tegra Video Input Device",
+		sizeof(vi->media_dev.model));
+	vi->media_dev.hw_revision = 3;
+
+	ret = media_device_register(&vi->media_dev);
+	if (ret < 0) {
+		dev_err(vi->dev, "media device registration failed (%d)\n",
+			ret);
+		return ret;
+	}
+
+	vi->v4l2_dev.mdev = &vi->media_dev;
+	ret = v4l2_device_register(vi->dev, &vi->v4l2_dev);
+	if (ret < 0) {
+		dev_err(vi->dev, "V4L2 device registration failed (%d)\n",
+			ret);
+		goto register_error;
+	}
+
+	v4l2_ctrl_handler_init(&vi->ctrl_handler, 1);
+	vi->pattern = v4l2_ctrl_new_std_menu_items(&vi->ctrl_handler,
+					&vi_ctrl_ops, V4L2_CID_TEST_PATTERN,
+					ARRAY_SIZE(vi_pattern_strings) - 1,
+					0, 0, vi_pattern_strings);
+
+	if (vi->ctrl_handler.error) {
+		dev_err(vi->dev, "failed to add controls\n");
+		ret = vi->ctrl_handler.error;
+		goto ctrl_error;
+	}
+	vi->v4l2_dev.ctrl_handler = &vi->ctrl_handler;
+
+	ret = v4l2_ctrl_handler_setup(&vi->ctrl_handler);
+	if (ret < 0) {
+		dev_err(vi->dev, "failed to set controls\n");
+		goto ctrl_error;
+	}
+	return 0;
+
+
+ctrl_error:
+	v4l2_ctrl_handler_free(&vi->ctrl_handler);
+	v4l2_device_unregister(&vi->v4l2_dev);
+register_error:
+	media_device_unregister(&vi->media_dev);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * Platform Device Driver
+ */
+
+int tegra_vi_power_on(struct tegra_vi *vi)
+{
+	int ret;
+
+	ret = regulator_enable(vi->vi_reg);
+	if (ret)
+		return ret;
+
+	ret = tegra_powergate_sequence_power_up(TEGRA_POWERGATE_VENC,
+						vi->vi_clk, vi->vi_rst);
+	if (ret) {
+		dev_err(vi->dev, "failed to power up!\n");
+		goto error_power_up;
+	}
+
+	ret = clk_set_rate(vi->vi_clk, 408000000);
+	if (ret) {
+		dev_err(vi->dev, "failed to set vi clock to 408MHz!\n");
+		goto error_clk_set_rate;
+	}
+
+	clk_prepare_enable(vi->csi_clk);
+
+	return 0;
+
+error_clk_set_rate:
+	tegra_powergate_power_off(TEGRA_POWERGATE_VENC);
+error_power_up:
+	regulator_disable(vi->vi_reg);
+	return ret;
+}
+
+void tegra_vi_power_off(struct tegra_vi *vi)
+{
+	reset_control_assert(vi->vi_rst);
+	clk_disable_unprepare(vi->vi_clk);
+	clk_disable_unprepare(vi->csi_clk);
+	tegra_powergate_power_off(TEGRA_POWERGATE_VENC);
+	regulator_disable(vi->vi_reg);
+}
+
+static int tegra_vi_channels_init(struct tegra_vi *vi)
+{
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(vi->chans); i++) {
+		ret = tegra_channel_init(vi, i);
+		if (ret < 0) {
+			dev_err(vi->dev, "channel %d init failed\n", i);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int tegra_vi_channels_cleanup(struct tegra_vi *vi)
+{
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(vi->chans); i++) {
+		ret = tegra_channel_cleanup(&vi->chans[i]);
+		if (ret < 0) {
+			dev_err(vi->dev, "channel %d cleanup failed\n", i);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * Graph Management
+ */
+
+static struct tegra_vi_graph_entity *
+tegra_vi_graph_find_entity(struct tegra_vi *vi,
+		       const struct device_node *node)
+{
+	struct tegra_vi_graph_entity *entity;
+
+	list_for_each_entry(entity, &vi->entities, list) {
+		if (entity->node == node)
+			return entity;
+	}
+
+	return NULL;
+}
+
+static int tegra_vi_graph_build_links(struct tegra_vi *vi)
+{
+	u32 link_flags = MEDIA_LNK_FL_ENABLED;
+	struct device_node *node = vi->dev->of_node;
+	struct media_entity *source;
+	struct media_entity *sink;
+	struct media_pad *source_pad;
+	struct media_pad *sink_pad;
+	struct tegra_vi_graph_entity *ent;
+	struct v4l2_of_link link;
+	struct device_node *ep = NULL;
+	struct device_node *next;
+	struct tegra_channel *chan;
+	int ret = 0;
+
+	dev_dbg(vi->dev, "creating links for channels\n");
+
+	while (1) {
+		/* Get the next endpoint and parse its link. */
+		next = of_graph_get_next_endpoint(node, ep);
+		if (next == NULL)
+			break;
+
+		of_node_put(ep);
+		ep = next;
+
+		dev_dbg(vi->dev, "processing endpoint %s\n", ep->full_name);
+
+		ret = v4l2_of_parse_link(ep, &link);
+		if (ret < 0) {
+			dev_err(vi->dev, "failed to parse link for %s\n",
+				ep->full_name);
+			continue;
+		}
+
+		if (link.local_port > MAX_CHAN_NUM) {
+			dev_err(vi->dev, "wrong channel number for port %u\n",
+				link.local_port);
+			v4l2_of_put_link(&link);
+			ret = -EINVAL;
+			break;
+		}
+
+		chan = &vi->chans[link.local_port];
+
+		dev_dbg(vi->dev, "creating link for channel %s\n",
+			chan->video.name);
+
+		/* Find the remote entity. */
+		ent = tegra_vi_graph_find_entity(vi, link.remote_node);
+		if (ent == NULL) {
+			dev_err(vi->dev, "no entity found for %s\n",
+				link.remote_node->full_name);
+			v4l2_of_put_link(&link);
+			ret = -ENODEV;
+			break;
+		}
+
+		source = ent->entity;
+		source_pad = &source->pads[(link.remote_port & 1) * 2 + 1];
+		sink = &chan->video.entity;
+		sink_pad = &chan->pad;
+
+		v4l2_of_put_link(&link);
+
+		/* Create the media link. */
+		dev_dbg(vi->dev, "creating %s:%u -> %s:%u link\n",
+			source->name, source_pad->index,
+			sink->name, sink_pad->index);
+
+		ret = media_entity_create_link(source, source_pad->index,
+					       sink, sink_pad->index,
+					       link_flags);
+		if (ret < 0) {
+			dev_err(vi->dev,
+				"failed to create %s:%u -> %s:%u link\n",
+				source->name, source_pad->index,
+				sink->name, sink_pad->index);
+			break;
+		}
+
+		tegra_channel_fmts_bitmap_init(chan, ent);
+	}
+
+	of_node_put(ep);
+	return ret;
+}
+
+static int tegra_vi_graph_notify_complete(struct v4l2_async_notifier *notifier)
+{
+	struct tegra_vi *vi =
+		container_of(notifier, struct tegra_vi, notifier);
+	int ret;
+
+	dev_dbg(vi->dev, "notify complete, all subdevs registered\n");
+
+	/* Create links for every entity. */
+	ret = tegra_vi_graph_build_links(vi);
+	if (ret < 0)
+		return ret;
+
+	ret = v4l2_device_register_subdev_nodes(&vi->v4l2_dev);
+	if (ret < 0)
+		dev_err(vi->dev, "failed to register subdev nodes\n");
+
+	return ret;
+}
+
+static int tegra_vi_graph_notify_bound(struct v4l2_async_notifier *notifier,
+				   struct v4l2_subdev *subdev,
+				   struct v4l2_async_subdev *asd)
+{
+	struct tegra_vi *vi = container_of(notifier, struct tegra_vi, notifier);
+	struct tegra_vi_graph_entity *entity;
+
+	/* Locate the entity corresponding to the bound subdev and store the
+	 * subdev pointer.
+	 */
+	list_for_each_entry(entity, &vi->entities, list) {
+		if (entity->node != subdev->dev->of_node)
+			continue;
+
+		if (entity->subdev) {
+			dev_err(vi->dev, "duplicate subdev for node %s\n",
+				entity->node->full_name);
+			return -EINVAL;
+		}
+
+		dev_dbg(vi->dev, "subdev %s bound\n", subdev->name);
+		entity->entity = &subdev->entity;
+		entity->subdev = subdev;
+		return 0;
+	}
+
+	dev_err(vi->dev, "no entity for subdev %s\n", subdev->name);
+	return -EINVAL;
+}
+
+static void tegra_vi_graph_cleanup(struct tegra_vi *vi)
+{
+	struct tegra_vi_graph_entity *entityp;
+	struct tegra_vi_graph_entity *entity;
+
+	v4l2_async_notifier_unregister(&vi->notifier);
+
+	list_for_each_entry_safe(entity, entityp, &vi->entities, list) {
+		of_node_put(entity->node);
+		list_del(&entity->list);
+	}
+}
+
+static int tegra_vi_graph_init(struct tegra_vi *vi)
+{
+	struct device_node *node = vi->dev->of_node;
+	struct device_node *ep = NULL;
+	struct device_node *next;
+	struct device_node *remote = NULL;
+	struct tegra_vi_graph_entity *entity;
+	struct v4l2_async_subdev **subdevs = NULL;
+	unsigned int num_subdevs = 0;
+	int ret = 0, i;
+
+	/* Parse all the remote entities and put them into the list */
+	while (1) {
+		next = of_graph_get_next_endpoint(node, ep);
+		if (!next)
+			break;
+
+		of_node_put(ep);
+		ep = next;
+
+		remote = of_graph_get_remote_port_parent(ep);
+		if (!remote) {
+			ret = -EINVAL;
+			break;
+		}
+
+		entity = tegra_vi_graph_find_entity(vi, remote);
+		if (!entity) {
+			entity = devm_kzalloc(vi->dev, sizeof(*entity),
+					      GFP_KERNEL);
+			if (entity == NULL) {
+				of_node_put(remote);
+				ret = -ENOMEM;
+				break;
+			}
+
+			entity->node = remote;
+			entity->asd.match_type = V4L2_ASYNC_MATCH_OF;
+			entity->asd.match.of.node = remote;
+			list_add_tail(&entity->list, &vi->entities);
+			vi->num_subdevs++;
+		}
+	}
+	of_node_put(ep);
+
+	if (!vi->num_subdevs) {
+		dev_warn(vi->dev, "no subdev found in graph\n");
+		goto done;
+	}
+
+	/*
+	 * VI has at least MAX_CHAN_NUM / 2 subdevices for CSI blocks.
+	 * If just found CSI subdevices connecting to VI, VI has no sensors
+	 * described in DT but has to use test pattern generator mode.
+	 * Otherwise VI has sensors connecting.
+	 */
+	vi->has_sensors = (vi->num_subdevs > MAX_CHAN_NUM / 2);
+	if (!vi->has_sensors)
+		dev_info(vi->dev, "has no sensors connected!\n");
+
+	/* Register the subdevices notifier. */
+	num_subdevs = vi->num_subdevs;
+	subdevs = devm_kzalloc(vi->dev, sizeof(*subdevs) * num_subdevs,
+			       GFP_KERNEL);
+	if (subdevs == NULL) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	i = 0;
+	list_for_each_entry(entity, &vi->entities, list)
+		subdevs[i++] = &entity->asd;
+
+	vi->notifier.subdevs = subdevs;
+	vi->notifier.num_subdevs = num_subdevs;
+	vi->notifier.bound = tegra_vi_graph_notify_bound;
+	vi->notifier.complete = tegra_vi_graph_notify_complete;
+
+	ret = v4l2_async_notifier_register(&vi->v4l2_dev, &vi->notifier);
+	if (ret < 0) {
+		dev_err(vi->dev, "notifier registration failed\n");
+		goto done;
+	}
+
+	return 0;
+
+done:
+	if (ret < 0)
+		tegra_vi_graph_cleanup(vi);
+
+	return ret;
+}
+
+static int tegra_vi_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct tegra_vi *vi;
+	int ret = 0;
+
+	vi = devm_kzalloc(&pdev->dev, sizeof(*vi), GFP_KERNEL);
+	if (!vi)
+		return -ENOMEM;
+
+	vi->dev = &pdev->dev;
+	INIT_LIST_HEAD(&vi->entities);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	vi->iomem = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(vi->iomem))
+		return PTR_ERR(vi->iomem);
+
+	vi->vi_rst = devm_reset_control_get(&pdev->dev, "vi");
+	if (IS_ERR(vi->vi_rst)) {
+		dev_err(&pdev->dev, "Failed to get vi reset\n");
+		return PTR_ERR(vi->vi_rst);
+	}
+
+	vi->vi_clk = devm_clk_get(&pdev->dev, "vi");
+	if (IS_ERR(vi->vi_clk)) {
+		dev_err(&pdev->dev, "Failed to get vi clock\n");
+		return PTR_ERR(vi->vi_clk);
+	}
+
+	vi->parent_clk = devm_clk_get(&pdev->dev, "parent");
+	if (IS_ERR(vi->parent_clk)) {
+		dev_err(&pdev->dev, "Failed to get VI parent clock\n");
+		return PTR_ERR(vi->parent_clk);
+	}
+
+	ret = clk_set_parent(vi->vi_clk, vi->parent_clk);
+	if (ret < 0)
+		return ret;
+
+	vi->csi_clk = devm_clk_get(&pdev->dev, "csi");
+	if (IS_ERR(vi->csi_clk)) {
+		dev_err(&pdev->dev, "Failed to get csi clock\n");
+		return PTR_ERR(vi->csi_clk);
+	}
+
+	vi->vi_reg = devm_regulator_get(&pdev->dev, "avdd-dsi-csi");
+	if (IS_ERR(vi->vi_reg)) {
+		dev_err(&pdev->dev, "Failed to get avdd-dsi-csi regulators\n");
+		return -EPROBE_DEFER;
+	}
+
+	vi_tpg_fmts_bitmap_init(vi);
+
+	ret = tegra_vi_v4l2_init(vi);
+	if (ret < 0)
+		return ret;
+
+	/* Init Tegra VI channels */
+	ret = tegra_vi_channels_init(vi);
+	if (ret < 0)
+		goto channels_error;
+
+	/* Setup media links between VI and external sensor subdev. */
+	ret = tegra_vi_graph_init(vi);
+	if (ret < 0)
+		goto graph_error;
+
+	platform_set_drvdata(pdev, vi);
+
+	return 0;
+
+graph_error:
+	tegra_vi_channels_cleanup(vi);
+channels_error:
+	tegra_vi_v4l2_cleanup(vi);
+	return ret;
+}
+
+static int tegra_vi_remove(struct platform_device *pdev)
+{
+	struct tegra_vi *vi = platform_get_drvdata(pdev);
+
+	tegra_vi_graph_cleanup(vi);
+	tegra_vi_channels_cleanup(vi);
+	tegra_vi_v4l2_cleanup(vi);
+
+	return 0;
+}
+
+static const struct of_device_id tegra_vi_of_id_table[] = {
+	{ .compatible = "nvidia,tegra210-vi" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, tegra_vi_of_id_table);
+
+static struct platform_driver tegra_vi_driver = {
+	.driver = {
+		.name = "tegra-vi",
+		.of_match_table = tegra_vi_of_id_table,
+	},
+	.probe = tegra_vi_probe,
+	.remove = tegra_vi_remove,
+};
+module_platform_driver(tegra_vi_driver);
+
+MODULE_AUTHOR("Bryan Wu <pengw@nvidia.com>");
+MODULE_DESCRIPTION("NVIDIA Tegra Video Input Device Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/tegra/tegra-vi.h b/drivers/media/platform/tegra/tegra-vi.h
new file mode 100644
index 0000000..a6b6343
--- /dev/null
+++ b/drivers/media/platform/tegra/tegra-vi.h
@@ -0,0 +1,209 @@
+/*
+ * NVIDIA Tegra Video Input Device
+ *
+ * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Author: Bryan Wu <pengw@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __TEGRA_VI_H__
+#define __TEGRA_VI_H__
+
+#include <linux/host1x.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/videodev2.h>
+
+#include <media/media-device.h>
+#include <media/media-entity.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-dev.h>
+#include <media/videobuf2-core.h>
+
+#include "tegra-core.h"
+
+#define MAX_CHAN_NUM	6
+#define MAX_FORMAT_NUM	64
+
+/**
+ * struct tegra_channel_buffer - video channel buffer
+ * @buf: vb2 buffer base object
+ * @queue: buffer list entry in the channel queued buffers list
+ * @chan: channel that uses the buffer
+ * @addr: Tegra IOVA buffer address for VI output
+ */
+struct tegra_channel_buffer {
+	struct vb2_buffer buf;
+	struct list_head queue;
+	struct tegra_channel *chan;
+
+	dma_addr_t addr;
+};
+
+#define to_tegra_channel_buffer(vb) \
+	container_of(vb, struct tegra_channel_buffer, buf)
+
+/**
+ * struct tegra_vi_graph_entity - Entity in the video graph
+ * @list: list entry in a graph entities list
+ * @node: the entity's DT node
+ * @entity: media entity, from the corresponding V4L2 subdev
+ * @asd: subdev asynchronous registration information
+ * @subdev: V4L2 subdev
+ */
+struct tegra_vi_graph_entity {
+	struct list_head list;
+	struct device_node *node;
+	struct media_entity *entity;
+
+	struct v4l2_async_subdev asd;
+	struct v4l2_subdev *subdev;
+};
+
+/**
+ * struct tegra_channel - Tegra video channel
+ * @list: list entry in a composite device dmas list
+ * @video: V4L2 video device associated with the video channel
+ * @video_lock:
+ * @pad: media pad for the video device entity
+ * @pipe: pipeline belonging to the channel
+ *
+ * @vi: composite device DT node port number for the channel
+ *
+ * @client: host1x client struct
+ * @sp: host1x syncpoint pointer
+ *
+ * @kthread_capture: kernel thread task structure of this video channel
+ * @wait: wait queue structure for kernel thread
+ *
+ * @format: active V4L2 pixel format
+ * @fmtinfo: format information corresponding to the active @format
+ *
+ * @queue: vb2 buffers queue
+ * @alloc_ctx: allocation context for the vb2 @queue
+ * @sequence: V4L2 buffers sequence number
+ *
+ * @capture: list of queued buffers for capture
+ * @queued_lock: protects the buf_queued list
+ *
+ * @csi: CSI register bases
+ * @align: channel buffer alignment, default is 64
+ * @port: CSI port of this video channel
+ * @io_id: Tegra IO rail ID of this video channel
+ *
+ * @fmts_bitmap: a bitmap for formats supported
+ */
+struct tegra_channel {
+	struct list_head list;
+	struct video_device video;
+	struct mutex video_lock;
+	struct media_pad pad;
+	struct media_pipeline pipe;
+
+	struct tegra_vi *vi;
+
+	struct host1x_client client;
+	struct host1x_syncpt *sp;
+
+	struct task_struct *kthread_capture;
+	wait_queue_head_t wait;
+
+	struct v4l2_pix_format format;
+	const struct tegra_video_format *fmtinfo;
+
+	struct vb2_queue queue;
+	void *alloc_ctx;
+	u32 sequence;
+
+	struct list_head capture;
+	spinlock_t queued_lock;
+
+	void __iomem *csi;
+	unsigned int align;
+	unsigned int port;
+	unsigned int io_id;
+
+	DECLARE_BITMAP(fmts_bitmap, MAX_FORMAT_NUM);
+};
+
+#define to_tegra_channel(vdev) \
+	container_of(vdev, struct tegra_channel, video)
+
+enum tegra_vi_pg_mode {
+	TEGRA_VI_PG_DISABLED = 0,
+	TEGRA_VI_PG_DIRECT,
+	TEGRA_VI_PG_PATCH,
+};
+
+/**
+ * struct tegra_vi - NVIDIA Tegra Video Input device structure
+ * @v4l2_dev: V4L2 device
+ * @media_dev: media device
+ * @dev: device struct
+ *
+ * @iomem: register base
+ * @vi_clk: main clock for VI block
+ * @parent_clk: parent clock of VI clock
+ * @csi_clk: clock for CSI
+ * @vi_rst: reset controller
+ * @vi_reg: regulator for VI hardware, normally it avdd_dsi_csi
+ *
+ * @power_on_refcnt: reference count for power on/off operations
+ *
+ * @notifier: V4L2 asynchronous subdevs notifier
+ * @entities: entities in the graph as a list of tegra_vi_graph_entity
+ * @num_subdevs: number of subdevs in the pipeline
+ *
+ * @channels: list of channels at the pipeline output and input
+ *
+ * @ctrl_handler: V4L2 control handler
+ * @pattern: test pattern generator V4L2 control
+ * @pg_mode: test pattern generator mode (disabled/direct/patch)
+ * @tpg_fmts_bitmap: a bitmap for formats in test pattern generator mode
+ *
+ * @has_sensors: a flag to indicate whether is a real sensor connecting
+ */
+struct tegra_vi {
+	struct v4l2_device v4l2_dev;
+	struct media_device media_dev;
+	struct device *dev;
+
+	void __iomem *iomem;
+	struct clk *vi_clk;
+	struct clk *parent_clk;
+	struct clk *csi_clk;
+	struct reset_control *vi_rst;
+	struct regulator *vi_reg;
+
+	atomic_t power_on_refcnt;
+
+	struct v4l2_async_notifier notifier;
+	struct list_head entities;
+	unsigned int num_subdevs;
+
+	struct tegra_channel chans[MAX_CHAN_NUM];
+
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_ctrl *pattern;
+	enum tegra_vi_pg_mode pg_mode;
+	DECLARE_BITMAP(tpg_fmts_bitmap, MAX_FORMAT_NUM);
+
+	bool has_sensors;
+};
+
+int tegra_vi_power_on(struct tegra_vi *vi);
+void tegra_vi_power_off(struct tegra_vi *vi);
+
+int tegra_channel_init(struct tegra_vi *vi, unsigned int port);
+int tegra_channel_cleanup(struct tegra_channel *chan);
+void tegra_channel_fmts_bitmap_init(struct tegra_channel *chan,
+				    struct tegra_vi_graph_entity *entity);
+
+#endif /* __TEGRA_VI_H__ */
-- 
2.1.4

