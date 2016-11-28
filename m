Return-path: <linux-media-owner@vger.kernel.org>
Message-ID: <583BC14B.2040809@amd.com>
Date: Mon, 28 Nov 2016 13:31:55 +0800
From: zhoucm1 <david1.zhou@amd.com>
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
        "Haggai Eran" <haggaie@mellanox.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "Yu, Qiang" <Qiang.Yu@amd.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        Serguei Sagalovitch <serguei.sagalovitch@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "Sander, Ben" <ben.sander@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
References: <20161123190515.GA12146@obsidianresearch.com> <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com> <20161123193228.GC12146@obsidianresearch.com> <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com> <20161123203332.GA15062@obsidianresearch.com> <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com> <20161123215510.GA16311@obsidianresearch.com> <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com> <20161124164249.GD20818@obsidianresearch.com> <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com> <20161125193252.GC16504@obsidianresearch.com> <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com> <0087fba9-7bcb-8bb3-c26e-4ef3e4970c34@amd.com>
In-Reply-To: <0087fba9-7bcb-8bb3-c26e-4ef3e4970c34@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+Qiang, who is working on it.

On 2016年11月27日 22:07, Christian König wrote:
> Am 27.11.2016 um 15:02 schrieb Haggai Eran:
>> On 11/25/2016 9:32 PM, Jason Gunthorpe wrote:
>>> On Fri, Nov 25, 2016 at 02:22:17PM +0100, Christian König wrote:
>>>
>>>>> Like you say below we have to handle short lived in the usual way, 
>>>>> and
>>>>> that covers basically every device except IB MRs, including the
>>>>> command queue on a NVMe drive.
>>>> Well a problem which wasn't mentioned so far is that while GPUs do 
>>>> have a
>>>> page table to mirror the CPU page table, they usually can't recover 
>>>> from
>>>> page faults.
>>>> So what we do is making sure that all memory accessed by the GPU 
>>>> Jobs stays
>>>> in place while those jobs run (pretty much the same pinning you do 
>>>> for the
>>>> DMA).
>>> Yes, it is DMA, so this is a valid approach.
>>>
>>> But, you don't need page faults from the GPU to do proper coherent
>>> page table mirroring. Basically when the driver submits the work to
>>> the GPU it 'faults' the pages into the CPU and mirror translation
>>> table (instead of pinning).
>>>
>>> Like in ODP, MMU notifiers/HMM are used to monitor for translation
>>> changes. If a change comes in the GPU driver checks if an executing
>>> command is touching those pages and blocks the MMU notifier until the
>>> command flushes, then unfaults the page (blocking future commands) and
>>> unblocks the mmu notifier.
>> I think blocking mmu notifiers against something that is basically
>> controlled by user-space can be problematic. This can block things like
>> memory reclaim. If you have user-space access to the device's queues,
>> user-space can block the mmu notifier forever.
> Really good point.
>
> I think this means the bare minimum if we don't have recoverable page 
> faults is to have preemption support like Felix described in his 
> answer as well.
>
> Going to keep that in mind,
> Christian.
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

