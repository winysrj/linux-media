Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.21]:22425 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab0GaOhq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 10:37:46 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2312.sfr.fr (SMTP Server) with ESMTP id 2B6D17000093
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 16:37:44 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (81.148.200-77.rev.gaoland.net [77.200.148.81])
	by msfrf2312.sfr.fr (SMTP Server) with SMTP id A70D3700008F
	for <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 16:37:43 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.200.148.81] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Sat, 31 Jul 2010 16:37:43 +0200
Subject: [PATCH] Nova-S-Plus audio line input
From: lawrence rust <lawrence@softsystem.co.uk>
To: linux-media@vger.kernel.org
Cc: Darron Broad <darron@kewl.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 16:37:42 +0200
Message-ID: <1280587062.1395.37.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

This patch adds audio DMA capture and ALSA mixer elements for the line
input jack of the Hauppauge Nova-S-plus DVB-S PCI card.

I'm using a Hauppauge Nova-S-plus PCI card to watch sat TV and it's been
very robust - thanks to everyone here.  I have one minor niggle - when I
use it with composite video input from an external STB I can't connect
the audio to the line input jack on the card.  So I developed this
patch, originally in late 2008 with lots of feedback and input from
Darron Broad.

The Nova-S-plus has a WM8775 ADC that is currently not detected.  This
patch enables this chip and exports elements for ALSA mixer controls.

I've used this patch with kernels from 2.6.24 to 2.6.35-rc6 and I'm just
a little tired of tweaking it every time a new kernel comes out so I'm
hoping that it can be permanently included.

Signed-off by Lawrence Rust <lawrence (at) softsystem.co.uk>

