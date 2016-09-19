Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752040AbcISVOM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 17:14:12 -0400
Date: Mon, 19 Sep 2016 23:14:05 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 09/17] smiapp: Read frame format earlier
Message-ID: <20160919211405.bx37cjzzkjh5r2qo@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-10-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pyckyjpspezhvuhh"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-10-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pyckyjpspezhvuhh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 15, 2016 at 02:22:23PM +0300, Sakari Ailus wrote:
> The information gathered during frame format reading will be required
> earlier in the initialisation when it was available. Also return an error
> if frame format cannot be obtained.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/s=
miapp/smiapp-core.c
> index 0b5671c..c9aee83 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2890,6 +2890,12 @@ static int smiapp_probe(struct i2c_client *client,
>  		goto out_power_off;
>  	}
> =20
> +	rval =3D smiapp_read_frame_fmt(sensor);
> +	if (rval) {
> +		rval =3D -ENODEV;
> +		goto out_power_off;
> +	}
> +
>  	/*
>  	 * Handle Sensor Module orientation on the board.
>  	 *
> @@ -3013,8 +3019,6 @@ static int smiapp_probe(struct i2c_client *client,
> =20
>  	sensor->pixel_array->sd.entity.function =3D MEDIA_ENT_F_CAM_SENSOR;
> =20
> -	/* final steps */
> -	smiapp_read_frame_fmt(sensor);
>  	rval =3D smiapp_init_controls(sensor);
>  	if (rval < 0)
>  		goto out_cleanup;

Is this missing a Fixes tag, or will it only be required earlier for
future patches?

-- Sebastian

--pyckyjpspezhvuhh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4FUcAAoJENju1/PIO/qaZWUP/RnVVSWUujTYUdQOGRHVY20l
R3Iv3b9CXoA6qHNGxowUY2DHM5INLCdpevYKafUERp9ghb0ygmbu36LLtXEVLoHB
Dws1hY/X7XEW+Sgq6mZ2rE9HI72kFLDDgpV3/Xd0WnEeICL7zjpva7UA+9pcUcBz
wxNwnXlWj3Lmb56z/LRiyGPdaQvn51SrhjW5LWL0rE8SFaz07Jy+QoBPLYMxHo6e
IXR1HlhL6cbW49lxYPDs5y9iiCc8lcW8vrAAkC1d3ExRSI4+jniBhr+IWEFh20SA
zBSXXSdBWXAk2ihaf1ZPCzUL8AnYgVrmzdmN/u6ctMwWF5wm5OdMIcICj8BdOSzw
BO3iqLpdY9okC6Nkp6vPIFChLh5XuG6ErfshDQyqP2DWp/yhmmUEDlu8qhfby5aV
S1vZ2MZBsoqIOUc0yC1OF+/jXTkjKbRTe1mIOmunt2LzTSrU3sAkeaCz8G5qJ9Ru
UuySWZsUi3FV8Cv220QBBmxobzgzbMSVKyN9Re9TS7K+3/tkiZ1fBt/0WhfPMjna
5ewcquUZotU3/CmM7DSXtfNiHA+0U3+QwYgJ63er8TuuK8Fsc4UTG3x39021Kn13
CB6k2jbmHWfg8xi5vGPiUpAwYtngLs4UM+o0+JZvmLNm9zVOIQxh7+Eylofyy/KQ
r+00kXcAAAau+fMJip3y
=QN+C
-----END PGP SIGNATURE-----

--pyckyjpspezhvuhh--
