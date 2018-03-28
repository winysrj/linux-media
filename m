Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:39600 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752907AbeC1QZp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 12:25:45 -0400
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-2-christian.koenig@amd.com>
 <20180328123830.GB25060@infradead.org>
 <613a6c91-7e72-5589-77e6-587ec973d553@gmail.com>
 <c81df70d-191d-bf8e-293a-413dd633e1fc@deltatee.com>
 <5498e9b5-8fe5-8999-a44e-f7dc483bc9ce@amd.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <16c7bef8-5f03-9e89-1f50-b62fb139a36f@deltatee.com>
Date: Wed, 28 Mar 2018 10:25:43 -0600
MIME-Version: 1.0
In-Reply-To: <5498e9b5-8fe5-8999-a44e-f7dc483bc9ce@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 28/03/18 10:02 AM, Christian König wrote:
> Yeah, that looks very similar to what I picked up from the older 
> patches, going to read up on that after my vacation.

Yeah, I was just reading through your patchset and there are a lot of
similarities. Though, I'm not sure what you're trying to accomplish as I
could not find a cover letter and it seems to only enable one driver. Is
it meant to enable DMA transactions only between two AMD GPUs?

I also don't see where you've taken into account the PCI bus address. On
some architectures this is not the same as the CPU physical address.

> Just in general why are you interested in the "distance" of the devices?

We've taken a general approach where some drivers may provide p2p memory
(ie. an NVMe card or an RDMA NIC) and other drivers make use of it (ie.
the NVMe-of driver). The orchestrator driver needs to find the most
applicable provider device for a transaction in a situation that may
have multiple providers and multiple clients. So the most applicable
provider is the one that's closest ("distance"-wise) to all the clients
for the P2P transaction.

> And BTW: At least for writes that Peer 2 Peer transactions between 
> different root complexes work is actually more common than the other way 
> around.

Maybe on x86 with hardware made in the last few years. But on PowerPC,
ARM64, and likely a lot more the chance of support is *much* less. Also,
hardware that only supports P2P stores is hardly full support and is
insufficient for our needs.

> So I'm a bit torn between using a blacklist or a whitelist. A whitelist 
> is certainly more conservative approach, but that could get a bit long.

I think a whitelist approach is correct. Given old hardware and other
architectures, a black list is going to be too long and too difficult to
comprehensively populate.

Logan
