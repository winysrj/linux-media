Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7435 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbeDYHnp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 03:43:45 -0400
Date: Wed, 25 Apr 2018 09:43:38 +0200
From: Thierry Reding <treding@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Daniel Vetter <daniel@ffwll.ch>,
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
Message-ID: <20180425074338.GB2271@ulmo>
References: <20180420124625.GA31078@infradead.org>
 <20180420152111.GR31310@phenom.ffwll.local>
 <20180424184847.GA3247@infradead.org>
 <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org>
 <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
 <20180425064335.GB28100@infradead.org>
 <CAKMK7uGF7p5ko=i6zL4dn0qR-5TVRKMi6xaCGSao_vyfJU+dWQ@mail.gmail.com>
 <20180425070905.GA24827@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20180425070905.GA24827@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 25, 2018 at 12:09:05AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 25, 2018 at 09:02:17AM +0200, Daniel Vetter wrote:
> > Can we please not nack everything right away? Doesn't really motivate
> > me to show you all the various things we're doing in gpu to make the
> > dma layer work for us. That kind of noodling around in lower levels to
> > get them to do what we want is absolutely par-for-course for gpu
> > drivers. If you just nack everything I point you at for illustrative
> > purposes, then I can't show you stuff anymore.
>=20
> No, it's not.  No driver (and that includes the magic GPUs) has
> any business messing with dma ops directly.
>=20
> A GPU driver imght have a very valid reason to disable the IOMMU,
> but the code to do so needs to be at least in the arch code, maybe
> in the dma-mapping/iommu code, not in the driver.
>=20
> As a first step to get the discussion started we'll simply need
> to move the code Thierry wrote into a helper in arch/arm and that
> alone would be a massive improvement.  I'm not even talking about
> minor details like actually using arm_get_dma_map_ops instead
> of duplicating it.
>=20
> And doing this basic trivial work really helps to get this whole
> mess under control.

That's a good idea and I can prepare patches for this, but I'd like to
make those changes on top of the fix to keep the option of getting this
into v4.16 if at all possible.

Thierry

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlrgMaoACgkQ3SOs138+
s6ErIw/9HFD80SMNmmYDdnDExj7GI+wX3JQtrnVIcvE0xhgwvEGghdvwuIitFnhe
0sSTzNFY1R3uZp+csLeMOjb7aBqI+txD+aX+KmGcdNLT015nMt/gOUjv/msbzuyN
y6gUXvEqqvByVOTuM/nrjPZhA+8PCB0n2UVfx9V7Z5FkraLvQnCiGxd+ds+tujvy
WhYItT846t9fgeiuSm2pmN/I7b8pBBMoQrA2y4h8zhuK6DI6hEC5xrd1Ebv2eMNq
yLPpWYqWokPvvlzcDbVTxQZEAY7PyAjB22DKMnQN5pgh9lrczDSVq89wmzsO4VKz
ajcglwDU7Z1of7HM1PbmgKGKwaB7zC6d0XD7wF0oUDtMYrnXbRUcAS9Lra2a39xf
u5I/8ehFct/uEkaDqgguMZDPKBEfeDEZ70DGHuSuebonUyYTupQZCCP4pSw+gPQi
7zlcoxbfO5Tp44mioLGgoMmwVfb6oIIvPLx5SueBOonSV172x2TqCYM4odsL8B7b
vYBMQgrcS95kar3smWMRf9VBT7n0EGW8G/3XgJM3hL5j/mMIJca7xXdKjuuc38Fn
wRIYQ/4znL5J8DQ7mkP2Ujv74O4Qq9nunVm+WL10JEKxbmqExGYwTH8dV/kYqPJy
Z9O+6FYV7u9PxvUDNIW0Hm/ruE+DqaTg/Vn4Hhd/8lnCmwWrcPo=
=PmGP
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
