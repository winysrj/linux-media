Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:50068 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750785AbcLFVrK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 16:47:10 -0500
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
References: <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com>
 <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
 <20161205180231.GA28133@obsidianresearch.com>
 <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ@mail.gmail.com>
 <a3a1c239-297d-c091-7758-54acdf00f74e@deltatee.com>
 <CAPcyv4iVHhOSxPrLMZ53Xw3CK+9cOWn9zEG8smMtqF_LAcKKpg@mail.gmail.com>
 <ac07a73f2601f6ca35cecc83c553feb0.squirrel@webmail.raithlin.com>
 <20161206163850.GC28066@obsidianresearch.com>
 <ec136c34-417d-8a55-c176-2c1d759a5fb8@deltatee.com>
 <20161206172838.GB19318@obsidianresearch.com>
Cc: Stephen Bates <sbates@raithlin.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Haggai Eran <haggaie@mellanox.com>,
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
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <bedaa7a2-e42d-da83-5c2b-9d639b0397c5@deltatee.com>
Date: Tue, 6 Dec 2016 14:47:04 -0700
MIME-Version: 1.0
In-Reply-To: <20161206172838.GB19318@obsidianresearch.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey,

> Okay, so clearly this needs a kernel side NVMe specific allocator
> and locking so users don't step on each other..

Yup, ideally. That's why device dax isn't ideal for this application: it
doesn't provide any way to prevent users from stepping on each other.

> Or as Christoph says some kind of general mechanism to get these
> bounce buffers..

Yeah, I imagine a general allocate from BAR/region system would be very
useful.

> Ah, I see.
> 
> As a first draft I'd stick with some kind of API built into the
> /dev/nvmeX that backs the filesystem. The user app would fstat the
> target file, open /dev/block/MAJOR(st_dev):MINOR(st_dev), do some
> ioctl to get a CMB mmap, and then proceed from there..
> 
> When that is all working kernel-side, it would make sense to look at a
> more general mechanism that could be used unprivileged??

That makes a lot of sense to me. I suggested mmapping the char device
because it's really easy, but I can see that an ioctl on the block
device does seem more general and device agnostic.

> This is similar to the GPU issues too.. On NVMe you don't need to pin
> the pages, you just need to lock that VMA so it doesn't get freed from
> the NVMe CMB allocator while the IO is running...
> Probably in the long run the get_user_pages is going to have to be
> pushed down into drivers.. Future MMU coherent IO hardware also does
> not need the pinning or other overheads.

Yup. Yup.

Logan
