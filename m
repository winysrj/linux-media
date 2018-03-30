Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751906AbeC3B67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 21:58:59 -0400
Date: Thu, 29 Mar 2018 21:58:54 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Message-ID: <20180330015854.GA3572@redhat.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d2de0c2e-4c2d-9e46-1c26-bfa40ca662ff@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 29, 2018 at 10:25:52AM -0600, Logan Gunthorpe wrote:
> 
> 
> On 29/03/18 10:10 AM, Christian König wrote:
> > Why not? I mean the dma_map_resource() function is for P2P while other 
> > dma_map_* functions are only for system memory.
> 
> Oh, hmm, I wasn't aware dma_map_resource was exclusively for mapping
> P2P. Though it's a bit odd seeing we've been working under the
> assumption that PCI P2P is different as it has to translate the PCI bus
> address. Where as P2P for devices on other buses is a big unknown.

dma_map_resource() is the right API (thought its current implementation
is fill with x86 assumptions). So i would argue that arch can decide to
implement it or simply return dma error address which trigger fallback
path into the caller (at least for GPU drivers). SG variant can be added
on top.

dma_map_resource() is the right API because it has all the necessary
informations. It use the CPU physical address as the common address
"language" with CPU physical address of PCIE bar to map to another
device you can find the corresponding bus address from the IOMMU code
(NOP on x86). So dma_map_resource() knows both the source device which
export its PCIE bar and the destination devices.


So i don't think Christian need to base his patchset on yours. This
is orthogonal. Christian is using existing upstream API, if it is
broken on some arch it is up to those arch to fix it, or return error
if it is not fixable. In fact i would assume that you would need to
base your patchset on top of dma_map_resource() too ...

Moreover i doubt Christian want to have struct page for this. For
nouveau there will be HMM struct page and this would conflict.

AFAICT you need struct page because the API you are trying to expose
to user space rely on "regular" filesystem/RDMA umem API which all
assume struct page. GPU drivers do not have this requirement and it
should not be impose on them.


So from my point of view Christian patchset is good as it is. Modulo
better commit message.


Bottom line i think we need common PCIE helper for P2P and the current
dma_map_resource() is the right kind from POV. What you are doing with
struct page is specific to your sub-system and should not be impose on
others.

Cheers,
Jérôme
