Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55906
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753511AbdDJOwh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 10:52:37 -0400
Subject: Re: [PATCH] arm: dma: fix sharing of coherent DMA memory without
 struct page
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        m.szyprowski@samsung.com
References: <20170405160242.14195-1-shuahkh@osg.samsung.com>
 <20170405231451.GB17774@n2100.armlinux.org.uk>
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
Message-ID: <953a06da-6eb3-a37e-d126-e11119217f29@osg.samsung.com>
Date: Mon, 10 Apr 2017 08:52:24 -0600
MIME-Version: 1.0
In-Reply-To: <20170405231451.GB17774@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/05/2017 05:14 PM, Russell King - ARM Linux wrote:
> On Wed, Apr 05, 2017 at 10:02:42AM -0600, Shuah Khan wrote:
>> When coherent DMA memory without struct page is shared, importer
>> fails to find the page and runs into kernel page fault when it
>> tries to dmabuf_ops_attach/map_sg/map_page the invalid page found
>> in the sg_table. Please see www.spinics.net/lists/stable/msg164204.html
>> for more information on this problem.
>>
>> This solution allows coherent DMA memory without struct page to be
>> shared by providing a way for the exporter to tag the DMA buffer as
>> a special buffer without struct page association and passing the
>> information in sg_table to the importer. This information is used
>> in attach/map_sg to avoid cleaning D-cache and mapping.
>>
>> The details of the change are:
>>
>> Framework:
>> - Add a new dma_attrs field to struct scatterlist.
>> - Add a new DMA_ATTR_DEV_COHERENT_NOPAGE attribute to clearly identify
>>   Coherent memory without struct page.
>> - Add a new dma_check_dev_coherent() interface to check if memory is
>>   the device coherent area. There is no way to tell where the memory
>>   returned by dma_alloc_attrs() came from.
>>
>> Exporter logic:
>> - Add logic to vb2_dc_alloc() to call dma_check_dev_coherent() and set
>>   DMA_ATTR_DEV_COHERENT_NOPAGE based the results of the check. This is
>>   done in the exporter context.
>> - Add logic to arm_dma_get_sgtable() to identify memory without struct
>>   page using DMA_ATTR_DEV_COHERENT_NOPAGE attribute. If this attr is
>>   set, arm_dma_get_sgtable() will set page as the cpu_addr and update
>>   dma_address and dma_attrs fields in struct scatterlist for this sgl.
>>   This is done in exporter context when buffer is exported. With this
> 
> This sentence appears to just end...
> 
> I'm not convinced that coherent allocations should be setting the "page"
> of a scatterlist to anything that isn't a real struct page or NULL.  It
> is, after all, an error to look up the virtual address etc of the
> scatterlist entry or kmap it when it isn't backed by a struct page.
> 
> I'm actually already passing non-page backed memory through the DMA API
> in armada-drm, although not entirely correctly, and etnaviv handles it
> fine:
> 
>         } else if (dobj->linear) {
>                 /* Single contiguous physical region - no struct page */
>                 if (sg_alloc_table(sgt, 1, GFP_KERNEL))
>                         goto free_sgt;
>                 sg_dma_address(sgt->sgl) = dobj->dev_addr;
>                 sg_dma_len(sgt->sgl) = dobj->obj.size;
> 
> This is not quite correct, as it assumes (which is safe for it currently)
> that the DMA address is the same on all devices.  On Dove, which is where
> this is used, that is the case, but it's not true elsewhere.  Also note
> that I'm avoid calling dma_map_sg() and dma_unmap_sg() - there's no iommus
> to be considered.

I see. That is not the case for the drivers involved in my use-case. exynos
has iommu and this s5p-mfc exporting buffers to exynos-gsc use-case does
work when iommu is enabled.

> 
> I'd suggest that this follows the same pattern - setting the DMA address
> (more appropriately for generic code) and the DMA length, while leaving
> the virtual address members NULL/0.  However, there's also the
> complication of setting up any IOMMUs that would be necessary.  I haven't
> looked at that, or how it could work.
> 
> I also think this should be documented in the dmabuf API that it can
> pass such scatterlists that are DMA-parameter only.
> 
> Lastly, I'd recommend that anything using this does _not_ provide
> functional kmap/kmap_atomic support for these - kmap and kmap_atomic
> are both out because there's no struct page anyway (and their use would
> probably oops the kernel in this scenario.)  I avoided mmap support in
> armada drm, but if there's a pressing reason and real use case for the
> importer to mmap() the buffers in userspace, it's something I could be
> convinced of.
> 
> What I'm quite certain of is that we do _not_ want to be passing
> coherent memory allocations into the streaming DMA API, not even with
> a special attribute.  The DMA API is about gaining coherent memory
> (shared ownership of the buffer), or mapping system memory to a
> specified device (which can imply unique ownership.)  Trying to mix
> the two together muddies the separation that we have there, and makes
> it harder to explain.  As can be seen from this patch, we'd end up
> needing to add this special DMA_ATTR_DEV_COHERENT_NOPAGE everywhere,
> which is added complexity on top of stuff that is not required for
> this circumstance.

The ownership can be tricky as you mentioned. In this particular use-case,
there is a clear ownership definition because of the way v4l2 export/import
works and also the qbuf/dqbuf rules. However, there might be other use-cases
ownership isn't clearly established.

> 
> I can see why you're doing it, to avoid having to duplicate more of
> the generic code in drm_prime, but I don't think plasting over this
> problem in arch code by adding this special flag is a particularly
> good way forward.
> 

Right. I went with this approach to avoid duplicating the code. It does
come with the complexity of needing to check the attribute in a few
places.

With the current code, we still have the issue of pagefault. Your patch
that adds a check for invalid doesn't cover all cases.

My goal behind this patch is two fold. 1. Fix the pagefault with a
definitive test and 2. see if per-device coherent memory can be passed
through.

The first goal is still worth while. Would it be reasonable to use
dma_check_dev_coherent() to test for this case in arm_dma_get_sgtable()
or even from dma_get_sgtable_attrs() and fail early? This will avoid
false negatives with the invalid page test. If this sounds reasonable,
I can spin this work to do that instead.

thanks,
-- Shuah
