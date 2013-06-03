Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2819 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab3FCJh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 05:37:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/13] usbvision: replace current_norm by g_std.
Date: Mon,  3 Jun 2013 11:36:47 +0200
Message-Id: <1370252210-4994-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

current_norm use is deprecated because it is per-devicenode and if you
have more device nodes all dependent on the same video source, then this
no longer works. Just implement g_std instead.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbvision/usbvision-video.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index d34c2af..7ad872a 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -608,6 +608,14 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 	return 0;
 }
 
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
+{
+	struct usb_usbvision *usbvision = video_drvdata(file);
+
+	*id = usbvision->tvnorm_id;
+	return 0;
+}
+
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *vt)
 {
@@ -1248,6 +1256,7 @@ static const struct v4l2_ioctl_ops usbvision_ioctl_ops = {
 	.vidioc_qbuf          = vidioc_qbuf,
 	.vidioc_dqbuf         = vidioc_dqbuf,
 	.vidioc_s_std         = vidioc_s_std,
+	.vidioc_g_std         = vidioc_g_std,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
@@ -1274,7 +1283,6 @@ static struct video_device usbvision_video_template = {
 	.name           = "usbvision-video",
 	.release	= video_device_release,
 	.tvnorms        = USBVISION_NORMS,
-	.current_norm   = V4L2_STD_PAL
 };
 
 
@@ -1307,9 +1315,6 @@ static struct video_device usbvision_radio_template = {
 	.name		= "usbvision-radio",
 	.release	= video_device_release,
 	.ioctl_ops	= &usbvision_radio_ioctl_ops,
-
-	.tvnorms              = USBVISION_NORMS,
-	.current_norm         = V4L2_STD_PAL
 };
 
 
-- 
1.7.10.4

