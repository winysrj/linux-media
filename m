Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3405 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3BDMgs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2013 07:36:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 6/8] stk-webcam: fix querycap and simplify s_input.
Date: Mon,  4 Feb 2013 13:36:19 +0100
Message-Id: <ad8ed42592df3b17f7683c34ad499fba9a8ed998.1359981193.git.hans.verkuil@cisco.com>
In-Reply-To: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <2d4b37cad1af7790d44cc541b4a5519716e6a98c.1359981193.git.hans.verkuil@cisco.com>
References: <2d4b37cad1af7790d44cc541b4a5519716e6a98c.1359981193.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add device_caps support to querycap and do not set the version field (let the
core handle that).

Also simplify the s_input ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index a7882d6..a654578 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -730,12 +730,16 @@ static int v4l_stk_mmap(struct file *fp, struct vm_area_struct *vma)
 static int stk_vidioc_querycap(struct file *filp,
 		void *priv, struct v4l2_capability *cap)
 {
+	struct stk_camera *dev = video_drvdata(filp);
+
 	strcpy(cap->driver, "stk");
 	strcpy(cap->card, "stk");
-	cap->version = DRIVER_VERSION_NUM;
+	strlcpy(cap->bus_info, dev_name(&dev->udev->dev),
+		sizeof(cap->bus_info));
 
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE
 		| V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -759,10 +763,7 @@ static int stk_vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
 
 static int stk_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
 {
-	if (i != 0)
-		return -EINVAL;
-	else
-		return 0;
+	return i ? -EINVAL : 0;
 }
 
 static int stk_s_ctrl(struct v4l2_ctrl *ctrl)
-- 
1.7.10.4

