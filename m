Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54676 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1EPHUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 03:20:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API
Date: Mon, 16 May 2011 09:21:28 +0200
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@maxwell.research.nokia.com
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com> <201105131443.09458.laurent.pinchart@ideasonboard.com> <201105141250.33075.hverkuil@xs4all.nl>
In-Reply-To: <201105141250.33075.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105160921.29283.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday 14 May 2011 12:50:32 Hans Verkuil wrote:
> On Friday, May 13, 2011 14:43:08 Laurent Pinchart wrote:
> > On Saturday 07 May 2011 13:52:25 Hans Verkuil wrote:
> > > On Thursday, May 05, 2011 11:39:54 Tomasz Stanislawski wrote:

[snip]

> > > > Applications set V4L2_SEL_TRY flag in v4l2_selection::flags to
> > > > prevent a driver from applying selection configuration to hardware.
> > > 
> > > I mentioned this before but I am very much opposed to this flag. It is
> > > inconsistent with the TRY_FMT and TRY_EXT_CTRLS ioctls. Note that in
> > > video_ioctl2 it should be just one function with 'try' boolean
> > > argument. It has always been a mistake that the try and set functions
> > > were separated in the driver code IMHO.
> > > 
> > > I know that the subdev ioctls do not have a try version, but it is not
> > > quite the same in that those try functions actually store the try
> > > information.
> > 
> > That's exactly why the subdevs pad-level API has a try flag instead of a
> > try operation, and that's why g/s_selection on subdevs will be done with
> > a try flag.
> > 
> > As for the video device node API, I won't oppose a TRY ioctl, as long as
> > we can guarantee there will never be dependencies between the selection
> > rectangles and other parameters (or between the different selection
> > rectangles). If the crop rectangle depends on the compose rectangle for
> > instance, how can you implement a TRY ioctl to try a crop rectangle for
> > a specific compose rectangle, without modifying the active compose
> > rectangle first ?
> 
> In that case the TRY would adjust the crop so that it works with the
> current compose rectangle.

And how do you try both crop and compose settings without modifying the active 
configuration ? That's not possible, and I think it's a bad API limitation.

> But this is just one more example of our lack of proper support for pipeline
> setup. It doesn't really matter whether this is at the subdev level or at
> the driver level, both have the same problems.
> 
> This requires a brainstorm session to work out.
> 
> > > This is something we need to look into more carefully. I am slowly
> > > becoming convinced that we need some sort of transaction-based
> > > configuration for pipelines.
> > 
> > This RFC is about video device node configuration, not pipelines. For
> > pipelines I think we'll need a transaction-based API. For video device
> > nodes, I'm still unsure. As stated above, if we have multiple parameters
> > that depend on each other, how do we let the user try them without
> > changing the active configuration ?
> 
> Cropping/scaling/composing IS a pipeline. Until recently the V4L2 device
> node API was sufficient to setup the trivial pipelines that most V4L2
> consumer devices have. But with the more modern devices it starts to show
> its limitations.

It's still a simple pipeline, and I think we should aim at making the V4L2 
device node API useful to configure this kind of pipeline. The selection API 
is a superset of the crop API, applications should be able to use it to 
replace the crop API in the long term.

> The whole 'try' concept we had for a long time needs to be re-examined.

I agree.

> As you remember, I was never satisfied with the subdev 'try' approach
> either, but I never could come up with a better alternative.
> 
> > > Regardless of how such a scheme should work, one thing that I believe
> > > is missing in the format ioctls (both on the video and subdev level)
> > > is a similar concept like the flags in this proposal. It would be
> > > quite useful if you could indicate that the desired WxH has to be
> > > exact or can be larger or smaller. It would certainly simplify the
> > > interaction between the selection and scaling.
> > > 
> > > > On success field v4l2_selection::r is filled with adjusted rectangle.
> > > > 
> > > > Return value
> > > > 
> > > > 	On success 0 is returned, on error -1 and the errno variable is set
> > > > 	
> > > >         appropriately:
> > > > 	EINVAL - incorrect buffer type, incorrect/not supported target
> > > > 
> > > > 4. Flags
> > > > 4.1. Hints
> > > > 
> > > > The field v4l2_selection::flags is used to give a driver a hint about
> > > > coordinate adjustments. The set of possible hint flags was reduced to
> > > > two entities for practical reasons. The flag V4L2_SEL_SIZE_LE is a
> > > > suggestion for the driver to decrease or keep size of a rectangle. 
> > > > The flags V4L2_SEL_SIZE_GE imply keeping or increasing a size of a
> > > > rectangle.
> > > > 
> > > > By default, lack of any hint flags indicate that driver has to choose
> > > > selection coordinates as close as possible to the ones passed in
> > > > v4l2_selection::r field.
> > > > 
> > > > Setting both flags implies that the driver is free to adjust the
> > > > rectangle.  It may return even random one however much more
> > > > encouraged behaviour would be adjusting coordinates in such a way
> > > > that other stream parameters are left intact. This means that the
> > > > driver should avoid changing a format of an image buffer and/or any
> > > > other controls.
> > > 
> > > This makes no sense to me. It sounds like this is what flags == 0
> > > should do.
> > > 
> > > I would expect that if both flags are specified that that would equal
> > > SEL_SIZE_EQ. I.E., the rectangle has to be exact size-wise, and should
> > > be as close as possible to the original position.
> > 
> > What happens if that's not possible ? The ioctl should never return an
> > error,
> 
> Why not? If I tell the driver that I want exactly WxH, then I see no reason
> why it can't return an error. An application might use that result to
> switch to a different resolution, for example. E.g., the application tries
> 640x480 first, that fails, then it tries 320x240 (or whatever).

