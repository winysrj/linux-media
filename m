Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2602 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab3EaKDe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 17/21] radio-sf16fmi: remove audio/input ioctls.
Date: Fri, 31 May 2013 12:02:37 +0200
Message-Id: <1369994561-25236-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The audio and input ioctls do not apply to radio devices. Remove them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/radio/radio-sf16fmi.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index adfcc61..c1d51ec 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -218,32 +218,6 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
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
-	return i ? -EINVAL : 0;
-}
-
-static int vidioc_g_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
-{
-	a->index = 0;
-	strlcpy(a->name, "Radio", sizeof(a->name));
-	a->capability = V4L2_AUDCAP_STEREO;
-	return 0;
-}
-
-static int vidioc_s_audio(struct file *file, void *priv,
-					const struct v4l2_audio *a)
-{
-	return a->index ? -EINVAL : 0;
-}
-
 static const struct v4l2_file_operations fmi_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= video_ioctl2,
@@ -253,10 +227,6 @@ static const struct v4l2_ioctl_ops fmi_ioctl_ops = {
 	.vidioc_querycap    = vidioc_querycap,
 	.vidioc_g_tuner     = vidioc_g_tuner,
 	.vidioc_s_tuner     = vidioc_s_tuner,
-	.vidioc_g_audio     = vidioc_g_audio,
-	.vidioc_s_audio     = vidioc_s_audio,
-	.vidioc_g_input     = vidioc_g_input,
-	.vidioc_s_input     = vidioc_s_input,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
 	.vidioc_queryctrl   = vidioc_queryctrl,
-- 
1.7.10.4

