Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0074.outbound.protection.outlook.com ([104.47.36.74]:11456
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752732AbeC1To1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 15:44:27 -0400
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
To: Logan Gunthorpe <logang@deltatee.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>
Cc: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
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
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <73578b4e-664b-141c-3e1f-e1fae1e4db07@amd.com>
Date: Wed, 28 Mar 2018 21:44:11 +0200
MIME-Version: 1.0
In-Reply-To: <e751cd28-f115-569f-5248-d24f30dee3cb@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.03.2018 um 20:57 schrieb Logan Gunthorpe:
>
> On 28/03/18 12:28 PM, Christian König wrote:
>> I'm just using amdgpu as blueprint because I'm the co-maintainer of it
>> and know it mostly inside out.
> Ah, I see.
>
>> The resource addresses are translated using dma_map_resource(). As far
>> as I know that should be sufficient to offload all the architecture
>> specific stuff to the DMA subsystem.
> It's not. The dma_map infrastructure currently has no concept of
> peer-to-peer mappings and is designed for system memory only. No
> architecture I'm aware of will translate PCI CPU addresses into PCI Bus
> addresses which is necessary for any transfer that doesn't go through
> the root complex (though on arches like x86 the CPU and Bus address
> happen to be the same). There's a lot of people that would like to see
> this change but it's likely going to be a long road before it does.

Well, isn't that exactly what dma_map_resource() is good for? As far as 
I can see it makes sure IOMMU is aware of the access route and 
translates a CPU address into a PCI Bus address.

> Furthermore, one of the reasons our patch-set avoids going through the
> root complex at all is that IOMMU drivers will need to be made aware
> that it is operating on P2P memory and do arch-specific things
> accordingly. There will also need to be flags that indicate whether a
> given IOMMU driver supports this. None of this work is done or easy.

I'm using that with the AMD IOMMU driver and at least there it works 
perfectly fine.

>> Yeah, but not for ours. See if you want to do real peer 2 peer you need
>> to keep both the operation as well as the direction into account.
> Not sure what you are saying here... I'm pretty sure we are doing "real"
> peer 2 peer...
>
>> For example when you can do writes between A and B that doesn't mean
>> that writes between B and A work. And reads are generally less likely to
>> work than writes. etc...
> If both devices are behind a switch then the PCI spec guarantees that A
> can both read and write B and vice versa.

Sorry to say that, but I know a whole bunch of PCI devices which 
horrible ignores that.

For example all AMD APUs fall under that category...

> Only once you involve root
> complexes do you have this problem. Ie. you have unknown support which
> may be no support, or partial support (stores but not loads); or
> sometimes bad performance; or a combination of both... and you need some
> way to figure out all this mess and that is hard. Whoever tries to
> implement a white list will have to sort all this out.

Yes, exactly and unfortunately it looks like I'm the poor guy who needs 
to do this :)

Regards,
Christian.

>
> Logan
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
