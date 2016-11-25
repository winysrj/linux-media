Return-path: <linux-media-owner@vger.kernel.org>
Date: Fri, 25 Nov 2016 12:41:33 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Logan Gunthorpe <logang@deltatee.com>,
        Serguei Sagalovitch <serguei.sagalovitch@amd.com>,
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
Message-ID: <20161125194133.GF16504@obsidianresearch.com>
References: <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <9cc22068-ede8-c1bc-5d8b-cf6224a7ce05@deltatee.com>
 <20161125075817.GA18428@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161125075817.GA18428@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 24, 2016 at 11:58:17PM -0800, Christoph Hellwig wrote:
> On Thu, Nov 24, 2016 at 11:11:34AM -0700, Logan Gunthorpe wrote:
> > * Regular DAX in the FS doesn't work at this time because the FS can
> > move the file you think your transfer to out from under you. Though I
> > understand there's been some work with XFS to solve that issue.
> 
> The file system will never move anything under locked down pages,
> locking down pages is used exactly to protect against that.

.. And ODP style mmu notifiers work correctly as well, I'd assume.

So this should work with ZONE_DEVICE, if it doesn't it is a filesystem
bug?

> really want a notification to the consumer if the file systems wants
> to remove the mapping.  We have implemented that using FL_LAYOUTS locks
> for NFSD, but only XFS supports it so far.  Without that a long term
> locked down region of memory (e.g. a kernel MR) would prevent various
> file operations that would simply hang.

So you imagine a signal back to user space asking user space to drop
any RDMA MRS so the FS can relocate things?

Do we need that, or should we encourage people to use either short
lived MRs or ODP MRs when working with scenarios that need FS
relocation?

Jason
