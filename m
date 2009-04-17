Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53882 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754660AbZDQKnc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 06:43:32 -0400
Date: Fri, 17 Apr 2009 12:43:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
In-Reply-To: <aec7e5c30904170331n6da85695gdd6da8d6a42eacf1@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904171235010.5119@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
 <aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com>
 <Pine.LNX.4.64.0904170950320.5119@axis700.grange>
 <aec7e5c30904170331n6da85695gdd6da8d6a42eacf1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 17 Apr 2009, Magnus Damm wrote:

> On Fri, Apr 17, 2009 at 4:51 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Fri, 17 Apr 2009, Magnus Damm wrote:
> >> On Wed, Apr 15, 2009 at 9:17 PM, Guennadi Liakhovetski
> >> <g.liakhovetski@gmx.de> wrote:
> >> > This patch series is a preparation for the v4l2-subdev conversion. Please,
> >> > review and test. My current patch-stack in the form of a
> >> > (manually-created) quilt-series is at
> >> > http://www.open-technology.de/download/20090415/ based on linux-next
> >> > history branch, commit ID in 0000-base file. Don't be surprised, that
> >> > patch-set also contains a few not directly related patches.
> >>
> >> Testing on Migo-R board with 2.6.30-rc2-git-something and the
> >> following cherry-picked patches:
> >>
> >> 0007-driver-core-fix-driver_match_device.patch
> >> 0033-soc-camera-host-driver-cleanup.patch
> >> 0034-soc-camera-remove-an-extra-device-generation-from-s.patch
> >> 0035-soc-camera-simplify-register-access-routines-in-mul.patch
> >> and part of 0036 (avoiding rejects, ap325 seems broken btw)
> >
> > Have I broken it or is it unrelated?
> 
> 2.6.30-rc seems broken on Migo-R. A quick check suggests the following:

Ok, before we come to Migo-R, what is with ap325? Have I broken it with 
this my series or is it a different problem?

> V4L/DVB (10141): OK
> V4L/DVB (10672): BAD
> V4L/DVB (11024): BAD

These seem to be pretty random snapshots... Are they all on Linus' master 
or on next or on v4l-dvb? You did pick up the

0007-driver-core-fix-driver_match_device.patch

above, so, you know about that problem (I am very much surprised in fact 
that patch is still not in the mainline, just sent a reminder...), and you 
did use it in all your tests with kernels past 
49b420a13ff95b449947181190b08367348e3e1b didn't you?

> OK means mplayer capture works as excepted with CEU and ov772x.
> BAD means failure to open() /dev/video0 in the case of CEU. vivi works fine.
> 
> Morimoto-san and/or Guennadi, do you see the same thing?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
