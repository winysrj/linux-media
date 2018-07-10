Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:56994 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbeGJImf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:42:35 -0400
Date: Tue, 10 Jul 2018 10:42:23 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
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
        Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: Re: [PATCH v5 18/22] media: platform: Add Sunxi-Cedrus VPU decoder
 driver
Message-ID: <20180710084223.jguogmvlwloi2utf@flea>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
 <20180710080114.31469-19-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="okv6qmpowge4nc7u"
Content-Disposition: inline
In-Reply-To: <20180710080114.31469-19-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--okv6qmpowge4nc7u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2018 at 10:01:10AM +0200, Paul Kocialkowski wrote:
> +static int cedrus_remove(struct platform_device *pdev)
> +{
> +       struct cedrus_dev *dev =3D platform_get_drvdata(pdev);
> +
> +       v4l2_info(&dev->v4l2_dev, "Removing " CEDRUS_NAME);

That log is kind of pointless.

> +static void cedrus_hw_set_capabilities(struct cedrus_dev *dev)
> +{
> +	unsigned int engine_version;
> +
> +	engine_version =3D cedrus_read(dev, VE_VERSION) >> VE_VERSION_SHIFT;
> +
> +	if (engine_version >=3D 0x1667)
> +		dev->capabilities |=3D CEDRUS_CAPABILITY_UNTILED;

The version used here would need a define, but I'm wondering if this
is the right solution here. You are using at the same time the version
ID returned by the register and the compatible in various places, and
they are both redundant. If you want to base the capabilities on the
compatible, then you can do it for all of those properties and
capabilities, and if you want to use the version register, then you
don't need all those compatibles but just one.

I think that basing all our capabilities on the compatible makes more
sense, since you need to have access to the registers in order to read
the version register, and this changes from one SoC generation to the
other (for example, keeping the reset line asserted would prevent you
=66rom reading it, and the fact that there is a reset line depends on
the SoC).

> +int cedrus_hw_probe(struct cedrus_dev *dev)
> +{
> +	struct resource *res;
> +	int irq_dec;
> +	int ret;
> +
> +	irq_dec =3D platform_get_irq(dev->pdev, 0);
> +	if (irq_dec <=3D 0) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to get IRQ\n");
> +		return -ENXIO;
> +	}

You already have an error code returned by platform_get_irq, there's
no point in masking it and returning -ENXIO. This can even lead to
some bugs, for example when the error code is EPROBE_DEFER.

(and please add a new line there).

> +	ret =3D devm_request_threaded_irq(dev->dev, irq_dec, cedrus_irq,
> +					cedrus_bh, 0, dev_name(dev->dev),
> +					dev);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to request IRQ\n");
> +		return -ENXIO;
> +	}

Same thing here, you're masking the actual error code.

> +	res =3D platform_get_resource(dev->pdev, IORESOURCE_MEM, 0);
> +	dev->base =3D devm_ioremap_resource(dev->dev, res);
> +	if (!dev->base) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to map registers\n");
> +
> +		ret =3D -EFAULT;

ENOMEM is usually returned in such a case.

> +		goto err_sram;
> +	}
> +
> +	ret =3D clk_set_rate(dev->mod_clk, CEDRUS_CLOCK_RATE_DEFAULT);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to set clock rate\n");
> +		goto err_sram;
> +	}
> +
> +	ret =3D clk_prepare_enable(dev->ahb_clk);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to enable AHB clock\n");
> +
> +		ret =3D -EFAULT;
> +		goto err_sram;

Same thing for the error code.

> +	}
> +
> +	ret =3D clk_prepare_enable(dev->mod_clk);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to enable MOD clock\n");
> +
> +		ret =3D -EFAULT;
> +		goto err_ahb_clk;

Ditto.

> +	}
> +
> +	ret =3D clk_prepare_enable(dev->ram_clk);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to enable RAM clock\n");
> +
> +		ret =3D -EFAULT;
> +		goto err_mod_clk;

Ditto.

> +	}
> +
> +	ret =3D reset_control_reset(dev->rstc);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to apply reset\n");
> +
> +		ret =3D -EFAULT;

Ditto.

There's also a bunch of warnings/checks reported by checkpatch that
should be fixed in the next iteration: the spaces after a cast, the
NULL comparison, macros arguments precedence, parenthesis alignments
issues, etc.)

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--okv6qmpowge4nc7u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAltEcW4ACgkQ0rTAlCFN
r3TqrQ//XlmctO0y2jW0/UHLJ/Ercl7EzUQBNk7890aXUuJHEpLwN9CTyWZUWyJ/
JTQux7Vrf2x7RxBjlzThdeyZ6LFfQotPI7+bal1H30QQxuClVHeZcIPxng5bzSiE
BmyKirQLr/A1iR0mG+G9ZbzSl3JzGu3UdvxW44CfVuOHiWIFHHteUIKpgJ6o/HZl
j8aIlBqqp3buurPyr2jN34fRcoOCFvItfYgIHhO8a09+Vye1KWzrhkA/hitsHISN
IxE6WzAf6KKxeSUyRFU/O2hE3tTFigts8P0InfzZ9LfMdFs3pFsCY8ViJTUM1Kga
Tb5thhFY6CkMX3duHUnK2LeEvPtvrRpeVTqY4sX3b31wmgc0u+Iw15tD2zQkiylT
rVJVnqUBHUg3bLfzmdpgAKS+fMpgn0ufoYne7wkfAiXF49du1PUd5KRaB5/MYwXZ
o9l3YREqbUYLY+6FL2Fe+sZ1MTzOIw7h4jZMP9PJuE1ILVPLjWIyDrHTSUs2rfp+
7oXBZDjpiyv1II8cnaODT+9sD0FEvMYOOh2936GaRv7kObWJFqG/XghFeieKVFjL
nFoVuytSsvUNqxF42HLS6FrDYp3yYrYYGlYCiGGoqUlNUScEU0b1a6kkRfmYvx0T
uIB56yZSXZ8DJtWmLQIg27XULzzMj0Qc9s5qMVi+mZuoXc44Sek=
=7Hqq
-----END PGP SIGNATURE-----

--okv6qmpowge4nc7u--
