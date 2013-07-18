Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24763 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab3GRHP3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 03:15:29 -0400
Message-id: <51E7960C.8050707@samsung.com>
Date: Thu, 18 Jul 2013 09:15:24 +0200
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
In-reply-to: <CAPybu_0b9ADaUFFHuw=tKkVR4fiu9bGNJVgy4MGbuE-zAA9sZQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 7/17/2013 4:20 PM, Ricardo Ribalda Delgado wrote:
> Hello again Marek
>
> In my system I am doing the scatter gather compaction on device
> driver... But I agree that it would be better done on the vb2 layer.
>
> For the oversize sglist we could do one of this two things.
>
> If we want to have a simple pass processing we have to allocate an
> structure A for the worts case, work on that structure. then allocate
> a structure B for the exact size that we need, memcpy A to B, and
> free(A).
>
> Otherwise we need two passes. One to allocate the pages, and another
> one to allocate the pages and find out the amount of sg, and another
> to greate the sg structure.
>
> What do you prefer?

I would prefer two passes approach. In the first pass you just fill the
buf->pages array with order 0 entries and count the total number of memory
chunks (adding support for max dma segment size at this point should be
quite easy). In the second pass you just allocate the scatter list and
fill it with previously allocated pages.

I have also the following changes on my TODO list for vb2-dma-sg:
- remove custom vb2_dma_sg_desc structure and replace it with common
sg_table structure
- move mapping of the scatter list from device driver to vb2-dma-sg module
to simplify driver code and unify memory management across devices (so the
driver just gets correctly mapped scatter list and only reads dma addresses
of each memory chunk, no longer needs to track buffer state/ownership).
The correct flow is to call dma_map_sg() at buffer allocation,
dma_unmap_sg() at free and dma_sync_for_{device,cpu} in prepare/finish
callbacks. The only problem here is the need to convert all existing users
of vb2-dma-sg (marvell-ccic and solo6x10) to the new interface.

However I have completely no time atm to do any of the above changes. Would
You like to take any of the above tasks while playing with vb2-dma-sg?

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


