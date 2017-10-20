Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>,
        "'linux-nvdimm@lists.01.org'" <linux-nvdimm@lists.01.org>,
        "'Linux-media@vger.kernel.org'" <Linux-media@vger.kernel.org>,
        "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>,
        "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>
Cc: "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
From: Ludwig Petrosyan <ludwig.petrosyan@desy.de>
Message-ID: <7f5e0303-f4ea-781a-8dec-74b30990d54f@desy.de>
Date: Fri, 20 Oct 2017 14:36:07 +0200
MIME-Version: 1.0
In-Reply-To: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Linux kernel group

my name is Ludwig Petrosyan I am working in DESY (Germany)

we are responsible for the control system of  all accelerators in DESY.

For a 7-8 years we have switched to MTCA.4 systems and using PCIe as a 
central Bus.

I am mostly responsible for the Linux drivers of the AMC Cards (PCIe 
endpoints).

The idea is start to use peer to peer transaction for PCIe endpoint (DMA 
and/or usual Read/Write)

Could You please advise me where to start, is there some Documentation 
how to do it.


with best regards


Ludwig


On 11/21/2016 09:36 PM, Deucher, Alexander wrote:
> This is certainly not the first time this has been brought up, but I'd like to try and get some consensus on the best way to move this forward.  Allowing devices to talk directly improves performance and reduces latency by avoiding the use of staging buffers in system memory.  Also in cases where both devices are behind a switch, it avoids the CPU entirely.  Most current APIs (DirectGMA, PeerDirect, CUDA, HSA) that deal with this are pointer based.  Ideally we'd be able to take a CPU virtual address and be able to get to a physical address taking into account IOMMUs, etc.  Having struct pages for the memory would allow it to work more generally and wouldn't require as much explicit support in drivers that wanted to use it.
>   
> Some use cases:
> 1. Storage devices streaming directly to GPU device memory
> 2. GPU device memory to GPU device memory streaming
> 3. DVB/V4L/SDI devices streaming directly to GPU device memory
> 4. DVB/V4L/SDI devices streaming directly to storage devices
>   
> Here is a relatively simple example of how this could work for testing.  This is obviously not a complete solution.
> - Device memory will be registered with Linux memory sub-system by created corresponding struct page structures for device memory
> - get_user_pages_fast() will  return corresponding struct pages when CPU address points to the device memory
> - put_page() will deal with struct pages for device memory
>   
> Previously proposed solutions and related proposals:
> 1.P2P DMA
> DMA-API/PCI map_peer_resource support for peer-to-peer (http://www.spinics.net/lists/linux-pci/msg44560.html)
> Pros: Low impact, already largely reviewed.
> Cons: requires explicit support in all drivers that want to support it, doesn't handle S/G in device memory.
>   
> 2. ZONE_DEVICE IO
> Direct I/O and DMA for persistent memory (https://lwn.net/Articles/672457/)
> Add support for ZONE_DEVICE IO memory with struct pages. (https://patchwork.kernel.org/patch/8583221/)
> Pro: Doesn't waste system memory for ZONE metadata
> Cons: CPU access to ZONE metadata slow, may be lost, corrupted on device reset.
>   
> 3. DMA-BUF
> RDMA subsystem DMA-BUF support (http://www.spinics.net/lists/linux-rdma/msg38748.html)
> Pros: uses existing dma-buf interface
> Cons: dma-buf is handle based, requires explicit dma-buf support in drivers.
>
> 4. iopmem
> iopmem : A block device for PCIe memory (https://lwn.net/Articles/703895/)
>   
> 5. HMM
> Heterogeneous Memory Management (http://lkml.iu.edu/hypermail/linux/kernel/1611.2/02473.html)
>
> 6. Some new mmap-like interface that takes a userptr and a length and returns a dma-buf and offset?
>   
> Alex
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
