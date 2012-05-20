Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab2ETBVf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 21:21:35 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ondrej Zary <linux@rainbow-software.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6/6] snd_tea575x: Add support for tuning AM
Date: Sun, 20 May 2012 03:25:31 +0200
Message-Id: <1337477131-21578-7-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
References: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
CC: Ondrej Zary <linux@rainbow-software.org>
---
 include/sound/tea575x-tuner.h   |    3 +
 sound/i2c/other/tea575x-tuner.c |  164 ++++++++++++++++++++++++++++-----------
 2 files changed, 121 insertions(+), 46 deletions(-)

diff --git a/include/sound/tea575x-tuner.h b/include/sound/tea575x-tuner.h
index fe8590c..602bddc 100644
--- a/include/sound/tea575x-tuner.h
+++ b/include/sound/tea575x-tuner.h
@@ -28,6 +28,7 @@
 #include <media/v4l2-device.h>
 
 #define TEA575X_FMIF	10700
+#define TEA575X_AMIF	  450
 
 #define TEA575X_DATA	(1 << 0)
 #define TEA575X_CLK	(1 << 1)
@@ -52,12 +53,14 @@ struct snd_tea575x {
 	struct video_device vd;		/* video device */
 	int radio_nr;			/* radio_nr */
 	bool tea5759;			/* 5759 chip is present */
+	bool has_am;			/* Device can tune to AM freqs */
 	bool cannot_read_data;		/* Device cannot read the data pin */
 	bool cannot_mute;		/* Device cannot mute */
 	bool mute;			/* Device is muted? */
 	bool stereo;			/* receiving stereo */
 	bool tuned;			/* tuned to a station */
 	unsigned int val;		/* hw value */
+	u32 tuner;			/* 0 == FM tuner, 1 == AM tuner */
 	u32 freq;			/* frequency */
 	struct mutex mutex;
 	struct snd_tea575x_ops *ops;
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index d16f7b7..90e06e9 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -37,8 +37,15 @@ MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
 MODULE_DESCRIPTION("Routines for control of TEA5757/5759 Philips AM/FM radio tuner chips");
 MODULE_LICENSE("GPL");
 
-#define FREQ_LO		((tea->tea5759 ? 760 :  875) * 1600U)
-#define FREQ_HI		((tea->tea5759 ? 910 : 1080) * 1600U)
+#define FM_FREQ_LO		((tea->tea5759 ? 760 :  875) * 1600U)
+#define FM_FREQ_HI		((tea->tea5759 ? 910 : 1080) * 1600U)
+/* These are based on what the Griffin radioSHARK can do */
+#define AM_FREQ_LO		( 530 * 16U)
+#define AM_FREQ_HI		(1710 * 16U)
+
+#define TUNER_FM 0
+#define TUNER_AM 1
+#define TUNER_MAX (tea->has_am ? TUNER_AM : TUNER_FM)
 
 /*
  * definitions
@@ -50,8 +57,8 @@ MODULE_LICENSE("GPL");
 #define TEA575X_BIT_BAND_MASK	(3<<20)
 #define TEA575X_BIT_BAND_FM	(0<<20)
 #define TEA575X_BIT_BAND_MW	(1<<20)
-#define TEA575X_BIT_BAND_LW	(1<<21)
-#define TEA575X_BIT_BAND_SW	(1<<22)
+#define TEA575X_BIT_BAND_LW	(2<<20)
+#define TEA575X_BIT_BAND_SW	(3<<20)
 #define TEA575X_BIT_PORT_0	(1<<19)		/* user bit */
 #define TEA575X_BIT_PORT_1	(1<<18)		/* user bit */
 #define TEA575X_BIT_SEARCH_MASK	(3<<16)		/* search level */
@@ -133,16 +140,25 @@ static u32 snd_tea575x_val_to_freq(struct snd_tea575x *tea, u32 val)
 	if (freq == 0)
 		return freq;
 
-	/* freq *= 12.5 */
-	freq *= 125;
-	freq /= 10;
-	/* crystal fixup */
-	if (tea->tea5759)
-		freq += TEA575X_FMIF;
-	else
-		freq -= TEA575X_FMIF;
+	switch(tea->tuner) {
+	case TUNER_FM:
+		/* freq *= 12.5 */
+		freq *= 125;
+		freq /= 10;
+		/* crystal fixup */
+		if (tea->tea5759)
+			freq += TEA575X_FMIF;
+		else
+			freq -= TEA575X_FMIF;
+
+		return clamp(freq * 16, FM_FREQ_LO, FM_FREQ_HI); /* from kHz */
+	case TUNER_AM:
+		/* crystal fixup */
+		freq -= TEA575X_AMIF;
+		return clamp(freq * 16, AM_FREQ_LO, AM_FREQ_HI); /* from kHz */
+	}
 
-	return clamp(freq * 16, FREQ_LO, FREQ_HI); /* from kHz */
+	return 0; /* Never reached */
 }
 
 static u32 snd_tea575x_get_freq(struct snd_tea575x *tea)
