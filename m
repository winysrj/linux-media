Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39931 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3H0Mu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 08:50:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
Date: Tue, 27 Aug 2013 14:52:19 +0200
Message-ID: <6237856.Ni2ROBVUfl@avalon>
In-Reply-To: <20130826110933.318f31fa@samsung.com>
References: <520E76E7.30201@googlemail.com> <Pine.LNX.4.64.1308261515320.1767@axis700.grange> <20130826110933.318f31fa@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday 26 August 2013 11:09:33 Mauro Carvalho Chehab wrote:
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:
> > On Sat, 24 Aug 2013, Mauro Carvalho Chehab wrote:
> > > Em Fri, 23 Aug 2013 00:15:52 +0200
> > > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> > > > Am 21.08.2013 23:42, schrieb Sylwester Nawrocki:
> > > > > On 08/21/2013 10:39 PM, Frank Schäfer wrote:
> > > > >> Am 20.08.2013 18:34, schrieb Frank Schäfer:
> > > > >>> Am 20.08.2013 15:38, schrieb Laurent Pinchart:
> > > > >>>> On Sunday 18 August 2013 12:20:08 Mauro Carvalho Chehab wrote:
> > > > >>>>> Em Sun, 18 Aug 2013 13:40:25 +0200 Frank Schäfer escreveu:
> > > > >>>>>> Am 17.08.2013 12:51, schrieb Guennadi Liakhovetski:
> > > > >>>>>>> Hi Frank,
> > > > >>>>>>> As I mentioned on the list, I'm currently on a holiday, so,
> > > > >>>>>>> replying briefly.
> > > > >>>>>> 
> > > > >>>>>> Sorry, I missed that (can't read all mails on the list).
> > > > >>>>>> 
> > > > >>>>>>> Since em28xx is a USB device, I conclude, that it's supplying
> > > > >>>>>>> clock to its components including the ov2640 sensor. So, yes,
> > > > >>>>>>> I think the driver should export a V4L2 clock.
> > > > >>>>>> 
> > > > >>>>>> Ok, so it's mandatory on purpose ?
> > > > >>>>>> I'll take a deeper into the v4l2-clk code and the
> > > > >>>>>> em28xx/ov2640/soc-camera interaction this week.
> > > > >>>>>> Have a nice holiday !
> > 
> > Thanks, it was nice indeed :)
> > 
> > > > >>>> too late to fix the issue (given that 3.10 is already broken) ?
> > > > >>>> The fix
> > 
> > Don't think it is, "[media] soc-camera: switch I2C subdevice drivers to
> > use v4l2-clk" only appeared in v3.11-rc1.
> > 
> > > > >>>> shouldn't be too complex, registering a dummy V4L2 clock in the
> > > > >>>> em28xx driver should be enough.
> > > > >>> 
> > > > >>> I would prefer either a) making the clock optional in the senor
> > > > >>> driver(s) or b) implementing a real V4L2 clock.
> > > > >>> 
> > > > >>> Reading the soc-camera code, it looks like NULL-pointers for
> > > > >>> struct
> > > > >>> 
> > > > >>> v4l2_clk are handled correctly. so a) should be pretty simple:
> > > > >>>      priv->clk = v4l2_clk_get(&client->dev, "mclk");
> > > > >>> 
> > > > >>> -   if (IS_ERR(priv->clk)) {
> > > > >>> -       ret = PTR_ERR(priv->clk);
> > > > >>> -       goto eclkget;
> > > > >>> -   }
> > > > >>> +   if (IS_ERR(priv->clk))
> > > > >>> +       priv->clk = NULL;
> > > > >>> 
> > > > >>> Some additional NULL-pointer checks might be necessary, e.g.
> > > > >>> before calling v4l2_clk_put().
> > > > >> 
> > > > >> Tested and that works.
> > > > >> Patch follows.
> > > > > 
> > > > > That patch breaks subdevs registration through the v4l2-async. See
> > > > > commit
> > > > > 
> > > > > ef6672ea35b5bb64ab42e18c1a1ffc717c31588a
> > > > > [media] V4L2: mt9m111: switch to asynchronous subdevice probing
> > > > > 
> > > > > Sensor probe() callback must return EPROBE_DEFER when the clock is
> > > > > not found. This cause the sensor's probe() callback to be called
> > > > > again by the driver core after some other driver has probed, e.g.
> > > > > the one that registers v4l2_clk. If specific error code is not
> > > > > returned from probe() the whole registration process breaks.
> > > > 
> > > > Urgh... great. :/
> > > > So the presence of a clock is used as indicator if the device is ready
> > > > ? Honestly, that sounds like a misuse... Is there no other way to
> > > > check if the device is ready ? Please don't get me wrong, I noticed
> > > > you've been working on the async subdevice registration patches for
> > > > quite a long time and I'm sure it wasn't an easy task.
> > > 
> > > The interface was written to mimic what OF does with clock.
> > > 
> > > Yeah, I agree that this sucks for non OF drivers.
> > > 
> > > > Btw: only 2 of the 14 drivers return -EPROBE_DEFER when no clock is
> > > > found: imx074, mt9m111m.
> > > > All others return the error code from v4l2_clk_get(), usually -ENODEV.
> > > 
> > > Probably because they weren't converted yet to the new way.
> > > 
> > > > >>> Concerning b): I'm not yet sure if it is really needed/makes
> > > > >>> sense... Who is supposed to configure/enable/disable the clock in
> > > > >>> a constellation like em28xx+ov2640 ?
> > 
> > Ok, let's try to summerise:
> > 
> > * background: many camera sensors do not react to I2C commands as long as
> > no master clock is supplied. Therefore for _those_ sensors making a clock
> > availability seems logical to me. And since it's the sensor driver, that
> > knows what that clock is used for, when it is needed and - eventually -
> > what rate is required - it's the sensor driver, that should manipulate it.
> > Example: some camera sensor drivers write sensor configuration directly to
> > the hardware in each ioctl() possibly without storing the state
> > internally. Such drivers will need a clock running all the time to keep
> > register values. Other drivers might only store configuration internally
> > and only send it to the hardware when streaming is enabled. Those drivers
> > can keep the clock disabled until that time then.
> > 
> > * problem: em28xx USB camera driver uses the ov2640 camera sensor driver
> > and doesn't supply a clock. But ov2640 sensors do need a clock, so, we
> > have to assume it is supplied internally in the camera. Presumably, it is
> > always on and its rate cannot be adjusted either.
> 
> Guennadi,
> 
> I don't have the schematics of those cameras, but I suspect that the
> clock for the sensor is hardwired, e. g. probably em28xx can't enable
> or disable it. This is the usual solution on non-embedded hardware.

