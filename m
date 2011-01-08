Return-path: <mchehab@pedra>
Received: from smtp24.services.sfr.fr ([93.17.128.82]:51493 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1AHSqI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 13:46:08 -0500
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2422.sfr.fr (SMTP Server) with ESMTP id 8914C7000091
	for <linux-media@vger.kernel.org>; Sat,  8 Jan 2011 19:46:05 +0100 (CET)
Received: from smtp-in.softsystem.co.uk (163.247.194-77.rev.gaoland.net [77.194.247.163])
	by msfrf2422.sfr.fr (SMTP Server) with SMTP id 1DAFA7000088
	for <linux-media@vger.kernel.org>; Sat,  8 Jan 2011 19:46:04 +0100 (CET)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.194.247.163] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Sat, 08 Jan 2011 19:45:47 +0100
Subject: Re: [REGRESSION: wm8775, ivtv] Please revert commit
 fcb9757333df37cf4a7feccef7ef6f5300643864
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Eric Sharkey <eric@lisaneric.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	auric <auric@aanet.com.au>, David Gesswein <djg@pdp8online.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
In-Reply-To: <1294496528.2443.85.camel@localhost>
References: <1293843343.7510.23.camel@localhost>
	 <AANLkTimHh4aS-6cp-CsX68WVSF6U+k6gb2mBSwkhd1Xn@mail.gmail.com>
	 <1294094056.10094.41.camel@morgan.silverblock.net>
	 <1294488550.9475.20.camel@gagarin>  <1294496528.2443.85.camel@localhost>
