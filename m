Return-path: <mchehab@pedra>
Received: from smtp22.services.sfr.fr ([93.17.128.13]:34578 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab0HJHxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Aug 2010 03:53:11 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2216.sfr.fr (SMTP Server) with ESMTP id D65E8700008F
	for <linux-media@vger.kernel.org>; Tue, 10 Aug 2010 09:53:06 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (81.148.200-77.rev.gaoland.net [77.200.148.81])
	by msfrf2216.sfr.fr (SMTP Server) with SMTP id 55E297000082
	for <linux-media@vger.kernel.org>; Tue, 10 Aug 2010 09:53:06 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.200.148.81] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Tue, 10 Aug 2010 09:52:59 +0200
Subject: [PATCH V2] Nova-S-Plus audio line input
From: lawrence rust <lawrence@softsystem.co.uk>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Darron Broad <darron@kewl.org>,
	Andy Walls <awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 09:52:57 +0200
Message-ID: <1281426777.1380.50.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi everyone,

This patch adds audio DMA capture and ALSA mixer elements for the line
input jack of the Hauppauge Nova-S-plus DVB-S PCI card.  The Nova-S-plus
has a WM8775 ADC that is currently not detected.  This patch enables
this chip and exports elements for ALSA mixer controls.

This is an update to the original, addressing points made by Andy Walls
(thanks Andy).  This is a summary of the main changes made:

- Add the macro call_hw() to cx88.h to call a subdev by group ID.

- In wm8775.h define a group ID for the wm8775.

- In cx88-alsa.c replace call_all() with call_hw() (call by group ID) to
pass volume & balance to a wm8775.  At first I thought that caching a
subdev* during init might be more efficient but on reflection this
method is not compatible with current user expectations of hotplug so a
runtime method is better.

- In cx88-video.c replace wm8775 call_all() with call_hw().

- The cx88 ALSA mixer volume control is renamed 'Analog-TV' with
associated mute switch.  cx88 audio output is muted with the switch
'Audio-Out'.

- Preserve the default ALC setup in wm8775.c but add an ALSA mixer
switch 'Line-In ALC' to switch between ALC and manual level control.

- Changes to comments & formatting in wm8775_probe() are reverted.  The
ALC setup is modified slightly to reduce large signal distortion.

Comments, criticism & errata please.

Signed-off by Lawrence Rust <lawrence (at) softsystem.co.uk>

diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 33082c9..95c0e54 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -40,6 +40,7 @@
 #include <sound/control.h>
 #include <sound/initval.h>
 #include <sound/tlv.h>
+#include <media/wm8775.h>
 
 #include "cx88.h"
 #include "cx88-reg.h"
@@ -587,26 +588,47 @@ static int snd_cx88_volume_put(struct snd_kcontrol *kcontrol,
 	int left, right, v, b;
 	int changed = 0;
 	u32 old;
+	struct v4l2_control client_ctl;
+
+	/* Pass volume & balance onto any WM8775 */
+	if ( value->value.integer.value[0] >= value->value.integer.value[1]) {
+		v = value->value.integer.value[0] << 10;
+		b = value->value.integer.value[0] ?
+			(0x8000 * value->value.integer.value[1]) / value->value.integer.value[0] :
+			0x8000;
+	} else {
+		v = value->value.integer.value[1] << 10;
+		b = value->value.integer.value[1] ?
+		0xffff - (0x8000 * value->value.integer.value[0]) / value->value.integer.value[1] :
+		0x8000;
+	}
+	client_ctl.value = v;
+	client_ctl.id = V4L2_CID_AUDIO_VOLUME;
+	call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
+
+	client_ctl.value = b;
+	client_ctl.id = V4L2_CID_AUDIO_BALANCE;
+	call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
 
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
 
@@ -619,7 +641,7 @@ static struct snd_kcontrol_new snd_cx88_volume = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE |
 		  SNDRV_CTL_ELEM_ACCESS_TLV_READ,
-	.name = "Playback Volume",
+	.name = "Analog-TV Volume",
 	.info = snd_cx88_volume_info,
 	.get = snd_cx88_volume_get,
 	.put = snd_cx88_volume_put,
@@ -650,7 +672,14 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
 	vol = cx_read(AUD_VOL_CTL);
 	if (value->value.integer.value[0] != !(vol & bit)) {
 		vol ^= bit;
-		cx_write(AUD_VOL_CTL, vol);
+        	cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, vol);
+		/* Pass mute onto any WM8775 */
+	        if ( (1<<6) == bit) {
+			struct v4l2_control client_ctl;
+			client_ctl.value = 0 == value->value.integer.value[0];
+			client_ctl.id = V4L2_CID_AUDIO_MUTE;
+			call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
+		}
 		ret = 1;
 	}
 	spin_unlock_irq(&chip->reg_lock);
