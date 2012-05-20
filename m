Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab2ETBVc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 21:21:32 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ondrej Zary <linux@rainbow-software.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4/6] snd_tea575x: Make the module using snd_tea575x the fops owner
Date: Sun, 20 May 2012 03:25:29 +0200
Message-Id: <1337477131-21578-5-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
References: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before this patch the owner field of the /dev/radio# device fops was set to
the snd-tea575x-tuner module itself. Meaning that the module which was using
it could be rmmod-ed while the device is open, and then BAD things happen.

I know, as I found out the hard way :)

Note that there is no need to also somehow increase the refcount of the
snd-tea575x-tuner module itself, since any drivers using it will have
symbolic references to it.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
CC: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/radio/radio-maxiradio.c |    2 +-
 drivers/media/radio/radio-sf16fmr2.c  |    2 +-
 include/sound/tea575x-tuner.h         |    3 ++-
 sound/i2c/other/tea575x-tuner.c       |    7 ++++---
 sound/pci/es1968.c                    |    2 +-
 sound/pci/fm801.c                     |    4 ++--
 6 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 740a3d5..b415211 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -157,7 +157,7 @@ static int __devinit maxiradio_probe(struct pci_dev *pdev, const struct pci_devi
 		goto err_out_free_region;
 
 	dev->io = pci_resource_start(pdev, 0);
-	if (snd_tea575x_init(&dev->tea)) {
+	if (snd_tea575x_init(&dev->tea, THIS_MODULE)) {
 		printk(KERN_ERR "radio-maxiradio: Unable to detect TEA575x tuner\n");
 		goto err_out_free_region;
 	}
diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index 7c69214..59e1191 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -222,7 +222,7 @@ static int __devinit fmr2_probe(struct device *pdev, unsigned int dev)
 	snprintf(fmr2->tea.bus_info, sizeof(fmr2->tea.bus_info), "ISA:%s",
 			fmr2->v4l2_dev.name);
 
-	if (snd_tea575x_init(&fmr2->tea)) {
+	if (snd_tea575x_init(&fmr2->tea, THIS_MODULE)) {
 		printk(KERN_ERR "radio-sf16fmr2: Unable to detect TEA575x tuner\n");
 		release_region(fmr2->io, 2);
 		kfree(fmr2);
diff --git a/include/sound/tea575x-tuner.h b/include/sound/tea575x-tuner.h
index af58ad2..fe8590c 100644
--- a/include/sound/tea575x-tuner.h
+++ b/include/sound/tea575x-tuner.h
@@ -48,6 +48,7 @@ struct snd_tea575x_ops {
 
 struct snd_tea575x {
 	struct v4l2_device *v4l2_dev;
+	struct v4l2_file_operations fops;
 	struct video_device vd;		/* video device */
 	int radio_nr;			/* radio_nr */
 	bool tea5759;			/* 5759 chip is present */
@@ -67,7 +68,7 @@ struct snd_tea575x {
 	int (*ext_init)(struct snd_tea575x *tea);
 };
 
-int snd_tea575x_init(struct snd_tea575x *tea);
+int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner);
 void snd_tea575x_exit(struct snd_tea575x *tea);
 
 #endif /* __SOUND_TEA575X_TUNER_H */
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index ddc08a8..8c142e5 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -323,7 +323,6 @@ static int tea575x_s_ctrl(struct v4l2_ctrl *ctrl)
 }
 
 static const struct v4l2_file_operations tea575x_fops = {
-	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= video_ioctl2,
 	.open           = v4l2_fh_open,
 	.release        = v4l2_fh_release,
@@ -343,7 +342,6 @@ static const struct v4l2_ioctl_ops tea575x_ioctl_ops = {
 };
 
 static const struct video_device tea575x_radio = {
-	.fops           = &tea575x_fops,
 	.ioctl_ops 	= &tea575x_ioctl_ops,
 	.release        = video_device_release_empty,
 };
@@ -355,7 +353,7 @@ static const struct v4l2_ctrl_ops tea575x_ctrl_ops = {
 /*
  * initialize all the tea575x chips
  */
-int snd_tea575x_init(struct snd_tea575x *tea)
+int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner)
 {
 	int retval;
 
@@ -379,6 +377,9 @@ int snd_tea575x_init(struct snd_tea575x *tea)
 	strlcpy(tea->vd.name, tea->v4l2_dev->name, sizeof(tea->vd.name));
 	tea->vd.lock = &tea->mutex;
 	tea->vd.v4l2_dev = tea->v4l2_dev;
+	tea->fops = tea575x_fops;
+	tea->fops.owner = owner;
+	tea->vd.fops = &tea->fops;
 	set_bit(V4L2_FL_USE_FH_PRIO, &tea->vd.flags);
 	/* disable hw_freq_seek if we can't use it */
 	if (tea->cannot_read_data)
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index a8faae1..0f2811e 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2769,7 +2769,7 @@ static int __devinit snd_es1968_create(struct snd_card *card,
 	chip->tea.ops = &snd_es1968_tea_ops;
 	strlcpy(chip->tea.card, "SF64-PCE2", sizeof(chip->tea.card));
 	sprintf(chip->tea.bus_info, "PCI:%s", pci_name(pci));
-	if (!snd_tea575x_init(&chip->tea))
+	if (!snd_tea575x_init(&chip->tea, THIS_MODULE))
 		printk(KERN_INFO "es1968: detected TEA575x radio\n");
 #endif
 
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index a416ea8..5265c57 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1254,7 +1254,7 @@ static int __devinit snd_fm801_create(struct snd_card *card,
 	sprintf(chip->tea.bus_info, "PCI:%s", pci_name(pci));
 	if ((tea575x_tuner & TUNER_TYPE_MASK) > 0 &&
 	    (tea575x_tuner & TUNER_TYPE_MASK) < 4) {
-		if (snd_tea575x_init(&chip->tea)) {
+		if (snd_tea575x_init(&chip->tea, THIS_MODULE)) {
 			snd_printk(KERN_ERR "TEA575x radio not found\n");
 			snd_fm801_free(chip);
 			return -ENODEV;
@@ -1263,7 +1263,7 @@ static int __devinit snd_fm801_create(struct snd_card *card,
 		/* autodetect tuner connection */
 		for (tea575x_tuner = 1; tea575x_tuner <= 3; tea575x_tuner++) {
 			chip->tea575x_tuner = tea575x_tuner;
-			if (!snd_tea575x_init(&chip->tea)) {
+			if (!snd_tea575x_init(&chip->tea, THIS_MODULE)) {
 				snd_printk(KERN_INFO "detected TEA575x radio type %s\n",
 					   get_tea575x_gpio(chip)->name);
 				break;
-- 
1.7.10

