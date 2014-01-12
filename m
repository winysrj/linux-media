Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaALRbL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 12:31:11 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] em28xx-audio: split URB initialization code
Date: Sun, 12 Jan 2014 11:52:34 -0200
Message-Id: <1389534755-19462-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The URB calculus code may eventually be moved to some other
place, like at pcm open, if it ends by needing more setups, like
working with different bit rates, or different audio latency.

So, move it into a separate routine. That also makes the code
more readable.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 145 +++++++++++++++++---------------
 1 file changed, 76 insertions(+), 69 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index f004680219e7..13ba631130cd 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -681,75 +681,14 @@ static int em28xx_audio_ep_packet_size(struct usb_device *udev,
 	return size & 0x7ff;
 }
 
-static int em28xx_audio_init(struct em28xx *dev)
+static int em28xx_audio_urb_init(struct em28xx *dev)
 {
-	struct em28xx_audio *adev = &dev->adev;
-	struct snd_pcm      *pcm;
-	struct snd_card     *card;
 	struct usb_interface *intf;
 	struct usb_endpoint_descriptor *e, *ep = NULL;
-	static int          devnr;
-	int                 err, i, ep_size, interval, num_urb, npackets;
+	int                 i, ep_size, interval, num_urb, npackets;
 	int		    urb_size, bytes_per_transfer;
 	u8 alt;
 
-	if (!dev->has_alsa_audio || dev->audio_ifnum < 0) {
-		/* This device does not support the extension (in this case
-		   the device is expecting the snd-usb-audio module or
-		   doesn't have analog audio support at all) */
-		return 0;
-	}
-
-	em28xx_info("Binding audio extension\n");
-
-	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2006 Markus "
-			 "Rechberger\n");
-	printk(KERN_INFO
-	       "em28xx-audio.c: Copyright (C) 2007-2014 Mauro Carvalho Chehab\n");
-
-	err = snd_card_create(index[devnr], "Em28xx Audio", THIS_MODULE, 0,
-			      &card);
-	if (err < 0)
-		return err;
-
-	spin_lock_init(&adev->slock);
-	adev->sndcard = card;
-	adev->udev = dev->udev;
-
-	err = snd_pcm_new(card, "Em28xx Audio", 0, 0, 1, &pcm);
-	if (err < 0) {
-		snd_card_free(card);
-		return err;
-	}
-
-	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_em28xx_pcm_capture);
-	pcm->info_flags = 0;
-	pcm->private_data = dev;
-	strcpy(pcm->name, "Empia 28xx Capture");
-
-	snd_card_set_dev(card, &dev->udev->dev);
-	strcpy(card->driver, "Em28xx-Audio");
-	strcpy(card->shortname, "Em28xx Audio");
-	strcpy(card->longname, "Empia Em28xx Audio");
-
-	INIT_WORK(&dev->wq_trigger, audio_trigger);
-
-	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
-		em28xx_cvol_new(card, dev, "Video", AC97_VIDEO);
-		em28xx_cvol_new(card, dev, "Line In", AC97_LINE);
-		em28xx_cvol_new(card, dev, "Phone", AC97_PHONE);
-		em28xx_cvol_new(card, dev, "Microphone", AC97_MIC);
-		em28xx_cvol_new(card, dev, "CD", AC97_CD);
-		em28xx_cvol_new(card, dev, "AUX", AC97_AUX);
-		em28xx_cvol_new(card, dev, "PCM", AC97_PCM);
-
-		em28xx_cvol_new(card, dev, "Master", AC97_MASTER);
-		em28xx_cvol_new(card, dev, "Line", AC97_HEADPHONE);
-		em28xx_cvol_new(card, dev, "Mono", AC97_MASTER_MONO);
-		em28xx_cvol_new(card, dev, "LFE", AC97_CENTER_LFE_MASTER);
-		em28xx_cvol_new(card, dev, "Surround", AC97_SURROUND_MASTER);
-	}
-
 	if (dev->audio_ifnum)
 		alt = 1;
 	else
@@ -760,7 +699,6 @@ static int em28xx_audio_init(struct em28xx *dev)
 	if (intf->num_altsetting <= alt) {
 		em28xx_errdev("alt %d doesn't exist on interface %d\n",
 			      dev->audio_ifnum, alt);
-		snd_card_free(card);
 		return -ENODEV;
 	}
 
@@ -776,7 +714,6 @@ static int em28xx_audio_init(struct em28xx *dev)
 
 	if (!ep) {
 		em28xx_errdev("Couldn't find an audio endpoint");
-		snd_card_free(card);
 		return -ENODEV;
 	}
 
