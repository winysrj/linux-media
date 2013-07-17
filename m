Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43857 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab3GQNmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 09:42:37 -0400
Message-id: <51E69F49.10500@samsung.com>
Date: Wed, 17 Jul 2013 15:42:33 +0200
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
In-reply-to: <CAPybu_3Je7+0Qh2OdptncnxC12G15Scad+A3yUeF898sVWKo8w@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 7/17/2013 11:43 AM, Ricardo Ribalda Delgado wrote:
> Hi Marek
>
>   alloc_pages_exact returns pages of order 0, every single page is
> filled into buf->pages, that then is used by vb2_dma_sg_mmap(), that
> also expects order 0 pages (its loops increments in PAGE_SIZE). The
> code has been tested on real HW.
>
> Your concern is that that alloc_pages_exact splits the higher order pages?
>
> Do you want that videobuf2-dma-sg to have support for higher order pages?

Ah... My fault. I didn't notice that you recalculate req_pages at the
begginning of each loop iteration, so the code is correct, buf->pages is
filled correctly with order 0 pages.

So now the only issue I see is the oversized sglist allocation (the size
of sg list is computed for worst case, 0 order pages) and lack of the max
segment size support. Sadly there are devices which can handle single sg
chunk up to some predefined size (see dma_get_max_seg_size() function).

For some reference code, please check __iommu_map_sg() and maybe
__iommu_alloc_buffer() functions in arch/arm/mm/dma-mapping.c

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


