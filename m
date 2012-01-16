Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1046 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2APNKV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:10:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 06/10] radio-terratec: Convert to radio-isa.
Date: Mon, 16 Jan 2012 14:10:02 +0100
Message-Id: <fbc7d7a49ce315dd6e3f8a27e47ae200738631d9.1326717025.git.hans.verkuil@cisco.com>
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
 drivers/media/radio/Kconfig          |   25 +--
 drivers/media/radio/radio-terratec.c |  364 ++++++----------------------------
 2 files changed, 64 insertions(+), 325 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 6af49e6..918bb6d 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -353,32 +353,17 @@ config RADIO_SF16FMR2
 config RADIO_TERRATEC
 	tristate "TerraTec ActiveRadio ISA Standalone"
 	depends on ISA && VIDEO_V4L2
+	select RADIO_ISA
 	---help---
-	  Choose Y here if you have this FM radio card, and then fill in the
-	  port address below. (TODO)
-
-	  Note: This driver is in its early stages.  Right now volume and
-	  frequency control and muting works at least for me, but
-	  unfortunately I have not found anybody who wants to use this card
-	  with Linux.  So if it is this what YOU are trying to do right now,
-	  PLEASE DROP ME A NOTE!!  Rolf Offermanns <rolf@offermanns.de>.
+	  Choose Y here if you have this FM radio card.
 
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
+	  Note: this driver hasn't been tested since a long time due to lack
+	  of hardware. If you have this hardware, then please contact the
+	  linux-media mailinglist.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-terratec.
 
-config RADIO_TERRATEC_PORT
-	hex "Terratec i/o port (normally 0x590)"
-	depends on RADIO_TERRATEC=y
-	default "590"
-	help
-	  Fill in the I/O port of your TerraTec FM radio card. If unsure, go
-	  with the default.
-
 config RADIO_TRUST
 	tristate "Trust FM radio card"
 	depends on ISA && VIDEO_V4L2
diff --git a/drivers/media/radio/radio-terratec.c b/drivers/media/radio/radio-terratec.c
index f2ed9cc..2b82dd7 100644
--- a/drivers/media/radio/radio-terratec.c
+++ b/drivers/media/radio/radio-terratec.c
@@ -16,11 +16,7 @@
  *  Frequency control is done digitally -- ie out(port,encodefreq(95.8));
  *  Volume Control is done digitally
  *
- *  there is a I2C controlled RDS decoder (SAA6588)  onboard, which i would like to support someday
- *  (as soon i have understand how to get started :)
- *  If you can help me out with that, please contact me!!
- *
- *
+ * Converted to the radio-isa framework by Hans Verkuil <hans.verkuil@cisco.com>
  * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
  */
 
@@ -32,41 +28,21 @@
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include "radio-isa.h"
 
-MODULE_AUTHOR("R.OFFERMANNS & others");
+MODULE_AUTHOR("R. Offermans & others");
 MODULE_DESCRIPTION("A driver for the TerraTec ActiveRadio Standalone radio card.");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0.0.3");
-
-#ifndef CONFIG_RADIO_TERRATEC_PORT
-#define CONFIG_RADIO_TERRATEC_PORT 0x590
-#endif
+MODULE_VERSION("0.1.99");
 
-static int io = CONFIG_RADIO_TERRATEC_PORT;
+/* Note: there seems to be only one possible port (0x590), but without
+   hardware this is hard to verify. For now, this is the only one we will
+   support. */
+static int io = 0x590;
 static int radio_nr = -1;
 
-module_param(io, int, 0);
-MODULE_PARM_DESC(io, "I/O address of the TerraTec ActiveRadio card (0x590 or 0x591)");
-module_param(radio_nr, int, 0);
-
-static struct v4l2_queryctrl radio_qctrl[] = {
-	{
-		.id            = V4L2_CID_AUDIO_MUTE,
-		.name          = "Mute",
-		.minimum       = 0,
-		.maximum       = 1,
-		.default_value = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},{
-		.id            = V4L2_CID_AUDIO_VOLUME,
-		.name          = "Volume",
-		.minimum       = 0,
-		.maximum       = 0xff,
-		.step          = 1,
-		.default_value = 0xff,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	}
-};
+module_param(radio_nr, int, 0444);
+MODULE_PARM_DESC(radio_nr, "Radio device number");
 
 #define WRT_DIS 	0x00
 #define CLK_OFF		0x00