@@ -833,13 +770,11 @@ static int em28xx_audio_init(struct em28xx *dev)
 					    sizeof(*dev->adev.transfer_buffer),
 					    GFP_ATOMIC);
 	if (!dev->adev.transfer_buffer) {
-		snd_card_free(card);
 		return -ENOMEM;
 	}
 
 	dev->adev.urb = kcalloc(num_urb, sizeof(*dev->adev.urb), GFP_ATOMIC);
 	if (!dev->adev.urb) {
-		snd_card_free(card);
 		kfree(dev->adev.transfer_buffer);
 		return -ENOMEM;
 	}
@@ -855,7 +790,6 @@ static int em28xx_audio_init(struct em28xx *dev)
 		if (!urb) {
 			em28xx_errdev("usb_alloc_urb failed!\n");
 			em28xx_audio_free_urb(dev);
-			snd_card_free(card);
 			return -ENOMEM;
 		}
 		dev->adev.urb[i] = urb;
@@ -865,7 +799,6 @@ static int em28xx_audio_init(struct em28xx *dev)
 		if (!buf) {
 			em28xx_errdev("usb_alloc_coherent failed!\n");
 			em28xx_audio_free_urb(dev);
-			snd_card_free(card);
 			return -ENOMEM;
 		}
 		dev->adev.transfer_buffer[i] = buf;
@@ -886,6 +819,80 @@ static int em28xx_audio_init(struct em28xx *dev)
 		}
 	}
 
+	return 0;
+}
+
+static int em28xx_audio_init(struct em28xx *dev)
+{
+	struct em28xx_audio *adev = &dev->adev;
+	struct snd_pcm      *pcm;
+	struct snd_card     *card;
+	static int          devnr;
+	int		    err;
+
+	if (!dev->has_alsa_audio || dev->audio_ifnum < 0) {
+		/* This device does not support the extension (in this case
+		   the device is expecting the snd-usb-audio module or
+		   doesn't have analog audio support at all) */
+		return 0;
+	}
+
+	em28xx_info("Binding audio extension\n");
+
+	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2006 Markus "
+			 "Rechberger\n");
+	printk(KERN_INFO
+	       "em28xx-audio.c: Copyright (C) 2007-2014 Mauro Carvalho Chehab\n");
+
+	err = snd_card_create(index[devnr], "Em28xx Audio", THIS_MODULE, 0,
+			      &card);
+	if (err < 0)
+		return err;
+
+	spin_lock_init(&adev->slock);
+	adev->sndcard = card;
+	adev->udev = dev->udev;
+
+	err = snd_pcm_new(card, "Em28xx Audio", 0, 0, 1, &pcm);
+	if (err < 0) {
+		snd_card_free(card);
+		return err;
+	}
+
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_em28xx_pcm_capture);
+	pcm->info_flags = 0;
+	pcm->private_data = dev;
+	strcpy(pcm->name, "Empia 28xx Capture");
+
+	snd_card_set_dev(card, &dev->udev->dev);
+	strcpy(card->driver, "Em28xx-Audio");
+	strcpy(card->shortname, "Em28xx Audio");
+	strcpy(card->longname, "Empia Em28xx Audio");
+
+	INIT_WORK(&dev->wq_trigger, audio_trigger);
+
+	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
+		em28xx_cvol_new(card, dev, "Video", AC97_VIDEO);
+		em28xx_cvol_new(card, dev, "Line In", AC97_LINE);
+		em28xx_cvol_new(card, dev, "Phone", AC97_PHONE);
+		em28xx_cvol_new(card, dev, "Microphone", AC97_MIC);
+		em28xx_cvol_new(card, dev, "CD", AC97_CD);
+		em28xx_cvol_new(card, dev, "AUX", AC97_AUX);
+		em28xx_cvol_new(card, dev, "PCM", AC97_PCM);
+
+		em28xx_cvol_new(card, dev, "Master", AC97_MASTER);
+		em28xx_cvol_new(card, dev, "Line", AC97_HEADPHONE);
+		em28xx_cvol_new(card, dev, "Mono", AC97_MASTER_MONO);
+		em28xx_cvol_new(card, dev, "LFE", AC97_CENTER_LFE_MASTER);
+		em28xx_cvol_new(card, dev, "Surround", AC97_SURROUND_MASTER);
+	}
+
+	err = em28xx_audio_urb_init(dev);
+	if (err) {
+		snd_card_free(card);
+		return -ENODEV;
+	}
+
 	err = snd_card_register(card);
 	if (err < 0) {
 		em28xx_audio_free_urb(dev);
-- 
1.8.3.1

