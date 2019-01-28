Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D6CC282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 09:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5BA721736
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 09:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfA1Jwr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:52:47 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:44960 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726521AbfA1Jwr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 04:52:47 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id o3arglqdzBDyIo3augnS3i; Mon, 28 Jan 2019 10:52:44 +0100
Subject: Re: [RFC PATCH] videodev2.h: introduce VIDIOC_DQEXTEVENT
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <700eff44-b903-24d0-ef41-e634e643a200@xs4all.nl>
 <20190128092128.3ir4pp66wb3aujf5@paasikivi.fi.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b0a90af3-f59e-3a9a-3a6a-1735c31c4ceb@xs4all.nl>
Date:   Mon, 28 Jan 2019 10:52:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190128092128.3ir4pp66wb3aujf5@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfMJjwsgtGDjldylU6IUyHdQTgweBGAwuPy+7ZHGu7Vj0tyFCrbEfU/F0pIMBaLKkUdo4OnuAyBdMNpVmvIqybbNNKZzHHAoKyWFAo218QwusA8/PVUCW
 BlvSQxW0CQfwzYw9Frqv3dUZjkJuGgvygpMP0clcdQ41CamvE1HsMWUIarcUi8Lqt2OtOR/D1rXM58el0FoMGJ+OLvUR4vTlhFuMBwy0QDiT2eo8/eLR6JYj
 GzkOe4/zYfRly/1thpZRgs5Q66pFDqK5xlUPeQCVBC0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/28/19 10:21 AM, Sakari Ailus wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Sat, Jan 26, 2019 at 12:06:19PM +0100, Hans Verkuil wrote:
>> This patch adds an extended version of VIDIOC_DQEVENT that:
>>
>> 1) is Y2038 safe by using a __u64 for the timestamp
>> 2) needs no compat32 conversion code
>> 3) is able to handle control events from 64-bit control types
>>    by changing the type of the minimum, maximum, step and default_value
>>    field to __u64
>>
>> All drivers and frameworks will be using this, and v4l2-ioctl.c would be the
>> only place where the old event ioctl and structs are used.
>>
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>> ---
>> Please let me know if there are additional requests for such a new ioctl.
>>
>> Note that I am using number 104 for the ioctl, but perhaps it would be better to
>> use an unused ioctl number like 1 or 3. There are quite a few holes in the
>> ioctl numbers. We currently have only 82 ioctls, yet are up to ioctl number 103.
>> ---
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 9a920f071ff9..969e775b8c25 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -2303,6 +2303,37 @@ struct v4l2_event {
>>  	__u32				reserved[8];
>>  };
>>
>> +struct v4l2_event_ext_ctrl {
>> +	__u32 changes;
>> +	__u32 type;
>> +	union {
>> +		__s32 value;
>> +		__s64 value64;
>> +	};
>> +	__s64 minimum;
>> +	__s64 maximum;
>> +	__s64 step;
>> +	__s64 default_value;
>> +	__u32 flags;
>> +};
>> +
>> +struct v4l2_ext_event {
>> +	__u32				type;
>> +	__u32				id;
>> +	union {
>> +		struct v4l2_event_vsync		vsync;
>> +		struct v4l2_event_ext_ctrl	ctrl;
>> +		struct v4l2_event_frame_sync	frame_sync;
>> +		struct v4l2_event_src_change	src_change;
>> +		struct v4l2_event_motion_det	motion_det;
>> +		__u8				data[64];
>> +	} u;
> 
> If I'd change something in the event IOCTL, I'd probably put the reserved
> fields here. That'd allow later taking some for the use of the event data
> if needed.

Good point, I'll do that.

> I might also increase the size of the event data. 64 bytes is not that
> much. But you indeed end up copying it around all the time... So it's a
> trade-off.

I decided to leave this alone. I think by putting the reserved array after
the union (nice idea) we allow for such future extension should it be
necessary.

> 
>> +	__u64				timestamp;
>> +	__u32				pending;
>> +	__u32				sequence;
>> +	__u32				reserved[8];
>> +};
>> +
>>  #define V4L2_EVENT_SUB_FL_SEND_INITIAL		(1 << 0)
>>  #define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK	(1 << 1)
>>
>> @@ -2475,6 +2506,7 @@ struct v4l2_create_buffers {
>>  #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
>>
>>  #define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
>> +#define	VIDIOC_DQEXTEVENT	 _IOR('V', 104, struct v4l2_ext_event)
> 
> How do you plan to name the new buffer handling IOCTLs? I.e. with or
> without underscores around "EXT"?

It's a good question. In my old patch I named them VIDIOC_EXT_QBUF etc. See:
https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=a95549df06d9900f3559afdbb9da06bd4b22d1f3

So I think I should probably rename this to VIDIOC_EXT_DQEVENT.

Alternatively, perhaps we should ditch the _ext_ usage and instead use a
version suffix: VIDIOC_DQEVENT_V2.

The problem with EXT is that if you want to make a newer version of such a
control, you can't just name it EXT_EXT, that would be silly. But naming it
_V3 would be fine.

Frankly, the extended control ioctls have that problem, also due to awful
64 bit alignment issues. It would be really nice to have _V3 versions of
those ioctls that do not require compat32 code.

Feedback on this would be very welcome!

Regards,

	Hans

> 
>>
>>  /* Reminder: when adding new ioctls please add support for them to
>>     drivers/media/v4l2-core/v4l2-compat-ioctl32.c as well! */
> 

