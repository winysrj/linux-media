Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:58746 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751235AbeGJJXW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 05:23:22 -0400
Date: Tue, 10 Jul 2018 11:23:10 +0200
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
Subject: Re: [PATCH v5 20/22] ARM: dts: sun7i-a20: Add Video Engine and
 reserved memory nodes
Message-ID: <20180710092310.2hzoc7shmfykr3n5@flea>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
 <20180710080114.31469-21-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mu7kkrbfxwnu6dth"
Content-Disposition: inline
In-Reply-To: <20180710080114.31469-21-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mu7kkrbfxwnu6dth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2018 at 10:01:12AM +0200, Paul Kocialkowski wrote:
> +		vpu: video-codec@1c0e000 {
> +			compatible =3D "allwinner,sun7i-a20-video-engine";
> +			reg =3D <0x01c0e000 0x1000>;
> +

The issue is here with all your patches, but you should drop the node
label and the extra new line.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--mu7kkrbfxwnu6dth
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAltEev0ACgkQ0rTAlCFN
r3QVjw/9GP7WTsxJr7ZffNM5gks3/vDZk7PDA9r+sXYULxhFDuv5YEUUtdMLfnxU
6LBw+dWz9IduAC1noxk2kLKBq5D7HFM9iE7uAprS5KyGRHqd71GtayufeKao/0Xh
3KfGTMckfFufa/WUqF/lDeiREsGGjZjvtOcu0Gh2kFefYipTTl7VJ51XBdxaaPeH
4Ypmg1j1ia/C9jsfDYZqKwlfgyY+yUyLriOFp1FVm5dmpLWURZV8YxDf0VDVjZ8c
nZp/2xooW3cdfeAY1pZgwtPudJHZ7XpoZ/FeKLat/IbeBpekm1ZBBYL+U3fN8XvG
K46IODEv+bPz446L4lYYXUXGNp+1fmZviByygVCedmf3TQ1yvEC6xz0dxmzCgUwL
JqhZvn+MaucbAakeRYVawZLXoCYMj7puhPPYTqj4vu6YtzrW+hF5zhArD2kaFXop
d44aJh2aacgVJRoStjhpfKh2WdOMNVx0lRNeqUW4VpEDPxu6rVF7l8kuWjBJCsAL
6qelyWvMGRSWCVboOB6sHIIShLd6nW9vdhsFGtj/84Nvh2y/M9vLBaWciMbrlpyI
mWsdT3bee/ogxWKzFrj5bDu6jGZnBmZIz7bq3r9TAxLLbzOQDzdPNuPWCz3jcV1Z
cX1+71ja20JucZQHpiROJkXjIGgKLofeJWTUS03v67Iw2t+QJ9E=
=1FOP
-----END PGP SIGNATURE-----

--mu7kkrbfxwnu6dth--
