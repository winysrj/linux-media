Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:5277 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab1JROZF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 10:25:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] Improved handling of presets
Date: Tue, 18 Oct 2011 16:24:41 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Mats Randgaard <mats.randgaard@cisco.com>
References: <201110171032.08466.hverkuil@xs4all.nl> <201110171903.24297.hverkuil@xs4all.nl> <4E9D6EDC.3010206@redhat.com>
In-Reply-To: <4E9D6EDC.3010206@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110181624.41565.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 18 October 2011 14:19:40 Mauro Carvalho Chehab wrote:
> Em 17-10-2011 15:03, Hans Verkuil escreveu:
> > On Monday, October 17, 2011 17:36:10 Mauro Carvalho Chehab wrote:
> >> Em 17-10-2011 06:32, Hans Verkuil escreveu:
> >>>    Currently I have four standards:
> >>> 	#define V4L2_DV_BT_STD_CEA861	(1 << 0)
> >>> 	#define V4L2_DV_BT_STD_DMT	(1 << 1)  /* VESA Discrete Monitor 
Timings
> >>> 	*/ #define V4L2_DV_BT_STD_CVT	(1 << 2)  /* VESA Coordinated Video
> >>> 	Timings */ #define V4L2_DV_BT_STD_GTF	(1 << 3)  /* VESA Generalized
> >>> 	Timings Formula */
> >>> 	
> >>>    A particular timing can be part of 0 or more standards.
> >>>    Both CVT and GTF timings have a so-called 'reduced blanking' mode.
> >>>    It would be nice to represent this with a flag somewhere. I guess
> >>>    we need a flags field for that. The 'polarities' field really
> >>>    should have been called a 'flags' field. Oh well...
> >> 
> >> instead of flags, we may consider using something like:
> >> 	_u32 polarity:1
> >> 
> >> We need to double check if this is portable enough, however.
> > 
> > Bitfields aren't portable, unfortunately. But I wonder if we could do
> > 
> > something like this:
> > 	union {
> > 	
> > 		__u32	polarities;	/* Positive or negative polarity */
> > 		__u32	flags;
> > 	
> > 	};
> > 
> > and deprecate 'polarities' and remove it in a year.
> 
> If the idea is to replace the existing ioctl's, just name it as flags for
> the structs used by the new ones. The old "polarities" will be removed
> together with the removal of the old ioctl's.

Do we want to replace the current DV_TIMINGS ioctls? I don't see a need for
that, to be honest. It's just the name of this field that's awkward.

