Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:56854 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab3F0Jgv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 05:36:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Question: interaction between selection API, ENUM_FRAMESIZES and S_FMT?
Date: Thu, 27 Jun 2013 11:36:43 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <201306241448.15187.hverkuil@xs4all.nl> <Pine.LNX.4.64.1306271045450.19503@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1306271045450.19503@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306271136.43554.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 27 June 2013 10:59:20 Guennadi Liakhovetski wrote:
> Hi Hans
> 
> On Mon, 24 Jun 2013, Hans Verkuil wrote:
> 
> > Hi all,
> > 
> > While working on extending v4l2-compliance with cropping/selection test cases
> > I decided to add support for that to vivi as well (this would give applications
> > a good test driver to work with).
> > 
> > However, I ran into problems how this should be implemented for V4L2 devices
> > (we are not talking about complex media controller devices where the video
> > pipelines are setup manually).
> > 
> > There are two problems, one related to ENUM_FRAMESIZES and one to S_FMT.
> > 
> > The ENUM_FRAMESIZES issue is simple: if you have a sensor that has several
> > possible frame sizes, and that can crop, compose and/or scale, then you need
> > to be able to set the frame size. Currently this is decided by S_FMT which
> > maps the format size to the closest valid frame size. This however makes
> > it impossible to e.g. scale up a frame, or compose the image into a larger
> > buffer.
> > 
> > For video receivers this issue doesn't exist: there the size of the incoming
> > video is decided by S_STD or S_DV_TIMINGS, but no equivalent exists for sensors.
> 
> Isn't it a part of the current uncertainty of the type "who should scale?" 
> Or what output format should be set on the sensor for any specific final 
> user-facing output frame? I thought we decided not to try to become much 
> smarter here with the classical V4L2 API, instead, those for whom this is 
> really important should support subdevice- or even pad-level 
> configuration?

I'm actually not trying to do anything complex. And remember that this is not
scaler specific: even if there is no scaler but you just want to crop and/or
compose you end up with the same problem: you can't define which framesize
should be used. You need to be able to do that in order to know how to interpret
the crop/compose rectangles.

The reason I found all these problems is by the simple experiment of adding
crop/compose support to vivi. Hardly a complex driver. But it is impossible
to do this today.

> 
> > I propose that a new selection target is added: V4L2_SEL_TGT_FRAMESIZE.
> > 
> > However, this leads to another problem: the current S_FMT behavior is that
> > it implicitly sets the framesize. That behavior we will have to keep, otherwise
> > applications will start to behave differently.
> > 
> > I have an idea on how to solve that, but the solution is related to the second
> > problem I found:
> > 
> > When you set a new format size, then the compose rectangle must be set to the
> > new format size as well since that has always been the behavior in the past
> > that applications have come to expect.
> > 
> > But this makes certain operations impossible to execute: if a driver can't
> > scale, then you can never select a new format size larger than the current
> > (possibly cropped) frame size, even though you would want to compose the
> > unscaled image into such a larger buffer.
> > 
> > So what is the behavior that I would expect from drivers?
> > 
> > 1) After calling S_STD, S_DV_TIMINGS or S_SELECTION(V4L2_SEL_TGT_FRAMESIZE)
> > the cropping, composing and format parameters are all adjusted to support the
> > new input video size (typically they are all set to the new size).
> > 
> > 2) After calling S_CROP/S_SELECTION(CROP) the compose and format parameters are all
> > adjusted to support the new crop rectangle.
> > 
> > 3) After calling S_SEL(COMPOSE) the format parameters are adjusted.
> > 
> > 4) Calling S_FMT validates the format parameters to support the compose
> > rectangle.
> > 
> > However, today step 4 does something different: the compose rectangle will be
> > adjusted to the format size (and in the case of a sensor supporting different
> > framesizes the whole pipeline will be adjusted).
> > 
> > The only way I see that would solve this (although it isn't perfect) is to
> > change the behavior of S_FMT only if the selection API was used before by the
> > filehandle. The core can keep easily keep track of that. When the application
> > calls S_FMT and no selection API was used in the past by that filehandle, then
> > the core will call first S_SELECTION(V4L2_SEL_TGT_FRAMESIZE). If that returns
> > -EINVAL, then it will call S_SELECTION(V4L2_SEL_TGT_COMPOSE). Finally it will
> > call S_FMT. Note that a similar sequence is needed for the display case.
> > 
> > This means that a driver supporting the selection API can implement the logical
> > behavior and the core will implement the historically-required illogical part.
> > 
> > So the fix for this would be to add a new selection target and add compatibility
> > code to the v4l2-core.
> > 
> > With that in place I can easily add crop/compose support to vivi.
> > 
> > One area of uncertainty is how drivers currently implement S_FMT: do they reset
> > any cropping done before? They should keep the crop rectangle according to the
> > spec (well, it is implied there). Guennadi, what does soc_camera do?
> 
> No, soc-camera core doesn't touch cropping parameters in s_fmt. Similarly 
> host drivers aren't expected to do that.

OK, good to know.

Thanks,

	Hans
