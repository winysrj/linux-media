Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39047 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab1DLJkI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 05:40:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API, ver2
Date: Tue, 12 Apr 2011 11:40:13 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <1302079459-4018-1-git-send-email-t.stanislaws@samsung.com> <201104081453.02965.hverkuil@xs4all.nl> <4DA2DB02.5020107@samsung.com>
In-Reply-To: <4DA2DB02.5020107@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104121140.13733.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans, Tomasz,

On Monday 11 April 2011 12:42:10 Tomasz Stanislawski wrote:
> Hans Verkuil wrote:
> > On Wednesday, April 06, 2011 10:44:17 Tomasz Stanislawski wrote:
> >> Hello everyone,
> >> 
> >> This patch-set introduces new ioctls to V4L2 API. The new method for
> >> configuration of cropping and composition is presented.
> >> 
> >> This is the second version of extcrop RFC. It was enriched with new
> >> features like additional hint flags, and a support for auxiliary
> >> crop/compose rectangles.
> >> 
> >> There is some confusion in understanding of a cropping in current
> >> version of V4L2. For CAPTURE devices cropping refers to choosing only a
> >> part of input data stream and processing it and storing it in a memory
> >> buffer. The buffer is fully filled by data. It is not possible to
> >> choose only a part of a buffer for being updated by hardware.
> >> 
> >> In case of OUTPUT devices, the whole content of a buffer is passed by
> >> hardware to output display. Cropping means selecting only a part of an
> >> output display/signal. It is not possible to choose only a part for a
> >> memory buffer to be processed.
> >> 
> >> The overmentioned flaws in cropping API were discussed in post:
> >> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/
> >> 28945
> >> 
> >> A solution was proposed during brainstorming session in Warsaw.
> >> 
> >> 
> >> 1. Data structures.
> >> 
> >> The structure v4l2_crop used by current API lacks any place for further
> >> extensions. Therefore new structure is proposed.
> >> 
> >> struct v4l2_selection {
> >> 
> >> 	u32 type;
> >> 	u32 target;
> >> 	struct v4l2_rect r;
> >> 	u32 flags;
> >> 	u32 reserved[9];
> >> 
> >> };
> >> 
> >> Where,
> >> type	 - type of buffer queue: V4L2_BUF_TYPE_VIDEO_CAPTURE,
> >> 
> >>            V4L2_BUF_TYPE_VIDEO_OUTPUT, etc.
> >> 
> >> target   - choose one of cropping/composing rectangles
> >> r	 - selection rectangle
> >> flags	 - control over coordinates adjustments
> >> reserved - place for further extensions, adjust struct size to 64 bytes
> >> 
> >> At first, the distinction between cropping and composing was stated. The
> >> cropping operation means choosing only part of input data bounding it by
> >> a cropping rectangle. All other data must be discarded. On the other
> >> hand, composing means pasting processed data into rectangular part of
> >> data sink. The sink may be output device, user buffer, etc.
> >> 
> >> 
> >> 2. Crop/Compose ioctl.
> >> Four new ioctls would be added to V4L2.
> >> 
> >> Name
> >> 
> >> 	VIDIOC_S_EXTCROP - set cropping rectangle on an input of a device
> >> 
> >> Synopsis
> >> 
> >> 	int ioctl(fd, VIDIOC_S_EXTCROP, struct v4l2_selection *s)
> >> 
> >> Description:
> >> 	The ioctl is used to configure:
> >> 	- for input devices, a part of input data that is processed in hardware
> >> 	- for output devices, a part of a data buffer to be passed to hardware
> >> 	
> >> 	  Drivers may adjust a cropping area. The adjustment can be controlled
> >> 	  
> >>           by v4l2_selection::flags. Please refer to Hints section.
> >> 	
> >> 	- an adjusted crop rectangle is returned in v4l2_selection::r
> >> 
> >> Return value
> >> 
> >> 	On success 0 is returned, on error -1 and the errno variable is set
> >> 	
> >>         appropriately:
> >> 	ERANGE - failed to find a rectangle that satisfy all constraints
> >> 	EINVAL - incorrect buffer type, incorrect target, cropping not
> >> 	supported
> >> 
> >> -----------------------------------------------------------------
> >> 
> >> Name
> >> 
> >> 	VIDIOC_G_EXTCROP - get cropping rectangle on an input of a device
> >> 
> >> Synopsis
> >> 
> >> 	int ioctl(fd, VIDIOC_G_EXTCROP, struct v4l2_selection *s)
> >> 
> >> Description:
> >> 	The ioctl is used to query:
> >> 	- for input devices, a part of input data that is processed in hardware
> >> 	
> >> 	  Other crop rectangles might be examined using this ioctl.
> >> 	  Please refer to Targets section.
> >> 	
> >> 	- for output devices, a part of data buffer to be passed to hardware
> >> 
> >> Return value
> >> 
> >> 	On success 0 is returned, on error -1 and the errno variable is set
> >> 	
> >>         appropriately:
> >> 	EINVAL - incorrect buffer type, incorrect target, cropping not
> >> 	supported
> >> 
> >> -----------------------------------------------------------------
> >> 
> >> Name
> >> 
> >> 	VIDIOC_S_COMPOSE - set destination rectangle on an output of a device
> >> 
> >> Synopsis
> >> 
> >> 	int ioctl(fd, VIDIOC_S_COMPOSE, struct v4l2_selection *s)
> >> 
> >> Description:
> >> 	The ioctl is used to configure:
> >> 	- for input devices, a part of a data buffer that is filled by hardware
> >> 	- for output devices, a area on output device where image is inserted
> >> 	Drivers may adjust a composing area. The adjustment can be controlled
> >> 	
> >>         by v4l2_selection::flags. Please refer to Hints section.
> >> 	
> >> 	- an adjusted composing rectangle is returned in v4l2_selection::r
> >> 
> >> Return value
> >> 
> >> 	On success 0 is returned, on error -1 and the errno variable is set
> >> 	
> >>         appropriately:
> >> 	ERANGE - failed to find a rectangle that satisfy all constraints
> >> 	EINVAL - incorrect buffer type, incorrect target, composing not
> >> 	supported
> >> 
> >> -----------------------------------------------------------------
> >> 
> >> Name
> >> 
> >> 	VIDIOC_G_COMPOSE - get destination rectangle on an output of a device
> >> 
> >> Synopsis
> >> 
> >> 	int ioctl(fd, VIDIOC_G_COMPOSE, struct v4l2_selection *s)
> >> 
> >> Description:
> >> 	The ioctl is used to query:
> >> 	- for input devices, a part of a data buffer that is filled by hardware
> >> 	
> >> 	  Other compose rectangles might be examined using this ioctl.
> >> 	  Please refer to Targets section.
> >> 	
> >> 	- for output devices, a area on output device where image is inserted
> >> 
> >> Return value
> >> 
> >> 	On success 0 is returned, on error -1 and the errno variable is set
> >> 	
> >>         appropriately:
> >> 	EINVAL - incorrect buffer type, incorrect target, composing not
> >> 	supported
> >> 
> >> 3. Hints
> >> 
> >> The v4l2_selection::flags field is used to give a driver a hint about
> >> coordinate adjustments.  Below one can find the proposition of
> >> adjustment flags. The syntax is V4L2_SEL_{name}_{LE/GE}, where {name}
> >> refer to a field in struct v4l2_rect. Two additional properties exist
> >> 'right' and 'bottom'. The refer to respectively: left + width, and top
> >> + height. The LE is abbreviation from "lesser or equal".  It prevents
> >> the driver form increasing a parameter. In similar fashion GE means
> >> "greater or equal" and it disallows decreasing. Combining LE and GE
> >> flags prevents the driver from any adjustments of parameters.  In such
> >> a manner, setting flags field to zero would give a driver a free hand
> >> in coordinate adjustment.
> >> 
> >> #define V4L2_SEL_WIDTH_GE	0x00000001
> >> #define V4L2_SEL_WIDTH_LE	0x00000002
> >> #define V4L2_SEL_HEIGHT_GE	0x00000004
> >> #define V4L2_SEL_HEIGHT_LE	0x00000008
> >> #define V4L2_SEL_LEFT_GE	0x00000010
> >> #define V4L2_SEL_LEFT_LE	0x00000020
> >> #define V4L2_SEL_TOP_GE		0x00000040
> >> #define V4L2_SEL_TOP_LE		0x00000080
> >> #define V4L2_SEL_RIGHT_GE	0x00000100
> >> #define V4L2_SEL_RIGHT_LE	0x00000200
> >> #define V4L2_SEL_BOTTOM_GE	0x00000400
> >> #define V4L2_SEL_BOTTOM_LE	0x00000800
> >> 
> >> #define V4L2_SEL_WIDTH_FIXED	0x00000003
> >> #define V4L2_SEL_HEIGHT_FIXED	0x0000000c
> >> #define V4L2_SEL_LEFT_FIXED	0x00000030
> >> #define V4L2_SEL_TOP_FIXED	0x000000c0
> >> #define V4L2_SEL_RIGHT_FIXED	0x00000300
> >> #define V4L2_SEL_BOTTOM_FIXED	0x00000c00
> >> 
> >> #define V4L2_SEL_FIXED		0x00000fff
> >> 
> >> The hint flags may be useful in a following scenario.  There is a sensor
> >> with a face detection functionality. An application receives
> >> information about a position of a face on sensor array. Assume that the
> >> camera pipeline is capable of an image scaling. The application is
> >> capable of obtaining a location of a face using V4L2 controls. The task
> >> it to grab only part of image that contains a face, and store it to a
> >> framebuffer at a fixed window. Therefore following constrains have to
> >> be satisfied:
> >> - the rectangle that contains a face must lay inside cropping area
> >> - hardware is allowed only to access area inside window on the
> >> framebuffer
> >> 
> >> Both constraints could be satisfied with two ioctl calls.
> >> - VIDIOC_EXTCROP with flags field equal to
> >> 
> >>   V4L2_SEL_TOP_LE | V4L2_SEL_LEFT_LE |
> >>   V4L2_SEL_RIGHT_GE | V4L2_SEL_BOTTOM_GE.
> >> 
> >> - VIDIOC_COMPOSE with flags field equal to
> >> 
> >>   V4L2_SEL_TOP_FIXED | V4L2_SEL_LEFT_FIXED |
> >>   V4L2_SEL_WIDTH_LE | V4L2_SEL_HEIGHT_LE
> >> 
> >> Feel free to add a new flag if necessary.
> > 
> > While this is very flexible, I am a bit concerned about the complexity
> > this would introduce in a driver. I think I would want to see this
> > actually implemented in a driver first. I suspect that some utility
> > functions are probably needed.

