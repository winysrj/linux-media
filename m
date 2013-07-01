Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35753 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab3GASZZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jul 2013 14:25:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Question: interaction between selection API, ENUM_FRAMESIZES and S_FMT?
Date: Mon, 01 Jul 2013 20:25:51 +0200
Message-ID: <1423440.7by3ZhWOSn@avalon>
In-Reply-To: <201307011638.34763.hverkuil@xs4all.nl>
References: <201306241448.15187.hverkuil@xs4all.nl> <1483196.tyaNtCpDTy@avalon> <201307011638.34763.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 01 July 2013 16:38:34 Hans Verkuil wrote:
> On Mon 1 July 2013 14:42:34 Laurent Pinchart wrote:
> > On Monday 24 June 2013 14:48:15 Hans Verkuil wrote:
> > > Hi all,
> > > 
> > > While working on extending v4l2-compliance with cropping/selection test
> > > cases I decided to add support for that to vivi as well (this would give
> > > applications a good test driver to work with).
> > > 
> > > However, I ran into problems how this should be implemented for V4L2
> > > devices (we are not talking about complex media controller devices
> > > where the video pipelines are setup manually).
> > > 
> > > There are two problems, one related to ENUM_FRAMESIZES and one to S_FMT.
> > > 
> > > The ENUM_FRAMESIZES issue is simple: if you have a sensor that has
> > > several possible frame sizes, and that can crop, compose and/or scale,
> > > then you need to be able to set the frame size.
> > 
> > You mentioned that this discussion relates to simple pipelines controlled
> > through a video node only. I'd like to take a step back here and first
> > define what pipelines we want to support in such a way, and what
> > pipelines requires the media controller API. Based on that information we
> > can list the use cases we need to support, and then decide on the
> > S_FMT/S_SELECTION APIs behaviour.
>
> It's fairly simple. If I have a video capture device, either using S_STD or
> S_DV_TIMINGS to define the resolution of the incoming video, then I can do
> cropping, composing and setting the final format without problem. I have all
> the information I need to do the calculations.
> 
> On the other hand, replace the video receiver by a sensor or by a software
> or hardware image generator that supports a range of resolutions and
> everything falls down just because you don't have the equivalent of
> S_STD/S_DV_TIMINGS for this type of device. All you need is a way to select
> which resolution should be produced at the beginning/source of the video
> pipeline. That's exactly why S_STD/S_DV_TIMINGS exist.

I understand that, but it wasn't my point. What I'd like to do is to define 
what hardware pipelines are supported by pure V4L2 drivers (with a video node 
only) and what hardware pipelines are supported by a combination of V4L2 and 
MC.

> > I vaguely remember to have discussed this topic previously in a meeting
> > but I can't find any related information in my notes at the moment. Would
> > anyone happen to have a better memory here ?
> > 
> > > Currently this is decided by S_FMT which maps the format size to the
> > > closest valid frame size. This however makes it impossible to e.g.
> > > scale up a frame, or compose the image into a larger buffer.
> > 
> > It also makes it impossible to scale a frame down without composing it
> > into a larger buffer. That's definitely a bad limitation of the API.
> > 
> > > For video receivers this issue doesn't exist: there the size of the
> > > incoming video is decided by S_STD or S_DV_TIMINGS, but no equivalent
> > > exists for sensors.
> > > 
> > > I propose that a new selection target is added: V4L2_SEL_TGT_FRAMESIZE.
> > 
> > Just to make sure I understand you correctly, are you proposing a new
> > selection target valid on video nodes only, that would control the format
> > at the source pad of the sensor ?
> 
> Yes. So this would be valid for an input that:
> 
> - Does not set V4L2_IN_CAP_DV_TIMINGS or CAP_STD in ENUMINPUT
> - Does support ENUM_FRAMESIZES

And ENUM_FRAMESIZES would then report the list of available FRAMESIZE 
rectangles, not the list of available output formats ?

> > > However, this leads to another problem: the current S_FMT behavior is
> > > that it implicitly sets the framesize. That behavior we will have to
> > > keep, otherwise applications will start to behave differently.
> > 
> > Which frame size are you talking about ? S_FMT definitely sets the frame
> > size in memory, do you mean it also implicitly sets the frame size at the
> > sensor source pad ?
> 
> For such devices, yes. How else can you select today which frame size the
> sensor should produce?

