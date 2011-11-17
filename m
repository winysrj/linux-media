Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55362 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677Ab1KQKou (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:44:50 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id pAHAils9001268
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 04:44:49 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [RESEND RFC PATCH v4 09/15] davinci: vpfe: resizer driver based on media framework
Date: Thu, 17 Nov 2011 16:14:35 +0530
Message-ID: <1321526681-22574-10-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1321526681-22574-1-git-send-email-manjunath.hadli@ti.com>
References: <1321526681-22574-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the video resizer driver with the v4l2 media controller framework
which takes care of resizing the video frames with both up-scaling
downscaling facility. The formats that is supported is YUV422.
The driver supports both continuous mode where it works in
tandem with the CCDC and previewer and single shot mode where
it can be used in isolation or with previewer. The driver underneath
uses the dm365 IPIPE module for programming the hardware.
The driver supports resizer as a subdevice and a media entity,
and the enumerable pads are 2(1 input and 1 output). The driver
supports streaming and all the pad and link related operations.
Specific filter functionality including filter types are set
through private ioctls.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/vpfe_resizer.c | 1079 ++++++++++++++++++++++++++++
 drivers/media/video/davinci/vpfe_resizer.h |   63 ++
 2 files changed, 1142 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/vpfe_resizer.c
 create mode 100644 drivers/media/video/davinci/vpfe_resizer.h

diff --git a/drivers/media/video/davinci/vpfe_resizer.c b/drivers/media/video/davinci/vpfe_resizer.c
new file mode 100644
index 0000000..f391b1a
--- /dev/null
+++ b/drivers/media/video/davinci/vpfe_resizer.c
@@ -0,0 +1,1079 @@
+/*
+ * Copyright (C) 2011 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
+ */
+
+#include <linux/platform_device.h>
+#include <linux/videodev2.h>
+#include <linux/v4l2-mediabus.h>
+#include <linux/slab.h>
+#include <media/v4l2-device.h>
+#include <media/media-entity.h>
+#include "vpfe_capture.h"
+#include "imp_hw_if.h"
+#include "vpss.h"
+
+#define MIN_IN_WIDTH	32
+#define MIN_IN_HEIGHT	32
+#define MAX_IN_WIDTH	4095
+#define MAX_IN_HEIGHT	4095
+#define MIN_OUT_WIDTH	16
+#define MIN_OUT_HEIGHT	2
+
+/* resizer pixel formats */
+static const unsigned int resz_input_fmts[] = {
+	V4L2_MBUS_FMT_UYVY8_2X8,
+#ifdef CONFIG_ARCH_DAVINCI_DM365
+	V4L2_MBUS_FMT_Y8_1X8,
+	V4L2_MBUS_FMT_UV8_1X8,
+#endif
+};
+
+static const unsigned int resz_output_fmts[] = {
+	V4L2_MBUS_FMT_UYVY8_2X8,
+#ifdef CONFIG_ARCH_DAVINCI_DM365
+	V4L2_MBUS_FMT_Y8_1X8,
+	V4L2_MBUS_FMT_UV8_1X8,
+	V4L2_MBUS_FMT_NV12_1X20,
+#endif
+};
+
+/*
+ * imp_set_resizer_config - set resizer config
+ * @resizer: vpfe resizer device pointer
+ * @channel: image processor logical channel
+ * @chan_config: resizer channel configuration
+ */
+static int imp_set_resizer_config(struct vpfe_resizer_device *resizer,
+			   struct imp_logical_channel *channel,
+			   struct rsz_channel_config *chan_config)
+{
+	struct imp_hw_interface *imp_hw_if = resizer->imp_hw_if;
+	struct device *dev = resizer->subdev.v4l2_dev->dev;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(resizer);
+	int ret;
+	int len;
+
+	dev_dbg(dev, "imp_set_resizer_config. len = %d\n", chan_config->len);
+
+	if (channel->config_state == STATE_NOT_CONFIGURED) {
+		channel->config =
+			imp_hw_if->alloc_config_block(dev, vpfe_dev->ipipe);
+
+		if (!channel->config) {
+			dev_err(dev, "memory allocation failed\n");
+			return -EFAULT;
+		}
+		/* allocate buffer for holding user configuration */
+		channel->user_config = imp_hw_if->alloc_user_config_block(dev,
+					vpfe_dev->ipipe, IMP_RESIZER, &len);
+
+		if (!channel->user_config) {
+			dev_err(dev, "memory allocation failed\n");
+			if (!chan_config->chain)
+				kfree(channel->config);
+			return -EFAULT;
+		}
+		channel->user_config_size = len;
+		dev_dbg(dev, "imp_set_resizer_config, len = %d.\n", len);
+	}
+
+	if (!chan_config->config) {
+		/* put defaults for user configuration */
+		imp_hw_if->set_user_config_defaults(dev, vpfe_dev->ipipe,
+					IMP_RESIZER, channel->user_config);
+
+		dev_dbg(dev, "imp_set_resizer_config, default\n");
+	} else {
+		memcpy(channel->user_config, chan_config->config,
+			channel->user_config_size);
+		dev_dbg(dev, "imp_set_resizer_config, user setting\n");
+	}
+
+	/* Update the user configuration in the hw config block or
+	   if chained, copy it to the shared block and allow previewer
+	   to configure it */
+	ret = imp_hw_if->set_resizer_config(dev, vpfe_dev->ipipe,
+					    chan_config->chain,
+					    channel->user_config,
+					    channel->config);
+
+	if (ret < 0)
+		dev_err(dev, "set resizer config failed\n");
+
+	channel->chained = chan_config->chain;
+	channel->config_state = STATE_CONFIGURED;
+
+	return ret;
+}
+
+/*
+ * imp_get_resizer_config - set resizer config
+ * @resizer: vpfe resizer device pointer
+ * @channel: image processor logical channel
+ * @chan_config: resizer channel configuration
+ */
+static int imp_get_resize_config(struct vpfe_resizer_device *resizer,
+			  struct imp_logical_channel *channel,
+			  struct rsz_channel_config *chan_config)
+{
+	struct device *dev = resizer->subdev.v4l2_dev->dev;
+
+	dev_dbg(dev, "imp_get_resize_config:\n");
+
+	if (channel->config_state != STATE_CONFIGURED) {
+		dev_err(dev, "channel not configured\n");
+		return -EINVAL;
+	}
+
+	if (!chan_config->config) {
+		dev_err(dev, " channel configuration NULL ptr\n");
+		return -EINVAL;
+	}
+
+	if (copy_to_user((void *)chan_config->config,
+			 (void *)channel->user_config,
+			 channel->user_config_size)) {
+		dev_err(dev, "Error in copy to user\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+/*
+ * set_resizer_channel_cont_mode - Set continous channel mode
+ * @resizer: vpfe resizer device pointer
+ */
+static void set_resizer_channel_cont_mode(struct vpfe_resizer_device *resizer)
+{
+	struct imp_logical_channel *channel = &resizer->channel;
+
+	channel->config_state = STATE_NOT_CONFIGURED;
+	channel->user_config = NULL;
+}
+
+/*
+ * set_resizer_channel_ss_mode - Set single-shot channel mode
+ * @resizer: vpfe resizer device pointer
+ */
+static int set_resizer_channel_ss_mode(struct vpfe_resizer_device *resizer)
+{
+	struct imp_logical_channel *channel = &resizer->channel;
+	struct imp_hw_interface *imp_hw_if = resizer->imp_hw_if;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(resizer);
+
+	channel->config_state = STATE_NOT_CONFIGURED;
+	channel->user_config = NULL;
+	return imp_hw_if->set_oper_mode(vpfe_dev->ipipe, IMP_MODE_SINGLE_SHOT);
+}
+
+/*
+ * reset_resizer_channel_mode - Reset channel mode
+ * @resizer: vpfe resizer device pointer
+ */
+static void reset_resizer_channel_mode(struct vpfe_resizer_device *resizer)
+{
+	struct imp_logical_channel *channel = &resizer->channel;
+	struct imp_hw_interface *imp_hw_if = resizer->imp_hw_if;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(resizer);
+
+	if (resizer->input == RESIZER_INPUT_MEMORY)
+		imp_hw_if->reset_oper_mode(vpfe_dev->ipipe);
+
+	if (channel->config_state == STATE_CONFIGURED) {
+		kfree(channel->user_config);
+		channel->user_config = NULL;
+	}
+}
+
+/*
+ * VPFE video operations
+ */
+/*
+ * rsz_video_in_queue - RESIZER video in queue
+ * @vpfe_dev: vpfe device pointer
+ * @addr: buffer address
+ */
+static void rsz_video_in_queue(struct vpfe_device *vpfe_dev,
+			       unsigned long addr)
+{
+	struct vpfe_resizer_device *resizer = &vpfe_dev->vpfe_resizer;
+	struct imp_hw_interface *imp_hw_if = resizer->imp_hw_if;
+	struct imp_logical_channel *chan = &resizer->channel;
+
+	if (resizer->input == RESIZER_INPUT_MEMORY)
+		imp_hw_if->update_inbuf_address(chan->config, addr);
+	else
+		imp_hw_if->update_inbuf_address(NULL, addr);
+}
+
+/*
+ * rsz_video_out1_queue - RESIZER-A video out queue
+ * @vpfe_dev: vpfe device pointer
+ * @addr: buffer address
+ */
+static void rsz_video_out1_queue(struct vpfe_device *vpfe_dev,
+				 unsigned long addr)
+{
+	struct vpfe_resizer_device *resizer = &vpfe_dev->vpfe_resizer;
+	struct imp_hw_interface *imp_hw_if = resizer->imp_hw_if;
+	struct vpfe_pipeline *pipe = &resizer->video_out.pipe;
+	struct imp_logical_channel *chan = &resizer->channel;
+
+	if (pipe->state == VPFE_PIPELINE_STREAM_SINGLESHOT)
+		imp_hw_if->update_outbuf1_address(vpfe_dev->ipipe,
+						  chan->config, addr);
+	else
+		imp_hw_if->update_outbuf1_address(vpfe_dev->ipipe, NULL, addr);
+
+}
+
+/*
+ * rsz_video_out2_queue - RESIZER-B video out queue
+ * @vpfe_dev: vpfe device pointer
+ * @addr: buffer address
+ */
+static void rsz_video_out2_queue(struct vpfe_device *vpfe_dev,
+				 unsigned long addr)
+{
+	struct vpfe_resizer_device *resizer = &vpfe_dev->vpfe_resizer;
+	struct imp_hw_interface *imp_hw_if = resizer->imp_hw_if;
+	struct vpfe_pipeline *pipe = &resizer->video_out.pipe;
+	struct imp_logical_channel *chan = &resizer->channel;
+
+	if (pipe->state == VPFE_PIPELINE_STREAM_SINGLESHOT)
+		imp_hw_if->update_outbuf2_address(vpfe_dev->ipipe,
+						  chan->config, addr);
+	else
+		imp_hw_if->update_outbuf2_address(vpfe_dev->ipipe, NULL, addr);
+}
+
+static const struct vpfe_video_operations video_in_ops = {
+	.queue = rsz_video_in_queue,
+};
+
+static const struct vpfe_video_operations video_out1_ops = {
+	.queue = rsz_video_out1_queue,
+};
+
+static const struct vpfe_video_operations video_out2_ops = {
+	.queue = rsz_video_out2_queue,
+};
+
+/*
+ * rsz_ss_buffer_isr - RESIZER module single-shot buffer scheduling isr
+ * @resizer: RESIZER device pointer
+ *
+ */
+static void rsz_ss_buffer_isr(struct vpfe_resizer_device *resizer)
+{
+	struct vpfe_video_device *video_out = &resizer->video_out;
+	struct vpfe_video_device *video_in = &resizer->video_in;
+	struct vpfe_video_device *video_out2 = &resizer->video_out2;
+	struct imp_hw_interface *imp_hw_if = resizer->imp_hw_if;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(resizer);
+	struct imp_logical_channel *chan = &resizer->channel;
+	struct vpfe_pipeline *pipe = &video_out->pipe;
+	u32 val;
+
+	if (resizer->output == RESIZER_OUPUT_MEMORY) {
+		val = vpss_dma_complete_interrupt();
+		if (val != 0 && val != 2)
+			return;
+	}
+
+	if (resizer->input == RESIZER_INPUT_MEMORY) {
+		spin_lock(&video_in->dma_queue_lock);
+		vpfe_process_buffer_complete(video_in);
+		video_in->state = VPFE_VIDEO_BUFFER_NOT_QUEUED;
+		vpfe_schedule_next_buffer(video_in);
+		spin_unlock(&video_in->dma_queue_lock);
+	}
+
+	if (resizer->output == RESIZER_OUPUT_MEMORY) {
+		spin_lock(&video_out->dma_queue_lock);
+		vpfe_process_buffer_complete(video_out);
+		video_out->state = VPFE_VIDEO_BUFFER_NOT_QUEUED;
+		vpfe_schedule_next_buffer(video_out);
+		spin_unlock(&video_out->dma_queue_lock);
+	}
+
+	/* If resizer B is enabled */
+	if (pipe->output_num > 1 && resizer->output2 == RESIZER_OUPUT_MEMORY) {
+		spin_lock(&video_out->dma_queue_lock);
+		vpfe_process_buffer_complete(video_out2);
+		video_out2->state = VPFE_VIDEO_BUFFER_NOT_QUEUED;
+		vpfe_schedule_next_buffer(video_out2);
+		spin_unlock(&video_out2->dma_queue_lock);
+	}
+
+	/* start HW if buffers are queued */
+	if (is_pipe_ready(pipe) && resizer->output == RESIZER_OUPUT_MEMORY)
+		imp_hw_if->enable(vpfe_dev->ipipe, 1, chan->config);
+}
+
+/*
+ * rsz_buffer_isr - RESIZER module buffer scheduling isr
+ * @resizer: RESIZER device pointer
+ *
+ */
+void rsz_buffer_isr(struct vpfe_resizer_device *resizer)
+{
+	struct vpfe_video_device *video_out2 = &resizer->video_out2;
+	struct vpfe_video_device *video_out = &resizer->video_out;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(resizer);
+	struct vpfe_pipeline *pipe = &resizer->video_out.pipe;
+	enum v4l2_field field;
+	int fid;
+
+	if (!video_out->started)
+		return;
+
+	if (resizer->input != RESIZER_INPUT_PREVIEWER)
+		return;
+
+	field = video_out->fmt.fmt.pix.field;
+
+	if (field == V4L2_FIELD_NONE) {
+		struct imp_hw_interface *imp_hw_if = resizer->imp_hw_if;
+
+		/* handle progressive frame capture */
+		if (video_out->cur_frm != video_out->next_frm) {
+			vpfe_process_buffer_complete(video_out);
+			if (pipe->output_num > 1)
+				vpfe_process_buffer_complete(video_out2);
+		}
+
+		video_out->skip_frame_count--;
+		if (!video_out->skip_frame_count) {
+			video_out->skip_frame_count =
+				video_out->skip_frame_count_init;
+			if (imp_hw_if->enable_resize)
+				imp_hw_if->enable_resize(1);
+		} else {
+			if (imp_hw_if->enable_resize)
+				imp_hw_if->enable_resize(0);
+		}
+		return;
+	}
+
+	/* handle interlaced frame capture */
+	fid = ccdc_get_fid(vpfe_dev);
+
+	/* switch the software maintained field id */
+	video_out->field_id ^= 1;
+	if (fid == video_out->field_id) {
+		/*
+		 * we are in-sync here,continue.
+		 * One frame is just being captured. If the
+		 * next frame is available, release the current
+		 * frame and move on
+		 */
+		if (fid == 0 && video_out->cur_frm != video_out->next_frm) {
+			vpfe_process_buffer_complete(video_out);
+			if (pipe->output_num > 1)
+				vpfe_process_buffer_complete(video_out2);
+		}
+	} else if (fid == 0) {
+		/*
+		* out of sync. Recover from any hardware out-of-sync.
+		* May loose one frame
+		*/
+		video_out->field_id = fid;
+	}
+}
+
+/*
+ * rsz_dma_isr - RESIZER module dma isr
+ * @resizer: RESIZER device pointer
+ *
+ */
+void rsz_dma_isr(struct vpfe_resizer_device *resizer)
+{
+	struct vpfe_video_device *video_out = &resizer->video_out;
+	struct vpfe_video_device *video_out2 = &resizer->video_out2;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(resizer);
+	struct vpfe_pipeline *pipe = &video_out->pipe;
+	enum v4l2_field field;
+	int schedule_capture = 0;
+	int fid;
+
+	if (!video_out->started)
+		return;
+
+	if (pipe->state == VPFE_PIPELINE_STREAM_SINGLESHOT) {
+		rsz_ss_buffer_isr(resizer);
+		return;
+	}
+
+	field = video_out->fmt.fmt.pix.field;
+
+	if (field == V4L2_FIELD_NONE) {
+		if (!list_empty(&video_out->dma_queue) &&
+			video_out->cur_frm == video_out->next_frm)
+			schedule_capture = 1;
+	} else {
+		fid = ccdc_get_fid(vpfe_dev);
+		if (fid == video_out->field_id) {
+			/* we are in-sync here,continue */
+			if (fid == 1 && !list_empty(&video_out->dma_queue) &&
+			    video_out->cur_frm == video_out->next_frm)
+				schedule_capture = 1;
+		}
+	}
+	if (!schedule_capture)
+		return;
+
+	spin_lock(&video_out->dma_queue_lock);
+	vpfe_schedule_next_buffer(video_out);
+	spin_unlock(&video_out->dma_queue_lock);
+	if (pipe->output_num > 1) {
+		spin_lock(&video_out2->dma_queue_lock);
+		vpfe_schedule_next_buffer(video_out2);
+		spin_unlock(&video_out2->dma_queue_lock);
+	}
+}
+
+/*
+ * V4L2 subdev operations
+ */
+
+/*
+ * resizer_ioctl - RESIZER module private ioctl's
+ * @sd: VPFE RESZIER V4L2 subdevice
+ * @cmd: ioctl command
+ * @arg: ioctl argument
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static long resizer_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	struct vpfe_resizer_device *resizer = v4l2_get_subdevdata(sd);
+	struct imp_logical_channel *rsz_conf_chan = &resizer->channel;
+	struct device *dev = resizer->subdev.v4l2_dev->dev;
+	struct rsz_channel_config *user_config;
+	int ret = -EINVAL;
+
+	switch (cmd) {
+	case RSZ_S_CONFIG:
+		user_config = (struct rsz_channel_config *)arg;
+
+		dev_dbg(dev, "RSZ_S_CONFIG:\n");
+		ret = imp_set_resizer_config(resizer, rsz_conf_chan,
+						user_config);
+		break;
+	case RSZ_G_CONFIG:
+		user_config = (struct rsz_channel_config *)arg;
+		dev_dbg(dev, "RSZ_G_CONFIG:%d:%d\n", user_config->chain,
+					user_config->len);
+		if (!user_config->config) {
+			dev_err(dev, "error in PREV_GET_CONFIG\n");
+			goto ERROR;
+		}
+		ret = imp_get_resize_config(resizer, rsz_conf_chan,
+							user_config);
+		break;
+	default:
+		printk(KERN_ERR "invalid command\n");
+	}
+
+ERROR:
+	return ret;
+}
+
+/*
+ * resizer_set_stream - Enable/Disable streaming on the RESIZER module
+ * @sd: VPFE RESIZER V4L2 subdevice
+ * @enable: Enable/disable stream
+ */
+static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct vpfe_resizer_device *resizer = v4l2_get_subdevdata(sd);
+	struct imp_hw_interface *imp_hw_if = resizer->imp_hw_if;
+	struct vpfe_pipeline *pipe = &resizer->video_out.pipe;
+	struct vpfe_device *vpfe_dev = to_vpfe_device(resizer);
+	struct imp_logical_channel *chan = &resizer->channel;
+	struct device *dev = resizer->subdev.v4l2_dev->dev;
+
+	void *config = (pipe->state == VPFE_PIPELINE_STREAM_SINGLESHOT) ?
+				chan->config : NULL;
+
+	if (resizer->output != RESIZER_OUPUT_MEMORY)
+		return 0;
+
+	switch (enable) {
+	case 1:
+		if (pipe->state == VPFE_PIPELINE_STREAM_SINGLESHOT &&
+				imp_hw_if->serialize(vpfe_dev->ipipe)) {
+			if (imp_hw_if->hw_setup(dev, vpfe_dev->ipipe,
+							config) < 0)
+				return -EINVAL;
+		} else if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS) {
+			imp_hw_if->lock_chain(vpfe_dev->ipipe);
+			if (imp_hw_if->hw_setup(dev, vpfe_dev->ipipe, NULL))
+				return -EINVAL;
+		}
+		imp_hw_if->enable(vpfe_dev->ipipe, 1, config);
+		break;
+	case 0:
+		imp_hw_if->enable(vpfe_dev->ipipe, 0, config);
+		if ((pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS))
+			imp_hw_if->unlock_chain(vpfe_dev->ipipe);
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * __resizer_get_format - helper function for getting resizer format
+ * @res   : pointer to resizer private structure
+ * @pad   : pad number
+ * @fh    : V4L2 subdev file handle
+ * @which : wanted subdev format
+ * Retun wanted mbus frame format
+ */
+static struct v4l2_mbus_framefmt *
+__resizer_get_format(struct vpfe_resizer_device *res, struct v4l2_subdev_fh *fh,
+		     unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(fh, pad);
+	return &res->formats[pad];
+}
+
+/*
+ * resizer_try_format - Handle try format by pad subdev method
+ * @res   : VPFE resizer device
+ * @fh    : V4L2 subdev file handle
+ * @pad   : pad num
+ * @fmt   : pointer to v4l2 format structure
+ * @which : wanted subdev format
+ */
+static void resizer_try_format(struct vpfe_resizer_device *res,
+			struct v4l2_subdev_fh *fh, unsigned int pad,
+			struct v4l2_mbus_framefmt *fmt,
+			enum v4l2_subdev_format_whence which)
+{
+	struct imp_hw_interface *imp_hw_if;
+	unsigned int max_out_height;
+	unsigned int max_out_width;
+	unsigned int i;
+
+	imp_hw_if = res->imp_hw_if;
+
+	if (pad == RESIZER_PAD_SINK) {
+		for (i = 0; i < ARRAY_SIZE(resz_input_fmts); i++) {
+			if (fmt->code == resz_input_fmts[i])
+				break;
+		}
+
+		/* If not found, use UYVY as default */
+		if (i >= ARRAY_SIZE(resz_input_fmts))
+			fmt->code = V4L2_MBUS_FMT_UYVY8_2X8;
+
+		fmt->width = clamp_t(u32, fmt->width, MIN_IN_WIDTH,
+					MAX_IN_WIDTH);
+		fmt->height = clamp_t(u32, fmt->height, MIN_IN_HEIGHT,
+				MAX_IN_HEIGHT);
+	} else if (pad == RESIZER_PAD_SOURCE) {
+		max_out_width = imp_hw_if->get_max_output_width(0);
+		max_out_height = imp_hw_if->get_max_output_height(0);
+
+		for (i = 0; i < ARRAY_SIZE(resz_output_fmts); i++) {
+			if (fmt->code == resz_output_fmts[i])
+				break;
+		}
+
+		/* If not found, use UYVY as default */
+		if (i >= ARRAY_SIZE(resz_output_fmts))
+			fmt->code = V4L2_MBUS_FMT_UYVY8_2X8;
+
+		fmt->width = clamp_t(u32, fmt->width, MIN_OUT_WIDTH,
+					max_out_width);
+		fmt->width &= ~15;
+		fmt->height = clamp_t(u32, fmt->height, MIN_OUT_HEIGHT,
+				max_out_height);
+	} else if (pad == RESIZER_PAD_SOURCE2) {
+		max_out_width = imp_hw_if->get_max_output_width(1);
+		max_out_height = imp_hw_if->get_max_output_height(1);
+
+		for (i = 0; i < ARRAY_SIZE(resz_output_fmts); i++) {
+			if (fmt->code == resz_output_fmts[i])
+				break;
+		}
+
+		/* If not found, use UYVY as default */
+		if (i >= ARRAY_SIZE(resz_output_fmts))
+			fmt->code = V4L2_MBUS_FMT_UYVY8_2X8;
+
+		fmt->width = clamp_t(u32, fmt->width, MIN_OUT_WIDTH,
+					max_out_width);
+		fmt->width &= ~15;
+		fmt->height = clamp_t(u32, fmt->height, MIN_OUT_HEIGHT,
+				max_out_height);
+	}
+}
+
+/*
+* resizer_set_format - set format on pad
+* @sd    : VPFE resizer device
+* @fh    : V4L2 subdev file handle
+* @fmt   : pointer to v4l2 subdev format structure
+*/
+static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct vpfe_resizer_device *resizer = v4l2_get_subdevdata(sd);
+	struct vpfe_device *vpfe_dev = to_vpfe_device(resizer);
+	struct imp_hw_interface *imp_hw_if = resizer->imp_hw_if;
+	struct v4l2_mbus_framefmt *format;
+
+	format = __resizer_get_format(resizer, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	resizer_try_format(resizer, fh, fmt->pad, &fmt->format, fmt->which);
+	*format = fmt->format;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
+		return 0;
+
+	if (fmt->pad == RESIZER_PAD_SINK &&
+			resizer->input == RESIZER_INPUT_PREVIEWER) {
+		/*
+		 *This is continous mode, input format is already set in
+		 *PREVIEWER sink set format, no need to do here.
+		 */
+		resizer->formats[fmt->pad] = fmt->format;
+	} else if (fmt->pad == RESIZER_PAD_SOURCE &&
+			resizer->output == RESIZER_OUPUT_MEMORY) {
+
+		imp_hw_if->set_out_mbus_format(vpfe_dev->ipipe, &fmt->format);
+		resizer->formats[fmt->pad] = fmt->format;
+
+	} else if (fmt->pad == RESIZER_PAD_SINK &&
+			resizer->input == RESIZER_INPUT_MEMORY) {
+		/*
+		 * single shot mode
+		 */
+
+		imp_hw_if->set_in_mbus_format(vpfe_dev->ipipe, &fmt->format);
+		resizer->formats[fmt->pad] = fmt->format;
+	} else if (fmt->pad == RESIZER_PAD_SOURCE2 &&
+		resizer->output2 == RESIZER_OUPUT_MEMORY) {
+		imp_hw_if->set_out2_mbus_format(vpfe_dev->ipipe, &fmt->format);
+		resizer->formats[fmt->pad] = fmt->format;
+
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * resizer_get_format - Retrieve the video format on a pad
+ * @sd : VPFE RESIZER V4L2 subdevice
+ * @fh : V4L2 subdev file handle
+ * @fmt: Format
+ *
+ * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
+ * to the format type.
+ */
+static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct vpfe_resizer_device *res = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __resizer_get_format(res, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	fmt->format = *format;
+
+	return 0;
+}
+
+/*
+ * resizer_enum_frame_size - enum frame sizes on pads
+ * @sd: VPFE resizer V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @code: pointer to v4l2_subdev_frame_size_enum structure
+ */
+static int resizer_enum_frame_size(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct vpfe_resizer_device *res = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt format;
+
+	if (fse->index != 0)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = 1;
+	format.height = 1;
+	resizer_try_format(res, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->min_width = format.width;
+	fse->min_height = format.height;
+
+	if (format.code != fse->code)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = -1;
+	format.height = -1;
+	resizer_try_format(res, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->max_width = format.width;
+	fse->max_height = format.height;
+
+	return 0;
+}
+
+/*
+ * resizer_enum_mbus_code - enum mbus codes for pads
+ * @sd: VPFE resizer V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ * @code: pointer to v4l2_subdev_mbus_code_enum structure
+ */
+static int resizer_enum_mbus_code(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->pad == RESIZER_PAD_SINK) {
+		if (code->index >= ARRAY_SIZE(resz_input_fmts))
+			return -EINVAL;
+
+		code->code = resz_input_fmts[code->index];
+	} else if (code->pad == RESIZER_PAD_SOURCE) {
+		if (code->index >= ARRAY_SIZE(resz_output_fmts))
+			return -EINVAL;
+
+		code->code = resz_output_fmts[code->index];
+	}
+
+	return 0;
+}
+
+/*
+ * resizer_init_formats - Initialize formats on all pads
+ * @sd: VPFE resizer V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values. If fh is not NULL, try
+ * formats are initialized on the file handle. Otherwise active formats are
+ * initialized on the device.
+ */
+static int resizer_init_formats(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh)
+{
+	struct vpfe_resizer_device *res = v4l2_get_subdevdata(sd);
+	struct imp_hw_interface *imp_hw_if = res->imp_hw_if;
+	struct v4l2_subdev_format format;
+
+	memset(&format, 0, sizeof(format));
+	format.pad = RESIZER_PAD_SINK;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_YUYV8_2X8;
+	format.format.width = MAX_IN_WIDTH;
+	format.format.height = MAX_IN_HEIGHT;
+	resizer_set_format(sd, fh, &format);
+
+	memset(&format, 0, sizeof(format));
+	format.pad = RESIZER_PAD_SOURCE;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_UYVY8_2X8;
+	format.format.width = imp_hw_if->get_max_output_width(0);
+	format.format.height = imp_hw_if->get_max_output_height(0);
+	resizer_set_format(sd, fh, &format);
+
+	return 0;
+}
+
+/* V4L2 subdev core operations */
+static const struct v4l2_subdev_core_ops resizer_v4l2_core_ops = {
+	.ioctl = resizer_ioctl,
+};
+
+/* subdev file operations */
+static const struct v4l2_subdev_file_ops resizer_v4l2_file_ops = {
+	.open = resizer_init_formats,
+};
+
+/* V4L2 subdev video operations */
+static const struct v4l2_subdev_video_ops resizer_v4l2_video_ops = {
+	.s_stream = resizer_set_stream,
+};
+
+/* V4L2 subdev pad operations */
+static const struct v4l2_subdev_pad_ops resizer_v4l2_pad_ops = {
+	.enum_mbus_code = resizer_enum_mbus_code,
+	.enum_frame_size = resizer_enum_frame_size,
+	.get_fmt = resizer_get_format,
+	.set_fmt = resizer_set_format,
+};
+
+/* V4L2 subdev operations */
+static const struct v4l2_subdev_ops resizer_v4l2_ops = {
+	.core = &resizer_v4l2_core_ops,
+	.file = &resizer_v4l2_file_ops,
+	.video = &resizer_v4l2_video_ops,
+	.pad = &resizer_v4l2_pad_ops,
+};
+
+/*
+ * Media entity operations
+ */
+
+/*
+ * resizer_link_setup - Setup RESIZER connections
+ * @entity: RESIZER media entity
+ * @local: Pad at the local end of the link
+ * @remote: Pad at the remote end of the link
+ * @flags: Link flags
+ *
+ * return -EINVAL or zero on success
+ */
+static int resizer_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct vpfe_resizer_device *resizer = v4l2_get_subdevdata(sd);
+
+	switch (local->index | media_entity_type(remote->entity)) {
+	case RESIZER_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* Read from previewer - continous mode */
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			reset_resizer_channel_mode(resizer);
+			resizer->input = RESIZER_INPUT_NONE;
+			break;
+		}
+
+		if (resizer->input != RESIZER_INPUT_NONE)
+			return -EBUSY;
+
+		resizer->input = RESIZER_INPUT_PREVIEWER;
+
+		set_resizer_channel_cont_mode(resizer);
+		break;
+	case RESIZER_PAD_SINK | MEDIA_ENT_T_DEVNODE:
+		/* Read from memory - single shot mode*/
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			reset_resizer_channel_mode(resizer);
+			resizer->input = RESIZER_INPUT_NONE;
+			break;
+		}
+
+		if (set_resizer_channel_ss_mode(resizer))
+			return -EINVAL;
+
+		resizer->input = RESIZER_INPUT_MEMORY;
+		break;
+	case RESIZER_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+		/* Write to memory */
+		if (flags & MEDIA_LNK_FL_ENABLED)
+			resizer->output = RESIZER_OUPUT_MEMORY;
+		else
+			resizer->output = RESIZER_OUTPUT_NONE;
+
+		break;
+	case RESIZER_PAD_SOURCE2 | MEDIA_ENT_T_DEVNODE:
+		/* Write to memory */
+		if (flags & MEDIA_LNK_FL_ENABLED)
+			resizer->output2 = RESIZER_OUPUT_MEMORY;
+		else
+			resizer->output2 = RESIZER_OUTPUT_NONE;
+
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+static const struct media_entity_operations resizer_media_ops = {
+	.link_setup = resizer_link_setup,
+};
+
+/*
+ * vpfe_resizer_unregister_entities - RESIZER subdevs/video
+ * driver unregistrations.
+ * @vpfe_rsz - pointer to resizer subdevice structure.
+ */
+void vpfe_resizer_unregister_entities(struct vpfe_resizer_device *vpfe_rsz)
+{
+	/* unregister video devices */
+	vpfe_video_unregister(&vpfe_rsz->video_in);
+	vpfe_video_unregister(&vpfe_rsz->video_out);
+	vpfe_video_unregister(&vpfe_rsz->video_out2);
+
+	/* cleanup entity */
+	media_entity_cleanup(&vpfe_rsz->subdev.entity);
+	/* unregister subdev */
+	v4l2_device_unregister_subdev(&vpfe_rsz->subdev);
+}
+
+/*
+ * vpfe_resizer_register_entities - RESIZER subdevs/video
+ * driver registrations.
+ * @resizer - pointer to resizer subdevice structure.
+ * @vdev: pointer to v4l2 device structure.
+ */
+int vpfe_resizer_register_entities(struct vpfe_resizer_device *resizer,
+				   struct v4l2_device *vdev)
+{
+	struct vpfe_device *vpfe_dev = to_vpfe_device(resizer);
+	unsigned int flags;
+	int ret;
+
+	/* Register the subdev */
+	ret = v4l2_device_register_subdev(vdev, &resizer->subdev);
+	if (ret < 0) {
+		printk(KERN_ERR "failed to register resizer as v4l2-subdev\n");
+		return ret;
+	}
+
+	ret = vpfe_video_register(&resizer->video_in, vdev);
+	if (ret) {
+		printk(KERN_ERR "failed to register RSZ video-in device\n");
+		goto out_video_in_register;
+	}
+
+	resizer->video_in.vpfe_dev = vpfe_dev;
+
+	ret = vpfe_video_register(&resizer->video_out, vdev);
+	if (ret) {
+		printk(KERN_ERR "failed to register RSZ video-out device\n");
+		goto out_video_out_register;
+	}
+
+	resizer->video_out.vpfe_dev = vpfe_dev;
+
+	ret = vpfe_video_register(&resizer->video_out2, vdev);
+	if (ret) {
+		printk(KERN_ERR "failed to register RSZ video-out2 device\n");
+		goto out_video_out2_register;
+	}
+
+	resizer->video_out2.vpfe_dev = vpfe_dev;
+
+	flags = 0;
+	ret = media_entity_create_link(&resizer->video_in.video_dev.entity, 0,
+				       &resizer->subdev.entity, 0, flags);
+	if (ret < 0)
+		goto out_create_link;
+
+	ret = media_entity_create_link(&resizer->subdev.entity, 1,
+				       &resizer->video_out.video_dev.entity,
+				       0, flags);
+	if (ret < 0)
+		goto out_create_link;
+
+	ret = media_entity_create_link(&resizer->subdev.entity, 2,
+					&resizer->video_out2.video_dev.entity,
+					0, flags);
+	if (ret < 0)
+		goto out_create_link;
+
+	return 0;
+
+out_create_link:
+	vpfe_video_unregister(&resizer->video_out2);
+out_video_out2_register:
+	vpfe_video_unregister(&resizer->video_out);
+out_video_out_register:
+	vpfe_video_unregister(&resizer->video_in);
+out_video_in_register:
+	media_entity_cleanup(&resizer->subdev.entity);
+	v4l2_device_unregister_subdev(&resizer->subdev);
+	return ret;
+}
+
+/*
+ * vpfe_resizer_init - RESIZER module initilaization.
+ * @vpfe_rsz - pointer to resizer subdevice structure.
+ * @pdev: platform device pointer.
+ */
+int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
+		      struct platform_device *pdev)
+{
+	struct imp_logical_channel *channel = &vpfe_rsz->channel;
+	struct v4l2_subdev *resizer = &vpfe_rsz->subdev;
+	struct media_pad *pads = &vpfe_rsz->pads[0];
+	struct media_entity *me = &resizer->entity;
+	int ret;
+
+	vpfe_rsz->imp_hw_if = imp_get_hw_if();
+	if (!vpfe_rsz->imp_hw_if)
+		return -EINVAL;
+
+	vpfe_rsz->video_in.ops = &video_in_ops;
+	vpfe_rsz->video_out.ops = &video_out1_ops;
+	vpfe_rsz->video_out2.ops = &video_out2_ops;
+
+	v4l2_subdev_init(resizer, &resizer_v4l2_ops);
+	strlcpy(resizer->name, "DAVINCI RESIZER", sizeof(resizer->name));
+	resizer->grp_id = 1 << 16;	/* group ID for davinci subdevs */
+	v4l2_set_subdevdata(resizer, vpfe_rsz);
+	resizer->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	pads[RESIZER_PAD_SINK].flags = MEDIA_PAD_FL_INPUT;
+	pads[RESIZER_PAD_SOURCE].flags = MEDIA_PAD_FL_OUTPUT;
+	pads[RESIZER_PAD_SOURCE2].flags = MEDIA_PAD_FL_OUTPUT;
+
+	vpfe_rsz->input = RESIZER_INPUT_NONE;
+	vpfe_rsz->output = RESIZER_OUTPUT_NONE;
+	vpfe_rsz->output2 = RESIZER_OUTPUT_NONE;
+
+	channel->type = IMP_RESIZER;
+	channel->config_state = STATE_NOT_CONFIGURED;
+
+	me->ops = &resizer_media_ops;
+
+	ret = media_entity_init(me, RESIZER_PADS_NUM, pads, 0);
+	if (ret)
+		return ret;
+
+	vpfe_rsz->video_in.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	ret = vpfe_video_init(&vpfe_rsz->video_in, "RSZ");
+	if (ret) {
+		printk(KERN_ERR "failed to init RSZ video-in device\n");
+		return ret;
+	}
+
+	vpfe_rsz->video_out.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ret = vpfe_video_init(&vpfe_rsz->video_out, "RSZ");
+	if (ret) {
+		printk(KERN_ERR "failed to init RSZ video-out device\n");
+		return ret;
+	}
+
+	vpfe_rsz->video_out2.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ret = vpfe_video_init(&vpfe_rsz->video_out2, "RSZB");
+	if (ret) {
+		printk(KERN_ERR "failed to init RSZ video-out2 device\n");
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/media/video/davinci/vpfe_resizer.h b/drivers/media/video/davinci/vpfe_resizer.h
new file mode 100644
index 0000000..35d60e0
--- /dev/null
+++ b/drivers/media/video/davinci/vpfe_resizer.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright (C) 2011 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#ifndef _VPFE_RSZ_H
+#define _VPFE_RSZ_H
+
+#define RESIZER_PAD_SINK	0
+#define RESIZER_PAD_SOURCE	1
+#define RESIZER_PAD_SOURCE2	2
+
+#define RESIZER_PADS_NUM	3
+
+enum resizer_input_entity {
+	RESIZER_INPUT_NONE,
+	RESIZER_INPUT_MEMORY,
+	RESIZER_INPUT_PREVIEWER,
+};
+
+#define RESIZER_OUTPUT_NONE	0
+#define RESIZER_OUPUT_MEMORY	(1 << 0)
+
+struct vpfe_resizer_device {
+	struct v4l2_subdev		subdev;
+	struct media_pad		pads[RESIZER_PADS_NUM];
+	struct v4l2_mbus_framefmt	formats[RESIZER_PADS_NUM];
+	enum resizer_input_entity	input;
+	unsigned int			output;
+	unsigned int                    output2;
+
+	/* pointer to ipipe function pointers */
+	struct imp_hw_interface		*imp_hw_if;
+	struct rsz_channel_config	chan_config;
+	struct imp_logical_channel	channel;
+
+	struct vpfe_video_device	video_in;
+	struct vpfe_video_device	video_out;
+	struct vpfe_video_device        video_out2;
+};
+
+void vpfe_resizer_unregister_entities(struct vpfe_resizer_device *vpfe_rsz);
+int vpfe_resizer_register_entities(struct vpfe_resizer_device *vpfe_rsz,
+				   struct v4l2_device *v4l2_dev);
+int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
+		      struct platform_device *pdev);
+void rsz_buffer_isr(struct vpfe_resizer_device *resizer);
+void vpfe_resizer_cleanup(struct platform_device *pdev);
+void rsz_dma_isr(struct vpfe_resizer_device *resizer);
+
+#endif
-- 
1.6.2.4

