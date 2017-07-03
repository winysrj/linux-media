Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59755 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752944AbdGCJ1i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 05:27:38 -0400
Subject: Re: [PATCH v3 0/2] [media] videobuf2-dc: Add support for cacheable MMAP
To: Thierry Escande <thierry.escande@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <f829886e-4842-a500-6b10-9a46e1b763f5@samsung.com>
Date: Mon, 03 Jul 2017 11:27:32 +0200
MIME-version: 1.0
In-reply-to: <1477471926-15796-1-git-send-email-thierry.escande@collabora.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20161026085228epcas3p3895ea279d5538750a3b1c59715ad3761@epcas3p3.samsung.com>
 <1477471926-15796-1-git-send-email-thierry.escande@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

On 2016-10-26 10:52, Thierry Escande wrote:
> This series adds support for cacheable MMAP in DMA coherent allocator.
>
> The first patch moves the vb2_dc_get_base_sgt() function above mmap
> callbacks for calls introduced by the second patch. This avoids a
> forward declaration.

I'm sorry for late review. Sylwester kicked me for pending v4l2/vb2 patches
and I've just found this thread in my TODO folder.

The main question here if we want to merge incomplete solution or not. As
for now, there is no support in ARM/ARM64 for NON_CONSISTENT attribute.
Also none of the v4l2 drivers use it. Sadly support for NON_CONSISTENT
attribute is not fully implemented nor even defined in mainline.

I know that it works fine for some vendor kernel trees, but supporting it in
mainline was a bit controversial. There is no proper way to sync cache 
for such
buffers. Calling dma_sync_sg worked so far, but it has to be first agreed as
a proper DMA API.

> Changes in v2:
> - Put function move in a separate patch
> - Added comments
>
> Changes in v3:
> - Remove redundant test on NO_KERNEL_MAPPING DMA attribute in mmap()
>
> Heng-Ruey Hsu (1):
>    [media] videobuf2-dc: Support cacheable MMAP
>
> Thierry Escande (1):
>    [media] videobuf2-dc: Move vb2_dc_get_base_sgt() above mmap callbacks
>
>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 60 ++++++++++++++++----------
>   1 file changed, 38 insertions(+), 22 deletions(-)
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
