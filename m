Return-path: <linux-media-owner@vger.kernel.org>
Date: Wed, 23 Nov 2016 16:25:03 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Dan Williams <dan.j.williams@intel.com>
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
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161123232503.GA13965@obsidianresearch.com>
References: <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <CAPcyv4jVDC=8AbVa9v6LcXm9n8QHgizv_+gQJC4RTd-wtTESWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jVDC=8AbVa9v6LcXm9n8QHgizv_+gQJC4RTd-wtTESWQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 23, 2016 at 02:42:12PM -0800, Dan Williams wrote:
> > The crucial part for this discussion is the ability to fence and block
> > DMA for a specific range. This is the hardware capability that lets
> > page migration happen: fence&block DMA, migrate page, update page
> > table in HCA, unblock DMA.
> 
> Wait, ODP requires migratable pages, ZONE_DEVICE pages are not
> migratable.

Does it? I didn't think so.. Does ZONE_DEVICE break MMU notifiers/etc
or something? There is certainly nothing about the hardware that cares
about ZONE_DEVICE vs System memory.

I used 'migration' in the broader sense of doing any transformation to
the page such that the DMA address changes - not the specific kernel
MM process...

> You can't replace a PCIe mapping with just any other System RAM
> physical address, right?

I thought that was exactly what HMM was trying to do? Migrate pages
between CPU and GPU memory as needed. As Serguei has said this process
needs to be driven by the GPU driver.

The peer-peer issue is how do you do that while RDMA is possible on
those pages, because when the page migrates to GPU memory you want the
RDMA to follow it seamlessly.

This is why page table mirroring is the best solution - use the
existing mm machinery to link the DMA driver and whatever is
controlling the VMA.

> At least not without a filesystem recording where things went, but
> at point we're no longer talking about the base P2P-DMA mapping

In the filesystem/DAX case, it would be the filesystem that initiates
any change in the page physical address.

ODP *follows* changes in the VMA it does not cause any change in
address mapping. That has to be done by whoever is in charge of the
VMA.

> something like pnfs-rdma to a DAX filesystem.

Something in the kernel (ie nfs-rdma) would be entirely different. We
generally don't do long lived mappings in the kernel for RDMA
(certainly not for NFS), so it is much more like your basic every day
DMA operation: map, execute, unmap. We probably don't need to use page
table mirroring for this.

ODP comes in when userpsace mmaps a DAX file and then tries to use it
for RDMA. Page table mirroring lets the DAX filesystem decide to move
the backing pages at any time. When it wants to do that it interacts
with the MM in the usual way which links to ODP and makes sure the
migration is seamless.

Jason
