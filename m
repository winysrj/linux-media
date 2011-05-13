Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34246 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759119Ab1EMMmQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 08:42:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API
Date: Fri, 13 May 2011 14:43:08 +0200
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@maxwell.research.nokia.com
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com> <201105071352.25515.hverkuil@xs4all.nl>
In-Reply-To: <201105071352.25515.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105131443.09458.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Tomasz and Hans,

First of all, apologies for the late reply.

On Saturday 07 May 2011 13:52:25 Hans Verkuil wrote:
> On Thursday, May 05, 2011 11:39:54 Tomasz Stanislawski wrote:
> > Hello everyone,
> > 
> > This patch-set introduces new ioctls to V4L2 API. The new method for
> > configuration of cropping and composition is presented.
> > 
> > This is the third version of extended crop/compose RFC. List of applied
> > changes:
> > - reduced number of hints and its semantics to be more practical and less
> >   restrictive
> > - combined EXTCROP and COMPOSE ioctls into VIDIOC_{S/G}_SELECTION
> > - introduced crop and compose targets
> > - introduced try flag that prevents passing configuration to a hardware
> > - added usage examples
> > 
> > ----------------
> >       RFC
> > ----------------
> > 
> > 1. Introduction
> > 
> > There is some confusion in understanding of cropping in current version
> > of V4L2. In a case of Capture Devices, cropping refers to choosing only
> > a part of input data stream, and processing it, and storing it in a
> > memory buffer. The buffer is fully filled by data. There is now generic
> > API to choose only a part of an image buffer for being updated by
> > hardware.
> > 
> > In case of OUTPUT devices, the whole content of a buffer is passed to
> > hardware and to output display. Cropping means selecting only a part of
> > an output display/signal. It is not possible to choose only a part of
> > the image buffer to be processed.
> > 
> > The overmentioned flaws in cropping API were discussed in post:
> > http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/2
> > 8945
> > 
> > A solution was proposed during brainstorming session in Warsaw.
> > 
> > At first, the distinction between cropping and composing was stated. The
> > cropping operation means choosing only part of input data by bounding it
> > by a cropping rectangle. All data outside cropping area must be
> > discarded. On the other hand, composing means pasting processed data
> > into rectangular part of data sink. The sink may be output device, user
> > buffer, etc.
> > 
> > Two concepts were introduced:
> > 
> > Cropping rectangle: a) for input devices, a part of input data selected
> > by hardware from input stream and pasted to an image buffer b) for
> > output devices, a part of image buffer to be passed by hardware to
> > output stream
> > 
> > Composing rectangle: a) for input devices, a part of a image buffer that
> > is filled by hardware b) for output devices, an area on output device
> > where image is inserted
> > 
> > The configuration of composing/cropping areas is the subject of this
> > document.
> > 
> > 2. Data structures.
> > 
> > The structure v4l2_crop used by current API lacks any place for further
> > extensions. Therefore new and more generic structure is proposed.
> > 
> > struct v4l2_selection {
> > 
> > 	u32 type;
> > 	u32 target;
> > 	u32 flags;
> > 	struct v4l2_rect r;
> > 	u32 reserved[9];
> > 
> > };
> > 
> > Where,
> > type	 - type of buffer queue: V4L2_BUF_TYPE_VIDEO_CAPTURE,
> > 
> >            V4L2_BUF_TYPE_VIDEO_OUTPUT, etc.
> > 
> > target   - choose one of cropping/composing rectangles
> > flags	 - control over coordinates adjustments
> > r	 - selection rectangle
> > reserved - place for further extensions, adjust struct size to 64 bytes
> > 
> > 3. Crop/Compose ioctl.
> > New ioctls are added to V4L2.
> > 
> > Name
> > 
> > 	VIDIOC_G_SELECTION - get crop/compose rectangles from a driver
> > 
> > Synopsis
> > 
> > 	int ioctl(fd, VIDIOC_G_SELECTION, struct v4l2_selection *s)
> > 
> > Description:
> > 	The ioctl is used to query selection rectangles. Currently, it involves
> > 
> > only cropping and composing ones. To query cropping rectangle application
> > must fill selection::type with respective stream type from
> > V4L2_BUF_TYPE_VIDEO_* family.  Next, v4l2_selection::target must be
> > field with desired target type. Please refer to section Target for
> > details. On success the rectangle is returned in v4l2_selection::r
> > field. Field v4l2_selection::flags and v4l2_selection::reserved are
> > ignored and they must be filled with zeros.
> > 
> > Return value
> > 
> > 	On success 0 is returned, on error -1 and the errno variable is set
> > 	
> >         appropriately:
> > 	EINVAL - incorrect buffer type, incorrect/not supported target
> 
> Looks fine.
> 
> > -----------------------------------------------------------------
> > 
> > Name
> > 
> > 	VIDIOC_S_SELECTION - set cropping rectangle on an input of a device
> > 
> > Synopsis
> > 
> > 	int ioctl(fd, VIDIOC_S_SELECTION, struct v4l2_selection *s)
> > 
> > Description:
> > 	The ioctl is used to configure a selection rectangle.  An application
> > 
> > fills v4l2_selection::type field to specify an adequate stream type. 
> > Next, the v4l2_selection::field target is filled. Basically, an
> > application choose between cropping or composing rectangle. Please refer
> > to section Targets for more details. Finally, structure
> > v4l2-selection::r is filled with suggested coordinates. The coordinates
> > are expressed in driver-dependant units.

