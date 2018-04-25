Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7604 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbeDYHl6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 03:41:58 -0400
Date: Wed, 25 Apr 2018 09:41:51 +0200
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
Message-ID: <20180425074151.GA2271@ulmo>
References: <20180420101755.GA11400@infradead.org>
 <f1100bd6-dd98-55a9-a92f-1cad919f235f@amd.com>
 <20180420124625.GA31078@infradead.org>
 <20180420152111.GR31310@phenom.ffwll.local>
 <20180424184847.GA3247@infradead.org>
 <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org>
 <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
 <20180425064335.GB28100@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20180425064335.GB28100@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 24, 2018 at 11:43:35PM -0700, Christoph Hellwig wrote:
> On Wed, Apr 25, 2018 at 08:23:15AM +0200, Daniel Vetter wrote:
> > For more fun:
> >=20
> > https://www.spinics.net/lists/dri-devel/msg173630.html
> >=20
> > Yeah, sometimes we want to disable the iommu because the on-gpu
> > pagetables are faster ...
>=20
> I am not on this list, but remote NAK from here.  This needs an
> API from the iommu/dma-mapping code.  Drivers have no business poking
> into these details.

The interfaces that the above patch uses are all EXPORT_SYMBOL_GPL,
which is rather misleading if they are not meant to be used by drivers
directly.

> Thierry, please resend this with at least the iommu list and
> linux-arm-kernel in Cc to have a proper discussion on the right API.

I'm certainly open to help with finding a correct solution, but the
patch above was purposefully terse because this is something that I
hope we can get backported to v4.16 to unbreak Nouveau. Coordinating
such a backport between ARM and DRM trees does not sound like something
that would help getting this fixed in v4.16.

The fundamental issue here is that the DMA/IOMMU integration is
something that has caused a number of surprising regressions in the past
because it tends to sneak in unexpectedly. For example the current
regression shows up only if CONFIG_ARM_DMA_USE_IOMMU=3Dy because the DMA
API will then transparently create a second mapping and mess things up.
Everything works fine if that option is disabled. This is ultimately why
we didn't notice, since we don't enable that option by default. I do
have a patch that I plan to apply to the Tegra tree that will always
enable CONFIG_ARM_DMA_USE_IOMMU=3Dy on Tegra to avoid any such surprises
in the future, but I can obviously only apply that once the above patch
is applied to Nouveau, otherwise we'll break Nouveau unconditionally.

Granted, this issue could've been caught with a little more testing, but
in retrospect I think it would've been a lot better if ARM_DMA_USE_IOMMU
was just enabled unconditionally if it has side-effects that platforms
don't opt in to but have to explicitly opt out of.

Thierry

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlrgMTwACgkQ3SOs138+
s6FhzxAAhAWFPLKYY1teMqCaHfPUBIUiOMRZJU7ufMMjY28rJFHHZGQoa0Tj3WzZ
2msD0RZKxdnYuRAs90G3XHtYYULICSYi3XJ31V9pLHHmptLNHmeAbzQ39lLue19L
Cc+1LozOpc99zmDTW94SdXzzoIqHzaPA0Pm+020+np6ASBxfn5jnkVTbB48Wm4WF
ug5gt+6n7jCX3jXOomaHJVeZKSCj57SIKb9YxJ7kconRU6J3zgVSaprku2yxKpeV
/ii6IdAMlb1vpFi126ssD81aJ72e2yWBwegLkn2m+exnz7BzkL2qs82ERiTYJZ8x
IeKoC8tNQcA1Ev6v8MpeUjpaGJuiTQjXXUvrBj3xh5hG+5yt8gFcRE1h4/hFHz2O
/GJwPNfWZsESd82c/uOAEGhuYiRkh85mP3JqRZOXt3xryf9tdpqGf6YI0dpE6Yle
Xc1hNRdDOKPswQxdSKoI75yRWD42fWEr2g3nY2KQO/FMZqPMq8Sp/vGzoBI1ZALH
W3f6ACLxBzrmUtLcBWWX20FoQ+wwrQefezXXljVIU8i/ZPh1Pcn9u9PCAW3FgGV6
lSdzTjsupvbC5rFvH/JL0vKcBf1UAZdctbV5preQOGBOv0qyy/mSPDUJCRhZc3M5
A5Y0hGYKZPw4EyGyA/YzsqcOFj5EmdXS5DQVoeYk/8ENbm+WEHI=
=wFUj
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
