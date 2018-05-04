Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53941 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751001AbeEDJP5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 05:15:57 -0400
Date: Fri, 4 May 2018 11:15:55 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
Subject: Re: [PATCH v2 09/10] ARM: dts: sun7i-a20: Add Video Engine and
 reserved memory nodes
Message-ID: <20180504091555.idgtzey53lozj2uh@flea>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
 <20180419154536.17846-5-paul.kocialkowski@bootlin.com>
 <20180420073908.nkcbsdxibnzkqski@flea>
 <82057e2f734137a3902d9313c228b01ceb345ee7.camel@bootlin.com>
 <20180504084008.h6p4brari3xrbv6l@flea>
 <e8cd340605ab4db8ebf2888a4fce645e8bc481d0.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lg266mocsnmqmuk4"
Content-Disposition: inline
In-Reply-To: <e8cd340605ab4db8ebf2888a4fce645e8bc481d0.camel@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lg266mocsnmqmuk4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 04, 2018 at 10:47:44AM +0200, Paul Kocialkowski wrote:
> > > > > +			reg =3D <0x01c0e000 0x1000>;
> > > > > +			memory-region =3D <&ve_memory>;
> > > >=20
> > > > Since you made the CMA region the default one, you don't need to
> > > > tie
> > > > it to that device in particular (and you can drop it being
> > > > mandatory
> > > > from your binding as well).
> > >=20
> > > What if another driver (or the system) claims memory from that zone
> > > and
> > > that the reserved memory ends up not being available for the VPU
> > > anymore?
> > >=20
> > > Acccording to the reserved-memory documentation, the reusable
> > > property
> > > (that we need for dmabuf) puts a limitation that the device driver
> > > owning the region must be able to reclaim it back.
> > >=20
> > > How does that work out if the CMA region is not tied to a driver in
> > > particular?
> >=20
> > I'm not sure to get what you're saying. You have the property
> > linux,cma-default in your reserved region, so the behaviour you
> > described is what you explicitly asked for.
>=20
> My point is that I don't see how the driver can claim back (part of) the
> reserved area if the area is not explicitly attached to it.
>=20
> Or is that mechanism made in a way that all drivers wishing to use the
> reserved memory area can claim it back from the system, but there is no
> priority (other than first-come first-served) for which drivers claims
> it back in case two want to use the same reserved region (in a scenario
> where there isn't enough memory to allow both drivers)?

This is indeed what happens. Reusable is to let the system use the
reserved memory for things like caches that can easily be dropped when
a driver wants to use the memory in that reserved area. Once that
memory has been allocated, there's no claiming back, unless that
memory segment was freed of course.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--lg266mocsnmqmuk4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrsJMoACgkQ0rTAlCFN
r3TOlw//aE2dU8svsZ2NIWYkNcyDnOnF0RDi5zxBPpErhmSWmQeJv5JTmvQrRrCn
q+o195rcU613Rx1KgLr2rmR8GyP2NP7I+sTRwA7T297ycU3grJrhRXuSDu8g7ZzK
vQPWw/3A6m3SxX3WMm3FHjrizU78V2Jr4N5VFfwgOwS30W9vL7UKxjiIQm1cqHut
gUuklM45Mj0i2bHesS9uU3YX/z7nlAkhy16wup9RSbyCuPfKqFmLyL6sB7CJztEP
ygw5CEOAZAUYcoVWLWQYKoFDn4/MfOmYyKc7448g5qnSToS7nC2nS9gmuY9OjLYY
9vOP+wwCGFIAu9ikytpvRsDUQYYxwuRUxenlSRAN/TeNOlYZDHy50sT3UDklVG7G
6pfyAm/OMDNWzT7vipCPcUenUOvQGLRsPqyhbAwEtBCc1bton20Z09UNFtfJIGs4
Sxw4+agcrF3I1YsrL8e91oVCUqMMVcehoIkARHyuVwQuE02fA1qpE1sUvVM4T9ES
HCmzW/KTXNRKBrzRYt5SsiS2O/v3Wem3af/kVarPXugmgpolkL7cMwRRr/A6IrnH
j+NvpT3lXIe277Ox69YhXOMxOzLZ68JYD4AcNO1WIubD24ROi7Po4L3j83yEO5gP
nNPSt8CI7AxobNwNWm9KnUflJS41KH3KBVOuIk0H0LZn1ucWhoI=
=o/bZ
-----END PGP SIGNATURE-----

--lg266mocsnmqmuk4--