To make the API more consistent. Applications ask drivers for specific 
settings (including optional hints), and drivers return what they've been able 
to configure. It's then the application's responsibility to check the return 
values and act upon it. Drivers shouldn't return an error when setting 
formats/selections, except if the given arguments can't be understood.

[snip]

> > > > All cropcap fields except pixel aspect are supported in new API. I
> > > > noticed that there was discussion about pixel aspect and I am not
> > > > convinced that it should be a part of the cropping API. Please refer
> > > > to the post:
> > > > http://lists-archives.org/video4linux/22837-need-vidioc_cropcap-clari
> > > > fica tion.html
> > > 
> > > Yeah, what are we going to do about that? I agree that it does not
> > > belong here. But we can't sweep it under the carpet either.
> > > 
> > > The pixel aspect ratio is typically a property of the current input or
> > > output video format (either a DV preset or a PAL/NTSC STD). For DV
> > > presets we could add it to struct v4l2_dv_enum_presets and we could do
> > > the same for STD formats by adding it to struct v4l2_standard.
> > 
> > Cropping and composing doesn't modify the pixel aspect ratio, so I agree
> > it doesn't belong there.
> > 
> > > This would fail for sensors, though, since there the chosen sensor
> > > framesize is set through S_FMT. (This never quite made sense to me,
> > > though, from a V4L2 API perspective). I'm not sure whether we can
> > > always assume 1:1 pixel ratio for sensors. Does anyone know?
> > 
> > Most of the time I suppose so, but I wouldn't be surprise if some exotic
> > sensors had non-square pixel aspect ratios.
> 
> Would it make sense to add the pixel ratio to struct v4l2_frmsizeenum?
> 
> And what about adding a VIDIOC_G/S_FRAMESIZE to select a sensor resolution?
> 
> This would typically be one of the discrete framesizes supported by a
> sensor through binning/skipping. If there is also a scaler on the sensor,
> then that is controlled through S_FMT. For video it is S_FMT that controls
> the scaler (together with S_CROP at the moment), but the source resolution
> is set through S_STD/S_DV_PRESET/S_DV_TIMINGS. It always felt very
> inconsistent to me that there is no equivalent for sensors, even though
> you can enumerate all the available framesizes (just as you can with
> ENUMSTD and ENUM_DV_PRESETS).

Let's take one step back here.

We started with the V4L2 device node API to control (more or less) simple 
devices. Device became more complex, and we created a new MC API (along with 
the subdev pad-level API) to configure complex pipelines. The V4L2 device node 
API still lives, and we want to enhance it to configure medium complexity 
devices.

Before going much further, I think we need to define what a medium complexity 
device is and where we put the boundary between devices that can be configured 
with the V4L2 device node API, and devices that require the MC API.

I believe this shouldn't be too difficult. What we need to do is create a 
simple virtual pipeline that supports cropping, scaling and composing, and map 
the V4L2 device node API to that pipeline configuration. Devices that map to 
that pipeline could then use the V4L2 device node API only, with clearly 
defined semantics.

[snip]

> > > >   * resolution of an image combined with support for
> > > >   VIDIOC_S_MULTISELECTION
> > > >   
> > > >     allows to pass a triple format/crop/compose sizes in a single
> > > >     ioctl
> > > 
> > > I don't believe S_MULTISELECTION will solve anything. Specific
> > > use-cases perhaps, but not the general problem of setting up a
> > > pipeline. I feel another brainstorm session coming to solve that. We
> > > never came to a solution for it in Warsaw.
> > 
> > Pipelines are configured on subdev nodes, not on video nodes, so I'm also
> > unsure whether multiselection support would really be useful.
> >
> > If we decide to implement multiselection support, we might as well use
> > that only. We would need a multiselection target bitmask, so selection
> > targets should all be < 32.
> > 
> > Thinking some more about it, does it make sense to set both crop and
> > compose on a single video device node (not talking about mem-to-mem,
> > where you use the type to multiplex input/output devices on the same
> > node) ? If so, what would the use cases be ?
> > 
> > Should all devices support the selection API, or only the simple ones
> > that don't expose a user-configurable pipeline to userspace through the
> > MC API ? The proposed API looks good to me, but before acking it I'd
> > like to clarify how (if at all) this will interact with subdev pad-level
> > configuration on devices that support that. My current feeling is that
> > video device nodes for such devices should only be used for video
> > streaming. All parameters should be configured directly on the subdevs.
> > Application might still need to call S_FMT in order to be able to
> > allocate buffers though.
> 
> This comes back to how we want to implement backwards compatibility for
> existing applications. There must be a way for 'standard' apps to work
> with complex drivers for specific video nodes (the mc would probably mark
> those as a 'DEFAULT' node).
> 
> I'd say that there are roughly two options: either implement the selection
> etc. APIs for those video nodes only in the driver, letting the driver set
> up the subdev pipeline, or do it via libv4l SoC-specific plugins.
> 
> In my opinion we need to finish the pipeline configuration topic we started
> in Warsaw before we can finalize this RFC. This RFC clearly demonstrates
> that we have inconsistencies and deficiencies in our API that need to be
> solved first. When we have done that, then I expect that this selection
> API will be easy to finalize.

-- 
Regards,

Laurent Pinchart
