Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3JJNuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Oct 2013 09:50:23 -0400
Date: Thu, 10 Oct 2013 15:50:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
In-Reply-To: <5256ACB9.6030800@googlemail.com>
Message-ID: <Pine.LNX.4.64.1310101539500.20787@axis700.grange>
References: <520E76E7.30201@googlemail.com> <74016946-c59e-4b0b-a25b-4c976f60ae43.maildroid@localhost>
 <5210B2A9.1030803@googlemail.com> <20130818122008.38fac218@samsung.com>
 <52543116.60509@googlemail.com> <Pine.LNX.4.64.1310081834030.31629@axis700.grange>
 <5256ACB9.6030800@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

On Thu, 10 Oct 2013, Frank Sch�fer wrote:

> Am 08.10.2013 18:38, schrieb Guennadi Liakhovetski:
> > Hi Frank,
> >
> > On Tue, 8 Oct 2013, Frank Schäfer wrote:
> >
> >> Am 18.08.2013 17:20, schrieb Mauro Carvalho Chehab:
> >>> Em Sun, 18 Aug 2013 13:40:25 +0200
> >>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >>>
> >>>> Am 17.08.2013 12:51, schrieb Guennadi Liakhovetski:
> >>>>> Hi Frank,
> >>>>> As I mentioned on the list, I'm currently on a holiday, so, replying briefly. 
> >>>> Sorry, I missed that (can't read all mails on the list).
> >>>>
> >>>>> Since em28xx is a USB device, I conclude, that it's supplying clock to its components including the ov2640 sensor. So, yes, I think the driver should export a V4L2 clock.
> >>>> Ok, so it's mandatory on purpose ?
> >>>> I'll take a deeper into the v4l2-clk code and the
> >>>> em28xx/ov2640/soc-camera interaction this week.
> >>>> Have a nice holiday !
> >>> commit 9aea470b399d797e88be08985c489855759c6c60
> >>> Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >>> Date:   Fri Dec 21 13:01:55 2012 -0300
> >>>
> >>>     [media] soc-camera: switch I2C subdevice drivers to use v4l2-clk
> >>>     
> >>>     Instead of centrally enabling and disabling subdevice master clocks in
> >>>     soc-camera core, let subdevice drivers do that themselves, using the
> >>>     V4L2 clock API and soc-camera convenience wrappers.
> >>>     
> >>>     Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >>>     Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>>     Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >>>
> >>>
> >>> (c/c the ones that acked with this broken changeset)
> >>>
> >>> We need to fix it ASAP or to revert the ov2640 changes, as some em28xx
> >>> cameras are currently broken on 3.10.
> >>>
> >>> I'll also reject other ports to the async API if the drivers are
> >>> used outside an embedded driver, as no PC driver currently defines 
> >>> any clock source. The same applies to regulators.
> >>>
> >>> Guennadi,
> >>>
> >>> Next time, please check if the i2c drivers are used outside soc_camera
> >>> and apply the fixes where needed, as no regressions are allowed.
> >>>
> >>> Regards,
> >>> Mauro
> >> FYI: 8 weeks have passed by now and this regression has still not been
> >> fixed.
> >> Does anybody care about it ? WONTFIX ?
> > You replied to my patch "em28xx: balance subdevice power-off calls" with a 
> > few non-essential IMHO comments but you didn't test it.
> 
> Non-essential comments ?
> Maybe you disagree or don't care about them, but that's something different.

Firstly, I did say "IMHO," didn't I? Secondly, sure, let's have a look at 
them:

"I wonder if we should make the (s_power, 1) call part of em28xx_wake_i2c()."

Is this an essential comment? Is it essential where to put an operation 
after a function or after it?

"em28xx_set_mode() calls em28xx_gpio_set(dev,
INPUT(dev->ctl_input)->gpio) and I'm not sure if this could disable
subdevice power again..."

You aren't sure about that. Me neither, so, there's no evidence 
whatsoever. This is just a guess. And I would consider switching subdevice 
power in a *_set_mode() function by explicitly toggling a GPIO in 
presence of proper APIs... not the best design perhaps. I consider this 
comment non-essential too then.

"Hmm... your patch didn't change this, but:
Why do we call these functions only in case of V4L2_BUF_TYPE_VIDEO_CAPTURE ?
Isn't it needed for VBI capturing, too ?
em28xx_wake_i2c() is probably also needed for radio mode..."

Right, my patch doesn't change this, so, this is unrelated.

Have I missed anything?

> > Could you test, please?
> 
> Yes, this patch will make the warnings disappear and works at least for
> my em28xx+ov2640 device.

Good, thanks for testing!

> What about Mauros an my concerns with regards to all other em28xx devices ?

This is still under discussion:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg66566.html

> And what about the em28xx v4l2-clk patches ?

Their acceptance is related to the above.

Thanks
Guennadi

> It's pretty simple: someone (usually the maintainer ;) ) needs to decide
> which way to go.
> Either accept and apply the existing patches or request new ones with
> changes.
> But IMHO doing nothing for 2 months isn't the right way to handle
> regressions.
> 
> Regards,
> Frank
> 
> > In the meantime I'm still waiting for more comments to my "[RFD] 
> > use-counting V4L2 clocks" mail, so far only Sylwester has replied. Without 
> > all these we don't seem to progress very well.
> >
> > Thanks
> > Guennadi
> >
> >>>>> -----Original Message-----
> >>>>> From: "Frank Schäfer" <fschaefer.oss@googlemail.com>
> >>>>> To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Linux Media Mailing List <linux-media@vger.kernel.org>
> >>>>> Sent: Fr., 16 Aug 2013 21:03
> >>>>> Subject: em28xx + ov2640 and v4l2-clk
> >>>>>
> >>>>> Hi Guennadi,
> >>>>>
> >>>>> since commit 9aea470b399d797e88be08985c489855759c6c60 "soc-camera:
> >>>>> switch I2C subdevice drivers to use v4l2-clk", the em28xx driver fails
> >>>>> to register the ov2640 subdevice (if needed).
> >>>>> The reason is that v4l2_clk_get() fails in ov2640_probe().
> >>>>> Does the em28xx driver have to register a (pseudo ?) clock first ?
> >>>>>
> >>>>> Regards,
> >>>>> Frank
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
