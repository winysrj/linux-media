Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:48421 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757633Ab1DLPlx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 11:41:53 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Q9fix-0000Xv-Vm
	for linux-media@vger.kernel.org; Tue, 12 Apr 2011 17:41:51 +0200
Received: from 217067201162.u.itsa.pl ([217.67.201.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 17:41:51 +0200
Received: from t.stanislaws by 217067201162.u.itsa.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 17:41:51 +0200
To: linux-media@vger.kernel.org
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API, ver2
Date: Tue, 12 Apr 2011 17:41:34 +0200
Message-ID: <io1rre$7ko$2@dough.gmane.org>
References: <1302079459-4018-1-git-send-email-t.stanislaws@samsung.com> <201104081453.02965.hverkuil@xs4all.nl> <4DA2DB02.5020107@samsung.com> <201104121140.13733.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <201104121140.13733.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,
Thank you for your comments.
 > Hi Hans, Tomasz,
 >
 > On Monday 11 April 2011 12:42:10 Tomasz Stanislawski wrote:
 >
 >> Hans Verkuil wrote:
 >>
 >>> On Wednesday, April 06, 2011 10:44:17 Tomasz Stanislawski wrote:
 >>>
 >>>> Hello everyone,
 >>>>
 >>>> This patch-set introduces new ioctls to V4L2 API. The new method for
 >>>> configuration of cropping and composition is presented.
 >>>>
 >>>>
 >>>>
[snip]
 >>>> 3. Hints
 >>>>
 >>>> The v4l2_selection::flags field is used to give a driver a hint about
 >>>> coordinate adjustments.  Below one can find the proposition of
 >>>> adjustment flags. The syntax is V4L2_SEL_{name}_{LE/GE}, where {name}
 >>>> refer to a field in struct v4l2_rect. Two additional properties exist
 >>>> 'right' and 'bottom'. The refer to respectively: left + width, and top
 >>>> + height. The LE is abbreviation from "lesser or equal".  It prevents
 >>>> the driver form increasing a parameter. In similar fashion GE means
 >>>> "greater or equal" and it disallows decreasing. Combining LE and GE
 >>>> flags prevents the driver from any adjustments of parameters.  In such
 >>>> a manner, setting flags field to zero would give a driver a free hand
 >>>> in coordinate adjustment.
 >>>>
 >>>> #define V4L2_SEL_WIDTH_GE	0x00000001
 >>>> #define V4L2_SEL_WIDTH_LE	0x00000002
 >>>> #define V4L2_SEL_HEIGHT_GE	0x00000004
 >>>> #define V4L2_SEL_HEIGHT_LE	0x00000008
 >>>> #define V4L2_SEL_LEFT_GE	0x00000010
 >>>> #define V4L2_SEL_LEFT_LE	0x00000020
 >>>> #define V4L2_SEL_TOP_GE		0x00000040
 >>>> #define V4L2_SEL_TOP_LE		0x00000080
 >>>> #define V4L2_SEL_RIGHT_GE	0x00000100
 >>>> #define V4L2_SEL_RIGHT_LE	0x00000200
 >>>> #define V4L2_SEL_BOTTOM_GE	0x00000400
 >>>> #define V4L2_SEL_BOTTOM_LE	0x00000800
 >>>>
 >>>> #define V4L2_SEL_WIDTH_FIXED	0x00000003
 >>>> #define V4L2_SEL_HEIGHT_FIXED	0x0000000c
 >>>> #define V4L2_SEL_LEFT_FIXED	0x00000030
 >>>> #define V4L2_SEL_TOP_FIXED	0x000000c0
 >>>> #define V4L2_SEL_RIGHT_FIXED	0x00000300
 >>>> #define V4L2_SEL_BOTTOM_FIXED	0x00000c00
 >>>>
 >>>> #define V4L2_SEL_FIXED		0x00000fff
 >>>>
 >>>> The hint flags may be useful in a following scenario.  There is a 
sensor
 >>>> with a face detection functionality. An application receives
 >>>> information about a position of a face on sensor array. Assume 
that the
 >>>> camera pipeline is capable of an image scaling. The application is
 >>>> capable of obtaining a location of a face using V4L2 controls. The 
task
 >>>> it to grab only part of image that contains a face, and store it to a
 >>>> framebuffer at a fixed window. Therefore following constrains have to
 >>>> be satisfied:
 >>>> - the rectangle that contains a face must lay inside cropping area
 >>>> - hardware is allowed only to access area inside window on the
 >>>> framebuffer
 >>>>
 >>>> Both constraints could be satisfied with two ioctl calls.
 >>>> - VIDIOC_EXTCROP with flags field equal to
 >>>>
 >>>>   V4L2_SEL_TOP_LE | V4L2_SEL_LEFT_LE |
 >>>>   V4L2_SEL_RIGHT_GE | V4L2_SEL_BOTTOM_GE.
 >>>>
 >>>> - VIDIOC_COMPOSE with flags field equal to
 >>>>
 >>>>   V4L2_SEL_TOP_FIXED | V4L2_SEL_LEFT_FIXED |
 >>>>   V4L2_SEL_WIDTH_LE | V4L2_SEL_HEIGHT_LE
 >>>>
 >>>> Feel free to add a new flag if necessary.
 >>>>
 >>> While this is very flexible, I am a bit concerned about the complexity
 >>> this would introduce in a driver. I think I would want to see this
 >>> actually implemented in a driver first. I suspect that some utility
 >>> functions are probably needed.
 >>>
 >
 > I'm very concerned about that as well. Without hints, computing the 
OMAP3 ISP
 > resizer configuration parameters in the driver is already very 
complex. With
 > hints it would become even worse, close to impossible. I know that I 
won't
 > have a month to spend on the implementation.
 >
 >

I think we will need a new helper function in V4L2 kernel API in order
to reduce complexity introduced by hints. This function would contain
typical business logic used to adjust cropping rectangle. It would use
structures similar
to struct v4l2_frmsizeenum to specify available ranges of rectangles'
sizes and offsets. The function would
also take hints flags and a rectangle provided by userspace. It would
return an adjusted rectangle.

Moreover, we will need a additional function in form:

u32 v4l2_rect_verify_constraints(struct v4l2_rect *desired, struct
v4l2_rect *proposed);

that checks which constraints are satisfied by 'proposed' rectangle
relative to 'desired' rectangle.
If returned hints have a zero bit that is set in user hints then EINVAL
is returned. Additionally, if
ioctl was called in TRY mode then v4l2_selection::r is substituted with
a rectangle proposed by a driver.

Other solution would be introduction of an ioctl similar to
VIDIOC_ENUM_FRAMESIZES but dedicated for cropping/composing. This way a
business logic could be partially exported to a userspace.

I will try to prepare an RFC about it.

Do you have any suggestions?

Please look below for comments about S_FMT stuff.
 >>>> 4. Targets
 >>>> The cropping/composing subsystem may use auxiliary rectangles 
other than
 >>>> a normal cropping rectangle. The field v4l2_selection::target is used
 >>>> to choose the rectangle. This functionality was added to simulate
 >>>> VIDIOC_CROPCAP ioctl. All cropcap fields except pixel aspect are
 >>>> supported. I noticed that there was discussion about pixel aspect 
and I
 >>>> am not convinced that it should be a part of the cropping API. Please
 >>>> refer to the post:
 >>>> 
http://lists-archives.org/video4linux/22837-need-vidioc_cropcap-clarific
 >>>> ation.html
 >>>>
 >>>> Proposed targets are:
 >>>> - active - numerical value 0, an area that is processed by hardware
 >>>> - default - is the suggested active rectangle that covers the "whole
 >>>> picture" - bounds - the limits that active rectangle cannot exceed
 >>>>
 >>>> V4L2_SEL_TARGET_ACTIVE	= 0
 >>>> V4L2_SEL_TARGET_DEFAULT	= 1
 >>>> V4L2_SEL_TARGET_BOUNDS	= 2
 >>>>
 >>>> Feel free to add other targets.
 >>>>
 >>>> Only V4L2_SEL_TARGET_ACTIVE is accepted for
 >>>> VIDIOC_S_EXTCROP/VIDIOC_S_COMPOSE ioctls.  Auxiliary target like
 >>>> DEFAULT and BOUNDS are supported only by 'get' interface.
 >>>>
 >>> Sorry, but I really don't like this idea of a target. It doesn't make
 >>> sense to add this when you can only choose a different target for a 
get.
 >>>
 >>> I think a EXTCROPCAP/COMPOSECAP pair (or a single CROPCOMPOSECAP ioctl,
 >>> see below) makes more sense.
 >>>
 >> I think that we should avoid adding new ioctl if they are not required.
 >> Laurent suggested that it natural solution to use G_EXTCROP to get
 >> different kinds of rectangles.
 >>
 >
 > I totally agree here. We don't have G_FMT_CAPTURE and G_FMT_OUTPUT, 
we have a
 > single G_FMT ioctl with a buffer type argument. Let's not create a 
bunch of
 > ioctls just for the fun of it :-)
 >
 > Using a target would also make the ioctls easier to extend later if 
we need to
 > add new targets.
 >
Thanks for support on the idea :).
 >
 >>>> 5. Possible improvements and extensions.
 >>>> - combine composing and cropping ioctl into a single ioctl
 >>>>
 >>> I think this could be very interesting. By doing this in a single ioctl
 >>> you should have all the information needed to setup a scaler. And with
 >>> the hints you can tell the driver how the input/output rectangles need
 >>> to be adjusted.
 >>>
 >
 > You would still need S_FMT to define the size of the captured 
