Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45808 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdJHVue (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Oct 2017 17:50:34 -0400
Date: Sun, 8 Oct 2017 23:50:29 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz
Subject: Re: [PATCH v15 02/32] v4l: async: Don't set sd->dev NULL in
 v4l2_async_cleanup
Message-ID: <20171008215029.u6qsuvbwig4gfh7t@earth>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
 <20171004215051.13385-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bh2rkpnl5gmsoxze"
Content-Disposition: inline
In-Reply-To: <20171004215051.13385-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bh2rkpnl5gmsoxze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 05, 2017 at 12:50:21AM +0300, Sakari Ailus wrote:
> v4l2_async_cleanup() is called when the async sub-device is unbound from
> the media device. As the pointer is set by the driver registering the
> async sub-device, leave the pointer as set by the driver.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/v4l2-core/v4l2-async.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-co=
re/v4l2-async.c
> index 60a1a50b9537..21c748bf3a7b 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -134,7 +134,6 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
>  	/* Subdevice driver will reprobe and put the subdev back onto the list =
*/
>  	list_del_init(&sd->async_list);
>  	sd->asd =3D NULL;
> -	sd->dev =3D NULL;
>  }
> =20
>  int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
> --=20
> 2.11.0
>=20

--bh2rkpnl5gmsoxze
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlnanaUACgkQ2O7X88g7
+pqpZQ/+IMVCqZ/SKrId1vBtQEuQP/536VRbx288CLJnNC4QwJTFgftkHBmeiwyJ
jzkB05W6YFKZhmH3YO47tNvO1aPHMhkkj2YYKJMx9nK5/eVf8FQTUWwRW4mfAo+Y
2TtKDXJ80S3jJGDw2upeCKAlRi3IVhz2XzbxRSkh2EAfX/6yX3kLa1WEbQ1bBzjX
nnKod1c5NeERoE6dhj/r1DlUcNS6ZwCvHh0kFvKyJI1OK6CyaNpzA7PP+8FQt26o
REQskp2iN18lC5Q0fWz+aX77Xg9k/qud9Wrymm6q2jaikJ+74fZt/2uqqBNMXOWP
fZGemTCu9EM314CFNT3CthGXkSg80Z5GOk8oUCbb34Id6FJWfLCIT/sJiz7k/gQ+
4o0pZDPfTOLb3zNelb3OORC3e3JnXyGdb4ZIGFAY7b5nbtdpz/1WWNHtQOkH723g
OCewH4duF38dPct8+RWPsSbsfPBvTOl+12Hk2XUh9E991J/IP1J0oOkZi5rwCln0
+rLVb35cjqgqNuR8qpTK77wrHqyPJsLYYWxdC7KfTXY+VsDKbQfTJRklKMhvvm1p
tqi+Mw2rPhw3nQ8Uwqogc/WFFc/2v9CH+iPwEy/hZKBzi2Qt5Am1NQ1lABuk/g8M
bZrVfwenK3cFHG8K5A0tPtfYFE6mNnNi/VBsQTOCLVFQz39Vj2Q=
=Kwzb
-----END PGP SIGNATURE-----

--bh2rkpnl5gmsoxze--
