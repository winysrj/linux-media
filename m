Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34496 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752713AbeADWvl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 17:51:41 -0500
Received: by mail-wm0-f65.google.com with SMTP id y82so4024693wmg.1
        for <linux-media@vger.kernel.org>; Thu, 04 Jan 2018 14:51:40 -0800 (PST)
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH] media: uvcvideo: support multiple frame descriptors with the same dimensions
Date: Thu,  4 Jan 2018 23:51:29 +0100
Message-Id: <20180104225129.9488-1-philipp.zabel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Microsoft HoloLens Sensors device has two separate frame descriptors
with the same dimensions, each with a single different frame interval:

      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                           481
        dwMinBitRate                147763200
        dwMaxBitRate                147763200
        dwMaxVideoFrameBufferSize      615680
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                           481
        dwMinBitRate                443289600
        dwMaxBitRate                443289600
        dwMaxVideoFrameBufferSize      615680
        dwDefaultFrameInterval         111111
        bFrameIntervalType                  1
        dwFrameInterval( 0)            111111

Skip duplicate dimensions in enum_framesizes, let enum_frameintervals list
the intervals from both frame descriptors. Change set_streamparm to switch
to the correct frame index when changing the interval. This enables 90 fps
capture on a Lenovo Explorer Windows Mixed Reality headset.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
Changes since v1 [1]:
- Break out of frame size loop if maxd == 0 in uvc_v4l2_set_streamparm.
- Moved d and tmp variables in uvc_v4l2_set_streamparm into loop,
  renamed tmp variable to tmp_ival.
- Changed i loop variables to unsigned int.
- Changed index variables to unsigned int.
- One line per variable declaration.

[1] https://patchwork.linuxtv.org/patch/46109/
---
 drivers/media/usb/uvc/uvc_v4l2.c | 71 +++++++++++++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index f5ab8164bca5..d9ee400bf47c 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -373,7 +373,10 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 {
 	struct uvc_streaming_control probe;
 	struct v4l2_fract timeperframe;
-	uint32_t interval;
+	struct uvc_format *format;
+	struct uvc_frame *frame;
+	__u32 interval, maxd;
+	unsigned int i;
 	int ret;
 
 	if (parm->type != stream->type)
@@ -396,9 +399,33 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 		return -EBUSY;
 	}
 
+	format = stream->cur_format;
+	frame = stream->cur_frame;
 	probe = stream->ctrl;
-	probe.dwFrameInterval =
-		uvc_try_frame_interval(stream->cur_frame, interval);
+	probe.dwFrameInterval = uvc_try_frame_interval(frame, interval);
+	maxd = abs((__s32)probe.dwFrameInterval - interval);
+
+	/* Try frames with matching size to find the best frame interval. */
+	for (i = 0; i < format->nframes && maxd != 0; i++) {
+		__u32 d, tmp_ival;
+
+		if (&format->frame[i] == stream->cur_frame)
+			continue;
+
+		if (format->frame[i].wWidth != stream->cur_frame->wWidth ||
+		    format->frame[i].wHeight != stream->cur_frame->wHeight)
+			continue;
+
+		tmp_ival = uvc_try_frame_interval(&format->frame[i], interval);
+		d = abs((__s32)tmp_ival - interval);
+		if (d >= maxd)
+			continue;
+
+		frame = &format->frame[i];
+		probe.bFrameIndex = frame->bFrameIndex;
+		probe.dwFrameInterval = tmp_ival;
+		maxd = d;
+	}
 
 	/* Probe the device with the new settings. */
 	ret = uvc_probe_video(stream, &probe);
@@ -408,6 +435,7 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 	}
 
 	stream->ctrl = probe;
+	stream->cur_frame = frame;
 	mutex_unlock(&stream->mutex);
 
 	/* Return the actual frame period. */
@@ -1209,7 +1237,8 @@ static int uvc_ioctl_enum_framesizes(struct file *file, void *fh,
 	struct uvc_streaming *stream = handle->stream;
 	struct uvc_format *format = NULL;
 	struct uvc_frame *frame;
-	int i;
+	unsigned int index;
+	unsigned int i;
 
 	/* Look for the given pixel format */
 	for (i = 0; i < stream->nformats; i++) {
@@ -1221,10 +1250,20 @@ static int uvc_ioctl_enum_framesizes(struct file *file, void *fh,
 	if (format == NULL)
 		return -EINVAL;
 
-	if (fsize->index >= format->nframes)
+	/* Skip duplicate frame sizes */
+	for (i = 0, index = 0; i < format->nframes; i++) {
+		if (i && frame->wWidth == format->frame[i].wWidth &&
+		    frame->wHeight == format->frame[i].wHeight)
+			continue;
+		frame = &format->frame[i];
+		if (index == fsize->index)
+			break;
+		index++;
+	}
+
+	if (i == format->nframes)
 		return -EINVAL;
 
-	frame = &format->frame[fsize->index];
 	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
 	fsize->discrete.width = frame->wWidth;
 	fsize->discrete.height = frame->wHeight;
@@ -1238,7 +1277,9 @@ static int uvc_ioctl_enum_frameintervals(struct file *file, void *fh,
 	struct uvc_streaming *stream = handle->stream;
 	struct uvc_format *format = NULL;
 	struct uvc_frame *frame = NULL;
-	int i;
+	unsigned int nintervals;
+	unsigned int index;
+	unsigned int i;
 
 	/* Look for the given pixel format and frame size */
 	for (i = 0; i < stream->nformats; i++) {
@@ -1250,30 +1291,28 @@ static int uvc_ioctl_enum_frameintervals(struct file *file, void *fh,
 	if (format == NULL)
 		return -EINVAL;
 
+	index = fival->index;
 	for (i = 0; i < format->nframes; i++) {
 		if (format->frame[i].wWidth == fival->width &&
 		    format->frame[i].wHeight == fival->height) {
 			frame = &format->frame[i];
-			break;
+			nintervals = frame->bFrameIntervalType ?: 1;
+			if (index < nintervals)
+				break;
+			index -= nintervals;
 		}
 	}
-	if (frame == NULL)
+	if (i == format->nframes)
 		return -EINVAL;
 
 	if (frame->bFrameIntervalType) {
-		if (fival->index >= frame->bFrameIntervalType)
-			return -EINVAL;
-
 		fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
 		fival->discrete.numerator =
-			frame->dwFrameInterval[fival->index];
+			frame->dwFrameInterval[index];
 		fival->discrete.denominator = 10000000;
 		uvc_simplify_fraction(&fival->discrete.numerator,
 			&fival->discrete.denominator, 8, 333);
 	} else {
-		if (fival->index)
-			return -EINVAL;
-
 		fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
 		fival->stepwise.min.numerator = frame->dwFrameInterval[0];
 		fival->stepwise.min.denominator = 10000000;
-- 
2.15.1
