Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57248 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbeINXiT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 19:38:19 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/4] media: em28xx: fix handler for vidioc_s_input()
Date: Fri, 14 Sep 2018 15:22:31 -0300
Message-Id: <4e78ad314781de962caef8e1695c391c8a975612.1536949178.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1536949178.git.mchehab+samsung@kernel.org>
References: <cover.1536949178.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1536949178.git.mchehab+samsung@kernel.org>
References: <cover.1536949178.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The a->index is not the name of the internal amux entry,
but, instead a value from zero to the maximum number
of audio inputs.

As the actual available inputs depend on each board, build
it dynamically.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 29 +++++++++
 drivers/media/usb/em28xx/em28xx-video.c | 83 ++++++++++++++++++++++---
 drivers/media/usb/em28xx/em28xx.h       |  8 ++-
 3 files changed, 111 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 71c829f31d3b..e9ab1fbc8f0d 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3039,6 +3039,9 @@ static int em28xx_hint_board(struct em28xx *dev)
 
 static void em28xx_card_setup(struct em28xx *dev)
 {
+	int i, j, idx;
+	bool duplicate_entry;
+
 	/*
 	 * If the device can be a webcam, seek for a sensor.
 	 * If sensor is not found, then it isn't a webcam.
@@ -3195,6 +3198,32 @@ static void em28xx_card_setup(struct em28xx *dev)
 	/* Allow override tuner type by a module parameter */
 	if (tuner >= 0)
 		dev->tuner_type = tuner;
+
+	/*
+	 * Dynamically generate a list of valid audio inputs for this
+	 * specific board, mapping them via enum em28xx_amux.
+	 */
+
+	idx = 0;
+	for (i = 0; i < MAX_EM28XX_INPUT; i++) {
+		if (!INPUT(i)->type)
+			continue;
+
+		/* Skip already mapped audio inputs */
+		duplicate_entry = false;
+		for (j = 0; j < idx; j++) {
+			if (INPUT(i)->amux == dev->amux_map[j]) {
+				duplicate_entry = true;
+				break;
+			}
+		}
+		if (duplicate_entry)
+			continue;
+
+		dev->amux_map[idx++] = INPUT(i)->amux;
+	}
+	for (;idx < MAX_EM28XX_INPUT; idx++)
+		dev->amux_map[idx] = EM28XX_AMUX_UNUSED;
 }
 
 void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl)
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 917602954bfb..fcb5c1b25ab3 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1666,6 +1666,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 {
 	struct em28xx *dev = video_drvdata(file);
 	unsigned int       n;
+	int j;
 
 	n = i->index;
 	if (n >= MAX_EM28XX_INPUT)
@@ -1685,6 +1686,12 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	if (dev->is_webcam)
 		i->capabilities = 0;
 
+	/* Dynamically generates an audioset bitmask */
+	i->audioset = 0;
+	for (j = 0; j < MAX_EM28XX_INPUT; j++)
+		if (dev->amux_map[j] != EM28XX_AMUX_UNUSED)
+			i->audioset |= 1 << j;
+
 	return 0;
 }
 
