Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45755 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbZHMWKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 18:10:07 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>, "Yin, Paul" <zhenyin@ti.com>
Date: Thu, 13 Aug 2009 17:10:00 -0500
Subject: RE: DM6467 VPIF adding support for HD resolution capture and
 display standards
Message-ID: <A69FA2915331DC488A831521EAE36FE40145289000@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401452885B1@dlee06.ent.ti.com>
 <200908120904.09140.hverkuil@xs4all.nl>
In-Reply-To: <200908120904.09140.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Thanks for your quick reply on this. I need few clarification though.

>My proposal would be something like this:
>
>enum dv_preset {
>	V4L2_DV_CUSTOM,
>	V4L2_DV_720P24,
>	V4L2_DV_720P25,
>	V4L2_DV_720P30,
>	V4L2_DV_720P50,
>	V4L2_DV_720P60,
>	/* etc */
>};
>
How do you define preset? Can I call all BT656, BT1120 and VESA standard timing as presets? For example, if I have an Digital LCD panel that supports standard VESA timing, I would be able to define presets for them right? Similarly for BT656/BT1120.

>/* bt.656/bt.1120 timing data */
>struct bt_timings {
>	__u32 interlaced;
>	__u32 pixelclock;
Shouldn't this be in fractional form? how do we represent 74.25 MHz? 
>	__u32 width, height;
>	__u32 polarities;
Is it a bit mask of polarities such as vsync, hsync etc? In that case shouldn't it be a bit field (pol_hsync, pol_vsync etc)
>	__u32 hfrontporch, hsync, htotal;
What you mean by hsync? Is it hsync length? then it should be better to call it sync_len right? All of these are in pixelclocks right? Why there is no backporch? Are you expecting it to be derived as htotal-hsync-width.
>	__u32 vfrontporch, vsync, vtotal;
Similar questions as above.
>	/* timings for bottom frame for interlaced formats */
>	__u32 il_hfrontporch, il_hsync, il_htotal;
>	__u32 il_vfrontporch, il_vsync, il_vtotal;
Looking at a typical vesa timing values, I don't see them defined separately for top and bottom fields. Is it for BT1120/BT656 and camera capture timing?

here are the values I got when googled for "VGA industry standard" 640x480 pixel mode

General characteristics

Clock frequency 25.175 MHz
Line  frequency 31469 Hz
Field frequency 59.94 Hz

One line

  8 pixels front porch
 96 pixels horizontal sync
 40 pixels back porch
  8 pixels left border
640 pixels video
  8 pixels right border
---
800 pixels total per line

One field

  2 lines front porch
  2 lines vertical sync
 25 lines back porch
  8 lines top border
480 lines video
  8 lines bottom border
---
525 lines total per field              

Other details

Sync polarity: H negative, V negative
Scan type: non interlaced.

>	__u32 reserved[4];
>};
>

>enum dv_timings_type {
>	V4L2_DV_BT_656_1120,
Why combine BT656 and BT1120? They have different set of timing values. Also if custom timing to be allowed, shouldn't there be a type
V4L2_CUSTOM_TIMING as one of the type. So only then bt_timings values will be used.

>};
VPIF supports SMPTE 296 mode in which different timing values are used than BT1120. So I see V4L2_DV_SMPTE_296 as well to begin with.
>
>struct dv_timings {
>	enum dv_timings_type type;
>	union {
>		struct bt_timings bt;
>		__u32 reserved[32];
>	};
>};
>
>and ioctls:
>
>VIDIOC_S/G_DV_PRESET, VIDIOC_ENUM_DV_PRESETS and VIDIOC_S/G_DV_TIMINGS.
>
>I don't think we need to have ioctls to determine what custom timings
>are possible: if you are going to use that, then we can safely assume that
>you know what you are doing.
>
>There are some details to hammer out: what does G_DV_TIMINGS return if e.g.
>the 720P60 preset is active? Does it return the timings for 720P60 or the
>last

>set custom timings?
Why last set custom timing? If preset is used, then it should return preset timing which mostly will be standard timing values as defined in the respective standard, right?
>
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

