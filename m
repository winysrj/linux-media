Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47140
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbcGTOGy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 10:06:54 -0400
Subject: Re: [PATCH] [media] vb2: map dmabuf for planes on driver queue
 instead of vidioc_qbuf
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
 <20160720132005.GC7976@valkosipuli.retiisi.org.uk>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Message-ID: <b0c71d30-4392-e404-c41b-923bcb5bcc2a@osg.samsung.com>
Date: Wed, 20 Jul 2016 10:06:42 -0400
MIME-Version: 1.0
In-Reply-To: <20160720132005.GC7976@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

On 07/20/2016 09:20 AM, Sakari Ailus wrote:
> Hi Javier,
> 
> On Fri, Jul 15, 2016 at 12:26:06PM -0400, Javier Martinez Canillas wrote:
>> The buffer planes' dma-buf are currently mapped when buffers are queued
>> from userspace but it's more appropriate to do the mapping when buffers
>> are queued in the driver since that's when the actual DMA operation are
>> going to happen.
>>
>> Suggested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> ---
>>
>> Hello,
>>
>> A side effect of this change is that if the dmabuf map fails for some
>> reasons (i.e: a driver using the DMA contig memory allocator but CMA
>> not being enabled), the fail will no longer happen on VIDIOC_QBUF but
>> later (i.e: in VIDIOC_STREAMON).
>>
>> I don't know if that's an issue though but I think is worth mentioning.
> 
> I have the same question has Hans --- why?
>

Yes, sorry for missing this information. Nicolas already explained a little
bit but the context is that I want to add dma-buf fence support to videobuf2,
and currently the dma-buf is unmapped in VIDIOC_DQBUF.

But with dma-buf fence, the idea is to be able to dequeue a buffer even when
the driver has not yet finished processing the buffer. So the dma-buf needs to
be mapped until vb2_buffer_done() when the driver is done processing the vb2,
and is able to signal the pending fence.

Since the unmapping was going to be delayed to vb2_buffer_done(), I thought
it would make sense to also move the mapping closer to when is really going
to be used and that's why I moved it to __enqueue_in_driver() in this patch.

But I didn't know that user-space was using the dma-buf map as a way to know
if the dma-buf will be compatible and fallback to a different streaming I/O
method if that's not the case. So $SUBJECT is wrong if it prevents user-space
to recover gracefully from a dma-buf mapping failure.

In any case, only delaying the unmapping is needed to support fence and doing
the map early in VIDIOC_QBUF is not an issue.
 
> I rather think we should keep the buffers mapped all the time. That'd
> require a bit of extra from the DMA-BUF framework I suppose, to support
> streaming mappings.
> 

Interesting, I can take a look to this possibility after adding the dma-buf
fence support.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
