Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:46240 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbbKQHxp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 02:53:45 -0500
Subject: Re: cobalt & dma
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
References: <CAJ2oMhLN1T5GL3OhdcOLpK=t74NpULTz4ezu=fZDOEaXYVoWdg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <564ADD04.90700@xs4all.nl>
Date: Tue, 17 Nov 2015 08:53:40 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhLN1T5GL3OhdcOLpK=t74NpULTz4ezu=fZDOEaXYVoWdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/17/2015 08:39 AM, Ran Shalit wrote:
> Hello,
> 
> I intend to use cobalt driver as a refence for new pci v4l2 driver,
> which is required to use several input simultaneously. for this cobalt
> seems like a best starting point.
> read/write streaming will probably be suffecient (at least for the
> dirst debugging).
> The configuration in my cast is i7 core <-- pci ---> fpga.
> I see that the dma implementation is quite complex, and would like to
> ask for some tips regarding the following points related to dma issue:
> 
> 1. Is it possible to do the read/write without dma (for debug as start) ?

No. All video capture/output devices all use DMA since it would be prohibitively
expensive for the CPU to do otherwise. So just dig in and implement it.

> What changes are required for read without dma (I assume dma is used
> by default in read/write) ?
> Is it done by using  #include <media/videobuf2-vmalloc.h> instead of
> #include <media/videobuf2-dma*> ?

No. The vmalloc variant is typically used for USB devices. For PCI(e) you'll
use videobuf2-dma-contig if the DMA engine requires physically contiguous DMA,
or videobuf2-dma-sg if the DMA engine supports scatter-gather DMA. You can
start with dma-contig since the DMA code tends to be simpler, but it is
harder to get the required physically contiguous memory if memory fragmentation
takes place. So you may not be able to allocate the buffers. dma-sg works much
better with virtual memory.

> 
> 2. I find it difficult to unerstand  cobalt_dma_start_streaming()
> implementation, which has many specific cobalt memory writing
> iowrite32().
> How can I understand how/what to implement dma in my specific platform/device ?

Read include/media/videobuf2-core.h.

There is also an LWN article somewhere (albeit somewhat outdated by now).

Don't expect to write three lines of code and everything works. You *do*
have to write the code for your DMA hardware, there is no way around that.

Regards,

	Hans

> 
> 
> Best Regards,
> Ran
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

