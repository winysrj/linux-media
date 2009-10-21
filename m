Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:46747 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbZJUPV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 11:21:29 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 21 Oct 2009 10:21:32 -0500
Subject: RE: RFC (v1.2): V4L - Support for video timings at the
   input/output interface
Message-ID: <A69FA2915331DC488A831521EAE36FE4015560A3EF@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40155609B3F@dlee06.ent.ti.com>
    <0da0629d3f5701e9fa9761cf92189a75.squirrel@webmail.xs4all.nl>
    <A69FA2915331DC488A831521EAE36FE4015560A325@dlee06.ent.ti.com>
 <865830e80e6eb4d6a7a272b5e20bd015.squirrel@webmail.xs4all.nl>
In-Reply-To: <865830e80e6eb4d6a7a272b5e20bd015.squirrel@webmail.xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

>>>>
>>>> /* timing data values specified by various standards such as BT.1120,
>>>> BT.656 etc. */
>>>>
>>>> /* bt.656/bt.1120 timing data */
>>>> struct v4l2_bt_timings {
>>>>     __u32      interlaced;
>>>>     __u64      pixelclock;
>>>>     __u32      width, height;
>>>>     __u32      polarities;
>>>>     __u32      hfrontporch, hsync, htotal;
>>>>     __u32      vfrontporch, vsync, vtotal;
>>>>     /* timings for bottom frame for interlaced formats */
>>>>     __u32      il_vtotal;
>>>>     __u32      reserved[16];
>>>> };
>>>
>>>I think that we should be a change here: instead of specifying htotal and
>>>vtotal it is more symmetrical to specify hbackporch and vbackporch.
>>>
>>>And instead of il_vtotal I think it is better to specify il_vfrontporch,
>>>il_vsync, il_vbackporch. Since any of these three parameters can be the
>>>one that is 1 longer than the top field.
>>
>>
>> [MK] So are you saying we need all four:- il_vtotal, il_vfrontporch,
>> il_vsync, & il_vbackporch ?
>
>No, the htotal, vtotal and il_vtotal fields should be removed. These can
>be calculated from adding up the other fields.
>
[MK] Ok. That make sense. Here is the final structure...

struct v4l2_bt_timings {
	__u32      interlaced;
	__u64      pixelclock;
      __u32      width, height;
      __u32      polarities;
      __u32      hfrontporch, hsync, hbackporch;
      __u32      vfrontporch, vsync, vbackporch;
      /* timings for bottom frame for interlaced formats */
      __u32      il_vfrontporch, il_vsync, il_vbackporch ;
      __u32      reserved[16];
};

Murali
