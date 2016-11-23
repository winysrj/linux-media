Return-path: <linux-media-owner@vger.kernel.org>
To: Serguei Sagalovitch <serguei.sagalovitch@amd.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
Date: Wed, 23 Nov 2016 10:13:03 -0700
MIME-Version: 1.0
In-Reply-To: <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey,

On 22/11/16 11:59 AM, Serguei Sagalovitch wrote:
> -  How well we will be able to handle case when we need to "move"/"evict"
>    memory/data to the new location so CPU pointer should point to the
> new physical location/address
>     (and may be not in PCI device memory at all)?

IMO any memory that has been registered for a P2P transaction should be
locked from being evicted. So if there's a get_user_pages call it needs
to be pinned until the put_page. The main issue being with the RDMA
case: handling an eviction when a chunk of memory has been registered as
an MR would be very tricky. The MR may be relied upon by another host
and the kernel would have to inform user-space the MR was invalid then
user-space would have to tell the remote application. This seems like a
lot of burden to place on applications and may be subject to timing
issues. Either that or all RDMA applications need to be written with the
assumption that their target memory could go away at any time.

More generally, if you tell one PCI device to do a DMA transfer to
another PCI device's BAR space, and the target memory gets evicted then
DMA transaction needs to be aborted which means every driver doing the
transfer would need special support for this. If the memory can be
relied on to not be evicted than existing drivers should work unmodified
(ie O_DIRECT to/from an NVMe card would just work).

I feel the better approach is to pin memory subject to P2P transactions
as is typically done with DMA transfers to main memory.

Logan

