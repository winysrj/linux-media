Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1036 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab2BENRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2012 08:17:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>,
	alsa-devel@alsa-project.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 1/2] tea575x-tuner: update to latest V4L2 framework requirements.
Date: Sun,  5 Feb 2012 14:17:06 +0100
Message-Id: <a9d0e4a1a621edf0a0395bc58544cbd3d1d9ec8f.1328447243.git.hans.verkuil@cisco.com>
In-Reply-To: <1328447827-9842-1-git-send-email-hverkuil@xs4all.nl>
References: <1328447827-9842-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The tea575x-tuner module has been updated to use the latest V4L2 framework
functionality. This also required changes in the drivers that rely on it.

The tea575x changes are:

- The drivers must provide a v4l2_device struct to the tea module.
- The radio_nr module parameter must be part of the actual radio driver,
  and not of the tea module.
- Changed the frequency range to the normal 76-108 MHz range instead of
  50-150.
- Add hardware frequency seek support.
- Fix broken rxsubchans/audmode handling.
- The application can now select between stereo and mono.
- Support polling for control events.
- Add V4L2 priority handling.

And radio-sf16fmr2.c now uses the isa bus kernel framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-sf16fmr2.c |   56 ++++++++++++-
 include/sound/tea575x-tuner.h        |    6 +-
 sound/i2c/other/tea575x-tuner.c      |  143 ++++++++++++++++++----------------
 sound/pci/es1968.c                   |   15 ++++
 sound/pci/fm801.c                    |   20 ++++-
 5 files changed, 165 insertions(+), 75 deletions(-)

diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index 2dd4859..772a886 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -11,14 +11,20 @@
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
 #include <linux/io.h>		/* outb, outb_p			*/
+#include <linux/isa.h>
 #include <sound/tea575x-tuner.h>
 
 MODULE_AUTHOR("Ondrej Zary");
 MODULE_DESCRIPTION("MediaForte SF16-FMR2 FM radio card driver");
 MODULE_LICENSE("GPL");
 
+static int radio_nr = -1;
+module_param(radio_nr, int, 0444);
+MODULE_PARM_DESC(radio_nr, "Radio device number");
+
 struct fmr2 {
 	int io;
+	struct v4l2_device v4l2_dev;
 	struct snd_tea575x tea;
 	struct v4l2_ctrl *volume;
 	struct v4l2_ctrl *balance;
@@ -180,26 +186,45 @@ static int fmr2_tea_ext_init(struct snd_tea575x *tea)
 	return 0;
 }
 
