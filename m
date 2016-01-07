Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58049 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbcAGUoA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jan 2016 15:44:00 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: [PATCH] uvc: Fix bytesperline calculation for planar YUV
Date: Thu,  7 Jan 2016 15:43:48 -0500
Message-Id: <1452199428-3513-1-git-send-email-nicolas.dufresne@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The formula used to calculate bytesperline only works for packed format.
So far, all planar format we support have their bytesperline equal to
the image width (stride of the Y plane or a line of Y for M420).

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index d7723ce..ceb1d1b 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -142,6 +142,20 @@ static __u32 uvc_try_frame_interval(struct uvc_frame *frame, __u32 interval)
 	return interval;
 }
 
+static __u32 uvc_v4l2_get_bytesperline(struct uvc_format *format,
+	struct uvc_frame *frame)
+{
+	switch (format->fcc) {
+	case V4L2_PIX_FMT_NV12:
+	case V4L2_PIX_FMT_YVU420:
+	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_M420:
+		return frame->wWidth;
+	default:
+		return format->bpp * frame->wWidth / 8;
+	}
+}
+
 static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 	struct v4l2_format *fmt, struct uvc_streaming_control *probe,
 	struct uvc_format **uvc_format, struct uvc_frame **uvc_frame)
@@ -245,7 +259,7 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 	fmt->fmt.pix.width = frame->wWidth;
 	fmt->fmt.pix.height = frame->wHeight;
 	fmt->fmt.pix.field = V4L2_FIELD_NONE;
-	fmt->fmt.pix.bytesperline = format->bpp * frame->wWidth / 8;
+	fmt->fmt.pix.bytesperline = uvc_v4l2_get_bytesperline(format, frame);
 	fmt->fmt.pix.sizeimage = probe->dwMaxVideoFrameSize;
 	fmt->fmt.pix.colorspace = format->colorspace;
 	fmt->fmt.pix.priv = 0;
@@ -282,7 +296,7 @@ static int uvc_v4l2_get_format(struct uvc_streaming *stream,
 	fmt->fmt.pix.width = frame->wWidth;
 	fmt->fmt.pix.height = frame->wHeight;
 	fmt->fmt.pix.field = V4L2_FIELD_NONE;
-	fmt->fmt.pix.bytesperline = format->bpp * frame->wWidth / 8;
+	fmt->fmt.pix.bytesperline = uvc_v4l2_get_bytesperline(format, frame);
 	fmt->fmt.pix.sizeimage = stream->ctrl.dwMaxVideoFrameSize;
 	fmt->fmt.pix.colorspace = format->colorspace;
 	fmt->fmt.pix.priv = 0;
-- 
2.5.0

