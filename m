Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4085 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab2APNKb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:10:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 09/10] radio-zoltrix: Convert to radio-isa.
Date: Mon, 16 Jan 2012 14:10:05 +0100
Message-Id: <bd427652e313a1f13c24f1d3e3b96f05198aa6d6.1326717025.git.hans.verkuil@cisco.com>
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
 drivers/media/radio/radio-zoltrix.c |  441 +++++++++--------------------------
 2 files changed, 115 insertions(+), 334 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index a6710d5..c31bd76 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -424,14 +424,14 @@ config RADIO_TYPHOON_MUTEFREQ
 config RADIO_ZOLTRIX
 	tristate "Zoltrix Radio"
 	depends on ISA && VIDEO_V4L2
+	select RADIO_ISA
 	---help---
 	  Choose Y here if you have one of these FM radio cards, and then fill
 	  in the port address below.
 
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
+	  Note: this driver hasn't been tested since a long time due to lack
+	  of hardware. If you have this hardware, then please contact the
+	  linux-media mailinglist.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-zoltrix.
diff --git a/drivers/media/radio/radio-zoltrix.c b/drivers/media/radio/radio-zoltrix.c
index f5613b9..33dc089 100644
--- a/drivers/media/radio/radio-zoltrix.c
+++ b/drivers/media/radio/radio-zoltrix.c
@@ -1,5 +1,6 @@
-/* zoltrix radio plus driver for Linux radio support
- * (c) 1998 C. van Schaik <carl@leg.uct.ac.za>
+/*
+ * Zoltrix Radio Plus driver
+ * Copyright 1998 C. van Schaik <carl@leg.uct.ac.za>
  *
  * BUGS
  *  Due to the inconsistency in reading from the signal flags
@@ -27,6 +28,14 @@
  *
  * 2006-07-24 - Converted to V4L2 API
  *		by Mauro Carvalho Chehab <mchehab@infradead.org>
+ *
+ * Converted to the radio-isa framework by Hans Verkuil <hans.verkuil@cisco.com>
+ *
+ * Note that this is the driver for the Zoltrix Radio Plus.
+ * This driver does not work for the Zoltrix Radio Plus 108 or the
+ * Zoltrix Radio Plus for Windows.
+ *
+ * Fully tested with the Keene USB FM Transmitter and the v4l2-compliance tool.
  */
 
 #include <linux/module.h>	/* Modules                        */
@@ -38,80 +47,67 @@
 #include <linux/io.h>		/* outb, outb_p                   */
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include "radio-isa.h"
 
-MODULE_AUTHOR("C.van Schaik");
+MODULE_AUTHOR("C. van Schaik");
 MODULE_DESCRIPTION("A driver for the Zoltrix Radio Plus.");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0.0.3");
+MODULE_VERSION("0.1.99");
 
 #ifndef CONFIG_RADIO_ZOLTRIX_PORT
 #define CONFIG_RADIO_ZOLTRIX_PORT -1
 #endif
 
-static int io = CONFIG_RADIO_ZOLTRIX_PORT;
-static int radio_nr = -1;
+#define ZOLTRIX_MAX 2
+
+static int io[ZOLTRIX_MAX] = { [0] = CONFIG_RADIO_ZOLTRIX_PORT,
+			       [1 ... (ZOLTRIX_MAX - 1)] = -1 };
+static int radio_nr[ZOLTRIX_MAX] = { [0 ... (ZOLTRIX_MAX - 1)] = -1 };
 
-module_param(io, int, 0);
-MODULE_PARM_DESC(io, "I/O address of the Zoltrix Radio Plus (0x20c or 0x30c)");
-module_param(radio_nr, int, 0);
+module_param_array(io, int, NULL, 0444);
+MODULE_PARM_DESC(io, "I/O addresses of the Zoltrix Radio Plus card (0x20c or 0x30c)");
+module_param_array(radio_nr, int, NULL, 0444);
+MODULE_PARM_DESC(radio_nr, "Radio device numbers");
 
 struct zoltrix {
-	struct v4l2_device v4l2_dev;
-	struct video_device vdev;
-	int io;
+	struct radio_isa_card isa;
 	int curvol;
-	unsigned long curfreq;
-	int muted;
-	unsigned int stereo;
-	struct mutex lock;
+	bool muted;
 };
 
-static struct zoltrix zoltrix_card;
+static struct radio_isa_card *zoltrix_alloc(void)
+{
+	struct zoltrix *zol = kzalloc(sizeof(*zol), GFP_KERNEL);
+
+	return zol ? &zol->isa : NULL;
+}
 
