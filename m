Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1683 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab0KNNW1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 08:22:27 -0500
Message-Id: <24e81e4361b0ae25159d549a422f319ece1551e3.1289740431.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289740431.git.hverkuil@xs4all.nl>
References: <cover.1289740431.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 14 Nov 2010 14:22:15 +0100
Subject: [RFC PATCH 2/8] BKL: trivial BKL removal from V4L2 radio drivers
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The patch converts a bunch of V4L2 radio drivers to unlocked_ioctl.

These are all simple conversions: most already had a lock and so the ioctl
fop could simply be replaced by unlocked_ioctl.

radio-miropcm20.c was converted to use the new V4L2 core lock.

While doing this work I noticed that many of these drivers initialized
some more fields or muted audio or something like that *after* creating
the device node. This should be done before the device node is created
to prevent problems. Especially hal tends to grab a device node as soon
as it is created.

In one or two cases the mutex_init was even done after the device creation!

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-aimslab.c    |   16 ++++++++--------
 drivers/media/radio/radio-aztech.c     |    6 +++---
 drivers/media/radio/radio-gemtek-pci.c |    6 +++---
 drivers/media/radio/radio-gemtek.c     |   14 +++++++-------
 drivers/media/radio/radio-maestro.c    |   14 ++++++--------
 drivers/media/radio/radio-maxiradio.c  |    2 +-
 drivers/media/radio/radio-miropcm20.c  |    6 ++++--
 drivers/media/radio/radio-rtrack2.c    |   10 +++++-----
 drivers/media/radio/radio-sf16fmi.c    |    7 ++++---
 drivers/media/radio/radio-sf16fmr2.c   |   11 +++++------
 drivers/media/radio/radio-terratec.c   |    8 ++++----
 drivers/media/radio/radio-trust.c      |   18 +++++++++---------
 drivers/media/radio/radio-zoltrix.c    |   30 +++++++++++++++---------------
 13 files changed, 74 insertions(+), 74 deletions(-)

diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index 5bf4985..05e832f 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -361,7 +361,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations rtrack_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops rtrack_ioctl_ops = {
@@ -412,13 +412,6 @@ static int __init rtrack_init(void)
 	rt->vdev.release = video_device_release_empty;
 	video_set_drvdata(&rt->vdev, rt);
 
-	if (video_register_device(&rt->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-		v4l2_device_unregister(&rt->v4l2_dev);
-		release_region(rt->io, 2);
-		return -EINVAL;
-	}
-	v4l2_info(v4l2_dev, "AIMSlab RadioTrack/RadioReveal card driver.\n");
-
 	/* Set up the I/O locking */
 
 	mutex_init(&rt->lock);
@@ -430,6 +423,13 @@ static int __init rtrack_init(void)
 	sleep_delay(2000000);	/* make sure it's totally down	*/
 	outb(0xc0, rt->io);		/* steady volume, mute card	*/
 
+	if (video_register_device(&rt->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
+		v4l2_device_unregister(&rt->v4l2_dev);
+		release_region(rt->io, 2);
+		return -EINVAL;
+	}
+	v4l2_info(v4l2_dev, "AIMSlab RadioTrack/RadioReveal card driver.\n");
+
 	return 0;
 }
 
diff --git a/drivers/media/radio/radio-aztech.c b/drivers/media/radio/radio-aztech.c
index c223113..dd8a6ab 100644
--- a/drivers/media/radio/radio-aztech.c
+++ b/drivers/media/radio/radio-aztech.c
@@ -324,7 +324,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 static const struct v4l2_file_operations aztech_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops aztech_ioctl_ops = {
@@ -375,6 +375,8 @@ static int __init aztech_init(void)
 	az->vdev.ioctl_ops = &aztech_ioctl_ops;
 	az->vdev.release = video_device_release_empty;
 	video_set_drvdata(&az->vdev, az);
+	/* mute card - prevents noisy bootups */
+	outb(0, az->io);
 
 	if (video_register_device(&az->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
 		v4l2_device_unregister(v4l2_dev);
@@ -383,8 +385,6 @@ static int __init aztech_init(void)
 	}
 
 	v4l2_info(v4l2_dev, "Aztech radio card driver v1.00/19990224 rkroll@exploits.org\n");
-	/* mute card - prevents noisy bootups */
-	outb(0, az->io);
 	return 0;
 }
 
diff --git a/drivers/media/radio/radio-gemtek-pci.c b/drivers/media/radio/radio-gemtek-pci.c
index 7903967..28fa85b 100644
--- a/drivers/media/radio/radio-gemtek-pci.c
+++ b/drivers/media/radio/radio-gemtek-pci.c
@@ -361,7 +361,7 @@ MODULE_DEVICE_TABLE(pci, gemtek_pci_id);
 
 static const struct v4l2_file_operations gemtek_pci_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops gemtek_pci_ioctl_ops = {
@@ -422,11 +422,11 @@ static int __devinit gemtek_pci_probe(struct pci_dev *pdev, const struct pci_dev
 	card->vdev.release = video_device_release_empty;
 	video_set_drvdata(&card->vdev, card);
 
+	gemtek_pci_mute(card);
+
 	if (video_register_device(&card->vdev, VFL_TYPE_RADIO, nr_radio) < 0)
 		goto err_video;
 
-	gemtek_pci_mute(card);
-
 	v4l2_info(v4l2_dev, "Gemtek PCI Radio (rev. %d) found at 0x%04x-0x%04x.\n",
 		pdev->revision, card->iobase, card->iobase + card->length - 1);
 
diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index 73985f6..2599364 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -378,7 +378,7 @@ static int gemtek_probe(struct gemtek *gt)
 
 static const struct v4l2_file_operations gemtek_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static int vidioc_querycap(struct file *file, void *priv,
@@ -577,12 +577,6 @@ static int __init gemtek_init(void)
 	gt->vdev.release = video_device_release_empty;
 	video_set_drvdata(&gt->vdev, gt);
 
-	if (video_register_device(&gt->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-		v4l2_device_unregister(v4l2_dev);
-		release_region(gt->io, 1);
-		return -EBUSY;
-	}
-
 	/* Set defaults */
 	gt->lastfreq = GEMTEK_LOWFREQ;
 	gt->bu2614data = 0;
@@ -590,6 +584,12 @@ static int __init gemtek_init(void)
 	if (initmute)
 		gemtek_mute(gt);
 
+	if (video_register_device(&gt->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
+		v4l2_device_unregister(v4l2_dev);
+		release_region(gt->io, 1);
+		return -EBUSY;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/media/radio/radio-maestro.c b/drivers/media/radio/radio-maestro.c
index 08f1051..6af61bf 100644
--- a/drivers/media/radio/radio-maestro.c
+++ b/drivers/media/radio/radio-maestro.c
@@ -299,7 +299,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations maestro_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops maestro_ioctl_ops = {
@@ -383,22 +383,20 @@ static int __devinit maestro_probe(struct pci_dev *pdev,
 	dev->vdev.release = video_device_release_empty;
 	video_set_drvdata(&dev->vdev, dev);
 
+	if (!radio_power_on(dev)) {
+		retval = -EIO;
+		goto errfr1;
+	}
+
 	retval = video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr);
 	if (retval) {
 		v4l2_err(v4l2_dev, "can't register video device!\n");
 		goto errfr1;
 	}
 
-	if (!radio_power_on(dev)) {
-		retval = -EIO;
-		goto errunr;
-	}
-
 	v4l2_info(v4l2_dev, "version " DRIVER_VERSION "\n");
 
 	return 0;
-errunr:
-	video_unregister_device(&dev->vdev);
 errfr1:
 	v4l2_device_unregister(v4l2_dev);
 errfr:
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 255d40d..6459a22 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -346,7 +346,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 static const struct v4l2_file_operations maxiradio_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl          = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops maxiradio_ioctl_ops = {
diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 4ff8854..3fb76e3 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -33,6 +33,7 @@ struct pcm20 {
 	unsigned long freq;
 	int muted;
 	struct snd_miro_aci *aci;
+	struct mutex lock;
 };
 
 static struct pcm20 pcm20_card = {
@@ -72,7 +73,7 @@ static int pcm20_setfreq(struct pcm20 *dev, unsigned long freq)
 
 static const struct v4l2_file_operations pcm20_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static int vidioc_querycap(struct file *file, void *priv,
@@ -229,7 +230,7 @@ static int __init pcm20_init(void)
 		return -ENODEV;
 	}
 	strlcpy(v4l2_dev->name, "miropcm20", sizeof(v4l2_dev->name));
-
+	mutex_init(&dev->lock);
 
 	res = v4l2_device_register(NULL, v4l2_dev);
 	if (res < 0) {
@@ -242,6 +243,7 @@ static int __init pcm20_init(void)
 	dev->vdev.fops = &pcm20_fops;
 	dev->vdev.ioctl_ops = &pcm20_ioctl_ops;
 	dev->vdev.release = video_device_release_empty;
+	dev->vdev.lock = &dev->lock;
 	video_set_drvdata(&dev->vdev, dev);
 
 	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0)
diff --git a/drivers/media/radio/radio-rtrack2.c b/drivers/media/radio/radio-rtrack2.c
index a79296a..8d6ea59 100644
--- a/drivers/media/radio/radio-rtrack2.c
+++ b/drivers/media/radio/radio-rtrack2.c
@@ -266,7 +266,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations rtrack2_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops rtrack2_ioctl_ops = {
@@ -315,6 +315,10 @@ static int __init rtrack2_init(void)
 	dev->vdev.release = video_device_release_empty;
 	video_set_drvdata(&dev->vdev, dev);
 
+	/* mute card - prevents noisy bootups */
+	outb(1, dev->io);
+	dev->muted = 1;
+
 	mutex_init(&dev->lock);
 	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
 		v4l2_device_unregister(v4l2_dev);
@@ -324,10 +328,6 @@ static int __init rtrack2_init(void)
 
 	v4l2_info(v4l2_dev, "AIMSlab Radiotrack II card driver.\n");
 
-	/* mute card - prevents noisy bootups */
-	outb(1, dev->io);
-	dev->muted = 1;
-
 	return 0;
 }
 
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index 985359d..b5a5f89 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -260,7 +260,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations fmi_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops fmi_ioctl_ops = {
@@ -382,6 +382,9 @@ static int __init fmi_init(void)
 
 	mutex_init(&fmi->lock);
 
+	/* mute card - prevents noisy bootups */
+	fmi_mute(fmi);
+
 	if (video_register_device(&fmi->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
 		v4l2_device_unregister(v4l2_dev);
 		release_region(fmi->io, 2);
@@ -391,8 +394,6 @@ static int __init fmi_init(void)
 	}
 
 	v4l2_info(v4l2_dev, "card driver at 0x%x\n", fmi->io);
-	/* mute card - prevents noisy bootups */
-	fmi_mute(fmi);
 	return 0;
 }
 
diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index 52c7bbb..dc3f04c 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -376,7 +376,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations fmr2_fops = {
 	.owner          = THIS_MODULE,
-	.ioctl          = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops fmr2_ioctl_ops = {
@@ -424,6 +424,10 @@ static int __init fmr2_init(void)
 	fmr2->vdev.release = video_device_release_empty;
 	video_set_drvdata(&fmr2->vdev, fmr2);
 
+	/* mute card - prevents noisy bootups */
+	fmr2_mute(fmr2->io);
+	fmr2_product_info(fmr2);
+
 	if (video_register_device(&fmr2->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
 		v4l2_device_unregister(v4l2_dev);
 		release_region(fmr2->io, 2);
@@ -431,11 +435,6 @@ static int __init fmr2_init(void)
 	}
 
 	v4l2_info(v4l2_dev, "SF16FMR2 radio card driver at 0x%x.\n", fmr2->io);
-	/* mute card - prevents noisy bootups */
-	mutex_lock(&fmr2->lock);
-	fmr2_mute(fmr2->io);
-	fmr2_product_info(fmr2);
-	mutex_unlock(&fmr2->lock);
 	debug_print((KERN_DEBUG "card_type %d\n", fmr2->card_type));
 	return 0;
 }
diff --git a/drivers/media/radio/radio-terratec.c b/drivers/media/radio/radio-terratec.c
index fc1c860..a326639 100644
--- a/drivers/media/radio/radio-terratec.c
+++ b/drivers/media/radio/radio-terratec.c
@@ -338,7 +338,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations terratec_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops terratec_ioctl_ops = {
@@ -389,6 +389,9 @@ static int __init terratec_init(void)
 
 	mutex_init(&tt->lock);
 
+	/* mute card - prevents noisy bootups */
+	tt_write_vol(tt, 0);
+
 	if (video_register_device(&tt->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
 		v4l2_device_unregister(&tt->v4l2_dev);
 		release_region(tt->io, 2);
@@ -396,9 +399,6 @@ static int __init terratec_init(void)
 	}
 
 	v4l2_info(v4l2_dev, "TERRATEC ActivRadio Standalone card driver.\n");
-
-	/* mute card - prevents noisy bootups */
-	tt_write_vol(tt, 0);
 	return 0;
 }
 
diff --git a/drivers/media/radio/radio-trust.c b/drivers/media/radio/radio-trust.c
index 9d6dcf8..22fa9cc 100644
--- a/drivers/media/radio/radio-trust.c
+++ b/drivers/media/radio/radio-trust.c
@@ -344,7 +344,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations trust_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops trust_ioctl_ops = {
@@ -396,14 +396,6 @@ static int __init trust_init(void)
 	tr->vdev.release = video_device_release_empty;
 	video_set_drvdata(&tr->vdev, tr);
 
-	if (video_register_device(&tr->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-		v4l2_device_unregister(v4l2_dev);
-		release_region(tr->io, 2);
-		return -EINVAL;
-	}
-
-	v4l2_info(v4l2_dev, "Trust FM Radio card driver v1.0.\n");
-
 	write_i2c(tr, 2, TDA7318_ADDR, 0x80);	/* speaker att. LF = 0 dB */
 	write_i2c(tr, 2, TDA7318_ADDR, 0xa0);	/* speaker att. RF = 0 dB */
 	write_i2c(tr, 2, TDA7318_ADDR, 0xc0);	/* speaker att. LR = 0 dB */
@@ -418,6 +410,14 @@ static int __init trust_init(void)
 	/* mute card - prevents noisy bootups */
 	tr_setmute(tr, 1);
 
+	if (video_register_device(&tr->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
+		v4l2_device_unregister(v4l2_dev);
+		release_region(tr->io, 2);
+		return -EINVAL;
+	}
+
+	v4l2_info(v4l2_dev, "Trust FM Radio card driver v1.0.\n");
+
 	return 0;
 }
 
diff --git a/drivers/media/radio/radio-zoltrix.c b/drivers/media/radio/radio-zoltrix.c
index f31eab9..af99c5b 100644
--- a/drivers/media/radio/radio-zoltrix.c
+++ b/drivers/media/radio/radio-zoltrix.c
@@ -377,7 +377,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 static const struct v4l2_file_operations zoltrix_fops =
 {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops zoltrix_ioctl_ops = {
@@ -424,20 +424,6 @@ static int __init zoltrix_init(void)
 		return res;
 	}
 
-	strlcpy(zol->vdev.name, v4l2_dev->name, sizeof(zol->vdev.name));
-	zol->vdev.v4l2_dev = v4l2_dev;
-	zol->vdev.fops = &zoltrix_fops;
-	zol->vdev.ioctl_ops = &zoltrix_ioctl_ops;
-	zol->vdev.release = video_device_release_empty;
-	video_set_drvdata(&zol->vdev, zol);
-
-	if (video_register_device(&zol->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-		v4l2_device_unregister(v4l2_dev);
-		release_region(zol->io, 2);
-		return -EINVAL;
-	}
-	v4l2_info(v4l2_dev, "Zoltrix Radio Plus card driver.\n");
-
 	mutex_init(&zol->lock);
 
 	/* mute card - prevents noisy bootups */
@@ -452,6 +438,20 @@ static int __init zoltrix_init(void)
 	zol->curvol = 0;
 	zol->stereo = 1;
 
+	strlcpy(zol->vdev.name, v4l2_dev->name, sizeof(zol->vdev.name));
+	zol->vdev.v4l2_dev = v4l2_dev;
+	zol->vdev.fops = &zoltrix_fops;
+	zol->vdev.ioctl_ops = &zoltrix_ioctl_ops;
+	zol->vdev.release = video_device_release_empty;
+	video_set_drvdata(&zol->vdev, zol);
+
+	if (video_register_device(&zol->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
+		v4l2_device_unregister(v4l2_dev);
+		release_region(zol->io, 2);
+		return -EINVAL;
+	}
+	v4l2_info(v4l2_dev, "Zoltrix Radio Plus card driver.\n");
+
 	return 0;
 }
 
-- 
1.7.0.4

