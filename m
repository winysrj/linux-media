Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40802 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbdLDXXd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 18:23:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/2] uvcvideo: Report V4L2 device caps through the video_device structure
Date: Tue,  5 Dec 2017 01:23:33 +0200
Message-Id: <20171204232333.30084-3-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20171204232333.30084-1-laurent.pinchart@ideasonboard.com>
References: <20171204232333.30084-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 core populates the struct v4l2_capability device_caps field
from the same field in video_device. There's no need to handle that
manually in the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 11 +++++++++++
 drivers/media/usb/uvc/uvc_v4l2.c   |  4 ----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index b832929d3382..0ebdcc8b4ff6 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1925,6 +1925,17 @@ int uvc_register_video_device(struct uvc_device *dev,
 	vdev->prio = &stream->chain->prio;
 	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		vdev->vfl_dir = VFL_DIR_TX;
+
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	default:
+		vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		vdev->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+		break;
+	}
+
 	strlcpy(vdev->name, dev->name, sizeof vdev->name);
 
 	/*
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 3e7e283a44a8..5e0323982577 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -568,10 +568,6 @@ static int uvc_ioctl_querycap(struct file *file, void *fh,
 	usb_make_path(stream->dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
 			  | chain->caps;
-	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
-	else
-		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
 
 	return 0;
 }
-- 
Regards,

Laurent Pinchart
