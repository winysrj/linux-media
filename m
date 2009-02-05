Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:40879 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589AbZBEBWB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2009 20:22:01 -0500
Subject: Re: KWorld ATSC 115 all static
From: hermann pitton <hermann-pitton@arcor.de>
To: CityK <cityk@rogers.com>
Cc: David Engel <david@istwok.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <498926EE.4050204@rogers.com>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	 <496FE555.7090405@rogers.com> <496FFCE2.8010902@rogers.com>
	 <200901171720.03890.hverkuil@xs4all.nl> <49737088.7060800@rogers.com>
	 <20090202235820.GA9781@opus.istwok.net>  <4987DE4E.2090902@rogers.com>
	 <1233714662.3728.45.camel@pc10.localdom.local>
	 <498926EE.4050204@rogers.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 02:22:29 +0100
Message-Id: <1233796949.3605.25.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

please take this as preliminary only.

Am Mittwoch, den 04.02.2009, 00:26 -0500 schrieb CityK:
> hermann pitton wrote:
> > Am Dienstag, den 03.02.2009, 01:03 -0500 schrieb CityK:
> >   
> >> - Mauro created a patch intended to be applied against mainline ... I
> >> tested and analog tv did NOT work
> >>     
> >
> > strange, that we don't see at least some error messages.
> >   
> 
> Indeed, on a quick glance, the output looks entirely indifferent

At least the digital demod takes all without any hick up and does not
report what it is doing next. The messages are sent from the saa713x.

> hermann pitton wrote:
> > I had a quick test on the in kernel radeon driver on Fedora 10 and
> > recent 2.6.27 with xawtv-3.95.
> > True is, that overlay-preview yields dga is not supported, but with
> > current v4l-dvb master and Hans' conversions mmap/grabdisplay works with
> > the old "xawtv -v 1 -nodga -remote -c /dev/video2" something.
> >   
> Yep, as I menitoned: 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg00989.html. 
> In regards the hit and miss functionality I mentioned with kdetv, the
> pattern was simple:  grabdisplay v4l1 mode would work only after having
> just used tvtime.  Similarly, in the v4l2 mode, after having just used
> tvtime, one can observe a momentary flicker of video (i.e. lasting only
> a few hundredths of a second) from a channel before it reverted to all
> static.
> 
> Additionally, when the apps fail in overlay mode, and are displaying all
> static, you can actually simultaneously open up one of the digital apps
> (take your pick; kaffeine, MPlayer...) and successfully watch dvb.

Open simultaneously is known since ever.
Harder it becomes here.
http://bugzilla.kernel.org/show_bug.cgi?id=10036

Seems I must reread it all or you point me to something to reproduce it.

BTW, using mplayer causes troubles for some apps to get the hardware
Overlay back, not overlay-preview, but not for tvtime. 

> hermann pitton wrote:
> > Like you, I can't imagine that the earlier Kworld ATSC 110/15
> > initialization in Hans' kworld repo could be related to it.
> >   
> 
> No, no -- Mauro doubts it.  I,  on the other hand, suspect that there
> has been something innocuous introduced  within the new v4l2 framework
> that is causing this.

The latter I can't confirm so far and, IIRC, Mauro said he does not
expect that it is related to our driver.

> hermann pitton wrote:
> > I can test on nv drivers as well next, they might have dropped support for it too and just the x capabilies should be reported.
> 
> Nope -- as I mentioned, dropping back to a snapshot from roughly 3 weeks
> ago and applying Mike's patch works with both the nv and nvidia driver,
> hence disproving that it is anything X related. 
> 
> 
> >> - Mainline v4l-dvb:
> >> Pros: none ... you will achieve this thread's namesake -- all static.
> >> Cons: since the code from Hans' v4l-dvb-saa7134 repo was merged, Mike's
> >> hack/workaround patch has been rendered ineffective for good. Mauro's
> >> later patch was also pulled into mainline, but it does not change the
> >> situation analog tv (and I do not mean in relation to Mike's patch, I
> >> mean precisely upon its own).
> >>
> >> - Mike's hack/workaround patch
> >> Pros: it will apply and work with snapshots of v4l-dvb up to probably ~
> >> Jan 15th or so. All the apps that I tested with work as expected.
> >> Cons: in order to use analog tv, upon each boot, one must do what I
> >> termed being a dance with unloading and reloading the tuner module via
> >> modprobe.
> >>     
> >
> > I'm not sure if we even have the status of all devices potentially
> > seeing impacts, but reloading modules becomes more difficult, since we
> > load now saa7134-alsa by default. This will cause that apps like mixers
> > on runlevel 5 need to be closed before you can unload/reload
> > saa7134-alsa and saa7134 and then further any tuner modules.
> >
> > This is fine for all the cards without such problems, but else one must
> > be aware off. With "options saa7134 alsa=0" the old behaviour is
> > restored.
> >
> > Mauro also disabled saa7134-alsa support on saa7130 devices, which
> > simply do not support it and the deprecated saa7134-oss. Thanks! 
> >   
> 
> And speaking of alsa:
> 
> CityK wrote (Jan 19th):
> > Some Other Miscellanea:
> >
> > 2) This is likely related to the discussion about the gate -- after
> > closing the analog TV app, the audio from the last channel being viewed
> > can still be heard if one turns up the volume on their system.  This
> > leakage has always been present.  But given that we are addressing this
> > issue now, it strikes me that the gate is being kept open on the audio
> > line after application closing/release occurs.
> >   
> 
> This issue seems to have been resolved since having updated to the ALSA
> 1.0.19 release from a couple of weeks ago (which literally contained a
> zillion fixes, so I'm not going to bother trying to figure out which one
> might have been the fix).. 

This would need closer insight and I can't reproduce it either on
saa7131e. The saa7134 has some specials for mute, not to talk about the
saa7130.

It should not be related to any ALSA versions, except you might be
talking about your sound card mixer.

The hardware mute always happens in saa7134-tvaudio and saa7134-alsa
only uses an exported symbol for that (Ricardo for mythtv).

The analog and i2s/dma sound can be muted separately by different
registers. The i2s/dma was previously always enabled for possible mpeg
encoders waiting for it, but this was changed in 2005 for all the
cardbus and others without any analog audio out. Maybe not all
saa7133/35/31e chips are equally covered, but I can't tell ;)

Cheers,
Hermann


