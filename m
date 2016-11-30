Return-path: <linux-media-owner@vger.kernel.org>
Date: Wed, 30 Nov 2016 09:23:53 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Haggai Eran <haggaie@mellanox.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "Suravee.Suthikulpanit@amd.com" <Suravee.Suthikulpanit@amd.com>,
        "John.Bridgman@amd.com" <John.Bridgman@amd.com>,
        "Alexander.Deucher@amd.com" <Alexander.Deucher@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "logang@deltatee.com" <logang@deltatee.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "serguei.sagalovitch@amd.com" <serguei.sagalovitch@amd.com>,
        "Paul.Blinzer@amd.com" <Paul.Blinzer@amd.com>,
        "Felix.Kuehling@amd.com" <Felix.Kuehling@amd.com>,
        "ben.sander@amd.com" <ben.sander@amd.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161130162353.GA24639@obsidianresearch.com>
References: <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <20161125193252.GC16504@obsidianresearch.com>
 <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
 <20161128165751.GB28381@obsidianresearch.com>
 <1480357179.19407.13.camel@mellanox.com>
 <20161128190244.GA21975@obsidianresearch.com>
 <c0ddccf3-52ce-d883-a57a-70d8a1febf85@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0ddccf3-52ce-d883-a57a-70d8a1febf85@mellanox.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 30, 2016 at 12:45:58PM +0200, Haggai Eran wrote:

> > That just forces applications to handle horrible unexpected
> > failures. If this sort of thing is needed for correctness then OOM
> > kill the offending process, don't corrupt its operation.

> Yes, that sounds fine. Can we simply kill the process from the GPU driver?
> Or do we need to extend the OOM killer to manage GPU pages?

I don't know..

> >>> From what I understand we are not really talking about kernel p2p,
> >>> everything proposed so far is being mediated by a userspace VMA, so
> >>> I'd focus on making that work.
> > 
> >> Fair enough, although we will need both eventually, and I hope the
> >> infrastructure can be shared to some degree.
> > 
> > What use case do you see for in kernel?

> Two cases I can think of are RDMA access to an NVMe device's controller
> memory buffer,

I'm not sure on the use model there..

> and O_DIRECT operations that access GPU memory.

This goes through user space so there is still a VMA..

> Also, HMM's migration between two GPUs could use peer to peer in the
> kernel, although that is intended to be handled by the GPU driver if
> I understand correctly.

Hum, presumably these migrations are VMA backed as well...

> > Presumably in-kernel could use a vmap or something and the same basic
> > flow?
> I think we can achieve the kernel's needs with ZONE_DEVICE and DMA-API support
> for peer to peer. I'm not sure we need vmap. We need a way to have a scatterlist
> of MMIO pfns, and ZONE_DEVICE allows that.

Well, if there is no virtual map then we are back to how do you do
migrations and other things people seem to want to do on these
pages. Maybe the loose 'struct page' flow is not for those users.

But I think if you want kGPU or similar then you probably need vmaps
or something similar to represent the GPU pages in kernel memory.

Jason
