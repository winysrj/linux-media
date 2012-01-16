Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1119 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2APNKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:10:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: =?UTF-8?q?=5BRFC=20PATCH=2004/10=5D=20radio-gemtek=3A=20Convert=20to=20radio-isa=2E?=
Date: Mon, 16 Jan 2012 14:10:00 +0100
Message-Id: <5b181cfa741d3946d77a89e56347cf269c7beb88.1326717025.git.hans.verkuil@cisco.com>
In-Reply-To: <1326719406-4538-1-git-send-email-hverkuil@xs4all.nl>
References: <1326719406-4538-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <30958c9eb2499987a608cdf411e578984b617046.1326717025.git.hans.verkuil@cisco.com>
References: <30958c9eb2499987a608cdf411e578984b617046.1326717025.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Tested with actual hardware (up to two cards) and the Keene USB FM Transmitter.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/Kconfig        |   17 +-
 drivers/media/radio/radio-gemtek.c |  493 +++++++-----------------------------
 2 files changed, 106 insertions(+), 404 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 803f31a..0695219 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -266,6 +266,7 @@ config RADIO_AZTECH_PORT
 config RADIO_GEMTEK
 	tristate "GemTek Radio card (or compatible) support"
 	depends on ISA && VIDEO_V4L2
+	select RADIO_ISA
 	---help---
 	  Choose Y here if you have this FM radio card, and then fill in the
 	  I/O port address and settings below. The following cards either have
@@ -275,23 +276,21 @@ config RADIO_GEMTEK
 	  - Typhoon Radio card (some models)
 	  - Hama Radio card
 
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-gemtek.
 
 config RADIO_GEMTEK_PORT
-	hex "Fixed I/O port (0x20c, 0x30c, 0x24c, 0x34c, 0c24c or 0x28c)"
+	hex "Fixed I/O port (0x20c, 0x30c, 0x24c, 0x34c, 0x248 or 0x28c)"
 	depends on RADIO_GEMTEK=y
 	default "34c"
 	help
-	  Enter either 0x20c, 0x30c, 0x24c or 0x34c here. The card default is
-	  0x34c, if you haven't changed the jumper setting on the card. On
-	  Sound Vision 16 Gold PnP with FM Radio (ESS1869+FM Gemtek), the I/O
+	  Enter either 0x20c, 0x30c, 0x24c, 0x34c, 0x248 or 0x28c here. The
+	  card default is 0x34c, if you haven't changed the jumper setting
+	  on the card.
+
+	  On Sound Vision 16 Gold PnP with FM Radio (ESS1869+FM Gemtek), the I/O
 	  port is 0x20c, 0x248 or 0x28c.
+
 	  If automatic I/O port probing is enabled this port will be used only
 	  in case of automatic probing failure, ie. as a fallback.
 
diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index edadc84..d5712a9 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -1,4 +1,7 @@
-/* GemTek radio card driver for Linux (C) 1998 Jonas Munsin <jmunsin@iki.fi>
+/*
+ * GemTek radio card driver
+ *
+ * Copyright 1998 Jonas Munsin <jmunsin@iki.fi>
  *
  * GemTek hasn't released any specs on the card, so the protocol had to
  * be reverse engineered with dosemu.
@@ -11,9 +14,12 @@
  *    Converted to new API by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *    Various bugfixes and enhancements by Russell Kroll <rkroll@exploits.org>
  *
- * TODO: Allow for more than one of these foolish entities :-)
- *
+ * Converted to the radio-isa framework by Hans Verkuil <hans.verkuil@cisco.com>
  * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
+ *
+ * Note: this card seems to swap the left and right audio channels!
+ *
+ * Fully tested with the Keene USB FM Transmitter and the v4l2-compliance tool.
  */
 
 #include <linux/module.h>	/* Modules 			*/
