Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49728 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750848AbdGGHPc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 03:15:32 -0400
Subject: Re: [PATCH 03/12] [media] vb2: add in-fence support to QBUF
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-4-gustavo@padovan.org>
 <396bc2f8-eea6-82d5-c3b5-b8c2514af853@xs4all.nl>
 <20170707015346.GD10284@jade>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <71e2f26a-37c8-de40-67e6-b9971e9fae37@xs4all.nl>
Date: Fri, 7 Jul 2017 09:15:26 +0200
MIME-Version: 1.0
In-Reply-To: <20170707015346.GD10284@jade>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2017 03:53 AM, Gustavo Padovan wrote:
>>
>>>   	help
>>>   	  If you want to use Webcams, Video grabber devices and/or TV devices
>>>   	  enable this option and other options below.
>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>>> index ea83126..29aa9d4 100644
> 
>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>> @@ -1279,6 +1279,22 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
>>>   	return 0;
>>>   }
>>>   
>>> +static int __get_num_ready_buffers(struct vb2_queue *q)
>>> +{
>>> +	struct vb2_buffer *vb;
>>> +	int ready_count = 0;
>>> +
>>> +	/* count num of buffers ready in front of the queued_list */
>>> +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
>>> +		if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
>>> +			break;
>>
>> Obviously the break is wrong as Mauro mentioned.
> 
> I replied this in the other email to Mauro, if a fence is not signaled
> it is not ready te be queued by the driver nor is all buffers following
> it. Hence the break. They need all to be in order and in front of the
> queue.
> 
> In any case I'll check this again as now there is two people saying I'm
> wrong! :)

I think this comes back to the 'ordered' requirement and what that means
exactly. In this particular case if I have buffers queued up in vb2 without
a fence (or the fence was signaled), why shouldn't it possible to queue them
up to the driver right away?

Of course, if all buffers are waiting for a fence, then __get_num_ready_buffers
returns 0 and nothing happens.

My understanding is that the ordered requirement is for the hardware,
i.e. queueing buffers A, B, C to ordered hardware requires that they come
out in the same order.

If 'ordered' means that the qbuf/dqbuf sequence must be ordered which implies
that vb2 also needs to keep them ordered, then I need to review the code again.

Can you explain (or point to an explanation) the reason behind the ordered
requirement?

I think you explained it to me when we met during a conference, but I've
forgotten the details.

Regards,

	Hans
