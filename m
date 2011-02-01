Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:23257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1BAPui (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Feb 2011 10:50:38 -0500
Message-ID: <4D482B93.7010602@redhat.com>
Date: Tue, 01 Feb 2011 13:49:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Lawrence Rust <lawrence@softsystem.co.uk>
CC: Andy Walls <awalls@md.metrocast.net>,
	Eric Sharkey <eric@lisaneric.org>, auric <auric@aanet.com.au>,
	David Gesswein <djg@pdp8online.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
Subject: Re: [REGRESSION: wm8775, ivtv] Please revert commit fcb9757333df37cf4a7feccef7ef6f5300643864
References: <1293843343.7510.23.camel@localhost>	 <AANLkTimHh4aS-6cp-CsX68WVSF6U+k6gb2mBSwkhd1Xn@mail.gmail.com>	 <1294094056.10094.41.camel@morgan.silverblock.net>	 <1294488550.9475.20.camel@gagarin>  <1294496528.2443.85.camel@localhost> <1294512347.16924.28.camel@gagarin>
In-Reply-To: <1294512347.16924.28.camel@gagarin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Lawrence,

Em 08-01-2011 16:45, Lawrence Rust escreveu:
> Thanks for the info on the PVR-150.  It largely confirmed what I had
> surmised - that the two cards disagree about serial audio data format.
> Before my patch, the wm8775 was programmed for Philips mode but the
> CX25843 on the PVR-150 is setup for Sony I2S mode!!  On the Nova-S, the
> cx23883 is setup (in cx88-tvaudio.c) for Philips mode.  The patch
> changed the wm8775 to Sony I2S mode because the existing setup gave
> noise, indicative of a mismatch.
> 
> It is my belief that either the wm8775 datasheet is wrong or there are
> inverters on the SCLK lines between the wm8775 and cx25843/23883. It is
> also plausible that Conexant have it wrong and both their datasheets are
> wrong.
> 
> Anyway, I have revised the patch (attached) so that the wm8775 is kept
> in Philips mode (to please the PVR-150) and the cx23883 on the Nove-S is
> now switched to Sony I2S mode (like the PVR-150) and this works fine.
> The change is trivial, just 2 lines, so they're shouldn't be any other
> consequences.  However, could this affect any other cards? 
> 
> NB I have only tested this patch on my Nova-S, no other.

As it was pointed, your patch affects other boards with wm8775. In order
to avoid it, you need to use platform_data to pass nova_s specific parameters,
and be sure that other boards won't be affected by your changes.

As you might not be able to see how this should be written, I modified your
patch in a way that, hopefully, it won't affect PVR-150. Please test.

Please notice that I don't have any board with wm8775 handy, so it is 
compiled-only.

If this patch doesn't break PVR-150 or Nova-S, then I think we can merge
it.

There are however two issues:
	1) I don't think it is a good idea to keep the I2C group for wm8775 inside
the wm8775 header. Instead, we should move it to some place were people can look on it
to avoid duplicated groups. We may instead just get rid of it, as I added tests for
wm8775 on all places. So, only if wm8775 is used, the i2c subdev commands will be
called.
	2) I just added one platform_data info that indicates if the device is a
nova_s or not. I did it just because I was lazy enough to not go through wm8775
datasheet and add parameters for the parameters that are different. The better
is to split it into some more parameters.

If it works for you, please add your Signed-off-by:. 

Andy, 
please test if this don't break ivtv. If it breaks, please help us to fix,
as only you noticed an issue on the previous versions.

-

From: Lawrence Rust <lawrence@softsystem.co.uk>	

This patch adds audio DMA capture and ALSA mixer elements for the line
input jack of the Hauppauge Nova-S-plus DVB-S PCI card.  The Nova-S-plus
has a WM8775 ADC that is currently not detected.  This patch enables
this chip and exports volume, balance mute and ALC elements for ALSA
mixer controls.

[mchehab@redhat.com: Changed the patch to only talk with wm8775 if board info says so. Also, added platform_data support, to avoid changing the behaviour for other boards, and fixed CodingStyle]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 54b7fcd..a2d688e 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -40,6 +40,7 @@
 #include <sound/control.h>
 #include <sound/initval.h>
 #include <sound/tlv.h>
