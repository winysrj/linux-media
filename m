Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58449 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752028AbcLFRMZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 12:12:25 -0500
Date: Tue, 6 Dec 2016 09:12:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Stephen Bates <sbates@raithlin.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
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
Message-ID: <20161206171213.GA870@infradead.org>
References: <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com>
 <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com>
 <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
 <20161205180231.GA28133@obsidianresearch.com>
 <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ@mail.gmail.com>
 <a3a1c239-297d-c091-7758-54acdf00f74e@deltatee.com>
 <CAPcyv4iVHhOSxPrLMZ53Xw3CK+9cOWn9zEG8smMtqF_LAcKKpg@mail.gmail.com>
 <ac07a73f2601f6ca35cecc83c553feb0.squirrel@webmail.raithlin.com>
 <20161206163850.GC28066@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161206163850.GC28066@obsidianresearch.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 06, 2016 at 09:38:50AM -0700, Jason Gunthorpe wrote:
> > > I'm not opposed to mapping /dev/nvmeX.  However, the lookup is trivial
> > > to accomplish in sysfs through /sys/dev/char to find the sysfs path of the
> > > device-dax instance under the nvme device, or if you already have the nvme
> > > sysfs path the dax instance(s) will appear under the "dax" sub-directory.
> > 
> > Personally I think mapping the dax resource in the sysfs tree is a nice
> > way to do this and a bit more intuitive than mapping a /dev/nvmeX.
> 
> It is still not at all clear to me what userpsace is supposed to do
> with this on nvme.. How is the CMB usable from userspace?

I don't think trying to expose it to userspace makes any sense.
Exposing it to in-kernel storage targets on the other hand makes a lot
of sense.