(output) image
 > for capture (output) devices.
 >
 >
Frankly, I think that there is a general flaw in a purpose of S_FMT.
In V4l2, there are following entities and associated ioctl used for
configuration:
analog TV input/output - VIDIOC_S_STD
digital TV input/output - VIDIOC_S_DV_PRESET
audio  input - VIDIOC_S_AUDIO
memory buffer - VIDIOC_S_FMT

Now I ask:
Why S_CROP can change a format in memory buffer (width and size) but it
is not allowed to change DV preset?
Why symmetry is broken between these entities?

In my opinion, a format should stay fixed after successful VIDIOC_S_FMT.
It would mean that width and height of an image must not be changed by
CROP/COMPOSE setup.
For input devices, if an image is too large for desired cropping
rectangle then a buffer's composing rectangle is adjusted. So data from
a sensor are blit on a part of an image. If HW did not support buffer
composing then it would return EINVAL or increase cropping rectangle if
hints allow this.

Using this treat CROP/COMPOSE ioctls could be merged. Driver could
adjust crop/compose rectangle simultaneously  according to its scaling
capabilities. No adjustment of resolution of input data, output data.
Moreover no memory management would be involved because a buffer size
would not change. I think it may greatly simply driver's code.

BTW: I think that sensors need some dedicated ioctl for configuration
similar to ioctls available for other entities (like S_DV_PRESET or more
general S_DV_TIMINGS).
 >>> This would make sense as well on the subdev level.
 >>>
 >>> Laurent, wouldn't this solve the way the omap3 ISP sets up the 
