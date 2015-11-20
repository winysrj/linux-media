Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:32984 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbbKTQOy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 11:14:54 -0500
Received: by igvi2 with SMTP id i2so35937893igv.0
        for <linux-media@vger.kernel.org>; Fri, 20 Nov 2015 08:14:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <564F346B.3090504@xs4all.nl>
References: <CAJ2oMhLN1T5GL3OhdcOLpK=t74NpULTz4ezu=fZDOEaXYVoWdg@mail.gmail.com>
	<564ADD04.90700@xs4all.nl>
	<CAJ2oMhKX4uq=Wd02=ZN7YUEVHuo_rjFi3VNkbfQDxL0O+_YmOA@mail.gmail.com>
	<564F346B.3090504@xs4all.nl>
Date: Fri, 20 Nov 2015 18:14:53 +0200
Message-ID: <CAJ2oMhLWHCNxDmwOnwBxPdjjqbcO6Q2khBrzohMET=LsQ_AQjg@mail.gmail.com>
Subject: Re: cobalt & dma
From: Ran Shalit <ranshalit@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>
>> 1. I tried to understand the code implementation of videobuf2 with
>> regards to read():
>> read() ->
>>     vb2_read() ->
>>           __vb2_perform_fileio()->
>>              vb2_internal_dqbuf() &  copy_to_user()
>>
>> Where is the actual allocation of dma contiguous memory ? Is done with
>> the userspace calloc() call in userspace (as shown in the v4l2 API
>> example) ? As I understand the calloc/malloc are not guaranteed to be
>> contiguous.
>>      How do I know if the try to allocate contigious memory has failed or not ?
>
> The actual allocation happens in videobuf2-vmalloc/dma-contig/dma-sg depending
> on the flavor of buffers you want (virtual memory, DMA into physically contiguous
> memory or DMA into scatter-gather memory). The alloc operation is the one that
> allocates the memory.


Thank you very much for the time.

Just to be sure I understand the general mechanism of DMA with regards
to the read() operation and in the case of using contiguous memory,
I try to draw the general sequence as I understand it from the code
and reading on this issue:

read() into user memory buffer ->
          vb2_read() ->
                __vb2_perform_fileio() ->
                        deaque buffer with:  vb2_internal_dqbuf() into
contiguous DMA memory (kernel)  ->
                               copy_to_user() will actually copy from
the contigious dma memory(kernel)  into user buffer (userspace)

1. Is the above sequence  correct ?
2. When talking about contiguous dma memory (or scatter-gatther) we
actually always refer to memory allocated in kernel, right ?

Best Regards,

Ran