@@ -25,6 +31,7 @@
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
+#include "radio-isa.h"
 
 /*
  * Module info.
@@ -33,7 +40,7 @@
 MODULE_AUTHOR("Jonas Munsin, Pekka Seppänen <pexu@kapsi.fi>");
 MODULE_DESCRIPTION("A driver for the GemTek Radio card.");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0.0.4");
+MODULE_VERSION("1.0.0");
 
 /*
  * Module params.
@@ -46,45 +53,29 @@ MODULE_VERSION("0.0.4");
 #define CONFIG_RADIO_GEMTEK_PROBE 1
 #endif
 
-static int io		= CONFIG_RADIO_GEMTEK_PORT;
-static int probe	= CONFIG_RADIO_GEMTEK_PROBE;
-static int hardmute;
-static int shutdown	= 1;
-static int keepmuted	= 1;
-static int initmute	= 1;
-static int radio_nr	= -1;
+#define GEMTEK_MAX 4
 
-module_param(io, int, 0444);
-MODULE_PARM_DESC(io, "Force I/O port for the GemTek Radio card if automatic "
-	 "probing is disabled or fails. The most common I/O ports are: 0x20c "
-	 "0x30c, 0x24c or 0x34c (0x20c, 0x248 and 0x28c have been reported to "
-	 "work for the combined sound/radiocard).");
+static int probe = CONFIG_RADIO_GEMTEK_PROBE;
+static int hardmute;
+static int io[GEMTEK_MAX] = { [0] = CONFIG_RADIO_GEMTEK_PORT,
+			      [1 ... (GEMTEK_MAX - 1)] = -1 };
+static int radio_nr[GEMTEK_MAX]	= { [0 ... (GEMTEK_MAX - 1)] = -1 };
 
 module_param(probe, bool, 0444);
-MODULE_PARM_DESC(probe, "Enable automatic device probing. Note: only the most "
-	"common I/O ports used by the card are probed.");
+MODULE_PARM_DESC(probe, "Enable automatic device probing.");
 
 module_param(hardmute, bool, 0644);
-MODULE_PARM_DESC(hardmute, "Enable `hard muting' by shutting down PLL, may "
+MODULE_PARM_DESC(hardmute, "Enable 'hard muting' by shutting down PLL, may "
 	 "reduce static noise.");
 
-module_param(shutdown, bool, 0644);
-MODULE_PARM_DESC(shutdown, "Enable shutting down PLL and muting line when "
-	 "module is unloaded.");
-
-module_param(keepmuted, bool, 0644);
-MODULE_PARM_DESC(keepmuted, "Keep card muted even when frequency is changed.");
-
-module_param(initmute, bool, 0444);
-MODULE_PARM_DESC(initmute, "Mute card when module is loaded.");
-
-module_param(radio_nr, int, 0444);
+module_param_array(io, int, NULL, 0444);
+MODULE_PARM_DESC(io, "Force I/O ports for the GemTek Radio card if automatic "
+	 "probing is disabled or fails. The most common I/O ports are: 0x20c "
+	 "0x30c, 0x24c or 0x34c (0x20c, 0x248 and 0x28c have been reported to "
+	 "work for the combined sound/radiocard).");
 
-/*
- * Functions for controlling the card.
- */
-#define GEMTEK_LOWFREQ	(87*16000)
-#define GEMTEK_HIGHFREQ	(108*16000)
+module_param_array(radio_nr, int, NULL, 0444);
+MODULE_PARM_DESC(radio_nr, "Radio device numbers");
 
 /*
  * Frequency calculation constants.  Intermediate frequency 10.52 MHz (nominal
@@ -108,18 +99,11 @@ module_param(radio_nr, int, 0444);
 #define LONG_DELAY 75		/* usec */
 
 struct gemtek {
-	struct v4l2_device v4l2_dev;
-	struct video_device vdev;
-	struct mutex lock;
-	unsigned long lastfreq;
-	int muted;
-	int verified;
-	int io;
+	struct radio_isa_card isa;
+	bool muted;
 	u32 bu2614data;
 };
 
-static struct gemtek gemtek_card;
-
 #define BU2614_FREQ_BITS 	16 /* D0..D15, Frequency data		*/
 #define BU2614_PORT_BITS	3 /* P0..P2, Output port control data	*/
 #define BU2614_VOID_BITS	4 /* unused 				*/
