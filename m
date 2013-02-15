Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4803 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161340Ab3BOMza (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 07:55:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 02/10] au0828: fix querycap.
Date: Fri, 15 Feb 2013 13:55:05 +0100
Message-Id: <cfb52a280790b2d28febae0126cd02aa4c7a1d97.1360932644.git.hans.verkuil@cisco.com>
In-Reply-To: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
References: <1360932913-3548-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
References: <ee88bd549bcb37235d975b6799fbcf6501e98f0c.1360932644.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-video.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 8b9e826..4254b2c 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1241,20 +1241,25 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 static int vidioc_querycap(struct file *file, void  *priv,
 			   struct v4l2_capability *cap)
 {
-	struct au0828_fh *fh  = priv;
+	struct video_device *vdev = video_devdata(file);
+	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
 
 	strlcpy(cap->driver, "au0828", sizeof(cap->driver));
 	strlcpy(cap->card, dev->board.name, sizeof(cap->card));
-	strlcpy(cap->bus_info, dev->v4l2_dev.name, sizeof(cap->bus_info));
+	usb_make_path(dev->usbdev, cap->bus_info, sizeof(cap->bus_info));
 
-	/*set the device capabilities */
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_VBI_CAPTURE |
-		V4L2_CAP_AUDIO |
+	/* set the device capabilities */
+	cap->device_caps = V4L2_CAP_AUDIO |
 		V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING |
 		V4L2_CAP_TUNER;
+	if (vdev->vfl_type == VFL_TYPE_GRABBER)
+		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
+	else
+		cap->device_caps |= V4L2_CAP_VBI_CAPTURE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
+		V4L2_CAP_VBI_CAPTURE | V4L2_CAP_VIDEO_CAPTURE;
 	return 0;
 }
 
-- 
1.7.10.4