scaler? By
 >>> fixing the output of the scaler and setting hints to allow changes 
to the
 >>> input crop rectangle we would fix the scaler setup issues we 
discussed in
 >>> Warsaw.
 >>>
 >
 > On subdevs you would need something even more generic, with the 
ability to set
 > parameters on multiple pads at the same time. For the OMAP3 ISP scaler,
 > cropping is done on the input, and we need to set format on the 
output pads.
 > There's no compose capability (that's not entirely true, compose 
could be
 > implemented by configuring offsets and line length in the DMA engine, 
but
 > that's unrelated).
 >
Additional target rectangles may help here.
 >> What about merging EXTCROP and COMPOSE into single ioct, which argument
 >>   contains two rectangles.. similar to the one posted here:
 >> 
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/2894
 >> 5
 >>
 >
 > Would that allow new use cases that can't be supported by two 
separate ioctls
 > ?
 >
If a device has very limited scaling abilities that not all combinations
of cropping/composing rectangles could be accepted. A problem with
configuration was described by you in a post:
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/27581
The driver could choose the best possible configuration because it has
compose and crop rectangles and is allowed to adjust them according to
hints flags.

What do you think about a following idea?
The cropping/compose configuration would introduce no scaling but only
setting active area assuming no scaling.
Scaling configuration would be done using S_SCALING ioctl.
However, some of pixels in destination buffer may be undefined for a
flawed configuration.
 > It would also double the number of hints. I would then create a 
