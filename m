Return-path: <linux-media-owner@vger.kernel.org>
Date: Thu, 5 Jan 2017 12:01:13 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
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
Message-ID: <20170105190113.GA12587@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170105183927.GA5324@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 05, 2017 at 01:39:29PM -0500, Jerome Glisse wrote:

>   1) peer-to-peer because of userspace specific API like NVidia GPU
>     direct (AMD is pushing its own similar API i just can't remember
>     marketing name). This does not happen through a vma, this happens
>     through specific device driver call going through device specific
>     ioctl on both side (GPU and RDMA). So both kernel driver are aware
>     of each others.

Today you can only do user-initiated RDMA operations in conjection
with a VMA.

We'd need a really big and strong reason to create an entirely new
non-VMA based memory handle scheme for RDMA.

So my inclination is to just completely push back on this idea. You
need a VMA to do RMA.

GPUs need to create VMAs for the memory they want to RDMA from, even
if the VMA handle just causes SIGBUS for any CPU access.

Jason
