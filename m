Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22163 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751165AbdGMLNe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 07:13:34 -0400
Subject: Re: [PATCH v3 0/2] [media] videobuf2-dc: Add support for cacheable MMAP
To: Christoph Hellwig <hch@lst.de>
Cc: Thierry Escande <thierry.escande@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <7505cb31-6bd1-7f76-f975-aa5e61e567f0@samsung.com>
Date: Thu, 13 Jul 2017 13:13:28 +0200
MIME-version: 1.0
In-reply-to: <20170705173327.GD5417@lst.de>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20161026085228epcas3p3895ea279d5538750a3b1c59715ad3761@epcas3p3.samsung.com>
 <1477471926-15796-1-git-send-email-thierry.escande@collabora.com>
 <f829886e-4842-a500-6b10-9a46e1b763f5@samsung.com>
 <20170705173327.GD5417@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christoph,

On 2017-07-05 19:33, Christoph Hellwig wrote:
> On Mon, Jul 03, 2017 at 11:27:32AM +0200, Marek Szyprowski wrote:
>> The main question here if we want to merge incomplete solution or not. As
>> for now, there is no support in ARM/ARM64 for NON_CONSISTENT attribute.
>> Also none of the v4l2 drivers use it. Sadly support for NON_CONSISTENT
>> attribute is not fully implemented nor even defined in mainline.
>>
> DMA_ATTR_NON_CONSISTENT is the way to get the dma_alloc_noncoherent
> semantics through the dma_alloc_attr API, and as such I think it is
> pretty well defined, although the documentation in
> Documentation/DMA-attributes.txt is really bad and we need to improve
> it, by merging it with the dma_alloc_noncoherent description in
> Documentation/DMA-API.txt. My series to remove dma_alloc_noncoherent
> updates the latter to mention DMA_ATTR_NON_CONSISTENT, but
> we should probably merge Documentation/DMA-API.txt,
> Documentation/DMA-attributes.txt and Documentation/DMA-API-HOWTO.txt
> into a single coherent document.

Right. I started conversion of dma_alloc_noncoherent to NON_CONSISTENT
DMA attribute, but later I got stuck at the details of cache 
synchronization.

>> I know that it works fine for some vendor kernel trees, but supporting it in
>> mainline was a bit controversial. There is no proper way to sync cache for
>> such
>> buffers. Calling dma_sync_sg worked so far, but it has to be first agreed as
>> a proper DMA API.
> As documented in Documentation/DMA-API.txt the proper way to sync
> noncoherent/nonconsistent regions is to call dma_cache_sync.  It seems
> like it generally is the same as dma_sync_range/sg so if we could
> eventually merge these APIs that should reduce the confusion further.

Original dma_alloc_noncoherent utilized dma_cache_sync() function, which had
some flaws, which prevented me to continue that task and introduce it to ARM
architecture. The dma_alloc_noncoherent() and dma_cache_sync() API lacks
buffer ownership and imprecisely defines how and when the caches has to be
synchronized. dma_cache_sync() also lacks DMA address argument, what also
complicates potential lightweight implementation.

IMHO it would make sense to change it to work similar to the other
dma_sync_*_for_{cpu,device} functions, but I didn't find enough time to
finally take a try.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
