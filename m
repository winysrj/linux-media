Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4340 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3EaKDZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?= <richard.rojfors@pelagicore.com>
Subject: [PATCH 11/21] radio-timb: add device_caps support, remove input/audio ioctls.
Date: Fri, 31 May 2013 12:02:31 +0200
Message-Id: <1369994561-25236-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The audio and input ioctls are not applicable for radio devices,
remove them.

Also set the device_caps field in v4l2_querycap.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Richard Röjfors <richard.rojfors@pelagicore.com>
---
 drivers/media/radio/radio-timb.c |   35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index bb7b143..cecf7d7 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -44,7 +44,8 @@ static int timbradio_vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(v->driver, DRIVER_NAME, sizeof(v->driver));
 	strlcpy(v->card, "Timberdale Radio", sizeof(v->card));
 	snprintf(v->bus_info, sizeof(v->bus_info), "platform:"DRIVER_NAME);
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -62,34 +63,6 @@ static int timbradio_vidioc_s_tuner(struct file *file, void *priv,
 	return v4l2_subdev_call(tr->sd_tuner, tuner, s_tuner, v);
 }
 
-static int timbradio_vidioc_g_input(struct file *filp, void *priv,
-	unsigned int *i)
-{
-	*i = 0;
-	return 0;
-}
-
-static int timbradio_vidioc_s_input(struct file *filp, void *priv,
-	unsigned int i)
-{
-	return i ? -EINVAL : 0;
-}
-
-static int timbradio_vidioc_g_audio(struct file *file, void *priv,
-	struct v4l2_audio *a)
-{
-	a->index = 0;
-	strlcpy(a->name, "Radio", sizeof(a->name));
-	a->capability = V4L2_AUDCAP_STEREO;
-	return 0;
-}
-
-static int timbradio_vidioc_s_audio(struct file *file, void *priv,
-	const struct v4l2_audio *a)
-{
-	return a->index ? -EINVAL : 0;
-}
-
 static int timbradio_vidioc_s_frequency(struct file *file, void *priv,
 	const struct v4l2_frequency *f)
 {
@@ -131,10 +104,6 @@ static const struct v4l2_ioctl_ops timbradio_ioctl_ops = {
 	.vidioc_s_tuner		= timbradio_vidioc_s_tuner,
 	.vidioc_g_frequency	= timbradio_vidioc_g_frequency,
 	.vidioc_s_frequency	= timbradio_vidioc_s_frequency,
-	.vidioc_g_input		= timbradio_vidioc_g_input,
-	.vidioc_s_input		= timbradio_vidioc_s_input,
-	.vidioc_g_audio		= timbradio_vidioc_g_audio,
-	.vidioc_s_audio		= timbradio_vidioc_s_audio,
 	.vidioc_queryctrl	= timbradio_vidioc_queryctrl,
 	.vidioc_g_ctrl		= timbradio_vidioc_g_ctrl,
 	.vidioc_s_ctrl		= timbradio_vidioc_s_ctrl
-- 
1.7.10.4

