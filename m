Return-path: <linux-media-owner@vger.kernel.org>
Date: Mon, 28 Nov 2016 12:02:44 -0700
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
Message-ID: <20161128190244.GA21975@obsidianresearch.com>
References: <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <20161125193252.GC16504@obsidianresearch.com>
 <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
 <20161128165751.GB28381@obsidianresearch.com>
 <1480357179.19407.13.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1480357179.19407.13.camel@mellanox.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 28, 2016 at 06:19:40PM +0000, Haggai Eran wrote:
> > > GPU memory. We create a non-ODP MR pointing to VRAM but rely on
> > > user-space and the GPU not to migrate it. If they do, the MR gets
> > > destroyed immediately.
> > That sounds horrible. How can that possibly work? What if the MR is
> > being used when the GPU decides to migrate? 
> Naturally this doesn't support migration. The GPU is expected to pin
> these pages as long as the MR lives. The MR invalidation is done only as
> a last resort to keep system correctness.

That just forces applications to handle horrible unexpected
failures. If this sort of thing is needed for correctness then OOM
kill the offending process, don't corrupt its operation.

> I think it is similar to how non-ODP MRs rely on user-space today to
> keep them correct. If you do something like madvise(MADV_DONTNEED) on a
> non-ODP MR's pages, you can still get yourself into a data corruption
> situation (HCA sees one page and the process sees another for the same
> virtual address). The pinning that we use only guarentees the HCA's page
> won't be reused.

That is not really data corruption - the data still goes where it was
originally destined. That is an application violating the
requirements of a MR. An application cannot munmap/mremap a VMA
while a non ODP MR points to it and then keep using the MR.

That is totally different from a GPU driver wanthing to mess with
translation to physical pages.

> > From what I understand we are not really talking about kernel p2p,
> > everything proposed so far is being mediated by a userspace VMA, so
> > I'd focus on making that work.

> Fair enough, although we will need both eventually, and I hope the
> infrastructure can be shared to some degree.

What use case do you see for in kernel?

Presumably in-kernel could use a vmap or something and the same basic
flow?

Jason
