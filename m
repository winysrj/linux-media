Return-path: <mchehab@pedra>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:49254 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757865Ab1FKNhh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 09:37:37 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] tea575x: remove useless input ioctls
Date: Sat, 11 Jun 2011 15:37:29 +0200
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106111537.32037.linux@rainbow-software.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Remove empty and useless g_input and s_input ioctls.
This fixes one fail of v4l2-compliance test.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-/sound/i2c/other/tea575x-tuner.c	2011-06-11 15:29:18.000000000 +0200
+++ linux-2.6.39-rc2/sound/i2c/other/tea575x-tuner.c	2011-06-11 15:29:51.000000000 +0200
@@ -269,19 +269,6 @@ static int tea575x_s_ctrl(struct v4l2_ct
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
 static const struct v4l2_file_operations tea575x_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= video_ioctl2,
@@ -293,8 +280,6 @@ static const struct v4l2_ioctl_ops tea57
 	.vidioc_s_tuner     = vidioc_s_tuner,
 	.vidioc_g_audio     = vidioc_g_audio,
 	.vidioc_s_audio     = vidioc_s_audio,
-	.vidioc_g_input     = vidioc_g_input,
-	.vidioc_s_input     = vidioc_s_input,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
 };


-- 
Ondrej Zary
