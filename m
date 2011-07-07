Return-path: <mchehab@localhost>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2766 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab1GGLdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2011 07:33:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] DV timings spec fixes at V4L2 API - was: [PATCH 1/8] v4l: add macro for 1080p59_54 preset
Date: Thu, 7 Jul 2011 13:33:24 +0200
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com> <761c3894fa161d5e702cccf80443c7dd.squirrel@webmail.xs4all.nl> <4E14BA02.1010207@redhat.com>
In-Reply-To: <4E14BA02.1010207@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107071333.24501.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Wednesday, July 06, 2011 21:39:46 Mauro Carvalho Chehab wrote:
> Em 06-07-2011 09:14, Hans Verkuil escreveu:
> >> Em 06-07-2011 08:31, Hans Verkuil escreveu:
> >>>> Em 05-07-2011 10:20, Hans Verkuil escreveu:
> >>>>
> >>>>>> I failed to see what information is provided by the "presets" name.
> >>>>>> If
> >>>>>> this were removed
> >>>>>> from the ioctl, and fps would be added instead, the API would be
> >>>>>> clearer. The only
> >>>>>> adjustment would be to use "index" as the preset selection key.
> >>>>>> Anyway,
> >>>>>> it is too late
> >>>>>> for such change. We need to live with that.
> >>>>>
> >>>>> Adding the fps solves nothing. Because that still does not give you
> >>>>> specific timings.
> >>>>> You can have 1920x1080P60 that has quite different timings from the
> >>>>> CEA-861 standard
> >>>>> and that may not be supported by a TV.
> >>>>>
> >>>>> If you are working with HDMI, then you may want to filter all
> >>>>> supported
> >>>>> presets to
> >>>>> those of the CEA standard.
> >>>>>
> >>>>> That's one thing that is missing at the moment: that presets belonging
> >>>>> to a certain
> >>>>> standard get their own range. Since we only do CEA861 right now it
> >>>>> hasn't been an
> >>>>> issue, but it will.
> >>>>
> >>>> I prepared a long email about that, but then I realized that we're
> >>>> investing our time into
> >>>> something broken, at the light of all DV timing standards. So, I've
> >>>> dropped it and
> >>>> started from scratch.
> >>>>
> >>>> From what I've got, there are some hardware that can only do a limited
> >>>> set
> >>>> of DV timings.
> >>>> If this were not the case, we could simply just use the
> >>>> VIDIOC_S_DV_TIMINGS/VIDIOC_G_DV_TIMINGS,
> >>>> and put the CEA 861 and VESA timings into some userspace library.
> >>>>
> >>>> In other words, the PRESET API is meant to solve the case where
> >>>> hardware
> >>>> only support
> >>>> a limited set of frequencies, that may or may not be inside the CEA
> >>>> standard.
> >>>>
> >>>> Let's assume we never added the current API, and discuss how it would
> >>>> properly fulfill
> >>>> the user needs. An API that would likely work is:
> >>>>
> >>>> struct v4l2_dv_enum_preset2 {
> >>>> 	__u32	  index;
> >>>> 	__u8	  name[32]; /* Name of the preset timing */
> >>>>
> >>>> 	struct v4l2_fract fps;
> >>>>
> >>>> #define DV_PRESET_IS_PROGRESSIVE	1<<31
> >>>> #define DV_PRESET_SPEC(flag)		(flag && 0xff)
> >>>> #define DV_PRESET_IS_CEA861		1
> >>>> #define DV_PRESET_IS_DMT		2
> >>>> #define DV_PRESET_IS_CVF		3
> >>>> #define DV_PRESET_IS_GTF		4
> >>>> #define DV_PRESET_IS_VENDOR_SPECIFIC	5
> >>>>
> >>>> 	__u32	flags;		/* Interlaced/progressive, DV specs, etc */
> >>>>
> >>>> 	__u32	width;		/* width in pixels */
> >>>> 	__u32	height;		/* height in lines */
> >>>> 	__u32	polarities;	/* Positive or negative polarity */
> >>>> 	__u64	pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
> >>>> 	__u32	hfrontporch;	/* Horizpontal front porch in pixels */
> >>>> 	__u32	hsync;		/* Horizontal Sync length in pixels */
> >>>> 	__u32	hbackporch;	/* Horizontal back porch in pixels */
> >>>> 	__u32	vfrontporch;	/* Vertical front porch in pixels */
> >>>> 	__u32	vsync;		/* Vertical Sync length in lines */
> >>>> 	__u32	vbackporch;	/* Vertical back porch in lines */
> >>>> 	__u32	il_vfrontporch;	/* Vertical front porch for bottom field of
> >>>> 				 * interlaced field formats
> >>>> 				 */
> >>>> 	__u32	il_vsync;	/* Vertical sync length for bottom field of
> >>>> 				 * interlaced field formats
> >>>> 				 */
> >>>> 	__u32	il_vbackporch;	/* Vertical back porch for bottom field of
> >>>> 				 * interlaced field formats
> >>>> 				 */
> >>>> 	__u32	  reserved[4];
> >>>> };
> >>>>
> >>>> #define	VIDIOC_ENUM_DV_PRESETS2	_IOWR('V', 83, struct
> >>>> v4l2_dv_enum_preset2)
> >>>> #define	VIDIOC_S_DV_PRESET2	_IOWR('V', 84, u32 index)
> >>>> #define	VIDIOC_G_DV_PRESET2	_IOWR('V', 85, u32 index)
> >>>>
> >>>> Such preset API seems to work for all cases. Userspace can use any DV
> >>>> timing
> >>>> information to select the desired format, and don't need to have a
> >>>> switch
> >>>> for
> >>>> a preset macro to try to guess what the format actually means. Also,
> >>>> there's no
> >>>> need to touch at the API spec every time a new DV timeline is needed.
> >>>>
> >>>> Also, it should be noticed that, since the size of the data on the
> >>>> above
> >>>> definitions
> >>>> are different than the old ones, _IO macros will provide a different
> >>>> magic
> >>>> number,
> >>>> so, adding these won't break the existing API.
> >>>>
> >>>> So, I think we should work on this proposal, and mark the existing one
> >>>> as
> >>>> deprecated.
> >>>
> >>> This proposal makes it very hard for applications to directly select a
> >>> format like 720p50 because the indices can change at any time.
> >>
> >> Why? All the application needs to do is to call VIDIOC_ENUM_DV_PRESETS2,
> >> check what line it wants,
> > 
> > It's not so easy as you think to find the right timings: you have to check
> > many parameters to be certain you have the right one and not some subtle
> > variation.
> > 
> >> and do a S_DV_PRESET2, just like any other place
> >> where V4L2 defines an ENUM function.
> >>
> >> The enum won't change during application runtime, so, they can be stored
> >> if the application would need to switch to other formats latter.
> >>
> >>> I think
> >>> this is a very desirable feature, particularly for apps running on
> >>> embedded systems where the hardware is known. This was one of the design
> >>> considerations at the time this API was made.
> >>
> >> This is a very weak argument. With just one ENUM loop, the application can
> >> quickly get the right format(s), and associate them with any internal
> >> namespace.
> > 
> > That actually isn't easy at all.
> 
> For the trivial case where the application just wants one of the CEA861 standard
> (or VESA DMT), the check is trivial.
> 
> 
> The speed of the test can even be improved if the order at the struct would
> be changed to be:
> 
> struct v4l2_dv_enum_preset2 {
> 	__u32	index;
> 	__u32	flags;
> 
> 	struct v4l2_fract fps;
>  	__u32	width;		/* width in pixels */
>  	__u32	height;		/* height in lines */
> 
> 	...
> }
> 
> The dv preset seek routine at the application can then be coded as:
> 
> struct seek_preset {		/* Need to follow the same order/arguments as v4l2_dv_enum_preset2 */
> 	struct v4l2_fract fps;
>  	__u32	width;
>  	__u32	height;
> };
> 
> struct myapp_preset {
> 	__u32 flags;
> 
> 	struct seek_preset preset;
> };
> 
> struct  myapp_preset cea861_vic16  = {
> 	.flags = DV_PRESET_IS_PROGRESSIVE | DV_PRESET_IS_CEA861,
> 	.width = 1920,
> 	.height = 1080,
> };
> 
> int return_dv_preset_index(fp, struct  myapp_preset *needed)
> {
> 	int found = -1;
> 	struct v4l2_dv_enum_preset2 preset;
> 	do {
> 		rc = ioctl(fp, VIDIOC_ENUM_DV_PRESETS, &preset);
> 		if (rc == -1)
> 			break;
> 		if ((preset.flags & needed->flags) != needed->flags)
> 			continue;
> 		if (!memcmp(&preset.fps, &needed->preset)) {
> 			found = preset->index;
> 			break;
> 		}	
> 	} while (!rc && found < 0);
> }
> 
> void main(void) {
> ...
> 	index = return_dv_preset_index(fp, cea861_vic16);
> ...
> }

