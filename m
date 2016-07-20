Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47147
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbcGTOTM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 10:19:12 -0400
Subject: Re: [PATCH] [media] vb2: map dmabuf for planes on driver queue
 instead of vidioc_qbuf
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
 <20160720132005.GC7976@valkosipuli.retiisi.org.uk>
 <b0c71d30-4392-e404-c41b-923bcb5bcc2a@osg.samsung.com>
 <e6444ca3-53c9-15c3-ff49-cb0b3e291fc2@xs4all.nl>
Cc: linux-kernel@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Luis de Bethencourt <luisbg@osg.samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <59bb1cff-2743-dd86-e02d-a771b50266c9@osg.samsung.com>
Date: Wed, 20 Jul 2016 10:19:01 -0400
MIME-Version: 1.0
In-Reply-To: <e6444ca3-53c9-15c3-ff49-cb0b3e291fc2@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 07/20/2016 10:12 AM, Hans Verkuil wrote:
> On 07/20/2016 04:06 PM, Javier Martinez Canillas wrote:
>> Hello Sakari,
>>
>> On 07/20/2016 09:20 AM, Sakari Ailus wrote:
>>> Hi Javier,
>>>
>>> On Fri, Jul 15, 2016 at 12:26:06PM -0400, Javier Martinez Canillas wrote:
>>>> The buffer planes' dma-buf are currently mapped when buffers are queued
>>>> from userspace but it's more appropriate to do the mapping when buffers
>>>> are queued in the driver since that's when the actual DMA operation are
>>>> going to happen.
>>>>
>>>> Suggested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
>>>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>>>
>>>> ---
>>>>
>>>> Hello,
>>>>
>>>> A side effect of this change is that if the dmabuf map fails for some
>>>> reasons (i.e: a driver using the DMA contig memory allocator but CMA
>>>> not being enabled), the fail will no longer happen on VIDIOC_QBUF but
>>>> later (i.e: in VIDIOC_STREAMON).
>>>>
>>>> I don't know if that's an issue though but I think is worth mentioning.
>>>
>>> I have the same question has Hans --- why?
>>>
>>
>> Yes, sorry for missing this information. Nicolas already explained a little
>> bit but the context is that I want to add dma-buf fence support to videobuf2,
>> and currently the dma-buf is unmapped in VIDIOC_DQBUF.
>>
>> But with dma-buf fence, the idea is to be able to dequeue a buffer even when
>> the driver has not yet finished processing the buffer. So the dma-buf needs to
>> be mapped until vb2_buffer_done() when the driver is done processing the vb2,
>> and is able to signal the pending fence.
>>
>> Since the unmapping was going to be delayed to vb2_buffer_done(), I thought
>> it would make sense to also move the mapping closer to when is really going
>> to be used and that's why I moved it to __enqueue_in_driver() in this patch.
>>
>> But I didn't know that user-space was using the dma-buf map as a way to know
>> if the dma-buf will be compatible and fallback to a different streaming I/O
>> method if that's not the case. So $SUBJECT is wrong if it prevents user-space
>> to recover gracefully from a dma-buf mapping failure.
>>
>> In any case, only delaying the unmapping is needed to support fence and doing
>> the map early in VIDIOC_QBUF is not an issue.
> 
> OK. I've rejected this patch. I understand the DQBUF part and I happily accept

Ok, thanks.

> a patch for that. But the other side should be left as-is. The TODO comment
> should probably be dropped, now that I think about it.
>

I can post such a patch, do you want me to also add a comment about why is done
in QBUF instead of when the buffer is queued in the driver (e.g: that user-space
is able to recover in QBUF but no in STREAMON) or just removing it and mention
that in the commit message is enough?
 
> Regards,
> 
> 	Hans
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