What kind of driver-dependant units do you think will be used in practice ?

> > The only exception are rectangles for images in raw formats, which
> > coordinates are expressed in pixels.
> > 
> > Drivers are free to adjust selection rectangles on their own. The
> > suggested behaviour is to choose a rectangle with the closest
> > coordinates to desired ones passed in v4l2_selection::r. However,
> > drivers are allowed to ignore suggested it completely. A driver may even
> > return a fixed and immutable rectangle every call. If there is an
> > alternative between multiple, then a driver may use hint flags. Please
> > refer to section Hints. Hints are optional but it is strongly encouraged
> > to use them.
> > 
> > Applications set V4L2_SEL_TRY flag in v4l2_selection::flags to prevent a
> > driver from applying selection configuration to hardware.
> 
> I mentioned this before but I am very much opposed to this flag. It is
> inconsistent with the TRY_FMT and TRY_EXT_CTRLS ioctls. Note that in
> video_ioctl2 it should be just one function with 'try' boolean argument. It
> has always been a mistake that the try and set functions were separated in
> the driver code IMHO.
> 
> I know that the subdev ioctls do not have a try version, but it is not
> quite the same in that those try functions actually store the try
> information.

That's exactly why the subdevs pad-level API has a try flag instead of a try 
operation, and that's why g/s_selection on subdevs will be done with a try 
flag.

As for the video device node API, I won't oppose a TRY ioctl, as long as we 
can guarantee there will never be dependencies between the selection 
rectangles and other parameters (or between the different selection 
rectangles). If the crop rectangle depends on the compose rectangle for 
instance, how can you implement a TRY ioctl to try a crop rectangle for a 
specific compose rectangle, without modifying the active compose rectangle 
first ?

> This is something we need to look into more carefully. I am slowly becoming
> convinced that we need some sort of transaction-based configuration for
> pipelines.

This RFC is about video device node configuration, not pipelines. For 
pipelines I think we'll need a transaction-based API. For video device nodes, 
I'm still unsure. As stated above, if we have multiple parameters that depend 
on each other, how do we let the user try them without changing the active 
configuration ?

