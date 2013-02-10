Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2394 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab3BJRxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 12:53:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 07/12] stk-webcam: fix querycap and simplify s_input.
Date: Sun, 10 Feb 2013 18:52:48 +0100
Message-Id: <b1645cda4d0b4458986aca3b7efe506419119639.1360518391.git.hans.verkuil@cisco.com>
In-Reply-To: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
References: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add device_caps support to querycap, fill in bus_info correctly and
do not set the version field (let the core handle that).

Also simplify the s_input ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 272e1a2..c72a1c4 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -730,12 +730,15 @@ static int v4l_stk_mmap(struct file *fp, struct vm_area_struct *vma)
 static int stk_vidioc_querycap(struct file *filp,
 		void *priv, struct v4l2_capability *cap)
 {
+	struct stk_camera *dev = video_drvdata(filp);
+
 	strcpy(cap->driver, "stk");
 	strcpy(cap->card, "stk");
-	cap->version = DRIVER_VERSION_NUM;
+	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE
 		| V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -759,10 +762,7 @@ static int stk_vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
 
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

