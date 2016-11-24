Return-path: <linux-media-owner@vger.kernel.org>
Date: Thu, 24 Nov 2016 09:26:20 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Serguei Sagalovitch <serguei.sagalovitch@amd.com>,
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
Message-ID: <20161124162620.GC20818@obsidianresearch.com>
References: <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <CAPcyv4jVDC=8AbVa9v6LcXm9n8QHgizv_+gQJC4RTd-wtTESWQ@mail.gmail.com>
 <20161123232503.GA13965@obsidianresearch.com>
 <a33ec1cd-051f-8a24-0587-68707459c25c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a33ec1cd-051f-8a24-0587-68707459c25c@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 24, 2016 at 10:45:18AM +0100, Christian König wrote:
> Am 24.11.2016 um 00:25 schrieb Jason Gunthorpe:
> >There is certainly nothing about the hardware that cares
> >about ZONE_DEVICE vs System memory.
> Well that is clearly not so simple. When your ZONE_DEVICE pages describe a
> PCI BAR and another PCI device initiates a DMA to this address the DMA
> subsystem must be able to check if the interconnection really works.

I said the hardware doesn't care.. You are right, we still have an
outstanding problem in Linux of how to generically DMA map a P2P
address - which is a different issue from getting the P2P address from
a __user pointer...

Jason
