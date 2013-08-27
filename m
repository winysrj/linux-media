Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40885 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3H0P0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 11:26:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
Date: Tue, 27 Aug 2013 17:27:52 +0200
Message-ID: <5182139.9PqyLJNP0L@avalon>
In-Reply-To: <20130827110858.01d88513@samsung.com>
References: <520E76E7.30201@googlemail.com> <6237856.Ni2ROBVUfl@avalon> <20130827110858.01d88513@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 27 August 2013 11:08:58 Mauro Carvalho Chehab wrote:
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> > On Monday 26 August 2013 11:09:33 Mauro Carvalho Chehab wrote:
> > > Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

[snip]

> > > > Ok, let's try to summerise:
> > > > 
> > > > * background: many camera sensors do not react to I2C commands as long
> > > > as no master clock is supplied. Therefore for _those_ sensors making a
> > > > clock availability seems logical to me. And since it's the sensor
> > > > driver, that knows what that clock is used for, when it is needed and
> > > > - eventually - what rate is required - it's the sensor driver, that
> > > > should manipulate it.
> > > > Example: some camera sensor drivers write sensor configuration
> > > > directly to the hardware in each ioctl() possibly without storing the
> > > > state internally. Such drivers will need a clock running all the time
> > > > to keep register values. Other drivers might only store configuration
> > > > internally and only send it to the hardware when streaming is enabled.
> > > > Those drivers can keep the clock disabled until that time then.
> > > > 
> > > > * problem: em28xx USB camera driver uses the ov2640 camera sensor
> > > > driver and doesn't supply a clock. But ov2640 sensors do need a clock,
> > > > so, we have to assume it is supplied internally in the camera.
> > > > Presumably, it is always on and its rate cannot be adjusted either.
> > > 
> > > Guennadi,
> > > 
> > > I don't have the schematics of those cameras, but I suspect that the
> > > clock for the sensor is hardwired, e. g. probably em28xx can't enable
> > > or disable it. This is the usual solution on non-embedded hardware.
> > 
> > Possibly. Or the em28xx controls the clock transparently. We will probably
> > never know, and it doesn't matter much at the end of the day. We know that
> > the clock is on whenever we access the sensor, so we can consider that
> > clock as an always-on clock for all practical matters.
> 
> Yes.
> 
> > > That's why, IMHO, putting anything at the USB bridge driver (em28xx)
> > > makes no sense: the bridge doesn't have any control over the clock.
> > 
> > That's where I don't agree. Here we need to think about the bridge as the
> > combination of the bridge chip and the board on which it's soldered, as
> > the
> > board itself isn't modelled separately.
> 
> Yes, we agree to disagree on this. The board layout is not the bridge.

Strictly speaking, you're right. However, board layout is information that 
need to be conveyed to software one way or the other. Historically that 
information has been part of the bridge driver. For instance, if you look at 
the bttv driver, board layouts are stored in bttv-cards.c. That's why I 
believe that the em28xx driver should store board layout information as well.

> > Even if the bridge doesn't control the clock, it provides a clock to the
> > sensor.
> 
> That highly depends on how it is wired. The clock could be provided by some
> independent circuit, or could be driven from the bridge clock. It is very
> common on those em28xx sticks to see two or even more xtals on it.
> 
> > As such, it's the responsibility of the bridge driver to provide the
> > clock to the sensor driver. The sensor driver knows that the sensor needs
> > a clock, and must thus get a clock object from somewhere.
> 
> "Somewhere" doesn't mean that it comes from em28xx.
> 
> > This is a fundamental principle of the Linux clock framework and regulator
> > framework. For fixed-frequency always-on clocks, as well as for
> > fixed-voltage always-on regulators, the clock and/or regulator provider
> > just needs to register a fixed clock or regulator, which is very easy to
> > do.
> 
> Ok, but the voltage and clock regulators are not mapped, on embedded
> devices, as part of the USB or PCI bus bridge device (except, of course,
> when the voltage/clocks are needed by the bridge device itself). It is
> mapped elsewhere, at DT.

