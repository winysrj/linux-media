Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:44300 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440AbbAOULA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2015 15:11:00 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/3] tea575x: split and export functions
Date: Thu, 15 Jan 2015 21:10:46 +0100
Message-Id: <1421352647-10383-2-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1421352647-10383-1-git-send-email-linux@rainbow-software.org>
References: <1421352647-10383-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Split ioctl interface from enum_freq_bands, g_tuner and s_hw_freq_seek
functions and export them to be used in other drivers like bttv.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/radio/tea575x.c |   41 ++++++++++++++++++++++++++++++++---------
 include/media/tea575x.h       |    5 +++++
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/media/radio/tea575x.c b/drivers/media/radio/tea575x.c
index f1a0867..43d1ea5 100644
--- a/drivers/media/radio/tea575x.c
+++ b/drivers/media/radio/tea575x.c
@@ -247,10 +247,9 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	return 0;
 }
 
-static int vidioc_enum_freq_bands(struct file *file, void *priv,
-					 struct v4l2_frequency_band *band)
+int snd_tea575x_enum_freq_bands(struct snd_tea575x *tea,
+					struct v4l2_frequency_band *band)
 {
-	struct snd_tea575x *tea = video_drvdata(file);
 	int index;
 
 	if (band->tuner != 0)
@@ -279,18 +278,25 @@ static int vidioc_enum_freq_bands(struct file *file, void *priv,
 
 	return 0;
 }
+EXPORT_SYMBOL(snd_tea575x_enum_freq_bands);
 
-static int vidioc_g_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *v)
+static int vidioc_enum_freq_bands(struct file *file, void *priv,
+					 struct v4l2_frequency_band *band)
 {
 	struct snd_tea575x *tea = video_drvdata(file);
+
+	return snd_tea575x_enum_freq_bands(tea, band);
+}
+
+int snd_tea575x_g_tuner(struct snd_tea575x *tea, struct v4l2_tuner *v)
+{
 	struct v4l2_frequency_band band_fm = { 0, };
 
 	if (v->index > 0)
 		return -EINVAL;
 
 	snd_tea575x_read(tea);
-	vidioc_enum_freq_bands(file, priv, &band_fm);
+	snd_tea575x_enum_freq_bands(tea, &band_fm);
 
 	memset(v, 0, sizeof(*v));
 	strlcpy(v->name, tea->has_am ? "FM/AM" : "FM", sizeof(v->name));
@@ -304,6 +310,15 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	v->signal = tea->tuned ? 0xffff : 0;
 	return 0;
 }
+EXPORT_SYMBOL(snd_tea575x_g_tuner);
+
+static int vidioc_g_tuner(struct file *file, void *priv,
+					struct v4l2_tuner *v)
+{
+	struct snd_tea575x *tea = video_drvdata(file);
+
+	return snd_tea575x_g_tuner(tea, v);
+}
 
 static int vidioc_s_tuner(struct file *file, void *priv,
 					const struct v4l2_tuner *v)
@@ -356,10 +371,9 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
-					const struct v4l2_hw_freq_seek *a)
+int snd_tea575x_s_hw_freq_seek(struct file *file, struct snd_tea575x *tea,
+				const struct v4l2_hw_freq_seek *a)
 {
-	struct snd_tea575x *tea = video_drvdata(file);
 	unsigned long timeout;
 	int i, spacing;
 
@@ -442,6 +456,15 @@ static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
 	snd_tea575x_set_freq(tea);
 	return -ENODATA;
 }
+EXPORT_SYMBOL(snd_tea575x_s_hw_freq_seek);
+
+static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
+					const struct v4l2_hw_freq_seek *a)
+{
+	struct snd_tea575x *tea = video_drvdata(file);
+
+	return snd_tea575x_s_hw_freq_seek(file, tea, a);
+}
 
 static int tea575x_s_ctrl(struct v4l2_ctrl *ctrl)
 {
diff --git a/include/media/tea575x.h b/include/media/tea575x.h
index 2d4fa59..5d09657 100644
--- a/include/media/tea575x.h
+++ b/include/media/tea575x.h
@@ -71,6 +71,11 @@ struct snd_tea575x {
 	int (*ext_init)(struct snd_tea575x *tea);
 };
 
+int snd_tea575x_enum_freq_bands(struct snd_tea575x *tea,
+					struct v4l2_frequency_band *band);
+int snd_tea575x_g_tuner(struct snd_tea575x *tea, struct v4l2_tuner *v);
+int snd_tea575x_s_hw_freq_seek(struct file *file, struct snd_tea575x *tea,
+				const struct v4l2_hw_freq_seek *a);
 int snd_tea575x_hw_init(struct snd_tea575x *tea);
 int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner);
 void snd_tea575x_exit(struct snd_tea575x *tea);
-- 
Ondrej Zary