I'm very concerned about that as well. Without hints, computing the OMAP3 ISP 
resizer configuration parameters in the driver is already very complex. With 
hints it would become even worse, close to impossible. I know that I won't 
have a month to spend on the implementation.

> >> 4. Targets
> >> The cropping/composing subsystem may use auxiliary rectangles other than
> >> a normal cropping rectangle. The field v4l2_selection::target is used
> >> to choose the rectangle. This functionality was added to simulate
> >> VIDIOC_CROPCAP ioctl. All cropcap fields except pixel aspect are
> >> supported. I noticed that there was discussion about pixel aspect and I
> >> am not convinced that it should be a part of the cropping API. Please
> >> refer to the post:
> >> http://lists-archives.org/video4linux/22837-need-vidioc_cropcap-clarific
> >> ation.html
> >> 
> >> Proposed targets are:
> >> - active - numerical value 0, an area that is processed by hardware
> >> - default - is the suggested active rectangle that covers the "whole
> >> picture" - bounds - the limits that active rectangle cannot exceed
> >> 
> >> V4L2_SEL_TARGET_ACTIVE	= 0
> >> V4L2_SEL_TARGET_DEFAULT	= 1
> >> V4L2_SEL_TARGET_BOUNDS	= 2
> >> 
> >> Feel free to add other targets.
> >> 
> >> Only V4L2_SEL_TARGET_ACTIVE is accepted for
> >> VIDIOC_S_EXTCROP/VIDIOC_S_COMPOSE ioctls.  Auxiliary target like
> >> DEFAULT and BOUNDS are supported only by 'get' interface.
> > 
> > Sorry, but I really don't like this idea of a target. It doesn't make
> > sense to add this when you can only choose a different target for a get.
> > 
> > I think a EXTCROPCAP/COMPOSECAP pair (or a single CROPCOMPOSECAP ioctl,
> > see below) makes more sense.
> 
> I think that we should avoid adding new ioctl if they are not required.
> Laurent suggested that it natural solution to use G_EXTCROP to get
> different kinds of rectangles.

