Return-path: <linux-media-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:42177 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750819AbdALRRp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jan 2017 12:17:45 -0500
Date: Thu, 12 Jan 2017 10:17:20 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>, david1.zhou@amd.com,
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
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20170112171720.GA12257@obsidianresearch.com>
References: <20170105224215.GA3855@obsidianresearch.com>
 <20170105232352.GB6426@redhat.com>
 <20170106003034.GB4670@obsidianresearch.com>
 <20170106015831.GA2226@gmail.com>
 <f07700d5-211f-d091-2b0b-fbaf03c4a959@amd.com>
 <20170106173722.GB3804@redhat.com>
 <20170106182625.GB5724@obsidianresearch.com>
 <2a148b6e-86bc-4c4d-2f22-d733e2cc94cc@deltatee.com>
 <d5a72e1e5f6d606697dc0027f073fd87.squirrel@webmail.raithlin.com>
 <20170112151129.GA10942@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170112151129.GA10942@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 12, 2017 at 10:11:29AM -0500, Jerome Glisse wrote:
> On Wed, Jan 11, 2017 at 10:54:39PM -0600, Stephen Bates wrote:
> > > What we want is for RDMA, O_DIRECT, etc to just work with special VMAs
> > > (ie. at least those backed with ZONE_DEVICE memory). Then
> > > GPU/NVME/DAX/whatever drivers can just hand these VMAs to userspace
> > > (using whatever interface is most appropriate) and userspace can do what
> > > it pleases with them. This makes _so_ much sense and actually largely
> > > already works today (as demonstrated by iopmem).

> So i say let solve the IOMMU issue first and let everyone use it in their
> own way with their device. I do not think we can share much more than
> that.

Solve it for the easy ZONE_DIRECT/etc case then.

Jason
