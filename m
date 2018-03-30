Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:53108 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752303AbeC3Sqv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Mar 2018 14:46:51 -0400
To: Jerome Glisse <jglisse@redhat.com>
Cc: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
References: <5498e9b5-8fe5-8999-a44e-f7dc483bc9ce@amd.com>
 <16c7bef8-5f03-9e89-1f50-b62fb139a36f@deltatee.com>
 <6a5c9a10-50fe-b03d-dfc1-791d62d79f8e@amd.com>
 <e751cd28-f115-569f-5248-d24f30dee3cb@deltatee.com>
 <73578b4e-664b-141c-3e1f-e1fae1e4db07@amd.com>
 <1b08c13e-b4a2-08f2-6194-93e6c21b7965@deltatee.com>
 <70adc2cc-f7aa-d4b9-7d7a-71f3ae99f16c@gmail.com>
 <98ce6cfd-bcf3-811e-a0f1-757b60da467a@deltatee.com>
 <8d050848-8970-b8c4-a657-429fefd31769@amd.com>
 <d2de0c2e-4c2d-9e46-1c26-bfa40ca662ff@deltatee.com>
 <20180330015854.GA3572@redhat.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <0234bc5e-495e-0f68-fb0a-debb17a35761@deltatee.com>
Date: Fri, 30 Mar 2018 12:46:42 -0600
MIME-Version: 1.0
In-Reply-To: <20180330015854.GA3572@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 29/03/18 07:58 PM, Jerome Glisse wrote:
> On Thu, Mar 29, 2018 at 10:25:52AM -0600, Logan Gunthorpe wrote:
>>
>>
>> On 29/03/18 10:10 AM, Christian König wrote:
>>> Why not? I mean the dma_map_resource() function is for P2P while other 
>>> dma_map_* functions are only for system memory.
>>
>> Oh, hmm, I wasn't aware dma_map_resource was exclusively for mapping
>> P2P. Though it's a bit odd seeing we've been working under the
>> assumption that PCI P2P is different as it has to translate the PCI bus
>> address. Where as P2P for devices on other buses is a big unknown.
> 
> dma_map_resource() is the right API (thought its current implementation
> is fill with x86 assumptions). So i would argue that arch can decide to
> implement it or simply return dma error address which trigger fallback
> path into the caller (at least for GPU drivers). SG variant can be added
> on top.
> 
> dma_map_resource() is the right API because it has all the necessary
> informations. It use the CPU physical address as the common address
> "language" with CPU physical address of PCIE bar to map to another
> device you can find the corresponding bus address from the IOMMU code
> (NOP on x86). So dma_map_resource() knows both the source device which
> export its PCIE bar and the destination devices.

Well, as it is today, it doesn't look very sane to me. The default is to
just return the physical address if the architecture doesn't support it.
So if someone tries this on an arch that hasn't added itself to return
an error they're very likely going to just end up DMAing to an invalid
address and loosing the data or causing a machine check.

Furthermore, the API does not have all the information it needs to do
sane things. A phys_addr_t doesn't really tell you anything about the
memory behind it or what needs to be done with it. For example, on some
arm64 implementations if the physical address points to a PCI BAR and
that BAR is behind a switch with the DMA device then the address must be
converted to the PCI BUS address. On the other hand, if it's a physical
address of a device in an SOC it might need to  be handled in a
completely different way. And right now all the implementations I can
find seem to just assume that phys_addr_t points to regular memory and
can be treated as such.

This is one of the reasons that, based on feedback, our work went from
being general P2P with any device to being restricted to only P2P with
PCI devices. The dream that we can just grab the physical address of any
device and use it in a DMA request is simply not realistic.

Logan
