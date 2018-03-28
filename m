Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:40952 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753225AbeC1Tx3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 15:53:29 -0400
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
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
 <73578b4e-664b-141c-3e1f-e1fae1e4db07@amd.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <1b08c13e-b4a2-08f2-6194-93e6c21b7965@deltatee.com>
Date: Wed, 28 Mar 2018 13:53:25 -0600
MIME-Version: 1.0
In-Reply-To: <73578b4e-664b-141c-3e1f-e1fae1e4db07@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 28/03/18 01:44 PM, Christian König wrote:
> Well, isn't that exactly what dma_map_resource() is good for? As far as 
> I can see it makes sure IOMMU is aware of the access route and 
> translates a CPU address into a PCI Bus address.

> I'm using that with the AMD IOMMU driver and at least there it works 
> perfectly fine.

Yes, it would be nice, but no arch has implemented this yet. We are just
lucky in the x86 case because that arch is simple and doesn't need to do
anything for P2P (partially due to the Bus and CPU addresses being the
same). But in the general case, you can't rely on it.

>>> Yeah, but not for ours. See if you want to do real peer 2 peer you need
>>> to keep both the operation as well as the direction into account.
>> Not sure what you are saying here... I'm pretty sure we are doing "real"
>> peer 2 peer...
>>
>>> For example when you can do writes between A and B that doesn't mean
>>> that writes between B and A work. And reads are generally less likely to
>>> work than writes. etc...
>> If both devices are behind a switch then the PCI spec guarantees that A
>> can both read and write B and vice versa.
> 
> Sorry to say that, but I know a whole bunch of PCI devices which 
> horrible ignores that.

Can you elaborate? As far as the device is concerned it shouldn't know
whether a request comes from a peer or from the host. If it does do
crazy stuff like that it's well out of spec. It's up to the switch (or
root complex if good support exists) to route the request to the device
and it's the root complex that tends to be what drops the load requests
which causes the asymmetries.

Logan
