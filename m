Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3084 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3AaKZw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 15/18] tlg2300: remove empty vidioc_try_fmt_vid_cap, add missing g_std.
Date: Thu, 31 Jan 2013 11:25:33 +0100
Message-Id: <2e32299585af78c94bfb4c8df2d61d790935cefb.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
References: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-video.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index 849c4bb..4c045b3 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -705,12 +705,6 @@ static int vidioc_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
 	return 0;
 }
 
-static int vidioc_try_fmt(struct file *file, void *fh,
-		struct v4l2_format *f)
-{
-	return 0;
-}
-
 /*
  * VLC calls VIDIOC_S_STD before VIDIOC_S_FMT, while
  * Mplayer calls them in the reverse order.
@@ -866,6 +860,14 @@ static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id *norm)
 	return set_std(front->pd, norm);
 }
 
+static int vidioc_g_std(struct file *file, void *fh, v4l2_std_id *norm)
+{
+	struct front_face *front = fh;
+	logs(front);
+	*norm = front->pd->video_data.context.tvnormid;
+	return 0;
+}
+
 static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *in)
 {
 	struct front_face *front = fh;
@@ -1495,7 +1497,6 @@ static const struct v4l2_ioctl_ops pd_video_ioctl_ops = {
 	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt,
 	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt,
 	.vidioc_g_fmt_vbi_cap	= vidioc_g_fmt_vbi, /* VBI */
-	.vidioc_try_fmt_vid_cap = vidioc_try_fmt,
 
 	/* Input */
 	.vidioc_g_input		= vidioc_g_input,
@@ -1510,6 +1511,7 @@ static const struct v4l2_ioctl_ops pd_video_ioctl_ops = {
 	/* Tuner ioctls */
 	.vidioc_g_tuner		= vidioc_g_tuner,
 	.vidioc_s_tuner		= vidioc_s_tuner,
+	.vidioc_g_std		= vidioc_g_std,
 	.vidioc_s_std		= vidioc_s_std,
 	.vidioc_g_frequency	= vidioc_g_frequency,
 	.vidioc_s_frequency	= vidioc_s_frequency,
-- 
1.7.10.4

