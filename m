Return-path: <linux-media-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:44407 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751570AbcLETq2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 14:46:28 -0500
Date: Mon, 5 Dec 2016 12:46:14 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
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
Message-ID: <20161205194614.GA21132@obsidianresearch.com>
References: <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com>
 <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com>
 <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
 <20161205180231.GA28133@obsidianresearch.com>
 <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ@mail.gmail.com>
 <a3a1c239-297d-c091-7758-54acdf00f74e@deltatee.com>
 <CAPcyv4iVHhOSxPrLMZ53Xw3CK+9cOWn9zEG8smMtqF_LAcKKpg@mail.gmail.com>
 <20161205191438.GA20464@obsidianresearch.com>
 <10356964-c454-47fb-7fb3-8bf2a418b11b@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10356964-c454-47fb-7fb3-8bf2a418b11b@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 05, 2016 at 12:27:20PM -0700, Logan Gunthorpe wrote:
> 
> 
> On 05/12/16 12:14 PM, Jason Gunthorpe wrote:
> >But CMB sounds much more like the GPU case where there is a
> >specialized allocator handing out the BAR to consumers, so I'm not
> >sure a general purpose chardev makes a lot of sense?
> 
> I don't think it will ever need to be as complicated as the GPU case. There
> will probably only ever be a relatively small amount of memory behind the
> CMB and really the only users are those doing P2P work. Thus the specialized
> allocator could be pretty simple and I expect it would be fine to just
> return -ENOMEM if there is not enough memory.

NVMe might have to deal with pci-e hot-unplug, which is a similar
problem-class to the GPU case..

In any event the allocator still needs to track which regions are in
use and be able to hook 'free' from userspace. That does suggest it
should be integrated into the nvme driver and not a bolt on driver..

Jason
