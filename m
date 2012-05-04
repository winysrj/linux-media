Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3210 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2EDNan (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 09:30:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
	Tobias Lorenz <tobias.lorenz@gmx.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/4] radio-si470x-common.c: remove unnecessary kernel log spam.
Date: Fri,  4 May 2012 15:30:31 +0200
Message-Id: <6bc768e0c1d1664d96f8a051324c9fc1ef71ff8c.1336137768.git.hans.verkuil@cisco.com>
In-Reply-To: <1336138232-17528-1-git-send-email-hverkuil@xs4all.nl>
References: <1336138232-17528-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <e9c50530e84fcff80f9928f679eb1d02ba8c349d.1336137768.git.hans.verkuil@cisco.com>
References: <e9c50530e84fcff80f9928f679eb1d02ba8c349d.1336137768.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There is no need to report an error in the log, you are already returning
that error to userspace after all.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/si470x/radio-si470x-common.c |   78 +++++-----------------
 1 file changed, 17 insertions(+), 61 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index e70badf..b9a44d4 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -327,7 +327,7 @@ static int si470x_set_seek(struct si470x_device *radio,
 		radio->registers[POWERCFG] &= ~POWERCFG_SEEKUP;
 	retval = si470x_set_register(radio, POWERCFG);
 	if (retval < 0)
-		goto done;
+		return retval;
 
 	/* currently I2C driver only uses interrupt way to seek */
 	if (radio->stci_enabled) {
@@ -355,20 +355,15 @@ static int si470x_set_seek(struct si470x_device *radio,
 	if (radio->registers[STATUSRSSI] & STATUSRSSI_SF)
 		dev_warn(&radio->videodev.dev,
 			"seek failed / band limit reached\n");
-	if (timed_out)
-		dev_warn(&radio->videodev.dev,
-			"seek timed out after %u ms\n", seek_timeout);
 
 stop:
 	/* stop seeking */
 	radio->registers[POWERCFG] &= ~POWERCFG_SEEK;
 	retval = si470x_set_register(radio, POWERCFG);
 
-done:
 	/* try again, if timed out */
-	if ((retval == 0) && timed_out)
-		retval = -EAGAIN;
-
+	if (retval == 0 && timed_out)
+		return -EAGAIN;
 	return retval;
 }
 
@@ -589,16 +584,14 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 		struct v4l2_tuner *tuner)
 {
 	struct si470x_device *radio = video_drvdata(file);
-	int retval = 0;
+	int retval;
 
-	if (tuner->index != 0) {
-		retval = -EINVAL;
-		goto done;
-	}
+	if (tuner->index != 0)
+		return -EINVAL;
 
 	retval = si470x_get_register(radio, STATUSRSSI);
 	if (retval < 0)
-		goto done;
+		return retval;
 
 	/* driver constants */
 	strcpy(tuner->name, "FM");
@@ -653,10 +646,6 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 	/* AFCRL does only indicate that freq. differs, not if too low/high */
 	tuner->afc = (radio->registers[STATUSRSSI] & STATUSRSSI_AFCRL) ? 1 : 0;
 
-done:
-	if (retval < 0)
-		dev_warn(&radio->videodev.dev,
-			"get tuner failed with %d\n", retval);
 	return retval;
 }
 
@@ -668,7 +657,6 @@ static int si470x_vidioc_s_tuner(struct file *file, void *priv,
 		struct v4l2_tuner *tuner)
 {
 	struct si470x_device *radio = video_drvdata(file);
-	int retval = 0;
 
 	if (tuner->index != 0)
 		return -EINVAL;
@@ -684,12 +672,7 @@ static int si470x_vidioc_s_tuner(struct file *file, void *priv,
 		break;
 	}
 
-	retval = si470x_set_register(radio, POWERCFG);
-
-	if (retval < 0)
-		dev_warn(&radio->videodev.dev,
-			"set tuner failed with %d\n", retval);
-	return retval;
+	return si470x_set_register(radio, POWERCFG);
 }
 
 
@@ -700,21 +683,12 @@ static int si470x_vidioc_g_frequency(struct file *file, void *priv,
 		struct v4l2_frequency *freq)
 {
 	struct si470x_device *radio = video_drvdata(file);
-	int retval = 0;
 
-	if (freq->tuner != 0) {
-		retval = -EINVAL;
-		goto done;
-	}
+	if (freq->tuner != 0)
+		return -EINVAL;
 
 	freq->type = V4L2_TUNER_RADIO;
-	retval = si470x_get_freq(radio, &freq->frequency);
-
-done:
-	if (retval < 0)
-		dev_warn(&radio->videodev.dev,
-			"get frequency failed with %d\n", retval);
-	return retval;
+	return si470x_get_freq(radio, &freq->frequency);
 }
 
 
@@ -725,20 +699,11 @@ static int si470x_vidioc_s_frequency(struct file *file, void *priv,
 		struct v4l2_frequency *freq)
 {
 	struct si470x_device *radio = video_drvdata(file);
-	int retval = 0;
-
-	if (freq->tuner != 0) {
-		retval = -EINVAL;
-		goto done;
-	}
 
-	retval = si470x_set_freq(radio, freq->frequency);
+	if (freq->tuner != 0)
+		return -EINVAL;
 
-done:
-	if (retval < 0)
-		dev_warn(&radio->videodev.dev,
-			"set frequency failed with %d\n", retval);
-	return retval;
+	return si470x_set_freq(radio, freq->frequency);
 }
 
 
@@ -749,20 +714,11 @@ static int si470x_vidioc_s_hw_freq_seek(struct file *file, void *priv,
 		struct v4l2_hw_freq_seek *seek)
 {
 	struct si470x_device *radio = video_drvdata(file);
-	int retval = 0;
-
-	if (seek->tuner != 0) {
-		retval = -EINVAL;
-		goto done;
-	}
 
-	retval = si470x_set_seek(radio, seek->wrap_around, seek->seek_upward);
+	if (seek->tuner != 0)
+		return -EINVAL;
 
-done:
-	if (retval < 0)
-		dev_warn(&radio->videodev.dev,
-			"set hardware frequency seek failed with %d\n", retval);
-	return retval;
+	return si470x_set_seek(radio, seek->wrap_around, seek->seek_upward);
 }
 
 const struct v4l2_ctrl_ops si470x_ctrl_ops = {
-- 
1.7.10

