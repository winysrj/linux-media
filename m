Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:17543 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab3HZOJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Aug 2013 10:09:40 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MS5001ZS5Y0XA30@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 26 Aug 2013 10:09:38 -0400 (EDT)
Date: Mon, 26 Aug 2013 11:09:33 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
Message-id: <20130826110933.318f31fa@samsung.com>
In-reply-to: <Pine.LNX.4.64.1308261515320.1767@axis700.grange>
References: <520E76E7.30201@googlemail.com> <5210B2A9.1030803@googlemail.com>
 <20130818122008.38fac218@samsung.com> <1904390.nVVGcVBrVP@avalon>
 <52139A9B.1030400@googlemail.com> <52152578.2060201@googlemail.com>
 <5215344E.2070002@gmail.com> <52168D98.9060600@googlemail.com>
 <20130824160348.074b3d3f@samsung.com>
 <Pine.LNX.4.64.1308261515320.1767@axis700.grange>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Aug 2013 15:54:16 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> On Sat, 24 Aug 2013, Mauro Carvalho Chehab wrote:
> 
> > Em Fri, 23 Aug 2013 00:15:52 +0200
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> > 
> > > Hi Sylwester,
> > > 
> > > Am 21.08.2013 23:42, schrieb Sylwester Nawrocki:
> > > > Hi Frank,
> > > >
> > > > On 08/21/2013 10:39 PM, Frank Schäfer wrote:
> > > >> Am 20.08.2013 18:34, schrieb Frank Schäfer:
> > > >>> Am 20.08.2013 15:38, schrieb Laurent Pinchart:
> > > >>>> Hi Mauro,
> > > >>>>
> > > >>>> On Sunday 18 August 2013 12:20:08 Mauro Carvalho Chehab wrote:
> > > >>>>> Em Sun, 18 Aug 2013 13:40:25 +0200 Frank Schäfer escreveu:
> > > >>>>>> Am 17.08.2013 12:51, schrieb Guennadi Liakhovetski:
> > > >>>>>>> Hi Frank,
> > > >>>>>>> As I mentioned on the list, I'm currently on a holiday, so,
> > > >>>>>>> replying
> > > >>>>>>> briefly.
> > > >>>>>> Sorry, I missed that (can't read all mails on the list).
> > > >>>>>>
> > > >>>>>>> Since em28xx is a USB device, I conclude, that it's supplying
> > > >>>>>>> clock to
> > > >>>>>>> its components including the ov2640 sensor. So, yes, I think the
> > > >>>>>>> driver
> > > >>>>>>> should export a V4L2 clock.
> > > >>>>>> Ok, so it's mandatory on purpose ?
> > > >>>>>> I'll take a deeper into the v4l2-clk code and the
> > > >>>>>> em28xx/ov2640/soc-camera interaction this week.
> > > >>>>>> Have a nice holiday !
> 
> Thanks, it was nice indeed :)
> 
> > > >>>> too late to
> > > >>>> fix the issue (given that 3.10 is already broken) ? The fix
> 
> Don't think it is, "[media] soc-camera: switch I2C subdevice drivers to 
> use v4l2-clk" only appeared in v3.11-rc1.
> 
> > > >>>> shouldn't be too
> > > >>>> complex, registering a dummy V4L2 clock in the em28xx driver should
> > > >>>> be enough.
> > > >>> I would prefer either a) making the clock optional in the senor
> > > >>> driver(s) or b) implementing a real V4L2 clock.
> > > >>>
> > > >>> Reading the soc-camera code, it looks like NULL-pointers for struct
> > > >>> v4l2_clk are handled correctly. so a) should be pretty simple:
> > > >>>
> > > >>>      priv->clk = v4l2_clk_get(&client->dev, "mclk");
> > > >>> -   if (IS_ERR(priv->clk)) {
> > > >>> -       ret = PTR_ERR(priv->clk);
> > > >>> -       goto eclkget;
> > > >>> -   }
> > > >>> +   if (IS_ERR(priv->clk))
> > > >>> +       priv->clk = NULL;
> > > >>>
> > > >>> Some additional NULL-pointer checks might be necessary, e.g. before
> > > >>> calling v4l2_clk_put().
> > > >>
> > > >> Tested and that works.
> > > >> Patch follows.
> > > >
> > > > That patch breaks subdevs registration through the v4l2-async. See commit
> > > >
> > > > ef6672ea35b5bb64ab42e18c1a1ffc717c31588a
> > > > [media] V4L2: mt9m111: switch to asynchronous subdevice probing
> > > >
> > > > Sensor probe() callback must return EPROBE_DEFER when the clock is not
> > > > found. This cause the sensor's probe() callback to be called again by
> > > > the driver core after some other driver has probed, e.g. the one that
> > > > registers v4l2_clk. If specific error code is not returned from probe()
> > > > the whole registration process breaks.
> > > Urgh... great. :/
> > > So the presence of a clock is used as indicator if the device is ready ?
> > > Honestly, that sounds like a misuse... Is there no other way to check if
> > > the device is ready ?
> > > Please don't get me wrong, I noticed you've been working on the async
> > > subdevice registration patches for quite a long time and I'm sure it
> > > wasn't an easy task.
> > 
> > The interface was written to mimic what OF does with clock.
> > 
> > Yeah, I agree that this sucks for non OF drivers.
> > 
> > > Btw: only 2 of the 14 drivers return -EPROBE_DEFER when no clock is
> > > found: imx074, mt9m111m.
> > > All others return the error code from v4l2_clk_get(), usually -ENODEV.
> > 
> > Probably because they weren't converted yet to the new way.
> > 
> > > >
> > > >>> Concerning b): I'm not yet sure if it is really needed/makes sense...
> > > >>> Who is supposed to configure/enable/disable the clock in a
> > > >>> constellation
> > > >>> like em28xx+ov2640 ?
> 
> Ok, let's try to summerise:
> 
> * background: many camera sensors do not react to I2C commands as long as 
> no master clock is supplied. Therefore for _those_ sensors making a clock 
> availability seems logical to me. And since it's the sensor driver, that 
> knows what that clock is used for, when it is needed and - eventually - 
> what rate is required - it's the sensor driver, that should manipulate it. 
> Example: some camera sensor drivers write sensor configuration directly to 
> the hardware in each ioctl() possibly without storing the state 
> internally. Such drivers will need a clock running all the time to keep 
> register values. Other drivers might only store configuration internally 
> and only send it to the hardware when streaming is enabled. Those drivers 
> can keep the clock disabled until that time then.
> 
> * problem: em28xx USB camera driver uses the ov2640 camera sensor driver 
> and doesn't supply a clock. But ov2640 sensors do need a clock, so, we 
> have to assume it is supplied internally in the camera. Presumably, it is 
> always on and its rate cannot be adjusted either.