diff --git a/drivers/media/video/cx88/cx88-alsa.c
b/drivers/media/video/cx88/cx88-alsa.c
index 33082c9..044516b 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -588,6 +588,30 @@ static int snd_cx88_volume_put(struct snd_kcontrol *kcontrol,
 	int changed = 0;
 	u32 old;
 
+    /* If a WM8775 is used for audio input utilise the audio controls */
+    if ( core->board.audio_chip && core->board.audio_chip == V4L2_IDENT_WM8775) {
+        struct v4l2_control client_ctl;
+
+        if ( value->value.integer.value[0] >= value->value.integer.value[1]) {
+            v = value->value.integer.value[0] << 10;
+            b = value->value.integer.value[0] ?
+              (0x8000 * value->value.integer.value[1]) / value->value.integer.value[0] :
+              0x8000;
+        } else {
+            v = value->value.integer.value[1] << 10;
+            b = value->value.integer.value[1] ?
+              0xffff - (0x8000 * value->value.integer.value[0]) / value->value.integer.value[1] :
+              0x8000;
+        }
+        client_ctl.value = v;
+        client_ctl.id = V4L2_CID_AUDIO_VOLUME;
+        call_all(core, core, s_ctrl, &client_ctl);
+
+        client_ctl.value = b;
+        client_ctl.id = V4L2_CID_AUDIO_BALANCE;
+        call_all(core, core, s_ctrl, &client_ctl);
+    }
+
 	left = value->value.integer.value[0] & 0x3f;
 	right = value->value.integer.value[1] & 0x3f;
 	b = right - left;
@@ -601,10 +625,10 @@ static int snd_cx88_volume_put(struct snd_kcontrol *kcontrol,
 	spin_lock_irq(&chip->reg_lock);
 	old = cx_read(AUD_VOL_CTL);
 	if (v != (old & 0x3f)) {
-	    cx_write(AUD_VOL_CTL, (old & ~0x3f) | v);
+        cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, (old & ~0x3f) | v);
 	    changed = 1;
 	}
-	if (cx_read(AUD_BAL_CTL) != b) {
+    if ((cx_read(AUD_BAL_CTL) & 0x7f) != b) {
 	    cx_write(AUD_BAL_CTL, b);
 	    changed = 1;
 	}
@@ -619,7 +643,7 @@ static struct snd_kcontrol_new snd_cx88_volume = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE |
 		  SNDRV_CTL_ELEM_ACCESS_TLV_READ,
-	.name = "Playback Volume",
+	.name = "Tuner Volume",
 	.info = snd_cx88_volume_info,
 	.get = snd_cx88_volume_get,
 	.put = snd_cx88_volume_put,
@@ -650,7 +674,14 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
 	vol = cx_read(AUD_VOL_CTL);
 	if (value->value.integer.value[0] != !(vol & bit)) {
 		vol ^= bit;
-		cx_write(AUD_VOL_CTL, vol);
+        cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, vol);
+        /* If a WM8775 is used for audio input utilise the audio controls */
+        if ( (1<<6) == bit && core->board.audio_chip && core->board.audio_chip == V4L2_IDENT_WM8775) {
+            struct v4l2_control client_ctl;
+            client_ctl.value = 0 == value->value.integer.value[0];
+            client_ctl.id = V4L2_CID_AUDIO_MUTE;
+            call_all(core, core, s_ctrl, &client_ctl);
+        }
 		ret = 1;
 	}
 	spin_unlock_irq(&chip->reg_lock);
@@ -659,7 +690,7 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
 
 static struct snd_kcontrol_new snd_cx88_dac_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Playback Switch",
+	.name = "Audio Out Switch",
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
@@ -668,7 +699,7 @@ static struct snd_kcontrol_new snd_cx88_dac_switch = {
 
 static struct snd_kcontrol_new snd_cx88_source_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Capture Switch",
+	.name = "Tuner Switch",
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index 2918a6e..c7ac0fe 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -962,19 +962,26 @@ static const struct cx88_board cx88_boards[] = {
 	},
 	[CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1] = {
 		.name		= "Hauppauge Nova-S-Plus DVB-S",
-		.tuner_type	= TUNER_ABSENT,
+		.tuner_type	= UNSET, /* BUG: Needed by cx88_i2c_init for WM8775 */
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
+        .audio_chip = V4L2_IDENT_WM8775,
 		.input		= {{
 			.type	= CX88_VMUX_DVB,
 			.vmux	= 0,
+            /* 2: Line-In */
+            .audioroute = 2,
 		},{
 			.type	= CX88_VMUX_COMPOSITE1,
 			.vmux	= 1,
+            /* 2: Line-In */
+            .audioroute = 2,
 		},{
 			.type	= CX88_VMUX_SVIDEO,
 			.vmux	= 2,
+            /* 2: Line-In */
+            .audioroute = 2,
 		}},
 		.mpeg           = CX88_MPEG_DVB,
 	},
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 0fab65c..2c5bd14 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -992,6 +992,32 @@ int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl)
 		ctl->value = c->v.minimum;
 	if (ctl->value > c->v.maximum)
 		ctl->value = c->v.maximum;
+
+	/* If a WM8775 is used for audio input utilise the audio controls */
+	if (core->board.audio_chip &&
+			core->board.audio_chip == V4L2_IDENT_WM8775) {
+		struct v4l2_control client_ctl;
+
+		client_ctl.id = ctl->id;
+		switch (ctl->id) {
+			case V4L2_CID_AUDIO_MUTE:
+				client_ctl.value = ctl->value;
+				break;
+			case V4L2_CID_AUDIO_VOLUME:
+				client_ctl.value = (ctl->value) ?
+					(0x90 + ctl->value) << 8 : 0;
+				break;
+			case V4L2_CID_AUDIO_BALANCE:
+				client_ctl.value = ctl->value << 9;
+				break;
+			default:
+				client_ctl.id = 0;
+				break;
+		}
+		if (client_ctl.id)
+			call_all(core, core, s_ctrl, &client_ctl);
+	}
+
 	mask=c->mask;
 	switch (ctl->id) {
 	case V4L2_CID_AUDIO_BALANCE:
@@ -1537,7 +1563,9 @@ static int radio_queryctrl (struct file *file, void *priv,
 	if (c->id <  V4L2_CID_BASE ||
 		c->id >= V4L2_CID_LASTP1)
 		return -EINVAL;
-	if (c->id == V4L2_CID_AUDIO_MUTE) {
+	if (c->id == V4L2_CID_AUDIO_MUTE ||
+		c->id == V4L2_CID_AUDIO_VOLUME ||
+			c->id == V4L2_CID_AUDIO_BALANCE) {
 		for (i = 0; i < CX8800_CTLS; i++) {
 			if (cx8800_ctls[i].v.id == c->id)
 				break;
diff --git a/drivers/media/video/wm8775.c b/drivers/media/video/wm8775.c
index 5c2ba59..140e54a 100644
--- a/drivers/media/video/wm8775.c
+++ b/drivers/media/video/wm8775.c
@@ -55,6 +55,8 @@ struct wm8775_state {
 	struct v4l2_subdev sd;
 	u8 input;		/* Last selected input (0-0xf) */
 	u8 muted;
+    u16 volume;
+    u16 balance;
 };
 
 static inline struct wm8775_state *to_state(struct v4l2_subdev *sd)
@@ -80,6 +82,27 @@ static int wm8775_write(struct v4l2_subdev *sd, int reg, u16 val)
 	return -1;
 }
 
+static void wm8775_set_audio(struct v4l2_subdev *sd)
+{
+    struct wm8775_state *state = to_state(sd);
+
+    u8 vol_l, vol_r;
+
+    /* normalize ( 65535 to 0 -> 255 to 0 (+24dB to -103dB) ) */
+    vol_l = ((min(65536 - state->balance, 32768) * state->volume) / 32768) >> 8;
+    vol_r = ((min(state->balance, (u16)32768) * state->volume) / 32768) >> 8;
+
+    /* Mute */
+    wm8775_write(sd, R21, 0x0c0);
+
+    wm8775_write(sd, R14, vol_l);
+    wm8775_write(sd, R15, vol_r);
+
+    /* Un-mute */
+    if (!state->muted)
+      wm8775_write(sd, R21, state->input);
+}
+
 static int wm8775_s_routing(struct v4l2_subdev *sd,
 			    u32 input, u32 output, u32 config)
 {
@@ -95,12 +118,7 @@ static int wm8775_s_routing(struct v4l2_subdev *sd,
 		return -EINVAL;
 	}
 	state->input = input;
-	if (state->muted)
-		return 0;
-	wm8775_write(sd, R21, 0x0c0);
-	wm8775_write(sd, R14, 0x1d4);
-	wm8775_write(sd, R15, 0x1d4);
-	wm8775_write(sd, R21, 0x100 + state->input);
+        wm8775_set_audio(sd);
 	return 0;
 }
 
@@ -108,9 +126,23 @@ static int wm8775_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	struct wm8775_state *state = to_state(sd);
 
-	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
-		return -EINVAL;
-	ctrl->value = state->muted;
+    switch (ctrl->id) {
+    case V4L2_CID_AUDIO_MUTE:
+        ctrl->value = state->muted;
+        break;
+
+    case V4L2_CID_AUDIO_VOLUME:
+        ctrl->value = state->volume;
+        break;
+
+    case V4L2_CID_AUDIO_BALANCE:
+        ctrl->value = state->balance;
+        break;
+
+    default:
+        return -EINVAL;
+    }
+
 	return 0;
 }
 
@@ -118,14 +150,24 @@ static int wm8775_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 {
 	struct wm8775_state *state = to_state(sd);
 
-	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
-		return -EINVAL;
-	state->muted = ctrl->value;
-	wm8775_write(sd, R21, 0x0c0);
-	wm8775_write(sd, R14, 0x1d4);
-	wm8775_write(sd, R15, 0x1d4);
-	if (!state->muted)
-		wm8775_write(sd, R21, 0x100 + state->input);
+    switch (ctrl->id) {
+    case V4L2_CID_AUDIO_MUTE:
+        state->muted = ctrl->value;
+        break;
+
+    case V4L2_CID_AUDIO_VOLUME:
+        state->volume = ctrl->value;
+        break;
+
+    case V4L2_CID_AUDIO_BALANCE:
+        state->balance = ctrl->value;
+        break;
+
+    default:
+        return -EINVAL;
+    }
+    wm8775_set_audio(sd);
+
 	return 0;
 }
 
@@ -140,31 +182,71 @@ static int wm8775_log_status(struct v4l2_subdev *sd)
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
 	/* If I remove this, then it can happen that I have no
 	   sound the first time I tune from static to a valid channel.
 	   It's difficult to reproduce and is almost certainly related
 	   to the zero cross detect circuit. */
-	wm8775_write(sd, R21, 0x0c0);
-	wm8775_write(sd, R14, 0x1d4);
-	wm8775_write(sd, R15, 0x1d4);
-	wm8775_write(sd, R21, 0x100 + state->input);
+        wm8775_set_audio(sd);
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
+       }
+};
+
+static int wm8775_query_ctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
+{
+    int i;
+
+    for (i = 0; i < ARRAY_SIZE(wm8775_qctrl); i++)
+        if (qc->id && qc->id == wm8775_qctrl[i].id) {
+            memcpy(qc, &wm8775_qctrl[i], sizeof(*qc));
+            return 0;
+        }
+    return -EINVAL;
+}
+
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops wm8775_core_ops = {
 	.log_status = wm8775_log_status,
 	.g_chip_ident = wm8775_g_chip_ident,
+        .queryctrl = wm8775_query_ctrl,
 	.g_ctrl = wm8775_g_ctrl,
 	.s_ctrl = wm8775_s_ctrl,
 };
@@ -212,36 +294,23 @@ static int wm8775_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(sd, client, &wm8775_ops);
 	state->input = 2;
 	state->muted = 0;
+    state->volume = 0xCF00;
+    state->balance = 0x8000;
 
 	/* Initialize wm8775 */
 
-	/* RESET */
-	wm8775_write(sd, R23, 0x000);
-	/* Disable zero cross detect timeout */
-	wm8775_write(sd, R7, 0x000);
-	/* Left justified, 24-bit mode */
-	wm8775_write(sd, R11, 0x021);
-	/* Master mode, clock ratio 256fs */
-	wm8775_write(sd, R12, 0x102);
-	/* Powered up */
-	wm8775_write(sd, R13, 0x000);
-	/* ADC gain +2.5dB, enable zero cross */
-	wm8775_write(sd, R14, 0x1d4);
-	/* ADC gain +2.5dB, enable zero cross */
-	wm8775_write(sd, R15, 0x1d4);
-	/* ALC Stereo, ALC target level -1dB FS max gain +8dB */
-	wm8775_write(sd, R16, 0x1bf);
-	/* Enable gain control, use zero cross detection,
-	   ALC hold time 42.6 ms */
-	wm8775_write(sd, R17, 0x185);
-	/* ALC gain ramp up delay 34 s, ALC gain ramp down delay 33 ms */
-	wm8775_write(sd, R18, 0x0a2);
-	/* Enable noise gate, threshold -72dBfs */
-	wm8775_write(sd, R19, 0x005);
-	/* Transient window 4ms, lower PGA gain limit -1dB */
-	wm8775_write(sd, R20, 0x07a);
-	/* LRBOTH = 1, use input 2. */
-	wm8775_write(sd, R21, 0x102);
+    wm8775_write(sd, R23, 0x000); /* RESET */
+    wm8775_write(sd, R11, 0x022); /* HPF enable, I2S mode, 24-bit */
+    wm8775_write(sd, R12, 0x102); /* Master mode, clock ratio 256fs */
+    wm8775_write(sd, R13, 0x000); /* Powered up */
+    wm8775_set_audio(sd);         /* set volume/mute */
+#if 0 /* Enable ALC */
+    wm8775_write(sd, R16, 0x1bb); /* ALC stereo, ALC target level -5dB FS, ALC max gain +8dB */
+    wm8775_write(sd, R17, 0x185); /* Enable LC, use zero cross, ALC hold 42.7 ms */
+    wm8775_write(sd, R18, 0x0a2); /* ALC decay time 34 s, ALC attack time 33 ms */
+    wm8775_write(sd, R19, 0x005); /* Enable noise gate, threshold -72dB fs */
+    wm8775_write(sd, R20, 0x0fb); /* Transient window 4ms, ALC min gain -5dB */
+#endif
 	return 0;
 }
 


