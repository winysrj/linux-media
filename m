Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2722 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2APNKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:10:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 07/10] radio-trust: Convert to radio-isa.
Date: Mon, 16 Jan 2012 14:10:03 +0100
Message-Id: <13796f998868961014e22860442b2b75672ed8af.1326717025.git.hans.verkuil@cisco.com>
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
 drivers/media/radio/Kconfig       |    5 +
 drivers/media/radio/radio-trust.c |  387 ++++++++++---------------------------
 2 files changed, 104 insertions(+), 288 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 918bb6d..bc2da17 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -367,10 +367,15 @@ config RADIO_TERRATEC
 config RADIO_TRUST
 	tristate "Trust FM radio card"
 	depends on ISA && VIDEO_V4L2
+	select RADIO_ISA
 	help
 	  This is a driver for the Trust FM radio cards. Say Y if you have
 	  such a card and want to use it under Linux.
 
+	  Note: this driver hasn't been tested since a long time due to lack
+	  of hardware. If you have this hardware, then please contact the
+	  linux-media mailinglist.
+
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-trust.
 
diff --git a/drivers/media/radio/radio-trust.c b/drivers/media/radio/radio-trust.c
index b3f45a0..0703a80 100644
--- a/drivers/media/radio/radio-trust.c
+++ b/drivers/media/radio/radio-trust.c
@@ -23,11 +23,12 @@
 #include <linux/io.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include "radio-isa.h"
 
 MODULE_AUTHOR("Eric Lammerts, Russell Kroll, Quay Lu, Donald Song, Jason Lewis, Scott McGrath, William McGrath");
 MODULE_DESCRIPTION("A driver for the Trust FM Radio card.");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0.0.3");
+MODULE_VERSION("0.1.99");
 
 /* acceptable ports: 0x350 (JP3 shorted), 0x358 (JP3 open) */
 
@@ -35,39 +36,38 @@ MODULE_VERSION("0.0.3");
 #define CONFIG_RADIO_TRUST_PORT -1
 #endif
 
-static int io = CONFIG_RADIO_TRUST_PORT;
-static int radio_nr = -1;
+#define TRUST_MAX 2
 
-module_param(io, int, 0);
-MODULE_PARM_DESC(io, "I/O address of the Trust FM Radio card (0x350 or 0x358)");
-module_param(radio_nr, int, 0);
+static int io[TRUST_MAX] = { [0] = CONFIG_RADIO_TRUST_PORT,
+			      [1 ... (TRUST_MAX - 1)] = -1 };
+static int radio_nr[TRUST_MAX] = { [0 ... (TRUST_MAX - 1)] = -1 };
+
+module_param_array(io, int, NULL, 0444);
+MODULE_PARM_DESC(io, "I/O addresses of the Trust FM Radio card (0x350 or 0x358)");
+module_param_array(radio_nr, int, NULL, 0444);
+MODULE_PARM_DESC(radio_nr, "Radio device numbers");
 
 struct trust {
-	struct v4l2_device v4l2_dev;
-	struct video_device vdev;
-	int io;
+	struct radio_isa_card isa;
 	int ioval;
-	__u16 curvol;
-	__u16 curbass;
-	__u16 curtreble;
-	int muted;
-	unsigned long curfreq;
-	int curstereo;
-	int curmute;
-	struct mutex lock;
 };
 
-static struct trust trust_card;
+static struct radio_isa_card *trust_alloc(void)
+{
+	struct trust *tr = kzalloc(sizeof(*tr), GFP_KERNEL);
+
+	return tr ? &tr->isa : NULL;
+}
 
 /* i2c addresses */
 #define TDA7318_ADDR 0x88
 #define TSA6060T_ADDR 0xc4
 
