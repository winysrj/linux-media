Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33796 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbdGFLLw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 07:11:52 -0400
Date: Thu, 6 Jul 2017 13:11:49 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 7/8] omap3isp: Check for valid port in endpoints
Message-ID: <20170706111149.ws6olipu7ph4tcyd@earth>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
 <20170705230019.5461-8-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wzsqfnmbtaiucm67"
Content-Disposition: inline
In-Reply-To: <20170705230019.5461-8-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wzsqfnmbtaiucm67
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 06, 2017 at 02:00:18AM +0300, Sakari Ailus wrote:
> Check that we do have a valid port in an endpoint, return an error if not.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
>  drivers/media/platform/omap3isp/isp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platfo=
rm/omap3isp/isp.c
> index 2d45bf471c82..0676be725d7c 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2081,7 +2081,7 @@ static int isp_fwnode_parse(struct device *dev, str=
uct fwnode_handle *fwnode,
>  	default:
>  		dev_warn(dev, "%s: invalid interface %u\n",
>  			 to_of_node(fwnode)->full_name, vep.base.port);
> -		break;
> +		return -EINVAL;
>  	}
> =20
>  	return 0;
> --=20
> 2.11.0
>=20

--wzsqfnmbtaiucm67
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlleGvUACgkQ2O7X88g7
+pqHVw//efogOFA/4h/zMNsdtz3KFPiOSUOvfvmCHJVOPqH2YA9RVWpjcDADmyIn
Bv63w6s7ArNLDkCVVT82ymX7TKQyG8lFul0C+zF7S2XaaVjQwW6nQzTdxSrcCE/d
DNc1Ns4oFeSkbuAkB6D0jRHpcOr/56JKLxxwX+HewWXPAagOgwRSEJ1CFSarG01c
sFQTA9G8Kix5iI1vbVSK3ne744HPvxF670scoweblJYrOmT01Yna9wiic5LJR/gQ
YSL6JyKaA0VEL43xQz7fMDiQz7hyQQ01auFJQkZC5a3XQc0RCduw7ZYUE902FYG6
kpPvA6jtkIbVsbTDlfPH9vZYPwThzgIddZ95yLEqPvyL1EpgYRx/lsl0K2ARWJfM
RoHEKX6x1QpYMjpDpz2kfuMdGhYzTULW5Lc8eO2+w6n7eFIdjgZVOu4pXcmkR9ri
BBjB1TTVs1wNheKF56UueWToC8Oz/Ensy3DJq586FDSfNtLz4HYBgrcPB6oAqtpg
R7RrQ6805yU3Z1TzTb9z7g5kW3IRVo76iOaXxA+ljgbbeA4qa0E/Se8ifj+8o1qn
cmzA4tyQfYxnR6LfRL3W0P1S69Cw/NLFqLhPxmzSFVammGf+vNwstkz72OBGoGhF
2JeuL1m9e0CKlcKmcSNUIG5Rm/Fj3SEGgUuKMYr5QMCOy1tHecs=
=d4Yu
-----END PGP SIGNATURE-----

--wzsqfnmbtaiucm67--
