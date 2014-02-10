Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:38413 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaBJMxP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 07:53:15 -0500
Received: by mail-ea0-f170.google.com with SMTP id g15so1192370eak.1
        for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 04:53:14 -0800 (PST)
Date: Mon, 10 Feb 2014 13:53:08 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
	devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
	Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel@lists.freedesktop.org,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/2] drivers/base: permit base components to omit the
 bind/unbind ops
Message-ID: <20140210125307.GG20143@ulmo.nvidia.com>
References: <cover.1391792986.git.moinejf@free.fr>
 <9b3c3c2c982f31b026fd1516a2b608026d55b1e9.1391792986.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ndw/alBWmZEhfcZ"
Content-Disposition: inline
In-Reply-To: <9b3c3c2c982f31b026fd1516a2b608026d55b1e9.1391792986.git.moinejf@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4ndw/alBWmZEhfcZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 07, 2014 at 04:55:00PM +0100, Jean-Francois Moine wrote:
> Some simple components don't need to do any specific action on
> bind to / unbind from a master component.
>=20
> This patch permits such components to omit the bind/unbind
> operations.
>=20
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>  drivers/base/component.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/base/component.c b/drivers/base/component.c
> index c53efe6..0a39d7a 100644
> --- a/drivers/base/component.c
> +++ b/drivers/base/component.c
> @@ -225,7 +225,8 @@ static void component_unbind(struct component *compon=
ent,
>  {
>  	WARN_ON(!component->bound);
> =20
> -	component->ops->unbind(component->dev, master->dev, data);
> +	if (component->ops)
> +		component->ops->unbind(component->dev, master->dev, data);

This doesn't actually do what the commit message says. This makes
component->ops optional, not component->ops->unbind().

A more correct check would be:

	if (component->ops && component->ops->unbind)

>  	component->bound =3D false;
> =20
>  	/* Release all resources claimed in the binding of this component */
> @@ -274,7 +275,11 @@ static int component_bind(struct component *componen=
t, struct master *master,
>  	dev_dbg(master->dev, "binding %s (ops %ps)\n",
>  		dev_name(component->dev), component->ops);
> =20
> -	ret =3D component->ops->bind(component->dev, master->dev, data);
> +	if (component->ops)
> +		ret =3D component->ops->bind(component->dev, master->dev, data);

Same here.

Thierry

--4ndw/alBWmZEhfcZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+MuzAAoJEN0jrNd/PrOhD+YP/0yqsCV8/Kk54U0h4ijYsxXa
g20qgFqu3Ggy2WRUtbY831emWdP1PZk1J9n9pqKIKOQa8BDCpIMlQitdIxkZxuur
0xAdUHIzp6ZerhnxrM8hJW9d2GTCHLWZMGXmY0UrN2X4njQbmplfXRwd1/mu9eMt
X06nX9aTOOsBLLtnZsIl/IdYIB4dhsLRnon0mUkfJhfcjuivPathgNG562HyTk8q
X90y4bHvHfM+4cqick02eeQ36i+C9FZlcuMYGcgxRIf13g0Xu9K02N+cY58aBpRi
0TeC/9In4BPKx8I+baAdIARE6DPXfHfM6vLOBgblXZePAsTv07fLcVdEQPnQHDPS
Fn03qQL9WxQW31cx17DQ4T1fav80WqlNGXIweStc1F85ZzCqgP+RDgQNA+K/r2Sb
B2l8l+weCYkm25/IpdEKUI21wvarixzDhs1Jv6VAoP7FLoVPW2RSBBQOFoKa5INK
TmWZKSf6W4NrXZ1Vh4BQBRL4LEixt6ikxmUgli5sTc2KDzMnxsI6EQLK6TJjoVqM
3GcW6ljWAuFKqAUniS0xnR2vgHy7GpIANYANpWUmtuNBJEYXKojOYDD9CSgGKHze
l9HVif8Tm5Yqbwwm8YQAtcJ3BsFM8I/N8u8ZozKtGQIMFmtDbL1/Rjvt4Jd/sUGn
2YKbQ6LPZk8hKR4JQo2D
=VtBy
-----END PGP SIGNATURE-----

--4ndw/alBWmZEhfcZ--
