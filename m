Return-path: <linux-media-owner@vger.kernel.org>
Date: Wed, 23 Nov 2016 12:32:28 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Cc: Logan Gunthorpe <logang@deltatee.com>,
        Dan Williams <dan.j.williams@intel.com>,
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
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161123193228.GC12146@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 23, 2016 at 02:14:40PM -0500, Serguei Sagalovitch wrote:
> 
> On 2016-11-23 02:05 PM, Jason Gunthorpe wrote:

> >As Bart says, it would be best to be combined with something like
> >Mellanox's ODP MRs, which allows a page to be evicted and then trigger
> >a CPU interrupt if a DMA is attempted so it can be brought back.

> Please note that in the general case (including  MR one) we could have
> "page fault" from the different PCIe device. So all  PCIe device must
> be synchronized.

Standard RDMA MRs require pinned pages, the DMA address cannot change
while the MR exists (there is no hardware support for this at all), so
page faulting from any other device is out of the question while they
exist. This is the same requirement as typical simple driver DMA which
requires pages pinned until the simple device completes DMA.

ODP RDMA MRs do not require that, they just page fault like the CPU or
really anything and the kernel has to make sense of concurrant page
faults from multiple sources.

The upshot is that GPU scenarios that rely on highly dynamic
virtual->physical translation cannot sanely be combined with standard
long-life RDMA MRs.

Certainly, any solution for GPUs must follow the typical page pinning
semantics, changing the DMA address of a page must be blocked while
any DMA is in progress.

> >Does HMM solve the peer-peer problem? Does it do it generically or
> >only for drivers that are mirroring translation tables?

> In current form HMM doesn't solve peer-peer problem. Currently it allow
> "mirroring" of  "malloc" memory on GPU which is not always what needed.
> Additionally  there is need to have opportunity to share VRAM allocations
> between  different processes.

Humm, so it can be removed from Alexander's list then :\

As Dan suggested, maybe we need to do both. Some kind of fix for
get_user_pages() for smaller mappings (eg ZONE_DEVICE) and a mandatory
API conversion to get_user_dma_sg() for other cases?

Jason