@@ -659,7 +688,7 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
 
 static struct snd_kcontrol_new snd_cx88_dac_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Playback Switch",
+	.name = "Audio-Out Switch",
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
@@ -668,13 +697,49 @@ static struct snd_kcontrol_new snd_cx88_dac_switch = {
 
 static struct snd_kcontrol_new snd_cx88_source_switch = {
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
@@ -831,6 +896,15 @@ static int __devinit cx88_audio_initdev(struct pci_dev *pci,
 	if (err < 0)
 		goto error;
 
+	/* If there's a wm8775 then add a Line-In ALC switch */
+	{ struct v4l2_subdev *sd;
+	list_for_each_entry(sd, &chip->core->v4l2_dev.subdevs, list) {
+		if (WM8775_GID == sd->grp_id) {
+			snd_ctl_add(card, snd_ctl_new1(&snd_cx88_alc_switch, chip));
+			break;
+		}
+	}}
+
 	strcpy (card->driver, "CX88x");
 	sprintf(card->shortname, "Conexant CX%x", pci->device);
 	sprintf(card->longname, "%s at %#llx",
diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index 2918a6e..6d487bf 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -966,15 +966,22 @@ static const struct cx88_board cx88_boards[] = {
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
+		.audio_chip = V4L2_IDENT_WM8775,
 		.input		= {{
 			.type	= CX88_VMUX_DVB,
 			.vmux	= 0,
+			/* 2: Line-In */
+			.audioroute = 2,
 		},{
 			.type	= CX88_VMUX_COMPOSITE1,
 			.vmux	= 1,
+			/* 2: Line-In */
+			.audioroute = 2,
 		},{
 			.type	= CX88_VMUX_SVIDEO,
 			.vmux	= 2,
+			/* 2: Line-In */
+			.audioroute = 2,
 		}},
 		.mpeg           = CX88_MPEG_DVB,
 	},
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 0fab65c..98cbba2 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -41,6 +41,7 @@
 #include "cx88.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/wm8775.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx2388x based TV cards");
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
@@ -979,6 +980,7 @@ int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl)
 	struct cx88_ctrl *c = NULL;
 	u32 value,mask;
 	int i;
+	struct v4l2_control client_ctl;
 
 	for (i = 0; i < CX8800_CTLS; i++) {
 		if (cx8800_ctls[i].v.id == ctl->id) {
@@ -992,6 +994,27 @@ int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl)
 		ctl->value = c->v.minimum;
 	if (ctl->value > c->v.maximum)
 		ctl->value = c->v.maximum;
+
+	/* Pass changes onto any WM8775 */
+	client_ctl.id = ctl->id;
+	switch (ctl->id) {
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
+	}
+	if (client_ctl.id)
+		call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
+
 	mask=c->mask;
 	switch (ctl->id) {
 	case V4L2_CID_AUDIO_BALANCE:
@@ -1537,7 +1560,9 @@ static int radio_queryctrl (struct file *file, void *priv,
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
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index bdb03d3..a77fe3f 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -381,17 +381,19 @@ static inline struct cx88_core *to_core(struct v4l2_device *v4l2_dev)
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
index 5c2ba59..22a5f58 100644
--- a/drivers/media/video/wm8775.c
+++ b/drivers/media/video/wm8775.c
@@ -36,6 +36,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
+#include <media/wm8775.h>
 
 MODULE_DESCRIPTION("wm8775 driver");
 MODULE_AUTHOR("Ulf Eklund, Hans Verkuil");
@@ -51,10 +52,16 @@ enum {
 	TOT_REGS
 };
 
+#define ALC_HOLD 0x85 /* R17: use zero cross detection, ALC hold time 42.6 ms */
+#define ALC_EN 0x100  /* R17: ALC enable */
+
 struct wm8775_state {
 	struct v4l2_subdev sd;
 	u8 input;		/* Last selected input (0-0xf) */
 	u8 muted;
+	u16 volume;
+	u16 balance;
+	u8 alc;
 };
 
 static inline struct wm8775_state *to_state(struct v4l2_subdev *sd)
@@ -80,6 +87,27 @@ static int wm8775_write(struct v4l2_subdev *sd, int reg, u16 val)
 	return -1;
 }
 
+static void wm8775_set_audio(struct v4l2_subdev *sd, int quietly)
+{
+	struct wm8775_state *state = to_state(sd);
+	u8 vol_l, vol_r;
+
+	/* normalize ( 65535 to 0 -> 255 to 0 (+24dB to -103dB) ) */
+	vol_l = (min(65536 - state->balance, 32768) * state->volume) >> 23;
+	vol_r = (min(state->balance, (u16)32768) * state->volume) >> 23;
+
+	/* Mute */
+	if (state->muted || quietly)
+		wm8775_write(sd, R21, 0x0c0 | state->input);
+
+	wm8775_write(sd, R14, vol_l | 0x100); /* 0x100= Left channel ADC zero cross enable */
+	wm8775_write(sd, R15, vol_r | 0x100); /* 0x100= Right channel ADC zero cross enable */
+
+	/* Un-mute */
+	if (!state->muted)
+		wm8775_write(sd, R21, state->input);
+}
+
 static int wm8775_s_routing(struct v4l2_subdev *sd,
 			    u32 input, u32 output, u32 config)
 {
@@ -95,12 +123,7 @@ static int wm8775_s_routing(struct v4l2_subdev *sd,
 		return -EINVAL;
 	}
 	state->input = input;
-	if (state->muted)
-		return 0;
-	wm8775_write(sd, R21, 0x0c0);
-	wm8775_write(sd, R14, 0x1d4);
-	wm8775_write(sd, R15, 0x1d4);
-	wm8775_write(sd, R21, 0x100 + state->input);
+	wm8775_set_audio(sd, 1);
 	return 0;
 }
 
@@ -108,9 +131,27 @@ static int wm8775_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	struct wm8775_state *state = to_state(sd);
 
-	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		ctrl->value = state->muted;
+		break;
+
+	case V4L2_CID_AUDIO_VOLUME:
+		ctrl->value = state->volume;
+		break;
+
+	case V4L2_CID_AUDIO_BALANCE:
+		ctrl->value = state->balance;
+		break;
+
+	case V4L2_CID_AUDIO_LOUDNESS:
+		ctrl->value = state->alc;
+		break;
+
+	default:
 		return -EINVAL;
-	ctrl->value = state->muted;
+	}
+
 	return 0;
 }
 
@@ -118,14 +159,29 @@ static int wm8775_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	struct wm8775_state *state = to_state(sd);
 
-	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		state->muted = 0 != ctrl->value;
+		break;
+
+	case V4L2_CID_AUDIO_VOLUME:
+		state->volume = ctrl->value;
+		break;
+
+	case V4L2_CID_AUDIO_BALANCE:
+		state->balance = ctrl->value;
+		break;
+
+	case V4L2_CID_AUDIO_LOUDNESS:
+		state->alc = 0 != ctrl->value;
+		wm8775_write(sd, R17, (state->alc ? ALC_EN : 0) | ALC_HOLD);
+		break;
+
+	default:
 		return -EINVAL;
-	state->muted = ctrl->value;
-	wm8775_write(sd, R21, 0x0c0);
-	wm8775_write(sd, R14, 0x1d4);
-	wm8775_write(sd, R15, 0x1d4);
-	if (!state->muted)
-		wm8775_write(sd, R21, 0x100 + state->input);
+	}
+	wm8775_set_audio(sd, 0);
+
 	return 0;
 }
 
@@ -140,31 +196,76 @@ static int wm8775_log_status(struct v4l2_subdev *sd)
 {
 	struct wm8775_state *state = to_state(sd);
 
-	v4l2_info(sd, "Input: %d%s\n", state->input,
-			state->muted ? " (muted)" : "");
+        v4l2_info(sd, "Volume: %04x%s Balance: %04x Input: %d\n",
+                state->volume, state->muted ? " (muted)" : "",
+                state->balance, state->input);
 	return 0;
 }
 
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
 
+static struct v4l2_queryctrl wm8775_qctrl[] = {
+       {
+               .id            = V4L2_CID_AUDIO_VOLUME,
+               .name          = "Volume",
+               .minimum       = 0,
+               .maximum       = 65535,
+               .step          = 65535/100,
+               .default_value = 0xCF00, /* 0 dB */
+               .flags         = 0,
+               .type          = V4L2_CTRL_TYPE_INTEGER,
+       }, {
+               .id            = V4L2_CID_AUDIO_MUTE,
+               .name          = "Mute",
+               .minimum       = 0,
+               .maximum       = 1,
+               .step          = 1,
+               .default_value = 1,
+               .flags         = 0,
+               .type          = V4L2_CTRL_TYPE_BOOLEAN,
+       }, {
+               .id            = V4L2_CID_AUDIO_BALANCE,
+               .name          = "Balance",
+               .minimum       = 0,
+               .maximum       = 65535,
+               .step          = 65535/100,
+               .default_value = 32768,
+               .flags         = 0,
+               .type          = V4L2_CTRL_TYPE_INTEGER,
+       }, {
+               .id            = V4L2_CID_AUDIO_LOUDNESS,
+               .name          = "Auto Level Control",
+               .minimum       = 0,
+               .maximum       = 1,
+               .step          = 1,
+               .default_value = 1,
+               .flags         = 0,
+               .type          = V4L2_CTRL_TYPE_BOOLEAN,
+       }
+};
+
+static int wm8775_query_ctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wm8775_qctrl); i++)
+	if (qc->id && qc->id == wm8775_qctrl[i].id) {
+		memcpy(qc, &wm8775_qctrl[i], sizeof(*qc));
+		return 0;
+	}
+	return -EINVAL;
+}
+
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops wm8775_core_ops = {
 	.log_status = wm8775_log_status,
 	.g_chip_ident = wm8775_g_chip_ident,
+	.queryctrl = wm8775_query_ctrl,
 	.g_ctrl = wm8775_g_ctrl,
 	.s_ctrl = wm8775_s_ctrl,
 };
