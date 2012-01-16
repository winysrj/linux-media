Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3736 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab2APNKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:10:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 02/10] radio-aimslab: Convert to radio-isa.
Date: Mon, 16 Jan 2012 14:09:58 +0100
Message-Id: <331e00fac221113b091e22c603c054a7c58dfb7b.1326717025.git.hans.verkuil@cisco.com>
In-Reply-To: <1326719406-4538-1-git-send-email-hverkuil@xs4all.nl>
References: <1326719406-4538-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <30958c9eb2499987a608cdf411e578984b617046.1326717025.git.hans.verkuil@cisco.com>
References: <30958c9eb2499987a608cdf411e578984b617046.1326717025.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Tested with actual hardware and the Keene USB FM Transmitter.

Improved the volume handling delays through trial and error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/Kconfig         |    9 +-
 drivers/media/radio/radio-aimslab.c |  439 +++++++++--------------------------
 2 files changed, 110 insertions(+), 338 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 2ad446f..366fed4 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -192,6 +192,7 @@ config RADIO_CADET
 config RADIO_RTRACK
 	tristate "AIMSlab RadioTrack (aka RadioReveal) support"
 	depends on ISA && VIDEO_V4L2
+	select RADIO_ISA
 	---help---
 	  Choose Y here if you have one of these FM radio cards, and then fill
 	  in the port address below.
@@ -205,11 +206,7 @@ config RADIO_RTRACK
 	  You must also pass the module a suitable io parameter, 0x248 has
 	  been reported to be used by these cards.
 
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>. More information is
-	  contained in the file
+	  More information is contained in the file
 	  <file:Documentation/video4linux/radiotrack.txt>.
 
 	  To compile this driver as a module, choose M here: the
@@ -218,7 +215,7 @@ config RADIO_RTRACK
 config RADIO_RTRACK_PORT
 	hex "RadioTrack i/o port (0x20f or 0x30f)"
 	depends on RADIO_RTRACK=y
-	default "20f"
+	default "30f"
 	help
 	  Enter either 0x30f or 0x20f here.  The card default is 0x30f, if you
 	  haven't changed the jumper setting on the card.
diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index 1c3f844..862dfce 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -1,16 +1,13 @@
-/* radiotrack (radioreveal) driver for Linux radio support
- * (c) 1997 M. Kirkwood
+/*
+ * AimsLab RadioTrack (aka RadioVeveal) driver
+ *
+ * Copyright 1997 M. Kirkwood
+ *
+ * Converted to the radio-isa framework by Hans Verkuil <hans.verkuil@cisco.com>
  * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
  * Converted to new API by Alan Cox <alan@lxorguk.ukuu.org.uk>
  * Various bugfixes and enhancements by Russell Kroll <rkroll@exploits.org>
  *
- * History:
- * 1999-02-24	Russell Kroll <rkroll@exploits.org>
- * 		Fine tuning/VIDEO_TUNER_LOW
- *		Frequency range expanded to start at 87 MHz
- *
- * TODO: Allow for more than one of these foolish entities :-)
- *
  * Notes on the hardware (reverse engineered from other peoples'
  * reverse engineering of AIMS' code :-)
  *
@@ -26,6 +23,7 @@
  *   wait(a_wee_while);
  *   out(port, stop_changing_the_volume);
  *
+ * Fully tested with the Keene USB FM Transmitter and the v4l2-compliance tool.
  */
 
 #include <linux/module.h>	/* Modules 			*/
@@ -36,399 +34,176 @@
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include "radio-isa.h"
 
-MODULE_AUTHOR("M.Kirkwood");
+MODULE_AUTHOR("M. Kirkwood");
 MODULE_DESCRIPTION("A driver for the RadioTrack/RadioReveal radio card.");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0.0.3");
+MODULE_VERSION("1.0.0");
 
 #ifndef CONFIG_RADIO_RTRACK_PORT
 #define CONFIG_RADIO_RTRACK_PORT -1
 #endif
 
-static int io = CONFIG_RADIO_RTRACK_PORT;
-static int radio_nr = -1;
+#define RTRACK_MAX 2
 
