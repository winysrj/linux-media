Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Logan Gunthorpe <logang@deltatee.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dan Williams <dan.j.williams@intel.com>
References: <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <CAPcyv4jVDC=8AbVa9v6LcXm9n8QHgizv_+gQJC4RTd-wtTESWQ@mail.gmail.com>
 <20161123232503.GA13965@obsidianresearch.com>
 <a33ec1cd-051f-8a24-0587-68707459c25c@amd.com>
 <5e1de9ee-34f5-136d-a07e-f949d492864f@deltatee.com>
 <c60815a1-aaac-52eb-1714-66abb28bdc01@amd.com>
 <209107c7-3098-ca70-7d62-b55021d01faa@deltatee.com>
CC: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Sander, Ben" <ben.sander@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>,
        Haggai Eran <haggaie@mellanox.com>
From: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Message-ID: <ea52d962-6c8e-92d9-eb1b-3ace4bf56126@amd.com>
Date: Fri, 25 Nov 2016 12:20:47 -0500
MIME-Version: 1.0
In-Reply-To: <209107c7-3098-ca70-7d62-b55021d01faa@deltatee.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> A white list may end up being rather complicated if it has to cover
> different CPU generations and system architectures. I feel this is a
> decision user space could easily make.
>
> Logan
I agreed that it is better to leave up to user space to check what is 
working
and what is not. I found that write is practically always working but 
read very
often not. Also sometimes system BIOS update could fix the issue.

