Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41694 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933383AbeGJO6k (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 10:58:40 -0400
Date: Tue, 10 Jul 2018 16:58:28 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
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
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: Re: [PATCH v5 08/22] ARM: dts: sun4i-a10: Use system-control
 compatible
Message-ID: <20180710145828.ndrsiyb3ngnnxjk6@flea>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
 <20180710080114.31469-9-paul.kocialkowski@bootlin.com>
 <CAGb2v65JP8fBvD6Sbexjg2cv5AXVufWxjMVuOPa7J1A9qQjZ2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wutdh35tqmlryjrr"
Content-Disposition: inline
In-Reply-To: <CAGb2v65JP8fBvD6Sbexjg2cv5AXVufWxjMVuOPa7J1A9qQjZ2g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wutdh35tqmlryjrr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2018 at 10:52:39PM +0800, Chen-Yu Tsai wrote:
> On Tue, Jul 10, 2018 at 4:01 PM, Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
>=20
> Subject prefix should be "ARM: dts: sun4i:"
>=20
> We don't need the "a10" part since the A10 owns into this category
> all by itself.
>=20
> Also, it doesn't say what the system control compatible is for.
> "Switch to new system control compatible string" would be slightly
> better.
>=20
> > This switches the sun4i-a10 dtsi to use the new compatible for the
> > system-control block (previously named SRAM controller) instead of
> > the deprecated one.
> >
> > The phandle is also updated to reflect the fact that the controller
>=20
> The label actually.

Node name, actually :)

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--wutdh35tqmlryjrr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAltEyZMACgkQ0rTAlCFN
r3SUUA/8DozE70W/Zqvjbe4aTk+VB+iQYkDprijYWz07GFnv3wyFYRIJlDti5sfo
eVN9FDBxXY2t2HsujRr2aTDueZlKQAqwBcyluGmGUBkaAeI1UXKQH3fa9wsxh8Qo
4lGMfrchx1QHaBv7HqCIpbbxRebX4725s/vDGWill3UgzrXgNFSg9AOplyuv7tjZ
u+Fa0YjTVJ0vMQxpclpqMGzHRcijVDNNJaOCVt+tcKfRsnX4NFvri1aKZrf/OeoW
jVnGj9r9Tfppsiqnvu0aNpWpkEffstW1E+LcFxBz3daHnzj16diAzt+iThD3QLZ0
1TAdLzd90x2bFQ7xziCwBwr8v1r6suOSw5RboIyBgbLqlH0iFTUU1iXfoG7cNmHa
DZh7qkD3cxMn+7vEbNHNDyvgkTIIB7IsYAAj3W9MBbWt9Es7VAkTb/HUxqVIUs9A
ZTfz3TUTOaMMPJ4EtpV6zVz6qdG8lvpMD/s9m+0xw4IJtgEHh5Z0c+4ergj47mB1
QCS1r/5kFD7OVG/oPWYl24Qhcq8H2x2eXkhOoaQVBG4MgQ7qwA0kIKTo/FJDG3F4
eBOtkRoZ+tJvYnq6SZXHxwK2dyIb9Gr4gE+92OkzgKUm4Sz6CiQ+u/EyLCDWbou2
Qn7YM2f8foSPnggmxL2lWktzuhJSlI+oCnOEuQ7t1NBJ5eOXlj8=
=6knu
-----END PGP SIGNATURE-----

--wutdh35tqmlryjrr--
