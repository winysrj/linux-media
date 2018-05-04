Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53220 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750709AbeEDIzu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 04:55:50 -0400
Message-ID: <5f7961d548b4d27eab8e0bd6bcfc35ea70e2d79b.camel@bootlin.com>
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
Date: Fri, 04 May 2018 10:54:18 +0200
In-Reply-To: <e8cd340605ab4db8ebf2888a4fce645e8bc481d0.camel@bootlin.com>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
         <20180419154536.17846-5-paul.kocialkowski@bootlin.com>
         <20180420073908.nkcbsdxibnzkqski@flea>
         <82057e2f734137a3902d9313c228b01ceb345ee7.camel@bootlin.com>
         <20180504084008.h6p4brari3xrbv6l@flea>
         <e8cd340605ab4db8ebf2888a4fce645e8bc481d0.camel@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-nNmSDE07s9p6POYMMwU2"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-nNmSDE07s9p6POYMMwU2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-05-04 at 10:47 +0200, Paul Kocialkowski wrote:
> > > > Don't you also need to map the SRAM on the A20?
> > >=20
> > > That's a good point, there is currently no syscon handle for A20
> > > (and
> > > also A13). Maybe SRAM is muxed to the VE by default so it "just
> > > works"?=20

I just checked on the manual and it appears that SRAM Area C1 is muxed
to the VE at reset, so we can probably keep things as-is until the SRAM
driver is ready to handle explicitly muxing that area to the VE.

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-nNmSDE07s9p6POYMMwU2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrsH7oACgkQ3cLmz3+f
v9Gjzwf/VJIPyfbLP57WySJ3jDDD22f6uslLoKf/Jc3wmwMDAAcuEE+5yWOhx5ih
9xHkkQSJMLZBry9FkSQ2JFQz58shk/uDDCP4QWFXKHbAuALMSfqf4iX+SFQV8Nun
lNB4ccI3NhVSvG9YS6QSUHMGd4+hBPTpdRlYigZ0DCD089E4ftldhNKdWQQWT7nW
SuaGAE9vBwpt/aEvOO26xnPD2oq/wjTkboh82X+BW2Uw6bKJnZ49Dec6uKMGFBP0
ZyiV/vlggjBvaCcH8LKB7sATWQ97S1yVyC4GCXs9g7EHrN2Su9qyauivkEw/eErI
otMRSx1PFmPftpXL7jqVoU1HqAAxgw==
=nOQ+
-----END PGP SIGNATURE-----

--=-nNmSDE07s9p6POYMMwU2--