@@ -1710,11 +1717,25 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
+
+static int em28xx_fill_audio_input(struct em28xx *dev,
+				   const char *s,
+				   struct v4l2_audio *a,
+				   unsigned index)
 {
-	struct em28xx *dev = video_drvdata(file);
+	unsigned int idx = dev->amux_map[index];
 
-	switch (a->index) {
+	/*
+	 * With msp3400, almost all mappings use the default (amux = 0).
+	 * The only one may use a different value is WinTV USB2, where it
+	 * can also be SCART1 input.
+	 * As it is very doubtful that we would see new boards with msp3400,
+	 * let's just reuse the existing switch.
+	 */
+	if (dev->has_msp34xx && idx != EM28XX_AMUX_UNUSED)
+		idx = EM28XX_AMUX_LINE_IN;
+
+	switch (idx) {
 	case EM28XX_AMUX_VIDEO:
 		strscpy(a->name, "Television", sizeof(a->name));
 		break;
@@ -1739,32 +1760,77 @@ static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 	case EM28XX_AMUX_PCM_OUT:
 		strscpy(a->name, "PCM", sizeof(a->name));
 		break;
+	case EM28XX_AMUX_UNUSED:
 	default:
 		return -EINVAL;
 	}
-
-	a->index = dev->ctl_ainput;
+	a->index = index;
 	a->capability = V4L2_AUDCAP_STEREO;
 
+	em28xx_videodbg("%s: audio input index %d is '%s'\n", s, a->index, a->name);
+
 	return 0;
 }
 
+static int vidioc_enumaudio(struct file *file, void *fh, struct v4l2_audio *a)
+{
+	struct em28xx *dev = video_drvdata(file);
+
+	if (a->index >= MAX_EM28XX_INPUT)
+		return -EINVAL;
+
+	return em28xx_fill_audio_input(dev, __func__,a, a->index);
+}
+
+static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
+{
+	struct em28xx *dev = video_drvdata(file);
+	int i;
+
+	for (i = 0; i < MAX_EM28XX_INPUT; i++)
+		if (dev->ctl_ainput == dev->amux_map[i])
+			return em28xx_fill_audio_input(dev, __func__, a, i);
+
+	/* Should never happen! */
+	return -EINVAL;
+}
+
 static int vidioc_s_audio(struct file *file, void *priv,
 			  const struct v4l2_audio *a)
 {
 	struct em28xx *dev = video_drvdata(file);
+	int idx, i;
 
 	if (a->index >= MAX_EM28XX_INPUT)
 		return -EINVAL;
-	if (!INPUT(a->index)->type)
+
+	idx = dev->amux_map[a->index];
+
+	if (idx == EM28XX_AMUX_UNUSED)
+		return -EINVAL;
+
+	dev->ctl_ainput = idx;
+
+	/*
+	 * FIXME: This is wrong, as different inputs at em28xx_cards
+	 * may have different audio outputs. So, the right thing
+	 * to do is to implement VIDIOC_G_AUDOUT/VIDIOC_S_AUDOUT.
+	 * With the current board definitions, this would work fine,
+	 * as, currently, all boards fit.
+	 */
+	for (i = 0; i < MAX_EM28XX_INPUT; i++)
+		if (idx == dev->amux_map[i])
+			break;
+	if (i == MAX_EM28XX_INPUT)
 		return -EINVAL;
 
-	dev->ctl_ainput = INPUT(a->index)->amux;
-	dev->ctl_aoutput = INPUT(a->index)->aout;
+	dev->ctl_aoutput = INPUT(i)->aout;
 
 	if (!dev->ctl_aoutput)
 		dev->ctl_aoutput = EM28XX_AOUT_MASTER;
 
+	em28xx_videodbg("%s: set audio input to %d\n", __func__, dev->ctl_ainput);
+
 	return 0;
 }
 
@@ -2302,6 +2368,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_try_fmt_vbi_cap     = vidioc_g_fmt_vbi_cap,
 	.vidioc_s_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
 	.vidioc_enum_framesizes     = vidioc_enum_framesizes,
+	.vidioc_enumaudio           = vidioc_enumaudio,
 	.vidioc_g_audio             = vidioc_g_audio,
 	.vidioc_s_audio             = vidioc_s_audio,
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 953caac025f2..a551072e62ed 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -335,6 +335,9 @@ enum em28xx_usb_audio_type {
 /**
  * em28xx_amux - describes the type of audio input used by em28xx
  *
+ * @EM28XX_AMUX_UNUSED:
+ *	Used only on em28xx dev->map field, in order to mark an entry
+ *	as unused.
  * @EM28XX_AMUX_VIDEO:
  *	On devices without AC97, this is the only value that it is currently
  *	allowed.
@@ -369,7 +372,8 @@ enum em28xx_usb_audio_type {
  * same time, via the alsa mux.
  */
 enum em28xx_amux {
-	EM28XX_AMUX_VIDEO,
+	EM28XX_AMUX_UNUSED = -1,
+	EM28XX_AMUX_VIDEO = 0,
 	EM28XX_AMUX_LINE_IN,
 
 	/* Some less-common mixer setups */
@@ -692,6 +696,8 @@ struct em28xx {
 	unsigned int ctl_input;	// selected input
 	unsigned int ctl_ainput;// selected audio input
 	unsigned int ctl_aoutput;// selected audio output
+	enum em28xx_amux amux_map[MAX_EM28XX_INPUT];
+
 	int mute;
 	int volume;
 
-- 
2.17.1
