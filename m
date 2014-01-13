Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1026 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaAMNtU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 08:49:20 -0500
Message-ID: <52D3EECF.3030500@xs4all.nl>
Date: Mon, 13 Jan 2014 14:49:03 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4 2/2] videobuf2-dma-sg: Replace vb2_dma_sg_desc with
 sg_table
References: <1375453200-28459-1-git-send-email-ricardo.ribalda@gmail.com> <1375453200-28459-3-git-send-email-ricardo.ribalda@gmail.com> <52C6CEC6.8020602@xs4all.nl> <CAPybu_1ABrgBGYNicL37cBE_A2-eYq4=7Cwa-nfEJWndVqq2EQ@mail.gmail.com> <52C6D90D.9010906@xs4all.nl> <CAPybu_2NAyE+Os9NJSSRY0n1+6ObWYpfH1m9Nj0c+B-xj+KVYg@mail.gmail.com> <52CD5BB2.2080305@samsung.com> <52D3B7E3.4030901@xs4all.nl> <52D3E3CB.60901@samsung.com>
In-Reply-To: <52D3E3CB.60901@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/13/2014 02:02 PM, Marek Szyprowski wrote:
> Hello,
> 
> On 2014-01-13 10:54, Hans Verkuil wrote:
>> Hi Marek, Ricardo,
>>
>> On 01/08/2014 03:07 PM, Marek Szyprowski wrote:
>>> Hello All,
>>>
>>> On 2014-01-03 16:51, Ricardo Ribalda Delgado wrote:
>>>> Hello Hans
>>>>
>>>> What if we move the dma_map_sg and dma_unmap_sg to the vb2 interface,
>>>> and there do something like:
>>>>
>>>> n_sg= dma_map_sg()
>>>> if (n_sg=-ENOMEM){
>>>>     split_table() //Breaks down the sg_table into monopages sg
>>>>     n_sg= dma_map_sg()
>>
>> This is not a good approach. Remember that if swiotbl needs to allocate
>> e.g. 17 contiguous pages it will round up to the next power of two, so it
>> allocates 32 pages. So even if dma_map_sg succeeds, it might waste a lot
>> of memory.
>>
>>>> }
>>>> if (n_sg=-ENOMEM)
>>>>    return -ENOMEM
>>>
>>> dma_map_sg/dma_unmap_sg should be moved to vb2-dma-sg memory allocator.
>>> The best place for calling them is buf_prepare() and buf_finish()
>>> callbacks. I think that I've already pointed this some time ago, but
>>> unfortunately I didn't find enough time to convert existing code.
>>
>> That would be nice, but this is a separate issue.
>>
>>> For solving the problem described by Hans, I think that vb2-dma-sg
>>> memory allocator should check dma mask of the client device and add
>>> appropriate GFP_DMA or GFP_DMA32 flags to alloc_pages(). This should fix
>>> the issues with failed dma_map_sg due to lack of bouncing buffers.
>>
>> Those GFP flags are for the scatterlist itself, and that can be placed
>> anywhere in memory (frankly, I'm not sure why sg_alloc_table_from_pages
>> has a gfp_flags argument at all and I think it is used incorrectly in
>> videobuf2-dma-sg.c as well).
> 
> I was talking about GFP flags passed to alloc_pages in vb2_dma_sg allocator,
> not the sg_alloc_table_from_pages().
> 
> IMHO the following changes should fix your problem:
> 
> 1. add client struct device pointer to vb2_dma_sg_desc, so vb2_dma_sg
> allocator will be able to check dma parameters of the client device.
> 
> 2. add following check to vb2_dma_sg_alloc_compacted():
> 
> if (dev->dma_mask) {
>      if (dev->dma_mask < DMA_BIT_MASK(32))
>          gfp_mask |= GFP_DMA;
>      else if (dev->dev_mask == DMA_BIT_MASK(32)
>          gfp_mask |= GFP_DMA32;
> }

No, it doesn't. This concerns the USERPTR memory model, so the memory for
the buffer is allocated by userspace, not by the kernel. The MMAP memory
model works fine, that's not where the problem is.

> 
> 
>> I see two options. The first is the patch I included below: this adds a
>> bool to sg_alloc_table_from_pages() that tells it whether or not page
>> combining should be enabled. It also adds the vb2 queue's gfp_flags as
>> an argument to the get_userptr operation. In videobuf2-dma-sg.c that is
>> checked to see whether or not sg_alloc_table_from_pages() should enable
>> page-combining.
>>
>> The alternative would be to have vb2_queue_init check if the use of
>> V4L2_MEMORY_USERPTR would lead to dma bouncing based on the q->io_modes
>> and q->gfp_flags and if so, remove USERPTR support from io_modes. Do
>> we really want to have page bouncing for video capture?
> 
> So the main problem is about user ptr modes? This once again shows that
> the current user pointer API is too limited and should be replaced by
> something more reliable.

The userptr model worked perfectly fine before the memory compaction was
added. This is a pure regression.

Regards,

	Hans
