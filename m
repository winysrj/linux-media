Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4782 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbZDTTRR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 15:17:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc-camera to v4l2-subdev conversion
Date: Mon, 20 Apr 2009 21:17:13 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.0904071122511.5155@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0904071122511.5155@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904202117.13348.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Sorry for the late reply, but this got buried beneath a pile of other 
emails...

On Thursday 16 April 2009 21:20:38 Guennadi Liakhovetski wrote:
> Hi Hans,
>
> I have so far partially converted a couple of example setups, namely the
> i.MX31-based pcm037/pcm970 and PXA270-based pcm027/pcm990 boards.
>
> Partially means, that I use v4l2_i2c_new_subdev() to register new cameras
> and v4l2_device_register() to register hosts, I use some core and video
> operations, but there are still quite a few extra bonds that tie camera
> drivers and soc-camera core, that have to be broken. The current diff is
> at http://download.open-technology.de/testing/20090416-4.gitdiff,
> although, you, probably, don't want to look at it:-)
>
> A couple of minor general remarks first:
>
> Shouldn't v4l2_device_call_until_err() return an error if the call is
> unimplemented?

It's my opinion that in general if no subdev needs to handle a particular 
call, then that's OK. I'm assuming that if it is wrong, then the device 
won't work anyway.

> There's no counterpart to v4l2_i2c_new_subdev() in the API, so one is
> supposed to call i2c_unregister_device() directly?

You don't need to call that. It's done automatically when the i2c adapter is 
deleted. It might be that in the future this will have to be called, but if 
so then it will go through v4l2_device_unregister.

> We'll have to extend v4l2_subdev_video_ops with [gs]_crop.

No problem. Just add it.

> Now I'm thinking about how best to break those remaining ties in
> soc-camera. The remaining bindings that have to be torn are in
> struct soc_camera_device. Mostly these are:
>
> 1. current geometry and geometry limits - as seen on the canera host -
> camera client interfase. I think, these are common to all video devices,
> so, maybe we could put them meaningfully in a struct video_data,
> accessible for both v4l2 subdevices and devices - one per subdevice?

See notes under 3.

> 2. current exposure and gain. There are of course other video parameters
> similar to these, like gamma, saturation, hue... Actually, these are only
> needed in the sensor driver, the only reason why I keep them globally
> available it to reply to V4L2_CID_GAIN and V4L2_CID_EXPOSURE G_CTRL
> requests. So, if I pass these down to the sensor drivers just like all
> other control requests, they can be removed from soc_camera_device.

Agreed.

> 3. format negotiation. This is a pretty important part of the soc-camera
> framework. Currently, sensor drivers provide a list of supported pixel
> formats, based on it camera host drivers build translation tables and
> calculate user pixel formats. I'd like to preserve this functionality in
> some form. I think, we could make an optional common data block, which,
> if available, can be used also for the format negotiation and conversion.
> If it is not available, I could just pass format requests one-to-one down
> to sensor drivers.
>
> Maybe a more universal approach would be to just keep "synthetic" formats
> in each camera host driver. Then, on any format request first just
> request it from the sensor trying to pass it one-to-one to the user. If
> this doesn't work, look through the possible conversion table, if the
> requested format is found among output formats, try to request all input
> formats, that can be converted to it, one by one from the sensor. Hm...

Both 1 and 3 touch on the basic reason for creating the framework: one can 
build on it to move common driver code into framework. But the order in 
which I prefer to do this is to first move everything over to the framework 
first, before starting on refactoring drivers. The reason is that that way 
to have a really good overview of what everyone is doing.

My question is: is it possible without too much effort to fix 1 and 3 
without modifying the framework? It will be suboptimal, I know, but it will 
also be faster. The alternative is to move support for this into the core 
framework, but that will mean a lot more work because then I want to do it 
right the first time, which means going through all the existing drivers, 
see how they do it, see how the framework can assist with that, and then 
come up with a good solution.

> 4. bus parameter negotiation. Also an important thing. Should do the
> same: if available - use it, if not - use platform-provided defaults.

This is something for which I probably need to make changes. I think it is 
reasonable to add something like a s_bus_param call for this.

An alternative is to use platform_data in board_info. This will mean an 
extra argument to the new_subdev functions. And since this is only 
available for 2.6.26 and up it is not as general.

> I think, I just finalise this partial conversion and we commit it,
> because if I keep it locally for too long, I'll be getting multiple merge
> conflicts, because this conversion also touches platform code... Then,
> when the first step is in the tree we can work on breaking the remaining
> bonds.

Agreed. Do it step by step, that makes it much easier to work with.

Regards,

	Hans

> Ideas? Comments?
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
