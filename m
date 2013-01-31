Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3670 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab3AaKZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 02/18] tlg2300: fix tuner and frequency handling of the radio device.
Date: Thu, 31 Jan 2013 11:25:20 +0100
Message-Id: <b4d0a04e07ad8b07837096f2601fad0f6614acb2.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
References: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver now passes the tuner and frequency tests of v4l2-compliance.

It's the usual bugs: frequency wasn't clamped to the valid frequency range,
incorrect tuner capabilities and tuner fields not filled in, missing test
for invalid tuner index, no initial frequency and incorrect error handling.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-radio.c |   37 +++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
index 25eeb16..90dc1d1 100644
--- a/drivers/media/usb/tlg2300/pd-radio.c
+++ b/drivers/media/usb/tlg2300/pd-radio.c
@@ -18,8 +18,8 @@ static int set_frequency(struct poseidon *p, __u32 frequency);
 static int poseidon_fm_close(struct file *filp);
 static int poseidon_fm_open(struct file *filp);
 
-#define TUNER_FREQ_MIN_FM 76000000
-#define TUNER_FREQ_MAX_FM 108000000
+#define TUNER_FREQ_MIN_FM 76000000U
+#define TUNER_FREQ_MAX_FM 108000000U
 
 #define MAX_PREEMPHASIS (V4L2_PREEMPHASIS_75_uS + 1)
 static int preemphasis[MAX_PREEMPHASIS] = {
@@ -170,13 +170,14 @@ static int tlg_fm_vidioc_g_tuner(struct file *file, void *priv,
 		return -EINVAL;
 
 	vt->type	= V4L2_TUNER_RADIO;
-	vt->capability	= V4L2_TUNER_CAP_STEREO;
-	vt->rangelow	= TUNER_FREQ_MIN_FM / 62500;
-	vt->rangehigh	= TUNER_FREQ_MAX_FM / 62500;
+	vt->capability	= V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LOW;
+	vt->rangelow	= TUNER_FREQ_MIN_FM * 2 / 125;
+	vt->rangehigh	= TUNER_FREQ_MAX_FM * 2 / 125;
 	vt->rxsubchans	= V4L2_TUNER_SUB_STEREO;
 	vt->audmode	= V4L2_TUNER_MODE_STEREO;
 	vt->signal	= 0;
 	vt->afc 	= 0;
+	strlcpy(vt->name, "Radio", sizeof(vt->name));
 
 	mutex_lock(&p->lock);
 	ret = send_get_req(p, TUNER_STATUS, TLG_MODE_FM_RADIO,
@@ -207,6 +208,8 @@ static int fm_get_freq(struct file *file, void *priv,
 {
 	struct poseidon *p = file->private_data;
 
+	if (argp->tuner)
+		return -EINVAL;
 	argp->frequency = p->radio_data.fm_freq;
 	return 0;
 }
@@ -221,11 +224,8 @@ static int set_frequency(struct poseidon *p, __u32 frequency)
 	ret = send_set_req(p, TUNER_AUD_ANA_STD,
 				p->radio_data.pre_emphasis, &status);
 
-	freq =  (frequency * 125) * 500 / 1000;/* kHZ */
-	if (freq < TUNER_FREQ_MIN_FM/1000 || freq > TUNER_FREQ_MAX_FM/1000) {
-		ret = -EINVAL;
-		goto error;
-	}
+	freq = (frequency * 125) / 2; /* Hz */
+	freq = clamp(freq, TUNER_FREQ_MIN_FM, TUNER_FREQ_MAX_FM);
 
 	ret = send_set_req(p, TUNE_FREQ_SELECT, freq, &status);
 	if (ret < 0)
@@ -240,7 +240,7 @@ static int set_frequency(struct poseidon *p, __u32 frequency)
 				TLG_TUNE_PLAY_SVC_START, &status);
 		p->radio_data.is_radio_streaming = 1;
 	}
-	p->radio_data.fm_freq = frequency;
+	p->radio_data.fm_freq = freq * 2 / 125;
 error:
 	mutex_unlock(&p->lock);
 	return ret;
@@ -251,7 +251,9 @@ static int fm_set_freq(struct file *file, void *priv,
 {
 	struct poseidon *p = file->private_data;
 
-	p->file_for_stream  = file;
+	if (argp->tuner)
+		return -EINVAL;
+	p->file_for_stream = file;
 #ifdef CONFIG_PM
 	p->pm_suspend = pm_fm_suspend;
 	p->pm_resume  = pm_fm_resume;
@@ -401,16 +403,19 @@ static struct video_device poseidon_fm_template = {
 int poseidon_fm_init(struct poseidon *p)
 {
 	struct video_device *fm_dev;
+	int err;
 
 	fm_dev = vdev_init(p, &poseidon_fm_template);
 	if (fm_dev == NULL)
-		return -1;
+		return -ENOMEM;
 
-	if (video_register_device(fm_dev, VFL_TYPE_RADIO, -1) < 0) {
+	p->radio_data.fm_dev = fm_dev;
+	set_frequency(p, TUNER_FREQ_MIN_FM);
+	err = video_register_device(fm_dev, VFL_TYPE_RADIO, -1);
+	if (err < 0) {
 		video_device_release(fm_dev);
-		return -1;
+		return err;
 	}
-	p->radio_data.fm_dev = fm_dev;
 	return 0;
 }
 
-- 
1.7.10.4

