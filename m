Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:44293 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbbIKLMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 07:12:05 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NUI034UHF43VGA0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Sep 2015 20:12:04 +0900 (KST)
Message-id: <55F2B703.7030500@samsung.com>
Date: Fri, 11 Sep 2015 20:12:03 +0900
From: Junghak Sung <jh1009.sung@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v4 6/8] [media] videobuf2: Replace v4l2-specific data
 with vb2 data.
References: <1441797597-17389-1-git-send-email-jh1009.sung@samsung.com>
 <1441797597-17389-7-git-send-email-jh1009.sung@samsung.com>
 <55F28D4E.9@xs4all.nl>
In-reply-to: <55F28D4E.9@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/11/2015 05:14 PM, Hans Verkuil wrote:
> Hi Junghak,
>
> A few comments:
>
> On 09/09/2015 01:19 PM, Junghak Sung wrote:
>> enum v4l2_memory -> enum vb2_memory
>> VIDEO_MAX_FRAME -> VB2_MAX_FRAME
>> VIDEO_MAX_PLANES -> VB2_MAX_PLANES
>
> and owner is now a void pointer!
>
> With respect to the two defines above: I think it is a good idea to
> add a check to videobuf2-v4l2.c where the compiler compares VIDEO_MAX_FRAME
> and VB2_MAX_FRAME (and ditto for MAX_PLANES) and throws an #error if they
> do not match.
>

OK, I'll do that at next round.

>>
>> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
>> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> ---
>>   drivers/media/v4l2-core/videobuf2-core.c |   80 +++++++++++++++---------------
>>   include/media/videobuf2-core.h           |   29 +++++++----
>>   include/trace/events/v4l2.h              |    5 +-
>>   3 files changed, 64 insertions(+), 50 deletions(-)
>
> <snip>
>
>> diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
>> index b015b38..b3616ab 100644
>> --- a/include/trace/events/v4l2.h
>> +++ b/include/trace/events/v4l2.h
>> @@ -5,6 +5,7 @@
>>   #define _TRACE_V4L2_H
>>
>>   #include <linux/tracepoint.h>
>> +#include <media/videobuf2-v4l2.h>
>>
>>   /* Enums require being exported to userspace, for user tool parsing */
>>   #undef EM
>> @@ -203,7 +204,9 @@ DECLARE_EVENT_CLASS(vb2_event_class,
>>
>>   	TP_fast_assign(
>>   		struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> -		__entry->minor = q->owner ? q->owner->vdev->minor : -1;
>> +		struct v4l2_fh *owner = (struct v4l2_fh *) q->owner;
>
> You don't need a cast here.

Oh, it was my mistake. I'll fix it.

>
>> +
>> +		__entry->minor = owner ? owner->vdev->minor : -1;
>>   		__entry->queued_count = q->queued_count;
>>   		__entry->owned_by_drv_count =
>>   			atomic_read(&q->owned_by_drv_count);
>>
>
> Regards,
>
> 	Hans
>