@@ -166,31 +150,24 @@ static struct gemtek gemtek_card;
  */
 static void gemtek_bu2614_transmit(struct gemtek *gt)
 {
+	struct radio_isa_card *isa = &gt->isa;
 	int i, bit, q, mute;
 
-	mutex_lock(&gt->lock);
-
 	mute = gt->muted ? GEMTEK_MT : 0x00;
 
-	outb_p(mute | GEMTEK_DA | GEMTEK_CK, gt->io);
-	udelay(SHORT_DELAY);
-	outb_p(mute | GEMTEK_CE | GEMTEK_DA | GEMTEK_CK, gt->io);
+	outb_p(mute | GEMTEK_CE | GEMTEK_DA | GEMTEK_CK, isa->io);
 	udelay(LONG_DELAY);
 
 	for (i = 0, q = gt->bu2614data; i < 32; i++, q >>= 1) {
 		bit = (q & 1) ? GEMTEK_DA : 0;
-		outb_p(mute | GEMTEK_CE | bit, gt->io);
+		outb_p(mute | GEMTEK_CE | bit, isa->io);
 		udelay(SHORT_DELAY);
-		outb_p(mute | GEMTEK_CE | bit | GEMTEK_CK, gt->io);
+		outb_p(mute | GEMTEK_CE | bit | GEMTEK_CK, isa->io);
 		udelay(SHORT_DELAY);
 	}
 
-	outb_p(mute | GEMTEK_DA | GEMTEK_CK, gt->io);
+	outb_p(mute | GEMTEK_DA | GEMTEK_CK, isa->io);
 	udelay(SHORT_DELAY);
-	outb_p(mute | GEMTEK_CE | GEMTEK_DA | GEMTEK_CK, gt->io);
-	udelay(LONG_DELAY);
-
-	mutex_unlock(&gt->lock);
 }
 
 /*
@@ -198,21 +175,27 @@ static void gemtek_bu2614_transmit(struct gemtek *gt)
  */
 static unsigned long gemtek_convfreq(unsigned long freq)
 {
-	return ((freq<<FSCALE) + IF_OFFSET + REF_FREQ/2) / REF_FREQ;
+	return ((freq << FSCALE) + IF_OFFSET + REF_FREQ / 2) / REF_FREQ;
+}
+
+static struct radio_isa_card *gemtek_alloc(void)
+{
+	struct gemtek *gt = kzalloc(sizeof(*gt), GFP_KERNEL);
+
+	if (gt)
+		gt->muted = true;
+	return gt ? &gt->isa : NULL;
 }
 
 /*
  * Set FM-frequency.
  */
-static void gemtek_setfreq(struct gemtek *gt, unsigned long freq)
+static int gemtek_s_frequency(struct radio_isa_card *isa, u32 freq)
 {
-	if (keepmuted && hardmute && gt->muted)
-		return;
+	struct gemtek *gt = container_of(isa, struct gemtek, isa);
 
-	freq = clamp_val(freq, GEMTEK_LOWFREQ, GEMTEK_HIGHFREQ);
-
-	gt->lastfreq = freq;
-	gt->muted = 0;
+	if (hardmute && gt->muted)
+		return 0;
 
 	gemtek_bu2614_set(gt, BU2614_PORT, 0);
 	gemtek_bu2614_set(gt, BU2614_FMES, 0);
@@ -220,23 +203,25 @@ static void gemtek_setfreq(struct gemtek *gt, unsigned long freq)
 	gemtek_bu2614_set(gt, BU2614_SWAL, 0);
 	gemtek_bu2614_set(gt, BU2614_FMUN, 1);	/* GT bit set	*/
 	gemtek_bu2614_set(gt, BU2614_TEST, 0);
-
 	gemtek_bu2614_set(gt, BU2614_STDF, GEMTEK_STDF_3_125_KHZ);
 	gemtek_bu2614_set(gt, BU2614_FREQ, gemtek_convfreq(freq));
-
 	gemtek_bu2614_transmit(gt);
+	return 0;
 }
 
 /*
  * Set mute flag.
  */
