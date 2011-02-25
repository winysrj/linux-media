Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:62684 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab1BYUeH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 15:34:07 -0500
Date: Fri, 25 Feb 2011 21:33:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kim HeungJun <riverful@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-Reply-To: <4D67F9A7.9000106@maxwell.research.nokia.com>
Message-ID: <Pine.LNX.4.64.1102252105060.26361@axis700.grange>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <Pine.LNX.4.64.1102241608090.18242@axis700.grange>
 <822C7F65-82D7-4513-BED4-B484163BEB3E@gmail.com>
 <201102251105.06026.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1102251119410.23338@axis700.grange> <4D67F9A7.9000106@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 25 Feb 2011, Sakari Ailus wrote:

> Hi Guennadi,
> 
> Guennadi Liakhovetski wrote:
> > In principle - yes, and yes, I do realise, that the couple of controls, 
> > that I've proposed only cover a very minor subset of the whole flash 
> > function palette. The purposes of my RFC were:
> 
> Why would there be a different interface for controlling the flash in
> simple cases and more complex cases?

Sorry, not sure what you mean. Do you mean different APIs when the flash 
is controlled directly by the sensor and by an external controller? No, of 
course we need one API, but you either issue those ioctl()s to the sensor 
(sub)device, or to the dedicated flash (sub)device. If you mean my "minor 
subset" above, then I was trying to say, that this is a basis, that has to 
be extended, but not, that we will develop a new API for more complicated 
cases.

> As far as I see it, the way the flash is accessed should be the same in
> both cases --- if more complex functionality is required that would be
> implemented in using additional ways (controls, for example).

Of course, that's what we're discussing here - what functions have to be 
implemented.

> The drivers should use sane defaults for controls like power and length.
> I assume things like mode (strobe/continuous) is fairly standard
> functionality.

Yes, these are all the things, that we shall discuss...

> > 1. get things started in the snapshot / flash direction;)
> > 2. get access to dedicated snapshot / flash registers, present on many 
> > sensors and SoCs
> > 3. get at least the very basic snapshot / flash functions, common to most 
> > hardware implementations, but trying to make it future-proof for further 
> > extensions
> > 4. get a basis for a future detailed discussion
> > 
> >> Let's also not forget that, in addition to the flash LEDs itself, devices 
> >> often feature an indicator LED (a small low-power red LED used to indicate 
> >> that video capture is ongoing).
> > 
> > Well, this one doesn't seem too special to me? Wouldn't it suffice to just 
> > toggle it from user-space on streamon / streamoff?
> 
> And what if you want to use the led unconnected to the streaming state? :-)

That's even easier, isn't it? Just turn it on and off from your 
application whenever you want.

> >> This doesn't solve the flash/capture synchronization problem though. I don't 
> >> think we need a dedicated snapshot capture mode at the V4L2 level. A way to 
> >> configure the sensor to react on an external trigger provided by the flash 
> >> controller is needed, and that could be a control on the flash sub-device. 
> > 
> > Well... Sensors call this a "snapshot mode." I don't care that much how we 
> > _call_ it, but I do think, that we should be able to use it.
> 
> Some sensors and webcams might have that, but newer camera solutions
> tend to contain a raw bayer sensor and and ISP. There is no concept of
> snapsnot mode in these sensors.

Hm, I am not sure I understand, why sensors with DSPs in them should have 
no notion of a snapshot mode. Do they have no strobe / trigger pins? And 
no built in possibility to synchronize with a flash?

> > Hm, don't think only the "flash subdevice" has to know about this. First, 
> > you have to switch the sensor into that mode. Second, it might be either 
> > external trigger from the flash controller, or a programmed trigger and a 
> > flash strobe from the sensor to the flash (controller). Third, well, not 
> > quite sure, but doesn't the host have to know about the snapshot mode? 
> 
> I do not favour adding use case type of functionality to interfaces that
> do not necessarily need it. Would the concept of a snapshot be
> parametrisable on V4L2 level?

I am open to this. I don't have a good idea of whether camera hosts have 
to know about the snapshot mode or not. It's open for discussion.

> Otherwise we may end adding interfaces for use case specific things. The
> use cases vary a lot more than the individual features that are required
> to implement them, suggesting it's relatively easy to add redundant
> functionality to the API.

Sure, completely agree - if we can sufficiently implement all the needed 
functionality for those new use-cases with existing API, no need to add 
anything new.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
