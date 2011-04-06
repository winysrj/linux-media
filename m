Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26946 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab1DFIqA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 04:46:00 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LJ800JHB2Y6RB@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Apr 2011 09:44:30 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LJ8007SO2Y4CI@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Apr 2011 09:44:29 +0100 (BST)
Date: Wed, 06 Apr 2011 10:44:17 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 0/2] V4L: Extended crop/compose API, ver2
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com
Message-id: <1302079459-4018-1-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello everyone,

This patch-set introduces new ioctls to V4L2 API. The new method for
configuration of cropping and composition is presented.

This is the second version of extcrop RFC. It was enriched with new features
like additional hint flags, and a support for auxiliary crop/compose
rectangles.

There is some confusion in understanding of a cropping in current version of
V4L2. For CAPTURE devices cropping refers to choosing only a part of input
data stream and processing it and storing it in a memory buffer. The buffer is
fully filled by data. It is not possible to choose only a part of a buffer for
being updated by hardware.

In case of OUTPUT devices, the whole content of a buffer is passed by hardware
to output display. Cropping means selecting only a part of an output
display/signal. It is not possible to choose only a part for a memory buffer
to be processed.

The overmentioned flaws in cropping API were discussed in post:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/28945

A solution was proposed during brainstorming session in Warsaw.


1. Data structures.

The structure v4l2_crop used by current API lacks any place for further
extensions. Therefore new structure is proposed.

struct v4l2_selection {
	u32 type;
	u32 target;
	struct v4l2_rect r;
	u32 flags;
	u32 reserved[9];
};

Where,
type	 - type of buffer queue: V4L2_BUF_TYPE_VIDEO_CAPTURE,
           V4L2_BUF_TYPE_VIDEO_OUTPUT, etc.
target   - choose one of cropping/composing rectangles
r	 - selection rectangle
flags	 - control over coordinates adjustments
reserved - place for further extensions, adjust struct size to 64 bytes

At first, the distinction between cropping and composing was stated. The
cropping operation means choosing only part of input data bounding it by a
cropping rectangle. All other data must be discarded. On the other hand,
composing means pasting processed data into rectangular part of data sink. The
sink may be output device, user buffer, etc.


2. Crop/Compose ioctl.
Four new ioctls would be added to V4L2.

Name
	VIDIOC_S_EXTCROP - set cropping rectangle on an input of a device

Synopsis
	int ioctl(fd, VIDIOC_S_EXTCROP, struct v4l2_selection *s)

Description:
	The ioctl is used to configure:
	- for input devices, a part of input data that is processed in hardware
	- for output devices, a part of a data buffer to be passed to hardware
	  Drivers may adjust a cropping area. The adjustment can be controlled
          by v4l2_selection::flags. Please refer to Hints section.
	- an adjusted crop rectangle is returned in v4l2_selection::r

Return value
	On success 0 is returned, on error -1 and the errno variable is set
        appropriately:
	ERANGE - failed to find a rectangle that satisfy all constraints
	EINVAL - incorrect buffer type, incorrect target, cropping not supported

-----------------------------------------------------------------

Name
	VIDIOC_G_EXTCROP - get cropping rectangle on an input of a device

Synopsis
	int ioctl(fd, VIDIOC_G_EXTCROP, struct v4l2_selection *s)

Description:
	The ioctl is used to query:
	- for input devices, a part of input data that is processed in hardware
	  Other crop rectangles might be examined using this ioctl.
	  Please refer to Targets section.
	- for output devices, a part of data buffer to be passed to hardware

Return value
	On success 0 is returned, on error -1 and the errno variable is set
        appropriately:
	EINVAL - incorrect buffer type, incorrect target, cropping not supported

-----------------------------------------------------------------

Name
	VIDIOC_S_COMPOSE - set destination rectangle on an output of a device

Synopsis
	int ioctl(fd, VIDIOC_S_COMPOSE, struct v4l2_selection *s)

Description:
	The ioctl is used to configure:
	- for input devices, a part of a data buffer that is filled by hardware
	- for output devices, a area on output device where image is inserted
	Drivers may adjust a composing area. The adjustment can be controlled
        by v4l2_selection::flags. Please refer to Hints section.
	- an adjusted composing rectangle is returned in v4l2_selection::r

Return value
	On success 0 is returned, on error -1 and the errno variable is set
        appropriately:
	ERANGE - failed to find a rectangle that satisfy all constraints
	EINVAL - incorrect buffer type, incorrect target, composing not supported

-----------------------------------------------------------------

Name
	VIDIOC_G_COMPOSE - get destination rectangle on an output of a device

Synopsis
	int ioctl(fd, VIDIOC_G_COMPOSE, struct v4l2_selection *s)

Description:
	The ioctl is used to query:
	- for input devices, a part of a data buffer that is filled by hardware
	  Other compose rectangles might be examined using this ioctl.
	  Please refer to Targets section.
	- for output devices, a area on output device where image is inserted

Return value
	On success 0 is returned, on error -1 and the errno variable is set
        appropriately:
	EINVAL - incorrect buffer type, incorrect target, composing not supported


3. Hints

