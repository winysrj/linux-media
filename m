Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4972 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab1AHNhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 08:37:07 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08DalkB015112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 14:37:06 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 14/16] radio-maxiradio: convert to core-assisted locking
Date: Sat,  8 Jan 2011 14:36:39 +0100
Message-Id: <ff51bbdf849ecc23a25603412c0c18c5dbd423bc.1294493428.git.hverkuil@xs4all.nl>
In-Reply-To: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
References: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
References: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-maxiradio.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 6459a22..1323a56 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -98,12 +98,10 @@ struct maxiradio
 
 	u16	io;	/* base of radio io */
 	u16	muted;	/* VIDEO_AUDIO_MUTE */
-	u16	stereo;	/* VIDEO_TUNER_STEREO_ON */
-	u16	tuned;	/* signal strength (0 or 0xffff) */
 
 	unsigned long freq;
 
-	struct mutex lock;
+	struct mutex v4l2_lock;
 };
 
 static inline struct maxiradio *to_maxiradio(struct v4l2_device *v4l2_dev)
@@ -208,7 +206,6 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (v->index > 0)
 		return -EINVAL;
 
-	mutex_lock(&dev->lock);
 	strlcpy(v->name, "FM", sizeof(v->name));
 	v->type = V4L2_TUNER_RADIO;
 	v->rangelow = FREQ_LO;
@@ -220,8 +217,6 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	else
 		v->audmode = V4L2_TUNER_MODE_MONO;
 	v->signal = 0xffff * get_tune(dev->io);
-	mutex_unlock(&dev->lock);
-
 	return 0;
 }
 
@@ -274,12 +269,9 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	mutex_lock(&dev->lock);
 	dev->freq = f->frequency;
 	set_freq(dev, dev->freq);
 	msleep(125);
-	mutex_unlock(&dev->lock);
-
 	return 0;
 }
 
@@ -331,13 +323,11 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		mutex_lock(&dev->lock);
 		dev->muted = ctrl->value;
 		if (dev->muted)
 			turn_power(dev, 0);
 		else
 			set_freq(dev, dev->freq);
-		mutex_unlock(&dev->lock);
 		return 0;
 	}
 
@@ -377,7 +367,7 @@ static int __devinit maxiradio_init_one(struct pci_dev *pdev, const struct pci_d
 	}
 
 	v4l2_dev = &dev->v4l2_dev;
-	mutex_init(&dev->lock);
+	mutex_init(&dev->v4l2_lock);
 	dev->pdev = pdev;
 	dev->muted = 1;
 	dev->freq = FREQ_LO;
@@ -405,6 +395,7 @@ static int __devinit maxiradio_init_one(struct pci_dev *pdev, const struct pci_d
 	dev->vdev.fops = &maxiradio_fops;
 	dev->vdev.ioctl_ops = &maxiradio_ioctl_ops;
 	dev->vdev.release = video_device_release_empty;
+	dev->vdev.lock = &dev->v4l2_lock;
 	video_set_drvdata(&dev->vdev, dev);
 
 	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-- 
1.7.0.4