> > I suspect that Cisco might be the only user of this API anyway with the
> > davinci drivers.
> 
> Likely.
> 
> >>> 2) Create a VIDIOC_ENUM_DV_TIMINGS ioctl:
> >>> 	struct v4l2_enum_dv_timings {
> >>> 	
> >>> 		__u32 index;
> >>> 		char name[32];
> >> 
> >> Not sure about the "name" field. An u32 working as an enum could work
> >> better.
> > 
> > Huh? You need a name field for the human-readable description of the
> > timings, just like all other enum ioctls.
> 
> The naming here could be something completely arbitrary, especially for
> custom timings. I'm ok if you insist on keeping it, but I don't think that
> this would bring any value. If userspace needs naming, it can give
> whatever name it wants, as all data for the timings are there: standards,
> resolutions, fps, etc.
> 
> So, userspace could for example do something like:
> 
> sprintf ("%s%dx%d_%.02ffps",
> 	dv_standard_name(dv),
> 	dv->width,
> 	dv->height,
> 	dv->pixelclock/(dv->width * dv->height));

It is common to refer to certain standard resolutions by an alias such as
720p60 or "XGA @ 60". A name would be useful for that.

For consistency in general I also think it is better if the kernel generates
the name rather than having userspace do that. Whether the kernel should use
the alias as (part of) the name is something we need to debate. I'm not sure
either way.

> >>> 		struct v4l2_dv_timings timings;
> >>> 		__u32 reserved[];
> >> 
> >> Adding a reserved here is probably an overkill, as there are already
> >> reserved fields at timings struct.
> > 
> > Probably true.
> > 
> >>> 	};
> >>> 	
> >>> 	#define VIDIOC_ENUM_DV_TIMINGS     _IOWR('V', XX, struct
> >>> 	v4l2_enum_dv_timings)
> >>> 	
> >>>    This ioctl enumerates over all discrete supported timings and
> >>>    returns their name and timings.
> >>>    
> >>>    The timings field can be used as an input to S_DV_TIMINGS. The
> >>>    timings in this enumeration are guaranteed to be supported by the
> >>>    hardware. However, other custom timings may be supported as well
> >>>    (see my proposal for VIDIOC_DV_TIMINGS_CAP).
> >> 
> >> If I understood well, enum will show all timings officially supported by
> >> the hardware, right? The ones that are custom (e. g. doesn't belong to
> >> any standard, but, for some reason, the chipset vendor decided to add
> >> there) will have the standards field equal to 0, right?
> > 
> > Correct.
> > 
> > I have seen roughly two types of receivers/transmitters: those that only
> > have a limited list of timings, and those that can handle an almost
> > unlimited range of timings, typically only restricted by the maximum
> > pixel clock and sometimes blanking requirements.
> > 
> > The enum ioctl will return either the fixed list, or a representative
> > list of formats. In the latter case I am thinking of the various
> > VGA-derived resolutions and the 720p/1080p variants. That's typically
> > what a user wants to see.
> 
> As proposed, this ioctl will only fine for those with a limited list of
> timings, but it doesn't cover well the "unlimited range" case.
> 
> For nowadays needs, the discrete list is probably OK, but adding a "type"
> field like what I've proposed below would allow adding other ways to
> better cover the "unlimited range of timings".

Ah, now I understand. I'm OK with adding a type field here.

