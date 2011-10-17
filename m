Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2452 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab1JQRDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Oct 2011 13:03:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] Improved handling of presets
Date: Mon, 17 Oct 2011 19:03:24 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Mats Randgaard <mats.randgaard@cisco.com>
References: <201110171032.08466.hverkuil@xs4all.nl> <4E9C4B6A.7020902@redhat.com>
In-Reply-To: <4E9C4B6A.7020902@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110171903.24297.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, October 17, 2011 17:36:10 Mauro Carvalho Chehab wrote:
> Em 17-10-2011 06:32, Hans Verkuil escreveu:
> > RFC: Improved handling of presets
> > =================================
> > 
> > This RFC attempts to resolve the issues raised by this thread a few months ago:
> > 
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg33981.html
> > 
> > The last post in this thread did a good job of summarizing the discussion:
> > 
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg34190.html
> > 
> > I think it is time to revisit this problem. It basically boils down to the fact
> > that the current preset API is too limited and somewhat awkward and I agree
> > with that.
> > 
> > Now, I really do not like the idea of creating a preset2 API. Instead I think
> > it is better to extend the current dv_timings API with new ioctls:
> > 
> > VIDIOC_QUERY_DV_TIMINGS
> > VIDIOC_ENUM_DV_TIMINGS
> > VIDIOC_DV_TIMINGS_CAP
> > 
> > These form a superset of the preset API and once this is in place we can
> > deprecate some or all of the preset ioctls and eventually remove them (say
> > in one or two years).
> 
> Those 3 new ioctl's are, in practice, a preset2 API. I hate needing to deprecate
> an API, but, if this is needed, better to do earlier than later. Let's not spend
> our time investing on a dead horse.
> 
> > Here is the current definition of the v4l2_dv_timings struct from videodev2.h:
> > 
> > /* BT.656/BT.1120 timing data */
> > struct v4l2_bt_timings {
> > 	__u32	width;		/* width in pixels */
> > 	__u32	height;		/* height in lines */
> > 	__u32	interlaced;	/* Interlaced or progressive */
> > 	__u32	polarities;	/* Positive or negative polarity */
> > 	__u64	pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
> > 	__u32	hfrontporch;	/* Horizpontal front porch in pixels */
> > 	__u32	hsync;		/* Horizontal Sync length in pixels */
> > 	__u32	hbackporch;	/* Horizontal back porch in pixels */
> > 	__u32	vfrontporch;	/* Vertical front porch in pixels */
> > 	__u32	vsync;		/* Vertical Sync length in lines */
> > 	__u32	vbackporch;	/* Vertical back porch in lines */
> > 	__u32	il_vfrontporch;	/* Vertical front porch for bottom field of
> > 				 * interlaced field formats
> > 				 */
> > 	__u32	il_vsync;	/* Vertical sync length for bottom field of
> > 				 * interlaced field formats
> > 				 */
> > 	__u32	il_vbackporch;	/* Vertical back porch for bottom field of
> > 				 * interlaced field formats
> > 				 */
> > 	__u32	reserved[16];
> > } __attribute__ ((packed));
> > 
> > /* Interlaced or progressive format */
> > #define	V4L2_DV_PROGRESSIVE	0
> > #define	V4L2_DV_INTERLACED	1
> > 
> > /* Polarities. If bit is not set, it is assumed to be negative polarity */
> > #define V4L2_DV_VSYNC_POS_POL	0x00000001
> > #define V4L2_DV_HSYNC_POS_POL	0x00000002
> > 
> > /* DV timings */
> > struct v4l2_dv_timings {
> > 	__u32 type;
> > 	union {
> > 		struct v4l2_bt_timings	bt;
> > 		__u32	reserved[32];
> > 	};
> > } __attribute__ ((packed));
> > 
> > /* Values for the type field */
> > #define V4L2_DV_BT_656_1120	0	/* BT.656/1120 timing type */
> > 
> > This API allows you to set and get all the timings details. Its current
> > use is to allow userspace to set non-standard timings and it is used only in
> > the dm646x davinci drivers at the moment.
> > 
> > I propose the following additions:
> > 
> > 1) Add a standards field to v4l2_bt_timings:
> > 
> > 	__u32 standards;
> 
> Seems fine for get/query/enum operations. It probably doesn't make sense for set.

No, it doesn't. For set it will just be ignored by the driver.

