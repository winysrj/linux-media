Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:54575 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801Ab2BRQqQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Feb 2012 11:46:16 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] tea575x: fix HW seek
Date: Sat, 18 Feb 2012 17:45:45 +0100
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202181745.49819.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix HW seek in TEA575x to work properly:
 - a delay must be present after search start and before first register read
   or the seek does weird things
 - when the search stops, the new frequency is not available immediately, we
   must wait until it appears in the register (fortunately, we can clear the
   frequency bits when starting the search as it starts at the frequency
   currently set, not from the value written)
 - sometimes, seek remains on the current frequency (or moves only a little),
   so repeat it until it moves by at least 50 kHz

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -89,7 +89,7 @@ static void snd_tea575x_write(struct snd_tea575x *tea, unsigned int val)
 		tea->ops->set_pins(tea, 0);
 }
 
-static unsigned int snd_tea575x_read(struct snd_tea575x *tea)
+static u32 snd_tea575x_read(struct snd_tea575x *tea)
 {
 	u16 l, rdata;
 	u32 data = 0;
@@ -120,6 +120,27 @@ static unsigned int snd_tea575x_read(struct snd_tea575x *tea)
 	return data;
 }
 
+static void snd_tea575x_get_freq(struct snd_tea575x *tea)
+{
+	u32 freq = snd_tea575x_read(tea) & TEA575X_BIT_FREQ_MASK;
+
+	if (freq == 0) {
+		tea->freq = 0;
+		return;
+	}
+
+	/* freq *= 12.5 */
+	freq *= 125;
+	freq /= 10;
+	/* crystal fixup */
+	if (tea->tea5759)
+		freq += TEA575X_FMIF;
+	else
+		freq -= TEA575X_FMIF;
+
+	tea->freq = clamp(freq * 16, FREQ_LO, FREQ_HI); /* from kHz */
+}
+
 static void snd_tea575x_set_freq(struct snd_tea575x *tea)
 {
 	u32 freq = tea->freq;
@@ -203,6 +224,8 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	if (f->tuner != 0)
 		return -EINVAL;
 	f->type = V4L2_TUNER_RADIO;
+	if (!tea->cannot_read_data)
+		snd_tea575x_get_freq(tea);
 	f->frequency = tea->freq;
 	return 0;
 }
@@ -225,36 +248,50 @@ static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
 					struct v4l2_hw_freq_seek *a)
 {
 	struct snd_tea575x *tea = video_drvdata(file);
+	int i, old_freq;
+	unsigned long timeout;
 
 	if (tea->cannot_read_data)
 		return -ENOTTY;
+
+	snd_tea575x_get_freq(tea);
+	old_freq = tea->freq;
+	/* clear the frequency, HW will fill it in */
+	tea->val &= ~TEA575X_BIT_FREQ_MASK;
 	tea->val |= TEA575X_BIT_SEARCH;
-	tea->val &= ~TEA575X_BIT_UPDOWN;
 	if (a->seek_upward)
 		tea->val |= TEA575X_BIT_UPDOWN;
+	else
+		tea->val &= ~TEA575X_BIT_UPDOWN;
 	snd_tea575x_write(tea, tea->val);
+	timeout = jiffies + msecs_to_jiffies(10000);
 	for (;;) {
-		unsigned val = snd_tea575x_read(tea);
-
-		if (!(val & TEA575X_BIT_SEARCH)) {
-			/* Found a frequency */
-			val &= TEA575X_BIT_FREQ_MASK;
-			val = (val * 10) / 125;
-			if (tea->tea5759)
-				val += TEA575X_FMIF;
-			else
-				val -= TEA575X_FMIF;
-			tea->freq = clamp(val * 16, FREQ_LO, FREQ_HI);
-			return 0;
-		}
+		if (time_after(jiffies, timeout))
+			break;
 		if (schedule_timeout_interruptible(msecs_to_jiffies(10))) {
 			/* some signal arrived, stop search */
 			tea->val &= ~TEA575X_BIT_SEARCH;
 			snd_tea575x_write(tea, tea->val);
 			return -ERESTARTSYS;
 		}
+		if (!(snd_tea575x_read(tea) & TEA575X_BIT_SEARCH)) {
+			/* Found a frequency, wait until it can be read */
+			for (i = 0; i < 100; i++) {
+				msleep(10);
+				snd_tea575x_get_freq(tea);
+				if (tea->freq != 0) /* available */
+					break;
+			}
+			/* if we moved by less than 50 kHz, continue seeking */
+			if (abs(old_freq - tea->freq) < 16 * 500) {
+				snd_tea575x_write(tea, tea->val);
+				continue;
+			}
+			tea->val &= ~TEA575X_BIT_SEARCH;
+			return 0;
+		}
 	}
-	return 0;
+	return -ETIMEDOUT;
 }
 
 static int tea575x_s_ctrl(struct v4l2_ctrl *ctrl)
@@ -318,7 +355,7 @@ int snd_tea575x_init(struct snd_tea575x *tea)
 			return -ENODEV;
 	}
 
-	tea->val = TEA575X_BIT_BAND_FM | TEA575X_BIT_SEARCH_10_40;
+	tea->val = TEA575X_BIT_BAND_FM | TEA575X_BIT_SEARCH_5_28;
 	tea->freq = 90500 * 16;		/* 90.5Mhz default */
 	snd_tea575x_set_freq(tea);
 



-- 
Ondrej Zary
