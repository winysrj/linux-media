Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42643 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726632AbeGKJTG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 05:19:06 -0400
Date: Wed, 11 Jul 2018 11:15:43 +0200
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
Subject: Re: [PATCH v5 14/22] ARM: sun8i-h3: Add SRAM controller node and C1
 SRAM region
Message-ID: <20180711091543.f36t3llqz6ptlcir@flea>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
 <20180710080114.31469-15-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rg7scobloivjv74w"
Content-Disposition: inline
In-Reply-To: <20180710080114.31469-15-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--rg7scobloivjv74w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2018 at 10:01:06AM +0200, Paul Kocialkowski wrote:
> This adds a SRAM controller node for the H3, with support for the C1
> SRAM region that is shared between the Video Engine and the CPU.
>=20
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Fixed the commit prefix and the compatible and applied, thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--rg7scobloivjv74w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAltFyr4ACgkQ0rTAlCFN
r3Sf9hAAgADGeEd0CSQqNNVggcxUAx8nGT3VrADg3BZ0EumKrYoYaQugNSoxIJHv
PORIDOMUvA2fzEcwufNcoJEUHPsXA51dJN8pVnv5Ybo3HOX4h5jOUdXZTZIH5ktm
2l2GfIr7Fq3z/BDLIM2wYX7d0JzsJK7wcDiI0skb/pQQbrUMVMIbyFXRpFDFkinl
A7nteOSVigB74scZDS6vOjpcKZ72ivCz4OXt2cqc6BZ0VPYCf0T4/2Y//c/jiRKw
a7plk3KzRksPdKwA/noykQDNT0653qxYfmmD2I+7d7GNB5ctdlYlbmf9VmRRp0W2
OHtYZDem4IQS2HfdBhTp6ToQSQc6jrVu4fgcENyNaTVUS/uWfkPQSzbTvNiVZwv9
iWdJc4lzN2bENFOjI24/BSpa7U5Ti4LD6y8Qc6+Fw5dZcHYMuJ9rn9zTARQTx2J3
lAquLM+1K1n7KyDc3xWhvDUSJonMxWqpE/S7T4yFIoO7A53Ax0B49PNRuE7tId4d
Gtle1EyW1Oq4ZSy+xvcwtzOap4RxgRiuyC9VdwyaGCNgcVGrOzJplT0MO6n43rff
uPXm8cd/LqrTTD6jrCrwbDFyfGUgaqUXBgWAHzNMFnVA+3hgxGqOes9bXhdBmPXh
4G1V0f/+ntFzjLC3t/n36aL3RfjR+Uh03NmjoPU/PVbQNXzIgbo=
=/dKn
-----END PGP SIGNATURE-----

--rg7scobloivjv74w--
