Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3474 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbZHNGYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2009 02:24:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: DM6467 VPIF adding support for HD resolution capture and display standards
Date: Fri, 14 Aug 2009 08:24:35 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>, "Yin, Paul" <zhenyin@ti.com>
References: <A69FA2915331DC488A831521EAE36FE401452885B1@dlee06.ent.ti.com> <200908120904.09140.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE40145289000@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40145289000@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908140824.36016.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 14 August 2009 00:10:00 Karicheri, Muralidharan wrote:
> Hans,
> 
> Thanks for your quick reply on this. I need few clarification though.
> 
> >My proposal would be something like this:
> >
> >enum dv_preset {
> >	V4L2_DV_CUSTOM,
> >	V4L2_DV_720P24,
> >	V4L2_DV_720P25,
> >	V4L2_DV_720P30,
> >	V4L2_DV_720P50,
> >	V4L2_DV_720P60,
> >	/* etc */
> >};
> >
> How do you define preset? Can I call all BT656, BT1120 and VESA standard timing as presets? For example, if I have an Digital LCD panel that supports standard VESA timing, I would be able to define presets for them right? Similarly for BT656/BT1120.

Correct. Most apps will only deal with the common resolutions and you don't
want to force them to know all the low-level timings. Instead you want them
to present to the user a list of common formats supported by the card.

> 
> >/* bt.656/bt.1120 timing data */
> >struct bt_timings {
> >	__u32 interlaced;
> >	__u32 pixelclock;
> Shouldn't this be in fractional form? how do we represent 74.25 MHz? 

We represent that as 74250000 :-) The unit is in Hz.

A more interesting question is if we should make this a u64 to be prepared
for frequencies >4GHz. Or am I paranoid?

> >	__u32 width, height;
> >	__u32 polarities;
> Is it a bit mask of polarities such as vsync, hsync etc?

Yes.

> In that case shouldn't it be a bit field (pol_hsync, pol_vsync etc) 

Bitfields cannot be used in public APIs: how bits are assigned in an integer
is compiler dependent.

> >	__u32 hfrontporch, hsync, htotal;
> What you mean by hsync? Is it hsync length?

Yes.

> then it should be better to call it sync_len right? 

Hey, I just whipped this up quickly you know! :-)

> All of these are in pixelclocks right?

Yes.

> Why there is no backporch? Are you expecting it to be derived as htotal-hsync-width.   

Yes, we just derive it.

> >	__u32 vfrontporch, vsync, vtotal;
> Similar questions as above.
> >	/* timings for bottom frame for interlaced formats */
> >	__u32 il_hfrontporch, il_hsync, il_htotal;
> >	__u32 il_vfrontporch, il_vsync, il_vtotal;
> Looking at a typical vesa timing values, I don't see them defined separately for top and bottom fields. Is it for BT1120/BT656 and camera capture timing?

Front porch, sync length and htotal can be removed, but I think il_vtotal can
be different from vtotal by one line so we should keep that one.

> 
> here are the values I got when googled for "VGA industry standard" 640x480 pixel mode
> 
> General characteristics
> 
> Clock frequency 25.175 MHz
> Line  frequency 31469 Hz
> Field frequency 59.94 Hz
> 
> One line
> 
>   8 pixels front porch
>  96 pixels horizontal sync
>  40 pixels back porch
>   8 pixels left border

Note on these left/right border values: in practice I think these are always
added to the front/back porch values. I don't think we should add them to the
timings struct. Only 640x480 resolutions ever use these.

I've got access to the full VESA specs, so I have all the timings for the VESA
modes.

> 640 pixels video
>   8 pixels right border
> ---
> 800 pixels total per line
> 
> One field
> 
>   2 lines front porch
>   2 lines vertical sync
>  25 lines back porch
>   8 lines top border
> 480 lines video
>   8 lines bottom border
> ---
> 525 lines total per field              
> 
> Other details
> 
> Sync polarity: H negative, V negative
> Scan type: non interlaced.
> 
> >	__u32 reserved[4];
> >};
> >
> 
> >enum dv_timings_type {
> >	V4L2_DV_BT_656_1120,
> Why combine BT656 and BT1120? They have different set of timing values. Also if custom timing to be allowed, shouldn't there be a type
> V4L2_CUSTOM_TIMING as one of the type. So only then bt_timings values will be used.

No. BT656 and BT1120 define how bitstreams for video are formatted. There is
very little difference between the two. I would have to do research as to what
exactly the differences are, but based on my experience so far I think there
is no need to separate them.

Also note that both use the same timing parameters, so the custom settings are
actually following the bt656/1120 timings.

> 
> >};
> VPIF supports SMPTE 296 mode in which different timing values are used than BT1120. So I see V4L2_DV_SMPTE_296 as well to begin with.

Someone needs to put these standards next to one another and research what
the differences are and whether those differences are enough to require
adding a new type. Do you have access to those standards and can you go
through them and see what the differences are exactly and whether those
require adding a special type + associated timings struct?

> >
> >struct dv_timings {
> >	enum dv_timings_type type;
> >	union {
> >		struct bt_timings bt;
> >		__u32 reserved[32];
> >	};
> >};
> >
> >and ioctls:
> >
> >VIDIOC_S/G_DV_PRESET, VIDIOC_ENUM_DV_PRESETS and VIDIOC_S/G_DV_TIMINGS.
> >
> >I don't think we need to have ioctls to determine what custom timings
> >are possible: if you are going to use that, then we can safely assume that
> >you know what you are doing.
> >
> >There are some details to hammer out: what does G_DV_TIMINGS return if e.g.
> >the 720P60 preset is active? Does it return the timings for 720P60 or the
> >last
> 
> >set custom timings?
> Why last set custom timing? If preset is used, then it should return preset timing which mostly will be standard timing values as defined in the respective standard, right?

My reasoning was that returning the preset timings would require that a driver
will need to know those timings. For some hardware a programmer can just write
a single 'standards' register and the hardware will do its own timings lookup.
So in those cases a driver would need to keep a timings table around just for
this API.

It is also slightly cleaner since if a driver only supports presets, then there
is no need for the DV_TIMINGS ioctls.

Remember, this is just an initial API proposal that's quickly put together.

For one thing, for the presets we really want to put that in a struct:

struct v4l2_dv_preset {
	__u32 preset;
	__u32 reserved[4];
};

And instead of an enum I would use a list of #defines for the preset IDs.

Using enum makes compat32 conversion harder (I believe they have different
sizes under 32 vs 64 bits).

The enum struct would be:

struct v4l2_dv_enum_preset {
	__u32 preset;
	char name[32];
	__u32 reserved[4];
};

Where 'name' is the name of the preset.

Regards,

       Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
