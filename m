Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2939 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbaEEKTg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 May 2014 06:19:36 -0400
Message-ID: <536765B1.3050207@xs4all.nl>
Date: Mon, 05 May 2014 12:19:29 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: n179911 <n179911@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Question about implementation of __qbuf_dmabuf() in videobuf2-core.c
References: <CAKZjMP3B5k8MByhVrn=vsWOwnZLDL+YS48VvAWQ+z4=RKduV-Q@mail.gmail.com>	<53576AC4.8090303@xs4all.nl> <CAKZjMP14q0YTu11hJuQoRoOYihWw5Y63qGAoMUfGpL=2=ouG4g@mail.gmail.com>
In-Reply-To: <CAKZjMP14q0YTu11hJuQoRoOYihWw5Y63qGAoMUfGpL=2=ouG4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/29/2014 07:27 PM, n179911 wrote:
> Hi,
> 
> Is there a work around for this bug without upgrading to 3.16 kernel?
> 
> Is it safe to manually set the length to be data_offset + size + 1 to make sure
> 
> planes[plane].length is greater than planes[plane].data_offset +
>                     q->plane_sizes[plane]?

Yes, that should be safe. However, if you are building the kernel yourself, then
I would recommend just fixing the kernel instead of working around it elsewhere.

Regards,

	Hans

> 
> Thank you.
> 
> On Wed, Apr 23, 2014 at 12:24 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 04/23/2014 02:18 AM, n179911 wrote:
>>> In __qbuf_dmabuf(), it check the length and size of the buffer being
>>> queued, like this:
>>> http://lxr.free-electrons.com/source/drivers/media/v4l2-core/videobuf2-core.c#L1158
>>>
>>> My question is why the range check is liked this:
>>>
>>> 1158  if (planes[plane].length < planes[plane].data_offset +
>>> 1159                     q->plane_sizes[plane]) {
>>
>> It's a bug. It should be:
>>
>>         if (planes[plane].length < q->plane_sizes[plane]) {
>>
>> This has been fixed in our upstream code and will appear in 3.16.
>>
>> Regards,
>>
>>         Hans
>>
>>>         .....
>>>
>>> Isn't  planes[plane].length + planes[plane].data_offset equals to
>>> q->plane_sizes[plane]?
>>>
>>> So the check should be?
>>>  if (planes[plane].length < q->plane_sizes[plane] - planes[plane].data_offset)
>>>
>>> Please tell me what am I missing?
>>>
>>> Thank you
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>

