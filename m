Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51097 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751261AbeEDIM0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 04:12:26 -0400
Date: Fri, 4 May 2018 10:12:14 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Rob Herring <robh@kernel.org>, Tomasz Figa <tfiga@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, wens@csie.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>
Subject: Re: [PATCH v2 08/10] dt-bindings: media: Document bindings for the
 Sunxi-Cedrus VPU driver
Message-ID: <20180504081214.3luailyresuq5x4z@flea>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
 <20180419154536.17846-4-paul.kocialkowski@bootlin.com>
 <1524153860.3416.9.camel@pengutronix.de>
 <CAAFQd5DT_xjUbZzFOoKk7_duiSZ8Awb1J=0dPEhVTBk0P3gppA@mail.gmail.com>
 <5fa80b1e88ad2a215f51ea3a2b9b62274fa9b1ec.camel@bootlin.com>
 <20180427030436.3ptrb2ldhtnssipj@rob-hp-laptop>
 <ce85c790b639bf9101b8c33526bdf149070bcc03.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fjsv7zqvnkrt3jk5"
Content-Disposition: inline
In-Reply-To: <ce85c790b639bf9101b8c33526bdf149070bcc03.camel@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fjsv7zqvnkrt3jk5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 04, 2018 at 09:56:20AM +0200, Paul Kocialkowski wrote:
> > > I agree that the term VPU is more commonly associated with video
> > > decoding, while video engine could mean a number of things.
> > >=20
> > > The reason I went with "video-engine" here (while still presenting
> > > the
> > > driver as a VPU driver) is that Video Engine is the term used in
> > > Allwinner's litterature. Other nodes in Allwinner device-trees
> > > generally
> > > stick to these terms (for instance, we have "display-engine" nodes).
> > > This also makes it easier to find the matching parts in the
> > > documentation.
> >=20
> > 'video-codec' is what is defined in the DT spec.
>=20
> Is that an actively-enforced guideline or a suggestion? I'd like to keep
> video-engine just to stick with the technical documentation wording and
> my personal taste is also to prefer vpu over video-codec (in terms of
> clarity/straightforwardness) as a second choice.
>=20
> Still, if the choice isn't up to me, we can go with video-codec (or
> vpu).

The unit-name is supposed to reflect the class of the device, and
nothing else. If there's already a pre-existing class name defined for
these kind of devices, then there's no point in choosing something
else.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--fjsv7zqvnkrt3jk5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrsFd0ACgkQ0rTAlCFN
r3QvAQ//Xxc8HEG57Cn/O9rEjht7eApgiZMWz/Lzf5q8HZSszSWVVtS0OKCNkdCT
ASikrOGclsjj5N+YDsboPDgdVodPy2hReSlyKDHjn5G4MVh7Lgut7XFhITWVmbKA
eZwDVp9i/5pcTXOAK5dXqgm9aBmKW8N3MhncAjg5ZOd9JqtbNtL/gHGZ75po5nWE
Cd7zgv1VYbsJQjQCyR9jS/6Ncdwf0tMm47J0Q0DpeXzhjHaArak4Mmh/oVxEqZZl
nZCFQSNXIYFQV0DLuK7/YHyPjl8Tv/E4jpFsTX079DlddlYHvoSsvgXlhhjq/pA2
uSrD29lEfOswm+6SaGvjeMjWYtDL137KcGo4vbwuu9q88SpgtQNJJHsfy10uiRJy
5+hAdM0+wfNettHGsECLMjx0JioUrDXWc62JcID3KQjeByiQ9LgsYM9GertEJoc2
FFFEzqvkO1FVpAPH8sUGz6OnmWjtvr/uRFmvE/+uJSPVjxUBT3ZdweKKmh5Ls8Bb
vQIiVEVSb3IRSrJHUyntHnYapvnJtoxkrVO0yzehaizOChBnxsFGAxY8Mu/L+Uqh
154w2EZKkwuGJHv99/yS2p0/IgJ+qY1pP5Swx9KuBy9Zs/gbwHQLobgGChq3q8MN
LmX5zeNnH0kiMc39G3W/rm2JDqoYRCwJHmOS65NJBQlSJG7FRQ4=
=A2rQ
-----END PGP SIGNATURE-----

--fjsv7zqvnkrt3jk5--
