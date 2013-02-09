Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4731 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab3BIKBY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 15/26] cx231xx-417: remove empty functions.
Date: Sat,  9 Feb 2013 11:00:45 +0100
Message-Id: <fec9d49790b53d4b3ed41cc86f68615b8bfe7503.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c |   68 +------------------------------
 1 file changed, 1 insertion(+), 67 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 15dd334..ac15a55 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1551,33 +1551,6 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
 	dprintk(3, "exit vidioc_s_std() i=0x%x\n", i);
 	return 0;
 }
-static int vidioc_g_audio(struct file *file, void *fh,
-					struct v4l2_audio *a)
-{
-		struct v4l2_audio *vin = a;
-
-		int ret = -EINVAL;
-		if (vin->index > 0)
-			return ret;
-		strncpy(vin->name, "VideoGrabber Audio", 14);
-		vin->capability = V4L2_AUDCAP_STEREO;
-return 0;
-}
-static int vidioc_enumaudio(struct file *file, void *fh,
-					struct v4l2_audio *a)
-{
-		struct v4l2_audio *vin = a;
-
-		int ret = -EINVAL;
-
-		if (vin->index > 0)
-			return ret;
-		strncpy(vin->name, "VideoGrabber Audio", 14);
-		vin->capability = V4L2_AUDCAP_STEREO;
-
-
-return 0;
-}
 static const char *iname[] = {
 	[CX231XX_VMUX_COMPOSITE1] = "Composite1",
 	[CX231XX_VMUX_SVIDEO]     = "S-Video",
@@ -1642,32 +1615,6 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-static int vidioc_g_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *t)
-{
-	return 0;
-}
-
-static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *t)
-{
-	return 0;
-}
-
-static int vidioc_g_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
-{
-	return 0;
-}
-
-static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
-{
-
-
-	return 0;
-}
-
 static int vidioc_s_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctl)
 {
@@ -1748,13 +1695,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f)
-{
-
-	return 0;
-}
-
 static int vidioc_reqbufs(struct file *file, void *priv,
 				struct v4l2_requestbuffers *p)
 {
@@ -2073,20 +2013,14 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_std		 = vidioc_s_std,
 	.vidioc_g_std		 = vidioc_g_std,
 	.vidioc_enum_input	 = vidioc_enum_input,
-	.vidioc_enumaudio	 = vidioc_enumaudio,
-	.vidioc_g_audio		 = vidioc_g_audio,
 	.vidioc_g_input		 = vidioc_g_input,
 	.vidioc_s_input		 = vidioc_s_input,
-	.vidioc_g_tuner		 = vidioc_g_tuner,
-	.vidioc_s_tuner		 = vidioc_s_tuner,
-	.vidioc_g_frequency	 = vidioc_g_frequency,
-	.vidioc_s_frequency	 = vidioc_s_frequency,
 	.vidioc_s_ctrl		 = vidioc_s_ctrl,
 	.vidioc_querycap	 = vidioc_querycap,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap	 = vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap	 = vidioc_try_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap	 = vidioc_s_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap	 = vidioc_try_fmt_vid_cap,
 	.vidioc_reqbufs		 = vidioc_reqbufs,
 	.vidioc_querybuf	 = vidioc_querybuf,
 	.vidioc_qbuf		 = vidioc_qbuf,
-- 
1.7.10.4

