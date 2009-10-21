Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2033 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbZJUO5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 10:57:05 -0400
Message-ID: <865830e80e6eb4d6a7a272b5e20bd015.squirrel@webmail.xs4all.nl>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4015560A325@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40155609B3F@dlee06.ent.ti.com>
    <0da0629d3f5701e9fa9761cf92189a75.squirrel@webmail.xs4all.nl>
    <A69FA2915331DC488A831521EAE36FE4015560A325@dlee06.ent.ti.com>
Date: Wed, 21 Oct 2009 16:57:07 +0200
Subject: RE: RFC (v1.2): V4L - Support for video timings at the  
 input/output interface
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hans,
>
>
>>>
>>> #define	  V4L2_DV_INVALID		 0x00000000
>>> #define       V4L2_DV_480I59_94      0x00000001
>>> #define       V4L2_DV_480I60         0x00000002
>>> #define       V4L2_DV_480P23_976     0x00000003
>>> #define       V4L2_DV_480P24         0x00000004
>>> #define       V4L2_DV_480P29_97      0x00000005
>>> #define       V4L2_DV_480P30         0x00000006
>>> #define       V4L2_DV_576I50         0x00000007
>>> #define       V4L2_DV_576P25         0x00000008
>>> #define       V4L2_DV_576P50         0x00000009
>>> #define       V4L2_DV_720P23_976     0x0000000A
>>> #define       V4L2_DV_720P24         0x0000000B
>>> #define       V4L2_DV_720P25         0x0000000C
>>> #define       V4L2_DV_720P29_97      0x0000000D
>>> #define       V4L2_DV_720P30         0x0000000E
>>> #define       V4L2_DV_720P50         0x0000000F
>>> #define       V4L2_DV_720P59_94      0x00000010
>>> #define       V4L2_DV_720P60         0x00000011
>>> #define       V4L2_DV_1080I50        0x00000012
>>> #define       V4L2_DV_1080I59_94     0x00000013
>>> #define       V4L2_DV_1080I60        0x00000014
>>> #define       V4L2_DV_1080P23_976    0x00000015
>>> #define       V4L2_DV_1080P24        0x00000016
>>> #define       V4L2_DV_1080P25        0x00000017
>>> #define       V4L2_DV_1080P29_97     0x00000018
>>> #define       V4L2_DV_1080P30        0x00000019
>>> #define       V4L2_DV_1080P60        0x00000020
>>
>>Note: when defining this in the videodev2 header we also need to document
>>the timings for each preset and where we got this data from (e.g.
>> CEA861-E
>>if I recall correctly).
>>
> [MK] To be honest, I did a google search and arrived at the list. If you
> need to specify where it actually defined, I would need your help since I
> don't have access to any standards document. If not, we might want to
> start with a small set ( where we know there is a specific standard for
> the same) which can be expanded later by developers (since they would know
> what standard they refer to)

In that case, start with a standard set. I can check this later when I'm
back in Norway.

