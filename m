Return-path: <linux-media-owner@vger.kernel.org>
Date: Fri, 25 Nov 2016 13:19:39 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Logan Gunthorpe <logang@deltatee.com>,
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
        Haggai Eran <haggaie@mellanox.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161125201939.GJ16504@obsidianresearch.com>
References: <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <7ff3cf70-b0c3-028e-fea8-c370a1185b65@amd.com>
 <20161125193410.GD16504@obsidianresearch.com>
 <80aae3e6-278e-49af-7d09-bea87ffd19e8@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80aae3e6-278e-49af-7d09-bea87ffd19e8@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 25, 2016 at 02:49:50PM -0500, Serguei Sagalovitch wrote:

> GPU could perfectly access all VRAM.  It is only issue for p2p without
> special interconnect and CPU access. Strictly speaking as long as we
> have "bus address"  we could have RDMA but  I agreed that for
> RDMA we could/should(?) always "request"  CPU address (I hope that we
> could forget about 32-bit application :-)).

At least on x86 if you have a bus address you have a CPU address. All
RDMAable VRAM has to be visible in the BAR.

> BTW/FYI: About CPU access: Some user-level API is mainly handle based
> so there is no need for CPU access by default.

You mean no need for the memory to be virtually mapped into the
process?

Do you expect to RDMA from this kind of API? How will that work?

Jason
