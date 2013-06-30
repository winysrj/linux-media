Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:36282 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3F3U3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Jun 2013 16:29:00 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf17so1386337bkc.7
        for <linux-media@vger.kernel.org>; Sun, 30 Jun 2013 13:28:59 -0700 (PDT)
Message-ID: <51D09507.80501@gmail.com>
Date: Sun, 30 Jun 2013 22:28:55 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Question: interaction between selection API, ENUM_FRAMESIZES
 and S_FMT?
References: <201306241448.15187.hverkuil@xs4all.nl>
In-Reply-To: <201306241448.15187.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 06/24/2013 02:48 PM, Hans Verkuil wrote:
> Hi all,
>
> While working on extending v4l2-compliance with cropping/selection test cases
> I decided to add support for that to vivi as well (this would give applications
> a good test driver to work with).
>
> However, I ran into problems how this should be implemented for V4L2 devices
> (we are not talking about complex media controller devices where the video
> pipelines are setup manually).
>
> There are two problems, one related to ENUM_FRAMESIZES and one to S_FMT.
>
> The ENUM_FRAMESIZES issue is simple: if you have a sensor that has several
> possible frame sizes, and that can crop, compose and/or scale, then you need
> to be able to set the frame size. Currently this is decided by S_FMT which
> maps the format size to the closest valid frame size. This however makes
> it impossible to e.g. scale up a frame, or compose the image into a larger
> buffer.
>
> For video receivers this issue doesn't exist: there the size of the incoming
> video is decided by S_STD or S_DV_TIMINGS, but no equivalent exists for sensors.
>
> I propose that a new selection target is added: V4L2_SEL_TGT_FRAMESIZE.

V4L2_SEL_TGT_FRAMESIZE seems a bit imprecise to me, perhaps:
V4L2_SEL_TGT_SENSOR(_SIZE) or V4L2_SEL_TGT_SOURCE(_SIZE) ? The latter might
be a bit weird when referred to the subdev API though, not sure if defining
it as valid only on V4L2 device nodes makes any difference.

> However, this leads to another problem: the current S_FMT behavior is that
> it implicitly sets the framesize. That behavior we will have to keep, otherwise
> applications will start to behave differently.
>
> I have an idea on how to solve that, but the solution is related to the second
> problem I found:
>
> When you set a new format size, then the compose rectangle must be set to the
> new format size as well since that has always been the behavior in the past
> that applications have come to expect.
>
> But this makes certain operations impossible to execute: if a driver can't
> scale, then you can never select a new format size larger than the current
> (possibly cropped) frame size, even though you would want to compose the
> unscaled image into such a larger buffer.
>
> So what is the behavior that I would expect from drivers?
>
> 1) After calling S_STD, S_DV_TIMINGS or S_SELECTION(V4L2_SEL_TGT_FRAMESIZE)
> the cropping, composing and format parameters are all adjusted to support the
> new input video size (typically they are all set to the new size).
>
> 2) After calling S_CROP/S_SELECTION(CROP) the compose and format parameters are all
> adjusted to support the new crop rectangle.
>
> 3) After calling S_SEL(COMPOSE) the format parameters are adjusted.
>
> 4) Calling S_FMT validates the format parameters to support the compose
> rectangle.

Then, if one wants to change the COMPOSE rectangle while streaming, step 3)
would limit possible COMPOSE rectangle to the current format only ?

> However, today step 4 does something different: the compose rectangle will be
> adjusted to the format size (and in the case of a sensor supporting different
> framesizes the whole pipeline will be adjusted).
>
> The only way I see that would solve this (although it isn't perfect) is to
> change the behavior of S_FMT only if the selection API was used before by the
> filehandle. The core can keep easily keep track of that. When the application
> calls S_FMT and no selection API was used in the past by that filehandle, then
> the core will call first S_SELECTION(V4L2_SEL_TGT_FRAMESIZE). If that returns
> -EINVAL, then it will call S_SELECTION(V4L2_SEL_TGT_COMPOSE). Finally it will
> call S_FMT. Note that a similar sequence is needed for the display case.

Sounds sane to me.

> This means that a driver supporting the selection API can implement the logical
> behavior and the core will implement the historically-required illogical part.
>
> So the fix for this would be to add a new selection target and add compatibility
> code to the v4l2-core.
>
> With that in place I can easily add crop/compose support to vivi.
>
> One area of uncertainty is how drivers currently implement S_FMT: do they reset
> any cropping done before? They should keep the crop rectangle according to the
> spec (well, it is implied there). Guennadi, what does soc_camera do?
>
> Sylwester, I am also looking at exynos4-is/fimc-lite.c. I do see that setting
> the compose rectangle will adjust it to the format size instead of the other
> way around, but I can't tell if setting the format size will also adjust the
> compose rectangle if that is now out-of-bounds of the new format size.

Hmm, yes, adjusting compose rectangle to the format size should be fixed in
this driver, especially given that this video device can't be used 
standalone,
only as a part of a pipeline including at least the FIMC-LITE and an image
sensor subdev. And no, currently S_FMT doesn't adjust the compose 
rectangle's
size, as it is always equal to the size of the crop rectangle on the camera
interface input (FIMC-LITE.n subdev's sink pad crop rectangle size or 
source
pad format of this subdev). This is a bug, because the driver can be in an
incorrect state for certain configuration sequence in user space. But
I don't want to be setting any FRAMESIZE on FIMC-LITE video node, it 
belongs
to the subdev API (the subdev sink pad format). This would mean the rule of
configuring the video pipeline from data source to video node is not
conformed to. All that is needed in this case is just to compose the image
rectangle, of which size is determined by the FIMC-LITE.n subdev source pad
format, onto whatever location in the memory buffer set up with 
VIDIOC_S_FMT.
I guess this is not a problem WRT your approach as long as this driver
doesn't implement V4L2_SEL_TGT_FRAMESIZE/SENSOR selection target.

The selection API documentation currently says that the
V4L2_SEL_TGT_COMPOSE_BOUNDS rectangle is set by VIDIOC_S_FMT:

"The composing targets refer to a memory buffer. The limits of composing
coordinates are obtained using V4L2_SEL_TGT_COMPOSE_BOUNDS. All coordinates
are expressed in pixels. The rectangle's top/left corner must be located at
position (0,0) . The width and height are equal to the image size set by
VIDIOC_S_FMT."

So I understand it as one first must do S_FMT to define COMPOSE rectangle's
bounds and then COMPOSE rectangle should be set, however it's not said
explicitly.

Additionally, when a device is streaming and compose rectangle is adjusted
the format size cannot be changed. I guess the solution is simply to adjust
COMPOSE rectangle to the current format in such case.

Thanks,
Sylwester

[1] http://linuxtv.org/downloads/v4l-dvb-apis/selection-api.html
