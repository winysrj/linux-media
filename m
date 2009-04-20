Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39390 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751285AbZDTHWZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 03:22:25 -0400
Date: Mon, 20 Apr 2009 09:22:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
In-Reply-To: <aec7e5c30904200014n2d8cdcfeud23f2b6b221f9fad@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904200921090.4403@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
 <aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com>
 <Pine.LNX.4.64.0904170950320.5119@axis700.grange>
 <aec7e5c30904170331n6da85695gdd6da8d6a42eacf1@mail.gmail.com>
 <Pine.LNX.4.64.0904171235010.5119@axis700.grange>
 <aec7e5c30904200014n2d8cdcfeud23f2b6b221f9fad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Apr 2009, Magnus Damm wrote:

> On Fri, Apr 17, 2009 at 7:43 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Fri, 17 Apr 2009, Magnus Damm wrote:
> >> On Fri, Apr 17, 2009 at 4:51 PM, Guennadi Liakhovetski
> >> <g.liakhovetski@gmx.de> wrote:
> >> > On Fri, 17 Apr 2009, Magnus Damm wrote:
> >> >> On Wed, Apr 15, 2009 at 9:17 PM, Guennadi Liakhovetski
> >> >> <g.liakhovetski@gmx.de> wrote:
> >> >> > This patch series is a preparation for the v4l2-subdev conversion. Please,
> >> >> > review and test. My current patch-stack in the form of a
> >> >> > (manually-created) quilt-series is at
> >> >> > http://www.open-technology.de/download/20090415/ based on linux-next
> >> >> > history branch, commit ID in 0000-base file. Don't be surprised, that
> >> >> > patch-set also contains a few not directly related patches.
> >> >>
> >> >> Testing on Migo-R board with 2.6.30-rc2-git-something and the
> >> >> following cherry-picked patches:
> >> >>
> >> >> 0007-driver-core-fix-driver_match_device.patch
> >> >> 0033-soc-camera-host-driver-cleanup.patch
> >> >> 0034-soc-camera-remove-an-extra-device-generation-from-s.patch
> >> >> 0035-soc-camera-simplify-register-access-routines-in-mul.patch
> >> >> and part of 0036 (avoiding rejects, ap325 seems broken btw)
> >> >
> >> > Have I broken it or is it unrelated?
> >>
> >> 2.6.30-rc seems broken on Migo-R. A quick check suggests the following:
> >
> > Ok, before we come to Migo-R, what is with ap325? Have I broken it with
> > this my series or is it a different problem?
> 
> Not sure. I used 2.6.30-rc but I guess your patches are aimed at linux-next.
> 
> >> V4L/DVB (10141): OK
> >> V4L/DVB (10672): BAD
> >> V4L/DVB (11024): BAD
> >
> > These seem to be pretty random snapshots... Are they all on Linus' master
> > or on next or on v4l-dvb? You did pick up the
> >
> > 0007-driver-core-fix-driver_match_device.patch
> 
> Yeah, I tried that one. I'm not sure what was the problem, but it's gone now.
> 
> Today I've tested the following on top of linux-2.6 (stable 2.6.30-rc)
> d91dfbb41bb2e9bdbfbd2cc7078ed7436eab027a
> 
> 0033-soc-camera-host-driver-cleanup.patch
> 0034-soc-camera-remove-an-extra-device-generation-from-s.patch
> 0035-soc-camera-simplify-register-access-routines-in-mul.patch
> 
> So far OK.
> However, applying 0036- or v2 from the mailing list results in rejects
> (probably because linux-next vs linux-2.6 differences) but the files
> should not affect Migo-R.
> 
> So with 0036 or v2 applied it builds ok for Migo-R, but I can't open
> /dev/video0 for some reason. Reverting the patch and only using
> 0033->0035 above results in ok /dev/video0 opening.

Did you have video drivers build in or as modules? If modules - in which 
order did you load them? Unfortunately, at the moment it might be 
important:-( What's in dmesg after loading all drivers?

> What are your dependencies?
> 
> I'll try out your 20090415/series on top of the matching linux-next for now.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
