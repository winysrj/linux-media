Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3822 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3BJRxE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 12:53:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 02/12] stk-webcam: remove bogus STD support.
Date: Sun, 10 Feb 2013 18:52:43 +0100
Message-Id: <8935bd137dd4f8cfe15e4023a28877d5dc9bde4a.1360518391.git.hans.verkuil@cisco.com>
In-Reply-To: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
References: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It's a webcam, the STD API is not applicable to webcams.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 71ac307..3b874e4 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -768,12 +768,6 @@ static int stk_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
 		return 0;
 }
 
-/* from vivi.c */
-static int stk_vidioc_s_std(struct file *filp, void *priv, v4l2_std_id *a)
-{
-	return 0;
-}
-
 /* List of all V4Lv2 controls supported by the driver */
 static struct v4l2_queryctrl stk_controls[] = {
 	{
@@ -1225,7 +1219,6 @@ static const struct v4l2_ioctl_ops v4l_stk_ioctl_ops = {
 	.vidioc_enum_input = stk_vidioc_enum_input,
 	.vidioc_s_input = stk_vidioc_s_input,
 	.vidioc_g_input = stk_vidioc_g_input,
-	.vidioc_s_std = stk_vidioc_s_std,
 	.vidioc_reqbufs = stk_vidioc_reqbufs,
 	.vidioc_querybuf = stk_vidioc_querybuf,
 	.vidioc_qbuf = stk_vidioc_qbuf,
@@ -1251,8 +1244,6 @@ static void stk_v4l_dev_release(struct video_device *vd)
 
 static struct video_device stk_v4l_data = {
 	.name = "stkwebcam",
-	.tvnorms = V4L2_STD_UNKNOWN,
-	.current_norm = V4L2_STD_UNKNOWN,
 	.fops = &v4l_stk_fops,
 	.ioctl_ops = &v4l_stk_ioctl_ops,
 	.release = stk_v4l_dev_release,
-- 
1.7.10.4