I totally agree here. We don't have G_FMT_CAPTURE and G_FMT_OUTPUT, we have a 
single G_FMT ioctl with a buffer type argument. Let's not create a bunch of 
ioctls just for the fun of it :-)

Using a target would also make the ioctls easier to extend later if we need to 
add new targets.

> >> 5. Possible improvements and extensions.
> >> - combine composing and cropping ioctl into a single ioctl
> > 
> > I think this could be very interesting. By doing this in a single ioctl
> > you should have all the information needed to setup a scaler. And with
> > the hints you can tell the driver how the input/output rectangles need
> > to be adjusted.

You would still need S_FMT to define the size of the captured (output) image 
for capture (output) devices.

> > This would make sense as well on the subdev level.
> >
> > Laurent, wouldn't this solve the way the omap3 ISP sets up the scaler? By
> > fixing the output of the scaler and setting hints to allow changes to the
> > input crop rectangle we would fix the scaler setup issues we discussed in
> > Warsaw.

On subdevs you would need something even more generic, with the ability to set 
parameters on multiple pads at the same time. For the OMAP3 ISP scaler, 
cropping is done on the input, and we need to set format on the output pads. 
There's no compose capability (that's not entirely true, compose could be 
implemented by configuring offsets and line length in the DMA engine, but 
that's unrelated).