> Regardless of how such a scheme should work, one thing that I believe is
> missing in the format ioctls (both on the video and subdev level) is a
> similar concept like the flags in this proposal. It would be quite useful
> if you could indicate that the desired WxH has to be exact or can be
> larger or smaller. It would certainly simplify the interaction between the
> selection and scaling.
> 
> > On success field v4l2_selection::r is filled with adjusted rectangle.
> > 
> > Return value
> > 
> > 	On success 0 is returned, on error -1 and the errno variable is set
> > 	
> >         appropriately:
> > 	EINVAL - incorrect buffer type, incorrect/not supported target
> > 
> > 4. Flags
> > 4.1. Hints
> > 
> > The field v4l2_selection::flags is used to give a driver a hint about
> > coordinate adjustments. The set of possible hint flags was reduced to two
> > entities for practical reasons. The flag V4L2_SEL_SIZE_LE is a suggestion
> > for the driver to decrease or keep size of a rectangle.  The flags
> > V4L2_SEL_SIZE_GE imply keeping or increasing a size of a rectangle.
> > 
> > By default, lack of any hint flags indicate that driver has to choose
> > selection coordinates as close as possible to the ones passed in
> > v4l2_selection::r field.
> > 
> > Setting both flags implies that the driver is free to adjust the
> > rectangle.  It may return even random one however much more encouraged
> > behaviour would be adjusting coordinates in such a way that other stream
> > parameters are left intact. This means that the driver should avoid
> > changing a format of an image buffer and/or any other controls.
> 
> This makes no sense to me. It sounds like this is what flags == 0 should
> do.
> 
> I would expect that if both flags are specified that that would equal
> SEL_SIZE_EQ. I.E., the rectangle has to be exact size-wise, and should be
> as close as possible to the original position.

What happens if that's not possible ? The ioctl should never return an error, 
it should modify the rectangle instead. Setting boths flags would be then be 
identical to setting none. I don't think we should allow the user to set both 
hint flags.

> Otherwise I like these flags.

So do I :-)

> > The hint flag V4L2_SEL_SIZE_GE may be useful in a following scenario.
> > There is a sensor with a face detection feature. An application receives
> > information about a position of a face via V4L2 controls. Assume that
> > the camera's pipeline is capable of scaling and cropping. The task it to
> > grab only a part of an image that contains a face. In such a case, the
> > application would try to prevent the driver from decreasing the
> > rectangle, thus cutting off part of a face. It is achieved by passing
> > V4L2_SEL_SIZE_GE for a cropping target.
> > 
> > The hint V4L2_SEL_SIZE_LE is useful when data from a sensor are pasted
> > directly to an application window on a framebuffer. It is expected that
> > the image would not be inserted outside bounds of the window. Passing
> > V4L2_SEL_SIZE_LE for a composing target would inform driver not to
> > exceed window's bounds.
> > 
> > Hints definitions:
> > 
> > #define V4L2_SEL_SIZE_GE	0x00000001
> > #define V4L2_SEL_SIZE_LE	0x00000002
> > 
> > Feel free to add a new flag if necessary.

You should make it clear that drivers must try to keep the rectangle center 
position as close to the requested one, regardless of hint flags.

> > 4.2. Try flag.
> > A new flag was introduced in order to avoid adding to many new ioctl to
> > V4L2 API.  The flag name if V4L2_SEL_TRY. It is or-ed info field
> > v4l2_selection::flags.  The flag can only be used with VIDIOC_S_SELECTION
> > ioctl. It implies that the driver should only adjust passed rectangle.
> > The rectangle must not be passed to hardware.
> > 
> > #define V4L2_SEL_TRY		0x80000000
> > 
> > Feel free to add a new flag if necessary.
> 
> As mentioned above, I still do not like this at all.
> 
> > 5. Targets
> > The idea of targets was introduced for to reduce the number of new ioctls
> > and to increase their flexibility. Both compose and crop rectangles are
> > types of selection rectangles that describe a pipeline. They are very
> > similar, the only difference is that one touches data source, another
> > touches data sink. Therefore crop and compose rectangles are only
> > distinguished by a target type. The field v4l2_selection::target is used
> > to choose a target.
> > 
> > Following targets are added:
> > 
> > V4L2_SEL_CROP_ACTIVE		= 0
> > V4L2_SEL_CROP_DEFAULT		= 1
> > V4L2_SEL_CROP_BOUNDS		= 2
> > V4L2_SEL_COMPOSE_ACTIVE		= 16 + 0
> > V4L2_SEL_COMPOSE_DEFAULT	= 16 + 1
> > V4L2_SEL_COMPOSE_BOUNDS		= 16 + 2
> > 
> > The gap between V4L2_SEL_CROP_BOUNDS and V4L2_SEL_COMPOSE_ACTIVE gives
> > place for further extensions.
> 
> Just 16? I'd go with 256. We got 32 bits to play with here :-)
> 
> > The within cropping/composing target one may use auxiliary rectangles
> > other than a normal cropping/composing rectangle.  Proposed auxiliary
> > targets are: - active - an area that is processed by hardware
> > - default - is the suggested active rectangle that covers the "whole
> > picture" - bounds - the limits that active rectangle cannot exceed
> > 
> > Auxiliary target default and bounds can be only used with
> > VIDIOC_G_SELECTION. This functionality was added to simulate
> > VIDIOC_CROPCAP ioctl.
> > 
> > An application uses V4L2_SEL_CROP_ACTIVE to setup cropping rectangle. 
> > Target V4L2_SEL_COMPOSE_ACTIVE is used to setup composing rectangle.
> 
> OK, I'm giving up my resistance to having default and bounds targets. I
> have to admit that it looks clean.
> 
> One thing I think would be helpful though, is if the target name would tell
> you whether it is a read-only or a read-write target. It might also be
> helpful if the IDs of the read-only targets would set some read-only bit.
> That would make it easy for video_ioctl2 to test for invalid targets for
> S_SELECTION.
> 
> Not sure about the naming though:
> 
> V4L2_SEL_RO_CROP_DEFAULT
> V4L2_SEL_CROP_RO_DEFAULT
> V4L2_SEL_CROP_DEFAULT_RO
> 
> None looks right. A read-only bit might be sufficient as it would clearly
> indicate in the header that that target is a read-only target.

