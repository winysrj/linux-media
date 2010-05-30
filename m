Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:33871 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400Ab0E3MU7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 08:20:59 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 1/3] tm6000: rewrite init and fini
Date: Sun, 30 May 2010 14:19:02 +0200
Message-Id: <1275221944-27887-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

rewrite tm6000_audio_init and tm6000_audio_fini

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-alsa.c |  127 +++++++++++++---------------------
 drivers/staging/tm6000/tm6000.h      |   15 ++++
 2 files changed, 63 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index ce081cd..477dd78 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -35,29 +35,6 @@
 	} while (0)
 
 /****************************************************************************
-	Data type declarations - Can be moded to a header file later
- ****************************************************************************/
-
-struct snd_tm6000_card {
-	struct snd_card            *card;
-
-	spinlock_t                 reg_lock;
-
-	atomic_t		   count;
-
-	unsigned int               period_size;
-	unsigned int               num_periods;
-
-	struct tm6000_core         *core;
-	struct tm6000_buffer       *buf;
-
-	int			   bufsize;
-
-	struct snd_pcm_substream *substream;
-};
-
-
-/****************************************************************************
 			Module global static vars
  ****************************************************************************/
 
@@ -311,21 +288,6 @@ static struct snd_pcm_ops snd_tm6000_pcm_ops = {
 /*
  * create a PCM device
  */
-static int __devinit snd_tm6000_pcm(struct snd_tm6000_card *chip,
-				    int device, char *name)
-{
-	int err;
-	struct snd_pcm *pcm;
-
-	err = snd_pcm_new(chip->card, name, device, 0, 1, &pcm);
-	if (err < 0)
-		return err;
-	pcm->private_data = chip;
-	strcpy(pcm->name, name);
-	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_tm6000_pcm_ops);
-
-	return 0;
-}
 
 /* FIXME: Control interface - How to control volume/mute? */
 
@@ -336,73 +298,64 @@ static int __devinit snd_tm6000_pcm(struct snd_tm6000_card *chip,
 /*
  * Alsa Constructor - Component probe
  */
-
-int tm6000_audio_init(struct tm6000_core *dev, int idx)
+int tm6000_audio_init(struct tm6000_core *dev)
 {
-	struct snd_card         *card;
-	struct snd_tm6000_card  *chip;
-	int                     rc, len;
-	char                    component[14];
+	struct snd_card		*card;
+	struct snd_tm6000_card	*chip;
+	int			rc;
+	static int		devnr;
+	char			component[14];
+	struct snd_pcm		*pcm;
+
+	if (!dev)
+		return 0;
 
-	if (idx >= SNDRV_CARDS)
+	if (devnr >= SNDRV_CARDS)
 		return -ENODEV;
 
-	if (!enable[idx])
+	if (!enable[devnr])
 		return -ENOENT;
 
-	rc = snd_card_create(index[idx], id[idx], THIS_MODULE, 0, &card);
+	rc = snd_card_create(index[devnr], id[devnr], THIS_MODULE, 0, &card);
 	if (rc < 0) {
-		snd_printk(KERN_ERR "cannot create card instance %d\n", idx);
+		snd_printk(KERN_ERR "cannot create card instance %d\n", devnr);
 		return rc;
 	}
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = kzalloc(sizeof(struct snd_tm6000_card), GFP_KERNEL);
 	if (!chip) {
 		rc = -ENOMEM;
 		goto error;
 	}
 
-	chip->core = dev;
-	chip->card = card;
-
-	strcpy(card->driver, "tm6000-alsa");
 	sprintf(component, "USB%04x:%04x",
 		le16_to_cpu(dev->udev->descriptor.idVendor),
 		le16_to_cpu(dev->udev->descriptor.idProduct));
-	snd_component_add(card, component);
-
-	if (dev->udev->descriptor.iManufacturer)
-		len = usb_string(dev->udev,
-				 dev->udev->descriptor.iManufacturer,
-				 card->longname, sizeof(card->longname));
-	else
-		len = 0;
-
-	if (len > 0)
-		strlcat(card->longname, " ", sizeof(card->longname));
+	snd_component_add(card, component); 
 
-	strlcat(card->longname, card->shortname, sizeof(card->longname));
-
-	len = strlcat(card->longname, " at ", sizeof(card->longname));
-
-	if (len < sizeof(card->longname))
-		usb_make_path(dev->udev, card->longname + len,
-			      sizeof(card->longname) - len);
-
-	strlcat(card->longname,
-		dev->udev->speed == USB_SPEED_LOW ? ", low speed" :
-		dev->udev->speed == USB_SPEED_FULL ? ", full speed" :
-							   ", high speed",
-		sizeof(card->longname));
-
-	rc = snd_tm6000_pcm(chip, 0, "tm6000 Digital");
+	spin_lock_init(&chip->reg_lock);
+	rc = snd_pcm_new(card, "TM6000 Audio", 0, 0, 1, &pcm);
 	if (rc < 0)
 		goto error;
 
+	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_tm6000_pcm_ops);
+	pcm->info_flags = 0;
+	pcm->private_data = dev;
+	strcpy(pcm->name, "Trident TM5600/60x0");
+	strcpy(card->driver, "tm6000-alsa");
+	strcpy(card->shortname, "TM5600/60x0");
+	sprintf(card->longname, "TM5600/60x0 Audio at bus %d device %d",
+		dev->udev->bus->busnum, dev->udev->devnum);
+
+	snd_card_set_dev(card, &dev->udev->dev);
+
 	rc = snd_card_register(card);
 	if (rc < 0)
 		goto error;
 
+	chip->core = dev;
+	chip->card = card;
+	dev->adev = chip;
 
 	return 0;
 
@@ -413,6 +366,22 @@ error:
 
 static int tm6000_audio_fini(struct tm6000_core *dev)
 {
+	struct snd_tm6000_card	*chip = dev->adev;
+
+	if (!dev)
+		return 0;
+
+	if (!chip)
+		return 0;
+
+	if (!chip->card)
+		return 0;
+
+	snd_card_free(chip->card);
+	chip->card = NULL;
+	kfree(chip);
+	dev->adev = NULL;
+
 	return 0;
 }
 
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 79ef72a..231e2be 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -132,6 +132,18 @@ struct tm6000_dvb {
 	struct mutex		mutex;
 };
 
+struct snd_tm6000_card {
+	struct snd_card			*card;
+	spinlock_t			reg_lock;
+	atomic_t			count;
+	unsigned int			period_size;
+	unsigned int			num_periods;
+	struct tm6000_core		*core;
+	struct tm6000_buffer		*buf;
+	int				bufsize;
+	struct snd_pcm_substream	*substream;
+};
+
 struct tm6000_endpoint {
 	struct usb_host_endpoint	*endp;
 	__u8				bInterfaceNumber;
@@ -190,6 +202,9 @@ struct tm6000_core {
 	/* DVB-T support */
 	struct tm6000_dvb		*dvb;
 
+	/* audio support */
+	struct snd_tm6000_card		*adev;
+
 	/* locks */
 	struct mutex			lock;
 
-- 
1.7.0.3

