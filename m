Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
References: <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <20161125193252.GC16504@obsidianresearch.com>
 <a98185d9-ffb1-6469-4272-2d1222600825@vodafone.de>
CC: Haggai Eran <haggaie@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        Serguei Sagalovitch <serguei.sagalovitch@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "Sander, Ben" <ben.sander@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
From: Felix Kuehling <felix.kuehling@amd.com>
Message-ID: <e3c2640a-5dd9-7527-7db8-9b3219bb7625@amd.com>
Date: Fri, 25 Nov 2016 15:51:15 -0500
MIME-Version: 1.0
In-Reply-To: <a98185d9-ffb1-6469-4272-2d1222600825@vodafone.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 16-11-25 03:40 PM, Christian König wrote:
> Am 25.11.2016 um 20:32 schrieb Jason Gunthorpe:
>> This assumes the commands are fairly short lived of course, the
>> expectation of the mmu notifiers is that a flush is reasonably prompt
>
> Correct, this is another problem. GFX command submissions usually
> don't take longer than a few milliseconds, but compute command
> submission can easily take multiple hours.
>
> I can easily imagine what would happen when kswapd is blocked by a GPU
> command submission for an hour or so while the system is under memory
> pressure :)
>
> I'm thinking on this problem for about a year now and going in circles
> for quite a while. So if you have ideas on this even if they sound
> totally crazy, feel free to come up.

Our GPUs (at least starting with VI) support compute-wave-save-restore
and can swap out compute queues with fairly low latency. Yes, there is
some overhead (both memory usage and time), but it's a fairly regular
thing with our hardware scheduler (firmware, actually) when we need to
preempt running compute queues to update runlists or we overcommit the
hardware queue resources.

Regards,
  Felix