-static void gemtek_mute(struct gemtek *gt)
+static int gemtek_s_mute_volume(struct radio_isa_card *isa, bool mute, int vol)
 {
+	struct gemtek *gt = container_of(isa, struct gemtek, isa);
 	int i;
 
-	gt->muted = 1;
-
+	gt->muted = mute;
 	if (hardmute) {
+		if (!mute)
+			return gemtek_s_frequency(isa, isa->freq);
+
 		/* Turn off PLL, disable data output */
 		gemtek_bu2614_set(gt, BU2614_PORT, 0);
 		gemtek_bu2614_set(gt, BU2614_FMES, 0);	/* CT bit off	*/
@@ -247,367 +232,85 @@ static void gemtek_mute(struct gemtek *gt)
 		gemtek_bu2614_set(gt, BU2614_STDF, GEMTEK_PLL_OFF);
 		gemtek_bu2614_set(gt, BU2614_FREQ, 0);
 		gemtek_bu2614_transmit(gt);
-		return;
+		return 0;
 	}
 
-	mutex_lock(&gt->lock);
-
 	/* Read bus contents (CE, CK and DA). */
-	i = inb_p(gt->io);
+	i = inb_p(isa->io);
 	/* Write it back with mute flag set. */
-	outb_p((i >> 5) | GEMTEK_MT, gt->io);
+	outb_p((i >> 5) | (mute ? GEMTEK_MT : 0), isa->io);
 	udelay(SHORT_DELAY);
-
-	mutex_unlock(&gt->lock);
-}
-
-/*
- * Unset mute flag.
- */
-static void gemtek_unmute(struct gemtek *gt)
-{
-	int i;
-
-	gt->muted = 0;
-	if (hardmute) {
-		/* Turn PLL back on. */
-		gemtek_setfreq(gt, gt->lastfreq);
-		return;
-	}
-	mutex_lock(&gt->lock);
-
-	i = inb_p(gt->io);
-	outb_p(i >> 5, gt->io);
-	udelay(SHORT_DELAY);
-
-	mutex_unlock(&gt->lock);
+	return 0;
 }
 
-/*
- * Get signal strength (= stereo status).
- */
-static inline int gemtek_getsigstr(struct gemtek *gt)
+static u32 gemtek_g_rxsubchans(struct radio_isa_card *isa)
 {
-	int sig;
-
-	mutex_lock(&gt->lock);
-	sig = inb_p(gt->io) & GEMTEK_NS ? 0 : 1;
-	mutex_unlock(&gt->lock);
-	return sig;
+	if (inb_p(isa->io) & GEMTEK_NS)
+		return V4L2_TUNER_SUB_MONO;
+	return V4L2_TUNER_SUB_STEREO;
 }
 
 /*
  * Check if requested card acts like GemTek Radio card.
  */
-static int gemtek_verify(struct gemtek *gt, int port)
+static bool gemtek_probe(struct radio_isa_card *isa, int io)
 {
 	int i, q;
 
-	if (gt->verified == port)
-		return 1;
-
-	mutex_lock(&gt->lock);
-
-	q = inb_p(port);	/* Read bus contents before probing. */
+	q = inb_p(io);	/* Read bus contents before probing. */
 	/* Try to turn on CE, CK and DA respectively and check if card responds
 	   properly. */
 	for (i = 0; i < 3; ++i) {
-		outb_p(1 << i, port);
+		outb_p(1 << i, io);
 		udelay(SHORT_DELAY);
 
-		if ((inb_p(port) & (~GEMTEK_NS)) != (0x17 | (1 << (i + 5)))) {
-			mutex_unlock(&gt->lock);
-			return 0;
-		}
+		if ((inb_p(io) & ~GEMTEK_NS) != (0x17 | (1 << (i + 5))))
+			return false;
 	}
-	outb_p(q >> 5, port);	/* Write bus contents back. */
+	outb_p(q >> 5, io);	/* Write bus contents back. */
 	udelay(SHORT_DELAY);
-
-	mutex_unlock(&gt->lock);
-	gt->verified = port;
-
-	return 1;
-}
-
-/*
- * Automatic probing for card.
- */
-static int gemtek_probe(struct gemtek *gt)
-{
-	struct v4l2_device *v4l2_dev = &gt->v4l2_dev;
-	int ioports[] = { 0x20c, 0x30c, 0x24c, 0x34c, 0x248, 0x28c };
-	int i;
-
-	if (!probe) {
-		v4l2_info(v4l2_dev, "Automatic device probing disabled.\n");
-		return -1;
-	}
-
-	v4l2_info(v4l2_dev, "Automatic device probing enabled.\n");
-
-	for (i = 0; i < ARRAY_SIZE(ioports); ++i) {
-		v4l2_info(v4l2_dev, "Trying I/O port 0x%x...\n", ioports[i]);
-
-		if (!request_region(ioports[i], 1, "gemtek-probe")) {
-			v4l2_warn(v4l2_dev, "I/O port 0x%x busy!\n",
-			       ioports[i]);
-			continue;
-		}
-
-		if (gemtek_verify(gt, ioports[i])) {
-			v4l2_info(v4l2_dev, "Card found from I/O port "
-			       "0x%x!\n", ioports[i]);
-
-			release_region(ioports[i], 1);
-			gt->io = ioports[i];
-			return gt->io;
-		}
-
-		release_region(ioports[i], 1);
-	}
-
-	v4l2_err(v4l2_dev, "Automatic probing failed!\n");
-	return -1;
+	return true;
 }
 
