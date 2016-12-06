Return-path: <linux-media-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:55287 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753761AbcLFQjI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 11:39:08 -0500
Date: Tue, 6 Dec 2016 09:38:50 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Stephen Bates <sbates@raithlin.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
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
Message-ID: <20161206163850.GC28066@obsidianresearch.com>
References: <5f5b7989-84f5-737e-47c8-831f752d6280@deltatee.com>
 <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com>
 <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com>
 <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
 <20161205180231.GA28133@obsidianresearch.com>
 <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ@mail.gmail.com>
 <a3a1c239-297d-c091-7758-54acdf00f74e@deltatee.com>
 <CAPcyv4iVHhOSxPrLMZ53Xw3CK+9cOWn9zEG8smMtqF_LAcKKpg@mail.gmail.com>
 <ac07a73f2601f6ca35cecc83c553feb0.squirrel@webmail.raithlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac07a73f2601f6ca35cecc83c553feb0.squirrel@webmail.raithlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > I'm not opposed to mapping /dev/nvmeX.  However, the lookup is trivial
> > to accomplish in sysfs through /sys/dev/char to find the sysfs path of the
> > device-dax instance under the nvme device, or if you already have the nvme
> > sysfs path the dax instance(s) will appear under the "dax" sub-directory.
> 
> Personally I think mapping the dax resource in the sysfs tree is a nice
> way to do this and a bit more intuitive than mapping a /dev/nvmeX.

It is still not at all clear to me what userpsace is supposed to do
with this on nvme.. How is the CMB usable from userspace?

Jason
