Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp24.services.sfr.fr ([93.17.128.81]:20002 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab0HHLbC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Aug 2010 07:31:02 -0400
Received: from smtp24.services.sfr.fr (msfrf2402 [10.18.29.16])
	by msfrf2405.sfr.fr (SMTP Server) with ESMTP id B0ECB700011E
	for <linux-media@vger.kernel.org>; Sun,  8 Aug 2010 13:23:55 +0200 (CEST)
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2402.sfr.fr (SMTP Server) with ESMTP id 37EA87000086
	for <linux-media@vger.kernel.org>; Sun,  8 Aug 2010 13:20:53 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (81.148.200-77.rev.gaoland.net [77.200.148.81])
	by msfrf2402.sfr.fr (SMTP Server) with SMTP id A03507000083
	for <linux-media@vger.kernel.org>; Sun,  8 Aug 2010 13:20:52 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.200.148.81] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Sun, 08 Aug 2010 13:20:50 +0200
Subject: Re: [PATCH] Nova-S-Plus audio line input
From: lawrence rust <lawrence@softsystem.co.uk>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, Darron Broad <darron@kewl.org>
In-Reply-To: <1281191356.2400.91.camel@localhost>
References: <1280587062.1395.37.camel@gagarin>
	 <1281191356.2400.91.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Aug 2010 13:20:50 +0200
