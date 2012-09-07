Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1262 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab2IGN3j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 18/28] v4l2: make vidioc_s_freq_hw_seek const.
Date: Fri,  7 Sep 2012 15:29:18 +0200
Message-Id: <b61f6cfe38e7218a6ac90d85e01eec4a3eb90e7c.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Write-only ioctls should have a const argument in the ioctl op.

Do this conversion for vidioc_s_freq_hw_seek.

Adding const for write-only ioctls was decided during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-mr800.c                |    2 +-
 drivers/media/radio/radio-tea5777.c              |    2 +-
 drivers/media/radio/radio-wl1273.c               |    2 +-
 drivers/media/radio/si470x/radio-si470x-common.c |    4 ++--
 drivers/media/radio/wl128x/fmdrv_v4l2.c          |    2 +-
 include/media/v4l2-ioctl.h                       |    2 +-
 sound/i2c/other/tea575x-tuner.c                  |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

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
index 5bc9fa6..82a1617 100644
--- a/drivers/media/radio/radio-tea5777.c
+++ b/drivers/media/radio/radio-tea5777.c
@@ -303,7 +303,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
-					struct v4l2_hw_freq_seek *a)
+					const struct v4l2_hw_freq_seek *a)
 {
 	struct radio_tea5777 *tea = video_drvdata(file);
 	u32 orig_freq = tea->freq;
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
index d14edb7..59cebe2 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -255,7 +255,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 }
 
 static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
-					struct v4l2_hw_freq_seek *a)
+					const struct v4l2_hw_freq_seek *a)
 {
 	struct snd_tea575x *tea = video_drvdata(file);
 	unsigned long timeout;
-- 
1.7.10.4