Or in a C code board file, depending on the platform. DT or board files are 
more or less equivalent, both of them store information about the board. For 
PCI and USB devices we need to store that information somewhere as well. As 
the em28xx driver already stores board layout information in em28xx-cards.c, 
we could store clock information there as well (I haven't checked whether 
that's the best place to store that information in the driver). I don't see 
why storing board-specific clock information ("there's a fixed-frequency clock 
with this frequency and this name on the board") in the driver is a different 
issue than storing other kind of board information in the em28xx_board 
structure.

> > The v4l2-clock API has been designed to mimic the clock API to ease the
> > transition to the clock API at a later time (the v4l2-clock API is meant
> > to be temporary only). It doesn't offer all the helper functions
> > available in the clock API and should thus be improved, as Guennadi
> > pointed out.
> 
> That argument I understand: it should mimic the clock API, to avoid rework.
> 
> > > > * possible fixes: several fixes have been proposed, e.g.
> > > > (a) implement a V4L2 clock in em28xx.
> > > > 
> > > >     Pro: logically correct - a clock is indeed present, local - no
> > > >     core changes are needed
> > > >     Contra: presumably relatively many devices will have such static
> > > > 	
> > > > 	always-on clocks. Implementing them in each of those drivers will
> > > > 	add copied code. Besides creating a clock name from I2C bus and
> > > > 	device numbers is ugly (a helper is needed).
> > > > 
> > > > (b) make clocks optional in all subdevice drivers
> > > > 
> > > >     Pro: host / bridge drivers or core don't have to be modified
> > > >     Contra: wrong in principle - those clocks are indeed compulsory
> > > 
> > > I don't think that (b) is wrong: it is not a matter or clocks being
> > > compulsory or not. It is a matter of being able to be controlled or not.
> > 
> > No, it's a matter of providing a clock to a chip that needs one. If the
> > chip needs a clock, it must get one. Whether the clock can be controlled
> > or not is not relevant. Otherwise all clock users would need to implement
> > several code paths depending on whether the clock is controllable or not.
> > That's something we wanted to avoid, as it would result in code bloat.
> > We've instead pushed all that common code to the core, with a requirement
> > for clock providers to register a clock, even if it can't be controlled.
> 
> Software can't provide clock. Only hardware can do it.

The hardware provides a clock, and the software provides a corresponding clock 
object to access clock properties.

> If the hardware already provides it, it doesn't make any sense to add an API
> to control something that can't be controlled at all.

The point is that the client driver knows that it needs a clock, and knows how 
to use it (for instance it knows that it should turn the clock on at least 
100ms before sending the first I2C command). However, the client should not 
know how the clock is provided. That's the clock API abstraction layer. The 
client will request the clock and turn it on/off when it needs to, and if the 
clock source is a crystal it will always be on. On platforms where the clock 
can be controlled we will thus save power by disabling the clock when it's not 
used, and on other platforms the clock will just always be on, without any 
need to code this explictly in all client drivers.

> So, the only sense on having a clock API is when the hardware allows some
> control on it.
> 
> So, if the hardware can't be controlled and it is always on, it makes no
> sense to register a clock.

Please also note that, even if the clock can't be controlled, the sensor might 
need to query the clock frequency for instance to adjust its PLL parameters. 
The clk_get_rate() call is used for such a purpose, and requires a clock 
object.

> The thing is that you're wanting to use the clock register as a way to
> detect that the device got initialized.

I'm not sure to follow you there, I don't think that's how I want to use the 
clock. Could you please elaborate ?

> This is wrong on devices where the clock is hardwired.
>
> > > If the clock can't be controlled via software, there's no sense on
> > > adding control stuff for it: it will just add extra code for no good
> > > reason.
> > > 
> > > > (c) add a global flag to indicate, that the use of clocks on this
> > > > device
> > > > 
> > > >     is optional
> > > >     Pro: easy to support in drivers
> > > >     Contra: as in (b) above
> > > > 
> > > > (d) a variant of (a), but with a helper function in V4L2 clock core to
> > > > 
> > > >     implement such a static always-on clock
> > > >     Pro: simple to support in host / bridge drivers
> > > >     Contra: adds bloat to V4L2 clock helper layer, which we want to
> > > >     keep
> > > > 	
> > > > 	small and remove eventually.
> > > > 
> > > > Have I missed anything? Of the above I would go with (d). I could try
> > > > to code the required always-on clock helpers.
> > > 
> > > I prefer to have some solution that won't add any extra code if the
> > > clock is always on and can't be controlled.
> > 
> > But that's not how the common clock framework works. Sure, we could
> > implement that right now in the v4l2-clock API, but we will need to
> > register a fixed- clock in the em28xx driver when moving to the clock API
> > anyway. Let's not make the transition more complex than it should be.
> 
> Or to fix the clock API to not over-design on devices where the clock can't
> be controlled.

-- 
Regards,

Laurent Pinchart

