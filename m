Return-path: <mchehab@pedra>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:37897 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932140Ab1EQUFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 16:05:40 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH RFC v2] radio-sf16fmr2: convert to generic TEA575x interface
Date: Tue, 17 May 2011 22:05:26 +0200
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	"Kernel development list" <linux-kernel@vger.kernel.org>
References: <201105140017.26968.linux@rainbow-software.org> <201105152326.33925.hverkuil@xs4all.nl> <201105172133.14835.hverkuil@xs4all.nl>
In-Reply-To: <201105172133.14835.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105172205.28899.linux@rainbow-software.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 17 May 2011 21:33:14 Hans Verkuil wrote:
> Hi Ondrej!
>
> On Sunday, May 15, 2011 23:26:33 Hans Verkuil wrote:
> > On Sunday, May 15, 2011 22:18:21 Ondrej Zary wrote:
> > > Thanks, it's much simpler with the new control framework.
> > > Do the negative volume control values make sense? The TC9154A chip can
> > > attenuate the volume from 0 to -68dB in 2dB steps.
> >
> > It does make sense, but I think I would offset the values so they start
> > at 0. Mostly because there might be some old apps that set the volume to
> > 0 when they want to mute, which in this case is full volume.
> >
> > I am not aware of any driver where a volume of 0 isn't the same as the
> > lowest volume possible, so in this particular case I would apply an
> > offset.
> >
> > I will have to do a closer review tomorrow or the day after. I think
> > there are a few subtleties that I need to look at. Ping me if you haven't
> > heard from me by Wednesday. I would really like to get these drivers up
> > to spec now that I have someone who can test them, and once that's done I
> > hope that I never have to look at them again :-) (Unlikely, but one can
> > dream...)
>
> OK, I looked at it a bit more and it needs to be changed a little bit. The
> problem is that the VOLUME control is added after snd_tea575x_init, i.e.
> after the video_register_device call. The video_register_device call should
> be the last thing done before the init sequence returns. There may be
> applications (dbus/hal) that open devices as soon as they appear, so doing
> more initialization after the video node is registered is not a good idea
> (many older V4L drivers make this mistake).
>
> Perhaps creating a snd_tea575x_register function doing just the
> registration may be a good idea. Or a callback before doing the
> video_register_device.

OK, I'll reorder the lines in snd_tea575x_init function and add a callback 
that radio-sf16fmr2 can use.

Also upgraded my card with TC9154AP chip so I can actually test the volume 
control code (and it was broken in my previous patch...). The left and right 
channels can be separately controlled - is there a way to provide separate 
left and right volume controls? Or do I need to fake up a balance control?

> Another thing: the tea->mute field shouldn't be needed anymore. And the
> 'mute on init' bit in snd_tea575x_init can be removed as well since that
> is automatically performed by v4l2_ctrl_handler_setup.

Thought about this too but the snd_tea575x_write() and snd_tea575x_read() 
functions need to know the mute status. And these functions are also used to 
detect the tuner presence before initializing the controls. I don't see any 
elegant solution.

> In addition, the .ioctl field in tea575x_fops can be replaced by
> .unlocked_ioctl. The whole exclusive open stuff and the in_use field can be
> removed. The only thing needed is a struct mutex in struct snd_tea575x,
> initialize it and set tea575x_radio_inst->lock to the mutex. This will
> serialize all access safely.

I'll do this as a separate patch later.

> To do this really right you should add struct v4l2_device to struct
> snd_tea575x (the radio-sf16fmr2 driver has one, so you can use that as an
> example). With that in place you can also add support for 'priority'
> handling. I'd say see what you can do, and if it takes too much time then
> mail me the tea575x code and the radio-sf16frm2 code and I'll finish it.
>
> Regards,
>
> 	Hans



-- 
Ondrej Zary