> > 
> >    Currently I have four standards:
> > 
> > 	#define V4L2_DV_BT_STD_CEA861	(1 << 0)
> > 	#define V4L2_DV_BT_STD_DMT	(1 << 1)  /* VESA Discrete Monitor Timings */
> > 	#define V4L2_DV_BT_STD_CVT	(1 << 2)  /* VESA Coordinated Video Timings */
> > 	#define V4L2_DV_BT_STD_GTF	(1 << 3)  /* VESA Generalized Timings Formula */
> > 
> >    A particular timing can be part of 0 or more standards.
> >    Both CVT and GTF timings have a so-called 'reduced blanking' mode. It would be
> >    nice to represent this with a flag somewhere. I guess we need a flags field
> >    for that. The 'polarities' field really should have been called a 'flags' field.
> >    Oh well...
> 
> instead of flags, we may consider using something like:
> 	_u32 polarity:1
> 
> We need to double check if this is portable enough, however.

Bitfields aren't portable, unfortunately. But I wonder if we could do
something like this:

	union {
		__u32	polarities;	/* Positive or negative polarity */
		__u32	flags;
	};

and deprecate 'polarities' and remove it in a year.

I suspect that Cisco might be the only user of this API anyway with the
davinci drivers.

> > 2) Create a VIDIOC_ENUM_DV_TIMINGS ioctl:
> > 
> > 	struct v4l2_enum_dv_timings {
> > 		__u32 index;
> > 		char name[32];
> 
> Not sure about the "name" field. An u32 working as an enum could work better.

Huh? You need a name field for the human-readable description of the
timings, just like all other enum ioctls.

> > 		struct v4l2_dv_timings timings;
> > 		__u32 reserved[];
> 
> Adding a reserved here is probably an overkill, as there are already reserved
> fields at timings struct.

Probably true.

> > 	};
> > 
> > 	#define VIDIOC_ENUM_DV_TIMINGS     _IOWR('V', XX, struct v4l2_enum_dv_timings)
> > 
> >    This ioctl enumerates over all discrete supported timings and returns their
> >    name and timings.
> > 
> >    The timings field can be used as an input to S_DV_TIMINGS. The timings in
> >    this enumeration are guaranteed to be supported by the hardware.
> >    However, other custom timings may be supported as well (see my proposal
> >    for VIDIOC_DV_TIMINGS_CAP).
> 
> If I understood well, enum will show all timings officially supported by the
> hardware, right? The ones that are custom (e. g. doesn't belong to any standard,
> but, for some reason, the chipset vendor decided to add there) will have the
> standards field equal to 0, right?

Correct.

I have seen roughly two types of receivers/transmitters: those that only have a
limited list of timings, and those that can handle an almost unlimited range of
timings, typically only restricted by the maximum pixel clock and sometimes
blanking requirements.

The enum ioctl will return either the fixed list, or a representative list of
formats. In the latter case I am thinking of the various VGA-derived resolutions
and the 720p/1080p variants. That's typically what a user wants to see.

Vendor-specific formats may be added as well if there is some good reason for
it.

> If so, it seems to be doing its job.
> 
> > 3) Create a VIDIOC_QUERY_DV_TIMINGS ioctl:
> > 
> > 	struct v4l2_query_dv_timings {
> > 		__u32 state;
> > 		__u32 index;
> > 		struct v4l2_dv_timings timings;
> > 		__u32 reserved[];
> > 	};
> > 
> > 	#define V4L2_QUERY_STATE_NO_TIMINGS	0
> > 	#define V4L2_QUERY_STATE_UNSUPP_TIMINGS	1
> > 	#define V4L2_QUERY_STATE_SUPP_TIMINGS	2
> > 
> > 	#define VIDIOC_QUERY_DV_TIMINGS     _IOR('V', XX, struct v4l2_query_dv_timings)
> 
> Hmm... are you meant to using it to detect the supported DV's from a certain
> input?

It is the DV equivalent of QUERYSTD: so detecting what video format is found
on the input.

> I'm not a TV/monitor set expert. I'm not sure if this is enough, as some devices might 
> accept a continuous range for some timings parameter. Maybe it makes sense to have a
> "type" field here in order to allow future expansion.
> 
> Something like:
> 
>  	struct v4l2_query_dv_timings {
>  		__u32 state;		/* In fact, I think this should be removed. See bellow */

bellow -> below. I'm going to cure you of this typo one of these days :-)

>  		__u32 index;
> #define V4L2_DV_QUERY_TYPE_DISCRETE
> 		__u32 type;

I don't really see what this adds. The BT656 et al doesn't have a range.
Should a new interface appear that needs a range, then that also means a new
timings type (and we already have a field for that).

> 		union {
> 	 		struct v4l2_dv_timings timings;
> 			__u32 reserved[128];
> 		};
>  	};
>  
> 
> >    There are three states:
> > 
> >    1 - no timings could be detected. Call ENUM_INPUT to find out why.
> 
> If the input doesn't accept DV timings, just return some error code.
> It makes sense to define different error codes for each possible condition:
> 	- input(or output) is analog (so, no DV is supported);
> 	- TV set/monitor doesn't support querying DV;
> 	- chipset doesn't support it (ENOTTY);
> 	- index out of range (EINVAL).

