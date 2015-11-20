Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:47280 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162616AbbKTOzo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 09:55:44 -0500
Subject: Re: cobalt & dma
To: Ran Shalit <ranshalit@gmail.com>
References: <CAJ2oMhLN1T5GL3OhdcOLpK=t74NpULTz4ezu=fZDOEaXYVoWdg@mail.gmail.com>
 <564ADD04.90700@xs4all.nl>
 <CAJ2oMhKX4uq=Wd02=ZN7YUEVHuo_rjFi3VNkbfQDxL0O+_YmOA@mail.gmail.com>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <564F346B.3090504@xs4all.nl>
Date: Fri, 20 Nov 2015 15:55:39 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhKX4uq=Wd02=ZN7YUEVHuo_rjFi3VNkbfQDxL0O+_YmOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/20/2015 03:49 PM, Ran Shalit wrote:
> Hello,
> 
> 
> 
>>
>> No. All video capture/output devices all use DMA since it would be prohibitively
>> expensive for the CPU to do otherwise. So just dig in and implement it.
> 
> I am trying to better understand how read() operation actually use the
> dma, but I can't yet understand it from code.
> 
>>
>> No. The vmalloc variant is typically used for USB devices. For PCI(e) you'll
>> use videobuf2-dma-contig if the DMA engine requires physically contiguous DMA,
>> or videobuf2-dma-sg if the DMA engine supports scatter-gather DMA. You can
>> start with dma-contig since the DMA code tends to be simpler, but it is
>> harder to get the required physically contiguous memory if memory fragmentation
>> takes place. So you may not be able to allocate the buffers. dma-sg works much
>> better with virtual memory.
>>
>>
> 
> 
> 1. I tried to understand the code implementation of videobuf2 with
> regards to read():
> read() ->
>     vb2_read() ->
>           __vb2_perform_fileio()->
>              vb2_internal_dqbuf() &  copy_to_user()
> 
> Where is the actual allocation of dma contiguous memory ? Is done with
> the userspace calloc() call in userspace (as shown in the v4l2 API
> example) ? As I understand the calloc/malloc are not guaranteed to be
> contiguous.
>      How do I know if the try to allocate contigious memory has failed or not ?

The actual allocation happens in videobuf2-vmalloc/dma-contig/dma-sg depending
on the flavor of buffers you want (virtual memory, DMA into physically contiguous
memory or DMA into scatter-gather memory). The alloc operation is the one that
allocates the memory.

> 
> 
> 2. Is the call to copy_to_user results is performance degredation of
> read() in compare to mmap() method ?

Correct. But if you use the vb2 framework then you get stream I/O and the
read/write operations for free. vb2_read() sits on top of the stream I/O
implementation. It basically requests buffers and loops while queuing and
dequeuing buffers and calling copy_to_user() to copy the data into the
read() buffer.

This is (very) inefficient and applications should use the V4L2 stream I/O
mechanism directly.

Regards,

	Hans