Message-ID: <1281266450.1350.198.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-08-07 at 10:29 -0400, Andy Walls wrote:
> On Sat, 2010-07-31 at 16:37 +0200, lawrence rust wrote:
> > Hi everyone,
> > 
> > This patch adds audio DMA capture and ALSA mixer elements for the line
> > input jack of the Hauppauge Nova-S-plus DVB-S PCI card.
> > 
> > I'm using a Hauppauge Nova-S-plus PCI card to watch sat TV and it's been
> > very robust - thanks to everyone here.  I have one minor niggle - when I
> > use it with composite video input from an external STB I can't connect
> > the audio to the line input jack on the card.  So I developed this
> > patch, originally in late 2008 with lots of feedback and input from
> > Darron Broad.
> > 
> > The Nova-S-plus has a WM8775 ADC that is currently not detected.  This
> > patch enables this chip and exports elements for ALSA mixer controls.
> > 
> > I've used this patch with kernels from 2.6.24 to 2.6.35-rc6 and I'm just
> > a little tired of tweaking it every time a new kernel comes out so I'm
> > hoping that it can be permanently included.
> > 
> > Signed-off by Lawrence Rust <lawrence (at) softsystem.co.uk>
> > 
> > diff --git a/drivers/media/video/cx88/cx88-alsa.c
> > b/drivers/media/video/cx88/cx88-alsa.c
> > index 33082c9..044516b 100644
> > --- a/drivers/media/video/cx88/cx88-alsa.c
> > +++ b/drivers/media/video/cx88/cx88-alsa.c
> > @@ -588,6 +588,30 @@ static int snd_cx88_volume_put(struct snd_kcontrol *kcontrol,
> >  	int changed = 0;
> >  	u32 old;
> >  
> > +    /* If a WM8775 is used for audio input utilise the audio controls */
> > +    if ( core->board.audio_chip && core->board.audio_chip == V4L2_IDENT_WM8775) {
> > +        struct v4l2_control client_ctl;
> > +
> > +        if ( value->value.integer.value[0] >= value->value.integer.value[1]) {
> > +            v = value->value.integer.value[0] << 10;
> > +            b = value->value.integer.value[0] ?
> > +              (0x8000 * value->value.integer.value[1]) / value->value.integer.value[0] :
> > +              0x8000;
> > +        } else {
> > +            v = value->value.integer.value[1] << 10;
> > +            b = value->value.integer.value[1] ?
> > +              0xffff - (0x8000 * value->value.integer.value[0]) / value->value.integer.value[1] :
> > +              0x8000;
> > +        }
> > +        client_ctl.value = v;
> > +        client_ctl.id = V4L2_CID_AUDIO_VOLUME;
> > +        call_all(core, core, s_ctrl, &client_ctl);
> > +
> > +        client_ctl.value = b;
> > +        client_ctl.id = V4L2_CID_AUDIO_BALANCE;
> > +        call_all(core, core, s_ctrl, &client_ctl);
> > +    }
> > +
> 
> With the subdev construct, there is really no need for the conditional
> check on the chip's existence.  Just do the call_all().
> 
> Or better yet, when the audio control subdevice is instantiated,
> squirrel away a v4l2_subdev * to it in the card's instance structure and
> just use that instead of "call_all()".  Or when the subdev is
> instantiated, mark the subdev's grp_id with some sort of WM8775 or audio
> control marker value and call the subdev by grp_ip match.  Using
> call_all() isn't the best thing to do, when you know you're just after
> one or two specific devices.

OK, saving the v4l2_subdev * at instantiation looks best.

> 
> >  	left = value->value.integer.value[0] & 0x3f;
> >  	right = value->value.integer.value[1] & 0x3f;
> >  	b = right - left;
> > @@ -601,10 +625,10 @@ static int snd_cx88_volume_put(struct snd_kcontrol *kcontrol,
> >  	spin_lock_irq(&chip->reg_lock);
> >  	old = cx_read(AUD_VOL_CTL);
> >  	if (v != (old & 0x3f)) {
> > -	    cx_write(AUD_VOL_CTL, (old & ~0x3f) | v);
> > +        cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, (old & ~0x3f) | v);
> >  	    changed = 1;
> >  	}
> > -	if (cx_read(AUD_BAL_CTL) != b) {
> > +    if ((cx_read(AUD_BAL_CTL) & 0x7f) != b) {
> >  	    cx_write(AUD_BAL_CTL, b);
> >  	    changed = 1;
> >  	}
> > @@ -619,7 +643,7 @@ static struct snd_kcontrol_new snd_cx88_volume = {
> >  	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
> >  	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE |
> >  		  SNDRV_CTL_ELEM_ACCESS_TLV_READ,
> > -	.name = "Playback Volume",
> > +	.name = "Tuner Volume",
> 
> I'd call this "Analog TV Capture Volume" myself, but meh, it doesn't
> really matter.

I thought long and hard about this name to find something meaningful.
The problem I found was that many of the ALSA mixer GUIs leave little
space for the name or just truncate it.  "Analog-TV Volume" might work -
avoiding the word break.  I'll play with this some more.

> 
> >  	.info = snd_cx88_volume_info,
> >  	.get = snd_cx88_volume_get,
> >  	.put = snd_cx88_volume_put,
> > @@ -650,7 +674,14 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
> >  	vol = cx_read(AUD_VOL_CTL);
> >  	if (value->value.integer.value[0] != !(vol & bit)) {
> >  		vol ^= bit;
> > -		cx_write(AUD_VOL_CTL, vol);
> > +        cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, vol);
> > +        /* If a WM8775 is used for audio input utilise the audio controls */
> > +        if ( (1<<6) == bit && core->board.audio_chip && core->board.audio_chip == V4L2_IDENT_WM8775) {
> > +            struct v4l2_control client_ctl;
> > +            client_ctl.value = 0 == value->value.integer.value[0];
> > +            client_ctl.id = V4L2_CID_AUDIO_MUTE;
> > +            call_all(core, core, s_ctrl, &client_ctl);
> > +        }
> 
> My previous comment abouit calling subdevs applies here.

OK.

> >  		ret = 1;
> >  	}
> >  	spin_unlock_irq(&chip->reg_lock);
> > @@ -659,7 +690,7 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
> >  
> >  static struct snd_kcontrol_new snd_cx88_dac_switch = {
> >  	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
> > -	.name = "Playback Switch",
> > +	.name = "Audio Out Switch",
> 
> The name is a little better.  But just to play devil's advocate, it
> still doesn't say exactly what it does: On/Off? Output 1/Output 2?

The 'switch' suffix is necessary for some mixer GUIs and implies a mute
function.

> 
> 
> >  	.info = snd_ctl_boolean_mono_info,
> >  	.get = snd_cx88_switch_get,
> >  	.put = snd_cx88_switch_put,
> > @@ -668,7 +699,7 @@ static struct snd_kcontrol_new snd_cx88_dac_switch = {
> >  
> >  static struct snd_kcontrol_new snd_cx88_source_switch = {
> >  	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
> > -	.name = "Capture Switch",
> > +	.name = "Tuner Switch",
> 
> Ditto.

For the benefit of some ALSA mixer GUIs this name needs to parallel
"Tuner Volume" or whatever it ends up being called.  For instance
"Analog-TV Switch" implies that the control mutes Analog-TV Volume".
It's not ideal but there doesn't appear to be another programmatic way
to link controls.

> >  	.info = snd_ctl_boolean_mono_info,
> >  	.get = snd_cx88_switch_get,
> >  	.put = snd_cx88_switch_put,
> > diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
> > index 2918a6e..c7ac0fe 100644
> > --- a/drivers/media/video/cx88/cx88-cards.c
> > +++ b/drivers/media/video/cx88/cx88-cards.c
> > @@ -962,19 +962,26 @@ static const struct cx88_board cx88_boards[] = {
> >  	},
> >  	[CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1] = {
> >  		.name		= "Hauppauge Nova-S-Plus DVB-S",
> > -		.tuner_type	= TUNER_ABSENT,
> > +		.tuner_type	= UNSET, /* BUG: Needed by cx88_i2c_init for WM8775 */
> 
> Hrmm.  UNSET can cause many drivers to try to probe the I2C bus for a
> tuner (but I'm not sure if it has that effect in the cx88 driver).
> Probing on the I2C bus is generally bad and should be avoided,
> especially if you know for certain nothing is there.
> 
> Also I see that the .tuner_type check in cx88_i2c_init() is needed for
> kernels older than 2.6.26.  This paticular change to UNSET shouldn't be
> done.

For kernels 2.6.24 and older, wm8775_probe() tests that adapter->class
has I2C_CLASS_TV_ANALOG set and skips the probe if not.  Forcing the
tuner_type to UNSET causes cx88_i2c_init() to set I2C_CLASS_TV_ANALOG
and hence allows the wm8775 to be detected.  The change is unnecessary,
but not deleterious for the nova-s-plus card, for later kernels.  Maybe
it should be made an #ifdef on kernel version?

> >  		.radio_type	= UNSET,
> >  		.tuner_addr	= ADDR_UNSET,
> >  		.radio_addr	= ADDR_UNSET,
> > +        .audio_chip = V4L2_IDENT_WM8775,
> >  		.input		= {{
> >  			.type	= CX88_VMUX_DVB,
> >  			.vmux	= 0,
> > +            /* 2: Line-In */
> > +            .audioroute = 2,
> >  		},{
> >  			.type	= CX88_VMUX_COMPOSITE1,
> >  			.vmux	= 1,
> > +            /* 2: Line-In */
> > +            .audioroute = 2,
> >  		},{
> >  			.type	= CX88_VMUX_SVIDEO,
> >  			.vmux	= 2,
> > +            /* 2: Line-In */
> > +            .audioroute = 2,
> >  		}},
> >  		.mpeg           = CX88_MPEG_DVB,
> >  	},
> > diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
> > index 0fab65c..2c5bd14 100644
> > --- a/drivers/media/video/cx88/cx88-video.c
> > +++ b/drivers/media/video/cx88/cx88-video.c
> > @@ -992,6 +992,32 @@ int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl)
> >  		ctl->value = c->v.minimum;
> >  	if (ctl->value > c->v.maximum)
> >  		ctl->value = c->v.maximum;
> > +
> > +	/* If a WM8775 is used for audio input utilise the audio controls */
> > +	if (core->board.audio_chip &&
> > +			core->board.audio_chip == V4L2_IDENT_WM8775) {
> > +		struct v4l2_control client_ctl;
> > +
> > +		client_ctl.id = ctl->id;
> > +		switch (ctl->id) {
> > +			case V4L2_CID_AUDIO_MUTE:
> > +				client_ctl.value = ctl->value;
> > +				break;
> > +			case V4L2_CID_AUDIO_VOLUME:
> > +				client_ctl.value = (ctl->value) ?
> > +					(0x90 + ctl->value) << 8 : 0;
> > +				break;
> > +			case V4L2_CID_AUDIO_BALANCE:
> > +				client_ctl.value = ctl->value << 9;
> > +				break;
> > +			default:
> > +				client_ctl.id = 0;
> > +				break;
> > +		}
> > +		if (client_ctl.id)
> > +			call_all(core, core, s_ctrl, &client_ctl);
> > +	}
> 
> My previous comment about calling subdevs applies here.

OK, will fix as noted above.

> >  	mask=c->mask;
> >  	switch (ctl->id) {
> >  	case V4L2_CID_AUDIO_BALANCE:
> > @@ -1537,7 +1563,9 @@ static int radio_queryctrl (struct file *file, void *priv,
> >  	if (c->id <  V4L2_CID_BASE ||
> >  		c->id >= V4L2_CID_LASTP1)
> >  		return -EINVAL;
> > -	if (c->id == V4L2_CID_AUDIO_MUTE) {
> > +	if (c->id == V4L2_CID_AUDIO_MUTE ||
> > +		c->id == V4L2_CID_AUDIO_VOLUME ||
> > +			c->id == V4L2_CID_AUDIO_BALANCE) {
> >  		for (i = 0; i < CX8800_CTLS; i++) {
> >  			if (cx8800_ctls[i].v.id == c->id)
> >  				break;
> > diff --git a/drivers/media/video/wm8775.c b/drivers/media/video/wm8775.c
> > index 5c2ba59..140e54a 100644
> > --- a/drivers/media/video/wm8775.c
> > +++ b/drivers/media/video/wm8775.c
> > @@ -55,6 +55,8 @@ struct wm8775_state {
> >  	struct v4l2_subdev sd;
> >  	u8 input;		/* Last selected input (0-0xf) */
> >  	u8 muted;
> > +    u16 volume;
> > +    u16 balance;
> >  };
> >  
> >  static inline struct wm8775_state *to_state(struct v4l2_subdev *sd)
> > @@ -80,6 +82,27 @@ static int wm8775_write(struct v4l2_subdev *sd, int reg, u16 val)
> >  	return -1;
> >  }
> >  
> > +static void wm8775_set_audio(struct v4l2_subdev *sd)
> > +{
> > +    struct wm8775_state *state = to_state(sd);
> > +
> > +    u8 vol_l, vol_r;
> > +
> > +    /* normalize ( 65535 to 0 -> 255 to 0 (+24dB to -103dB) ) */
> > +    vol_l = ((min(65536 - state->balance, 32768) * state->volume) / 32768) >> 8;
> > +    vol_r = ((min(state->balance, (u16)32768) * state->volume) / 32768) >> 8;
> 
> A >> 15 is probably less expensive than a  / 32768.

Any decent compiler will optimise a divide by common powers of 2, but
noted.

> > +    /* Mute */
> > +    wm8775_write(sd, R21, 0x0c0);
> 
> Why glitch the audio when changing the volume?

Don't know - IIRC this came from Darron.  It doesn't appear to cause any
noise while dragging a volume slider but I too don't see the benefit.

> Setting the zero crossing detection in the left and right gain registers
> should cause the chip to change gains in such a way that artifacts won't
> be heard.  You may have to muck with the zero crossing detection timeout
> enable in register R07 too.  See page 22 of the publicly available
> WM8775 datasheet.

I spent hours playing with various wm8775 ALC setups and never found one
that IMHO produced clean, decent quality audio over a range of
programming - not good, low noise audio suitable for recording.  I did
suspect noise pickup prior to the ADC but when I disabled ALC the
quality improved substantially.

> > +    wm8775_write(sd, R14, vol_l);
> > +    wm8775_write(sd, R15, vol_r);
> 
> This change discards the zero-crossing detection enable that was
> manually turned on in other places in this driver which you replaced
> with a call to this function.

Well spotted - will fix.

> > +    /* Un-mute */
> > +    if (!state->muted)
> > +      wm8775_write(sd, R21, state->input);
> > +}
> > +
> >  static int wm8775_s_routing(struct v4l2_subdev *sd,
> >  			    u32 input, u32 output, u32 config)
> >  {
> > @@ -95,12 +118,7 @@ static int wm8775_s_routing(struct v4l2_subdev *sd,
> >  		return -EINVAL;
> >  	}
> >  	state->input = input;
> > -	if (state->muted)
> > -		return 0;
> > -	wm8775_write(sd, R21, 0x0c0);
> > -	wm8775_write(sd, R14, 0x1d4);
> > -	wm8775_write(sd, R15, 0x1d4);
> > -	wm8775_write(sd, R21, 0x100 + state->input);
> > +        wm8775_set_audio(sd);
> 
> Zero crossing detection enable is discarded with this change.

Will fix - see above.

> >  	return 0;
> >  }
> >  
> > @@ -108,9 +126,23 @@ static int wm8775_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> >  {
> >  	struct wm8775_state *state = to_state(sd);
> >  
> > -	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
> > -		return -EINVAL;
> > -	ctrl->value = state->muted;
> > +    switch (ctrl->id) {
> > +    case V4L2_CID_AUDIO_MUTE:
> > +        ctrl->value = state->muted;
> > +        break;
> > +
> > +    case V4L2_CID_AUDIO_VOLUME:
> > +        ctrl->value = state->volume;
> > +        break;
> > +
> > +    case V4L2_CID_AUDIO_BALANCE:
> > +        ctrl->value = state->balance;
> > +        break;
> > +
> > +    default:
> > +        return -EINVAL;
> > +    }
> > +
> >  	return 0;
> >  }
> >  
> > @@ -118,14 +150,24 @@ static int wm8775_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> >  {
> >  	struct wm8775_state *state = to_state(sd);
> >  
> > -	if (ctrl->id != V4L2_CID_AUDIO_MUTE)
> > -		return -EINVAL;
> > -	state->muted = ctrl->value;
> > -	wm8775_write(sd, R21, 0x0c0);
> > -	wm8775_write(sd, R14, 0x1d4);
> > -	wm8775_write(sd, R15, 0x1d4);
> > -	if (!state->muted)
> > -		wm8775_write(sd, R21, 0x100 + state->input);
> > +    switch (ctrl->id) {
> > +    case V4L2_CID_AUDIO_MUTE:
> > +        state->muted = ctrl->value;
> > +        break;
> > +
> > +    case V4L2_CID_AUDIO_VOLUME:
> > +        state->volume = ctrl->value;
> > +        break;
> > +
> > +    case V4L2_CID_AUDIO_BALANCE:
> > +        state->balance = ctrl->value;
> > +        break;
> > +
> > +    default:
> > +        return -EINVAL;
> > +    }
> > +    wm8775_set_audio(sd);
> > +
> 
> Zero crossing detection enable is discarded with this change.

Will fix - see above.

> >  	return 0;
> >  }
> >  
> > @@ -140,31 +182,71 @@ static int wm8775_log_status(struct v4l2_subdev *sd)
> >  {
> >  	struct wm8775_state *state = to_state(sd);
> >  
> > -	v4l2_info(sd, "Input: %d%s\n", state->input,
> > -			state->muted ? " (muted)" : "");
> > +        v4l2_info(sd, "Volume: %04x%s Balance: %04x Input: %d\n",
> > +                state->volume, state->muted ? " (muted)" : "",
> > +                state->balance, state->input);
> >  	return 0;
> >  }
> >  
> >  static int wm8775_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *freq)
> >  {
> > -	struct wm8775_state *state = to_state(sd);
> > -
> >  	/* If I remove this, then it can happen that I have no
> >  	   sound the first time I tune from static to a valid channel.
> >  	   It's difficult to reproduce and is almost certainly related
> >  	   to the zero cross detect circuit. */
> > -	wm8775_write(sd, R21, 0x0c0);
> > -	wm8775_write(sd, R14, 0x1d4);
> > -	wm8775_write(sd, R15, 0x1d4);
> > -	wm8775_write(sd, R21, 0x100 + state->input);
> > +        wm8775_set_audio(sd);
> 
> Zero crossing detection enable is discarded with this change.  It also
> reverse the sense of the comment that remained unchanged.

Zero crossing to be re-instated as above.

> >  	return 0;
> >  }
> >  
> > +static struct v4l2_queryctrl wm8775_qctrl[] = {
> > +       {
> > +               .id            = V4L2_CID_AUDIO_VOLUME,
> > +               .name          = "Volume",
> > +               .minimum       = 0,
> > +               .maximum       = 65535,
> > +               .step          = 65535/100,
> > +               .default_value = 0xCF00, /* 0 dB */
> > +               .flags         = 0,
> > +               .type          = V4L2_CTRL_TYPE_INTEGER,
> > +       }, {
> > +               .id            = V4L2_CID_AUDIO_MUTE,
> > +               .name          = "Mute",
> > +               .minimum       = 0,
> > +               .maximum       = 1,
> > +               .step          = 1,
> > +               .default_value = 1,
> > +               .flags         = 0,
> > +               .type          = V4L2_CTRL_TYPE_BOOLEAN,
> > +       }, {
> > +               .id            = V4L2_CID_AUDIO_BALANCE,
> > +               .name          = "Balance",
> > +               .minimum       = 0,
> > +               .maximum       = 65535,
> > +               .step          = 65535/100,
> > +               .default_value = 32768,
> > +               .flags         = 0,
> > +               .type          = V4L2_CTRL_TYPE_INTEGER,
> > +       }
> > +};
> > +
> > +static int wm8775_query_ctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
> > +{
> > +    int i;
> > +
> > +    for (i = 0; i < ARRAY_SIZE(wm8775_qctrl); i++)
> > +        if (qc->id && qc->id == wm8775_qctrl[i].id) {
> > +            memcpy(qc, &wm8775_qctrl[i], sizeof(*qc));
> > +            return 0;
> > +        }
> > +    return -EINVAL;
> > +}
> > +
> >  /* ----------------------------------------------------------------------- */
> >  
> >  static const struct v4l2_subdev_core_ops wm8775_core_ops = {
> >  	.log_status = wm8775_log_status,
> >  	.g_chip_ident = wm8775_g_chip_ident,
> > +        .queryctrl = wm8775_query_ctrl,
> >  	.g_ctrl = wm8775_g_ctrl,
> >  	.s_ctrl = wm8775_s_ctrl,
> >  };
> > @@ -212,36 +294,23 @@ static int wm8775_probe(struct i2c_client *client,
> >  	v4l2_i2c_subdev_init(sd, client, &wm8775_ops);
> >  	state->input = 2;
> >  	state->muted = 0;
> > +    state->volume = 0xCF00;
> > +    state->balance = 0x8000;
> >  
> >  	/* Initialize wm8775 */
> >  
> > -	/* RESET */
> > -	wm8775_write(sd, R23, 0x000);
> > -	/* Disable zero cross detect timeout */
> > -	wm8775_write(sd, R7, 0x000);
> > -	/* Left justified, 24-bit mode */
> > -	wm8775_write(sd, R11, 0x021);
> > -	/* Master mode, clock ratio 256fs */
> > -	wm8775_write(sd, R12, 0x102);
> > -	/* Powered up */
> > -	wm8775_write(sd, R13, 0x000);
> > -	/* ADC gain +2.5dB, enable zero cross */
> > -	wm8775_write(sd, R14, 0x1d4);
> > -	/* ADC gain +2.5dB, enable zero cross */
> > -	wm8775_write(sd, R15, 0x1d4);
> > -	/* ALC Stereo, ALC target level -1dB FS max gain +8dB */
> > -	wm8775_write(sd, R16, 0x1bf);
> > -	/* Enable gain control, use zero cross detection,
> > -	   ALC hold time 42.6 ms */
> > -	wm8775_write(sd, R17, 0x185);
> > -	/* ALC gain ramp up delay 34 s, ALC gain ramp down delay 33 ms */
> > -	wm8775_write(sd, R18, 0x0a2);
> > -	/* Enable noise gate, threshold -72dBfs */
> > -	wm8775_write(sd, R19, 0x005);
> > -	/* Transient window 4ms, lower PGA gain limit -1dB */
> > -	wm8775_write(sd, R20, 0x07a);
> > -	/* LRBOTH = 1, use input 2. */
> > -	wm8775_write(sd, R21, 0x102);
> > +    wm8775_write(sd, R23, 0x000); /* RESET */
> > +    wm8775_write(sd, R11, 0x022); /* HPF enable, I2S mode, 24-bit */
> > +    wm8775_write(sd, R12, 0x102); /* Master mode, clock ratio 256fs */
> > +    wm8775_write(sd, R13, 0x000); /* Powered up */
> > +    wm8775_set_audio(sd);         /* set volume/mute */
> > +#if 0 /* Enable ALC */
> > +    wm8775_write(sd, R16, 0x1bb); /* ALC stereo, ALC target level -5dB FS, ALC max gain +8dB */
> > +    wm8775_write(sd, R17, 0x185); /* Enable LC, use zero cross, ALC hold 42.7 ms */
> > +    wm8775_write(sd, R18, 0x0a2); /* ALC decay time 34 s, ALC attack time 33 ms */
> > +    wm8775_write(sd, R19, 0x005); /* Enable noise gate, threshold -72dB fs */
> > +    wm8775_write(sd, R20, 0x0fb); /* Transient window 4ms, ALC min gain -5dB */
> > +#endif
> 
> I haven't inspected this thoroughly because you combined a
> whitespace/comment placement change with a functional change, so the
> functions changes are not obvious.
> 
> These sort of changes should be done in two patches, one for the
> functional change and one for the fluff.
> 
> I can say that disabling the ALC is not what the ivtv driver is
> expecting.  Automatic control to avoid clipping is taken for granted.
> Turning ALC off may cause users problems they never had before.  
> 
> ivtv/PVR-150 users only get *1* volume control in the current v4l2_ctrl
> framework, and that is volume control in the CX25843.  They have no
> control currently of the WM8775, and if it starts clipping the input,
> they have no way to correct it.  (Not that the normal user might even
> know where to begin.)
> 
> So NAK on turning off the ALC by default.

OK, I'll add an ioctl and ALSA control to disable ALC, with the default
being ALC on, using the current settings.  ALSA mixer settings are
preserved across a restart so that works fine for me too.

> Just for fun, I dug up some ASCII art of a similar ivtv card discussed
> on the ivtv-devel list in July 2009.  The issue was better auio
> performance could be obtained by having manual control over the WM8739
> and then the CX25841, but V4L2 only really allowed 1 user volume
> control.
> 
>               +----------+                                       +---------------+
>               |     Sel0 |<--------------------------------------| GPIO14        |
>               |     Sel1 |<--------------------------------------| GPIO15        |
>               |          |                                       |               |
> (FM AF L)---->| 74HC4052 |                                       |               |
> (FM AF R)---->|          |         +----------------+------------|I2C Data & CLK |
>               | Dual 4:1 |         V                V            |               |
>               | Mux      |     +------+      +--------------+    |               |
> Line-in L --->|          |     |WM8739|      |   CX25841    |    |   CX23416     |
> Line-in R --->|          |---->|Analog|----->|I2S Data In   |    |               |
>               |          |---->|to I2S|------|I2S Clock     |    |               |
> White Conn?-->|          |     |Audio |      | I2S Data Out |--->|I2S Data In    |
>               |          |     +------+      | I2S Clock    |----|I2S Clock      |
>               +----------+                   |              |    |               |
> Tuner SIF ---------------------------------->|SIF In        |    +---------------+
>                                              |              |
>                                              +--------------+
> 

Yes, this is the situation on the Nova-S-Plus and HVR-1300 but without
the 4052, the mux being within the wm8775.

I'll have another bash at the patch and re-submit it later.

Thanks

-- Lawrence Rust