-static int __init fmr2_init(void)
+static int __init fmr2_probe(struct device *pdev, unsigned int dev)
 {
 	struct fmr2 *fmr2 = &fmr2_card;
+	int err;
+
+	fmr2 = kzalloc(sizeof(*fmr2), GFP_KERNEL);
+	if (fmr2 == NULL)
+		return -ENOMEM;
 
+	strlcpy(fmr2->v4l2_dev.name, dev_name(pdev),
+			sizeof(fmr2->v4l2_dev.name));
 	fmr2->io = FMR2_PORT;
 
-	if (!request_region(fmr2->io, 2, "SF16-FMR2")) {
+	if (!request_region(fmr2->io, 2, fmr2->v4l2_dev.name)) {
 		printk(KERN_ERR "radio-sf16fmr2: I/O port 0x%x already in use\n", fmr2->io);
+		kfree(fmr2);
 		return -EBUSY;
 	}
 
+	err = v4l2_device_register(NULL, &fmr2->v4l2_dev);
+	if (err < 0) {
+		v4l2_err(&fmr2->v4l2_dev, "Could not register v4l2_device\n");
+		release_region(fmr2->io, 2);
+		kfree(fmr2);
+		return err;
+	}
+	fmr2->tea.v4l2_dev = &fmr2->v4l2_dev;
 	fmr2->tea.private_data = fmr2;
+	fmr2->tea.radio_nr = radio_nr;
 	fmr2->tea.ops = &fmr2_tea_ops;
 	fmr2->tea.ext_init = fmr2_tea_ext_init;
 	strlcpy(fmr2->tea.card, "SF16-FMR2", sizeof(fmr2->tea.card));
-	strcpy(fmr2->tea.bus_info, "ISA");
+	snprintf(fmr2->tea.bus_info, sizeof(fmr2->tea.bus_info), "ISA:%s",
+			fmr2->v4l2_dev.name);
 
 	if (snd_tea575x_init(&fmr2->tea)) {
 		printk(KERN_ERR "radio-sf16fmr2: Unable to detect TEA575x tuner\n");
 		release_region(fmr2->io, 2);
+		kfree(fmr2);
 		return -ENODEV;
 	}
 
@@ -207,12 +232,33 @@ static int __init fmr2_init(void)
 	return 0;
 }
 
-static void __exit fmr2_exit(void)
+static int __exit fmr2_remove(struct device *pdev, unsigned int dev)
 {
-	struct fmr2 *fmr2 = &fmr2_card;
+	struct fmr2 *fmr2 = dev_get_drvdata(pdev);
 
 	snd_tea575x_exit(&fmr2->tea);
 	release_region(fmr2->io, 2);
+	v4l2_device_unregister(&fmr2->v4l2_dev);
+	kfree(fmr2);
+	return 0;
+}
+
+struct isa_driver fmr2_driver = {
+	.probe		= fmr2_probe,
+	.remove		= fmr2_remove,
+	.driver		= {
+		.name	= "radio-sf16fmr2",
+	},
+};
+
+static int __init fmr2_init(void)
+{
+	return isa_register_driver(&fmr2_driver, 1);
+}
+
+static void __exit fmr2_exit(void)
+{
+	isa_unregister_driver(&fmr2_driver);
 }
 
 module_init(fmr2_init);
diff --git a/include/sound/tea575x-tuner.h b/include/sound/tea575x-tuner.h
index 726e947..ec3f910 100644
--- a/include/sound/tea575x-tuner.h
+++ b/include/sound/tea575x-tuner.h
@@ -25,6 +25,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
 
 #define TEA575X_FMIF	10700
 
@@ -42,13 +43,16 @@ struct snd_tea575x_ops {
 };
 
 struct snd_tea575x {
+	struct v4l2_device *v4l2_dev;
 	struct video_device vd;		/* video device */
+	int radio_nr;			/* radio_nr */
 	bool tea5759;			/* 5759 chip is present */
+	bool cannot_read_data;		/* Device cannot read the data pin */
 	bool mute;			/* Device is muted? */
 	bool stereo;			/* receiving stereo */
 	bool tuned;			/* tuned to a station */
 	unsigned int val;		/* hw value */
-	unsigned long freq;		/* frequency */
+	u32 freq;			/* frequency */
 	struct mutex mutex;
 	struct snd_tea575x_ops *ops;
 	void *private_data;
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index 6b68c82..ae4397d 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -25,8 +25,10 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/version.h>
+#include <linux/sched.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
 #include <media/v4l2-ioctl.h>
 #include <sound/tea575x-tuner.h>
 
@@ -34,12 +36,8 @@ MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
 MODULE_DESCRIPTION("Routines for control of TEA5757/5759 Philips AM/FM radio tuner chips");
 MODULE_LICENSE("GPL");
 
-static int radio_nr = -1;
-module_param(radio_nr, int, 0);
-
-#define RADIO_VERSION KERNEL_VERSION(0, 0, 2)
-#define FREQ_LO		 (50UL * 16000)
-#define FREQ_HI		(150UL * 16000)
+#define FREQ_LO		 (76U * 16000)
+#define FREQ_HI		(108U * 16000)
 
 /*
  * definitions
@@ -121,28 +119,10 @@ static unsigned int snd_tea575x_read(struct snd_tea575x *tea)
 	return data;
 }
 
-static void snd_tea575x_get_freq(struct snd_tea575x *tea)
-{
-	unsigned long freq;
-
-	freq = snd_tea575x_read(tea) & TEA575X_BIT_FREQ_MASK;
-	/* freq *= 12.5 */
-	freq *= 125;
-	freq /= 10;
-	/* crystal fixup */
-	if (tea->tea5759)
-		freq += TEA575X_FMIF;
-	else
-		freq -= TEA575X_FMIF;
-
-	tea->freq = freq * 16;		/* from kHz */
-}
-
 static void snd_tea575x_set_freq(struct snd_tea575x *tea)
 {
-	unsigned long freq;
+	u32 freq = tea->freq;
 
-	freq = clamp(tea->freq, FREQ_LO, FREQ_HI);
 	freq /= 16;		/* to kHz */
 	/* crystal fixup */
 	if (tea->tea5759)
@@ -167,12 +147,14 @@ static int vidioc_querycap(struct file *file, void  *priv,
 {
 	struct snd_tea575x *tea = video_drvdata(file);
 
-	strlcpy(v->driver, "tea575x-tuner", sizeof(v->driver));
+	strlcpy(v->driver, tea->v4l2_dev->name, sizeof(v->driver));
 	strlcpy(v->card, tea->card, sizeof(v->card));
 	strlcat(v->card, tea->tea5759 ? " TEA5759" : " TEA5757", sizeof(v->card));
 	strlcpy(v->bus_info, tea->bus_info, sizeof(v->bus_info));
-	v->version = RADIO_VERSION;
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	if (!tea->cannot_read_data)
+		v->device_caps |= V4L2_CAP_HW_FREQ_SEEK;
+	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -191,18 +173,24 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
 	v->rangelow = FREQ_LO;
 	v->rangehigh = FREQ_HI;
-	v->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
-	v->audmode = tea->stereo ? V4L2_TUNER_MODE_STEREO : V4L2_TUNER_MODE_MONO;
+	v->rxsubchans = tea->stereo ? V4L2_TUNER_SUB_STEREO : V4L2_TUNER_SUB_MONO;
+	v->audmode = (tea->val & TEA575X_BIT_MONO) ?
+		V4L2_TUNER_MODE_MONO : V4L2_TUNER_MODE_STEREO;
 	v->signal = tea->tuned ? 0xffff : 0;
-
 	return 0;
 }
 
 static int vidioc_s_tuner(struct file *file, void *priv,
 					struct v4l2_tuner *v)
 {
-	if (v->index > 0)
+	struct snd_tea575x *tea = video_drvdata(file);
+
+	if (v->index)
 		return -EINVAL;
+	tea->val &= ~TEA575X_BIT_MONO;
+	if (v->audmode == V4L2_TUNER_MODE_MONO)
+		tea->val |= TEA575X_BIT_MONO;
+	snd_tea575x_write(tea, tea->val);
 	return 0;
 }
 
@@ -214,7 +202,6 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	if (f->tuner != 0)
 		return -EINVAL;
 	f->type = V4L2_TUNER_RADIO;
-	snd_tea575x_get_freq(tea);
 	f->frequency = tea->freq;
 	return 0;
 }
@@ -227,32 +214,45 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
 
-	if (f->frequency < FREQ_LO || f->frequency > FREQ_HI)
-		return -EINVAL;
-
-	tea->freq = f->frequency;
-
+	tea->val &= ~TEA575X_BIT_SEARCH;
+	tea->freq = clamp(f->frequency, FREQ_LO, FREQ_HI);
 	snd_tea575x_set_freq(tea);
-
 	return 0;
 }
 
-static int vidioc_g_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
+static int vidioc_s_hw_freq_seek(struct file *file, void *fh,
+					struct v4l2_hw_freq_seek *a)
 {
-	if (a->index > 1)
-		return -EINVAL;
-
-	strcpy(a->name, "Radio");
-	a->capability = V4L2_AUDCAP_STEREO;
-	return 0;
-}
+	struct snd_tea575x *tea = video_drvdata(file);
 
-static int vidioc_s_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
-{
-	if (a->index != 0)
-		return -EINVAL;
+	if (tea->cannot_read_data)
+		return -ENOTTY;
+	tea->val |= TEA575X_BIT_SEARCH;
+	tea->val &= ~TEA575X_BIT_UPDOWN;
+	if (a->seek_upward)
+		tea->val |= TEA575X_BIT_UPDOWN;
+	snd_tea575x_write(tea, tea->val);
+	for (;;) {
+		unsigned val = snd_tea575x_read(tea);
+
+		if (!(val & TEA575X_BIT_SEARCH)) {
+			/* Found a frequency */
+			val &= TEA575X_BIT_FREQ_MASK;
+			val = (val * 10) / 125;
+			if (tea->tea5759)
+				val += TEA575X_FMIF;
+			else
+				val -= TEA575X_FMIF;
+			tea->freq = clamp(val * 16, FREQ_LO, FREQ_HI);
+			return 0;
+		}
+		if (schedule_timeout_interruptible(msecs_to_jiffies(10))) {
+			/* some signal arrived, stop search */
+			tea->val &= ~TEA575X_BIT_SEARCH;
+			snd_tea575x_write(tea, tea->val);
+			return -ERESTARTSYS;
+		}
+	}
 	return 0;
 }
 
@@ -273,23 +273,25 @@ static int tea575x_s_ctrl(struct v4l2_ctrl *ctrl)
 static const struct v4l2_file_operations tea575x_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= video_ioctl2,
+	.open           = v4l2_fh_open,
+	.release        = v4l2_fh_release,
+	.poll           = v4l2_ctrl_poll,
 };
 
 static const struct v4l2_ioctl_ops tea575x_ioctl_ops = {
 	.vidioc_querycap    = vidioc_querycap,
 	.vidioc_g_tuner     = vidioc_g_tuner,
 	.vidioc_s_tuner     = vidioc_s_tuner,
-	.vidioc_g_audio     = vidioc_g_audio,
-	.vidioc_s_audio     = vidioc_s_audio,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
+	.vidioc_s_hw_freq_seek = vidioc_s_hw_freq_seek,
+	.vidioc_log_status  = v4l2_ctrl_log_status,
 };
 
