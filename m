Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.51.172]:46497 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750881AbcLDNsQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Dec 2016 08:48:16 -0500
Received: from cm6.websitewelcome.com (cm6.websitewelcome.com [108.167.139.19])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 7C61AF5C35FC0
        for <linux-media@vger.kernel.org>; Sun,  4 Dec 2016 07:23:03 -0600 (CST)
Message-ID: <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
In-Reply-To: <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com>
References: <20161123215510.GA16311@obsidianresearch.com>
    <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
    <20161124164249.GD20818@obsidianresearch.com>
    <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
    <20161125193252.GC16504@obsidianresearch.com>
    <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
    <20161128165751.GB28381@obsidianresearch.com>
    <1480357179.19407.13.camel@mellanox.com>
    <20161128190244.GA21975@obsidianresearch.com>
    <c0ddccf3-52ce-d883-a57a-70d8a1febf85@mellanox.com>
    <20161130162353.GA24639@obsidianresearch.com>
    <5f5b7989-84f5-737e-47c8-831f752d6280@deltatee.com>
    <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com>
Date: Sun, 4 Dec 2016 07:23:00 -0600
Subject: Re: Enabling peer to peer device transactions for PCIe devices
From: "Stephen Bates" <sbates@raithlin.com>
To: "Haggai Eran" <haggaie@mellanox.com>
Cc: "Logan Gunthorpe" <logang@deltatee.com>,
        "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
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
        "Max Gurtovoy" <maxg@mellanox.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "serguei.sagalovitch@amd.com" <serguei.sagalovitch@amd.com>,
        "Paul.Blinzer@amd.com" <paul.blinzer@amd.com>,
        "Felix.Kuehling@amd.com" <felix.kuehling@amd.com>,
        "ben.sander@amd.com" <ben.sander@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All

This has been a great thread (thanks to Alex for kicking it off) and I
wanted to jump in and maybe try and put some summary around the
discussion. I also wanted to propose we include this as a topic for LFS/MM
because I think we need more discussion on the best way to add this
functionality to the kernel.

As far as I can tell the people looking for P2P support in the kernel fall
into two main camps:

1. Those who simply want to expose static BARs on PCIe devices that can be
used as the source/destination for DMAs from another PCIe device. This
group has no need for memory invalidation and are happy to use
physical/bus addresses and not virtual addresses.

2. Those who want to support devices that suffer from occasional memory
pressure and need to invalidate memory regions from time to time. This
camp also would like to use virtual addresses rather than physical ones to
allow for things like migration.

I am wondering if people agree with this assessment?

I think something like the iopmem patches Logan and I submitted recently
come close to addressing use case 1. There are some issues around
routability but based on feedback to date that does not seem to be a
show-stopper for an initial inclusion.

For use-case 2 it looks like there are several options and some of them
(like HMM) have been around for quite some time without gaining
acceptance. I think there needs to be more discussion on this usecase and
it could be some time before we get something upstreamable.

I for one, would really like to see use case 1 get addressed soon because
we have consumers for it coming soon in the form of CMBs for NVMe devices.

Long term I think Jason summed it up really well. CPU vendors will put
high-speed, open, switchable, coherent buses on their processors and all
these problems will vanish. But I ain't holding my breathe for that to
happen ;-).

Cheers

Stephen
