Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33483 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbbKTOtS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 09:49:18 -0500
Received: by igvi2 with SMTP id i2so34219125igv.0
        for <linux-media@vger.kernel.org>; Fri, 20 Nov 2015 06:49:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <564ADD04.90700@xs4all.nl>
References: <CAJ2oMhLN1T5GL3OhdcOLpK=t74NpULTz4ezu=fZDOEaXYVoWdg@mail.gmail.com>
	<564ADD04.90700@xs4all.nl>
Date: Fri, 20 Nov 2015 16:49:18 +0200
Message-ID: <CAJ2oMhKX4uq=Wd02=ZN7YUEVHuo_rjFi3VNkbfQDxL0O+_YmOA@mail.gmail.com>
Subject: Re: cobalt & dma
From: Ran Shalit <ranshalit@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,



>
> No. All video capture/output devices all use DMA since it would be prohibitively
> expensive for the CPU to do otherwise. So just dig in and implement it.

I am trying to better understand how read() operation actually use the
dma, but I can't yet understand it from code.

>
> No. The vmalloc variant is typically used for USB devices. For PCI(e) you'll
> use videobuf2-dma-contig if the DMA engine requires physically contiguous DMA,
> or videobuf2-dma-sg if the DMA engine supports scatter-gather DMA. You can
> start with dma-contig since the DMA code tends to be simpler, but it is
> harder to get the required physically contiguous memory if memory fragmentation
> takes place. So you may not be able to allocate the buffers. dma-sg works much
> better with virtual memory.
>
>


1. I tried to understand the code implementation of videobuf2 with
regards to read():
read() ->
    vb2_read() ->
          __vb2_perform_fileio()->
             vb2_internal_dqbuf() &  copy_to_user()

Where is the actual allocation of dma contiguous memory ? Is done with
the userspace calloc() call in userspace (as shown in the v4l2 API
example) ? As I understand the calloc/malloc are not guaranteed to be
contiguous.
     How do I know if the try to allocate contigious memory has failed or not ?


2. Is the call to copy_to_user results is performance degredation of
read() in compare to mmap() method ?

Best Regards,
Ran
