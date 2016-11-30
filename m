Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
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
 <20161128190244.GA21975@obsidianresearch.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        "Max Gurtovoy" <maxg@mellanox.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "serguei.sagalovitch@amd.com" <serguei.sagalovitch@amd.com>,
        "Paul.Blinzer@amd.com" <Paul.Blinzer@amd.com>,
        "Felix.Kuehling@amd.com" <Felix.Kuehling@amd.com>,
        "ben.sander@amd.com" <ben.sander@amd.com>
From: Haggai Eran <haggaie@mellanox.com>
Message-ID: <c0ddccf3-52ce-d883-a57a-70d8a1febf85@mellanox.com>
Date: Wed, 30 Nov 2016 12:45:58 +0200
MIME-Version: 1.0
In-Reply-To: <20161128190244.GA21975@obsidianresearch.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/28/2016 9:02 PM, Jason Gunthorpe wrote:
> On Mon, Nov 28, 2016 at 06:19:40PM +0000, Haggai Eran wrote:
>>>> GPU memory. We create a non-ODP MR pointing to VRAM but rely on
>>>> user-space and the GPU not to migrate it. If they do, the MR gets
>>>> destroyed immediately.
>>> That sounds horrible. How can that possibly work? What if the MR is
>>> being used when the GPU decides to migrate? 
>> Naturally this doesn't support migration. The GPU is expected to pin
>> these pages as long as the MR lives. The MR invalidation is done only as
>> a last resort to keep system correctness.
> 
> That just forces applications to handle horrible unexpected
> failures. If this sort of thing is needed for correctness then OOM
> kill the offending process, don't corrupt its operation.
Yes, that sounds fine. Can we simply kill the process from the GPU driver?
Or do we need to extend the OOM killer to manage GPU pages?

> 
>> I think it is similar to how non-ODP MRs rely on user-space today to
>> keep them correct. If you do something like madvise(MADV_DONTNEED) on a
>> non-ODP MR's pages, you can still get yourself into a data corruption
>> situation (HCA sees one page and the process sees another for the same
>> virtual address). The pinning that we use only guarentees the HCA's page
>> won't be reused.
> 
> That is not really data corruption - the data still goes where it was
> originally destined. That is an application violating the
> requirements of a MR. 
I guess it is a matter of terminology. If you compare it to the ODP case 
or the CPU case then you usually expect a single virtual address to map to
a single physical page. Violating this cause some of your writes to be dropped
which is a data corruption in my book, even if the application caused it.

> An application cannot munmap/mremap a VMA
> while a non ODP MR points to it and then keep using the MR.
Right. And it is perfectly fine to have some similar requirements from the application
when doing peer to peer with a non-ODP MR. 

> That is totally different from a GPU driver wanthing to mess with
> translation to physical pages.
> 
>>> From what I understand we are not really talking about kernel p2p,
>>> everything proposed so far is being mediated by a userspace VMA, so
>>> I'd focus on making that work.
> 
>> Fair enough, although we will need both eventually, and I hope the
>> infrastructure can be shared to some degree.
> 
> What use case do you see for in kernel?
Two cases I can think of are RDMA access to an NVMe device's controller 
memory buffer, and O_DIRECT operations that access GPU memory.
Also, HMM's migration between two GPUs could use peer to peer in the kernel,
although that is intended to be handled by the GPU driver if I understand
correctly.

> Presumably in-kernel could use a vmap or something and the same basic
> flow?
I think we can achieve the kernel's needs with ZONE_DEVICE and DMA-API support
for peer to peer. I'm not sure we need vmap. We need a way to have a scatterlist
of MMIO pfns, and ZONE_DEVICE allows that.

Haggai
