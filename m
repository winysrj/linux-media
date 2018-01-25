Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:42769 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751428AbeAYK4G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 05:56:06 -0500
Date: Thu, 25 Jan 2018 11:55:54 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC 1/4] drm: Add colorkey properties
Message-ID: <20180125105554.ytfpuob2ap7aewnm@flea.lan>
References: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com>
 <20171217001724.1348-2-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6lk6enxvp5qwo73w"
Content-Disposition: inline
In-Reply-To: <20171217001724.1348-2-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6lk6enxvp5qwo73w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 17, 2017 at 02:17:21AM +0200, Laurent Pinchart wrote:
> Color keying is the action of replacing pixels matching a given color
> (or range of colors) with transparent pixels in an overlay when
> performing blitting. Depending on the hardware capabilities, the
> matching pixel can either become fully transparent, or gain a
> programmable alpha value.
>=20
> Color keying is found in a large number of devices whose capabilities
> often differ, but they still have enough common features in range to
> standardize color key properties. This commit adds four properties
> related to color keying named colorkey.min, colorkey.max, colorkey.alpha
> and colorkey.mode. Additional properties can be defined by drivers to
> expose device-specific features.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.co=
m>

Sorry for the delay,
Reviewed-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--6lk6enxvp5qwo73w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlppt7kACgkQ0rTAlCFN
r3Q8rQ//cmqF0IWwUuok9EEW6whNO1C1kdRwWjGciopjyKaQlNoHww0e3jJbT6Ko
KBL0EHuIK3GwLQw9VrAyQznsSE6CfNu9YwPZwzduU1j++zlX0Lu9uwXcudbXq6xm
txxl0pDzX42d7Pumx+vlMxAJdbqAj4RWQBdgonqMmBhLKB6nv9y8HyDNipNoi7vb
BOg/64Hb+7PVNfHzx1gwMgwM6s9fhPCLghIv23jE4Pb8rBbCtByBs5aIU9Izm5hs
dY8TebtgQcVfNOwWYBzPlM13E6+kp8ZUDl29MLTfbMAUi8gEvzC4EgEM8BxehCxJ
XOTeEGpxbgdJKVD3sDj/55/BQ6TKSXrLzSzlZ3Fc4KZfUxSj3qo/yMic5kfb64Qc
Wp93vVZc0LWAoPEZ7v/1WV1kDV4XWlbPZl8NhdsC2kg02RY9UTa9vMxyWCN4HWJ2
tlTUadIRtddRiKCD9TiXk4pHZDVRQOPhSZ5dyoB4UstAaF2e5ZBf7a6WnDmM8LrC
WVpDBewrq35TxsaoPGI+q/0PvvOUvrFnAzOensK+qjJHKVrmtvyVMVOeTWI5wDJV
X+Cn1okyk3cZcf8F73eczqhyhH7hrH5c3lEYg8YXYEEGNpYX1mIOqbnKuld+ZTrv
dy7V739CCL8s9Gal9eKWjy7BLPpOi8+C72hUdWUP6ic6rf2Ajo4=
=Jp3O
-----END PGP SIGNATURE-----

--6lk6enxvp5qwo73w--
