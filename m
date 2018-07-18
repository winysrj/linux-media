Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:36138 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730782AbeGRKpe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 06:45:34 -0400
Subject: Re: [PATCH] videobuf2-core: check for q->error in vb2_core_qbuf()
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <ab3d5aa7-c06b-9918-235e-ff983cb5cce7@xs4all.nl>
 <20180716124906.hi34a2u5xftakx76@valkosipuli.retiisi.org.uk>
 <147321b3-d0fe-6ec3-f914-d53ec270c4a7@xs4all.nl>
 <20180718100641.pl7477es5ujohgj4@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <df78f2a6-d98d-2286-7a8b-7bc15b75d87b@xs4all.nl>
Date: Wed, 18 Jul 2018 12:08:22 +0200
MIME-Version: 1.0
In-Reply-To: <20180718100641.pl7477es5ujohgj4@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/07/18 12:06, Sakari Ailus wrote:
> On Wed, Jul 18, 2018 at 11:29:01AM +0200, Hans Verkuil wrote:
>> On 16/07/18 14:49, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> On Thu, Jul 05, 2018 at 10:25:19AM +0200, Hans Verkuil wrote:
>>>> The vb2_core_qbuf() function didn't check if q->error was set. It is checked in
>>>> __buf_prepare(), but that function isn't called if the buffer was already
>>>> prepared before with VIDIOC_PREPARE_BUF.
>>>>
>>>> So check it at the start of vb2_core_qbuf() as well.
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
>>>> index d3501cd604cb..5d7946ec80d8 100644
>>>> --- a/drivers/media/common/videobuf2/videobuf2-core.c
>>>> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
>>>> @@ -1484,6 +1484,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
>>>>  	struct vb2_buffer *vb;
>>>>  	int ret;
>>>>
>>>> +	if (q->error) {
>>>> +		dprintk(1, "fatal error occurred on queue\n");
>>>> +		return -EIO;
>>>> +	}
>>>> +
>>>>  	vb = q->bufs[index];
>>>>
>>>>  	if ((req && q->uses_qbuf) ||
>>>
>>> How long has this problem existed? It looks like something that should go
>>> to the stable branches, too...
>>
>> It's always been there, but I don't think it is worth backporting. The use of
>> VIDIOC_PREPARE_BUF is very rare, let alone the combination with vb2_queue_error().
>>
>> I came across it while reviewing code.
> 
> What's the effect of the missing check? That the user may queue a buffer
> when the driver thinks the hardware won't be able to complete it? At least
> that doesn't seem like a security issue.

Right. But e.g. dqbuf will still return EIO in this case, so normally apps
will discover this error condition when dequeueing and not when enqueueing
buffers.

> 
> Anyway,
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 

Thanks,

	Hans
