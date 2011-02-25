Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:49262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab1BYRIJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 12:08:09 -0500
Date: Fri, 25 Feb 2011 18:08:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kim HeungJun <riverful@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-Reply-To: <20110225135314.GF23853@valkosipuli.localdomain>
Message-ID: <Pine.LNX.4.64.1102251708080.26361@axis700.grange>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <Pine.LNX.4.64.1102241608090.18242@axis700.grange>
 <822C7F65-82D7-4513-BED4-B484163BEB3E@gmail.com>
 <201102251105.06026.laurent.pinchart@ideasonboard.com>
 <20110225135314.GF23853@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari

On Fri, 25 Feb 2011, Sakari Ailus wrote:

> On Fri, Feb 25, 2011 at 11:05:05AM +0100, Laurent Pinchart wrote:
> > Hi,
> 
> Hi,
> 
> > On Thursday 24 February 2011 18:57:22 Kim HeungJun wrote:
> > > Hi Guennadi,
> > > 
> > > I think, it's maybe a good suggestion for current trend! ( I'm not sure
> > > this express *trend* is right :))
> > > 
> > > But, the flash or strobe control connected with sensor can be controlled by
> > > user application directly, not in the sensor subdev device. For example,
> > > let's think that there is a Flash light application. Its function is just
> > > power-up LED. So, in this case, if the flash control mechanism should be
> > > used *only* in the V4L2 API belonging through S/G_PARM, this mechanism
> > > might be a little complicated, nevertheless it's possible to control
> > > led/strobe using S/G_PARM. I mean that we must check the camera must be in
> > > the capture state or not, or another setting (like a FPS) should be
> > > checked. Namely, for powering up LED, the more procedure is needed.
> > > 
> > > Also, we can think another case. Generally, the LED/STROBE/FLASH is
> > > connected with camera sensor directly, but another case can be existed
> > > that LED connected with Processor by controlling GPIO. So, In this case,
> > > using LED framework look more better I guess, and then user application
> > > access LED frame sysfs node eaisly.
> > 
> > The flash is usually handled by a dedicated I2C flash controller (such as the 
> > ADP1653 used in the N900 - http://www.analog.com/static/imported-
> > files/data_sheets/ADP1653.pdf), which is in that case mapped to a v4l2_subdev. 
> > Simpler solutions of course exist, such as GPIO LEDs or LEDs connected 
> > directly to the sensor. We need an API that can support all those hardware 
> > options.
> > 
> > Let's also not forget that, in addition to the flash LEDs itself, devices 
> > often feature an indicator LED (a small low-power red LED used to indicate 
> > that video capture is ongoing). The flash LEDs can also be used during video 
> > capture, and in focus assist mode (pre-flashing also comes to mind).
> > 
> > In addition to the modes, flash controllers can generate strobe signals or 
> > react on them. Durations are programmable, as well as current limits, and 
> > sometimes PWM/current source mode selection. The device can usually detect 
> > faults (such as over-current or over-temperature faults) that need to be 
> > reported to the user. And we haven't even discussed Xenon flashes.
> > 
> > Given the wide variety of parameters, I think it would make sense to use V4L2 
> > controls on the sub-device directly. If the flash LEDs are connected directly 
> > to the sensor, controls on the sensor sub-device can be used to select the 
> > flash parameters.
> > 
> > This doesn't solve the flash/capture synchronization problem though. I don't 
> > think we need a dedicated snapshot capture mode at the V4L2 level. A way to 
> 
> I agree with that. Flash synchronisation is just one of the many parameters
> that would benefit from frame level synchronisation. Exposure time, gain
> etc. are also such. The sensors provide varying level of hardware support
> for all these.

Well, that's true, but... From what I've seen so far, many sensors 
synchronise such sensitive configuration changes with their frame readout 
automatically, i.e., you configure some new parameter in a sensor 
register, but it will only become valid with the next frame. On other 
sensors you can issue a "hold" command, perform any needed changed, then 
issue a "commit" and all your changes will be applied atomically.

Also, we already _can_ configure gain, exposure and many other parameters, 
but we have no way to use sensor snapshot and flash-synchronisation 
capabilities.

What we could also do, we could add an optional callback to subdev (core?) 
operations, which, if activated, the host would call on each frame 
completion.

> Flash and indicator power setting can be included to the list of controls
> above.

As I replied to Laurent, not sure we need to control the power indicator 
from V4L2, unless there are sensors, that have support for that.

> One more thing that suggests the flash control should be available as a
> separate subdev is to support the use of flash in torch mode without
> performing streaming at all.

Well, yes, that's what my V4L2_MODE_FLASH_ON was supposed to do - 
independent from the streaming status. Maybe placing it in 
v4l2_captureparm::capturemode made it look like it was related to 
streaming status, but it certainly should be possible without any capture 
at all.

> The power management of the camera is
> preferrably optimised for speed so that the camera related devices need not
> to be power cycled when using it. If the flash interface is available on a
> subdev separately the flash can also be easily powered separately without
> making this a special case --- the rest of the camera related devices (ISP,
> lens and sensor) should stay powered off.
> 
> > configure the sensor to react on an external trigger provided by the flash 
> > controller is needed, and that could be a control on the flash sub-device. 
> > What we would probably miss is a way to issue a STREAMON with a number of 
> > frames to capture. A new ioctl is probably needed there. Maybe that would be 
> > an opportunity to create a new stream-control ioctl that could replace 
> > STREAMON and STREAMOFF in the long term (we could extend the subdev s_stream 
> > operation, and easily map STREAMON and STREAMOFF to the new ioctl in 
> > video_ioctl2 internally).
> 
> How would this be different from queueing n frames (in total; count
> dequeueing, too) and issuing streamon? --- Except that when the last frame
> is processed the pipeline could be stopped already before issuing STREAMOFF.
> That does indeed have some benefits. Something else?

Well, you usually see in your host driver, that the videobuffer queue is 
empty (no more free buffers are available), so, you stop streaming 
immediately too.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
