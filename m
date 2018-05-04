Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:36527 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751324AbeEDPoT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 11:44:19 -0400
Date: Fri, 4 May 2018 17:44:06 +0200
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
Message-ID: <20180504154406.djxq6wqil3dwutvw@flea>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
 <20180419154536.17846-5-paul.kocialkowski@bootlin.com>
 <20180420073908.nkcbsdxibnzkqski@flea>
 <82057e2f734137a3902d9313c228b01ceb345ee7.camel@bootlin.com>
 <20180504084008.h6p4brari3xrbv6l@flea>
 <e8cd340605ab4db8ebf2888a4fce645e8bc481d0.camel@bootlin.com>
 <20180504091555.idgtzey53lozj2uh@flea>
 <fc064c3f1534a6082dc2b4e18454e054b53e5aee.camel@bootlin.com>
 <20180504134033.wngpe5scyisreonn@flea>
 <dd6b502c66aad1fe34eb0b16a1e44a4ebfd172f1.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bufjwml43ljuvt67"
Content-Disposition: inline
In-Reply-To: <dd6b502c66aad1fe34eb0b16a1e44a4ebfd172f1.camel@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bufjwml43ljuvt67
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 04, 2018 at 03:57:48PM +0200, Paul Kocialkowski wrote:
> On Fri, 2018-05-04 at 15:40 +0200, Maxime Ripard wrote:
> > On Fri, May 04, 2018 at 02:04:38PM +0200, Paul Kocialkowski wrote:
> > > On Fri, 2018-05-04 at 11:15 +0200, Maxime Ripard wrote:
> > > > On Fri, May 04, 2018 at 10:47:44AM +0200, Paul Kocialkowski wrote:
> > > > > > > > > +			reg =3D <0x01c0e000 0x1000>;
> > > > > > > > > +			memory-region =3D <&ve_memory>;
> > > > > > > >=20
> > > > > > > > Since you made the CMA region the default one, you don't
> > > > > > > > need
> > > > > > > > to
> > > > > > > > tie
> > > > > > > > it to that device in particular (and you can drop it being
> > > > > > > > mandatory
> > > > > > > > from your binding as well).
> > > > > > >=20
> > > > > > > What if another driver (or the system) claims memory from
> > > > > > > that
> > > > > > > zone
> > > > > > > and
> > > > > > > that the reserved memory ends up not being available for the
> > > > > > > VPU
> > > > > > > anymore?
> > > > > > >=20
> > > > > > > Acccording to the reserved-memory documentation, the
> > > > > > > reusable
> > > > > > > property
> > > > > > > (that we need for dmabuf) puts a limitation that the device
> > > > > > > driver
> > > > > > > owning the region must be able to reclaim it back.
> > > > > > >=20
> > > > > > > How does that work out if the CMA region is not tied to a
> > > > > > > driver
> > > > > > > in
> > > > > > > particular?
> > > > > >=20
> > > > > > I'm not sure to get what you're saying. You have the property
> > > > > > linux,cma-default in your reserved region, so the behaviour
> > > > > > you
> > > > > > described is what you explicitly asked for.
> > > > >=20
> > > > > My point is that I don't see how the driver can claim back (part
> > > > > of)
> > > > > the
> > > > > reserved area if the area is not explicitly attached to it.
> > > > >=20
> > > > > Or is that mechanism made in a way that all drivers wishing to
> > > > > use
> > > > > the
> > > > > reserved memory area can claim it back from the system, but
> > > > > there is
> > > > > no
> > > > > priority (other than first-come first-served) for which drivers
> > > > > claims
> > > > > it back in case two want to use the same reserved region (in a
> > > > > scenario
> > > > > where there isn't enough memory to allow both drivers)?
> > > >=20
> > > > This is indeed what happens. Reusable is to let the system use the
> > > > reserved memory for things like caches that can easily be dropped
> > > > when
> > > > a driver wants to use the memory in that reserved area. Once that
> > > > memory has been allocated, there's no claiming back, unless that
> > > > memory segment was freed of course.
> > >=20
> > > Thanks for the clarification. So in our case, perhaps the best fit
> > > would
> > > be to make that area the default CMA pool so that we can be ensured
> > > that
> > > the whole 96 MiB is available for the VPU and that no other consumer
> > > of
> > > CMA will use it?
> >=20
> > The best fit for what use case ? We already discussed this, and I
> > don't see any point in having two separate CMA regions. If you have a
> > reasonably sized region that will accomodate for both the VPU and
> > display engine, why would we want to split them?
>=20
> The use case I have in mind is boilerplate use of the VPU with the
> display engine, say with DMAbuf.
>=20
> It wasn't exactly clear in my memory whether we had decided that the CMA
> pool we use for the VPU should also be used for other CMA consumers (I
> realize that this is what we've been doing all along by having
> linux,cma-default; though).
>=20
> The fact that the memory region will accomodate for both the display
> engine and the VPU is not straightforward IMO and I think this has to be
> an explicit choice that we take. I was under the impression that we
> chose the 96 MiB because that's what the Allwinner reference code does.
> Does the reference code also use this pool for display?

Yes

> I liked the idea of having 96 MiB fully reserved to the VPU because it
> allows us to provide a limit on the use case, such as "this guarantees N
> buffers for resolution foo in format bar". If the display engine also
> uses it, then the limit also depends on how many GEM buffers are
> allocated (unless I'm missing something).

This also guarantees that you take away a fifth of the RAM on some
boards. If we had yet another CMA pool of 64MB as is the multi_v7
defconfig, that's a third of your RAM that's gone, possibly for no
particular reason.

If we make the math, let's say that we are running a system with 4
planes used in 1080p, with 4 Bpp, in double buffering (which is
already an unlikely setup). Let's add on top of that that we're
decoding a 1080p video with 8 buffers pre-allocated with 2Bpp (in
YUV422). Which really seems extreme now :)

And we're at 80MB. My guess is that your memory bus is going to be
dead before you need to use all that memory.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--bufjwml43ljuvt67
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrsf8UACgkQ0rTAlCFN
r3RTwBAAkCBZ06EaJDp66jvexpX+rA++nZr1EDR2LbhAn942QJD3qxsojAInH0bO
9qimkU1IzP5fhDl6FPhdNBQ9u4dYvZRjTXaa3ccpjuUlbaEzOYaPVpX1sAKIxDu1
OVZUrkDluWRcEi7c2oeAjUpdZMXedegChoT1uW55HGS+rHHeEyU9tTOiS6PqmCRf
mtwh1xzbsFDVyvAG+K76KJNFCRCqF35olt1feXxrR0+BfvopoTjYel+HK2WFHJwb
wh2P7bdSLz4xLpUV2Eag3PhC4HHirxW3up9PEJWnLh7iMWA1gaoc7rTaFYFs0o+P
L5QoxSUjp11gaY37fTJtw4BW4ooWMibLmaXzTnlI3lR6CSyezl0OLRXGvO31at3G
h0UC75m4iJ8TFzxuILyWxev/vr5lhoUqX+Z2IOMof1dC2R4zrRHdMzUJEfJ/CiVC
26R6jUli+Sjg61fcvJzWOvj5b+o1qWBL3Xw2vfLvIMoTOF0umbPDpKvUL40KfoGP
TjMrlbhKay1bHPwOQFTkr99ZH0yyTTYycRvOnJUTD2pKov17DfLMq6K4vvKORaIR
G+hp4vkqIbawoJRlNs3fAD8IkzHtruN1m2nLQrunS4hOU5sXLY3V/WkxT/QLNnb5
l0I3LWvwdarzwj8g3tejclvtJ4Fm9Inv4JbBc1RT5LRUprkV6oc=
=03hu
-----END PGP SIGNATURE-----

--bufjwml43ljuvt67--