@@ -76,63 +52,24 @@ static struct v4l2_queryctrl radio_qctrl[] = {
 #define CLK_ON 		0x08
 #define WRT_EN		0x10
 
-struct terratec
+static struct radio_isa_card *terratec_alloc(void)
 {
-	struct v4l2_device v4l2_dev;
-	struct video_device vdev;
-	int io;
-	int curvol;
-	unsigned long curfreq;
-	int muted;
-	struct mutex lock;
-};
-
-static struct terratec terratec_card;
-
-/* local things */
+	return kzalloc(sizeof(struct radio_isa_card), GFP_KERNEL);
+}
 
-static void tt_write_vol(struct terratec *tt, int volume)
+static int terratec_s_mute_volume(struct radio_isa_card *isa, bool mute, int vol)
 {
 	int i;
 
-	volume = volume + (volume * 32); /* change both channels */
-	mutex_lock(&tt->lock);
+	if (mute)
+		vol = 0;
+	vol = vol + (vol * 32); /* change both channels */
 	for (i = 0; i < 8; i++) {
-		if (volume & (0x80 >> i))
-			outb(0x80, tt->io + 1);
+		if (vol & (0x80 >> i))
+			outb(0x80, isa->io + 1);
 		else
-			outb(0x00, tt->io + 1);
-	}
-	mutex_unlock(&tt->lock);
-}
-
-
-
-static void tt_mute(struct terratec *tt)
-{
-	tt->muted = 1;
-	tt_write_vol(tt, 0);
-}
-
-static int tt_setvol(struct terratec *tt, int vol)
-{
-	if (vol == tt->curvol) {	/* requested volume = current */
-		if (tt->muted) {	/* user is unmuting the card  */
-			tt->muted = 0;
-			tt_write_vol(tt, vol);	/* enable card */
-		}
-		return 0;
-	}
-
-	if (vol == 0) {			/* volume = 0 means mute the card */
-		tt_write_vol(tt, 0);	/* "turn off card" by setting vol to 0 */
-		tt->curvol = vol;	/* track the volume state!	*/
-		return 0;
+			outb(0x00, isa->io + 1);
 	}
-
-	tt->muted = 0;
-	tt_write_vol(tt, vol);
-	tt->curvol = vol;
 	return 0;
 }
 
@@ -140,20 +77,15 @@ static int tt_setvol(struct terratec *tt, int vol)
 /* this is the worst part in this driver */
 /* many more or less strange things are going on here, but hey, it works :) */
 
