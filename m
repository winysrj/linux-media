Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Logan Gunthorpe <logang@deltatee.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
CC: Dan Williams <dan.j.williams@intel.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>,
        Haggai Eran <haggaie@mellanox.com>
From: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Message-ID: <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
Date: Wed, 23 Nov 2016 14:14:40 -0500
MIME-Version: 1.0
In-Reply-To: <20161123190515.GA12146@obsidianresearch.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 2016-11-23 02:05 PM, Jason Gunthorpe wrote:
> On Wed, Nov 23, 2016 at 10:13:03AM -0700, Logan Gunthorpe wrote:
>
>> an MR would be very tricky. The MR may be relied upon by another host
>> and the kernel would have to inform user-space the MR was invalid then
>> user-space would have to tell the remote application.
> As Bart says, it would be best to be combined with something like
> Mellanox's ODP MRs, which allows a page to be evicted and then trigger
> a CPU interrupt if a DMA is attempted so it can be brought back.
Please note that in the general case (including  MR one) we could have
"page fault" from the different PCIe device. So all  PCIe device must
be synchronized.
> includes the usual fencing mechanism so the CPU can block, flush, and
> then evict a page coherently.
>
> This is the general direction the industry is going in: Link PCI DMA
> directly to dynamic user page tabels, including support for demand
> faulting and synchronicity.
>
> Mellanox ODP is a rough implementation of mirroring a process's page
> table via the kernel, while IBM's CAPI (and CCIX, PCI ATS?) is
> probably a good example of where this is ultimately headed.
>
> CAPI allows a PCI DMA to directly target an ASID associated with a
> user process and then use the usual CPU machinery to do the page
> translation for the DMA. This includes page faults for evicted pages,
> and obviously allows eviction and migration..
>
> So, of all the solutions in the original list, I would discard
> anything that isn't VMA focused. Emulating what CAPI does in hardware
> with software is probably the best choice, or we have to do it all
> again when CAPI style hardware broadly rolls out :(
>
> DAX and GPU allocators should create VMAs and manipulate them in the
> usual way to achieve migration, windowing, cache&mirror, movement or
> swap of the potentially peer-peer memory pages. They would have to
> respect the usual rules for a VMA, including pinning.
>
> DMA drivers would use the usual approaches for dealing with DMA from
> a VMA: short term pin or long term coherent translation mirror.
>
> So, to my view (looking from RDMA), the main problem with peer-peer is
> how do you DMA translate VMA's that point at non struct page memory?
>
> Does HMM solve the peer-peer problem? Does it do it generically or
> only for drivers that are mirroring translation tables?
In current form HMM doesn't solve peer-peer problem. Currently it allow
"mirroring" of  "malloc" memory on GPU which is not always what needed.
Additionally  there is need to have opportunity to share VRAM allocations
between  different processes.
>  From a RDMA perspective we could use something other than
> get_user_pages() to pin and DMA translate a VMA if the core community
> could decide on an API. eg get_user_dma_sg() would probably be quite
> usable.
>
> Jason

