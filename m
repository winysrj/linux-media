Return-path: <linux-media-owner@vger.kernel.org>
Date: Thu, 5 Jan 2017 13:07:19 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: Jerome Glisse <j.glisse@gmail.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>,
        "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>,
        "'Linux-media@vger.kernel.org'" <Linux-media@vger.kernel.org>,
        "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>,
        "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>, hch@infradead.org,
        david1.zhou@amd.com, qiang.yu@amd.com
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20170105200719.GB31047@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
 <20170105190113.GA12587@obsidianresearch.com>
 <20170105195424.GB2166@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170105195424.GB2166@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 05, 2017 at 02:54:24PM -0500, Jerome Glisse wrote:

> Mellanox and NVidia support peer to peer with what they market a
> GPUDirect. It only works without IOMMU. It is probably not upstream :
> 
> https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg21402.html
> 
> I thought it was but it seems it require an out of tree driver to work.

Right, it is out of tree and not under consideration for mainline.

> Wether there is a vma or not isn't important to the issue anyway. If
> you want to enforce VMA rule for RDMA it is an RDMA specific discussion
> in which i don't want to be involve, it is not my turf :)

Always having a VMA changes the discussion - the question is how to
create a VMA that reprensents IO device memory, and how do DMA
consumers extract the correct information from that VMA to pass to the
kernel DMA API so it can setup peer-peer DMA.

> What matter is the back channel API between peer-to-peer device. Like
> the above patchset points out for GPU we need to be able to invalidate
> a mapping at any point in time. Pining is not something we want to
> live with.

We have MMU notifiers to handle this today in RDMA. Async RDMA MR
Invalidate like you see in the above out of tree patches is totally
crazy and shouldn't be in mainline. Use ODP capable RDMA hardware.

Jason
