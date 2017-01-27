Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:52158 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752126AbdA0V7F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 16:59:05 -0500
From: Eric Anholt <eric@anholt.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Anholt <eric@anholt.net>
Subject: [PATCH 1/6] staging: Import the BCM2835 MMAL-based V4L2 camera driver.
Date: Fri, 27 Jan 2017 13:54:58 -0800
Message-Id: <20170127215503.13208-2-eric@anholt.net>
In-Reply-To: <20170127215503.13208-1-eric@anholt.net>
References: <20170127215503.13208-1-eric@anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Supports raw YUV capture, preview, JPEG and H264.
- Uses videobuf2 for data transfer, using dma_buf.
- Uses 3.6.10 timestamping
- Camera power based on use
- Uses immutable input mode on video encoder

This code comes from the Raspberry Pi kernel tree (rpi-4.9.y) as of
a15ba877dab4e61ea3fc7b006e2a73828b083c52.

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 .../media/platform/bcm2835/bcm2835-camera.c        | 2016 ++++++++++++++++++++
 .../media/platform/bcm2835/bcm2835-camera.h        |  145 ++
 drivers/staging/media/platform/bcm2835/controls.c  | 1345 +++++++++++++
 .../staging/media/platform/bcm2835/mmal-common.h   |   53 +
 .../media/platform/bcm2835/mmal-encodings.h        |  127 ++
 .../media/platform/bcm2835/mmal-msg-common.h       |   50 +
 .../media/platform/bcm2835/mmal-msg-format.h       |   81 +
 .../staging/media/platform/bcm2835/mmal-msg-port.h |  107 ++
 drivers/staging/media/platform/bcm2835/mmal-msg.h  |  404 ++++
 .../media/platform/bcm2835/mmal-parameters.h       |  689 +++++++
 .../staging/media/platform/bcm2835/mmal-vchiq.c    | 1916 +++++++++++++++++++
 .../staging/media/platform/bcm2835/mmal-vchiq.h    |  178 ++
 12 files changed, 7111 insertions(+)
 create mode 100644 drivers/staging/media/platform/bcm2835/bcm2835-camera.c
 create mode 100644 drivers/staging/media/platform/bcm2835/bcm2835-camera.h
 create mode 100644 drivers/staging/media/platform/bcm2835/controls.c
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-common.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-encodings.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-common.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-format.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-port.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-parameters.h
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-vchiq.c
 create mode 100644 drivers/staging/media/platform/bcm2835/mmal-vchiq.h

diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
new file mode 100644
index 000000000000..4f03949aecf3
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
@@ -0,0 +1,2016 @@
+/*
+ * Broadcom BM2835 V4L2 driver
+ *
+ * Copyright © 2013 Raspberry Pi (Trading) Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
+ *          Dave Stevenson <dsteve@broadcom.com>
+ *          Simon Mellor <simellor@broadcom.com>
+ *          Luke Diamand <luked@broadcom.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <media/videobuf2-vmalloc.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-common.h>
+#include <linux/delay.h>
+
+#include "mmal-common.h"
+#include "mmal-encodings.h"
+#include "mmal-vchiq.h"
+#include "mmal-msg.h"
+#include "mmal-parameters.h"
+#include "bcm2835-camera.h"
+
+#define BM2835_MMAL_VERSION "0.0.2"
+#define BM2835_MMAL_MODULE_NAME "bcm2835-v4l2"
+#define MIN_WIDTH 32
+#define MIN_HEIGHT 32
+#define MIN_BUFFER_SIZE (80*1024)
+
+#define MAX_VIDEO_MODE_WIDTH 1280
+#define MAX_VIDEO_MODE_HEIGHT 720
+
+#define MAX_BCM2835_CAMERAS 2
+
+MODULE_DESCRIPTION("Broadcom 2835 MMAL video capture");
+MODULE_AUTHOR("Vincent Sanders");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(BM2835_MMAL_VERSION);
+
+int bcm2835_v4l2_debug;
+module_param_named(debug, bcm2835_v4l2_debug, int, 0644);
+MODULE_PARM_DESC(bcm2835_v4l2_debug, "Debug level 0-2");
+
+#define UNSET (-1)
+static int video_nr[] = {[0 ... (MAX_BCM2835_CAMERAS - 1)] = UNSET };
+module_param_array(video_nr, int, NULL, 0644);
+MODULE_PARM_DESC(video_nr, "videoX start numbers, -1 is autodetect");
+
+static int max_video_width = MAX_VIDEO_MODE_WIDTH;
+static int max_video_height = MAX_VIDEO_MODE_HEIGHT;
+module_param(max_video_width, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+MODULE_PARM_DESC(max_video_width, "Threshold for video mode");
+module_param(max_video_height, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+MODULE_PARM_DESC(max_video_height, "Threshold for video mode");
+
+/* Gstreamer bug https://bugzilla.gnome.org/show_bug.cgi?id=726521
+ * v4l2src does bad (and actually wrong) things when the vidioc_enum_framesizes
+ * function says type V4L2_FRMSIZE_TYPE_STEPWISE, which we do by default.
+ * It's happier if we just don't say anything at all, when it then
+ * sets up a load of defaults that it thinks might work.
+ * If gst_v4l2src_is_broken is non-zero, then we remove the function from
+ * our function table list (actually switch to an alternate set, but same
+ * result).
+ */
+static int gst_v4l2src_is_broken;
+module_param(gst_v4l2src_is_broken, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+MODULE_PARM_DESC(gst_v4l2src_is_broken, "If non-zero, enable workaround for Gstreamer");
+
+/* global device data array */
+static struct bm2835_mmal_dev *gdev[MAX_BCM2835_CAMERAS];
+
+#define FPS_MIN 1
+#define FPS_MAX 90
+
+/* timeperframe: min/max and default */
+static const struct v4l2_fract
+	tpf_min     = {.numerator = 1,		.denominator = FPS_MAX},
+	tpf_max     = {.numerator = 1,	        .denominator = FPS_MIN},
+	tpf_default = {.numerator = 1000,	.denominator = 30000};
+
+/* video formats */
+static struct mmal_fmt formats[] = {
+	{
+	 .name = "4:2:0, planar, YUV",
+	 .fourcc = V4L2_PIX_FMT_YUV420,
+	 .flags = 0,
+	 .mmal = MMAL_ENCODING_I420,
+	 .depth = 12,
+	 .mmal_component = MMAL_COMPONENT_CAMERA,
+	 .ybbp = 1,
+	 },
+	{
+	 .name = "4:2:2, packed, YUYV",
+	 .fourcc = V4L2_PIX_FMT_YUYV,
+	 .flags = 0,
+	 .mmal = MMAL_ENCODING_YUYV,
+	 .depth = 16,
+	 .mmal_component = MMAL_COMPONENT_CAMERA,
+	 .ybbp = 2,
+	 },
+	{
+	 .name = "RGB24 (LE)",
+	 .fourcc = V4L2_PIX_FMT_RGB24,
+	 .flags = 0,
+	 .mmal = MMAL_ENCODING_RGB24,
+	 .depth = 24,
+	 .mmal_component = MMAL_COMPONENT_CAMERA,
+	 .ybbp = 3,
+	 },
+	{
+	 .name = "JPEG",
+	 .fourcc = V4L2_PIX_FMT_JPEG,
+	 .flags = V4L2_FMT_FLAG_COMPRESSED,
+	 .mmal = MMAL_ENCODING_JPEG,
+	 .depth = 8,
+	 .mmal_component = MMAL_COMPONENT_IMAGE_ENCODE,
+	 .ybbp = 0,
+	 },
+	{
+	 .name = "H264",
+	 .fourcc = V4L2_PIX_FMT_H264,
+	 .flags = V4L2_FMT_FLAG_COMPRESSED,
+	 .mmal = MMAL_ENCODING_H264,
+	 .depth = 8,
+	 .mmal_component = MMAL_COMPONENT_VIDEO_ENCODE,
+	 .ybbp = 0,
+	 },
+	{
+	 .name = "MJPEG",
+	 .fourcc = V4L2_PIX_FMT_MJPEG,
+	 .flags = V4L2_FMT_FLAG_COMPRESSED,
+	 .mmal = MMAL_ENCODING_MJPEG,
+	 .depth = 8,
+	 .mmal_component = MMAL_COMPONENT_VIDEO_ENCODE,
+	 .ybbp = 0,
+	 },
+	{
+	 .name = "4:2:2, packed, YVYU",
+	 .fourcc = V4L2_PIX_FMT_YVYU,
+	 .flags = 0,
+	 .mmal = MMAL_ENCODING_YVYU,
+	 .depth = 16,
+	 .mmal_component = MMAL_COMPONENT_CAMERA,
+	 .ybbp = 2,
+	 },
+	{
+	 .name = "4:2:2, packed, VYUY",
+	 .fourcc = V4L2_PIX_FMT_VYUY,
+	 .flags = 0,
+	 .mmal = MMAL_ENCODING_VYUY,
+	 .depth = 16,
+	 .mmal_component = MMAL_COMPONENT_CAMERA,
+	 .ybbp = 2,
+	 },
+	{
+	 .name = "4:2:2, packed, UYVY",
+	 .fourcc = V4L2_PIX_FMT_UYVY,
+	 .flags = 0,
+	 .mmal = MMAL_ENCODING_UYVY,
+	 .depth = 16,
+	 .mmal_component = MMAL_COMPONENT_CAMERA,
+	 .ybbp = 2,
+	 },
+	{
+	 .name = "4:2:0, planar, NV12",
+	 .fourcc = V4L2_PIX_FMT_NV12,
+	 .flags = 0,
+	 .mmal = MMAL_ENCODING_NV12,
+	 .depth = 12,
+	 .mmal_component = MMAL_COMPONENT_CAMERA,
+	 .ybbp = 1,
+	 },
+	{
+	 .name = "RGB24 (BE)",
+	 .fourcc = V4L2_PIX_FMT_BGR24,
+	 .flags = 0,
+	 .mmal = MMAL_ENCODING_BGR24,
+	 .depth = 24,
+	 .mmal_component = MMAL_COMPONENT_CAMERA,
+	 .ybbp = 3,
+	 },
+	{
+	 .name = "4:2:0, planar, YVU",
+	 .fourcc = V4L2_PIX_FMT_YVU420,
+	 .flags = 0,
+	 .mmal = MMAL_ENCODING_YV12,
+	 .depth = 12,
+	 .mmal_component = MMAL_COMPONENT_CAMERA,
+	 .ybbp = 1,
+	 },
+	{
+	 .name = "4:2:0, planar, NV21",
+	 .fourcc = V4L2_PIX_FMT_NV21,
+	 .flags = 0,
+	 .mmal = MMAL_ENCODING_NV21,
+	 .depth = 12,
+	 .mmal_component = MMAL_COMPONENT_CAMERA,
+	 .ybbp = 1,
+	 },
+	{
+	 .name = "RGB32 (BE)",
+	 .fourcc = V4L2_PIX_FMT_BGR32,
+	 .flags = 0,
+	 .mmal = MMAL_ENCODING_BGRA,
+	 .depth = 32,
+	 .mmal_component = MMAL_COMPONENT_CAMERA,
+	 .ybbp = 4,
+	 },
+};
+
+static struct mmal_fmt *get_format(struct v4l2_format *f)
+{
+	struct mmal_fmt *fmt;
+	unsigned int k;
+
+	for (k = 0; k < ARRAY_SIZE(formats); k++) {
+		fmt = &formats[k];
+		if (fmt->fourcc == f->fmt.pix.pixelformat)
+			break;
+	}
+
+	if (k == ARRAY_SIZE(formats))
+		return NULL;
+
+	return &formats[k];
+}
+
+/* ------------------------------------------------------------------
+	Videobuf queue operations
+   ------------------------------------------------------------------*/
+
+static int queue_setup(struct vb2_queue *vq,
+		       unsigned int *nbuffers, unsigned int *nplanes,
+		       unsigned int sizes[], struct device *alloc_ctxs[])
+{
+	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
+	unsigned long size;
+
+	/* refuse queue setup if port is not configured */
+	if (dev->capture.port == NULL) {
+		v4l2_err(&dev->v4l2_dev,
+			 "%s: capture port not configured\n", __func__);
+		return -EINVAL;
+	}
+
+	size = dev->capture.port->current_buffer.size;
+	if (size == 0) {
+		v4l2_err(&dev->v4l2_dev,
+			 "%s: capture port buffer size is zero\n", __func__);
+		return -EINVAL;
+	}
+
+	if (*nbuffers < (dev->capture.port->current_buffer.num + 2))
+		*nbuffers = (dev->capture.port->current_buffer.num + 2);
+
+	*nplanes = 1;
+
+	sizes[0] = size;
+
+	/*
+	 * videobuf2-vmalloc allocator is context-less so no need to set
+	 * alloc_ctxs array.
+	 */
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "%s: dev:%p\n",
+		 __func__, dev);
+
+	return 0;
+}
+
+static int buffer_prepare(struct vb2_buffer *vb)
+{
+	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long size;
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "%s: dev:%p\n",
+		 __func__, dev);
+
+	BUG_ON(dev->capture.port == NULL);
+	BUG_ON(dev->capture.fmt == NULL);
+
+	size = dev->capture.stride * dev->capture.height;
+	if (vb2_plane_size(vb, 0) < size) {
+		v4l2_err(&dev->v4l2_dev,
+			 "%s data will not fit into plane (%lu < %lu)\n",
+			 __func__, vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static inline bool is_capturing(struct bm2835_mmal_dev *dev)
+{
+	return dev->capture.camera_port ==
+	    &dev->
+	    component[MMAL_COMPONENT_CAMERA]->output[MMAL_CAMERA_PORT_CAPTURE];
+}
+
+static void buffer_cb(struct vchiq_mmal_instance *instance,
+		      struct vchiq_mmal_port *port,
+		      int status,
+		      struct mmal_buffer *buf,
+		      unsigned long length, u32 mmal_flags, s64 dts, s64 pts)
+{
+	struct bm2835_mmal_dev *dev = port->cb_ctx;
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+		 "%s: status:%d, buf:%p, length:%lu, flags %u, pts %lld\n",
+		 __func__, status, buf, length, mmal_flags, pts);
+
+	if (status != 0) {
+		/* error in transfer */
+		if (buf != NULL) {
+			/* there was a buffer with the error so return it */
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+		}
+		return;
+	} else if (length == 0) {
+		/* stream ended */
+		if (buf != NULL) {
+			/* this should only ever happen if the port is
+			 * disabled and there are buffers still queued
+			 */
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+			pr_debug("Empty buffer");
+		} else if (dev->capture.frame_count) {
+			/* grab another frame */
+			if (is_capturing(dev)) {
+				pr_debug("Grab another frame");
+				vchiq_mmal_port_parameter_set(
+					instance,
+					dev->capture.
+					camera_port,
+					MMAL_PARAMETER_CAPTURE,
+					&dev->capture.
+					frame_count,
+					sizeof(dev->capture.frame_count));
+			}
+		} else {
+			/* signal frame completion */
+			complete(&dev->capture.frame_cmplt);
+		}
+	} else {
+		if (dev->capture.frame_count) {
+			if (dev->capture.vc_start_timestamp != -1 &&
+			    pts != 0) {
+				struct timeval timestamp;
+				s64 runtime_us = pts -
+				    dev->capture.vc_start_timestamp;
+				u32 div = 0;
+				u32 rem = 0;
+
+				div =
+				    div_u64_rem(runtime_us, USEC_PER_SEC, &rem);
+				timestamp.tv_sec =
+				    dev->capture.kernel_start_ts.tv_sec + div;
+				timestamp.tv_usec =
+				    dev->capture.kernel_start_ts.tv_usec + rem;
+
+				if (timestamp.tv_usec >=
+				    USEC_PER_SEC) {
+					timestamp.tv_sec++;
+					timestamp.tv_usec -=
+					    USEC_PER_SEC;
+				}
+				v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+					 "Convert start time %d.%06d and %llu "
+					 "with offset %llu to %d.%06d\n",
+					 (int)dev->capture.kernel_start_ts.
+					 tv_sec,
+					 (int)dev->capture.kernel_start_ts.
+					 tv_usec,
+					 dev->capture.vc_start_timestamp, pts,
+					 (int)timestamp.tv_sec,
+					 (int)timestamp.tv_usec);
+				buf->vb.vb2_buf.timestamp = timestamp.tv_sec * 1000000000ULL +
+					timestamp.tv_usec * 1000ULL;
+			} else {
+				buf->vb.vb2_buf.timestamp = ktime_get_ns();
+			}
+
+			vb2_set_plane_payload(&buf->vb.vb2_buf, 0, length);
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
+
+			if (mmal_flags & MMAL_BUFFER_HEADER_FLAG_EOS &&
+			    is_capturing(dev)) {
+				v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+					 "Grab another frame as buffer has EOS");
+				vchiq_mmal_port_parameter_set(
+					instance,
+					dev->capture.
+					camera_port,
+					MMAL_PARAMETER_CAPTURE,
+					&dev->capture.
+					frame_count,
+					sizeof(dev->capture.frame_count));
+			}
+		} else {
+			/* signal frame completion */
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+			complete(&dev->capture.frame_cmplt);
+		}
+	}
+}
+
+static int enable_camera(struct bm2835_mmal_dev *dev)
+{
+	int ret;
+	if (!dev->camera_use_count) {
+		ret = vchiq_mmal_port_parameter_set(
+			dev->instance,
+			&dev->component[MMAL_COMPONENT_CAMERA]->control,
+			MMAL_PARAMETER_CAMERA_NUM, &dev->camera_num,
+			sizeof(dev->camera_num));
+		if (ret < 0) {
+			v4l2_err(&dev->v4l2_dev,
+				 "Failed setting camera num, ret %d\n", ret);
+			return -EINVAL;
+		}
+
+		ret = vchiq_mmal_component_enable(
+				dev->instance,
+				dev->component[MMAL_COMPONENT_CAMERA]);
+		if (ret < 0) {
+			v4l2_err(&dev->v4l2_dev,
+				 "Failed enabling camera, ret %d\n", ret);
+			return -EINVAL;
+		}
+	}
+	dev->camera_use_count++;
+	v4l2_dbg(1, bcm2835_v4l2_debug,
+		 &dev->v4l2_dev, "enabled camera (refcount %d)\n",
+			dev->camera_use_count);
+	return 0;
+}
+
+static int disable_camera(struct bm2835_mmal_dev *dev)
+{
+	int ret;
+	if (!dev->camera_use_count) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Disabled the camera when already disabled\n");
+		return -EINVAL;
+	}
+	dev->camera_use_count--;
+	if (!dev->camera_use_count) {
+		unsigned int i = 0xFFFFFFFF;
+		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+			 "Disabling camera\n");
+		ret =
+		    vchiq_mmal_component_disable(
+				dev->instance,
+				dev->component[MMAL_COMPONENT_CAMERA]);
+		if (ret < 0) {
+			v4l2_err(&dev->v4l2_dev,
+				 "Failed disabling camera, ret %d\n", ret);
+			return -EINVAL;
+		}
+		vchiq_mmal_port_parameter_set(
+			dev->instance,
+			&dev->component[MMAL_COMPONENT_CAMERA]->control,
+			MMAL_PARAMETER_CAMERA_NUM, &i,
+			sizeof(i));
+	}
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+		 "Camera refcount now %d\n", dev->camera_use_count);
+	return 0;
+}
+
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vb2 = to_vb2_v4l2_buffer(vb);
+	struct mmal_buffer *buf = container_of(vb2, struct mmal_buffer, vb);
+	int ret;
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+		 "%s: dev:%p buf:%p\n", __func__, dev, buf);
+
+	buf->buffer = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
+	buf->buffer_size = vb2_plane_size(&buf->vb.vb2_buf, 0);
+
+	ret = vchiq_mmal_submit_buffer(dev->instance, dev->capture.port, buf);
+	if (ret < 0)
+		v4l2_err(&dev->v4l2_dev, "%s: error submitting buffer\n",
+			 __func__);
+}
+
+static int start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
+	int ret;
+	int parameter_size;
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "%s: dev:%p\n",
+		 __func__, dev);
+
+	/* ensure a format has actually been set */
+	if (dev->capture.port == NULL)
+		return -EINVAL;
+
+	if (enable_camera(dev) < 0) {
+		v4l2_err(&dev->v4l2_dev, "Failed to enable camera\n");
+		return -EINVAL;
+	}
+
+	/*init_completion(&dev->capture.frame_cmplt); */
+
+	/* enable frame capture */
+	dev->capture.frame_count = 1;
+
+	/* if the preview is not already running, wait for a few frames for AGC
+	 * to settle down.
+	 */
+	if (!dev->component[MMAL_COMPONENT_PREVIEW]->enabled)
+		msleep(300);
+
+	/* enable the connection from camera to encoder (if applicable) */
+	if (dev->capture.camera_port != dev->capture.port
+	    && dev->capture.camera_port) {
+		ret = vchiq_mmal_port_enable(dev->instance,
+					     dev->capture.camera_port, NULL);
+		if (ret) {
+			v4l2_err(&dev->v4l2_dev,
+				 "Failed to enable encode tunnel - error %d\n",
+				 ret);
+			return -1;
+		}
+	}
+
+	/* Get VC timestamp at this point in time */
+	parameter_size = sizeof(dev->capture.vc_start_timestamp);
+	if (vchiq_mmal_port_parameter_get(dev->instance,
+					  dev->capture.camera_port,
+					  MMAL_PARAMETER_SYSTEM_TIME,
+					  &dev->capture.vc_start_timestamp,
+					  &parameter_size)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Failed to get VC start time - update your VC f/w\n");
+
+		/* Flag to indicate just to rely on kernel timestamps */
+		dev->capture.vc_start_timestamp = -1;
+	} else
+		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+			 "Start time %lld size %d\n",
+			 dev->capture.vc_start_timestamp, parameter_size);
+
+	v4l2_get_timestamp(&dev->capture.kernel_start_ts);
+
+	/* enable the camera port */
+	dev->capture.port->cb_ctx = dev;
+	ret =
+	    vchiq_mmal_port_enable(dev->instance, dev->capture.port, buffer_cb);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev,
+			"Failed to enable capture port - error %d. "
+			"Disabling camera port again\n", ret);
+
+		vchiq_mmal_port_disable(dev->instance,
+					dev->capture.camera_port);
+		if (disable_camera(dev) < 0) {
+			v4l2_err(&dev->v4l2_dev, "Failed to disable camera\n");
+			return -EINVAL;
+		}
+		return -1;
+	}
+
+	/* capture the first frame */
+	vchiq_mmal_port_parameter_set(dev->instance,
+				      dev->capture.camera_port,
+				      MMAL_PARAMETER_CAPTURE,
+				      &dev->capture.frame_count,
+				      sizeof(dev->capture.frame_count));
+	return 0;
+}
+
+/* abort streaming and wait for last buffer */
+static void stop_streaming(struct vb2_queue *vq)
+{
+	int ret;
+	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "%s: dev:%p\n",
+		 __func__, dev);
+
+	init_completion(&dev->capture.frame_cmplt);
+	dev->capture.frame_count = 0;
+
+	/* ensure a format has actually been set */
+	if (dev->capture.port == NULL) {
+		v4l2_err(&dev->v4l2_dev,
+			 "no capture port - stream not started?\n");
+		return;
+	}
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "stopping capturing\n");
+
+	/* stop capturing frames */
+	vchiq_mmal_port_parameter_set(dev->instance,
+				      dev->capture.camera_port,
+				      MMAL_PARAMETER_CAPTURE,
+				      &dev->capture.frame_count,
+				      sizeof(dev->capture.frame_count));
+
+	/* wait for last frame to complete */
+	ret = wait_for_completion_timeout(&dev->capture.frame_cmplt, HZ);
+	if (ret <= 0)
+		v4l2_err(&dev->v4l2_dev,
+			 "error %d waiting for frame completion\n", ret);
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+		 "disabling connection\n");
+
+	/* disable the connection from camera to encoder */
+	ret = vchiq_mmal_port_disable(dev->instance, dev->capture.camera_port);
+	if (!ret && dev->capture.camera_port != dev->capture.port) {
+		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+			 "disabling port\n");
+		ret = vchiq_mmal_port_disable(dev->instance, dev->capture.port);
+	} else if (dev->capture.camera_port != dev->capture.port) {
+		v4l2_err(&dev->v4l2_dev, "port_disable failed, error %d\n",
+			 ret);
+	}
+
+	if (disable_camera(dev) < 0)
+		v4l2_err(&dev->v4l2_dev, "Failed to disable camera\n");
+}
+
+static void bm2835_mmal_lock(struct vb2_queue *vq)
+{
+	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
+	mutex_lock(&dev->mutex);
+}
+
+static void bm2835_mmal_unlock(struct vb2_queue *vq)
+{
+	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
+	mutex_unlock(&dev->mutex);
+}
+
+static struct vb2_ops bm2835_mmal_video_qops = {
+	.queue_setup = queue_setup,
+	.buf_prepare = buffer_prepare,
+	.buf_queue = buffer_queue,
+	.start_streaming = start_streaming,
+	.stop_streaming = stop_streaming,
+	.wait_prepare = bm2835_mmal_unlock,
+	.wait_finish = bm2835_mmal_lock,
+};
+
+/* ------------------------------------------------------------------
+	IOCTL operations
+   ------------------------------------------------------------------*/
+
+static int set_overlay_params(struct bm2835_mmal_dev *dev,
+			      struct vchiq_mmal_port *port)
+{
+	int ret;
+	struct mmal_parameter_displayregion prev_config = {
+	.set = MMAL_DISPLAY_SET_LAYER | MMAL_DISPLAY_SET_ALPHA |
+	    MMAL_DISPLAY_SET_DEST_RECT | MMAL_DISPLAY_SET_FULLSCREEN,
+	.layer = PREVIEW_LAYER,
+	.alpha = dev->overlay.global_alpha,
+	.fullscreen = 0,
+	.dest_rect = {
+		      .x = dev->overlay.w.left,
+		      .y = dev->overlay.w.top,
+		      .width = dev->overlay.w.width,
+		      .height = dev->overlay.w.height,
+		      },
+	};
+	ret = vchiq_mmal_port_parameter_set(dev->instance, port,
+					    MMAL_PARAMETER_DISPLAYREGION,
+					    &prev_config, sizeof(prev_config));
+
+	return ret;
+}
+
+/* overlay ioctl */
+static int vidioc_enum_fmt_vid_overlay(struct file *file, void *priv,
+				       struct v4l2_fmtdesc *f)
+{
+	struct mmal_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(formats))
+		return -EINVAL;
+
+	fmt = &formats[f->index];
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+	f->flags = fmt->flags;
+
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_overlay(struct file *file, void *priv,
+				    struct v4l2_format *f)
+{
+	struct bm2835_mmal_dev *dev = video_drvdata(file);
+
+	f->fmt.win = dev->overlay;
+
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_overlay(struct file *file, void *priv,
+				      struct v4l2_format *f)
+{
+	struct bm2835_mmal_dev *dev = video_drvdata(file);
+
+	f->fmt.win.field = V4L2_FIELD_NONE;
+	f->fmt.win.chromakey = 0;
+	f->fmt.win.clips = NULL;
+	f->fmt.win.clipcount = 0;
+	f->fmt.win.bitmap = NULL;
+
+	v4l_bound_align_image(&f->fmt.win.w.width, MIN_WIDTH, dev->max_width, 1,
+			      &f->fmt.win.w.height, MIN_HEIGHT, dev->max_height,
+			      1, 0);
+	v4l_bound_align_image(&f->fmt.win.w.left, MIN_WIDTH, dev->max_width, 1,
+			      &f->fmt.win.w.top, MIN_HEIGHT, dev->max_height,
+			      1, 0);
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+		"Overlay: Now w/h %dx%d l/t %dx%d\n",
+		f->fmt.win.w.width, f->fmt.win.w.height,
+		f->fmt.win.w.left, f->fmt.win.w.top);
+
+	v4l2_dump_win_format(1,
+			     bcm2835_v4l2_debug,
+			     &dev->v4l2_dev,
+			     &f->fmt.win,
+			     __func__);
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_overlay(struct file *file, void *priv,
+				    struct v4l2_format *f)
+{
+	struct bm2835_mmal_dev *dev = video_drvdata(file);
+
+	vidioc_try_fmt_vid_overlay(file, priv, f);
+
+	dev->overlay = f->fmt.win;
+	if (dev->component[MMAL_COMPONENT_PREVIEW]->enabled) {
+		set_overlay_params(dev,
+			&dev->component[MMAL_COMPONENT_PREVIEW]->input[0]);
+	}
+
+	return 0;
+}
+
+static int vidioc_overlay(struct file *file, void *f, unsigned int on)
+{
+	int ret;
+	struct bm2835_mmal_dev *dev = video_drvdata(file);
+	struct vchiq_mmal_port *src;
+	struct vchiq_mmal_port *dst;
+	if ((on && dev->component[MMAL_COMPONENT_PREVIEW]->enabled) ||
+	    (!on && !dev->component[MMAL_COMPONENT_PREVIEW]->enabled))
+		return 0;	/* already in requested state */
+
+	src =
+	    &dev->component[MMAL_COMPONENT_CAMERA]->
+	    output[MMAL_CAMERA_PORT_PREVIEW];
+
+	if (!on) {
+		/* disconnect preview ports and disable component */
+		ret = vchiq_mmal_port_disable(dev->instance, src);
+		if (!ret)
+			ret =
+			    vchiq_mmal_port_connect_tunnel(dev->instance, src,
+							   NULL);
+		if (ret >= 0)
+			ret = vchiq_mmal_component_disable(
+					dev->instance,
+					dev->component[MMAL_COMPONENT_PREVIEW]);
+
+		disable_camera(dev);
+		return ret;
+	}
+
+	/* set preview port format and connect it to output */
+	dst = &dev->component[MMAL_COMPONENT_PREVIEW]->input[0];
+
+	ret = vchiq_mmal_port_set_format(dev->instance, src);
+	if (ret < 0)
+		goto error;
+
+	ret = set_overlay_params(dev, dst);
+	if (ret < 0)
+		goto error;
+
+	if (enable_camera(dev) < 0)
+		goto error;
+
+	ret = vchiq_mmal_component_enable(
+			dev->instance,
+			dev->component[MMAL_COMPONENT_PREVIEW]);
+	if (ret < 0)
+		goto error;
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "connecting %p to %p\n",
+		 src, dst);
+	ret = vchiq_mmal_port_connect_tunnel(dev->instance, src, dst);
+	if (!ret)
+		ret = vchiq_mmal_port_enable(dev->instance, src, NULL);
+error:
+	return ret;
+}
+
+static int vidioc_g_fbuf(struct file *file, void *fh,
+			 struct v4l2_framebuffer *a)
+{
+	/* The video overlay must stay within the framebuffer and can't be
+	   positioned independently. */
+	struct bm2835_mmal_dev *dev = video_drvdata(file);
+	struct vchiq_mmal_port *preview_port =
+		    &dev->component[MMAL_COMPONENT_CAMERA]->
+		    output[MMAL_CAMERA_PORT_PREVIEW];
+
+	a->capability = V4L2_FBUF_CAP_EXTERNOVERLAY |
+			V4L2_FBUF_CAP_GLOBAL_ALPHA;
+	a->flags = V4L2_FBUF_FLAG_OVERLAY;
+	a->fmt.width = preview_port->es.video.width;
+	a->fmt.height = preview_port->es.video.height;
+	a->fmt.pixelformat = V4L2_PIX_FMT_YUV420;
+	a->fmt.bytesperline = preview_port->es.video.width;
+	a->fmt.sizeimage = (preview_port->es.video.width *
+			       preview_port->es.video.height * 3)>>1;
+	a->fmt.colorspace = V4L2_COLORSPACE_SMPTE170M;
+
+	return 0;
+}
+
+/* input ioctls */
+static int vidioc_enum_input(struct file *file, void *priv,
+			     struct v4l2_input *inp)
+{
+	/* only a single camera input */
+	if (inp->index != 0)
+		return -EINVAL;
+
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	sprintf(inp->name, "Camera %u", inp->index);
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	if (i != 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+/* capture ioctls */
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct bm2835_mmal_dev *dev = video_drvdata(file);
+	u32 major;
+	u32 minor;
+
+	vchiq_mmal_version(dev->instance, &major, &minor);
+
+	strcpy(cap->driver, "bm2835 mmal");
+	snprintf(cap->card, sizeof(cap->card), "mmal service %d.%d",
+		 major, minor);
+
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+		 "platform:%s", dev->v4l2_dev.name);
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OVERLAY |
+	    V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	struct mmal_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(formats))
+		return -EINVAL;
+
+	fmt = &formats[f->index];
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+	f->flags = fmt->flags;
+
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct bm2835_mmal_dev *dev = video_drvdata(file);
+
+	f->fmt.pix.width = dev->capture.width;
+	f->fmt.pix.height = dev->capture.height;
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	f->fmt.pix.pixelformat = dev->capture.fmt->fourcc;
+	f->fmt.pix.bytesperline = dev->capture.stride;
+	f->fmt.pix.sizeimage = dev->capture.buffersize;
+
+	if (dev->capture.fmt->fourcc == V4L2_PIX_FMT_RGB24)
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
+	else if (dev->capture.fmt->fourcc == V4L2_PIX_FMT_JPEG)
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
+	else
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
+
+	v4l2_dump_pix_format(1, bcm2835_v4l2_debug, &dev->v4l2_dev, &f->fmt.pix,
+			     __func__);
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct bm2835_mmal_dev *dev = video_drvdata(file);
+	struct mmal_fmt *mfmt;
+
+	mfmt = get_format(f);
+	if (!mfmt) {
+		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+			 "Fourcc format (0x%08x) unknown.\n",
+			 f->fmt.pix.pixelformat);
+		f->fmt.pix.pixelformat = formats[0].fourcc;
+		mfmt = get_format(f);
+	}
+
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+		"Clipping/aligning %dx%d format %08X\n",
+		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.pixelformat);
+
+	v4l_bound_align_image(&f->fmt.pix.width, MIN_WIDTH, dev->max_width, 1,
+			      &f->fmt.pix.height, MIN_HEIGHT, dev->max_height,
+			      1, 0);
+	f->fmt.pix.bytesperline = f->fmt.pix.width * mfmt->ybbp;
+
+	/* Image buffer has to be padded to allow for alignment, even though
+	 * we then remove that padding before delivering the buffer.
+	 */
+	f->fmt.pix.sizeimage = ((f->fmt.pix.height+15)&~15) *
+			(((f->fmt.pix.width+31)&~31) * mfmt->depth) >> 3;
+
+	if ((mfmt->flags & V4L2_FMT_FLAG_COMPRESSED) &&
+	    f->fmt.pix.sizeimage < MIN_BUFFER_SIZE)
+		f->fmt.pix.sizeimage = MIN_BUFFER_SIZE;
+
+	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_RGB24)
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
+	else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_JPEG)
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
+	else
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+		"Now %dx%d format %08X\n",
+		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.pixelformat);
+
+	v4l2_dump_pix_format(1, bcm2835_v4l2_debug, &dev->v4l2_dev, &f->fmt.pix,
+			     __func__);
+	return 0;
+}
+
+static int mmal_setup_components(struct bm2835_mmal_dev *dev,
+				 struct v4l2_format *f)
+{
+	int ret;
+	struct vchiq_mmal_port *port = NULL, *camera_port = NULL;
+	struct vchiq_mmal_component *encode_component = NULL;
+	struct mmal_fmt *mfmt = get_format(f);
+
+	BUG_ON(!mfmt);
+
+	if (dev->capture.encode_component) {
+		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+			 "vid_cap - disconnect previous tunnel\n");
+
+		/* Disconnect any previous connection */
+		vchiq_mmal_port_connect_tunnel(dev->instance,
+					       dev->capture.camera_port, NULL);
+		dev->capture.camera_port = NULL;
+		ret = vchiq_mmal_component_disable(dev->instance,
+						   dev->capture.
+						   encode_component);
+		if (ret)
+			v4l2_err(&dev->v4l2_dev,
+				 "Failed to disable encode component %d\n",
+				 ret);
+
+		dev->capture.encode_component = NULL;
+	}
+	/* format dependant port setup */
+	switch (mfmt->mmal_component) {
+	case MMAL_COMPONENT_CAMERA:
+		/* Make a further decision on port based on resolution */
+		if (f->fmt.pix.width <= max_video_width
+		    && f->fmt.pix.height <= max_video_height)
+			camera_port = port =
+			    &dev->component[MMAL_COMPONENT_CAMERA]->
+			    output[MMAL_CAMERA_PORT_VIDEO];
+		else
+			camera_port = port =
+			    &dev->component[MMAL_COMPONENT_CAMERA]->
+			    output[MMAL_CAMERA_PORT_CAPTURE];
+		break;
+	case MMAL_COMPONENT_IMAGE_ENCODE:
+		encode_component = dev->component[MMAL_COMPONENT_IMAGE_ENCODE];
+		port = &dev->component[MMAL_COMPONENT_IMAGE_ENCODE]->output[0];
+		camera_port =
+		    &dev->component[MMAL_COMPONENT_CAMERA]->
+		    output[MMAL_CAMERA_PORT_CAPTURE];
+		break;
+	case MMAL_COMPONENT_VIDEO_ENCODE:
+		encode_component = dev->component[MMAL_COMPONENT_VIDEO_ENCODE];
+		port = &dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0];
+		camera_port =
+		    &dev->component[MMAL_COMPONENT_CAMERA]->
+		    output[MMAL_CAMERA_PORT_VIDEO];
+		break;
+	default:
+		break;
+	}
+
+	if (!port)
+		return -EINVAL;
+
+	if (encode_component)
+		camera_port->format.encoding = MMAL_ENCODING_OPAQUE;
+	else
+		camera_port->format.encoding = mfmt->mmal;
+
+	if (dev->rgb_bgr_swapped) {
+		if (camera_port->format.encoding == MMAL_ENCODING_RGB24)
+			camera_port->format.encoding = MMAL_ENCODING_BGR24;
+		else if (camera_port->format.encoding == MMAL_ENCODING_BGR24)
+			camera_port->format.encoding = MMAL_ENCODING_RGB24;
+	}
+
+	camera_port->format.encoding_variant = 0;
+	camera_port->es.video.width = f->fmt.pix.width;
+	camera_port->es.video.height = f->fmt.pix.height;
+	camera_port->es.video.crop.x = 0;
+	camera_port->es.video.crop.y = 0;
+	camera_port->es.video.crop.width = f->fmt.pix.width;
+	camera_port->es.video.crop.height = f->fmt.pix.height;
+	camera_port->es.video.frame_rate.num = 0;
+	camera_port->es.video.frame_rate.den = 1;
+	camera_port->es.video.color_space = MMAL_COLOR_SPACE_JPEG_JFIF;
+
+	ret = vchiq_mmal_port_set_format(dev->instance, camera_port);
+
+	if (!ret
+	    && camera_port ==
+	    &dev->component[MMAL_COMPONENT_CAMERA]->
+	    output[MMAL_CAMERA_PORT_VIDEO]) {
+		bool overlay_enabled =
+		    !!dev->component[MMAL_COMPONENT_PREVIEW]->enabled;
+		struct vchiq_mmal_port *preview_port =
+		    &dev->component[MMAL_COMPONENT_CAMERA]->
+		    output[MMAL_CAMERA_PORT_PREVIEW];
+		/* Preview and encode ports need to match on resolution */
+		if (overlay_enabled) {
+			/* Need to disable the overlay before we can update
+			 * the resolution
+			 */
+			ret =
+			    vchiq_mmal_port_disable(dev->instance,
+						    preview_port);
+			if (!ret)
+				ret =
+				    vchiq_mmal_port_connect_tunnel(
+						dev->instance,
+						preview_port,
+						NULL);
+		}
+		preview_port->es.video.width = f->fmt.pix.width;
+		preview_port->es.video.height = f->fmt.pix.height;
+		preview_port->es.video.crop.x = 0;
+		preview_port->es.video.crop.y = 0;
+		preview_port->es.video.crop.width = f->fmt.pix.width;
+		preview_port->es.video.crop.height = f->fmt.pix.height;
+		preview_port->es.video.frame_rate.num =
+					  dev->capture.timeperframe.denominator;
+		preview_port->es.video.frame_rate.den =
+					  dev->capture.timeperframe.numerator;
+		ret = vchiq_mmal_port_set_format(dev->instance, preview_port);
+		if (overlay_enabled) {
+			ret = vchiq_mmal_port_connect_tunnel(
+				dev->instance,
+				preview_port,
+				&dev->component[MMAL_COMPONENT_PREVIEW]->input[0]);
+			if (!ret)
+				ret = vchiq_mmal_port_enable(dev->instance,
+							     preview_port,
+							     NULL);
+		}
+	}
+
+	if (ret) {
+		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+			 "%s failed to set format %dx%d %08X\n", __func__,
+			 f->fmt.pix.width, f->fmt.pix.height,
+			 f->fmt.pix.pixelformat);
+		/* ensure capture is not going to be tried */
+		dev->capture.port = NULL;
+	} else {
+		if (encode_component) {
+			v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+				 "vid_cap - set up encode comp\n");
+
+			/* configure buffering */
+			camera_port->current_buffer.size =
+			    camera_port->recommended_buffer.size;
+			camera_port->current_buffer.num =
+			    camera_port->recommended_buffer.num;
+
+			ret =
+			    vchiq_mmal_port_connect_tunnel(
+					dev->instance,
+					camera_port,
+					&encode_component->input[0]);
+			if (ret) {
+				v4l2_dbg(1, bcm2835_v4l2_debug,
+					 &dev->v4l2_dev,
+					 "%s failed to create connection\n",
+					 __func__);
+				/* ensure capture is not going to be tried */
+				dev->capture.port = NULL;
+			} else {
+				port->es.video.width = f->fmt.pix.width;
+				port->es.video.height = f->fmt.pix.height;
+				port->es.video.crop.x = 0;
+				port->es.video.crop.y = 0;
+				port->es.video.crop.width = f->fmt.pix.width;
+				port->es.video.crop.height = f->fmt.pix.height;
+				port->es.video.frame_rate.num =
+					  dev->capture.timeperframe.denominator;
+				port->es.video.frame_rate.den =
+					  dev->capture.timeperframe.numerator;
+
+				port->format.encoding = mfmt->mmal;
+				port->format.encoding_variant = 0;
+				/* Set any encoding specific parameters */
+				switch (mfmt->mmal_component) {
+				case MMAL_COMPONENT_VIDEO_ENCODE:
+					port->format.bitrate =
+					    dev->capture.encode_bitrate;
+					break;
+				case MMAL_COMPONENT_IMAGE_ENCODE:
+					/* Could set EXIF parameters here */
+					break;
+				default:
+					break;
+				}
+				ret = vchiq_mmal_port_set_format(dev->instance,
+								 port);
+				if (ret)
+					v4l2_dbg(1, bcm2835_v4l2_debug,
+						 &dev->v4l2_dev,
+						 "%s failed to set format %dx%d fmt %08X\n",
+						 __func__,
+						 f->fmt.pix.width,
+						 f->fmt.pix.height,
+						 f->fmt.pix.pixelformat
+						 );
+			}
+
+			if (!ret) {
+				ret = vchiq_mmal_component_enable(
+						dev->instance,
+						encode_component);
+				if (ret) {
+					v4l2_dbg(1, bcm2835_v4l2_debug,
+					   &dev->v4l2_dev,
+					   "%s Failed to enable encode components\n",
+					   __func__);
+				}
+			}
+			if (!ret) {
+				/* configure buffering */
+				port->current_buffer.num = 1;
+				port->current_buffer.size =
+				    f->fmt.pix.sizeimage;
+				if (port->format.encoding ==
+				    MMAL_ENCODING_JPEG) {
+					v4l2_dbg(1, bcm2835_v4l2_debug,
+					    &dev->v4l2_dev,
+					    "JPG - buf size now %d was %d\n",
+					    f->fmt.pix.sizeimage,
+					    port->current_buffer.size);
+					port->current_buffer.size =
+					    (f->fmt.pix.sizeimage <
+					     (100 << 10))
+					    ? (100 << 10) : f->fmt.pix.
+					    sizeimage;
+				}
+				v4l2_dbg(1, bcm2835_v4l2_debug,
+					 &dev->v4l2_dev,
+					 "vid_cap - cur_buf.size set to %d\n",
+					 f->fmt.pix.sizeimage);
+				port->current_buffer.alignment = 0;
+			}
+		} else {
+			/* configure buffering */
+			camera_port->current_buffer.num = 1;
+			camera_port->current_buffer.size = f->fmt.pix.sizeimage;
+			camera_port->current_buffer.alignment = 0;
+		}
+
+		if (!ret) {
+			dev->capture.fmt = mfmt;
+			dev->capture.stride = f->fmt.pix.bytesperline;
+			dev->capture.width = camera_port->es.video.crop.width;
+			dev->capture.height = camera_port->es.video.crop.height;
+			dev->capture.buffersize = port->current_buffer.size;
+
+			/* select port for capture */
+			dev->capture.port = port;
+			dev->capture.camera_port = camera_port;
+			dev->capture.encode_component = encode_component;
+			v4l2_dbg(1, bcm2835_v4l2_debug,
+				 &dev->v4l2_dev,
+				"Set dev->capture.fmt %08X, %dx%d, stride %d, size %d",
+				port->format.encoding,
+				dev->capture.width, dev->capture.height,
+				dev->capture.stride, dev->capture.buffersize);
+		}
+	}
+
+	/* todo: Need to convert the vchiq/mmal error into a v4l2 error. */
+	return ret;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	int ret;
+	struct bm2835_mmal_dev *dev = video_drvdata(file);
+	struct mmal_fmt *mfmt;
+
+	/* try the format to set valid parameters */
+	ret = vidioc_try_fmt_vid_cap(file, priv, f);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev,
+			 "vid_cap - vidioc_try_fmt_vid_cap failed\n");
+		return ret;
+	}
+
+	/* if a capture is running refuse to set format */
+	if (vb2_is_busy(&dev->capture.vb_vidq)) {
+		v4l2_info(&dev->v4l2_dev, "%s device busy\n", __func__);
+		return -EBUSY;
+	}
+
+	/* If the format is unsupported v4l2 says we should switch to
+	 * a supported one and not return an error. */
+	mfmt = get_format(f);
+	if (!mfmt) {
+		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+			 "Fourcc format (0x%08x) unknown.\n",
+			 f->fmt.pix.pixelformat);
+		f->fmt.pix.pixelformat = formats[0].fourcc;
+		mfmt = get_format(f);
+	}
+
+	ret = mmal_setup_components(dev, f);
+	if (ret != 0) {
+		v4l2_err(&dev->v4l2_dev,
+			 "%s: failed to setup mmal components: %d\n",
+			 __func__, ret);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+int vidioc_enum_framesizes(struct file *file, void *fh,
+			   struct v4l2_frmsizeenum *fsize)
+{
+	struct bm2835_mmal_dev *dev = video_drvdata(file);
+	static const struct v4l2_frmsize_stepwise sizes = {
+		MIN_WIDTH, 0, 2,
+		MIN_HEIGHT, 0, 2
+	};
+	int i;
+
+	if (fsize->index)
+		return -EINVAL;
+	for (i = 0; i < ARRAY_SIZE(formats); i++)
+		if (formats[i].fourcc == fsize->pixel_format)
+			break;
+	if (i == ARRAY_SIZE(formats))
+		return -EINVAL;
+	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+	fsize->stepwise = sizes;
+	fsize->stepwise.max_width = dev->max_width;
+	fsize->stepwise.max_height = dev->max_height;
+	return 0;
+}
+
+/* timeperframe is arbitrary and continous */
+static int vidioc_enum_frameintervals(struct file *file, void *priv,
+					     struct v4l2_frmivalenum *fival)
+{
+	struct bm2835_mmal_dev *dev = video_drvdata(file);
+	int i;
+
+	if (fival->index)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(formats); i++)
+		if (formats[i].fourcc == fival->pixel_format)
+			break;
+	if (i == ARRAY_SIZE(formats))
+		return -EINVAL;
+
+	/* regarding width & height - we support any within range */
+	if (fival->width < MIN_WIDTH || fival->width > dev->max_width ||
+	    fival->height < MIN_HEIGHT || fival->height > dev->max_height)
+		return -EINVAL;
+
+	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
+
+	/* fill in stepwise (step=1.0 is requred by V4L2 spec) */
+	fival->stepwise.min  = tpf_min;
+	fival->stepwise.max  = tpf_max;
+	fival->stepwise.step = (struct v4l2_fract) {1, 1};
+
+	return 0;
+}
+
+static int vidioc_g_parm(struct file *file, void *priv,
+			  struct v4l2_streamparm *parm)
+{
+	struct bm2835_mmal_dev *dev = video_drvdata(file);
+
+	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	parm->parm.capture.capability   = V4L2_CAP_TIMEPERFRAME;
+	parm->parm.capture.timeperframe = dev->capture.timeperframe;
+	parm->parm.capture.readbuffers  = 1;
+	return 0;
+}
+
+#define FRACT_CMP(a, OP, b)	\
+	((u64)(a).numerator * (b).denominator  OP  \
+	 (u64)(b).numerator * (a).denominator)
+
+static int vidioc_s_parm(struct file *file, void *priv,
+			  struct v4l2_streamparm *parm)
+{
+	struct bm2835_mmal_dev *dev = video_drvdata(file);
+	struct v4l2_fract tpf;
+	struct mmal_parameter_rational fps_param;
+
+	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	tpf = parm->parm.capture.timeperframe;
+
+	/* tpf: {*, 0} resets timing; clip to [min, max]*/
+	tpf = tpf.denominator ? tpf : tpf_default;
+	tpf = FRACT_CMP(tpf, <, tpf_min) ? tpf_min : tpf;
+	tpf = FRACT_CMP(tpf, >, tpf_max) ? tpf_max : tpf;
+
+	dev->capture.timeperframe = tpf;
+	parm->parm.capture.timeperframe = tpf;
+	parm->parm.capture.readbuffers  = 1;
+	parm->parm.capture.capability   = V4L2_CAP_TIMEPERFRAME;
+
+	fps_param.num = 0;	/* Select variable fps, and then use
+				 * FPS_RANGE to select the actual limits.
+				 */
+	fps_param.den = 1;
+	set_framerate_params(dev);
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops camera0_ioctl_ops = {
+	/* overlay */
+	.vidioc_enum_fmt_vid_overlay = vidioc_enum_fmt_vid_overlay,
+	.vidioc_g_fmt_vid_overlay = vidioc_g_fmt_vid_overlay,
+	.vidioc_try_fmt_vid_overlay = vidioc_try_fmt_vid_overlay,
+	.vidioc_s_fmt_vid_overlay = vidioc_s_fmt_vid_overlay,
+	.vidioc_overlay = vidioc_overlay,
+	.vidioc_g_fbuf = vidioc_g_fbuf,
+
+	/* inputs */
+	.vidioc_enum_input = vidioc_enum_input,
+	.vidioc_g_input = vidioc_g_input,
+	.vidioc_s_input = vidioc_s_input,
+
+	/* capture */
+	.vidioc_querycap = vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
+
+	/* buffer management */
+	.vidioc_reqbufs = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf = vb2_ioctl_querybuf,
+	.vidioc_qbuf = vb2_ioctl_qbuf,
+	.vidioc_dqbuf = vb2_ioctl_dqbuf,
+	.vidioc_enum_framesizes = vidioc_enum_framesizes,
+	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
+	.vidioc_g_parm        = vidioc_g_parm,
+	.vidioc_s_parm        = vidioc_s_parm,
+	.vidioc_streamon = vb2_ioctl_streamon,
+	.vidioc_streamoff = vb2_ioctl_streamoff,
+
+	.vidioc_log_status = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+};
+
+static const struct v4l2_ioctl_ops camera0_ioctl_ops_gstreamer = {
+	/* overlay */
+	.vidioc_enum_fmt_vid_overlay = vidioc_enum_fmt_vid_overlay,
+	.vidioc_g_fmt_vid_overlay = vidioc_g_fmt_vid_overlay,
+	.vidioc_try_fmt_vid_overlay = vidioc_try_fmt_vid_overlay,
+	.vidioc_s_fmt_vid_overlay = vidioc_s_fmt_vid_overlay,
+	.vidioc_overlay = vidioc_overlay,
+	.vidioc_g_fbuf = vidioc_g_fbuf,
+
+	/* inputs */
+	.vidioc_enum_input = vidioc_enum_input,
+	.vidioc_g_input = vidioc_g_input,
+	.vidioc_s_input = vidioc_s_input,
+
+	/* capture */
+	.vidioc_querycap = vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
+
+	/* buffer management */
+	.vidioc_reqbufs = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf = vb2_ioctl_querybuf,
+	.vidioc_qbuf = vb2_ioctl_qbuf,
+	.vidioc_dqbuf = vb2_ioctl_dqbuf,
+	/* Remove this function ptr to fix gstreamer bug
+	.vidioc_enum_framesizes = vidioc_enum_framesizes, */
+	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
+	.vidioc_g_parm        = vidioc_g_parm,
+	.vidioc_s_parm        = vidioc_s_parm,
+	.vidioc_streamon = vb2_ioctl_streamon,
+	.vidioc_streamoff = vb2_ioctl_streamoff,
+
+	.vidioc_log_status = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+};
+
+/* ------------------------------------------------------------------
+	Driver init/finalise
+   ------------------------------------------------------------------*/
+
+static const struct v4l2_file_operations camera0_fops = {
+	.owner = THIS_MODULE,
+	.open = v4l2_fh_open,
+	.release = vb2_fop_release,
+	.read = vb2_fop_read,
+	.poll = vb2_fop_poll,
+	.unlocked_ioctl = video_ioctl2,	/* V4L2 ioctl handler */
+	.mmap = vb2_fop_mmap,
+};
+
+static struct video_device vdev_template = {
+	.name = "camera0",
+	.fops = &camera0_fops,
+	.ioctl_ops = &camera0_ioctl_ops,
+	.release = video_device_release_empty,
+};
+
+/* Returns the number of cameras, and also the max resolution supported
+ * by those cameras.
+ */
+static int get_num_cameras(struct vchiq_mmal_instance *instance,
+	unsigned int resolutions[][2], int num_resolutions)
+{
+	int ret;
+	struct vchiq_mmal_component  *cam_info_component;
+	struct mmal_parameter_camera_info_t cam_info = {0};
+	int param_size = sizeof(cam_info);
+	int i;
+
+	/* create a camera_info component */
+	ret = vchiq_mmal_component_init(instance, "camera_info",
+					&cam_info_component);
+	if (ret < 0)
+		/* Unusual failure - let's guess one camera. */
+		return 1;
+
+	if (vchiq_mmal_port_parameter_get(instance,
+					  &cam_info_component->control,
+					  MMAL_PARAMETER_CAMERA_INFO,
+					  &cam_info,
+					  &param_size)) {
+		pr_info("Failed to get camera info\n");
+	}
+	for (i = 0;
+	     i < (cam_info.num_cameras > num_resolutions ?
+			num_resolutions :
+			cam_info.num_cameras);
+	     i++) {
+		resolutions[i][0] = cam_info.cameras[i].max_width;
+		resolutions[i][1] = cam_info.cameras[i].max_height;
+	}
+
+	vchiq_mmal_component_finalise(instance,
+				      cam_info_component);
+
+	return cam_info.num_cameras;
+}
+
+static int set_camera_parameters(struct vchiq_mmal_instance *instance,
+				 struct vchiq_mmal_component *camera,
+				 struct bm2835_mmal_dev *dev)
+{
+	int ret;
+	struct mmal_parameter_camera_config cam_config = {
+		.max_stills_w = dev->max_width,
+		.max_stills_h = dev->max_height,
+		.stills_yuv422 = 1,
+		.one_shot_stills = 1,
+		.max_preview_video_w = (max_video_width > 1920) ?
+						max_video_width : 1920,
+		.max_preview_video_h = (max_video_height > 1088) ?
+						max_video_height : 1088,
+		.num_preview_video_frames = 3,
+		.stills_capture_circular_buffer_height = 0,
+		.fast_preview_resume = 0,
+		.use_stc_timestamp = MMAL_PARAM_TIMESTAMP_MODE_RAW_STC
+	};
+
+	ret = vchiq_mmal_port_parameter_set(instance, &camera->control,
+					    MMAL_PARAMETER_CAMERA_CONFIG,
+					    &cam_config, sizeof(cam_config));
+	return ret;
+}
+
+#define MAX_SUPPORTED_ENCODINGS 20
+
+/* MMAL instance and component init */
+static int __init mmal_init(struct bm2835_mmal_dev *dev)
+{
+	int ret;
+	struct mmal_es_format *format;
+	u32 bool_true = 1;
+	u32 supported_encodings[MAX_SUPPORTED_ENCODINGS];
+	int param_size;
+	struct vchiq_mmal_component  *camera;
+
+	ret = vchiq_mmal_init(&dev->instance);
+	if (ret < 0)
+		return ret;
+
+	/* get the camera component ready */
+	ret = vchiq_mmal_component_init(dev->instance, "ril.camera",
+					&dev->component[MMAL_COMPONENT_CAMERA]);
+	if (ret < 0)
+		goto unreg_mmal;
+
+	camera = dev->component[MMAL_COMPONENT_CAMERA];
+	if (camera->outputs <  MMAL_CAMERA_PORT_COUNT) {
+		ret = -EINVAL;
+		goto unreg_camera;
+	}
+
+	ret = set_camera_parameters(dev->instance,
+				    camera,
+				    dev);
+	if (ret < 0)
+		goto unreg_camera;
+
+	/* There was an error in the firmware that meant the camera component
+	 * produced BGR instead of RGB.
+	 * This is now fixed, but in order to support the old firmwares, we
+	 * have to check.
+	 */
+	dev->rgb_bgr_swapped = true;
+	param_size = sizeof(supported_encodings);
+	ret = vchiq_mmal_port_parameter_get(dev->instance,
+		&camera->output[MMAL_CAMERA_PORT_CAPTURE],
+		MMAL_PARAMETER_SUPPORTED_ENCODINGS,
+		&supported_encodings,
+		&param_size);
+	if (ret == 0) {
+		int i;
+
+		for (i = 0; i < param_size/sizeof(u32); i++) {
+			if (supported_encodings[i] == MMAL_ENCODING_BGR24) {
+				/* Found BGR24 first - old firmware. */
+				break;
+			}
+			if (supported_encodings[i] == MMAL_ENCODING_RGB24) {
+				/* Found RGB24 first
+				 * new firmware, so use RGB24.
+				 */
+				dev->rgb_bgr_swapped = false;
+			break;
+			}
+		}
+	}
+	format = &camera->output[MMAL_CAMERA_PORT_PREVIEW].format;
+
+	format->encoding = MMAL_ENCODING_OPAQUE;
+	format->encoding_variant = MMAL_ENCODING_I420;
+
+	format->es->video.width = 1024;
+	format->es->video.height = 768;
+	format->es->video.crop.x = 0;
+	format->es->video.crop.y = 0;
+	format->es->video.crop.width = 1024;
+	format->es->video.crop.height = 768;
+	format->es->video.frame_rate.num = 0; /* Rely on fps_range */
+	format->es->video.frame_rate.den = 1;
+
+	format = &camera->output[MMAL_CAMERA_PORT_VIDEO].format;
+
+	format->encoding = MMAL_ENCODING_OPAQUE;
+	format->encoding_variant = MMAL_ENCODING_I420;
+
+	format->es->video.width = 1024;
+	format->es->video.height = 768;
+	format->es->video.crop.x = 0;
+	format->es->video.crop.y = 0;
+	format->es->video.crop.width = 1024;
+	format->es->video.crop.height = 768;
+	format->es->video.frame_rate.num = 0; /* Rely on fps_range */
+	format->es->video.frame_rate.den = 1;
+
+	vchiq_mmal_port_parameter_set(dev->instance,
+		&camera->output[MMAL_CAMERA_PORT_VIDEO],
+		MMAL_PARAMETER_NO_IMAGE_PADDING,
+		&bool_true, sizeof(bool_true));
+
+	format = &camera->output[MMAL_CAMERA_PORT_CAPTURE].format;
+
+	format->encoding = MMAL_ENCODING_OPAQUE;
+
+	format->es->video.width = 2592;
+	format->es->video.height = 1944;
+	format->es->video.crop.x = 0;
+	format->es->video.crop.y = 0;
+	format->es->video.crop.width = 2592;
+	format->es->video.crop.height = 1944;
+	format->es->video.frame_rate.num = 0; /* Rely on fps_range */
+	format->es->video.frame_rate.den = 1;
+
+	dev->capture.width = format->es->video.width;
+	dev->capture.height = format->es->video.height;
+	dev->capture.fmt = &formats[0];
+	dev->capture.encode_component = NULL;
+	dev->capture.timeperframe = tpf_default;
+	dev->capture.enc_profile = V4L2_MPEG_VIDEO_H264_PROFILE_HIGH;
+	dev->capture.enc_level = V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
+
+	vchiq_mmal_port_parameter_set(dev->instance,
+		&camera->output[MMAL_CAMERA_PORT_CAPTURE],
+		MMAL_PARAMETER_NO_IMAGE_PADDING,
+		&bool_true, sizeof(bool_true));
+
+	/* get the preview component ready */
+	ret = vchiq_mmal_component_init(
+			dev->instance, "ril.video_render",
+			&dev->component[MMAL_COMPONENT_PREVIEW]);
+	if (ret < 0)
+		goto unreg_camera;
+
+	if (dev->component[MMAL_COMPONENT_PREVIEW]->inputs < 1) {
+		ret = -EINVAL;
+		pr_debug("too few input ports %d needed %d\n",
+			 dev->component[MMAL_COMPONENT_PREVIEW]->inputs, 1);
+		goto unreg_preview;
+	}
+
+	/* get the image encoder component ready */
+	ret = vchiq_mmal_component_init(
+		dev->instance, "ril.image_encode",
+		&dev->component[MMAL_COMPONENT_IMAGE_ENCODE]);
+	if (ret < 0)
+		goto unreg_preview;
+
+	if (dev->component[MMAL_COMPONENT_IMAGE_ENCODE]->inputs < 1) {
+		ret = -EINVAL;
+		v4l2_err(&dev->v4l2_dev, "too few input ports %d needed %d\n",
+			 dev->component[MMAL_COMPONENT_IMAGE_ENCODE]->inputs,
+			 1);
+		goto unreg_image_encoder;
+	}
+
+	/* get the video encoder component ready */
+	ret = vchiq_mmal_component_init(dev->instance, "ril.video_encode",
+					&dev->
+					component[MMAL_COMPONENT_VIDEO_ENCODE]);
+	if (ret < 0)
+		goto unreg_image_encoder;
+
+	if (dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->inputs < 1) {
+		ret = -EINVAL;
+		v4l2_err(&dev->v4l2_dev, "too few input ports %d needed %d\n",
+			 dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->inputs,
+			 1);
+		goto unreg_vid_encoder;
+	}
+
+	{
+		struct vchiq_mmal_port *encoder_port =
+			&dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0];
+		encoder_port->format.encoding = MMAL_ENCODING_H264;
+		ret = vchiq_mmal_port_set_format(dev->instance,
+			encoder_port);
+	}
+
+	{
+		unsigned int enable = 1;
+		vchiq_mmal_port_parameter_set(
+			dev->instance,
+			&dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->control,
+			MMAL_PARAMETER_VIDEO_IMMUTABLE_INPUT,
+			&enable, sizeof(enable));
+
+		vchiq_mmal_port_parameter_set(dev->instance,
+			&dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->control,
+			MMAL_PARAMETER_MINIMISE_FRAGMENTATION,
+			&enable,
+			sizeof(enable));
+	}
+	ret = bm2835_mmal_set_all_camera_controls(dev);
+	if (ret < 0)
+		goto unreg_vid_encoder;
+
+	return 0;
+
+unreg_vid_encoder:
+	pr_err("Cleanup: Destroy video encoder\n");
+	vchiq_mmal_component_finalise(
+		dev->instance,
+		dev->component[MMAL_COMPONENT_VIDEO_ENCODE]);
+
+unreg_image_encoder:
+	pr_err("Cleanup: Destroy image encoder\n");
+	vchiq_mmal_component_finalise(
+		dev->instance,
+		dev->component[MMAL_COMPONENT_IMAGE_ENCODE]);
+
+unreg_preview:
+	pr_err("Cleanup: Destroy video render\n");
+	vchiq_mmal_component_finalise(dev->instance,
+				      dev->component[MMAL_COMPONENT_PREVIEW]);
+
+unreg_camera:
+	pr_err("Cleanup: Destroy camera\n");
+	vchiq_mmal_component_finalise(dev->instance,
+				      dev->component[MMAL_COMPONENT_CAMERA]);
+
+unreg_mmal:
+	vchiq_mmal_finalise(dev->instance);
+	return ret;
+}
+
+static int __init bm2835_mmal_init_device(struct bm2835_mmal_dev *dev,
+					  struct video_device *vfd)
+{
+	int ret;
+
+	*vfd = vdev_template;
+	if (gst_v4l2src_is_broken) {
+		v4l2_info(&dev->v4l2_dev,
+		  "Work-around for gstreamer issue is active.\n");
+		vfd->ioctl_ops = &camera0_ioctl_ops_gstreamer;
+	}
+
+	vfd->v4l2_dev = &dev->v4l2_dev;
+
+	vfd->lock = &dev->mutex;
+
+	vfd->queue = &dev->capture.vb_vidq;
+
+	/* video device needs to be able to access instance data */
+	video_set_drvdata(vfd, dev);
+
+	ret = video_register_device(vfd,
+				    VFL_TYPE_GRABBER,
+				    video_nr[dev->camera_num]);
+	if (ret < 0)
+		return ret;
+
+	v4l2_info(vfd->v4l2_dev,
+		"V4L2 device registered as %s - stills mode > %dx%d\n",
+		video_device_node_name(vfd), max_video_width, max_video_height);
+
+	return 0;
+}
+
+void bcm2835_cleanup_instance(struct bm2835_mmal_dev *dev)
+{
+	if (!dev)
+		return;
+
+	v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
+		  video_device_node_name(&dev->vdev));
+
+	video_unregister_device(&dev->vdev);
+
+	if (dev->capture.encode_component) {
+		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+			 "mmal_exit - disconnect tunnel\n");
+		vchiq_mmal_port_connect_tunnel(dev->instance,
+					       dev->capture.camera_port, NULL);
+		vchiq_mmal_component_disable(dev->instance,
+					     dev->capture.encode_component);
+	}
+	vchiq_mmal_component_disable(dev->instance,
+				     dev->component[MMAL_COMPONENT_CAMERA]);
+
+	vchiq_mmal_component_finalise(dev->instance,
+				      dev->
+				      component[MMAL_COMPONENT_VIDEO_ENCODE]);
+
+	vchiq_mmal_component_finalise(dev->instance,
+				      dev->
+				      component[MMAL_COMPONENT_IMAGE_ENCODE]);
+
+	vchiq_mmal_component_finalise(dev->instance,
+				      dev->component[MMAL_COMPONENT_PREVIEW]);
+
+	vchiq_mmal_component_finalise(dev->instance,
+				      dev->component[MMAL_COMPONENT_CAMERA]);
+
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+
+	v4l2_device_unregister(&dev->v4l2_dev);
+
+	kfree(dev);
+}
+
+static struct v4l2_format default_v4l2_format = {
+	.fmt.pix.pixelformat = V4L2_PIX_FMT_JPEG,
+	.fmt.pix.width = 1024,
+	.fmt.pix.bytesperline = 0,
+	.fmt.pix.height = 768,
+	.fmt.pix.sizeimage = 1024*768,
+};
+
+static int __init bm2835_mmal_init(void)
+{
+	int ret;
+	struct bm2835_mmal_dev *dev;
+	struct vb2_queue *q;
+	int camera;
+	unsigned int num_cameras;
+	struct vchiq_mmal_instance *instance;
+	unsigned int resolutions[MAX_BCM2835_CAMERAS][2];
+
+	ret = vchiq_mmal_init(&instance);
+	if (ret < 0)
+		return ret;
+
+	num_cameras = get_num_cameras(instance,
+				      resolutions,
+				      MAX_BCM2835_CAMERAS);
+	if (num_cameras > MAX_BCM2835_CAMERAS)
+		num_cameras = MAX_BCM2835_CAMERAS;
+
+	for (camera = 0; camera < num_cameras; camera++) {
+		dev = kzalloc(sizeof(struct bm2835_mmal_dev), GFP_KERNEL);
+		if (!dev)
+			return -ENOMEM;
+
+		dev->camera_num = camera;
+		dev->max_width = resolutions[camera][0];
+		dev->max_height = resolutions[camera][1];
+
+		/* setup device defaults */
+		dev->overlay.w.left = 150;
+		dev->overlay.w.top = 50;
+		dev->overlay.w.width = 1024;
+		dev->overlay.w.height = 768;
+		dev->overlay.clipcount = 0;
+		dev->overlay.field = V4L2_FIELD_NONE;
+		dev->overlay.global_alpha = 255;
+
+		dev->capture.fmt = &formats[3]; /* JPEG */
+
+		/* v4l device registration */
+		snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
+			 "%s", BM2835_MMAL_MODULE_NAME);
+		ret = v4l2_device_register(NULL, &dev->v4l2_dev);
+		if (ret)
+			goto free_dev;
+
+		/* setup v4l controls */
+		ret = bm2835_mmal_init_controls(dev, &dev->ctrl_handler);
+		if (ret < 0)
+			goto unreg_dev;
+		dev->v4l2_dev.ctrl_handler = &dev->ctrl_handler;
+
+		/* mmal init */
+		dev->instance = instance;
+		ret = mmal_init(dev);
+		if (ret < 0)
+			goto unreg_dev;
+
+		/* initialize queue */
+		q = &dev->capture.vb_vidq;
+		memset(q, 0, sizeof(*q));
+		q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
+		q->drv_priv = dev;
+		q->buf_struct_size = sizeof(struct mmal_buffer);
+		q->ops = &bm2835_mmal_video_qops;
+		q->mem_ops = &vb2_vmalloc_memops;
+		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		ret = vb2_queue_init(q);
+		if (ret < 0)
+			goto unreg_dev;
+
+		/* v4l2 core mutex used to protect all fops and v4l2 ioctls. */
+		mutex_init(&dev->mutex);
+
+		/* initialise video devices */
+		ret = bm2835_mmal_init_device(dev, &dev->vdev);
+		if (ret < 0)
+			goto unreg_dev;
+
+		/* Really want to call vidioc_s_fmt_vid_cap with the default
+		 * format, but currently the APIs don't join up.
+		 */
+		ret = mmal_setup_components(dev, &default_v4l2_format);
+		if (ret < 0) {
+			v4l2_err(&dev->v4l2_dev,
+				 "%s: could not setup components\n", __func__);
+			goto unreg_dev;
+		}
+
+		v4l2_info(&dev->v4l2_dev,
+			  "Broadcom 2835 MMAL video capture ver %s loaded.\n",
+			  BM2835_MMAL_VERSION);
+
+		gdev[camera] = dev;
+	}
+	return 0;
+
+unreg_dev:
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+	v4l2_device_unregister(&dev->v4l2_dev);
+
+free_dev:
+	kfree(dev);
+
+	for ( ; camera > 0; camera--) {
+		bcm2835_cleanup_instance(gdev[camera]);
+		gdev[camera] = NULL;
+	}
+	pr_info("%s: error %d while loading driver\n",
+		 BM2835_MMAL_MODULE_NAME, ret);
+
+	return ret;
+}
+
+static void __exit bm2835_mmal_exit(void)
+{
+	int camera;
+	struct vchiq_mmal_instance *instance = gdev[0]->instance;
+
+	for (camera = 0; camera < MAX_BCM2835_CAMERAS; camera++) {
+		bcm2835_cleanup_instance(gdev[camera]);
+		gdev[camera] = NULL;
+	}
+	vchiq_mmal_finalise(instance);
+}
+
+module_init(bm2835_mmal_init);
+module_exit(bm2835_mmal_exit);
diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.h b/drivers/staging/media/platform/bcm2835/bcm2835-camera.h
new file mode 100644
index 000000000000..e6aeb7e7e381
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.h
@@ -0,0 +1,145 @@
+/*
+ * Broadcom BM2835 V4L2 driver
+ *
+ * Copyright © 2013 Raspberry Pi (Trading) Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
+ *          Dave Stevenson <dsteve@broadcom.com>
+ *          Simon Mellor <simellor@broadcom.com>
+ *          Luke Diamand <luked@broadcom.com>
+ *
+ * core driver device
+ */
+
+#define V4L2_CTRL_COUNT 29 /* number of v4l controls */
+
+enum {
+	MMAL_COMPONENT_CAMERA = 0,
+	MMAL_COMPONENT_PREVIEW,
+	MMAL_COMPONENT_IMAGE_ENCODE,
+	MMAL_COMPONENT_VIDEO_ENCODE,
+	MMAL_COMPONENT_COUNT
+};
+
+enum {
+	MMAL_CAMERA_PORT_PREVIEW = 0,
+	MMAL_CAMERA_PORT_VIDEO,
+	MMAL_CAMERA_PORT_CAPTURE,
+	MMAL_CAMERA_PORT_COUNT
+};
+
+#define PREVIEW_LAYER      2
+
+extern int bcm2835_v4l2_debug;
+
+struct bm2835_mmal_dev {
+	/* v4l2 devices */
+	struct v4l2_device     v4l2_dev;
+	struct video_device    vdev;
+	struct mutex           mutex;
+
+	/* controls */
+	struct v4l2_ctrl_handler  ctrl_handler;
+	struct v4l2_ctrl          *ctrls[V4L2_CTRL_COUNT];
+	enum v4l2_scene_mode	  scene_mode;
+	struct mmal_colourfx      colourfx;
+	int                       hflip;
+	int                       vflip;
+	int			  red_gain;
+	int			  blue_gain;
+	enum mmal_parameter_exposuremode exposure_mode_user;
+	enum v4l2_exposure_auto_type exposure_mode_v4l2_user;
+	/* active exposure mode may differ if selected via a scene mode */
+	enum mmal_parameter_exposuremode exposure_mode_active;
+	enum mmal_parameter_exposuremeteringmode metering_mode;
+	unsigned int		  manual_shutter_speed;
+	bool			  exp_auto_priority;
+	bool manual_iso_enabled;
+	uint32_t iso;
+
+	/* allocated mmal instance and components */
+	struct vchiq_mmal_instance   *instance;
+	struct vchiq_mmal_component  *component[MMAL_COMPONENT_COUNT];
+	int camera_use_count;
+
+	struct v4l2_window overlay;
+
+	struct {
+		unsigned int     width;  /* width */
+		unsigned int     height;  /* height */
+		unsigned int     stride;  /* stride */
+		unsigned int     buffersize; /* buffer size with padding */
+		struct mmal_fmt  *fmt;
+		struct v4l2_fract timeperframe;
+
+		/* H264 encode bitrate */
+		int         encode_bitrate;
+		/* H264 bitrate mode. CBR/VBR */
+		int         encode_bitrate_mode;
+		/* H264 profile */
+		enum v4l2_mpeg_video_h264_profile enc_profile;
+		/* H264 level */
+		enum v4l2_mpeg_video_h264_level enc_level;
+		/* JPEG Q-factor */
+		int         q_factor;
+
+		struct vb2_queue	vb_vidq;
+
+		/* VC start timestamp for streaming */
+		s64         vc_start_timestamp;
+		/* Kernel start timestamp for streaming */
+		struct timeval kernel_start_ts;
+
+		struct vchiq_mmal_port  *port; /* port being used for capture */
+		/* camera port being used for capture */
+		struct vchiq_mmal_port  *camera_port;
+		/* component being used for encode */
+		struct vchiq_mmal_component *encode_component;
+		/* number of frames remaining which driver should capture */
+		unsigned int  frame_count;
+		/* last frame completion */
+		struct completion  frame_cmplt;
+
+	} capture;
+
+	unsigned int camera_num;
+	unsigned int max_width;
+	unsigned int max_height;
+	unsigned int rgb_bgr_swapped;
+};
+
+int bm2835_mmal_init_controls(
+			struct bm2835_mmal_dev *dev,
+			struct v4l2_ctrl_handler *hdl);
+
+int bm2835_mmal_set_all_camera_controls(struct bm2835_mmal_dev *dev);
+int set_framerate_params(struct bm2835_mmal_dev *dev);
+
+/* Debug helpers */
+
+#define v4l2_dump_pix_format(level, debug, dev, pix_fmt, desc)	\
+{	\
+	v4l2_dbg(level, debug, dev,	\
+"%s: w %u h %u field %u pfmt 0x%x bpl %u sz_img %u colorspace 0x%x priv %u\n", \
+		desc == NULL ? "" : desc,	\
+		(pix_fmt)->width, (pix_fmt)->height, (pix_fmt)->field,	\
+		(pix_fmt)->pixelformat, (pix_fmt)->bytesperline,	\
+		(pix_fmt)->sizeimage, (pix_fmt)->colorspace, (pix_fmt)->priv); \
+}
+#define v4l2_dump_win_format(level, debug, dev, win_fmt, desc)	\
+{	\
+	v4l2_dbg(level, debug, dev,	\
+"%s: w %u h %u l %u t %u  field %u chromakey %06X clip %p " \
+"clipcount %u bitmap %p\n", \
+		desc == NULL ? "" : desc,	\
+		(win_fmt)->w.width, (win_fmt)->w.height, \
+		(win_fmt)->w.left, (win_fmt)->w.top, \
+		(win_fmt)->field,	\
+		(win_fmt)->chromakey,	\
+		(win_fmt)->clips, (win_fmt)->clipcount,	\
+		(win_fmt)->bitmap); \
+}
diff --git a/drivers/staging/media/platform/bcm2835/controls.c b/drivers/staging/media/platform/bcm2835/controls.c
new file mode 100644
index 000000000000..fe61330ba2a6
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/controls.c
@@ -0,0 +1,1345 @@
+/*
+ * Broadcom BM2835 V4L2 driver
+ *
+ * Copyright © 2013 Raspberry Pi (Trading) Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
+ *          Dave Stevenson <dsteve@broadcom.com>
+ *          Simon Mellor <simellor@broadcom.com>
+ *          Luke Diamand <luked@broadcom.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <media/videobuf2-vmalloc.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-common.h>
+
+#include "mmal-common.h"
+#include "mmal-vchiq.h"
+#include "mmal-parameters.h"
+#include "bcm2835-camera.h"
+
+/* The supported V4L2_CID_AUTO_EXPOSURE_BIAS values are from -4.0 to +4.0.
+ * MMAL values are in 1/6th increments so the MMAL range is -24 to +24.
+ * V4L2 docs say value "is expressed in terms of EV, drivers should interpret
+ * the values as 0.001 EV units, where the value 1000 stands for +1 EV."
+ * V4L2 is limited to a max of 32 values in a menu, so count in 1/3rds from
+ * -4 to +4
+ */
+static const s64 ev_bias_qmenu[] = {
+	-4000, -3667, -3333,
+	-3000, -2667, -2333,
+	-2000, -1667, -1333,
+	-1000,  -667,  -333,
+	    0,   333,   667,
+	 1000,  1333,  1667,
+	 2000,  2333,  2667,
+	 3000,  3333,  3667,
+	 4000
+};
+
+/* Supported ISO values (*1000)
+ * ISOO = auto ISO
+ */
+static const s64 iso_qmenu[] = {
+	0, 100000, 200000, 400000, 800000,
+};
+static const uint32_t iso_values[] = {
+	0, 100, 200, 400, 800,
+};
+
+static const s64 mains_freq_qmenu[] = {
+	V4L2_CID_POWER_LINE_FREQUENCY_DISABLED,
+	V4L2_CID_POWER_LINE_FREQUENCY_50HZ,
+	V4L2_CID_POWER_LINE_FREQUENCY_60HZ,
+	V4L2_CID_POWER_LINE_FREQUENCY_AUTO
+};
+
+/* Supported video encode modes */
+static const s64 bitrate_mode_qmenu[] = {
+	(s64)V4L2_MPEG_VIDEO_BITRATE_MODE_VBR,
+	(s64)V4L2_MPEG_VIDEO_BITRATE_MODE_CBR,
+};
+
+enum bm2835_mmal_ctrl_type {
+	MMAL_CONTROL_TYPE_STD,
+	MMAL_CONTROL_TYPE_STD_MENU,
+	MMAL_CONTROL_TYPE_INT_MENU,
+	MMAL_CONTROL_TYPE_CLUSTER, /* special cluster entry */
+};
+
+struct bm2835_mmal_v4l2_ctrl;
+
+typedef	int(bm2835_mmal_v4l2_ctrl_cb)(
+				struct bm2835_mmal_dev *dev,
+				struct v4l2_ctrl *ctrl,
+				const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl);
+
+struct bm2835_mmal_v4l2_ctrl {
+	u32 id; /* v4l2 control identifier */
+	enum bm2835_mmal_ctrl_type type;
+	/* control minimum value or
+	 * mask for MMAL_CONTROL_TYPE_STD_MENU */
+	s32 min;
+	s32 max; /* maximum value of control */
+	s32 def;  /* default value of control */
+	s32 step; /* step size of the control */
+	const s64 *imenu; /* integer menu array */
+	u32 mmal_id; /* mmal parameter id */
+	bm2835_mmal_v4l2_ctrl_cb *setter;
+	bool ignore_errors;
+};
+
+struct v4l2_to_mmal_effects_setting {
+	u32 v4l2_effect;
+	u32 mmal_effect;
+	s32 col_fx_enable;
+	s32 col_fx_fixed_cbcr;
+	u32 u;
+	u32 v;
+	u32 num_effect_params;
+	u32 effect_params[MMAL_MAX_IMAGEFX_PARAMETERS];
+};
+
+static const struct v4l2_to_mmal_effects_setting
+	v4l2_to_mmal_effects_values[] = {
+	{  V4L2_COLORFX_NONE,         MMAL_PARAM_IMAGEFX_NONE,
+		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
+	{  V4L2_COLORFX_BW,           MMAL_PARAM_IMAGEFX_NONE,
+		1,   0,    128,  128, 0, {0, 0, 0, 0, 0} },
+	{  V4L2_COLORFX_SEPIA,        MMAL_PARAM_IMAGEFX_NONE,
+		1,   0,    87,   151, 0, {0, 0, 0, 0, 0} },
+	{  V4L2_COLORFX_NEGATIVE,     MMAL_PARAM_IMAGEFX_NEGATIVE,
+		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
+	{  V4L2_COLORFX_EMBOSS,       MMAL_PARAM_IMAGEFX_EMBOSS,
+		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
+	{  V4L2_COLORFX_SKETCH,       MMAL_PARAM_IMAGEFX_SKETCH,
+		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
+	{  V4L2_COLORFX_SKY_BLUE,     MMAL_PARAM_IMAGEFX_PASTEL,
+		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
+	{  V4L2_COLORFX_GRASS_GREEN,  MMAL_PARAM_IMAGEFX_WATERCOLOUR,
+		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
+	{  V4L2_COLORFX_SKIN_WHITEN,  MMAL_PARAM_IMAGEFX_WASHEDOUT,
+		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
+	{  V4L2_COLORFX_VIVID,        MMAL_PARAM_IMAGEFX_SATURATION,
+		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
+	{  V4L2_COLORFX_AQUA,         MMAL_PARAM_IMAGEFX_NONE,
+		1,   0,    171,  121, 0, {0, 0, 0, 0, 0} },
+	{  V4L2_COLORFX_ART_FREEZE,   MMAL_PARAM_IMAGEFX_HATCH,
+		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
+	{  V4L2_COLORFX_SILHOUETTE,   MMAL_PARAM_IMAGEFX_FILM,
+		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
+	{  V4L2_COLORFX_SOLARIZATION, MMAL_PARAM_IMAGEFX_SOLARIZE,
+		0,   0,    0,    0,   5, {1, 128, 160, 160, 48} },
+	{  V4L2_COLORFX_ANTIQUE,      MMAL_PARAM_IMAGEFX_COLOURBALANCE,
+		0,   0,    0,    0,   3, {108, 274, 238, 0, 0} },
+	{  V4L2_COLORFX_SET_CBCR,     MMAL_PARAM_IMAGEFX_NONE,
+		1,   1,    0,    0,   0, {0, 0, 0, 0, 0} }
+};
+
+struct v4l2_mmal_scene_config {
+	enum v4l2_scene_mode			v4l2_scene;
+	enum mmal_parameter_exposuremode	exposure_mode;
+	enum mmal_parameter_exposuremeteringmode metering_mode;
+};
+
+static const struct v4l2_mmal_scene_config scene_configs[] = {
+	/* V4L2_SCENE_MODE_NONE automatically added */
+	{
+		V4L2_SCENE_MODE_NIGHT,
+		MMAL_PARAM_EXPOSUREMODE_NIGHT,
+		MMAL_PARAM_EXPOSUREMETERINGMODE_AVERAGE
+	},
+	{
+		V4L2_SCENE_MODE_SPORTS,
+		MMAL_PARAM_EXPOSUREMODE_SPORTS,
+		MMAL_PARAM_EXPOSUREMETERINGMODE_AVERAGE
+	},
+};
+
+/* control handlers*/
+
+static int ctrl_set_rational(struct bm2835_mmal_dev *dev,
+		      struct v4l2_ctrl *ctrl,
+		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	struct mmal_parameter_rational rational_value;
+	struct vchiq_mmal_port *control;
+
+	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
+
+	rational_value.num = ctrl->val;
+	rational_value.den = 100;
+
+	return vchiq_mmal_port_parameter_set(dev->instance, control,
+					     mmal_ctrl->mmal_id,
+					     &rational_value,
+					     sizeof(rational_value));
+}
+
+static int ctrl_set_value(struct bm2835_mmal_dev *dev,
+		      struct v4l2_ctrl *ctrl,
+		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	u32 u32_value;
+	struct vchiq_mmal_port *control;
+
+	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
+
+	u32_value = ctrl->val;
+
+	return vchiq_mmal_port_parameter_set(dev->instance, control,
+					     mmal_ctrl->mmal_id,
+					     &u32_value, sizeof(u32_value));
+}
+
+static int ctrl_set_iso(struct bm2835_mmal_dev *dev,
+		      struct v4l2_ctrl *ctrl,
+		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	u32 u32_value;
+	struct vchiq_mmal_port *control;
+
+	if (ctrl->val > mmal_ctrl->max || ctrl->val < mmal_ctrl->min)
+		return 1;
+
+	if (ctrl->id == V4L2_CID_ISO_SENSITIVITY)
+		dev->iso = iso_values[ctrl->val];
+	else if (ctrl->id == V4L2_CID_ISO_SENSITIVITY_AUTO)
+		dev->manual_iso_enabled =
+				(ctrl->val == V4L2_ISO_SENSITIVITY_MANUAL ?
+							true :
+							false);
+
+	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
+
+	if (dev->manual_iso_enabled)
+		u32_value = dev->iso;
+	else
+		u32_value = 0;
+
+	return vchiq_mmal_port_parameter_set(dev->instance, control,
+					     MMAL_PARAMETER_ISO,
+					     &u32_value, sizeof(u32_value));
+}
+
+static int ctrl_set_value_ev(struct bm2835_mmal_dev *dev,
+		      struct v4l2_ctrl *ctrl,
+		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	s32 s32_value;
+	struct vchiq_mmal_port *control;
+
+	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
+
+	s32_value = (ctrl->val-12)*2;	/* Convert from index to 1/6ths */
+
+	return vchiq_mmal_port_parameter_set(dev->instance, control,
+					     mmal_ctrl->mmal_id,
+					     &s32_value, sizeof(s32_value));
+}
+
+static int ctrl_set_rotate(struct bm2835_mmal_dev *dev,
+		      struct v4l2_ctrl *ctrl,
+		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	int ret;
+	u32 u32_value;
+	struct vchiq_mmal_component *camera;
+
+	camera = dev->component[MMAL_COMPONENT_CAMERA];
+
+	u32_value = ((ctrl->val % 360) / 90) * 90;
+
+	ret = vchiq_mmal_port_parameter_set(dev->instance, &camera->output[0],
+					    mmal_ctrl->mmal_id,
+					    &u32_value, sizeof(u32_value));
+	if (ret < 0)
+		return ret;
+
+	ret = vchiq_mmal_port_parameter_set(dev->instance, &camera->output[1],
+					    mmal_ctrl->mmal_id,
+					    &u32_value, sizeof(u32_value));
+	if (ret < 0)
+		return ret;
+
+	ret = vchiq_mmal_port_parameter_set(dev->instance, &camera->output[2],
+					    mmal_ctrl->mmal_id,
+					    &u32_value, sizeof(u32_value));
+
+	return ret;
+}
+
+static int ctrl_set_flip(struct bm2835_mmal_dev *dev,
+		      struct v4l2_ctrl *ctrl,
+		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	int ret;
+	u32 u32_value;
+	struct vchiq_mmal_component *camera;
+
+	if (ctrl->id == V4L2_CID_HFLIP)
+		dev->hflip = ctrl->val;
+	else
+		dev->vflip = ctrl->val;
+
+	camera = dev->component[MMAL_COMPONENT_CAMERA];
+
+	if (dev->hflip && dev->vflip)
+		u32_value = MMAL_PARAM_MIRROR_BOTH;
+	else if (dev->hflip)
+		u32_value = MMAL_PARAM_MIRROR_HORIZONTAL;
+	else if (dev->vflip)
+		u32_value = MMAL_PARAM_MIRROR_VERTICAL;
+	else
+		u32_value = MMAL_PARAM_MIRROR_NONE;
+
+	ret = vchiq_mmal_port_parameter_set(dev->instance, &camera->output[0],
+					    mmal_ctrl->mmal_id,
+					    &u32_value, sizeof(u32_value));
+	if (ret < 0)
+		return ret;
+
+	ret = vchiq_mmal_port_parameter_set(dev->instance, &camera->output[1],
+					    mmal_ctrl->mmal_id,
+					    &u32_value, sizeof(u32_value));
+	if (ret < 0)
+		return ret;
+
+	ret = vchiq_mmal_port_parameter_set(dev->instance, &camera->output[2],
+					    mmal_ctrl->mmal_id,
+					    &u32_value, sizeof(u32_value));
+
+	return ret;
+
+}
+
+static int ctrl_set_exposure(struct bm2835_mmal_dev *dev,
+		      struct v4l2_ctrl *ctrl,
+		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	enum mmal_parameter_exposuremode exp_mode = dev->exposure_mode_user;
+	u32 shutter_speed = 0;
+	struct vchiq_mmal_port *control;
+	int ret = 0;
+
+	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
+
+	if (mmal_ctrl->mmal_id == MMAL_PARAMETER_SHUTTER_SPEED)	{
+		/* V4L2 is in 100usec increments.
+		 * MMAL is 1usec.
+		 */
+		dev->manual_shutter_speed = ctrl->val * 100;
+	} else if (mmal_ctrl->mmal_id == MMAL_PARAMETER_EXPOSURE_MODE) {
+		switch (ctrl->val) {
+		case V4L2_EXPOSURE_AUTO:
+			exp_mode = MMAL_PARAM_EXPOSUREMODE_AUTO;
+			break;
+
+		case V4L2_EXPOSURE_MANUAL:
+			exp_mode = MMAL_PARAM_EXPOSUREMODE_OFF;
+			break;
+		}
+		dev->exposure_mode_user = exp_mode;
+		dev->exposure_mode_v4l2_user = ctrl->val;
+	} else if (mmal_ctrl->id == V4L2_CID_EXPOSURE_AUTO_PRIORITY) {
+		dev->exp_auto_priority = ctrl->val;
+	}
+
+	if (dev->scene_mode == V4L2_SCENE_MODE_NONE) {
+		if (exp_mode == MMAL_PARAM_EXPOSUREMODE_OFF)
+			shutter_speed = dev->manual_shutter_speed;
+
+		ret = vchiq_mmal_port_parameter_set(dev->instance,
+					control,
+					MMAL_PARAMETER_SHUTTER_SPEED,
+					&shutter_speed,
+					sizeof(shutter_speed));
+		ret += vchiq_mmal_port_parameter_set(dev->instance,
+					control,
+					MMAL_PARAMETER_EXPOSURE_MODE,
+					&exp_mode,
+					sizeof(u32));
+		dev->exposure_mode_active = exp_mode;
+	}
+	/* exposure_dynamic_framerate (V4L2_CID_EXPOSURE_AUTO_PRIORITY) should
+	 * always apply irrespective of scene mode.
+	 */
+	ret += set_framerate_params(dev);
+
+	return ret;
+}
+
+static int ctrl_set_metering_mode(struct bm2835_mmal_dev *dev,
+			   struct v4l2_ctrl *ctrl,
+			   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	switch (ctrl->val) {
+	case V4L2_EXPOSURE_METERING_AVERAGE:
+		dev->metering_mode = MMAL_PARAM_EXPOSUREMETERINGMODE_AVERAGE;
+		break;
+
+	case V4L2_EXPOSURE_METERING_CENTER_WEIGHTED:
+		dev->metering_mode = MMAL_PARAM_EXPOSUREMETERINGMODE_BACKLIT;
+		break;
+
+	case V4L2_EXPOSURE_METERING_SPOT:
+		dev->metering_mode = MMAL_PARAM_EXPOSUREMETERINGMODE_SPOT;
+		break;
+
+	/* todo matrix weighting not added to Linux API till 3.9
+	case V4L2_EXPOSURE_METERING_MATRIX:
+		dev->metering_mode = MMAL_PARAM_EXPOSUREMETERINGMODE_MATRIX;
+		break;
+	*/
+
+	}
+
+	if (dev->scene_mode == V4L2_SCENE_MODE_NONE) {
+		struct vchiq_mmal_port *control;
+		u32 u32_value = dev->metering_mode;
+
+		control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
+
+		return vchiq_mmal_port_parameter_set(dev->instance, control,
+					     mmal_ctrl->mmal_id,
+					     &u32_value, sizeof(u32_value));
+	} else
+		return 0;
+}
+
+static int ctrl_set_flicker_avoidance(struct bm2835_mmal_dev *dev,
+			   struct v4l2_ctrl *ctrl,
+			   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	u32 u32_value;
+	struct vchiq_mmal_port *control;
+
+	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
+
+	switch (ctrl->val) {
+	case V4L2_CID_POWER_LINE_FREQUENCY_DISABLED:
+		u32_value = MMAL_PARAM_FLICKERAVOID_OFF;
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY_50HZ:
+		u32_value = MMAL_PARAM_FLICKERAVOID_50HZ;
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY_60HZ:
+		u32_value = MMAL_PARAM_FLICKERAVOID_60HZ;
+		break;
+	case V4L2_CID_POWER_LINE_FREQUENCY_AUTO:
+		u32_value = MMAL_PARAM_FLICKERAVOID_AUTO;
+		break;
+	}
+
+	return vchiq_mmal_port_parameter_set(dev->instance, control,
+					     mmal_ctrl->mmal_id,
+					     &u32_value, sizeof(u32_value));
+}
+
+static int ctrl_set_awb_mode(struct bm2835_mmal_dev *dev,
+		      struct v4l2_ctrl *ctrl,
+		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	u32 u32_value;
+	struct vchiq_mmal_port *control;
+
+	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
+
+	switch (ctrl->val) {
+	case V4L2_WHITE_BALANCE_MANUAL:
+		u32_value = MMAL_PARAM_AWBMODE_OFF;
+		break;
+
+	case V4L2_WHITE_BALANCE_AUTO:
+		u32_value = MMAL_PARAM_AWBMODE_AUTO;
+		break;
+
+	case V4L2_WHITE_BALANCE_INCANDESCENT:
+		u32_value = MMAL_PARAM_AWBMODE_INCANDESCENT;
+		break;
+
+	case V4L2_WHITE_BALANCE_FLUORESCENT:
+		u32_value = MMAL_PARAM_AWBMODE_FLUORESCENT;
+		break;
+
+	case V4L2_WHITE_BALANCE_FLUORESCENT_H:
+		u32_value = MMAL_PARAM_AWBMODE_TUNGSTEN;
+		break;
+
+	case V4L2_WHITE_BALANCE_HORIZON:
+		u32_value = MMAL_PARAM_AWBMODE_HORIZON;
+		break;
+
+	case V4L2_WHITE_BALANCE_DAYLIGHT:
+		u32_value = MMAL_PARAM_AWBMODE_SUNLIGHT;
+		break;
+
+	case V4L2_WHITE_BALANCE_FLASH:
+		u32_value = MMAL_PARAM_AWBMODE_FLASH;
+		break;
+
+	case V4L2_WHITE_BALANCE_CLOUDY:
+		u32_value = MMAL_PARAM_AWBMODE_CLOUDY;
+		break;
+
+	case V4L2_WHITE_BALANCE_SHADE:
+		u32_value = MMAL_PARAM_AWBMODE_SHADE;
+		break;
+
+	}
+
+	return vchiq_mmal_port_parameter_set(dev->instance, control,
+					     mmal_ctrl->mmal_id,
+					     &u32_value, sizeof(u32_value));
+}
+
+static int ctrl_set_awb_gains(struct bm2835_mmal_dev *dev,
+		      struct v4l2_ctrl *ctrl,
+		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	struct vchiq_mmal_port *control;
+	struct mmal_parameter_awbgains gains;
+
+	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
+
+	if (ctrl->id == V4L2_CID_RED_BALANCE)
+		dev->red_gain = ctrl->val;
+	else if (ctrl->id == V4L2_CID_BLUE_BALANCE)
+		dev->blue_gain = ctrl->val;
+
+	gains.r_gain.num = dev->red_gain;
+	gains.b_gain.num = dev->blue_gain;
+	gains.r_gain.den = gains.b_gain.den = 1000;
+
+	return vchiq_mmal_port_parameter_set(dev->instance, control,
+					     mmal_ctrl->mmal_id,
+					     &gains, sizeof(gains));
+}
+
+static int ctrl_set_image_effect(struct bm2835_mmal_dev *dev,
+		   struct v4l2_ctrl *ctrl,
+		   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	int ret = -EINVAL;
+	int i, j;
+	struct vchiq_mmal_port *control;
+	struct mmal_parameter_imagefx_parameters imagefx;
+
+	for (i = 0; i < ARRAY_SIZE(v4l2_to_mmal_effects_values); i++) {
+		if (ctrl->val == v4l2_to_mmal_effects_values[i].v4l2_effect) {
+
+			imagefx.effect =
+				v4l2_to_mmal_effects_values[i].mmal_effect;
+			imagefx.num_effect_params =
+				v4l2_to_mmal_effects_values[i].num_effect_params;
+
+			if (imagefx.num_effect_params > MMAL_MAX_IMAGEFX_PARAMETERS)
+				imagefx.num_effect_params = MMAL_MAX_IMAGEFX_PARAMETERS;
+
+			for (j = 0; j < imagefx.num_effect_params; j++)
+				imagefx.effect_parameter[j] =
+					v4l2_to_mmal_effects_values[i].effect_params[j];
+
+			dev->colourfx.enable =
+				v4l2_to_mmal_effects_values[i].col_fx_enable;
+			if (!v4l2_to_mmal_effects_values[i].col_fx_fixed_cbcr) {
+				dev->colourfx.u =
+					v4l2_to_mmal_effects_values[i].u;
+				dev->colourfx.v =
+					v4l2_to_mmal_effects_values[i].v;
+			}
+
+			control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
+
+			ret = vchiq_mmal_port_parameter_set(
+					dev->instance, control,
+					MMAL_PARAMETER_IMAGE_EFFECT_PARAMETERS,
+					&imagefx, sizeof(imagefx));
+			if (ret)
+				goto exit;
+
+			ret = vchiq_mmal_port_parameter_set(
+					dev->instance, control,
+					MMAL_PARAMETER_COLOUR_EFFECT,
+					&dev->colourfx, sizeof(dev->colourfx));
+		}
+	}
+
+exit:
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+		 "mmal_ctrl:%p ctrl id:0x%x ctrl val:%d imagefx:0x%x color_effect:%s u:%d v:%d ret %d(%d)\n",
+				mmal_ctrl, ctrl->id, ctrl->val, imagefx.effect,
+				dev->colourfx.enable ? "true" : "false",
+				dev->colourfx.u, dev->colourfx.v,
+				ret, (ret == 0 ? 0 : -EINVAL));
+	return (ret == 0 ? 0 : EINVAL);
+}
+
+static int ctrl_set_colfx(struct bm2835_mmal_dev *dev,
+		   struct v4l2_ctrl *ctrl,
+		   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	int ret = -EINVAL;
+	struct vchiq_mmal_port *control;
+
+	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
+
+	dev->colourfx.enable = (ctrl->val & 0xff00) >> 8;
+	dev->colourfx.enable = ctrl->val & 0xff;
+
+	ret = vchiq_mmal_port_parameter_set(dev->instance, control,
+					MMAL_PARAMETER_COLOUR_EFFECT,
+					&dev->colourfx, sizeof(dev->colourfx));
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+		 "%s: After: mmal_ctrl:%p ctrl id:0x%x ctrl val:%d ret %d(%d)\n",
+			__func__, mmal_ctrl, ctrl->id, ctrl->val, ret,
+			(ret == 0 ? 0 : -EINVAL));
+	return (ret == 0 ? 0 : EINVAL);
+}
+
+static int ctrl_set_bitrate(struct bm2835_mmal_dev *dev,
+		   struct v4l2_ctrl *ctrl,
+		   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	int ret;
+	struct vchiq_mmal_port *encoder_out;
+
+	dev->capture.encode_bitrate = ctrl->val;
+
+	encoder_out = &dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0];
+
+	ret = vchiq_mmal_port_parameter_set(dev->instance, encoder_out,
+					    mmal_ctrl->mmal_id,
+					    &ctrl->val, sizeof(ctrl->val));
+	ret = 0;
+	return ret;
+}
+
+static int ctrl_set_bitrate_mode(struct bm2835_mmal_dev *dev,
+		   struct v4l2_ctrl *ctrl,
+		   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	u32 bitrate_mode;
+	struct vchiq_mmal_port *encoder_out;
+
+	encoder_out = &dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0];
+
+	dev->capture.encode_bitrate_mode = ctrl->val;
+	switch (ctrl->val) {
+	default:
+	case V4L2_MPEG_VIDEO_BITRATE_MODE_VBR:
+		bitrate_mode = MMAL_VIDEO_RATECONTROL_VARIABLE;
+		break;
+	case V4L2_MPEG_VIDEO_BITRATE_MODE_CBR:
+		bitrate_mode = MMAL_VIDEO_RATECONTROL_CONSTANT;
+		break;
+	}
+
+	vchiq_mmal_port_parameter_set(dev->instance, encoder_out,
+					     mmal_ctrl->mmal_id,
+					     &bitrate_mode,
+					     sizeof(bitrate_mode));
+	return 0;
+}
+
+static int ctrl_set_image_encode_output(struct bm2835_mmal_dev *dev,
+		      struct v4l2_ctrl *ctrl,
+		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	u32 u32_value;
+	struct vchiq_mmal_port *jpeg_out;
+
+	jpeg_out = &dev->component[MMAL_COMPONENT_IMAGE_ENCODE]->output[0];
+
+	u32_value = ctrl->val;
+
+	return vchiq_mmal_port_parameter_set(dev->instance, jpeg_out,
+					     mmal_ctrl->mmal_id,
+					     &u32_value, sizeof(u32_value));
+}
+
+static int ctrl_set_video_encode_param_output(struct bm2835_mmal_dev *dev,
+		      struct v4l2_ctrl *ctrl,
+		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	u32 u32_value;
+	struct vchiq_mmal_port *vid_enc_ctl;
+
+	vid_enc_ctl = &dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0];
+
+	u32_value = ctrl->val;
+
+	return vchiq_mmal_port_parameter_set(dev->instance, vid_enc_ctl,
+					     mmal_ctrl->mmal_id,
+					     &u32_value, sizeof(u32_value));
+}
+
+static int ctrl_set_video_encode_profile_level(struct bm2835_mmal_dev *dev,
+		      struct v4l2_ctrl *ctrl,
+		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	struct mmal_parameter_video_profile param;
+	int ret = 0;
+
+	if (ctrl->id == V4L2_CID_MPEG_VIDEO_H264_PROFILE) {
+		switch (ctrl->val) {
+		case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
+		case V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE:
+		case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
+		case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH:
+			dev->capture.enc_profile = ctrl->val;
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+	} else if (ctrl->id == V4L2_CID_MPEG_VIDEO_H264_LEVEL) {
+		switch (ctrl->val) {
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1_0:
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1B:
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1_1:
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1_2:
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1_3:
+		case V4L2_MPEG_VIDEO_H264_LEVEL_2_0:
+		case V4L2_MPEG_VIDEO_H264_LEVEL_2_1:
+		case V4L2_MPEG_VIDEO_H264_LEVEL_2_2:
+		case V4L2_MPEG_VIDEO_H264_LEVEL_3_0:
+		case V4L2_MPEG_VIDEO_H264_LEVEL_3_1:
+		case V4L2_MPEG_VIDEO_H264_LEVEL_3_2:
+		case V4L2_MPEG_VIDEO_H264_LEVEL_4_0:
+			dev->capture.enc_level = ctrl->val;
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+	}
+
+	if (!ret) {
+		switch (dev->capture.enc_profile) {
+		case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
+			param.profile = MMAL_VIDEO_PROFILE_H264_BASELINE;
+			break;
+		case V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE:
+			param.profile =
+				MMAL_VIDEO_PROFILE_H264_CONSTRAINED_BASELINE;
+			break;
+		case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
+			param.profile = MMAL_VIDEO_PROFILE_H264_MAIN;
+			break;
+		case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH:
+			param.profile = MMAL_VIDEO_PROFILE_H264_HIGH;
+			break;
+		default:
+			/* Should never get here */
+			break;
+		}
+
+		switch (dev->capture.enc_level) {
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1_0:
+			param.level = MMAL_VIDEO_LEVEL_H264_1;
+			break;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1B:
+			param.level = MMAL_VIDEO_LEVEL_H264_1b;
+			break;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1_1:
+			param.level = MMAL_VIDEO_LEVEL_H264_11;
+			break;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1_2:
+			param.level = MMAL_VIDEO_LEVEL_H264_12;
+			break;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_1_3:
+			param.level = MMAL_VIDEO_LEVEL_H264_13;
+			break;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_2_0:
+			param.level = MMAL_VIDEO_LEVEL_H264_2;
+			break;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_2_1:
+			param.level = MMAL_VIDEO_LEVEL_H264_21;
+			break;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_2_2:
+			param.level = MMAL_VIDEO_LEVEL_H264_22;
+			break;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_3_0:
+			param.level = MMAL_VIDEO_LEVEL_H264_3;
+			break;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_3_1:
+			param.level = MMAL_VIDEO_LEVEL_H264_31;
+			break;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_3_2:
+			param.level = MMAL_VIDEO_LEVEL_H264_32;
+			break;
+		case V4L2_MPEG_VIDEO_H264_LEVEL_4_0:
+			param.level = MMAL_VIDEO_LEVEL_H264_4;
+			break;
+		default:
+			/* Should never get here */
+			break;
+		}
+
+		ret = vchiq_mmal_port_parameter_set(dev->instance,
+			&dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0],
+			mmal_ctrl->mmal_id,
+			&param, sizeof(param));
+	}
+	return ret;
+}
+
+static int ctrl_set_scene_mode(struct bm2835_mmal_dev *dev,
+		      struct v4l2_ctrl *ctrl,
+		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
+{
+	int ret = 0;
+	int shutter_speed;
+	struct vchiq_mmal_port *control;
+
+	v4l2_dbg(0, bcm2835_v4l2_debug, &dev->v4l2_dev,
+		"scene mode selected %d, was %d\n", ctrl->val,
+		dev->scene_mode);
+	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
+
+	if (ctrl->val == dev->scene_mode)
+		return 0;
+
+	if (ctrl->val == V4L2_SCENE_MODE_NONE) {
+		/* Restore all user selections */
+		dev->scene_mode = V4L2_SCENE_MODE_NONE;
+
+		if (dev->exposure_mode_user == MMAL_PARAM_EXPOSUREMODE_OFF)
+			shutter_speed = dev->manual_shutter_speed;
+		else
+			shutter_speed = 0;
+
+		v4l2_dbg(0, bcm2835_v4l2_debug, &dev->v4l2_dev,
+			"%s: scene mode none: shut_speed %d, exp_mode %d, metering %d\n",
+			__func__, shutter_speed, dev->exposure_mode_user,
+			dev->metering_mode);
+		ret = vchiq_mmal_port_parameter_set(dev->instance,
+					control,
+					MMAL_PARAMETER_SHUTTER_SPEED,
+					&shutter_speed,
+					sizeof(shutter_speed));
+		ret += vchiq_mmal_port_parameter_set(dev->instance,
+					control,
+					MMAL_PARAMETER_EXPOSURE_MODE,
+					&dev->exposure_mode_user,
+					sizeof(u32));
+		dev->exposure_mode_active = dev->exposure_mode_user;
+		ret += vchiq_mmal_port_parameter_set(dev->instance,
+					control,
+					MMAL_PARAMETER_EXP_METERING_MODE,
+					&dev->metering_mode,
+					sizeof(u32));
+		ret += set_framerate_params(dev);
+	} else {
+		/* Set up scene mode */
+		int i;
+		const struct v4l2_mmal_scene_config *scene = NULL;
+		int shutter_speed;
+		enum mmal_parameter_exposuremode exposure_mode;
+		enum mmal_parameter_exposuremeteringmode metering_mode;
+
+		for (i = 0; i < ARRAY_SIZE(scene_configs); i++) {
+			if (scene_configs[i].v4l2_scene ==
+				ctrl->val) {
+				scene = &scene_configs[i];
+				break;
+			}
+		}
+		if (!scene)
+			return -EINVAL;
+		if (i >= ARRAY_SIZE(scene_configs))
+			return -EINVAL;
+
+		/* Set all the values */
+		dev->scene_mode = ctrl->val;
+
+		if (scene->exposure_mode == MMAL_PARAM_EXPOSUREMODE_OFF)
+			shutter_speed = dev->manual_shutter_speed;
+		else
+			shutter_speed = 0;
+		exposure_mode = scene->exposure_mode;
+		metering_mode = scene->metering_mode;
+
+		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+			"%s: scene mode none: shut_speed %d, exp_mode %d, metering %d\n",
+			__func__, shutter_speed, exposure_mode, metering_mode);
+
+		ret = vchiq_mmal_port_parameter_set(dev->instance, control,
+					MMAL_PARAMETER_SHUTTER_SPEED,
+					&shutter_speed,
+					sizeof(shutter_speed));
+		ret += vchiq_mmal_port_parameter_set(dev->instance,
+					control,
+					MMAL_PARAMETER_EXPOSURE_MODE,
+					&exposure_mode,
+					sizeof(u32));
+		dev->exposure_mode_active = exposure_mode;
+		ret += vchiq_mmal_port_parameter_set(dev->instance, control,
+					MMAL_PARAMETER_EXPOSURE_MODE,
+					&exposure_mode,
+					sizeof(u32));
+		ret += vchiq_mmal_port_parameter_set(dev->instance, control,
+					MMAL_PARAMETER_EXP_METERING_MODE,
+					&metering_mode,
+					sizeof(u32));
+		ret += set_framerate_params(dev);
+	}
+	if (ret) {
+		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+			"%s: Setting scene to %d, ret=%d\n",
+			__func__, ctrl->val, ret);
+		ret = -EINVAL;
+	}
+	return 0;
+}
+
+static int bm2835_mmal_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct bm2835_mmal_dev *dev =
+		container_of(ctrl->handler, struct bm2835_mmal_dev,
+			     ctrl_handler);
+	const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl = ctrl->priv;
+	int ret;
+
+	if ((mmal_ctrl == NULL) ||
+	    (mmal_ctrl->id != ctrl->id) ||
+	    (mmal_ctrl->setter == NULL)) {
+		pr_warn("mmal_ctrl:%p ctrl id:%d\n", mmal_ctrl, ctrl->id);
+		return -EINVAL;
+	}
+
+	ret = mmal_ctrl->setter(dev, ctrl, mmal_ctrl);
+	if (ret)
+		pr_warn("ctrl id:%d/MMAL param %08X- returned ret %d\n",
+				ctrl->id, mmal_ctrl->mmal_id, ret);
+	if (mmal_ctrl->ignore_errors)
+		ret = 0;
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops bm2835_mmal_ctrl_ops = {
+	.s_ctrl = bm2835_mmal_s_ctrl,
+};
+
+
+
+static const struct bm2835_mmal_v4l2_ctrl v4l2_ctrls[V4L2_CTRL_COUNT] = {
+	{
+		V4L2_CID_SATURATION, MMAL_CONTROL_TYPE_STD,
+		-100, 100, 0, 1, NULL,
+		MMAL_PARAMETER_SATURATION,
+		&ctrl_set_rational,
+		false
+	},
+	{
+		V4L2_CID_SHARPNESS, MMAL_CONTROL_TYPE_STD,
+		-100, 100, 0, 1, NULL,
+		MMAL_PARAMETER_SHARPNESS,
+		&ctrl_set_rational,
+		false
+	},
+	{
+		V4L2_CID_CONTRAST, MMAL_CONTROL_TYPE_STD,
+		-100, 100, 0, 1, NULL,
+		MMAL_PARAMETER_CONTRAST,
+		&ctrl_set_rational,
+		false
+	},
+	{
+		V4L2_CID_BRIGHTNESS, MMAL_CONTROL_TYPE_STD,
+		0, 100, 50, 1, NULL,
+		MMAL_PARAMETER_BRIGHTNESS,
+		&ctrl_set_rational,
+		false
+	},
+	{
+		V4L2_CID_ISO_SENSITIVITY, MMAL_CONTROL_TYPE_INT_MENU,
+		0, ARRAY_SIZE(iso_qmenu) - 1, 0, 1, iso_qmenu,
+		MMAL_PARAMETER_ISO,
+		&ctrl_set_iso,
+		false
+	},
+	{
+		V4L2_CID_ISO_SENSITIVITY_AUTO, MMAL_CONTROL_TYPE_STD_MENU,
+		0, 1, V4L2_ISO_SENSITIVITY_AUTO, 1, NULL,
+		MMAL_PARAMETER_ISO,
+		&ctrl_set_iso,
+		false
+	},
+	{
+		V4L2_CID_IMAGE_STABILIZATION, MMAL_CONTROL_TYPE_STD,
+		0, 1, 0, 1, NULL,
+		MMAL_PARAMETER_VIDEO_STABILISATION,
+		&ctrl_set_value,
+		false
+	},
+/*	{
+		0, MMAL_CONTROL_TYPE_CLUSTER, 3, 1, 0, NULL, 0, NULL
+	}, */
+	{
+		V4L2_CID_EXPOSURE_AUTO, MMAL_CONTROL_TYPE_STD_MENU,
+		~0x03, 3, V4L2_EXPOSURE_AUTO, 0, NULL,
+		MMAL_PARAMETER_EXPOSURE_MODE,
+		&ctrl_set_exposure,
+		false
+	},
+/* todo this needs mixing in with set exposure
+	{
+	       V4L2_CID_SCENE_MODE, MMAL_CONTROL_TYPE_STD_MENU,
+	},
+ */
+	{
+		V4L2_CID_EXPOSURE_ABSOLUTE, MMAL_CONTROL_TYPE_STD,
+		/* Units of 100usecs */
+		1, 1*1000*10, 100*10, 1, NULL,
+		MMAL_PARAMETER_SHUTTER_SPEED,
+		&ctrl_set_exposure,
+		false
+	},
+	{
+		V4L2_CID_AUTO_EXPOSURE_BIAS, MMAL_CONTROL_TYPE_INT_MENU,
+		0, ARRAY_SIZE(ev_bias_qmenu) - 1,
+		(ARRAY_SIZE(ev_bias_qmenu)+1)/2 - 1, 0, ev_bias_qmenu,
+		MMAL_PARAMETER_EXPOSURE_COMP,
+		&ctrl_set_value_ev,
+		false
+	},
+	{
+		V4L2_CID_EXPOSURE_AUTO_PRIORITY, MMAL_CONTROL_TYPE_STD,
+		0, 1,
+		0, 1, NULL,
+		0,	/* Dummy MMAL ID as it gets mapped into FPS range*/
+		&ctrl_set_exposure,
+		false
+	},
+	{
+		V4L2_CID_EXPOSURE_METERING,
+		MMAL_CONTROL_TYPE_STD_MENU,
+		~0x7, 2, V4L2_EXPOSURE_METERING_AVERAGE, 0, NULL,
+		MMAL_PARAMETER_EXP_METERING_MODE,
+		&ctrl_set_metering_mode,
+		false
+	},
+	{
+		V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE,
+		MMAL_CONTROL_TYPE_STD_MENU,
+		~0x3ff, 9, V4L2_WHITE_BALANCE_AUTO, 0, NULL,
+		MMAL_PARAMETER_AWB_MODE,
+		&ctrl_set_awb_mode,
+		false
+	},
+	{
+		V4L2_CID_RED_BALANCE, MMAL_CONTROL_TYPE_STD,
+		1, 7999, 1000, 1, NULL,
+		MMAL_PARAMETER_CUSTOM_AWB_GAINS,
+		&ctrl_set_awb_gains,
+		false
+	},
+	{
+		V4L2_CID_BLUE_BALANCE, MMAL_CONTROL_TYPE_STD,
+		1, 7999, 1000, 1, NULL,
+		MMAL_PARAMETER_CUSTOM_AWB_GAINS,
+		&ctrl_set_awb_gains,
+		false
+	},
+	{
+		V4L2_CID_COLORFX, MMAL_CONTROL_TYPE_STD_MENU,
+		0, 15, V4L2_COLORFX_NONE, 0, NULL,
+		MMAL_PARAMETER_IMAGE_EFFECT,
+		&ctrl_set_image_effect,
+		false
+	},
+	{
+		V4L2_CID_COLORFX_CBCR, MMAL_CONTROL_TYPE_STD,
+		0, 0xffff, 0x8080, 1, NULL,
+		MMAL_PARAMETER_COLOUR_EFFECT,
+		&ctrl_set_colfx,
+		false
+	},
+	{
+		V4L2_CID_ROTATE, MMAL_CONTROL_TYPE_STD,
+		0, 360, 0, 90, NULL,
+		MMAL_PARAMETER_ROTATION,
+		&ctrl_set_rotate,
+		false
+	},
+	{
+		V4L2_CID_HFLIP, MMAL_CONTROL_TYPE_STD,
+		0, 1, 0, 1, NULL,
+		MMAL_PARAMETER_MIRROR,
+		&ctrl_set_flip,
+		false
+	},
+	{
+		V4L2_CID_VFLIP, MMAL_CONTROL_TYPE_STD,
+		0, 1, 0, 1, NULL,
+		MMAL_PARAMETER_MIRROR,
+		&ctrl_set_flip,
+		false
+	},
+	{
+		V4L2_CID_MPEG_VIDEO_BITRATE_MODE, MMAL_CONTROL_TYPE_STD_MENU,
+		0, ARRAY_SIZE(bitrate_mode_qmenu) - 1,
+		0, 0, bitrate_mode_qmenu,
+		MMAL_PARAMETER_RATECONTROL,
+		&ctrl_set_bitrate_mode,
+		false
+	},
+	{
+		V4L2_CID_MPEG_VIDEO_BITRATE, MMAL_CONTROL_TYPE_STD,
+		25*1000, 25*1000*1000, 10*1000*1000, 25*1000, NULL,
+		MMAL_PARAMETER_VIDEO_BIT_RATE,
+		&ctrl_set_bitrate,
+		false
+	},
+	{
+		V4L2_CID_JPEG_COMPRESSION_QUALITY, MMAL_CONTROL_TYPE_STD,
+		1, 100,
+		30, 1, NULL,
+		MMAL_PARAMETER_JPEG_Q_FACTOR,
+		&ctrl_set_image_encode_output,
+		false
+	},
+	{
+		V4L2_CID_POWER_LINE_FREQUENCY, MMAL_CONTROL_TYPE_STD_MENU,
+		0, ARRAY_SIZE(mains_freq_qmenu) - 1,
+		1, 1, NULL,
+		MMAL_PARAMETER_FLICKER_AVOID,
+		&ctrl_set_flicker_avoidance,
+		false
+	},
+	{
+		V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER, MMAL_CONTROL_TYPE_STD,
+		0, 1,
+		0, 1, NULL,
+		MMAL_PARAMETER_VIDEO_ENCODE_INLINE_HEADER,
+		&ctrl_set_video_encode_param_output,
+		true	/* Errors ignored as requires latest firmware to work */
+	},
+	{
+		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
+		MMAL_CONTROL_TYPE_STD_MENU,
+		~((1<<V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
+			(1<<V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE) |
+			(1<<V4L2_MPEG_VIDEO_H264_PROFILE_MAIN) |
+			(1<<V4L2_MPEG_VIDEO_H264_PROFILE_HIGH)),
+		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
+		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH, 1, NULL,
+		MMAL_PARAMETER_PROFILE,
+		&ctrl_set_video_encode_profile_level,
+		false
+	},
+	{
+		V4L2_CID_MPEG_VIDEO_H264_LEVEL, MMAL_CONTROL_TYPE_STD_MENU,
+		~((1<<V4L2_MPEG_VIDEO_H264_LEVEL_1_0) |
+			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_1B) |
+			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_1_1) |
+			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_1_2) |
+			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_1_3) |
+			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_2_0) |
+			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_2_1) |
+			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_2_2) |
+			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_3_0) |
+			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_3_1) |
+			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_3_2) |
+			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_4_0)),
+		V4L2_MPEG_VIDEO_H264_LEVEL_4_0,
+		V4L2_MPEG_VIDEO_H264_LEVEL_4_0, 1, NULL,
+		MMAL_PARAMETER_PROFILE,
+		&ctrl_set_video_encode_profile_level,
+		false
+	},
+	{
+		V4L2_CID_SCENE_MODE, MMAL_CONTROL_TYPE_STD_MENU,
+		-1,	/* Min is computed at runtime */
+		V4L2_SCENE_MODE_TEXT,
+		V4L2_SCENE_MODE_NONE, 1, NULL,
+		MMAL_PARAMETER_PROFILE,
+		&ctrl_set_scene_mode,
+		false
+	},
+	{
+		V4L2_CID_MPEG_VIDEO_H264_I_PERIOD, MMAL_CONTROL_TYPE_STD,
+		0, 0x7FFFFFFF, 60, 1, NULL,
+		MMAL_PARAMETER_INTRAPERIOD,
+		&ctrl_set_video_encode_param_output,
+		false
+	},
+};
+
+int bm2835_mmal_set_all_camera_controls(struct bm2835_mmal_dev *dev)
+{
+	int c;
+	int ret = 0;
+
+	for (c = 0; c < V4L2_CTRL_COUNT; c++) {
+		if ((dev->ctrls[c]) && (v4l2_ctrls[c].setter)) {
+			ret = v4l2_ctrls[c].setter(dev, dev->ctrls[c],
+						   &v4l2_ctrls[c]);
+			if (!v4l2_ctrls[c].ignore_errors && ret) {
+				v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+					"Failed when setting default values for ctrl %d\n",
+					c);
+				break;
+			}
+		}
+	}
+	return ret;
+}
+
+int set_framerate_params(struct bm2835_mmal_dev *dev)
+{
+	struct mmal_parameter_fps_range fps_range;
+	int ret;
+
+	if ((dev->exposure_mode_active != MMAL_PARAM_EXPOSUREMODE_OFF) &&
+	     (dev->exp_auto_priority)) {
+		/* Variable FPS. Define min FPS as 1fps.
+		 * Max as max defined FPS.
+		 */
+		fps_range.fps_low.num = 1;
+		fps_range.fps_low.den = 1;
+		fps_range.fps_high.num = dev->capture.timeperframe.denominator;
+		fps_range.fps_high.den = dev->capture.timeperframe.numerator;
+	} else {
+		/* Fixed FPS - set min and max to be the same */
+		fps_range.fps_low.num = fps_range.fps_high.num =
+			dev->capture.timeperframe.denominator;
+		fps_range.fps_low.den = fps_range.fps_high.den =
+			dev->capture.timeperframe.numerator;
+	}
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+			 "Set fps range to %d/%d to %d/%d\n",
+			 fps_range.fps_low.num,
+			 fps_range.fps_low.den,
+			 fps_range.fps_high.num,
+			 fps_range.fps_high.den
+		 );
+
+	ret = vchiq_mmal_port_parameter_set(dev->instance,
+				      &dev->component[MMAL_COMPONENT_CAMERA]->
+					output[MMAL_CAMERA_PORT_PREVIEW],
+				      MMAL_PARAMETER_FPS_RANGE,
+				      &fps_range, sizeof(fps_range));
+	ret += vchiq_mmal_port_parameter_set(dev->instance,
+				      &dev->component[MMAL_COMPONENT_CAMERA]->
+					output[MMAL_CAMERA_PORT_VIDEO],
+				      MMAL_PARAMETER_FPS_RANGE,
+				      &fps_range, sizeof(fps_range));
+	ret += vchiq_mmal_port_parameter_set(dev->instance,
+				      &dev->component[MMAL_COMPONENT_CAMERA]->
+					output[MMAL_CAMERA_PORT_CAPTURE],
+				      MMAL_PARAMETER_FPS_RANGE,
+				      &fps_range, sizeof(fps_range));
+	if (ret)
+		v4l2_dbg(0, bcm2835_v4l2_debug, &dev->v4l2_dev,
+		 "Failed to set fps ret %d\n",
+		 ret);
+
+	return ret;
+
+}
+
+int bm2835_mmal_init_controls(struct bm2835_mmal_dev *dev,
+			      struct v4l2_ctrl_handler *hdl)
+{
+	int c;
+	const struct bm2835_mmal_v4l2_ctrl *ctrl;
+
+	v4l2_ctrl_handler_init(hdl, V4L2_CTRL_COUNT);
+
+	for (c = 0; c < V4L2_CTRL_COUNT; c++) {
+		ctrl = &v4l2_ctrls[c];
+
+		switch (ctrl->type) {
+		case MMAL_CONTROL_TYPE_STD:
+			dev->ctrls[c] = v4l2_ctrl_new_std(hdl,
+				&bm2835_mmal_ctrl_ops, ctrl->id,
+				ctrl->min, ctrl->max, ctrl->step, ctrl->def);
+			break;
+
+		case MMAL_CONTROL_TYPE_STD_MENU:
+		{
+			int mask = ctrl->min;
+
+			if (ctrl->id == V4L2_CID_SCENE_MODE) {
+				/* Special handling to work out the mask
+				 * value based on the scene_configs array
+				 * at runtime. Reduces the chance of
+				 * mismatches.
+				 */
+				int i;
+				mask = 1<<V4L2_SCENE_MODE_NONE;
+				for (i = 0;
+				     i < ARRAY_SIZE(scene_configs);
+				     i++) {
+					mask |= 1<<scene_configs[i].v4l2_scene;
+				}
+				mask = ~mask;
+			}
+
+			dev->ctrls[c] = v4l2_ctrl_new_std_menu(hdl,
+			&bm2835_mmal_ctrl_ops, ctrl->id,
+			ctrl->max, mask, ctrl->def);
+			break;
+		}
+
+		case MMAL_CONTROL_TYPE_INT_MENU:
+			dev->ctrls[c] = v4l2_ctrl_new_int_menu(hdl,
+				&bm2835_mmal_ctrl_ops, ctrl->id,
+				ctrl->max, ctrl->def, ctrl->imenu);
+			break;
+
+		case MMAL_CONTROL_TYPE_CLUSTER:
+			/* skip this entry when constructing controls */
+			continue;
+		}
+
+		if (hdl->error)
+			break;
+
+		dev->ctrls[c]->priv = (void *)ctrl;
+	}
+
+	if (hdl->error) {
+		pr_err("error adding control %d/%d id 0x%x\n", c,
+			 V4L2_CTRL_COUNT, ctrl->id);
+		return hdl->error;
+	}
+
+	for (c = 0; c < V4L2_CTRL_COUNT; c++) {
+		ctrl = &v4l2_ctrls[c];
+
+		switch (ctrl->type) {
+		case MMAL_CONTROL_TYPE_CLUSTER:
+			v4l2_ctrl_auto_cluster(ctrl->min,
+					       &dev->ctrls[c+1],
+					       ctrl->max,
+					       ctrl->def);
+			break;
+
+		case MMAL_CONTROL_TYPE_STD:
+		case MMAL_CONTROL_TYPE_STD_MENU:
+		case MMAL_CONTROL_TYPE_INT_MENU:
+			break;
+		}
+
+	}
+
+	return 0;
+}
diff --git a/drivers/staging/media/platform/bcm2835/mmal-common.h b/drivers/staging/media/platform/bcm2835/mmal-common.h
new file mode 100644
index 000000000000..840fd139e033
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/mmal-common.h
@@ -0,0 +1,53 @@
+/*
+ * Broadcom BM2835 V4L2 driver
+ *
+ * Copyright © 2013 Raspberry Pi (Trading) Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
+ *          Dave Stevenson <dsteve@broadcom.com>
+ *          Simon Mellor <simellor@broadcom.com>
+ *          Luke Diamand <luked@broadcom.com>
+ *
+ * MMAL structures
+ *
+ */
+
+#define MMAL_FOURCC(a, b, c, d) ((a) | (b << 8) | (c << 16) | (d << 24))
+#define MMAL_MAGIC MMAL_FOURCC('m', 'm', 'a', 'l')
+
+/** Special value signalling that time is not known */
+#define MMAL_TIME_UNKNOWN (1LL<<63)
+
+/* mapping between v4l and mmal video modes */
+struct mmal_fmt {
+	char  *name;
+	u32   fourcc;          /* v4l2 format id */
+	int   flags;           /* v4l2 flags field */
+	u32   mmal;
+	int   depth;
+	u32   mmal_component;  /* MMAL component index to be used to encode */
+	u32   ybbp;            /* depth of first Y plane for planar formats */
+};
+
+/* buffer for one video frame */
+struct mmal_buffer {
+	/* v4l buffer data -- must be first */
+	struct vb2_v4l2_buffer	vb;
+
+	/* list of buffers available */
+	struct list_head	list;
+
+	void *buffer; /* buffer pointer */
+	unsigned long buffer_size; /* size of allocated buffer */
+};
+
+/* */
+struct mmal_colourfx {
+	s32 enable;
+	u32 u;
+	u32 v;
+};
diff --git a/drivers/staging/media/platform/bcm2835/mmal-encodings.h b/drivers/staging/media/platform/bcm2835/mmal-encodings.h
new file mode 100644
index 000000000000..024d620dc1df
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/mmal-encodings.h
@@ -0,0 +1,127 @@
+/*
+ * Broadcom BM2835 V4L2 driver
+ *
+ * Copyright © 2013 Raspberry Pi (Trading) Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
+ *          Dave Stevenson <dsteve@broadcom.com>
+ *          Simon Mellor <simellor@broadcom.com>
+ *          Luke Diamand <luked@broadcom.com>
+ */
+#ifndef MMAL_ENCODINGS_H
+#define MMAL_ENCODINGS_H
+
+#define MMAL_ENCODING_H264             MMAL_FOURCC('H', '2', '6', '4')
+#define MMAL_ENCODING_H263             MMAL_FOURCC('H', '2', '6', '3')
+#define MMAL_ENCODING_MP4V             MMAL_FOURCC('M', 'P', '4', 'V')
+#define MMAL_ENCODING_MP2V             MMAL_FOURCC('M', 'P', '2', 'V')
+#define MMAL_ENCODING_MP1V             MMAL_FOURCC('M', 'P', '1', 'V')
+#define MMAL_ENCODING_WMV3             MMAL_FOURCC('W', 'M', 'V', '3')
+#define MMAL_ENCODING_WMV2             MMAL_FOURCC('W', 'M', 'V', '2')
+#define MMAL_ENCODING_WMV1             MMAL_FOURCC('W', 'M', 'V', '1')
+#define MMAL_ENCODING_WVC1             MMAL_FOURCC('W', 'V', 'C', '1')
+#define MMAL_ENCODING_VP8              MMAL_FOURCC('V', 'P', '8', ' ')
+#define MMAL_ENCODING_VP7              MMAL_FOURCC('V', 'P', '7', ' ')
+#define MMAL_ENCODING_VP6              MMAL_FOURCC('V', 'P', '6', ' ')
+#define MMAL_ENCODING_THEORA           MMAL_FOURCC('T', 'H', 'E', 'O')
+#define MMAL_ENCODING_SPARK            MMAL_FOURCC('S', 'P', 'R', 'K')
+#define MMAL_ENCODING_MJPEG            MMAL_FOURCC('M', 'J', 'P', 'G')
+
+#define MMAL_ENCODING_JPEG             MMAL_FOURCC('J', 'P', 'E', 'G')
+#define MMAL_ENCODING_GIF              MMAL_FOURCC('G', 'I', 'F', ' ')
+#define MMAL_ENCODING_PNG              MMAL_FOURCC('P', 'N', 'G', ' ')
+#define MMAL_ENCODING_PPM              MMAL_FOURCC('P', 'P', 'M', ' ')
+#define MMAL_ENCODING_TGA              MMAL_FOURCC('T', 'G', 'A', ' ')
+#define MMAL_ENCODING_BMP              MMAL_FOURCC('B', 'M', 'P', ' ')
+
+#define MMAL_ENCODING_I420             MMAL_FOURCC('I', '4', '2', '0')
+#define MMAL_ENCODING_I420_SLICE       MMAL_FOURCC('S', '4', '2', '0')
+#define MMAL_ENCODING_YV12             MMAL_FOURCC('Y', 'V', '1', '2')
+#define MMAL_ENCODING_I422             MMAL_FOURCC('I', '4', '2', '2')
+#define MMAL_ENCODING_I422_SLICE       MMAL_FOURCC('S', '4', '2', '2')
+#define MMAL_ENCODING_YUYV             MMAL_FOURCC('Y', 'U', 'Y', 'V')
+#define MMAL_ENCODING_YVYU             MMAL_FOURCC('Y', 'V', 'Y', 'U')
+#define MMAL_ENCODING_UYVY             MMAL_FOURCC('U', 'Y', 'V', 'Y')
+#define MMAL_ENCODING_VYUY             MMAL_FOURCC('V', 'Y', 'U', 'Y')
+#define MMAL_ENCODING_NV12             MMAL_FOURCC('N', 'V', '1', '2')
+#define MMAL_ENCODING_NV21             MMAL_FOURCC('N', 'V', '2', '1')
+#define MMAL_ENCODING_ARGB             MMAL_FOURCC('A', 'R', 'G', 'B')
+#define MMAL_ENCODING_RGBA             MMAL_FOURCC('R', 'G', 'B', 'A')
+#define MMAL_ENCODING_ABGR             MMAL_FOURCC('A', 'B', 'G', 'R')
+#define MMAL_ENCODING_BGRA             MMAL_FOURCC('B', 'G', 'R', 'A')
+#define MMAL_ENCODING_RGB16            MMAL_FOURCC('R', 'G', 'B', '2')
+#define MMAL_ENCODING_RGB24            MMAL_FOURCC('R', 'G', 'B', '3')
+#define MMAL_ENCODING_RGB32            MMAL_FOURCC('R', 'G', 'B', '4')
+#define MMAL_ENCODING_BGR16            MMAL_FOURCC('B', 'G', 'R', '2')
+#define MMAL_ENCODING_BGR24            MMAL_FOURCC('B', 'G', 'R', '3')
+#define MMAL_ENCODING_BGR32            MMAL_FOURCC('B', 'G', 'R', '4')
+
+/** SAND Video (YUVUV128) format, native format understood by VideoCore.
+ * This format is *not* opaque - if requested you will receive full frames
+ * of YUV_UV video.
+ */
+#define MMAL_ENCODING_YUVUV128         MMAL_FOURCC('S', 'A', 'N', 'D')
+
+/** VideoCore opaque image format, image handles are returned to
+ * the host but not the actual image data.
+ */
+#define MMAL_ENCODING_OPAQUE           MMAL_FOURCC('O', 'P', 'Q', 'V')
+
+/** An EGL image handle
+ */
+#define MMAL_ENCODING_EGL_IMAGE        MMAL_FOURCC('E', 'G', 'L', 'I')
+
+/* }@ */
+
+/** \name Pre-defined audio encodings */
+/* @{ */
+#define MMAL_ENCODING_PCM_UNSIGNED_BE  MMAL_FOURCC('P', 'C', 'M', 'U')
+#define MMAL_ENCODING_PCM_UNSIGNED_LE  MMAL_FOURCC('p', 'c', 'm', 'u')
+#define MMAL_ENCODING_PCM_SIGNED_BE    MMAL_FOURCC('P', 'C', 'M', 'S')
+#define MMAL_ENCODING_PCM_SIGNED_LE    MMAL_FOURCC('p', 'c', 'm', 's')
+#define MMAL_ENCODING_PCM_FLOAT_BE     MMAL_FOURCC('P', 'C', 'M', 'F')
+#define MMAL_ENCODING_PCM_FLOAT_LE     MMAL_FOURCC('p', 'c', 'm', 'f')
+
+/* Pre-defined H264 encoding variants */
+
+/** ISO 14496-10 Annex B byte stream format */
+#define MMAL_ENCODING_VARIANT_H264_DEFAULT   0
+/** ISO 14496-15 AVC stream format */
+#define MMAL_ENCODING_VARIANT_H264_AVC1      MMAL_FOURCC('A', 'V', 'C', '1')
+/** Implicitly delineated NAL units without emulation prevention */
+#define MMAL_ENCODING_VARIANT_H264_RAW       MMAL_FOURCC('R', 'A', 'W', ' ')
+
+
+/** \defgroup MmalColorSpace List of pre-defined video color spaces
+ * This defines a list of common color spaces. This list isn't exhaustive and
+ * is only provided as a convenience to avoid clients having to use FourCC
+ * codes directly. However components are allowed to define and use their own
+ * FourCC codes.
+ */
+/* @{ */
+
+/** Unknown color space */
+#define MMAL_COLOR_SPACE_UNKNOWN       0
+/** ITU-R BT.601-5 [SDTV] */
+#define MMAL_COLOR_SPACE_ITUR_BT601    MMAL_FOURCC('Y', '6', '0', '1')
+/** ITU-R BT.709-3 [HDTV] */
+#define MMAL_COLOR_SPACE_ITUR_BT709    MMAL_FOURCC('Y', '7', '0', '9')
+/** JPEG JFIF */
+#define MMAL_COLOR_SPACE_JPEG_JFIF     MMAL_FOURCC('Y', 'J', 'F', 'I')
+/** Title 47 Code of Federal Regulations (2003) 73.682 (a) (20) */
+#define MMAL_COLOR_SPACE_FCC           MMAL_FOURCC('Y', 'F', 'C', 'C')
+/** Society of Motion Picture and Television Engineers 240M (1999) */
+#define MMAL_COLOR_SPACE_SMPTE240M     MMAL_FOURCC('Y', '2', '4', '0')
+/** ITU-R BT.470-2 System M */
+#define MMAL_COLOR_SPACE_BT470_2_M     MMAL_FOURCC('Y', '_', '_', 'M')
+/** ITU-R BT.470-2 System BG */
+#define MMAL_COLOR_SPACE_BT470_2_BG    MMAL_FOURCC('Y', '_', 'B', 'G')
+/** JPEG JFIF, but with 16..255 luma */
+#define MMAL_COLOR_SPACE_JFIF_Y16_255  MMAL_FOURCC('Y', 'Y', '1', '6')
+/* @} MmalColorSpace List */
+
+#endif /* MMAL_ENCODINGS_H */
diff --git a/drivers/staging/media/platform/bcm2835/mmal-msg-common.h b/drivers/staging/media/platform/bcm2835/mmal-msg-common.h
new file mode 100644
index 000000000000..66e8a6edf628
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/mmal-msg-common.h
@@ -0,0 +1,50 @@
+/*
+ * Broadcom BM2835 V4L2 driver
+ *
+ * Copyright © 2013 Raspberry Pi (Trading) Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
+ *          Dave Stevenson <dsteve@broadcom.com>
+ *          Simon Mellor <simellor@broadcom.com>
+ *          Luke Diamand <luked@broadcom.com>
+ */
+
+#ifndef MMAL_MSG_COMMON_H
+#define MMAL_MSG_COMMON_H
+
+enum mmal_msg_status {
+	MMAL_MSG_STATUS_SUCCESS = 0, /**< Success */
+	MMAL_MSG_STATUS_ENOMEM,      /**< Out of memory */
+	MMAL_MSG_STATUS_ENOSPC,      /**< Out of resources other than memory */
+	MMAL_MSG_STATUS_EINVAL,      /**< Argument is invalid */
+	MMAL_MSG_STATUS_ENOSYS,      /**< Function not implemented */
+	MMAL_MSG_STATUS_ENOENT,      /**< No such file or directory */
+	MMAL_MSG_STATUS_ENXIO,       /**< No such device or address */
+	MMAL_MSG_STATUS_EIO,         /**< I/O error */
+	MMAL_MSG_STATUS_ESPIPE,      /**< Illegal seek */
+	MMAL_MSG_STATUS_ECORRUPT,    /**< Data is corrupt \attention */
+	MMAL_MSG_STATUS_ENOTREADY,   /**< Component is not ready */
+	MMAL_MSG_STATUS_ECONFIG,     /**< Component is not configured */
+	MMAL_MSG_STATUS_EISCONN,     /**< Port is already connected */
+	MMAL_MSG_STATUS_ENOTCONN,    /**< Port is disconnected */
+	MMAL_MSG_STATUS_EAGAIN,      /**< Resource temporarily unavailable. */
+	MMAL_MSG_STATUS_EFAULT,      /**< Bad address */
+};
+
+struct mmal_rect {
+	s32 x;      /**< x coordinate (from left) */
+	s32 y;      /**< y coordinate (from top) */
+	s32 width;  /**< width */
+	s32 height; /**< height */
+};
+
+struct mmal_rational {
+	s32 num;    /**< Numerator */
+	s32 den;    /**< Denominator */
+};
+
+#endif /* MMAL_MSG_COMMON_H */
diff --git a/drivers/staging/media/platform/bcm2835/mmal-msg-format.h b/drivers/staging/media/platform/bcm2835/mmal-msg-format.h
new file mode 100644
index 000000000000..123d86ef582b
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/mmal-msg-format.h
@@ -0,0 +1,81 @@
+/*
+ * Broadcom BM2835 V4L2 driver
+ *
+ * Copyright © 2013 Raspberry Pi (Trading) Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
+ *          Dave Stevenson <dsteve@broadcom.com>
+ *          Simon Mellor <simellor@broadcom.com>
+ *          Luke Diamand <luked@broadcom.com>
+ */
+
+#ifndef MMAL_MSG_FORMAT_H
+#define MMAL_MSG_FORMAT_H
+
+#include "mmal-msg-common.h"
+
+/* MMAL_ES_FORMAT_T */
+
+
+struct mmal_audio_format {
+	u32 channels;           /**< Number of audio channels */
+	u32 sample_rate;        /**< Sample rate */
+
+	u32 bits_per_sample;    /**< Bits per sample */
+	u32 block_align;        /**< Size of a block of data */
+};
+
+struct mmal_video_format {
+	u32 width;        /**< Width of frame in pixels */
+	u32 height;       /**< Height of frame in rows of pixels */
+	struct mmal_rect crop;         /**< Visible region of the frame */
+	struct mmal_rational frame_rate;   /**< Frame rate */
+	struct mmal_rational par;          /**< Pixel aspect ratio */
+
+	/* FourCC specifying the color space of the video stream. See the
+	 * \ref MmalColorSpace "pre-defined color spaces" for some examples.
+	 */
+	u32 color_space;
+};
+
+struct mmal_subpicture_format {
+	u32 x_offset;
+	u32 y_offset;
+};
+
+union mmal_es_specific_format {
+	struct mmal_audio_format audio;
+	struct mmal_video_format video;
+	struct mmal_subpicture_format subpicture;
+};
+
+/** Definition of an elementary stream format (MMAL_ES_FORMAT_T) */
+struct mmal_es_format {
+	u32 type;      /* enum mmal_es_type */
+
+	u32 encoding;  /* FourCC specifying encoding of the elementary stream.*/
+	u32 encoding_variant; /* FourCC specifying the specific
+			       * encoding variant of the elementary
+			       * stream.
+			       */
+
+	union mmal_es_specific_format *es; /* TODO: pointers in
+					    * message serialisation?!?
+					    */
+					    /* Type specific
+					     * information for the
+					     * elementary stream
+					     */
+
+	u32 bitrate;        /**< Bitrate in bits per second */
+	u32 flags; /**< Flags describing properties of the elementary stream. */
+
+	u32 extradata_size;       /**< Size of the codec specific data */
+	u8  *extradata;           /**< Codec specific data */
+};
+
+#endif /* MMAL_MSG_FORMAT_H */
diff --git a/drivers/staging/media/platform/bcm2835/mmal-msg-port.h b/drivers/staging/media/platform/bcm2835/mmal-msg-port.h
new file mode 100644
index 000000000000..a55c1ea2eceb
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/mmal-msg-port.h
@@ -0,0 +1,107 @@
+/*
+ * Broadcom BM2835 V4L2 driver
+ *
+ * Copyright © 2013 Raspberry Pi (Trading) Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
+ *          Dave Stevenson <dsteve@broadcom.com>
+ *          Simon Mellor <simellor@broadcom.com>
+ *          Luke Diamand <luked@broadcom.com>
+ */
+
+/* MMAL_PORT_TYPE_T */
+enum mmal_port_type {
+	MMAL_PORT_TYPE_UNKNOWN = 0,  /**< Unknown port type */
+	MMAL_PORT_TYPE_CONTROL,      /**< Control port */
+	MMAL_PORT_TYPE_INPUT,        /**< Input port */
+	MMAL_PORT_TYPE_OUTPUT,       /**< Output port */
+	MMAL_PORT_TYPE_CLOCK,        /**< Clock port */
+};
+
+/** The port is pass-through and doesn't need buffer headers allocated */
+#define MMAL_PORT_CAPABILITY_PASSTHROUGH                       0x01
+/** The port wants to allocate the buffer payloads.
+ * This signals a preference that payload allocation should be done
+ * on this port for efficiency reasons. */
+#define MMAL_PORT_CAPABILITY_ALLOCATION                        0x02
+/** The port supports format change events.
+ * This applies to input ports and is used to let the client know
+ * whether the port supports being reconfigured via a format
+ * change event (i.e. without having to disable the port). */
+#define MMAL_PORT_CAPABILITY_SUPPORTS_EVENT_FORMAT_CHANGE      0x04
+
+/* mmal port structure (MMAL_PORT_T)
+ *
+ * most elements are informational only, the pointer values for
+ * interogation messages are generally provided as additional
+ * strucures within the message. When used to set values only teh
+ * buffer_num, buffer_size and userdata parameters are writable.
+ */
+struct mmal_port {
+	void *priv; /* Private member used by the framework */
+	const char *name; /* Port name. Used for debugging purposes (RO) */
+
+	u32 type;      /* Type of the port (RO) enum mmal_port_type */
+	u16 index;     /* Index of the port in its type list (RO) */
+	u16 index_all; /* Index of the port in the list of all ports (RO) */
+
+	u32 is_enabled; /* Indicates whether the port is enabled or not (RO) */
+	struct mmal_es_format *format; /* Format of the elementary stream */
+
+	u32 buffer_num_min; /* Minimum number of buffers the port
+			     *   requires (RO).  This is set by the
+			     *   component.
+			     */
+
+	u32 buffer_size_min; /* Minimum size of buffers the port
+			      * requires (RO).  This is set by the
+			      * component.
+			      */
+
+	u32 buffer_alignment_min; /* Minimum alignment requirement for
+				   * the buffers (RO).  A value of
+				   * zero means no special alignment
+				   * requirements.  This is set by the
+				   * component.
+				   */
+
+	u32 buffer_num_recommended;  /* Number of buffers the port
+				      * recommends for optimal
+				      * performance (RO).  A value of
+				      * zero means no special
+				      * recommendation.  This is set
+				      * by the component.
+				      */
+
+	u32 buffer_size_recommended; /* Size of buffers the port
+				      * recommends for optimal
+				      * performance (RO).  A value of
+				      * zero means no special
+				      * recommendation.  This is set
+				      * by the component.
+				      */
+
+	u32 buffer_num; /* Actual number of buffers the port will use.
+			 * This is set by the client.
+			 */
+
+	u32 buffer_size; /* Actual maximum size of the buffers that
+			  * will be sent to the port. This is set by
+			  * the client.
+			  */
+
+	void *component; /* Component this port belongs to (Read Only) */
+
+	void *userdata; /* Field reserved for use by the client */
+
+	u32 capabilities; /* Flags describing the capabilities of a
+			   * port (RO).  Bitwise combination of \ref
+			   * portcapabilities "Port capabilities"
+			   * values.
+			   */
+
+};
diff --git a/drivers/staging/media/platform/bcm2835/mmal-msg.h b/drivers/staging/media/platform/bcm2835/mmal-msg.h
new file mode 100644
index 000000000000..67b1076015a5
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/mmal-msg.h
@@ -0,0 +1,404 @@
+/*
+ * Broadcom BM2835 V4L2 driver
+ *
+ * Copyright © 2013 Raspberry Pi (Trading) Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
+ *          Dave Stevenson <dsteve@broadcom.com>
+ *          Simon Mellor <simellor@broadcom.com>
+ *          Luke Diamand <luked@broadcom.com>
+ */
+
+/* all the data structures which serialise the MMAL protocol. note
+ * these are directly mapped onto the recived message data.
+ *
+ * BEWARE: They seem to *assume* pointers are u32 and that there is no
+ * structure padding!
+ *
+ * NOTE: this implementation uses kernel types to ensure sizes. Rather
+ * than assigning values to enums to force their size the
+ * implementation uses fixed size types and not the enums (though the
+ * comments have the actual enum type
+ */
+
+#define VC_MMAL_VER 15
+#define VC_MMAL_MIN_VER 10
+#define VC_MMAL_SERVER_NAME  MAKE_FOURCC("mmal")
+
+/* max total message size is 512 bytes */
+#define MMAL_MSG_MAX_SIZE 512
+/* with six 32bit header elements max payload is therefore 488 bytes */
+#define MMAL_MSG_MAX_PAYLOAD 488
+
+#include "mmal-msg-common.h"
+#include "mmal-msg-format.h"
+#include "mmal-msg-port.h"
+
+enum mmal_msg_type {
+	MMAL_MSG_TYPE_QUIT = 1,
+	MMAL_MSG_TYPE_SERVICE_CLOSED,
+	MMAL_MSG_TYPE_GET_VERSION,
+	MMAL_MSG_TYPE_COMPONENT_CREATE,
+	MMAL_MSG_TYPE_COMPONENT_DESTROY, /* 5 */
+	MMAL_MSG_TYPE_COMPONENT_ENABLE,
+	MMAL_MSG_TYPE_COMPONENT_DISABLE,
+	MMAL_MSG_TYPE_PORT_INFO_GET,
+	MMAL_MSG_TYPE_PORT_INFO_SET,
+	MMAL_MSG_TYPE_PORT_ACTION, /* 10 */
+	MMAL_MSG_TYPE_BUFFER_FROM_HOST,
+	MMAL_MSG_TYPE_BUFFER_TO_HOST,
+	MMAL_MSG_TYPE_GET_STATS,
+	MMAL_MSG_TYPE_PORT_PARAMETER_SET,
+	MMAL_MSG_TYPE_PORT_PARAMETER_GET, /* 15 */
+	MMAL_MSG_TYPE_EVENT_TO_HOST,
+	MMAL_MSG_TYPE_GET_CORE_STATS_FOR_PORT,
+	MMAL_MSG_TYPE_OPAQUE_ALLOCATOR,
+	MMAL_MSG_TYPE_CONSUME_MEM,
+	MMAL_MSG_TYPE_LMK, /* 20 */
+	MMAL_MSG_TYPE_OPAQUE_ALLOCATOR_DESC,
+	MMAL_MSG_TYPE_DRM_GET_LHS32,
+	MMAL_MSG_TYPE_DRM_GET_TIME,
+	MMAL_MSG_TYPE_BUFFER_FROM_HOST_ZEROLEN,
+	MMAL_MSG_TYPE_PORT_FLUSH, /* 25 */
+	MMAL_MSG_TYPE_HOST_LOG,
+	MMAL_MSG_TYPE_MSG_LAST
+};
+
+/* port action request messages differ depending on the action type */
+enum mmal_msg_port_action_type {
+	MMAL_MSG_PORT_ACTION_TYPE_UNKNOWN = 0,      /* Unkown action */
+	MMAL_MSG_PORT_ACTION_TYPE_ENABLE,           /* Enable a port */
+	MMAL_MSG_PORT_ACTION_TYPE_DISABLE,          /* Disable a port */
+	MMAL_MSG_PORT_ACTION_TYPE_FLUSH,            /* Flush a port */
+	MMAL_MSG_PORT_ACTION_TYPE_CONNECT,          /* Connect ports */
+	MMAL_MSG_PORT_ACTION_TYPE_DISCONNECT,       /* Disconnect ports */
+	MMAL_MSG_PORT_ACTION_TYPE_SET_REQUIREMENTS, /* Set buffer requirements*/
+};
+
+struct mmal_msg_header {
+	u32 magic;
+	u32 type; /** enum mmal_msg_type */
+
+	/* Opaque handle to the control service */
+	struct mmal_control_service *control_service;
+
+	struct mmal_msg_context *context; /** a u32 per message context */
+	u32 status; /** The status of the vchiq operation */
+	u32 padding;
+};
+
+/* Send from VC to host to report version */
+struct mmal_msg_version {
+	u32 flags;
+	u32 major;
+	u32 minor;
+	u32 minimum;
+};
+
+/* request to VC to create component */
+struct mmal_msg_component_create {
+	void *client_component; /* component context */
+	char name[128];
+	u32 pid;                /* For debug */
+};
+
+/* reply from VC to component creation request */
+struct mmal_msg_component_create_reply {
+	u32 status; /** enum mmal_msg_status - how does this differ to
+		     * the one in the header?
+		     */
+	u32 component_handle; /* VideoCore handle for component */
+	u32 input_num;        /* Number of input ports */
+	u32 output_num;       /* Number of output ports */
+	u32 clock_num;        /* Number of clock ports */
+};
+
+/* request to VC to destroy a component */
+struct mmal_msg_component_destroy {
+	u32 component_handle;
+};
+
+struct mmal_msg_component_destroy_reply {
+	u32 status; /** The component destruction status */
+};
+
+
+/* request and reply to VC to enable a component */
+struct mmal_msg_component_enable {
+	u32 component_handle;
+};
+
+struct mmal_msg_component_enable_reply {
+	u32 status; /** The component enable status */
+};
+
+
+/* request and reply to VC to disable a component */
+struct mmal_msg_component_disable {
+	u32 component_handle;
+};
+
+struct mmal_msg_component_disable_reply {
+	u32 status; /** The component disable status */
+};
+
+/* request to VC to get port information */
+struct mmal_msg_port_info_get {
+	u32 component_handle;  /* component handle port is associated with */
+	u32 port_type;         /* enum mmal_msg_port_type */
+	u32 index;             /* port index to query */
+};
+
+/* reply from VC to get port info request */
+struct mmal_msg_port_info_get_reply {
+	u32 status; /** enum mmal_msg_status */
+	u32 component_handle;  /* component handle port is associated with */
+	u32 port_type;         /* enum mmal_msg_port_type */
+	u32 port_index;        /* port indexed in query */
+	s32 found;             /* unused */
+	u32 port_handle;               /**< Handle to use for this port */
+	struct mmal_port port;
+	struct mmal_es_format format; /* elementry stream format */
+	union mmal_es_specific_format es; /* es type specific data */
+	u8 extradata[MMAL_FORMAT_EXTRADATA_MAX_SIZE]; /* es extra data */
+};
+
+/* request to VC to set port information */
+struct mmal_msg_port_info_set {
+	u32 component_handle;
+	u32 port_type;         /* enum mmal_msg_port_type */
+	u32 port_index;           /* port indexed in query */
+	struct mmal_port port;
+	struct mmal_es_format format;
+	union mmal_es_specific_format es;
+	u8 extradata[MMAL_FORMAT_EXTRADATA_MAX_SIZE];
+};
+
+/* reply from VC to port info set request */
+struct mmal_msg_port_info_set_reply {
+	u32 status;
+	u32 component_handle;  /* component handle port is associated with */
+	u32 port_type;         /* enum mmal_msg_port_type */
+	u32 index;             /* port indexed in query */
+	s32 found;             /* unused */
+	u32 port_handle;               /**< Handle to use for this port */
+	struct mmal_port port;
+	struct mmal_es_format format;
+	union mmal_es_specific_format es;
+	u8 extradata[MMAL_FORMAT_EXTRADATA_MAX_SIZE];
+};
+
+
+/* port action requests that take a mmal_port as a parameter */
+struct mmal_msg_port_action_port {
+	u32 component_handle;
+	u32 port_handle;
+	u32 action; /* enum mmal_msg_port_action_type */
+	struct mmal_port port;
+};
+
+/* port action requests that take handles as a parameter */
+struct mmal_msg_port_action_handle {
+	u32 component_handle;
+	u32 port_handle;
+	u32 action; /* enum mmal_msg_port_action_type */
+	u32 connect_component_handle;
+	u32 connect_port_handle;
+};
+
+struct mmal_msg_port_action_reply {
+	u32 status; /** The port action operation status */
+};
+
+
+
+
+/* MMAL buffer transfer */
+
+/** Size of space reserved in a buffer message for short messages. */
+#define MMAL_VC_SHORT_DATA 128
+
+/** Signals that the current payload is the end of the stream of data */
+#define MMAL_BUFFER_HEADER_FLAG_EOS                    (1<<0)
+/** Signals that the start of the current payload starts a frame */
+#define MMAL_BUFFER_HEADER_FLAG_FRAME_START            (1<<1)
+/** Signals that the end of the current payload ends a frame */
+#define MMAL_BUFFER_HEADER_FLAG_FRAME_END              (1<<2)
+/** Signals that the current payload contains only complete frames (>1) */
+#define MMAL_BUFFER_HEADER_FLAG_FRAME                  \
+	(MMAL_BUFFER_HEADER_FLAG_FRAME_START|MMAL_BUFFER_HEADER_FLAG_FRAME_END)
+/** Signals that the current payload is a keyframe (i.e. self decodable) */
+#define MMAL_BUFFER_HEADER_FLAG_KEYFRAME               (1<<3)
+/** Signals a discontinuity in the stream of data (e.g. after a seek).
+ * Can be used for instance by a decoder to reset its state */
+#define MMAL_BUFFER_HEADER_FLAG_DISCONTINUITY          (1<<4)
+/** Signals a buffer containing some kind of config data for the component
+ * (e.g. codec config data) */
+#define MMAL_BUFFER_HEADER_FLAG_CONFIG                 (1<<5)
+/** Signals an encrypted payload */
+#define MMAL_BUFFER_HEADER_FLAG_ENCRYPTED              (1<<6)
+/** Signals a buffer containing side information */
+#define MMAL_BUFFER_HEADER_FLAG_CODECSIDEINFO          (1<<7)
+/** Signals a buffer which is the snapshot/postview image from a stills
+ * capture
+ */
+#define MMAL_BUFFER_HEADER_FLAGS_SNAPSHOT              (1<<8)
+/** Signals a buffer which contains data known to be corrupted */
+#define MMAL_BUFFER_HEADER_FLAG_CORRUPTED              (1<<9)
+/** Signals that a buffer failed to be transmitted */
+#define MMAL_BUFFER_HEADER_FLAG_TRANSMISSION_FAILED    (1<<10)
+
+struct mmal_driver_buffer {
+	u32 magic;
+	u32 component_handle;
+	u32 port_handle;
+	void *client_context;
+};
+
+/* buffer header */
+struct mmal_buffer_header {
+	struct mmal_buffer_header *next; /* next header */
+	void *priv; /* framework private data */
+	u32 cmd;
+	void *data;
+	u32 alloc_size;
+	u32 length;
+	u32 offset;
+	u32 flags;
+	s64 pts;
+	s64 dts;
+	void *type;
+	void *user_data;
+};
+
+struct mmal_buffer_header_type_specific {
+	union {
+		struct {
+		u32 planes;
+		u32 offset[4];
+		u32 pitch[4];
+		u32 flags;
+		} video;
+	} u;
+};
+
+struct mmal_msg_buffer_from_host {
+	/* The front 32 bytes of the buffer header are copied
+	 * back to us in the reply to allow for context. This
+	 * area is used to store two mmal_driver_buffer structures to
+	 * allow for multiple concurrent service users.
+	 */
+	/* control data */
+	struct mmal_driver_buffer drvbuf;
+
+	/* referenced control data for passthrough buffer management */
+	struct mmal_driver_buffer drvbuf_ref;
+	struct mmal_buffer_header buffer_header; /* buffer header itself */
+	struct mmal_buffer_header_type_specific buffer_header_type_specific;
+	s32 is_zero_copy;
+	s32 has_reference;
+
+	/** allows short data to be xfered in control message */
+	u32 payload_in_message;
+	u8 short_data[MMAL_VC_SHORT_DATA];
+};
+
+
+/* port parameter setting */
+
+#define MMAL_WORKER_PORT_PARAMETER_SPACE      96
+
+struct mmal_msg_port_parameter_set {
+	u32 component_handle; /* component */
+	u32 port_handle;      /* port */
+	u32 id;     /* Parameter ID  */
+	u32 size;      /* Parameter size */
+	uint32_t value[MMAL_WORKER_PORT_PARAMETER_SPACE];
+};
+
+struct mmal_msg_port_parameter_set_reply {
+	u32 status; /** enum mmal_msg_status todo: how does this
+		     * differ to the one in the header?
+		     */
+};
+
+/* port parameter getting */
+
+struct mmal_msg_port_parameter_get {
+	u32 component_handle; /* component */
+	u32 port_handle;      /* port */
+	u32 id;     /* Parameter ID  */
+	u32 size;      /* Parameter size */
+};
+
+struct mmal_msg_port_parameter_get_reply {
+	u32 status;           /* Status of mmal_port_parameter_get call */
+	u32 id;     /* Parameter ID  */
+	u32 size;      /* Parameter size */
+	uint32_t value[MMAL_WORKER_PORT_PARAMETER_SPACE];
+};
+
+/* event messages */
+#define MMAL_WORKER_EVENT_SPACE 256
+
+struct mmal_msg_event_to_host {
+	void *client_component; /* component context */
+
+	u32 port_type;
+	u32 port_num;
+
+	u32 cmd;
+	u32 length;
+	u8 data[MMAL_WORKER_EVENT_SPACE];
+	struct mmal_buffer_header *delayed_buffer;
+};
+
+/* all mmal messages are serialised through this structure */
+struct mmal_msg {
+	/* header */
+	struct mmal_msg_header h;
+	/* payload */
+	union {
+		struct mmal_msg_version version;
+
+		struct mmal_msg_component_create component_create;
+		struct mmal_msg_component_create_reply component_create_reply;
+
+		struct mmal_msg_component_destroy component_destroy;
+		struct mmal_msg_component_destroy_reply component_destroy_reply;
+
+		struct mmal_msg_component_enable component_enable;
+		struct mmal_msg_component_enable_reply component_enable_reply;
+
+		struct mmal_msg_component_disable component_disable;
+		struct mmal_msg_component_disable_reply component_disable_reply;
+
+		struct mmal_msg_port_info_get port_info_get;
+		struct mmal_msg_port_info_get_reply port_info_get_reply;
+
+		struct mmal_msg_port_info_set port_info_set;
+		struct mmal_msg_port_info_set_reply port_info_set_reply;
+
+		struct mmal_msg_port_action_port port_action_port;
+		struct mmal_msg_port_action_handle port_action_handle;
+		struct mmal_msg_port_action_reply port_action_reply;
+
+		struct mmal_msg_buffer_from_host buffer_from_host;
+
+		struct mmal_msg_port_parameter_set port_parameter_set;
+		struct mmal_msg_port_parameter_set_reply
+			port_parameter_set_reply;
+		struct mmal_msg_port_parameter_get
+			port_parameter_get;
+		struct mmal_msg_port_parameter_get_reply
+			port_parameter_get_reply;
+
+		struct mmal_msg_event_to_host event_to_host;
+
+		u8 payload[MMAL_MSG_MAX_PAYLOAD];
+	} u;
+};
diff --git a/drivers/staging/media/platform/bcm2835/mmal-parameters.h b/drivers/staging/media/platform/bcm2835/mmal-parameters.h
new file mode 100644
index 000000000000..f6abb5cfa49d
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/mmal-parameters.h
@@ -0,0 +1,689 @@
+/*
+ * Broadcom BM2835 V4L2 driver
+ *
+ * Copyright © 2013 Raspberry Pi (Trading) Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
+ *          Dave Stevenson <dsteve@broadcom.com>
+ *          Simon Mellor <simellor@broadcom.com>
+ *          Luke Diamand <luked@broadcom.com>
+ */
+
+/* common parameters */
+
+/** @name Parameter groups
+ * Parameters are divided into groups, and then allocated sequentially within
+ * a group using an enum.
+ * @{
+ */
+
+/** Common parameter ID group, used with many types of component. */
+#define MMAL_PARAMETER_GROUP_COMMON            (0<<16)
+/** Camera-specific parameter ID group. */
+#define MMAL_PARAMETER_GROUP_CAMERA            (1<<16)
+/** Video-specific parameter ID group. */
+#define MMAL_PARAMETER_GROUP_VIDEO             (2<<16)
+/** Audio-specific parameter ID group. */
+#define MMAL_PARAMETER_GROUP_AUDIO             (3<<16)
+/** Clock-specific parameter ID group. */
+#define MMAL_PARAMETER_GROUP_CLOCK             (4<<16)
+/** Miracast-specific parameter ID group. */
+#define MMAL_PARAMETER_GROUP_MIRACAST       (5<<16)
+
+/* Common parameters */
+enum mmal_parameter_common_type {
+	MMAL_PARAMETER_UNUSED  /**< Never a valid parameter ID */
+		= MMAL_PARAMETER_GROUP_COMMON,
+	MMAL_PARAMETER_SUPPORTED_ENCODINGS, /**< MMAL_PARAMETER_ENCODING_T */
+	MMAL_PARAMETER_URI, /**< MMAL_PARAMETER_URI_T */
+
+	/** MMAL_PARAMETER_CHANGE_EVENT_REQUEST_T */
+	MMAL_PARAMETER_CHANGE_EVENT_REQUEST,
+
+	/** MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_ZERO_COPY,
+
+	/**< MMAL_PARAMETER_BUFFER_REQUIREMENTS_T */
+	MMAL_PARAMETER_BUFFER_REQUIREMENTS,
+
+	MMAL_PARAMETER_STATISTICS, /**< MMAL_PARAMETER_STATISTICS_T */
+	MMAL_PARAMETER_CORE_STATISTICS, /**< MMAL_PARAMETER_CORE_STATISTICS_T */
+	MMAL_PARAMETER_MEM_USAGE, /**< MMAL_PARAMETER_MEM_USAGE_T */
+	MMAL_PARAMETER_BUFFER_FLAG_FILTER, /**< MMAL_PARAMETER_UINT32_T */
+	MMAL_PARAMETER_SEEK, /**< MMAL_PARAMETER_SEEK_T */
+	MMAL_PARAMETER_POWERMON_ENABLE, /**< MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_LOGGING, /**< MMAL_PARAMETER_LOGGING_T */
+	MMAL_PARAMETER_SYSTEM_TIME, /**< MMAL_PARAMETER_UINT64_T */
+	MMAL_PARAMETER_NO_IMAGE_PADDING  /**< MMAL_PARAMETER_BOOLEAN_T */
+};
+
+/* camera parameters */
+
+enum mmal_parameter_camera_type {
+	/* 0 */
+	/** @ref MMAL_PARAMETER_THUMBNAIL_CONFIG_T */
+	MMAL_PARAMETER_THUMBNAIL_CONFIGURATION
+		= MMAL_PARAMETER_GROUP_CAMERA,
+	MMAL_PARAMETER_CAPTURE_QUALITY, /**< Unused? */
+	MMAL_PARAMETER_ROTATION, /**< @ref MMAL_PARAMETER_INT32_T */
+	MMAL_PARAMETER_EXIF_DISABLE, /**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_EXIF, /**< @ref MMAL_PARAMETER_EXIF_T */
+	MMAL_PARAMETER_AWB_MODE, /**< @ref MMAL_PARAM_AWBMODE_T */
+	MMAL_PARAMETER_IMAGE_EFFECT, /**< @ref MMAL_PARAMETER_IMAGEFX_T */
+	MMAL_PARAMETER_COLOUR_EFFECT, /**< @ref MMAL_PARAMETER_COLOURFX_T */
+	MMAL_PARAMETER_FLICKER_AVOID, /**< @ref MMAL_PARAMETER_FLICKERAVOID_T */
+	MMAL_PARAMETER_FLASH, /**< @ref MMAL_PARAMETER_FLASH_T */
+	MMAL_PARAMETER_REDEYE, /**< @ref MMAL_PARAMETER_REDEYE_T */
+	MMAL_PARAMETER_FOCUS, /**< @ref MMAL_PARAMETER_FOCUS_T */
+	MMAL_PARAMETER_FOCAL_LENGTHS, /**< Unused? */
+	MMAL_PARAMETER_EXPOSURE_COMP, /**< @ref MMAL_PARAMETER_INT32_T */
+	MMAL_PARAMETER_ZOOM, /**< @ref MMAL_PARAMETER_SCALEFACTOR_T */
+	MMAL_PARAMETER_MIRROR, /**< @ref MMAL_PARAMETER_MIRROR_T */
+
+	/* 0x10 */
+	MMAL_PARAMETER_CAMERA_NUM, /**< @ref MMAL_PARAMETER_UINT32_T */
+	MMAL_PARAMETER_CAPTURE, /**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_EXPOSURE_MODE, /**< @ref MMAL_PARAMETER_EXPOSUREMODE_T */
+	MMAL_PARAMETER_EXP_METERING_MODE, /**< @ref MMAL_PARAMETER_EXPOSUREMETERINGMODE_T */
+	MMAL_PARAMETER_FOCUS_STATUS, /**< @ref MMAL_PARAMETER_FOCUS_STATUS_T */
+	MMAL_PARAMETER_CAMERA_CONFIG, /**< @ref MMAL_PARAMETER_CAMERA_CONFIG_T */
+	MMAL_PARAMETER_CAPTURE_STATUS, /**< @ref MMAL_PARAMETER_CAPTURE_STATUS_T */
+	MMAL_PARAMETER_FACE_TRACK, /**< @ref MMAL_PARAMETER_FACE_TRACK_T */
+	MMAL_PARAMETER_DRAW_BOX_FACES_AND_FOCUS, /**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_JPEG_Q_FACTOR, /**< @ref MMAL_PARAMETER_UINT32_T */
+	MMAL_PARAMETER_FRAME_RATE, /**< @ref MMAL_PARAMETER_FRAME_RATE_T */
+	MMAL_PARAMETER_USE_STC, /**< @ref MMAL_PARAMETER_CAMERA_STC_MODE_T */
+	MMAL_PARAMETER_CAMERA_INFO, /**< @ref MMAL_PARAMETER_CAMERA_INFO_T */
+	MMAL_PARAMETER_VIDEO_STABILISATION, /**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_FACE_TRACK_RESULTS, /**< @ref MMAL_PARAMETER_FACE_TRACK_RESULTS_T */
+	MMAL_PARAMETER_ENABLE_RAW_CAPTURE, /**< @ref MMAL_PARAMETER_BOOLEAN_T */
+
+	/* 0x20 */
+	MMAL_PARAMETER_DPF_FILE, /**< @ref MMAL_PARAMETER_URI_T */
+	MMAL_PARAMETER_ENABLE_DPF_FILE, /**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_DPF_FAIL_IS_FATAL, /**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_CAPTURE_MODE, /**< @ref MMAL_PARAMETER_CAPTUREMODE_T */
+	MMAL_PARAMETER_FOCUS_REGIONS, /**< @ref MMAL_PARAMETER_FOCUS_REGIONS_T */
+	MMAL_PARAMETER_INPUT_CROP, /**< @ref MMAL_PARAMETER_INPUT_CROP_T */
+	MMAL_PARAMETER_SENSOR_INFORMATION, /**< @ref MMAL_PARAMETER_SENSOR_INFORMATION_T */
+	MMAL_PARAMETER_FLASH_SELECT, /**< @ref MMAL_PARAMETER_FLASH_SELECT_T */
+	MMAL_PARAMETER_FIELD_OF_VIEW, /**< @ref MMAL_PARAMETER_FIELD_OF_VIEW_T */
+	MMAL_PARAMETER_HIGH_DYNAMIC_RANGE, /**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_DYNAMIC_RANGE_COMPRESSION, /**< @ref MMAL_PARAMETER_DRC_T */
+	MMAL_PARAMETER_ALGORITHM_CONTROL, /**< @ref MMAL_PARAMETER_ALGORITHM_CONTROL_T */
+	MMAL_PARAMETER_SHARPNESS, /**< @ref MMAL_PARAMETER_RATIONAL_T */
+	MMAL_PARAMETER_CONTRAST, /**< @ref MMAL_PARAMETER_RATIONAL_T */
+	MMAL_PARAMETER_BRIGHTNESS, /**< @ref MMAL_PARAMETER_RATIONAL_T */
+	MMAL_PARAMETER_SATURATION, /**< @ref MMAL_PARAMETER_RATIONAL_T */
+
+	/* 0x30 */
+	MMAL_PARAMETER_ISO, /**< @ref MMAL_PARAMETER_UINT32_T */
+	MMAL_PARAMETER_ANTISHAKE, /**< @ref MMAL_PARAMETER_BOOLEAN_T */
+
+	/** @ref MMAL_PARAMETER_IMAGEFX_PARAMETERS_T */
+	MMAL_PARAMETER_IMAGE_EFFECT_PARAMETERS,
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_CAMERA_BURST_CAPTURE,
+
+	/** @ref MMAL_PARAMETER_UINT32_T */
+	MMAL_PARAMETER_CAMERA_MIN_ISO,
+
+	/** @ref MMAL_PARAMETER_CAMERA_USE_CASE_T */
+	MMAL_PARAMETER_CAMERA_USE_CASE,
+
+	/**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_CAPTURE_STATS_PASS,
+
+	/** @ref MMAL_PARAMETER_UINT32_T */
+	MMAL_PARAMETER_CAMERA_CUSTOM_SENSOR_CONFIG,
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_ENABLE_REGISTER_FILE,
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_REGISTER_FAIL_IS_FATAL,
+
+	/** @ref MMAL_PARAMETER_CONFIGFILE_T */
+	MMAL_PARAMETER_CONFIGFILE_REGISTERS,
+
+	/** @ref MMAL_PARAMETER_CONFIGFILE_CHUNK_T */
+	MMAL_PARAMETER_CONFIGFILE_CHUNK_REGISTERS,
+	MMAL_PARAMETER_JPEG_ATTACH_LOG, /**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_ZERO_SHUTTER_LAG, /**< @ref MMAL_PARAMETER_ZEROSHUTTERLAG_T */
+	MMAL_PARAMETER_FPS_RANGE, /**< @ref MMAL_PARAMETER_FPS_RANGE_T */
+	MMAL_PARAMETER_CAPTURE_EXPOSURE_COMP, /**< @ref MMAL_PARAMETER_INT32_T */
+
+	/* 0x40 */
+	MMAL_PARAMETER_SW_SHARPEN_DISABLE, /**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_FLASH_REQUIRED, /**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_SW_SATURATION_DISABLE, /**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_SHUTTER_SPEED,             /**< Takes a @ref MMAL_PARAMETER_UINT32_T */
+	MMAL_PARAMETER_CUSTOM_AWB_GAINS,          /**< Takes a @ref MMAL_PARAMETER_AWB_GAINS_T */
+};
+
+struct mmal_parameter_rational {
+	s32 num;    /**< Numerator */
+	s32 den;    /**< Denominator */
+};
+
+enum mmal_parameter_camera_config_timestamp_mode {
+	MMAL_PARAM_TIMESTAMP_MODE_ZERO = 0, /* Always timestamp frames as 0 */
+	MMAL_PARAM_TIMESTAMP_MODE_RAW_STC,  /* Use the raw STC value
+					     * for the frame timestamp
+					     */
+	MMAL_PARAM_TIMESTAMP_MODE_RESET_STC, /* Use the STC timestamp
+					      * but subtract the
+					      * timestamp of the first
+					      * frame sent to give a
+					      * zero based timestamp.
+					      */
+};
+
+struct mmal_parameter_fps_range {
+	/**< Low end of the permitted framerate range */
+	struct mmal_parameter_rational	fps_low;
+	/**< High end of the permitted framerate range */
+	struct mmal_parameter_rational	fps_high;
+};
+
+
+/* camera configuration parameter */
+struct mmal_parameter_camera_config {
+	/* Parameters for setting up the image pools */
+	u32 max_stills_w; /* Max size of stills capture */
+	u32 max_stills_h;
+	u32 stills_yuv422; /* Allow YUV422 stills capture */
+	u32 one_shot_stills; /* Continuous or one shot stills captures. */
+
+	u32 max_preview_video_w; /* Max size of the preview or video
+				  * capture frames
+				  */
+	u32 max_preview_video_h;
+	u32 num_preview_video_frames;
+
+	/** Sets the height of the circular buffer for stills capture. */
+	u32 stills_capture_circular_buffer_height;
+
+	/** Allows preview/encode to resume as fast as possible after the stills
+	 * input frame has been received, and then processes the still frame in
+	 * the background whilst preview/encode has resumed.
+	 * Actual mode is controlled by MMAL_PARAMETER_CAPTURE_MODE.
+	 */
+	u32 fast_preview_resume;
+
+	/** Selects algorithm for timestamping frames if
+	 * there is no clock component connected.
+	 * enum mmal_parameter_camera_config_timestamp_mode
+	 */
+	s32 use_stc_timestamp;
+};
+
+
+enum mmal_parameter_exposuremode {
+	MMAL_PARAM_EXPOSUREMODE_OFF,
+	MMAL_PARAM_EXPOSUREMODE_AUTO,
+	MMAL_PARAM_EXPOSUREMODE_NIGHT,
+	MMAL_PARAM_EXPOSUREMODE_NIGHTPREVIEW,
+	MMAL_PARAM_EXPOSUREMODE_BACKLIGHT,
+	MMAL_PARAM_EXPOSUREMODE_SPOTLIGHT,
+	MMAL_PARAM_EXPOSUREMODE_SPORTS,
+	MMAL_PARAM_EXPOSUREMODE_SNOW,
+	MMAL_PARAM_EXPOSUREMODE_BEACH,
+	MMAL_PARAM_EXPOSUREMODE_VERYLONG,
+	MMAL_PARAM_EXPOSUREMODE_FIXEDFPS,
+	MMAL_PARAM_EXPOSUREMODE_ANTISHAKE,
+	MMAL_PARAM_EXPOSUREMODE_FIREWORKS,
+};
+
+enum mmal_parameter_exposuremeteringmode {
+	MMAL_PARAM_EXPOSUREMETERINGMODE_AVERAGE,
+	MMAL_PARAM_EXPOSUREMETERINGMODE_SPOT,
+	MMAL_PARAM_EXPOSUREMETERINGMODE_BACKLIT,
+	MMAL_PARAM_EXPOSUREMETERINGMODE_MATRIX,
+};
+
+enum mmal_parameter_awbmode {
+	MMAL_PARAM_AWBMODE_OFF,
+	MMAL_PARAM_AWBMODE_AUTO,
+	MMAL_PARAM_AWBMODE_SUNLIGHT,
+	MMAL_PARAM_AWBMODE_CLOUDY,
+	MMAL_PARAM_AWBMODE_SHADE,
+	MMAL_PARAM_AWBMODE_TUNGSTEN,
+	MMAL_PARAM_AWBMODE_FLUORESCENT,
+	MMAL_PARAM_AWBMODE_INCANDESCENT,
+	MMAL_PARAM_AWBMODE_FLASH,
+	MMAL_PARAM_AWBMODE_HORIZON,
+};
+
+enum mmal_parameter_imagefx {
+	MMAL_PARAM_IMAGEFX_NONE,
+	MMAL_PARAM_IMAGEFX_NEGATIVE,
+	MMAL_PARAM_IMAGEFX_SOLARIZE,
+	MMAL_PARAM_IMAGEFX_POSTERIZE,
+	MMAL_PARAM_IMAGEFX_WHITEBOARD,
+	MMAL_PARAM_IMAGEFX_BLACKBOARD,
+	MMAL_PARAM_IMAGEFX_SKETCH,
+	MMAL_PARAM_IMAGEFX_DENOISE,
+	MMAL_PARAM_IMAGEFX_EMBOSS,
+	MMAL_PARAM_IMAGEFX_OILPAINT,
+	MMAL_PARAM_IMAGEFX_HATCH,
+	MMAL_PARAM_IMAGEFX_GPEN,
+	MMAL_PARAM_IMAGEFX_PASTEL,
+	MMAL_PARAM_IMAGEFX_WATERCOLOUR,
+	MMAL_PARAM_IMAGEFX_FILM,
+	MMAL_PARAM_IMAGEFX_BLUR,
+	MMAL_PARAM_IMAGEFX_SATURATION,
+	MMAL_PARAM_IMAGEFX_COLOURSWAP,
+	MMAL_PARAM_IMAGEFX_WASHEDOUT,
+	MMAL_PARAM_IMAGEFX_POSTERISE,
+	MMAL_PARAM_IMAGEFX_COLOURPOINT,
+	MMAL_PARAM_IMAGEFX_COLOURBALANCE,
+	MMAL_PARAM_IMAGEFX_CARTOON,
+};
+
+enum MMAL_PARAM_FLICKERAVOID_T {
+	MMAL_PARAM_FLICKERAVOID_OFF,
+	MMAL_PARAM_FLICKERAVOID_AUTO,
+	MMAL_PARAM_FLICKERAVOID_50HZ,
+	MMAL_PARAM_FLICKERAVOID_60HZ,
+	MMAL_PARAM_FLICKERAVOID_MAX = 0x7FFFFFFF
+};
+
+struct mmal_parameter_awbgains {
+	struct mmal_parameter_rational r_gain;	/**< Red gain */
+	struct mmal_parameter_rational b_gain;	/**< Blue gain */
+};
+
+/** Manner of video rate control */
+enum mmal_parameter_rate_control_mode {
+	MMAL_VIDEO_RATECONTROL_DEFAULT,
+	MMAL_VIDEO_RATECONTROL_VARIABLE,
+	MMAL_VIDEO_RATECONTROL_CONSTANT,
+	MMAL_VIDEO_RATECONTROL_VARIABLE_SKIP_FRAMES,
+	MMAL_VIDEO_RATECONTROL_CONSTANT_SKIP_FRAMES
+};
+
+enum mmal_video_profile {
+	MMAL_VIDEO_PROFILE_H263_BASELINE,
+	MMAL_VIDEO_PROFILE_H263_H320CODING,
+	MMAL_VIDEO_PROFILE_H263_BACKWARDCOMPATIBLE,
+	MMAL_VIDEO_PROFILE_H263_ISWV2,
+	MMAL_VIDEO_PROFILE_H263_ISWV3,
+	MMAL_VIDEO_PROFILE_H263_HIGHCOMPRESSION,
+	MMAL_VIDEO_PROFILE_H263_INTERNET,
+	MMAL_VIDEO_PROFILE_H263_INTERLACE,
+	MMAL_VIDEO_PROFILE_H263_HIGHLATENCY,
+	MMAL_VIDEO_PROFILE_MP4V_SIMPLE,
+	MMAL_VIDEO_PROFILE_MP4V_SIMPLESCALABLE,
+	MMAL_VIDEO_PROFILE_MP4V_CORE,
+	MMAL_VIDEO_PROFILE_MP4V_MAIN,
+	MMAL_VIDEO_PROFILE_MP4V_NBIT,
+	MMAL_VIDEO_PROFILE_MP4V_SCALABLETEXTURE,
+	MMAL_VIDEO_PROFILE_MP4V_SIMPLEFACE,
+	MMAL_VIDEO_PROFILE_MP4V_SIMPLEFBA,
+	MMAL_VIDEO_PROFILE_MP4V_BASICANIMATED,
+	MMAL_VIDEO_PROFILE_MP4V_HYBRID,
+	MMAL_VIDEO_PROFILE_MP4V_ADVANCEDREALTIME,
+	MMAL_VIDEO_PROFILE_MP4V_CORESCALABLE,
+	MMAL_VIDEO_PROFILE_MP4V_ADVANCEDCODING,
+	MMAL_VIDEO_PROFILE_MP4V_ADVANCEDCORE,
+	MMAL_VIDEO_PROFILE_MP4V_ADVANCEDSCALABLE,
+	MMAL_VIDEO_PROFILE_MP4V_ADVANCEDSIMPLE,
+	MMAL_VIDEO_PROFILE_H264_BASELINE,
+	MMAL_VIDEO_PROFILE_H264_MAIN,
+	MMAL_VIDEO_PROFILE_H264_EXTENDED,
+	MMAL_VIDEO_PROFILE_H264_HIGH,
+	MMAL_VIDEO_PROFILE_H264_HIGH10,
+	MMAL_VIDEO_PROFILE_H264_HIGH422,
+	MMAL_VIDEO_PROFILE_H264_HIGH444,
+	MMAL_VIDEO_PROFILE_H264_CONSTRAINED_BASELINE,
+	MMAL_VIDEO_PROFILE_DUMMY = 0x7FFFFFFF
+};
+
+enum mmal_video_level {
+	MMAL_VIDEO_LEVEL_H263_10,
+	MMAL_VIDEO_LEVEL_H263_20,
+	MMAL_VIDEO_LEVEL_H263_30,
+	MMAL_VIDEO_LEVEL_H263_40,
+	MMAL_VIDEO_LEVEL_H263_45,
+	MMAL_VIDEO_LEVEL_H263_50,
+	MMAL_VIDEO_LEVEL_H263_60,
+	MMAL_VIDEO_LEVEL_H263_70,
+	MMAL_VIDEO_LEVEL_MP4V_0,
+	MMAL_VIDEO_LEVEL_MP4V_0b,
+	MMAL_VIDEO_LEVEL_MP4V_1,
+	MMAL_VIDEO_LEVEL_MP4V_2,
+	MMAL_VIDEO_LEVEL_MP4V_3,
+	MMAL_VIDEO_LEVEL_MP4V_4,
+	MMAL_VIDEO_LEVEL_MP4V_4a,
+	MMAL_VIDEO_LEVEL_MP4V_5,
+	MMAL_VIDEO_LEVEL_MP4V_6,
+	MMAL_VIDEO_LEVEL_H264_1,
+	MMAL_VIDEO_LEVEL_H264_1b,
+	MMAL_VIDEO_LEVEL_H264_11,
+	MMAL_VIDEO_LEVEL_H264_12,
+	MMAL_VIDEO_LEVEL_H264_13,
+	MMAL_VIDEO_LEVEL_H264_2,
+	MMAL_VIDEO_LEVEL_H264_21,
+	MMAL_VIDEO_LEVEL_H264_22,
+	MMAL_VIDEO_LEVEL_H264_3,
+	MMAL_VIDEO_LEVEL_H264_31,
+	MMAL_VIDEO_LEVEL_H264_32,
+	MMAL_VIDEO_LEVEL_H264_4,
+	MMAL_VIDEO_LEVEL_H264_41,
+	MMAL_VIDEO_LEVEL_H264_42,
+	MMAL_VIDEO_LEVEL_H264_5,
+	MMAL_VIDEO_LEVEL_H264_51,
+	MMAL_VIDEO_LEVEL_DUMMY = 0x7FFFFFFF
+};
+
+struct mmal_parameter_video_profile {
+	enum mmal_video_profile profile;
+	enum mmal_video_level level;
+};
+
+/* video parameters */
+
+enum mmal_parameter_video_type {
+	/** @ref MMAL_DISPLAYREGION_T */
+	MMAL_PARAMETER_DISPLAYREGION = MMAL_PARAMETER_GROUP_VIDEO,
+
+	/** @ref MMAL_PARAMETER_VIDEO_PROFILE_T */
+	MMAL_PARAMETER_SUPPORTED_PROFILES,
+
+	/** @ref MMAL_PARAMETER_VIDEO_PROFILE_T */
+	MMAL_PARAMETER_PROFILE,
+
+	/** @ref MMAL_PARAMETER_UINT32_T */
+	MMAL_PARAMETER_INTRAPERIOD,
+
+	/** @ref MMAL_PARAMETER_VIDEO_RATECONTROL_T */
+	MMAL_PARAMETER_RATECONTROL,
+
+	/** @ref MMAL_PARAMETER_VIDEO_NALUNITFORMAT_T */
+	MMAL_PARAMETER_NALUNITFORMAT,
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_MINIMISE_FRAGMENTATION,
+
+	/** @ref MMAL_PARAMETER_UINT32_T.
+	 * Setting the value to zero resets to the default (one slice per frame).
+	 */
+	MMAL_PARAMETER_MB_ROWS_PER_SLICE,
+
+	/** @ref MMAL_PARAMETER_VIDEO_LEVEL_EXTENSION_T */
+	MMAL_PARAMETER_VIDEO_LEVEL_EXTENSION,
+
+	/** @ref MMAL_PARAMETER_VIDEO_EEDE_ENABLE_T */
+	MMAL_PARAMETER_VIDEO_EEDE_ENABLE,
+
+	/** @ref MMAL_PARAMETER_VIDEO_EEDE_LOSSRATE_T */
+	MMAL_PARAMETER_VIDEO_EEDE_LOSSRATE,
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T. Request an I-frame. */
+	MMAL_PARAMETER_VIDEO_REQUEST_I_FRAME,
+	/** @ref MMAL_PARAMETER_VIDEO_INTRA_REFRESH_T */
+	MMAL_PARAMETER_VIDEO_INTRA_REFRESH,
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T. */
+	MMAL_PARAMETER_VIDEO_IMMUTABLE_INPUT,
+
+	/** @ref MMAL_PARAMETER_UINT32_T. Run-time bit rate control */
+	MMAL_PARAMETER_VIDEO_BIT_RATE,
+
+	/** @ref MMAL_PARAMETER_FRAME_RATE_T */
+	MMAL_PARAMETER_VIDEO_FRAME_RATE,
+
+	/** @ref MMAL_PARAMETER_UINT32_T. */
+	MMAL_PARAMETER_VIDEO_ENCODE_MIN_QUANT,
+
+	/** @ref MMAL_PARAMETER_UINT32_T. */
+	MMAL_PARAMETER_VIDEO_ENCODE_MAX_QUANT,
+
+	/** @ref MMAL_PARAMETER_VIDEO_ENCODE_RC_MODEL_T. */
+	MMAL_PARAMETER_VIDEO_ENCODE_RC_MODEL,
+
+	MMAL_PARAMETER_EXTRA_BUFFERS, /**< @ref MMAL_PARAMETER_UINT32_T. */
+	/** @ref MMAL_PARAMETER_UINT32_T.
+	 * Changing this parameter from the default can reduce frame rate
+	 * because image buffers need to be re-pitched.
+	 */
+	MMAL_PARAMETER_VIDEO_ALIGN_HORIZ,
+
+	/** @ref MMAL_PARAMETER_UINT32_T.
+	 * Changing this parameter from the default can reduce frame rate
+	 * because image buffers need to be re-pitched.
+	 */
+	MMAL_PARAMETER_VIDEO_ALIGN_VERT,
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T. */
+	MMAL_PARAMETER_VIDEO_DROPPABLE_PFRAMES,
+
+	/** @ref MMAL_PARAMETER_UINT32_T. */
+	MMAL_PARAMETER_VIDEO_ENCODE_INITIAL_QUANT,
+
+	/**< @ref MMAL_PARAMETER_UINT32_T. */
+	MMAL_PARAMETER_VIDEO_ENCODE_QP_P,
+
+	/**< @ref MMAL_PARAMETER_UINT32_T. */
+	MMAL_PARAMETER_VIDEO_ENCODE_RC_SLICE_DQUANT,
+
+	/** @ref MMAL_PARAMETER_UINT32_T */
+	MMAL_PARAMETER_VIDEO_ENCODE_FRAME_LIMIT_BITS,
+
+	/** @ref MMAL_PARAMETER_UINT32_T. */
+	MMAL_PARAMETER_VIDEO_ENCODE_PEAK_RATE,
+
+	/* H264 specific parameters */
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T. */
+	MMAL_PARAMETER_VIDEO_ENCODE_H264_DISABLE_CABAC,
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T. */
+	MMAL_PARAMETER_VIDEO_ENCODE_H264_LOW_LATENCY,
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T. */
+	MMAL_PARAMETER_VIDEO_ENCODE_H264_AU_DELIMITERS,
+
+	/** @ref MMAL_PARAMETER_UINT32_T. */
+	MMAL_PARAMETER_VIDEO_ENCODE_H264_DEBLOCK_IDC,
+
+	/** @ref MMAL_PARAMETER_VIDEO_ENCODER_H264_MB_INTRA_MODES_T. */
+	MMAL_PARAMETER_VIDEO_ENCODE_H264_MB_INTRA_MODE,
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_VIDEO_ENCODE_HEADER_ON_OPEN,
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_VIDEO_ENCODE_PRECODE_FOR_QP,
+
+	/** @ref MMAL_PARAMETER_VIDEO_DRM_INIT_INFO_T. */
+	MMAL_PARAMETER_VIDEO_DRM_INIT_INFO,
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_VIDEO_TIMESTAMP_FIFO,
+
+	/** @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_VIDEO_DECODE_ERROR_CONCEALMENT,
+
+	/** @ref MMAL_PARAMETER_VIDEO_DRM_PROTECT_BUFFER_T. */
+	MMAL_PARAMETER_VIDEO_DRM_PROTECT_BUFFER,
+
+	/** @ref MMAL_PARAMETER_BYTES_T */
+	MMAL_PARAMETER_VIDEO_DECODE_CONFIG_VD3,
+
+	/**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_VIDEO_ENCODE_H264_VCL_HRD_PARAMETERS,
+
+	/**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_VIDEO_ENCODE_H264_LOW_DELAY_HRD_FLAG,
+
+	/**< @ref MMAL_PARAMETER_BOOLEAN_T */
+	MMAL_PARAMETER_VIDEO_ENCODE_INLINE_HEADER
+};
+
+/** Valid mirror modes */
+enum mmal_parameter_mirror {
+	MMAL_PARAM_MIRROR_NONE,
+	MMAL_PARAM_MIRROR_VERTICAL,
+	MMAL_PARAM_MIRROR_HORIZONTAL,
+	MMAL_PARAM_MIRROR_BOTH,
+};
+
+enum mmal_parameter_displaytransform {
+	MMAL_DISPLAY_ROT0 = 0,
+	MMAL_DISPLAY_MIRROR_ROT0 = 1,
+	MMAL_DISPLAY_MIRROR_ROT180 = 2,
+	MMAL_DISPLAY_ROT180 = 3,
+	MMAL_DISPLAY_MIRROR_ROT90 = 4,
+	MMAL_DISPLAY_ROT270 = 5,
+	MMAL_DISPLAY_ROT90 = 6,
+	MMAL_DISPLAY_MIRROR_ROT270 = 7,
+};
+
+enum mmal_parameter_displaymode {
+	MMAL_DISPLAY_MODE_FILL = 0,
+	MMAL_DISPLAY_MODE_LETTERBOX = 1,
+};
+
+enum mmal_parameter_displayset {
+	MMAL_DISPLAY_SET_NONE = 0,
+	MMAL_DISPLAY_SET_NUM = 1,
+	MMAL_DISPLAY_SET_FULLSCREEN = 2,
+	MMAL_DISPLAY_SET_TRANSFORM = 4,
+	MMAL_DISPLAY_SET_DEST_RECT = 8,
+	MMAL_DISPLAY_SET_SRC_RECT = 0x10,
+	MMAL_DISPLAY_SET_MODE = 0x20,
+	MMAL_DISPLAY_SET_PIXEL = 0x40,
+	MMAL_DISPLAY_SET_NOASPECT = 0x80,
+	MMAL_DISPLAY_SET_LAYER = 0x100,
+	MMAL_DISPLAY_SET_COPYPROTECT = 0x200,
+	MMAL_DISPLAY_SET_ALPHA = 0x400,
+};
+
+struct mmal_parameter_displayregion {
+	/** Bitfield that indicates which fields are set and should be
+	 * used. All other fields will maintain their current value.
+	 * \ref MMAL_DISPLAYSET_T defines the bits that can be
+	 * combined.
+	 */
+	u32 set;
+
+	/** Describes the display output device, with 0 typically
+	 * being a directly connected LCD display.  The actual values
+	 * will depend on the hardware.  Code using hard-wired numbers
+	 * (e.g. 2) is certain to fail.
+	 */
+
+	u32 display_num;
+	/** Indicates that we are using the full device screen area,
+	 * rather than a window of the display.  If zero, then
+	 * dest_rect is used to specify a region of the display to
+	 * use.
+	 */
+
+	s32 fullscreen;
+	/** Indicates any rotation or flipping used to map frames onto
+	 * the natural display orientation.
+	 */
+	u32 transform; /* enum mmal_parameter_displaytransform */
+
+	/** Where to display the frame within the screen, if
+	 * fullscreen is zero.
+	 */
+	struct vchiq_mmal_rect dest_rect;
+
+	/** Indicates which area of the frame to display. If all
+	 * values are zero, the whole frame will be used.
+	 */
+	struct vchiq_mmal_rect src_rect;
+
+	/** If set to non-zero, indicates that any display scaling
+	 * should disregard the aspect ratio of the frame region being
+	 * displayed.
+	 */
+	s32 noaspect;
+
+	/** Indicates how the image should be scaled to fit the
+	 * display. \code MMAL_DISPLAY_MODE_FILL \endcode indicates
+	 * that the image should fill the screen by potentially
+	 * cropping the frames.  Setting \code mode \endcode to \code
+	 * MMAL_DISPLAY_MODE_LETTERBOX \endcode indicates that all the
+	 * source region should be displayed and black bars added if
+	 * necessary.
+	 */
+	u32 mode; /* enum mmal_parameter_displaymode */
+
+	/** If non-zero, defines the width of a source pixel relative
+	 * to \code pixel_y \endcode.  If zero, then pixels default to
+	 * being square.
+	 */
+	u32 pixel_x;
+
+	/** If non-zero, defines the height of a source pixel relative
+	 * to \code pixel_x \endcode.  If zero, then pixels default to
+	 * being square.
+	 */
+	u32 pixel_y;
+
+	/** Sets the relative depth of the images, with greater values
+	 * being in front of smaller values.
+	 */
+	u32 layer;
+
+	/** Set to non-zero to ensure copy protection is used on
+	 * output.
+	 */
+	s32 copyprotect_required;
+
+	/** Level of opacity of the layer, where zero is fully
+	 * transparent and 255 is fully opaque.
+	 */
+	u32 alpha;
+};
+
+#define MMAL_MAX_IMAGEFX_PARAMETERS 5
+
+struct mmal_parameter_imagefx_parameters {
+	enum mmal_parameter_imagefx effect;
+	u32 num_effect_params;
+	u32 effect_parameter[MMAL_MAX_IMAGEFX_PARAMETERS];
+};
+
+#define MMAL_PARAMETER_CAMERA_INFO_MAX_CAMERAS 4
+#define MMAL_PARAMETER_CAMERA_INFO_MAX_FLASHES 2
+#define MMAL_PARAMETER_CAMERA_INFO_MAX_STR_LEN 16
+
+struct mmal_parameter_camera_info_camera_t {
+	u32    port_id;
+	u32    max_width;
+	u32    max_height;
+	u32    lens_present;
+	u8     camera_name[MMAL_PARAMETER_CAMERA_INFO_MAX_STR_LEN];
+};
+
+enum mmal_parameter_camera_info_flash_type_t {
+	/* Make values explicit to ensure they match values in config ini */
+	MMAL_PARAMETER_CAMERA_INFO_FLASH_TYPE_XENON = 0,
+	MMAL_PARAMETER_CAMERA_INFO_FLASH_TYPE_LED   = 1,
+	MMAL_PARAMETER_CAMERA_INFO_FLASH_TYPE_OTHER = 2,
+	MMAL_PARAMETER_CAMERA_INFO_FLASH_TYPE_MAX = 0x7FFFFFFF
+};
+
+struct mmal_parameter_camera_info_flash_t {
+	enum mmal_parameter_camera_info_flash_type_t flash_type;
+};
+
+struct mmal_parameter_camera_info_t {
+	u32                            num_cameras;
+	u32                            num_flashes;
+	struct mmal_parameter_camera_info_camera_t
+				cameras[MMAL_PARAMETER_CAMERA_INFO_MAX_CAMERAS];
+	struct mmal_parameter_camera_info_flash_t
+				flashes[MMAL_PARAMETER_CAMERA_INFO_MAX_FLASHES];
+};
diff --git a/drivers/staging/media/platform/bcm2835/mmal-vchiq.c b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
new file mode 100644
index 000000000000..781322542d5a
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/mmal-vchiq.c
@@ -0,0 +1,1916 @@
+/*
+ * Broadcom BM2835 V4L2 driver
+ *
+ * Copyright © 2013 Raspberry Pi (Trading) Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
+ *          Dave Stevenson <dsteve@broadcom.com>
+ *          Simon Mellor <simellor@broadcom.com>
+ *          Luke Diamand <luked@broadcom.com>
+ *
+ * V4L2 driver MMAL vchiq interface code
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/completion.h>
+#include <linux/vmalloc.h>
+#include <asm/cacheflush.h>
+#include <media/videobuf2-vmalloc.h>
+
+#include "mmal-common.h"
+#include "mmal-vchiq.h"
+#include "mmal-msg.h"
+
+#define USE_VCHIQ_ARM
+#include "interface/vchi/vchi.h"
+
+/* maximum number of components supported */
+#define VCHIQ_MMAL_MAX_COMPONENTS 4
+
+/*#define FULL_MSG_DUMP 1*/
+
+#ifdef DEBUG
+static const char *const msg_type_names[] = {
+	"UNKNOWN",
+	"QUIT",
+	"SERVICE_CLOSED",
+	"GET_VERSION",
+	"COMPONENT_CREATE",
+	"COMPONENT_DESTROY",
+	"COMPONENT_ENABLE",
+	"COMPONENT_DISABLE",
+	"PORT_INFO_GET",
+	"PORT_INFO_SET",
+	"PORT_ACTION",
+	"BUFFER_FROM_HOST",
+	"BUFFER_TO_HOST",
+	"GET_STATS",
+	"PORT_PARAMETER_SET",
+	"PORT_PARAMETER_GET",
+	"EVENT_TO_HOST",
+	"GET_CORE_STATS_FOR_PORT",
+	"OPAQUE_ALLOCATOR",
+	"CONSUME_MEM",
+	"LMK",
+	"OPAQUE_ALLOCATOR_DESC",
+	"DRM_GET_LHS32",
+	"DRM_GET_TIME",
+	"BUFFER_FROM_HOST_ZEROLEN",
+	"PORT_FLUSH",
+	"HOST_LOG",
+};
+#endif
+
+static const char *const port_action_type_names[] = {
+	"UNKNOWN",
+	"ENABLE",
+	"DISABLE",
+	"FLUSH",
+	"CONNECT",
+	"DISCONNECT",
+	"SET_REQUIREMENTS",
+};
+
+#if defined(DEBUG)
+#if defined(FULL_MSG_DUMP)
+#define DBG_DUMP_MSG(MSG, MSG_LEN, TITLE)				\
+	do {								\
+		pr_debug(TITLE" type:%s(%d) length:%d\n",		\
+			 msg_type_names[(MSG)->h.type],			\
+			 (MSG)->h.type, (MSG_LEN));			\
+		print_hex_dump(KERN_DEBUG, "<<h: ", DUMP_PREFIX_OFFSET,	\
+			       16, 4, (MSG),				\
+			       sizeof(struct mmal_msg_header), 1);	\
+		print_hex_dump(KERN_DEBUG, "<<p: ", DUMP_PREFIX_OFFSET,	\
+			       16, 4,					\
+			       ((u8 *)(MSG)) + sizeof(struct mmal_msg_header),\
+			       (MSG_LEN) - sizeof(struct mmal_msg_header), 1); \
+	} while (0)
+#else
+#define DBG_DUMP_MSG(MSG, MSG_LEN, TITLE)				\
+	{								\
+		pr_debug(TITLE" type:%s(%d) length:%d\n",		\
+			 msg_type_names[(MSG)->h.type],			\
+			 (MSG)->h.type, (MSG_LEN));			\
+	}
+#endif
+#else
+#define DBG_DUMP_MSG(MSG, MSG_LEN, TITLE)
+#endif
+
+/* normal message context */
+struct mmal_msg_context {
+	union {
+		struct {
+			/* work struct for defered callback - must come first */
+			struct work_struct work;
+			/* mmal instance */
+			struct vchiq_mmal_instance *instance;
+			/* mmal port */
+			struct vchiq_mmal_port *port;
+			/* actual buffer used to store bulk reply */
+			struct mmal_buffer *buffer;
+			/* amount of buffer used */
+			unsigned long buffer_used;
+			/* MMAL buffer flags */
+			u32 mmal_flags;
+			/* Presentation and Decode timestamps */
+			s64 pts;
+			s64 dts;
+
+			int status;	/* context status */
+
+		} bulk;		/* bulk data */
+
+		struct {
+			/* message handle to release */
+			VCHI_HELD_MSG_T msg_handle;
+			/* pointer to received message */
+			struct mmal_msg *msg;
+			/* received message length */
+			u32 msg_len;
+			/* completion upon reply */
+			struct completion cmplt;
+		} sync;		/* synchronous response */
+	} u;
+
+};
+
+struct vchiq_mmal_instance {
+	VCHI_SERVICE_HANDLE_T handle;
+
+	/* ensure serialised access to service */
+	struct mutex vchiq_mutex;
+
+	/* ensure serialised access to bulk operations */
+	struct mutex bulk_mutex;
+
+	/* vmalloc page to receive scratch bulk xfers into */
+	void *bulk_scratch;
+
+	/* component to use next */
+	int component_idx;
+	struct vchiq_mmal_component component[VCHIQ_MMAL_MAX_COMPONENTS];
+};
+
+static struct mmal_msg_context *get_msg_context(struct vchiq_mmal_instance
+						*instance)
+{
+	struct mmal_msg_context *msg_context;
+
+	/* todo: should this be allocated from a pool to avoid kmalloc */
+	msg_context = kmalloc(sizeof(*msg_context), GFP_KERNEL);
+	memset(msg_context, 0, sizeof(*msg_context));
+
+	return msg_context;
+}
+
+static void release_msg_context(struct mmal_msg_context *msg_context)
+{
+	kfree(msg_context);
+}
+
+/* deals with receipt of event to host message */
+static void event_to_host_cb(struct vchiq_mmal_instance *instance,
+			     struct mmal_msg *msg, u32 msg_len)
+{
+	pr_debug("unhandled event\n");
+	pr_debug("component:%p port type:%d num:%d cmd:0x%x length:%d\n",
+		 msg->u.event_to_host.client_component,
+		 msg->u.event_to_host.port_type,
+		 msg->u.event_to_host.port_num,
+		 msg->u.event_to_host.cmd, msg->u.event_to_host.length);
+}
+
+/* workqueue scheduled callback
+ *
+ * we do this because it is important we do not call any other vchiq
+ * sync calls from witin the message delivery thread
+ */
+static void buffer_work_cb(struct work_struct *work)
+{
+	struct mmal_msg_context *msg_context = (struct mmal_msg_context *)work;
+
+	msg_context->u.bulk.port->buffer_cb(msg_context->u.bulk.instance,
+					    msg_context->u.bulk.port,
+					    msg_context->u.bulk.status,
+					    msg_context->u.bulk.buffer,
+					    msg_context->u.bulk.buffer_used,
+					    msg_context->u.bulk.mmal_flags,
+					    msg_context->u.bulk.dts,
+					    msg_context->u.bulk.pts);
+
+	/* release message context */
+	release_msg_context(msg_context);
+}
+
+/* enqueue a bulk receive for a given message context */
+static int bulk_receive(struct vchiq_mmal_instance *instance,
+			struct mmal_msg *msg,
+			struct mmal_msg_context *msg_context)
+{
+	unsigned long rd_len;
+	unsigned long flags = 0;
+	int ret;
+
+	/* bulk mutex stops other bulk operations while we have a
+	 * receive in progress - released in callback
+	 */
+	ret = mutex_lock_interruptible(&instance->bulk_mutex);
+	if (ret != 0)
+		return ret;
+
+	rd_len = msg->u.buffer_from_host.buffer_header.length;
+
+	/* take buffer from queue */
+	spin_lock_irqsave(&msg_context->u.bulk.port->slock, flags);
+	if (list_empty(&msg_context->u.bulk.port->buffers)) {
+		spin_unlock_irqrestore(&msg_context->u.bulk.port->slock, flags);
+		pr_err("buffer list empty trying to submit bulk receive\n");
+
+		/* todo: this is a serious error, we should never have
+		 * commited a buffer_to_host operation to the mmal
+		 * port without the buffer to back it up (underflow
+		 * handling) and there is no obvious way to deal with
+		 * this - how is the mmal servie going to react when
+		 * we fail to do the xfer and reschedule a buffer when
+		 * it arrives? perhaps a starved flag to indicate a
+		 * waiting bulk receive?
+		 */
+
+		mutex_unlock(&instance->bulk_mutex);
+
+		return -EINVAL;
+	}
+
+	msg_context->u.bulk.buffer =
+	    list_entry(msg_context->u.bulk.port->buffers.next,
+		       struct mmal_buffer, list);
+	list_del(&msg_context->u.bulk.buffer->list);
+
+	spin_unlock_irqrestore(&msg_context->u.bulk.port->slock, flags);
+
+	/* ensure we do not overrun the available buffer */
+	if (rd_len > msg_context->u.bulk.buffer->buffer_size) {
+		rd_len = msg_context->u.bulk.buffer->buffer_size;
+		pr_warn("short read as not enough receive buffer space\n");
+		/* todo: is this the correct response, what happens to
+		 * the rest of the message data?
+		 */
+	}
+
+	/* store length */
+	msg_context->u.bulk.buffer_used = rd_len;
+	msg_context->u.bulk.mmal_flags =
+	    msg->u.buffer_from_host.buffer_header.flags;
+	msg_context->u.bulk.dts = msg->u.buffer_from_host.buffer_header.dts;
+	msg_context->u.bulk.pts = msg->u.buffer_from_host.buffer_header.pts;
+
+	// only need to flush L1 cache here, as VCHIQ takes care of the L2
+	// cache.
+	__cpuc_flush_dcache_area(msg_context->u.bulk.buffer->buffer, rd_len);
+
+	/* queue the bulk submission */
+	vchi_service_use(instance->handle);
+	ret = vchi_bulk_queue_receive(instance->handle,
+				      msg_context->u.bulk.buffer->buffer,
+				      /* Actual receive needs to be a multiple
+				       * of 4 bytes
+				       */
+				      (rd_len + 3) & ~3,
+				      VCHI_FLAGS_CALLBACK_WHEN_OP_COMPLETE |
+				      VCHI_FLAGS_BLOCK_UNTIL_QUEUED,
+				      msg_context);
+
+	vchi_service_release(instance->handle);
+
+	if (ret != 0) {
+		/* callback will not be clearing the mutex */
+		mutex_unlock(&instance->bulk_mutex);
+	}
+
+	return ret;
+}
+
+/* enque a dummy bulk receive for a given message context */
+static int dummy_bulk_receive(struct vchiq_mmal_instance *instance,
+			      struct mmal_msg_context *msg_context)
+{
+	int ret;
+
+	/* bulk mutex stops other bulk operations while we have a
+	 * receive in progress - released in callback
+	 */
+	ret = mutex_lock_interruptible(&instance->bulk_mutex);
+	if (ret != 0)
+		return ret;
+
+	/* zero length indicates this was a dummy transfer */
+	msg_context->u.bulk.buffer_used = 0;
+
+	/* queue the bulk submission */
+	vchi_service_use(instance->handle);
+
+	ret = vchi_bulk_queue_receive(instance->handle,
+				      instance->bulk_scratch,
+				      8,
+				      VCHI_FLAGS_CALLBACK_WHEN_OP_COMPLETE |
+				      VCHI_FLAGS_BLOCK_UNTIL_QUEUED,
+				      msg_context);
+
+	vchi_service_release(instance->handle);
+
+	if (ret != 0) {
+		/* callback will not be clearing the mutex */
+		mutex_unlock(&instance->bulk_mutex);
+	}
+
+	return ret;
+}
+
+/* data in message, memcpy from packet into output buffer */
+static int inline_receive(struct vchiq_mmal_instance *instance,
+			  struct mmal_msg *msg,
+			  struct mmal_msg_context *msg_context)
+{
+	unsigned long flags = 0;
+
+	/* take buffer from queue */
+	spin_lock_irqsave(&msg_context->u.bulk.port->slock, flags);
+	if (list_empty(&msg_context->u.bulk.port->buffers)) {
+		spin_unlock_irqrestore(&msg_context->u.bulk.port->slock, flags);
+		pr_err("buffer list empty trying to receive inline\n");
+
+		/* todo: this is a serious error, we should never have
+		 * commited a buffer_to_host operation to the mmal
+		 * port without the buffer to back it up (with
+		 * underflow handling) and there is no obvious way to
+		 * deal with this. Less bad than the bulk case as we
+		 * can just drop this on the floor but...unhelpful
+		 */
+		return -EINVAL;
+	}
+
+	msg_context->u.bulk.buffer =
+	    list_entry(msg_context->u.bulk.port->buffers.next,
+		       struct mmal_buffer, list);
+	list_del(&msg_context->u.bulk.buffer->list);
+
+	spin_unlock_irqrestore(&msg_context->u.bulk.port->slock, flags);
+
+	memcpy(msg_context->u.bulk.buffer->buffer,
+	       msg->u.buffer_from_host.short_data,
+	       msg->u.buffer_from_host.payload_in_message);
+
+	msg_context->u.bulk.buffer_used =
+	    msg->u.buffer_from_host.payload_in_message;
+
+	return 0;
+}
+
+/* queue the buffer availability with MMAL_MSG_TYPE_BUFFER_FROM_HOST */
+static int
+buffer_from_host(struct vchiq_mmal_instance *instance,
+		 struct vchiq_mmal_port *port, struct mmal_buffer *buf)
+{
+	struct mmal_msg_context *msg_context;
+	struct mmal_msg m;
+	int ret;
+
+	pr_debug("instance:%p buffer:%p\n", instance->handle, buf);
+
+	/* bulk mutex stops other bulk operations while we
+	 * have a receive in progress
+	 */
+	if (mutex_lock_interruptible(&instance->bulk_mutex))
+		return -EINTR;
+
+	/* get context */
+	msg_context = get_msg_context(instance);
+	if (msg_context == NULL)
+		return -ENOMEM;
+
+	/* store bulk message context for when data arrives */
+	msg_context->u.bulk.instance = instance;
+	msg_context->u.bulk.port = port;
+	msg_context->u.bulk.buffer = NULL;	/* not valid until bulk xfer */
+	msg_context->u.bulk.buffer_used = 0;
+
+	/* initialise work structure ready to schedule callback */
+	INIT_WORK(&msg_context->u.bulk.work, buffer_work_cb);
+
+	/* prep the buffer from host message */
+	memset(&m, 0xbc, sizeof(m));	/* just to make debug clearer */
+
+	m.h.type = MMAL_MSG_TYPE_BUFFER_FROM_HOST;
+	m.h.magic = MMAL_MAGIC;
+	m.h.context = msg_context;
+	m.h.status = 0;
+
+	/* drvbuf is our private data passed back */
+	m.u.buffer_from_host.drvbuf.magic = MMAL_MAGIC;
+	m.u.buffer_from_host.drvbuf.component_handle = port->component->handle;
+	m.u.buffer_from_host.drvbuf.port_handle = port->handle;
+	m.u.buffer_from_host.drvbuf.client_context = msg_context;
+
+	/* buffer header */
+	m.u.buffer_from_host.buffer_header.cmd = 0;
+	m.u.buffer_from_host.buffer_header.data = buf->buffer;
+	m.u.buffer_from_host.buffer_header.alloc_size = buf->buffer_size;
+	m.u.buffer_from_host.buffer_header.length = 0;	/* nothing used yet */
+	m.u.buffer_from_host.buffer_header.offset = 0;	/* no offset */
+	m.u.buffer_from_host.buffer_header.flags = 0;	/* no flags */
+	m.u.buffer_from_host.buffer_header.pts = MMAL_TIME_UNKNOWN;
+	m.u.buffer_from_host.buffer_header.dts = MMAL_TIME_UNKNOWN;
+
+	/* clear buffer type sepecific data */
+	memset(&m.u.buffer_from_host.buffer_header_type_specific, 0,
+	       sizeof(m.u.buffer_from_host.buffer_header_type_specific));
+
+	/* no payload in message */
+	m.u.buffer_from_host.payload_in_message = 0;
+
+	vchi_service_use(instance->handle);
+
+	ret = vchi_msg_queue(instance->handle, &m,
+			     sizeof(struct mmal_msg_header) +
+			     sizeof(m.u.buffer_from_host),
+			     VCHI_FLAGS_BLOCK_UNTIL_QUEUED, NULL);
+
+	if (ret != 0) {
+		release_msg_context(msg_context);
+		/* todo: is this correct error value? */
+	}
+
+	vchi_service_release(instance->handle);
+
+	mutex_unlock(&instance->bulk_mutex);
+
+	return ret;
+}
+
+/* submit a buffer to the mmal sevice
+ *
+ * the buffer_from_host uses size data from the ports next available
+ * mmal_buffer and deals with there being no buffer available by
+ * incrementing the underflow for later
+ */
+static int port_buffer_from_host(struct vchiq_mmal_instance *instance,
+				 struct vchiq_mmal_port *port)
+{
+	int ret;
+	struct mmal_buffer *buf;
+	unsigned long flags = 0;
+
+	if (!port->enabled)
+		return -EINVAL;
+
+	/* peek buffer from queue */
+	spin_lock_irqsave(&port->slock, flags);
+	if (list_empty(&port->buffers)) {
+		port->buffer_underflow++;
+		spin_unlock_irqrestore(&port->slock, flags);
+		return -ENOSPC;
+	}
+
+	buf = list_entry(port->buffers.next, struct mmal_buffer, list);
+
+	spin_unlock_irqrestore(&port->slock, flags);
+
+	/* issue buffer to mmal service */
+	ret = buffer_from_host(instance, port, buf);
+	if (ret) {
+		pr_err("adding buffer header failed\n");
+		/* todo: how should this be dealt with */
+	}
+
+	return ret;
+}
+
+/* deals with receipt of buffer to host message */
+static void buffer_to_host_cb(struct vchiq_mmal_instance *instance,
+			      struct mmal_msg *msg, u32 msg_len)
+{
+	struct mmal_msg_context *msg_context;
+
+	pr_debug("buffer_to_host_cb: instance:%p msg:%p msg_len:%d\n",
+		 instance, msg, msg_len);
+
+	if (msg->u.buffer_from_host.drvbuf.magic == MMAL_MAGIC) {
+		msg_context = msg->u.buffer_from_host.drvbuf.client_context;
+	} else {
+		pr_err("MMAL_MSG_TYPE_BUFFER_TO_HOST with bad magic\n");
+		return;
+	}
+
+	if (msg->h.status != MMAL_MSG_STATUS_SUCCESS) {
+		/* message reception had an error */
+		pr_warn("error %d in reply\n", msg->h.status);
+
+		msg_context->u.bulk.status = msg->h.status;
+
+	} else if (msg->u.buffer_from_host.buffer_header.length == 0) {
+		/* empty buffer */
+		if (msg->u.buffer_from_host.buffer_header.flags &
+		    MMAL_BUFFER_HEADER_FLAG_EOS) {
+			msg_context->u.bulk.status =
+			    dummy_bulk_receive(instance, msg_context);
+			if (msg_context->u.bulk.status == 0)
+				return;	/* successful bulk submission, bulk
+					 * completion will trigger callback
+					 */
+		} else {
+			/* do callback with empty buffer - not EOS though */
+			msg_context->u.bulk.status = 0;
+			msg_context->u.bulk.buffer_used = 0;
+		}
+	} else if (msg->u.buffer_from_host.payload_in_message == 0) {
+		/* data is not in message, queue a bulk receive */
+		msg_context->u.bulk.status =
+		    bulk_receive(instance, msg, msg_context);
+		if (msg_context->u.bulk.status == 0)
+			return;	/* successful bulk submission, bulk
+				 * completion will trigger callback
+				 */
+
+		/* failed to submit buffer, this will end badly */
+		pr_err("error %d on bulk submission\n",
+		       msg_context->u.bulk.status);
+
+	} else if (msg->u.buffer_from_host.payload_in_message <=
+		   MMAL_VC_SHORT_DATA) {
+		/* data payload within message */
+		msg_context->u.bulk.status = inline_receive(instance, msg,
+							    msg_context);
+	} else {
+		pr_err("message with invalid short payload\n");
+
+		/* signal error */
+		msg_context->u.bulk.status = -EINVAL;
+		msg_context->u.bulk.buffer_used =
+		    msg->u.buffer_from_host.payload_in_message;
+	}
+
+	/* replace the buffer header */
+	port_buffer_from_host(instance, msg_context->u.bulk.port);
+
+	/* schedule the port callback */
+	schedule_work(&msg_context->u.bulk.work);
+}
+
+static void bulk_receive_cb(struct vchiq_mmal_instance *instance,
+			    struct mmal_msg_context *msg_context)
+{
+	/* bulk receive operation complete */
+	mutex_unlock(&msg_context->u.bulk.instance->bulk_mutex);
+
+	/* replace the buffer header */
+	port_buffer_from_host(msg_context->u.bulk.instance,
+			      msg_context->u.bulk.port);
+
+	msg_context->u.bulk.status = 0;
+
+	/* schedule the port callback */
+	schedule_work(&msg_context->u.bulk.work);
+}
+
+static void bulk_abort_cb(struct vchiq_mmal_instance *instance,
+			  struct mmal_msg_context *msg_context)
+{
+	pr_err("%s: bulk ABORTED msg_context:%p\n", __func__, msg_context);
+
+	/* bulk receive operation complete */
+	mutex_unlock(&msg_context->u.bulk.instance->bulk_mutex);
+
+	/* replace the buffer header */
+	port_buffer_from_host(msg_context->u.bulk.instance,
+			      msg_context->u.bulk.port);
+
+	msg_context->u.bulk.status = -EINTR;
+
+	schedule_work(&msg_context->u.bulk.work);
+}
+
+/* incoming event service callback */
+static void service_callback(void *param,
+			     const VCHI_CALLBACK_REASON_T reason,
+			     void *bulk_ctx)
+{
+	struct vchiq_mmal_instance *instance = param;
+	int status;
+	u32 msg_len;
+	struct mmal_msg *msg;
+	VCHI_HELD_MSG_T msg_handle;
+
+	if (!instance) {
+		pr_err("Message callback passed NULL instance\n");
+		return;
+	}
+
+	switch (reason) {
+	case VCHI_CALLBACK_MSG_AVAILABLE:
+		status = vchi_msg_hold(instance->handle, (void **)&msg,
+				       &msg_len, VCHI_FLAGS_NONE, &msg_handle);
+		if (status) {
+			pr_err("Unable to dequeue a message (%d)\n", status);
+			break;
+		}
+
+		DBG_DUMP_MSG(msg, msg_len, "<<< reply message");
+
+		/* handling is different for buffer messages */
+		switch (msg->h.type) {
+
+		case MMAL_MSG_TYPE_BUFFER_FROM_HOST:
+			vchi_held_msg_release(&msg_handle);
+			break;
+
+		case MMAL_MSG_TYPE_EVENT_TO_HOST:
+			event_to_host_cb(instance, msg, msg_len);
+			vchi_held_msg_release(&msg_handle);
+
+			break;
+
+		case MMAL_MSG_TYPE_BUFFER_TO_HOST:
+			buffer_to_host_cb(instance, msg, msg_len);
+			vchi_held_msg_release(&msg_handle);
+			break;
+
+		default:
+			/* messages dependant on header context to complete */
+
+			/* todo: the msg.context really ought to be sanity
+			 * checked before we just use it, afaict it comes back
+			 * and is used raw from the videocore. Perhaps it
+			 * should be verified the address lies in the kernel
+			 * address space.
+			 */
+			if (msg->h.context == NULL) {
+				pr_err("received message context was null!\n");
+				vchi_held_msg_release(&msg_handle);
+				break;
+			}
+
+			/* fill in context values */
+			msg->h.context->u.sync.msg_handle = msg_handle;
+			msg->h.context->u.sync.msg = msg;
+			msg->h.context->u.sync.msg_len = msg_len;
+
+			/* todo: should this check (completion_done()
+			 * == 1) for no one waiting? or do we need a
+			 * flag to tell us the completion has been
+			 * interrupted so we can free the message and
+			 * its context. This probably also solves the
+			 * message arriving after interruption todo
+			 * below
+			 */
+
+			/* complete message so caller knows it happened */
+			complete(&msg->h.context->u.sync.cmplt);
+			break;
+		}
+
+		break;
+
+	case VCHI_CALLBACK_BULK_RECEIVED:
+		bulk_receive_cb(instance, bulk_ctx);
+		break;
+
+	case VCHI_CALLBACK_BULK_RECEIVE_ABORTED:
+		bulk_abort_cb(instance, bulk_ctx);
+		break;
+
+	case VCHI_CALLBACK_SERVICE_CLOSED:
+		/* TODO: consider if this requires action if received when
+		 * driver is not explicitly closing the service
+		 */
+		break;
+
+	default:
+		pr_err("Received unhandled message reason %d\n", reason);
+		break;
+	}
+}
+
+static int send_synchronous_mmal_msg(struct vchiq_mmal_instance *instance,
+				     struct mmal_msg *msg,
+				     unsigned int payload_len,
+				     struct mmal_msg **msg_out,
+				     VCHI_HELD_MSG_T *msg_handle_out)
+{
+	struct mmal_msg_context msg_context;
+	int ret;
+
+	/* payload size must not cause message to exceed max size */
+	if (payload_len >
+	    (MMAL_MSG_MAX_SIZE - sizeof(struct mmal_msg_header))) {
+		pr_err("payload length %d exceeds max:%d\n", payload_len,
+			 (MMAL_MSG_MAX_SIZE - sizeof(struct mmal_msg_header)));
+		return -EINVAL;
+	}
+
+	init_completion(&msg_context.u.sync.cmplt);
+
+	msg->h.magic = MMAL_MAGIC;
+	msg->h.context = &msg_context;
+	msg->h.status = 0;
+
+	DBG_DUMP_MSG(msg, (sizeof(struct mmal_msg_header) + payload_len),
+		     ">>> sync message");
+
+	vchi_service_use(instance->handle);
+
+	ret = vchi_msg_queue(instance->handle,
+			     msg,
+			     sizeof(struct mmal_msg_header) + payload_len,
+			     VCHI_FLAGS_BLOCK_UNTIL_QUEUED, NULL);
+
+	vchi_service_release(instance->handle);
+
+	if (ret) {
+		pr_err("error %d queuing message\n", ret);
+		return ret;
+	}
+
+	ret = wait_for_completion_timeout(&msg_context.u.sync.cmplt, 3*HZ);
+	if (ret <= 0) {
+		pr_err("error %d waiting for sync completion\n", ret);
+		if (ret == 0)
+			ret = -ETIME;
+		/* todo: what happens if the message arrives after aborting */
+		return ret;
+	}
+
+	*msg_out = msg_context.u.sync.msg;
+	*msg_handle_out = msg_context.u.sync.msg_handle;
+
+	return 0;
+}
+
+static void dump_port_info(struct vchiq_mmal_port *port)
+{
+	pr_debug("port handle:0x%x enabled:%d\n", port->handle, port->enabled);
+
+	pr_debug("buffer minimum num:%d size:%d align:%d\n",
+		 port->minimum_buffer.num,
+		 port->minimum_buffer.size, port->minimum_buffer.alignment);
+
+	pr_debug("buffer recommended num:%d size:%d align:%d\n",
+		 port->recommended_buffer.num,
+		 port->recommended_buffer.size,
+		 port->recommended_buffer.alignment);
+
+	pr_debug("buffer current values num:%d size:%d align:%d\n",
+		 port->current_buffer.num,
+		 port->current_buffer.size, port->current_buffer.alignment);
+
+	pr_debug("elementry stream: type:%d encoding:0x%x varient:0x%x\n",
+		 port->format.type,
+		 port->format.encoding, port->format.encoding_variant);
+
+	pr_debug("		    bitrate:%d flags:0x%x\n",
+		 port->format.bitrate, port->format.flags);
+
+	if (port->format.type == MMAL_ES_TYPE_VIDEO) {
+		pr_debug
+		    ("es video format: width:%d height:%d colourspace:0x%x\n",
+		     port->es.video.width, port->es.video.height,
+		     port->es.video.color_space);
+
+		pr_debug("		 : crop xywh %d,%d,%d,%d\n",
+			 port->es.video.crop.x,
+			 port->es.video.crop.y,
+			 port->es.video.crop.width, port->es.video.crop.height);
+		pr_debug("		 : framerate %d/%d  aspect %d/%d\n",
+			 port->es.video.frame_rate.num,
+			 port->es.video.frame_rate.den,
+			 port->es.video.par.num, port->es.video.par.den);
+	}
+}
+
+static void port_to_mmal_msg(struct vchiq_mmal_port *port, struct mmal_port *p)
+{
+
+	/* todo do readonly fields need setting at all? */
+	p->type = port->type;
+	p->index = port->index;
+	p->index_all = 0;
+	p->is_enabled = port->enabled;
+	p->buffer_num_min = port->minimum_buffer.num;
+	p->buffer_size_min = port->minimum_buffer.size;
+	p->buffer_alignment_min = port->minimum_buffer.alignment;
+	p->buffer_num_recommended = port->recommended_buffer.num;
+	p->buffer_size_recommended = port->recommended_buffer.size;
+
+	/* only three writable fields in a port */
+	p->buffer_num = port->current_buffer.num;
+	p->buffer_size = port->current_buffer.size;
+	p->userdata = port;
+}
+
+static int port_info_set(struct vchiq_mmal_instance *instance,
+			 struct vchiq_mmal_port *port)
+{
+	int ret;
+	struct mmal_msg m;
+	struct mmal_msg *rmsg;
+	VCHI_HELD_MSG_T rmsg_handle;
+
+	pr_debug("setting port info port %p\n", port);
+	if (!port)
+		return -1;
+	dump_port_info(port);
+
+	m.h.type = MMAL_MSG_TYPE_PORT_INFO_SET;
+
+	m.u.port_info_set.component_handle = port->component->handle;
+	m.u.port_info_set.port_type = port->type;
+	m.u.port_info_set.port_index = port->index;
+
+	port_to_mmal_msg(port, &m.u.port_info_set.port);
+
+	/* elementry stream format setup */
+	m.u.port_info_set.format.type = port->format.type;
+	m.u.port_info_set.format.encoding = port->format.encoding;
+	m.u.port_info_set.format.encoding_variant =
+	    port->format.encoding_variant;
+	m.u.port_info_set.format.bitrate = port->format.bitrate;
+	m.u.port_info_set.format.flags = port->format.flags;
+
+	memcpy(&m.u.port_info_set.es, &port->es,
+	       sizeof(union mmal_es_specific_format));
+
+	m.u.port_info_set.format.extradata_size = port->format.extradata_size;
+	memcpy(&m.u.port_info_set.extradata, port->format.extradata,
+	       port->format.extradata_size);
+
+	ret = send_synchronous_mmal_msg(instance, &m,
+					sizeof(m.u.port_info_set),
+					&rmsg, &rmsg_handle);
+	if (ret)
+		return ret;
+
+	if (rmsg->h.type != MMAL_MSG_TYPE_PORT_INFO_SET) {
+		/* got an unexpected message type in reply */
+		ret = -EINVAL;
+		goto release_msg;
+	}
+
+	/* return operation status */
+	ret = -rmsg->u.port_info_get_reply.status;
+
+	pr_debug("%s:result:%d component:0x%x port:%d\n", __func__, ret,
+		 port->component->handle, port->handle);
+
+release_msg:
+	vchi_held_msg_release(&rmsg_handle);
+
+	return ret;
+
+}
+
+/* use port info get message to retrive port information */
+static int port_info_get(struct vchiq_mmal_instance *instance,
+			 struct vchiq_mmal_port *port)
+{
+	int ret;
+	struct mmal_msg m;
+	struct mmal_msg *rmsg;
+	VCHI_HELD_MSG_T rmsg_handle;
+
+	/* port info time */
+	m.h.type = MMAL_MSG_TYPE_PORT_INFO_GET;
+	m.u.port_info_get.component_handle = port->component->handle;
+	m.u.port_info_get.port_type = port->type;
+	m.u.port_info_get.index = port->index;
+
+	ret = send_synchronous_mmal_msg(instance, &m,
+					sizeof(m.u.port_info_get),
+					&rmsg, &rmsg_handle);
+	if (ret)
+		return ret;
+
+	if (rmsg->h.type != MMAL_MSG_TYPE_PORT_INFO_GET) {
+		/* got an unexpected message type in reply */
+		ret = -EINVAL;
+		goto release_msg;
+	}
+
+	/* return operation status */
+	ret = -rmsg->u.port_info_get_reply.status;
+	if (ret != MMAL_MSG_STATUS_SUCCESS)
+		goto release_msg;
+
+	if (rmsg->u.port_info_get_reply.port.is_enabled == 0)
+		port->enabled = false;
+	else
+		port->enabled = true;
+
+	/* copy the values out of the message */
+	port->handle = rmsg->u.port_info_get_reply.port_handle;
+
+	/* port type and index cached to use on port info set becuase
+	 * it does not use a port handle
+	 */
+	port->type = rmsg->u.port_info_get_reply.port_type;
+	port->index = rmsg->u.port_info_get_reply.port_index;
+
+	port->minimum_buffer.num =
+	    rmsg->u.port_info_get_reply.port.buffer_num_min;
+	port->minimum_buffer.size =
+	    rmsg->u.port_info_get_reply.port.buffer_size_min;
+	port->minimum_buffer.alignment =
+	    rmsg->u.port_info_get_reply.port.buffer_alignment_min;
+
+	port->recommended_buffer.alignment =
+	    rmsg->u.port_info_get_reply.port.buffer_alignment_min;
+	port->recommended_buffer.num =
+	    rmsg->u.port_info_get_reply.port.buffer_num_recommended;
+
+	port->current_buffer.num = rmsg->u.port_info_get_reply.port.buffer_num;
+	port->current_buffer.size =
+	    rmsg->u.port_info_get_reply.port.buffer_size;
+
+	/* stream format */
+	port->format.type = rmsg->u.port_info_get_reply.format.type;
+	port->format.encoding = rmsg->u.port_info_get_reply.format.encoding;
+	port->format.encoding_variant =
+	    rmsg->u.port_info_get_reply.format.encoding_variant;
+	port->format.bitrate = rmsg->u.port_info_get_reply.format.bitrate;
+	port->format.flags = rmsg->u.port_info_get_reply.format.flags;
+
+	/* elementry stream format */
+	memcpy(&port->es,
+	       &rmsg->u.port_info_get_reply.es,
+	       sizeof(union mmal_es_specific_format));
+	port->format.es = &port->es;
+
+	port->format.extradata_size =
+	    rmsg->u.port_info_get_reply.format.extradata_size;
+	memcpy(port->format.extradata,
+	       rmsg->u.port_info_get_reply.extradata,
+	       port->format.extradata_size);
+
+	pr_debug("received port info\n");
+	dump_port_info(port);
+
+release_msg:
+
+	pr_debug("%s:result:%d component:0x%x port:%d\n",
+		 __func__, ret, port->component->handle, port->handle);
+
+	vchi_held_msg_release(&rmsg_handle);
+
+	return ret;
+}
+
+/* create comonent on vc */
+static int create_component(struct vchiq_mmal_instance *instance,
+			    struct vchiq_mmal_component *component,
+			    const char *name)
+{
+	int ret;
+	struct mmal_msg m;
+	struct mmal_msg *rmsg;
+	VCHI_HELD_MSG_T rmsg_handle;
+
+	/* build component create message */
+	m.h.type = MMAL_MSG_TYPE_COMPONENT_CREATE;
+	m.u.component_create.client_component = component;
+	strncpy(m.u.component_create.name, name,
+		sizeof(m.u.component_create.name));
+
+	ret = send_synchronous_mmal_msg(instance, &m,
+					sizeof(m.u.component_create),
+					&rmsg, &rmsg_handle);
+	if (ret)
+		return ret;
+
+	if (rmsg->h.type != m.h.type) {
+		/* got an unexpected message type in reply */
+		ret = -EINVAL;
+		goto release_msg;
+	}
+
+	ret = -rmsg->u.component_create_reply.status;
+	if (ret != MMAL_MSG_STATUS_SUCCESS)
+		goto release_msg;
+
+	/* a valid component response received */
+	component->handle = rmsg->u.component_create_reply.component_handle;
+	component->inputs = rmsg->u.component_create_reply.input_num;
+	component->outputs = rmsg->u.component_create_reply.output_num;
+	component->clocks = rmsg->u.component_create_reply.clock_num;
+
+	pr_debug("Component handle:0x%x in:%d out:%d clock:%d\n",
+		 component->handle,
+		 component->inputs, component->outputs, component->clocks);
+
+release_msg:
+	vchi_held_msg_release(&rmsg_handle);
+
+	return ret;
+}
+
+/* destroys a component on vc */
+static int destroy_component(struct vchiq_mmal_instance *instance,
+			     struct vchiq_mmal_component *component)
+{
+	int ret;
+	struct mmal_msg m;
+	struct mmal_msg *rmsg;
+	VCHI_HELD_MSG_T rmsg_handle;
+
+	m.h.type = MMAL_MSG_TYPE_COMPONENT_DESTROY;
+	m.u.component_destroy.component_handle = component->handle;
+
+	ret = send_synchronous_mmal_msg(instance, &m,
+					sizeof(m.u.component_destroy),
+					&rmsg, &rmsg_handle);
+	if (ret)
+		return ret;
+
+	if (rmsg->h.type != m.h.type) {
+		/* got an unexpected message type in reply */
+		ret = -EINVAL;
+		goto release_msg;
+	}
+
+	ret = -rmsg->u.component_destroy_reply.status;
+
+release_msg:
+
+	vchi_held_msg_release(&rmsg_handle);
+
+	return ret;
+}
+
+/* enable a component on vc */
+static int enable_component(struct vchiq_mmal_instance *instance,
+			    struct vchiq_mmal_component *component)
+{
+	int ret;
+	struct mmal_msg m;
+	struct mmal_msg *rmsg;
+	VCHI_HELD_MSG_T rmsg_handle;
+
+	m.h.type = MMAL_MSG_TYPE_COMPONENT_ENABLE;
+	m.u.component_enable.component_handle = component->handle;
+
+	ret = send_synchronous_mmal_msg(instance, &m,
+					sizeof(m.u.component_enable),
+					&rmsg, &rmsg_handle);
+	if (ret)
+		return ret;
+
+	if (rmsg->h.type != m.h.type) {
+		/* got an unexpected message type in reply */
+		ret = -EINVAL;
+		goto release_msg;
+	}
+
+	ret = -rmsg->u.component_enable_reply.status;
+
+release_msg:
+	vchi_held_msg_release(&rmsg_handle);
+
+	return ret;
+}
+
+/* disable a component on vc */
+static int disable_component(struct vchiq_mmal_instance *instance,
+			     struct vchiq_mmal_component *component)
+{
+	int ret;
+	struct mmal_msg m;
+	struct mmal_msg *rmsg;
+	VCHI_HELD_MSG_T rmsg_handle;
+
+	m.h.type = MMAL_MSG_TYPE_COMPONENT_DISABLE;
+	m.u.component_disable.component_handle = component->handle;
+
+	ret = send_synchronous_mmal_msg(instance, &m,
+					sizeof(m.u.component_disable),
+					&rmsg, &rmsg_handle);
+	if (ret)
+		return ret;
+
+	if (rmsg->h.type != m.h.type) {
+		/* got an unexpected message type in reply */
+		ret = -EINVAL;
+		goto release_msg;
+	}
+
+	ret = -rmsg->u.component_disable_reply.status;
+
+release_msg:
+
+	vchi_held_msg_release(&rmsg_handle);
+
+	return ret;
+}
+
+/* get version of mmal implementation */
+static int get_version(struct vchiq_mmal_instance *instance,
+		       u32 *major_out, u32 *minor_out)
+{
+	int ret;
+	struct mmal_msg m;
+	struct mmal_msg *rmsg;
+	VCHI_HELD_MSG_T rmsg_handle;
+
+	m.h.type = MMAL_MSG_TYPE_GET_VERSION;
+
+	ret = send_synchronous_mmal_msg(instance, &m,
+					sizeof(m.u.version),
+					&rmsg, &rmsg_handle);
+	if (ret)
+		return ret;
+
+	if (rmsg->h.type != m.h.type) {
+		/* got an unexpected message type in reply */
+		ret = -EINVAL;
+		goto release_msg;
+	}
+
+	*major_out = rmsg->u.version.major;
+	*minor_out = rmsg->u.version.minor;
+
+release_msg:
+	vchi_held_msg_release(&rmsg_handle);
+
+	return ret;
+}
+
+/* do a port action with a port as a parameter */
+static int port_action_port(struct vchiq_mmal_instance *instance,
+			    struct vchiq_mmal_port *port,
+			    enum mmal_msg_port_action_type action_type)
+{
+	int ret;
+	struct mmal_msg m;
+	struct mmal_msg *rmsg;
+	VCHI_HELD_MSG_T rmsg_handle;
+
+	m.h.type = MMAL_MSG_TYPE_PORT_ACTION;
+	m.u.port_action_port.component_handle = port->component->handle;
+	m.u.port_action_port.port_handle = port->handle;
+	m.u.port_action_port.action = action_type;
+
+	port_to_mmal_msg(port, &m.u.port_action_port.port);
+
+	ret = send_synchronous_mmal_msg(instance, &m,
+					sizeof(m.u.port_action_port),
+					&rmsg, &rmsg_handle);
+	if (ret)
+		return ret;
+
+	if (rmsg->h.type != MMAL_MSG_TYPE_PORT_ACTION) {
+		/* got an unexpected message type in reply */
+		ret = -EINVAL;
+		goto release_msg;
+	}
+
+	ret = -rmsg->u.port_action_reply.status;
+
+	pr_debug("%s:result:%d component:0x%x port:%d action:%s(%d)\n",
+		 __func__,
+		 ret, port->component->handle, port->handle,
+		 port_action_type_names[action_type], action_type);
+
+release_msg:
+	vchi_held_msg_release(&rmsg_handle);
+
+	return ret;
+}
+
+/* do a port action with handles as parameters */
+static int port_action_handle(struct vchiq_mmal_instance *instance,
+			      struct vchiq_mmal_port *port,
+			      enum mmal_msg_port_action_type action_type,
+			      u32 connect_component_handle,
+			      u32 connect_port_handle)
+{
+	int ret;
+	struct mmal_msg m;
+	struct mmal_msg *rmsg;
+	VCHI_HELD_MSG_T rmsg_handle;
+
+	m.h.type = MMAL_MSG_TYPE_PORT_ACTION;
+
+	m.u.port_action_handle.component_handle = port->component->handle;
+	m.u.port_action_handle.port_handle = port->handle;
+	m.u.port_action_handle.action = action_type;
+
+	m.u.port_action_handle.connect_component_handle =
+	    connect_component_handle;
+	m.u.port_action_handle.connect_port_handle = connect_port_handle;
+
+	ret = send_synchronous_mmal_msg(instance, &m,
+					sizeof(m.u.port_action_handle),
+					&rmsg, &rmsg_handle);
+	if (ret)
+		return ret;
+
+	if (rmsg->h.type != MMAL_MSG_TYPE_PORT_ACTION) {
+		/* got an unexpected message type in reply */
+		ret = -EINVAL;
+		goto release_msg;
+	}
+
+	ret = -rmsg->u.port_action_reply.status;
+
+	pr_debug("%s:result:%d component:0x%x port:%d action:%s(%d)" \
+		 " connect component:0x%x connect port:%d\n",
+		 __func__,
+		 ret, port->component->handle, port->handle,
+		 port_action_type_names[action_type],
+		 action_type, connect_component_handle, connect_port_handle);
+
+release_msg:
+	vchi_held_msg_release(&rmsg_handle);
+
+	return ret;
+}
+
+static int port_parameter_set(struct vchiq_mmal_instance *instance,
+			      struct vchiq_mmal_port *port,
+			      u32 parameter_id, void *value, u32 value_size)
+{
+	int ret;
+	struct mmal_msg m;
+	struct mmal_msg *rmsg;
+	VCHI_HELD_MSG_T rmsg_handle;
+
+	m.h.type = MMAL_MSG_TYPE_PORT_PARAMETER_SET;
+
+	m.u.port_parameter_set.component_handle = port->component->handle;
+	m.u.port_parameter_set.port_handle = port->handle;
+	m.u.port_parameter_set.id = parameter_id;
+	m.u.port_parameter_set.size = (2 * sizeof(u32)) + value_size;
+	memcpy(&m.u.port_parameter_set.value, value, value_size);
+
+	ret = send_synchronous_mmal_msg(instance, &m,
+					(4 * sizeof(u32)) + value_size,
+					&rmsg, &rmsg_handle);
+	if (ret)
+		return ret;
+
+	if (rmsg->h.type != MMAL_MSG_TYPE_PORT_PARAMETER_SET) {
+		/* got an unexpected message type in reply */
+		ret = -EINVAL;
+		goto release_msg;
+	}
+
+	ret = -rmsg->u.port_parameter_set_reply.status;
+
+	pr_debug("%s:result:%d component:0x%x port:%d parameter:%d\n",
+		 __func__,
+		 ret, port->component->handle, port->handle, parameter_id);
+
+release_msg:
+	vchi_held_msg_release(&rmsg_handle);
+
+	return ret;
+}
+
+static int port_parameter_get(struct vchiq_mmal_instance *instance,
+			      struct vchiq_mmal_port *port,
+			      u32 parameter_id, void *value, u32 *value_size)
+{
+	int ret;
+	struct mmal_msg m;
+	struct mmal_msg *rmsg;
+	VCHI_HELD_MSG_T rmsg_handle;
+
+	m.h.type = MMAL_MSG_TYPE_PORT_PARAMETER_GET;
+
+	m.u.port_parameter_get.component_handle = port->component->handle;
+	m.u.port_parameter_get.port_handle = port->handle;
+	m.u.port_parameter_get.id = parameter_id;
+	m.u.port_parameter_get.size = (2 * sizeof(u32)) + *value_size;
+
+	ret = send_synchronous_mmal_msg(instance, &m,
+					sizeof(struct
+					       mmal_msg_port_parameter_get),
+					&rmsg, &rmsg_handle);
+	if (ret)
+		return ret;
+
+	if (rmsg->h.type != MMAL_MSG_TYPE_PORT_PARAMETER_GET) {
+		/* got an unexpected message type in reply */
+		pr_err("Incorrect reply type %d\n", rmsg->h.type);
+		ret = -EINVAL;
+		goto release_msg;
+	}
+
+	ret = -rmsg->u.port_parameter_get_reply.status;
+	if (ret) {
+		/* Copy only as much as we have space for
+		 * but report true size of parameter
+		 */
+		memcpy(value, &rmsg->u.port_parameter_get_reply.value,
+		       *value_size);
+		*value_size = rmsg->u.port_parameter_get_reply.size;
+	} else
+		memcpy(value, &rmsg->u.port_parameter_get_reply.value,
+		       rmsg->u.port_parameter_get_reply.size);
+
+	pr_debug("%s:result:%d component:0x%x port:%d parameter:%d\n", __func__,
+	        ret, port->component->handle, port->handle, parameter_id);
+
+release_msg:
+	vchi_held_msg_release(&rmsg_handle);
+
+	return ret;
+}
+
+/* disables a port and drains buffers from it */
+static int port_disable(struct vchiq_mmal_instance *instance,
+			struct vchiq_mmal_port *port)
+{
+	int ret;
+	struct list_head *q, *buf_head;
+	unsigned long flags = 0;
+
+	if (!port->enabled)
+		return 0;
+
+	port->enabled = false;
+
+	ret = port_action_port(instance, port,
+			       MMAL_MSG_PORT_ACTION_TYPE_DISABLE);
+	if (ret == 0) {
+
+		/* drain all queued buffers on port */
+		spin_lock_irqsave(&port->slock, flags);
+
+		list_for_each_safe(buf_head, q, &port->buffers) {
+			struct mmal_buffer *mmalbuf;
+			mmalbuf = list_entry(buf_head, struct mmal_buffer,
+					     list);
+			list_del(buf_head);
+			if (port->buffer_cb)
+				port->buffer_cb(instance,
+						port, 0, mmalbuf, 0, 0,
+						MMAL_TIME_UNKNOWN,
+						MMAL_TIME_UNKNOWN);
+		}
+
+		spin_unlock_irqrestore(&port->slock, flags);
+
+		ret = port_info_get(instance, port);
+	}
+
+	return ret;
+}
+
+/* enable a port */
+static int port_enable(struct vchiq_mmal_instance *instance,
+		       struct vchiq_mmal_port *port)
+{
+	unsigned int hdr_count;
+	struct list_head *buf_head;
+	int ret;
+
+	if (port->enabled)
+		return 0;
+
+	/* ensure there are enough buffers queued to cover the buffer headers */
+	if (port->buffer_cb != NULL) {
+		hdr_count = 0;
+		list_for_each(buf_head, &port->buffers) {
+			hdr_count++;
+		}
+		if (hdr_count < port->current_buffer.num)
+			return -ENOSPC;
+	}
+
+	ret = port_action_port(instance, port,
+			       MMAL_MSG_PORT_ACTION_TYPE_ENABLE);
+	if (ret)
+		goto done;
+
+	port->enabled = true;
+
+	if (port->buffer_cb) {
+		/* send buffer headers to videocore */
+		hdr_count = 1;
+		list_for_each(buf_head, &port->buffers) {
+			struct mmal_buffer *mmalbuf;
+			mmalbuf = list_entry(buf_head, struct mmal_buffer,
+					     list);
+			ret = buffer_from_host(instance, port, mmalbuf);
+			if (ret)
+				goto done;
+
+			hdr_count++;
+			if (hdr_count > port->current_buffer.num)
+				break;
+		}
+	}
+
+	ret = port_info_get(instance, port);
+
+done:
+	return ret;
+}
+
+/* ------------------------------------------------------------------
+ * Exported API
+ *------------------------------------------------------------------*/
+
+int vchiq_mmal_port_set_format(struct vchiq_mmal_instance *instance,
+			       struct vchiq_mmal_port *port)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&instance->vchiq_mutex))
+		return -EINTR;
+
+	ret = port_info_set(instance, port);
+	if (ret)
+		goto release_unlock;
+
+	/* read what has actually been set */
+	ret = port_info_get(instance, port);
+
+release_unlock:
+	mutex_unlock(&instance->vchiq_mutex);
+
+	return ret;
+
+}
+
+int vchiq_mmal_port_parameter_set(struct vchiq_mmal_instance *instance,
+				  struct vchiq_mmal_port *port,
+				  u32 parameter, void *value, u32 value_size)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&instance->vchiq_mutex))
+		return -EINTR;
+
+	ret = port_parameter_set(instance, port, parameter, value, value_size);
+
+	mutex_unlock(&instance->vchiq_mutex);
+
+	return ret;
+}
+
+int vchiq_mmal_port_parameter_get(struct vchiq_mmal_instance *instance,
+				  struct vchiq_mmal_port *port,
+				  u32 parameter, void *value, u32 *value_size)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&instance->vchiq_mutex))
+		return -EINTR;
+
+	ret = port_parameter_get(instance, port, parameter, value, value_size);
+
+	mutex_unlock(&instance->vchiq_mutex);
+
+	return ret;
+}
+
+/* enable a port
+ *
+ * enables a port and queues buffers for satisfying callbacks if we
+ * provide a callback handler
+ */
+int vchiq_mmal_port_enable(struct vchiq_mmal_instance *instance,
+			   struct vchiq_mmal_port *port,
+			   vchiq_mmal_buffer_cb buffer_cb)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&instance->vchiq_mutex))
+		return -EINTR;
+
+	/* already enabled - noop */
+	if (port->enabled) {
+		ret = 0;
+		goto unlock;
+	}
+
+	port->buffer_cb = buffer_cb;
+
+	ret = port_enable(instance, port);
+
+unlock:
+	mutex_unlock(&instance->vchiq_mutex);
+
+	return ret;
+}
+
+int vchiq_mmal_port_disable(struct vchiq_mmal_instance *instance,
+			    struct vchiq_mmal_port *port)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&instance->vchiq_mutex))
+		return -EINTR;
+
+	if (!port->enabled) {
+		mutex_unlock(&instance->vchiq_mutex);
+		return 0;
+	}
+
+	ret = port_disable(instance, port);
+
+	mutex_unlock(&instance->vchiq_mutex);
+
+	return ret;
+}
+
+/* ports will be connected in a tunneled manner so data buffers
+ * are not handled by client.
+ */
+int vchiq_mmal_port_connect_tunnel(struct vchiq_mmal_instance *instance,
+				   struct vchiq_mmal_port *src,
+				   struct vchiq_mmal_port *dst)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&instance->vchiq_mutex))
+		return -EINTR;
+
+	/* disconnect ports if connected */
+	if (src->connected != NULL) {
+		ret = port_disable(instance, src);
+		if (ret) {
+			pr_err("failed disabling src port(%d)\n", ret);
+			goto release_unlock;
+		}
+
+		/* do not need to disable the destination port as they
+		 * are connected and it is done automatically
+		 */
+
+		ret = port_action_handle(instance, src,
+					 MMAL_MSG_PORT_ACTION_TYPE_DISCONNECT,
+					 src->connected->component->handle,
+					 src->connected->handle);
+		if (ret < 0) {
+			pr_err("failed disconnecting src port\n");
+			goto release_unlock;
+		}
+		src->connected->enabled = false;
+		src->connected = NULL;
+	}
+
+	if (dst == NULL) {
+		/* do not make new connection */
+		ret = 0;
+		pr_debug("not making new connection\n");
+		goto release_unlock;
+	}
+
+	/* copy src port format to dst */
+	dst->format.encoding = src->format.encoding;
+	dst->es.video.width = src->es.video.width;
+	dst->es.video.height = src->es.video.height;
+	dst->es.video.crop.x = src->es.video.crop.x;
+	dst->es.video.crop.y = src->es.video.crop.y;
+	dst->es.video.crop.width = src->es.video.crop.width;
+	dst->es.video.crop.height = src->es.video.crop.height;
+	dst->es.video.frame_rate.num = src->es.video.frame_rate.num;
+	dst->es.video.frame_rate.den = src->es.video.frame_rate.den;
+
+	/* set new format */
+	ret = port_info_set(instance, dst);
+	if (ret) {
+		pr_debug("setting port info failed\n");
+		goto release_unlock;
+	}
+
+	/* read what has actually been set */
+	ret = port_info_get(instance, dst);
+	if (ret) {
+		pr_debug("read back port info failed\n");
+		goto release_unlock;
+	}
+
+	/* connect two ports together */
+	ret = port_action_handle(instance, src,
+				 MMAL_MSG_PORT_ACTION_TYPE_CONNECT,
+				 dst->component->handle, dst->handle);
+	if (ret < 0) {
+		pr_debug("connecting port %d:%d to %d:%d failed\n",
+			 src->component->handle, src->handle,
+			 dst->component->handle, dst->handle);
+		goto release_unlock;
+	}
+	src->connected = dst;
+
+release_unlock:
+
+	mutex_unlock(&instance->vchiq_mutex);
+
+	return ret;
+}
+
+int vchiq_mmal_submit_buffer(struct vchiq_mmal_instance *instance,
+			     struct vchiq_mmal_port *port,
+			     struct mmal_buffer *buffer)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&port->slock, flags);
+	list_add_tail(&buffer->list, &port->buffers);
+	spin_unlock_irqrestore(&port->slock, flags);
+
+	/* the port previously underflowed because it was missing a
+	 * mmal_buffer which has just been added, submit that buffer
+	 * to the mmal service.
+	 */
+	if (port->buffer_underflow) {
+		port_buffer_from_host(instance, port);
+		port->buffer_underflow--;
+	}
+
+	return 0;
+}
+
+/* Initialise a mmal component and its ports
+ *
+ */
+int vchiq_mmal_component_init(struct vchiq_mmal_instance *instance,
+			      const char *name,
+			      struct vchiq_mmal_component **component_out)
+{
+	int ret;
+	int idx;		/* port index */
+	struct vchiq_mmal_component *component;
+
+	if (mutex_lock_interruptible(&instance->vchiq_mutex))
+		return -EINTR;
+
+	if (instance->component_idx == VCHIQ_MMAL_MAX_COMPONENTS) {
+		ret = -EINVAL;	/* todo is this correct error? */
+		goto unlock;
+	}
+
+	component = &instance->component[instance->component_idx];
+
+	ret = create_component(instance, component, name);
+	if (ret < 0)
+		goto unlock;
+
+	/* ports info needs gathering */
+	component->control.type = MMAL_PORT_TYPE_CONTROL;
+	component->control.index = 0;
+	component->control.component = component;
+	spin_lock_init(&component->control.slock);
+	INIT_LIST_HEAD(&component->control.buffers);
+	ret = port_info_get(instance, &component->control);
+	if (ret < 0)
+		goto release_component;
+
+	for (idx = 0; idx < component->inputs; idx++) {
+		component->input[idx].type = MMAL_PORT_TYPE_INPUT;
+		component->input[idx].index = idx;
+		component->input[idx].component = component;
+		spin_lock_init(&component->input[idx].slock);
+		INIT_LIST_HEAD(&component->input[idx].buffers);
+		ret = port_info_get(instance, &component->input[idx]);
+		if (ret < 0)
+			goto release_component;
+	}
+
+	for (idx = 0; idx < component->outputs; idx++) {
+		component->output[idx].type = MMAL_PORT_TYPE_OUTPUT;
+		component->output[idx].index = idx;
+		component->output[idx].component = component;
+		spin_lock_init(&component->output[idx].slock);
+		INIT_LIST_HEAD(&component->output[idx].buffers);
+		ret = port_info_get(instance, &component->output[idx]);
+		if (ret < 0)
+			goto release_component;
+	}
+
+	for (idx = 0; idx < component->clocks; idx++) {
+		component->clock[idx].type = MMAL_PORT_TYPE_CLOCK;
+		component->clock[idx].index = idx;
+		component->clock[idx].component = component;
+		spin_lock_init(&component->clock[idx].slock);
+		INIT_LIST_HEAD(&component->clock[idx].buffers);
+		ret = port_info_get(instance, &component->clock[idx]);
+		if (ret < 0)
+			goto release_component;
+	}
+
+	instance->component_idx++;
+
+	*component_out = component;
+
+	mutex_unlock(&instance->vchiq_mutex);
+
+	return 0;
+
+release_component:
+	destroy_component(instance, component);
+unlock:
+	mutex_unlock(&instance->vchiq_mutex);
+
+	return ret;
+}
+
+/*
+ * cause a mmal component to be destroyed
+ */
+int vchiq_mmal_component_finalise(struct vchiq_mmal_instance *instance,
+				  struct vchiq_mmal_component *component)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&instance->vchiq_mutex))
+		return -EINTR;
+
+	if (component->enabled)
+		ret = disable_component(instance, component);
+
+	ret = destroy_component(instance, component);
+
+	mutex_unlock(&instance->vchiq_mutex);
+
+	return ret;
+}
+
+/*
+ * cause a mmal component to be enabled
+ */
+int vchiq_mmal_component_enable(struct vchiq_mmal_instance *instance,
+				struct vchiq_mmal_component *component)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&instance->vchiq_mutex))
+		return -EINTR;
+
+	if (component->enabled) {
+		mutex_unlock(&instance->vchiq_mutex);
+		return 0;
+	}
+
+	ret = enable_component(instance, component);
+	if (ret == 0)
+		component->enabled = true;
+
+	mutex_unlock(&instance->vchiq_mutex);
+
+	return ret;
+}
+
+/*
+ * cause a mmal component to be enabled
+ */
+int vchiq_mmal_component_disable(struct vchiq_mmal_instance *instance,
+				 struct vchiq_mmal_component *component)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&instance->vchiq_mutex))
+		return -EINTR;
+
+	if (!component->enabled) {
+		mutex_unlock(&instance->vchiq_mutex);
+		return 0;
+	}
+
+	ret = disable_component(instance, component);
+	if (ret == 0)
+		component->enabled = false;
+
+	mutex_unlock(&instance->vchiq_mutex);
+
+	return ret;
+}
+
+int vchiq_mmal_version(struct vchiq_mmal_instance *instance,
+		       u32 *major_out, u32 *minor_out)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&instance->vchiq_mutex))
+		return -EINTR;
+
+	ret = get_version(instance, major_out, minor_out);
+
+	mutex_unlock(&instance->vchiq_mutex);
+
+	return ret;
+}
+
+int vchiq_mmal_finalise(struct vchiq_mmal_instance *instance)
+{
+	int status = 0;
+
+	if (instance == NULL)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&instance->vchiq_mutex))
+		return -EINTR;
+
+	vchi_service_use(instance->handle);
+
+	status = vchi_service_close(instance->handle);
+	if (status != 0)
+		pr_err("mmal-vchiq: VCHIQ close failed");
+
+	mutex_unlock(&instance->vchiq_mutex);
+
+	vfree(instance->bulk_scratch);
+
+	kfree(instance);
+
+	return status;
+}
+
+int vchiq_mmal_init(struct vchiq_mmal_instance **out_instance)
+{
+	int status;
+	struct vchiq_mmal_instance *instance;
+	static VCHI_CONNECTION_T *vchi_connection;
+	static VCHI_INSTANCE_T vchi_instance;
+	SERVICE_CREATION_T params = {
+		VCHI_VERSION_EX(VC_MMAL_VER, VC_MMAL_MIN_VER),
+		VC_MMAL_SERVER_NAME,
+		vchi_connection,
+		0,		/* rx fifo size (unused) */
+		0,		/* tx fifo size (unused) */
+		service_callback,
+		NULL,		/* service callback parameter */
+		1,		/* unaligned bulk receives */
+		1,		/* unaligned bulk transmits */
+		0		/* want crc check on bulk transfers */
+	};
+
+	/* compile time checks to ensure structure size as they are
+	 * directly (de)serialised from memory.
+	 */
+
+	/* ensure the header structure has packed to the correct size */
+	BUILD_BUG_ON(sizeof(struct mmal_msg_header) != 24);
+
+	/* ensure message structure does not exceed maximum length */
+	BUILD_BUG_ON(sizeof(struct mmal_msg) > MMAL_MSG_MAX_SIZE);
+
+	/* mmal port struct is correct size */
+	BUILD_BUG_ON(sizeof(struct mmal_port) != 64);
+
+	/* create a vchi instance */
+	status = vchi_initialise(&vchi_instance);
+	if (status) {
+		pr_err("Failed to initialise VCHI instance (status=%d)\n",
+		       status);
+		return -EIO;
+	}
+
+	status = vchi_connect(NULL, 0, vchi_instance);
+	if (status) {
+		pr_err("Failed to connect VCHI instance (status=%d)\n", status);
+		return -EIO;
+	}
+
+	instance = kmalloc(sizeof(*instance), GFP_KERNEL);
+	memset(instance, 0, sizeof(*instance));
+
+	mutex_init(&instance->vchiq_mutex);
+	mutex_init(&instance->bulk_mutex);
+
+	instance->bulk_scratch = vmalloc(PAGE_SIZE);
+
+	params.callback_param = instance;
+
+	status = vchi_service_open(vchi_instance, &params, &instance->handle);
+	if (status) {
+		pr_err("Failed to open VCHI service connection (status=%d)\n",
+		       status);
+		goto err_close_services;
+	}
+
+	vchi_service_release(instance->handle);
+
+	*out_instance = instance;
+
+	return 0;
+
+err_close_services:
+
+	vchi_service_close(instance->handle);
+	vfree(instance->bulk_scratch);
+	kfree(instance);
+	return -ENODEV;
+}
diff --git a/drivers/staging/media/platform/bcm2835/mmal-vchiq.h b/drivers/staging/media/platform/bcm2835/mmal-vchiq.h
new file mode 100644
index 000000000000..9d1d11e4a53e
--- /dev/null
+++ b/drivers/staging/media/platform/bcm2835/mmal-vchiq.h
@@ -0,0 +1,178 @@
+/*
+ * Broadcom BM2835 V4L2 driver
+ *
+ * Copyright © 2013 Raspberry Pi (Trading) Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
+ *          Dave Stevenson <dsteve@broadcom.com>
+ *          Simon Mellor <simellor@broadcom.com>
+ *          Luke Diamand <luked@broadcom.com>
+ *
+ * MMAL interface to VCHIQ message passing
+ */
+
+#ifndef MMAL_VCHIQ_H
+#define MMAL_VCHIQ_H
+
+#include "mmal-msg-format.h"
+
+#define MAX_PORT_COUNT 4
+
+/* Maximum size of the format extradata. */
+#define MMAL_FORMAT_EXTRADATA_MAX_SIZE 128
+
+struct vchiq_mmal_instance;
+
+enum vchiq_mmal_es_type {
+	MMAL_ES_TYPE_UNKNOWN,     /**< Unknown elementary stream type */
+	MMAL_ES_TYPE_CONTROL,     /**< Elementary stream of control commands */
+	MMAL_ES_TYPE_AUDIO,       /**< Audio elementary stream */
+	MMAL_ES_TYPE_VIDEO,       /**< Video elementary stream */
+	MMAL_ES_TYPE_SUBPICTURE   /**< Sub-picture elementary stream */
+};
+
+/* rectangle, used lots so it gets its own struct */
+struct vchiq_mmal_rect {
+	s32 x;
+	s32 y;
+	s32 width;
+	s32 height;
+};
+
+struct vchiq_mmal_port_buffer {
+	unsigned int num; /* number of buffers */
+	u32 size; /* size of buffers */
+	u32 alignment; /* alignment of buffers */
+};
+
+struct vchiq_mmal_port;
+
+typedef void (*vchiq_mmal_buffer_cb)(
+		struct vchiq_mmal_instance  *instance,
+		struct vchiq_mmal_port *port,
+		int status, struct mmal_buffer *buffer,
+		unsigned long length, u32 mmal_flags, s64 dts, s64 pts);
+
+struct vchiq_mmal_port {
+	bool enabled;
+	u32 handle;
+	u32 type; /* port type, cached to use on port info set */
+	u32 index; /* port index, cached to use on port info set */
+
+	/* component port belongs to, allows simple deref */
+	struct vchiq_mmal_component *component;
+
+	struct vchiq_mmal_port *connected; /* port conencted to */
+
+	/* buffer info */
+	struct vchiq_mmal_port_buffer minimum_buffer;
+	struct vchiq_mmal_port_buffer recommended_buffer;
+	struct vchiq_mmal_port_buffer current_buffer;
+
+	/* stream format */
+	struct mmal_es_format format;
+	/* elementry stream format */
+	union mmal_es_specific_format es;
+
+	/* data buffers to fill */
+	struct list_head buffers;
+	/* lock to serialise adding and removing buffers from list */
+	spinlock_t slock;
+	/* count of how many buffer header refils have failed because
+	 * there was no buffer to satisfy them
+	 */
+	int buffer_underflow;
+	/* callback on buffer completion */
+	vchiq_mmal_buffer_cb buffer_cb;
+	/* callback context */
+	void *cb_ctx;
+};
+
+struct vchiq_mmal_component {
+	bool enabled;
+	u32 handle;  /* VideoCore handle for component */
+	u32 inputs;  /* Number of input ports */
+	u32 outputs; /* Number of output ports */
+	u32 clocks;  /* Number of clock ports */
+	struct vchiq_mmal_port control; /* control port */
+	struct vchiq_mmal_port input[MAX_PORT_COUNT]; /* input ports */
+	struct vchiq_mmal_port output[MAX_PORT_COUNT]; /* output ports */
+	struct vchiq_mmal_port clock[MAX_PORT_COUNT]; /* clock ports */
+};
+
+
+int vchiq_mmal_init(struct vchiq_mmal_instance **out_instance);
+int vchiq_mmal_finalise(struct vchiq_mmal_instance *instance);
+
+/* Initialise a mmal component and its ports
+*
+*/
+int vchiq_mmal_component_init(
+		struct vchiq_mmal_instance *instance,
+		const char *name,
+		struct vchiq_mmal_component **component_out);
+
+int vchiq_mmal_component_finalise(
+		struct vchiq_mmal_instance *instance,
+		struct vchiq_mmal_component *component);
+
+int vchiq_mmal_component_enable(
+		struct vchiq_mmal_instance *instance,
+		struct vchiq_mmal_component *component);
+
+int vchiq_mmal_component_disable(
+		struct vchiq_mmal_instance *instance,
+		struct vchiq_mmal_component *component);
+
+
+
+/* enable a mmal port
+ *
+ * enables a port and if a buffer callback provided enque buffer
+ * headers as apropriate for the port.
+ */
+int vchiq_mmal_port_enable(
+		struct vchiq_mmal_instance *instance,
+		struct vchiq_mmal_port *port,
+		vchiq_mmal_buffer_cb buffer_cb);
+
+/* disable a port
+ *
+ * disable a port will dequeue any pending buffers
+ */
+int vchiq_mmal_port_disable(struct vchiq_mmal_instance *instance,
+			   struct vchiq_mmal_port *port);
+
+
+int vchiq_mmal_port_parameter_set(struct vchiq_mmal_instance *instance,
+				  struct vchiq_mmal_port *port,
+				  u32 parameter,
+				  void *value,
+				  u32 value_size);
+
+int vchiq_mmal_port_parameter_get(struct vchiq_mmal_instance *instance,
+				  struct vchiq_mmal_port *port,
+				  u32 parameter,
+				  void *value,
+				  u32 *value_size);
+
+int vchiq_mmal_port_set_format(struct vchiq_mmal_instance *instance,
+			       struct vchiq_mmal_port *port);
+
+int vchiq_mmal_port_connect_tunnel(struct vchiq_mmal_instance *instance,
+			    struct vchiq_mmal_port *src,
+			    struct vchiq_mmal_port *dst);
+
+int vchiq_mmal_version(struct vchiq_mmal_instance *instance,
+		       u32 *major_out,
+		       u32 *minor_out);
+
+int vchiq_mmal_submit_buffer(struct vchiq_mmal_instance *instance,
+			     struct vchiq_mmal_port *port,
+			     struct mmal_buffer *buf);
+
+#endif /* MMAL_VCHIQ_H */
-- 
2.11.0

