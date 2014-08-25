Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4841 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaHYLax (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 07:30:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 06/12] vivid: add VBI capture and output code
Date: Mon, 25 Aug 2014 13:30:17 +0200
Message-Id: <1408966223-5221-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408966223-5221-1-git-send-email-hverkuil@xs4all.nl>
References: <1408966223-5221-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This adds support for VBI capture (raw and sliced) and VBI output
(raw and sliced) to the vivid driver. In addition a VBI generator
is added that generates simple VBI data in either sliced or raw
format.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-vbi-cap.c | 356 +++++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-vbi-cap.h |  40 +++
 drivers/media/platform/vivid/vivid-vbi-gen.c | 248 +++++++++++++++++++
 drivers/media/platform/vivid/vivid-vbi-gen.h |  33 +++
 drivers/media/platform/vivid/vivid-vbi-out.c | 247 +++++++++++++++++++
 drivers/media/platform/vivid/vivid-vbi-out.h |  34 +++
 6 files changed, 958 insertions(+)
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-cap.c
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-cap.h
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-gen.c
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-gen.h
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-out.c
 create mode 100644 drivers/media/platform/vivid/vivid-vbi-out.h

diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
new file mode 100644
index 0000000..e239cfd
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -0,0 +1,356 @@
+/*
+ * vivid-vbi-cap.c - vbi capture support functions.
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
+#include <linux/videodev2.h>
+#include <media/v4l2-common.h>
+
+#include "vivid-core.h"
+#include "vivid-kthread-cap.h"
+#include "vivid-vbi-cap.h"
+#include "vivid-vbi-gen.h"
+
+static void vivid_sliced_vbi_cap_fill(struct vivid_dev *dev, unsigned seqnr)
+{
+	struct vivid_vbi_gen_data *vbi_gen = &dev->vbi_gen;
+	bool is_60hz = dev->std_cap & V4L2_STD_525_60;
+
+	vivid_vbi_gen_sliced(vbi_gen, is_60hz, seqnr);
+
+	if (!is_60hz) {
+		if (dev->loop_video) {
+			if (dev->vbi_out_have_wss) {
+				vbi_gen->data[0].data[0] = dev->vbi_out_wss[0];
+				vbi_gen->data[0].data[1] = dev->vbi_out_wss[1];
+			} else {
+				vbi_gen->data[0].id = 0;
+			}
+		} else {
+			switch (tpg_g_video_aspect(&dev->tpg)) {
+			case TPG_VIDEO_ASPECT_14X9_CENTRE:
+				vbi_gen->data[0].data[0] = 0x01;
+				break;
+			case TPG_VIDEO_ASPECT_16X9_CENTRE:
+				vbi_gen->data[0].data[0] = 0x0b;
+				break;
+			case TPG_VIDEO_ASPECT_16X9_ANAMORPHIC:
+				vbi_gen->data[0].data[0] = 0x07;
+				break;
+			case TPG_VIDEO_ASPECT_4X3:
+			default:
+				vbi_gen->data[0].data[0] = 0x08;
+				break;
+			}
+		}
+	} else if (dev->loop_video && is_60hz) {
+		if (dev->vbi_out_have_cc[0]) {
+			vbi_gen->data[0].data[0] = dev->vbi_out_cc[0][0];
+			vbi_gen->data[0].data[1] = dev->vbi_out_cc[0][1];
+		} else {
+			vbi_gen->data[0].id = 0;
+		}
+		if (dev->vbi_out_have_cc[1]) {
+			vbi_gen->data[1].data[0] = dev->vbi_out_cc[1][0];
+			vbi_gen->data[1].data[1] = dev->vbi_out_cc[1][1];
+		} else {
+			vbi_gen->data[1].id = 0;
+		}
+	}
+}
+
+static void vivid_g_fmt_vbi_cap(struct vivid_dev *dev, struct v4l2_vbi_format *vbi)
+{
+	bool is_60hz = dev->std_cap & V4L2_STD_525_60;
+
+	vbi->sampling_rate = 27000000;
+	vbi->offset = 24;
+	vbi->samples_per_line = 1440;
+	vbi->sample_format = V4L2_PIX_FMT_GREY;
+	vbi->start[0] = is_60hz ? 10 : 6;
+	vbi->start[1] = is_60hz ? 273 : 318;
+	vbi->count[0] = vbi->count[1] = is_60hz ? 12 : 18;
+	vbi->flags = dev->vbi_cap_interlaced ? V4L2_VBI_INTERLACED : 0;
+	vbi->reserved[0] = 0;
+	vbi->reserved[1] = 0;
+}
+
+void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
+{
+	struct v4l2_vbi_format vbi;
+	u8 *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+
+	vivid_g_fmt_vbi_cap(dev, &vbi);
+	buf->vb.v4l2_buf.sequence = dev->vbi_cap_seq_count;
+	if (dev->field_cap == V4L2_FIELD_ALTERNATE)
+		buf->vb.v4l2_buf.sequence /= 2;
+
+	vivid_sliced_vbi_cap_fill(dev, buf->vb.v4l2_buf.sequence);
+
+	memset(vbuf, 0x10, vb2_plane_size(&buf->vb, 0));
+
+	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode))
+		vivid_vbi_gen_raw(&dev->vbi_gen, &vbi, vbuf);
+
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
+}
+
+
+void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
+{
+	struct v4l2_sliced_vbi_data *vbuf = vb2_plane_vaddr(&buf->vb, 0);
+
+	buf->vb.v4l2_buf.sequence = dev->vbi_cap_seq_count;
+	if (dev->field_cap == V4L2_FIELD_ALTERNATE)
+		buf->vb.v4l2_buf.sequence /= 2;
+
+	vivid_sliced_vbi_cap_fill(dev, buf->vb.v4l2_buf.sequence);
+
+	memset(vbuf, 0, vb2_plane_size(&buf->vb, 0));
+	if (!VIVID_INVALID_SIGNAL(dev->std_signal_mode)) {
+		vbuf[0] = dev->vbi_gen.data[0];
+		vbuf[1] = dev->vbi_gen.data[1];
+	}
+
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	buf->vb.v4l2_buf.timestamp.tv_sec += dev->time_wrap_offset;
+}
+
+static int vbi_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+		       unsigned *nbuffers, unsigned *nplanes,
+		       unsigned sizes[], void *alloc_ctxs[])
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+	bool is_60hz = dev->std_cap & V4L2_STD_525_60;
+	unsigned size = vq->type == V4L2_BUF_TYPE_SLICED_VBI_CAPTURE ?
+		36 * sizeof(struct v4l2_sliced_vbi_data) :
+		1440 * 2 * (is_60hz ? 12 : 18);
+
+	if (!vivid_is_sdtv_cap(dev))
+		return -EINVAL;
+
+	sizes[0] = size;
+
+	if (vq->num_buffers + *nbuffers < 2)
+		*nbuffers = 2 - vq->num_buffers;
+
+	*nplanes = 1;
+	return 0;
+}
+
+static int vbi_cap_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	bool is_60hz = dev->std_cap & V4L2_STD_525_60;
+	unsigned size = vb->vb2_queue->type == V4L2_BUF_TYPE_SLICED_VBI_CAPTURE ?
+		36 * sizeof(struct v4l2_sliced_vbi_data) :
+		1440 * 2 * (is_60hz ? 12 : 18);
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	if (dev->buf_prepare_error) {
+		/*
+		 * Error injection: test what happens if buf_prepare() returns
+		 * an error.
+		 */
+		dev->buf_prepare_error = false;
+		return -EINVAL;
+	}
+	if (vb2_plane_size(vb, 0) < size) {
+		dprintk(dev, 1, "%s data will not fit into plane (%lu < %u)\n",
+				__func__, vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+	vb2_set_plane_payload(vb, 0, size);
+
+	return 0;
+}
+
+static void vbi_cap_buf_queue(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	spin_lock(&dev->slock);
+	list_add_tail(&buf->list, &dev->vbi_cap_active);
+	spin_unlock(&dev->slock);
+}
+
+static int vbi_cap_start_streaming(struct vb2_queue *vq, unsigned count)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+	int err;
+
+	dprintk(dev, 1, "%s\n", __func__);
+	dev->vbi_cap_seq_count = 0;
+	if (dev->start_streaming_error) {
+		dev->start_streaming_error = false;
+		err = -EINVAL;
+	} else {
+		err = vivid_start_generating_vid_cap(dev, &dev->vbi_cap_streaming);
+	}
+	if (err) {
+		struct vivid_buffer *buf, *tmp;
+
+		list_for_each_entry_safe(buf, tmp, &dev->vbi_cap_active, list) {
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		}
+	}
+	return err;
+}
+
+/* abort streaming and wait for last buffer */
+static void vbi_cap_stop_streaming(struct vb2_queue *vq)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+
+	dprintk(dev, 1, "%s\n", __func__);
+	vivid_stop_generating_vid_cap(dev, &dev->vbi_cap_streaming);
+}
+
+const struct vb2_ops vivid_vbi_cap_qops = {
+	.queue_setup		= vbi_cap_queue_setup,
+	.buf_prepare		= vbi_cap_buf_prepare,
+	.buf_queue		= vbi_cap_buf_queue,
+	.start_streaming	= vbi_cap_start_streaming,
+	.stop_streaming		= vbi_cap_stop_streaming,
+	.wait_prepare		= vivid_unlock,
+	.wait_finish		= vivid_lock,
+};
+
+int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_vbi_format *vbi = &f->fmt.vbi;
+
+	if (!vivid_is_sdtv_cap(dev) || !dev->has_raw_vbi_cap)
+		return -EINVAL;
+
+	vivid_g_fmt_vbi_cap(dev, vbi);
+	return 0;
+}
+
+int vidioc_s_fmt_vbi_cap(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	int ret = vidioc_g_fmt_vbi_cap(file, priv, f);
+
+	if (ret)
+		return ret;
+	if (dev->stream_sliced_vbi_cap && vb2_is_busy(&dev->vb_vbi_cap_q))
+		return -EBUSY;
+	dev->stream_sliced_vbi_cap = false;
+	dev->vbi_cap_dev.queue->type = V4L2_BUF_TYPE_VBI_CAPTURE;
+	return 0;
+}
+
+void vivid_fill_service_lines(struct v4l2_sliced_vbi_format *vbi, u32 service_set)
+{
+	vbi->io_size = sizeof(struct v4l2_sliced_vbi_data) * 36;
+	vbi->service_set = service_set;
+	memset(vbi->service_lines, 0, sizeof(vbi->service_lines));
+	memset(vbi->reserved, 0, sizeof(vbi->reserved));
+
+	if (vbi->service_set == 0)
+		return;
+
+	if (vbi->service_set & V4L2_SLICED_CAPTION_525) {
+		vbi->service_lines[0][21] = V4L2_SLICED_CAPTION_525;
+		vbi->service_lines[1][21] = V4L2_SLICED_CAPTION_525;
+	}
+	if (vbi->service_set & V4L2_SLICED_WSS_625)
+		vbi->service_lines[0][23] = V4L2_SLICED_WSS_625;
+}
+
+int vidioc_g_fmt_sliced_vbi_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_sliced_vbi_format *vbi = &fmt->fmt.sliced;
+
+	if (!vivid_is_sdtv_cap(dev) || !dev->has_sliced_vbi_cap)
+		return -EINVAL;
+
+	vivid_fill_service_lines(vbi, dev->service_set_cap);
+	return 0;
+}
+
+int vidioc_try_fmt_sliced_vbi_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_sliced_vbi_format *vbi = &fmt->fmt.sliced;
+	bool is_60hz = dev->std_cap & V4L2_STD_525_60;
+	u32 service_set = vbi->service_set;
+
+	if (!vivid_is_sdtv_cap(dev) || !dev->has_sliced_vbi_cap)
+		return -EINVAL;
+
+	service_set &= is_60hz ? V4L2_SLICED_CAPTION_525 : V4L2_SLICED_WSS_625;
+	vivid_fill_service_lines(vbi, service_set);
+	return 0;
+}
+
+int vidioc_s_fmt_sliced_vbi_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_sliced_vbi_format *vbi = &fmt->fmt.sliced;
+	int ret = vidioc_try_fmt_sliced_vbi_cap(file, fh, fmt);
+
+	if (ret)
+		return ret;
+	if (!dev->stream_sliced_vbi_cap && vb2_is_busy(&dev->vb_vbi_cap_q))
+		return -EBUSY;
+	dev->service_set_cap = vbi->service_set;
+	dev->stream_sliced_vbi_cap = true;
+	dev->vbi_cap_dev.queue->type = V4L2_BUF_TYPE_SLICED_VBI_CAPTURE;
+	return 0;
+}
+
+int vidioc_g_sliced_vbi_cap(struct file *file, void *fh, struct v4l2_sliced_vbi_cap *cap)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
+	bool is_60hz;
+
+	if (vdev->vfl_dir == VFL_DIR_RX) {
+		is_60hz = dev->std_cap & V4L2_STD_525_60;
+		if (!vivid_is_sdtv_cap(dev) || !dev->has_sliced_vbi_cap ||
+		    cap->type != V4L2_BUF_TYPE_SLICED_VBI_CAPTURE)
+			return -EINVAL;
+	} else {
+		is_60hz = dev->std_out & V4L2_STD_525_60;
+		if (!vivid_is_svid_out(dev) || !dev->has_sliced_vbi_out ||
+		    cap->type != V4L2_BUF_TYPE_SLICED_VBI_OUTPUT)
+			return -EINVAL;
+	}
+
+	cap->service_set = is_60hz ? V4L2_SLICED_CAPTION_525 : V4L2_SLICED_WSS_625;
+	if (is_60hz) {
+		cap->service_lines[0][21] = V4L2_SLICED_CAPTION_525;
+		cap->service_lines[1][21] = V4L2_SLICED_CAPTION_525;
+	} else {
+		cap->service_lines[0][23] = V4L2_SLICED_WSS_625;
+	}
+	return 0;
+}
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.h b/drivers/media/platform/vivid/vivid-vbi-cap.h
new file mode 100644
index 0000000..2d8ea0b
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.h
@@ -0,0 +1,40 @@
+/*
+ * vivid-vbi-cap.h - vbi capture support functions.
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
+#ifndef _VIVID_VBI_CAP_H_
+#define _VIVID_VBI_CAP_H_
+
+void vivid_fill_time_of_day_packet(u8 *packet);
+void vivid_raw_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf);
+void vivid_sliced_vbi_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf);
+void vivid_sliced_vbi_out_process(struct vivid_dev *dev, struct vivid_buffer *buf);
+int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
+					struct v4l2_format *f);
+int vidioc_s_fmt_vbi_cap(struct file *file, void *priv,
+					struct v4l2_format *f);
+int vidioc_g_fmt_sliced_vbi_cap(struct file *file, void *fh, struct v4l2_format *fmt);
+int vidioc_try_fmt_sliced_vbi_cap(struct file *file, void *fh, struct v4l2_format *fmt);
+int vidioc_s_fmt_sliced_vbi_cap(struct file *file, void *fh, struct v4l2_format *fmt);
+int vidioc_g_sliced_vbi_cap(struct file *file, void *fh, struct v4l2_sliced_vbi_cap *cap);
+
+void vivid_fill_service_lines(struct v4l2_sliced_vbi_format *vbi, u32 service_set);
+
+extern const struct vb2_ops vivid_vbi_cap_qops;
+
+#endif
diff --git a/drivers/media/platform/vivid/vivid-vbi-gen.c b/drivers/media/platform/vivid/vivid-vbi-gen.c
new file mode 100644
index 0000000..22f4bcc
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-vbi-gen.c
@@ -0,0 +1,248 @@
+/*
+ * vivid-vbi-gen.c - vbi generator support functions.
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
+#include <linux/ktime.h>
+#include <linux/videodev2.h>
+
+#include "vivid-vbi-gen.h"
+
+static void wss_insert(u8 *wss, u32 val, unsigned size)
+{
+	while (size--)
+		*wss++ = (val & (1 << size)) ? 0xc0 : 0x10;
+}
+
+static void vivid_vbi_gen_wss_raw(const struct v4l2_sliced_vbi_data *data,
+		u8 *buf, unsigned sampling_rate)
+{
+	const unsigned rate = 5000000;	/* WSS has a 5 MHz transmission rate */
+	u8 wss[29 + 24 + 24 + 24 + 18 + 18] = { 0 };
+	const unsigned zero = 0x07;
+	const unsigned one = 0x38;
+	unsigned bit = 0;
+	u16 wss_data;
+	int i;
+
+	wss_insert(wss + bit, 0x1f1c71c7, 29); bit += 29;
+	wss_insert(wss + bit, 0x1e3c1f, 24); bit += 24;
+
+	wss_data = (data->data[1] << 8) | data->data[0];
+	for (i = 0; i <= 13; i++, bit += 6)
+		wss_insert(wss + bit, (wss_data & (1 << i)) ? one : zero, 6);
+
+	for (i = 0, bit = 0; bit < sizeof(wss); bit++) {
+		unsigned n = ((bit + 1) * sampling_rate) / rate;
+
+		while (i < n)
+			buf[i++] = wss[bit];
+	}
+}
+
+static void cc_insert(u8 *cc, u8 ch)
+{
+	unsigned tot = 0;
+	unsigned i;
+
+	for (i = 0; i < 7; i++) {
+		cc[2 * i] = cc[2 * i + 1] = (ch & (1 << i)) ? 1 : 0;
+		tot += cc[2 * i];
+	}
+	cc[14] = cc[15] = !(tot & 1);
+}
+
+#define CC_PREAMBLE_BITS (14 + 4 + 2)
+
+static void vivid_vbi_gen_cc_raw(const struct v4l2_sliced_vbi_data *data,
+		u8 *buf, unsigned sampling_rate)
+{
+	const unsigned rate = 1000000;	/* CC has a 1 MHz transmission rate */
+
+	u8 cc[CC_PREAMBLE_BITS + 2 * 16] = {
+		/* Clock run-in: 7 cycles */
+		0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1,
+		/* 2 cycles of 0 */
+		0, 0, 0, 0,
+		/* Start bit of 1 (each bit is two cycles) */
+		1, 1
+	};
+	unsigned bit, i;
+
+	cc_insert(cc + CC_PREAMBLE_BITS, data->data[0]);
+	cc_insert(cc + CC_PREAMBLE_BITS + 16, data->data[1]);
+
+	for (i = 0, bit = 0; bit < sizeof(cc); bit++) {
+		unsigned n = ((bit + 1) * sampling_rate) / rate;
+
+		while (i < n)
+			buf[i++] = cc[bit] ? 0xc0 : 0x10;
+	}
+}
+
+void vivid_vbi_gen_raw(const struct vivid_vbi_gen_data *vbi,
+		const struct v4l2_vbi_format *vbi_fmt, u8 *buf)
+{
+	unsigned idx;
+
+	for (idx = 0; idx < 2; idx++) {
+		const struct v4l2_sliced_vbi_data *data = vbi->data + idx;
+		unsigned start_2nd_field;
+		unsigned line = data->line;
+		u8 *linebuf = buf;
+
+		start_2nd_field = (data->id & V4L2_SLICED_VBI_525) ? 263 : 313;
+		if (data->field)
+			line += start_2nd_field;
+		line -= vbi_fmt->start[data->field];
+
+		if (vbi_fmt->flags & V4L2_VBI_INTERLACED)
+			linebuf += (line * 2 + data->field) *
+				vbi_fmt->samples_per_line;
+		else
+			linebuf += (line + data->field * vbi_fmt->count[0]) *
+				vbi_fmt->samples_per_line;
+		if (data->id == V4L2_SLICED_CAPTION_525)
+			vivid_vbi_gen_cc_raw(data, linebuf, vbi_fmt->sampling_rate);
+		else if (data->id == V4L2_SLICED_WSS_625)
+			vivid_vbi_gen_wss_raw(data, linebuf, vbi_fmt->sampling_rate);
+	}
+}
+
+static const u8 vivid_cc_sequence1[30] = {
+	0x14, 0x20,	/* Resume Caption Loading */
+	'H',  'e',
+	'l',  'l',
+	'o',  ' ',
+	'w',  'o',
+	'r',  'l',
+	'd',  '!',
+	0x14, 0x2f,	/* End of Caption */
+};
+
+static const u8 vivid_cc_sequence2[30] = {
+	0x14, 0x20,	/* Resume Caption Loading */
+	'C',  'l',
+	'o',  's',
+	'e',  'd',
+	' ',  'c',
+	'a',  'p',
+	't',  'i',
+	'o',  'n',
+	's',  ' ',
+	't',  'e',
+	's',  't',
+	0x14, 0x2f,	/* End of Caption */
+};
+
+static u8 calc_parity(u8 val)
+{
+	unsigned i;
+	unsigned tot = 0;
+
+	for (i = 0; i < 7; i++)
+		tot += (val & (1 << i)) ? 1 : 0;
+	return val | ((tot & 1) ? 0 : 0x80);
+}
+
+static void vivid_vbi_gen_set_time_of_day(u8 *packet)
+{
+	struct tm tm;
+	u8 checksum, i;
+
+	time_to_tm(get_seconds(), 0, &tm);
+	packet[0] = calc_parity(0x07);
+	packet[1] = calc_parity(0x01);
+	packet[2] = calc_parity(0x40 | tm.tm_min);
+	packet[3] = calc_parity(0x40 | tm.tm_hour);
+	packet[4] = calc_parity(0x40 | tm.tm_mday);
+	if (tm.tm_mday == 1 && tm.tm_mon == 2 &&
+	    sys_tz.tz_minuteswest > tm.tm_min + tm.tm_hour * 60)
+		packet[4] = calc_parity(0x60 | tm.tm_mday);
+	packet[5] = calc_parity(0x40 | (1 + tm.tm_mon));
+	packet[6] = calc_parity(0x40 | (1 + tm.tm_wday));
+	packet[7] = calc_parity(0x40 | ((tm.tm_year - 90) & 0x3f));
+	packet[8] = calc_parity(0x0f);
+	for (checksum = i = 0; i <= 8; i++)
+		checksum += packet[i] & 0x7f;
+	packet[9] = calc_parity(0x100 - checksum);
+	checksum = 0;
+	packet[10] = calc_parity(0x07);
+	packet[11] = calc_parity(0x04);
+	if (sys_tz.tz_minuteswest >= 0)
+		packet[12] = calc_parity(0x40 | ((sys_tz.tz_minuteswest / 60) & 0x1f));
+	else
+		packet[12] = calc_parity(0x40 | ((24 + sys_tz.tz_minuteswest / 60) & 0x1f));
+	packet[13] = calc_parity(0);
+	packet[14] = calc_parity(0x0f);
+	for (checksum = 0, i = 10; i <= 14; i++)
+		checksum += packet[i] & 0x7f;
+	packet[15] = calc_parity(0x100 - checksum);
+}
+
+void vivid_vbi_gen_sliced(struct vivid_vbi_gen_data *vbi,
+		bool is_60hz, unsigned seqnr)
+{
+	struct v4l2_sliced_vbi_data *data0 = vbi->data;
+	struct v4l2_sliced_vbi_data *data1 = vbi->data + 1;
+	unsigned frame = seqnr % 60;
+
+	memset(vbi->data, 0, sizeof(vbi->data));
+
+	if (!is_60hz) {
+		data0->id = V4L2_SLICED_WSS_625;
+		data0->line = 23;
+		/* 4x3 video aspect ratio */
+		data0->data[0] = 0x08;
+		return;
+	}
+
+	data0->id = V4L2_SLICED_CAPTION_525;
+	data0->line = 21;
+	data1->id = V4L2_SLICED_CAPTION_525;
+	data1->field = 1;
+	data1->line = 21;
+
+	if (frame < 15) {
+		data0->data[0] = calc_parity(vivid_cc_sequence1[2 * frame]);
+		data0->data[1] = calc_parity(vivid_cc_sequence1[2 * frame + 1]);
+	} else if (frame >= 30 && frame < 45) {
+		frame -= 30;
+		data0->data[0] = calc_parity(vivid_cc_sequence2[2 * frame]);
+		data0->data[1] = calc_parity(vivid_cc_sequence2[2 * frame + 1]);
+	} else {
+		data0->data[0] = calc_parity(0);
+		data0->data[1] = calc_parity(0);
+	}
+
+	frame = seqnr % (30 * 60);
+	switch (frame) {
+	case 0:
+		vivid_vbi_gen_set_time_of_day(vbi->time_of_day_packet);
+		/* fall through */
+	case 1 ... 7:
+		data1->data[0] = vbi->time_of_day_packet[frame * 2];
+		data1->data[1] = vbi->time_of_day_packet[frame * 2 + 1];
+		break;
+	default:
+		data1->data[0] = calc_parity(0);
+		data1->data[1] = calc_parity(0);
+		break;
+	}
+}
diff --git a/drivers/media/platform/vivid/vivid-vbi-gen.h b/drivers/media/platform/vivid/vivid-vbi-gen.h
new file mode 100644
index 0000000..401dd47
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-vbi-gen.h
@@ -0,0 +1,33 @@
+/*
+ * vivid-vbi-gen.h - vbi generator support functions.
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
+#ifndef _VIVID_VBI_GEN_H_
+#define _VIVID_VBI_GEN_H_
+
+struct vivid_vbi_gen_data {
+	struct v4l2_sliced_vbi_data data[2];
+	u8 time_of_day_packet[16];
+};
+
+void vivid_vbi_gen_sliced(struct vivid_vbi_gen_data *vbi,
+		bool is_60hz, unsigned seqnr);
+void vivid_vbi_gen_raw(const struct vivid_vbi_gen_data *vbi,
+		const struct v4l2_vbi_format *vbi_fmt, u8 *buf);
+
+#endif
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
new file mode 100644
index 0000000..039316d
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -0,0 +1,247 @@
+/*
+ * vivid-vbi-out.c - vbi output support functions.
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
+#include <linux/videodev2.h>
+#include <media/v4l2-common.h>
+
+#include "vivid-core.h"
+#include "vivid-kthread-out.h"
+#include "vivid-vbi-out.h"
+#include "vivid-vbi-cap.h"
+
+static int vbi_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+		       unsigned *nbuffers, unsigned *nplanes,
+		       unsigned sizes[], void *alloc_ctxs[])
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+	bool is_60hz = dev->std_out & V4L2_STD_525_60;
+	unsigned size = vq->type == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT ?
+		36 * sizeof(struct v4l2_sliced_vbi_data) :
+		1440 * 2 * (is_60hz ? 12 : 18);
+
+	if (!vivid_is_svid_out(dev))
+		return -EINVAL;
+
+	sizes[0] = size;
+
+	if (vq->num_buffers + *nbuffers < 2)
+		*nbuffers = 2 - vq->num_buffers;
+
+	*nplanes = 1;
+	return 0;
+}
+
+static int vbi_out_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	bool is_60hz = dev->std_out & V4L2_STD_525_60;
+	unsigned size = vb->vb2_queue->type == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT ?
+		36 * sizeof(struct v4l2_sliced_vbi_data) :
+		1440 * 2 * (is_60hz ? 12 : 18);
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	if (dev->buf_prepare_error) {
+		/*
+		 * Error injection: test what happens if buf_prepare() returns
+		 * an error.
+		 */
+		dev->buf_prepare_error = false;
+		return -EINVAL;
+	}
+	if (vb2_plane_size(vb, 0) < size) {
+		dprintk(dev, 1, "%s data will not fit into plane (%lu < %u)\n",
+				__func__, vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+	vb2_set_plane_payload(vb, 0, size);
+
+	return 0;
+}
+
+static void vbi_out_buf_queue(struct vb2_buffer *vb)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vivid_buffer *buf = container_of(vb, struct vivid_buffer, vb);
+
+	dprintk(dev, 1, "%s\n", __func__);
+
+	spin_lock(&dev->slock);
+	list_add_tail(&buf->list, &dev->vbi_out_active);
+	spin_unlock(&dev->slock);
+}
+
+static int vbi_out_start_streaming(struct vb2_queue *vq, unsigned count)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+	int err;
+
+	dprintk(dev, 1, "%s\n", __func__);
+	dev->vbi_out_seq_count = 0;
+	if (dev->start_streaming_error) {
+		dev->start_streaming_error = false;
+		err = -EINVAL;
+	} else {
+		err = vivid_start_generating_vid_out(dev, &dev->vbi_out_streaming);
+	}
+	if (err) {
+		struct vivid_buffer *buf, *tmp;
+
+		list_for_each_entry_safe(buf, tmp, &dev->vbi_out_active, list) {
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		}
+	}
+	return err;
+}
+
+/* abort streaming and wait for last buffer */
+static void vbi_out_stop_streaming(struct vb2_queue *vq)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+
+	dprintk(dev, 1, "%s\n", __func__);
+	vivid_stop_generating_vid_out(dev, &dev->vbi_out_streaming);
+	dev->vbi_out_have_wss = false;
+	dev->vbi_out_have_cc[0] = false;
+	dev->vbi_out_have_cc[1] = false;
+}
+
+const struct vb2_ops vivid_vbi_out_qops = {
+	.queue_setup		= vbi_out_queue_setup,
+	.buf_prepare		= vbi_out_buf_prepare,
+	.buf_queue		= vbi_out_buf_queue,
+	.start_streaming	= vbi_out_start_streaming,
+	.stop_streaming		= vbi_out_stop_streaming,
+	.wait_prepare		= vivid_unlock,
+	.wait_finish		= vivid_lock,
+};
+
+int vidioc_g_fmt_vbi_out(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_vbi_format *vbi = &f->fmt.vbi;
+	bool is_60hz = dev->std_out & V4L2_STD_525_60;
+
+	if (!vivid_is_svid_out(dev) || !dev->has_raw_vbi_out)
+		return -EINVAL;
+
+	vbi->sampling_rate = 25000000;
+	vbi->offset = 24;
+	vbi->samples_per_line = 1440;
+	vbi->sample_format = V4L2_PIX_FMT_GREY;
+	vbi->start[0] = is_60hz ? 10 : 6;
+	vbi->start[1] = is_60hz ? 273 : 318;
+	vbi->count[0] = vbi->count[1] = is_60hz ? 12 : 18;
+	vbi->flags = dev->vbi_cap_interlaced ? V4L2_VBI_INTERLACED : 0;
+	vbi->reserved[0] = 0;
+	vbi->reserved[1] = 0;
+	return 0;
+}
+
+int vidioc_s_fmt_vbi_out(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	int ret = vidioc_g_fmt_vbi_out(file, priv, f);
+
+	if (ret)
+		return ret;
+	if (vb2_is_busy(&dev->vb_vbi_out_q))
+		return -EBUSY;
+	dev->stream_sliced_vbi_out = false;
+	dev->vbi_out_dev.queue->type = V4L2_BUF_TYPE_VBI_OUTPUT;
+	return 0;
+}
+
+int vidioc_g_fmt_sliced_vbi_out(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_sliced_vbi_format *vbi = &fmt->fmt.sliced;
+
+	if (!vivid_is_svid_out(dev) || !dev->has_sliced_vbi_out)
+		return -EINVAL;
+
+	vivid_fill_service_lines(vbi, dev->service_set_out);
+	return 0;
+}
+
+int vidioc_try_fmt_sliced_vbi_out(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_sliced_vbi_format *vbi = &fmt->fmt.sliced;
+	bool is_60hz = dev->std_out & V4L2_STD_525_60;
+	u32 service_set = vbi->service_set;
+
+	if (!vivid_is_svid_out(dev) || !dev->has_sliced_vbi_out)
+		return -EINVAL;
+
+	service_set &= is_60hz ? V4L2_SLICED_CAPTION_525 : V4L2_SLICED_WSS_625;
+	vivid_fill_service_lines(vbi, service_set);
+	return 0;
+}
+
+int vidioc_s_fmt_sliced_vbi_out(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_sliced_vbi_format *vbi = &fmt->fmt.sliced;
+	int ret = vidioc_try_fmt_sliced_vbi_out(file, fh, fmt);
+
+	if (ret)
+		return ret;
+	if (vb2_is_busy(&dev->vb_vbi_out_q))
+		return -EBUSY;
+	dev->service_set_out = vbi->service_set;
+	dev->stream_sliced_vbi_out = true;
+	dev->vbi_out_dev.queue->type = V4L2_BUF_TYPE_SLICED_VBI_OUTPUT;
+	return 0;
+}
+
+void vivid_sliced_vbi_out_process(struct vivid_dev *dev, struct vivid_buffer *buf)
+{
+	struct v4l2_sliced_vbi_data *vbi = vb2_plane_vaddr(&buf->vb, 0);
+	unsigned elems = vb2_get_plane_payload(&buf->vb, 0) / sizeof(*vbi);
+
+	dev->vbi_out_have_cc[0] = false;
+	dev->vbi_out_have_cc[1] = false;
+	dev->vbi_out_have_wss = false;
+	while (elems--) {
+		switch (vbi->id) {
+		case V4L2_SLICED_CAPTION_525:
+			if ((dev->std_out & V4L2_STD_525_60) && vbi->line == 21) {
+				dev->vbi_out_have_cc[!!vbi->field] = true;
+				dev->vbi_out_cc[!!vbi->field][0] = vbi->data[0];
+				dev->vbi_out_cc[!!vbi->field][1] = vbi->data[1];
+			}
+			break;
+		case V4L2_SLICED_WSS_625:
+			if ((dev->std_out & V4L2_STD_625_50) &&
+			    vbi->field == 0 && vbi->line == 23) {
+				dev->vbi_out_have_wss = true;
+				dev->vbi_out_wss[0] = vbi->data[0];
+				dev->vbi_out_wss[1] = vbi->data[1];
+			}
+			break;
+		}
+		vbi++;
+	}
+}
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.h b/drivers/media/platform/vivid/vivid-vbi-out.h
new file mode 100644
index 0000000..6555ba9
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-vbi-out.h
@@ -0,0 +1,34 @@
+/*
+ * vivid-vbi-out.h - vbi output support functions.
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
+#ifndef _VIVID_VBI_OUT_H_
+#define _VIVID_VBI_OUT_H_
+
+void vivid_sliced_vbi_out_process(struct vivid_dev *dev, struct vivid_buffer *buf);
+int vidioc_g_fmt_vbi_out(struct file *file, void *priv,
+					struct v4l2_format *f);
+int vidioc_s_fmt_vbi_out(struct file *file, void *priv,
+					struct v4l2_format *f);
+int vidioc_g_fmt_sliced_vbi_out(struct file *file, void *fh, struct v4l2_format *fmt);
+int vidioc_try_fmt_sliced_vbi_out(struct file *file, void *fh, struct v4l2_format *fmt);
+int vidioc_s_fmt_sliced_vbi_out(struct file *file, void *fh, struct v4l2_format *fmt);
+
+extern const struct vb2_ops vivid_vbi_out_qops;
+
+#endif
-- 
2.0.1

