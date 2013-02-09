Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2702 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3BIKBY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 16/26] cx231xx-417: use one querycap for all device nodes.
Date: Sat,  9 Feb 2013 11:00:46 +0100
Message-Id: <563da8543392ad7a21db515e8c3e192391ef6439.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c   |   20 +-------------------
 drivers/media/usb/cx231xx/cx231xx-video.c |    6 +++---
 drivers/media/usb/cx231xx/cx231xx.h       |    2 ++
 3 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index ac15a55..be8f7481 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1626,24 +1626,6 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	dprintk(3, "exit vidioc_s_ctrl()\n");
 	return 0;
 }
-static struct v4l2_capability pvr_capability = {
-	.driver         = "cx231xx",
-	.card           = "VideoGrabber",
-	.bus_info       = "usb",
-	.version        = 1,
-	.capabilities   = (V4L2_CAP_VIDEO_CAPTURE |
-			   V4L2_CAP_TUNER | V4L2_CAP_AUDIO | V4L2_CAP_RADIO |
-			 V4L2_CAP_STREAMING | V4L2_CAP_READWRITE),
-};
-static int vidioc_querycap(struct file *file, void  *priv,
-				struct v4l2_capability *cap)
-{
-
-
-
-		memcpy(cap, &pvr_capability, sizeof(struct v4l2_capability));
-	return 0;
-}
 
 static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
@@ -2016,7 +1998,7 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_g_input		 = vidioc_g_input,
 	.vidioc_s_input		 = vidioc_s_input,
 	.vidioc_s_ctrl		 = vidioc_s_ctrl,
-	.vidioc_querycap	 = vidioc_querycap,
+	.vidioc_querycap	 = cx231xx_querycap,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap	 = vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap	 = vidioc_try_fmt_vid_cap,
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 208926f..60a7b3ee 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1631,7 +1631,7 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_querycap(struct file *file, void *priv,
+int cx231xx_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
 	struct video_device *vdev = video_devdata(file);
@@ -2185,7 +2185,7 @@ static const struct v4l2_file_operations cx231xx_v4l_fops = {
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
-	.vidioc_querycap               = vidioc_querycap,
+	.vidioc_querycap               = cx231xx_querycap,
 	.vidioc_enum_fmt_vid_cap       = vidioc_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap          = vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap        = vidioc_try_fmt_vid_cap,
@@ -2236,7 +2236,7 @@ static const struct v4l2_file_operations radio_fops = {
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
-	.vidioc_querycap    = vidioc_querycap,
+	.vidioc_querycap    = cx231xx_querycap,
 	.vidioc_g_tuner     = radio_g_tuner,
 	.vidioc_s_tuner     = radio_s_tuner,
 	.vidioc_g_frequency = vidioc_g_frequency,
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index c17889d..efc0d1c 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -934,6 +934,8 @@ int cx231xx_register_extension(struct cx231xx_ops *dev);
 void cx231xx_unregister_extension(struct cx231xx_ops *dev);
 void cx231xx_init_extension(struct cx231xx *dev);
 void cx231xx_close_extension(struct cx231xx *dev);
+int cx231xx_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap);
 
 /* Provided by cx231xx-cards.c */
 extern void cx231xx_pre_card_setup(struct cx231xx *dev);
-- 
1.7.10.4

