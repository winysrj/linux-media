Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:60278 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751984AbeEDN7X (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 09:59:23 -0400
Message-ID: <dd6b502c66aad1fe34eb0b16a1e44a4ebfd172f1.camel@bootlin.com>
Subject: Re: [PATCH v2 09/10] ARM: dts: sun7i-a20: Add Video Engine and
 reserved memory nodes
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
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
Date: Fri, 04 May 2018 15:57:48 +0200
In-Reply-To: <20180504134033.wngpe5scyisreonn@flea>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
         <20180419154536.17846-5-paul.kocialkowski@bootlin.com>
         <20180420073908.nkcbsdxibnzkqski@flea>
         <82057e2f734137a3902d9313c228b01ceb345ee7.camel@bootlin.com>
         <20180504084008.h6p4brari3xrbv6l@flea>
         <e8cd340605ab4db8ebf2888a4fce645e8bc481d0.camel@bootlin.com>
         <20180504091555.idgtzey53lozj2uh@flea>
         <fc064c3f1534a6082dc2b4e18454e054b53e5aee.camel@bootlin.com>
         <20180504134033.wngpe5scyisreonn@flea>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-mE95aWzEnbnH7U7+7hKq"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-mE95aWzEnbnH7U7+7hKq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-05-04 at 15:40 +0200, Maxime Ripard wrote:
> On Fri, May 04, 2018 at 02:04:38PM +0200, Paul Kocialkowski wrote:
> > On Fri, 2018-05-04 at 11:15 +0200, Maxime Ripard wrote:
> > > On Fri, May 04, 2018 at 10:47:44AM +0200, Paul Kocialkowski wrote:
> > > > > > > > +			reg =3D <0x01c0e000 0x1000>;
> > > > > > > > +			memory-region =3D <&ve_memory>;
> > > > > > >=20
> > > > > > > Since you made the CMA region the default one, you don't
> > > > > > > need
> > > > > > > to
> > > > > > > tie
> > > > > > > it to that device in particular (and you can drop it being
> > > > > > > mandatory
> > > > > > > from your binding as well).
> > > > > >=20
> > > > > > What if another driver (or the system) claims memory from
> > > > > > that
> > > > > > zone
> > > > > > and
> > > > > > that the reserved memory ends up not being available for the
> > > > > > VPU
> > > > > > anymore?
> > > > > >=20
> > > > > > Acccording to the reserved-memory documentation, the
> > > > > > reusable
> > > > > > property
> > > > > > (that we need for dmabuf) puts a limitation that the device
> > > > > > driver
> > > > > > owning the region must be able to reclaim it back.
> > > > > >=20
> > > > > > How does that work out if the CMA region is not tied to a
> > > > > > driver
> > > > > > in
> > > > > > particular?
> > > > >=20
> > > > > I'm not sure to get what you're saying. You have the property
> > > > > linux,cma-default in your reserved region, so the behaviour
> > > > > you
> > > > > described is what you explicitly asked for.
> > > >=20
> > > > My point is that I don't see how the driver can claim back (part
> > > > of)
> > > > the
> > > > reserved area if the area is not explicitly attached to it.
> > > >=20
> > > > Or is that mechanism made in a way that all drivers wishing to
> > > > use
> > > > the
> > > > reserved memory area can claim it back from the system, but
> > > > there is
> > > > no
> > > > priority (other than first-come first-served) for which drivers
> > > > claims
> > > > it back in case two want to use the same reserved region (in a
> > > > scenario
> > > > where there isn't enough memory to allow both drivers)?
> > >=20
> > > This is indeed what happens. Reusable is to let the system use the
> > > reserved memory for things like caches that can easily be dropped
> > > when
> > > a driver wants to use the memory in that reserved area. Once that
> > > memory has been allocated, there's no claiming back, unless that
> > > memory segment was freed of course.
> >=20
> > Thanks for the clarification. So in our case, perhaps the best fit
> > would
> > be to make that area the default CMA pool so that we can be ensured
> > that
> > the whole 96 MiB is available for the VPU and that no other consumer
> > of
> > CMA will use it?
>=20
> The best fit for what use case ? We already discussed this, and I
> don't see any point in having two separate CMA regions. If you have a
> reasonably sized region that will accomodate for both the VPU and
> display engine, why would we want to split them?

The use case I have in mind is boilerplate use of the VPU with the
display engine, say with DMAbuf.

It wasn't exactly clear in my memory whether we had decided that the CMA
pool we use for the VPU should also be used for other CMA consumers (I
realize that this is what we've been doing all along by having
linux,cma-default; though).

The fact that the memory region will accomodate for both the display
engine and the VPU is not straightforward IMO and I think this has to be
an explicit choice that we take. I was under the impression that we
chose the 96 MiB because that's what the Allwinner reference code does.
Does the reference code also use this pool for display?

I liked the idea of having 96 MiB fully reserved to the VPU because it
allows us to provide a limit on the use case, such as "this guarantees N
buffers for resolution foo in format bar". If the display engine also
uses it, then the limit also depends on how many GEM buffers are
allocated (unless I'm missing something).

> Or did you have any experience of running out of buffers?

Not yet, I haven't. I have no objection with making the reserved region
the default CMA pool and have other consumers use it too.

Cheers,

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-mE95aWzEnbnH7U7+7hKq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrsZtwACgkQ3cLmz3+f
v9EL2wf+NPCzuKNgVq3Hnr2tDKkvVTg3EG7IU8oApVHtDC5ozsXMXweu1YAgoTH1
f9efNP/op4SPm7W8srYXC242RrCkLnzva83C8M9/3ey3M/Mdfitocx3FmFI66OCK
BWfiDqOEwJzlVkVgBS05rfJolMbZZBl4STHUjRg2DB9SceFT8dj7VVZiSxrnTKNC
G14mtB7qkuDIYnbPL8pN554C44SYcLmlXJJWulreKqgeCPmHQ7h0V2yZpJXQCbR2
bniAHj056Q892FJukO7q2sSNjtNOe4gWP5DAiKLfBBCL7T5pLF7UjYFQJFnEKqe6
bAzSTMBdEb1SWUCCm7/lF7jt+BmOZA==
=0arc
-----END PGP SIGNATURE-----

--=-mE95aWzEnbnH7U7+7hKq--
