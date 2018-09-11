Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:37660 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbeIKMpi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 08:45:38 -0400
Date: Tue, 11 Sep 2018 09:47:23 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: Re: [GIT PULL FOR v4.20 (request_api branch)] Add Allwinner cedrus
 decoder driver
Message-ID: <20180911074723.wioe7fnm6mrxsgjt@flea>
References: <8c00abfd-3f15-eab5-7d0b-5a4f7580d1f0@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yc5lauzpmfq4coa5"
Content-Disposition: inline
In-Reply-To: <8c00abfd-3f15-eab5-7d0b-5a4f7580d1f0@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yc5lauzpmfq4coa5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Mon, Sep 10, 2018 at 10:34:53AM +0200, Hans Verkuil wrote:
> This is the cedrus Allwinner decoder driver. It is for the request_api to=
pic
> branch, but it assumes that this pull request is applied first:
> https://patchwork.linuxtv.org/patch/51889/
>=20
> The last two patches could optionally be squashed with the main driver pa=
tch:
> they fix COMPILE_TEST issues. I decided not to squash them and leave the =
choice
> to you.
>=20
> This won't fully fix the COMPILE_TEST problems, for that another patch is=
 needed:
>=20
> https://lore.kernel.org/patchwork/patch/983848/
>=20
> But that's going through another subsystem.
>=20
> Many, many thanks go to Paul for working on this, trying to keep up to da=
te with
> the Request API changes at the same time. It was a pleasure working with =
you on
> this!
>
> Regards,
>=20
> 	Hans
>=20
> The following changes since commit 051dfd971de1317626d322581546257b748ebd=
e1:
>=20
>   media-request: update documentation (2018-09-04 11:34:57 +0200)
>=20
> are available in the Git repository at:
>=20
>   git://linuxtv.org/hverkuil/media_tree.git cedrus
>=20
> for you to fetch changes up to e035b190fac3735e5f9d3c96cee5afc82aa1a94d:
>=20
>   media: cedrus: Select the sunxi SRAM driver in Kconfig (2018-09-10 10:2=
2:07 +0200)
>=20
> ----------------------------------------------------------------
> Paul Kocialkowski (13):
>       media: videobuf2-core: Rework and rename helper for request buffer =
count
>       media: v4l: Add definitions for MPEG-2 slice format and metadata
>       media: v4l: Add definition for the Sunxi tiled NV12 format
>       dt-bindings: media: Document bindings for the Cedrus VPU driver
>       media: platform: Add Cedrus VPU decoder driver
>       ARM: dts: sun5i: Add Video Engine and reserved memory nodes
>       ARM: dts: sun7i-a20: Add Video Engine and reserved memory nodes
>       ARM: dts: sun8i-a33: Add Video Engine and reserved memory nodes
>       ARM: dts: sun8i-h3: Add Video Engine and reserved memory nodes
>       media: cedrus: Fix error reporting in request validation
>       media: cedrus: Add TODO file with tasks to complete before unstaging
>       media: cedrus: Wrap PHYS_PFN_OFFSET with ifdef and add dedicated co=
mment
>       media: cedrus: Select the sunxi SRAM driver in Kconfig
>=20
>  Documentation/devicetree/bindings/media/cedrus.txt |  54 +++++
>  Documentation/media/uapi/v4l/extended-controls.rst | 176 ++++++++++++++++
>  Documentation/media/uapi/v4l/pixfmt-compressed.rst |  16 ++
>  Documentation/media/uapi/v4l/pixfmt-reserved.rst   |  15 +-
>  Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  14 +-
>  Documentation/media/videodev2.h.rst.exceptions     |   2 +
>  MAINTAINERS                                        |   7 +
>  arch/arm/boot/dts/sun5i.dtsi                       |  26 +++
>  arch/arm/boot/dts/sun7i-a20.dtsi                   |  26 +++
>  arch/arm/boot/dts/sun8i-a33.dtsi                   |  26 +++
>  arch/arm/boot/dts/sun8i-h3.dtsi                    |  25 +++

Sorry for not noticing it earlier, but we'll want to merge the
arch/arm/boot/dts/* changes through arm-soc, to reduce the merge
conflicts.

I guess we can do it through several ways, depending on what's the
most convenient for you:

  - Drop the patches in your PR,
  - Send a revert patch as an additional patch on top of your current PR
  - Or just merge the same patches in our tree and let git figure it out.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--yc5lauzpmfq4coa5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluXcwoACgkQ0rTAlCFN
r3S+WRAAiVr2LbbOjXEjlpLKYgqeaWSAN+IEbilFTgqmzrejd6qNWWs7bnKEzJcj
6ZUuQMuLYI/NfqlaJZQ+V5V9V3E3hFicI623JdgRkKGXxfsjaDqLis1PBNYuoNme
QoMGw0GAxubkg2tPYmFUPktB63231MdKNZHrq2vXOj32kyHrbISnI0RNE0vWXyn9
BGAPEPt1jk8TuAqAzPhJi1tLHSCYZ21Ub9E3MqiZrlUoRRsYaOgRE2rRHivzKhhf
2O11nrC87MFASGZokn1GfVA/JD59fCvKtNEFlISxpDWWon4YMQXl5uKKXklb+GRD
POw7iuAumuTHaU47gK0DFjtqEgGIdmFtYnjpk8YdilXLoj0vqmh3SGyzNDJKQFmp
W4g+Nduo6wrFL0YO3BsRVpLxoTPchcRr91/iBrums9RdrJhq/ApYOG3PDxt2zUsU
HxBxbmqTJWu4BrRo4XaG2pqT3JbYvqvSE3q18ROmRSQ2m8vZ96hv/EJysEFVZLRd
6Jy4fNBfHm2b5mMHKsT4TJ+ABJXOnakG5J3h99aYsd09vTmAGnq7KyiadR55nIMt
bMjBZMru/od+KZ9bwQWEXYC7AaYMMUByktr2KFtJ2mJ5DYX2vCAL9YDTUjzcW6wZ
DDtiBblPuMx+Q0eKnZcZsOYldQrsxRwqUWHuK7FXfQUTQoDwf/E=
=fX8W
-----END PGP SIGNATURE-----

--yc5lauzpmfq4coa5--
