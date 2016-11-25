Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
References: <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <7ff3cf70-b0c3-028e-fea8-c370a1185b65@amd.com>
 <20161125193410.GD16504@obsidianresearch.com>
CC: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
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
From: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Message-ID: <80aae3e6-278e-49af-7d09-bea87ffd19e8@amd.com>
Date: Fri, 25 Nov 2016 14:49:50 -0500
MIME-Version: 1.0
In-Reply-To: <20161125193410.GD16504@obsidianresearch.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-11-25 02:34 PM, Jason Gunthorpe wrote:
> On Fri, Nov 25, 2016 at 12:16:30PM -0500, Serguei Sagalovitch wrote:
>
>> b) Allocation may not  have CPU address  at all - only GPU one.
> But you don't expect RDMA to work in the case, right?
>
> GPU people need to stop doing this windowed memory stuff :)
GPU could perfectly access all VRAM.  It is only issue for p2p without
special interconnect and CPU access. Strictly speaking as long as we
have "bus address"  we could have RDMA but  I agreed that for
RDMA we could/should(?) always "request"  CPU address (I hope that we
could forget about 32-bit application :-)).

BTW/FYI: About CPU access: Some user-level API is mainly handle based
so there is no need for CPU access by default.

About "visible" / non-visible VRAM parts: I assume  that going
forward we will be able to get rid from it completely as soon as support
for resizable PCI BAR will be implemented and/or old/current h/w
will become obsolete.
