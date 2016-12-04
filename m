Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Serguei Sagalovitch <serguei.sagalovitch@amd.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
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
 <2560aab2-426c-6e58-cb4f-77ec76e0c941@amd.com>
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
        "Paul.Blinzer@amd.com" <Paul.Blinzer@amd.com>,
        "Felix.Kuehling@amd.com" <Felix.Kuehling@amd.com>,
        "ben.sander@amd.com" <ben.sander@amd.com>
From: Haggai Eran <haggaie@mellanox.com>
Message-ID: <f0d4652f-291e-a700-c2ef-8134d8d21e51@mellanox.com>
Date: Sun, 4 Dec 2016 09:33:09 +0200
MIME-Version: 1.0
In-Reply-To: <2560aab2-426c-6e58-cb4f-77ec76e0c941@amd.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/30/2016 7:28 PM, Serguei Sagalovitch wrote:
> On 2016-11-30 11:23 AM, Jason Gunthorpe wrote:
>>> Yes, that sounds fine. Can we simply kill the process from the GPU driver?
>>> Or do we need to extend the OOM killer to manage GPU pages?
>> I don't know..
> We could use send_sig_info to send signal from  kernel  to user space. So theoretically GPU driver
> could issue KILL signal to some process.
> 
>> On Wed, Nov 30, 2016 at 12:45:58PM +0200, Haggai Eran wrote:
>>> I think we can achieve the kernel's needs with ZONE_DEVICE and DMA-API support
>>> for peer to peer. I'm not sure we need vmap. We need a way to have a scatterlist
>>> of MMIO pfns, and ZONE_DEVICE allows that.
> I do not think that using DMA-API as it is is the best solution (at least in the current form):
> 
> -  It deals with handles/fd for the whole allocation but client could/will use sub-allocation as
> well as theoretically possible to "merge" several allocations in one from GPU perspective.
> -  It require knowledge to export but because "sharing" is controlled from user space it
> means that we must "export" all allocation by default
> - It deals with 'fd'/handles but user application may work with addresses/pointers.

Aren't you confusing DMABUF and DMA-API? DMA-API is how you program the IOMMU (dma_map_page/dma_map_sg/etc.).
The comment above is just about the need to extend this API to allow mapping peer device pages to bus addresses.

In the past I sent an RFC for using DMABUF for peer to peer. I think it had some
advantages for legacy devices. I agree that working with addresses and pointers through
something like HMM/ODP is much more flexible and easier to program from user-space.
For legacy, DMABUF would have allowed you a way to pin the pages so the GPU knows not to
move them. However, that can probably also be achieved simply via the reference count
on ZONE_DEVICE pages. The other nice thing about DMABUF is that it migrate the buffer
itself during attachment according to the requirements of the device that is attaching,
so you can automatically decide in the exporter whether to use p2p or a staging buffer.

> 
> Also current  DMA-API force each time to do all DMA table programming unrelated if
> location was changed or not. With  vma / mmu  we are  able to install notifier to intercept
> changes in location and update  translation tables only as needed (we do not need to keep
> get_user_pages()  lock).
I agree.
