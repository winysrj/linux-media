Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1503 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1C2G6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 02:58:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API
Date: Tue, 29 Mar 2011 08:58:16 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
References: <1301325596-18166-1-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1301325596-18166-1-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103290858.16138.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, March 28, 2011 17:19:54 Tomasz Stanislawski wrote:
> Hello everyone,
> 
> This patch-set introduces new ioctls to V4L2 API. The new method for
> configuration of cropping and composition is presented.
> 
> There is some confusion in understanding of a cropping in current version of
> V4L2. For CAPTURE devices cropping refers to choosing only a part of input
> data stream and processing it and storing it in a memory buffer. The buffer is
> fully filled by data. It is not possible to choose only a part of a buffer for
> being updated by hardware.
> 
> In case of OUTPUT devices, the whole content of a buffer is passed by hardware
> to output display. Cropping means selecting only a part of an output
> display/signal. It is not possible to choose only a part for a memory buffer
> to be processed.
> 
> The overmentioned flaws in cropping API were discussed in post:
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/28945
> 
> A solution was proposed during brainstorming session in Warsaw.

I don't have time right now to review this RFC in-depth, but one thing that
needs more attention is the relationship between these new ioctls and CROPCAP.

And also how this relates to analog inputs (I don't think analog outputs make
any sense). And would a COMPOSECAP ioctl make sense?

> 
> 1. Data structures.
> 
> The structure v4l2_crop used by current API lacks any place for further
> extensions. Therefore new structure is proposed.
> 
> struct v4l2_selection {
> 	u32 type;
> 	struct v4l2_rect r;
> 	u32 flags;
> 	u32 reserved[10];
> };
> 
> Where,
> type	 - type of buffer queue: V4L2_BUF_TYPE_VIDEO_CAPTURE,
>            V4L2_BUF_TYPE_VIDEO_OUTPUT, etc.
> r	 - selection rectangle
> flags	 - control over coordinates adjustments
> reserved - place for further extensions, adjust struct size to 64 bytes
> 
> At first, the distinction between cropping and composing was stated. The
> cropping operation means choosing only part of input data bounding it by a
> cropping rectangle.  All other data must be discarded.  On the other hand,
> composing means pasting processed data into rectangular part of data sink. The
> sink may be output device, user buffer, etc.
> 
> 2. Crop/Compose ioctl.
> Four new ioctls would be added to V4L2.
> 
> Name
> 	VIDIOC_S_EXTCROP - set cropping rectangle on an input of a device
> 
> Synopsis
> 	int ioctl(fd, VIDIOC_S_EXTCROP, struct v4l2_selection *s)
> 
> Description:
> 	The ioctl is used to configure:
> 	- for input devices, a part of input data that is processed in hardware
> 	- for output devices, a part of a data buffer to be passed to hardware
> 	  Drivers may adjust a cropping area. The adjustment can be controlled
>           by v4l2_selection::flags.  Please refer to Hints section.
> 	- an adjusted crop rectangle is returned in v4l2_selection::r
> 
> Return value
> 	On success 0 is returned, on error -1 and the errno variable is set
>         appropriately:
> 	ERANGE - failed to find a rectangle that satisfy all constraints
> 	EINVAL - incorrect buffer type, cropping not supported
> 
> -----------------------------------------------------------------
> 
> Name
> 	VIDIOC_G_EXTCROP - get cropping rectangle on an input of a device
> 
> Synopsis
> 	int ioctl(fd, VIDIOC_G_EXTCROP, struct v4l2_selection *s)
> 
> Description:
> 	The ioctl is used to query:
> 	- for input devices, a part of input data that is processed in hardware
> 	- for output devices, a part of data buffer to be passed to hardware
> 
> Return value
> 	On success 0 is returned, on error -1 and the errno variable is set
>         appropriately:
> 	EINVAL - incorrect buffer type, cropping not supported
> 
> -----------------------------------------------------------------
> 
> Name
> 	VIDIOC_S_COMPOSE - set destination rectangle on an output of a device
> 
> Synopsis
> 	int ioctl(fd, VIDIOC_S_COMPOSE, struct v4l2_selection *s)
> 
> Description:
> 	The ioctl is used to configure:
> 	- for input devices, a part of a data buffer that is filled by hardware
> 	- for output devices, a area on output device where image is inserted
> 	Drivers may adjust a composing area. The adjustment can be controlled
>         by v4l2_selection::flags. Please refer to Hints section.
> 	- an adjusted composing rectangle is returned in v4l2_selection::r
> 
> Return value
> 	On success 0 is returned, on error -1 and the errno variable is set
>         appropriately:
> 	ERANGE - failed to find a rectangle that satisfy all constraints
> 	EINVAL - incorrect buffer type, composing not supported
> 
> -----------------------------------------------------------------
> 
> Name
> 	VIDIOC_G_COMPOSE - get destination rectangle on an output of a device
> 
> Synopsis
> 	int ioctl(fd, VIDIOC_G_COMPOSE, struct v4l2_selection *s)
> 
> Description:
> 	The ioctl is used to query:
> 	- for input devices, a part of a data buffer that is filled by hardware
> 	- for output devices, a area on output device where image is inserted
> 
> Return value
> 	On success 0 is returned, on error -1 and the errno variable is set
>         appropriately:
> 	EINVAL - incorrect buffer type, composing not supported
> 
> 
> 3. Hints
> 
> The v4l2_selection::flags field is used to give a driver a hint about
> coordinate adjustments.  Below one can find the proposition of adjustment
> flags. The syntax is V4L2_SEL_{name}_{LE/GE}, where {name} refer to a field in
> struct v4l2_rect. The LE is abbreviation from "lesser or equal".  It prevents
> the driver form increasing a parameter. In similar fashion GE means "greater or
> equal" and it disallows decreasing. Combining LE and GE flags prevents the
> driver from any adjustments of parameters.  In such a manner, setting flags
> field to zero would give a driver a free hand in coordinate adjustment.
> 
> #define V4L2_SEL_WIDTH_GE	0x00000001
> #define V4L2_SEL_WIDTH_LE	0x00000002
> #define V4L2_SEL_HEIGHT_GE	0x00000004
> #define V4L2_SEL_HEIGHT_LE	0x00000008
> #define V4L2_SEL_LEFT_GE	0x00000010
> #define V4L2_SEL_LEFT_LE	0x00000020
> #define V4L2_SEL_TOP_GE		0x00000040
> #define V4L2_SEL_TOP_LE		0x00000080