-static int tt_setfreq(struct terratec *tt, unsigned long freq1)
+static int terratec_s_frequency(struct radio_isa_card *isa, u32 freq)
 {
-	int freq;
 	int i;
 	int p;
-	int  temp;
+	int temp;
 	long rest;
 	unsigned char buffer[25];		/* we have to bit shift 25 registers */
 
-	mutex_lock(&tt->lock);
-
-	tt->curfreq = freq1;
-
-	freq = freq1 / 160;			/* convert the freq. to a nice to handle value */
+	freq = freq / 160;			/* convert the freq. to a nice to handle value */
 	memset(buffer, 0, sizeof(buffer));
 
 	rest = freq * 10 + 10700;	/* I once had understood what is going on here */
@@ -175,239 +107,61 @@ static int tt_setfreq(struct terratec *tt, unsigned long freq1)
 
 	for (i = 24; i > -1; i--) {	/* bit shift the values to the radiocard */
 		if (buffer[i] == 1) {
-			outb(WRT_EN | DATA, tt->io);
-			outb(WRT_EN | DATA | CLK_ON, tt->io);
-			outb(WRT_EN | DATA, tt->io);
+			outb(WRT_EN | DATA, isa->io);
+			outb(WRT_EN | DATA | CLK_ON, isa->io);
+			outb(WRT_EN | DATA, isa->io);
 		} else {
-			outb(WRT_EN | 0x00, tt->io);
-			outb(WRT_EN | 0x00 | CLK_ON, tt->io);
-		}
-	}
-	outb(0x00, tt->io);
-
-	mutex_unlock(&tt->lock);
-
-	return 0;
-}
-
-static int tt_getsigstr(struct terratec *tt)
-{
-	if (inb(tt->io) & 2)	/* bit set = no signal present	*/
-		return 0;
-	return 1;		/* signal present		*/
-}
-
-static int vidioc_querycap(struct file *file, void *priv,
-					struct v4l2_capability *v)
-{
-	strlcpy(v->driver, "radio-terratec", sizeof(v->driver));
-	strlcpy(v->card, "ActiveRadio", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
-	return 0;
-}
-
-static int vidioc_g_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *v)
-{
-	struct terratec *tt = video_drvdata(file);
-
-	if (v->index > 0)
-		return -EINVAL;
-
-	strlcpy(v->name, "FM", sizeof(v->name));
-	v->type = V4L2_TUNER_RADIO;
-	v->rangelow = 87 * 16000;
-	v->rangehigh = 108 * 16000;
-	v->rxsubchans = V4L2_TUNER_SUB_MONO;
-	v->capability = V4L2_TUNER_CAP_LOW;
-	v->audmode = V4L2_TUNER_MODE_MONO;
-	v->signal = 0xFFFF * tt_getsigstr(tt);
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
-	struct terratec *tt = video_drvdata(file);
-
-	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
-		return -EINVAL;
-	tt_setfreq(tt, f->frequency);
-	return 0;
-}
-
-static int vidioc_g_frequency(struct file *file, void *priv,
-					struct v4l2_frequency *f)
-{
-	struct terratec *tt = video_drvdata(file);
-
-	if (f->tuner != 0)
-		return -EINVAL;
-	f->type = V4L2_TUNER_RADIO;
-	f->frequency = tt->curfreq;
-	return 0;
-}
-
-static int vidioc_queryctrl(struct file *file, void *priv,
-					struct v4l2_queryctrl *qc)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(radio_qctrl); i++) {
-		if (qc->id && qc->id == radio_qctrl[i].id) {
-			memcpy(qc, &(radio_qctrl[i]), sizeof(*qc));
-			return 0;
+			outb(WRT_EN | 0x00, isa->io);
+			outb(WRT_EN | 0x00 | CLK_ON, isa->io);
 		}
 	}
-	return -EINVAL;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-					struct v4l2_control *ctrl)
-{
-	struct terratec *tt = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		if (tt->muted)
-			ctrl->value = 1;
-		else
-			ctrl->value = 0;
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = tt->curvol * 6554;
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-					struct v4l2_control *ctrl)
-{
-	struct terratec *tt = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		if (ctrl->value)
-			tt_mute(tt);
-		else
-			tt_setvol(tt,tt->curvol);
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		tt_setvol(tt,ctrl->value);
-		return 0;
-	}
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
-
-static int vidioc_g_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
-{
-	a->index = 0;
-	strlcpy(a->name, "Radio", sizeof(a->name));
-	a->capability = V4L2_AUDCAP_STEREO;
+	outb(0x00, isa->io);
 	return 0;
 }
 
-static int vidioc_s_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
+static u32 terratec_g_signal(struct radio_isa_card *isa)
 {
-	return a->index ? -EINVAL : 0;
+	/* bit set = no signal present	*/
+	return (inb(isa->io) & 2) ? 0 : 0xffff;
 }
 