-static struct video_device tea575x_radio = {
-	.name           = "tea575x-tuner",
+static const struct video_device tea575x_radio = {
 	.fops           = &tea575x_fops,
 	.ioctl_ops 	= &tea575x_ioctl_ops,
-	.release	= video_device_release_empty,
+	.release        = video_device_release_empty,
 };
 
 static const struct v4l2_ctrl_ops tea575x_ctrl_ops = {
@@ -303,11 +305,15 @@ int snd_tea575x_init(struct snd_tea575x *tea)
 {
 	int retval;
 
-	tea->mute = 1;
+	tea->mute = true;
 
-	snd_tea575x_write(tea, 0x55AA);
-	if (snd_tea575x_read(tea) != 0x55AA)
-		return -ENODEV;
+	/* Not all devices can or know how to read the data back.
+	   Such devices can set cannot_read_data to true. */
+	if (!tea->cannot_read_data) {
+		snd_tea575x_write(tea, 0x55AA);
+		if (snd_tea575x_read(tea) != 0x55AA)
+			return -ENODEV;
+	}
 
 	tea->val = TEA575X_BIT_BAND_FM | TEA575X_BIT_SEARCH_10_40;
 	tea->freq = 90500 * 16;		/* 90.5Mhz default */
@@ -316,14 +322,17 @@ int snd_tea575x_init(struct snd_tea575x *tea)
 	tea->vd = tea575x_radio;
 	video_set_drvdata(&tea->vd, tea);
 	mutex_init(&tea->mutex);
+	strlcpy(tea->vd.name, tea->v4l2_dev->name, sizeof(tea->vd.name));
 	tea->vd.lock = &tea->mutex;
+	tea->vd.v4l2_dev = tea->v4l2_dev;
+	tea->vd.ctrl_handler = &tea->ctrl_handler;
+	set_bit(V4L2_FL_USE_FH_PRIO, &tea->vd.flags);
 
 	v4l2_ctrl_handler_init(&tea->ctrl_handler, 1);
-	tea->vd.ctrl_handler = &tea->ctrl_handler;
 	v4l2_ctrl_new_std(&tea->ctrl_handler, &tea575x_ctrl_ops, V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
 	retval = tea->ctrl_handler.error;
 	if (retval) {
-		printk(KERN_ERR "tea575x-tuner: can't initialize controls\n");
+		v4l2_err(tea->v4l2_dev, "can't initialize controls\n");
 		v4l2_ctrl_handler_free(&tea->ctrl_handler);
 		return retval;
 	}
@@ -338,9 +347,9 @@ int snd_tea575x_init(struct snd_tea575x *tea)
 
 	v4l2_ctrl_handler_setup(&tea->ctrl_handler);
 
-	retval = video_register_device(&tea->vd, VFL_TYPE_RADIO, radio_nr);
+	retval = video_register_device(&tea->vd, VFL_TYPE_RADIO, tea->radio_nr);
 	if (retval) {
-		printk(KERN_ERR "tea575x-tuner: can't register video device!\n");
+		v4l2_err(tea->v4l2_dev, "can't register video device!\n");
 		v4l2_ctrl_handler_free(&tea->ctrl_handler);
 		return retval;
 	}
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index cb557c6..a8faae1 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -142,6 +142,7 @@ static int enable_mpu[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 2};
 #ifdef SUPPORT_JOYSTICK
 static bool joystick[SNDRV_CARDS];
 #endif
+static int radio_nr[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = -1};
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for " CARD_NAME " soundcard.");
@@ -165,6 +166,9 @@ MODULE_PARM_DESC(enable_mpu, "Enable MPU401.  (0 = off, 1 = on, 2 = auto)");
 module_param_array(joystick, bool, NULL, 0444);
 MODULE_PARM_DESC(joystick, "Enable joystick.");
 #endif
+module_param_array(radio_nr, int, NULL, 0444);
+MODULE_PARM_DESC(radio_nr, "Radio device numbers");
+
 
 
 #define NR_APUS			64
@@ -558,6 +562,7 @@ struct es1968 {
 	struct work_struct hwvol_work;
 
 #ifdef CONFIG_SND_ES1968_RADIO
+	struct v4l2_device v4l2_dev;
 	struct snd_tea575x tea;
 #endif
 };
@@ -2613,6 +2618,7 @@ static int snd_es1968_free(struct es1968 *chip)
 
 #ifdef CONFIG_SND_ES1968_RADIO
 	snd_tea575x_exit(&chip->tea);
+	v4l2_device_unregister(&chip->v4l2_dev);
 #endif
 
 	if (chip->irq >= 0)
@@ -2655,6 +2661,7 @@ static int __devinit snd_es1968_create(struct snd_card *card,
 				       int capt_streams,
 				       int chip_type,
 				       int do_pm,
+				       int radio_nr,
 				       struct es1968 **chip_ret)
 {
 	static struct snd_device_ops ops = {
@@ -2751,7 +2758,14 @@ static int __devinit snd_es1968_create(struct snd_card *card,
 	snd_card_set_dev(card, &pci->dev);
 
 #ifdef CONFIG_SND_ES1968_RADIO
+	err = v4l2_device_register(&pci->dev, &chip->v4l2_dev);
+	if (err < 0) {
+		snd_es1968_free(chip);
+		return err;
+	}
+	chip->tea.v4l2_dev = &chip->v4l2_dev;
 	chip->tea.private_data = chip;
+	chip->tea.radio_nr = radio_nr;
 	chip->tea.ops = &snd_es1968_tea_ops;
 	strlcpy(chip->tea.card, "SF64-PCE2", sizeof(chip->tea.card));
 	sprintf(chip->tea.bus_info, "PCI:%s", pci_name(pci));
@@ -2797,6 +2811,7 @@ static int __devinit snd_es1968_probe(struct pci_dev *pci,
 				     pcm_substreams_c[dev],
 				     pci_id->driver_data,
 				     use_pm[dev],
+				     radio_nr[dev],
 				     &chip)) < 0) {
 		snd_card_free(card);
 		return err;
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index 9597ef1..a416ea8 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -58,6 +58,7 @@ static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card
  *  High 16-bits are video (radio) device number + 1
  */
 static int tea575x_tuner[SNDRV_CARDS];
+static int radio_nr[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = -1};
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for the FM801 soundcard.");
@@ -67,6 +68,9 @@ module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable FM801 soundcard.");
 module_param_array(tea575x_tuner, int, NULL, 0444);
 MODULE_PARM_DESC(tea575x_tuner, "TEA575x tuner access method (0 = auto, 1 = SF256-PCS, 2=SF256-PCP, 3=SF64-PCR, 8=disable, +16=tuner-only).");
+module_param_array(radio_nr, int, NULL, 0444);
+MODULE_PARM_DESC(radio_nr, "Radio device numbers");
+
 
 #define TUNER_DISABLED		(1<<3)
 #define TUNER_ONLY		(1<<4)
@@ -197,6 +201,7 @@ struct fm801 {
 	struct snd_info_entry *proc_entry;
 
 #ifdef CONFIG_SND_FM801_TEA575X_BOOL
+	struct v4l2_device v4l2_dev;
 	struct snd_tea575x tea;
 #endif
 
@@ -1154,8 +1159,10 @@ static int snd_fm801_free(struct fm801 *chip)
 
       __end_hw:
 #ifdef CONFIG_SND_FM801_TEA575X_BOOL
-	if (!(chip->tea575x_tuner & TUNER_DISABLED))
+	if (!(chip->tea575x_tuner & TUNER_DISABLED)) {
 		snd_tea575x_exit(&chip->tea);
+		v4l2_device_unregister(&chip->v4l2_dev);
+	}
 #endif
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
@@ -1175,6 +1182,7 @@ static int snd_fm801_dev_free(struct snd_device *device)
 static int __devinit snd_fm801_create(struct snd_card *card,
 				      struct pci_dev * pci,
 				      int tea575x_tuner,
+				      int radio_nr,
 				      struct fm801 ** rchip)
 {
 	struct fm801 *chip;
@@ -1234,6 +1242,13 @@ static int __devinit snd_fm801_create(struct snd_card *card,
 	snd_card_set_dev(card, &pci->dev);
 
 #ifdef CONFIG_SND_FM801_TEA575X_BOOL
+	err = v4l2_device_register(&pci->dev, &chip->v4l2_dev);
+	if (err < 0) {
+		snd_fm801_free(chip);
+		return err;
+	}
+	chip->tea.v4l2_dev = &chip->v4l2_dev;
+	chip->tea.radio_nr = radio_nr;
 	chip->tea.private_data = chip;
 	chip->tea.ops = &snd_fm801_tea_ops;
 	sprintf(chip->tea.bus_info, "PCI:%s", pci_name(pci));
@@ -1241,6 +1256,7 @@ static int __devinit snd_fm801_create(struct snd_card *card,
 	    (tea575x_tuner & TUNER_TYPE_MASK) < 4) {
 		if (snd_tea575x_init(&chip->tea)) {
 			snd_printk(KERN_ERR "TEA575x radio not found\n");
+			snd_fm801_free(chip);
 			return -ENODEV;
 		}
 	} else if ((tea575x_tuner & TUNER_TYPE_MASK) == 0) {
@@ -1287,7 +1303,7 @@ static int __devinit snd_card_fm801_probe(struct pci_dev *pci,
 	err = snd_card_create(index[dev], id[dev], THIS_MODULE, 0, &card);
 	if (err < 0)
 		return err;
-	if ((err = snd_fm801_create(card, pci, tea575x_tuner[dev], &chip)) < 0) {
+	if ((err = snd_fm801_create(card, pci, tea575x_tuner[dev], radio_nr[dev], &chip)) < 0) {
 		snd_card_free(card);
 		return err;
 	}
-- 
1.7.8.3