What if some future hardware have setable default or bounds rectangles ? I 
don't know what that would be used for, it's just in case :-)

> > All cropcap fields except pixel aspect are supported in new API. I
> > noticed that there was discussion about pixel aspect and I am not
> > convinced that it should be a part of the cropping API. Please refer to
> > the post:
> > http://lists-archives.org/video4linux/22837-need-vidioc_cropcap-clarifica
> > tion.html
> 
> Yeah, what are we going to do about that? I agree that it does not belong
> here. But we can't sweep it under the carpet either.
> 
> The pixel aspect ratio is typically a property of the current input or
> output video format (either a DV preset or a PAL/NTSC STD). For DV presets
> we could add it to struct v4l2_dv_enum_presets and we could do the same
> for STD formats by adding it to struct v4l2_standard.

Cropping and composing doesn't modify the pixel aspect ratio, so I agree it 
doesn't belong there.

> This would fail for sensors, though, since there the chosen sensor
> framesize is set through S_FMT. (This never quite made sense to me,
> though, from a V4L2 API perspective). I'm not sure whether we can always
> assume 1:1 pixel ratio for sensors. Does anyone know?

Most of the time I suppose so, but I wouldn't be surprise if some exotic 
sensors had non-square pixel aspect ratios.

> > Feel free to add new targets if necessary.
> > 
> > 6. Usage examples.
> > 
> > 6.1. Getting default rectangle of composing for video output.
> > 
> > 	struct v4l2_selection sel = {
> > 	
> > 		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
> > 		.target = V4L2_SEL_COMPOSE_DEFAULT,
> > 	
> > 	};
> > 	ret = ioctl(fd, VIDIOC_G_SELECTION, &sel);
> > 
> > 6.2. Obtain crop from capture device and use it as composing area for an
> > image buffer in order to avoid scaling.
> > 
> > 	struct v4l2_selection sel = {
> > 	
> > 		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> > 		.target = V4L2_SEL_CROP_ACTIVE,
> > 	
> > 	};
> > 	ret = ioctl(fd, VIDIOC_G_SELECTION, &sel);
> > 	... /* some error checking */
> > 	/* using input crop as a composing rectangle for the image */
> > 	sel.target = V4L2_SEL_COMPOSE_ACTIVE;
> > 	ioctl(fd, VIDIOC_S_SELECTION, &sel);
> > 
> > 6.3. Setting a composing area on output of size of AT MOST half of limit
> > placed at a center of a display.
> > 
> > 	struct v4l2_selection sel = {
> > 	
> > 		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
> > 		.target = V4L2_SEL_COMPOSE_BOUNDS,
> > 	
> > 	};
> > 	struct v4l2_rect r;
> > 	ret = ioctl(fd, VIDIOC_G_SELECTION, &sel);
> > 	/* setting smaller compose rectangle */
> > 	r.width = sel.r.width / 2;
> > 	r.height = sel.r.height / 2;
> > 	r.left = sel.r.width / 4;
> > 	r.top = sel.r.height / 4;
> > 	sel.r = r;
> > 	sel.flags = V4L2_SEL_SIZE_LE;
> > 	ret = ioctl(fd, VIDIOC_S_SELECTION, &sel);
> > 
> > 6.4. Trying to set crop 150 x 100 at coordinates (200,300) on a sensor
> > array. Inform the driver that the actual crop should contain desired
> > rectangle. The hardware configuration must not change.
> > 
> > 	struct v4l2_selection sel = {
> > 	
> > 		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> > 		.target = V4L2_SEL_CROP_ACTIVE,
> > 		.flags = V4L2_SEL_SIZE_GE | V4L2_SEL_TRY,
> > 		.r = {
> > 		
> > 			.left = 200,
> > 			.top = 300,
> > 			.width = 150,
> > 			.height = 100,
> > 		
> > 		},
> > 	
> > 	};
> > 	ret = ioctl(fd, VIDIOC_S_SELECTION, &sel);
> 
> It still doesn't look right to me, not to have a TRY_SELECTION. You really
> have to look carefully at the code to notice that you are not actually
> changing the selection but just trying it. I'd see that immediately if the
> ioctl would read 'VIDIOC_TRY_SELECTION'.
> 
> > 7. Possible improvements and extensions.
> > - add subpixel resolution
> > 
> >   * hardware is often capable of subpixel processing by passing
> >   denominator of
> >   
> >     rectangle's coordinates in one of v4l2_selection reserved fields
> > 
> > - introduce more hint
> > 
> >   * add {RIGHT/LEFT/TOP/BOTTOM/HEIGHT/WIDTH}_{LE/GE} flags to give more
> >   
> >     flexibility
> >   
> >   * split SIZE_GE to LEFT_LE | RIGHT_GE | TOP_LE | BOTTOM_GE
> >   * split SIZE_LE to LEFT_GE | RIGHT_LE | TOP_GE | BOTTOM_LE
> > 
> > - implement VIDIOC_S_MULTISELECTION
> > 
> >   * allow to configure multiple rectangles simultaneously
> > 
> > - add image size of new target
> > 
> >   * remove setup of width and height of image buffer from S_FMT, use
> >   S_SELECTION
> >   
> >     with targets:
> >     + V4L2_SEL_FORMAT_ACTIVE - active format
> >     + V4L2_SEL_FORMAT_BOUNDS - maximal resolution of an image
> >     + V4L2_SEL_FORMAT_DEFAULT - optimal suggestion about

