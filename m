Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:46322 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933083AbZHVSNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 14:13:53 -0400
From: =?utf-8?q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH, RESEND] Update ALSA capture controls according to selected source.
Date: Sat, 22 Aug 2009 20:13:51 +0200
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908222013.51493.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch introduces new snd_saa7134_capsrc_set (code taken from
snd_saa7134_capsrc_put) that updates also the ALSA capture controls during
snd_card_saa7134_capture_prepare and snd_saa7134_capsrc_put.

There can be much more work done in order to unify the control of the card
(now the card's capture source is tuned/switched in saa7134-video.c too), but
I don't have enough time. This work could be a starting point, but it can be
applied as-is too (it doesn't need any further work to make it working).

Signed-off-by: Oldřich Jedlička <oldium.pro@seznam.cz>

diff --git a/linux/drivers/media/video/saa7134/saa7134-alsa.c b/linux/drivers/media/video/saa7134/saa7134-alsa.c
index 504186a..0d9c833 100644
--- a/linux/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/linux/drivers/media/video/saa7134/saa7134-alsa.c
@@ -41,6 +41,7 @@ MODULE_PARM_DESC(debug,"enable debug messages [alsa]");
  */
 
 /* defaults */
+#define MIXER_ADDR_UNSELECTED	-1
 #define MIXER_ADDR_TVTUNER	0
 #define MIXER_ADDR_LINE1	1
 #define MIXER_ADDR_LINE2	2
@@ -69,7 +70,9 @@ typedef struct snd_card_saa7134 {
 	struct snd_card *card;
 	spinlock_t mixer_lock;
 	int mixer_volume[MIXER_ADDR_LAST+1][2];
-	int capture_source[MIXER_ADDR_LAST+1][2];
+	int capture_source_addr;
+	int capture_source[2];
+	struct snd_kcontrol *capture_ctl[MIXER_ADDR_LAST+1];
 	struct pci_dev *pci;
 	struct saa7134_dev *dev;
 
@@ -319,6 +322,115 @@ static int dsp_buffer_free(struct saa7134_dev *dev)
 	return 0;
 }
 
+/*
+ * Setting the capture source and updating the ALSA controls
+ */
+static int snd_saa7134_capsrc_set(struct snd_kcontrol *kcontrol,
+				  int left, int right, bool force_notify)
+{
+	snd_card_saa7134_t *chip = snd_kcontrol_chip(kcontrol);
+	int change = 0, addr = kcontrol->private_value;
+	int active, old_addr;
+	u32 anabar, xbarin;
+	int analog_io, rate;
+	struct saa7134_dev *dev;
+
+	dev = chip->dev;
+
+	spin_lock_irq(&chip->mixer_lock);
+
+	active = left != 0 || right != 0;
+	old_addr = chip->capture_source_addr;
+
+	/* The active capture source cannot be deactivated */
+	if (active) {
+		change = old_addr != addr ||
+			 chip->capture_source[0] != left ||
+			 chip->capture_source[1] != right;
+
+		chip->capture_source[0] = left;
+		chip->capture_source[1] = right;
+		chip->capture_source_addr = addr;
+		dev->dmasound.input = addr;
+	}
+	spin_unlock_irq(&chip->mixer_lock);
+
+	if (change) {
+		switch (dev->pci->device) {
+
+		case PCI_DEVICE_ID_PHILIPS_SAA7134:
+			switch (addr) {
+			case MIXER_ADDR_TVTUNER:
+				saa_andorb(SAA7134_AUDIO_FORMAT_CTRL,
+					   0xc0, 0xc0);
+				saa_andorb(SAA7134_SIF_SAMPLE_FREQ,
+					   0x03, 0x00);
+				break;
+			case MIXER_ADDR_LINE1:
+			case MIXER_ADDR_LINE2:
+				analog_io = (MIXER_ADDR_LINE1 == addr) ?
+					     0x00 : 0x08;
+				rate = (32000 == dev->dmasound.rate) ?
+					0x01 : 0x03;
+				saa_andorb(SAA7134_ANALOG_IO_SELECT,
+					   0x08, analog_io);
+				saa_andorb(SAA7134_AUDIO_FORMAT_CTRL,
+					   0xc0, 0x80);
+				saa_andorb(SAA7134_SIF_SAMPLE_FREQ,
+					   0x03, rate);
+				break;
+			}
+
+			break;
+		case PCI_DEVICE_ID_PHILIPS_SAA7133:
+		case PCI_DEVICE_ID_PHILIPS_SAA7135:
+			xbarin = 0x03; /* adc */
+			anabar = 0;
+			switch (addr) {
+			case MIXER_ADDR_TVTUNER:
+				xbarin = 0; /* Demodulator */
+				anabar = 2; /* DACs */
+				break;
+			case MIXER_ADDR_LINE1:
+				anabar = 0;  /* aux1, aux1 */
+				break;
+			case MIXER_ADDR_LINE2:
+				anabar = 9;  /* aux2, aux2 */
+				break;
+			}
+
+			/* output xbar always main channel */
+			saa_dsp_writel(dev, SAA7133_DIGITAL_OUTPUT_SEL1,
+				       0xbbbb10);
+
+			if (left || right) {
+				/* We've got data, turn the input on */
+				saa_dsp_writel(dev, SAA7133_DIGITAL_INPUT_XBAR1,
+					       xbarin);
+				saa_writel(SAA7133_ANALOG_IO_SELECT, anabar);
+			} else {
+				saa_dsp_writel(dev, SAA7133_DIGITAL_INPUT_XBAR1,
+					       0);
+				saa_writel(SAA7133_ANALOG_IO_SELECT, 0);
+			}
+			break;
+		}
+	}
+
+	if (change) {
+		if (force_notify)
+			snd_ctl_notify(chip->card,
+				       SNDRV_CTL_EVENT_MASK_VALUE,
+				       &chip->capture_ctl[addr]->id);
+
+		if (old_addr != MIXER_ADDR_UNSELECTED && old_addr != addr)
+			snd_ctl_notify(chip->card,
+				       SNDRV_CTL_EVENT_MASK_VALUE,
+				       &chip->capture_ctl[old_addr]->id);
+	}
+
+	return change;
+}
 
 /*
  * ALSA PCM preparation
@@ -406,6 +518,10 @@ static int snd_card_saa7134_capture_prepare(struct snd_pcm_substream * substream
 
 	dev->dmasound.rate = runtime->rate;
 
+	/* Setup and update the card/ALSA controls */
+	snd_saa7134_capsrc_set(saa7134->capture_ctl[dev->dmasound.input], 1, 1,
+			       true);
+
 	return 0;
 
 }
@@ -851,8 +967,13 @@ static int snd_saa7134_capsrc_get(struct snd_kcontrol * kcontrol,
 	int addr = kcontrol->private_value;
 
 	spin_lock_irq(&chip->mixer_lock);
-	ucontrol->value.integer.value[0] = chip->capture_source[addr][0];
-	ucontrol->value.integer.value[1] = chip->capture_source[addr][1];
+	if (chip->capture_source_addr == addr) {
+		ucontrol->value.integer.value[0] = chip->capture_source[0];
+		ucontrol->value.integer.value[1] = chip->capture_source[1];
+	} else {
+		ucontrol->value.integer.value[0] = 0;
+		ucontrol->value.integer.value[1] = 0;
+	}
 	spin_unlock_irq(&chip->mixer_lock);
 
 	return 0;
@@ -861,87 +982,22 @@ static int snd_saa7134_capsrc_get(struct snd_kcontrol * kcontrol,
 static int snd_saa7134_capsrc_put(struct snd_kcontrol * kcontrol,
 				  struct snd_ctl_elem_value * ucontrol)
 {
-	snd_card_saa7134_t *chip = snd_kcontrol_chip(kcontrol);
-	int change, addr = kcontrol->private_value;
 	int left, right;
-	u32 anabar, xbarin;
-	int analog_io, rate;
-	struct saa7134_dev *dev;
-
-	dev = chip->dev;
-
 	left = ucontrol->value.integer.value[0] & 1;
 	right = ucontrol->value.integer.value[1] & 1;
-	spin_lock_irq(&chip->mixer_lock);
 
-	change = chip->capture_source[addr][0] != left ||
-		 chip->capture_source[addr][1] != right;
-	chip->capture_source[addr][0] = left;
-	chip->capture_source[addr][1] = right;
-	dev->dmasound.input=addr;
-	spin_unlock_irq(&chip->mixer_lock);
-
-
-	if (change) {
-	  switch (dev->pci->device) {
-
-	   case PCI_DEVICE_ID_PHILIPS_SAA7134:
-		switch (addr) {
-			case MIXER_ADDR_TVTUNER:
-				saa_andorb(SAA7134_AUDIO_FORMAT_CTRL, 0xc0, 0xc0);
-				saa_andorb(SAA7134_SIF_SAMPLE_FREQ,   0x03, 0x00);
-				break;
-			case MIXER_ADDR_LINE1:
-			case MIXER_ADDR_LINE2:
-				analog_io = (MIXER_ADDR_LINE1 == addr) ? 0x00 : 0x08;
-				rate = (32000 == dev->dmasound.rate) ? 0x01 : 0x03;
-				saa_andorb(SAA7134_ANALOG_IO_SELECT,  0x08, analog_io);
-				saa_andorb(SAA7134_AUDIO_FORMAT_CTRL, 0xc0, 0x80);
-				saa_andorb(SAA7134_SIF_SAMPLE_FREQ,   0x03, rate);
-				break;
-		}
-
-		break;
-	   case PCI_DEVICE_ID_PHILIPS_SAA7133:
-	   case PCI_DEVICE_ID_PHILIPS_SAA7135:
-		xbarin = 0x03; // adc
-		anabar = 0;
-		switch (addr) {
-			case MIXER_ADDR_TVTUNER:
-				xbarin = 0; // Demodulator
-				anabar = 2; // DACs
-				break;
-			case MIXER_ADDR_LINE1:
-				anabar = 0;  // aux1, aux1
-				break;
-			case MIXER_ADDR_LINE2:
-				anabar = 9;  // aux2, aux2
-				break;
-		}
-
-		/* output xbar always main channel */
-		saa_dsp_writel(dev, SAA7133_DIGITAL_OUTPUT_SEL1, 0xbbbb10);
-
-		if (left || right) { // We've got data, turn the input on
-		  saa_dsp_writel(dev, SAA7133_DIGITAL_INPUT_XBAR1, xbarin);
-		  saa_writel(SAA7133_ANALOG_IO_SELECT, anabar);
-		} else {
-		  saa_dsp_writel(dev, SAA7133_DIGITAL_INPUT_XBAR1, 0);
-		  saa_writel(SAA7133_ANALOG_IO_SELECT, 0);
-		}
-		break;
-	  }
-	}
-
-	return change;
+	return snd_saa7134_capsrc_set(kcontrol, left, right, false);
 }
 
-static struct snd_kcontrol_new snd_saa7134_controls[] = {
+static struct snd_kcontrol_new snd_saa7134_volume_controls[] = {
 SAA713x_VOLUME("Video Volume", 0, MIXER_ADDR_TVTUNER),
-SAA713x_CAPSRC("Video Capture Switch", 0, MIXER_ADDR_TVTUNER),
 SAA713x_VOLUME("Line Volume", 1, MIXER_ADDR_LINE1),
-SAA713x_CAPSRC("Line Capture Switch", 1, MIXER_ADDR_LINE1),
 SAA713x_VOLUME("Line Volume", 2, MIXER_ADDR_LINE2),
+};
+
+static struct snd_kcontrol_new snd_saa7134_capture_controls[] = {
+SAA713x_CAPSRC("Video Capture Switch", 0, MIXER_ADDR_TVTUNER),
+SAA713x_CAPSRC("Line Capture Switch", 1, MIXER_ADDR_LINE1),
 SAA713x_CAPSRC("Line Capture Switch", 2, MIXER_ADDR_LINE2),
 };
 
@@ -956,17 +1012,33 @@ SAA713x_CAPSRC("Line Capture Switch", 2, MIXER_ADDR_LINE2),
 static int snd_card_saa7134_new_mixer(snd_card_saa7134_t * chip)
 {
 	struct snd_card *card = chip->card;
+	struct snd_kcontrol *kcontrol;
 	unsigned int idx;
-	int err;
+	int err, addr;
 
 	if (snd_BUG_ON(!chip))
 		return -EINVAL;
 	strcpy(card->mixername, "SAA7134 Mixer");
 
-	for (idx = 0; idx < ARRAY_SIZE(snd_saa7134_controls); idx++) {
-		if ((err = snd_ctl_add(card, snd_ctl_new1(&snd_saa7134_controls[idx], chip))) < 0)
+	for (idx = 0; idx < ARRAY_SIZE(snd_saa7134_volume_controls); idx++) {
+		kcontrol = snd_ctl_new1(&snd_saa7134_volume_controls[idx],
+					chip);
+		err = snd_ctl_add(card, kcontrol);
+		if (err < 0)
 			return err;
 	}
+
+	for (idx = 0; idx < ARRAY_SIZE(snd_saa7134_capture_controls); idx++) {
+		kcontrol = snd_ctl_new1(&snd_saa7134_capture_controls[idx],
+					chip);
+		addr = snd_saa7134_capture_controls[idx].private_value;
+		chip->capture_ctl[addr] = kcontrol;
+		err = snd_ctl_add(card, kcontrol);
+		if (err < 0)
+			return err;
+	}
+
+	chip->capture_source_addr = MIXER_ADDR_UNSELECTED;
 	return 0;
 }
 
