Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2517 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2APNKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:10:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 08/10] radio-typhoon: Convert to radio-isa.
Date: Mon, 16 Jan 2012 14:10:04 +0100
Message-Id: <33744ecf570f266b9612cb7002796fe0c6f2679c.1326717025.git.hans.verkuil@cisco.com>
In-Reply-To: <1326719406-4538-1-git-send-email-hverkuil@xs4all.nl>
References: <1326719406-4538-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <30958c9eb2499987a608cdf411e578984b617046.1326717025.git.hans.verkuil@cisco.com>
References: <30958c9eb2499987a608cdf411e578984b617046.1326717025.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Tested with v4l2-compliance, but not with actual hardware. Contact the
linux-media mailinglist if you have this card!

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/Kconfig         |    8 +-
 drivers/media/radio/radio-typhoon.c |  365 +++++++----------------------------
 2 files changed, 73 insertions(+), 300 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index bc2da17..a6710d5 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -390,14 +390,14 @@ config RADIO_TRUST_PORT
 config RADIO_TYPHOON
 	tristate "Typhoon Radio (a.k.a. EcoRadio)"
 	depends on ISA && VIDEO_V4L2
+	select RADIO_ISA
 	---help---
 	  Choose Y here if you have one of these FM radio cards, and then fill
 	  in the port address and the frequency used for muting below.
 
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
+	  Note: this driver hasn't been tested since a long time due to lack
+	  of hardware. If you have this hardware, then please contact the
+	  linux-media mailinglist.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-typhoon.
diff --git a/drivers/media/radio/radio-typhoon.c b/drivers/media/radio/radio-typhoon.c
index 398726a..145d10c 100644
--- a/drivers/media/radio/radio-typhoon.c
+++ b/drivers/media/radio/radio-typhoon.c
@@ -35,61 +35,50 @@
 #include <linux/io.h>		/* outb, outb_p                   */
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include "radio-isa.h"
 
 #define DRIVER_VERSION "0.1.2"
 
 MODULE_AUTHOR("Dr. Henrik Seidel");
 MODULE_DESCRIPTION("A driver for the Typhoon radio card (a.k.a. EcoRadio).");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRIVER_VERSION);
+MODULE_VERSION("0.1.99");
 
 #ifndef CONFIG_RADIO_TYPHOON_PORT
 #define CONFIG_RADIO_TYPHOON_PORT -1
 #endif
 
 #ifndef CONFIG_RADIO_TYPHOON_MUTEFREQ
-#define CONFIG_RADIO_TYPHOON_MUTEFREQ 0
+#define CONFIG_RADIO_TYPHOON_MUTEFREQ 87000
 #endif
 
-static int io = CONFIG_RADIO_TYPHOON_PORT;
-static int radio_nr = -1;
-
-module_param(io, int, 0);
-MODULE_PARM_DESC(io, "I/O address of the Typhoon card (0x316 or 0x336)");
-
-module_param(radio_nr, int, 0);
+#define TYPHOON_MAX 2
 
+static int io[TYPHOON_MAX] = { [0] = CONFIG_RADIO_TYPHOON_PORT,
+			      [1 ... (TYPHOON_MAX - 1)] = -1 };
+static int radio_nr[TYPHOON_MAX]	= { [0 ... (TYPHOON_MAX - 1)] = -1 };
 static unsigned long mutefreq = CONFIG_RADIO_TYPHOON_MUTEFREQ;
+
+module_param_array(io, int, NULL, 0444);
+MODULE_PARM_DESC(io, "I/O addresses of the Typhoon card (0x316 or 0x336)");
+module_param_array(radio_nr, int, NULL, 0444);
+MODULE_PARM_DESC(radio_nr, "Radio device numbers");
 module_param(mutefreq, ulong, 0);
 MODULE_PARM_DESC(mutefreq, "Frequency used when muting the card (in kHz)");
 
-#define BANNER "Typhoon Radio Card driver v" DRIVER_VERSION "\n"
-
 struct typhoon {
-	struct v4l2_device v4l2_dev;
-	struct video_device vdev;
-	int io;
-	int curvol;
+	struct radio_isa_card isa;
 	int muted;
-	unsigned long curfreq;
-	unsigned long mutefreq;
-	struct mutex lock;
 };
 
