Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:46182 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751161AbeC2Ppa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 11:45:30 -0400
To: christian.koenig@amd.com, Christoph Hellwig <hch@infradead.org>
Cc: linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
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
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <98ce6cfd-bcf3-811e-a0f1-757b60da467a@deltatee.com>
Date: Thu, 29 Mar 2018 09:45:23 -0600
MIME-Version: 1.0
In-Reply-To: <70adc2cc-f7aa-d4b9-7d7a-71f3ae99f16c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 29/03/18 05:44 AM, Christian König wrote:
> Am 28.03.2018 um 21:53 schrieb Logan Gunthorpe:
>>
>> On 28/03/18 01:44 PM, Christian König wrote:
>>> Well, isn't that exactly what dma_map_resource() is good for? As far as
>>> I can see it makes sure IOMMU is aware of the access route and
>>> translates a CPU address into a PCI Bus address.
>>> I'm using that with the AMD IOMMU driver and at least there it works
>>> perfectly fine.
>> Yes, it would be nice, but no arch has implemented this yet. We are just
>> lucky in the x86 case because that arch is simple and doesn't need to do
>> anything for P2P (partially due to the Bus and CPU addresses being the
>> same). But in the general case, you can't rely on it.
> 
> Well, that an arch hasn't implemented it doesn't mean that we don't have 
> the right interface to do it.

Yes, but right now we don't have a performant way to check if we are
doing P2P or not in the dma_map_X() wrappers. And this is necessary to
check if the DMA ops in use support it or not. We can't have the
dma_map_X() functions do the wrong thing because they don't support it yet.

> Devices integrated in the CPU usually only "claim" to be PCIe devices. 
> In reality their memory request path go directly through the integrated 
> north bridge. The reason for this is simple better throughput/latency.

These are just more reasons why our patchset restricts to devices behind
a switch. And more mess for someone to deal with if they need to relax
that restriction.

Logan
