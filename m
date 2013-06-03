Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3755 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3FCJhW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 05:37:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [RFC PATCH 02/13] via-camera: replace current_norm by g_std.
Date: Mon,  3 Jun 2013 11:36:39 +0200
Message-Id: <1370252210-4994-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The current_norm field is deprecated. Replace it by properly implementing
g_std.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/platform/via-camera.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index a794cd6..7522abc 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -852,6 +852,12 @@ static int viacam_s_std(struct file *filp, void *priv, v4l2_std_id std)
 	return 0;
 }
 
+static int viacam_g_std(struct file *filp, void *priv, v4l2_std_id *std)
+{
+	*std = V4L2_STD_NTSC_M;
+	return 0;
+}
+
 /*
  * Video format stuff.	Here is our default format until
  * user space messes with things.
@@ -1179,6 +1185,7 @@ static const struct v4l2_ioctl_ops viacam_ioctl_ops = {
 	.vidioc_g_input		= viacam_g_input,
 	.vidioc_s_input		= viacam_s_input,
 	.vidioc_s_std		= viacam_s_std,
+	.vidioc_g_std		= viacam_g_std,
 	.vidioc_enum_fmt_vid_cap = viacam_enum_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap = viacam_try_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap	= viacam_g_fmt_vid_cap,
@@ -1266,7 +1273,6 @@ static struct video_device viacam_v4l_template = {
 	.name		= "via-camera",
 	.minor		= -1,
 	.tvnorms	= V4L2_STD_NTSC_M,
-	.current_norm	= V4L2_STD_NTSC_M,
 	.fops		= &viacam_fops,
 	.ioctl_ops	= &viacam_ioctl_ops,
 	.release	= video_device_release_empty, /* Check this */
-- 
1.7.10.4

