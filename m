Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:59716 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab1JSOFc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Oct 2011 10:05:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFCv2] Improved handling of presets
Date: Wed, 19 Oct 2011 16:05:08 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mats Randgaard <mats.randgaard@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110191605.08366.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RFCv2: Improved handling of presets
===================================

Changes from RFCv1:

- Removed name[] in v4l2_enum_bt_timings.
- Improved the description of QUERY_DV_TIMINGS.
- Removed v4l2_query_dv_timings, instead reuse v4l2_dv_timings.
  The various 'states' of RFCv1 are now returned as error codes.
- Simplified signalling whether root permissions are required when
  setting the timings: just add a single flag to v4l2_dv_timings_cap.
- Add a section on EDID handling.



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
   One option is just to rename 'polarities' to 'flags' if Mauro would agree to that.
   The ABI would be preserved, but applications using the polarities field would no
   longer compile.

   The standards field is ignored when setting timings.


2) Create a VIDIOC_ENUM_DV_TIMINGS ioctl:

	struct v4l2_enum_dv_timings {
		__u32 index;
		__u32 reserved[3];
		struct v4l2_dv_timings timings;
	};

	#define VIDIOC_ENUM_DV_TIMINGS     _IOWR('V', XX, struct v4l2_enum_dv_timings)

   This ioctl enumerates over all discrete supported timings and returns their
   timings.

   The timings field can be used as an input to S_DV_TIMINGS. The timings in
   this enumeration are guaranteed to be supported by the hardware.
   However, other custom timings may be supported as well (see my proposal
   for VIDIOC_DV_TIMINGS_CAP).

   Mauro suggested adding a type field to struct v4l2_enum_dv_timings to make
   it possible in the future to support non-discrete timings (similar to what
   ENUM_FRAMESIZES does). I don't really see how that would work, and it also
   seems to be that that is something that the proposed VIDIOC_DV_TIMINGS_CAP
   already does. However, it doesn't hurt to add a few reserved fields so we
   can easily add a type field later.


3) Create a VIDIOC_QUERY_DV_TIMINGS ioctl. This ioctl will determine the timings of
   the video at the input connector. The purpose of this ioctl is identical to that
   of VIDIOC_QUERYSTD: determining the resolution and framerate of the input video.
   VIDIOC_QUERY_DV_TIMINGS is specific to receivers.

	#define VIDIOC_QUERY_DV_TIMINGS     _IOR('V', XX, struct v4l2_dv_timings)

   There are three states:

   1 - No timings could be detected. Call ENUM_INPUT to find out why.
       A specific error code is returned in this case by VIDIOC_QUERY_DV_TIMINGS.
       Possible error codes: EPIPE, ENOLINK, EXDEV, ENODATA.
   2 - Timings could be detected, and the timings struct is filled in, but they
       are not supported by other parts of the hardware. Call DV_TIMINGS_CAP
       and check the timings against the capabilities to find out why.
       In this case another error code is returned. Suggested error code: ERANGE.
   3 - Timings are detected and are supported. The ioctl returns 0.

   Note that just like QUERYSTD this ioctl will do a best-effort only to detect
   the format. Especially for analog receivers it can be tricky to get it right.
   The receiver driver has the most complete information and so it should be the
   task of the driver (assisted by some V4L core utilities) to match the input
   with specific timings.

   We could add a fourth state where some timings could be detected, but no
   matching format could be found. In that case some of the fields would be
   left empty (or somehow marked as being unknown) and it would be up to the
   userspace to try and do something with it. In that case another error code
   would have to be returned. I'm not sure if this makes sense, and it is also
   something that can be added later.


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
		__u32 flags;
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
   I propose adding a V4L2_DV_CAP_ROOT flag to v4l2_dv_timings_cap to tell
   userspace that root permissions are required when setting timings.


6) Parsing the timings structures can be difficult, and for many applications
   you are just interested in finding certain industry standard timings.

   This was the idea behind the original preset API, and I still think that
   that is very useful in practice.
   
   My general view is that the preset API should be deprecated and eventually
   removed. After extending the timings API I see no more need for the preset
   API.

   So that leaves the question how to incorporate the preset functionality in
   the timings API.

   I see a few options:

   a) Add a preset or alias field to v4l2_enum_dv_timings. This just makes it
      easy for the application to check for specific formats and to store
      the timings.

   b) As a), but also add a new v4l2_dv_timings type: V4L2_DV_PRESET (or DV_ALIAS).
      This also has a struct v4l2_dv_preset (or dv_alias) that is used to store
      the preset value. This way you can set a preset directly using
      VIDIOC_S_DV_TIMINGS.

   c) Move the whole functionality to userspace into a library and create a
      function that converts a preset alias to a filled-in timings struct.


7) In the past Cisco posted an RFC for better EDID handling:

   http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/30401

   However, this RFC is quite old and is now out-of-date although many of the
   ideas in it still hold.

   EDIDs can be handled either in the driver or in userspace. Drivers for PCI(e)
   will likely handle it in the driver. Handling it in userspace is more appropriate
   for embedded systems.

   In the case of a video receiver device someone will have to set the EDID
   data. This is a one-type thing usually (EDIDs may change on the fly for
   DVI-I connectors whenever the source switches from analog to digital).

   So either the driver or userspace sets the EDID in the receiver. When you
   connect a source to the input the source will read the EDID and based on
   that choose what video to send to the receiver. QUERY_DV_TIMINGS is then
   called to figure out what the source sends us. Note that there is no
   guarantee that the source will actually read the EDID, it may choose to send
   something else (yes, then it no longer complies to the standard, but there
   is a lot of shit out there).

   The important thing here is that a receiver just presents the EDID info to
   a source, it cannot get any information back from the source.

   For transmitters it is a different story: the transmitter reads the EDID
   info (if any) from the sink and then has to decide what to send. Choosing
   an output resolution is the task of the application. However, it would be
   a good idea to restrict the list of possible timings for a transmitter to
   those that are valid according to the EDID. This will mean that the application
   has to re-enumerate timings whenever the EDID on the sink changes.

   This type of functionality will require some V4L2 core support to handled this
   efficiently. I know there was an effort to move the EDID parsing routines to
   a centralized place in the kernel and I guess that's something that we need
   first before we can implement such checks on the timings. It might be something
   that we skip for the first version and add later.


Comments?

	Hans