-#define TR_DELAY do { inb(tr->io); inb(tr->io); inb(tr->io); } while (0)
-#define TR_SET_SCL outb(tr->ioval |= 2, tr->io)
-#define TR_CLR_SCL outb(tr->ioval &= 0xfd, tr->io)
-#define TR_SET_SDA outb(tr->ioval |= 1, tr->io)
-#define TR_CLR_SDA outb(tr->ioval &= 0xfe, tr->io)
+#define TR_DELAY do { inb(tr->isa.io); inb(tr->isa.io); inb(tr->isa.io); } while (0)
+#define TR_SET_SCL outb(tr->ioval |= 2, tr->isa.io)
+#define TR_CLR_SCL outb(tr->ioval &= 0xfd, tr->isa.io)
+#define TR_SET_SDA outb(tr->ioval |= 1, tr->isa.io)
+#define TR_CLR_SDA outb(tr->ioval &= 0xfe, tr->isa.io)
 
 static void write_i2c(struct trust *tr, int n, ...)
 {
@@ -84,10 +84,10 @@ static void write_i2c(struct trust *tr, int n, ...)
 	TR_CLR_SCL;
 	TR_DELAY;
 
-	for(; n; n--) {
+	for (; n; n--) {
 		val = va_arg(args, unsigned);
-		for(mask = 0x80; mask; mask >>= 1) {
-			if(val & mask)
+		for (mask = 0x80; mask; mask >>= 1) {
+			if (val & mask)
 				TR_SET_SDA;
 			else
 				TR_CLR_SDA;
@@ -115,317 +115,128 @@ static void write_i2c(struct trust *tr, int n, ...)
 	va_end(args);
 }
 
-static void tr_setvol(struct trust *tr, __u16 vol)
+static int trust_s_mute_volume(struct radio_isa_card *isa, bool mute, int vol)
 {
-	mutex_lock(&tr->lock);
-	tr->curvol = vol / 2048;
-	write_i2c(tr, 2, TDA7318_ADDR, tr->curvol ^ 0x1f);
-	mutex_unlock(&tr->lock);
-}
+	struct trust *tr = container_of(isa, struct trust, isa);
 
-static int basstreble2chip[15] = {
-	0, 1, 2, 3, 4, 5, 6, 7, 14, 13, 12, 11, 10, 9, 8
-};
-
-static void tr_setbass(struct trust *tr, __u16 bass)
-{
-	mutex_lock(&tr->lock);
-	tr->curbass = bass / 4370;
-	write_i2c(tr, 2, TDA7318_ADDR, 0x60 | basstreble2chip[tr->curbass]);
-	mutex_unlock(&tr->lock);
-}
-
-static void tr_settreble(struct trust *tr, __u16 treble)
-{
-	mutex_lock(&tr->lock);
-	tr->curtreble = treble / 4370;
-	write_i2c(tr, 2, TDA7318_ADDR, 0x70 | basstreble2chip[tr->curtreble]);
-	mutex_unlock(&tr->lock);
+	tr->ioval = (tr->ioval & 0xf7) | (mute << 3);
+	outb(tr->ioval, isa->io);
+	write_i2c(tr, 2, TDA7318_ADDR, vol ^ 0x1f);
+	return 0;
 }
 
-static void tr_setstereo(struct trust *tr, int stereo)
+static int trust_s_stereo(struct radio_isa_card *isa, bool stereo)
 {
-	mutex_lock(&tr->lock);
-	tr->curstereo = !!stereo;
-	tr->ioval = (tr->ioval & 0xfb) | (!tr->curstereo << 2);
-	outb(tr->ioval, tr->io);
-	mutex_unlock(&tr->lock);
-}
+	struct trust *tr = container_of(isa, struct trust, isa);
 
-static void tr_setmute(struct trust *tr, int mute)
-{
-	mutex_lock(&tr->lock);
-	tr->curmute = !!mute;
-	tr->ioval = (tr->ioval & 0xf7) | (tr->curmute << 3);
-	outb(tr->ioval, tr->io);
-	mutex_unlock(&tr->lock);
+	tr->ioval = (tr->ioval & 0xfb) | (!stereo << 2);
+	outb(tr->ioval, isa->io);
+	return 0;
 }
 
-static int tr_getsigstr(struct trust *tr)
+static u32 trust_g_signal(struct radio_isa_card *isa)
 {
 	int i, v;
 
-	mutex_lock(&tr->lock);
 	for (i = 0, v = 0; i < 100; i++)
-		v |= inb(tr->io);
-	mutex_unlock(&tr->lock);
+		v |= inb(isa->io);
 	return (v & 1) ? 0 : 0xffff;
 }
 
-static int tr_getstereo(struct trust *tr)
-{
-	/* don't know how to determine it, just return the setting */
-	return tr->curstereo;
-}
-
-static void tr_setfreq(struct trust *tr, unsigned long f)
+static int trust_s_frequency(struct radio_isa_card *isa, u32 freq)
 {
-	mutex_lock(&tr->lock);
-	tr->curfreq = f;
-	f /= 160;	/* Convert to 10 kHz units	*/
-	f += 1070;	/* Add 10.7 MHz IF		*/
-	write_i2c(tr, 5, TSA6060T_ADDR, (f << 1) | 1, f >> 7, 0x60 | ((f >> 15) & 1), 0);
-	mutex_unlock(&tr->lock);
-}
+	struct trust *tr = container_of(isa, struct trust, isa);
 
-static int vidioc_querycap(struct file *file, void *priv,
-				struct v4l2_capability *v)
-{
-	strlcpy(v->driver, "radio-trust", sizeof(v->driver));
-	strlcpy(v->card, "Trust FM Radio", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	freq /= 160;	/* Convert to 10 kHz units	*/
+	freq += 1070;	/* Add 10.7 MHz IF		*/
+	write_i2c(tr, 5, TSA6060T_ADDR, (freq << 1) | 1,
+			freq >> 7, 0x60 | ((freq >> 15) & 1), 0);
 	return 0;
 }
 
-static int vidioc_g_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *v)
-{
-	struct trust *tr = video_drvdata(file);
-
-	if (v->index > 0)
-		return -EINVAL;
-
-	strlcpy(v->name, "FM", sizeof(v->name));
-	v->type = V4L2_TUNER_RADIO;
-	v->rangelow = 87.5 * 16000;
-	v->rangehigh = 108 * 16000;
-	v->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
-	v->capability = V4L2_TUNER_CAP_LOW;
-	if (tr_getstereo(tr))
-		v->audmode = V4L2_TUNER_MODE_STEREO;
-	else
-		v->audmode = V4L2_TUNER_MODE_MONO;
-	v->signal = tr_getsigstr(tr);
-	return 0;
-}
-
-static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *v)
-{
-	struct trust *tr = video_drvdata(file);
-
-	if (v->index)
-		return -EINVAL;
-	tr_setstereo(tr, v->audmode == V4L2_TUNER_MODE_STEREO);
-	return 0;
-}
-
-static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
-{
-	struct trust *tr = video_drvdata(file);
-
-	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
-		return -EINVAL;
-	tr_setfreq(tr, f->frequency);
-	return 0;
-}
-
-static int vidioc_g_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
-{
-	struct trust *tr = video_drvdata(file);
-
-	if (f->tuner != 0)
-		return -EINVAL;
-	f->type = V4L2_TUNER_RADIO;
-	f->frequency = tr->curfreq;
-	return 0;
-}
-
-static int vidioc_queryctrl(struct file *file, void *priv,
-				struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(qc, 0, 65535, 2048, 65535);
-	case V4L2_CID_AUDIO_BASS:
-	case V4L2_CID_AUDIO_TREBLE:
-		return v4l2_ctrl_query_fill(qc, 0, 65535, 4370, 32768);
-	}
-	return -EINVAL;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
-{
-	struct trust *tr = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = tr->curmute;
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = tr->curvol * 2048;
-		return 0;
-	case V4L2_CID_AUDIO_BASS:
-		ctrl->value = tr->curbass * 4370;
-		return 0;
-	case V4L2_CID_AUDIO_TREBLE:
-		ctrl->value = tr->curtreble * 4370;
-		return 0;
-	}
-	return -EINVAL;
-}
+static int basstreble2chip[15] = {
+	0, 1, 2, 3, 4, 5, 6, 7, 14, 13, 12, 11, 10, 9, 8
+};
 
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
+static int trust_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct trust *tr = video_drvdata(file);
+	struct radio_isa_card *isa =
+		container_of(ctrl->handler, struct radio_isa_card, hdl);
+	struct trust *tr = container_of(isa, struct trust, isa);
 
 	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		tr_setmute(tr, ctrl->value);
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		tr_setvol(tr, ctrl->value);
-		return 0;
 	case V4L2_CID_AUDIO_BASS:
-		tr_setbass(tr, ctrl->value);
+		write_i2c(tr, 2, TDA7318_ADDR, 0x60 | basstreble2chip[ctrl->val]);
 		return 0;
 	case V4L2_CID_AUDIO_TREBLE:
-		tr_settreble(tr, ctrl->value);
+		write_i2c(tr, 2, TDA7318_ADDR, 0x70 | basstreble2chip[ctrl->val]);
 		return 0;
 	}
 	return -EINVAL;
 }
 
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
-static const struct v4l2_file_operations trust_fops = {
-	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= video_ioctl2,
-};
-
-static const struct v4l2_ioctl_ops trust_ioctl_ops = {
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
+static const struct v4l2_ctrl_ops trust_ctrl_ops = {
+	.s_ctrl = trust_s_ctrl,
 };
 
-static int __init trust_init(void)
+static int trust_initialize(struct radio_isa_card *isa)
 {
-	struct trust *tr = &trust_card;
-	struct v4l2_device *v4l2_dev = &tr->v4l2_dev;
-	int res;
+	struct trust *tr = container_of(isa, struct trust, isa);
 
-	strlcpy(v4l2_dev->name, "trust", sizeof(v4l2_dev->name));
-	tr->io = io;
 	tr->ioval = 0xf;
-	mutex_init(&tr->lock);
-
-	if (tr->io == -1) {
-		v4l2_err(v4l2_dev, "You must set an I/O address with io=0x0x350 or 0x358\n");
-		return -EINVAL;
-	}
-	if (!request_region(tr->io, 2, "Trust FM Radio")) {
-		v4l2_err(v4l2_dev, "port 0x%x already in use\n", tr->io);
-		return -EBUSY;
-	}
-
-	res = v4l2_device_register(NULL, v4l2_dev);
-	if (res < 0) {
-		release_region(tr->io, 2);
-		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
-		return res;
-	}
-
-	strlcpy(tr->vdev.name, v4l2_dev->name, sizeof(tr->vdev.name));
-	tr->vdev.v4l2_dev = v4l2_dev;
-	tr->vdev.fops = &trust_fops;
-	tr->vdev.ioctl_ops = &trust_ioctl_ops;
-	tr->vdev.release = video_device_release_empty;
-	video_set_drvdata(&tr->vdev, tr);
-
 	write_i2c(tr, 2, TDA7318_ADDR, 0x80);	/* speaker att. LF = 0 dB */
 	write_i2c(tr, 2, TDA7318_ADDR, 0xa0);	/* speaker att. RF = 0 dB */
 	write_i2c(tr, 2, TDA7318_ADDR, 0xc0);	/* speaker att. LR = 0 dB */
 	write_i2c(tr, 2, TDA7318_ADDR, 0xe0);	/* speaker att. RR = 0 dB */
 	write_i2c(tr, 2, TDA7318_ADDR, 0x40);	/* stereo 1 input, gain = 18.75 dB */
 
-	tr_setvol(tr, 0xffff);
-	tr_setbass(tr, 0x8000);
-	tr_settreble(tr, 0x8000);
-	tr_setstereo(tr, 1);
-
-	/* mute card - prevents noisy bootups */
-	tr_setmute(tr, 1);
+	v4l2_ctrl_new_std(&isa->hdl, &trust_ctrl_ops,
+				V4L2_CID_AUDIO_BASS, 0, 15, 1, 8);
+	v4l2_ctrl_new_std(&isa->hdl, &trust_ctrl_ops,
+				V4L2_CID_AUDIO_TREBLE, 0, 15, 1, 8);
+	return isa->hdl.error;
+}
 
-	if (video_register_device(&tr->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-		v4l2_device_unregister(v4l2_dev);
-		release_region(tr->io, 2);
-		return -EINVAL;
-	}
+static const struct radio_isa_ops trust_ops = {
+	.init = trust_initialize,
+	.alloc = trust_alloc,
+	.s_mute_volume = trust_s_mute_volume,
+	.s_frequency = trust_s_frequency,
+	.s_stereo = trust_s_stereo,
+	.g_signal = trust_g_signal,
+};
 
-	v4l2_info(v4l2_dev, "Trust FM Radio card driver v1.0.\n");
+static const int trust_ioports[] = { 0x350, 0x358 };
+
+static struct radio_isa_driver trust_driver = {
+	.driver = {
+		.match		= radio_isa_match,
+		.probe		= radio_isa_probe,
+		.remove		= radio_isa_remove,
+		.driver		= {
+			.name	= "radio-trust",
+		},
+	},
+	.io_params = io,
+	.radio_nr_params = radio_nr,
+	.io_ports = trust_ioports,
+	.num_of_io_ports = ARRAY_SIZE(trust_ioports),
+	.region_size = 2,
+	.card = "Trust FM Radio",
+	.ops = &trust_ops,
+	.has_stereo = true,
+	.max_volume = 31,
+};
 
-	return 0;
+static int __init trust_init(void)
+{
+	return isa_register_driver(&trust_driver.driver, TRUST_MAX);
 }
 
-static void __exit cleanup_trust_module(void)
+static void __exit trust_exit(void)
 {
-	struct trust *tr = &trust_card;
-
-	video_unregister_device(&tr->vdev);
-	v4l2_device_unregister(&tr->v4l2_dev);
-	release_region(tr->io, 2);
+	isa_unregister_driver(&trust_driver.driver);
 }
 
 module_init(trust_init);
-module_exit(cleanup_trust_module);
+module_exit(trust_exit);
-- 
1.7.7.3

