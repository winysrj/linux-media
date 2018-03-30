Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34000 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbeC3Gdn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Mar 2018 02:33:43 -0400
Date: Thu, 29 Mar 2018 23:33:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jerome Glisse <jglisse@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Message-ID: <20180330063334.GA8634@infradead.org>
References: <16c7bef8-5f03-9e89-1f50-b62fb139a36f@deltatee.com>
 <6a5c9a10-50fe-b03d-dfc1-791d62d79f8e@amd.com>
 <e751cd28-f115-569f-5248-d24f30dee3cb@deltatee.com>
 <73578b4e-664b-141c-3e1f-e1fae1e4db07@amd.com>
 <1b08c13e-b4a2-08f2-6194-93e6c21b7965@deltatee.com>
 <70adc2cc-f7aa-d4b9-7d7a-71f3ae99f16c@gmail.com>
 <98ce6cfd-bcf3-811e-a0f1-757b60da467a@deltatee.com>
 <8d050848-8970-b8c4-a657-429fefd31769@amd.com>
 <d2de0c2e-4c2d-9e46-1c26-bfa40ca662ff@deltatee.com>
 <20180330015854.GA3572@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180330015854.GA3572@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 29, 2018 at 09:58:54PM -0400, Jerome Glisse wrote:
> dma_map_resource() is the right API (thought its current implementation
> is fill with x86 assumptions). So i would argue that arch can decide to
> implement it or simply return dma error address which trigger fallback
> path into the caller (at least for GPU drivers). SG variant can be added
> on top.

It isn't in general.  It doesn't integrate with scatterlists (see my
comment to page one), and it doesn't integrate with all the subsystems
that also need a kernel virtual address.
