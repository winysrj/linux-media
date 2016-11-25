Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Felix Kuehling <felix.kuehling@amd.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
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
 <5e1de9ee-34f5-136d-a07e-f949d492864f@deltatee.com>
 <c60815a1-aaac-52eb-1714-66abb28bdc01@amd.com>
 <209107c7-3098-ca70-7d62-b55021d01faa@deltatee.com>
 <ea52d962-6c8e-92d9-eb1b-3ace4bf56126@amd.com>
 <fa44af1c-0c8a-7726-5100-a1f74f824a21@amd.com>
CC: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Sander, Ben" <ben.sander@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>,
        Haggai Eran <haggaie@mellanox.com>
From: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Message-ID: <5d43c69b-84fd-f13a-711f-e10c9bb5b1d1@amd.com>
Date: Fri, 25 Nov 2016 15:48:36 -0500
MIME-Version: 1.0
In-Reply-To: <fa44af1c-0c8a-7726-5100-a1f74f824a21@amd.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 2016-11-25 03:26 PM, Felix Kuehling wrote:
> On 16-11-25 12:20 PM, Serguei Sagalovitch wrote:
>>> A white list may end up being rather complicated if it has to cover
>>> different CPU generations and system architectures. I feel this is a
>>> decision user space could easily make.
>>>
>>> Logan
>> I agreed that it is better to leave up to user space to check what is
>> working
>> and what is not. I found that write is practically always working but
>> read very
>> often not. Also sometimes system BIOS update could fix the issue.
>>
> But is user mode always aware that P2P is going on or even possible? For
> example you may have a library reading a buffer from a file, but it
> doesn't necessarily know where that buffer is located (system memory,
> VRAM, ...) and it may not know what kind of the device the file is on
> (SATA drive, NVMe SSD, ...). The library will never know if all it gets
> is a pointer and a file descriptor.
>
> The library ends up calling a read system call. Then it would be up to
> the kernel to figure out the most efficient way to read the buffer from
> the file. If supported, it could use P2P between a GPU and NVMe where
> the NVMe device performs a DMA write to VRAM.
>
> If you put the burden of figuring out the P2P details on user mode code,
> I think it will severely limit the use cases that actually take
> advantage of it. You also risk a bunch of different implementations that
> get it wrong half the time on half the systems out there.
>
> Regards,
>    Felix
>
>
I agreed in theory with you but  I must admit that I do not know how
kernel could effectively collect all informations without running
pretty complicated tests each time on boot-up (if any configuration
changed including BIOS settings)  and on pnp events. Also for efficient
way kernel needs to know performance results (and it could also
depends on clock / power mode) for read/write of each pair devices, for
double-buffering it needs to know / detect on which NUMA node
to allocate, etc. etc.  Also  device could be fully configured only
on the first request for access so it may be needed to change initialization
sequences.

