Return-path: <linux-media-owner@vger.kernel.org>
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: 'Haggai Eran' <haggaie@mellanox.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "logang@deltatee.com" <logang@deltatee.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>
Subject: RE: Enabling peer to peer device transactions for PCIe devices
Date: Wed, 30 Nov 2016 17:10:53 +0000
Message-ID: <MWHPR12MB1694CF1A306B61BEEBFC77EFF78C0@MWHPR12MB1694.namprd12.prod.outlook.com>
References: <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <20161125193252.GC16504@obsidianresearch.com>
 <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
 <20161128165751.GB28381@obsidianresearch.com>
 <1480357179.19407.13.camel@mellanox.com>
 <20161128190244.GA21975@obsidianresearch.com>
 <c0ddccf3-52ce-d883-a57a-70d8a1febf85@mellanox.com>
In-Reply-To: <c0ddccf3-52ce-d883-a57a-70d8a1febf85@mellanox.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Haggai Eran [mailto:haggaie@mellanox.com]
> Sent: Wednesday, November 30, 2016 5:46 AM
> To: Jason Gunthorpe
> Cc: linux-kernel@vger.kernel.org; linux-rdma@vger.kernel.org; linux-
> nvdimm@ml01.01.org; Koenig, Christian; Suthikulpanit, Suravee; Bridgman,
> John; Deucher, Alexander; Linux-media@vger.kernel.org;
> dan.j.williams@intel.com; logang@deltatee.com; dri-
> devel@lists.freedesktop.org; Max Gurtovoy; linux-pci@vger.kernel.org;
> Sagalovitch, Serguei; Blinzer, Paul; Kuehling, Felix; Sander, Ben
> Subject: Re: Enabling peer to peer device transactions for PCIe devices
>=20
> On 11/28/2016 9:02 PM, Jason Gunthorpe wrote:
> > On Mon, Nov 28, 2016 at 06:19:40PM +0000, Haggai Eran wrote:
> >>>> GPU memory. We create a non-ODP MR pointing to VRAM but rely on
> >>>> user-space and the GPU not to migrate it. If they do, the MR gets
> >>>> destroyed immediately.
> >>> That sounds horrible. How can that possibly work? What if the MR is
> >>> being used when the GPU decides to migrate?
> >> Naturally this doesn't support migration. The GPU is expected to pin
> >> these pages as long as the MR lives. The MR invalidation is done only =
as
> >> a last resort to keep system correctness.
> >
> > That just forces applications to handle horrible unexpected
> > failures. If this sort of thing is needed for correctness then OOM
> > kill the offending process, don't corrupt its operation.
> Yes, that sounds fine. Can we simply kill the process from the GPU driver=
?
> Or do we need to extend the OOM killer to manage GPU pages?

Christian sent out an RFC patch a while back that extended the OOM to cover=
 memory allocated for the GPU:
https://lists.freedesktop.org/archives/dri-devel/2015-September/089778.html

Alex

>=20
> >
> >> I think it is similar to how non-ODP MRs rely on user-space today to
> >> keep them correct. If you do something like madvise(MADV_DONTNEED)
> on a
> >> non-ODP MR's pages, you can still get yourself into a data corruption
> >> situation (HCA sees one page and the process sees another for the same
> >> virtual address). The pinning that we use only guarentees the HCA's pa=
ge
> >> won't be reused.
> >
> > That is not really data corruption - the data still goes where it was
> > originally destined. That is an application violating the
> > requirements of a MR.
> I guess it is a matter of terminology. If you compare it to the ODP case
> or the CPU case then you usually expect a single virtual address to map t=
o
> a single physical page. Violating this cause some of your writes to be dr=
opped
> which is a data corruption in my book, even if the application caused it.
>=20
> > An application cannot munmap/mremap a VMA
> > while a non ODP MR points to it and then keep using the MR.
> Right. And it is perfectly fine to have some similar requirements from th=
e
> application
> when doing peer to peer with a non-ODP MR.
>=20
> > That is totally different from a GPU driver wanthing to mess with
> > translation to physical pages.
> >
> >>> From what I understand we are not really talking about kernel p2p,
> >>> everything proposed so far is being mediated by a userspace VMA, so
> >>> I'd focus on making that work.
> >
> >> Fair enough, although we will need both eventually, and I hope the
> >> infrastructure can be shared to some degree.
> >
> > What use case do you see for in kernel?
> Two cases I can think of are RDMA access to an NVMe device's controller
> memory buffer, and O_DIRECT operations that access GPU memory.
> Also, HMM's migration between two GPUs could use peer to peer in the
> kernel,
> although that is intended to be handled by the GPU driver if I understand
> correctly.
>=20
> > Presumably in-kernel could use a vmap or something and the same basic
> > flow?
> I think we can achieve the kernel's needs with ZONE_DEVICE and DMA-API
> support
> for peer to peer. I'm not sure we need vmap. We need a way to have a
> scatterlist
> of MMIO pfns, and ZONE_DEVICE allows that.
>=20
> Haggai