In that case we might need to rename selection to something else :-)

> Interesting idea. Not sure what the implications are, though.

Breaking API/ABI ?

> >   * resolution of an image combined with support for
> >   VIDIOC_S_MULTISELECTION
> >   
> >     allows to pass a triple format/crop/compose sizes in a single ioctl
> 
> I don't believe S_MULTISELECTION will solve anything. Specific use-cases
> perhaps, but not the general problem of setting up a pipeline. I feel
> another brainstorm session coming to solve that. We never came to a
> solution for it in Warsaw.

Pipelines are configured on subdev nodes, not on video nodes, so I'm also 
unsure whether multiselection support would really be useful.

If we decide to implement multiselection support, we might as well use that 
only. We would need a multiselection target bitmask, so selection targets 
should all be < 32.

Thinking some more about it, does it make sense to set both crop and compose 
on a single video device node (not talking about mem-to-mem, where you use the 
type to multiplex input/output devices on the same node) ? If so, what would 
the use cases be ?

Should all devices support the selection API, or only the simple ones that 
don't expose a user-configurable pipeline to userspace through the MC API ? 
The proposed API looks good to me, but before acking it I'd like to clarify 
how (if at all) this will interact with subdev pad-level configuration on 
devices that support that. My current feeling is that video device nodes for 
such devices should only be used for video streaming. All parameters should be 
configured directly on the subdevs. Application might still need to call S_FMT 
in order to be able to allocate buffers though.

-- 
Regards,

Laurent Pinchart
