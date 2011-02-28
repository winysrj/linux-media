Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:62172 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1B1LU7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 06:20:59 -0500
Date: Mon, 28 Feb 2011 12:20:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kim HeungJun <riverful@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-Reply-To: <4D6ABB84.9090209@iki.fi>
Message-ID: <Pine.LNX.4.64.1102272224190.6510@axis700.grange>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <Pine.LNX.4.64.1102241608090.18242@axis700.grange>
 <822C7F65-82D7-4513-BED4-B484163BEB3E@gmail.com>
 <201102251105.06026.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1102251119410.23338@axis700.grange> <4D67F9A7.9000106@maxwell.research.nokia.com>
 <Pine.LNX.4.64.1102252105060.26361@axis700.grange> <4D6ABB84.9090209@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 27 Feb 2011, Sakari Ailus wrote:

> Hi,
> 
> Guennadi Liakhovetski wrote:
> > On Fri, 25 Feb 2011, Sakari Ailus wrote:
> > 
> > > Hi Guennadi,
> > > 
> > > Guennadi Liakhovetski wrote:
> > > > In principle - yes, and yes, I do realise, that the couple of controls,
> > > > that I've proposed only cover a very minor subset of the whole flash
> > > > function palette. The purposes of my RFC were:
> > > 
> > > Why would there be a different interface for controlling the flash in
> > > simple cases and more complex cases?
> > 
> > Sorry, not sure what you mean. Do you mean different APIs when the flash
> > is controlled directly by the sensor and by an external controller? No, of
> > course we need one API, but you either issue those ioctl()s to the sensor
> > (sub)device, or to the dedicated flash (sub)device. If you mean my "minor
> > subset" above, then I was trying to say, that this is a basis, that has to
> > be extended, but not, that we will develop a new API for more complicated
> > cases.
> 
> I think I misunderstood you originally, sorry. I should have properly read the
> RFC. :-)
> 
> Your proposal of the flash mode is good, but what about software strobe (a
> little more on that below)?
> 
> Also, what about making this a V4L2 control instead?

These are two things, I think: first we have to decide which functions we 
need, second - how to implement them. Sure, controls are also a 
possibility.

> The ADP1653 driver that
> Laurent referred to implements flash control using V4L2 controls only.
> 
> A version of the driver is here:
> 
> <URL:http://gitorious.org/omap3camera/mainline/commit/a41027c857dfcbc268cf8d1c7c7d0ab8b6abac92>
> 
> It's not yet in mainline --- one reason for this is the lack of time to
> discuss a proper API for the flash. :-)
> 
> ...
> 
> > > > > This doesn't solve the flash/capture synchronization problem though. I
> > > > > don't
> > > > > think we need a dedicated snapshot capture mode at the V4L2 level. A
> > > > > way to
> > > > > configure the sensor to react on an external trigger provided by the
> > > > > flash
> > > > > controller is needed, and that could be a control on the flash
> > > > > sub-device.
> > > > 
> > > > Well... Sensors call this a "snapshot mode." I don't care that much how
> > > > we
> > > > _call_ it, but I do think, that we should be able to use it.
> > > 
> > > Some sensors and webcams might have that, but newer camera solutions
> > > tend to contain a raw bayer sensor and and ISP. There is no concept of
> > > snapsnot mode in these sensors.
> > 
> > Hm, I am not sure I understand, why sensors with DSPs in them should have
> > no notion of a snapshot mode. Do they have no strobe / trigger pins? And
> > no built in possibility to synchronize with a flash?
> 
> I was referring to ISPs such as the OMAP 3 ISP. Some hardware have a flash
> strobe pin while some doesn't (such as the N900).

Of course, if no flash is present, you don't have to support it;)

> Still, even if the strobe pin is missing it should be possible to allow
> strobing the flash by using software strobe (usually an I2C message).
> 
> I agree using a hardware strobe is much much better if it's available.

Again - don't understand. Above (i2c message) you're referring to the 
sensor. But I don't think toggling the flash on per-frame basis from 
software via the sensor makes much sense. That way you could also just 
wire your flash to a GPIO. The main advantage of a sensor-controlled flash 
is, that is toggles the flash automatically, synchronised with its image 
read-out. You would, however, toggle the flash manually, if you just 
wanted to turn it on permanently (torch-mode).

> > > > Hm, don't think only the "flash subdevice" has to know about this.
> > > > First,
> > > > you have to switch the sensor into that mode. Second, it might be either
> > > > external trigger from the flash controller, or a programmed trigger and
> > > > a
> > > > flash strobe from the sensor to the flash (controller). Third, well, not
> > > > quite sure, but doesn't the host have to know about the snapshot mode?
> > > 
> > > I do not favour adding use case type of functionality to interfaces that
> > > do not necessarily need it. Would the concept of a snapshot be
> > > parametrisable on V4L2 level?
> > 
> > I am open to this. I don't have a good idea of whether camera hosts have
> > to know about the snapshot mode or not. It's open for discussion.
> 
> What functionality would the snapshot mode provide? Flash synchronisation?
> Something else?

Also pre-defined number of images, enabling of the trigger pin and trigger 
i2c command. Just noticed - on mt9t031 and mt9v022 the snapshot mode also 
enables externally controlled exposure...

> I have to admit I don't know of any hardware which would recognise a concept
> of "snapshot". Do you have a smart sensor which does this, for example? The
> only hardware support for the flash use I know of is the flash strobe signal.

Several Aptina / Micron sensors have such a mode, e.g., mt9p031, mt9t031, 
mt9v022, mt9m001, also ov7725 from OmniVision (there it's called a "Single 
frame" mode), and, I presume, many others. And no, those are not some 
"smart" sensors, the ones from Aptina are pretty primitive Bayer / 
monochrome cameras.

> Flash synchronisation is indeed an issue, and how to tell that a given frame
> has been exposed with flash. The use of flash is just one of the parameters
> which would be nice to connect to frames, though.

Hm, yes, that's something to think about too...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
