Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:45877 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751064AbcLET1a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 14:27:30 -0500
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dan Williams <dan.j.williams@intel.com>
References: <20161130162353.GA24639@obsidianresearch.com>
 <5f5b7989-84f5-737e-47c8-831f752d6280@deltatee.com>
 <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com>
 <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com>
 <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
 <20161205180231.GA28133@obsidianresearch.com>
 <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ@mail.gmail.com>
 <a3a1c239-297d-c091-7758-54acdf00f74e@deltatee.com>
 <CAPcyv4iVHhOSxPrLMZ53Xw3CK+9cOWn9zEG8smMtqF_LAcKKpg@mail.gmail.com>
 <20161205191438.GA20464@obsidianresearch.com>
Cc: Stephen Bates <sbates@raithlin.com>,
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
Message-ID: <10356964-c454-47fb-7fb3-8bf2a418b11b@deltatee.com>
Date: Mon, 5 Dec 2016 12:27:20 -0700
MIME-Version: 1.0
In-Reply-To: <20161205191438.GA20464@obsidianresearch.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/12/16 12:14 PM, Jason Gunthorpe wrote:
> But CMB sounds much more like the GPU case where there is a
> specialized allocator handing out the BAR to consumers, so I'm not
> sure a general purpose chardev makes a lot of sense?

I don't think it will ever need to be as complicated as the GPU case. 
There will probably only ever be a relatively small amount of memory 
behind the CMB and really the only users are those doing P2P work. Thus 
the specialized allocator could be pretty simple and I expect it would 
be fine to just return -ENOMEM if there is not enough memory.

Also, if it was implemented this way, if there was a need to make the 
allocator more complicated it could easily be added later as the 
userspace interface is just mmap to obtain a buffer.

Logan
