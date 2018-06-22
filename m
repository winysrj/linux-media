Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:55369 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933196AbeFVOTy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 10:19:54 -0400
Date: Fri, 22 Jun 2018 16:19:41 +0200
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
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: Re: [PATCH v4 05/19] dt-bindings: sram: sunxi: Add A33 binding for
 the C1 SRAM region
Message-ID: <20180622141941.ckap4ydxqbihai6m@flea>
References: <20180618145843.14631-1-paul.kocialkowski@bootlin.com>
 <20180618145843.14631-6-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="o332dmtqsa3phzof"
Content-Disposition: inline
In-Reply-To: <20180618145843.14631-6-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--o332dmtqsa3phzof
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 18, 2018 at 04:58:29PM +0200, Paul Kocialkowski wrote:
> This introduces a dedicated binding for the C1 SRAM region for the A33
> sunxi platform.
>=20
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>=20
> diff --git a/Documentation/devicetree/bindings/sram/sunxi-sram.txt b/Docu=
mentation/devicetree/bindings/sram/sunxi-sram.txt
> index 221fa7b42c18..d8d1aac0840b 100644
> --- a/Documentation/devicetree/bindings/sram/sunxi-sram.txt
> +++ b/Documentation/devicetree/bindings/sram/sunxi-sram.txt
> @@ -38,6 +38,9 @@ The valid sections compatible for A13 are:
>  The valid sections compatible for A20 are:
>      - allwinner,sun7i-a20-sram-c1
> =20
> +The valid sections compatible for A33 are:
> +    - allwinner,sun8i-a33-sram-c1
> +

This is just a detail, but that got introduced with the A23, not the
A33, so it should be the A23 in the compatible instead. It applies for
the SRAM controller compatible too.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--o332dmtqsa3phzof
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlstBXwACgkQ0rTAlCFN
r3SbhQ//SZInlcbAXZwvlgwBAX68pwt/UhAldI8l2H76iVsvAks3s7vV7wRYylUg
BQLKbstx/v8F8qmfERtqY/ZVu0CW9/pImF5kKpwTCRWua8l4kK5qNBOYLqcbGqPU
ghrXJp1zwWrfEWpo7diaJBUCxZxJ/jeJdDftiEYLSzf7XsMgI3F6KRzV4N6hl82U
xqVU+8Ve6z25YeXnMXR5xlA1Lp/bxuxZOF/5MbkG8JwZuxJNWZzj89Rj2vVzHPQV
6umm7lq7sl2M6jFYxIQuIjTrMHZHLnNks5DmKoBaVQJbAAHLm+6LygvLs2j0ATC7
huwAWw5GBY0vHbh/pMBAWhM71FQtrc1e+TkDeZifiUJaoXrlxIo/4NujkYdjeYIR
sUZgi7KnlApv0Us/ZNfefEkwIe8BsDo+QzlNmkyJOFY2OgnChAPh9Djsli30C8rq
Zk5E41nU3Djy41jG7d8IU7oO621cpBvWKjL+6b9WsdVl7ViKa3NwcMQ4bUa0xKGw
nOr51IRhkW6pr9oDPHXI7quIbCBjzfE/OJbtEUkUuejdqvyBMqF1gwYkpvebwQr6
4PR5jtwJoQoftKXsHlkAElHke2DplG9pZPxAy+/RC8faM63qBsfzRNwuEy5o9dsu
+h/Szz3A4Yt65L5HF084ykxyZAI7IBoTcI+cDGz3M5b+tcD5dp4=
=hH7z
-----END PGP SIGNATURE-----

--o332dmtqsa3phzof--