> 
> > Vendor-specific formats may be added as well if there is some good reason
> > for it.
> > 
> >> If so, it seems to be doing its job.
> >> 
> >>> 3) Create a VIDIOC_QUERY_DV_TIMINGS ioctl:
> >>> 	struct v4l2_query_dv_timings {
> >>> 	
> >>> 		__u32 state;
> >>> 		__u32 index;
> >>> 		struct v4l2_dv_timings timings;
> >>> 		__u32 reserved[];
> >>> 	
> >>> 	};
> >>> 	
> >>> 	#define V4L2_QUERY_STATE_NO_TIMINGS	0
> >>> 	#define V4L2_QUERY_STATE_UNSUPP_TIMINGS	1
> >>> 	#define V4L2_QUERY_STATE_SUPP_TIMINGS	2
> >>> 	
> >>> 	#define VIDIOC_QUERY_DV_TIMINGS     _IOR('V', XX, struct
> >>> 	v4l2_query_dv_timings)
> >> 
> >> Hmm... are you meant to using it to detect the supported DV's from a
> >> certain input?
> > 
> > It is the DV equivalent of QUERYSTD: so detecting what video format is
> > found on the input.
> > 
> >> I'm not a TV/monitor set expert. I'm not sure if this is enough, as some
> >> devices might accept a continuous range for some timings parameter.
> >> Maybe it makes sense to have a "type" field here in order to allow
> >> future expansion.
> >> 
> >> Something like:
> >>  	struct v4l2_query_dv_timings {
> >>  	
> >>  		__u32 state;		/* In fact, I think this should be 
removed. See bellow
> >>  		*/
> > 
> > bellow -> below. I'm going to cure you of this typo one of these days :-)
> :
> :)
> :
> >>  		__u32 index;
> >> 
> >> #define V4L2_DV_QUERY_TYPE_DISCRETE
> >> 
> >> 		__u32 type;
> > 
> > I don't really see what this adds. The BT656 et al doesn't have a range.
> > Should a new interface appear that needs a range, then that also means a
> > new timings type (and we already have a field for that).
> 
> The non-discrete types would cover the cases that you called before as
> "unlimited range of timings".
> 
> >> 		union {
> >> 		
> >> 	 		struct v4l2_dv_timings timings;
> >> 			
> >> 			__u32 reserved[128];
> >> 		
> >> 		};
> >> 		
> >>  	};
> >>  	
> >>>    There are three states:
> >>>    
> >>>    1 - no timings could be detected. Call ENUM_INPUT to find out why.
> >> 
> >> If the input doesn't accept DV timings, just return some error code.
> >> 
> >> It makes sense to define different error codes for each possible 
condition:
> >> 	- input(or output) is analog (so, no DV is supported);
> >> 	- TV set/monitor doesn't support querying DV;
> >> 	- chipset doesn't support it (ENOTTY);
> >> 	- index out of range (EINVAL).
> > 
> > An error could indeed be returned in this case.
> > 
> >>>    2 - timings could be detected, and the timings struct is filled in,
> >>>    but they
> >>>    
> >>>        are not supported by other parts of the hardware. Call
> >>>        DV_TIMINGS_CAP and check the timings against the capabilities
> >>>        to find out why.
> >> 
> >> If the timing is known to not be supported by part of the hardware, any
> >> trial to use it should be denied (EINVAL).
> >> 
> >> As such, it doesn't make any sense to return a DV timing that is known
> >> to not be supported by the hardware.
> > 
> > It does. Where this becomes important is when you have to tell the user
> > *why* it isn't working. It is quite common that the receiver i2c device
> > can handle the format it receives, but other parts in the pipeline
> > can't. Examples: the receiver can handle interlaced formats, but the
> > FPGA only does progressive, or the receiver can handle higher clock
> > frequencies than other parts of the pipeline can (these are real-life
> > examples).
> > 
> > By returning this information you can check against the capabilities and
> > actualy produce a sensible user message.
> 
> There's no way to tell userspace where the problem is, e. g. in each
> part of the pipeline the timing is not supported. Also, it doesn't seem to
> be the usual usecase to show invalid entries, as it helps only when
> there's no match.
> 
> IMO, if this feature is really needed, I would add a "filter" bitmask
> parameter that would allow showing those invalid timings. if filter is
> zero, it will show only the timings that are valid. Otherwise, it will
> show the valid timings, plus the invalid ones that match the filter. At
> the return, those valid parameters will fill the filter with 0, and the
> invalid will fill it with the parts of the pipeline where it is not
> supported.
> 
> Another option would be to implement the DV's at pad level. So, userspace
> could query it at pad level, when no timing were found. This is probably
> the better solution.
> 
> >> It should be noticed that the "standards" field equal to 0 already
> >> indicates that such timing is not part of any known standard. So, if
> >> the idea here was to let userspace know what are the "preferred"
> >> timings, it can just use the standards field.
> > 
> > Hmm, I think you misinterpret this ioctl. It's not about preferred
> > timings, it's about discovering what timings the video on the input
> > uses.
> 
> No. You miss-interpreted my comment. What I meant to say is that userspace
> may prefer to set a DV timing that is supported by some standard (as it is
> better to get something known than to just randomly choosing a
> non-official timing).
> 
> A DV query will return all supported timings.

No! The DV_QUERY ioctl returns the timings of the video that is arriving at
the receiver. Identical to QUERYSTD for SDTV receivers. And (as per the irc
discussion we had today) just as with QUERYSTD this is best-effort only.

I will attempt to make a new RFC tomorrow that hopefully clarifies my
proposal and incorporates some of your comments.

Regards,

	Hans

