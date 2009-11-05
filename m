Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54301 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbZKEQYZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 11:24:25 -0500
Date: Thu, 5 Nov 2009 14:23:45 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Cohen David Abraham <david.cohen@nokia.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	Zutshi Vimarsh <vimarsh.zutshi@nokia.com>
Subject: Re: RFCv2: Media controller proposal
Message-ID: <20091105142345.35fcc7c7@pedra.chehab.org>
In-Reply-To: <200911051522.10007.hverkuil@xs4all.nl>
References: <200909100913.09065.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.0910270854300.4828@axis700.grange>
	<829197380910270656s18d0ce9n87f452888b6983ba@mail.gmail.com>
	<200911051522.10007.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 5 Nov 2009 15:22:09 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Tuesday 27 October 2009 14:56:24 Devin Heitmueller wrote:
> > On Tue, Oct 27, 2009 at 4:04 AM, Guennadi Liakhovetski
> > <g.liakhovetski@gmx.de> wrote:
> > > Hi
> > >
> > > (repeating my preamble from a previous post)
> > >
> > > This is a general comment to the whole "media controller" work: having
> > > given a talk at the ELC-E in Grenoble on soc-camera, I mentioned briefly a
> > > few related RFCs, including this one. I've got a couple of comments back,
> > > including the following ones (which is to say, opinions are not mine and
> > > may or may not be relevant, I'm just fulfilling my promise to pass them
> > > on;)):
> > >
> > > 1) what about DVB? Wouldn't they also benefit from such an API? I wasn't
> > > able to reply to the question, whether the DVB folks know about this and
> > > have a chance to take part in the discussion and eventually use this API?
> > 
> > The extent to which DVB applies is that the DVB devices will appear in
> > the MC enumeration.  This will allow userland to be able to see
> > "hybrid devices" where both DVB and analog are tied to the same tuner
> > and cannot be used at the same time.
> > 
> > > 2) what I am even less sure about is, whether ALSA / ASoC have been
> > > mentioned as possible users of MC, or, at least, possible sources for
> > > ideas. ASoC has definitely been mentioned as an audio analog of
> > > soc-camera, so, I'll be looking at that - at least at their documentation
> > > - to see if I can borrow some of their ideas:-)
> > 
> > ALSA devices will definitely be available, although at this point I
> > have no reason to believe this will require changes the ALSA code
> > itself.  All of the changes involve enumeration within v4l to find the
> > correct ALSA device associated with the tuner and report the correct
> > card number.  The ALSA case is actually my foremost concern with
> > regards to the MC API, since it will solve the problem related to
> > applications such as tvtime figuring out which ALSA device to playback
> > audio on.
> > 
> > Devin
> > 
> 
> Does anyone know if alsa has similar routing problems as we have for SoCs?
> Currently the MC can be used to discover and change the routing of video streams,
> but it would be very easy indeed to include audio streams (or any type of
> stream for that matter) as well.

em28xx can have an ac97 device with lots of mixers inside, for input and for
output. Some of those ac97 chips are also present on some ac97 motherboards
with advanced audio sound, although I'm not sure if this makes much sense.

On some devices (for example Hauppauge USB 2), there are separate output
mixers for the analog output via the output plug and for the digital output.

On others, you could eventually mix the audio input from the tuner with an
external audio source.

The more complex ac97 are more common on capture-only devices.

Currently, we don't support those advanced usages. For example, with Hauppauge
USB 2, the code just assumes that we want audio on both analog and digital
outputs, but the device allows independent control to each volume.

I'm not sure what would be the proper way for mapping it: maybe two independent
mixers at -alsa? Yet, what happens if the -alsa module weren't compiled?

I'm also not quite sure what would be the media controller paper on such cases.

Cheers,
Mauro
