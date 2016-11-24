Return-path: <linux-media-owner@vger.kernel.org>
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dan Williams <dan.j.williams@intel.com>
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
 <20161123232503.GA13965@obsidianresearch.com>
 <a33ec1cd-051f-8a24-0587-68707459c25c@amd.com>
Cc: Serguei Sagalovitch <serguei.sagalovitch@amd.com>,
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
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <5e1de9ee-34f5-136d-a07e-f949d492864f@deltatee.com>
Date: Thu, 24 Nov 2016 10:55:39 -0700
MIME-Version: 1.0
In-Reply-To: <a33ec1cd-051f-8a24-0587-68707459c25c@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey,

On 24/11/16 02:45 AM, Christian K�nig wrote:
> E.g. it can happen that PCI device A exports it's BAR using ZONE_DEVICE.
> Not PCI device B (a SATA device) can directly read/write to it because
> it is on the same bus segment, but PCI device C (a network card for
> example) can't because it is on a different bus segment and the bridge
> can't handle P2P transactions.

Yeah, that could be an issue but in our experience we have yet to see
it. We've tested with two separate PCI buses on different CPUs connected
through QPI links and it works fine. (It is rather slow but I understand
Intel has improved the bottleneck in newer CPUs than the ones we tested.)

It may just be older hardware that has this issue. I expect that as long
as a failed transfer can be handled gracefully by the initiator I don't
see a need to predetermine whether a device can see another devices memory.


Logan
