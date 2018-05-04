Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:59508 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751229AbeEDNkf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 09:40:35 -0400
Date: Fri, 4 May 2018 15:40:33 +0200
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
Message-ID: <20180504134033.wngpe5scyisreonn@flea>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
 <20180419154536.17846-5-paul.kocialkowski@bootlin.com>
 <20180420073908.nkcbsdxibnzkqski@flea>
 <82057e2f734137a3902d9313c228b01ceb345ee7.camel@bootlin.com>
 <20180504084008.h6p4brari3xrbv6l@flea>
 <e8cd340605ab4db8ebf2888a4fce645e8bc481d0.camel@bootlin.com>
 <20180504091555.idgtzey53lozj2uh@flea>
 <fc064c3f1534a6082dc2b4e18454e054b53e5aee.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mqms3knof33f5jwx"
Content-Disposition: inline
In-Reply-To: <fc064c3f1534a6082dc2b4e18454e054b53e5aee.camel@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mqms3knof33f5jwx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 04, 2018 at 02:04:38PM +0200, Paul Kocialkowski wrote:
> On Fri, 2018-05-04 at 11:15 +0200, Maxime Ripard wrote:
> > On Fri, May 04, 2018 at 10:47:44AM +0200, Paul Kocialkowski wrote:
> > > > > > > +			reg =3D <0x01c0e000 0x1000>;
> > > > > > > +			memory-region =3D <&ve_memory>;
> > > > > >=20
> > > > > > Since you made the CMA region the default one, you don't need
> > > > > > to
> > > > > > tie
> > > > > > it to that device in particular (and you can drop it being
> > > > > > mandatory
> > > > > > from your binding as well).
> > > > >=20
> > > > > What if another driver (or the system) claims memory from that
> > > > > zone
> > > > > and
> > > > > that the reserved memory ends up not being available for the VPU
> > > > > anymore?
> > > > >=20
> > > > > Acccording to the reserved-memory documentation, the reusable
> > > > > property
> > > > > (that we need for dmabuf) puts a limitation that the device
> > > > > driver
> > > > > owning the region must be able to reclaim it back.
> > > > >=20
> > > > > How does that work out if the CMA region is not tied to a driver
> > > > > in
> > > > > particular?
> > > >=20
> > > > I'm not sure to get what you're saying. You have the property
> > > > linux,cma-default in your reserved region, so the behaviour you
> > > > described is what you explicitly asked for.
> > >=20
> > > My point is that I don't see how the driver can claim back (part of)
> > > the
> > > reserved area if the area is not explicitly attached to it.
> > >=20
> > > Or is that mechanism made in a way that all drivers wishing to use
> > > the
> > > reserved memory area can claim it back from the system, but there is
> > > no
> > > priority (other than first-come first-served) for which drivers
> > > claims
> > > it back in case two want to use the same reserved region (in a
> > > scenario
> > > where there isn't enough memory to allow both drivers)?
> >=20
> > This is indeed what happens. Reusable is to let the system use the
> > reserved memory for things like caches that can easily be dropped when
> > a driver wants to use the memory in that reserved area. Once that
> > memory has been allocated, there's no claiming back, unless that
> > memory segment was freed of course.
>=20
> Thanks for the clarification. So in our case, perhaps the best fit would
> be to make that area the default CMA pool so that we can be ensured that
> the whole 96 MiB is available for the VPU and that no other consumer of
> CMA will use it?

The best fit for what use case ? We already discussed this, and I
don't see any point in having two separate CMA regions. If you have a
reasonably sized region that will accomodate for both the VPU and
display engine, why would we want to split them?

Or did you have any experience of running out of buffers?

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--mqms3knof33f5jwx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrsYr4ACgkQ0rTAlCFN
r3QDfw/9FgjN1zE2Qdx/vj5fU28Ulwr8Hs1Zq7Wd68zc5j9CChR0UHqnmXBErKcY
qDgV8kCgmCl2fnfA1V9JV+Cec2E6+F6KxrLZv8Pg577FWvZKW4EBH+QtBx7iEFRL
nE8o0KxI/Bu8XHD4e0L/eEexk2mWMC+FWpmvZ0+fzi5to75hUeVujwYMFRjdoCTz
5+H+/2RH+vLnSLAurNJdfMU20KZ+ahqWpChwbO9nE9sFyqHDs4lhlff2zQstv32e
tp10Y5irwds6dhvoH1cVyAXZFGQ7nrHXFsHiBZZZdCXxqGb53CPVf7Q4iQUqFzMx
BW8jonZ3Coz+Y/NlgSYIAVjQdL5b8+5D1rJhsYN5CcYWhVF58acr7Yx/waB6aGX0
EfKVf/HF3L9OTok2cgFHapFZERHwm7WzPoH8kQrLK8tQID8LsqMolAzrsFJWYgvK
Gp/7AF/zBjwfUP4L4fCHJTJF9bhOU9t645pB0JwbC+0EovFKzNffCjNbIt6dxBKV
dde7b/ePI4LPxm9zF4ZQLLC41jqO3KU6KBJ2XXZipUaTjhW7WpizhFS2tZZiuUCw
UxmsQfCUf12H3EFRBOP+/Mjp+kangTSchbZ+E09VKsdJAmxrXpzw9VImlvmasgTe
l72/l+OnLG2vYy8dCpRdYQOb49ODfXqtQGPiRn8opNhhUrkqADw=
=MxQL
-----END PGP SIGNATURE-----

--mqms3knof33f5jwx--
