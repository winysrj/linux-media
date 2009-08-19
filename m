Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35123 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbZHSRo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 13:44:27 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>, "Yin, Paul" <zhenyin@ti.com>
Date: Wed, 19 Aug 2009 12:44:24 -0500
Subject: RE: DM6467 VPIF adding support for HD resolution capture and
 display standards
Message-ID: <A69FA2915331DC488A831521EAE36FE401548C24B2@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401452885B1@dlee06.ent.ti.com>
 <200908120904.09140.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE40145289000@dlee06.ent.ti.com>
 <200908140824.36016.hverkuil@xs4all.nl>
In-Reply-To: <200908140824.36016.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

You have done a great job in putting up a quick proposal. I was just trying to understand the intentions/rational behind your proposal to be on the same page. Thanks for the education. I think this will help others as well.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

<Snip>
>> Shouldn't this be in fractional form? how do we represent 74.25 MHz?
>
>We represent that as 74250000 :-) The unit is in Hz.
>
>A more interesting question is if we should make this a u64 to be prepared
>for frequencies >4GHz. Or am I paranoid?
>

The highest pixel clock that I have seen for DaVinci platforms is 128MHz. So I believe it will be a while before someone use > 4GHz :)

<Snip>

>> >	__u32 width, height;
>> >	__u32 polarities;
>> Is it a bit mask of polarities such as vsync, hsync etc?
>
>Yes.
Then we would need to define POLARITIES as bit mask for user space usage.
like

#define V4L2_DV_VSYNC_POL	0x1
#define V4L2_DV_HSYNC_POL	0x2

and so forth?
>

<Snip>

>> >	/* timings for bottom frame for interlaced formats */
>> >	__u32 il_hfrontporch, il_hsync, il_htotal;
>> >	__u32 il_vfrontporch, il_vsync, il_vtotal;
>> Looking at a typical vesa timing values, I don't see them defined
>separately for top and bottom fields. Is it for BT1120/BT656 and camera
>capture timing?
>
>Front porch, sync length and htotal can be removed, but I think il_vtotal
>can
>be different from vtotal by one line so we should keep that one.
>

I think it is safer to keep them and mark them as experimental?. 

>>
>> >enum dv_timings_type {
>> >	V4L2_DV_BT_656_1120,
>> Why combine BT656 and BT1120? They have different set of timing values.
>Also if custom timing to be allowed, shouldn't there be a type
>> V4L2_CUSTOM_TIMING as one of the type. So only then bt_timings values
>will be used.
>
>No. BT656 and BT1120 define how bitstreams for video are formatted. There
>is
>very little difference between the two. I would have to do research as to
>what
>exactly the differences are, but based on my experience so far I think
>there
>is no need to separate them.
>Also note that both use the same timing parameters, so the custom settings
>are
>actually following the bt656/1120 timings.

What I see from the VPIF hardware spec is that they use different values for first line of top/bottom field, first line of active video, last line of active video and so forth. That means timing parameters are different, right? 

<Snip>

>
>>
>> >};
>> VPIF supports SMPTE 296 mode in which different timing values are used
>than BT1120. So I see V4L2_DV_SMPTE_296 as well to begin with.
>
>Someone needs to put these standards next to one another and research what
>the differences are and whether those differences are enough to require
>adding a new type. Do you have access to those standards and can you go
>through them and see what the differences are exactly and whether those
>require adding a special type + associated timings struct?
>

I don't have access to the specs. But VPIF hardware manual says hardware use different values for first line of top/bottom field, first line of active video, last line of active video and so forth. i.e they are different for BT656, BT1120, & SMPTE 296.

>> >
>> >struct dv_timings {
>> >	enum dv_timings_type type;
>> >	union {
>> >		struct bt_timings bt;
>> >		__u32 reserved[32];
>> >	};
>> >};
>> >
>> >and ioctls:
>> >
>> >VIDIOC_S/G_DV_PRESET, VIDIOC_ENUM_DV_PRESETS and VIDIOC_S/G_DV_TIMINGS.
>> >
>> >I don't think we need to have ioctls to determine what custom timings
>> >are possible: if you are going to use that, then we can safely assume
>that
>> >you know what you are doing.
>> >
>> >There are some details to hammer out: what does G_DV_TIMINGS return if
>e.g.
>> >the 720P60 preset is active? Does it return the timings for 720P60 or
>the
>> >last
>>
>> >set custom timings?
>> Why last set custom timing? If preset is used, then it should return
>preset timing which mostly will be standard timing values as defined in the
>respective standard, right?
>
>My reasoning was that returning the preset timings would require that a
>driver
>will need to know those timings. For some hardware a programmer can just
>write
>a single 'standards' register and the hardware will do its own timings
>lookup.
>So in those cases a driver would need to keep a timings table around just
>for
>this API.
Make sense.
>
>It is also slightly cleaner since if a driver only supports presets, then
>there
>is no need for the DV_TIMINGS ioctls.
>
Agree.
>Remember, this is just an initial API proposal that's quickly put together.
>
>For one thing, for the presets we really want to put that in a struct:
>
>struct v4l2_dv_preset {
>	__u32 preset;
>	__u32 reserved[4];
>};
>
>And instead of an enum I would use a list of #defines for the preset IDs.
>
>Using enum makes compat32 conversion harder (I believe they have different
>sizes under 32 vs 64 bits).
>
>The enum struct would be:
>
>struct v4l2_dv_enum_preset {
>	__u32 preset;
>	char name[32];
>	__u32 reserved[4];
>};
>
Ok.
>Where 'name' is the name of the preset.
>
>Regards,
>
>       Hans
>
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

