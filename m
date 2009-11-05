Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1847 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbZKEOWL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 09:22:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: RFCv2: Media controller proposal
Date: Thu, 5 Nov 2009 15:22:09 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Cohen David Abraham <david.cohen@nokia.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	Zutshi Vimarsh <vimarsh.zutshi@nokia.com>
References: <200909100913.09065.hverkuil@xs4all.nl> <Pine.LNX.4.64.0910270854300.4828@axis700.grange> <829197380910270656s18d0ce9n87f452888b6983ba@mail.gmail.com>
In-Reply-To: <829197380910270656s18d0ce9n87f452888b6983ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051522.10007.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 27 October 2009 14:56:24 Devin Heitmueller wrote:
> On Tue, Oct 27, 2009 at 4:04 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi
> >
> > (repeating my preamble from a previous post)
> >
> > This is a general comment to the whole "media controller" work: having
> > given a talk at the ELC-E in Grenoble on soc-camera, I mentioned briefly a
> > few related RFCs, including this one. I've got a couple of comments back,
> > including the following ones (which is to say, opinions are not mine and
> > may or may not be relevant, I'm just fulfilling my promise to pass them
> > on;)):
> >
> > 1) what about DVB? Wouldn't they also benefit from such an API? I wasn't
> > able to reply to the question, whether the DVB folks know about this and
> > have a chance to take part in the discussion and eventually use this API?
> 
> The extent to which DVB applies is that the DVB devices will appear in
> the MC enumeration.  This will allow userland to be able to see
> "hybrid devices" where both DVB and analog are tied to the same tuner
> and cannot be used at the same time.
> 
> > 2) what I am even less sure about is, whether ALSA / ASoC have been
> > mentioned as possible users of MC, or, at least, possible sources for
> > ideas. ASoC has definitely been mentioned as an audio analog of
> > soc-camera, so, I'll be looking at that - at least at their documentation
> > - to see if I can borrow some of their ideas:-)
> 
> ALSA devices will definitely be available, although at this point I
> have no reason to believe this will require changes the ALSA code
> itself.  All of the changes involve enumeration within v4l to find the
> correct ALSA device associated with the tuner and report the correct
> card number.  The ALSA case is actually my foremost concern with
> regards to the MC API, since it will solve the problem related to
> applications such as tvtime figuring out which ALSA device to playback
> audio on.
> 
> Devin
> 

Does anyone know if alsa has similar routing problems as we have for SoCs?
Currently the MC can be used to discover and change the routing of video streams,
but it would be very easy indeed to include audio streams (or any type of
stream for that matter) as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
