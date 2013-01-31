Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2069 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3AaKZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 04/18] tlg2300: remove ioctls that are invalid for radio devices.
Date: Thu, 31 Jan 2013 11:25:22 +0100
Message-Id: <fa815493501dbc166181e228f66319ac3398cd2c.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
References: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The input and audio ioctls are only valid for video/vbi nodes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-radio.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
index c4feffb..4c76e089 100644
--- a/drivers/media/usb/tlg2300/pd-radio.c
+++ b/drivers/media/usb/tlg2300/pd-radio.c
@@ -350,36 +350,9 @@ static int vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
 {
 	return vt->index > 0 ? -EINVAL : 0;
 }
-static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio *va)
-{
-	return (va->index != 0) ? -EINVAL : 0;
-}
-
-static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
-{
-	a->index    = 0;
-	a->mode    = 0;
-	a->capability = V4L2_AUDCAP_STEREO;
-	strcpy(a->name, "Radio");
-	return 0;
-}
-
-static int vidioc_s_input(struct file *filp, void *priv, u32 i)
-{
-	return (i != 0) ? -EINVAL : 0;
-}
-
-static int vidioc_g_input(struct file *filp, void *priv, u32 *i)
-{
-	return (*i != 0) ? -EINVAL : 0;
-}
 
 static const struct v4l2_ioctl_ops poseidon_fm_ioctl_ops = {
 	.vidioc_querycap    = vidioc_querycap,
-	.vidioc_g_audio     = vidioc_g_audio,
-	.vidioc_s_audio     = vidioc_s_audio,
-	.vidioc_g_input     = vidioc_g_input,
-	.vidioc_s_input     = vidioc_s_input,
 	.vidioc_queryctrl   = tlg_fm_vidioc_queryctrl,
 	.vidioc_querymenu   = tlg_fm_vidioc_querymenu,
 	.vidioc_g_ctrl      = tlg_fm_vidioc_g_ctrl,
-- 
1.7.10.4

