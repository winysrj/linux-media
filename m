Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41145 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbeGKIuL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 04:50:11 -0400
Date: Wed, 11 Jul 2018 10:46:56 +0200
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
Subject: Re: [PATCH v5 04/22] dt-bindings: sram: sunxi: Add A13, A20, A23 and
 H3 dedicated bindings
Message-ID: <20180711084656.4y3m7maiszewzgsz@flea>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
 <20180710080114.31469-5-paul.kocialkowski@bootlin.com>
 <CAGb2v65MO9xmKQz5LuydwqwvVB-_bbM=FeqbsRwJbh-5km9XCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7xak3bjnuzaq4fcl"
Content-Disposition: inline
In-Reply-To: <CAGb2v65MO9xmKQz5LuydwqwvVB-_bbM=FeqbsRwJbh-5km9XCQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7xak3bjnuzaq4fcl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2018 at 10:36:19PM +0800, Chen-Yu Tsai wrote:
> On Tue, Jul 10, 2018 at 4:00 PM, Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> > This introduces dedicated bindings for the system control blocks found
> > on the A13, A20, A23 and H3 sunxi platforms.
> >
> > Since the controllers on the A33 are the very same as those on the A23,
> > no specific compatible is introduced for it.
> >
> > These bindings are introduced to allow reflecting the differences that
> > exist between these controllers, that may become significant to driver
> > implementations.
> >
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>=20
> Not sure if there's a difference between A10 and A20, if you don't count
> the NMI that we have a separate node for. But anyway,
>=20
> Reviewed-by: Chen-Yu Tsai <wens@csie.org>

I've applied it, adding the A10 fallback compatible for the A20.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--7xak3bjnuzaq4fcl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAltFw/8ACgkQ0rTAlCFN
r3RG2Q//UY8tKZzpQY3u34hE+DqO8V2dQE8TFa25BgqlqD/R48vYooRoCjQiOMIF
GPAu5hZjAUxcUfx2G5A8vKXF1eZQRAPLJm8iRHMpdYztcpBCvDsvbpc7Wr2oly3t
zrS/f9l3t4lMbyx07oLU8b7WsQ1k5CmtNxpjKDbWJr2QfiVa0DoIECpx1LPfSdyM
jp5KJeDoiH3XwBPaSoojWmWX2GxiMQ4lHWLXwSwf++s8RxLTftZhRej0OJCAuAKK
Ax/wx60j3BcxvAoMtUy7wPHcvRhNOlmgKYUmynweJjqZwQfRmoh5Lr0Ec3in6hXy
ZETtN+aEx0yjzZpswRZGlsTwu2+pNwwLUlSmNkGOZscJt0r0/ncBG4Sej80P2nbb
0jbhr8v9UlJ4Ot8qsjij3ZvUX0uV4UrkK2TlMVa8Qxj5riRKQq4wclKZBqaGbP5D
C54qSJ30V7pvl3v29PmAtJudst2TMCeIP7ZB5QIhFQrK3g2OJA480hdnMo/MbIIp
OFRhhbrzEayJqqDYg8QxklpUZXAIMvOrD+8PusQsVIPyNjomwtR8ZG9fE4SFpjmq
J8Ng5/FwheWHLUYme0EkOKOn5Pmng7Y77XXR9E3VPg63a2/GYwSmLGikUFyePgAc
jBKhA3VLMsGrB5bjMpxRF4+jo4r/0yZ8qJOD2SzPx3yJi1EmpMY=
=ooSy
-----END PGP SIGNATURE-----

--7xak3bjnuzaq4fcl--
