Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1910 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab3EaKDQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Fabio Belavenuto <belavenuto@gmail.com>
Subject: [PATCH 07/21] radio-tea5764: audio and input ioctls do not apply to radio devices.
Date: Fri, 31 May 2013 12:02:27 +0200
Message-Id: <1369994561-25236-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Deleted those ioctls from this driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Fabio Belavenuto <belavenuto@gmail.com>
---
 drivers/media/radio/radio-tea5764.c |   37 -----------------------------------
 1 file changed, 37 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 5c47a97..5a60990 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -389,39 +389,6 @@ static int tea5764_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-static int vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	*i = 0;
-	return 0;
-}
-
-static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
-{
-	if (i != 0)
-		return -EINVAL;
-	return 0;
-}
-
-static int vidioc_g_audio(struct file *file, void *priv,
-			   struct v4l2_audio *a)
-{
-	if (a->index > 1)
-		return -EINVAL;
-
-	strcpy(a->name, "Radio");
-	a->capability = V4L2_AUDCAP_STEREO;
-	return 0;
-}
-
-static int vidioc_s_audio(struct file *file, void *priv,
-			   const struct v4l2_audio *a)
-{
-	if (a->index != 0)
-		return -EINVAL;
-
-	return 0;
-}
-
 static const struct v4l2_ctrl_ops tea5764_ctrl_ops = {
 	.s_ctrl = tea5764_s_ctrl,
 };
@@ -436,10 +403,6 @@ static const struct v4l2_ioctl_ops tea5764_ioctl_ops = {
 	.vidioc_querycap    = vidioc_querycap,
 	.vidioc_g_tuner     = vidioc_g_tuner,
 	.vidioc_s_tuner     = vidioc_s_tuner,
-	.vidioc_g_audio     = vidioc_g_audio,
-	.vidioc_s_audio     = vidioc_s_audio,
-	.vidioc_g_input     = vidioc_g_input,
-	.vidioc_s_input     = vidioc_s_input,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
 };
-- 
1.7.10.4