+#include <media/wm8775.h>
 
 #include "cx88.h"
 #include "cx88-reg.h"
@@ -577,6 +578,35 @@ static int snd_cx88_volume_get(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
+static void snd_cx88_wm8775_volume_put(struct snd_kcontrol *kcontrol,
+			       struct snd_ctl_elem_value *value)
+{
+	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
+	struct cx88_core *core = chip->core;
+	struct v4l2_control client_ctl;
+	int left = value->value.integer.value[0];
+	int right = value->value.integer.value[1];
+	int v, b;
+
+	memset(&client_ctl, 0, sizeof(client_ctl));
+
+	/* Pass volume & balance onto any WM8775 */
+	if (left >= right) {
+		v = left << 10;
+		b = left ? (0x8000 * right) / left : 0x8000;
+	} else {
+		v = right << 10;
+		b = right ? 0xffff - (0x8000 * left) / right : 0x8000;
+	}
+	client_ctl.value = v;
+	client_ctl.id = V4L2_CID_AUDIO_VOLUME;
+	call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
+
+	client_ctl.value = b;
+	client_ctl.id = V4L2_CID_AUDIO_BALANCE;
+	call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
+}
+
 /* OK - TODO: test it */
 static int snd_cx88_volume_put(struct snd_kcontrol *kcontrol,
 			       struct snd_ctl_elem_value *value)
@@ -587,25 +617,28 @@ static int snd_cx88_volume_put(struct snd_kcontrol *kcontrol,
 	int changed = 0;
 	u32 old;
 
+	if (core->board.audio_chip == V4L2_IDENT_WM8775)
+		snd_cx88_wm8775_volume_put(kcontrol, value);
+
 	left = value->value.integer.value[0] & 0x3f;
 	right = value->value.integer.value[1] & 0x3f;
 	b = right - left;
 	if (b < 0) {
-	    v = 0x3f - left;
-	    b = (-b) | 0x40;
+		v = 0x3f - left;
+		b = (-b) | 0x40;
 	} else {
-	    v = 0x3f - right;
+		v = 0x3f - right;
 	}
 	/* Do we really know this will always be called with IRQs on? */
 	spin_lock_irq(&chip->reg_lock);
 	old = cx_read(AUD_VOL_CTL);
 	if (v != (old & 0x3f)) {
-	    cx_write(AUD_VOL_CTL, (old & ~0x3f) | v);
-	    changed = 1;
+		cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, (old & ~0x3f) | v);
+		changed = 1;
 	}
-	if (cx_read(AUD_BAL_CTL) != b) {
-	    cx_write(AUD_BAL_CTL, b);
-	    changed = 1;
+	if ((cx_read(AUD_BAL_CTL) & 0x7f) != b) {
+		cx_write(AUD_BAL_CTL, b);
+		changed = 1;
 	}
 	spin_unlock_irq(&chip->reg_lock);
 
@@ -618,7 +651,7 @@ static const struct snd_kcontrol_new snd_cx88_volume = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE |
 		  SNDRV_CTL_ELEM_ACCESS_TLV_READ,
-	.name = "Playback Volume",
+	.name = "Analog-TV Volume",
 	.info = snd_cx88_volume_info,
 	.get = snd_cx88_volume_get,
 	.put = snd_cx88_volume_put,
@@ -649,7 +682,17 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
 	vol = cx_read(AUD_VOL_CTL);
 	if (value->value.integer.value[0] != !(vol & bit)) {
 		vol ^= bit;
-		cx_write(AUD_VOL_CTL, vol);
+		cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, vol);
+		/* Pass mute onto any WM8775 */
+		if ((core->board.audio_chip == V4L2_IDENT_WM8775) &&
+		    ((1<<6) == bit)) {
+			struct v4l2_control client_ctl;
+
+			memset(&client_ctl, 0, sizeof(client_ctl));
+			client_ctl.value = 0 != (vol & bit);
+			client_ctl.id = V4L2_CID_AUDIO_MUTE;
+			call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
+		}
 		ret = 1;
 	}
 	spin_unlock_irq(&chip->reg_lock);
@@ -658,7 +701,7 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
 
 static const struct snd_kcontrol_new snd_cx88_dac_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Playback Switch",
+	.name = "Audio-Out Switch",
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
@@ -667,13 +710,51 @@ static const struct snd_kcontrol_new snd_cx88_dac_switch = {
 
 static const struct snd_kcontrol_new snd_cx88_source_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Capture Switch",
+	.name = "Analog-TV Switch",
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
 	.private_value = (1<<6),
 };
 
+static int snd_cx88_alc_get(struct snd_kcontrol *kcontrol,
+			       struct snd_ctl_elem_value *value)
+{
+	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
+	struct cx88_core *core = chip->core;
+	struct v4l2_control client_ctl;
+
+	memset(&client_ctl, 0, sizeof(client_ctl));
+	client_ctl.id = V4L2_CID_AUDIO_LOUDNESS;
+	call_hw(core, WM8775_GID, core, g_ctrl, &client_ctl);
+	value->value.integer.value[0] = client_ctl.value ? 1 : 0;
+
+	return 0;
+}
+
+static int snd_cx88_alc_put(struct snd_kcontrol *kcontrol,
+				       struct snd_ctl_elem_value *value)
+{
+	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
+	struct cx88_core *core = chip->core;
+	struct v4l2_control client_ctl;
+
+	memset(&client_ctl, 0, sizeof(client_ctl));
+	client_ctl.value = 0 != value->value.integer.value[0];
+	client_ctl.id = V4L2_CID_AUDIO_LOUDNESS;
+	call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
+
+	return 0;
+}
+
+static struct snd_kcontrol_new snd_cx88_alc_switch = {
+	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name = "Line-In ALC Switch",
+	.info = snd_ctl_boolean_mono_info,
+	.get = snd_cx88_alc_get,
+	.put = snd_cx88_alc_put,
+};
+
 /****************************************************************************
 			Basic Flow for Sound Devices
  ****************************************************************************/
@@ -724,7 +805,8 @@ static void snd_cx88_dev_free(struct snd_card * card)
 static int devno;
 static int __devinit snd_cx88_create(struct snd_card *card,
 				     struct pci_dev *pci,
-				     snd_cx88_card_t **rchip)
+				     snd_cx88_card_t **rchip,
+				     struct cx88_core **core_ptr)
 {
 	snd_cx88_card_t   *chip;
 	struct cx88_core  *core;
@@ -750,7 +832,7 @@ static int __devinit snd_cx88_create(struct snd_card *card,
 	if (!pci_dma_supported(pci,DMA_BIT_MASK(32))) {
 		dprintk(0, "%s/1: Oops: no 32bit PCI DMA ???\n",core->name);
 		err = -EIO;
-		cx88_core_put(core,pci);
+		cx88_core_put(core, pci);
 		return err;
 	}
 
@@ -786,6 +868,7 @@ static int __devinit snd_cx88_create(struct snd_card *card,
 	snd_card_set_dev(card, &pci->dev);
 
 	*rchip = chip;
+	*core_ptr = core;
 
 	return 0;
 }
@@ -795,6 +878,7 @@ static int __devinit cx88_audio_initdev(struct pci_dev *pci,
 {
 	struct snd_card  *card;
 	snd_cx88_card_t  *chip;
+	struct cx88_core *core;
 	int              err;
 
 	if (devno >= SNDRV_CARDS)
@@ -812,7 +896,7 @@ static int __devinit cx88_audio_initdev(struct pci_dev *pci,
 
 	card->private_free = snd_cx88_dev_free;
 
-	err = snd_cx88_create(card, pci, &chip);
+	err = snd_cx88_create(card, pci, &chip, &core);
 	if (err < 0)
 		goto error;
 
@@ -830,6 +914,10 @@ static int __devinit cx88_audio_initdev(struct pci_dev *pci,
 	if (err < 0)
 		goto error;
 
+	/* If there's a wm8775 then add a Line-In ALC switch */
+	if (core->board.audio_chip == V4L2_IDENT_WM8775)
+		snd_ctl_add(card, snd_ctl_new1(&snd_cx88_alc_switch, chip));
+
 	strcpy (card->driver, "CX88x");
 	sprintf(card->shortname, "Conexant CX%x", pci->device);
 	sprintf(card->longname, "%s at %#llx",
diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index 4e6ee55..6ccbb9c 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -970,7 +970,8 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.audio_chip = V4L2_IDENT_WM8775,
+		.audio_chip	= V4L2_IDENT_WM8775,
+		.i2sinputcntl   = 2,
 		.input		= {{
 			.type	= CX88_VMUX_DVB,
 			.vmux	= 0,
diff --git a/drivers/media/video/cx88/cx88-tvaudio.c b/drivers/media/video/cx88/cx88-tvaudio.c
index 08220de..770ec05 100644
--- a/drivers/media/video/cx88/cx88-tvaudio.c
+++ b/drivers/media/video/cx88/cx88-tvaudio.c
@@ -786,8 +786,12 @@ void cx88_set_tvaudio(struct cx88_core *core)
 		break;
 	case WW_I2SADC:
 		set_audio_start(core, 0x01);
-		/* Slave/Philips/Autobaud */
-		cx_write(AUD_I2SINPUTCNTL, 0);
+		/*
+		 * Slave/Philips/Autobaud
+		 * NB on Nova-S bit1 NPhilipsSony appears to be inverted:
+		 *	0= Sony, 1=Philips
+		 */
+		cx_write(AUD_I2SINPUTCNTL, core->board.i2sinputcntl);
 		/* Switch to "I2S ADC mode" */
 		cx_write(AUD_I2SCNTL, 0x1);
 		set_audio_finish(core, EN_I2SIN_ENABLE);
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 508dabb..0f0aa96 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -40,6 +40,7 @@
 #include "cx88.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/wm8775.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx2388x based TV cards");
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
@@ -989,6 +990,32 @@ int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl)
 		ctl->value = c->v.minimum;
 	if (ctl->value > c->v.maximum)
 		ctl->value = c->v.maximum;
+
+	/* Pass changes onto any WM8775 */
+	if (core->board.audio_chip == V4L2_IDENT_WM8775) {
+		struct v4l2_control client_ctl;
+		memset(&client_ctl, 0, sizeof(client_ctl));
+		client_ctl.id = ctl->id;
+
+		switch (ctl->id) {
+		case V4L2_CID_AUDIO_MUTE:
+			client_ctl.value = ctl->value;
+			break;
+		case V4L2_CID_AUDIO_VOLUME:
+			client_ctl.value = (ctl->value) ?
+				(0x90 + ctl->value) << 8 : 0;
+			break;
+		case V4L2_CID_AUDIO_BALANCE:
+			client_ctl.value = ctl->value << 9;
+			break;
+		default:
+			client_ctl.id = 0;
+			break;
+		}
+		if (client_ctl.id)
+			call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
+	}
+
 	mask=c->mask;
 	switch (ctl->id) {
 	case V4L2_CID_AUDIO_BALANCE:
@@ -1526,7 +1553,9 @@ static int radio_queryctrl (struct file *file, void *priv,
 	if (c->id <  V4L2_CID_BASE ||
 		c->id >= V4L2_CID_LASTP1)
 		return -EINVAL;
-	if (c->id == V4L2_CID_AUDIO_MUTE) {
+	if (c->id == V4L2_CID_AUDIO_MUTE ||
+		c->id == V4L2_CID_AUDIO_VOLUME ||
+		c->id == V4L2_CID_AUDIO_BALANCE) {
 		for (i = 0; i < CX8800_CTLS; i++) {
 			if (cx8800_ctls[i].v.id == c->id)
 				break;
@@ -1856,9 +1885,21 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 
 	/* load and configure helper modules */
 
-	if (core->board.audio_chip == V4L2_IDENT_WM8775)
-		v4l2_i2c_new_subdev(&core->v4l2_dev, &core->i2c_adap,
-				"wm8775", 0x36 >> 1, NULL);
+	if (core->board.audio_chip == V4L2_IDENT_WM8775) {
+		struct i2c_board_info wm8775_info = {
+			.type = "wm8775",
+			.addr = 0x36 >> 1,
+			.platform_data = &core->wm8775_data,
+		};
+
+		if (core->boardnr == CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1)
+			core->wm8775_data.is_nova_s = true;
+		else
+			core->wm8775_data.is_nova_s = false;
+
+		v4l2_i2c_new_subdev_board(&core->v4l2_dev, &core->i2c_adap,
+				&wm8775_info, NULL);
+	}
 
 	if (core->board.audio_chip == V4L2_IDENT_TVAUDIO) {
 		/* This probes for a tda9874 as is used on some
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index c9981e7..13bbe95 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -33,6 +33,7 @@
 #include <media/cx2341x.h>
 #include <media/videobuf-dvb.h>
 #include <media/ir-kbd-i2c.h>
+#include <media/wm8775.h>
 
 #include "btcx-risc.h"
 #include "cx88-reg.h"
@@ -273,6 +274,9 @@ struct cx88_board {
 	enum cx88_board_type    mpeg;
 	unsigned int            audio_chip;
 	int			num_frontends;
+
+	/* Used for I2S devices */
+	int			i2sinputcntl;
 };
 
 struct cx88_subid {
@@ -379,6 +383,7 @@ struct cx88_core {
 
 	/* I2C remote data */
 	struct IR_i2c_init_data    init_data;
+	struct wm8775_platform_data wm8775_data;
 
 	struct mutex               lock;
 	/* various v4l controls */
@@ -398,17 +403,19 @@ static inline struct cx88_core *to_core(struct v4l2_device *v4l2_dev)
 	return container_of(v4l2_dev, struct cx88_core, v4l2_dev);
 }
 
-#define call_all(core, o, f, args...) 				\
+#define call_hw(core, grpid, o, f, args...) \
 	do {							\
 		if (!core->i2c_rc) {				\
 			if (core->gate_ctrl)			\
 				core->gate_ctrl(core, 1);	\
-			v4l2_device_call_all(&core->v4l2_dev, 0, o, f, ##args); \
+			v4l2_device_call_all(&core->v4l2_dev, grpid, o, f, ##args); \
 			if (core->gate_ctrl)			\
 				core->gate_ctrl(core, 0);	\
 		}						\
 	} while (0)
 
+#define call_all(core, o, f, args...) call_hw(core, 0, o, f, ##args)
+
 struct cx8800_dev;
 struct cx8802_dev;
 
diff --git a/drivers/media/video/wm8775.c b/drivers/media/video/wm8775.c
index fe8ef64..8674986 100644
--- a/drivers/media/video/wm8775.c
+++ b/drivers/media/video/wm8775.c
@@ -35,6 +35,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
+#include <media/wm8775.h>
 
 MODULE_DESCRIPTION("wm8775 driver");
 MODULE_AUTHOR("Ulf Eklund, Hans Verkuil");
@@ -50,10 +51,16 @@ enum {
 	TOT_REGS
 };
 
+#define ALC_HOLD 0x85 /* R17: use zero cross detection, ALC hold time 42.6 ms */
+#define ALC_EN 0x100  /* R17: ALC enable */
+
 struct wm8775_state {
 	struct v4l2_subdev sd;
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_ctrl *mute;
+	struct v4l2_ctrl *vol;
+	struct v4l2_ctrl *bal;
+	struct v4l2_ctrl *loud;
 	u8 input;		/* Last selected input (0-0xf) */
 };
 
@@ -85,6 +92,30 @@ static int wm8775_write(struct v4l2_subdev *sd, int reg, u16 val)
 	return -1;
 }
 
+static void wm8775_set_audio(struct v4l2_subdev *sd, int quietly)
+{
+	struct wm8775_state *state = to_state(sd);
+	u8 vol_l, vol_r;
+	int muted = 0 != state->mute->val;
+	u16 volume = (u16)state->vol->val;
+	u16 balance = (u16)state->bal->val;
+
+	/* normalize ( 65535 to 0 -> 255 to 0 (+24dB to -103dB) ) */
+	vol_l = (min(65536 - balance, 32768) * volume) >> 23;
+	vol_r = (min(balance, (u16)32768) * volume) >> 23;
+
+	/* Mute */
+	if (muted || quietly)
+		wm8775_write(sd, R21, 0x0c0 | state->input);
+
+	wm8775_write(sd, R14, vol_l | 0x100); /* 0x100= Left channel ADC zero cross enable */
+	wm8775_write(sd, R15, vol_r | 0x100); /* 0x100= Right channel ADC zero cross enable */
+
+	/* Un-mute */
+	if (!muted)
+		wm8775_write(sd, R21, state->input);
+}
+
 static int wm8775_s_routing(struct v4l2_subdev *sd,
 			    u32 input, u32 output, u32 config)
 {
@@ -102,25 +133,26 @@ static int wm8775_s_routing(struct v4l2_subdev *sd,
 	state->input = input;
 	if (!v4l2_ctrl_g_ctrl(state->mute))
 		return 0;
-	wm8775_write(sd, R21, 0x0c0);
-	wm8775_write(sd, R14, 0x1d4);
-	wm8775_write(sd, R15, 0x1d4);
-	wm8775_write(sd, R21, 0x100 + state->input);
+	if (!v4l2_ctrl_g_ctrl(state->vol))
+		return 0;
+	if (!v4l2_ctrl_g_ctrl(state->bal))
+		return 0;
+	wm8775_set_audio(sd, 1);
 	return 0;
 }
 
 static int wm8775_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
-	struct wm8775_state *state = to_state(sd);
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		wm8775_write(sd, R21, 0x0c0);
-		wm8775_write(sd, R14, 0x1d4);
-		wm8775_write(sd, R15, 0x1d4);
-		if (!ctrl->val)
-			wm8775_write(sd, R21, 0x100 + state->input);
+	case V4L2_CID_AUDIO_VOLUME:
+	case V4L2_CID_AUDIO_BALANCE:
+		wm8775_set_audio(sd, 0);
+		return 0;
+	case V4L2_CID_AUDIO_LOUDNESS:
+		wm8775_write(sd, R17, (ctrl->val ? ALC_EN : 0) | ALC_HOLD);
 		return 0;
 	}
 	return -EINVAL;
@@ -144,16 +176,7 @@ static int wm8775_log_status(struct v4l2_subdev *sd)
 
 static int wm8775_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *freq)
 {
-	struct wm8775_state *state = to_state(sd);
-
-	/* If I remove this, then it can happen that I have no
-	   sound the first time I tune from static to a valid channel.
-	   It's difficult to reproduce and is almost certainly related
-	   to the zero cross detect circuit. */
-	wm8775_write(sd, R21, 0x0c0);
-	wm8775_write(sd, R14, 0x1d4);
-	wm8775_write(sd, R15, 0x1d4);
-	wm8775_write(sd, R21, 0x100 + state->input);
+	wm8775_set_audio(sd, 0);
 	return 0;
 }
 
@@ -203,6 +226,13 @@ static int wm8775_probe(struct i2c_client *client,
 {
 	struct wm8775_state *state;
 	struct v4l2_subdev *sd;
+	int err;
+	bool is_nova_s = false;
+
+	if (client->dev.platform_data) {
+		struct wm8775_platform_data *data = client->dev.platform_data;
+		is_nova_s = data->is_nova_s;
+	}
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
@@ -216,15 +246,21 @@ static int wm8775_probe(struct i2c_client *client,
 		return -ENOMEM;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &wm8775_ops);
+	sd->grp_id = WM8775_GID; /* subdev group id */
 	state->input = 2;
 
-	v4l2_ctrl_handler_init(&state->hdl, 1);
+	v4l2_ctrl_handler_init(&state->hdl, 4);
 	state->mute = v4l2_ctrl_new_std(&state->hdl, &wm8775_ctrl_ops,
 			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	state->vol = v4l2_ctrl_new_std(&state->hdl, &wm8775_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, 0, 65535, (65535+99)/100, 0xCF00); /* 0dB*/
+	state->bal = v4l2_ctrl_new_std(&state->hdl, &wm8775_ctrl_ops,
+			V4L2_CID_AUDIO_BALANCE, 0, 65535, (65535+99)/100, 32768);
+	state->loud = v4l2_ctrl_new_std(&state->hdl, &wm8775_ctrl_ops,
+			V4L2_CID_AUDIO_LOUDNESS, 0, 1, 1, 1);
 	sd->ctrl_handler = &state->hdl;
-	if (state->hdl.error) {
-		int err = state->hdl.error;
-
+	err = state->hdl.error;
+	if (err) {
 		v4l2_ctrl_handler_free(&state->hdl);
 		kfree(state);
 		return err;
@@ -236,29 +272,44 @@ static int wm8775_probe(struct i2c_client *client,
 	wm8775_write(sd, R23, 0x000);
 	/* Disable zero cross detect timeout */
 	wm8775_write(sd, R7, 0x000);
-	/* Left justified, 24-bit mode */
+	/* HPF enable, left justified, 24-bit (Philips) mode */
 	wm8775_write(sd, R11, 0x021);
 	/* Master mode, clock ratio 256fs */
 	wm8775_write(sd, R12, 0x102);
 	/* Powered up */
 	wm8775_write(sd, R13, 0x000);
-	/* ADC gain +2.5dB, enable zero cross */
-	wm8775_write(sd, R14, 0x1d4);
-	/* ADC gain +2.5dB, enable zero cross */
-	wm8775_write(sd, R15, 0x1d4);
-	/* ALC Stereo, ALC target level -1dB FS max gain +8dB */
-	wm8775_write(sd, R16, 0x1bf);
-	/* Enable gain control, use zero cross detection,
-	   ALC hold time 42.6 ms */
-	wm8775_write(sd, R17, 0x185);
+
+	if (!is_nova_s) {
+		/* ADC gain +2.5dB, enable zero cross */
+		wm8775_write(sd, R14, 0x1d4);
+		/* ADC gain +2.5dB, enable zero cross */
+		wm8775_write(sd, R15, 0x1d4);
+		/* ALC Stereo, ALC target level -1dB FS max gain +8dB */
+		wm8775_write(sd, R16, 0x1bf);
+		/* Enable gain control, use zero cross detection,
+		   ALC hold time 42.6 ms */
+		wm8775_write(sd, R17, 0x185);
+	} else {
+		/* ALC stereo, ALC target level -5dB FS, ALC max gain +8dB */
+		wm8775_write(sd, R16, 0x1bb);
+		/* Set ALC mode and hold time */
+		wm8775_write(sd, R17, (state->loud->val ? ALC_EN : 0) | ALC_HOLD);
+	}
 	/* ALC gain ramp up delay 34 s, ALC gain ramp down delay 33 ms */
 	wm8775_write(sd, R18, 0x0a2);
 	/* Enable noise gate, threshold -72dBfs */
 	wm8775_write(sd, R19, 0x005);
-	/* Transient window 4ms, lower PGA gain limit -1dB */
-	wm8775_write(sd, R20, 0x07a);
-	/* LRBOTH = 1, use input 2. */
-	wm8775_write(sd, R21, 0x102);
+	if (!is_nova_s) {
+		/* Transient window 4ms, lower PGA gain limit -1dB */
+		wm8775_write(sd, R20, 0x07a);
+		/* LRBOTH = 1, use input 2. */
+		wm8775_write(sd, R21, 0x102);
+	} else {
+		/* Transient window 4ms, ALC min gain -5dB  */
+		wm8775_write(sd, R20, 0x0fb);
+
+		wm8775_set_audio(sd, 1);      /* set volume/mute/mux */
+	}
 	return 0;
 }
 
diff --git a/drivers/staging/vme/bridges/Module.symvers b/drivers/staging/vme/bridges/Module.symvers
deleted file mode 100644
index e69de29..0000000
diff --git a/include/media/wm8775.h b/include/media/wm8775.h
index 60739c5..fe6ccd1 100644
--- a/include/media/wm8775.h
+++ b/include/media/wm8775.h
@@ -32,4 +32,20 @@
 #define WM8775_AIN3 4
 #define WM8775_AIN4 8
 
+/*
+ * subdev group ID
+ * FIXME: This is not a good place for I2C group ID's.
+ * We should move it to another place, to be sure that no
+ * conflicts between different device types will ever happen
+ */
+#define WM8775_GID (1 << 0)
+
+struct wm8775_platform_data {
+	/*
+	 * FIXME: Instead, we should parametrize the params
+	 * that need different settings between ivtv and Nova-S
+	 */
+	bool is_nova_s;
+};
+
 #endif

