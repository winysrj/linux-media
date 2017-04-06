Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20961 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755303AbdDFMBa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Apr 2017 08:01:30 -0400
Subject: Re: [PATCH] arm: dma: fix sharing of coherent DMA memory without
 struct page
To: Shuah Khan <shuahkh@osg.samsung.com>, linux@armlinux.org.uk,
        gregkh@linuxfoundation.org, pawel@osciak.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: will.deacon@arm.com, Robin.Murphy@arm.com, jroedel@suse.de,
        bart.vanassche@sandisk.com, gregory.clement@free-electrons.com,
        acourbot@nvidia.com, festevam@gmail.com, krzk@kernel.org,
        niklas.soderlund+renesas@ragnatech.se, sricharan@codeaurora.org,
        dledford@redhat.com, vinod.koul@intel.com,
        andrew.smirnov@gmail.com, mauricfo@linux.vnet.ibm.com,
        alexander.h.duyck@intel.com, sagi@grimberg.me,
        ming.l@ssi.samsung.com, martin.petersen@oracle.com,
        javier@dowhile0.org, javier@osg.samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <e49715a3-b925-79ad-7d1d-ce2cb5673a97@samsung.com>
Date: Thu, 06 Apr 2017 14:01:23 +0200
MIME-version: 1.0
In-reply-to: <20170405160242.14195-1-shuahkh@osg.samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
References: <CGME20170405160251epcas4p14cc5d5f6064c84b133b9e280ac987a93@epcas4p1.samsung.com>
 <20170405160242.14195-1-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On 2017-04-05 18:02, Shuah Khan wrote:
> When coherent DMA memory without struct page is shared, importer
> fails to find the page and runs into kernel page fault when it
> tries to dmabuf_ops_attach/map_sg/map_page the invalid page found
> in the sg_table. Please see www.spinics.net/lists/stable/msg164204.html
> for more information on this problem.
>
> This solution allows coherent DMA memory without struct page to be
> shared by providing a way for the exporter to tag the DMA buffer as
> a special buffer without struct page association and passing the
> information in sg_table to the importer. This information is used
> in attach/map_sg to avoid cleaning D-cache and mapping.
>
> The details of the change are:
>
> Framework:
> - Add a new dma_attrs field to struct scatterlist.
> - Add a new DMA_ATTR_DEV_COHERENT_NOPAGE attribute to clearly identify
>    Coherent memory without struct page.
> - Add a new dma_check_dev_coherent() interface to check if memory is
>    the device coherent area. There is no way to tell where the memory
>    returned by dma_alloc_attrs() came from.
>
> Exporter logic:
> - Add logic to vb2_dc_alloc() to call dma_check_dev_coherent() and set
>    DMA_ATTR_DEV_COHERENT_NOPAGE based the results of the check. This is
>    done in the exporter context.
> - Add logic to arm_dma_get_sgtable() to identify memory without struct
>    page using DMA_ATTR_DEV_COHERENT_NOPAGE attribute. If this attr is
>    set, arm_dma_get_sgtable() will set page as the cpu_addr and update
>    dma_address and dma_attrs fields in struct scatterlist for this sgl.
>    This is done in exporter context when buffer is exported. With this
>    Note: This change is made on top of Russell King's patch that added
>    !pfn_valid(pfn) check to arm_dma_get_sgtable() to error out on invalid
>    pages. Coherent memory without struct page will trigger this error.
>
> Importer logic:
> - Add logic to vb2_dc_dmabuf_ops_attach() to identify memory without
>    struct page using DMA_ATTR_DEV_COHERENT_NOPAGE attribute when it copies
>    the sg_table from the exporter. It will copy dma_attrs and dma_address
>    fields. With this logic, dmabuf_ops_attach will no longer trip on an
>    invalid page.
> - Add logic to arm_dma_map_sg() to avoid mapping the page when sg_table
>    has DMA_ATTR_DEV_COHERENT_NOPAGE buffer.
> - Add logic to arm_dma_unmap_sg() to do nothing for sg entries with
>    DMA_ATTR_DEV_COHERENT_NOPAGE attribute.
>
> Without this change the following use-case that runs into kernel
> pagefault when importer tries to attach the exported buffer.
>
> With this change it works: (what a relief after watching pagefaults for
> weeks!!)
>
> gst-launch-1.0 filesrc location=~/GH3_MOV_HD.mp4 ! qtdemux ! h264parse ! v4l2video4dec capture-io-mode=dmabuf ! v4l2video7convert output-io-mode=dmabuf-import ! kmssink force-modesetting=true
>
> I am sending RFC patch to get feedback on the approach and see if I missed
> anything.

Frankly, once You decided to hack around dma-buf and issues with coherent,
carved out memory, it might be a bit better to find the ultimate solution
instead of the another hack. Please note that it will still not allow to
share a buffer allocated from carved-out memory and a device, which is
behind IOMMU.

I thought a bit about this and the current shape of dma-buf code.

IMHO the proper way of solving all those issues would be to replace
dma-buf internal representation of the memory from struct scatter_list
to pfn array. This would really solve the problem of buffers which
cannot be properly represented by scatter lists/struct pages and would
even allow sharing buffers between all kinds of devices. Scatter-lists
are also quite over-engineered structures to represent a single buffer
(pfn array is a bit more compact representation). Also there is a lots
of buggy code which use scatter-list in a bit creative way (like
assuming that each page maps to a single scatter list entry for
example). The only missing piece, required for such change would be
extending DMA-mapping with dma_map_pfn() interface.

This would be however quite large task, especially taking into account
all current users of DMA-buf framework...

> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>   arch/arm/mm/dma-mapping.c                      | 34 ++++++++++++++++++++++----
>   drivers/base/dma-coherent.c                    | 25 +++++++++++++++++++
>   drivers/media/v4l2-core/videobuf2-dma-contig.c |  6 +++++
>   include/linux/dma-mapping.h                    |  8 ++++++
>   include/linux/scatterlist.h                    |  1 +
>   5 files changed, 69 insertions(+), 5 deletions(-)
 > [...]

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