An error could indeed be returned in this case.

> >    2 - timings could be detected, and the timings struct is filled in, but they
> >        are not supported by other parts of the hardware. Call DV_TIMINGS_CAP
> >        and check the timings against the capabilities to find out why.
> 
> If the timing is known to not be supported by part of the hardware, any trial to use it
> should be denied (EINVAL).
> 
> As such, it doesn't make any sense to return a DV timing that is known to not be 
> supported by the hardware.

It does. Where this becomes important is when you have to tell the user *why* it
isn't working. It is quite common that the receiver i2c device can handle the format
it receives, but other parts in the pipeline can't. Examples: the receiver can
handle interlaced formats, but the FPGA only does progressive, or the receiver can
handle higher clock frequencies than other parts of the pipeline can (these are
real-life examples).

By returning this information you can check against the capabilities and
actualy produce a sensible user message.

> It should be noticed that the "standards" field equal to 0 already indicates that such
> timing is not part of any known standard. So, if the idea here was to let userspace know
> what are the "preferred" timings, it can just use the standards field.

Hmm, I think you misinterpret this ioctl. It's not about preferred timings, it's
about discovering what timings the video on the input uses.

> Maybe it makes sense to add a "standard" flag to indicate that the timing matches an
> existing timing at the drivers timing table, as it may have some de-facto timings supported
> by both the monitor/tv set and the hardware, but not officially (yet) part of any standard.
> 
> >    3 - timings are detected and are supported.
> > 
> >    The index can be used with ENUM_DV_TIMINGS to get the name. If the timings
> >    are not part of the enumerated timings list, then index is set to 0xffffffff
> >    (or at least some value that will cause ENUM_DV_TIMINGS to return EINVAL).
> >    That value would be represented by a macro such as V4L2_QUERY_UNKNOWN_INDEX.
> 
> The index should be something between 0 to n, where n is the last supported DV timing.
> using it for anything else than that will make this different than the other VIDIOC_ENUM
> ioctl's, making the API messy.
> 
> If the device needs to return EINVAL, just return it, instead of adding any tricks.

I'd better add a new field then, such as: 'is_custom', if the incoming video has
valid timings that are not in the enum list.

For example: 1024x768 is a standard XGA resolution which comes in a number of fps
values. So XGA@60 would be a resolution that's part of the enum list. But it's
quite possible to send it 1028x768@60. This is non-standard, but QUERY_DV_TIMINGS
should still be able to detect it (if the hardware can, of course).

In that case the 'index' field can't be used, but the timings struct must be instead.

> 
> > 4) Create a VIDIOC_DV_TIMINGS_CAP ioctl:
> > 
> > 	/* BT.656/BT.1120 timing capabilities */
> > 	struct v4l2_bt_timings_cap {
> > 		__u32	min_width;	/* width in pixels */
> > 		__u32	max_width;	/* width in pixels */
> > 		__u32	min_height;	/* height in lines */
> > 		__u32	max_height;	/* height in lines */
> > 		__u64	min_pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
> > 		__u64	max_pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
> > 		__u32	standards;	/* Supported standards */
> > 		__u32	flags;		/* Interlaced or progressive */
> > 		__u32	reserved[16];
> > 	} __attribute__ ((packed));
> > 
> > 	/* Supports interlaced formats */
> > 	#define V4L2_DV_BT_CAP_INTERLACED	(1 << 0)
> > 	/* Supports progressive formats */
> > 	#define V4L2_DV_BT_CAP_PROGRESSIVE	(1 << 1)
> > 	/* Supports reduced blanking formats */
> > 	#define V4L2_DV_BT_CAP_REDUCED_BLANKING	(1 << 2)
> > 	/* Supports custom formats */
> > 	#define V4L2_DV_BT_CAP_CUSTOM		(1 << 3)
> > 
> > 	/* DV timings capabilities */
> > 	struct v4l2_dv_timings_cap {
> > 		__u32 type;
> > 		union {
> > 			struct v4l2_bt_timings_cap bt;
> > 			__u32	reserved[32];
> > 		};
> > 	} __attribute__ ((packed));
> > 
> > 	#define VIDIOC_DV_TIMINGS_CAP     _IOWR('V', XX, struct v4l2_dv_timings_cap)
> > 
> >    This ioctl can be used to query the driver for the supported capabilities.
> >    Most speak for themselves. If V4L2_DV_BT_CAP_CUSTOM is not set, then only
> >    the timings from ENUM_DV_TIMINGS can be used, if it is set, then the hardware
> >    also supports timings that are not in that list.
> 
> What information would this ioctl return? The DV times supported by the chipset?
> The ones supported by the TV set/monitor? The subset that it is supported by the
> entire pipeline?

