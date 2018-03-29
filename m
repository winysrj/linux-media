Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:46512 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752261AbeC2QZy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 12:25:54 -0400
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>
Cc: linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-2-christian.koenig@amd.com>
 <20180328123830.GB25060@infradead.org>
 <613a6c91-7e72-5589-77e6-587ec973d553@gmail.com>
 <c81df70d-191d-bf8e-293a-413dd633e1fc@deltatee.com>
 <5498e9b5-8fe5-8999-a44e-f7dc483bc9ce@amd.com>
 <16c7bef8-5f03-9e89-1f50-b62fb139a36f@deltatee.com>
 <6a5c9a10-50fe-b03d-dfc1-791d62d79f8e@amd.com>
 <e751cd28-f115-569f-5248-d24f30dee3cb@deltatee.com>
 <73578b4e-664b-141c-3e1f-e1fae1e4db07@amd.com>
 <1b08c13e-b4a2-08f2-6194-93e6c21b7965@deltatee.com>
 <70adc2cc-f7aa-d4b9-7d7a-71f3ae99f16c@gmail.com>
 <98ce6cfd-bcf3-811e-a0f1-757b60da467a@deltatee.com>
 <8d050848-8970-b8c4-a657-429fefd31769@amd.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <d2de0c2e-4c2d-9e46-1c26-bfa40ca662ff@deltatee.com>
Date: Thu, 29 Mar 2018 10:25:52 -0600
MIME-Version: 1.0
In-Reply-To: <8d050848-8970-b8c4-a657-429fefd31769@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 29/03/18 10:10 AM, Christian König wrote:
> Why not? I mean the dma_map_resource() function is for P2P while other 
> dma_map_* functions are only for system memory.

Oh, hmm, I wasn't aware dma_map_resource was exclusively for mapping
P2P. Though it's a bit odd seeing we've been working under the
assumption that PCI P2P is different as it has to translate the PCI bus
address. Where as P2P for devices on other buses is a big unknown.

>> And this is necessary to
>> check if the DMA ops in use support it or not. We can't have the
>> dma_map_X() functions do the wrong thing because they don't support it yet.
> 
> Well that sounds like we should just return an error from 
> dma_map_resources() when an architecture doesn't support P2P yet as Alex 
> suggested.

Yes, well except in our patch-set we can't easily use
dma_map_resources() as we either have SGLs to deal with or we need to
create whole new interfaces to a number of subsystems.

> You don't seem to understand the implications: The devices do have a 
> common upstream bridge! In other words your code would currently claim 
> that P2P is supported, but in practice it doesn't work.

Do they? They don't on any of the Intel machines I'm looking at. The
previous version of the patchset not only required a common upstream
bridge but two layers of upstream bridges on both devices which would
effectively limit transfers to PCIe switches only. But Bjorn did not
like this.

> You need to include both drivers which participate in the P2P 
> transaction to make sure that both supports this and give them 
> opportunity to chicken out and in the case of AMD APUs even redirect the 
> request to another location (e.g. participate in the DMA translation).

I don't think it's the drivers responsibility to reject P2P . The
topology is what governs support or not. The discussions we had with
Bjorn settled on if the devices are all behind the same bridge they can
communicate with each other. This is essentially guaranteed by the PCI spec.

> DMA-buf fortunately seems to handle all this already, that's why we 
> choose it as base for our implementation.

Well, unfortunately DMA-buf doesn't help for the drivers we are working
with as neither the block layer nor the RDMA subsystem have any
interfaces for it.

Logan