And the current equivalent is:

	struct v4l_dv_preset preset = { V4L2_DV_1080P60 };
	ioctl(f, VIDIOC_S_DV_PRESET, &preset);

You want a whole new API that in my view makes things only more complicated and
misses existing functionality (such as the one above).

Whereas with a few tweaks and possibly a new VIDIOC_G_PRESET_TIMINGS ioctl you
can offer the same functionality with the existing API.

So, once again my proposal:

ENUM_DV_PRESETS is extended with a flags field and a fps v4l2_fract (or frame_period,
whatever works best). Flags give you progressive vs interlaced, and I've no problem
adding things like IS_CEA861 or similar flags to that.

The current set of presets remain in use (but get renamed with the old ones as aliases)
for CEA861 and (in the near future) VESA DMT timings. Note that all the hardware I
know that has predefined timings does so only for those two standards. Makes sense
too: only the consumer electronic standards for SDTV/HDTV and the VGA-like PC monitor
standards are typical standards.

For presets not related to those standards the easiest method I see is just to assign
a preset like (0x80000000 | index).

We may need to add a VIDIOC_G_PRESET_TIMINGS, but I am not certain we really need
that. ENUM_DV_PRESETS may give sufficient information already.

Based on my experience with GTF/CVT formats I strongly suspect that drivers will
need to implement a VIDIOC_QUERY_DV_TIMINGS ioctl and let a userspace library detect
the GTF/CVT standard. This is surprisingly complex (mostly due to extremely shoddy
standards). For GTF/CVT output you want to use VIDIOC_S_DV_TIMINGS anyway. The reason
there is no GTF/CVT support yet is simply because I don't want to make proposals
unless I actually implemented it and worked with it for some time to see what works
best.

Everything you can do with your proposal you can do with mine, and mine doesn't
deprecate anything.

BTW, in the case of HD-SDI transmitters/receivers the CEA-861 standard does not
apply, strictly speaking. That standard is covered by SMPTE 292M. It does support
most of the usual SDTV/HDTV formats as are defined in CEA-861, except that things
like front/back porch etc. do not apply to this serial interface. The idea behind
the presets is that it defines industry standard resolution/framerate combinations,
but the standards behind those differ per interface type. You don't really care
about those in an application. The user (or developer) just wants to select 1080P60 or
WUXGA. I am frankly not certain anymore if we want to have the standard as part of
the macro name. Something like V4L2_DV_HDTV_1920X1080P60 might be more appropriate,
with comments next to it referring to the relevant standards depending on the
physical interface type.

And instead of using flags to denote the used standard, it might be better to
reserve a u16 for the standard.

History has shown that video formats stay around for a looong time, but the standards
describing them evolve continuously.

Regards,

	Hans
