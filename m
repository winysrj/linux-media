Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37436 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbcLEUGq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 15:06:46 -0500
Date: Mon, 5 Dec 2016 12:06:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Logan Gunthorpe <logang@deltatee.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Stephen Bates <sbates@raithlin.com>,
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
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161205200632.GA24497@infradead.org>
References: <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com>
 <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
 <20161205180231.GA28133@obsidianresearch.com>
 <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ@mail.gmail.com>
 <a3a1c239-297d-c091-7758-54acdf00f74e@deltatee.com>
 <CAPcyv4iVHhOSxPrLMZ53Xw3CK+9cOWn9zEG8smMtqF_LAcKKpg@mail.gmail.com>
 <20161205191438.GA20464@obsidianresearch.com>
 <10356964-c454-47fb-7fb3-8bf2a418b11b@deltatee.com>
 <20161205194614.GA21132@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161205194614.GA21132@obsidianresearch.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 05, 2016 at 12:46:14PM -0700, Jason Gunthorpe wrote:
> In any event the allocator still needs to track which regions are in
> use and be able to hook 'free' from userspace. That does suggest it
> should be integrated into the nvme driver and not a bolt on driver..

Two totally different use cases:

 - a card that exposes directly byte addressable storage as a PCI-e
   bar.  Thin of it as a nvdimm on a PCI-e card.  That's the iopmem
   case.
 - the NVMe CMB which exposes a byte addressable indirection buffer for
   I/O, but does not actually provide byte addressable persistent
   storage.  This is something that needs to be added to the NVMe driver
   (and the block layer for the abstraction probably).
