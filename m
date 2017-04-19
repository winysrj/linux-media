Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33366
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935172AbdDSXiP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 19:38:15 -0400
Subject: Re: [PATCH] arm: dma: fix sharing of coherent DMA memory without
 struct page
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <CGME20170405160251epcas4p14cc5d5f6064c84b133b9e280ac987a93@epcas4p1.samsung.com>
 <20170405160242.14195-1-shuahkh@osg.samsung.com>
 <e49715a3-b925-79ad-7d1d-ce2cb5673a97@samsung.com>
 <3afd77e5-2a98-42fd-b5c9-cbf4c32baa4f@osg.samsung.com>
 <6d0c3e3c-8d1b-89bb-1392-6ffc7d8073c1@samsung.com>
 <20170414094643.GG17774@n2100.armlinux.org.uk>
Cc: gregkh@linuxfoundation.org, pawel@osciak.com,
        kyungmin.park@samsung.com, mchehab@kernel.org, will.deacon@arm.com,
        Robin.Murphy@arm.com, jroedel@suse.de, bart.vanassche@sandisk.com,
        gregory.clement@free-electrons.com, acourbot@nvidia.com,
        festevam@gmail.com, krzk@kernel.org,
        niklas.soderlund+renesas@ragnatech.se, sricharan@codeaurora.org,
        dledford@redhat.com, vinod.koul@intel.com,
        andrew.smirnov@gmail.com, mauricfo@linux.vnet.ibm.com,
        alexander.h.duyck@intel.com, sagi@grimberg.me,
        ming.l@ssi.samsung.com, martin.petersen@oracle.com,
        javier@dowhile0.org, javier@osg.samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <fac2d577-29fc-45c6-5881-adf19e8108cb@osg.samsung.com>
Date: Wed, 19 Apr 2017 17:38:10 -0600
MIME-Version: 1.0
In-Reply-To: <20170414094643.GG17774@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell, and Marek,

On 04/14/2017 03:46 AM, Russell King - ARM Linux wrote:
> On Fri, Apr 14, 2017 at 09:56:07AM +0200, Marek Szyprowski wrote:
>>>> This would be however quite large task, especially taking into account
>>>> all current users of DMA-buf framework...
>>> Yeah it will be a large task.
>>
>> Maybe once scatterlist are switched to pfns, changing dmabuf internal
>> memory representation to pfn array might be much easier.
> 
> Switching to a PFN array won't work either as we have no cross-arch
> way to translate PFNs to a DMA address and vice versa.  Yes, we have
> them in ARM, but they are an _implementation detail_ of ARM's
> DMA API support, they are not for use by drivers.
> 
> So, the very first problem that needs solving is this:
> 
>   How do we go from a coherent DMA allocation for device X to a set
>   of DMA addresses for device Y.
> 
> Essentially, we need a way of remapping the DMA buffer for use with
> another device, and returning a DMA address suitable for that device.
> This could well mean that we need to deal with setting up an IOMMU
> mapping.  My guess is that this needs to happen at the DMA coherent
> API level - the DMA coherent API needs to be augmented with support
> for this.  I'll call this "DMA coherent remap".
> 
> We then need to think about how to pass this through the dma-buf API.
> dma_map_sg() is done by the exporter, who should know what kind of
> memory is being exported.  The exporter can avoid calling dma_map_sg()
> if it knows in advance that it is exporting DMA coherent memory.
> Instead, the exporter can simply create a scatterlist with the DMA
> address and DMA length prepopulated with the results of the DMA
> coherent remap operation above.

As Russell pointed to armama-drm case, I looked at that closely.
armada-drm is creating sg_table and populating it with DMA-address in
its map_dma_buf ops and unmap_dma_buf ops handles the special case and
doesn't call dma_unmap_sg().

In the case of drm, gem_prime_map_dma_buf interfaces and the common
drm_gem_map_dma_buf() will need modification to not do dma_map_sg()
and create scatterlist with the DMA address and DMA length instead.
We have to get drm_gem_map_dma_buf() info. to have it not do dma_map_sg()
and create scatterlist.

Focusing on drm for now, looks like there are probably about 15 or so
map_dma_buf interfaces will need to handle coherent memory case.

> 
> What the scatterlist can't carry in this case is a set of valid
> struct page pointers, and an importer must not walk the scatterlist
> expecting to get at the virtual address parameters or struct page
> pointers.

Right - importers need handling to not walk the sg_list and handle
it differently. Is there a good example drm you can point me to for
this? aramda-drm seems to special case this in armada_gem_map_import()
if I am not mistaken.

> 
> On the mmap() side of things, remember that DMA coherent allocations
> may require special mapping into userspace, and which can only be
> mapped by the DMA coherent mmap support.  kmap etc will also need to
> be different.  So it probably makes sense for DMA coherent dma-buf
> exports to use a completely separate set of dma_buf_ops from the
> streaming version.
> 

I agree. It would make is easier and also limits the scope of changes.

> I think this is the easiest approach to solving the problem without
> needing massive driver changes all over the kernel.
> 

Anyway this is a quick note to say that I am looking into this and
haven't drooped it :)

thanks,
-- Shuah
