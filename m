Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934041Ab0FFOxm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:42 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o56ErgRP030112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 6 Jun 2010 10:53:42 -0400
Received: from pedra (vpn-11-208.rdu.redhat.com [10.11.11.208])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o56EraZC031853
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 6 Jun 2010 10:53:41 -0400
Date: Sun, 6 Jun 2010 11:53:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] tm6000-alsa: Fix several bugs at the driver
 initialization code
Message-ID: <20100606115312.3c6affe7@pedra>
In-Reply-To: <cover.1275835609.git.mchehab@redhat.com>
References: <cover.1275835609.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several missing things at the driver, preventing, for example,
the code to start/stop DMA to actually work. Fix them before implementing
a routine to store data at the audio buffers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index e71579e..fa19a41 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -77,6 +77,8 @@ static int _tm6000_start_audio_dma(struct snd_tm6000_card *chip)
 	struct tm6000_core *core = chip->core;
 	int val;
 
+	dprintk(1, "Starting audio DMA\n");
+
 	/* Enables audio */
 	val = tm6000_get_reg(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x0);
 	val |= 0x20;
@@ -236,7 +238,9 @@ static int snd_tm6000_hw_params(struct snd_pcm_substream *substream,
  */
 static int snd_tm6000_hw_free(struct snd_pcm_substream *substream)
 {
-	dsp_buffer_free(substream);
+	struct snd_tm6000_card *chip = snd_pcm_substream_chip(substream);
+
+	_tm6000_stop_audio_dma(chip);
 
 	return 0;
 }
@@ -246,6 +250,11 @@ static int snd_tm6000_hw_free(struct snd_pcm_substream *substream)
  */
 static int snd_tm6000_prepare(struct snd_pcm_substream *substream)
 {
+	struct snd_tm6000_card *chip = snd_pcm_substream_chip(substream);
+
+	chip->buf_pos = 0;
+	chip->period_pos = 0;
+
 	return 0;
 }
 
@@ -283,12 +292,8 @@ static int snd_tm6000_card_trigger(struct snd_pcm_substream *substream, int cmd)
 static snd_pcm_uframes_t snd_tm6000_pointer(struct snd_pcm_substream *substream)
 {
 	struct snd_tm6000_card *chip = snd_pcm_substream_chip(substream);
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	u16 count;
 
-	count = atomic_read(&chip->count);
-
-	return runtime->period_size * (count & (runtime->periods-1));
+	return chip->buf_pos;
 }
 
 /*
@@ -341,41 +346,43 @@ int tm6000_audio_init(struct tm6000_core *dev)
 		snd_printk(KERN_ERR "cannot create card instance %d\n", devnr);
 		return rc;
 	}
-
-	chip = kzalloc(sizeof(struct snd_tm6000_card), GFP_KERNEL);
-	if (!chip) {
-		rc = -ENOMEM;
-		goto error;
-	}
+	strcpy(card->driver, "tm6000-alsa");
+	strcpy(card->shortname, "TM5600/60x0");
+	sprintf(card->longname, "TM5600/60x0 Audio at bus %d device %d",
+		dev->udev->bus->busnum, dev->udev->devnum);
 
 	sprintf(component, "USB%04x:%04x",
 		le16_to_cpu(dev->udev->descriptor.idVendor),
 		le16_to_cpu(dev->udev->descriptor.idProduct));
 	snd_component_add(card, component);
+	snd_card_set_dev(card, &dev->udev->dev);
 
+	chip = kzalloc(sizeof(struct snd_tm6000_card), GFP_KERNEL);
+	if (!chip) {
+		rc = -ENOMEM;
+		goto error;
+	}
+
+	chip->core = dev;
+	chip->card = card;
+	dev->adev = chip;
 	spin_lock_init(&chip->reg_lock);
+
 	rc = snd_pcm_new(card, "TM6000 Audio", 0, 0, 1, &pcm);
 	if (rc < 0)
 		goto error;
 
-	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_tm6000_pcm_ops);
 	pcm->info_flags = 0;
-	pcm->private_data = dev;
+	pcm->private_data = chip;
 	strcpy(pcm->name, "Trident TM5600/60x0");
-	strcpy(card->driver, "tm6000-alsa");
-	strcpy(card->shortname, "TM5600/60x0");
-	sprintf(card->longname, "TM5600/60x0 Audio at bus %d device %d",
-		dev->udev->bus->busnum, dev->udev->devnum);
 
-	snd_card_set_dev(card, &dev->udev->dev);
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_tm6000_pcm_ops);
 
 	rc = snd_card_register(card);
 	if (rc < 0)
 		goto error;
 
-	chip->core = dev;
-	chip->card = card;
-	dev->adev = chip;
+	dprintk(1,"Registered audio driver for %s\n", card->longname);
 
 	return 0;
 
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 626b85e..46b9ec5 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -677,10 +677,10 @@ int tm6000_register_extension(struct tm6000_ops *ops)
 	mutex_lock(&tm6000_extension_devlist_lock);
 	list_add_tail(&ops->next, &tm6000_extension_devlist);
 	list_for_each_entry(dev, &tm6000_devlist, devlist) {
-		if (dev)
-			ops->init(dev);
+		ops->init(dev);
+		printk(KERN_INFO "%s: Initialized (%s) extension\n",
+		       dev->name, ops->name);
 	}
-	printk(KERN_INFO "tm6000: Initialized (%s) extension\n", ops->name);
 	mutex_unlock(&tm6000_extension_devlist_lock);
 	mutex_unlock(&tm6000_devlist_mutex);
 	return 0;
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index db99959..89862a4 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -135,9 +135,12 @@ struct tm6000_dvb {
 struct snd_tm6000_card {
 	struct snd_card			*card;
 	spinlock_t			reg_lock;
-	atomic_t			count;
 	struct tm6000_core		*core;
 	struct snd_pcm_substream	*substream;
+
+	/* temporary data for buffer fill processing */
+	unsigned			buf_pos;
+	unsigned			period_pos;
 };
 
 struct tm6000_endpoint {
-- 
1.7.1


