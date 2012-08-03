Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2343 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2HCJL6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 05:11:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jun Nie <niej0001@gmail.com>
Subject: Re: [Workshop-2011] Media summit/KS-2012 proposals
Date: Fri, 3 Aug 2012 11:10:35 +0200
Cc: workshop-2011@linuxtv.org, Rob Clark <rob.clark@linaro.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20120713173708.GB17109@thunk.org> <201208011111.12597.hverkuil@xs4all.nl> <CAGA24MJuUdX=d8aEtExNF=Tn86czLh=Vaqyts7V7g6g6YDRyUg@mail.gmail.com>
In-Reply-To: <CAGA24MJuUdX=d8aEtExNF=Tn86czLh=Vaqyts7V7g6g6YDRyUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208031110.35930.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri August 3 2012 07:37:13 Jun Nie wrote:
> 2012/8/1 Hans Verkuil <hverkuil@xs4all.nl>:
> > On Tue 31 July 2012 19:58:23 Mauro Carvalho Chehab wrote:
> >> In order to sum-up the discussions around the media summit,
> >> this is what we've got so far:
> >>
> >> Proposals                                                                             proposed by
> >> =====================================================================================|=========================================================================================
> >> Common device tree bindings for media devices                                         Sylvester Nawrocki / Guennadi Liakhovetski
> >> ALSA and V4L/Media Controller                                                         Steven Toth / Laurent Pinchart
> >> ARM and needed features for V4L/DVB                                                   Steven Toth
> >> Intel media SDK                                                                               Steven Toth
> >> V4L compiance tool                                                                    Hans Verkuil
> >> V4L2 API ambiguities                                                                  Hans Verkuil
> >> Media Controller library                                                              Laurent Pincart / Sakari Ailus
> >> SoC Vendors feedback � how to help them to go upstream � Android's V4L2 cam library   Laurent Pincart / Guennadi Liakhovetski / Palash Bandyopadhyay / Naveen Krishnamurthy
> >> Synchronization, shared resource and optimizations                                    Pawel Osciak
> >> V4L2/DVB issues from userspace perspective                                            R�mi Denis-Courmont
> >>
> >> As we'll have only one day for the summit, we may need to remove some
> >> themes, or maybe to get an extra time during LPC for the remaining
> >> discussions.
> >>
> >> Possible attendents:
> >> ===================
> >>
> >> Guennadi Liakhovetski
> >> Laurent Pinchart
> >> Mauro Carvalho Chehab
> >> Michael Krufky
> >> Naveen Krishnamurthy
> >> +1 seat from ST (waiting Naveen to define who will be the other seat)
> >> Palash Bandyopadhyay
> >> Pawel Osciak
> >> R�mi Denis-Courmont
> >> Sakari Ailus
> >> Steven Toth
> >> Sylvester Nawrocki
> >>
> >> Am I missing something?
> >>
> >> Are there other proposals or people intending to participate?
> >
> > Yes: I would like to discuss how to add support for HDMI CEC to the kernel.
> > In particularly I need some feedback from the GPU driver developers on what
> > their ideas are, since CEC is something that touches both V4L2 and GPU.
> >
> I am not familiar with CEC implementation in GPU.

As far as I am aware there isn't any.

> But CEC should be
> independent in functionality with audio/video though it is A/V
> related. I prefer to support only CEC frame TX/RX in kernel. CEC
> include different category features that need parsing and may need
> application interaction. Venders may also configure some features as
> not supported.  If kernel support more than TX/RX, policy may be
> separated to user space part and kernel space part. The kernel
> interface also becomes complex, maybe ambiguous too. An user space
> library is more suitable for this task to interact with OS/media
> player/audio control/etc.

I wish that were possible. Our current implementation internally is as you
proposed, but we recently discovered that for HDMI 1.4a this won't fly.

There the CEC channel is also used for control of the ethernet and audio
return channel, and even for hotplug detect in some cases.

That's something that has to be handled entirely in kernelspace. So some
parts of the CEC protocol have to be internally processed, other parts
have to be processed in userspace.

This really complicates things and it makes it even more important that
the subsystems that need CEC work together on this.

Regards,

	Hans