Wouldn't you also need similar flags for RIGHT and BOTTOM?

Regards,

	Hans

> 
> #define V4L2_SEL_WIDTH_FIXED	0x00000003
> #define V4L2_SEL_HEIGHT_FIXED	0x0000000c
> #define V4L2_SEL_LEFT_FIXED	0x00000030
> #define V4L2_SEL_TOP_FIXED	0x000000c0
> 
> #define V4L2_SEL_FIXED		0x000000ff
> 
> The hint flags may be useful in a following scenario.  There is a sensor with a
> face detection functionality. An application receives information about a
> position of a face on sensor array. Assume that the camera pipeline is capable
> of an image scaling. The application is capable of obtaining a location of a
> face using V4L2 controls. The task it to grab only part of image that contains
> a face, and store it to a framebuffer at a fixed window. Therefore following
> constrains have to be satisfied:
> - the rectangle that contains a face must lay inside cropping area
> - hardware is allowed only to access area inside window on the framebuffer
> 
> Both constraints could be satisfied with two ioctl calls.
> - VIDIOC_EXTCROP with flags field equal to
>   V4L2_SEL_TOP_FIXED | V4L2_SEL_LEFT_FIXED |
>   V4L2_SEL_WIDTH_GE | V4L2_SEL_HEIGHT_GE.
> - VIDIOC_COMPOSE with flags field equal to
>   V4L2_SEL_TOP_FIXED | V4L2_SEL_LEFT_FIXED |
>   V4L2_SEL_WIDTH_LE | V4L2_SEL_HEIGHT_LE
> 
> Feel free to add a new flag if necessary.
> 
> 4. Possible improvements and extensions.
> - combine composing and cropping ioctl into a single ioctl
> - add subpixel resolution
>  * hardware is often capable of subpixel processing. The ioctl triple
>    S_EXTCROP, S_SCALE, S_COMPOSE can be converted to S_EXTCROP and S_COMPOSE
>    pair if a subpixel resolution is supported
> 
> 
> What it your opinion about proposed solutions?
> 
> Looking for a reply,
> 
> Best regards,
> Tomasz Stanislawski
> 
> Tomasz Stanislawski (2):
>   v4l: add support for extended crop/compose API
>   v4l: simulate old crop API using extcrop/compose
> 
>  drivers/media/video/v4l2-compat-ioctl32.c |    4 +
>  drivers/media/video/v4l2-ioctl.c          |  102 +++++++++++++++++++++++++++--
>  include/linux/videodev2.h                 |   30 +++++++++
>  include/media/v4l2-ioctl.h                |    8 ++
>  4 files changed, 137 insertions(+), 7 deletions(-)
> 
> 