The latter. It's about finding the limitations of the hardware. It's not about
the limitations of whatever you hook up to the hardware, that's handled by
EDID negotiations, etc.

> 
> What happens if the user changes the TV set and/or monitor? A practical case to consider:
> how this would handle things like a KVM (Keyboard, Video Monitor) switch?
> 
> I think it may need a field to indicate if the TV set/monitor were detected, and maybe
> the screen size, in cm or pols (in order to help sizing the letters for OSD).
> 
> Side note: I have this problem here on my current environment: if I start X here with my
> KVM switched to another monitor, X miss-detects the screen size (in pols), and uses bigger fonts.
> This happens because, when X starts, it tries to read the EDID information from my monitor, but
> it won't answer, as is connected to another computer. I'm not sure what my KVM
> device answers to it, but it is clear to me that it is not providing the complete data to X.

This is faulty EDID handling, nothing to do with this API.

The better KVM switches should be able to deal with this intelligently, but intelligent
EDID handling is a rather hit and miss in my experience.

> > 5) It can be dangerous to allow userspace to set up random timings for an output
> >    as this can damage monitors. It depends on various factors whether or not this
> >    should be protected by requiring root access. This has to be signalled somehow.
> >    I think that we should add a flag to v4l2_enum_dv_timings that tells whether
> >    selecting that specific timing requires root permissions. And we also need a
> >    V4L2_DV_BT_CAP_CUSTOM_ROOT flag in struct v4l2_bt_timings_cap to signal
> >    whether setting up custom timings requires root permissions.
> 
> I think that custom settings should always require root, as they're not officially
> supported by the hardware, so, they could potentially cause damages.

'custom' != 'not officially supported'. 'Custom' means: not part of the enumerated
timings list. Since many receivers and transmitters support an almost infinite number
of timings you cannot say in general that custom settings require root. This has
more to do with how the input or output is hooked up.

Any transmitter that is hooked up to a DVI/HDMI output probably needs root, but
a transmitter that is hooked up to a known device (e.g. a monitor panel) and where
the driver can guarantee that the timings are always safe, than root shouldn't be
necessary. This is in the end a board-specific decision.

What I want to avoid is that applications are forced to run as root, even if
the designer of the board knows that there is no need for it.

> The ones returned by the query ioctl probably won't need, as the query should be
> checking at the entire pipeline if those timings are supported, so they're
> potentially safe.
> 
> 
> > 6) Parsing the timings structures can be difficult, and for many applications
> >    you are just interested in finding certain industry standard timings.
> > 
> >    This was the idea behind the original preset API, and I still think that
> >    that is very useful in practice.
> >    
> >    My general view is that the preset API should be deprecated and eventually
> >    removed. After extending the timings API I see no more need for the preset
> >    API.
> 
> That's my impression too. Considering that the end result is that the old API will
> be removed, I don't think we should be bind to keep the same data structure. If/where
> it doesn't fit well, just replace it by something that fits (like the idea of having
> a "flags" field).
> 
> >    So that leaves the question how to incorporate the preset functionality in
> >    the timings API.
> > 
> >    I see two options:
> > 
> >    a) Add a preset or alias field to v4l2_enum_dv_timings. This just makes it
> >       easy for the application to check for specific formats and to store
> >       the timings.
> > 
> >    b) As a), but also add a new v4l2_dv_timings type: V4L2_DV_PRESET (or DV_ALIAS).
> >       This also has a struct v4l2_dv_preset (or dv_alias) that is used to store
> >       the preset value. This way you can set a preset directly using
> >       VIDIOC_S_DV_TIMINGS.
> 
> c) discard struct v4l2_dv_preset, and add an optional v4l2_enum_dv_timings_v2.
> 
> At v4l2_enum_dv_timings_v2, zero would mean to use the timers. Any other value means that
> the timings should be discarded, an it should just use the timings for that enum.
> A query or enum iocl should fill it with a non-zero value for those enum standards that
> are supported by the driver.

You've lost me here. I've no idea what you mean here, sorry.

> In any case, we should create an enum namespace that won't have duplicate names for
> different settings, as we've discussed before.

Agreed.

> I suggest to implement some core functions to easy driver to handle the presets that are
> part of the existing standards.

That was the plan.


Regards,

	Hans

> 
> > 
> > 
> > Comments?
> > 
> > 	Hans Verkuil
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