-static struct typhoon typhoon_card;
-
-static void typhoon_setvol_generic(struct typhoon *dev, int vol)
+static struct radio_isa_card *typhoon_alloc(void)
 {
-	mutex_lock(&dev->lock);
-	vol >>= 14;				/* Map 16 bit to 2 bit */
-	vol &= 3;
-	outb_p(vol / 2, dev->io);		/* Set the volume, high bit. */
-	outb_p(vol % 2, dev->io + 2);	/* Set the volume, low bit. */
-	mutex_unlock(&dev->lock);
+	struct typhoon *ty = kzalloc(sizeof(*ty), GFP_KERNEL);
+
+	return ty ? &ty->isa : NULL;
 }
 
-static int typhoon_setfreq_generic(struct typhoon *dev,
-				   unsigned long frequency)
+static int typhoon_s_frequency(struct radio_isa_card *isa, u32 freq)
 {
 	unsigned long outval;
 	unsigned long x;
@@ -105,302 +94,86 @@ static int typhoon_setfreq_generic(struct typhoon *dev,
 	 *
 	 */
 
-	mutex_lock(&dev->lock);
-	x = frequency / 160;
+	x = freq / 160;
 	outval = (x * x + 2500) / 5000;
 	outval = (outval * x + 5000) / 10000;
 	outval -= (10 * x * x + 10433) / 20866;
 	outval += 4 * x - 11505;
 
-	outb_p((outval >> 8) & 0x01, dev->io + 4);
-	outb_p(outval >> 9, dev->io + 6);
-	outb_p(outval & 0xff, dev->io + 8);
-	mutex_unlock(&dev->lock);
-
-	return 0;
-}
-
-static int typhoon_setfreq(struct typhoon *dev, unsigned long frequency)
-{
-	typhoon_setfreq_generic(dev, frequency);
-	dev->curfreq = frequency;
-	return 0;
-}
-
-static void typhoon_mute(struct typhoon *dev)
-{
-	if (dev->muted == 1)
-		return;
-	typhoon_setvol_generic(dev, 0);
-	typhoon_setfreq_generic(dev, dev->mutefreq);
-	dev->muted = 1;
-}
-
-static void typhoon_unmute(struct typhoon *dev)
-{
-	if (dev->muted == 0)
-		return;
-	typhoon_setfreq_generic(dev, dev->curfreq);
-	typhoon_setvol_generic(dev, dev->curvol);
-	dev->muted = 0;
-}
-
-static int typhoon_setvol(struct typhoon *dev, int vol)
-{
-	if (dev->muted && vol != 0) {	/* user is unmuting the card */
-		dev->curvol = vol;
-		typhoon_unmute(dev);
-		return 0;
-	}
-	if (vol == dev->curvol)		/* requested volume == current */
-		return 0;
-
-	if (vol == 0) {			/* volume == 0 means mute the card */
-		typhoon_mute(dev);
-		dev->curvol = vol;
-		return 0;
-	}
-	typhoon_setvol_generic(dev, vol);
-	dev->curvol = vol;
-	return 0;
-}
-
-static int vidioc_querycap(struct file *file, void  *priv,
-					struct v4l2_capability *v)
-{
-	strlcpy(v->driver, "radio-typhoon", sizeof(v->driver));
-	strlcpy(v->card, "Typhoon Radio", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
-	return 0;
-}
-
-static int vidioc_g_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *v)
-{
-	if (v->index > 0)
-		return -EINVAL;
-
-	strlcpy(v->name, "FM", sizeof(v->name));
-	v->type = V4L2_TUNER_RADIO;
-	v->rangelow = 87.5 * 16000;
-	v->rangehigh = 108 * 16000;
-	v->rxsubchans = V4L2_TUNER_SUB_MONO;
-	v->capability = V4L2_TUNER_CAP_LOW;
-	v->audmode = V4L2_TUNER_MODE_MONO;
-	v->signal = 0xFFFF;     /* We can't get the signal strength */
-	return 0;
-}
-
-static int vidioc_s_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *v)
-{
-	return v->index ? -EINVAL : 0;
-}
-
-static int vidioc_g_frequency(struct file *file, void *priv,
-					struct v4l2_frequency *f)
-{
-	struct typhoon *dev = video_drvdata(file);
-
-	if (f->tuner != 0)
-		return -EINVAL;
-	f->type = V4L2_TUNER_RADIO;
-	f->frequency = dev->curfreq;
-	return 0;
-}
-
-static int vidioc_s_frequency(struct file *file, void *priv,
-					struct v4l2_frequency *f)
-{
-	struct typhoon *dev = video_drvdata(file);
-
-	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
-		return -EINVAL;
-	dev->curfreq = f->frequency;
-	typhoon_setfreq(dev, dev->curfreq);
+	outb_p((outval >> 8) & 0x01, isa->io + 4);
+	outb_p(outval >> 9, isa->io + 6);
+	outb_p(outval & 0xff, isa->io + 8);
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-					struct v4l2_queryctrl *qc)
+static int typhoon_s_mute_volume(struct radio_isa_card *isa, bool mute, int vol)
 {
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(qc, 0, 65535, 16384, 65535);
-	}
-	return -EINVAL;
-}
+	struct typhoon *ty = container_of(isa, struct typhoon, isa);
 
