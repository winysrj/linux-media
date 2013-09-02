Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56597 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758983Ab3IBWCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Sep 2013 18:02:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
Date: Tue, 03 Sep 2013 00:02:14 +0200
Message-ID: <5842102.PGlJOvU1M9@avalon>
In-Reply-To: <5224D952.5020004@googlemail.com>
References: <520E76E7.30201@googlemail.com> <6237856.Ni2ROBVUfl@avalon> <5224D952.5020004@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

On Monday 02 September 2013 20:30:42 Frank Schäfer wrote:
> Sorry for the delayed reply.
> A few remarks:
> 
> Am 27.08.2013 14:52, schrieb Laurent Pinchart:
> > ...
> > 
> > Even if the bridge doesn't control the clock, it provides a clock to the
> > sensor. As such, it's the responsibility of the bridge driver to provide
> > the clock to the sensor driver. The sensor driver knows that the sensor
> > needs a clock, and must thus get a clock object from somewhere.
> 
> As Mauro already noticed: the clock may be provided by a simple crystal.
> Who is supposed to provide the clock object in this case ?

Whatever code provides other board information. In this case board information 
is provided by em28xx driver (in em28xx-cards.c), so the clock object should 
be provided by that driver as well.

> Making a clock object mandatory isn't reasonable.

The point could be debated further, but you will need to bring that to LKML 
and convince the core CCF (common clock framework) developers.

> And the second argument is, that even if the clock is provided/controlled by
> another chip, it often makes no sense to let the sensor control them.
> At least in em28xx USB devices, it's the _bridge_ that controls and
> configures the sensor, not the other way around.
> The bridge knows better than the sensor if it wants to drive the sensor
> with 6, 12 or 24 MHz, when power should be switched on or off etc.
> From an em28xx bridges point of view, the whole soc_camera module isn't
> needed and the sensor driver design appears to be "upside-down".
> 
> The problem with the sensor drivers in soc_camera seems to be, that the
> assumptions and driver design decisions seem to be based on typical
> embedded hardware only and don't match the requirements of others.
> Changing that will be a not-so-trivial long-term task... :/

Sensor drivers are modeled around the assumption that the host needs to 
control the sensor. If the bridge performs half of the job and relies on the 
host performing the other half, no API generalization is possible. If the half 
that is incumbant upon us matches the current sensor API, great. Otherwise we 
might need custom sensor drivers. There's not much that can be done in terms 
of software APIs generalization when the device defines the boundary between 
software and hardware on a per-device basis.

> >>> * possible fixes: several fixes have been proposed, e.g.
> >>> (a) implement a V4L2 clock in em28xx.
> >>> 
> >>>     Pro: logically correct - a clock is indeed present, local - no core
> >>> 	 changes are needed
> >>> 	
> >>>     Contra: presumably relatively many devices will have such static
> >>> 	 always-on clocks. Implementing them in each of those drivers will
> >>> 	 add copied code. Besides creating a clock name from I2C bus and
> >>> 	 device numbers is ugly (a helper is needed).
> >>> 
> >>> (b) make clocks optional in all subdevice drivers
> >>> 
> >>>     Pro: host / bridge drivers or core don't have to be modified
> >>>     Contra: wrong in principle - those clocks are indeed compulsory
> >> 
> >> I don't think that (b) is wrong: it is not a matter or clocks being
> >> compulsory or not. It is a matter of being able to be controlled or not.
> > 
> > No, it's a matter of providing a clock to a chip that needs one. If the
> > chip needs a clock, it must get one. Whether the clock can be controlled
> > or not is not relevant.
> 
> IMHO it is relevant. And (as mentioned above) if the sensor
> _should_be_allowed_ to control the clock is also relevant.
> 
> > Otherwise all clock users would need to implement several code
> > paths depending on whether the clock is controllable or not.
> 
> That's indeed what the drivers should do.
> What's so unusual about it ? soc_camera already does it. ;)
> As you can see from the code (and also my RFC patch), these "code paths"
> are basically pretty simple.

They might be simple, but they need to be duplicated all over the place, 
resulting in code bloat and bugs.

> Of course, the async device registration mechanism needs to be
> fixed/improved.
> 
> > That's something we wanted to avoid, as it would result in code bloat.
> 
> Forcing drivers to implement pseudo/fake clocks is code bloat.

There's no fake clock. There's a real hardware clock, which we model as a 
software clock object.

> Am 27.08.2013 18:00, schrieb Mauro Carvalho Chehab:
> > Em Tue, 27 Aug 2013 17:27:52 +0200
> > Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> > 
> > ...
> > 
> >> The point is that the client driver knows that it needs a clock, and
> >> knows how to use it (for instance it knows that it should turn the clock
> >> on at least 100ms before sending the first I2C command). However, the
> >> client should not know how the clock is provided. That's the clock API
> >> abstraction layer. The client will request the clock and turn it on/off
> >> when it needs to, and if the clock source is a crystal it will always be
> >> on. On platforms where the clock can be controlled we will thus save
> >> power by disabling the clock when it's not used, and on other platforms
> >> the clock will just always be on, without any need to code this
> >> explictly in all client drivers.
> > 
> > On em28xx devices, power saving is done by enabling reset pin. On several
> > hardware, doing that internally disables the clock line. I'm not sure if
> > ov2640 supports this mode (Frank may know better how power saving is done
> > with those cameras). Other devices have an special pin for power off or
> > power saving.
> 
> The EM25xx describes a standard mapping of GPIO pins to several
> functionalities (LEDs, buttons, sensor power on/off, ...).
> But hardware manufacturers can of course build circuits differently.
> The VAD Laplace webcam for example doesn't use the dedicated GPIO-pin
> for sensor power on/off. It's sensor seems to be powered all the time.
> 
> > Anyway, that rises an interesting question: on devices with wired clocks,
> > the power saving mode should not be provided via clock API abstraction
> > layer, but via a callback to the bridge (as the bridge knows the GPIO
> > register/bit that corresponds to device reset and/or power off pin).
> 
> Well, you can add power on/off callbacks to struct soc_camera_link for
> this.
> But - same question as above: who controls who ? ;)
> IMHO, it's the em28xx bridge that controls the sensor and decides when
> the sensor power needs to be switched on/off.

-- 
Regards,

Laurent Pinchart

