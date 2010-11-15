Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:56430 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757588Ab0KOI2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 03:28:07 -0500
Date: Mon, 15 Nov 2010 09:28:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jun Nie <niej0001@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>,
	linux-fbdev@vger.kernel.org
Subject: Re: V4L2 and framebuffer for the same controller
In-Reply-To: <AANLkTi=hGzas8GvpgdumDuBhB8_yMDN8qGrHz4vg4W-o@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1011150925140.32257@axis700.grange>
References: <AANLkTikJNdcnRbNwv4j8zfv4TfSqOgB2K=UD4UFfL=q4@mail.gmail.com>
 <Pine.LNX.4.64.1011020821300.3804@axis700.grange>
 <AANLkTikww_o+L0hS8jFhL+u2EGvZMQPogY_F89Kcm1xT@mail.gmail.com>
 <AANLkTikOdktmvDS0eXof-JCBT_6k=HKHSCYkR2Mu3v9d@mail.gmail.com>
 <Pine.LNX.4.64.1011150816240.32257@axis700.grange>
 <AANLkTi=hGzas8GvpgdumDuBhB8_yMDN8qGrHz4vg4W-o@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 15 Nov 2010, Jun Nie wrote:

> 2010/11/15 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> > On Mon, 15 Nov 2010, Jun Nie wrote:
> >
> >> 2010/11/8 Jun Nie <niej0001@gmail.com>:
> >> > 2010/11/2 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> >> >> Hi Jun
> >> >>
> >> >> On Fri, 29 Oct 2010, Jun Nie wrote:
> >> >>
> >> >>> Hi Guennadi,
> >> >>>     I find that your idea of "provide a generic framebuffer driver
> >> >>> that could sit on top of a v4l output driver", which may be a good
> >> >>> solution of our LCD controller driver, or maybe much more other SOC
> >> >>> LCD drivers. V4L2 interface support many features than framebuffer for
> >> >>> video playback usage, such as buffer queue/dequeue, quality control,
> >> >>> etc. However, framebuffer is common for UI display. Implement two
> >> >>> drivers for one controller is a challenge for current architecture.
> >> >>>     I am interested in your idea. Could you elaborate it? Or do you
> >> >>> think multifunction driver is the right solution for this the
> >> >>> scenario?
> >> >>
> >> >> Right, we have discussed this idea at the V4L2/MC mini-summit earlier this
> >> >> year, there the outcome was, that the idea is not bad, but it is easy
> >> >> enough to create such framebuffer additions on top of specific v4l2 output
> >> >> drivers anyway, so, noone was interested enough to start designing and
> >> >> implementing such a generic wrapper driver. However, I've heard, that this
> >> >> topic has also been scheduled for discussion at another v4l / kernel
> >> >> meeting (plumbers?), so, someone might be looking into implementing
> >> >> this... If you yourself would like to do that - feel free to propose a
> >> >> design on both mailing lists (fbdev added to cc), then we can discuss it,
> >> >> and you can implement it;)
> >> >>
> >> >> Thanks
> >> >> Guennadi
> >> >> ---
> >> >> Guennadi Liakhovetski, Ph.D.
> >> >> Freelance Open-Source Software Developer
> >> >> http://www.open-technology.de/
> >> >>
> >> >
> >> > Good to know others are also interested in it. I surely can contribute
> >> > to it. But my concern is how to support Xwindow. Android and Ubuntu
> >> > should both run on our platform. Queue/deque should work well for
> >> > Android UI. I still can not figure out how to support Xwindow, for it
> >> > does not interact with driver after it get the mmaped buffer.
> >> >
> >> > Jun
> >> >
> >>
> >> Guennadi,
> >>
> >> Any idea on supporting this feature with V4L2 based FB? I can not
> >> figure out any method and will adopt framebuffer for UI and V4L2 for
> >> video layer for the schedule pressure.
> >
> > Hi Jun
> >
> > Sorry, not sure I understand you right here. You are saying, that atm you
> > don't have the time to work on a generic solution and are going for a
> > specific one, right? Yes, that's what everybody is currently doing. And
> > you're asking whether I am working or am going to work on such a generic
> > solution? No, sorry, I don't think I'll have time for it either in the
> > near future.
> >
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> >
> 
> 
> Hi Guennadi
>    I mean I have no idea on how to support Xwindow's requirement if FB
> is based on V4L2. I can contribute on V4L2 based FB if it is clear.
> But I will do as everbody does currently.

Maybe you didn't understand the concept of this driver then. The shole 
idea is to have a v4l2 output driver as a base and add a framebuffer 
translation layer on the top. Which would provide two interfaces to the 
user: a v4l2 one with frame queuing etc, and a standard fb one, which 
should be usable by any fb application (X, directfb,...) natively.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
