Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3467 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3FCJhQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 05:37:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [RFC PATCH 01/13] mcam-core: replace current_norm by g_std.
Date: Mon,  3 Jun 2013 11:36:38 +0200
Message-Id: <1370252210-4994-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The current_norm field is deprecated, replace this by properly
implementing g_std.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 64ab91e..61e34bd 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1362,6 +1362,12 @@ static int mcam_vidioc_s_std(struct file *filp, void *priv, v4l2_std_id a)
 	return 0;
 }
 
+static int mcam_vidioc_g_std(struct file *filp, void *priv, v4l2_std_id *a)
+{
+	*a = V4L2_STD_NTSC_M;
+	return 0;
+}
+
 /*
  * G/S_PARM.  Most of this is done by the sensor, but we are
  * the level which controls the number of read buffers.
@@ -1467,6 +1473,7 @@ static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
 	.vidioc_g_input		= mcam_vidioc_g_input,
 	.vidioc_s_input		= mcam_vidioc_s_input,
 	.vidioc_s_std		= mcam_vidioc_s_std,
+	.vidioc_g_std		= mcam_vidioc_g_std,
 	.vidioc_reqbufs		= mcam_vidioc_reqbufs,
 	.vidioc_querybuf	= mcam_vidioc_querybuf,
 	.vidioc_qbuf		= mcam_vidioc_qbuf,
@@ -1593,7 +1600,6 @@ static const struct v4l2_file_operations mcam_v4l_fops = {
 static struct video_device mcam_v4l_template = {
 	.name = "mcam",
 	.tvnorms = V4L2_STD_NTSC_M,
-	.current_norm = V4L2_STD_NTSC_M,  /* make mplayer happy */
 
 	.fops = &mcam_v4l_fops,
 	.ioctl_ops = &mcam_v4l_ioctl_ops,
-- 
1.7.10.4

