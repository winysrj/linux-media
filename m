Return-path: <linux-media-owner@vger.kernel.org>
From: "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Logan Gunthorpe <logang@deltatee.com>
CC: Dan Williams <dan.j.williams@intel.com>,
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
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>,
        Haggai Eran <haggaie@mellanox.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Thu, 24 Nov 2016 00:40:37 +0000
Message-ID: <SN1PR12MB0703CE07F4878243164299C4FEB70@SN1PR12MB0703.namprd12.prod.outlook.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>,<20161123215510.GA16311@obsidianresearch.com>
In-Reply-To: <20161123215510.GA16311@obsidianresearch.com>
Content-Language: en-CA
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 23, 2016 at 02:11:29PM -0700, Logan Gunthorpe wrote:

> Perhaps I am not following what Serguei is asking for, but I
> understood the desire was for a complex GPU allocator that could
> migrate pages between GPU and CPU memory under control of the GPU
> driver, among other things. The desire is for DMA to continue to work
> even after these migrations happen.

The main issue is to  how to solve use cases when p2p is=20
requested/initiated via CPU pointers where such pointers could=20
point to non-system memory location e.g.  VRAM. =20

It will allow to provide consistent working model for user to deal only
with pointers (HSA, CUDA, OpenCL 2.0 SVM) as well as provide=20
performance optimization avoiding double-buffering and extra special code=20
when dealing with PCIe device memory.

 Examples are:

 - RDMA Network operations.  RDMA MRs where registered memory=20
could be e.g. VRAM.  Currently it is solved using so called PeerDirect =20
interface which  is currently out-of-tree and  provided as part of OFED.
- File operations (fread/fwrite) when user wants to transfer file data dire=
ctly=20
to/from e.g. VRAM


Challenges are:
- Because graphics sub-system must support overcomit (at least each=20
application/process should independently see all resources) ideally=20
such memory should be movable without changing CPU pointer value
as well as "paged-out" supporting "page fault" at least on access from=20
CPU.
 - We must co-exist with existing DRM infrastructure, as well as=20
support sharing VRAM memory between different processes
- We should be able to deal with large allocations: tens, hundreds of=20
MBs or may be GBs.
- We may have PCIe devices where p2p may not work
- Potentially any GPU memory should be supported including=20
memory carved out from system RAM (e.g. allocated via
get_free_pages()).


Note:
-  In the case of RDMA MRs life-span of "pinning"=20
(get_user_pages"/put_page) may be defined/controlled by=20
application not kernel which  may be should=20
treated differently as special case.=20
 =20

Original proposal was to create "struct pages" for VRAM memory=20
to allow "get_user_pages"  to work transparently similar=20
how it is/was done for "DAX Device" case. Unfortunately=20
based on my understanding "DAX Device" implementation=20
deal only with permanently  "locked" memory  (fixed location)=20
unrelated to "get_user_pages"/"put_page" scope =20
which doesn't satisfy requirements  for "eviction" / "moving" of=20
memory keeping CPU address intact. =20

> The desire is for DMA to continue to work
> even after these migrations happen
At least some kind of mm notifier callback to inform about changing=20
in location (pre- and post-) similar how it is done for system pages.=20
My understanding is that It will not solve RDMA MR issue where "lock"=20
could be during the whole  application life but  (a) it will not make=20
RDMA MR case worse  (b) should be enough for all other cases for=20
"get_user_pages"/"put_page" controlled by  kernel.
=20
 =