-static int zol_setvol(struct zoltrix *zol, int vol)
+static int zoltrix_s_mute_volume(struct radio_isa_card *isa, bool mute, int vol)
 {
-	zol->curvol = vol;
-	if (zol->muted)
-		return 0;
+	struct zoltrix *zol = container_of(isa, struct zoltrix, isa);
 
-	mutex_lock(&zol->lock);
-	if (vol == 0) {
-		outb(0, zol->io);
-		outb(0, zol->io);
-		inb(zol->io + 3);    /* Zoltrix needs to be read to confirm */
-		mutex_unlock(&zol->lock);
+	zol->curvol = vol;
+	zol->muted = mute;
+	if (mute || vol == 0) {
+		outb(0, isa->io);
+		outb(0, isa->io);
+		inb(isa->io + 3);            /* Zoltrix needs to be read to confirm */
 		return 0;
 	}
 
-	outb(zol->curvol-1, zol->io);
+	outb(vol - 1, isa->io);
 	msleep(10);
-	inb(zol->io + 2);
-	mutex_unlock(&zol->lock);
+	inb(isa->io + 2);
 	return 0;
 }
 
-static void zol_mute(struct zoltrix *zol)
-{
-	zol->muted = 1;
-	mutex_lock(&zol->lock);
-	outb(0, zol->io);
-	outb(0, zol->io);
-	inb(zol->io + 3);            /* Zoltrix needs to be read to confirm */
-	mutex_unlock(&zol->lock);
-}
-
-static void zol_unmute(struct zoltrix *zol)
-{
-	zol->muted = 0;
-	zol_setvol(zol, zol->curvol);
-}
-
-static int zol_setfreq(struct zoltrix *zol, unsigned long freq)
+/* tunes the radio to the desired frequency */
+static int zoltrix_s_frequency(struct radio_isa_card *isa, u32 freq)
 {
-	/* tunes the radio to the desired frequency */
-	struct v4l2_device *v4l2_dev = &zol->v4l2_dev;
+	struct zoltrix *zol = container_of(isa, struct zoltrix, isa);
+	struct v4l2_device *v4l2_dev = &isa->v4l2_dev;
 	unsigned long long bitmask, f, m;
-	unsigned int stereo = zol->stereo;
+	bool stereo = isa->stereo;
 	int i;
 
 	if (freq == 0) {
@@ -125,340 +121,125 @@ static int zol_setfreq(struct zoltrix *zol, unsigned long freq)
 	bitmask = 0xc480402c10080000ull;
 	i = 45;
 
-	mutex_lock(&zol->lock);
-
-	zol->curfreq = freq;
-
-	outb(0, zol->io);
-	outb(0, zol->io);
-	inb(zol->io + 3);            /* Zoltrix needs to be read to confirm */
+	outb(0, isa->io);
+	outb(0, isa->io);
+	inb(isa->io + 3);            /* Zoltrix needs to be read to confirm */
 
-	outb(0x40, zol->io);
-	outb(0xc0, zol->io);
+	outb(0x40, isa->io);
+	outb(0xc0, isa->io);
 
 	bitmask = (bitmask ^ ((f & 0xff) << 47) ^ ((f & 0xff00) << 30) ^ (stereo << 31));
 	while (i--) {
 		if ((bitmask & 0x8000000000000000ull) != 0) {
-			outb(0x80, zol->io);
+			outb(0x80, isa->io);
 			udelay(50);
-			outb(0x00, zol->io);
+			outb(0x00, isa->io);
 			udelay(50);
-			outb(0x80, zol->io);
+			outb(0x80, isa->io);
 			udelay(50);
 		} else {
-			outb(0xc0, zol->io);
+			outb(0xc0, isa->io);
 			udelay(50);
-			outb(0x40, zol->io);
+			outb(0x40, isa->io);
 			udelay(50);
-			outb(0xc0, zol->io);
+			outb(0xc0, isa->io);
 			udelay(50);
 		}
 		bitmask *= 2;
 	}
 	/* termination sequence */
-	outb(0x80, zol->io);
-	outb(0xc0, zol->io);
-	outb(0x40, zol->io);
+	outb(0x80, isa->io);
+	outb(0xc0, isa->io);
+	outb(0x40, isa->io);
 	udelay(1000);
-	inb(zol->io + 2);
-
+	inb(isa->io + 2);
 	udelay(1000);
 
-	if (zol->muted) {
-		outb(0, zol->io);
-		outb(0, zol->io);
-		inb(zol->io + 3);
-		udelay(1000);
-	}
-
-	mutex_unlock(&zol->lock);
-
-	if (!zol->muted)
-		zol_setvol(zol, zol->curvol);
-	return 0;
+	return zoltrix_s_mute_volume(isa, zol->muted, zol->curvol);
 }
 
 /* Get signal strength */
-static int zol_getsigstr(struct zoltrix *zol)
+static u32 zoltrix_g_rxsubchans(struct radio_isa_card *isa)
 {
+	struct zoltrix *zol = container_of(isa, struct zoltrix, isa);
 	int a, b;
 
-	mutex_lock(&zol->lock);
-	outb(0x00, zol->io);         /* This stuff I found to do nothing */
-	outb(zol->curvol, zol->io);
+	outb(0x00, isa->io);         /* This stuff I found to do nothing */
+	outb(zol->curvol, isa->io);
 	msleep(20);
 
-	a = inb(zol->io);
+	a = inb(isa->io);
 	msleep(10);
-	b = inb(zol->io);
+	b = inb(isa->io);
 
-	mutex_unlock(&zol->lock);
-
-	if (a != b)
-		return 0;
-
-	/* I found this out by playing with a binary scanner on the card io */
-	return a == 0xcf || a == 0xdf || a == 0xef;
+	return (a == b && a == 0xcf) ?
+		V4L2_TUNER_SUB_STEREO : V4L2_TUNER_SUB_MONO;
 }
 
-static int zol_is_stereo(struct zoltrix *zol)
+static u32 zoltrix_g_signal(struct radio_isa_card *isa)
 {
-	int x1, x2;
-
-	mutex_lock(&zol->lock);
+	struct zoltrix *zol = container_of(isa, struct zoltrix, isa);
+	int a, b;
 
-	outb(0x00, zol->io);
-	outb(zol->curvol, zol->io);
+	outb(0x00, isa->io);         /* This stuff I found to do nothing */
+	outb(zol->curvol, isa->io);
 	msleep(20);
 
-	x1 = inb(zol->io);
+	a = inb(isa->io);
 	msleep(10);
-	x2 = inb(zol->io);
-
-	mutex_unlock(&zol->lock);
-
-	return x1 == x2 && x1 == 0xcf;
-}
-
-static int vidioc_querycap(struct file *file, void  *priv,
-					struct v4l2_capability *v)
-{
-	strlcpy(v->driver, "radio-zoltrix", sizeof(v->driver));
-	strlcpy(v->card, "Zoltrix Radio", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
-	return 0;
-}
-
-static int vidioc_g_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *v)
-{
-	struct zoltrix *zol = video_drvdata(file);
-
-	if (v->index > 0)
-		return -EINVAL;
-
-	strlcpy(v->name, "FM", sizeof(v->name));
-	v->type = V4L2_TUNER_RADIO;
-	v->rangelow = 88 * 16000;
-	v->rangehigh = 108 * 16000;
-	v->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
-	v->capability = V4L2_TUNER_CAP_LOW;
-	if (zol_is_stereo(zol))
-		v->audmode = V4L2_TUNER_MODE_STEREO;
-	else
-		v->audmode = V4L2_TUNER_MODE_MONO;
-	v->signal = 0xFFFF * zol_getsigstr(zol);
-	return 0;
-}
-
-static int vidioc_s_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *v)
-{
-	return v->index ? -EINVAL : 0;
-}
-
-static int vidioc_s_frequency(struct file *file, void *priv,
-					struct v4l2_frequency *f)
-{
-	struct zoltrix *zol = video_drvdata(file);
-
-	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
-		return -EINVAL;
-	if (zol_setfreq(zol, f->frequency) != 0)
-		return -EINVAL;
-	return 0;
-}
-
-static int vidioc_g_frequency(struct file *file, void *priv,
-					struct v4l2_frequency *f)
-{
-	struct zoltrix *zol = video_drvdata(file);
+	b = inb(isa->io);
 
-	if (f->tuner != 0)
-		return -EINVAL;
-	f->type = V4L2_TUNER_RADIO;
-	f->frequency = zol->curfreq;
-	return 0;
-}
-
-static int vidioc_queryctrl(struct file *file, void *priv,
-					struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(qc, 0, 65535, 4096, 65535);
-	}
-	return -EINVAL;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct zoltrix *zol = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = zol->muted;
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = zol->curvol * 4096;
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct zoltrix *zol = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		if (ctrl->value)
-			zol_mute(zol);
-		else {
-			zol_unmute(zol);
-			zol_setvol(zol, zol->curvol);
-		}
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		zol_setvol(zol, ctrl->value / 4096);
+	if (a != b)
 		return 0;
-	}
-	zol->stereo = 1;
-	if (zol_setfreq(zol, zol->curfreq) != 0)
-		return -EINVAL;
-#if 0
-/* FIXME: Implement stereo/mono switch on V4L2 */
-	if (v->mode & VIDEO_SOUND_STEREO) {
-		zol->stereo = 1;
-		zol_setfreq(zol, zol->curfreq);
-	}
-	if (v->mode & VIDEO_SOUND_MONO) {
-		zol->stereo = 0;
-		zol_setfreq(zol, zol->curfreq);
-	}
-#endif
-	return -EINVAL;
-}
-
-static int vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	*i = 0;
-	return 0;
-}
-
-static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
-{
-	return i ? -EINVAL : 0;
-}
 
