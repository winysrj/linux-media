Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Logan Gunthorpe <logang@deltatee.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
References: <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <9cc22068-ede8-c1bc-5d8b-cf6224a7ce05@deltatee.com>
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
Message-ID: <3d92687e-e327-0474-2b3b-4c3301b2c57c@amd.com>
Date: Fri, 25 Nov 2016 12:59:07 -0500
MIME-Version: 1.0
In-Reply-To: <9cc22068-ede8-c1bc-5d8b-cf6224a7ce05@deltatee.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Well, I guess there's some consensus building to do. The existing
> options are:
>
> * Device DAX: which could work but the problem I see with it is that it
> only allows one application to do these transfers. Or there would have
> to be some user-space coordination to figure which application gets what
> memeroy.
About one application restriction: so it is per memory mapping? I assume 
that
it should not be problem for one application to do transfer to the 
several devices
simultaneously? Am I right?

May be we should follow RDMA MR design and register memory for p2p 
transfer from user
space?

What about the following:

a)  Device DAX is created
b) "Normal" (movable, etc.) allocation will be done for PCIe memory and 
CPU pointer/access will
be requested.
c)  p2p_mr_register() will be called and CPU pointer (mmap( on DAX 
Device)) will be returned.
Accordingly such memory will be marked as "unmovable" by e.g. graphics 
driver.
d) When p2p is not needed then p2p_mr_unregister() will be called.

What do you think? Will it work?


