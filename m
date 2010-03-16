Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:46028 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937796Ab0CPLNJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Mar 2010 07:13:09 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@radix.net>
To: Mark Lord <kernel@teksavvy.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
In-Reply-To: <4B9F0DF0.50006@teksavvy.com>
References: <4B8BE647.7070709@teksavvy.com>
	 <1267493641.4035.17.camel@palomino.walls.org>
	 <4B8CA8DD.5030605@teksavvy.com>
	 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
	 <1268653884.3209.32.camel@palomino.walls.org> <4B9F0DF0.50006@teksavvy.com>
Content-Type: text/plain
Date: Tue, 16 Mar 2010 07:11:52 -0400
Message-Id: <1268737912.3078.45.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-03-16 at 00:49 -0400, Mark Lord wrote:
> On 03/15/10 07:51, Andy Walls wrote:
> > On Sun, 2010-03-14 at 22:48 -0400, Mark Lord wrote:

> >> If the audio is not working after modprobe, then simply doing rmmod/modprobe
> >> in a loop (until working audio is achieved) is enough to cure it.
> ..
> 
> Well, crap.  Tonight our MythTV box proved that assertion to be false.
> The cx18 audio was okay after modprobe, but went bad a few seconds later,
> when mythbackend started up and did the initial channel tuning.
> I have a script that attempts audio input toggling when that happens,
> but it had no effect.  

I'll note from your logs that you're capturing using the 48 ksps audio
sampling rate with tuner audio.

I've never had a problem with the AUX_PLL with 48 ksps audio, so I'm
going to assume the AUX_PLL isn't the problem's cause.




> rmmod/modprobe is still the only "solution",
> and it's rather difficult to do those while mythbackend is running.

> >
> > I've got a first WAG at fixing the resets of the audio microcontroller's
> > resets at:
> >
> > 	http://linuxtv.org/hg/~awalls/cx18-audio
> >
> > If it doesn't work, change the CXADEC_AUDIO_SOFT_RESET register define
> > from 0x810 to 0x9cc, although that may not work either.
> ..
> 
> I'll have a go at that, and anything else you can dream up as well.

Here's an easy one:


I see from the log your work-around is failing:

Mar 13 14:30:04 duke logger: /dev/video1: fix_hvr1600_stutter.sh: Pre-initializing
Mar 13 14:30:09 duke logger: /dev/video1: fix_hvr1600_stutter.sh: HVR1600/cx18 audio bug, reloading cx18 driver
Mar 13 14:30:09 duke logger: /dev/video1: fix_hvr1600_stutter.sh: rmmod cx18 failed

If a cx18 video device node is open or a cx18-alsa device node is open
you won't be able to unload the cx18 and cx18-alsa modules.

Move the cx18-alsa.ko module out of the way so the kernel can't find it
and load it.  Then you never have to worry about something like
pulseaduio keeping it held open.



I see in your log that this is a tuner audio standard autodetection
problem in the A/V digitizer/decoder:

Mar 13 14:42:16 duke kernel: cx18-0 843: Video signal:              present
Mar 13 14:42:16 duke kernel: cx18-0 843: Detected format:           NTSC-M
Mar 13 14:42:16 duke kernel: cx18-0 843: Specified standard:        NTSC-M
Mar 13 14:42:16 duke kernel: cx18-0 843: Specified video input:     Composite 7
Mar 13 14:42:16 duke kernel: cx18-0 843: Specified audioclock freq: 48000 Hz
Mar 13 14:42:16 duke kernel: cx18-0 843: Detected audio mode:       mono
Mar 13 14:42:16 duke kernel: cx18-0 843: Detected audio standard:   no detected audio standard
Mar 13 14:42:16 duke kernel: cx18-0 843: Audio muted:               yes
Mar 13 14:42:16 duke kernel: cx18-0 843: Audio microcontroller:     running
Mar 13 14:42:16 duke kernel: cx18-0 843: Configured audio standard: automatic detection
Mar 13 14:42:16 duke kernel: cx18-0 843: Configured audio system:   BTSC
Mar 13 14:42:16 duke kernel: cx18-0 843: Specified audio input:     Tuner (In8)
Mar 13 14:42:16 duke kernel: cx18-0 843: Preferred audio mode:      stereo

The built-in A/V digitzer/decoder's microcontroller won't unmute the
audio until it has detected the standard and set the registers. 

I also note the "channel change" (audio input toggling from tuner to
composite in and back?) is having no effect:

Mar 13 14:30:23 duke logger: /dev/video1: channel_change: hit HVR1600/cx18 audio bug.. attempting workaround
Mar 13 14:30:24 duke logger: /dev/video1: channel_change: hit HVR1600/cx18 audio bug.. workaround failed

Which means the audio microcontroller didn't restart it's detection loop
or the detection loop is still failing to find anything.  It should
restart on an input toggle.


This means your problem is occuring in the A/V digitizer or before it;
ruling out the APU or the APU firmware, given the current information.


So the areas to concentrate on here are:


a. digitizer audio standard detection microcontroller intitialization,
reset, and restart of the format detection loop

b. TDA9887 analog IF demodulator programming via the CX23418's I2C
master

c. digitizer audio standard detection microcontroller firmware load and
verification (the cx18 driver already does a lot here, but it may be
worth re-inspecting the code)

d. digitizer analog front end and AUX PLL settings for SIF audio (these
should be correct though, so it is unlikely to be the problem)


> But not for a few days -- really really crazy busy at work right now.

Same here.  Crazy at work and home.  I don't mind waiting.


> I am a Linux kernel developer, so I can handle patches and stuff
> if you have any to offer.

I'll keep that in mind.



> Oh.. attached is a full log from a failure a few nights ago.
> This one has the full card status dump included, which shows
> where the audio is being muted at.
> 
> ...
> > With that said, the CX23418 will sometimes have to let register access
> > over the PCI bus fail.  For that, I have routines in cx18-io.[ch] to
> > perform retries.  You may wish to add a log statement there to watch for
> > retry loops that completely fail.
> ..
> 
> I did that a while ago, and they didn't trigger back then.

OK.

Regards,
Andy