-module_param(io, int, 0);
-MODULE_PARM_DESC(io, "I/O address of the RadioTrack card (0x20f or 0x30f)");
-module_param(radio_nr, int, 0);
+static int io[RTRACK_MAX] = { [0] = CONFIG_RADIO_RTRACK_PORT,
+			      [1 ... (RTRACK_MAX - 1)] = -1 };
+static int radio_nr[RTRACK_MAX]	= { [0 ... (RTRACK_MAX - 1)] = -1 };
 
-struct rtrack
-{
-	struct v4l2_device v4l2_dev;
-	struct video_device vdev;
-	int port;
+module_param_array(io, int, NULL, 0444);
+MODULE_PARM_DESC(io, "I/O addresses of the RadioTrack card (0x20f or 0x30f)");
+module_param_array(radio_nr, int, NULL, 0444);
+MODULE_PARM_DESC(radio_nr, "Radio device numbers");
+
+struct rtrack {
+	struct radio_isa_card isa;
 	int curvol;
-	unsigned long curfreq;
-	int muted;
-	int io;
-	struct mutex lock;
 };
 
-static struct rtrack rtrack_card;
-
-/* local things */
-
-static void rt_decvol(struct rtrack *rt)
-{
-	outb(0x58, rt->io);		/* volume down + sigstr + on	*/
-	msleep(100);
-	outb(0xd8, rt->io);		/* volume steady + sigstr + on	*/
-}
-
-static void rt_incvol(struct rtrack *rt)
-{
-	outb(0x98, rt->io);		/* volume up + sigstr + on	*/
-	msleep(100);
-	outb(0xd8, rt->io);		/* volume steady + sigstr + on	*/
-}
-
-static void rt_mute(struct rtrack *rt)
-{
-	rt->muted = 1;
-	mutex_lock(&rt->lock);
-	outb(0xd0, rt->io);		/* volume steady, off		*/
-	mutex_unlock(&rt->lock);
-}
-
-static int rt_setvol(struct rtrack *rt, int vol)
+static struct radio_isa_card *rtrack_alloc(void)
 {
-	int i;
-
-	mutex_lock(&rt->lock);
-
-	if (vol == rt->curvol) {	/* requested volume = current */
-		if (rt->muted) {	/* user is unmuting the card  */
-			rt->muted = 0;
-			outb(0xd8, rt->io);	/* enable card */
-		}
-		mutex_unlock(&rt->lock);
-		return 0;
-	}
-
-	if (vol == 0) {			/* volume = 0 means mute the card */
-		outb(0x48, rt->io);	/* volume down but still "on"	*/
-		msleep(2000);	/* make sure it's totally down	*/
-		outb(0xd0, rt->io);	/* volume steady, off		*/
-		rt->curvol = 0;		/* track the volume state!	*/
-		mutex_unlock(&rt->lock);
-		return 0;
-	}
+	struct rtrack *rt = kzalloc(sizeof(struct rtrack), GFP_KERNEL);
 
-	rt->muted = 0;
-	if (vol > rt->curvol)
-		for (i = rt->curvol; i < vol; i++)
-			rt_incvol(rt);
-	else
-		for (i = rt->curvol; i > vol; i--)
-			rt_decvol(rt);
-
-	rt->curvol = vol;
-	mutex_unlock(&rt->lock);
-	return 0;
+	if (rt)
+		rt->curvol = 0xff;
+	return rt ? &rt->isa : NULL;
 }
 
-/* the 128+64 on these outb's is to keep the volume stable while tuning
- * without them, the volume _will_ creep up with each frequency change
- * and bit 4 (+16) is to keep the signal strength meter enabled
+/* The 128+64 on these outb's is to keep the volume stable while tuning.
+ * Without them, the volume _will_ creep up with each frequency change
+ * and bit 4 (+16) is to keep the signal strength meter enabled.
  */
 
-static void send_0_byte(struct rtrack *rt)
+static void send_0_byte(struct radio_isa_card *isa, int on)
 {
-	if (rt->curvol == 0 || rt->muted) {
-		outb_p(128+64+16+  1, rt->io);   /* wr-enable + data low */
-		outb_p(128+64+16+2+1, rt->io);   /* clock */
-	}
-	else {
-		outb_p(128+64+16+8+  1, rt->io);  /* on + wr-enable + data low */
-		outb_p(128+64+16+8+2+1, rt->io);  /* clock */
-	}
+	outb_p(128+64+16+on+1, isa->io);	/* wr-enable + data low */
+	outb_p(128+64+16+on+2+1, isa->io);	/* clock */
 	msleep(1);
 }
 
-static void send_1_byte(struct rtrack *rt)
+static void send_1_byte(struct radio_isa_card *isa, int on)
 {
-	if (rt->curvol == 0 || rt->muted) {
-		outb_p(128+64+16+4  +1, rt->io);   /* wr-enable+data high */
-		outb_p(128+64+16+4+2+1, rt->io);   /* clock */
-	}
-	else {
-		outb_p(128+64+16+8+4  +1, rt->io); /* on+wr-enable+data high */
-		outb_p(128+64+16+8+4+2+1, rt->io); /* clock */
-	}
-
+	outb_p(128+64+16+on+4+1, isa->io);	/* wr-enable+data high */
+	outb_p(128+64+16+on+4+2+1, isa->io);	/* clock */
 	msleep(1);
 }
 
-static int rt_setfreq(struct rtrack *rt, unsigned long freq)
+static int rtrack_s_frequency(struct radio_isa_card *isa, u32 freq)
 {
+	int on = v4l2_ctrl_g_ctrl(isa->mute) ? 0 : 8;
 	int i;
 
-	mutex_lock(&rt->lock);			/* Stop other ops interfering */
-
-	rt->curfreq = freq;
-
-	/* now uses VIDEO_TUNER_LOW for fine tuning */
-
 	freq += 171200;			/* Add 10.7 MHz IF 		*/
 	freq /= 800;			/* Convert to 50 kHz units	*/
 
-	send_0_byte(rt);		/*  0: LSB of frequency		*/
+	send_0_byte(isa, on);		/*  0: LSB of frequency		*/
 
 	for (i = 0; i < 13; i++)	/*   : frequency bits (1-13)	*/
 		if (freq & (1 << i))
-			send_1_byte(rt);
+			send_1_byte(isa, on);
 		else
-			send_0_byte(rt);
-
-	send_0_byte(rt);		/* 14: test bit - always 0    */
-	send_0_byte(rt);		/* 15: test bit - always 0    */
-
-	send_0_byte(rt);		/* 16: band data 0 - always 0 */
-	send_0_byte(rt);		/* 17: band data 1 - always 0 */
-	send_0_byte(rt);		/* 18: band data 2 - always 0 */
-	send_0_byte(rt);		/* 19: time base - always 0   */
-
-	send_0_byte(rt);		/* 20: spacing (0 = 25 kHz)   */
-	send_1_byte(rt);		/* 21: spacing (1 = 25 kHz)   */
-	send_0_byte(rt);		/* 22: spacing (0 = 25 kHz)   */
-	send_1_byte(rt);		/* 23: AM/FM (FM = 1, always) */
-
-	if (rt->curvol == 0 || rt->muted)
-		outb(0xd0, rt->io);	/* volume steady + sigstr */
-	else
-		outb(0xd8, rt->io);	/* volume steady + sigstr + on */
-
-	mutex_unlock(&rt->lock);
-
-	return 0;
-}
-
-static int rt_getsigstr(struct rtrack *rt)
-{
-	int sig = 1;
-
-	mutex_lock(&rt->lock);
-	if (inb(rt->io) & 2)	/* bit set = no signal present	*/
-		sig = 0;
-	mutex_unlock(&rt->lock);
-	return sig;
-}
-
-static int vidioc_querycap(struct file *file, void  *priv,
-					struct v4l2_capability *v)
-{
-	strlcpy(v->driver, "radio-aimslab", sizeof(v->driver));
-	strlcpy(v->card, "RadioTrack", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
-	return 0;
-}
-
-static int vidioc_g_tuner(struct file *file, void *priv,
-					struct v4l2_tuner *v)
-{
-	struct rtrack *rt = video_drvdata(file);
+			send_0_byte(isa, on);
 
-	if (v->index > 0)
-		return -EINVAL;
+	send_0_byte(isa, on);		/* 14: test bit - always 0    */
+	send_0_byte(isa, on);		/* 15: test bit - always 0    */
 
-	strlcpy(v->name, "FM", sizeof(v->name));
-	v->type = V4L2_TUNER_RADIO;
-	v->rangelow = 87 * 16000;
-	v->rangehigh = 108 * 16000;
-	v->rxsubchans = V4L2_TUNER_SUB_MONO;
-	v->capability = V4L2_TUNER_CAP_LOW;
-	v->audmode = V4L2_TUNER_MODE_MONO;
-	v->signal = 0xffff * rt_getsigstr(rt);
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
-	struct rtrack *rt = video_drvdata(file);
-
-	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
-		return -EINVAL;
-	rt_setfreq(rt, f->frequency);
-	return 0;
-}
+	send_0_byte(isa, on);		/* 16: band data 0 - always 0 */
+	send_0_byte(isa, on);		/* 17: band data 1 - always 0 */
+	send_0_byte(isa, on);		/* 18: band data 2 - always 0 */
+	send_0_byte(isa, on);		/* 19: time base - always 0   */
 
-static int vidioc_g_frequency(struct file *file, void *priv,
-					struct v4l2_frequency *f)
-{
-	struct rtrack *rt = video_drvdata(file);
+	send_0_byte(isa, on);		/* 20: spacing (0 = 25 kHz)   */
+	send_1_byte(isa, on);		/* 21: spacing (1 = 25 kHz)   */
+	send_0_byte(isa, on);		/* 22: spacing (0 = 25 kHz)   */
+	send_1_byte(isa, on);		/* 23: AM/FM (FM = 1, always) */
 
-	if (f->tuner != 0)
-		return -EINVAL;
-	f->type = V4L2_TUNER_RADIO;
-	f->frequency = rt->curfreq;
+	outb(0xd0 + on, isa->io);	/* volume steady + sigstr */
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-					struct v4l2_queryctrl *qc)
+static u32 rtrack_g_signal(struct radio_isa_card *isa)
 {
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(qc, 0, 0xff, 1, 0xff);
-	}
-	return -EINVAL;
+	/* bit set = no signal present */
+	return 0xffff * !(inb(isa->io) & 2);
 }
 
-static int vidioc_g_ctrl(struct file *file, void *priv,
-					struct v4l2_control *ctrl)
+static int rtrack_s_mute_volume(struct radio_isa_card *isa, bool mute, int vol)
 {
-	struct rtrack *rt = video_drvdata(file);
+	struct rtrack *rt = container_of(isa, struct rtrack, isa);
+	int curvol = rt->curvol;
 
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = rt->muted;
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = rt->curvol;
+	if (mute) {
+		outb(0xd0, isa->io);	/* volume steady + sigstr + off	*/
 		return 0;
 	}
-	return -EINVAL;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-					struct v4l2_control *ctrl)
-{
-	struct rtrack *rt = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		if (ctrl->value)
-			rt_mute(rt);
-		else
-			rt_setvol(rt, rt->curvol);
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		rt_setvol(rt, ctrl->value);
-		return 0;
+	if (vol == 0) {			/* volume = 0 means mute the card */
+		outb(0x48, isa->io);	/* volume down but still "on"	*/
+		msleep(curvol * 3);	/* make sure it's totally down	*/
+	} else if (curvol < vol) {
+		outb(0x98, isa->io);	/* volume up + sigstr + on	*/
+		for (; curvol < vol; curvol++)
+			udelay(3000);
+	} else if (curvol > vol) {
+		outb(0x58, isa->io);	/* volume down + sigstr + on	*/
+		for (; curvol > vol; curvol--)
+			udelay(3000);
 	}
-	return -EINVAL;
-}
-
-static int vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	*i = 0;
+	outb(0xd8, isa->io);		/* volume steady + sigstr + on	*/
+	rt->curvol = vol;
 	return 0;
 }
 
