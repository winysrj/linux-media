Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:62348 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab2INK6M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:58:12 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBq013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:57 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 21/31] v4l2: make vidioc_s_freq_hw_seek const.
Date: Fri, 14 Sep 2012 12:57:36 +0200
Message-Id: <34ac99718a6d3bae17c9ca3520d3089a16f5a9ec.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Write-only ioctls should have a const argument in the ioctl op.

Do this conversion for vidioc_s_freq_hw_seek.

Adding const for write-only ioctls was decided during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-mr800.c                |    2 +-
 drivers/media/radio/radio-tea5777.c              |   32 ++++++++++++----------
 drivers/media/radio/radio-wl1273.c               |    2 +-
 drivers/media/radio/si470x/radio-si470x-common.c |    4 +--
 drivers/media/radio/wl128x/fmdrv_v4l2.c          |    2 +-
 include/media/v4l2-ioctl.h                       |    2 +-
 sound/i2c/other/tea575x-tuner.c                  |    2 +-
 7 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 3182b26..720bf0d 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -348,7 +348,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_hw_freq_seek(struct file *file, void *priv,
-		struct v4l2_hw_freq_seek *seek)
+		const struct v4l2_hw_freq_seek *seek)
 {
 	static u8 buf[8] = {
 		0x3d, 0x32, 0x0f, 0x08, 0x3d, 0x32, 0x0f, 0x08
diff --git a/drivers/media/radio/radio-tea5777.c b/drivers/media/radio/radio-tea5777.c
index ef82898..c1a2ea6 100644
--- a/drivers/media/radio/radio-tea5777.c
+++ b/drivers/media/radio/radio-tea5777.c
@@ -385,59 +385,61 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
-					struct v4l2_hw_freq_seek *a)
+					const struct v4l2_hw_freq_seek *a)
 {
 	struct radio_tea5777 *tea = video_drvdata(file);
 	unsigned long timeout;
+	u32 rangelow = a->rangelow;
+	u32 rangehigh = a->rangehigh;
 	int i, res, spacing;
 	u32 orig_freq;
 
 	if (a->tuner || a->wrap_around)
 		return -EINVAL;
 
-	if (a->rangelow || a->rangehigh) {
+	if (rangelow || rangehigh) {
 		for (i = 0; i < ARRAY_SIZE(bands); i++) {
 			if (i == BAND_AM && !tea->has_am)
 				continue;
-			if (bands[i].rangelow  >= a->rangelow &&
-			    bands[i].rangehigh <= a->rangehigh)
+			if (bands[i].rangelow  >= rangelow &&
+			    bands[i].rangehigh <= rangehigh)
 				break;
 		}
 		if (i == ARRAY_SIZE(bands))
 			return -EINVAL; /* No matching band found */
 
 		tea->band = i;
-		if (tea->freq < a->rangelow || tea->freq > a->rangehigh) {
-			tea->freq = clamp(tea->freq, a->rangelow,
-						     a->rangehigh);
+		if (tea->freq < rangelow || tea->freq > rangehigh) {
+			tea->freq = clamp(tea->freq, rangelow,
+						     rangehigh);
 			res = radio_tea5777_set_freq(tea);
 			if (res)
 				return res;
 		}
 	} else {
-		a->rangelow  = bands[tea->band].rangelow;
-		a->rangehigh = bands[tea->band].rangehigh;
+		rangelow  = bands[tea->band].rangelow;
+		rangehigh = bands[tea->band].rangehigh;
 	}
 
 	spacing   = (tea->band == BAND_AM) ? (5 * 16) : (200 * 16); /* kHz */
 	orig_freq = tea->freq;
 
 	tea->write_reg |= TEA5777_W_PROGBLIM_MASK;
-	if (tea->seek_rangelow != a->rangelow) {
+	if (tea->seek_rangelow != rangelow) {
 		tea->write_reg &= ~TEA5777_W_UPDWN_MASK;
-		tea->freq = a->rangelow;
+		tea->freq = rangelow;
 		res = radio_tea5777_set_freq(tea);
 		if (res)
 			goto leave;
-		tea->seek_rangelow = a->rangelow;
+		tea->seek_rangelow = rangelow;
 	}
-	if (tea->seek_rangehigh != a->rangehigh) {
+	if (tea->seek_rangehigh != rangehigh) {
 		tea->write_reg |= TEA5777_W_UPDWN_MASK;
-		tea->freq = a->rangehigh;
+		tea->freq = rangehigh;
 		res = radio_tea5777_set_freq(tea);
 		if (res)
 			goto leave;
-		tea->seek_rangehigh = a->rangehigh;
+		tea->seek_rangehigh = rangehigh;
 	}
 	tea->write_reg &= ~TEA5777_W_PROGBLIM_MASK;
 
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index a22ad1c..71968a6 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1682,7 +1682,7 @@ static int wl1273_fm_vidioc_s_frequency(struct file *file, void *priv,
 #define WL1273_DEFAULT_SEEK_LEVEL	7
 
 static int wl1273_fm_vidioc_s_hw_freq_seek(struct file *file, void *priv,
-					   struct v4l2_hw_freq_seek *seek)
+					   const struct v4l2_hw_freq_seek *seek)
 {
 	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
 	struct wl1273_core *core = radio->core;
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 9bb65e1..74a5c90 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -296,7 +296,7 @@ int si470x_set_freq(struct si470x_device *radio, unsigned int freq)
  * si470x_set_seek - set seek
  */
 static int si470x_set_seek(struct si470x_device *radio,
-			   struct v4l2_hw_freq_seek *seek)
+			   const struct v4l2_hw_freq_seek *seek)
 {
 	int band, retval;
 	unsigned int freq;
@@ -701,7 +701,7 @@ static int si470x_vidioc_s_frequency(struct file *file, void *priv,
  * si470x_vidioc_s_hw_freq_seek - set hardware frequency seek
  */
 static int si470x_vidioc_s_hw_freq_seek(struct file *file, void *priv,
-		struct v4l2_hw_freq_seek *seek)
+		const struct v4l2_hw_freq_seek *seek)
 {
 	struct si470x_device *radio = video_drvdata(file);
 
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index db2248e..f816ea6 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -403,7 +403,7 @@ static int fm_v4l2_vidioc_s_freq(struct file *file, void *priv,
 
 /* Set hardware frequency seek. If current mode is NOT RX, set it RX. */
 static int fm_v4l2_vidioc_s_hw_freq_seek(struct file *file, void *priv,
-		struct v4l2_hw_freq_seek *seek)
+		const struct v4l2_hw_freq_seek *seek)
 {
 	struct fmdev *fmdev = video_drvdata(file);
 	int ret;
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 21f6245..865f95d 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -233,7 +233,7 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_log_status)       (struct file *file, void *fh);
 
 	int (*vidioc_s_hw_freq_seek)   (struct file *file, void *fh,
-					struct v4l2_hw_freq_seek *a);
+					const struct v4l2_hw_freq_seek *a);
 
 	/* Debugging ioctls */
 #ifdef CONFIG_VIDEO_ADV_DEBUG
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index cd79ed5..4a8fad6 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -357,7 +357,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
-					struct v4l2_hw_freq_seek *a)
+					const struct v4l2_hw_freq_seek *a)
 {
 	struct snd_tea575x *tea = video_drvdata(file);
 	unsigned long timeout;
-- 
1.7.10.4

