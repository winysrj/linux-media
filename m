Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4657 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab3FVKHJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jun 2013 06:07:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Manjunatha Halli <manjunatha_halli@ti.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/6] wl128x: remove illegal g/s_audio
Date: Sat, 22 Jun 2013 12:06:52 +0200
Message-Id: <1371895615-14162-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371895615-14162-1-git-send-email-hverkuil@xs4all.nl>
References: <1371895615-14162-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These ioctls are for video devices, not for radio devices.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/wl128x/fmdrv_v4l2.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 1d8fa30..22becae 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -249,25 +249,6 @@ static int fm_v4l2_s_ctrl(struct v4l2_ctrl *ctrl)
 	}
 }
 
-static int fm_v4l2_vidioc_g_audio(struct file *file, void *priv,
-		struct v4l2_audio *audio)
-{
-	memset(audio, 0, sizeof(*audio));
-	strcpy(audio->name, "Radio");
-	audio->capability = V4L2_AUDCAP_STEREO;
-
-	return 0;
-}
-
-static int fm_v4l2_vidioc_s_audio(struct file *file, void *priv,
-		const struct v4l2_audio *audio)
-{
-	if (audio->index != 0)
-		return -EINVAL;
-
-	return 0;
-}
-
 /* Get tuner attributes. If current mode is NOT RX, return error */
 static int fm_v4l2_vidioc_g_tuner(struct file *file, void *priv,
 		struct v4l2_tuner *tuner)
@@ -501,8 +482,6 @@ static const struct v4l2_ctrl_ops fm_ctrl_ops = {
 };
 static const struct v4l2_ioctl_ops fm_drv_ioctl_ops = {
 	.vidioc_querycap = fm_v4l2_vidioc_querycap,
-	.vidioc_g_audio = fm_v4l2_vidioc_g_audio,
-	.vidioc_s_audio = fm_v4l2_vidioc_s_audio,
 	.vidioc_g_tuner = fm_v4l2_vidioc_g_tuner,
 	.vidioc_s_tuner = fm_v4l2_vidioc_s_tuner,
 	.vidioc_g_frequency = fm_v4l2_vidioc_g_freq,
-- 
1.8.3.1