Guennadi,

I don't have the schematics of those cameras, but I suspect that the
clock for the sensor is hardwired, e. g. probably em28xx can't enable
or disable it. This is the usual solution on non-embedded hardware.

That's why, IMHO, putting anything at the USB bridge driver (em28xx)
makes no sense: the bridge doesn't have any control over the clock.

> * possible fixes: several fixes have been proposed, e.g.
> (a) implement a V4L2 clock in em28xx.
>     Pro: logically correct - a clock is indeed present, local - no core 
> 	changes are needed
>     Contra: presumably relatively many devices will have such static 
> 	always-on clocks. Implementing them in each of those drivers will 
> 	add copied code. Besides creating a clock name from I2C bus and 
> 	device numbers is ugly (a helper is needed).
> 
> (b) make clocks optional in all subdevice drivers
>     Pro: host / bridge drivers or core don't have to be modified
>     Contra: wrong in principle - those clocks are indeed compulsory

I don't think that (b) is wrong: it is not a matter or clocks being
compulsory or not. It is a matter of being able to be controlled or not.

If the clock can't be controlled via software, there's no sense on adding
control stuff for it: it will just add extra code for no good reason.

> 
> (c) add a global flag to indicate, that the use of clocks on this device 
>     is optional
>     Pro: easy to support in drivers
>     Contra: as in (b) above
> 
> (d) a variant of (a), but with a helper function in V4L2 clock core to 
>     implement such a static always-on clock
>     Pro: simple to support in host / bridge drivers
>     Contra: adds bloat to V4L2 clock helper layer, which we want to keep 
> 	small and remove eventually.
> 
> Have I missed anything? Of the above I would go with (d). I could try to 
> code the required always-on clock helpers.

I prefer to have some solution that won't add any extra code if the
clock is always on and can't be controlled.

Regards,
Mauro
