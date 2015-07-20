Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44636 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755488AbbGTNA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:00:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/12] usbvision: the radio device node has wrong caps
Date: Mon, 20 Jul 2015 14:59:32 +0200
Message-Id: <1437397178-5013-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397178-5013-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The radio device node had the same caps as the video node. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-video.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 15a1ebf..f526712 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -487,17 +487,24 @@ static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *vc)
 {
 	struct usb_usbvision *usbvision = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
 
 	strlcpy(vc->driver, "USBVision", sizeof(vc->driver));
 	strlcpy(vc->card,
 		usbvision_device_data[usbvision->dev_model].model_string,
 		sizeof(vc->card));
 	usb_make_path(usbvision->dev, vc->bus_info, sizeof(vc->bus_info));
-	vc->device_caps = V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_READWRITE |
-		V4L2_CAP_STREAMING |
-		(usbvision->have_tuner ? V4L2_CAP_TUNER : 0);
-	vc->capabilities = vc->device_caps | V4L2_CAP_DEVICE_CAPS;
+	vc->device_caps = usbvision->have_tuner ? V4L2_CAP_TUNER : 0;
+	if (vdev->vfl_type == VFL_TYPE_GRABBER)
+		vc->device_caps |= V4L2_CAP_VIDEO_CAPTURE |
+			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	else
+		vc->device_caps |= V4L2_CAP_RADIO;
+
+	vc->capabilities = vc->device_caps | V4L2_CAP_VIDEO_CAPTURE |
+		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;
+	if (usbvision_device_data[usbvision->dev_model].radio)
+		vc->capabilities |= V4L2_CAP_RADIO;
 	return 0;
 }
 
-- 
2.1.4

