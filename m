Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35492 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaBCLEn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Feb 2014 06:04:43 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] uvcvideo: Check format and frame size in VIDIOC_CREATE_BUFS
Date: Mon,  3 Feb 2014 12:04:37 +0100
Message-Id: <1391425477-3889-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Verify that create_bufs requests buffers with the currently selected
format and frame size, return an error otherwise.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 2cea127..fae61a2 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -1003,10 +1003,24 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_CREATE_BUFS:
 	{
 		struct v4l2_create_buffers *cb = arg;
+		struct v4l2_pix_format *pix;
+		struct uvc_format *format;
+		struct uvc_frame *frame;
 
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
+		format = stream->cur_format;
+		frame = stream->cur_frame;
+		pix = &cb->format.fmt.pix;
+
+		if (pix->pixelformat != format->fcc ||
+		    pix->width != frame->wWidth ||
+		    pix->height != frame->wHeight ||
+		    pix->bytesperline != format->bpp * frame->wWidth / 8 ||
+		    pix->sizeimage != stream->ctrl.dwMaxVideoFrameSize)
+			return -EINVAL;
+
 		return uvc_create_buffers(&stream->queue, cb);
 	}
 
-- 
1.8.5.3

