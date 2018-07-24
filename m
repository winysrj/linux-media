Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:36644 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388522AbeGXQEC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 12:04:02 -0400
Message-ID: <25fee2b5ad35f46ccadf56b93d1a9261c9855f97.camel@bootlin.com>
Subject: Re: [PATCH v5 18/22] media: platform: Add Sunxi-Cedrus VPU decoder
 driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Date: Tue, 24 Jul 2018 16:56:57 +0200
In-Reply-To: <20180710084223.jguogmvlwloi2utf@flea>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
         <20180710080114.31469-19-paul.kocialkowski@bootlin.com>
         <20180710084223.jguogmvlwloi2utf@flea>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-K/4/n7VHwkFtfdOG6klo"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-K/4/n7VHwkFtfdOG6klo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2018-07-10 at 10:42 +0200, Maxime Ripard wrote:
> On Tue, Jul 10, 2018 at 10:01:10AM +0200, Paul Kocialkowski wrote:
> > +static int cedrus_remove(struct platform_device *pdev)
> > +{
> > +       struct cedrus_dev *dev =3D platform_get_drvdata(pdev);
> > +
> > +       v4l2_info(&dev->v4l2_dev, "Removing " CEDRUS_NAME);
>=20
> That log is kind of pointless.

Fair enough, I'll get rid of it.

> > +static void cedrus_hw_set_capabilities(struct cedrus_dev *dev)
> > +{
> > +	unsigned int engine_version;
> > +
> > +	engine_version =3D cedrus_read(dev, VE_VERSION) >> VE_VERSION_SHIFT;
> > +
> > +	if (engine_version >=3D 0x1667)
> > +		dev->capabilities |=3D CEDRUS_CAPABILITY_UNTILED;
>=20
> The version used here would need a define, but I'm wondering if this
> is the right solution here. You are using at the same time the version
> ID returned by the register and the compatible in various places, and
> they are both redundant. If you want to base the capabilities on the
> compatible, then you can do it for all of those properties and
> capabilities, and if you want to use the version register, then you
> don't need all those compatibles but just one.
>=20
> I think that basing all our capabilities on the compatible makes more
> sense, since you need to have access to the registers in order to read
> the version register, and this changes from one SoC generation to the
> other (for example, keeping the reset line asserted would prevent you
> from reading it, and the fact that there is a reset line depends on
> the SoC).

I concur, let's move this to a compatible-based logic instead!

> > +int cedrus_hw_probe(struct cedrus_dev *dev)
> > +{
> > +	struct resource *res;
> > +	int irq_dec;
> > +	int ret;
> > +
> > +	irq_dec =3D platform_get_irq(dev->pdev, 0);
> > +	if (irq_dec <=3D 0) {
> > +		v4l2_err(&dev->v4l2_dev, "Failed to get IRQ\n");
> > +		return -ENXIO;
> > +	}
>=20
> You already have an error code returned by platform_get_irq, there's
> no point in masking it and returning -ENXIO. This can even lead to
> some bugs, for example when the error code is EPROBE_DEFER.

Right, I'll fix this and all the similar issues you mentionned.

[...]

> There's also a bunch of warnings/checks reported by checkpatch that
> should be fixed in the next iteration: the spaces after a cast, the
> NULL comparison, macros arguments precedence, parenthesis alignments
> issues, etc.)

Thanks, I'll look into that for the next revision.

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-K/4/n7VHwkFtfdOG6klo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltXPjkACgkQ3cLmz3+f
v9EuqQf/UkZE1Lr5R+25s/cm7mrjWPJBxbjbLmZ8xhsH/Ql3/pKr7pat48bV55cr
AV/voTzP2+Z6dsO9hSQwY8TK7NyhYUpMoeucKQyY+ACvPj8HbRus+iJvAuCO33XA
usE6H6xYi0KZHUxXY6ec+qQer8MABdvm4lkvX1lgbFzqjH0/fYh2Dm2Z/63wOy8B
SXagq1WEa+HVCWUl2C0wlt7rZvASEFz4HMDPLbaIz4blFzXBNRq4zJprrD30SNrc
gRq4HLeBr4Ow3qtmEdzWHisntOP+qNixyL4vBGcJDWjiZFXiRS1PfXHo1LRlAP3n
wgy0ANf4gavscU8ptot6zw/BqYOHeA==
=zp4C
-----END PGP SIGNATURE-----

--=-K/4/n7VHwkFtfdOG6klo--
