Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
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
 <20161130162353.GA24639@obsidianresearch.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        "Max Gurtovoy" <maxg@mellanox.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "serguei.sagalovitch@amd.com" <serguei.sagalovitch@amd.com>,
        "Paul.Blinzer@amd.com" <Paul.Blinzer@amd.com>,
        "Felix.Kuehling@amd.com" <Felix.Kuehling@amd.com>,
        "ben.sander@amd.com" <ben.sander@amd.com>
From: Haggai Eran <haggaie@mellanox.com>
Message-ID: <3781848f-d4a0-69d3-678d-c5623bac3c10@mellanox.com>
Date: Sun, 4 Dec 2016 09:53:26 +0200
MIME-Version: 1.0
In-Reply-To: <20161130162353.GA24639@obsidianresearch.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/30/2016 6:23 PM, Jason Gunthorpe wrote:
>> and O_DIRECT operations that access GPU memory.
> This goes through user space so there is still a VMA..
> 
>> Also, HMM's migration between two GPUs could use peer to peer in the
>> kernel, although that is intended to be handled by the GPU driver if
>> I understand correctly.
> Hum, presumably these migrations are VMA backed as well...
I guess so.

>>> Presumably in-kernel could use a vmap or something and the same basic
>>> flow?
>> I think we can achieve the kernel's needs with ZONE_DEVICE and DMA-API support
>> for peer to peer. I'm not sure we need vmap. We need a way to have a scatterlist
>> of MMIO pfns, and ZONE_DEVICE allows that.
> Well, if there is no virtual map then we are back to how do you do
> migrations and other things people seem to want to do on these
> pages. Maybe the loose 'struct page' flow is not for those users.
I was thinking that kernel use cases would disallow migration, similar to how 
non-ODP MRs would work. Either they are short-lived (like an O_DIRECT transfer)
or they can be longed lived but non-migratable (like perhaps a CMB staging buffer).

> But I think if you want kGPU or similar then you probably need vmaps
> or something similar to represent the GPU pages in kernel memory.
Right, although sometimes the GPU pages are simply inaccessible to the CPU.
In any case, I haven't thought about kGPU as a use-case.
