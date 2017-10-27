Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751747AbdJ0Orq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 10:47:46 -0400
Date: Fri, 27 Oct 2017 16:47:42 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 12/32] omap3isp: Print the name of the entity where
 no source pads could be found
Message-ID: <20171027144742.guamrqshy335mzvx@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-13-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nacv4banhkr24hqm"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-13-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nacv4banhkr24hqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:22AM +0300, Sakari Ailus wrote:
> If no source pads are found in an entity, print the name of the entity.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/platform/omap3isp/isp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platfo=
rm/omap3isp/isp.c
> index 4afd7ba4fad6..35687c9707e0 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1669,8 +1669,8 @@ static int isp_link_entity(
>  			break;
>  	}
>  	if (i =3D=3D entity->num_pads) {
> -		dev_err(isp->dev, "%s: no source pad in external entity\n",
> -			__func__);
> +		dev_err(isp->dev, "%s: no source pad in external entity %s\n",
> +			__func__, entity->name);
>  		return -EINVAL;
>  	}
> =20
> --=20
> 2.11.0
>=20

--nacv4banhkr24hqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlnzRw4ACgkQ2O7X88g7
+prMMQ//R2GRwJpiqJ9mVNwKEavejkEBo0f4T2Kev9Fk1gvMgIrkQU0q/JYeYpvj
AVl/ZUbWZuAd2szwXuqLqiTVD4XvC/QiZfttFcOpASMat5y1rxVc/OxTNOy/7awS
+61d20cz8ISPJebShg1o6Njrel3PUPHjDAdRa0ysgpiy1tlcaiWn/fdG06TXx3Lt
QFJ0gSLhOz/PBux69bDIBP3uNofKHVjYGs79jPyXSX/8JA714Dz4MA7FP217TEIL
1iVWBlV6kl3RpzOj8CNx5Xcuc6YeviGE2eraYxPRKhBgym8jnbuYMeUF6FH5fWuw
UAJe9KZ6Oe9izjaHOL7EQ6FOrIE0uEjnWUd2jm31EseUOwpqD0iZ2eaQjCPYHEOJ
zm1gbjPcqjJZ9VdEs3sMXbQ4MO5p29Ly5sYSAe0fvJdK6UdEDgldCo/U9Zf0QThw
6KcZlttx2b6BPxuHbTzc1GEh0uUH5LrgpfQPHcIizdYCjxyYQLLPgQOjqDdQVj1F
g9lVMafM4jejkFzG34Nf6v3XsfqI+HvPlAo4LcZ3goE/BwGhgoiPvCd3OUO2wmGq
J9JeJtPH6/6aqNwJI29sOO/ErE/wV5W8irb4YnClgtgylE7vFceeTCYyH4hstRf1
teti5MPS5GZJAatNC9xTHl9ZpR1oojEsI/BIQwWBKCYYy5bU5qI=
=XXP/
-----END PGP SIGNATURE-----

--nacv4banhkr24hqm--