-/*
- * Video 4 Linux stuff.
- */
-
-static const struct v4l2_file_operations gemtek_fops = {
-	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= video_ioctl2,
+static const struct radio_isa_ops gemtek_ops = {
+	.alloc = gemtek_alloc,
+	.probe = gemtek_probe,
+	.s_mute_volume = gemtek_s_mute_volume,
+	.s_frequency = gemtek_s_frequency,
+	.g_rxsubchans = gemtek_g_rxsubchans,
 };
 
-static int vidioc_querycap(struct file *file, void *priv,
-			   struct v4l2_capability *v)
-{
-	strlcpy(v->driver, "radio-gemtek", sizeof(v->driver));
-	strlcpy(v->card, "GemTek", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
-	return 0;
-}
-
-static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
-{
-	struct gemtek *gt = video_drvdata(file);
-
-	if (v->index > 0)
-		return -EINVAL;
-
-	strlcpy(v->name, "FM", sizeof(v->name));
-	v->type = V4L2_TUNER_RADIO;
-	v->rangelow = GEMTEK_LOWFREQ;
-	v->rangehigh = GEMTEK_HIGHFREQ;
-	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
-	v->signal = 0xffff * gemtek_getsigstr(gt);
-	if (v->signal) {
-		v->audmode = V4L2_TUNER_MODE_STEREO;
-		v->rxsubchans = V4L2_TUNER_SUB_STEREO;
-	} else {
-		v->audmode = V4L2_TUNER_MODE_MONO;
-		v->rxsubchans = V4L2_TUNER_SUB_MONO;
-	}
-	return 0;
-}
-
-static int vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
-{
-	return (v->index != 0) ? -EINVAL : 0;
-}
-
-static int vidioc_g_frequency(struct file *file, void *priv,
-			      struct v4l2_frequency *f)
-{
-	struct gemtek *gt = video_drvdata(file);
-
-	if (f->tuner != 0)
-		return -EINVAL;
-	f->type = V4L2_TUNER_RADIO;
-	f->frequency = gt->lastfreq;
-	return 0;
-}
-
-static int vidioc_s_frequency(struct file *file, void *priv,
-			      struct v4l2_frequency *f)
-{
-	struct gemtek *gt = video_drvdata(file);
-
-	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
-		return -EINVAL;
-	gemtek_setfreq(gt, f->frequency);
-	return 0;
-}
-
-static int vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 0);
-	default:
-		return -EINVAL;
-	}
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct gemtek *gt = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = gt->muted;
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct gemtek *gt = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		if (ctrl->value)
-			gemtek_mute(gt);
-		else
-			gemtek_unmute(gt);
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
-	return (i != 0) ? -EINVAL : 0;
-}
-
-static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
-{
-	a->index = 0;
-	strlcpy(a->name, "Radio", sizeof(a->name));
-	a->capability = V4L2_AUDCAP_STEREO;
-	return 0;
-}
-
-static int vidioc_s_audio(struct file *file, void *priv, struct v4l2_audio *a)
-{
-	return (a->index != 0) ? -EINVAL : 0;
-}
-
-static const struct v4l2_ioctl_ops gemtek_ioctl_ops = {
-	.vidioc_querycap	= vidioc_querycap,
-	.vidioc_g_tuner		= vidioc_g_tuner,
-	.vidioc_s_tuner		= vidioc_s_tuner,
-	.vidioc_g_audio		= vidioc_g_audio,
-	.vidioc_s_audio		= vidioc_s_audio,
-	.vidioc_g_input		= vidioc_g_input,
-	.vidioc_s_input		= vidioc_s_input,
-	.vidioc_g_frequency	= vidioc_g_frequency,
-	.vidioc_s_frequency	= vidioc_s_frequency,
-	.vidioc_queryctrl	= vidioc_queryctrl,
-	.vidioc_g_ctrl		= vidioc_g_ctrl,
-	.vidioc_s_ctrl		= vidioc_s_ctrl
+static const int gemtek_ioports[] = { 0x20c, 0x30c, 0x24c, 0x34c, 0x248, 0x28c };
+
+static struct radio_isa_driver gemtek_driver = {
+	.driver = {
+		.match		= radio_isa_match,
+		.probe		= radio_isa_probe,
+		.remove		= radio_isa_remove,
+		.driver		= {
+			.name	= "radio-gemtek",
+		},
+	},
+	.io_params = io,
+	.radio_nr_params = radio_nr,
+	.io_ports = gemtek_ioports,
+	.num_of_io_ports = ARRAY_SIZE(gemtek_ioports),
+	.region_size = 1,
+	.card = "GemTek Radio",
+	.ops = &gemtek_ops,
+	.has_stereo = true,
 };
 
-/*
- * Initialization / cleanup related stuff.
- */
-
 static int __init gemtek_init(void)
 {
-	struct gemtek *gt = &gemtek_card;
-	struct v4l2_device *v4l2_dev = &gt->v4l2_dev;
-	int res;
-
-	strlcpy(v4l2_dev->name, "gemtek", sizeof(v4l2_dev->name));
-
-	v4l2_info(v4l2_dev, "GemTek Radio card driver: v0.0.3\n");
-
-	mutex_init(&gt->lock);
-
-	gt->verified = -1;
-	gt->io = io;
-	gemtek_probe(gt);
-	if (gt->io) {
-		if (!request_region(gt->io, 1, "gemtek")) {
-			v4l2_err(v4l2_dev, "I/O port 0x%x already in use.\n", gt->io);
-			return -EBUSY;
-		}
-
-		if (!gemtek_verify(gt, gt->io))
-			v4l2_warn(v4l2_dev, "Card at I/O port 0x%x does not "
-			       "respond properly, check your "
-			       "configuration.\n", gt->io);
-		else
-			v4l2_info(v4l2_dev, "Using I/O port 0x%x.\n", gt->io);
-	} else if (probe) {
-		v4l2_err(v4l2_dev, "Automatic probing failed and no "
-		       "fixed I/O port defined.\n");
-		return -ENODEV;
-	} else {
-		v4l2_err(v4l2_dev, "Automatic probing disabled but no fixed "
-		       "I/O port defined.");
-		return -EINVAL;
-	}
-
-	res = v4l2_device_register(NULL, v4l2_dev);
-	if (res < 0) {
-		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
-		release_region(gt->io, 1);
-		return res;
-	}
-
-	strlcpy(gt->vdev.name, v4l2_dev->name, sizeof(gt->vdev.name));
-	gt->vdev.v4l2_dev = v4l2_dev;
-	gt->vdev.fops = &gemtek_fops;
-	gt->vdev.ioctl_ops = &gemtek_ioctl_ops;
-	gt->vdev.release = video_device_release_empty;
-	video_set_drvdata(&gt->vdev, gt);
-
-	/* Set defaults */
-	gt->lastfreq = GEMTEK_LOWFREQ;
-	gt->bu2614data = 0;
-
-	if (initmute)
-		gemtek_mute(gt);
-
-	if (video_register_device(&gt->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-		v4l2_device_unregister(v4l2_dev);
-		release_region(gt->io, 1);
-		return -EBUSY;
-	}
-
-	return 0;
+	gemtek_driver.probe = probe;
+	return isa_register_driver(&gemtek_driver.driver, GEMTEK_MAX);
 }
 
-/*
- * Module cleanup
- */
 static void __exit gemtek_exit(void)
 {
-	struct gemtek *gt = &gemtek_card;
-	struct v4l2_device *v4l2_dev = &gt->v4l2_dev;
-
-	if (shutdown) {
-		hardmute = 1;	/* Turn off PLL */
-		gemtek_mute(gt);
-	} else {
-		v4l2_info(v4l2_dev, "Module unloaded but card not muted!\n");
-	}
-
-	video_unregister_device(&gt->vdev);
-	v4l2_device_unregister(&gt->v4l2_dev);
-	release_region(gt->io, 1);
+	hardmute = 1;	/* Turn off PLL */
+	isa_unregister_driver(&gemtek_driver.driver);
 }
 
 module_init(gemtek_init);
-- 
1.7.7.3