>
>>>
>>>
>>> Driver sets preset to V4L2_DV_INVALID to indicate there is no signal
>>> detected or could not lock to the signal for a VIDIOC_QUERY_DV_PRESET
>>> IOCTL
>>>
>>> This list is expected grow over time. So a bit mask is not used for
>>> this
>>> (Unlike analog TV standards) so that many presets can be defined as
>>needed
>>> in the future.
>>>
>>> To enumerate the DV preset timings available, applications call
>>> VIDIOC_ENUM_DV_PRESETS using the following structure:-
>>>
>>> struct v4l2_dv_enum_presets {
>>>         __u32     index;
>>>         __u32     preset;
>>>         __u8      name[32]; /* Name of the preset timing */
>>>         __u32     width;
>>>         __u32     height;
>>>         __u32     reserved[4];
>>> };
>>>
>>> Application set/get the preset by calling VIDIOC_S/G_DV_PRESET using
>>> v4l2_dv_preset structure.
>>>
>>> Also add a capabilities field in the input and output structure to
>>support
>>> presets
>>>
>>> /*
>>>  *      V I D E O   I N P U T S
>>>  */
>>> struct v4l2_input {
>>>         __u32        index;             /*  Which input */
>>>         __u8         name[32];          /*  Label */
>>>         __u32        type;              /*  Type of input */
>>>         __u32        audioset;          /*  Associated audios
>>> (bitfield)
>>> */
>>>         __u32        tuner;             /*  Associated tuner */
>>>         v4l2_std_id  std;
>>>         __u32        status;
>>>         __u32        capabilities;
>>>         __u32        reserved[3];
>>> };
>>>
>>> where capabilities can be one or more of the following:-
>>>
>>> #define V4L2_IN_CAP_PRESETS          0x00000001
>>> #define V4L2_IN_CAP_CUSTOM_TIMINGS 	 0x00000002
>>> #define V4L2_IN_CAP_STD              0x00000004
>>>
>>> /*
>>>  *      V I D E O   O U T P U T S
>>>  */
>>> struct v4l2_output {
>>>         __u32        index;             /*  Which output */
>>>         __u8         name[32];          /*  Label */
>>>         __u32        type;              /*  Type of output */
>>>         __u32        audioset;          /*  Associated audios
>>> (bitfield)
>>> */
>>>         __u32        modulator;         /*  Associated modulator */
>>>         v4l2_std_id  std;
>>>         __u32        capabilities;
>>>         __u32        reserved[3];
>>> };
>>>
>>> where capabilities can be one or more of the following:-
>>>
>>> #define V4L2_OUT_CAP_PRESETS        0x00000001
>>> #define V4L2_OUT_CAP_CUSTOM_TIMINGS 0x00000002
>>> #define V4L2_OUT_CAP_STD		0x00000004
>>>
>>> For setting custom timing at the device, following structure is used
>>which
>>> defines the complete set of timing values required at the input and
>>output
>>> interface:-
>>>
>>> /* timing data values specified by various standards such as BT.1120,
>>> BT.656 etc. */
>>>
>>> /* bt.656/bt.1120 timing data */
>>> struct v4l2_bt_timings {
>>>     __u32      interlaced;
>>>     __u64      pixelclock;
>>>     __u32      width, height;
>>>     __u32      polarities;
>>>     __u32      hfrontporch, hsync, htotal;
>>>     __u32      vfrontporch, vsync, vtotal;
>>>     /* timings for bottom frame for interlaced formats */
>>>     __u32      il_vtotal;
>>>     __u32      reserved[16];
>>> };
>>
>>I think that we should be a change here: instead of specifying htotal and
>>vtotal it is more symmetrical to specify hbackporch and vbackporch.
>>
>>And instead of il_vtotal I think it is better to specify il_vfrontporch,
>>il_vsync, il_vbackporch. Since any of these three parameters can be the
>>one that is 1 longer than the top field.
>
>
> [MK] So are you saying we need all four:- il_vtotal, il_vfrontporch,
> il_vsync, & il_vbackporch ?

No, the htotal, vtotal and il_vtotal fields should be removed. These can
be calculated from adding up the other fields.

>
>>
>>>
>>>
>>> interlaced - Interlaced or progressive. use following values:-
>>>
>>> #define V4L2_DV_INTERLACED      0
>>> #define V4L2_DV_PROGRESSIVE    1
>>
>>Make PROGRESSIVE 0 instead of 1. It fits the meaning of the field better.
>>For the interlaced formats we might end up with two: INTERLACED_TOP_FIRST
>>and INTERLACED_BOTTOM_FIRST: depending on the interlaced format the top
>>field or the bottom field is sent first. That's something that can differ
>>depending on the format (I know it is different between PAL and NTSC).
>
>
> [MK] will change to
>
> #define V4L2_DV_PROGRESSIVE    0
> #define V4L2_DV_INTERLACED     1
>
>>
>>I'm not sure how the CEA standard defines this.
>
> [MK]If we need to support different interlaced formats as you state, we
> could add a flag using the reserved later. I think it is better to add
> such things later when someone actually has a use case. I don't have
> access to CEA standard. So I can't comment on that.

OK, I agree with this.

Regards,

     Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

