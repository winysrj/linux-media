Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.51.61]:35066 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750704AbdALFW1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jan 2017 00:22:27 -0500
Received: from cm4.websitewelcome.com (unknown [108.167.139.16])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 0230114487
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2017 22:59:43 -0600 (CST)
Message-ID: <d5a72e1e5f6d606697dc0027f073fd87.squirrel@webmail.raithlin.com>
In-Reply-To: <2a148b6e-86bc-4c4d-2f22-d733e2cc94cc@deltatee.com>
References: <20170105190113.GA12587@obsidianresearch.com>
    <20170105195424.GB2166@redhat.com>
    <20170105200719.GB31047@obsidianresearch.com>
    <20170105201935.GC2166@redhat.com>
    <20170105224215.GA3855@obsidianresearch.com>
    <20170105232352.GB6426@redhat.com>
    <20170106003034.GB4670@obsidianresearch.com>
    <20170106015831.GA2226@gmail.com>
    <f07700d5-211f-d091-2b0b-fbaf03c4a959@amd.com>
    <20170106173722.GB3804@redhat.com>
    <20170106182625.GB5724@obsidianresearch.com>
    <2a148b6e-86bc-4c4d-2f22-d733e2cc94cc@deltatee.com>
Date: Wed, 11 Jan 2017 22:54:39 -0600
Subject: Re: Enabling peer to peer device transactions for PCIe devices
From: "Stephen Bates" <sbates@raithlin.com>
To: "Logan Gunthorpe" <logang@deltatee.com>
Cc: "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
        "Jerome Glisse" <jglisse@redhat.com>, david1.zhou@amd.com,
        qiang.yu@amd.com,
        "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>,
        "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>,
        "Kuehling, Felix" <felix.kuehling@amd.com>,
        "Serguei Sagalovitch" <serguei.sagalovitch@amd.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>,
        "Koenig, Christian" <christian.koenig@amd.com>, hch@infradead.org,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>,
        "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
        "Jerome Glisse" <j.glisse@gmail.com>,
        "Blinzer, Paul" <paul.blinzer@amd.com>,
        "'Linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, January 6, 2017 4:10 pm, Logan Gunthorpe wrote:
>
>
> On 06/01/17 11:26 AM, Jason Gunthorpe wrote:
>
>
>> Make a generic API for all of this and you'd have my vote..
>>
>>
>> IMHO, you must support basic pinning semantics - that is necessary to
>> support generic short lived DMA (eg filesystem, etc). That hardware can
>> clearly do that if it can support ODP.
>
> I agree completely.
>
>
> What we want is for RDMA, O_DIRECT, etc to just work with special VMAs
> (ie. at least those backed with ZONE_DEVICE memory). Then
> GPU/NVME/DAX/whatever drivers can just hand these VMAs to userspace
> (using whatever interface is most appropriate) and userspace can do what
> it pleases with them. This makes _so_ much sense and actually largely
> already works today (as demonstrated by iopmem).

+1 for iopmem ;-)

I feel like we are going around and around on this topic. I would like to
see something that is upstream that enables P2P even if it is only the
minimum viable useful functionality to begin. I think aiming for the moon
(which is what HMM and things like it are) are simply going to take more
time if they ever get there.

There is a use case for in-kernel P2P PCIe transfers between two NVMe
devices and between an NVMe device and an RDMA NIC (using NVMe CMBs or
BARs on the NIC). I am even seeing users who now want to move data P2P
between FPGAs and NVMe SSDs and the upstream kernel should be able to
support these users or they will look elsewhere.

The iopmem patchset addressed all the use cases above and while it is not
an in kernel API it could have been modified to be one reasonably easily.
As Logan states the driver can then choose to pass the VMAs to user-space
in a manner that makes sense.

Earlier in the thread someone mentioned LSF/MM. There is already a
proposal to discuss this topic so if you are interested please respond to
the email letting the committee know this topic is of interest to you [1].

Also earlier in the thread someone discussed the issues around the IOMMU.
Given the known issues around P2P transfers in certain CPU root complexes
[2] it might just be a case of only allowing P2P when a PCIe switch
connects the two EPs. Another option is just to use CONFIG_EXPERT and make
sure people are aware of the pitfalls if they invoke the P2P option.

Finally, as Jason noted, we could all just wait until
CAPI/OpenCAPI/CCIX/GenZ comes along. However given that these interfaces
are the remit of the CPU vendors I think it behooves us to solve this
problem before then. Also some of the above mentioned protocols are not
even switchable and may not be amenable to a P2P topology...

Stephen

[1] http://marc.info/?l=linux-mm&m=148156541804940&w=2
[2] https://community.mellanox.com/docs/DOC-1119

