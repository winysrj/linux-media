Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52129 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbeGMIl4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 04:41:56 -0400
Message-ID: <d9cc498c058b34b46eaf910de2f6ba4dd4ca4838.camel@bootlin.com>
Subject: Re: [PATCH v5 20/22] ARM: dts: sun7i-a20: Add Video Engine and
 reserved memory nodes
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
Date: Fri, 13 Jul 2018 10:28:17 +0200
In-Reply-To: <20180710092310.2hzoc7shmfykr3n5@flea>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
         <20180710080114.31469-21-paul.kocialkowski@bootlin.com>
         <20180710092310.2hzoc7shmfykr3n5@flea>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-mUToiGCHY1cIrP6GveCh"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-mUToiGCHY1cIrP6GveCh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2018-07-10 at 11:23 +0200, Maxime Ripard wrote:
> On Tue, Jul 10, 2018 at 10:01:12AM +0200, Paul Kocialkowski wrote:
> > +		vpu: video-codec@1c0e000 {
> > +			compatible =3D "allwinner,sun7i-a20-video-engine";
> > +			reg =3D <0x01c0e000 0x1000>;
> > +
>=20
> The issue is here with all your patches, but you should drop the node
> label and the extra new line.

Noted, this will be fixed in the next revision.

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-mUToiGCHY1cIrP6GveCh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltIYqEACgkQ3cLmz3+f
v9GeIwgAhY9paW0UIC3+V24nTHQH8+8lA/opmAUTwA+Gz60Gvant9jsvI439XAuH
uHCtrFeuNQ7e8xeZA2le+ecCqaKSc4z3iP3lnxJolxgeX9y7TBl5fAaayhfYEdz3
jdB4kGUpneQnHFxfzfhma2gaQoSfSNUhd/kSED/z41PZOugQYe4Nau1D1xzSL/fh
kj10peBit3e0+XSYUKEErbjLMzXv1QUZhY1gNp1mMhxH5N0/o4fCYXjHBT8Y2Bzg
idE+bKRnr3V677yKk+tTw7iSAthtkETlkRqxfcvOhKoQztSlW6dDRAJumnDrI3g/
/3kBKyUCZEr2B/K0SklRj5qZ40itbg==
=L+cQ
-----END PGP SIGNATURE-----

--=-mUToiGCHY1cIrP6GveCh--
