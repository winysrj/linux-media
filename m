Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:45799 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1JQIc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Oct 2011 04:32:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC] Improved handling of presets
Date: Mon, 17 Oct 2011 10:32:08 +0200
Cc: Mats Randgaard <mats.randgaard@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110171032.08466.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RFC: Improved handling of presets
=================================

This RFC attempts to resolve the issues raised by this thread a few months ago:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg33981.html

The last post in this thread did a good job of summarizing the discussion:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg34190.html

I think it is time to revisit this problem. It basically boils down to the fact
that the current preset API is too limited and somewhat awkward and I agree
with that.

Now, I really do not like the idea of creating a preset2 API. Instead I think
it is better to extend the current dv_timings API with new ioctls:

VIDIOC_QUERY_DV_TIMINGS
VIDIOC_ENUM_DV_TIMINGS
VIDIOC_DV_TIMINGS_CAP

These form a superset of the preset API and once this is in place we can
deprecate some or all of the preset ioctls and eventually remove them (say
in one or two years).

Here is the current definition of the v4l2_dv_timings struct from videodev2.h:

/* BT.656/BT.1120 timing data */
struct v4l2_bt_timings {
	__u32	width;		/* width in pixels */
	__u32	height;		/* height in lines */
	__u32	interlaced;	/* Interlaced or progressive */
	__u32	polarities;	/* Positive or negative polarity */
	__u64	pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
	__u32	hfrontporch;	/* Horizpontal front porch in pixels */
	__u32	hsync;		/* Horizontal Sync length in pixels */
	__u32	hbackporch;	/* Horizontal back porch in pixels */
	__u32	vfrontporch;	/* Vertical front porch in pixels */
	__u32	vsync;		/* Vertical Sync length in lines */
	__u32	vbackporch;	/* Vertical back porch in lines */
	__u32	il_vfrontporch;	/* Vertical front porch for bottom field of
				 * interlaced field formats
				 */
	__u32	il_vsync;	/* Vertical sync length for bottom field of
				 * interlaced field formats
				 */
	__u32	il_vbackporch;	/* Vertical back porch for bottom field of
				 * interlaced field formats
				 */
	__u32	reserved[16];
} __attribute__ ((packed));

/* Interlaced or progressive format */
#define	V4L2_DV_PROGRESSIVE	0
#define	V4L2_DV_INTERLACED	1

/* Polarities. If bit is not set, it is assumed to be negative polarity */
#define V4L2_DV_VSYNC_POS_POL	0x00000001
#define V4L2_DV_HSYNC_POS_POL	0x00000002

/* DV timings */
struct v4l2_dv_timings {
	__u32 type;
	union {
		struct v4l2_bt_timings	bt;
		__u32	reserved[32];
	};
} __attribute__ ((packed));

/* Values for the type field */
#define V4L2_DV_BT_656_1120	0	/* BT.656/1120 timing type */

This API allows you to set and get all the timings details. Its current
use is to allow userspace to set non-standard timings and it is used only in
the dm646x davinci drivers at the moment.

I propose the following additions:

1) Add a standards field to v4l2_bt_timings:

	__u32 standards;

   Currently I have four standards:

	#define V4L2_DV_BT_STD_CEA861	(1 << 0)
	#define V4L2_DV_BT_STD_DMT	(1 << 1)  /* VESA Discrete Monitor Timings */
	#define V4L2_DV_BT_STD_CVT	(1 << 2)  /* VESA Coordinated Video Timings */
	#define V4L2_DV_BT_STD_GTF	(1 << 3)  /* VESA Generalized Timings Formula */

   A particular timing can be part of 0 or more standards.
   Both CVT and GTF timings have a so-called 'reduced blanking' mode. It would be
   nice to represent this with a flag somewhere. I guess we need a flags field
   for that. The 'polarities' field really should have been called a 'flags' field.
   Oh well...


2) Create a VIDIOC_ENUM_DV_TIMINGS ioctl:

	struct v4l2_enum_dv_timings {
		__u32 index;
		char name[32];
		struct v4l2_dv_timings timings;
		__u32 reserved[];
	};

	#define VIDIOC_ENUM_DV_TIMINGS     _IOWR('V', XX, struct v4l2_enum_dv_timings)

   This ioctl enumerates over all discrete supported timings and returns their
   name and timings.

   The timings field can be used as an input to S_DV_TIMINGS. The timings in
   this enumeration are guaranteed to be supported by the hardware.
   However, other custom timings may be supported as well (see my proposal
   for VIDIOC_DV_TIMINGS_CAP).


