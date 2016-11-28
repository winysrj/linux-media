Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Haggai Eran <haggaie@mellanox.com>,
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
 <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
CC: Logan Gunthorpe <logang@deltatee.com>,
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
From: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Message-ID: <314e9ef7-f60e-bf6b-d488-c585f1ea60e8@amd.com>
Date: Mon, 28 Nov 2016 09:48:34 -0500
MIME-Version: 1.0
In-Reply-To: <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-11-27 09:02 AM, Haggai Eran wrote
> On PeerDirect, we have some kind of a middle-ground solution for pinning
> GPU memory. We create a non-ODP MR pointing to VRAM but rely on
> user-space and the GPU not to migrate it. If they do, the MR gets
> destroyed immediately. This should work on legacy devices without ODP
> support, and allows the system to safely terminate a process that
> misbehaves. The downside of course is that it cannot transparently
> migrate memory but I think for user-space RDMA doing that transparently
> requires hardware support for paging, via something like HMM.
>
> ...
May be I am wrong but my understanding is that PeerDirect logic basically
follow  "RDMA register MR" logic so basically nothing prevent to "terminate"
process for "MMU notifier" case when we are very low on memory
not making it similar (not worse) then PeerDirect case.
>> I'm hearing most people say ZONE_DEVICE is the way to handle this,
>> which means the missing remaing piece for RDMA is some kind of DMA
>> core support for p2p address translation..
> Yes, this is definitely something we need. I think Will Davis's patches
> are a good start.
>
> Another thing I think is that while HMM is good for user-space
> applications, for kernel p2p use there is no need for that.
About HMM: I do not think that in the current form HMM would  fit in
requirement for generic P2P transfer case. My understanding is that at
the current stage HMM is good for "caching" system memory
in device memory for fast GPU access but in RDMA MR non-ODP case
it will not work because  the location of memory should not be
changed so memory should be allocated directly in PCIe memory.
> Using ZONE_DEVICE with or without something like DMA-BUF to pin and unpin
> pages for the short duration as you wrote above could work fine for
> kernel uses in which we can guarantee they are short.
Potentially there is another issue related to pin/unpin. If memory could
be used a lot of time then there is no sense to rebuild and program
s/g tables each time if location of memory was not changed.