-static int vidioc_g_ctrl(struct file *file, void *priv,
-					struct v4l2_control *ctrl)
-{
-	struct typhoon *dev = video_drvdata(file);
+	if (mute)
+		vol = 0;
+	vol >>= 14;			/* Map 16 bit to 2 bit */
+	vol &= 3;
+	outb_p(vol / 2, isa->io);	/* Set the volume, high bit. */
+	outb_p(vol % 2, isa->io + 2);	/* Set the volume, low bit. */
 
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = dev->muted;
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = dev->curvol;
-		return 0;
+	if (vol == 0 && !ty->muted) {
+		ty->muted = true;
+		return typhoon_s_frequency(isa, mutefreq << 4);
 	}
-	return -EINVAL;
-}
-
-static int vidioc_s_ctrl (struct file *file, void *priv,
-					struct v4l2_control *ctrl)
-{
-	struct typhoon *dev = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		if (ctrl->value)
-			typhoon_mute(dev);
-		else
-			typhoon_unmute(dev);
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		typhoon_setvol(dev, ctrl->value);
-		return 0;
+	if (vol && ty->muted) {
+		ty->muted = false;
+		return typhoon_s_frequency(isa, isa->freq);
 	}
-	return -EINVAL;
-}
-
-static int vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	*i = 0;
 	return 0;
 }
 
