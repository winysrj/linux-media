Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2367 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbaHYLay (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 07:30:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 05/12] vivid: add the video capture and output parts
Date: Mon, 25 Aug 2014 13:30:16 +0200
Message-Id: <1408966223-5221-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408966223-5221-1-git-send-email-hverkuil@xs4all.nl>
References: <1408966223-5221-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This adds the ioctl and vb2 queue support for video capture and output.
Part of this is common to both, so that is placed in a vid-common source.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-cap.c    | 1729 +++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-vid-cap.h    |   71 +
 drivers/media/platform/vivid/vivid-vid-common.c |  571 ++++++++
 drivers/media/platform/vivid/vivid-vid-common.h |   61 +
 drivers/media/platform/vivid/vivid-vid-out.c    | 1205 ++++++++++++++++
 drivers/media/platform/vivid/vivid-vid-out.h    |   57 +
 6 files changed, 3694 insertions(+)
 create mode 100644 drivers/media/platform/vivid/vivid-vid-cap.c
 create mode 100644 drivers/media/platform/vivid/vivid-vid-cap.h
 create mode 100644 drivers/media/platform/vivid/vivid-vid-common.c
 create mode 100644 drivers/media/platform/vivid/vivid-vid-common.h
 create mode 100644 drivers/media/platform/vivid/vivid-vid-out.c
 create mode 100644 drivers/media/platform/vivid/vivid-vid-out.h

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
new file mode 100644
index 0000000..52f24ea
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -0,0 +1,1729 @@
+/*
+ * vivid-vid-cap.c - video capture support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/videodev2.h>
+#include <linux/v4l2-dv-timings.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-dv-timings.h>
+
+#include "vivid-core.h"
+#include "vivid-vid-common.h"
+#include "vivid-kthread-cap.h"
+#include "vivid-vid-cap.h"
+
+/* timeperframe: min/max and default */
+static const struct v4l2_fract
+	tpf_min     = {.numerator = 1,		.denominator = FPS_MAX},
+	tpf_max     = {.numerator = FPS_MAX,	.denominator = 1},
+	tpf_default = {.numerator = 1,		.denominator = 30};
+
+static const struct vivid_fmt formats_ovl[] = {
+	{
+		.name     = "RGB565 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
+		.depth    = 16,
+		.planes   = 1,
+	},
+	{
+		.name     = "XRGB555 (LE)",
+		.fourcc   = V4L2_PIX_FMT_XRGB555, /* gggbbbbb arrrrrgg */
+		.depth    = 16,
+		.planes   = 1,
+	},
+	{
+		.name     = "ARGB555 (LE)",
+		.fourcc   = V4L2_PIX_FMT_ARGB555, /* gggbbbbb arrrrrgg */
+		.depth    = 16,
+		.planes   = 1,
+	},
+};
+
+/* The number of discrete webcam framesizes */
+#define VIVID_WEBCAM_SIZES 3
+/* The number of discrete webcam frameintervals */
+#define VIVID_WEBCAM_IVALS (VIVID_WEBCAM_SIZES * 2)
+
+/* Sizes must be in increasing order */
+static const struct v4l2_frmsize_discrete webcam_sizes[VIVID_WEBCAM_SIZES] = {
+	{  320, 180 },
+	{  640, 360 },
+	{ 1280, 720 },
+};
+
+/*
+ * Intervals must be in increasing order and there must be twice as many
+ * elements in this array as there are in webcam_sizes.
+ */
+static const struct v4l2_fract webcam_intervals[VIVID_WEBCAM_IVALS] = {
+	{  1, 10 },
+	{  1, 15 },
+	{  1, 25 },
+	{  1, 30 },
+	{  1, 50 },
+	{  1, 60 },
+};
+
+static const struct v4l2_discrete_probe webcam_probe = {
+	webcam_sizes,
+	VIVID_WEBCAM_SIZES
+};
+
+static int vid_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+		       unsigned *nbuffers, unsigned *nplanes,
+		       unsigned sizes[], void *alloc_ctxs[])
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+	unsigned planes = tpg_g_planes(&dev->tpg);
+	unsigned h = dev->fmt_cap_rect.height;
+	unsigned p;
+
+	if (dev->field_cap == V4L2_FIELD_ALTERNATE) {
+		/*
+		 * You cannot use read() with FIELD_ALTERNATE since the field
+		 * information (TOP/BOTTOM) cannot be passed back to the user.
+		 */
+		if (vb2_fileio_is_active(vq))
+			return -EINVAL;
+	}
+
+	if (dev->queue_setup_error) {
+		/*
+		 * Error injection: test what happens if queue_setup() returns
+		 * an error.
+		 */
+		dev->queue_setup_error = false;
+		return -EINVAL;
+	}
+	if (fmt) {
+		const struct v4l2_pix_format_mplane *mp;
+		struct v4l2_format mp_fmt;
+		const struct vivid_fmt *vfmt;
+
+		if (!V4L2_TYPE_IS_MULTIPLANAR(fmt->type)) {
+			fmt_sp2mp(fmt, &mp_fmt);
+			fmt = &mp_fmt;
+		}
+		mp = &fmt->fmt.pix_mp;
+		/*
+		 * Check if the number of planes in the specified format match
+		 * the number of planes in the current format. You can't mix that.
+		 */
+		if (mp->num_planes != planes)
+			return -EINVAL;
+		vfmt = get_format(dev, mp->pixelformat);
+		for (p = 0; p < planes; p++) {
+			sizes[p] = mp->plane_fmt[p].sizeimage;
+			if (sizes[0] < tpg_g_bytesperline(&dev->tpg, 0) * h +
+							vfmt->data_offset[p])
+				return -EINVAL;
+		}
+	} else {
+		for (p = 0; p < planes; p++)
+			sizes[p] = tpg_g_bytesperline(&dev->tpg, p) * h +
+					dev->fmt_cap->data_offset[p];
+	}
+
+	if (vq->num_buffers + *nbuffers < 2)
+		*nbuffers = 2 - vq->num_buffers;
+
+	*nplanes = planes;
+
+	/*
+	 * videobuf2-vmalloc allocator is context-less so no need to set
+	 * alloc_ctxs array.
+	 */
+
+	if (planes == 2)
+		dprintk(dev, 1, "%s, count=%d, sizes=%u, %u\n", __func__,
+			*nbuffers, sizes[0], sizes[1]);
+	else
+		dprintk(dev, 1, "%s, count=%d, size=%u\n", __func__,
+			*nbuffers, sizes[0]);
+
+	return 0;
+}
+
+static int vid_cap_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long size;
+	unsigned planes = tpg_g_planes(&dev->tpg);
+	unsigned p;
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	if (WARN_ON(NULL == dev->fmt_cap))
+		return -EINVAL;
+
+	if (dev->buf_prepare_error) {
+		/*
+		 * Error injection: test what happens if buf_prepare() returns
+		 * an error.
+		 */
+		dev->buf_prepare_error = false;
+		return -EINVAL;
+	}
+	for (p = 0; p < planes; p++) {
+		size = tpg_g_bytesperline(&dev->tpg, p) * dev->fmt_cap_rect.height +
+			dev->fmt_cap->data_offset[p];
+
+		if (vb2_plane_size(vb, 0) < size) {
+			dprintk(dev, 1, "%s data will not fit into plane %u (%lu < %lu)\n",
+					__func__, p, vb2_plane_size(vb, 0), size);
+			return -EINVAL;
+		}
+
+		vb2_set_plane_payload(vb, p, size);
+		vb->v4l2_planes[p].data_offset = dev->fmt_cap->data_offset[p];
+	}
+
+	return 0;
+}
+
+static void vid_cap_buf_finish(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct v4l2_timecode *tc = &vb->v4l2_buf.timecode;
+	unsigned fps = 25;
+	unsigned seq = vb->v4l2_buf.sequence;
+
+	if (!vivid_is_sdtv_cap(dev))
+		return;
+
+	/*
+	 * Set the timecode. Rarely used, so it is interesting to
+	 * test this.
+	 */
+	vb->v4l2_buf.flags |= V4L2_BUF_FLAG_TIMECODE;
+	if (dev->std_cap & V4L2_STD_525_60)
+		fps = 30;
+	tc->type = (fps == 30) ? V4L2_TC_TYPE_30FPS : V4L2_TC_TYPE_25FPS;
+	tc->flags = 0;
+	tc->frames = seq % fps;
+	tc->seconds = (seq / fps) % 60;
+	tc->minutes = (seq / (60 * fps)) % 60;
+	tc->hours = (seq / (60 * 60 * fps)) % 24;
+}
+
+static void vid_cap_buf_queue(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	spin_lock(&dev->slock);
+	list_add_tail(&buf->list, &dev->vid_cap_active);
+	spin_unlock(&dev->slock);
+}
+
+static int vid_cap_start_streaming(struct vb2_queue *vq, unsigned count)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+	unsigned i;
+	int err;
+
+	if (vb2_is_streaming(&dev->vb_vid_out_q))
+		dev->can_loop_video = vivid_vid_can_loop(dev);
+
+	if (dev->kthread_vid_cap)
+		return 0;
+
+	dev->vid_cap_seq_count = 0;
+	dprintk(dev, 1, "%s\n", __func__);
+	for (i = 0; i < VIDEO_MAX_FRAME; i++)
+		dev->must_blank[i] = tpg_g_perc_fill(&dev->tpg) < 100;
+	if (dev->start_streaming_error) {
+		dev->start_streaming_error = false;
+		err = -EINVAL;
+	} else {
+		err = vivid_start_generating_vid_cap(dev, &dev->vid_cap_streaming);
+	}
+	if (err) {
+		struct vivid_buffer *buf, *tmp;
+
+		list_for_each_entry_safe(buf, tmp, &dev->vid_cap_active, list) {
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		}
+	}
+	return err;
+}
+
+/* abort streaming and wait for last buffer */
+static void vid_cap_stop_streaming(struct vb2_queue *vq)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+
+	dprintk(dev, 1, "%s\n", __func__);
+	vivid_stop_generating_vid_cap(dev, &dev->vid_cap_streaming);
+	dev->can_loop_video = false;
+}
+
+const struct vb2_ops vivid_vid_cap_qops = {
+	.queue_setup		= vid_cap_queue_setup,
+	.buf_prepare		= vid_cap_buf_prepare,
+	.buf_finish		= vid_cap_buf_finish,
+	.buf_queue		= vid_cap_buf_queue,
+	.start_streaming	= vid_cap_start_streaming,
+	.stop_streaming		= vid_cap_stop_streaming,
+	.wait_prepare		= vivid_unlock,
+	.wait_finish		= vivid_lock,
+};
+
+/*
+ * Determine the 'picture' quality based on the current TV frequency: either
+ * COLOR for a good 'signal', GRAY (grayscale picture) for a slightly off
+ * signal or NOISE for no signal.
+ */
+void vivid_update_quality(struct vivid_dev *dev)
+{
+	unsigned freq_modulus;
+
+	if (dev->loop_video && (vivid_is_svid_cap(dev) || vivid_is_hdmi_cap(dev))) {
+		/*
+		 * The 'noise' will only be replaced by the actual video
+		 * if the output video matches the input video settings.
+		 */
+		tpg_s_quality(&dev->tpg, TPG_QUAL_NOISE, 0);
+		return;
+	}
+	if (vivid_is_hdmi_cap(dev) && VIVID_INVALID_SIGNAL(dev->dv_timings_signal_mode)) {
+		tpg_s_quality(&dev->tpg, TPG_QUAL_NOISE, 0);
+		return;
+	}
+	if (vivid_is_sdtv_cap(dev) && VIVID_INVALID_SIGNAL(dev->std_signal_mode)) {
+		tpg_s_quality(&dev->tpg, TPG_QUAL_NOISE, 0);
+		return;
+	}
+	if (!vivid_is_tv_cap(dev)) {
+		tpg_s_quality(&dev->tpg, TPG_QUAL_COLOR, 0);
+		return;
+	}
+
+	/*
+	 * There is a fake channel every 6 MHz at 49.25, 55.25, etc.
+	 * From +/- 0.25 MHz around the channel there is color, and from
+	 * +/- 1 MHz there is grayscale (chroma is lost).
+	 * Everywhere else it is just noise.
+	 */
+	freq_modulus = (dev->tv_freq - 676 /* (43.25-1) * 16 */) % (6 * 16);
+	if (freq_modulus > 2 * 16) {
+		tpg_s_quality(&dev->tpg, TPG_QUAL_NOISE,
+			next_pseudo_random32(dev->tv_freq ^ 0x55) & 0x3f);
+		return;
+	}
+	if (freq_modulus < 12 /*0.75 * 16*/ || freq_modulus > 20 /*1.25 * 16*/)
+		tpg_s_quality(&dev->tpg, TPG_QUAL_GRAY, 0);
+	else
+		tpg_s_quality(&dev->tpg, TPG_QUAL_COLOR, 0);
+}
+
+/*
+ * Get the current picture quality and the associated afc value.
+ */
+static enum tpg_quality vivid_get_quality(struct vivid_dev *dev, s32 *afc)
+{
+	unsigned freq_modulus;
+
+	if (afc)
+		*afc = 0;
+	if (tpg_g_quality(&dev->tpg) == TPG_QUAL_COLOR ||
+	    tpg_g_quality(&dev->tpg) == TPG_QUAL_NOISE)
+		return tpg_g_quality(&dev->tpg);
+
+	/*
+	 * There is a fake channel every 6 MHz at 49.25, 55.25, etc.
+	 * From +/- 0.25 MHz around the channel there is color, and from
+	 * +/- 1 MHz there is grayscale (chroma is lost).
+	 * Everywhere else it is just gray.
+	 */
+	freq_modulus = (dev->tv_freq - 676 /* (43.25-1) * 16 */) % (6 * 16);
+	if (afc)
+		*afc = freq_modulus - 1 * 16;
+	return TPG_QUAL_GRAY;
+}
+
+enum tpg_video_aspect vivid_get_video_aspect(const struct vivid_dev *dev)
+{
+	if (vivid_is_sdtv_cap(dev))
+		return dev->std_aspect_ratio;
+
+	if (vivid_is_hdmi_cap(dev))
+		return dev->dv_timings_aspect_ratio;
+
+	return TPG_VIDEO_ASPECT_IMAGE;
+}
+
+static enum tpg_pixel_aspect vivid_get_pixel_aspect(const struct vivid_dev *dev)
+{
+	if (vivid_is_sdtv_cap(dev))
+		return (dev->std_cap & V4L2_STD_525_60) ?
+			TPG_PIXEL_ASPECT_NTSC : TPG_PIXEL_ASPECT_PAL;
+
+	if (vivid_is_hdmi_cap(dev) &&
+	    dev->src_rect.width == 720 && dev->src_rect.height <= 576)
+		return dev->src_rect.height == 480 ?
+			TPG_PIXEL_ASPECT_NTSC : TPG_PIXEL_ASPECT_PAL;
+
+	return TPG_PIXEL_ASPECT_SQUARE;
+}
+
+/*
+ * Called whenever the format has to be reset which can occur when
+ * changing inputs, standard, timings, etc.
+ */
+void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls)
+{
+	struct v4l2_bt_timings *bt = &dev->dv_timings_cap.bt;
+	unsigned size;
+
+	switch (dev->input_type[dev->input]) {
+	case WEBCAM:
+	default:
+		dev->src_rect.width = webcam_sizes[dev->webcam_size_idx].width;
+		dev->src_rect.height = webcam_sizes[dev->webcam_size_idx].height;
+		dev->timeperframe_vid_cap = webcam_intervals[dev->webcam_ival_idx];
+		dev->field_cap = V4L2_FIELD_NONE;
+		tpg_s_rgb_range(&dev->tpg, V4L2_DV_RGB_RANGE_AUTO);
+		break;
+	case TV:
+	case SVID:
+		dev->field_cap = dev->tv_field_cap;
+		dev->src_rect.width = 720;
+		if (dev->std_cap & V4L2_STD_525_60) {
+			dev->src_rect.height = 480;
+			dev->timeperframe_vid_cap = (struct v4l2_fract) { 1001, 30000 };
+			dev->service_set_cap = V4L2_SLICED_CAPTION_525;
+		} else {
+			dev->src_rect.height = 576;
+			dev->timeperframe_vid_cap = (struct v4l2_fract) { 1000, 25000 };
+			dev->service_set_cap = V4L2_SLICED_WSS_625;
+		}
+		tpg_s_rgb_range(&dev->tpg, V4L2_DV_RGB_RANGE_AUTO);
+		break;
+	case HDMI:
+		dev->src_rect.width = bt->width;
+		dev->src_rect.height = bt->height;
+		size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
+		dev->timeperframe_vid_cap = (struct v4l2_fract) {
+			size / 100, (u32)bt->pixelclock / 100
+		};
+		if (bt->interlaced)
+			dev->field_cap = V4L2_FIELD_ALTERNATE;
+		else
+			dev->field_cap = V4L2_FIELD_NONE;
+
+		/*
+		 * We can be called from within s_ctrl, in that case we can't
+		 * set/get controls. Luckily we don't need to in that case.
+		 */
+		if (keep_controls || !dev->colorspace)
+			break;
+		if (bt->standards & V4L2_DV_BT_STD_CEA861) {
+			if (bt->width == 720 && bt->height <= 576)
+				v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SMPTE170M);
+			else
+				v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_REC709);
+			v4l2_ctrl_s_ctrl(dev->real_rgb_range_cap, 1);
+		} else {
+			v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SRGB);
+			v4l2_ctrl_s_ctrl(dev->real_rgb_range_cap, 0);
+		}
+		tpg_s_rgb_range(&dev->tpg, v4l2_ctrl_g_ctrl(dev->rgb_range_cap));
+		break;
+	}
+	vivid_update_quality(dev);
+	tpg_reset_source(&dev->tpg, dev->src_rect.width, dev->src_rect.height, dev->field_cap);
+	dev->crop_cap = dev->src_rect;
+	dev->crop_bounds_cap = dev->src_rect;
+	dev->compose_cap = dev->crop_cap;
+	if (V4L2_FIELD_HAS_T_OR_B(dev->field_cap))
+		dev->compose_cap.height /= 2;
+	dev->fmt_cap_rect = dev->compose_cap;
+	tpg_s_video_aspect(&dev->tpg, vivid_get_video_aspect(dev));
+	tpg_s_pixel_aspect(&dev->tpg, vivid_get_pixel_aspect(dev));
+	tpg_update_mv_step(&dev->tpg);
+}
+
+/* Map the field to something that is valid for the current input */
+static enum v4l2_field vivid_field_cap(struct vivid_dev *dev, enum v4l2_field field)
+{
+	if (vivid_is_sdtv_cap(dev)) {
+		switch (field) {
+		case V4L2_FIELD_INTERLACED_TB:
+		case V4L2_FIELD_INTERLACED_BT:
+		case V4L2_FIELD_SEQ_TB:
+		case V4L2_FIELD_SEQ_BT:
+		case V4L2_FIELD_TOP:
+		case V4L2_FIELD_BOTTOM:
+		case V4L2_FIELD_ALTERNATE:
+			return field;
+		case V4L2_FIELD_INTERLACED:
+		default:
+			return V4L2_FIELD_INTERLACED;
+		}
+	}
+	if (vivid_is_hdmi_cap(dev))
+		return dev->dv_timings_cap.bt.interlaced ? V4L2_FIELD_ALTERNATE :
+						       V4L2_FIELD_NONE;
+	return V4L2_FIELD_NONE;
+}
+
+static unsigned vivid_colorspace_cap(struct vivid_dev *dev)
+{
+	if (!dev->loop_video || vivid_is_webcam(dev) || vivid_is_tv_cap(dev))
+		return tpg_g_colorspace(&dev->tpg);
+	return dev->colorspace_out;
+}
+
+int vivid_g_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+	unsigned p;
+
+	mp->width        = dev->fmt_cap_rect.width;
+	mp->height       = dev->fmt_cap_rect.height;
+	mp->field        = dev->field_cap;
+	mp->pixelformat  = dev->fmt_cap->fourcc;
+	mp->colorspace   = vivid_colorspace_cap(dev);
+	mp->num_planes = dev->fmt_cap->planes;
+	for (p = 0; p < mp->num_planes; p++) {
+		mp->plane_fmt[p].bytesperline = tpg_g_bytesperline(&dev->tpg, p);
+		mp->plane_fmt[p].sizeimage =
+			mp->plane_fmt[p].bytesperline * mp->height +
+			dev->fmt_cap->data_offset[p];
+	}
+	return 0;
+}
+
+int vivid_try_fmt_vid_cap(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+	struct v4l2_plane_pix_format *pfmt = mp->plane_fmt;
+	struct vivid_dev *dev = video_drvdata(file);
+	const struct vivid_fmt *fmt;
+	unsigned bytesperline, max_bpl;
+	unsigned factor = 1;
+	unsigned w, h;
+	unsigned p;
+
+	fmt = get_format(dev, mp->pixelformat);
+	if (!fmt) {
+		dprintk(dev, 1, "Fourcc format (0x%08x) unknown.\n",
+			mp->pixelformat);
+		mp->pixelformat = V4L2_PIX_FMT_YUYV;
+		fmt = get_format(dev, mp->pixelformat);
+	}
+
+	mp->field = vivid_field_cap(dev, mp->field);
+	if (vivid_is_webcam(dev)) {
+		const struct v4l2_frmsize_discrete *sz =
+			v4l2_find_nearest_format(&webcam_probe, mp->width, mp->height);
+
+		w = sz->width;
+		h = sz->height;
+	} else if (vivid_is_sdtv_cap(dev)) {
+		w = 720;
+		h = (dev->std_cap & V4L2_STD_525_60) ? 480 : 576;
+	} else {
+		w = dev->src_rect.width;
+		h = dev->src_rect.height;
+	}
+	if (V4L2_FIELD_HAS_T_OR_B(mp->field))
+		factor = 2;
+	if (vivid_is_webcam(dev) ||
+	    (!dev->has_scaler_cap && !dev->has_crop_cap && !dev->has_compose_cap)) {
+		mp->width = w;
+		mp->height = h / factor;
+	} else {
+		struct v4l2_rect r = { 0, 0, mp->width, mp->height * factor };
+
+		rect_set_min_size(&r, &vivid_min_rect);
+		rect_set_max_size(&r, &vivid_max_rect);
+		if (dev->has_scaler_cap && !dev->has_compose_cap) {
+			struct v4l2_rect max_r = { 0, 0, MAX_ZOOM * w, MAX_ZOOM * h };
+
+			rect_set_max_size(&r, &max_r);
+		} else if (!dev->has_scaler_cap && dev->has_crop_cap && !dev->has_compose_cap) {
+			rect_set_max_size(&r, &dev->src_rect);
+		} else if (!dev->has_scaler_cap && !dev->has_crop_cap) {
+			rect_set_min_size(&r, &dev->src_rect);
+		}
+		mp->width = r.width;
+		mp->height = r.height / factor;
+	}
+
+	/* This driver supports custom bytesperline values */
+
+	/* Calculate the minimum supported bytesperline value */
+	bytesperline = (mp->width * fmt->depth) >> 3;
+	/* Calculate the maximum supported bytesperline value */
+	max_bpl = (MAX_ZOOM * MAX_WIDTH * fmt->depth) >> 3;
+	mp->num_planes = fmt->planes;
+	for (p = 0; p < mp->num_planes; p++) {
+		if (pfmt[p].bytesperline > max_bpl)
+			pfmt[p].bytesperline = max_bpl;
+		if (pfmt[p].bytesperline < bytesperline)
+			pfmt[p].bytesperline = bytesperline;
+		pfmt[p].sizeimage = pfmt[p].bytesperline * mp->height +
+			fmt->data_offset[p];
+		memset(pfmt[p].reserved, 0, sizeof(pfmt[p].reserved));
+	}
+	mp->colorspace = vivid_colorspace_cap(dev);
+	memset(mp->reserved, 0, sizeof(mp->reserved));
+	return 0;
+}
+
+int vivid_s_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_rect *crop = &dev->crop_cap;
+	struct v4l2_rect *compose = &dev->compose_cap;
+	struct vb2_queue *q = &dev->vb_vid_cap_q;
+	int ret = vivid_try_fmt_vid_cap(file, priv, f);
+	unsigned factor = 1;
+	unsigned i;
+
+	if (ret < 0)
+		return ret;
+
+	if (vb2_is_busy(q)) {
+		dprintk(dev, 1, "%s device busy\n", __func__);
+		return -EBUSY;
+	}
+
+	if (dev->overlay_cap_owner && dev->fb_cap.fmt.pixelformat != mp->pixelformat) {
+		dprintk(dev, 1, "overlay is active, can't change pixelformat\n");
+		return -EBUSY;
+	}
+
+	dev->fmt_cap = get_format(dev, mp->pixelformat);
+	if (V4L2_FIELD_HAS_T_OR_B(mp->field))
+		factor = 2;
+
+	/* Note: the webcam input doesn't support scaling, cropping or composing */
+
+	if (!vivid_is_webcam(dev) &&
+	    (dev->has_scaler_cap || dev->has_crop_cap || dev->has_compose_cap)) {
+		struct v4l2_rect r = { 0, 0, mp->width, mp->height };
+
+		if (dev->has_scaler_cap) {
+			if (dev->has_compose_cap)
+				rect_map_inside(compose, &r);
+			else
+				*compose = r;
+			if (dev->has_crop_cap && !dev->has_compose_cap) {
+				struct v4l2_rect min_r = {
+					0, 0,
+					r.width / MAX_ZOOM,
+					factor * r.height / MAX_ZOOM
+				};
+				struct v4l2_rect max_r = {
+					0, 0,
+					r.width * MAX_ZOOM,
+					factor * r.height * MAX_ZOOM
+				};
+
+				rect_set_min_size(crop, &min_r);
+				rect_set_max_size(crop, &max_r);
+				rect_map_inside(crop, &dev->crop_bounds_cap);
+			} else if (dev->has_crop_cap) {
+				struct v4l2_rect min_r = {
+					0, 0,
+					compose->width / MAX_ZOOM,
+					factor * compose->height / MAX_ZOOM
+				};
+				struct v4l2_rect max_r = {
+					0, 0,
+					compose->width * MAX_ZOOM,
+					factor * compose->height * MAX_ZOOM
+				};
+
+				rect_set_min_size(crop, &min_r);
+				rect_set_max_size(crop, &max_r);
+				rect_map_inside(crop, &dev->crop_bounds_cap);
+			}
+		} else if (dev->has_crop_cap && !dev->has_compose_cap) {
+			r.height *= factor;
+			rect_set_size_to(crop, &r);
+			rect_map_inside(crop, &dev->crop_bounds_cap);
+			r = *crop;
+			r.height /= factor;
+			rect_set_size_to(compose, &r);
+		} else if (!dev->has_crop_cap) {
+			rect_map_inside(compose, &r);
+		} else {
+			r.height *= factor;
+			rect_set_max_size(crop, &r);
+			rect_map_inside(crop, &dev->crop_bounds_cap);
+			compose->top *= factor;
+			compose->height *= factor;
+			rect_set_size_to(compose, crop);
+			rect_map_inside(compose, &r);
+			compose->top /= factor;
+			compose->height /= factor;
+		}
+	} else if (vivid_is_webcam(dev)) {
+		/* Guaranteed to be a match */
+		for (i = 0; i < ARRAY_SIZE(webcam_sizes); i++)
+			if (webcam_sizes[i].width == mp->width &&
+					webcam_sizes[i].height == mp->height)
+				break;
+		dev->webcam_size_idx = i;
+		if (dev->webcam_ival_idx >= 2 * (3 - i))
+			dev->webcam_ival_idx = 2 * (3 - i) - 1;
+		vivid_update_format_cap(dev, false);
+	} else {
+		struct v4l2_rect r = { 0, 0, mp->width, mp->height };
+
+		rect_set_size_to(compose, &r);
+		r.height *= factor;
+		rect_set_size_to(crop, &r);
+	}
+
+	dev->fmt_cap_rect.width = mp->width;
+	dev->fmt_cap_rect.height = mp->height;
+	tpg_s_buf_height(&dev->tpg, mp->height);
+	tpg_s_bytesperline(&dev->tpg, 0, mp->plane_fmt[0].bytesperline);
+	if (tpg_g_planes(&dev->tpg) > 1)
+		tpg_s_bytesperline(&dev->tpg, 1, mp->plane_fmt[1].bytesperline);
+	dev->field_cap = mp->field;
+	tpg_s_field(&dev->tpg, dev->field_cap);
+	tpg_s_crop_compose(&dev->tpg, &dev->crop_cap, &dev->compose_cap);
+	tpg_s_fourcc(&dev->tpg, dev->fmt_cap->fourcc);
+	if (vivid_is_sdtv_cap(dev))
+		dev->tv_field_cap = mp->field;
+	tpg_update_mv_step(&dev->tpg);
+	return 0;
+}
+
+int vidioc_g_fmt_vid_cap_mplane(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!dev->multiplanar)
+		return -ENOTTY;
+	return vivid_g_fmt_vid_cap(file, priv, f);
+}
+
+int vidioc_try_fmt_vid_cap_mplane(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!dev->multiplanar)
+		return -ENOTTY;
+	return vivid_try_fmt_vid_cap(file, priv, f);
+}
+
+int vidioc_s_fmt_vid_cap_mplane(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!dev->multiplanar)
+		return -ENOTTY;
+	return vivid_s_fmt_vid_cap(file, priv, f);
+}
+
+int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+	return fmt_sp2mp_func(file, priv, f, vivid_g_fmt_vid_cap);
+}
+
+int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+	return fmt_sp2mp_func(file, priv, f, vivid_try_fmt_vid_cap);
+}
+
+int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+	return fmt_sp2mp_func(file, priv, f, vivid_s_fmt_vid_cap);
+}
+
+int vivid_vid_cap_g_selection(struct file *file, void *priv,
+			      struct v4l2_selection *sel)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!dev->has_crop_cap && !dev->has_compose_cap)
+		return -ENOTTY;
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (vivid_is_webcam(dev))
+		return -EINVAL;
+
+	sel->r.left = sel->r.top = 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+		if (!dev->has_crop_cap)
+			return -EINVAL;
+		sel->r = dev->crop_cap;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		if (!dev->has_crop_cap)
+			return -EINVAL;
+		sel->r = dev->src_rect;
+		break;
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		if (!dev->has_compose_cap)
+			return -EINVAL;
+		sel->r = vivid_max_rect;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+		if (!dev->has_compose_cap)
+			return -EINVAL;
+		sel->r = dev->compose_cap;
+		break;
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		if (!dev->has_compose_cap)
+			return -EINVAL;
+		sel->r = dev->fmt_cap_rect;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_rect *crop = &dev->crop_cap;
+	struct v4l2_rect *compose = &dev->compose_cap;
+	unsigned factor = V4L2_FIELD_HAS_T_OR_B(dev->field_cap) ? 2 : 1;
+	int ret;
+
+	if (!dev->has_crop_cap && !dev->has_compose_cap)
+		return -ENOTTY;
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (vivid_is_webcam(dev))
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+		if (!dev->has_crop_cap)
+			return -EINVAL;
+		ret = vivid_vid_adjust_sel(s->flags, &s->r);
+		if (ret)
+			return ret;
+		rect_set_min_size(&s->r, &vivid_min_rect);
+		rect_set_max_size(&s->r, &dev->src_rect);
+		rect_map_inside(&s->r, &dev->crop_bounds_cap);
+		s->r.top /= factor;
+		s->r.height /= factor;
+		if (dev->has_scaler_cap) {
+			struct v4l2_rect fmt = dev->fmt_cap_rect;
+			struct v4l2_rect max_rect = {
+				0, 0,
+				s->r.width * MAX_ZOOM,
+				s->r.height * MAX_ZOOM
+			};
+			struct v4l2_rect min_rect = {
+				0, 0,
+				s->r.width / MAX_ZOOM,
+				s->r.height / MAX_ZOOM
+			};
+
+			rect_set_min_size(&fmt, &min_rect);
+			if (!dev->has_compose_cap)
+				rect_set_max_size(&fmt, &max_rect);
+			if (!rect_same_size(&dev->fmt_cap_rect, &fmt) &&
+			    vb2_is_busy(&dev->vb_vid_cap_q))
+				return -EBUSY;
+			if (dev->has_compose_cap) {
+				rect_set_min_size(compose, &min_rect);
+				rect_set_max_size(compose, &max_rect);
+			}
+			dev->fmt_cap_rect = fmt;
+			tpg_s_buf_height(&dev->tpg, fmt.height);
+		} else if (dev->has_compose_cap) {
+			struct v4l2_rect fmt = dev->fmt_cap_rect;
+
+			rect_set_min_size(&fmt, &s->r);
+			if (!rect_same_size(&dev->fmt_cap_rect, &fmt) &&
+			    vb2_is_busy(&dev->vb_vid_cap_q))
+				return -EBUSY;
+			dev->fmt_cap_rect = fmt;
+			tpg_s_buf_height(&dev->tpg, fmt.height);
+			rect_set_size_to(compose, &s->r);
+			rect_map_inside(compose, &dev->fmt_cap_rect);
+		} else {
+			if (!rect_same_size(&s->r, &dev->fmt_cap_rect) &&
+			    vb2_is_busy(&dev->vb_vid_cap_q))
+				return -EBUSY;
+			rect_set_size_to(&dev->fmt_cap_rect, &s->r);
+			rect_set_size_to(compose, &s->r);
+			rect_map_inside(compose, &dev->fmt_cap_rect);
+			tpg_s_buf_height(&dev->tpg, dev->fmt_cap_rect.height);
+		}
+		s->r.top *= factor;
+		s->r.height *= factor;
+		*crop = s->r;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+		if (!dev->has_compose_cap)
+			return -EINVAL;
+		ret = vivid_vid_adjust_sel(s->flags, &s->r);
+		if (ret)
+			return ret;
+		rect_set_min_size(&s->r, &vivid_min_rect);
+		rect_set_max_size(&s->r, &dev->fmt_cap_rect);
+		if (dev->has_scaler_cap) {
+			struct v4l2_rect max_rect = {
+				0, 0,
+				dev->src_rect.width * MAX_ZOOM,
+				(dev->src_rect.height / factor) * MAX_ZOOM
+			};
+
+			rect_set_max_size(&s->r, &max_rect);
+			if (dev->has_crop_cap) {
+				struct v4l2_rect min_rect = {
+					0, 0,
+					s->r.width / MAX_ZOOM,
+					(s->r.height * factor) / MAX_ZOOM
+				};
+				struct v4l2_rect max_rect = {
+					0, 0,
+					s->r.width * MAX_ZOOM,
+					(s->r.height * factor) * MAX_ZOOM
+				};
+
+				rect_set_min_size(crop, &min_rect);
+				rect_set_max_size(crop, &max_rect);
+				rect_map_inside(crop, &dev->crop_bounds_cap);
+			}
+		} else if (dev->has_crop_cap) {
+			s->r.top *= factor;
+			s->r.height *= factor;
+			rect_set_max_size(&s->r, &dev->src_rect);
+			rect_set_size_to(crop, &s->r);
+			rect_map_inside(crop, &dev->crop_bounds_cap);
+			s->r.top /= factor;
+			s->r.height /= factor;
+		} else {
+			rect_set_size_to(&s->r, &dev->src_rect);
+			s->r.height /= factor;
+		}
+		rect_map_inside(&s->r, &dev->fmt_cap_rect);
+		if (dev->bitmap_cap && (compose->width != s->r.width ||
+					compose->height != s->r.height)) {
+			kfree(dev->bitmap_cap);
+			dev->bitmap_cap = NULL;
+		}
+		*compose = s->r;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	tpg_s_crop_compose(&dev->tpg, crop, compose);
+	return 0;
+}
+
+int vivid_vid_cap_cropcap(struct file *file, void *priv,
+			      struct v4l2_cropcap *cap)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (cap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	switch (vivid_get_pixel_aspect(dev)) {
+	case TPG_PIXEL_ASPECT_NTSC:
+		cap->pixelaspect.numerator = 11;
+		cap->pixelaspect.denominator = 10;
+		break;
+	case TPG_PIXEL_ASPECT_PAL:
+		cap->pixelaspect.numerator = 54;
+		cap->pixelaspect.denominator = 59;
+		break;
+	case TPG_PIXEL_ASPECT_SQUARE:
+		cap->pixelaspect.numerator = 1;
+		cap->pixelaspect.denominator = 1;
+		break;
+	}
+	return 0;
+}
+
+int vidioc_enum_fmt_vid_overlay(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	const struct vivid_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(formats_ovl))
+		return -EINVAL;
+
+	fmt = &formats_ovl[f->index];
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+int vidioc_g_fmt_vid_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	const struct v4l2_rect *compose = &dev->compose_cap;
+	struct v4l2_window *win = &f->fmt.win;
+	unsigned clipcount = win->clipcount;
+
+	win->w.top = dev->overlay_cap_top;
+	win->w.left = dev->overlay_cap_left;
+	win->w.width = compose->width;
+	win->w.height = compose->height;
+	win->field = dev->overlay_cap_field;
+	win->clipcount = dev->clipcount_cap;
+	if (clipcount > dev->clipcount_cap)
+		clipcount = dev->clipcount_cap;
+	if (dev->bitmap_cap == NULL)
+		win->bitmap = NULL;
+	else if (win->bitmap) {
+		if (copy_to_user(win->bitmap, dev->bitmap_cap,
+		    ((compose->width + 7) / 8) * compose->height))
+			return -EFAULT;
+	}
+	if (clipcount && win->clips) {
+		if (copy_to_user(win->clips, dev->clips_cap,
+				 clipcount * sizeof(dev->clips_cap[0])))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+int vidioc_try_fmt_vid_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	const struct v4l2_rect *compose = &dev->compose_cap;
+	struct v4l2_window *win = &f->fmt.win;
+	int i, j;
+
+	win->w.left = clamp_t(int, win->w.left,
+			      -dev->fb_cap.fmt.width, dev->fb_cap.fmt.width);
+	win->w.top = clamp_t(int, win->w.top,
+			     -dev->fb_cap.fmt.height, dev->fb_cap.fmt.height);
+	win->w.width = compose->width;
+	win->w.height = compose->height;
+	if (win->field != V4L2_FIELD_BOTTOM && win->field != V4L2_FIELD_TOP)
+		win->field = V4L2_FIELD_ANY;
+	win->chromakey = 0;
+	win->global_alpha = 0;
+	if (win->clipcount && !win->clips)
+		win->clipcount = 0;
+	if (win->clipcount > MAX_CLIPS)
+		win->clipcount = MAX_CLIPS;
+	if (win->clipcount) {
+		if (copy_from_user(dev->try_clips_cap, win->clips,
+				   win->clipcount * sizeof(dev->clips_cap[0])))
+			return -EFAULT;
+		for (i = 0; i < win->clipcount; i++) {
+			struct v4l2_rect *r = &dev->try_clips_cap[i].c;
+
+			r->top = clamp_t(s32, r->top, 0, dev->fb_cap.fmt.height - 1);
+			r->height = clamp_t(s32, r->height, 1, dev->fb_cap.fmt.height - r->top);
+			r->left = clamp_t(u32, r->left, 0, dev->fb_cap.fmt.width - 1);
+			r->width = clamp_t(u32, r->width, 1, dev->fb_cap.fmt.width - r->left);
+		}
+		/*
+		 * Yeah, so sue me, it's an O(n^2) algorithm. But n is a small
+		 * number and it's typically a one-time deal.
+		 */
+		for (i = 0; i < win->clipcount - 1; i++) {
+			struct v4l2_rect *r1 = &dev->try_clips_cap[i].c;
+
+			for (j = i + 1; j < win->clipcount; j++) {
+				struct v4l2_rect *r2 = &dev->try_clips_cap[j].c;
+
+				if (rect_overlap(r1, r2))
+					return -EINVAL;
+			}
+		}
+		if (copy_to_user(win->clips, dev->try_clips_cap,
+				 win->clipcount * sizeof(dev->clips_cap[0])))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+int vidioc_s_fmt_vid_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	const struct v4l2_rect *compose = &dev->compose_cap;
+	struct v4l2_window *win = &f->fmt.win;
+	int ret = vidioc_try_fmt_vid_overlay(file, priv, f);
+	unsigned bitmap_size = ((compose->width + 7) / 8) * compose->height;
+	unsigned clips_size = win->clipcount * sizeof(dev->clips_cap[0]);
+	void *new_bitmap = NULL;
+
+	if (ret)
+		return ret;
+
+	if (win->bitmap) {
+		new_bitmap = vzalloc(bitmap_size);
+
+		if (new_bitmap == NULL)
+			return -ENOMEM;
+		if (copy_from_user(new_bitmap, win->bitmap, bitmap_size)) {
+			vfree(new_bitmap);
+			return -EFAULT;
+		}
+	}
+
+	dev->overlay_cap_top = win->w.top;
+	dev->overlay_cap_left = win->w.left;
+	dev->overlay_cap_field = win->field;
+	vfree(dev->bitmap_cap);
+	dev->bitmap_cap = new_bitmap;
+	dev->clipcount_cap = win->clipcount;
+	if (dev->clipcount_cap)
+		memcpy(dev->clips_cap, dev->try_clips_cap, clips_size);
+	return 0;
+}
+
+int vivid_vid_cap_overlay(struct file *file, void *fh, unsigned i)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (i && dev->fb_vbase_cap == NULL)
+		return -EINVAL;
+
+	if (i && dev->fb_cap.fmt.pixelformat != dev->fmt_cap->fourcc) {
+		dprintk(dev, 1, "mismatch between overlay and video capture pixelformats\n");
+		return -EINVAL;
+	}
+
+	if (dev->overlay_cap_owner && dev->overlay_cap_owner != fh)
+		return -EBUSY;
+	dev->overlay_cap_owner = i ? fh : NULL;
+	return 0;
+}
+
+int vivid_vid_cap_g_fbuf(struct file *file, void *fh,
+				struct v4l2_framebuffer *a)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	*a = dev->fb_cap;
+	a->capability = V4L2_FBUF_CAP_BITMAP_CLIPPING |
+			V4L2_FBUF_CAP_LIST_CLIPPING;
+	a->flags = V4L2_FBUF_FLAG_PRIMARY;
+	a->fmt.field = V4L2_FIELD_NONE;
+	a->fmt.colorspace = V4L2_COLORSPACE_SRGB;
+	a->fmt.priv = 0;
+	return 0;
+}
+
+int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
+				const struct v4l2_framebuffer *a)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	const struct vivid_fmt *fmt;
+
+	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	if (dev->overlay_cap_owner)
+		return -EBUSY;
+
+	if (a->base == NULL) {
+		dev->fb_cap.base = NULL;
+		dev->fb_vbase_cap = NULL;
+		return 0;
+	}
+
+	if (a->fmt.width < 48 || a->fmt.height < 32)
+		return -EINVAL;
+	fmt = get_format(dev, a->fmt.pixelformat);
+	if (!fmt || !fmt->can_do_overlay)
+		return -EINVAL;
+	if (a->fmt.bytesperline < (a->fmt.width * fmt->depth) / 8)
+		return -EINVAL;
+	if (a->fmt.height * a->fmt.bytesperline < a->fmt.sizeimage)
+		return -EINVAL;
+
+	dev->fb_vbase_cap = phys_to_virt((unsigned long)a->base);
+	dev->fb_cap = *a;
+	dev->overlay_cap_left = clamp_t(int, dev->overlay_cap_left,
+				    -dev->fb_cap.fmt.width, dev->fb_cap.fmt.width);
+	dev->overlay_cap_top = clamp_t(int, dev->overlay_cap_top,
+				   -dev->fb_cap.fmt.height, dev->fb_cap.fmt.height);
+	return 0;
+}
+
+static const struct v4l2_audio vivid_audio_inputs[] = {
+	{ 0, "TV", V4L2_AUDCAP_STEREO },
+	{ 1, "Line-In", V4L2_AUDCAP_STEREO },
+};
+
+int vidioc_enum_input(struct file *file, void *priv,
+				struct v4l2_input *inp)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (inp->index >= dev->num_inputs)
+		return -EINVAL;
+
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	switch (dev->input_type[inp->index]) {
+	case WEBCAM:
+		snprintf(inp->name, sizeof(inp->name), "Webcam %u",
+				dev->input_name_counter[inp->index]);
+		inp->capabilities = 0;
+		break;
+	case TV:
+		snprintf(inp->name, sizeof(inp->name), "TV %u",
+				dev->input_name_counter[inp->index]);
+		inp->type = V4L2_INPUT_TYPE_TUNER;
+		inp->std = V4L2_STD_ALL;
+		if (dev->has_audio_inputs)
+			inp->audioset = (1 << ARRAY_SIZE(vivid_audio_inputs)) - 1;
+		inp->capabilities = V4L2_IN_CAP_STD;
+		break;
+	case SVID:
+		snprintf(inp->name, sizeof(inp->name), "S-Video %u",
+				dev->input_name_counter[inp->index]);
+		inp->std = V4L2_STD_ALL;
+		if (dev->has_audio_inputs)
+			inp->audioset = (1 << ARRAY_SIZE(vivid_audio_inputs)) - 1;
+		inp->capabilities = V4L2_IN_CAP_STD;
+		break;
+	case HDMI:
+		snprintf(inp->name, sizeof(inp->name), "HDMI %u",
+				dev->input_name_counter[inp->index]);
+		inp->capabilities = V4L2_IN_CAP_DV_TIMINGS;
+		if (dev->edid_blocks == 0 ||
+		    dev->dv_timings_signal_mode == NO_SIGNAL)
+			inp->status |= V4L2_IN_ST_NO_SIGNAL;
+		else if (dev->dv_timings_signal_mode == NO_LOCK ||
+			 dev->dv_timings_signal_mode == OUT_OF_RANGE)
+			inp->status |= V4L2_IN_ST_NO_H_LOCK;
+		break;
+	}
+	if (dev->sensor_hflip)
+		inp->status |= V4L2_IN_ST_HFLIP;
+	if (dev->sensor_vflip)
+		inp->status |= V4L2_IN_ST_VFLIP;
+	if (dev->input == inp->index && vivid_is_sdtv_cap(dev)) {
+		if (dev->std_signal_mode == NO_SIGNAL) {
+			inp->status |= V4L2_IN_ST_NO_SIGNAL;
+		} else if (dev->std_signal_mode == NO_LOCK) {
+			inp->status |= V4L2_IN_ST_NO_H_LOCK;
+		} else if (vivid_is_tv_cap(dev)) {
+			switch (tpg_g_quality(&dev->tpg)) {
+			case TPG_QUAL_GRAY:
+				inp->status |= V4L2_IN_ST_COLOR_KILL;
+				break;
+			case TPG_QUAL_NOISE:
+				inp->status |= V4L2_IN_ST_NO_H_LOCK;
+				break;
+			default:
+				break;
+			}
+		}
+	}
+	return 0;
+}
+
+int vidioc_g_input(struct file *file, void *priv, unsigned *i)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	*i = dev->input;
+	return 0;
+}
+
+int vidioc_s_input(struct file *file, void *priv, unsigned i)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_bt_timings *bt = &dev->dv_timings_cap.bt;
+	unsigned brightness;
+
+	if (i >= dev->num_inputs)
+		return -EINVAL;
+
+	if (i == dev->input)
+		return 0;
+
+	if (vb2_is_busy(&dev->vb_vid_cap_q) || vb2_is_busy(&dev->vb_vbi_cap_q))
+		return -EBUSY;
+
+	dev->input = i;
+	dev->vid_cap_dev.tvnorms = 0;
+	if (dev->input_type[i] == TV || dev->input_type[i] == SVID) {
+		dev->tv_audio_input = (dev->input_type[i] == TV) ? 0 : 1;
+		dev->vid_cap_dev.tvnorms = V4L2_STD_ALL;
+	}
+	dev->vbi_cap_dev.tvnorms = dev->vid_cap_dev.tvnorms;
+	vivid_update_format_cap(dev, false);
+
+	if (dev->colorspace) {
+		switch (dev->input_type[i]) {
+		case WEBCAM:
+			v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SRGB);
+			break;
+		case TV:
+		case SVID:
+			v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SMPTE170M);
+			break;
+		case HDMI:
+			if (bt->standards & V4L2_DV_BT_STD_CEA861) {
+				if (dev->src_rect.width == 720 && dev->src_rect.height <= 576)
+					v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SMPTE170M);
+				else
+					v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_REC709);
+			} else {
+				v4l2_ctrl_s_ctrl(dev->colorspace, V4L2_COLORSPACE_SRGB);
+			}
+			break;
+		}
+	}
+
+	/*
+	 * Modify the brightness range depending on the input.
+	 * This makes it easy to use vivid to test if applications can
+	 * handle control range modifications and is also how this is
+	 * typically used in practice as different inputs may be hooked
+	 * up to different receivers with different control ranges.
+	 */
+	brightness = 128 * i + dev->input_brightness[i];
+	v4l2_ctrl_modify_range(dev->brightness,
+			128 * i, 255 + 128 * i, 1, 128 + 128 * i);
+	v4l2_ctrl_s_ctrl(dev->brightness, brightness);
+	return 0;
+}
+
+int vidioc_enumaudio(struct file *file, void *fh, struct v4l2_audio *vin)
+{
+	if (vin->index >= ARRAY_SIZE(vivid_audio_inputs))
+		return -EINVAL;
+	*vin = vivid_audio_inputs[vin->index];
+	return 0;
+}
+
+int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *vin)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!vivid_is_sdtv_cap(dev))
+		return -EINVAL;
+	*vin = vivid_audio_inputs[dev->tv_audio_input];
+	return 0;
+}
+
+int vidioc_s_audio(struct file *file, void *fh, const struct v4l2_audio *vin)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!vivid_is_sdtv_cap(dev))
+		return -EINVAL;
+	if (vin->index >= ARRAY_SIZE(vivid_audio_inputs))
+		return -EINVAL;
+	dev->tv_audio_input = vin->index;
+	return 0;
+}
+
+int vivid_video_g_frequency(struct file *file, void *fh, struct v4l2_frequency *vf)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (vf->tuner != 0)
+		return -EINVAL;
+	vf->frequency = dev->tv_freq;
+	return 0;
+}
+
+int vivid_video_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *vf)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (vf->tuner != 0)
+		return -EINVAL;
+	dev->tv_freq = clamp_t(unsigned, vf->frequency, MIN_TV_FREQ, MAX_TV_FREQ);
+	if (vivid_is_tv_cap(dev))
+		vivid_update_quality(dev);
+	return 0;
+}
+
+int vivid_video_s_tuner(struct file *file, void *fh, const struct v4l2_tuner *vt)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (vt->index != 0)
+		return -EINVAL;
+	if (vt->audmode > V4L2_TUNER_MODE_LANG1_LANG2)
+		return -EINVAL;
+	dev->tv_audmode = vt->audmode;
+	return 0;
+}
+
+int vivid_video_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	enum tpg_quality qual;
+
+	if (vt->index != 0)
+		return -EINVAL;
+
+	vt->capability = V4L2_TUNER_CAP_NORM | V4L2_TUNER_CAP_STEREO |
+			 V4L2_TUNER_CAP_LANG1 | V4L2_TUNER_CAP_LANG2;
+	vt->audmode = dev->tv_audmode;
+	vt->rangelow = MIN_TV_FREQ;
+	vt->rangehigh = MAX_TV_FREQ;
+	qual = vivid_get_quality(dev, &vt->afc);
+	if (qual == TPG_QUAL_COLOR)
+		vt->signal = 0xffff;
+	else if (qual == TPG_QUAL_GRAY)
+		vt->signal = 0x8000;
+	else
+		vt->signal = 0;
+	if (qual == TPG_QUAL_NOISE) {
+		vt->rxsubchans = 0;
+	} else if (qual == TPG_QUAL_GRAY) {
+		vt->rxsubchans = V4L2_TUNER_SUB_MONO;
+	} else {
+		unsigned channel_nr = dev->tv_freq / (6 * 16);
+		unsigned options = (dev->std_cap & V4L2_STD_NTSC_M) ? 4 : 3;
+
+		switch (channel_nr % options) {
+		case 0:
+			vt->rxsubchans = V4L2_TUNER_SUB_MONO;
+			break;
+		case 1:
+			vt->rxsubchans = V4L2_TUNER_SUB_STEREO;
+			break;
+		case 2:
+			if (dev->std_cap & V4L2_STD_NTSC_M)
+				vt->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_SAP;
+			else
+				vt->rxsubchans = V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
+			break;
+		case 3:
+			vt->rxsubchans = V4L2_TUNER_SUB_STEREO | V4L2_TUNER_SUB_SAP;
+			break;
+		}
+	}
+	strlcpy(vt->name, "TV Tuner", sizeof(vt->name));
+	return 0;
+}
+
+/* Must remain in sync with the vivid_ctrl_standard_strings array */
+const v4l2_std_id vivid_standard[] = {
+	V4L2_STD_NTSC_M,
+	V4L2_STD_NTSC_M_JP,
+	V4L2_STD_NTSC_M_KR,
+	V4L2_STD_NTSC_443,
+	V4L2_STD_PAL_BG | V4L2_STD_PAL_H,
+	V4L2_STD_PAL_I,
+	V4L2_STD_PAL_DK,
+	V4L2_STD_PAL_M,
+	V4L2_STD_PAL_N,
+	V4L2_STD_PAL_Nc,
+	V4L2_STD_PAL_60,
+	V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H,
+	V4L2_STD_SECAM_DK,
+	V4L2_STD_SECAM_L,
+	V4L2_STD_SECAM_LC,
+	V4L2_STD_UNKNOWN
+};
+
+/* Must remain in sync with the vivid_standard array */
+const char * const vivid_ctrl_standard_strings[] = {
+	"NTSC-M",
+	"NTSC-M-JP",
+	"NTSC-M-KR",
+	"NTSC-443",
+	"PAL-BGH",
+	"PAL-I",
+	"PAL-DK",
+	"PAL-M",
+	"PAL-N",
+	"PAL-Nc",
+	"PAL-60",
+	"SECAM-BGH",
+	"SECAM-DK",
+	"SECAM-L",
+	"SECAM-Lc",
+	NULL,
+};
+
+int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *id)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!vivid_is_sdtv_cap(dev))
+		return -ENODATA;
+	if (dev->std_signal_mode == NO_SIGNAL ||
+	    dev->std_signal_mode == NO_LOCK) {
+		*id = V4L2_STD_UNKNOWN;
+		return 0;
+	}
+	if (vivid_is_tv_cap(dev) && tpg_g_quality(&dev->tpg) == TPG_QUAL_NOISE) {
+		*id = V4L2_STD_UNKNOWN;
+	} else if (dev->std_signal_mode == CURRENT_STD) {
+		*id = dev->std_cap;
+	} else if (dev->std_signal_mode == SELECTED_STD) {
+		*id = dev->query_std;
+	} else {
+		*id = vivid_standard[dev->query_std_last];
+		dev->query_std_last = (dev->query_std_last + 1) % ARRAY_SIZE(vivid_standard);
+	}
+
+	return 0;
+}
+
+int vivid_vid_cap_s_std(struct file *file, void *priv, v4l2_std_id id)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!vivid_is_sdtv_cap(dev))
+		return -ENODATA;
+	if (dev->std_cap == id)
+		return 0;
+	if (vb2_is_busy(&dev->vb_vid_cap_q) || vb2_is_busy(&dev->vb_vbi_cap_q))
+		return -EBUSY;
+	dev->std_cap = id;
+	vivid_update_format_cap(dev, false);
+	return 0;
+}
+
+int vivid_vid_cap_s_dv_timings(struct file *file, void *_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!vivid_is_hdmi_cap(dev))
+		return -ENODATA;
+	if (vb2_is_busy(&dev->vb_vid_cap_q))
+		return -EBUSY;
+	if (!v4l2_find_dv_timings_cap(timings, &vivid_dv_timings_cap,
+				0, NULL, NULL))
+		return -EINVAL;
+	if (v4l2_match_dv_timings(timings, &dev->dv_timings_cap, 0))
+		return 0;
+	dev->dv_timings_cap = *timings;
+	vivid_update_format_cap(dev, false);
+	return 0;
+}
+
+int vidioc_query_dv_timings(struct file *file, void *_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!vivid_is_hdmi_cap(dev))
+		return -ENODATA;
+	if (dev->dv_timings_signal_mode == NO_SIGNAL ||
+	    dev->edid_blocks == 0)
+		return -ENOLINK;
+	if (dev->dv_timings_signal_mode == NO_LOCK)
+		return -ENOLCK;
+	if (dev->dv_timings_signal_mode == OUT_OF_RANGE) {
+		timings->bt.pixelclock = vivid_dv_timings_cap.bt.max_pixelclock * 2;
+		return -ERANGE;
+	}
+	if (dev->dv_timings_signal_mode == CURRENT_DV_TIMINGS) {
+		*timings = dev->dv_timings_cap;
+	} else if (dev->dv_timings_signal_mode == SELECTED_DV_TIMINGS) {
+		*timings = v4l2_dv_timings_presets[dev->query_dv_timings];
+	} else {
+		*timings = v4l2_dv_timings_presets[dev->query_dv_timings_last];
+		dev->query_dv_timings_last = (dev->query_dv_timings_last + 1) %
+						dev->query_dv_timings_size;
+	}
+	return 0;
+}
+
+int vidioc_s_edid(struct file *file, void *_fh,
+			 struct v4l2_edid *edid)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	memset(edid->reserved, 0, sizeof(edid->reserved));
+	if (edid->pad >= dev->num_inputs)
+		return -EINVAL;
+	if (dev->input_type[edid->pad] != HDMI || edid->start_block)
+		return -EINVAL;
+	if (edid->blocks == 0) {
+		dev->edid_blocks = 0;
+		return 0;
+	}
+	if (edid->blocks > dev->edid_max_blocks) {
+		edid->blocks = dev->edid_max_blocks;
+		return -E2BIG;
+	}
+	dev->edid_blocks = edid->blocks;
+	memcpy(dev->edid, edid->edid, edid->blocks * 128);
+	return 0;
+}
+
+int vidioc_enum_framesizes(struct file *file, void *fh,
+					 struct v4l2_frmsizeenum *fsize)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!vivid_is_webcam(dev) && !dev->has_scaler_cap)
+		return -EINVAL;
+	if (get_format(dev, fsize->pixel_format) == NULL)
+		return -EINVAL;
+	if (vivid_is_webcam(dev)) {
+		if (fsize->index >= ARRAY_SIZE(webcam_sizes))
+			return -EINVAL;
+		fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+		fsize->discrete = webcam_sizes[fsize->index];
+		return 0;
+	}
+	if (fsize->index)
+		return -EINVAL;
+	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+	fsize->stepwise.min_width = MIN_WIDTH;
+	fsize->stepwise.max_width = MAX_WIDTH * MAX_ZOOM;
+	fsize->stepwise.step_width = 2;
+	fsize->stepwise.min_height = MIN_HEIGHT;
+	fsize->stepwise.max_height = MAX_HEIGHT * MAX_ZOOM;
+	fsize->stepwise.step_height = 2;
+	return 0;
+}
+
+/* timeperframe is arbitrary and continuous */
+int vidioc_enum_frameintervals(struct file *file, void *priv,
+					     struct v4l2_frmivalenum *fival)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	const struct vivid_fmt *fmt;
+	int i;
+
+	fmt = get_format(dev, fival->pixel_format);
+	if (!fmt)
+		return -EINVAL;
+
+	if (!vivid_is_webcam(dev)) {
+		static const struct v4l2_fract step = { 1, 1 };
+
+		if (fival->index)
+			return -EINVAL;
+		if (fival->width < MIN_WIDTH || fival->width > MAX_WIDTH * MAX_ZOOM)
+			return -EINVAL;
+		if (fival->height < MIN_HEIGHT || fival->height > MAX_HEIGHT * MAX_ZOOM)
+			return -EINVAL;
+		fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
+		fival->stepwise.min = tpf_min;
+		fival->stepwise.max = tpf_max;
+		fival->stepwise.step = step;
+		return 0;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(webcam_sizes); i++)
+		if (fival->width == webcam_sizes[i].width &&
+		    fival->height == webcam_sizes[i].height)
+			break;
+	if (i == ARRAY_SIZE(webcam_sizes))
+		return -EINVAL;
+	if (fival->index >= 2 * (3 - i))
+		return -EINVAL;
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete = webcam_intervals[fival->index];
+	return 0;
+}
+
+int vivid_vid_cap_g_parm(struct file *file, void *priv,
+			  struct v4l2_streamparm *parm)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (parm->type != (dev->multiplanar ?
+			   V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
+			   V4L2_BUF_TYPE_VIDEO_CAPTURE))
+		return -EINVAL;
+
+	parm->parm.capture.capability   = V4L2_CAP_TIMEPERFRAME;
+	parm->parm.capture.timeperframe = dev->timeperframe_vid_cap;
+	parm->parm.capture.readbuffers  = 1;
+	return 0;
+}
+
+#define FRACT_CMP(a, OP, b)	\
+	((u64)(a).numerator * (b).denominator  OP  (u64)(b).numerator * (a).denominator)
+
+int vivid_vid_cap_s_parm(struct file *file, void *priv,
+			  struct v4l2_streamparm *parm)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	unsigned ival_sz = 2 * (3 - dev->webcam_size_idx);
+	struct v4l2_fract tpf;
+	unsigned i;
+
+	if (parm->type != (dev->multiplanar ?
+			   V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
+			   V4L2_BUF_TYPE_VIDEO_CAPTURE))
+		return -EINVAL;
+	if (!vivid_is_webcam(dev))
+		return vivid_vid_cap_g_parm(file, priv, parm);
+
+	tpf = parm->parm.capture.timeperframe;
+
+	if (tpf.denominator == 0)
+		tpf = webcam_intervals[ival_sz - 1];
+	for (i = 0; i < ival_sz; i++)
+		if (FRACT_CMP(tpf, >=, webcam_intervals[i]))
+			break;
+	if (i == ival_sz)
+		i = ival_sz - 1;
+	dev->webcam_ival_idx = i;
+	tpf = webcam_intervals[dev->webcam_ival_idx];
+	tpf = FRACT_CMP(tpf, <, tpf_min) ? tpf_min : tpf;
+	tpf = FRACT_CMP(tpf, >, tpf_max) ? tpf_max : tpf;
+
+	/* resync the thread's timings */
+	dev->cap_seq_resync = true;
+	dev->timeperframe_vid_cap = tpf;
+	parm->parm.capture.timeperframe = tpf;
+	parm->parm.capture.readbuffers  = 1;
+	return 0;
+}
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.h b/drivers/media/platform/vivid/vivid-vid-cap.h
new file mode 100644
index 0000000..9407981
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-vid-cap.h
@@ -0,0 +1,71 @@
+/*
+ * vivid-vid-cap.h - video capture support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _VIVID_VID_CAP_H_
+#define _VIVID_VID_CAP_H_
+
+void vivid_update_quality(struct vivid_dev *dev);
+void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls);
+enum tpg_video_aspect vivid_get_video_aspect(const struct vivid_dev *dev);
+
+extern const v4l2_std_id vivid_standard[];
+extern const char * const vivid_ctrl_standard_strings[];
+
+extern const struct vb2_ops vivid_vid_cap_qops;
+
+int vivid_g_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f);
+int vivid_try_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f);
+int vivid_s_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_g_fmt_vid_cap_mplane(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_try_fmt_vid_cap_mplane(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_s_fmt_vid_cap_mplane(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_g_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_try_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_s_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f);
+int vivid_vid_cap_g_selection(struct file *file, void *priv, struct v4l2_selection *sel);
+int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection *s);
+int vivid_vid_cap_cropcap(struct file *file, void *priv, struct v4l2_cropcap *cap);
+int vidioc_enum_fmt_vid_overlay(struct file *file, void  *priv, struct v4l2_fmtdesc *f);
+int vidioc_g_fmt_vid_overlay(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_try_fmt_vid_overlay(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_s_fmt_vid_overlay(struct file *file, void *priv, struct v4l2_format *f);
+int vivid_vid_cap_overlay(struct file *file, void *fh, unsigned i);
+int vivid_vid_cap_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *a);
+int vivid_vid_cap_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuffer *a);
+int vidioc_enum_input(struct file *file, void *priv, struct v4l2_input *inp);
+int vidioc_g_input(struct file *file, void *priv, unsigned *i);
+int vidioc_s_input(struct file *file, void *priv, unsigned i);
+int vidioc_enumaudio(struct file *file, void *fh, struct v4l2_audio *vin);
+int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *vin);
+int vidioc_s_audio(struct file *file, void *fh, const struct v4l2_audio *vin);
+int vivid_video_g_frequency(struct file *file, void *fh, struct v4l2_frequency *vf);
+int vivid_video_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *vf);
+int vivid_video_s_tuner(struct file *file, void *fh, const struct v4l2_tuner *vt);
+int vivid_video_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt);
+int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *id);
+int vivid_vid_cap_s_std(struct file *file, void *priv, v4l2_std_id id);
+int vivid_vid_cap_s_dv_timings(struct file *file, void *_fh, struct v4l2_dv_timings *timings);
+int vidioc_query_dv_timings(struct file *file, void *_fh, struct v4l2_dv_timings *timings);
+int vidioc_s_edid(struct file *file, void *_fh, struct v4l2_edid *edid);
+int vidioc_enum_framesizes(struct file *file, void *fh, struct v4l2_frmsizeenum *fsize);
+int vidioc_enum_frameintervals(struct file *file, void *priv, struct v4l2_frmivalenum *fival);
+int vivid_vid_cap_g_parm(struct file *file, void *priv, struct v4l2_streamparm *parm);
+int vivid_vid_cap_s_parm(struct file *file, void *priv, struct v4l2_streamparm *parm);
+
+#endif
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
new file mode 100644
index 0000000..7b981c1
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -0,0 +1,571 @@
+/*
+ * vivid-vid-common.c - common video support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/videodev2.h>
+#include <linux/v4l2-dv-timings.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-dv-timings.h>
+
+#include "vivid-core.h"
+#include "vivid-vid-common.h"
+
+const struct v4l2_dv_timings_cap vivid_dv_timings_cap = {
+	.type = V4L2_DV_BT_656_1120,
+	/* keep this initialization for compatibility with GCC < 4.4.6 */
+	.reserved = { 0 },
+	V4L2_INIT_BT_TIMINGS(0, MAX_WIDTH, 0, MAX_HEIGHT, 25000000, 600000000,
+		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT,
+		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_INTERLACED)
+};
+
+/* ------------------------------------------------------------------
+	Basic structures
+   ------------------------------------------------------------------*/
+
+struct vivid_fmt vivid_formats[] = {
+	{
+		.name     = "4:2:2, packed, YUYV",
+		.fourcc   = V4L2_PIX_FMT_YUYV,
+		.depth    = 16,
+		.is_yuv   = true,
+		.planes   = 1,
+		.data_offset = { PLANE0_DATA_OFFSET, 0 },
+	},
+	{
+		.name     = "4:2:2, packed, UYVY",
+		.fourcc   = V4L2_PIX_FMT_UYVY,
+		.depth    = 16,
+		.is_yuv   = true,
+		.planes   = 1,
+	},
+	{
+		.name     = "4:2:2, packed, YVYU",
+		.fourcc   = V4L2_PIX_FMT_YVYU,
+		.depth    = 16,
+		.is_yuv   = true,
+		.planes   = 1,
+	},
+	{
+		.name     = "4:2:2, packed, VYUY",
+		.fourcc   = V4L2_PIX_FMT_VYUY,
+		.depth    = 16,
+		.is_yuv   = true,
+		.planes   = 1,
+	},
+	{
+		.name     = "RGB565 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
+		.depth    = 16,
+		.planes   = 1,
+		.can_do_overlay = true,
+	},
+	{
+		.name     = "RGB565 (BE)",
+		.fourcc   = V4L2_PIX_FMT_RGB565X, /* rrrrrggg gggbbbbb */
+		.depth    = 16,
+		.planes   = 1,
+		.can_do_overlay = true,
+	},
+	{
+		.name     = "RGB555 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB555, /* gggbbbbb arrrrrgg */
+		.depth    = 16,
+		.planes   = 1,
+		.can_do_overlay = true,
+	},
+	{
+		.name     = "XRGB555 (LE)",
+		.fourcc   = V4L2_PIX_FMT_XRGB555, /* gggbbbbb arrrrrgg */
+		.depth    = 16,
+		.planes   = 1,
+		.can_do_overlay = true,
+	},
+	{
+		.name     = "ARGB555 (LE)",
+		.fourcc   = V4L2_PIX_FMT_ARGB555, /* gggbbbbb arrrrrgg */
+		.depth    = 16,
+		.planes   = 1,
+		.can_do_overlay = true,
+		.alpha_mask = 0x8000,
+	},
+	{
+		.name     = "RGB555 (BE)",
+		.fourcc   = V4L2_PIX_FMT_RGB555X, /* arrrrrgg gggbbbbb */
+		.depth    = 16,
+		.planes   = 1,
+		.can_do_overlay = true,
+	},
+	{
+		.name     = "RGB24 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB24, /* rgb */
+		.depth    = 24,
+		.planes   = 1,
+	},
+	{
+		.name     = "RGB24 (BE)",
+		.fourcc   = V4L2_PIX_FMT_BGR24, /* bgr */
+		.depth    = 24,
+		.planes   = 1,
+	},
+	{
+		.name     = "RGB32 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB32, /* argb */
+		.depth    = 32,
+		.planes   = 1,
+	},
+	{
+		.name     = "RGB32 (BE)",
+		.fourcc   = V4L2_PIX_FMT_BGR32, /* bgra */
+		.depth    = 32,
+		.planes   = 1,
+	},
+	{
+		.name     = "XRGB32 (LE)",
+		.fourcc   = V4L2_PIX_FMT_XRGB32, /* argb */
+		.depth    = 32,
+		.planes   = 1,
+	},
+	{
+		.name     = "XRGB32 (BE)",
+		.fourcc   = V4L2_PIX_FMT_XBGR32, /* bgra */
+		.depth    = 32,
+		.planes   = 1,
+	},
+	{
+		.name     = "ARGB32 (LE)",
+		.fourcc   = V4L2_PIX_FMT_ARGB32, /* argb */
+		.depth    = 32,
+		.planes   = 1,
+		.alpha_mask = 0x000000ff,
+	},
+	{
+		.name     = "ARGB32 (BE)",
+		.fourcc   = V4L2_PIX_FMT_ABGR32, /* bgra */
+		.depth    = 32,
+		.planes   = 1,
+		.alpha_mask = 0xff000000,
+	},
+	{
+		.name     = "4:2:2, planar, YUV",
+		.fourcc   = V4L2_PIX_FMT_NV16M,
+		.depth    = 8,
+		.is_yuv   = true,
+		.planes   = 2,
+		.data_offset = { PLANE0_DATA_OFFSET, 0 },
+	},
+	{
+		.name     = "4:2:2, planar, YVU",
+		.fourcc   = V4L2_PIX_FMT_NV61M,
+		.depth    = 8,
+		.is_yuv   = true,
+		.planes   = 2,
+		.data_offset = { 0, PLANE0_DATA_OFFSET },
+	},
+};
+
+/* There are 2 multiplanar formats in the list */
+#define VIVID_MPLANAR_FORMATS 2
+
+const struct vivid_fmt *get_format(struct vivid_dev *dev, u32 pixelformat)
+{
+	const struct vivid_fmt *fmt;
+	unsigned k;
+
+	for (k = 0; k < ARRAY_SIZE(vivid_formats); k++) {
+		fmt = &vivid_formats[k];
+		if (fmt->fourcc == pixelformat)
+			if (fmt->planes == 1 || dev->multiplanar)
+				return fmt;
+	}
+
+	return NULL;
+}
+
+bool vivid_vid_can_loop(struct vivid_dev *dev)
+{
+	if (dev->src_rect.width != dev->sink_rect.width ||
+	    dev->src_rect.height != dev->sink_rect.height)
+		return false;
+	if (dev->fmt_cap->fourcc != dev->fmt_out->fourcc)
+		return false;
+	if (dev->field_cap != dev->field_out)
+		return false;
+	if (vivid_is_svid_cap(dev) && vivid_is_svid_out(dev)) {
+		if (!(dev->std_cap & V4L2_STD_525_60) !=
+		    !(dev->std_out & V4L2_STD_525_60))
+			return false;
+		return true;
+	}
+	if (vivid_is_hdmi_cap(dev) && vivid_is_hdmi_out(dev))
+		return true;
+	return false;
+}
+
+void vivid_send_source_change(struct vivid_dev *dev, unsigned type)
+{
+	struct v4l2_event ev = {
+		.type = V4L2_EVENT_SOURCE_CHANGE,
+		.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+	};
+	unsigned i;
+
+	for (i = 0; i < dev->num_inputs; i++) {
+		ev.id = i;
+		if (dev->input_type[i] == type) {
+			if (video_is_registered(&dev->vid_cap_dev) && dev->has_vid_cap)
+				v4l2_event_queue(&dev->vid_cap_dev, &ev);
+			if (video_is_registered(&dev->vbi_cap_dev) && dev->has_vbi_cap)
+				v4l2_event_queue(&dev->vbi_cap_dev, &ev);
+		}
+	}
+}
+
+/*
+ * Conversion function that converts a single-planar format to a
+ * single-plane multiplanar format.
+ */
+void fmt_sp2mp(const struct v4l2_format *sp_fmt, struct v4l2_format *mp_fmt)
+{
+	struct v4l2_pix_format_mplane *mp = &mp_fmt->fmt.pix_mp;
+	struct v4l2_plane_pix_format *ppix = &mp->plane_fmt[0];
+	const struct v4l2_pix_format *pix = &sp_fmt->fmt.pix;
+	bool is_out = sp_fmt->type == V4L2_BUF_TYPE_VIDEO_OUTPUT;
+
+	memset(mp->reserved, 0, sizeof(mp->reserved));
+	mp_fmt->type = is_out ? V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
+			   V4L2_CAP_VIDEO_CAPTURE_MPLANE;
+	mp->width = pix->width;
+	mp->height = pix->height;
+	mp->pixelformat = pix->pixelformat;
+	mp->field = pix->field;
+	mp->colorspace = pix->colorspace;
+	mp->num_planes = 1;
+	mp->flags = pix->flags;
+	ppix->sizeimage = pix->sizeimage;
+	ppix->bytesperline = pix->bytesperline;
+	memset(ppix->reserved, 0, sizeof(ppix->reserved));
+}
+
+int fmt_sp2mp_func(struct file *file, void *priv,
+		struct v4l2_format *f, fmtfunc func)
+{
+	struct v4l2_format fmt;
+	struct v4l2_pix_format_mplane *mp = &fmt.fmt.pix_mp;
+	struct v4l2_plane_pix_format *ppix = &mp->plane_fmt[0];
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	int ret;
+
+	/* Converts to a mplane format */
+	fmt_sp2mp(f, &fmt);
+	/* Passes it to the generic mplane format function */
+	ret = func(file, priv, &fmt);
+	/* Copies back the mplane data to the single plane format */
+	pix->width = mp->width;
+	pix->height = mp->height;
+	pix->pixelformat = mp->pixelformat;
+	pix->field = mp->field;
+	pix->colorspace = mp->colorspace;
+	pix->sizeimage = ppix->sizeimage;
+	pix->bytesperline = ppix->bytesperline;
+	pix->flags = mp->flags;
+	return ret;
+}
+
+/* v4l2_rect helper function: copy the width/height values */
+void rect_set_size_to(struct v4l2_rect *r, const struct v4l2_rect *size)
+{
+	r->width = size->width;
+	r->height = size->height;
+}
+
+/* v4l2_rect helper function: width and height of r should be >= min_size */
+void rect_set_min_size(struct v4l2_rect *r, const struct v4l2_rect *min_size)
+{
+	if (r->width < min_size->width)
+		r->width = min_size->width;
+	if (r->height < min_size->height)
+		r->height = min_size->height;
+}
+
+/* v4l2_rect helper function: width and height of r should be <= max_size */
+void rect_set_max_size(struct v4l2_rect *r, const struct v4l2_rect *max_size)
+{
+	if (r->width > max_size->width)
+		r->width = max_size->width;
+	if (r->height > max_size->height)
+		r->height = max_size->height;
+}
+
+/* v4l2_rect helper function: r should be inside boundary */
+void rect_map_inside(struct v4l2_rect *r, const struct v4l2_rect *boundary)
+{
+	rect_set_max_size(r, boundary);
+	if (r->left < boundary->left)
+		r->left = boundary->left;
+	if (r->top < boundary->top)
+		r->top = boundary->top;
+	if (r->left + r->width > boundary->width)
+		r->left = boundary->width - r->width;
+	if (r->top + r->height > boundary->height)
+		r->top = boundary->height - r->height;
+}
+
+/* v4l2_rect helper function: return true if r1 has the same size as r2 */
+bool rect_same_size(const struct v4l2_rect *r1, const struct v4l2_rect *r2)
+{
+	return r1->width == r2->width && r1->height == r2->height;
+}
+
+/* v4l2_rect helper function: calculate the intersection of two rects */
+struct v4l2_rect rect_intersect(const struct v4l2_rect *a, const struct v4l2_rect *b)
+{
+	struct v4l2_rect r;
+	int right, bottom;
+
+	r.top = max(a->top, b->top);
+	r.left = max(a->left, b->left);
+	bottom = min(a->top + a->height, b->top + b->height);
+	right = min(a->left + a->width, b->left + b->width);
+	r.height = max(0, bottom - r.top);
+	r.width = max(0, right - r.left);
+	return r;
+}
+
+/*
+ * v4l2_rect helper function: scale rect r by to->width / from->width and
+ * to->height / from->height.
+ */
+void rect_scale(struct v4l2_rect *r, const struct v4l2_rect *from,
+				     const struct v4l2_rect *to)
+{
+	if (from->width == 0 || from->height == 0) {
+		r->left = r->top = r->width = r->height = 0;
+		return;
+	}
+	r->left = (((r->left - from->left) * to->width) / from->width) & ~1;
+	r->width = ((r->width * to->width) / from->width) & ~1;
+	r->top = ((r->top - from->top) * to->height) / from->height;
+	r->height = (r->height * to->height) / from->height;
+}
+
+bool rect_overlap(const struct v4l2_rect *r1, const struct v4l2_rect *r2)
+{
+	/*
+	 * IF the left side of r1 is to the right of the right side of r2 OR
+	 *    the left side of r2 is to the right of the right side of r1 THEN
+	 * they do not overlap.
+	 */
+	if (r1->left >= r2->left + r2->width ||
+	    r2->left >= r1->left + r1->width)
+		return false;
+	/*
+	 * IF the top side of r1 is below the bottom of r2 OR
+	 *    the top side of r2 is below the bottom of r1 THEN
+	 * they do not overlap.
+	 */
+	if (r1->top >= r2->top + r2->height ||
+	    r2->top >= r1->top + r1->height)
+		return false;
+	return true;
+}
+int vivid_vid_adjust_sel(unsigned flags, struct v4l2_rect *r)
+{
+	unsigned w = r->width;
+	unsigned h = r->height;
+
+	if (!(flags & V4L2_SEL_FLAG_LE)) {
+		w++;
+		h++;
+		if (w < 2)
+			w = 2;
+		if (h < 2)
+			h = 2;
+	}
+	if (!(flags & V4L2_SEL_FLAG_GE)) {
+		if (w > MAX_WIDTH)
+			w = MAX_WIDTH;
+		if (h > MAX_HEIGHT)
+			h = MAX_HEIGHT;
+	}
+	w = w & ~1;
+	h = h & ~1;
+	if (w < 2 || h < 2)
+		return -ERANGE;
+	if (w > MAX_WIDTH || h > MAX_HEIGHT)
+		return -ERANGE;
+	if (r->top < 0)
+		r->top = 0;
+	if (r->left < 0)
+		r->left = 0;
+	r->left &= ~1;
+	r->top &= ~1;
+	if (r->left + w > MAX_WIDTH)
+		r->left = MAX_WIDTH - w;
+	if (r->top + h > MAX_HEIGHT)
+		r->top = MAX_HEIGHT - h;
+	if ((flags & (V4L2_SEL_FLAG_GE | V4L2_SEL_FLAG_LE)) ==
+			(V4L2_SEL_FLAG_GE | V4L2_SEL_FLAG_LE) &&
+	    (r->width != w || r->height != h))
+		return -ERANGE;
+	r->width = w;
+	r->height = h;
+	return 0;
+}
+
+int vivid_enum_fmt_vid(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	const struct vivid_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(vivid_formats) -
+	    (dev->multiplanar ? 0 : VIVID_MPLANAR_FORMATS))
+		return -EINVAL;
+
+	fmt = &vivid_formats[f->index];
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+int vidioc_enum_fmt_vid_mplane(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!dev->multiplanar)
+		return -ENOTTY;
+	return vivid_enum_fmt_vid(file, priv, f);
+}
+
+int vidioc_enum_fmt_vid(struct file *file, void  *priv,
+					struct v4l2_fmtdesc *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+	return vivid_enum_fmt_vid(file, priv, f);
+}
+
+int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX) {
+		if (!vivid_is_sdtv_cap(dev))
+			return -ENODATA;
+		*id = dev->std_cap;
+	} else {
+		if (!vivid_is_svid_out(dev))
+			return -ENODATA;
+		*id = dev->std_out;
+	}
+	return 0;
+}
+
+int vidioc_g_dv_timings(struct file *file, void *_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX) {
+		if (!vivid_is_hdmi_cap(dev))
+			return -ENODATA;
+		*timings = dev->dv_timings_cap;
+	} else {
+		if (!vivid_is_hdmi_out(dev))
+			return -ENODATA;
+		*timings = dev->dv_timings_out;
+	}
+	return 0;
+}
+
+int vidioc_enum_dv_timings(struct file *file, void *_fh,
+				    struct v4l2_enum_dv_timings *timings)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX) {
+		if (!vivid_is_hdmi_cap(dev))
+			return -ENODATA;
+	} else {
+		if (!vivid_is_hdmi_out(dev))
+			return -ENODATA;
+	}
+	return v4l2_enum_dv_timings_cap(timings, &vivid_dv_timings_cap,
+			NULL, NULL);
+}
+
+int vidioc_dv_timings_cap(struct file *file, void *_fh,
+				    struct v4l2_dv_timings_cap *cap)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX) {
+		if (!vivid_is_hdmi_cap(dev))
+			return -ENODATA;
+	} else {
+		if (!vivid_is_hdmi_out(dev))
+			return -ENODATA;
+	}
+	*cap = vivid_dv_timings_cap;
+	return 0;
+}
+
+int vidioc_g_edid(struct file *file, void *_fh,
+			 struct v4l2_edid *edid)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
+
+	memset(edid->reserved, 0, sizeof(edid->reserved));
+	if (vdev->vfl_dir == VFL_DIR_RX) {
+		if (edid->pad >= dev->num_inputs)
+			return -EINVAL;
+		if (dev->input_type[edid->pad] != HDMI)
+			return -EINVAL;
+	} else {
+		if (edid->pad >= dev->num_outputs)
+			return -EINVAL;
+		if (dev->output_type[edid->pad] != HDMI)
+			return -EINVAL;
+	}
+	if (edid->start_block == 0 && edid->blocks == 0) {
+		edid->blocks = dev->edid_blocks;
+		return 0;
+	}
+	if (dev->edid_blocks == 0)
+		return -ENODATA;
+	if (edid->start_block >= dev->edid_blocks)
+		return -EINVAL;
+	if (edid->start_block + edid->blocks > dev->edid_blocks)
+		edid->blocks = dev->edid_blocks - edid->start_block;
+	memcpy(edid->edid, dev->edid, edid->blocks * 128);
+	return 0;
+}
diff --git a/drivers/media/platform/vivid/vivid-vid-common.h b/drivers/media/platform/vivid/vivid-vid-common.h
new file mode 100644
index 0000000..9563c32
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-vid-common.h
@@ -0,0 +1,61 @@
+/*
+ * vivid-vid-common.h - common video support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _VIVID_VID_COMMON_H_
+#define _VIVID_VID_COMMON_H_
+
+typedef int (*fmtfunc)(struct file *file, void *priv, struct v4l2_format *f);
+
+/*
+ * Conversion function that converts a single-planar format to a
+ * single-plane multiplanar format.
+ */
+void fmt_sp2mp(const struct v4l2_format *sp_fmt, struct v4l2_format *mp_fmt);
+int fmt_sp2mp_func(struct file *file, void *priv,
+		struct v4l2_format *f, fmtfunc func);
+
+extern const struct v4l2_dv_timings_cap vivid_dv_timings_cap;
+
+const struct vivid_fmt *get_format(struct vivid_dev *dev, u32 pixelformat);
+
+bool vivid_vid_can_loop(struct vivid_dev *dev);
+void vivid_send_source_change(struct vivid_dev *dev, unsigned type);
+
+bool rect_overlap(const struct v4l2_rect *r1, const struct v4l2_rect *r2);
+void rect_set_size_to(struct v4l2_rect *r, const struct v4l2_rect *size);
+void rect_set_min_size(struct v4l2_rect *r, const struct v4l2_rect *min_size);
+void rect_set_max_size(struct v4l2_rect *r, const struct v4l2_rect *max_size);
+void rect_map_inside(struct v4l2_rect *r, const struct v4l2_rect *boundary);
+bool rect_same_size(const struct v4l2_rect *r1, const struct v4l2_rect *r2);
+struct v4l2_rect rect_intersect(const struct v4l2_rect *a, const struct v4l2_rect *b);
+void rect_scale(struct v4l2_rect *r, const struct v4l2_rect *from,
+				     const struct v4l2_rect *to);
+int vivid_vid_adjust_sel(unsigned flags, struct v4l2_rect *r);
+
+int vivid_enum_fmt_vid(struct file *file, void  *priv, struct v4l2_fmtdesc *f);
+int vidioc_enum_fmt_vid_mplane(struct file *file, void  *priv, struct v4l2_fmtdesc *f);
+int vidioc_enum_fmt_vid(struct file *file, void  *priv, struct v4l2_fmtdesc *f);
+int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id);
+int vidioc_g_dv_timings(struct file *file, void *_fh, struct v4l2_dv_timings *timings);
+int vidioc_enum_dv_timings(struct file *file, void *_fh, struct v4l2_enum_dv_timings *timings);
+int vidioc_dv_timings_cap(struct file *file, void *_fh, struct v4l2_dv_timings_cap *cap);
+int vidioc_g_edid(struct file *file, void *_fh, struct v4l2_edid *edid);
+int vidioc_subscribe_event(struct v4l2_fh *fh, const struct v4l2_event_subscription *sub);
+
+#endif
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
new file mode 100644
index 0000000..3078bd2
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -0,0 +1,1205 @@
+/*
+ * vivid-vid-out.c - video output support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/videodev2.h>
+#include <linux/v4l2-dv-timings.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-dv-timings.h>
+
+#include "vivid-core.h"
+#include "vivid-vid-common.h"
+#include "vivid-kthread-out.h"
+#include "vivid-vid-out.h"
+
+static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+		       unsigned *nbuffers, unsigned *nplanes,
+		       unsigned sizes[], void *alloc_ctxs[])
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+	unsigned planes = dev->fmt_out->planes;
+	unsigned h = dev->fmt_out_rect.height;
+	unsigned size = dev->bytesperline_out[0] * h;
+
+	if (dev->field_out == V4L2_FIELD_ALTERNATE) {
+		/*
+		 * You cannot use write() with FIELD_ALTERNATE since the field
+		 * information (TOP/BOTTOM) cannot be passed to the kernel.
+		 */
+		if (vb2_fileio_is_active(vq))
+			return -EINVAL;
+	}
+
+	if (dev->queue_setup_error) {
+		/*
+		 * Error injection: test what happens if queue_setup() returns
+		 * an error.
+		 */
+		dev->queue_setup_error = false;
+		return -EINVAL;
+	}
+
+	if (fmt) {
+		const struct v4l2_pix_format_mplane *mp;
+		struct v4l2_format mp_fmt;
+
+		if (!V4L2_TYPE_IS_MULTIPLANAR(fmt->type)) {
+			fmt_sp2mp(fmt, &mp_fmt);
+			fmt = &mp_fmt;
+		}
+		mp = &fmt->fmt.pix_mp;
+		/*
+		 * Check if the number of planes in the specified format match
+		 * the number of planes in the current format. You can't mix that.
+		 */
+		if (mp->num_planes != planes)
+			return -EINVAL;
+		sizes[0] = mp->plane_fmt[0].sizeimage;
+		if (planes == 2) {
+			sizes[1] = mp->plane_fmt[1].sizeimage;
+			if (sizes[0] < dev->bytesperline_out[0] * h ||
+			    sizes[1] < dev->bytesperline_out[1] * h)
+				return -EINVAL;
+		} else if (sizes[0] < size) {
+			return -EINVAL;
+		}
+	} else {
+		if (planes == 2) {
+			sizes[0] = dev->bytesperline_out[0] * h;
+			sizes[1] = dev->bytesperline_out[1] * h;
+		} else {
+			sizes[0] = size;
+		}
+	}
+
+	if (vq->num_buffers + *nbuffers < 2)
+		*nbuffers = 2 - vq->num_buffers;
+
+	*nplanes = planes;
+
+	/*
+	 * videobuf2-vmalloc allocator is context-less so no need to set
+	 * alloc_ctxs array.
+	 */
+
+	if (planes == 2)
+		dprintk(dev, 1, "%s, count=%d, sizes=%u, %u\n", __func__,
+			*nbuffers, sizes[0], sizes[1]);
+	else
+		dprintk(dev, 1, "%s, count=%d, size=%u\n", __func__,
+			*nbuffers, sizes[0]);
+	return 0;
+}
+
+static int vid_out_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long size;
+	unsigned planes = dev->fmt_out->planes;
+	unsigned p;
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	if (WARN_ON(NULL == dev->fmt_out))
+		return -EINVAL;
+
+	if (dev->buf_prepare_error) {
+		/*
+		 * Error injection: test what happens if buf_prepare() returns
+		 * an error.
+		 */
+		dev->buf_prepare_error = false;
+		return -EINVAL;
+	}
+
+	if (dev->field_out != V4L2_FIELD_ALTERNATE)
+		vb->v4l2_buf.field = dev->field_out;
+	else if (vb->v4l2_buf.field != V4L2_FIELD_TOP &&
+		 vb->v4l2_buf.field != V4L2_FIELD_BOTTOM)
+		return -EINVAL;
+
+	for (p = 0; p < planes; p++) {
+		size = dev->bytesperline_out[p] * dev->fmt_out_rect.height +
+			vb->v4l2_planes[p].data_offset;
+
+		if (vb2_get_plane_payload(vb, p) < size) {
+			dprintk(dev, 1, "%s the payload is too small for plane %u (%lu < %lu)\n",
+					__func__, p, vb2_get_plane_payload(vb, p), size);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static void vid_out_buf_queue(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	spin_lock(&dev->slock);
+	list_add_tail(&buf->list, &dev->vid_out_active);
+	spin_unlock(&dev->slock);
+}
+
+static int vid_out_start_streaming(struct vb2_queue *vq, unsigned count)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+	int err;
+
+	if (vb2_is_streaming(&dev->vb_vid_cap_q))
+		dev->can_loop_video = vivid_vid_can_loop(dev);
+
+	if (dev->kthread_vid_out)
+		return 0;
+
+	dev->vid_out_seq_count = 0;
+	dprintk(dev, 1, "%s\n", __func__);
+	if (dev->start_streaming_error) {
+		dev->start_streaming_error = false;
+		err = -EINVAL;
+	} else {
+		err = vivid_start_generating_vid_out(dev, &dev->vid_out_streaming);
+	}
+	if (err) {
+		struct vivid_buffer *buf, *tmp;
+
+		list_for_each_entry_safe(buf, tmp, &dev->vid_out_active, list) {
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		}
+	}
+	return err;
+}
+
+/* abort streaming and wait for last buffer */
+static void vid_out_stop_streaming(struct vb2_queue *vq)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+
+	dprintk(dev, 1, "%s\n", __func__);
+	vivid_stop_generating_vid_out(dev, &dev->vid_out_streaming);
+	dev->can_loop_video = false;
+}
+
+const struct vb2_ops vivid_vid_out_qops = {
+	.queue_setup		= vid_out_queue_setup,
+	.buf_prepare		= vid_out_buf_prepare,
+	.buf_queue		= vid_out_buf_queue,
+	.start_streaming	= vid_out_start_streaming,
+	.stop_streaming		= vid_out_stop_streaming,
+	.wait_prepare		= vivid_unlock,
+	.wait_finish		= vivid_lock,
+};
+
+/*
+ * Called whenever the format has to be reset which can occur when
+ * changing outputs, standard, timings, etc.
+ */
+void vivid_update_format_out(struct vivid_dev *dev)
+{
+	struct v4l2_bt_timings *bt = &dev->dv_timings_out.bt;
+	unsigned size;
+
+	switch (dev->output_type[dev->output]) {
+	case SVID:
+	default:
+		dev->field_out = dev->tv_field_out;
+		dev->sink_rect.width = 720;
+		if (dev->std_out & V4L2_STD_525_60) {
+			dev->sink_rect.height = 480;
+			dev->timeperframe_vid_out = (struct v4l2_fract) { 1001, 30000 };
+			dev->service_set_out = V4L2_SLICED_CAPTION_525;
+		} else {
+			dev->sink_rect.height = 576;
+			dev->timeperframe_vid_out = (struct v4l2_fract) { 1000, 25000 };
+			dev->service_set_out = V4L2_SLICED_WSS_625;
+		}
+		dev->colorspace_out = V4L2_COLORSPACE_SMPTE170M;
+		break;
+	case HDMI:
+		dev->sink_rect.width = bt->width;
+		dev->sink_rect.height = bt->height;
+		size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
+		dev->timeperframe_vid_out = (struct v4l2_fract) {
+			size / 100, (u32)bt->pixelclock / 100
+		};
+		if (bt->interlaced)
+			dev->field_out = V4L2_FIELD_ALTERNATE;
+		else
+			dev->field_out = V4L2_FIELD_NONE;
+		if (!dev->dvi_d_out && (bt->standards & V4L2_DV_BT_STD_CEA861)) {
+			if (bt->width == 720 && bt->height <= 576)
+				dev->colorspace_out = V4L2_COLORSPACE_SMPTE170M;
+			else
+				dev->colorspace_out = V4L2_COLORSPACE_REC709;
+		} else {
+			dev->colorspace_out = V4L2_COLORSPACE_SRGB;
+		}
+		break;
+	}
+	dev->compose_out = dev->sink_rect;
+	dev->compose_bounds_out = dev->sink_rect;
+	dev->crop_out = dev->compose_out;
+	if (V4L2_FIELD_HAS_T_OR_B(dev->field_out))
+		dev->crop_out.height /= 2;
+	dev->fmt_out_rect = dev->crop_out;
+	dev->bytesperline_out[0] = (dev->sink_rect.width * dev->fmt_out->depth) / 8;
+	if (dev->fmt_out->planes == 2)
+		dev->bytesperline_out[1] = (dev->sink_rect.width * dev->fmt_out->depth) / 8;
+}
+
+/* Map the field to something that is valid for the current output */
+static enum v4l2_field vivid_field_out(struct vivid_dev *dev, enum v4l2_field field)
+{
+	if (vivid_is_svid_out(dev)) {
+		switch (field) {
+		case V4L2_FIELD_INTERLACED_TB:
+		case V4L2_FIELD_INTERLACED_BT:
+		case V4L2_FIELD_SEQ_TB:
+		case V4L2_FIELD_SEQ_BT:
+		case V4L2_FIELD_ALTERNATE:
+			return field;
+		case V4L2_FIELD_INTERLACED:
+		default:
+			return V4L2_FIELD_INTERLACED;
+		}
+	}
+	if (vivid_is_hdmi_out(dev))
+		return dev->dv_timings_out.bt.interlaced ? V4L2_FIELD_ALTERNATE :
+						       V4L2_FIELD_NONE;
+	return V4L2_FIELD_NONE;
+}
+
+static enum tpg_pixel_aspect vivid_get_pixel_aspect(const struct vivid_dev *dev)
+{
+	if (vivid_is_svid_out(dev))
+		return (dev->std_out & V4L2_STD_525_60) ?
+			TPG_PIXEL_ASPECT_NTSC : TPG_PIXEL_ASPECT_PAL;
+
+	if (vivid_is_hdmi_out(dev) &&
+	    dev->sink_rect.width == 720 && dev->sink_rect.height <= 576)
+		return dev->sink_rect.height == 480 ?
+			TPG_PIXEL_ASPECT_NTSC : TPG_PIXEL_ASPECT_PAL;
+
+	return TPG_PIXEL_ASPECT_SQUARE;
+}
+
+int vivid_g_fmt_vid_out(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+	unsigned p;
+
+	mp->width        = dev->fmt_out_rect.width;
+	mp->height       = dev->fmt_out_rect.height;
+	mp->field        = dev->field_out;
+	mp->pixelformat  = dev->fmt_out->fourcc;
+	mp->colorspace   = dev->colorspace_out;
+	mp->num_planes = dev->fmt_out->planes;
+	for (p = 0; p < mp->num_planes; p++) {
+		mp->plane_fmt[p].bytesperline = dev->bytesperline_out[p];
+		mp->plane_fmt[p].sizeimage =
+			mp->plane_fmt[p].bytesperline * mp->height;
+	}
+	return 0;
+}
+
+int vivid_try_fmt_vid_out(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_bt_timings *bt = &dev->dv_timings_out.bt;
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+	struct v4l2_plane_pix_format *pfmt = mp->plane_fmt;
+	const struct vivid_fmt *fmt;
+	unsigned bytesperline, max_bpl;
+	unsigned factor = 1;
+	unsigned w, h;
+	unsigned p;
+
+	fmt = get_format(dev, mp->pixelformat);
+	if (!fmt) {
+		dprintk(dev, 1, "Fourcc format (0x%08x) unknown.\n",
+			mp->pixelformat);
+		mp->pixelformat = V4L2_PIX_FMT_YUYV;
+		fmt = get_format(dev, mp->pixelformat);
+	}
+
+	mp->field = vivid_field_out(dev, mp->field);
+	if (vivid_is_svid_out(dev)) {
+		w = 720;
+		h = (dev->std_out & V4L2_STD_525_60) ? 480 : 576;
+	} else {
+		w = dev->sink_rect.width;
+		h = dev->sink_rect.height;
+	}
+	if (V4L2_FIELD_HAS_T_OR_B(mp->field))
+		factor = 2;
+	if (!dev->has_scaler_out && !dev->has_crop_out && !dev->has_compose_out) {
+		mp->width = w;
+		mp->height = h / factor;
+	} else {
+		struct v4l2_rect r = { 0, 0, mp->width, mp->height * factor };
+
+		rect_set_min_size(&r, &vivid_min_rect);
+		rect_set_max_size(&r, &vivid_max_rect);
+		if (dev->has_scaler_out && !dev->has_crop_out) {
+			struct v4l2_rect max_r = { 0, 0, MAX_ZOOM * w, MAX_ZOOM * h };
+
+			rect_set_max_size(&r, &max_r);
+		} else if (!dev->has_scaler_out && dev->has_compose_out && !dev->has_crop_out) {
+			rect_set_max_size(&r, &dev->sink_rect);
+		} else if (!dev->has_scaler_out && !dev->has_compose_out) {
+			rect_set_min_size(&r, &dev->sink_rect);
+		}
+		mp->width = r.width;
+		mp->height = r.height / factor;
+	}
+
+	/* This driver supports custom bytesperline values */
+
+	/* Calculate the minimum supported bytesperline value */
+	bytesperline = (mp->width * fmt->depth) >> 3;
+	/* Calculate the maximum supported bytesperline value */
+	max_bpl = (MAX_ZOOM * MAX_WIDTH * fmt->depth) >> 3;
+	mp->num_planes = fmt->planes;
+	for (p = 0; p < mp->num_planes; p++) {
+		if (pfmt[p].bytesperline > max_bpl)
+			pfmt[p].bytesperline = max_bpl;
+		if (pfmt[p].bytesperline < bytesperline)
+			pfmt[p].bytesperline = bytesperline;
+		pfmt[p].sizeimage = pfmt[p].bytesperline * mp->height;
+		memset(pfmt[p].reserved, 0, sizeof(pfmt[p].reserved));
+	}
+	if (vivid_is_svid_out(dev))
+		mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	else if (dev->dvi_d_out || !(bt->standards & V4L2_DV_BT_STD_CEA861))
+		mp->colorspace = V4L2_COLORSPACE_SRGB;
+	else if (bt->width == 720 && bt->height <= 576)
+		mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	else if (mp->colorspace != V4L2_COLORSPACE_SMPTE170M &&
+		 mp->colorspace != V4L2_COLORSPACE_REC709 &&
+		 mp->colorspace != V4L2_COLORSPACE_SRGB)
+		mp->colorspace = V4L2_COLORSPACE_REC709;
+	memset(mp->reserved, 0, sizeof(mp->reserved));
+	return 0;
+}
+
+int vivid_s_fmt_vid_out(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *mp = &f->fmt.pix_mp;
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_rect *crop = &dev->crop_out;
+	struct v4l2_rect *compose = &dev->compose_out;
+	struct vb2_queue *q = &dev->vb_vid_out_q;
+	int ret = vivid_try_fmt_vid_out(file, priv, f);
+	unsigned factor = 1;
+
+	if (ret < 0)
+		return ret;
+
+	if (vb2_is_busy(q) &&
+	    (vivid_is_svid_out(dev) ||
+	     mp->width != dev->fmt_out_rect.width ||
+	     mp->height != dev->fmt_out_rect.height ||
+	     mp->pixelformat != dev->fmt_out->fourcc ||
+	     mp->field != dev->field_out)) {
+		dprintk(dev, 1, "%s device busy\n", __func__);
+		return -EBUSY;
+	}
+
+	/*
+	 * Allow for changing the colorspace on the fly. Useful for testing
+	 * purposes, and it is something that HDMI transmitters are able
+	 * to do.
+	 */
+	if (vb2_is_busy(q))
+		goto set_colorspace;
+
+	dev->fmt_out = get_format(dev, mp->pixelformat);
+	if (V4L2_FIELD_HAS_T_OR_B(mp->field))
+		factor = 2;
+
+	if (dev->has_scaler_out || dev->has_crop_out || dev->has_compose_out) {
+		struct v4l2_rect r = { 0, 0, mp->width, mp->height };
+
+		if (dev->has_scaler_out) {
+			if (dev->has_crop_out)
+				rect_map_inside(crop, &r);
+			else
+				*crop = r;
+			if (dev->has_compose_out && !dev->has_crop_out) {
+				struct v4l2_rect min_r = {
+					0, 0,
+					r.width / MAX_ZOOM,
+					factor * r.height / MAX_ZOOM
+				};
+				struct v4l2_rect max_r = {
+					0, 0,
+					r.width * MAX_ZOOM,
+					factor * r.height * MAX_ZOOM
+				};
+
+				rect_set_min_size(compose, &min_r);
+				rect_set_max_size(compose, &max_r);
+				rect_map_inside(compose, &dev->compose_bounds_out);
+			} else if (dev->has_compose_out) {
+				struct v4l2_rect min_r = {
+					0, 0,
+					crop->width / MAX_ZOOM,
+					factor * crop->height / MAX_ZOOM
+				};
+				struct v4l2_rect max_r = {
+					0, 0,
+					crop->width * MAX_ZOOM,
+					factor * crop->height * MAX_ZOOM
+				};
+
+				rect_set_min_size(compose, &min_r);
+				rect_set_max_size(compose, &max_r);
+				rect_map_inside(compose, &dev->compose_bounds_out);
+			}
+		} else if (dev->has_compose_out && !dev->has_crop_out) {
+			rect_set_size_to(crop, &r);
+			r.height *= factor;
+			rect_set_size_to(compose, &r);
+			rect_map_inside(compose, &dev->compose_bounds_out);
+		} else if (!dev->has_compose_out) {
+			rect_map_inside(crop, &r);
+			r.height /= factor;
+			rect_set_size_to(compose, &r);
+		} else {
+			r.height *= factor;
+			rect_set_max_size(compose, &r);
+			rect_map_inside(compose, &dev->compose_bounds_out);
+			crop->top *= factor;
+			crop->height *= factor;
+			rect_set_size_to(crop, compose);
+			rect_map_inside(crop, &r);
+			crop->top /= factor;
+			crop->height /= factor;
+		}
+	} else {
+		struct v4l2_rect r = { 0, 0, mp->width, mp->height };
+
+		rect_set_size_to(crop, &r);
+		r.height /= factor;
+		rect_set_size_to(compose, &r);
+	}
+
+	dev->fmt_out_rect.width = mp->width;
+	dev->fmt_out_rect.height = mp->height;
+	dev->bytesperline_out[0] = mp->plane_fmt[0].bytesperline;
+	if (mp->num_planes > 1)
+		dev->bytesperline_out[1] = mp->plane_fmt[1].bytesperline;
+	dev->field_out = mp->field;
+	if (vivid_is_svid_out(dev))
+		dev->tv_field_out = mp->field;
+
+set_colorspace:
+	dev->colorspace_out = mp->colorspace;
+	if (dev->loop_video) {
+		vivid_send_source_change(dev, SVID);
+		vivid_send_source_change(dev, HDMI);
+	}
+	return 0;
+}
+
+int vidioc_g_fmt_vid_out_mplane(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!dev->multiplanar)
+		return -ENOTTY;
+	return vivid_g_fmt_vid_out(file, priv, f);
+}
+
+int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!dev->multiplanar)
+		return -ENOTTY;
+	return vivid_try_fmt_vid_out(file, priv, f);
+}
+
+int vidioc_s_fmt_vid_out_mplane(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!dev->multiplanar)
+		return -ENOTTY;
+	return vivid_s_fmt_vid_out(file, priv, f);
+}
+
+int vidioc_g_fmt_vid_out(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+	return fmt_sp2mp_func(file, priv, f, vivid_g_fmt_vid_out);
+}
+
+int vidioc_try_fmt_vid_out(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+	return fmt_sp2mp_func(file, priv, f, vivid_try_fmt_vid_out);
+}
+
+int vidioc_s_fmt_vid_out(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (dev->multiplanar)
+		return -ENOTTY;
+	return fmt_sp2mp_func(file, priv, f, vivid_s_fmt_vid_out);
+}
+
+int vivid_vid_out_g_selection(struct file *file, void *priv,
+			      struct v4l2_selection *sel)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!dev->has_crop_out && !dev->has_compose_out)
+		return -ENOTTY;
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL;
+
+	sel->r.left = sel->r.top = 0;
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP:
+		if (!dev->has_crop_out)
+			return -EINVAL;
+		sel->r = dev->crop_out;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		if (!dev->has_crop_out)
+			return -EINVAL;
+		sel->r = dev->fmt_out_rect;
+		break;
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		if (!dev->has_compose_out)
+			return -EINVAL;
+		sel->r = vivid_max_rect;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+		if (!dev->has_compose_out)
+			return -EINVAL;
+		sel->r = dev->compose_out;
+		break;
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		if (!dev->has_compose_out)
+			return -EINVAL;
+		sel->r = dev->sink_rect;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+int vivid_vid_out_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_rect *crop = &dev->crop_out;
+	struct v4l2_rect *compose = &dev->compose_out;
+	unsigned factor = V4L2_FIELD_HAS_T_OR_B(dev->field_out) ? 2 : 1;
+	int ret;
+
+	if (!dev->has_crop_out && !dev->has_compose_out)
+		return -ENOTTY;
+	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+		if (!dev->has_crop_out)
+			return -EINVAL;
+		ret = vivid_vid_adjust_sel(s->flags, &s->r);
+		if (ret)
+			return ret;
+		rect_set_min_size(&s->r, &vivid_min_rect);
+		rect_set_max_size(&s->r, &dev->fmt_out_rect);
+		if (dev->has_scaler_out) {
+			struct v4l2_rect max_rect = {
+				0, 0,
+				dev->sink_rect.width * MAX_ZOOM,
+				(dev->sink_rect.height / factor) * MAX_ZOOM
+			};
+
+			rect_set_max_size(&s->r, &max_rect);
+			if (dev->has_compose_out) {
+				struct v4l2_rect min_rect = {
+					0, 0,
+					s->r.width / MAX_ZOOM,
+					(s->r.height * factor) / MAX_ZOOM
+				};
+				struct v4l2_rect max_rect = {
+					0, 0,
+					s->r.width * MAX_ZOOM,
+					(s->r.height * factor) * MAX_ZOOM
+				};
+
+				rect_set_min_size(compose, &min_rect);
+				rect_set_max_size(compose, &max_rect);
+				rect_map_inside(compose, &dev->compose_bounds_out);
+			}
+		} else if (dev->has_compose_out) {
+			s->r.top *= factor;
+			s->r.height *= factor;
+			rect_set_max_size(&s->r, &dev->sink_rect);
+			rect_set_size_to(compose, &s->r);
+			rect_map_inside(compose, &dev->compose_bounds_out);
+			s->r.top /= factor;
+			s->r.height /= factor;
+		} else {
+			rect_set_size_to(&s->r, &dev->sink_rect);
+			s->r.height /= factor;
+		}
+		rect_map_inside(&s->r, &dev->fmt_out_rect);
+		*crop = s->r;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+		if (!dev->has_compose_out)
+			return -EINVAL;
+		ret = vivid_vid_adjust_sel(s->flags, &s->r);
+		if (ret)
+			return ret;
+		rect_set_min_size(&s->r, &vivid_min_rect);
+		rect_set_max_size(&s->r, &dev->sink_rect);
+		rect_map_inside(&s->r, &dev->compose_bounds_out);
+		s->r.top /= factor;
+		s->r.height /= factor;
+		if (dev->has_scaler_out) {
+			struct v4l2_rect fmt = dev->fmt_out_rect;
+			struct v4l2_rect max_rect = {
+				0, 0,
+				s->r.width * MAX_ZOOM,
+				s->r.height * MAX_ZOOM
+			};
+			struct v4l2_rect min_rect = {
+				0, 0,
+				s->r.width / MAX_ZOOM,
+				s->r.height / MAX_ZOOM
+			};
+
+			rect_set_min_size(&fmt, &min_rect);
+			if (!dev->has_crop_out)
+				rect_set_max_size(&fmt, &max_rect);
+			if (!rect_same_size(&dev->fmt_out_rect, &fmt) &&
+			    vb2_is_busy(&dev->vb_vid_out_q))
+				return -EBUSY;
+			if (dev->has_crop_out) {
+				rect_set_min_size(crop, &min_rect);
+				rect_set_max_size(crop, &max_rect);
+			}
+			dev->fmt_out_rect = fmt;
+		} else if (dev->has_crop_out) {
+			struct v4l2_rect fmt = dev->fmt_out_rect;
+
+			rect_set_min_size(&fmt, &s->r);
+			if (!rect_same_size(&dev->fmt_out_rect, &fmt) &&
+			    vb2_is_busy(&dev->vb_vid_out_q))
+				return -EBUSY;
+			dev->fmt_out_rect = fmt;
+			rect_set_size_to(crop, &s->r);
+			rect_map_inside(crop, &dev->fmt_out_rect);
+		} else {
+			if (!rect_same_size(&s->r, &dev->fmt_out_rect) &&
+			    vb2_is_busy(&dev->vb_vid_out_q))
+				return -EBUSY;
+			rect_set_size_to(&dev->fmt_out_rect, &s->r);
+			rect_set_size_to(crop, &s->r);
+			crop->height /= factor;
+			rect_map_inside(crop, &dev->fmt_out_rect);
+		}
+		s->r.top *= factor;
+		s->r.height *= factor;
+		if (dev->bitmap_out && (compose->width != s->r.width ||
+					compose->height != s->r.height)) {
+			kfree(dev->bitmap_out);
+			dev->bitmap_out = NULL;
+		}
+		*compose = s->r;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int vivid_vid_out_cropcap(struct file *file, void *priv,
+			      struct v4l2_cropcap *cap)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (cap->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL;
+
+	switch (vivid_get_pixel_aspect(dev)) {
+	case TPG_PIXEL_ASPECT_NTSC:
+		cap->pixelaspect.numerator = 11;
+		cap->pixelaspect.denominator = 10;
+		break;
+	case TPG_PIXEL_ASPECT_PAL:
+		cap->pixelaspect.numerator = 54;
+		cap->pixelaspect.denominator = 59;
+		break;
+	case TPG_PIXEL_ASPECT_SQUARE:
+		cap->pixelaspect.numerator = 1;
+		cap->pixelaspect.denominator = 1;
+		break;
+	}
+	return 0;
+}
+
+int vidioc_g_fmt_vid_out_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	const struct v4l2_rect *compose = &dev->compose_out;
+	struct v4l2_window *win = &f->fmt.win;
+	unsigned clipcount = win->clipcount;
+
+	if (!dev->has_fb)
+		return -EINVAL;
+	win->w.top = dev->overlay_out_top;
+	win->w.left = dev->overlay_out_left;
+	win->w.width = compose->width;
+	win->w.height = compose->height;
+	win->clipcount = dev->clipcount_out;
+	win->field = V4L2_FIELD_ANY;
+	win->chromakey = dev->chromakey_out;
+	win->global_alpha = dev->global_alpha_out;
+	if (clipcount > dev->clipcount_out)
+		clipcount = dev->clipcount_out;
+	if (dev->bitmap_out == NULL)
+		win->bitmap = NULL;
+	else if (win->bitmap) {
+		if (copy_to_user(win->bitmap, dev->bitmap_out,
+		    ((dev->compose_out.width + 7) / 8) * dev->compose_out.height))
+			return -EFAULT;
+	}
+	if (clipcount && win->clips) {
+		if (copy_to_user(win->clips, dev->clips_out,
+				 clipcount * sizeof(dev->clips_out[0])))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+int vidioc_try_fmt_vid_out_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	const struct v4l2_rect *compose = &dev->compose_out;
+	struct v4l2_window *win = &f->fmt.win;
+	int i, j;
+
+	if (!dev->has_fb)
+		return -EINVAL;
+	win->w.left = clamp_t(int, win->w.left,
+			      -dev->display_width, dev->display_width);
+	win->w.top = clamp_t(int, win->w.top,
+			     -dev->display_height, dev->display_height);
+	win->w.width = compose->width;
+	win->w.height = compose->height;
+	/*
+	 * It makes no sense for an OSD to overlay only top or bottom fields,
+	 * so always set this to ANY.
+	 */
+	win->field = V4L2_FIELD_ANY;
+	if (win->clipcount && !win->clips)
+		win->clipcount = 0;
+	if (win->clipcount > MAX_CLIPS)
+		win->clipcount = MAX_CLIPS;
+	if (win->clipcount) {
+		if (copy_from_user(dev->try_clips_out, win->clips,
+				   win->clipcount * sizeof(dev->clips_out[0])))
+			return -EFAULT;
+		for (i = 0; i < win->clipcount; i++) {
+			struct v4l2_rect *r = &dev->try_clips_out[i].c;
+
+			r->top = clamp_t(s32, r->top, 0, dev->display_height - 1);
+			r->height = clamp_t(s32, r->height, 1, dev->display_height - r->top);
+			r->left = clamp_t(u32, r->left, 0, dev->display_width - 1);
+			r->width = clamp_t(u32, r->width, 1, dev->display_width - r->left);
+		}
+		/*
+		 * Yeah, so sue me, it's an O(n^2) algorithm. But n is a small
+		 * number and it's typically a one-time deal.
+		 */
+		for (i = 0; i < win->clipcount - 1; i++) {
+			struct v4l2_rect *r1 = &dev->try_clips_out[i].c;
+
+			for (j = i + 1; j < win->clipcount; j++) {
+				struct v4l2_rect *r2 = &dev->try_clips_out[j].c;
+
+				if (rect_overlap(r1, r2))
+					return -EINVAL;
+			}
+		}
+		if (copy_to_user(win->clips, dev->try_clips_out,
+				 win->clipcount * sizeof(dev->clips_out[0])))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+int vidioc_s_fmt_vid_out_overlay(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	const struct v4l2_rect *compose = &dev->compose_out;
+	struct v4l2_window *win = &f->fmt.win;
+	int ret = vidioc_try_fmt_vid_out_overlay(file, priv, f);
+	unsigned bitmap_size = ((compose->width + 7) / 8) * compose->height;
+	unsigned clips_size = win->clipcount * sizeof(dev->clips_out[0]);
+	void *new_bitmap = NULL;
+
+	if (ret)
+		return ret;
+
+	if (win->bitmap) {
+		new_bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+
+		if (new_bitmap == NULL)
+			return -ENOMEM;
+		if (copy_from_user(new_bitmap, win->bitmap, bitmap_size)) {
+			kfree(new_bitmap);
+			return -EFAULT;
+		}
+	}
+
+	dev->overlay_out_top = win->w.top;
+	dev->overlay_out_left = win->w.left;
+	kfree(dev->bitmap_out);
+	dev->bitmap_out = new_bitmap;
+	dev->clipcount_out = win->clipcount;
+	if (dev->clipcount_out)
+		memcpy(dev->clips_out, dev->try_clips_out, clips_size);
+	dev->chromakey_out = win->chromakey;
+	dev->global_alpha_out = win->global_alpha;
+	return ret;
+}
+
+int vivid_vid_out_overlay(struct file *file, void *fh, unsigned i)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (i && !dev->fmt_out->can_do_overlay) {
+		dprintk(dev, 1, "unsupported output format for output overlay\n");
+		return -EINVAL;
+	}
+
+	dev->overlay_out_enabled = i;
+	return 0;
+}
+
+int vivid_vid_out_g_fbuf(struct file *file, void *fh,
+				struct v4l2_framebuffer *a)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	a->capability = V4L2_FBUF_CAP_EXTERNOVERLAY |
+			V4L2_FBUF_CAP_BITMAP_CLIPPING |
+			V4L2_FBUF_CAP_LIST_CLIPPING |
+			V4L2_FBUF_CAP_CHROMAKEY |
+			V4L2_FBUF_CAP_SRC_CHROMAKEY |
+			V4L2_FBUF_CAP_GLOBAL_ALPHA |
+			V4L2_FBUF_CAP_LOCAL_ALPHA |
+			V4L2_FBUF_CAP_LOCAL_INV_ALPHA;
+	a->flags = V4L2_FBUF_FLAG_OVERLAY | dev->fbuf_out_flags;
+	a->base = (void *)dev->video_pbase;
+	a->fmt.width = dev->display_width;
+	a->fmt.height = dev->display_height;
+	if (dev->fb_defined.green.length == 5)
+		a->fmt.pixelformat = V4L2_PIX_FMT_ARGB555;
+	else
+		a->fmt.pixelformat = V4L2_PIX_FMT_RGB565;
+	a->fmt.bytesperline = dev->display_byte_stride;
+	a->fmt.sizeimage = a->fmt.height * a->fmt.bytesperline;
+	a->fmt.field = V4L2_FIELD_NONE;
+	a->fmt.colorspace = V4L2_COLORSPACE_SRGB;
+	a->fmt.priv = 0;
+	return 0;
+}
+
+int vivid_vid_out_s_fbuf(struct file *file, void *fh,
+				const struct v4l2_framebuffer *a)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	const unsigned chroma_flags = V4L2_FBUF_FLAG_CHROMAKEY |
+				      V4L2_FBUF_FLAG_SRC_CHROMAKEY;
+	const unsigned alpha_flags = V4L2_FBUF_FLAG_GLOBAL_ALPHA |
+				     V4L2_FBUF_FLAG_LOCAL_ALPHA |
+				     V4L2_FBUF_FLAG_LOCAL_INV_ALPHA;
+
+
+	if ((a->flags & chroma_flags) == chroma_flags)
+		return -EINVAL;
+	switch (a->flags & alpha_flags) {
+	case 0:
+	case V4L2_FBUF_FLAG_GLOBAL_ALPHA:
+	case V4L2_FBUF_FLAG_LOCAL_ALPHA:
+	case V4L2_FBUF_FLAG_LOCAL_INV_ALPHA:
+		break;
+	default:
+		return -EINVAL;
+	}
+	dev->fbuf_out_flags &= ~(chroma_flags | alpha_flags);
+	dev->fbuf_out_flags = a->flags & (chroma_flags | alpha_flags);
+	return 0;
+}
+
+static const struct v4l2_audioout vivid_audio_outputs[] = {
+	{ 0, "Line-Out 1" },
+	{ 1, "Line-Out 2" },
+};
+
+int vidioc_enum_output(struct file *file, void *priv,
+				struct v4l2_output *out)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (out->index >= dev->num_outputs)
+		return -EINVAL;
+
+	out->type = V4L2_OUTPUT_TYPE_ANALOG;
+	switch (dev->output_type[out->index]) {
+	case SVID:
+		snprintf(out->name, sizeof(out->name), "S-Video %u",
+				dev->output_name_counter[out->index]);
+		out->std = V4L2_STD_ALL;
+		if (dev->has_audio_outputs)
+			out->audioset = (1 << ARRAY_SIZE(vivid_audio_outputs)) - 1;
+		out->capabilities = V4L2_OUT_CAP_STD;
+		break;
+	case HDMI:
+		snprintf(out->name, sizeof(out->name), "HDMI %u",
+				dev->output_name_counter[out->index]);
+		out->capabilities = V4L2_OUT_CAP_DV_TIMINGS;
+		break;
+	}
+	return 0;
+}
+
+int vidioc_g_output(struct file *file, void *priv, unsigned *o)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	*o = dev->output;
+	return 0;
+}
+
+int vidioc_s_output(struct file *file, void *priv, unsigned o)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (o >= dev->num_outputs)
+		return -EINVAL;
+
+	if (o == dev->output)
+		return 0;
+
+	if (vb2_is_busy(&dev->vb_vid_out_q) || vb2_is_busy(&dev->vb_vbi_out_q))
+		return -EBUSY;
+
+	dev->output = o;
+	dev->tv_audio_output = 0;
+	if (dev->output_type[o] == SVID)
+		dev->vid_out_dev.tvnorms = V4L2_STD_ALL;
+	else
+		dev->vid_out_dev.tvnorms = 0;
+
+	dev->vbi_out_dev.tvnorms = dev->vid_out_dev.tvnorms;
+	vivid_update_format_out(dev);
+	return 0;
+}
+
+int vidioc_enumaudout(struct file *file, void *fh, struct v4l2_audioout *vout)
+{
+	if (vout->index >= ARRAY_SIZE(vivid_audio_outputs))
+		return -EINVAL;
+	*vout = vivid_audio_outputs[vout->index];
+	return 0;
+}
+
+int vidioc_g_audout(struct file *file, void *fh, struct v4l2_audioout *vout)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!vivid_is_svid_out(dev))
+		return -EINVAL;
+	*vout = vivid_audio_outputs[dev->tv_audio_output];
+	return 0;
+}
+
+int vidioc_s_audout(struct file *file, void *fh, const struct v4l2_audioout *vout)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!vivid_is_svid_out(dev))
+		return -EINVAL;
+	if (vout->index >= ARRAY_SIZE(vivid_audio_outputs))
+		return -EINVAL;
+	dev->tv_audio_output = vout->index;
+	return 0;
+}
+
+int vivid_vid_out_s_std(struct file *file, void *priv, v4l2_std_id id)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!vivid_is_svid_out(dev))
+		return -ENODATA;
+	if (dev->std_out == id)
+		return 0;
+	if (vb2_is_busy(&dev->vb_vid_out_q) || vb2_is_busy(&dev->vb_vbi_out_q))
+		return -EBUSY;
+	dev->std_out = id;
+	vivid_update_format_out(dev);
+	return 0;
+}
+
+int vivid_vid_out_s_dv_timings(struct file *file, void *_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (!vivid_is_hdmi_out(dev))
+		return -ENODATA;
+	if (vb2_is_busy(&dev->vb_vid_out_q))
+		return -EBUSY;
+	if (!v4l2_find_dv_timings_cap(timings, &vivid_dv_timings_cap,
+				0, NULL, NULL))
+		return -EINVAL;
+	if (v4l2_match_dv_timings(timings, &dev->dv_timings_out, 0))
+		return 0;
+	dev->dv_timings_out = *timings;
+	vivid_update_format_out(dev);
+	return 0;
+}
+
+int vivid_vid_out_g_edid(struct file *file, void *_fh,
+			 struct v4l2_edid *edid)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
+
+	memset(edid->reserved, 0, sizeof(edid->reserved));
+	if (vdev->vfl_dir == VFL_DIR_RX) {
+		if (edid->pad >= dev->num_inputs)
+			return -EINVAL;
+		if (dev->input_type[edid->pad] != HDMI)
+			return -EINVAL;
+	} else {
+		if (edid->pad >= dev->num_outputs)
+			return -EINVAL;
+		if (dev->output_type[edid->pad] != HDMI)
+			return -EINVAL;
+	}
+	if (edid->start_block == 0 && edid->blocks == 0) {
+		edid->blocks = dev->edid_blocks;
+		return 0;
+	}
+	if (dev->edid_blocks == 0)
+		return -ENODATA;
+	if (edid->start_block >= dev->edid_blocks)
+		return -EINVAL;
+	if (edid->start_block + edid->blocks > dev->edid_blocks)
+		edid->blocks = dev->edid_blocks - edid->start_block;
+	memcpy(edid->edid, dev->edid, edid->blocks * 128);
+	return 0;
+}
+
+int vivid_vid_out_s_edid(struct file *file, void *_fh,
+			 struct v4l2_edid *edid)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	memset(edid->reserved, 0, sizeof(edid->reserved));
+	if (edid->pad >= dev->num_inputs)
+		return -EINVAL;
+	if (dev->input_type[edid->pad] != HDMI || edid->start_block)
+		return -EINVAL;
+	if (edid->blocks == 0) {
+		dev->edid_blocks = 0;
+		return 0;
+	}
+	if (edid->blocks > dev->edid_max_blocks) {
+		edid->blocks = dev->edid_max_blocks;
+		return -E2BIG;
+	}
+	dev->edid_blocks = edid->blocks;
+	memcpy(dev->edid, edid->edid, edid->blocks * 128);
+	return 0;
+}
+
+int vivid_vid_out_g_parm(struct file *file, void *priv,
+			  struct v4l2_streamparm *parm)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (parm->type != (dev->multiplanar ?
+			   V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
+			   V4L2_BUF_TYPE_VIDEO_OUTPUT))
+		return -EINVAL;
+
+	parm->parm.output.capability   = V4L2_CAP_TIMEPERFRAME;
+	parm->parm.output.timeperframe = dev->timeperframe_vid_out;
+	parm->parm.output.writebuffers  = 1;
+return 0;
+}
+
+int vidioc_subscribe_event(struct v4l2_fh *fh,
+			const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_CTRL:
+		return v4l2_ctrl_subscribe_event(fh, sub);
+	case V4L2_EVENT_SOURCE_CHANGE:
+		if (fh->vdev->vfl_dir == VFL_DIR_RX)
+			return v4l2_src_change_event_subscribe(fh, sub);
+		break;
+	default:
+		break;
+	}
+	return -EINVAL;
+}
diff --git a/drivers/media/platform/vivid/vivid-vid-out.h b/drivers/media/platform/vivid/vivid-vid-out.h
new file mode 100644
index 0000000..a237465
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-vid-out.h
@@ -0,0 +1,57 @@
+/*
+ * vivid-vid-out.h - video output support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _VIVID_VID_OUT_H_
+#define _VIVID_VID_OUT_H_
+
+extern const struct vb2_ops vivid_vid_out_qops;
+
+void vivid_update_format_out(struct vivid_dev *dev);
+
+int vivid_g_fmt_vid_out(struct file *file, void *priv, struct v4l2_format *f);
+int vivid_try_fmt_vid_out(struct file *file, void *priv, struct v4l2_format *f);
+int vivid_s_fmt_vid_out(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_g_fmt_vid_out_mplane(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_s_fmt_vid_out_mplane(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_g_fmt_vid_out(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_try_fmt_vid_out(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_s_fmt_vid_out(struct file *file, void *priv, struct v4l2_format *f);
+int vivid_vid_out_g_selection(struct file *file, void *priv, struct v4l2_selection *sel);
+int vivid_vid_out_s_selection(struct file *file, void *fh, struct v4l2_selection *s);
+int vivid_vid_out_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cap);
+int vidioc_enum_fmt_vid_out_overlay(struct file *file, void  *priv, struct v4l2_fmtdesc *f);
+int vidioc_g_fmt_vid_out_overlay(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_try_fmt_vid_out_overlay(struct file *file, void *priv, struct v4l2_format *f);
+int vidioc_s_fmt_vid_out_overlay(struct file *file, void *priv, struct v4l2_format *f);
+int vivid_vid_out_overlay(struct file *file, void *fh, unsigned i);
+int vivid_vid_out_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *a);
+int vivid_vid_out_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuffer *a);
+int vidioc_enum_output(struct file *file, void *priv, struct v4l2_output *out);
+int vidioc_g_output(struct file *file, void *priv, unsigned *i);
+int vidioc_s_output(struct file *file, void *priv, unsigned i);
+int vidioc_enumaudout(struct file *file, void *fh, struct v4l2_audioout *vout);
+int vidioc_g_audout(struct file *file, void *fh, struct v4l2_audioout *vout);
+int vidioc_s_audout(struct file *file, void *fh, const struct v4l2_audioout *vout);
+int vivid_vid_out_s_std(struct file *file, void *priv, v4l2_std_id id);
+int vivid_vid_out_s_dv_timings(struct file *file, void *_fh, struct v4l2_dv_timings *timings);
+int vidioc_g_edid(struct file *file, void *_fh, struct v4l2_edid *edid);
+int vivid_vid_out_g_parm(struct file *file, void *priv, struct v4l2_streamparm *parm);
+
+#endif
-- 
2.0.1

