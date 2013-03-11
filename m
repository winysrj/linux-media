Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1727 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab3CKVBF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 02/15] au0828: fix querycap.
Date: Mon, 11 Mar 2013 22:00:33 +0100
Message-Id: <fe438e0b9c61ba667c44f4903cdd37c68cc7ca94.1363035203.git.hans.verkuil@cisco.com>
In-Reply-To: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
References: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
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

