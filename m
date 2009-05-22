Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50122 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756743AbZEVRhm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 13:37:42 -0400
Date: Fri, 22 May 2009 19:37:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RFC 09/10 v2] v4l2-subdev: re-add s_standby to v4l2_subdev_core_ops
In-Reply-To: <873aaxxf3d.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0905221933180.4418@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
 <Pine.LNX.4.64.0905151907460.4658@axis700.grange> <200905211533.34827.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.0905221611160.4418@axis700.grange> <873aaxxf3d.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 22 May 2009, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> >> Usual question: why do you need an init and halt? What do they do?
> >
> > Hm, maybe you're right, I don't need them. init() was used in soc_camera 
> > drivers on first open() to possibly reset the chip and put it in some 
> > reasonably pre-defined low-power state. But we can do this at the end of 
> > probe(), which even would be more correct, because even the first open 
> > should not change chip's configuration. And halt() (was called release() 
> > originally) is called on last close(). And it seems you shouldn't really 
> > do this at all - the chip should preserve its configuration between 
> > open/close cycles. Am I right?
> 
> 
> > Does anyone among cc'ed authors have any objections against this change? The
> > actual disable should indeed migrate to some PM functions, if implemented.
> If I understand correctly, what was done before was that on last close, the
> sensor was disabled (through sensor->release() call). What will be done now is
> leave the sensor on.
> 
> On an embedded system, the power eaten by an active sensor is usually too much
> compared to the other components.
> 
> So, if there is a solution which enables, on last close, to power down the
> device (or put it in low power mode), in the new API, I'm OK, even if it's a new
> powersaving function. If there is no such function and there will be a gap
> (let's say kernel 2.6.31 to 2.6.35) where the sensor will be left activated all
> the time, then I'm against.
> 
> Let me be even more precise about a usecase :
>  - a user takes a picture with his smartphone
>  - the same user then uses his phone to call his girlfriend
>  - the girlfriend has a lot of things to say, it lasts for 1 hour
> In that case, the sensor _has_ to be switched off.

Nice example, thanks! Ok, of course, we must not leave the poor girl with 
her boyfriend's flat battery:-)

I think we can put the camera to a low-power state in streamoff. But - not 
power it off! This has to be done from system's PM functions. What was 
there on linux-pm about managing power of single devices?...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