-static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
-{
-	return i ? -EINVAL : 0;
-}
-
-static int vidioc_g_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
-{
-	a->index = 0;
-	strlcpy(a->name, "Radio", sizeof(a->name));
-	a->capability = V4L2_AUDCAP_STEREO;
-	return 0;
-}
-
-static int vidioc_s_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
-{
-	return a->index ? -EINVAL : 0;
-}
-
-static int vidioc_log_status(struct file *file, void *priv)
-{
-	struct typhoon *dev = video_drvdata(file);
-	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
-
-	v4l2_info(v4l2_dev, BANNER);
-#ifdef MODULE
-	v4l2_info(v4l2_dev, "Load type: Driver loaded as a module\n\n");
-#else
-	v4l2_info(v4l2_dev, "Load type: Driver compiled into kernel\n\n");
-#endif
-	v4l2_info(v4l2_dev, "frequency = %lu kHz\n", dev->curfreq >> 4);
-	v4l2_info(v4l2_dev, "volume = %d\n", dev->curvol);
-	v4l2_info(v4l2_dev, "mute = %s\n", dev->muted ?  "on" : "off");
-	v4l2_info(v4l2_dev, "io = 0x%x\n", dev->io);
-	v4l2_info(v4l2_dev, "mute frequency = %lu kHz\n", dev->mutefreq >> 4);
-	return 0;
-}
-
-static const struct v4l2_file_operations typhoon_fops = {
-	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= video_ioctl2,
+static const struct radio_isa_ops typhoon_ops = {
+	.alloc = typhoon_alloc,
+	.s_mute_volume = typhoon_s_mute_volume,
+	.s_frequency = typhoon_s_frequency,
 };
 
-static const struct v4l2_ioctl_ops typhoon_ioctl_ops = {
-	.vidioc_log_status  = vidioc_log_status,
-	.vidioc_querycap    = vidioc_querycap,
-	.vidioc_g_tuner     = vidioc_g_tuner,
-	.vidioc_s_tuner     = vidioc_s_tuner,
-	.vidioc_g_audio     = vidioc_g_audio,
-	.vidioc_s_audio     = vidioc_s_audio,
-	.vidioc_g_input     = vidioc_g_input,
-	.vidioc_s_input     = vidioc_s_input,
-	.vidioc_g_frequency = vidioc_g_frequency,
-	.vidioc_s_frequency = vidioc_s_frequency,
-	.vidioc_queryctrl   = vidioc_queryctrl,
-	.vidioc_g_ctrl      = vidioc_g_ctrl,
-	.vidioc_s_ctrl      = vidioc_s_ctrl,
+static const int typhoon_ioports[] = { 0x316, 0x336 };
+
+static struct radio_isa_driver typhoon_driver = {
+	.driver = {
+		.match		= radio_isa_match,
+		.probe		= radio_isa_probe,
+		.remove		= radio_isa_remove,
+		.driver		= {
+			.name	= "radio-typhoon",
+		},
+	},
+	.io_params = io,
+	.radio_nr_params = radio_nr,
+	.io_ports = typhoon_ioports,
+	.num_of_io_ports = ARRAY_SIZE(typhoon_ioports),
+	.region_size = 8,
+	.card = "Typhoon Radio",
+	.ops = &typhoon_ops,
+	.has_stereo = true,
+	.max_volume = 3,
 };
 
 static int __init typhoon_init(void)
 {
-	struct typhoon *dev = &typhoon_card;
-	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
-	int res;
-
-	strlcpy(v4l2_dev->name, "typhoon", sizeof(v4l2_dev->name));
-	dev->io = io;
-
-	if (dev->io == -1) {
-		v4l2_err(v4l2_dev, "You must set an I/O address with io=0x316 or io=0x336\n");
-		return -EINVAL;
-	}
-
-	if (mutefreq < 87000 || mutefreq > 108500) {
-		v4l2_err(v4l2_dev, "You must set a frequency (in kHz) used when muting the card,\n");
-		v4l2_err(v4l2_dev, "e.g. with \"mutefreq=87500\" (87000 <= mutefreq <= 108500)\n");
-		return -EINVAL;
-	}
-	dev->curfreq = dev->mutefreq = mutefreq << 4;
-
-	mutex_init(&dev->lock);
-	if (!request_region(dev->io, 8, "typhoon")) {
-		v4l2_err(v4l2_dev, "port 0x%x already in use\n",
-		       dev->io);
-		return -EBUSY;
-	}
-
-	res = v4l2_device_register(NULL, v4l2_dev);
-	if (res < 0) {
-		release_region(dev->io, 8);
-		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
-		return res;
+	if (mutefreq < 87000 || mutefreq > 108000) {
+		printk(KERN_ERR "%s: You must set a frequency (in kHz) used when muting the card,\n",
+				typhoon_driver.driver.driver.name);
+		printk(KERN_ERR "%s: e.g. with \"mutefreq=87500\" (87000 <= mutefreq <= 108000)\n",
+				typhoon_driver.driver.driver.name);
+		return -ENODEV;
 	}
-	v4l2_info(v4l2_dev, BANNER);
-
-	strlcpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
-	dev->vdev.v4l2_dev = v4l2_dev;
-	dev->vdev.fops = &typhoon_fops;
-	dev->vdev.ioctl_ops = &typhoon_ioctl_ops;
-	dev->vdev.release = video_device_release_empty;
-	video_set_drvdata(&dev->vdev, dev);
-
-	/* mute card - prevents noisy bootups */
-	typhoon_mute(dev);
-
-	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-		v4l2_device_unregister(&dev->v4l2_dev);
-		release_region(dev->io, 8);
-		return -EINVAL;
-	}
-	v4l2_info(v4l2_dev, "port 0x%x.\n", dev->io);
-	v4l2_info(v4l2_dev, "mute frequency is %lu kHz.\n", mutefreq);
-
-	return 0;
+	return isa_register_driver(&typhoon_driver.driver, TYPHOON_MAX);
 }
 
 static void __exit typhoon_exit(void)
 {
-	struct typhoon *dev = &typhoon_card;
-
-	video_unregister_device(&dev->vdev);
-	v4l2_device_unregister(&dev->v4l2_dev);
-	release_region(dev->io, 8);
+	isa_unregister_driver(&typhoon_driver.driver);
 }
 
+
 module_init(typhoon_init);
 module_exit(typhoon_exit);
 
-- 
1.7.7.3

