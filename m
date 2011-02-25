Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:46797 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab1BYSzQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 13:55:16 -0500
Date: Fri, 25 Feb 2011 20:55:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kim HeungJun <riverful@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
Message-ID: <20110225185511.GG23853@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <Pine.LNX.4.64.1102241608090.18242@axis700.grange>
 <822C7F65-82D7-4513-BED4-B484163BEB3E@gmail.com>
 <201102251105.06026.laurent.pinchart@ideasonboard.com>
 <20110225135314.GF23853@valkosipuli.localdomain>
 <Pine.LNX.4.64.1102251708080.26361@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1102251708080.26361@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Feb 25, 2011 at 06:08:07PM +0100, Guennadi Liakhovetski wrote:
> Hi Sakari

Hi Guennadi,

> On Fri, 25 Feb 2011, Sakari Ailus wrote:
> > I agree with that. Flash synchronisation is just one of the many parameters
> > that would benefit from frame level synchronisation. Exposure time, gain
> > etc. are also such. The sensors provide varying level of hardware support
> > for all these.
> 
> Well, that's true, but... From what I've seen so far, many sensors 
> synchronise such sensitive configuration changes with their frame readout 
> automatically, i.e., you configure some new parameter in a sensor 
> register, but it will only become valid with the next frame. On other 
> sensors you can issue a "hold" command, perform any needed changed, then 
> issue a "commit" and all your changes will be applied atomically.

At that level it's automatic, but what I meant is synchronising the
application of the settings to the exposure start of a given frame. This is
very similar to flash synchronisation.

> Also, we already _can_ configure gain, exposure and many other parameters, 
> but we have no way to use sensor snapshot and flash-synchronisation 
> capabilities.

There is a way to configure them but the interface doesn't allow to specify
when they should take effect.

FCam type applications requires this sort of functionality.

<URL:http://fcam.garage.maemo.org/>

> What we could also do, we could add an optional callback to subdev (core?) 
> operations, which, if activated, the host would call on each frame 
> completion.

It's not quite that simple. The exposure of the next frame has started long
time before that. This requires much more thought probably --- in the case
of lack of hardware support, when the parameters need to be actually given
to the sensor depend somewhat on sensors, I suppose.

> > Flash and indicator power setting can be included to the list of controls
> > above.
> 
> As I replied to Laurent, not sure we need to control the power indicator 
> from V4L2, unless there are sensors, that have support for that.

Um, flash controllers, that is. Yes, there are; the ADP1653, which is just
one example.

> > The power management of the camera is
> > preferrably optimised for speed so that the camera related devices need not
> > to be power cycled when using it. If the flash interface is available on a
> > subdev separately the flash can also be easily powered separately without
> > making this a special case --- the rest of the camera related devices (ISP,
> > lens and sensor) should stay powered off.
> > 
> > > configure the sensor to react on an external trigger provided by the flash 
> > > controller is needed, and that could be a control on the flash sub-device. 
> > > What we would probably miss is a way to issue a STREAMON with a number of 
> > > frames to capture. A new ioctl is probably needed there. Maybe that would be 
> > > an opportunity to create a new stream-control ioctl that could replace 
> > > STREAMON and STREAMOFF in the long term (we could extend the subdev s_stream 
> > > operation, and easily map STREAMON and STREAMOFF to the new ioctl in 
> > > video_ioctl2 internally).
> > 
> > How would this be different from queueing n frames (in total; count
> > dequeueing, too) and issuing streamon? --- Except that when the last frame
> > is processed the pipeline could be stopped already before issuing STREAMOFF.
> > That does indeed have some benefits. Something else?
> 
> Well, you usually see in your host driver, that the videobuffer queue is 
> empty (no more free buffers are available), so, you stop streaming 
> immediately too.

That's right. Disabling streaming does save some power but even more is
saved when switching the devices off completely. This is important in
embedded systems that are often battery powered.

The hardware could be switched off when no streaming takes place. However,
this introduces extra delays to power-up at times they are unwanted --- for
example, when switching from viewfinder to still capture.

The alternative to this is to add a timer to the driver: power off if no
streaming has taken place for n seconds, for example. I would consider this
much inferior to just providing a simple subdev for the flash chip and not
involve the ISP at all.

Regards,

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
