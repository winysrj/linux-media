Return-path: <linux-media-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:50192 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbcLESCs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 13:02:48 -0500
Date: Mon, 5 Dec 2016 11:02:31 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Dan Williams <dan.j.williams@intel.com>
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
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161205180231.GA28133@obsidianresearch.com>
References: <20161128165751.GB28381@obsidianresearch.com>
 <1480357179.19407.13.camel@mellanox.com>
 <20161128190244.GA21975@obsidianresearch.com>
 <c0ddccf3-52ce-d883-a57a-70d8a1febf85@mellanox.com>
 <20161130162353.GA24639@obsidianresearch.com>
 <5f5b7989-84f5-737e-47c8-831f752d6280@deltatee.com>
 <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com>
 <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com>
 <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 05, 2016 at 09:40:38AM -0800, Dan Williams wrote:

> > If it is kernel only with physical addresess we don't need a uAPI for
> > it, so I'm not sure #1 is at all related to iopmem.
> >
> > Most people who want #1 probably can just mmap
> > /sys/../pci/../resourceX to get a user handle to it, or pass around
> > __iomem pointers in the kernel. This has been asked for before with
> > RDMA.
> >
> > I'm still not really clear what iopmem is for, or why DAX should ever
> > be involved in this..
> 
> Right, by default remap_pfn_range() does not establish DMA capable
> mappings. You can think of iopmem as remap_pfn_range() converted to
> use devm_memremap_pages(). Given the extra constraints of
> devm_memremap_pages() it seems reasonable to have those DMA capable
> mappings be optionally established via a separate driver.

Except the iopmem driver claims the PCI ID, and presents a block
interface which is really *NOT* what people who have asked for this in
the past have wanted. IIRC it was embedded stuff eg RDMA video
directly out of a capture card or a similar kind of thinking.

It is a good point about devm_memremap_pages limitations, but maybe
that just says to create a /sys/.../resource_dmableX ?

Or is there some reason why people want a filesystem on top of BAR
memory? That does not seem to have been covered yet..

Jason
