Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
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
Cc: Haggai Eran <haggaie@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
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
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
Message-ID: <a98185d9-ffb1-6469-4272-2d1222600825@vodafone.de>
Date: Fri, 25 Nov 2016 21:40:10 +0100
MIME-Version: 1.0
In-Reply-To: <20161125193252.GC16504@obsidianresearch.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 25.11.2016 um 20:32 schrieb Jason Gunthorpe:
> On Fri, Nov 25, 2016 at 02:22:17PM +0100, Christian König wrote:
>
>>> Like you say below we have to handle short lived in the usual way, and
>>> that covers basically every device except IB MRs, including the
>>> command queue on a NVMe drive.
>> Well a problem which wasn't mentioned so far is that while GPUs do have a
>> page table to mirror the CPU page table, they usually can't recover from
>> page faults.
>> So what we do is making sure that all memory accessed by the GPU Jobs stays
>> in place while those jobs run (pretty much the same pinning you do for the
>> DMA).
> Yes, it is DMA, so this is a valid approach.
>
> But, you don't need page faults from the GPU to do proper coherent
> page table mirroring. Basically when the driver submits the work to
> the GPU it 'faults' the pages into the CPU and mirror translation
> table (instead of pinning).
>
> Like in ODP, MMU notifiers/HMM are used to monitor for translation
> changes. If a change comes in the GPU driver checks if an executing
> command is touching those pages and blocks the MMU notifier until the
> command flushes, then unfaults the page (blocking future commands) and
> unblocks the mmu notifier.

Yeah, we have a function to "import" anonymous pages from a CPU pointer 
which works exactly that way as well.

We call this "userptr" and it's just a combination of get_user_pages() 
on command submission and making sure the returned list of pages stays 
valid using a MMU notifier.

The "big" problem with this approach is that it is horrible slow. I mean 
seriously horrible slow so that we actually can't use it for some of the 
purposes we wanted to use it.

> The code moving the page will move it and the next GPU command that
> needs it will refault it in the usual way, just like the CPU would.

And here comes the problem. CPU do this on a page by page basis, so they 
fault only what needed and everything else gets filled in on demand. 
This results that faulting a page is relatively light weight operation.

But for GPU command submission we don't know which pages might be 
accessed beforehand, so what we do is walking all possible pages and 
make sure all of them are present.

Now as far as I understand it the I/O subsystem for example assumes that 
it can easily change the CPU page tables without much overhead. So for 
example when a page can't modified it is temporary marked as readonly 
AFAIK (you are probably way deeper into this than me, so please confirm).

That absolutely kills any performance for GPU command submissions. We 
have use cases where we practically ended up playing ping/pong between 
the GPU driver trying to grab the page with get_user_pages() and sombody 
else in the kernel marking it readonly.

> This might be much more efficient since it optimizes for the common
> case of unchanging translation tables.

Yeah, completely agree. It works perfectly fine as long as you don't 
have two drivers trying to mess with the same page.

> This assumes the commands are fairly short lived of course, the
> expectation of the mmu notifiers is that a flush is reasonably prompt

Correct, this is another problem. GFX command submissions usually don't 
take longer than a few milliseconds, but compute command submission can 
easily take multiple hours.

I can easily imagine what would happen when kswapd is blocked by a GPU 
command submission for an hour or so while the system is under memory 
pressure :)

I'm thinking on this problem for about a year now and going in circles 
for quite a while. So if you have ideas on this even if they sound 
totally crazy, feel free to come up.

Cheers,
Christian.

