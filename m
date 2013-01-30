Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3496 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3A3Oy2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 09:54:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 5/6] radio-miropcm20: Fix audmode/tuner/frequency handling
Date: Wed, 30 Jan 2013 15:54:03 +0100
Message-Id: <8c7c15d1677b70b558085356df273ce4abf82846.1359557431.git.hans.verkuil@cisco.com>
In-Reply-To: <1359557644-10982-1-git-send-email-hverkuil@xs4all.nl>
References: <1359557644-10982-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6fc0e0fabcd9ccf60c95ed5cd9c7a08834b43f9b.1359557431.git.hans.verkuil@cisco.com>
References: <6fc0e0fabcd9ccf60c95ed5cd9c7a08834b43f9b.1359557431.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- instead of a mute module option, use audmode as per the spec.
- clamp the frequency before setting it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-miropcm20.c |   52 +++++++++++++++------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 4ac813c..eb6cd86 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -26,44 +26,27 @@ static int radio_nr = -1;
 module_param(radio_nr, int, 0);
 MODULE_PARM_DESC(radio_nr, "Set radio device number (/dev/radioX).  Default: -1 (autodetect)");
 
-static bool mono;
-module_param(mono, bool, 0);
-MODULE_PARM_DESC(mono, "Force tuner into mono mode.");
-
 struct pcm20 {
 	struct v4l2_device v4l2_dev;
 	struct video_device vdev;
 	struct v4l2_ctrl_handler ctrl_handler;
 	unsigned long freq;
-	int muted;
+	u32 audmode;
 	struct snd_miro_aci *aci;
 	struct mutex lock;
 };
 
 static struct pcm20 pcm20_card = {
-	.freq   = 87*16000,
-	.muted  = 1,
+	.freq = 87 * 16000,
+	.audmode = V4L2_TUNER_MODE_STEREO,
 };
 
-static int pcm20_mute(struct pcm20 *dev, unsigned char mute)
-{
-	dev->muted = mute;
-	return snd_aci_cmd(dev->aci, ACI_SET_TUNERMUTE, mute, -1);
-}
-
-static int pcm20_stereo(struct pcm20 *dev, unsigned char stereo)
-{
-	return snd_aci_cmd(dev->aci, ACI_SET_TUNERMONO, !stereo, -1);
-}
-
 static int pcm20_setfreq(struct pcm20 *dev, unsigned long freq)
 {
 	unsigned char freql;
 	unsigned char freqh;
 	struct snd_miro_aci *aci = dev->aci;
 
-	dev->freq = freq;
-
 	freq /= 160;
 	if (!(aci->aci_version == 0x07 || aci->aci_version >= 0xb0))
 		freq /= 10;  /* I don't know exactly which version
@@ -71,7 +54,6 @@ static int pcm20_setfreq(struct pcm20 *dev, unsigned long freq)
 	freql = freq & 0xff;
 	freqh = freq >> 8;
 
-	pcm20_stereo(dev, !mono);
 	return snd_aci_cmd(aci, ACI_WRITE_TUNE, freql, freqh);
 }
 
@@ -99,7 +81,9 @@ static int vidioc_querycap(struct file *file, void *priv,
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
-	if (v->index)	/* Only 1 tuner */
+	struct pcm20 *dev = video_drvdata(file);
+
+	if (v->index)
 		return -EINVAL;
 	strlcpy(v->name, "FM", sizeof(v->name));
 	v->type = V4L2_TUNER_RADIO;
@@ -107,15 +91,23 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	v->rangehigh = 108*16000;
 	v->signal = 0xffff;
 	v->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
-	v->capability = V4L2_TUNER_CAP_LOW;
-	v->audmode = V4L2_TUNER_MODE_MONO;
+	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
+	v->audmode = dev->audmode;
 	return 0;
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
-	return v->index ? -EINVAL : 0;
+	struct pcm20 *dev = video_drvdata(file);
+
+	if (v->index)
+		return -EINVAL;
+	if (v->audmode > V4L2_TUNER_MODE_STEREO)
+		v->audmode = V4L2_TUNER_MODE_STEREO;
+	snd_aci_cmd(dev->aci, ACI_SET_TUNERMONO,
+			v->audmode == V4L2_TUNER_MODE_MONO, -1);
+	return 0;
 }
 
 static int vidioc_g_frequency(struct file *file, void *priv,
@@ -140,8 +132,8 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
 
-	dev->freq = f->frequency;
-	pcm20_setfreq(dev, f->frequency);
+	dev->freq = clamp(f->frequency, 87 * 16000U, 108 * 16000U);
+	pcm20_setfreq(dev, dev->freq);
 	return 0;
 }
 
@@ -151,7 +143,7 @@ static int pcm20_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		pcm20_mute(dev, ctrl->val);
+		snd_aci_cmd(dev->aci, ACI_SET_TUNERMUTE, ctrl->val, -1);
 		return 0;
 	}
 	return -EINVAL;
@@ -212,6 +204,9 @@ static int __init pcm20_init(void)
 	dev->vdev.lock = &dev->lock;
 	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
 	video_set_drvdata(&dev->vdev, dev);
+	snd_aci_cmd(dev->aci, ACI_SET_TUNERMONO,
+			dev->audmode == V4L2_TUNER_MODE_MONO, -1);
+	pcm20_setfreq(dev, dev->freq);
 
 	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0)
 		goto err_hdl;
@@ -233,6 +228,7 @@ static void __exit pcm20_cleanup(void)
 	struct pcm20 *dev = &pcm20_card;
 
 	video_unregister_device(&dev->vdev);
+	snd_aci_cmd(dev->aci, ACI_SET_TUNERMUTE, 1, -1);
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	v4l2_device_unregister(&dev->v4l2_dev);
 }
-- 
1.7.10.4

