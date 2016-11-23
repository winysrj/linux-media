Return-path: <linux-media-owner@vger.kernel.org>
Date: Wed, 23 Nov 2016 12:12:15 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Serguei Sagalovitch <serguei.sagalovitch@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
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
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161123191215.GB12146@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <eca737c1-415c-bcd4-80b9-628010638051@sandisk.com>
 <CAPcyv4jsgrsQaeewFedUzcD1XLSQ8vQ5Zyr8EoB_5ORUqmL4nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jsgrsQaeewFedUzcD1XLSQ8vQ5Zyr8EoB_5ORUqmL4nQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 23, 2016 at 10:40:47AM -0800, Dan Williams wrote:

> I don't think that was designed for the case where the backing memory
> is a special/static physical address range rather than anonymous
> "System RAM", right?

The hardware doesn't care where the memory is. ODP is just a generic
mechanism to provide demand-fault behavior for a mirrored page table.

ODP has the same issue as everything else, it needs to translate a
page table entry into a DMA address, and we have no API to do that
when the page table points to peer-peer memory.

Jason
