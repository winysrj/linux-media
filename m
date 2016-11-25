Return-path: <linux-media-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20161125193410.GD16504@obsidianresearch.com>
References: <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com> <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com> <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com> <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com> <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com> <7ff3cf70-b0c3-028e-fea8-c370a1185b65@amd.com>
 <20161125193410.GD16504@obsidianresearch.com>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Fri, 25 Nov 2016 18:41:21 -0500
Message-ID: <CADnq5_PEBzxO7MVxV3q4Jy3uZNTfKWXo-gsvZQA8BdTMOSPjmw@mail.gmail.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Serguei Sagalovitch <serguei.sagalovitch@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 25, 2016 at 2:34 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Fri, Nov 25, 2016 at 12:16:30PM -0500, Serguei Sagalovitch wrote:
>
>> b) Allocation may not  have CPU address  at all - only GPU one.
>
> But you don't expect RDMA to work in the case, right?
>
> GPU people need to stop doing this windowed memory stuff :)
>

Blame 32 bit systems and GPUs with tons of vram :)

I think resizable bars are finally coming in a useful way so this
should go away soon.

Alex