> What about merging EXTCROP and COMPOSE into single ioct, which argument
>   contains two rectangles.. similar to the one posted here:
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/2894
> 5

Would that allow new use cases that can't be supported by two separate ioctls 
?

It would also double the number of hints. I would then create a separate hint 
flags field, as we would already use 24 out of the 32 available flags.

> >> - add subpixel resolution
> >> 
> >>  * hardware is often capable of subpixel processing. The ioctl triple
> >>  
> >>    S_EXTCROP, S_SCALE, S_COMPOSE can be converted to S_EXTCROP and
> >>    S_COMPOSE pair if a subpixel resolution is supported
> > 
> > I'm not sure I understand this. Can you give an example?
> 
> There is a problem with scaling. Look at the following (little non-life)
> example:
> Assume that we have sensor with 2x2 resolution.
> The buffer has resolution 4x4.
> One would like to crop area of size 1.5x1.5 and copy to to area 3x3 in
> memory buffer.
> Current Crop api does not allow it because first it does not support
> composing, second there is no subpixel resolution in crop rectangles.
> 
> I know this could be solved in two ways:
> a) use S_SCALING:
> - set cropping 2x2 on sensor
> - set scaling 2x using S_SCALING
> - set compose in buffer as 3x3 area (it will work like clipping)
> 
> b) use subpixel cropping:
> - set cropping area 1.5x1.5 using S_EXTCROP
> - set composing in buffer to 3x3 area
> 
> The problem with solution a) is need of introduction new family of
> ioctls {G/S/TRY}_SCALING, and making composing work as clipping for
> scaled data.
> 
> I suppose that subpixel cropping could be realized in one of two ways:
> 1. Introducing v4l2_fract_rect structure. Its all fields type would be
> v4l2_fract.
> 2. Use one of reserved fields in v4l2_selection as divisor for
> coordinates in v4l2_selection::r.
> 
> What is your opinion?
> 
> >> - merge v4l2_selection::target and v4l2_selection::flags into single
> >> field - allow using VIDIOC_S_EXTCROP with target type
> >> V4L2_SEL_TARGET_BOUNDS to
> >> 
> >>   choose a resolution of a sensor
> > 
> > Too obscure IMHO. That said, it would be nice to have a more explicit
> > method of selecting a sensor resolution. You can enumerate them, but you
> > choose it using VIDIOC_S_FMT, which I've always thought was very
> > dubious. This prevents any sensor-built-in scalers from being used. For
> > video you have S_STD and S_DV_PRESET that select a particular input
> > resolution, but a similar ioctl is missing for sensors. Laurent, what
> > are your thoughts?
> > 
> >> - add TRY flag to ask a driver to adjust a rectangle without applying it
> > 
> > Don't use a flag, use TRY_EXTCROP and TRY_COMPOSE, just like the other
> > try ioctls. Otherwise I'm in favor of this.

I actually like the flag better :-) It avoid adding too many new ioctls and 
it's in line with what we do on subdevs.

-- 
Regards,

Laurent Pinchart
