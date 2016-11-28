Return-path: <linux-media-owner@vger.kernel.org>
To: Serguei Sagalovitch <serguei.sagalovitch@amd.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Haggai Eran <haggaie@mellanox.com>
References: <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <20161125193252.GC16504@obsidianresearch.com>
 <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
 <20161128165751.GB28381@obsidianresearch.com>
 <f3bb8372-ae2e-2f5e-5505-4ecaddbfb16e@deltatee.com>
 <0d3d56e2-4d2b-85b7-9487-b7ae2aaea610@amd.com>
Cc: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
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
        Max Gurtovoy <maxg@mellanox.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <c8c25265-9f59-f3d6-6249-07500e73930e@deltatee.com>
Date: Mon, 28 Nov 2016 14:36:49 -0700
MIME-Version: 1.0
In-Reply-To: <0d3d56e2-4d2b-85b7-9487-b7ae2aaea610@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 28/11/16 12:35 PM, Serguei Sagalovitch wrote:
> As soon as PeerDirect mapping is called then GPU must not "move" the
> such memory.  It is by PeerDirect design. It is similar how it is works
> with system memory and RDMA MR: when "get_user_pages" is called then the
> memory is pinned.

We haven't touch this in a long time and perhaps it changed, but there
definitely was a call back in the PeerDirect API to allow the GPU to
invalidate the mapping. That's what we don't want.

Logan

