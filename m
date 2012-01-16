Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1037 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab2APNK1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:10:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 05/10] radio-rtrack2: Convert to radio-isa.
Date: Mon, 16 Jan 2012 14:10:01 +0100
Message-Id: <2f937a2cb150b46cd2b55e7e8eae1fc8c8610a4c.1326717025.git.hans.verkuil@cisco.com>
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
 drivers/media/radio/radio-rtrack2.c |  332 +++++++----------------------------
 2 files changed, 69 insertions(+), 271 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 0695219..6af49e6 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -223,14 +223,14 @@ config RADIO_RTRACK_PORT
 config RADIO_RTRACK2
 	tristate "AIMSlab RadioTrack II support"
 	depends on ISA && VIDEO_V4L2
+	select RADIO_ISA
 	---help---
 	  Choose Y here if you have this FM radio card, and then fill in the
 	  port address below.
 
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
+	  Note: this driver hasn't been tested since a long time due to lack
+	  of hardware. If you have this hardware, then please contact the
+	  linux-media mailinglist.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-rtrack2.
diff --git a/drivers/media/radio/radio-rtrack2.c b/drivers/media/radio/radio-rtrack2.c
index 3628be6..b275c5d 100644
--- a/drivers/media/radio/radio-rtrack2.c
+++ b/drivers/media/radio/radio-rtrack2.c
@@ -1,11 +1,12 @@
-/* RadioTrack II driver for Linux radio support (C) 1998 Ben Pfaff
+/*
+ * RadioTrack II driver
+ * Copyright 1998 Ben Pfaff
  *
  * Based on RadioTrack I/RadioReveal (C) 1997 M. Kirkwood
  * Converted to new API by Alan Cox <alan@lxorguk.ukuu.org.uk>
  * Various bugfixes and enhancements by Russell Kroll <rkroll@exploits.org>
  *
- * TODO: Allow for more than one of these foolish entities :-)
- *
+ * Converted to the radio-isa framework by Hans Verkuil <hans.verkuil@cisco.com>
  * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
  */
 
@@ -18,323 +19,120 @@
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include "radio-isa.h"
 
 MODULE_AUTHOR("Ben Pfaff");
 MODULE_DESCRIPTION("A driver for the RadioTrack II radio card.");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0.0.3");
+MODULE_VERSION("0.1.99");
 
 #ifndef CONFIG_RADIO_RTRACK2_PORT
 #define CONFIG_RADIO_RTRACK2_PORT -1
 #endif
 
-static int io = CONFIG_RADIO_RTRACK2_PORT;
-static int radio_nr = -1;
-
-module_param(io, int, 0);
-MODULE_PARM_DESC(io, "I/O address of the RadioTrack card (0x20c or 0x30c)");
-module_param(radio_nr, int, 0);
-
-struct rtrack2
-{
-	struct v4l2_device v4l2_dev;
-	struct video_device vdev;
-	int io;
-	unsigned long curfreq;
-	int muted;
-	struct mutex lock;
-};
+#define RTRACK2_MAX 2
 
-static struct rtrack2 rtrack2_card;
+static int io[RTRACK2_MAX] = { [0] = CONFIG_RADIO_RTRACK2_PORT,
+			      [1 ... (RTRACK2_MAX - 1)] = -1 };
+static int radio_nr[RTRACK2_MAX] = { [0 ... (RTRACK2_MAX - 1)] = -1 };
 
+module_param_array(io, int, NULL, 0444);
+MODULE_PARM_DESC(io, "I/O addresses of the RadioTrack card (0x20f or 0x30f)");
+module_param_array(radio_nr, int, NULL, 0444);
+MODULE_PARM_DESC(radio_nr, "Radio device numbers");
 
-/* local things */
-
-static void rt_mute(struct rtrack2 *dev)
-{
-	if (dev->muted)
-		return;
-	mutex_lock(&dev->lock);
-	outb(1, dev->io);
-	mutex_unlock(&dev->lock);
-	dev->muted = 1;
-}
-
-static void rt_unmute(struct rtrack2 *dev)
+static struct radio_isa_card *rtrack2_alloc(void)
 {
-	if(dev->muted == 0)
-		return;
-	mutex_lock(&dev->lock);
-	outb(0, dev->io);
-	mutex_unlock(&dev->lock);
-	dev->muted = 0;
+	return kzalloc(sizeof(struct radio_isa_card), GFP_KERNEL);
 }
 