separate hint
 > flags field, as we would already use 24 out of the 32 available flags.
 >
Hmm.. there are already to sets of hints flags, one passed by
VIDIOC_S_EXTCROP and another passed by VIDIOC_S_COMPOSE. Therefore a
merged structure would contains two hints fields.

Waiting for comment.

Best regards,
Tomasz Stanislawski
 >
 >>>> - add subpixel resolution
 >>>>
 >>>>  * hardware is often capable of subpixel processing. The ioctl triple
 >>>>
 >>>>    S_EXTCROP, S_SCALE, S_COMPOSE can be converted to S_EXTCROP and
 >>>>    S_COMPOSE pair if a subpixel resolution is supported
 >>>>
 >>> I'm not sure I understand this. Can you give an example?
 >>>
 >> There is a problem with scaling. Look at the following (little non-life)
 >> example:
 >> Assume that we have sensor with 2x2 resolution.
 >> The buffer has resolution 4x4.
 >> One would like to crop area of size 1.5x1.5 and copy to to area 3x3 in
 >> memory buffer.
 >> Current Crop api does not allow it because first it does not support
 >> composing, second there is no subpixel resolution in crop rectangles.
 >>
 >> I know this could be solved in two ways:
 >> a) use S_SCALING:
 >> - set cropping 2x2 on sensor
 >> - set scaling 2x using S_SCALING
 >> - set compose in buffer as 3x3 area (it will work like clipping)
 >>
 >> b) use subpixel cropping:
 >> - set cropping area 1.5x1.5 using S_EXTCROP
 >> - set composing in buffer to 3x3 area
 >>
 >> The problem with solution a) is need of introduction new family of
 >> ioctls {G/S/TRY}_SCALING, and making composing work as clipping for
 >> scaled data.
 >>
 >> I suppose that subpixel cropping could be realized in one of two ways:
 >> 1. Introducing v4l2_fract_rect structure. Its all fields type would be
 >> v4l2_fract.
 >> 2. Use one of reserved fields in v4l2_selection as divisor for
 >> coordinates in v4l2_selection::r.
 >>
 >> What is your opinion?
 >>
 >>
 >>>> - merge v4l2_selection::target and v4l2_selection::flags into single
 >>>> field - allow using VIDIOC_S_EXTCROP with target type
 >>>> V4L2_SEL_TARGET_BOUNDS to
 >>>>
 >>>>   choose a resolution of a sensor
 >>>>
 >>> Too obscure IMHO. That said, it would be nice to have a more explicit
 >>> method of selecting a sensor resolution. You can enumerate them, 
but you
 >>> choose it using VIDIOC_S_FMT, which I've always thought was very
 >>> dubious. This prevents any sensor-built-in scalers from being used. For
 >>> video you have S_STD and S_DV_PRESET that select a particular input
 >>> resolution, but a similar ioctl is missing for sensors. Laurent, what
 >>> are your thoughts?
 >>>
 >>>
 >>>> - add TRY flag to ask a driver to adjust a rectangle without 
applying it
 >>>>
 >>> Don't use a flag, use TRY_EXTCROP and TRY_COMPOSE, just like the other
 >>> try ioctls. Otherwise I'm in favor of this.
 >>>
 >
 > I actually like the flag better :-) It avoid adding too many new 
ioctls and
 > it's in line with what we do on subdevs.
 >
 >