3) Create a VIDIOC_QUERY_DV_TIMINGS ioctl:

	struct v4l2_query_dv_timings {
		__u32 state;
		__u32 index;
		struct v4l2_dv_timings timings;
		__u32 reserved[];
	};

	#define V4L2_QUERY_STATE_NO_TIMINGS	0
	#define V4L2_QUERY_STATE_UNSUPP_TIMINGS	1
	#define V4L2_QUERY_STATE_SUPP_TIMINGS	2

	#define VIDIOC_QUERY_DV_TIMINGS     _IOR('V', XX, struct v4l2_query_dv_timings)

   There are three states:

   1 - no timings could be detected. Call ENUM_INPUT to find out why.
   2 - timings could be detected, and the timings struct is filled in, but they
       are not supported by other parts of the hardware. Call DV_TIMINGS_CAP
       and check the timings against the capabilities to find out why.
   3 - timings are detected and are supported.

   The index can be used with ENUM_DV_TIMINGS to get the name. If the timings
   are not part of the enumerated timings list, then index is set to 0xffffffff
   (or at least some value that will cause ENUM_DV_TIMINGS to return EINVAL).
   That value would be represented by a macro such as V4L2_QUERY_UNKNOWN_INDEX.


4) Create a VIDIOC_DV_TIMINGS_CAP ioctl:

	/* BT.656/BT.1120 timing capabilities */
	struct v4l2_bt_timings_cap {
		__u32	min_width;	/* width in pixels */
		__u32	max_width;	/* width in pixels */
		__u32	min_height;	/* height in lines */
		__u32	max_height;	/* height in lines */
		__u64	min_pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
		__u64	max_pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
		__u32	standards;	/* Supported standards */
		__u32	flags;		/* Interlaced or progressive */
		__u32	reserved[16];
	} __attribute__ ((packed));

	/* Supports interlaced formats */
	#define V4L2_DV_BT_CAP_INTERLACED	(1 << 0)
	/* Supports progressive formats */
	#define V4L2_DV_BT_CAP_PROGRESSIVE	(1 << 1)
	/* Supports reduced blanking formats */
	#define V4L2_DV_BT_CAP_REDUCED_BLANKING	(1 << 2)
	/* Supports custom formats */
	#define V4L2_DV_BT_CAP_CUSTOM		(1 << 3)

	/* DV timings capabilities */
	struct v4l2_dv_timings_cap {
		__u32 type;
		union {
			struct v4l2_bt_timings_cap bt;
			__u32	reserved[32];
		};
	} __attribute__ ((packed));

	#define VIDIOC_DV_TIMINGS_CAP     _IOWR('V', XX, struct v4l2_dv_timings_cap)

   This ioctl can be used to query the driver for the supported capabilities.
   Most speak for themselves. If V4L2_DV_BT_CAP_CUSTOM is not set, then only
   the timings from ENUM_DV_TIMINGS can be used, if it is set, then the hardware
   also supports timings that are not in that list.


5) It can be dangerous to allow userspace to set up random timings for an output
   as this can damage monitors. It depends on various factors whether or not this
   should be protected by requiring root access. This has to be signalled somehow.
   I think that we should add a flag to v4l2_enum_dv_timings that tells whether
   selecting that specific timing requires root permissions. And we also need a
   V4L2_DV_BT_CAP_CUSTOM_ROOT flag in struct v4l2_bt_timings_cap to signal
   whether setting up custom timings requires root permissions.


6) Parsing the timings structures can be difficult, and for many applications
   you are just interested in finding certain industry standard timings.

   This was the idea behind the original preset API, and I still think that
   that is very useful in practice.
   
   My general view is that the preset API should be deprecated and eventually
   removed. After extending the timings API I see no more need for the preset
   API.

   So that leaves the question how to incorporate the preset functionality in
   the timings API.

   I see two options:

   a) Add a preset or alias field to v4l2_enum_dv_timings. This just makes it
      easy for the application to check for specific formats and to store
      the timings.

   b) As a), but also add a new v4l2_dv_timings type: V4L2_DV_PRESET (or DV_ALIAS).
      This also has a struct v4l2_dv_preset (or dv_alias) that is used to store
      the preset value. This way you can set a preset directly using
      VIDIOC_S_DV_TIMINGS.


Comments?

	Hans Verkuil