-static int vidioc_g_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
-{
-	a->index = 0;
-	strlcpy(a->name, "Radio", sizeof(a->name));
-	a->capability = V4L2_AUDCAP_STEREO;
-	return 0;
+	/* I found this out by playing with a binary scanner on the card io */
+	return (a == 0xcf || a == 0xdf || a == 0xef) ? 0xffff : 0;
 }
 
-static int vidioc_s_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
+static int zoltrix_s_stereo(struct radio_isa_card *isa, bool stereo)
 {
-	return a->index ? -EINVAL : 0;
+	return zoltrix_s_frequency(isa, isa->freq);
 }
 
-static const struct v4l2_file_operations zoltrix_fops =
-{
-	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= video_ioctl2,
+static const struct radio_isa_ops zoltrix_ops = {
+	.alloc = zoltrix_alloc,
+	.s_mute_volume = zoltrix_s_mute_volume,
+	.s_frequency = zoltrix_s_frequency,
+	.s_stereo = zoltrix_s_stereo,
+	.g_rxsubchans = zoltrix_g_rxsubchans,
+	.g_signal = zoltrix_g_signal,
 };
 
-static const struct v4l2_ioctl_ops zoltrix_ioctl_ops = {
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
+static const int zoltrix_ioports[] = { 0x20c, 0x30c };
+
+static struct radio_isa_driver zoltrix_driver = {
+	.driver = {
+		.match		= radio_isa_match,
+		.probe		= radio_isa_probe,
+		.remove		= radio_isa_remove,
+		.driver		= {
+			.name	= "radio-zoltrix",
+		},
+	},
+	.io_params = io,
+	.radio_nr_params = radio_nr,
+	.io_ports = zoltrix_ioports,
+	.num_of_io_ports = ARRAY_SIZE(zoltrix_ioports),
+	.region_size = 2,
+	.card = "Zoltrix Radio Plus",
+	.ops = &zoltrix_ops,
+	.has_stereo = true,
+	.max_volume = 15,
 };
 
 static int __init zoltrix_init(void)
 {
-	struct zoltrix *zol = &zoltrix_card;
-	struct v4l2_device *v4l2_dev = &zol->v4l2_dev;
-	int res;
-
-	strlcpy(v4l2_dev->name, "zoltrix", sizeof(v4l2_dev->name));
-	zol->io = io;
-	if (zol->io == -1) {
-		v4l2_err(v4l2_dev, "You must set an I/O address with io=0x20c or 0x30c\n");
-		return -EINVAL;
-	}
-	if (zol->io != 0x20c && zol->io != 0x30c) {
-		v4l2_err(v4l2_dev, "invalid port, try 0x20c or 0x30c\n");
-		return -ENXIO;
-	}
-
-	if (!request_region(zol->io, 2, "zoltrix")) {
-		v4l2_err(v4l2_dev, "port 0x%x already in use\n", zol->io);
-		return -EBUSY;
-	}
-
-	res = v4l2_device_register(NULL, v4l2_dev);
-	if (res < 0) {
-		release_region(zol->io, 2);
-		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
-		return res;
-	}
-
-	mutex_init(&zol->lock);
-
-	/* mute card - prevents noisy bootups */
-
-	/* this ensures that the volume is all the way down  */
-
-	outb(0, zol->io);
-	outb(0, zol->io);
-	msleep(20);
-	inb(zol->io + 3);
-
-	zol->curvol = 0;
-	zol->stereo = 1;
-
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
-	return 0;
+	return isa_register_driver(&zoltrix_driver.driver, ZOLTRIX_MAX);
 }
 
 static void __exit zoltrix_exit(void)
 {
-	struct zoltrix *zol = &zoltrix_card;
-
-	video_unregister_device(&zol->vdev);
-	v4l2_device_unregister(&zol->v4l2_dev);
-	release_region(zol->io, 2);
+	isa_unregister_driver(&zoltrix_driver.driver);
 }
 
 module_init(zoltrix_init);
-- 
1.7.7.3