@@ -154,16 +170,30 @@ static void snd_tea575x_set_freq(struct snd_tea575x *tea)
 {
 	u32 freq = tea->freq;
 
-	freq /= 16;		/* to kHz */
-	/* crystal fixup */
-	if (tea->tea5759)
-		freq -= TEA575X_FMIF;
-	else
-		freq += TEA575X_FMIF;
-	/* freq /= 12.5 */
-	freq *= 10;
-	freq /= 125;
-
+	switch(tea->tuner) {
+	case TUNER_FM:
+		freq = clamp(freq, FM_FREQ_LO, FM_FREQ_HI) / 16; /* to kHz */
+		/* crystal fixup */
+		if (tea->tea5759)
+			freq -= TEA575X_FMIF;
+		else
+			freq += TEA575X_FMIF;
+		/* freq /= 12.5 */
+		freq *= 10;
+		freq /= 125;
+
+		tea->val &= ~TEA575X_BIT_BAND_MASK;
+		tea->val |= TEA575X_BIT_BAND_FM;
+		break;
+	case TUNER_AM:
+		freq = clamp(freq, AM_FREQ_LO, AM_FREQ_HI) / 16; /* to kHz */
+		/* crystal fixup */
+		freq += TEA575X_AMIF;
+
+		tea->val &= ~TEA575X_BIT_BAND_MASK;
+		tea->val |= TEA575X_BIT_BAND_MW;
+		break;
+	}
 	tea->val &= ~TEA575X_BIT_FREQ_MASK;
 	tea->val |= freq & TEA575X_BIT_FREQ_MASK;
 	snd_tea575x_write(tea, tea->val);
@@ -194,21 +224,39 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 					struct v4l2_tuner *v)
 {
 	struct snd_tea575x *tea = video_drvdata(file);
+	u32 tuner = v->index;
 
-	if (v->index > 0)
+	if (tuner > TUNER_MAX)
 		return -EINVAL;
 
 	snd_tea575x_read(tea);
 
-	strcpy(v->name, "FM");
+	memset(v, 0, sizeof(*v));
+	v->index = tuner;
 	v->type = V4L2_TUNER_RADIO;
-	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
-	v->rangelow = FREQ_LO;
-	v->rangehigh = FREQ_HI;
-	v->rxsubchans = tea->stereo ? V4L2_TUNER_SUB_STEREO : V4L2_TUNER_SUB_MONO;
-	v->audmode = (tea->val & TEA575X_BIT_MONO) ?
-		V4L2_TUNER_MODE_MONO : V4L2_TUNER_MODE_STEREO;
-	v->signal = tea->tuned ? 0xffff : 0;
+	v->signal = (tuner == tea->tuner && tea->tuned) ? 0xffff : 0;
+	v->capability = V4L2_TUNER_CAP_LOW;
+
+	switch (tuner) {
+	case TUNER_FM:
+		strcpy(v->name, "FM");
+		v->capability |= V4L2_TUNER_CAP_STEREO;
+		v->rangelow = FM_FREQ_LO;
+		v->rangehigh = FM_FREQ_HI;
+		v->rxsubchans = tea->stereo ? V4L2_TUNER_SUB_STEREO :
+					      V4L2_TUNER_SUB_MONO;
+		v->audmode = (tea->val & TEA575X_BIT_MONO) ?
+			V4L2_TUNER_MODE_MONO : V4L2_TUNER_MODE_STEREO;
+		break;
+	case TUNER_AM:
+		strcpy(v->name, "AM");
+		v->rangelow = AM_FREQ_LO;
+		v->rangehigh = AM_FREQ_HI;
+		v->rxsubchans = V4L2_TUNER_SUB_MONO;
+		v->audmode = V4L2_TUNER_MODE_MONO;
+		break;
+	}
+
 	return 0;
 }
 
