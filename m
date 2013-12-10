Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:12323 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3LJLky (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 06:40:54 -0500
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 2/4] remove set_format from uvc_events_process_data
Date: Tue, 10 Dec 2013 12:40:35 +0100
Message-id: <1386675637-18243-3-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1386675637-18243-1-git-send-email-r.baldyga@samsung.com>
References: <1386675637-18243-1-git-send-email-r.baldyga@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Format is based on application parameters, and it stay unchanged, so we
don't need to do uvc_video_set_format() and v4l2_set_format()  in
uvc_events_process_data() function. In addition it allow us to do
VIDIOC_REQBUFS ioctl once at the beginning, and skip it in STREAMON and
STREAMOFF events.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 uvc-gadget.c |   38 --------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/uvc-gadget.c b/uvc-gadget.c
index 5512e2c..c964f37 100644
--- a/uvc-gadget.c
+++ b/uvc-gadget.c
@@ -1949,44 +1949,6 @@ uvc_events_process_data(struct uvc_device *dev, struct uvc_request_data *data)
 		dev->width = frame->width;
 		dev->height = frame->height;
 
-		/*
-		 * Try to set the default format at the V4L2 video capture
-		 * device as requested by the user.
-		 */
-		CLEAR(fmt);
-
-		fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		fmt.fmt.pix.field = V4L2_FIELD_ANY;
-		fmt.fmt.pix.width = frame->width;
-		fmt.fmt.pix.height = frame->height;
-		fmt.fmt.pix.pixelformat = format->fcc;
-
-		switch (format->fcc) {
-		case V4L2_PIX_FMT_YUYV:
-			fmt.fmt.pix.sizeimage =
-				(fmt.fmt.pix.width * fmt.fmt.pix.height * 2);
-			break;
-		case V4L2_PIX_FMT_MJPEG:
-			fmt.fmt.pix.sizeimage = dev->imgsize;
-			break;
-		}
-
-		/*
-		 * As per the new commit command received from the UVC host
-		 * change the current format selection at both UVC and V4L2
-		 * sides.
-		 */
-		ret = uvc_video_set_format(dev);
-		if (ret < 0)
-			goto err;
-
-		if (!dev->run_standalone) {
-			/* UVC - V4L2 integrated path. */
-			ret = v4l2_set_format(dev->vdev, &fmt);
-			if (ret < 0)
-				goto err;
-		}
-
 		if (dev->bulk) {
 			ret = uvc_handle_streamon_event(dev);
 			if (ret < 0)
-- 
1.7.9.5

