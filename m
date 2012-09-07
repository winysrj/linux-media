Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4516 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab2IGN3g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 13/28] Add V4L2_CAP_MONOTONIC_TS where applicable.
Date: Fri,  7 Sep 2012 15:29:13 +0200
Message-Id: <753ddb14136b19372f3a533961fc90b5adbfb07a.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the new V4L2_CAP_MONOTONIC_TS capability to those drivers that
use monotomic timestamps instead of the system time.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx18/cx18-ioctl.c           |    2 +-
 drivers/media/platform/davinci/vpbe_display.c |    3 ++-
 drivers/media/platform/omap3isp/ispvideo.c    |    5 +++--
 drivers/media/platform/s5p-fimc/fimc-lite.c   |    2 +-
 drivers/media/usb/gspca/gspca.c               |    1 +
 drivers/media/usb/uvc/uvc_v4l2.c              |    7 +++----
 6 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index e9912db..51675bc 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -473,7 +473,7 @@ static int cx18_querycap(struct file *file, void *fh,
 		 "PCI:%s", pci_name(cx->pci_dev));
 	vcap->capabilities = cx->v4l2_cap; 	    /* capabilities */
 	if (id->type == CX18_ENC_STREAM_TYPE_YUV)
-		vcap->capabilities |= V4L2_CAP_STREAMING;
+		vcap->capabilities |= V4L2_CAP_STREAMING | V4L2_CAP_MONOTONIC_TS;
 	return 0;
 }
 
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 9a05c81..3a50547 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -620,7 +620,8 @@ static int vpbe_display_querycap(struct file *file, void  *priv,
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
 
 	cap->version = VPBE_DISPLAY_VERSION_CODE;
-	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING |
+		V4L2_MONOTONIC_TS;
 	strlcpy(cap->driver, VPBE_DISPLAY_DRIVER, sizeof(cap->driver));
 	strlcpy(cap->bus_info, "platform", sizeof(cap->bus_info));
 	strlcpy(cap->card, vpbe_dev->cfg->module_name, sizeof(cap->card));
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 3a5085e..a25aa1d 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -663,10 +663,11 @@ isp_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 	strlcpy(cap->card, video->video.name, sizeof(cap->card));
 	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
 
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_MONOTONIC_TS;
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+		cap->capabilities |= V4L2_CAP_VIDEO_CAPTURE;
 	else
-		cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+		cap->capabilities |= V4L2_CAP_VIDEO_OUTPUT;
 
 	return 0;
 }
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index c5b57e8..ab12928 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -629,7 +629,7 @@ static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
 	strlcpy(cap->driver, FIMC_LITE_DRV_NAME, sizeof(cap->driver));
 	cap->bus_info[0] = 0;
 	cap->card[0] = 0;
-	cap->capabilities = V4L2_CAP_STREAMING;
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_MONOTONIC_TS;
 	return 0;
 }
 
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index d4e8343..5d3bcdc 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1351,6 +1351,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	usb_make_path(gspca_dev->dev, (char *) cap->bus_info,
 			sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE
+			  | V4L2_CAP_MONOTONIC_TS
 			  | V4L2_CAP_STREAMING
 			  | V4L2_CAP_READWRITE;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index f00db30..1c6dff0 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -564,12 +564,11 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		usb_make_path(stream->dev->udev,
 			      cap->bus_info, sizeof(cap->bus_info));
 		cap->version = LINUX_VERSION_CODE;
+		cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_MONOTONIC_TS;
 		if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-			cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
-					  | V4L2_CAP_STREAMING;
+			cap->capabilities |= V4L2_CAP_VIDEO_CAPTURE;
 		else
-			cap->capabilities = V4L2_CAP_VIDEO_OUTPUT
-					  | V4L2_CAP_STREAMING;
+			cap->capabilities |= V4L2_CAP_VIDEO_OUTPUT;
 		break;
 	}
 
-- 
1.7.10.4

