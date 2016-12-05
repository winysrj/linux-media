Return-path: <linux-media-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:55708 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751451AbcLERSt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 12:18:49 -0500
Date: Mon, 5 Dec 2016 10:18:30 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Stephen Bates <sbates@raithlin.com>
Cc: Haggai Eran <haggaie@mellanox.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "Suravee.Suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "John.Bridgman@amd.com" <john.bridgman@amd.com>,
        "Alexander.Deucher@amd.com" <alexander.deucher@amd.com>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "serguei.sagalovitch@amd.com" <serguei.sagalovitch@amd.com>,
        "Paul.Blinzer@amd.com" <paul.blinzer@amd.com>,
        "Felix.Kuehling@amd.com" <felix.kuehling@amd.com>,
        "ben.sander@amd.com" <ben.sander@amd.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161205171830.GB27784@obsidianresearch.com>
References: <20161125193252.GC16504@obsidianresearch.com>
 <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
 <20161128165751.GB28381@obsidianresearch.com>
 <1480357179.19407.13.camel@mellanox.com>
 <20161128190244.GA21975@obsidianresearch.com>
 <c0ddccf3-52ce-d883-a57a-70d8a1febf85@mellanox.com>
 <20161130162353.GA24639@obsidianresearch.com>
 <5f5b7989-84f5-737e-47c8-831f752d6280@deltatee.com>
 <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com>
 <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 04, 2016 at 07:23:00AM -0600, Stephen Bates wrote:
> Hi All
> 
> This has been a great thread (thanks to Alex for kicking it off) and I
> wanted to jump in and maybe try and put some summary around the
> discussion. I also wanted to propose we include this as a topic for LFS/MM
> because I think we need more discussion on the best way to add this
> functionality to the kernel.
> 
> As far as I can tell the people looking for P2P support in the kernel fall
> into two main camps:
> 
> 1. Those who simply want to expose static BARs on PCIe devices that can be
> used as the source/destination for DMAs from another PCIe device. This
> group has no need for memory invalidation and are happy to use
> physical/bus addresses and not virtual addresses.

I didn't think there was much on this topic except for the CMB
thing.. Even that is really a mapped kernel address..

> I think something like the iopmem patches Logan and I submitted recently
> come close to addressing use case 1. There are some issues around
> routability but based on feedback to date that does not seem to be a
> show-stopper for an initial inclusion.

If it is kernel only with physical addresess we don't need a uAPI for
it, so I'm not sure #1 is at all related to iopmem.

Most people who want #1 probably can just mmap
/sys/../pci/../resourceX to get a user handle to it, or pass around
__iomem pointers in the kernel. This has been asked for before with
RDMA.

I'm still not really clear what iopmem is for, or why DAX should ever
be involved in this..

> For use-case 2 it looks like there are several options and some of them
> (like HMM) have been around for quite some time without gaining
> acceptance. I think there needs to be more discussion on this usecase and
> it could be some time before we get something upstreamable.

AFAIK, hmm makes parts easier, but isn't directly addressing this
need..

I think you need to get ZONE_DEVICE accepted for non-cachable PCI BARs
as the first step.

>From there is pretty clear we the DMA API needs to be updated to
support that use and work can be done to solve the various problems
there on the basis of using ZONE_DEVICE pages to figure out to the
PCI-E end points

Jason
