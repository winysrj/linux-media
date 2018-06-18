Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:46270 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751704AbeFRQCD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 12:02:03 -0400
Date: Mon, 18 Jun 2018 18:01:50 +0200
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
Subject: Re: [PATCH v4 03/19] dt-bindings: sram: sunxi: Add A13 binding for
 the C1 SRAM region
Message-ID: <20180618160150.cowgucupmsm47tl7@flea>
References: <20180618145843.14631-1-paul.kocialkowski@bootlin.com>
 <20180618145843.14631-4-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4bghc2ietqyeucl6"
Content-Disposition: inline
In-Reply-To: <20180618145843.14631-4-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4bghc2ietqyeucl6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 18, 2018 at 04:58:27PM +0200, Paul Kocialkowski wrote:
> This introduces a dedicated binding for the C1 SRAM region for the A13
> sunxi platform.
>=20
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>=20
> diff --git a/Documentation/devicetree/bindings/sram/sunxi-sram.txt b/Docu=
mentation/devicetree/bindings/sram/sunxi-sram.txt
> index 5af5bafd5572..ddc82cbd7f4d 100644
> --- a/Documentation/devicetree/bindings/sram/sunxi-sram.txt
> +++ b/Documentation/devicetree/bindings/sram/sunxi-sram.txt
> @@ -32,6 +32,9 @@ The valid sections compatible for A10 are:
>      - allwinner,sun4i-a10-sram-c1
>      - allwinner,sun4i-a10-sram-d
> =20
> +The valid sections compatible for A13 are:
> +    - allwinner,sun5i-a13-sram-c1

It supports more SRAM than that, namely the SRAM A3-A4, C1 and D, at
least.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--4bghc2ietqyeucl6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlsn124ACgkQ0rTAlCFN
r3SvQA/+Iw9jjksH/IgnN9KPIcnWIeqr9rZC6PInBUCNmGP+bJ79yYFB2U6rbuHd
OUseTfvdNHrHoe73LXn4HOIUIdMxjSLQzvY9sAMyr0OEeg66/ZcqG7NhgIJWr4JI
zTMpC1jCDPAFTumhHhAZUeMRBPlvEy27PAYXWBbMJ5WWCO81FBSh7KBIN0yU1T6S
C9YtDAnZTeOsnIvrPwKlWBD06vXjpNfohBTapbpaJefmByZ3ayR+U50N5i7pgewN
IJOJWgEATcAP4vkDkxgykkNMxXPJ1B9/yxttEahindbUMES5MCfejiuA8sjqcdW6
wOncBz6FhRBQX6YsBb2vtQY623tUiEVITp9q2578TF+5aCdtKwnsNh+3AoN+DcaM
irmW9VG6c2Sx1DzHrjBixjFPqtJV7ncl0AuhRLhHCmbQPut8VbgiJw3gvfdsh+d4
sjdGT6x/mBcKyGdA9t++dzojFqgDUuEagLjEvBDoDOygTmah8URiP7UQWO9nl0ct
ojnG505c1qaaIBhcX7I4wpVsPFIu5m6MYzI7bl1FSmAnWtNuD0x+i8oLyZ7zw0YR
UdqlTf0mipMevdBqhsXdAsZ74rgcydPkEfS02GIBF0A8T8PXtr6HWuEY6/IwszTi
+z49dL8gYUhEBY3zcNIxqMmRKkWUU2oJvM9p4MHjWbYptlqiEvo=
=2GOu
-----END PGP SIGNATURE-----

--4bghc2ietqyeucl6--
