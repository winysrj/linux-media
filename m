Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.148.204]:48965 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750867AbcLDN3g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Dec 2016 08:29:36 -0500
Received: from cm1.websitewelcome.com (cm.websitewelcome.com [192.185.0.102])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 1226939646572
        for <linux-media@vger.kernel.org>; Sun,  4 Dec 2016 07:06:52 -0600 (CST)
Message-ID: <9e62994cb4086557b3d1199111d1cf26.squirrel@webmail.raithlin.com>
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
Date: Sun, 4 Dec 2016 07:06:49 -0600
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

>>
>> The NVMe fabrics stuff could probably make use of this. It's an
>> in-kernel system to allow remote access to an NVMe device over RDMA. So
>> they ought to be able to optimize their transfers by DMAing directly to
>>  the NVMe's CMB -- no userspace interface would be required but there
>> would need some kernel infrastructure.
>
> Yes, that's what I was thinking. The NVMe/f driver needs to map the CMB
> for RDMA. I guess if it used ZONE_DEVICE like in the iopmem patches it
> would be relatively easy to do.
>

Haggai, yes that was one of the use cases we considered when we put
together the patchset.