Right, I just wanted to make sure to understand your point properly.

> > > I have an idea on how to solve that, but the solution is related to the
> > > second problem I found:
> > > 
> > > When you set a new format size, then the compose rectangle must be set
> > > to the new format size as well since that has always been the behavior
> > > in the past that applications have come to expect.
> > 
> > That's the behaviour applications have come to expect from devices that
> > can't compose. From a quick look at the kernel source only Samsung
> > devices implement the composition API. Does this behaviour need to be
> > preserved there ?
>
> I believe so. I plan on adding composing capabilities to vivi. Any existing
> apps should keep working as expected.

Right. My point was that we could possibly break the way S_FMT works for 
drivers to implement composition, given that existing applications not aware 
of composition wouldn't work with those drivers anyway. But I wasn't 
considering drivers upgraded to support composition, which can't break 
anything. As we need a solution for those, we can as well extend the solution 
to all drivers.
 
> > > But this makes certain operations impossible to execute: if a driver
> > > can't scale, then you can never select a new format size larger than the
> > > current (possibly cropped) frame size, even though you would want to
> > > compose the unscaled image into such a larger buffer.
> > > 
> > > So what is the behavior that I would expect from drivers?
> > > 
> > > 1) After calling S_STD, S_DV_TIMINGS or
> > > S_SELECTION(V4L2_SEL_TGT_FRAMESIZE) the cropping, composing and format
> > > parameters are all adjusted to support the new input video size
> > > (typically they are all set to the new size).
> > > 
> > > 2) After calling S_CROP/S_SELECTION(CROP) the compose and format
> > > parameters are all adjusted to support the new crop rectangle.
> > > 
> > > 3) After calling S_SEL(COMPOSE) the format parameters are adjusted.
> > > 
> > > 4) Calling S_FMT validates the format parameters to support the compose
> > > rectangle.
> > > 
> > > However, today step 4 does something different: the compose rectangle
> > > will be adjusted to the format size (and in the case of a sensor
> > > supporting different framesizes the whole pipeline will be adjusted).
> > > 
> > > The only way I see that would solve this (although it isn't perfect) is
> > > to change the behavior of S_FMT only if the selection API was used
> > > before by the filehandle. The core can keep easily keep track of that.
> > > When the application calls S_FMT and no selection API was used in the
> > > past by that filehandle, then the core will call first
> > > S_SELECTION(V4L2_SEL_TGT_FRAMESIZE). If that returns -EINVAL, then it
> > > will call S_SELECTION(V4L2_SEL_TGT_COMPOSE). Finally it will call S_FMT.
> > > Note that a similar sequence is needed for the display case.
> > > 
> > > This means that a driver supporting the selection API can implement the
> > > logical behavior and the core will implement the historically-required
> > > illogical part.
> > > 
> > > So the fix for this would be to add a new selection target and add
> > > compatibility code to the v4l2-core.
> > > 
> > > With that in place I can easily add crop/compose support to vivi.
> > > 
> > > One area of uncertainty is how drivers currently implement S_FMT: do
> > > they reset any cropping done before? They should keep the crop rectangle
> > > according to the spec (well, it is implied there). Guennadi, what does
> > > soc_camera do?
> > > 
> > > Sylwester, I am also looking at exynos4-is/fimc-lite.c. I do see that
> > > setting the compose rectangle will adjust it to the format size instead
> > > of the other way around, but I can't tell if setting the format size
> > > will also adjust the compose rectangle if that is now out-of-bounds of
> > > the new format size.
> > > 
> > > Comments? Questions?
> > 
> > How should we handle devices for which supported sizes (crop, compose,
> > ...) are restricted by selected pixel format ?
> 
> Good question. ENUM_FRAMESIZES returns the available resolutions dependent
> on the pixelformat. That means that when you select a resolution you need
> to specify a pixelformat as well. So just a rectangle isn't enough.
>
> I need to think some more about this.

We could first set the pixel format using S_FMT, then proceed to set all 
resolutions, and finally call S_FMT again as in point 4 above, but that looks 
a bit like a hack to me.

-- 
Regards,

Laurent Pinchart

