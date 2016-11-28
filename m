Return-path: <linux-media-owner@vger.kernel.org>
Date: Mon, 28 Nov 2016 09:57:51 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Haggai Eran <haggaie@mellanox.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Logan Gunthorpe <logang@deltatee.com>,
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
        "Sander, Ben" <ben.sander@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161128165751.GB28381@obsidianresearch.com>
References: <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <20161125193252.GC16504@obsidianresearch.com>
 <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 27, 2016 at 04:02:16PM +0200, Haggai Eran wrote:

> > Like in ODP, MMU notifiers/HMM are used to monitor for translation
> > changes. If a change comes in the GPU driver checks if an executing
> > command is touching those pages and blocks the MMU notifier until the
> > command flushes, then unfaults the page (blocking future commands) and
> > unblocks the mmu notifier.

> I think blocking mmu notifiers against something that is basically
> controlled by user-space can be problematic. This can block things like
> memory reclaim. If you have user-space access to the device's queues,
> user-space can block the mmu notifier forever.

Right, I mentioned that..

> On PeerDirect, we have some kind of a middle-ground solution for pinning
> GPU memory. We create a non-ODP MR pointing to VRAM but rely on
> user-space and the GPU not to migrate it. If they do, the MR gets
> destroyed immediately.

That sounds horrible. How can that possibly work? What if the MR is
being used when the GPU decides to migrate? I would not support that
upstream without a lot more explanation..

I know people don't like requiring new hardware, but in this case we
really do need ODP hardware to get all the semantics people want..

> Another thing I think is that while HMM is good for user-space
> applications, for kernel p2p use there is no need for that. Using

>From what I understand we are not really talking about kernel p2p,
everything proposed so far is being mediated by a userspace VMA, so
I'd focus on making that work.

Jason