-static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
+/* Mute card - prevents noisy bootups */
+static int rtrack_initialize(struct radio_isa_card *isa)
 {
-	return i ? -EINVAL : 0;
-}
-
-static int vidioc_g_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
-{
-	a->index = 0;
-	strlcpy(a->name, "Radio", sizeof(a->name));
-	a->capability = V4L2_AUDCAP_STEREO;
+	/* this ensures that the volume is all the way up  */
+	outb(0x90, isa->io);	/* volume up but still "on"	*/
+	msleep(3000);		/* make sure it's totally up	*/
+	outb(0xc0, isa->io);	/* steady volume, mute card	*/
 	return 0;
 }
 
-static int vidioc_s_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
-{
-	return a->index ? -EINVAL : 0;
-}
-
-static const struct v4l2_file_operations rtrack_fops = {
-	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= video_ioctl2,
+static const struct radio_isa_ops rtrack_ops = {
+	.alloc = rtrack_alloc,
+	.init = rtrack_initialize,
+	.s_mute_volume = rtrack_s_mute_volume,
+	.s_frequency = rtrack_s_frequency,
+	.g_signal = rtrack_g_signal,
 };
 
-static const struct v4l2_ioctl_ops rtrack_ioctl_ops = {
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
+static const int rtrack_ioports[] = { 0x20f, 0x30f };
+
+static struct radio_isa_driver rtrack_driver = {
+	.driver = {
+		.match		= radio_isa_match,
+		.probe		= radio_isa_probe,
+		.remove		= radio_isa_remove,
+		.driver		= {
+			.name	= "radio-aimslab",
+		},
+	},
+	.io_params = io,
+	.radio_nr_params = radio_nr,
+	.io_ports = rtrack_ioports,
+	.num_of_io_ports = ARRAY_SIZE(rtrack_ioports),
+	.region_size = 2,
+	.card = "AIMSlab RadioTrack/RadioReveal",
+	.ops = &rtrack_ops,
+	.has_stereo = true,
+	.max_volume = 0xff,
 };
 
 static int __init rtrack_init(void)
 {
-	struct rtrack *rt = &rtrack_card;
-	struct v4l2_device *v4l2_dev = &rt->v4l2_dev;
-	int res;
-
-	strlcpy(v4l2_dev->name, "rtrack", sizeof(v4l2_dev->name));
-	rt->io = io;
-
-	if (rt->io == -1) {
-		v4l2_err(v4l2_dev, "you must set an I/O address with io=0x20f or 0x30f\n");
-		return -EINVAL;
-	}
-
-	if (!request_region(rt->io, 2, "rtrack")) {
-		v4l2_err(v4l2_dev, "port 0x%x already in use\n", rt->io);
-		return -EBUSY;
-	}
-
-	res = v4l2_device_register(NULL, v4l2_dev);
-	if (res < 0) {
-		release_region(rt->io, 2);
-		v4l2_err(v4l2_dev, "could not register v4l2_device\n");
-		return res;
-	}
-
-	strlcpy(rt->vdev.name, v4l2_dev->name, sizeof(rt->vdev.name));
-	rt->vdev.v4l2_dev = v4l2_dev;
-	rt->vdev.fops = &rtrack_fops;
-	rt->vdev.ioctl_ops = &rtrack_ioctl_ops;
-	rt->vdev.release = video_device_release_empty;
-	video_set_drvdata(&rt->vdev, rt);
-
-	/* Set up the I/O locking */
-
-	mutex_init(&rt->lock);
-
-	/* mute card - prevents noisy bootups */
-
-	/* this ensures that the volume is all the way down  */
-	outb(0x48, rt->io);		/* volume down but still "on"	*/
-	msleep(2000);	/* make sure it's totally down	*/
-	outb(0xc0, rt->io);		/* steady volume, mute card	*/
-
-	if (video_register_device(&rt->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-		v4l2_device_unregister(&rt->v4l2_dev);
-		release_region(rt->io, 2);
-		return -EINVAL;
-	}
-	v4l2_info(v4l2_dev, "AIMSlab RadioTrack/RadioReveal card driver.\n");
-
-	return 0;
+	return isa_register_driver(&rtrack_driver.driver, RTRACK_MAX);
 }
 
 static void __exit rtrack_exit(void)
 {
-	struct rtrack *rt = &rtrack_card;
-
-	video_unregister_device(&rt->vdev);
-	v4l2_device_unregister(&rt->v4l2_dev);
-	release_region(rt->io, 2);
+	isa_unregister_driver(&rtrack_driver.driver);
 }
 
 module_init(rtrack_init);
 module_exit(rtrack_exit);
-
-- 
1.7.7.3

