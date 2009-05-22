Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4428 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757652AbZEVOao (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 10:30:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC 09/10 v2] v4l2-subdev: re-add s_standby to v4l2_subdev_core_ops
Date: Fri, 22 May 2009 16:30:37 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange> <200905211533.34827.hverkuil@xs4all.nl> <Pine.LNX.4.64.0905221611160.4418@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0905221611160.4418@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221630.38339.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 22 May 2009 16:23:36 Guennadi Liakhovetski wrote:
> On Thu, 21 May 2009, Hans Verkuil wrote:
> > On Friday 15 May 2009 19:20:18 Guennadi Liakhovetski wrote:
> > > NOT FOR SUBMISSION. Probably, another solution has to be found.
> > > soc-camera drivers need an .init() (marked as "don't use") and a
> > > .halt() methods.
> > >
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > >
> > > Hans, you moved s_standby to tuner_ops, and init is not recommended
> > > for new drivers. Suggestions?
> >
> > Usual question: why do you need an init and halt? What do they do?
>
> Hm, maybe you're right, I don't need them. init() was used in soc_camera
> drivers on first open() to possibly reset the chip and put it in some
> reasonably pre-defined low-power state. But we can do this at the end of
> probe(), which even would be more correct, because even the first open
> should not change chip's configuration. And halt() (was called release()
> originally) is called on last close(). And it seems you shouldn't really
> do this at all - the chip should preserve its configuration between
> open/close cycles. Am I right?

That's correct.

It's interesting to see that init/halt/reset/powersaving type functions are 
usually not needed. I know that there are still a few i2c drivers 
implementing init and reset, and I also know that those can be removed 
since they are not needed at all. I just need to find some time to do the 
actual removal. So whenever I see these functions I always get 
suspicious :-)

Regards,

	Hans

> Does anyone among cc'ed authors have any 
> objections against this change? The actual disable should indeed migrate
> to some PM functions, if implemented.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
