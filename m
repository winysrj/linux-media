Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:54978 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760042AbbKTQZO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 11:25:14 -0500
Subject: Re: cobalt & dma
To: Ran Shalit <ranshalit@gmail.com>
References: <CAJ2oMhLN1T5GL3OhdcOLpK=t74NpULTz4ezu=fZDOEaXYVoWdg@mail.gmail.com>
 <564ADD04.90700@xs4all.nl>
 <CAJ2oMhKX4uq=Wd02=ZN7YUEVHuo_rjFi3VNkbfQDxL0O+_YmOA@mail.gmail.com>
 <564F346B.3090504@xs4all.nl>
 <CAJ2oMhLWHCNxDmwOnwBxPdjjqbcO6Q2khBrzohMET=LsQ_AQjg@mail.gmail.com>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <564F4963.5050902@xs4all.nl>
Date: Fri, 20 Nov 2015 17:25:07 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhLWHCNxDmwOnwBxPdjjqbcO6Q2khBrzohMET=LsQ_AQjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/20/2015 05:14 PM, Ran Shalit wrote:
>>>
>>> 1. I tried to understand the code implementation of videobuf2 with
>>> regards to read():
>>> read() ->
>>>     vb2_read() ->
>>>           __vb2_perform_fileio()->
>>>              vb2_internal_dqbuf() &  copy_to_user()
>>>
>>> Where is the actual allocation of dma contiguous memory ? Is done with
>>> the userspace calloc() call in userspace (as shown in the v4l2 API
>>> example) ? As I understand the calloc/malloc are not guaranteed to be
>>> contiguous.
>>>      How do I know if the try to allocate contigious memory has failed or not ?
>>
>> The actual allocation happens in videobuf2-vmalloc/dma-contig/dma-sg depending
>> on the flavor of buffers you want (virtual memory, DMA into physically contiguous
>> memory or DMA into scatter-gather memory). The alloc operation is the one that
>> allocates the memory.
> 
> 
> Thank you very much for the time.
> 
> Just to be sure I understand the general mechanism of DMA with regards
> to the read() operation and in the case of using contiguous memory,
> I try to draw the general sequence as I understand it from the code
> and reading on this issue:
> 
> read() into user memory buffer ->
>           vb2_read() ->
>                 __vb2_perform_fileio() ->
>                         deaque buffer with:  vb2_internal_dqbuf() into
> contiguous DMA memory (kernel)  ->
>                                copy_to_user() will actually copy from
> the contigious dma memory(kernel)  into user buffer (userspace)
> 
> 1. Is the above sequence  correct ?

Yes.

> 2. When talking about contiguous dma memory (or scatter-gatther) we
> actually always refer to memory allocated in kernel, right ?

Usually. With the V4L2_MEMORY_USERPTR stream I/O mode it is userspace
that allocates the memory, but when using physically contiguous DMA
this particular streaming mode is normally not supported.

With V4L2_MEMORY_MMAP it is always the kernel that allocates the memory.

Regards,

	Hans
