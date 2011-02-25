Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:55546 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794Ab1BYSt0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 13:49:26 -0500
Message-ID: <4D67F9A7.9000106@maxwell.research.nokia.com>
Date: Fri, 25 Feb 2011 20:49:11 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kim HeungJun <riverful@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange> <Pine.LNX.4.64.1102241608090.18242@axis700.grange> <822C7F65-82D7-4513-BED4-B484163BEB3E@gmail.com> <201102251105.06026.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1102251119410.23338@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102251119410.23338@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

Guennadi Liakhovetski wrote:
> In principle - yes, and yes, I do realise, that the couple of controls, 
> that I've proposed only cover a very minor subset of the whole flash 
> function palette. The purposes of my RFC were:

Why would there be a different interface for controlling the flash in
simple cases and more complex cases?

As far as I see it, the way the flash is accessed should be the same in
both cases --- if more complex functionality is required that would be
implemented in using additional ways (controls, for example).

The drivers should use sane defaults for controls like power and length.
I assume things like mode (strobe/continuous) is fairly standard
functionality.

> 1. get things started in the snapshot / flash direction;)
> 2. get access to dedicated snapshot / flash registers, present on many 
> sensors and SoCs
> 3. get at least the very basic snapshot / flash functions, common to most 
> hardware implementations, but trying to make it future-proof for further 
> extensions
> 4. get a basis for a future detailed discussion
> 
>> Let's also not forget that, in addition to the flash LEDs itself, devices 
>> often feature an indicator LED (a small low-power red LED used to indicate 
>> that video capture is ongoing).
> 
> Well, this one doesn't seem too special to me? Wouldn't it suffice to just 
> toggle it from user-space on streamon / streamoff?

And what if you want to use the led unconnected to the streaming state? :-)

>> This doesn't solve the flash/capture synchronization problem though. I don't 
>> think we need a dedicated snapshot capture mode at the V4L2 level. A way to 
>> configure the sensor to react on an external trigger provided by the flash 
>> controller is needed, and that could be a control on the flash sub-device. 
> 
> Well... Sensors call this a "snapshot mode." I don't care that much how we 
> _call_ it, but I do think, that we should be able to use it.

Some sensors and webcams might have that, but newer camera solutions
tend to contain a raw bayer sensor and and ISP. There is no concept of
snapsnot mode in these sensors.

> Hm, don't think only the "flash subdevice" has to know about this. First, 
> you have to switch the sensor into that mode. Second, it might be either 
> external trigger from the flash controller, or a programmed trigger and a 
> flash strobe from the sensor to the flash (controller). Third, well, not 
> quite sure, but doesn't the host have to know about the snapshot mode? 

I do not favour adding use case type of functionality to interfaces that
do not necessarily need it. Would the concept of a snapshot be
parametrisable on V4L2 level?

Otherwise we may end adding interfaces for use case specific things. The
use cases vary a lot more than the individual features that are required
to implement them, suggesting it's relatively easy to add redundant
functionality to the API.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