-static void zero(struct rtrack2 *dev)
+static void zero(struct radio_isa_card *isa)
 {
-	outb_p(1, dev->io);
-	outb_p(3, dev->io);
-	outb_p(1, dev->io);
+	outb_p(1, isa->io);
+	outb_p(3, isa->io);
+	outb_p(1, isa->io);
 }
 
-static void one(struct rtrack2 *dev)
+static void one(struct radio_isa_card *isa)
 {
-	outb_p(5, dev->io);
-	outb_p(7, dev->io);
-	outb_p(5, dev->io);
+	outb_p(5, isa->io);
+	outb_p(7, isa->io);
+	outb_p(5, isa->io);
 }
 
-static int rt_setfreq(struct rtrack2 *dev, unsigned long freq)
+static int rtrack2_s_frequency(struct radio_isa_card *isa, u32 freq)
 {
 	int i;
 
-	mutex_lock(&dev->lock);
-	dev->curfreq = freq;
 	freq = freq / 200 + 856;
 
-	outb_p(0xc8, dev->io);
-	outb_p(0xc9, dev->io);
-	outb_p(0xc9, dev->io);
+	outb_p(0xc8, isa->io);
+	outb_p(0xc9, isa->io);
+	outb_p(0xc9, isa->io);
 
 	for (i = 0; i < 10; i++)
-		zero(dev);
+		zero(isa);
 
 	for (i = 14; i >= 0; i--)
 		if (freq & (1 << i))
-			one(dev);
+			one(isa);
 		else
-			zero(dev);
-
-	outb_p(0xc8, dev->io);
-	if (!dev->muted)
-		outb_p(0, dev->io);
-
-	mutex_unlock(&dev->lock);
-	return 0;
-}
-
-static int vidioc_querycap(struct file *file, void *priv,
-				struct v4l2_capability *v)
-{
-	strlcpy(v->driver, "radio-rtrack2", sizeof(v->driver));
-	strlcpy(v->card, "RadioTrack II", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
-	return 0;
-}
+			zero(isa);
 
-static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *v)
-{
-	return v->index ? -EINVAL : 0;
-}
-
-static int rt_getsigstr(struct rtrack2 *dev)
-{
-	int sig = 1;
-
-	mutex_lock(&dev->lock);
-	if (inb(dev->io) & 2)	/* bit set = no signal present	*/
-		sig = 0;
-	mutex_unlock(&dev->lock);
-	return sig;
-}
-
-static int vidioc_g_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *v)
-{
-	struct rtrack2 *rt = video_drvdata(file);
-
-	if (v->index > 0)
-		return -EINVAL;
-
-	strlcpy(v->name, "FM", sizeof(v->name));
-	v->type = V4L2_TUNER_RADIO;
-	v->rangelow = 88 * 16000;
-	v->rangehigh = 108 * 16000;
-	v->rxsubchans = V4L2_TUNER_SUB_MONO;
-	v->capability = V4L2_TUNER_CAP_LOW;
-	v->audmode = V4L2_TUNER_MODE_MONO;
-	v->signal = 0xFFFF * rt_getsigstr(rt);
+	outb_p(0xc8, isa->io);
+	if (!v4l2_ctrl_g_ctrl(isa->mute))
+		outb_p(0, isa->io);
 	return 0;
 }
 
-static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+static u32 rtrack2_g_signal(struct radio_isa_card *isa)
 {
-	struct rtrack2 *rt = video_drvdata(file);
-
-	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
-		return -EINVAL;
-	rt_setfreq(rt, f->frequency);
-	return 0;
+	/* bit set = no signal present	*/
+	return (inb(isa->io) & 2) ? 0 : 0xffff;
 }
 
