Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:4441 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeDYH4u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 03:56:50 -0400
Date: Wed, 25 Apr 2018 09:56:43 +0200
From: Thierry Reding <treding@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Jerome Glisse <jglisse@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [PATCH 4/8] dma-buf: add peer2peer flag
Message-ID: <20180425075643.GC2271@ulmo>
References: <20180420152111.GR31310@phenom.ffwll.local>
 <20180424184847.GA3247@infradead.org>
 <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org>
 <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
 <20180425064335.GB28100@infradead.org>
 <CAKMK7uGF7p5ko=i6zL4dn0qR-5TVRKMi6xaCGSao_vyfJU+dWQ@mail.gmail.com>
 <20180425070905.GA24827@infradead.org>
 <20180425073039.GO25142@phenom.ffwll.local>
MIME-Version: 1.0
In-Reply-To: <20180425073039.GO25142@phenom.ffwll.local>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 25, 2018 at 09:30:39AM +0200, Daniel Vetter wrote:
> On Wed, Apr 25, 2018 at 12:09:05AM -0700, Christoph Hellwig wrote:
> > On Wed, Apr 25, 2018 at 09:02:17AM +0200, Daniel Vetter wrote:
> > > Can we please not nack everything right away? Doesn't really motivate
> > > me to show you all the various things we're doing in gpu to make the
> > > dma layer work for us. That kind of noodling around in lower levels to
> > > get them to do what we want is absolutely par-for-course for gpu
> > > drivers. If you just nack everything I point you at for illustrative
> > > purposes, then I can't show you stuff anymore.
> >=20
> > No, it's not.  No driver (and that includes the magic GPUs) has
> > any business messing with dma ops directly.
> >=20
> > A GPU driver imght have a very valid reason to disable the IOMMU,
> > but the code to do so needs to be at least in the arch code, maybe
> > in the dma-mapping/iommu code, not in the driver.
> >=20
> > As a first step to get the discussion started we'll simply need
> > to move the code Thierry wrote into a helper in arch/arm and that
> > alone would be a massive improvement.  I'm not even talking about
> > minor details like actually using arm_get_dma_map_ops instead
> > of duplicating it.
> >=20
> > And doing this basic trivial work really helps to get this whole
> > mess under control.
>=20
> Ah ok. It did sound a bit like a much more cathegorical NAK than an "ack
> in principle, but we need to shuffle the implementation into the right
> place first". In the past we generally got a principled NAK on anything
> funny we've been doing with the dma api, and the dma api maintainer
> steaming off telling us we're incompetent idiots. I guess I've been
> branded a bit on this topic :-/
>=20
> Really great that this is changing now.
>=20
> On the patch itself: It might not be the right thing in all cases, since
> for certain compression formats the nv gpu wants larger pages (easy to
> allocate from vram, not so easy from main memory), so might need the iommu
> still. But currently that's not implemented:
>=20
> https://www.spinics.net/lists/dri-devel/msg173932.html

To clarify: we do want to use the IOMMU, but we want to use it
explicitly via the IOMMU API rather than hiding it behind the DMA API.
We do the same thing in Tegra DRM where we don't want to use the DMA API
because it doesn't allow us to share the same mapping between multiple
display controllers in the same way the IOMMU API does. We've also been
thinking about using the IOMMU API directly in order to support process
isolation for devices that accept command streams from userspace.

Fortunately the issue I'm seeing with Nouveau doesn't happen with Tegra
DRM, which seems to be because we have an IOMMU group with multiple
devices and that prevents the DMA API from "hijacking" the IOMMU domain
for the group.

And to add to the confusion, none of this seems to be an issue on 64-bit
ARM where the generic DMA/IOMMU code from drivers/iommu/dma-iommu.c is
used.

Thierry

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlrgNLkACgkQ3SOs138+
s6FElA//Y4UG8175+Ww3Twe0Ng/0nU5D/3QkBRvSl+IZ1fTkAGn3XUtQVX4Ll8Wb
GbFn/WLFr87S4+E+LMBIJ526piuRzgXbLqL3X7Q8IOvx7JRWtux9iSlxznCr+hDe
L6u+d8oKoXjGotnmC9bZTWRRGkijAYojYYBkMWCrOS1TkMCgkiKc0g5kb1KisTaK
ttVUVendpNQsHMWZzPTXhVPfkBMdVvcbHdgaim1VD+NTRJaJ70S0Q0jhIgxqa18L
thYrCuJkYweE/yjlHezXo2BMGEeNTBp0khA1lXeCOp5dfv6W8Z/BcGS15OZQ+Ufg
Dl1Dwfq7WPOB7YB/KQdW4V7FI/h8gSzY4c0+oPMNvESrlqmoSGUHIHp7XV/ngL+T
Bq/pN7eKUImjMXa/wTzEUzjglRMxFpg6WEwV/7q1QDxgyoKWPKp5a3fa4qXonGIB
Qf43OcYWBqLAlpFpY03u/UUbdjwwOglZRM7Jo2p70sN90ISu6QpV/RNo26KylJJN
xEjE4CtIDRD/qHUegL6juDcC8tgCO7EPV/pqsvp6R6UmpguH0HT+TkG7TteR7lkh
CZm6xle9cx/2g7C4QMxgOHXGgFhxYQdJvwzKfm/UzFbBEs4iLk4iClYctRdnJRAz
3iWTou/HjHB3lArCebHYBEAxXMIUrUGwbFZdF+gm3BeP97e2x5o=
=M8KY
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--
