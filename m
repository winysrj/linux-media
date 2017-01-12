Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:56103 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751133AbdALWfQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jan 2017 17:35:16 -0500
To: Stephen Bates <sbates@raithlin.com>
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
 <d5a72e1e5f6d606697dc0027f073fd87.squirrel@webmail.raithlin.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jerome Glisse <jglisse@redhat.com>, david1.zhou@amd.com,
        qiang.yu@amd.com,
        "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>,
        "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>,
        "Kuehling, Felix" <felix.kuehling@amd.com>,
        Serguei Sagalovitch <serguei.sagalovitch@amd.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>,
        "Koenig, Christian" <christian.koenig@amd.com>, hch@infradead.org,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>,
        "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
        Jerome Glisse <j.glisse@gmail.com>,
        "Blinzer, Paul" <paul.blinzer@amd.com>,
        "'Linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <8bda88d4-1e7c-7889-7d20-1a0eb43de31a@deltatee.com>
Date: Thu, 12 Jan 2017 15:35:07 -0700
MIME-Version: 1.0
In-Reply-To: <d5a72e1e5f6d606697dc0027f073fd87.squirrel@webmail.raithlin.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/01/17 09:54 PM, Stephen Bates wrote:
> The iopmem patchset addressed all the use cases above and while it is not
> an in kernel API it could have been modified to be one reasonably easily.
> As Logan states the driver can then choose to pass the VMAs to user-space
> in a manner that makes sense.

Just to clarify: the iopmem patchset had one patch that allowed for
slightly more flexible zone device mappings which ought to be useful for
everyone.

The other patch (which was iopmem proper) was more of an example of how
the zone_device memory _could_ be exposed to userspace with "iopmem"
hardware that looks similar to nvdimm hardware. Iopmem was not really
useful, in itself, for NVMe devices and it was never expected to be
useful for GPUs.

Logan
