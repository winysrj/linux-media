Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Logan Gunthorpe <logang@deltatee.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
References: <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <20161125193252.GC16504@obsidianresearch.com>
 <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
 <20161128165751.GB28381@obsidianresearch.com>
 <1480357179.19407.13.camel@mellanox.com>
 <20161128190244.GA21975@obsidianresearch.com>
 <c0ddccf3-52ce-d883-a57a-70d8a1febf85@mellanox.com>
 <20161130162353.GA24639@obsidianresearch.com>
 <5f5b7989-84f5-737e-47c8-831f752d6280@deltatee.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "Suravee.Suthikulpanit@amd.com" <Suravee.Suthikulpanit@amd.com>,
        "John.Bridgman@amd.com" <John.Bridgman@amd.com>,
        "Alexander.Deucher@amd.com" <Alexander.Deucher@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "serguei.sagalovitch@amd.com" <serguei.sagalovitch@amd.com>,
        "Paul.Blinzer@amd.com" <Paul.Blinzer@amd.com>,
        "Felix.Kuehling@amd.com" <Felix.Kuehling@amd.com>,
        "ben.sander@amd.com" <ben.sander@amd.com>
From: Haggai Eran <haggaie@mellanox.com>
Message-ID: <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com>
Date: Sun, 4 Dec 2016 09:42:22 +0200
MIME-Version: 1.0
In-Reply-To: <5f5b7989-84f5-737e-47c8-831f752d6280@deltatee.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/30/2016 8:01 PM, Logan Gunthorpe wrote:
> 
> 
> On 30/11/16 09:23 AM, Jason Gunthorpe wrote:
>>> Two cases I can think of are RDMA access to an NVMe device's controller
>>> memory buffer,
>>
>> I'm not sure on the use model there..
> 
> The NVMe fabrics stuff could probably make use of this. It's an
> in-kernel system to allow remote access to an NVMe device over RDMA. So
> they ought to be able to optimize their transfers by DMAing directly to
> the NVMe's CMB -- no userspace interface would be required but there
> would need some kernel infrastructure.

Yes, that's what I was thinking. The NVMe/f driver needs to map the CMB for
RDMA. I guess if it used ZONE_DEVICE like in the iopmem patches it would be
relatively easy to do.

