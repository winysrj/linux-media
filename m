Return-path: <linux-media-owner@vger.kernel.org>
From: Haggai Eran <haggaie@mellanox.com>
To: "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "Suravee.Suthikulpanit@amd.com" <Suravee.Suthikulpanit@amd.com>,
        "John.Bridgman@amd.com" <John.Bridgman@amd.com>,
        "Alexander.Deucher@amd.com" <Alexander.Deucher@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "logang@deltatee.com" <logang@deltatee.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Max Gurtovoy" <maxg@mellanox.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "serguei.sagalovitch@amd.com" <serguei.sagalovitch@amd.com>,
        "Paul.Blinzer@amd.com" <Paul.Blinzer@amd.com>,
        "Felix.Kuehling@amd.com" <Felix.Kuehling@amd.com>,
        "ben.sander@amd.com" <ben.sander@amd.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Mon, 28 Nov 2016 18:19:40 +0000
Message-ID: <1480357179.19407.13.camel@mellanox.com>
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
In-Reply-To: <20161128165751.GB28381@obsidianresearch.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <15C391010025F34496D3F092DA4A205C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2016-11-28 at 09:57 -0700, Jason Gunthorpe wrote:
+AD4- On Sun, Nov 27, 2016 at 04:02:16PM +-0200, Haggai Eran wrote:
+AD4- +AD4- I think blocking mmu notifiers against something that is basica=
lly
+AD4- +AD4- controlled by user-space can be problematic. This can block thi=
ngs
+AD4- +AD4- like
+AD4- +AD4- memory reclaim. If you have user-space access to the device's
+AD4- +AD4- queues,
+AD4- +AD4- user-space can block the mmu notifier forever.
+AD4- Right, I mentioned that..
Sorry, I must have missed it.

+AD4- +AD4- On PeerDirect, we have some kind of a middle-ground solution fo=
r
+AD4- +AD4- pinning
+AD4- +AD4- GPU memory. We create a non-ODP MR pointing to VRAM but rely on
+AD4- +AD4- user-space and the GPU not to migrate it. If they do, the MR ge=
ts
+AD4- +AD4- destroyed immediately.
+AD4- That sounds horrible. How can that possibly work? What if the MR is
+AD4- being used when the GPU decides to migrate?=20
Naturally this doesn't support migration. The GPU is expected to pin
these pages as long as the MR lives. The MR invalidation is done only as
a last resort to keep system correctness.

I think it is similar to how non-ODP MRs rely on user-space today to
keep them correct. If you do something like madvise(MADV+AF8-DONTNEED) on a
non-ODP MR's pages, you can still get yourself into a data corruption
situation (HCA sees one page and the process sees another for the same
virtual address). The pinning that we use only guarentees the HCA's page
won't be reused.

+AD4- I would not support that
+AD4- upstream without a lot more explanation..
+AD4-=20
+AD4- I know people don't like requiring new hardware, but in this case we
+AD4- really do need ODP hardware to get all the semantics people want..
+AD4-=20
+AD4- +AD4-=20
+AD4- +AD4- Another thing I think is that while HMM is good for user-space
+AD4- +AD4- applications, for kernel p2p use there is no need for that. Usi=
ng
+AD4- From what I understand we are not really talking about kernel p2p,
+AD4- everything proposed so far is being mediated by a userspace VMA, so
+AD4- I'd focus on making that work.
Fair enough, although we will need both eventually, and I hope the
infrastructure can be shared to some degree.=
