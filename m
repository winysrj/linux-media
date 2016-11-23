Return-path: <linux-media-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20161123215510.GA16311@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com> <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com> <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com> <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com> <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Nov 2016 14:42:12 -0800
Message-ID: <CAPcyv4jVDC=8AbVa9v6LcXm9n8QHgizv_+gQJC4RTd-wtTESWQ@mail.gmail.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Logan Gunthorpe <logang@deltatee.com>,
        Serguei Sagalovitch <serguei.sagalovitch@amd.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 23, 2016 at 1:55 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Wed, Nov 23, 2016 at 02:11:29PM -0700, Logan Gunthorpe wrote:
>> > As I said, there is no possible special handling. Standard IB hardware
>> > does not support changing the DMA address once a MR is created. Forget
>> > about doing that.
>>
>> Yeah, that's essentially the point I was trying to make. Not to mention
>> all the other unrelated hardware that can't DMA to an address that might
>> disappear mid-transfer.
>
> Right, it is impossible to ask for generic page migration with ongoing
> DMA. That is simply not supported by any of the hardware at all.
>
>> > Only ODP hardware allows changing the DMA address on the fly, and it
>> > works at the page table level. We do not need special handling for
>> > RDMA.
>>
>> I am aware of ODP but, noted by others, it doesn't provide a general
>> solution to the points above.
>
> How do you mean?
>
> Perhaps I am not following what Serguei is asking for, but I
> understood the desire was for a complex GPU allocator that could
> migrate pages between GPU and CPU memory under control of the GPU
> driver, among other things. The desire is for DMA to continue to work
> even after these migrations happen.
>
> Page table mirroring *is* the general solution for this problem. The
> GPU driver controls the VMA and the DMA driver mirrors that VMA.
>
> Do you know of another option that doesn't just degenerate to page
> table mirroring??
>
> Remember, there are two facets to the RDMA ODP implementation, I feel
> there is some confusion here..
>
> The crucial part for this discussion is the ability to fence and block
> DMA for a specific range. This is the hardware capability that lets
> page migration happen: fence&block DMA, migrate page, update page
> table in HCA, unblock DMA.

Wait, ODP requires migratable pages, ZONE_DEVICE pages are not
migratable. You can't replace a PCIe mapping with just any other
System RAM physical address, right? At least not without a filesystem
recording where things went, but at point we're no longer talking
about the base P2P-DMA mapping mechanism and are instead talking about
something like pnfs-rdma to a DAX filesystem.
