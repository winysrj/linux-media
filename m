Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1997 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab3BIKBL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 01/26] cx231xx: add device_caps support to QUERYCAP.
Date: Sat,  9 Feb 2013 11:00:31 +0100
Message-Id: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This fixes a v4l2_compliance failure.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 06376d9..ffeedcd 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1854,6 +1854,7 @@ static int vidioc_streamoff(struct file *file, void *priv,
 static int vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
 
@@ -1861,17 +1862,20 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, cx231xx_boards[dev->model].name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
-	cap->capabilities = V4L2_CAP_VBI_CAPTURE |
-#if 0
-		V4L2_CAP_SLICED_VBI_CAPTURE |
-#endif
-		V4L2_CAP_VIDEO_CAPTURE	|
+	cap->device_caps =
 		V4L2_CAP_AUDIO		|
 		V4L2_CAP_READWRITE	|
 		V4L2_CAP_STREAMING;
 
+	if (vdev->vfl_type == VFL_TYPE_VBI)
+		cap->device_caps |= V4L2_CAP_VBI_CAPTURE;
+	else
+		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
 	if (dev->tuner_type != TUNER_ABSENT)
-		cap->capabilities |= V4L2_CAP_TUNER;
+		cap->device_caps |= V4L2_CAP_TUNER;
+	cap->capabilities = cap->device_caps |
+		V4L2_CAP_VBI_CAPTURE | V4L2_CAP_VIDEO_CAPTURE |
+		V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
-- 
1.7.10.4