@@ -216,13 +264,26 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 					struct v4l2_tuner *v)
 {
 	struct snd_tea575x *tea = video_drvdata(file);
+	u32 orig_val = tea->val;
 
-	if (v->index)
+	if (v->index > TUNER_MAX)
 		return -EINVAL;
-	tea->val &= ~TEA575X_BIT_MONO;
-	if (v->audmode == V4L2_TUNER_MODE_MONO)
-		tea->val |= TEA575X_BIT_MONO;
-	snd_tea575x_write(tea, tea->val);
+
+	switch (v->index) {
+	case TUNER_FM:
+		tea->val &= ~TEA575X_BIT_MONO;
+		if (v->audmode == V4L2_TUNER_MODE_MONO)
+			tea->val |= TEA575X_BIT_MONO;
+
+		/* Only apply changes if currently tuning FM */
+		if (tea->tuner == TUNER_FM && tea->val != orig_val)
+			snd_tea575x_set_freq(tea);
+		break;
+	case TUNER_AM:
+		/* There are no modifiable settings on the AM tuner */
+		break;
+	}
+
 	return 0;
 }
 
@@ -231,8 +292,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 {
 	struct snd_tea575x *tea = video_drvdata(file);
 
-	if (f->tuner != 0)
-		return -EINVAL;
+	f->tuner = tea->tuner;
 	f->type = V4L2_TUNER_RADIO;
 	f->frequency = tea->freq;
 	return 0;
@@ -243,11 +303,12 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 {
 	struct snd_tea575x *tea = video_drvdata(file);
 
-	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
+	if (f->tuner > TUNER_MAX || f->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
 
 	tea->val &= ~TEA575X_BIT_SEARCH;
-	tea->freq = clamp(f->frequency, FREQ_LO, FREQ_HI);
+	tea->tuner = f->tuner;
+	tea->freq  = f->frequency;
 	snd_tea575x_set_freq(tea);
 	return 0;
 }
@@ -257,12 +318,23 @@ static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
 {
 	struct snd_tea575x *tea = video_drvdata(file);
 	unsigned long timeout;
-	int i;
+	int i, spacing;
 
 	if (tea->cannot_read_data)
 		return -ENOTTY;
-	if (a->tuner || a->wrap_around)
+	if (a->tuner > TUNER_MAX || a->wrap_around)
 		return -EINVAL;
+        if (a->tuner != tea->tuner)
+		return -EBUSY;
+
+        switch (tea->tuner) {
+        case TUNER_FM:
+                spacing = 50; /* kHz */
+                break;
+        case TUNER_AM:
+                spacing = 5; /* kHz */
+                break;
+        }
 
 	/* clear the frequency, HW will fill it in */
 	tea->val &= ~TEA575X_BIT_FREQ_MASK;
@@ -295,10 +367,10 @@ static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
 			if (freq == 0) /* shouldn't happen */
 				break;
 			/*
-			 * if we moved by less than 50 kHz, or in the wrong
-			 * direction, continue seeking
+			 * if we moved by less than the spacing, or in the
+			 * wrong direction, continue seeking
 			 */
-			if (abs(tea->freq - freq) < 16 * 50 ||
+			if (abs(tea->freq - freq) < 16 * spacing ||
 					(a->seek_upward && freq < tea->freq) ||
 					(!a->seek_upward && freq > tea->freq)) {
 				snd_tea575x_write(tea, tea->val);
-- 
1.7.10

