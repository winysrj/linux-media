Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753380AbcISWCv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:02:51 -0400
Date: Tue, 20 Sep 2016 00:02:36 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 03/17] smiapp: Initialise media entity after sensor
 init
Message-ID: <20160919220235.vvc36czyxakukp2f@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sorirpxsr3f6hzp4"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-4-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--sorirpxsr3f6hzp4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 15, 2016 at 02:22:17PM +0300, Sakari Ailus wrote:
> This allows determining the number of pads in the entity based on the
> sensor.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/s=
miapp/smiapp-core.c
> index be74ba3..0a03f30 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -3056,12 +3056,7 @@ static int smiapp_probe(struct i2c_client *client,
>  	sensor->src->sd.internal_ops =3D &smiapp_internal_src_ops;
>  	sensor->src->sd.flags |=3D V4L2_SUBDEV_FL_HAS_DEVNODE;
>  	sensor->src->sensor =3D sensor;
> -
>  	sensor->src->pads[0].flags =3D MEDIA_PAD_FL_SOURCE;
> -	rval =3D media_entity_pads_init(&sensor->src->sd.entity, 2,
> -				 sensor->src->pads);
> -	if (rval < 0)
> -		return rval;
> =20
>  	if (client->dev.of_node) {
>  		rval =3D smiapp_init(sensor);
> @@ -3069,6 +3064,11 @@ static int smiapp_probe(struct i2c_client *client,
>  			goto out_media_entity_cleanup;
>  	}
> =20
> +	rval =3D media_entity_pads_init(&sensor->src->sd.entity, 2,
> +				 sensor->src->pads);
> +	if (rval < 0)
> +		goto out_media_entity_cleanup;
> +
>  	rval =3D v4l2_async_register_subdev(&sensor->src->sd);
>  	if (rval < 0)
>  		goto out_media_entity_cleanup;

As far as I can see this is not strictly needed, but:

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--sorirpxsr3f6hzp4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4GB4AAoJENju1/PIO/qalmAQAI4tyPRwkukjM4T0ZG1j5dF0
Ncx0bZF+HHDjL9mDehkgPi37DMqyn9CoWSfmRpfTu2gRiRXDG09jgfuiT5ymdkE7
tS+pgsKpGpYvfjPKY7t8uj+CMtC58eVeFPme2wTaVE5rrQ2KgxlHFyOqVkS3fRAJ
C1lhsKEmLAUke0qypwYZD0M3RUzSa1fDryUIVp2Yvcluw2k0qMAWVjl9qIiA9BT2
hnE4nUPEBfdh9DEPCFHZ0AwCokvkvwco40cyPHa9vbtgRvg6HtPhmHpIPMaavxGL
PeIlkiGwldTMjb81SXGPwhY77cw/g5WuGFMd5SC4bzXum55clPMJkzK2OJRKthyd
nZvtboKXig8+n5m4NBr0lQemqJOg2HVaD0+9UL7aCfiW1V9Npeo8bN379Ifdpp0C
rwu+Cn/jTReI0OucMTS85rmq8PUGDG2GpGJgiCQQ+lg4NX9PksWuE1bM5Y2dEpZV
ZjJDuqjCDutYuVG/pq4ZjSG4BWjV+5AulbWcpJnn5RDdjnlKCJjydShcDEjCoB4A
xonXj6V23k+90UzZ2sbs2ETATDMMVFc10mfkexzGLfHbg4q2ZRZVNa4H3O6L+Bn2
unsCCBPy8ekJS+0gYwqGZw8xZSp9N3PTFCAivoX22NNRw6mb0nbH2b3oP9BHk2dc
eHnijhZTLvAXy9rjQQQB
=ana2
-----END PGP SIGNATURE-----

--sorirpxsr3f6hzp4--
