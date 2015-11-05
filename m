Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48063 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032203AbbKEHuO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Nov 2015 02:50:14 -0500
Message-ID: <563B0A2A.3030905@xs4all.nl>
Date: Thu, 05 Nov 2015 08:50:02 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
CC: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v9 1/6] media: videobuf2: Move timestamp to vb2_buffer
References: <1446545802-28496-1-git-send-email-jh1009.sung@samsung.com> <1446545802-28496-2-git-send-email-jh1009.sung@samsung.com> <5639F9EA.7080400@xs4all.nl> <563AC908.9070708@samsung.com>
In-Reply-To: <563AC908.9070708@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/05/2015 04:12 AM, Junghak Sung wrote:
>>> diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
>>> index 83cc6d3..b0ad054 100644
>>> --- a/drivers/media/platform/vivid/vivid-kthread-cap.c
>>> +++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
>>> @@ -441,7 +441,7 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
>>>   	 * "Start of Exposure".
>>>   	 */
>>>   	if (dev->tstamp_src_is_soe)
>>> -		v4l2_get_timestamp(&buf->vb.timestamp);
>>> +		buf->vb.vb2_buf.timestamp = ktime_get_ns();
>>>   	if (dev->field_cap == V4L2_FIELD_ALTERNATE) {
>>>   		/*
>>>   		 * 60 Hz standards start with the bottom field, 50 Hz standards
>>> @@ -558,8 +558,9 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
>>>   	 * the timestamp now.
>>>   	 */
>>>   	if (!dev->tstamp_src_is_soe)
>>> -		v4l2_get_timestamp(&buf->vb.timestamp);
>>> -	buf->vb.timestamp.tv_sec += dev->time_wrap_offset;
>>> +		buf->vb.vb2_buf.timestamp = ktime_get_ns();
>>> +	buf->vb.vb2_buf.timestamp +=
>>> +			((u64) dev->time_wrap_offset * NSEC_PER_SEC);
>>
>> I'd do this differently: make time_wrap_offset of type u64 and assign it
>> accordingly with nanoseconds. That way you can just do:
>>
>> 	timestamp += dev->time_wrap_offset
>>
>> vivid-ctrls.c also needs to be modified (vivid_streaming_s_ctrl(), VIVID_CID_TIME_WRAP
>> case) to:
>>
>> 	dev->time_wrap_offset = (0x100000000ULL - 16) * NSEC_PER_SEC - ktime_get_ns();
>>
>> The v4l2_get_timestamp() call there can be dropped.
>>
> 
> I agree with your opinion. But it is too hard to read the code
> getting time_wrap_offset.
> How about this way?
> 
>   in vivid_streaming_s_ctrl() of vivid-ctrls.c
>          dev->time_wrap_offset = ktime_get_ns() + 16 * NSEC_PER_SEC;
>   and in vivid_fillbuff() of vivid-kthread-cap.c
> 	buf->vb.vb2_buf.timestamp -= dev->time_wrap_offset;

That doesn't do what I want it to do, which is to wrap around in the struct timeval
where seconds are 32 bits. The code above is actually wrong since I forgot that
tv_sec in struct timeval is signed, so 0x100000000ULL should be 0x80000000ULL.
Also, that code will fail after 2038, so that's no good either.

On a related note I send out a question to Arnd whether a timestamp should be u64
or s64. It's not clear to me which should be used as ktime_get_ns() returns a s64.

Once we return the full 64 bits to userspace, then we have a second wrap around when
the u64 (or s64) wraps. I'll add a second wrap-around control to vivid at that time.

I'll wait for Arnd to answer before fixing the time_wrap_offset calculation since I
need to know whether a timestamp is u64 or s64.

Regards,

	Hans
