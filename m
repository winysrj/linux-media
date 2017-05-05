Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38901 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbdEEJJW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 05:09:22 -0400
Date: Fri, 5 May 2017 11:09:19 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz
Subject: Re: [RFC v2 2/3] dt: bindings: Add lens-focus binding for image
 sensors
Message-ID: <20170505090919.unocpq7pk4oojs5t@earth>
References: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493974110-26510-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2rpne543od2eiftj"
Content-Disposition: inline
In-Reply-To: <1493974110-26510-3-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2rpne543od2eiftj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, May 05, 2017 at 11:48:29AM +0300, Sakari Ailus wrote:
> The lens-focus property contains a phandle to the lens voice coil driver
> that is associated to the sensor; typically both are contained in the same
> camera module.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt=
 b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index dac764b..0a33240 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -77,6 +77,8 @@ Optional properties
>    single LED, then the phandles here refer to the child nodes of the LED
>    driver describing individual LEDs.
> =20
> +- lens-focus: A phandle to the node of the focus lens controller.
> +
> =20
>  Optional endpoint properties
>  ----------------------------

-- Sebastian

--2rpne543od2eiftj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlkMQTwACgkQ2O7X88g7
+pq74g/+MrMEfa2Onx/PhUBbZphoMbvtOyY2n/GUlL0VqX8Fbpfy5OQ8QzsEeCFU
9radEKc3eQm2/KjldKNkF06l9FAMeotGDUvuoQz3T+a+eA7DTn+kn9/He1723o0y
S+FF0hBVlngyhVPNv7iqeXtm+qs1cZD9hsJVxrbzrYJUc9bSAQeJ5hPIKwmGLmkH
IoUk2r4F/rlkqO7KZ6t/fcbh6nOibcTGW3lM8bH976RSqOdwvuV7IViwDqCeGDDG
pxiMJU/UQSw+Y1Kdvpz2GffBtdeTIfW3IsX/KAgUpLW5447hZlkK5mCQczMGroVV
fGiGc92esYrmroyMrb2YSenx5y+cahbZKxYew6gbalNCnWwY8KX6dUOLz7KMMfpY
4QKfNqF5t90P9BS/Zaavn9U1JESqS7d85qsdcjia4lNqyRzcIGlCQ7gXOrbUEsOa
c9hQRx/1dSGINd/GRE0BnXg3G9qyATGpytF8zzNifDQhvUcMIkwriHyWYV12EQ20
ksqEUUmONZouxLzOc6vubkFL1pTJjhaMquecz3gKFDjwjkDCuWir7ta86GezKwh+
epbh1rRdA1wudNn1mAqdi5VV8W/a1Xeq7nINyoQawd9zN+UTqYSRTlxMP5MYKln2
73T3lu0I6wQ/RHdV7YuF8ggouLy7TyHZBA3V+Cdbz8qbAPQh4aU=
=JIpA
-----END PGP SIGNATURE-----

--2rpne543od2eiftj--
