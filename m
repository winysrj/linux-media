Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:41250 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757020AbeDBTck (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Apr 2018 15:32:40 -0400
To: Jerome Glisse <jglisse@redhat.com>
Cc: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>,
        Will Davis <wdavis@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
References: <70adc2cc-f7aa-d4b9-7d7a-71f3ae99f16c@gmail.com>
 <98ce6cfd-bcf3-811e-a0f1-757b60da467a@deltatee.com>
 <8d050848-8970-b8c4-a657-429fefd31769@amd.com>
 <d2de0c2e-4c2d-9e46-1c26-bfa40ca662ff@deltatee.com>
 <20180330015854.GA3572@redhat.com>
 <0234bc5e-495e-0f68-fb0a-debb17a35761@deltatee.com>
 <20180330194519.GC3198@redhat.com>
 <31266710-f6bb-99ee-c73d-6e58afe5c38c@deltatee.com>
 <20180402172027.GA18231@redhat.com>
 <6f796779-0ba3-d056-de33-341ee55d6b38@deltatee.com>
 <20180402191649.GB18231@redhat.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <4c672c71-6202-0775-7825-37f8077d1d35@deltatee.com>
Date: Mon, 2 Apr 2018 13:32:37 -0600
MIME-Version: 1.0
In-Reply-To: <20180402191649.GB18231@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/04/18 01:16 PM, Jerome Glisse wrote:
> There isn't good API at the moment AFAIK, closest thing would either be
> lookup_resource() or region_intersects(), but a more appropriate one can
> easily be added, code to walk down the tree is readily available. More-
> over this can be optimize like vma lookup are, even more as resource are
> seldomly added so read side (finding a resource) can be heavily favor
> over write side (adding|registering a new resource).

So someone needs to create a highly optimized tree that registers all
physical address on the system and maps them to devices? That seems a
long way from being realized. I'd hardly characterize that as "easily".
If we can pass both devices to the API I'd suspect it would be preferred
over the complicated tree. This, of course, depends on what users of the
API need.

> cache coherency protocol (bit further than PCIE snoop). But also the
> other direction the CPU access to device memory can also be cache coherent,
> which is not the case in PCIE.

I was not aware that CAPI allows PCI device memory to be cache coherent.
That sounds like it would be very tricky...

> Note that with mmu_notifier there isn't any need to pin stuff (even
> without any special hardware capabilities), as long as you can preempt
> what is happening on your hardware to update its page table.

I've been told there's a lot of dislike of the mmu_notifier interface.
And being able to preempt what's happening on hardware, generally, is
not trivial. But, yes, this is essentially how ODP works.

Logan