-static const struct v4l2_file_operations terratec_fops = {
-	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= video_ioctl2,
+static const struct radio_isa_ops terratec_ops = {
+	.alloc = terratec_alloc,
+	.s_mute_volume = terratec_s_mute_volume,
+	.s_frequency = terratec_s_frequency,
+	.g_signal = terratec_g_signal,
 };
 
-static const struct v4l2_ioctl_ops terratec_ioctl_ops = {
-	.vidioc_querycap    = vidioc_querycap,
-	.vidioc_g_tuner     = vidioc_g_tuner,
-	.vidioc_s_tuner     = vidioc_s_tuner,
-	.vidioc_g_frequency = vidioc_g_frequency,
-	.vidioc_s_frequency = vidioc_s_frequency,
-	.vidioc_queryctrl   = vidioc_queryctrl,
-	.vidioc_g_ctrl      = vidioc_g_ctrl,
-	.vidioc_s_ctrl      = vidioc_s_ctrl,
-	.vidioc_g_audio     = vidioc_g_audio,
-	.vidioc_s_audio     = vidioc_s_audio,
-	.vidioc_g_input     = vidioc_g_input,
-	.vidioc_s_input     = vidioc_s_input,
+static const int terratec_ioports[] = { 0x590 };
+
+static struct radio_isa_driver terratec_driver = {
+	.driver = {
+		.match		= radio_isa_match,
+		.probe		= radio_isa_probe,
+		.remove		= radio_isa_remove,
+		.driver		= {
+			.name	= "radio-terratec",
+		},
+	},
+	.io_params = &io,
+	.radio_nr_params = &radio_nr,
+	.io_ports = terratec_ioports,
+	.num_of_io_ports = ARRAY_SIZE(terratec_ioports),
+	.region_size = 2,
+	.card = "TerraTec ActiveRadio",
+	.ops = &terratec_ops,
+	.has_stereo = true,
+	.max_volume = 10,
 };
 
 static int __init terratec_init(void)
 {
-	struct terratec *tt = &terratec_card;
-	struct v4l2_device *v4l2_dev = &tt->v4l2_dev;
-	int res;
-
-	strlcpy(v4l2_dev->name, "terratec", sizeof(v4l2_dev->name));
-	tt->io = io;
-	if (tt->io == -1) {
-		v4l2_err(v4l2_dev, "you must set an I/O address with io=0x590 or 0x591\n");
-		return -EINVAL;
-	}
-	if (!request_region(tt->io, 2, "terratec")) {
-		v4l2_err(v4l2_dev, "port 0x%x already in use\n", io);
-		return -EBUSY;
-	}
-
-	res = v4l2_device_register(NULL, v4l2_dev);
-	if (res < 0) {
-		release_region(tt->io, 2);
-		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
-		return res;
-	}
-
-	strlcpy(tt->vdev.name, v4l2_dev->name, sizeof(tt->vdev.name));
-	tt->vdev.v4l2_dev = v4l2_dev;
-	tt->vdev.fops = &terratec_fops;
-	tt->vdev.ioctl_ops = &terratec_ioctl_ops;
-	tt->vdev.release = video_device_release_empty;
-	video_set_drvdata(&tt->vdev, tt);
-
-	mutex_init(&tt->lock);
-
-	/* mute card - prevents noisy bootups */
-	tt_write_vol(tt, 0);
-
-	if (video_register_device(&tt->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-		v4l2_device_unregister(&tt->v4l2_dev);
-		release_region(tt->io, 2);
-		return -EINVAL;
-	}
-
-	v4l2_info(v4l2_dev, "TERRATEC ActivRadio Standalone card driver.\n");
-	return 0;
+	return isa_register_driver(&terratec_driver.driver, 1);
 }
 
 static void __exit terratec_exit(void)
 {
-	struct terratec *tt = &terratec_card;
-	struct v4l2_device *v4l2_dev = &tt->v4l2_dev;
-
-	video_unregister_device(&tt->vdev);
-	v4l2_device_unregister(&tt->v4l2_dev);
-	release_region(tt->io, 2);
-	v4l2_info(v4l2_dev, "TERRATEC ActivRadio Standalone card driver unloaded.\n");
+	isa_unregister_driver(&terratec_driver.driver);
 }
 
 module_init(terratec_init);
-- 
1.7.7.3

