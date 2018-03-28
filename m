Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0083.outbound.protection.outlook.com ([104.47.40.83]:45639
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753024AbeC1S2n (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 14:28:43 -0400
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
To: Logan Gunthorpe <logang@deltatee.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-2-christian.koenig@amd.com>
 <20180328123830.GB25060@infradead.org>
 <613a6c91-7e72-5589-77e6-587ec973d553@gmail.com>
 <c81df70d-191d-bf8e-293a-413dd633e1fc@deltatee.com>
 <5498e9b5-8fe5-8999-a44e-f7dc483bc9ce@amd.com>
 <16c7bef8-5f03-9e89-1f50-b62fb139a36f@deltatee.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <6a5c9a10-50fe-b03d-dfc1-791d62d79f8e@amd.com>
Date: Wed, 28 Mar 2018 20:28:30 +0200
MIME-Version: 1.0
In-Reply-To: <16c7bef8-5f03-9e89-1f50-b62fb139a36f@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.03.2018 um 18:25 schrieb Logan Gunthorpe:
>
> On 28/03/18 10:02 AM, Christian König wrote:
>> Yeah, that looks very similar to what I picked up from the older
>> patches, going to read up on that after my vacation.
> Yeah, I was just reading through your patchset and there are a lot of
> similarities. Though, I'm not sure what you're trying to accomplish as I
> could not find a cover letter and it seems to only enable one driver.

Yeah, it was the last day before my easter vacation and I wanted it out 
of the door.

> Is it meant to enable DMA transactions only between two AMD GPUs?

Not really, DMA-buf is a general framework for sharing buffers between 
device drivers.

It is widely used in the GFX stack on laptops with both Intel+AMD, 
Intel+NVIDIA or AMD+AMD graphics devices.

Additional to that ARM uses it quite massively for their GFX stacks 
because they have rendering and displaying device separated.

I'm just using amdgpu as blueprint because I'm the co-maintainer of it 
and know it mostly inside out.

> I also don't see where you've taken into account the PCI bus address. On
> some architectures this is not the same as the CPU physical address.

The resource addresses are translated using dma_map_resource(). As far 
as I know that should be sufficient to offload all the architecture 
specific stuff to the DMA subsystem.

>
>> Just in general why are you interested in the "distance" of the devices?
> We've taken a general approach where some drivers may provide p2p memory
> (ie. an NVMe card or an RDMA NIC) and other drivers make use of it (ie.
> the NVMe-of driver). The orchestrator driver needs to find the most
> applicable provider device for a transaction in a situation that may
> have multiple providers and multiple clients. So the most applicable
> provider is the one that's closest ("distance"-wise) to all the clients
> for the P2P transaction.

That seems to make sense.

>
>> And BTW: At least for writes that Peer 2 Peer transactions between
>> different root complexes work is actually more common than the other way
>> around.
> Maybe on x86 with hardware made in the last few years. But on PowerPC,
> ARM64, and likely a lot more the chance of support is *much* less. Also,
> hardware that only supports P2P stores is hardly full support and is
> insufficient for our needs.

Yeah, but not for ours. See if you want to do real peer 2 peer you need 
to keep both the operation as well as the direction into account.

For example when you can do writes between A and B that doesn't mean 
that writes between B and A work. And reads are generally less likely to 
work than writes. etc...

Since the use case I'm targeting for is GFX or GFX+V4L (or GFX+NIC in 
the future) I really need to handle all such use cases as well.

>
>> So I'm a bit torn between using a blacklist or a whitelist. A whitelist
>> is certainly more conservative approach, but that could get a bit long.
> I think a whitelist approach is correct. Given old hardware and other
> architectures, a black list is going to be too long and too difficult to
> comprehensively populate.

Yeah, it would certainly be better if we have something in the root 
complex capabilities. But you're right that a whitelist sounds the less 
painful way.

Regards,
Christian.


>
> Logan
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