The v4l2_selection::flags field is used to give a driver a hint about
coordinate adjustments.  Below one can find the proposition of adjustment
flags. The syntax is V4L2_SEL_{name}_{LE/GE}, where {name} refer to a field in
struct v4l2_rect. Two additional properties exist 'right' and 'bottom'. The
refer to respectively: left + width, and top + height. The LE is abbreviation
from "lesser or equal".  It prevents the driver form increasing a parameter. In
similar fashion GE means "greater or equal" and it disallows decreasing.
Combining LE and GE flags prevents the driver from any adjustments of
parameters.  In such a manner, setting flags field to zero would give a driver
a free hand in coordinate adjustment.

#define V4L2_SEL_WIDTH_GE	0x00000001
#define V4L2_SEL_WIDTH_LE	0x00000002
#define V4L2_SEL_HEIGHT_GE	0x00000004
#define V4L2_SEL_HEIGHT_LE	0x00000008
#define V4L2_SEL_LEFT_GE	0x00000010
#define V4L2_SEL_LEFT_LE	0x00000020
#define V4L2_SEL_TOP_GE		0x00000040
#define V4L2_SEL_TOP_LE		0x00000080
#define V4L2_SEL_RIGHT_GE	0x00000100
#define V4L2_SEL_RIGHT_LE	0x00000200
#define V4L2_SEL_BOTTOM_GE	0x00000400
#define V4L2_SEL_BOTTOM_LE	0x00000800

#define V4L2_SEL_WIDTH_FIXED	0x00000003
#define V4L2_SEL_HEIGHT_FIXED	0x0000000c
#define V4L2_SEL_LEFT_FIXED	0x00000030
#define V4L2_SEL_TOP_FIXED	0x000000c0
#define V4L2_SEL_RIGHT_FIXED	0x00000300
#define V4L2_SEL_BOTTOM_FIXED	0x00000c00

#define V4L2_SEL_FIXED		0x00000fff

The hint flags may be useful in a following scenario.  There is a sensor with a
face detection functionality. An application receives information about a
position of a face on sensor array. Assume that the camera pipeline is capable
of an image scaling. The application is capable of obtaining a location of a
face using V4L2 controls. The task it to grab only part of image that contains
a face, and store it to a framebuffer at a fixed window. Therefore following
constrains have to be satisfied:
- the rectangle that contains a face must lay inside cropping area
- hardware is allowed only to access area inside window on the framebuffer

Both constraints could be satisfied with two ioctl calls.
- VIDIOC_EXTCROP with flags field equal to
  V4L2_SEL_TOP_LE | V4L2_SEL_LEFT_LE |
  V4L2_SEL_RIGHT_GE | V4L2_SEL_BOTTOM_GE.
- VIDIOC_COMPOSE with flags field equal to
  V4L2_SEL_TOP_FIXED | V4L2_SEL_LEFT_FIXED |
  V4L2_SEL_WIDTH_LE | V4L2_SEL_HEIGHT_LE

Feel free to add a new flag if necessary.


4. Targets
The cropping/composing subsystem may use auxiliary rectangles other than a
normal cropping rectangle. The field v4l2_selection::target is used to choose
the rectangle. This functionality was added to simulate VIDIOC_CROPCAP ioctl.
All cropcap fields except pixel aspect are supported. I noticed that there was
discussion about pixel aspect and I am not convinced that it should be a part
of the cropping API. Please refer to the post:
http://lists-archives.org/video4linux/22837-need-vidioc_cropcap-clarification.html

Proposed targets are:
- active - numerical value 0, an area that is processed by hardware
- default - is the suggested active rectangle that covers the "whole picture"
- bounds - the limits that active rectangle cannot exceed

V4L2_SEL_TARGET_ACTIVE	= 0
V4L2_SEL_TARGET_DEFAULT	= 1
V4L2_SEL_TARGET_BOUNDS	= 2

Feel free to add other targets.

Only V4L2_SEL_TARGET_ACTIVE is accepted for VIDIOC_S_EXTCROP/VIDIOC_S_COMPOSE
ioctls.  Auxiliary target like DEFAULT and BOUNDS are supported only by 'get'
interface.


5. Possible improvements and extensions.
- combine composing and cropping ioctl into a single ioctl
- add subpixel resolution
 * hardware is often capable of subpixel processing. The ioctl triple
   S_EXTCROP, S_SCALE, S_COMPOSE can be converted to S_EXTCROP and S_COMPOSE
   pair if a subpixel resolution is supported
- merge v4l2_selection::target and v4l2_selection::flags into single field
- allow using VIDIOC_S_EXTCROP with target type V4L2_SEL_TARGET_BOUNDS to
  choose a resolution of a sensor
- add TRY flag to ask a driver to adjust a rectangle without applying it

What it your opinion about proposed solutions?

Looking for a reply,

Best regards,
Tomasz Stanislawski


Tomasz Stanislawski (2):
  v4l: add support for extended crop/compose API
  v4l: simulate old crop API using extcrop/compose

 drivers/media/video/v4l2-compat-ioctl32.c |    4 +
 drivers/media/video/v4l2-ioctl.c          |  150 ++++++++++++++++++++++++++---
 include/linux/videodev2.h                 |   44 +++++++++
 include/media/v4l2-ioctl.h                |    8 ++
 4 files changed, 194 insertions(+), 12 deletions(-)

-- 
1.7.4.2