Content-Type: multipart/mixed; boundary="=-x2cAYxiz4yawDouLutgW"
Date: Sat, 08 Jan 2011 19:45:47 +0100
Message-ID: <1294512347.16924.28.camel@gagarin>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--=-x2cAYxiz4yawDouLutgW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Sat, 2011-01-08 at 09:22 -0500, Andy Walls wrote:
> On Sat, 2011-01-08 at 13:09 +0100, Lawrence Rust wrote:
> > On Mon, 2011-01-03 at 17:34 -0500, Andy Walls wrote:
> > > On Sun, 2011-01-02 at 23:00 -0500, Eric Sharkey wrote:
> > > > On Fri, Dec 31, 2010 at 7:55 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > > > > Mauro,
> > > > >
> > > > > Please revert at least the wm8775.c portion of commit
> > > > > fcb9757333df37cf4a7feccef7ef6f5300643864:
> > > > >
> > > > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fcb9757333df37cf4a7feccef7ef6f5300643864
> > > > >
> > > > > It completely trashes baseband line-in audio for PVR-150 cards, and
> > > > > likely does the same for any other ivtv card that has a WM8775 chip.
> > > > 
> > > > Confirmed.  I manually rolled back most of the changes in that commit
> > > > for wm8775.c, leaving all other files alone, and the audio is now
> > > > working correctly for me.  I haven't yet narrowed it down to exactly
> > > > which changes in that file cause the problem.  I'll try and do that
> > > > tomorrow if I have time.
> > 
> > Oh dear, you leave the ranch for 5 minutes to a place without email and
> > all hell breaks loose.  Didn't anyone think that New Year is a time for
> > holidays?
> > 
> > So, for a minor niggle, which is trivially sorted, you pull almost the
> > whole patch leaving the only bit that causes problems for the Nova-S
> > (for which the patch was intended).
> 
> Sorry Lawrence.  I didn't have time to review and test the original
> patch properly when you submitted it.  By the time the regression was
> discovered there was not time for me to fix.  (I did have to do work for
> customers between Christmas and New Year's :( ).

You should try harder to take a decent break.  It works wonders.

Thanks for the info on the PVR-150.  It largely confirmed what I had
surmised - that the two cards disagree about serial audio data format.
Before my patch, the wm8775 was programmed for Philips mode but the
CX25843 on the PVR-150 is setup for Sony I2S mode!!  On the Nova-S, the
cx23883 is setup (in cx88-tvaudio.c) for Philips mode.  The patch
changed the wm8775 to Sony I2S mode because the existing setup gave
noise, indicative of a mismatch.

It is my belief that either the wm8775 datasheet is wrong or there are
inverters on the SCLK lines between the wm8775 and cx25843/23883. It is
also plausible that Conexant have it wrong and both their datasheets are
wrong.

Anyway, I have revised the patch (attached) so that the wm8775 is kept
in Philips mode (to please the PVR-150) and the cx23883 on the Nove-S is
now switched to Sony I2S mode (like the PVR-150) and this works fine.
The change is trivial, just 2 lines, so they're shouldn't be any other
consequences.  However, could this affect any other cards? 

NB I have only tested this patch on my Nova-S, no other.

-- Lawrence

--=-x2cAYxiz4yawDouLutgW
Content-Disposition: attachment; filename="nova-2.6.37.patch"
Content-Type: text/x-patch; name="nova-2.6.37.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 54b7fcd..8ce7d7a 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -40,6 +40,7 @@
 #include <sound/control.h>
 #include <sound/initval.h>
 #include <sound/tlv.h>
+#include <media/wm8775.h>
 
 #include "cx88.h"
 #include "cx88-reg.h"
@@ -586,26 +587,47 @@ static int snd_cx88_volume_put(struct snd_kcontrol *kcontrol,
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
 
@@ -618,7 +640,7 @@ static const struct snd_kcontrol_new snd_cx88_volume = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE |
 		  SNDRV_CTL_ELEM_ACCESS_TLV_READ,
-	.name = "Playback Volume",
+	.name = "Analog-TV Volume",
 	.info = snd_cx88_volume_info,
 	.get = snd_cx88_volume_get,
 	.put = snd_cx88_volume_put,
@@ -649,7 +671,14 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
 	vol = cx_read(AUD_VOL_CTL);
 	if (value->value.integer.value[0] != !(vol & bit)) {
 		vol ^= bit;
-		cx_write(AUD_VOL_CTL, vol);
+        	cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, vol);
+		/* Pass mute onto any WM8775 */
+	        if ( (1<<6) == bit) {
+			struct v4l2_control client_ctl;
+			client_ctl.value = 0 != (vol & bit);
+			client_ctl.id = V4L2_CID_AUDIO_MUTE;
+			call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
+		}
 		ret = 1;
 	}
 	spin_unlock_irq(&chip->reg_lock);
@@ -658,7 +687,7 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
 
 static const struct snd_kcontrol_new snd_cx88_dac_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-	.name = "Playback Switch",
+	.name = "Audio-Out Switch",
 	.info = snd_ctl_boolean_mono_info,
 	.get = snd_cx88_switch_get,
 	.put = snd_cx88_switch_put,
@@ -667,13 +696,49 @@ static const struct snd_kcontrol_new snd_cx88_dac_switch = {
 
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
@@ -830,6 +895,15 @@ static int __devinit cx88_audio_initdev(struct pci_dev *pci,
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
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 19c64a7..bb16bff 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -41,6 +41,7 @@
 #include "cx88.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/wm8775.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx2388x based TV cards");
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
@@ -978,6 +979,7 @@ int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl)
 	const struct cx88_ctrl *c = NULL;
 	u32 value,mask;
 	int i;
+	struct v4l2_control client_ctl;
 
 	for (i = 0; i < CX8800_CTLS; i++) {
 		if (cx8800_ctls[i].v.id == ctl->id) {
@@ -991,6 +993,27 @@ int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl)
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
index c9981e7..e8c732e 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -398,17 +398,19 @@ static inline struct cx88_core *to_core(struct v4l2_device *v4l2_dev)
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
 
--- a/drivers/media/video/wm8775.c	2011-01-05 01:50:19.000000000 +0100
+++ b/drivers/media/video/wm8775.c	2011-01-08 18:24:25.000000000 +0100
@@ -35,6 +35,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
+#include <media/wm8775.h>
 
 MODULE_DESCRIPTION("wm8775 driver");
 MODULE_AUTHOR("Ulf Eklund, Hans Verkuil");
@@ -50,10 +51,16 @@
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
 
@@ -85,6 +92,30 @@
 	return -1;
 }
 
+static void wm8775_set_audio(struct v4l2_subdev *sd, int quietly)
+{
+	struct wm8775_state *state = to_state(sd);
+	u8 vol_l, vol_r;
+        int muted = 0 != state->mute->val;
+        u16 volume = (u16)state->vol->val;
+        u16 balance = (u16)state->bal->val;
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
@@ -102,25 +133,26 @@
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
@@ -144,16 +176,7 @@
 
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
 
@@ -203,6 +226,7 @@
 {
 	struct wm8775_state *state;
 	struct v4l2_subdev *sd;
+	int err;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
@@ -216,15 +240,21 @@
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
@@ -236,29 +266,25 @@
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
+	/* ALC stereo, ALC target level -5dB FS, ALC max gain +8dB */
+	wm8775_write(sd, R16, 0x1bb);
+	/* Set ALC mode and hold time */
+	wm8775_write(sd, R17, (state->loud->val ? ALC_EN : 0) | ALC_HOLD);
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
--- a/drivers/media/video/cx88/cx88-tvaudio.c	2011-01-05 01:50:19.000000000 +0100
+++ b/drivers/media/video/cx88/cx88-tvaudio.c	2011-01-08 18:21:49.000000000 +0100
@@ -786,8 +786,9 @@
 		break;
 	case WW_I2SADC:
 		set_audio_start(core, 0x01);
-		/* Slave/Philips/Autobaud */
-		cx_write(AUD_I2SINPUTCNTL, 0);
+		/* Slave/Philips/Autobaud
+		 * NB on Nova-S bit1 NPhilipsSony appears to be inverted; 0= Sony, 1=Philips */
+		cx_write(AUD_I2SINPUTCNTL, 2);
 		/* Switch to "I2S ADC mode" */
 		cx_write(AUD_I2SCNTL, 0x1);
 		set_audio_finish(core, EN_I2SIN_ENABLE);

--=-x2cAYxiz4yawDouLutgW--


