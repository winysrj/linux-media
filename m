Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:62118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1CCICZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 03:02:25 -0500
Date: Thu, 3 Mar 2011 09:02:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Hans Verkuil <hansverk@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-Reply-To: <201103021919.30003.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1103030837450.31639@axis700.grange>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <Pine.LNX.4.64.1102282340480.17525@axis700.grange>
 <Pine.LNX.4.64.1103021841140.29360@axis700.grange> <201103021919.30003.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2 Mar 2011, Hans Verkuil wrote:

> On Wednesday, March 02, 2011 18:51:43 Guennadi Liakhovetski wrote:
> > ...Just occurred to me:
> > 
> > On Mon, 28 Feb 2011, Guennadi Liakhovetski wrote:
> > 
> > > On Mon, 28 Feb 2011, Guennadi Liakhovetski wrote:
> > > 
> > > > On Mon, 28 Feb 2011, Hans Verkuil wrote:
> > > > 
> > > > > Does anyone know which drivers stop capture if there are no buffers available? 
> > > > > I'm not aware of any.
> > > > 
> > > > Many soc-camera hosts do that.
> > > > 
> > > > > I think this is certainly a good initial approach.
> > > > > 
> > > > > Can someone make a list of things needed for flash/snapshot? So don't look yet 
> > > > > at the implementation, but just start a list of functionalities that we need 
> > > > > to support. I don't think I have seen that yet.
> > > > 
> > > > These are not the features, that we _have_ to implement, these are just 
> > > > the ones, that are related to the snapshot mode:
> > > > 
> > > > * flash strobe (provided, we do not want to control its timing from 
> > > > 	generic controls, and leave that to "reasonable defaults" or to 
> > > > 	private controls)
> > 
> > Wouldn't it be a good idea to also export an LED (drivers/leds/) API from 
> > our flash implementation? At least for applications like torch. Downside: 
> > the LED API itself is not advanced enough for all our uses, and exporting 
> > two interfaces to the same device is usually a bad idea. Still, 
> > conceptually it seems to be a good fit.
> 
> I believe we discussed LEDs before (during a discussion about adding illuminator
> controls). I think the preference was to export LEDs as V4L controls.

Unfortunately, I missed that one.

> In general I am no fan of exporting multiple interfaces. It only leads to double
> maintenance and I see no noticable advantage to userspace, only confusion.

On the one hand - yes, but OTOH: think about MFDs. Also think about some 
other functions internal to cameras, like i2c busses. Before those I2C 
busses have been handled internally, but we now prefer properly exporting 
them at the system level and abstracting devices on them as normal i2c 
devices. Think about audio, say, on HDMI. I don't think we have any such 
examples in the mainline atm, but if you have to implement an HDMI 
output as a v4l2 device - you will export a standard audio interface too, 
and they probably will share some register spaces, at least on the PHY. 
Think about cameras with a separate illumitation sensor (yes, I have such 
a webcam, which has a separate sensor window, used to control its "flash" 
LEDs, no idea whether that's also available to the user, it works 
automatically - close the sensor, LEDs go on;)) - wouldn't you export it 
as an "ambient light sensor" device?

Wouldn't using a standard API like the LED one make it easier to cover the 
variety of implementations like: sensor-strobe driven, external dedicated 
flash controller, coupled with the sensor, primitive GPIO- or PWM-operated 
light. The LED API also has an in-kernel part (triggers) and a 
user-interface (sysfs), which is also something, that we need. Consider a 
case, when you have some LED-controller on the system, that controls 
several LEDs, some for camera status, some for other system statuses.

So, not sure...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
