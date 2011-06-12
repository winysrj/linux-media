Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1985 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab1FLOGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 10:06:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [RFCv1 PATCH 7/7] tuner-core: s_tuner should not change tuner mode.
Date: Sun, 12 Jun 2011 16:06:37 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl> <201106121523.15127.hverkuil@xs4all.nl> <1307886285.2592.31.camel@localhost>
In-Reply-To: <1307886285.2592.31.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106121606.37621.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, June 12, 2011 15:44:45 Andy Walls wrote:
> On Sun, 2011-06-12 at 15:23 +0200, Hans Verkuil wrote:
> > On Sunday, June 12, 2011 14:53:06 Andy Walls wrote:
> > > On Sun, 2011-06-12 at 14:30 +0200, Hans Verkuil wrote:
> > > > On Sunday, June 12, 2011 14:13:30 Mauro Carvalho Chehab wrote:
> > > > > Em 12-06-2011 08:59, Mauro Carvalho Chehab escreveu:
> > > > > > Em 12-06-2011 08:36, Hans Verkuil escreveu:
> > > > > >>>> What about this:
> > > > > >>>>
> > > > > >>>> Opening /dev/radio effectively starts the radio mode. So if there is TV
> > > > > >>>> capture in progress, then the open should return -EBUSY. Otherwise it
> > > > > >>>> switches the tuner to radio mode. And it stays in radio mode until the
> > > > > >>>> last filehandle of /dev/radio is closed. At that point it will automatically
> > > > > >>>> switch back to TV mode (if there is one, of course).
> > > > > >>>
> > > > > >>> No. This would break existing applications. The mode switch should be done
> > > > > >>> at S_FREQUENCY (e. g. when the radio application is tuning into a channel).
> > > > > >>
> > > > > >> This is not what happens today as the switch to radio occurs as soon as you open
> > > > > >> the radio node. It's the reason for the s_radio op.
> > > > > > 
> > > > > > The s_radio op is something that I wanted to remove. It was there in the past to feed
> > > > > > the TV/radio hint logic. I wrote a patch for it, but I ended by discarding from my
> > > > > > final queue (I can't remember why).
> > > > > > 
> > > > > > I think that the hint logic were completely removed, but we may need to take a look
> > > > > > on the callers for s_radio. I'll check it right now.
> > > > > > 
> > > > > 
> > > > > The s_radio callback requires some care, as it is used on several places. It is probably
> > > > > safe to remove it from tuner, but a few sub-drivers like msp3400 needs it. The actual
> > > > > troubles seem to happen at the bridge drivers that call it during open(). It should be
> > > > > called only at s_frequency. I opted to keep the callback just to avoid having a bridge
> > > > > driver switching its registers to radio mode, and not having the tuner following it.
> > > > > 
> > > > > If we move the radio mode switch at the bridge drivers to s_frequency only, we can just
> > > > > remove this callback from tuner, letting it to be implemented only at the audio decoders.
> > > > 
> > > > Why would the audio decoders need it? If we do the mode switch when s_freq is
> > > > called, then the audio decoders can do the same and s_radio can disappear completely.
> > > > 
> > > > I would like that, but I'm a bit afraid of application breakage since we're changing
> > > > the behavior of /dev/radio. It seems that pretty much every video driver with radio
> > > > capability is calling s_radio during open(): bttv, ivtv, saa7134, usbvision, em28xx,
> > > > cx18, cx88, cx231xx and tm6000.
> > > 
> > > I think ivtvhopper relies on it:
> > > 
> > > http://www.gateways-home.org/wb/pages/mycoding/--ivtvhopper-java.php
> > > 
> > > Also, per my recommendation, ivtvhopper changes radio freq by
> > > using /dev/video24, since V4L2 priorities got in the way:
> > > 
> > > http://ivtvdriver.org/pipermail/ivtv-users/2010-December/010097.html
> > 
> > Well, radio support for ivtv is weird and we really need a ivtv-alsa (easier
> > said than done). Because it is so non-standard, I am not terribly concerned
> > about it.
> 
> I use /dev/radio & /dev/video24 for FM radio using ivtv-radio, myself.
> 
> BTW, the cx18-alsa module annoys me as a developer.  PulseAudio holds
> the device nodes open, pinning the cx18-alsa and cx18 modules in kernel.
> When killed, PulseAudio respawns rapidly and reopens the nodes.
> Unloading cx18 for development purposes is a real pain when the
> cx18-alsa module exists.
> 
> 
> > BTW, one problem with /dev/radio and ivtv (and I think cx18 might have the same
> > problem) is that /dev/radio can be opened only once. A second attempt to open
> > it will result in -EBUSY. That's a driver bug. I wonder if that's really the
> > problem described in the link above instead of priority handling.
> 
> Gah, I think you are right.  It probably was a multiple open() problem
> on /dev/radio for the app author.
> 
> I do remember researching that cx18 and ivtv are single open()
> on /dev/radio.
> 
> I also remember finding that the V4L2 spec doesn't require multiple
> opens, and implies drivers need not support it in at least two places:
> 
>         "Multiple Opens
>         
>         In general, V4L2 devices can be opened more than once. When this
>         is supported by the driver, ..."
> 
> 
>         "Name
>         v4l2-open — Open a V4L2 device
>         
>         ...
>         
>         EBUSY
>                 The driver does not support multiple opens and the
>                 device is already in use.
>         ..."

One of the (loooong) list of TODOs is go through the spec remove such obsolete
stuff. You really must be able to open devices multiple times. Many old drivers
didn't support multiple opens but I think almost all of them have been fixed
now. In ivtv it was probably just laziness as well.

v4l2-compliance actually tests for this (try running v4l2-compliance -d /dev/radio0).

Regards,

	Hans
