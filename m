Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24942 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775Ab3GRNeY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 09:34:24 -0400
Message-id: <51E7EEDC.9080003@samsung.com>
Date: Thu, 18 Jul 2013 15:34:20 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] videobuf2-dma-sg: Minimize the number of dma segments
References: <1373880874-9270-1-git-send-email-ricardo.ribalda@gmail.com>
 <51E65577.7010403@samsung.com>
 <CAPybu_3Je7+0Qh2OdptncnxC12G15Scad+A3yUeF898sVWKo8w@mail.gmail.com>
 <51E69F49.10500@samsung.com>
 <CAPybu_0b9ADaUFFHuw=tKkVR4fiu9bGNJVgy4MGbuE-zAA9sZQ@mail.gmail.com>
 <51E7960C.8050707@samsung.com>
 <CAPybu_36Pe5+RO+qmUXTQtbESnrJg4hwey1mXXRH4urc9i4GAg@mail.gmail.com>
In-reply-to: <CAPybu_36Pe5+RO+qmUXTQtbESnrJg4hwey1mXXRH4urc9i4GAg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 7/18/2013 9:39 AM, Ricardo Ribalda Delgado wrote:
> Hello again:
>
> I have started to implemt it, but I think there is more hidden work in
> this task as it seems. In order to call dma_map_sg and
> max_dma_segment_size I need acess to the struct device, but (correct
> me if I am wrong), vb2 is device agnostic. Adding the above
> functionality will mean not only updating marvell-ccic and solo6x10,
> but updating all the vb2 buffers.

For getting device pointer, vb2-dma-sg need to be extended with so called
'allocator context'. Please check how it is done in vb2-dma-contig
(vb2_dma_contig_init_ctx() function).


> Also after some readings, maybe the sg compactation should not be done
> here, but in dma_map_sg. According to the doc:
>
> """
> The implementation is free to merge several consecutive sglist entries
> into one (e.g. if DMA mapping is done with PAGE_SIZE granularity, any
> consecutive sglist entries can be merged into one provided the first one
> ends and the second one starts on a page boundary - in fact this is a huge
> advantage for cards which either cannot do scatter-gather or have very
> limited number of scatter-gather entries) and returns the actual number
> of sg entries it mapped them to. On failure 0 is returned.
> """
>
> So, my proposal would be to alloc with alloc_pages to try to get
> memory as coherent as possible, then split the page, set the sg in
> PAGE_SIZE lenghts, and then let the dma_map_sg do its magic. if it
> doesnt do compactation, fix dma_map_sg, so more driver could take
> advantage of it.

Right, this approach is probably the best one, but this way you would need
to do the compaction in every dma-mapping implementation for every supported
architecture. IMHO vb2-dma-sg can help dma-mapping by at least by allocating
memory in larger chunks and constructing shorter scatter list. Updating
dma-mapping functions across all architectures is a lot of work and testing,
so for initial version we should focus on vb2-dma-sg. Memory allocators
already do some work to ease mapping a buffer to dma space.

> I could also of course fix marvell-ccic and solo6x10 to use sg_table.
>
> Does anything of this make sense?

I would also like to help you as much as possible, but for the next 10 days
I will be not available for both personal reasons and holidays. If you have
any questions, feel free to leave them on my mail, I will reply asap I get
back.

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