-static int vidioc_g_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+static int rtrack2_s_mute_volume(struct radio_isa_card *isa, bool mute, int vol)
 {
-	struct rtrack2 *rt = video_drvdata(file);
-
-	if (f->tuner != 0)
-		return -EINVAL;
-	f->type = V4L2_TUNER_RADIO;
-	f->frequency = rt->curfreq;
+	outb(mute, isa->io);
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-				struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(qc, 0, 65535, 65535, 65535);
-	}
-	return -EINVAL;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct rtrack2 *rt = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = rt->muted;
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		if (rt->muted)
-			ctrl->value = 0;
-		else
-			ctrl->value = 65535;
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct rtrack2 *rt = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		if (ctrl->value)
-			rt_mute(rt);
-		else
-			rt_unmute(rt);
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		if (ctrl->value)
-			rt_unmute(rt);
-		else
-			rt_mute(rt);
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
-				struct v4l2_audio *a)
-{
-	a->index = 0;
-	strlcpy(a->name, "Radio", sizeof(a->name));
-	a->capability = V4L2_AUDCAP_STEREO;
-	return 0;
-}
-
-static int vidioc_s_audio(struct file *file, void *priv,
-				struct v4l2_audio *a)
-{
-	return a->index ? -EINVAL : 0;
-}
-
-static const struct v4l2_file_operations rtrack2_fops = {
-	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= video_ioctl2,
+static const struct radio_isa_ops rtrack2_ops = {
+	.alloc = rtrack2_alloc,
+	.s_mute_volume = rtrack2_s_mute_volume,
+	.s_frequency = rtrack2_s_frequency,
+	.g_signal = rtrack2_g_signal,
 };
 
-static const struct v4l2_ioctl_ops rtrack2_ioctl_ops = {
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
+static const int rtrack2_ioports[] = { 0x20f, 0x30f };
+
+static struct radio_isa_driver rtrack2_driver = {
+	.driver = {
+		.match		= radio_isa_match,
+		.probe		= radio_isa_probe,
+		.remove		= radio_isa_remove,
+		.driver		= {
+			.name	= "radio-rtrack2",
+		},
+	},
+	.io_params = io,
+	.radio_nr_params = radio_nr,
+	.io_ports = rtrack2_ioports,
+	.num_of_io_ports = ARRAY_SIZE(rtrack2_ioports),
+	.region_size = 4,
+	.card = "AIMSlab RadioTrack II",
+	.ops = &rtrack2_ops,
+	.has_stereo = true,
 };
 
 static int __init rtrack2_init(void)
 {
-	struct rtrack2 *dev = &rtrack2_card;
-	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
-	int res;
-
-	strlcpy(v4l2_dev->name, "rtrack2", sizeof(v4l2_dev->name));
-	dev->io = io;
-	if (dev->io == -1) {
-		v4l2_err(v4l2_dev, "You must set an I/O address with io=0x20c or io=0x30c\n");
-		return -EINVAL;
-	}
-	if (!request_region(dev->io, 4, "rtrack2")) {
-		v4l2_err(v4l2_dev, "port 0x%x already in use\n", dev->io);
-		return -EBUSY;
-	}
-
-	res = v4l2_device_register(NULL, v4l2_dev);
-	if (res < 0) {
-		release_region(dev->io, 4);
-		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
-		return res;
-	}
-
-	strlcpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
-	dev->vdev.v4l2_dev = v4l2_dev;
-	dev->vdev.fops = &rtrack2_fops;
-	dev->vdev.ioctl_ops = &rtrack2_ioctl_ops;
-	dev->vdev.release = video_device_release_empty;
-	video_set_drvdata(&dev->vdev, dev);
-
-	/* mute card - prevents noisy bootups */
-	outb(1, dev->io);
-	dev->muted = 1;
-
-	mutex_init(&dev->lock);
-	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-		v4l2_device_unregister(v4l2_dev);
-		release_region(dev->io, 4);
-		return -EINVAL;
-	}
-
-	v4l2_info(v4l2_dev, "AIMSlab Radiotrack II card driver.\n");
-
-	return 0;
+	return isa_register_driver(&rtrack2_driver.driver, RTRACK2_MAX);
 }
 
 static void __exit rtrack2_exit(void)
 {
-	struct rtrack2 *dev = &rtrack2_card;
-
-	video_unregister_device(&dev->vdev);
-	v4l2_device_unregister(&dev->v4l2_dev);
-	release_region(dev->io, 4);
+	isa_unregister_driver(&rtrack2_driver.driver);
 }
 
 module_init(rtrack2_init);
-- 
1.7.7.3