Possibly. Or the em28xx controls the clock transparently. We will probably 
never know, and it doesn't matter much at the end of the day. We know that the 
clock is on whenever we access the sensor, so we can consider that clock as an 
always-on clock for all practical matters.

> That's why, IMHO, putting anything at the USB bridge driver (em28xx) makes
> no sense: the bridge doesn't have any control over the clock.

That's where I don't agree. Here we need to think about the bridge as the 
combination of the bridge chip and the board on which it's soldered, as the 
board itself isn't modelled separately.

Even if the bridge doesn't control the clock, it provides a clock to the 
sensor. As such, it's the responsibility of the bridge driver to provide the 
clock to the sensor driver. The sensor driver knows that the sensor needs a 
clock, and must thus get a clock object from somewhere.

This is a fundamental principle of the Linux clock framework and regulator 
framework. For fixed-frequency always-on clocks, as well as for fixed-voltage 
always-on regulators, the clock and/or regulator provider just needs to 
register a fixed clock or regulator, which is very easy to do.

The v4l2-clock API has been designed to mimic the clock API to ease the 
transition to the clock API at a later time (the v4l2-clock API is meant to be 
temporary only). It doesn't offer all the helper functions available in the 
clock API and should thus be improved, as Guennadi pointed out.

> > * possible fixes: several fixes have been proposed, e.g.
> > (a) implement a V4L2 clock in em28xx.
> > 
> >     Pro: logically correct - a clock is indeed present, local - no core
> > 	changes are needed
> >     Contra: presumably relatively many devices will have such static
> > 	
> > 	always-on clocks. Implementing them in each of those drivers will
> > 	add copied code. Besides creating a clock name from I2C bus and
> > 	device numbers is ugly (a helper is needed).
> > 
> > (b) make clocks optional in all subdevice drivers
> > 
> >     Pro: host / bridge drivers or core don't have to be modified
> >     Contra: wrong in principle - those clocks are indeed compulsory
> 
> I don't think that (b) is wrong: it is not a matter or clocks being
> compulsory or not. It is a matter of being able to be controlled or not.

No, it's a matter of providing a clock to a chip that needs one. If the chip 
needs a clock, it must get one. Whether the clock can be controlled or not is 
not relevant. Otherwise all clock users would need to implement several code 
paths depending on whether the clock is controllable or not. That's something 
we wanted to avoid, as it would result in code bloat. We've instead pushed all 
that common code to the core, with a requirement for clock providers to 
register a clock, even if it can't be controlled.

> If the clock can't be controlled via software, there's no sense on adding
> control stuff for it: it will just add extra code for no good reason.
> 
> > (c) add a global flag to indicate, that the use of clocks on this device
> > 
> >     is optional
> >     Pro: easy to support in drivers
> >     Contra: as in (b) above
> > 
> > (d) a variant of (a), but with a helper function in V4L2 clock core to
> > 
> >     implement such a static always-on clock
> >     Pro: simple to support in host / bridge drivers
> >     Contra: adds bloat to V4L2 clock helper layer, which we want to keep
> > 	
> > 	small and remove eventually.
> > 
> > Have I missed anything? Of the above I would go with (d). I could try to
> > code the required always-on clock helpers.
> 
> I prefer to have some solution that won't add any extra code if the clock is
> always on and can't be controlled.

But that's not how the common clock framework works. Sure, we could implement 
that right now in the v4l2-clock API, but we will need to register a fixed-
clock in the em28xx driver when moving to the clock API anyway. Let's not make 
the transition more complex than it should be.

-- 
Regards,

Laurent Pinchart

