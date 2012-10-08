Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:45576 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753687Ab2JHHMn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 03:12:43 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so2025282lag.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 00:12:41 -0700 (PDT)
Message-ID: <1349680358.3227.27.camel@deskari>
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Date: Mon, 08 Oct 2012 10:12:38 +0300
In-Reply-To: <1349680065.3227.25.camel@deskari>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
	 <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de>
	 <1349680065.3227.25.camel@deskari>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-L32r8tTcWf9+Yupqd/gB"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-L32r8tTcWf9+Yupqd/gB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-10-08 at 10:07 +0300, Tomi Valkeinen wrote:
> Hi,

> I don't see you setting disp->default_timing to OF_DEFAULT_TIMING in
> case there's no default_timing found.
>=20
> Or, at least I presume OF_DEFAULT_TIMING is meant to mark non-existing
> default timing. The name OF_DEFAULT_TIMING is not very descriptive to
> me.

Ah, I see now from the second patch how this is meant to be used. So if
there's no default timing in DT data, disp->default_timing is 0, meaning
the first entry. And the caller of of_get_videomode() will use
OF_DEFAULT_TIMING as index to get the default mode.

So I think it's ok.

 Tomi


--=-L32r8tTcWf9+Yupqd/gB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQcnzmAAoJEPo9qoy8lh71oBUP/0bxc1V5TTiuSaszMTujbf00
dpQd40W+w4TsDWWlHzHk9Qd7NNxZpF1Qs4Yh3xlLn++V3FpzlseyGyrelWFSosAl
vkCQdqENYBZ+bqfeuEQpKtAlbFoX0L3Jgxiv+2dGPIZvbzjjg5+dWHbN7ZBfdXhx
UdOlprPZ022HjK6Rt7Yk1QpL+rpqP96NObt7ALjrY3jQfMSXtkv9d+LJEFRkqA+5
krmoiVy6B+1cMMP/b4BcGqkOHs2Ek3LxiM4aSDfjF4ZEvrw0CH+uLWqvtjfErAhv
2CQkEQeWoSjqDiB0DKno+MS+Hb+UoZ8PcPU65jgd/dovQhVEk5HBQYWVoXgiSurI
uyfZ9qsoPhzhDx8UIYf0uZ3yEb7eThDWj6imRNqUhDtRoLLg4/MwxgQaiVVKo4Hb
+UbsBvKuVbFTxeB7CwD2h3DT7i2nhhAKuXDTtKL+bPNA2Humw+bnwi2R0J3SjU0j
gqqXz1+LbYT1yphW4eFTBC0r2NgKdfShB56ffuf0s3IunDX8OmoQIgsZ6niWZK6h
Kv7yTP+cIc0T8nEzuVth4HKsXlAC0nhTRB/JCoZsEfgy4oKuFQO+5TC+S46NCOSG
CeJyIstqxE91ILVqMz7l+W9T8il5oOiow+zC46kf7Cavvsx1yAqL2/cEBFdgdvJn
90okBD/kA251OMuKr8we
=LlnE
-----END PGP SIGNATURE-----

--=-L32r8tTcWf9+Yupqd/gB--

