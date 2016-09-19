Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751207AbcISUab (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 16:30:31 -0400
Date: Mon, 19 Sep 2016 22:30:22 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 04/17] smiapp: Split off sub-device registration into
 two
Message-ID: <20160919203022.v4vih6stlfci5cft@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-5-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="viydkzqqyecb7qdj"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-5-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--viydkzqqyecb7qdj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 15, 2016 at 02:22:18PM +0300, Sakari Ailus wrote:
> Remove the loop in sub-device registration and create each sub-device
> explicitly instead.

Reviewed-By: Sebastian Reichel <sre@kernel.org>

> +static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
> +{
> +	int rval;
> +
> +	if (sensor->scaler) {
> +		rval =3D smiapp_register_subdev(
> +			sensor, sensor->binner, sensor->scaler,
> +			SMIAPP_PAD_SRC, SMIAPP_PAD_SINK,
> +			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
> +		if (rval < 0)
>  			return rval;
> -		}
>  	}
> =20
> -	return 0;
> +	return smiapp_register_subdev(
> +		sensor, sensor->pixel_array, sensor->binner,
> +		SMIAPP_PA_PAD_SRC, SMIAPP_PAD_SINK,
> +		MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
>  }

I haven't looked at the remaining code, but is sensor->scaler
stuff being cleaned up properly if the binner part fails?

-- Sebastian

--viydkzqqyecb7qdj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4ErbAAoJENju1/PIO/qaosgP/A4VTHC1bv3gNyDZ/DAQFRH9
Aqe/7T5AYWnTlG7+937o1/LQf70mk170S4zaCnKxPp8ZUAjUHXROuuEoML+aHlNd
R8YEFcvOQGk/MG+KY7qOFJwXQa0G0MCZh52N2sLvXcN5z/88yVXhd0xRzAqJYeH1
9+5gpcpIbBPbwID5P+DkOMbuZqdUQHmEXzCrRmbz3Z7zsG18ftqzjgQCMvzRLlPD
iqaWGndDcQ2wmfZwxLIVHMaMHkJxKQIvZf3oKwTJwJKYyN9N8+4wCGBR9cPC3fIr
KykTQevQRRasuCpuMoTEHam9MCNCpmufgBhwl3DawRZzUOXvRwBSOyuXOLflDOOh
jlpJgzJ+oEbeWGJUnjrQxqBRZVxovn/Nafash9gjetfz5ViXw1geZPxYl7no0x9p
MuV14UnI5lQouOmUbftTXsgpVeBLngT4+x884qMKuVX3Gp5T38keHKxWy3Bm83OM
gEgAvk9SOMEwR8Ptgt+iHRpHlbh2I2b/hENGJ+aInxtquMbV2Z9FYZ6hyeNU2/nD
nEv/+Z0uhCl6hMzHPW4XbbHl+8MfWYUGYU4+lgJQ7HhWrdASnI++Okwk/YpndMFy
/3jONMxzKH17s/xexE9UnlMaLuq99rMQMU1M3UK9WQ5tD8xghyEz2ycnR6M7KP82
f/o22l/v7u3AmCaWAHeg
=9x3q
-----END PGP SIGNATURE-----

--viydkzqqyecb7qdj--
