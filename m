Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:48716 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932129AbeDWUgR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 16:36:17 -0400
Date: Mon, 23 Apr 2018 22:36:16 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v3 02/11] media: ov772x: allow i2c controllers without
 I2C_FUNC_PROTOCOL_MANGLING
Message-ID: <20180423203615.2ntymbibkgw2aiks@ninjato>
References: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com>
 <3172940.h9isB0x1K9@avalon>
 <20180423201121.cgcg6isobtku7swy@ninjato>
 <6809346.dy34v3ukH6@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i6xzbq3fz2aj6t4m"
Content-Disposition: inline
In-Reply-To: <6809346.dy34v3ukH6@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--i6xzbq3fz2aj6t4m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> SCCB helpers would work too. It would be easy to just move the functions=
=20
> defined in this patch to helpers and be done with it. However, there are =
I2C=20
> adapters that have native SCCB support, so to take advantage of that feat=
ure=20

Ah, didn't notice that so far. Can't find it in drivers/i2c/busses.
Where are those?

> we need to forward native SCCB calls all the way down the stack in that c=
ase.=20

And how is it done currently?

> That's why I thought an implementation in the I2C subsystem would be bett=
er.=20
> Furthermore, as SCCB is really a slightly mangled version of I2C, I think=
 the=20
> I2C subsystem would be a natural location for the implementation. It shou=
ldn't=20

Can be argued. But it can also be argues that it sits on top of I2C and
doesn't need to live in i2c-folders itself (like PMBus). The
implementation given in this patch looks a bit like the latter. However,
this is not the main question currently.

> be too much work, it's just a matter of deciding what the call stacks sho=
uld=20
> be for the native vs. emulated cases.

I don't like it. We shouldn't use SMBus calls for SCCB because SMBus
will very likely never support it. Or do you know of such a case? I
think I really want sccb helpers. So, people immediately see that SCCB
is used and not SMBus or I2C. And there, we can handle native support
vs. I2C-SCCB-emulation. And maybe SMBus-SCCB emulation but I doubt we
will ever need it.


--i6xzbq3fz2aj6t4m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlreQ78ACgkQFA3kzBSg
KbaTmg//aVCYkT8V6H8qX3Y18egbGxlHQGQ+pkPhhMMIZisCwhb5SjS7ptks1MgQ
JkKh1kuf9J1Cb/C+dQfuMOA74r5BqaPWpzhcH0iFeabY8Lq3oh+5gaqlC1ILoL8b
Ppdr7S7yb/eojx/4j8vsy6WfcQxyyGSYMleL9ukVUU7dcQ9O8Tu4+MxgaOFXK22m
gngbZGL8o+YUegobdPj7ctC58cuYozrZXcQmy9uknmuHE9+KvbLdulTwytHgv4iZ
nxRA1StT1yeXPzTsm8H0EdFfm9gEn8Z88LvSvC4gLt5Nsro3KmdyPQBhJMgLOpL+
k/ICuf+ZKZFFspud8dh7sMwhIQ/4sf4hSJizVyZVRWdz9h9sfWxbcjJuuEqZZK+D
K1+WjflN61bswm3I7V5G2dn/cboJDed7pFxY2RIlJML9spYKw3RBAMu2GeDg7fcV
ZAQJ7FcgzgXi1uDLHhnhQStKfJygd+tUfGOVCdsyiK9Mf8J0T7Y8tKwumj94uQMF
955hXinZlCewUdqv98EB4M0EwHosE0BhQRJ8RCE5yndkzoJjyv+Cz2t62NgG56/Q
abFffEvi6yV0Ox2cWRPbUBbYUueE/DtGcOM1T8y4zMcjcZLMGTUjjsJa88xtYJ9t
MM+tIYpPJOr3SdKpqKXjOlf+cXA3OH2xt+LHW+NAQg7zqbdhAJQ=
=lcnH
-----END PGP SIGNATURE-----

--i6xzbq3fz2aj6t4m--