@@ -210,8 +311,12 @@ static int wm8775_probe(struct i2c_client *client,
 		return -ENOMEM;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &wm8775_ops);
+	sd->grp_id = WM8775_GID; /* subdev group id */
 	state->input = 2;
 	state->muted = 0;
+	state->volume = 0xCF00;
+	state->balance = 0x8000;
+	state->alc = !0; /* Enable ALC by default */
 
 	/* Initialize wm8775 */
 
@@ -219,29 +324,25 @@ static int wm8775_probe(struct i2c_client *client,
 	wm8775_write(sd, R23, 0x000);
 	/* Disable zero cross detect timeout */
 	wm8775_write(sd, R7, 0x000);
-	/* Left justified, 24-bit mode */
-	wm8775_write(sd, R11, 0x021);
+	/* HPF enable, I2S mode, 24-bit */
+	wm8775_write(sd, R11, 0x022);
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
+	/* ALC stereo, ALC target level -5dB FS, ALC max gain +8dB */
+	wm8775_write(sd, R16, 0x1bb);
+	/* Set ALC mode and hold time */
+	wm8775_write(sd, R17, (state->alc ? ALC_EN : 0) | ALC_HOLD);
 	/* ALC gain ramp up delay 34 s, ALC gain ramp down delay 33 ms */
 	wm8775_write(sd, R18, 0x0a2);
 	/* Enable noise gate, threshold -72dBfs */
 	wm8775_write(sd, R19, 0x005);
-	/* Transient window 4ms, lower PGA gain limit -1dB */
-	wm8775_write(sd, R20, 0x07a);
-	/* LRBOTH = 1, use input 2. */
-	wm8775_write(sd, R21, 0x102);
+	/* Transient window 4ms, ALC min gain -5dB  */
+	wm8775_write(sd, R20, 0x0fb);
+
+	wm8775_set_audio(sd, 1);      /* set volume/mute/mux */
+
 	return 0;
 }
 
diff --git a/include/media/wm8775.h b/include/media/wm8775.h
index 60739c5..a1c4d41 100644
--- a/include/media/wm8775.h
+++ b/include/media/wm8775.h
@@ -32,4 +32,7 @@
 #define WM8775_AIN3 4
 #define WM8775_AIN4 8
 
+/* subdev group ID */
+#define WM8775_GID (1 << 0)
+
 #endif



