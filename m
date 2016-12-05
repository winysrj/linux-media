Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34232 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbcLERkk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 12:40:40 -0500
Received: by mail-oi0-f41.google.com with SMTP id y198so349220328oia.1
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2016 09:40:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161205171830.GB27784@obsidianresearch.com>
References: <20161125193252.GC16504@obsidianresearch.com> <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
 <20161128165751.GB28381@obsidianresearch.com> <1480357179.19407.13.camel@mellanox.com>
 <20161128190244.GA21975@obsidianresearch.com> <c0ddccf3-52ce-d883-a57a-70d8a1febf85@mellanox.com>
 <20161130162353.GA24639@obsidianresearch.com> <5f5b7989-84f5-737e-47c8-831f752d6280@deltatee.com>
 <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com> <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 5 Dec 2016 09:40:38 -0800
Message-ID: <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Stephen Bates <sbates@raithlin.com>,
        Haggai Eran <haggaie@mellanox.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "Suravee.Suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "John.Bridgman@amd.com" <john.bridgman@amd.com>,
        "Alexander.Deucher@amd.com" <alexander.deucher@amd.com>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "serguei.sagalovitch@amd.com" <serguei.sagalovitch@amd.com>,
        "Paul.Blinzer@amd.com" <paul.blinzer@amd.com>,
        "Felix.Kuehling@amd.com" <felix.kuehling@amd.com>,
        "ben.sander@amd.com" <ben.sander@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 5, 2016 at 9:18 AM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Sun, Dec 04, 2016 at 07:23:00AM -0600, Stephen Bates wrote:
>> Hi All
>>
>> This has been a great thread (thanks to Alex for kicking it off) and I
>> wanted to jump in and maybe try and put some summary around the
>> discussion. I also wanted to propose we include this as a topic for LFS/MM
>> because I think we need more discussion on the best way to add this
>> functionality to the kernel.
>>
>> As far as I can tell the people looking for P2P support in the kernel fall
>> into two main camps:
>>
>> 1. Those who simply want to expose static BARs on PCIe devices that can be
>> used as the source/destination for DMAs from another PCIe device. This
>> group has no need for memory invalidation and are happy to use
>> physical/bus addresses and not virtual addresses.
>
> I didn't think there was much on this topic except for the CMB
> thing.. Even that is really a mapped kernel address..
>
>> I think something like the iopmem patches Logan and I submitted recently
>> come close to addressing use case 1. There are some issues around
>> routability but based on feedback to date that does not seem to be a
>> show-stopper for an initial inclusion.
>
> If it is kernel only with physical addresess we don't need a uAPI for
> it, so I'm not sure #1 is at all related to iopmem.
>
> Most people who want #1 probably can just mmap
> /sys/../pci/../resourceX to get a user handle to it, or pass around
> __iomem pointers in the kernel. This has been asked for before with
> RDMA.
>
> I'm still not really clear what iopmem is for, or why DAX should ever
> be involved in this..

Right, by default remap_pfn_range() does not establish DMA capable
mappings. You can think of iopmem as remap_pfn_range() converted to
use devm_memremap_pages(). Given the extra constraints of
devm_memremap_pages() it seems reasonable to have those DMA capable
mappings be optionally established via a separate driver.