> By having the standards field
> properly filled, the userspace detection algorithm that chooses the DV
> timing to be used could benefit of the "standards" information, in order
> to select the DV timing to be used.
> 
> >> Maybe it makes sense to add a "standard" flag to indicate that the
> >> timing matches an existing timing at the drivers timing table, as it
> >> may have some de-facto timings supported by both the monitor/tv set and
> >> the hardware, but not officially (yet) part of any standard.
> >> 
> >>>    3 - timings are detected and are supported.
> >>>    
> >>>    The index can be used with ENUM_DV_TIMINGS to get the name. If the
> >>>    timings are not part of the enumerated timings list, then index is
> >>>    set to 0xffffffff (or at least some value that will cause
> >>>    ENUM_DV_TIMINGS to return EINVAL). That value would be represented
> >>>    by a macro such as V4L2_QUERY_UNKNOWN_INDEX.
> >> 
> >> The index should be something between 0 to n, where n is the last
> >> supported DV timing. using it for anything else than that will make
> >> this different than the other VIDIOC_ENUM ioctl's, making the API
> >> messy.
> >> 
> >> If the device needs to return EINVAL, just return it, instead of adding
> >> any tricks.
> > 
> > I'd better add a new field then, such as: 'is_custom', if the incoming
> > video has valid timings that are not in the enum list.
> 
> You don't need: standards = 0 already says that. That's what I said before,
> and that you've miss-interpreted ;)
> 
> > For example: 1024x768 is a standard XGA resolution which comes in a
> > number of fps values. So XGA@60 would be a resolution that's part of the
> > enum list. But it's quite possible to send it 1028x768@60. This is
> > non-standard, but QUERY_DV_TIMINGS should still be able to detect it (if
> > the hardware can, of course).
> > 
> > In that case the 'index' field can't be used, but the timings struct must
> > be instead.
> 
> index != enum
> 
> The index here should be a plain sequential number, just like any other
> enum ioctl. Anything different than that is messy and will prevent
> userspace to properly query the supported standards.
> 
> The typical query loop on userspace should be something like:
> 
> int rc, index = 0;
> 
> for (index = 0; 1; index++) {
> 	rc = ioctl(fd, VIDIOC_QUERY_DV_TIMINGS, &data);
> 	if (rc == -1 && rc == -EINVAL)
> 		break;
> 	if (rc == 0) {
> 		/* Handle the DV timing */
> 	} else {
> 		/* Handle an error condition */
> 	}
> }
> 
> >>> 4) Create a VIDIOC_DV_TIMINGS_CAP ioctl:
> >>> 	/* BT.656/BT.1120 timing capabilities */
> >>> 	struct v4l2_bt_timings_cap {
> >>> 	
> >>> 		__u32	min_width;	/* width in pixels */
> >>> 		__u32	max_width;	/* width in pixels */
> >>> 		__u32	min_height;	/* height in lines */
> >>> 		__u32	max_height;	/* height in lines */
> >>> 		__u64	min_pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz-
>74250000 */
> >>> 		__u64	max_pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz-
>74250000 */
> >>> 		__u32	standards;	/* Supported standards */
> >>> 		__u32	flags;		/* Interlaced or progressive */
> >>> 		__u32	reserved[16];
> >>> 	
> >>> 	} __attribute__ ((packed));
> >>> 	
> >>> 	/* Supports interlaced formats */
> >>> 	#define V4L2_DV_BT_CAP_INTERLACED	(1 << 0)
> >>> 	/* Supports progressive formats */
> >>> 	#define V4L2_DV_BT_CAP_PROGRESSIVE	(1 << 1)
> >>> 	/* Supports reduced blanking formats */
> >>> 	#define V4L2_DV_BT_CAP_REDUCED_BLANKING	(1 << 2)
> >>> 	/* Supports custom formats */
> >>> 	#define V4L2_DV_BT_CAP_CUSTOM		(1 << 3)
> >>> 	
> >>> 	/* DV timings capabilities */
> >>> 	struct v4l2_dv_timings_cap {
> >>> 	
> >>> 		__u32 type;
> >>> 		union {
> >>> 		
> >>> 			struct v4l2_bt_timings_cap bt;
> >>> 			__u32	reserved[32];
> >>> 		
> >>> 		};
> >>> 	
> >>> 	} __attribute__ ((packed));
> >>> 	
> >>> 	#define VIDIOC_DV_TIMINGS_CAP     _IOWR('V', XX, struct
> >>> 	v4l2_dv_timings_cap)
> >>> 	
> >>>    This ioctl can be used to query the driver for the supported
> >>>    capabilities. Most speak for themselves. If V4L2_DV_BT_CAP_CUSTOM
> >>>    is not set, then only the timings from ENUM_DV_TIMINGS can be used,
> >>>    if it is set, then the hardware also supports timings that are not
> >>>    in that list.
> >> 
> >> What information would this ioctl return? The DV times supported by the
> >> chipset? The ones supported by the TV set/monitor? The subset that it
> >> is supported by the entire pipeline?
> > 
> > The latter. It's about finding the limitations of the hardware. It's not
> > about the limitations of whatever you hook up to the hardware, that's
> > handled by EDID negotiations, etc.
> > 
> >> What happens if the user changes the TV set and/or monitor? A practical
> >> case to consider: how this would handle things like a KVM (Keyboard,
> >> Video Monitor) switch?
> >> 
> >> I think it may need a field to indicate if the TV set/monitor were
> >> detected, and maybe the screen size, in cm or pols (in order to help
> >> sizing the letters for OSD).
> >> 
> >> Side note: I have this problem here on my current environment: if I
> >> start X here with my KVM switched to another monitor, X miss-detects
> >> the screen size (in pols), and uses bigger fonts. This happens because,
> >> when X starts, it tries to read the EDID information from my monitor,
> >> but it won't answer, as is connected to another computer. I'm not sure
> >> what my KVM device answers to it, but it is clear to me that it is not
> >> providing the complete data to X.
> > 
> > This is faulty EDID handling, nothing to do with this API.
> > 
> > The better KVM switches should be able to deal with this intelligently,
> > but intelligent EDID handling is a rather hit and miss in my experience.
> 
> I agree, but reality is different. Not sure if we can actually do
> something, but an unconnected monitor (or a bad KVM) would result on an
> empty return from such query at device level.
> 
> >>> 5) It can be dangerous to allow userspace to set up random timings for
> >>> an output
> >>> 
> >>>    as this can damage monitors. It depends on various factors whether
> >>>    or not this should be protected by requiring root access. This has
> >>>    to be signalled somehow. I think that we should add a flag to
> >>>    v4l2_enum_dv_timings that tells whether selecting that specific
> >>>    timing requires root permissions. And we also need a
> >>>    V4L2_DV_BT_CAP_CUSTOM_ROOT flag in struct v4l2_bt_timings_cap to
> >>>    signal whether setting up custom timings requires root permissions.
> >> 
> >> I think that custom settings should always require root, as they're not
> >> officially supported by the hardware, so, they could potentially cause
> >> damages.
> > 
> > 'custom' != 'not officially supported'. 'Custom' means: not part of the
> > enumerated timings list. Since many receivers and transmitters support
> > an almost infinite number of timings you cannot say in general that
> > custom settings require root. This has more to do with how the input or
> > output is hooked up.
> 
> True, but if the timing were not enumerated, it means that there were no
> test for that specific timing (as it is very doubt that the vendors will
> test the entire timings range, as there are literally millions or billions
> of different combinations).
> 
> Look: if both the TV/monitor set and the pipeline says that they support an
> specific DV timing combination, such timing should be safe, as those
> timings are officially supported. So, root is not needed.
> 
> All the other possible timings are "likely" safe, at best. So, root access
> should be required.
> 
> > Any transmitter that is hooked up to a DVI/HDMI output probably needs
> > root,
> 
> Why? if the TV set connected into it supports EDID, and the selected timing
> were enumerated by both, root shouldn't be needed, as both chipset and
> pipeline explicitly says that such timing is supported.
> 
> > but
> > a transmitter that is hooked up to a known device (e.g. a monitor panel)
> > and where the driver can guarantee that the timings are always safe,
> > than root shouldn't be necessary. This is in the end a board-specific
> > decision.
> 
> On a system where the monitor is physically part of the device and there's
> no way to replace the monitor with something else, then all hardware is
> well known. However, on such system, it doesn't make sense for the driver
> to offer support for custom timings.
> 
> With great powers, comes great responsibility.
> 
> > What I want to avoid is that applications are forced to run as root, even
> > if the designer of the board knows that there is no need for it.
> 
> The entire application doesn't need to be root. Just the code that would
> set a custom DV. Xawtv has a v4l-conf application specifically designed
> for those ioctl's that require root. Similar approaches could be used when
> DV custom timings are needed.
> 
> >> The ones returned by the query ioctl probably won't need, as the query
> >> should be checking at the entire pipeline if those timings are
> >> supported, so they're potentially safe.
> >> 
> >>> 6) Parsing the timings structures can be difficult, and for many
> >>> applications
> >>> 
> >>>    you are just interested in finding certain industry standard
> >>>    timings.
> >>>    
> >>>    This was the idea behind the original preset API, and I still think
> >>>    that that is very useful in practice.
> >>>    
> >>>    My general view is that the preset API should be deprecated and
> >>>    eventually removed. After extending the timings API I see no more
> >>>    need for the preset API.
> >> 
> >> That's my impression too. Considering that the end result is that the
> >> old API will be removed, I don't think we should be bind to keep the
> >> same data structure. If/where it doesn't fit well, just replace it by
> >> something that fits (like the idea of having a "flags" field).
> >> 
> >>>    So that leaves the question how to incorporate the preset
> >>>    functionality in the timings API.
> >>>    
> >>>    I see two options:
> >>>    
> >>>    a) Add a preset or alias field to v4l2_enum_dv_timings. This just
> >>>    makes it
> >>>    
> >>>       easy for the application to check for specific formats and to
> >>>       store the timings.
> >>>    
> >>>    b) As a), but also add a new v4l2_dv_timings type: V4L2_DV_PRESET
> >>>    (or DV_ALIAS).
> >>>    
> >>>       This also has a struct v4l2_dv_preset (or dv_alias) that is used
> >>>       to store the preset value. This way you can set a preset
> >>>       directly using VIDIOC_S_DV_TIMINGS.
> >> 
> >> c) discard struct v4l2_dv_preset, and add an optional
> >> v4l2_enum_dv_timings_v2.
> >> 
> >> At v4l2_enum_dv_timings_v2, zero would mean to use the timers. Any other
> >> value means that the timings should be discarded, an it should just use
> >> the timings for that enum. A query or enum iocl should fill it with a
> >> non-zero value for those enum standards that are supported by the
> >> driver.
> > 
> > You've lost me here. I've no idea what you mean here, sorry.
> 
> What I'm proposing is something like:
> 
> #define		V4L2_DV2_CUSTOM		0
> #define		V4L2_DV2_480P59_94	1 /* BT.1362 */
> #define		V4L2_DV2_576P50		2 /* BT.1362 */
> ...
> 
> (Disclaimer note: I just renamed the enums to _DV2_ to avoid re-using an
> existing name for the sake of my  example. I'm not proposing to use the
> above names)
> 
> If a DV set operation fills the enum field with V4L2_DV2_CUSTOM, then the
> timings will be specified at the DV timings structure. If any other value
> is used, the timings will come from the preset.
> 
> >> In any case, we should create an enum namespace that won't have
> >> duplicate names for different settings, as we've discussed before.
> > 
> > Agreed.
> > 
> >> I suggest to implement some core functions to easy driver to handle the
> >> presets that are part of the existing standards.
> > 
> > That was the plan.
> > 
> > 
> > Regards,
> > 
> > 	Hans
> > 	
> >>> Comments?
> >>> 
> >>> 	Hans Verkuil
> >>> 
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-media"
> >>> in the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> 
> >> Regards,
> >> Mauro
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media"
> >> in the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
