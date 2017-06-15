Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44679 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdFOKpR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 06:45:17 -0400
Date: Thu, 15 Jun 2017 12:45:12 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 4/8] v4l2-flash: Use led_classdev instead of
 led_classdev_flash for indicator
Message-ID: <20170615104512.3qoplzxbhcwfeins@earth>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-5-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qnkw72h6ycc7wl33"
Content-Disposition: inline
In-Reply-To: <1497433639-13101-5-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qnkw72h6ycc7wl33
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 14, 2017 at 12:47:15PM +0300, Sakari Ailus wrote:
> The V4L2 flash class initialisation expects struct led_classdev_flash that
> describes an indicator but only uses struct led_classdev which is a field
> iled_cdev in the struct. Use struct iled_cdev only.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
>  drivers/media/v4l2-core/v4l2-flash-led-class.c | 19 +++++++------------
>  include/media/v4l2-flash-led-class.h           |  6 +++---
>  2 files changed, 10 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/med=
ia/v4l2-core/v4l2-flash-led-class.c
> index 7b82881..6d69119 100644
> --- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
> +++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> @@ -110,7 +110,7 @@ static void v4l2_flash_set_led_brightness(struct v4l2=
_flash *v4l2_flash,
>  		led_set_brightness_sync(&v4l2_flash->fled_cdev->led_cdev,
>  					brightness);
>  	} else {
> -		led_set_brightness_sync(&v4l2_flash->iled_cdev->led_cdev,
> +		led_set_brightness_sync(v4l2_flash->iled_cdev,
>  					brightness);
>  	}
>  }
> @@ -133,7 +133,7 @@ static int v4l2_flash_update_led_brightness(struct v4=
l2_flash *v4l2_flash,
>  			return 0;
>  		led_cdev =3D &v4l2_flash->fled_cdev->led_cdev;
>  	} else {
> -		led_cdev =3D &v4l2_flash->iled_cdev->led_cdev;
> +		led_cdev =3D v4l2_flash->iled_cdev;
>  	}
> =20
>  	ret =3D led_update_brightness(led_cdev);
> @@ -529,8 +529,7 @@ static int v4l2_flash_open(struct v4l2_subdev *sd, st=
ruct v4l2_subdev_fh *fh)
>  	struct v4l2_flash *v4l2_flash =3D v4l2_subdev_to_v4l2_flash(sd);
>  	struct led_classdev_flash *fled_cdev =3D v4l2_flash->fled_cdev;
>  	struct led_classdev *led_cdev =3D &fled_cdev->led_cdev;
> -	struct led_classdev_flash *iled_cdev =3D v4l2_flash->iled_cdev;
> -	struct led_classdev *led_cdev_ind =3D NULL;
> +	struct led_classdev *led_cdev_ind =3D v4l2_flash->iled_cdev;
>  	int ret =3D 0;
> =20
>  	if (!v4l2_fh_is_singular(&fh->vfh))
> @@ -543,9 +542,7 @@ static int v4l2_flash_open(struct v4l2_subdev *sd, st=
ruct v4l2_subdev_fh *fh)
> =20
>  	mutex_unlock(&led_cdev->led_access);
> =20
> -	if (iled_cdev) {
> -		led_cdev_ind =3D &iled_cdev->led_cdev;
> -
> +	if (led_cdev_ind) {
>  		mutex_lock(&led_cdev_ind->led_access);
> =20
>  		led_sysfs_disable(led_cdev_ind);
> @@ -578,7 +575,7 @@ static int v4l2_flash_close(struct v4l2_subdev *sd, s=
truct v4l2_subdev_fh *fh)
>  	struct v4l2_flash *v4l2_flash =3D v4l2_subdev_to_v4l2_flash(sd);
>  	struct led_classdev_flash *fled_cdev =3D v4l2_flash->fled_cdev;
>  	struct led_classdev *led_cdev =3D &fled_cdev->led_cdev;
> -	struct led_classdev_flash *iled_cdev =3D v4l2_flash->iled_cdev;
> +	struct led_classdev *led_cdev_ind =3D v4l2_flash->iled_cdev;
>  	int ret =3D 0;
> =20
>  	if (!v4l2_fh_is_singular(&fh->vfh))
> @@ -593,9 +590,7 @@ static int v4l2_flash_close(struct v4l2_subdev *sd, s=
truct v4l2_subdev_fh *fh)
> =20
>  	mutex_unlock(&led_cdev->led_access);
> =20
> -	if (iled_cdev) {
> -		struct led_classdev *led_cdev_ind =3D &iled_cdev->led_cdev;
> -
> +	if (led_cdev_ind) {
>  		mutex_lock(&led_cdev_ind->led_access);
>  		led_sysfs_enable(led_cdev_ind);
>  		mutex_unlock(&led_cdev_ind->led_access);
> @@ -614,7 +609,7 @@ static const struct v4l2_subdev_ops v4l2_flash_subdev=
_ops;
>  struct v4l2_flash *v4l2_flash_init(
>  	struct device *dev, struct fwnode_handle *fwn,
>  	struct led_classdev_flash *fled_cdev,
> -	struct led_classdev_flash *iled_cdev,
> +	struct led_classdev *iled_cdev,
>  	const struct v4l2_flash_ops *ops,
>  	struct v4l2_flash_config *config)
>  {
> diff --git a/include/media/v4l2-flash-led-class.h b/include/media/v4l2-fl=
ash-led-class.h
> index f9dcd54..54e31a8 100644
> --- a/include/media/v4l2-flash-led-class.h
> +++ b/include/media/v4l2-flash-led-class.h
> @@ -85,7 +85,7 @@ struct v4l2_flash_config {
>   */
>  struct v4l2_flash {
>  	struct led_classdev_flash *fled_cdev;
> -	struct led_classdev_flash *iled_cdev;
> +	struct led_classdev *iled_cdev;
>  	const struct v4l2_flash_ops *ops;
> =20
>  	struct v4l2_subdev sd;
> @@ -124,7 +124,7 @@ static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_fl=
ash(struct v4l2_ctrl *c)
>  struct v4l2_flash *v4l2_flash_init(
>  	struct device *dev, struct fwnode_handle *fwn,
>  	struct led_classdev_flash *fled_cdev,
> -	struct led_classdev_flash *iled_cdev,
> +	struct led_classdev *iled_cdev,
>  	const struct v4l2_flash_ops *ops,
>  	struct v4l2_flash_config *config);
> =20
> @@ -140,7 +140,7 @@ void v4l2_flash_release(struct v4l2_flash *v4l2_flash=
);
>  static inline struct v4l2_flash *v4l2_flash_init(
>  	struct device *dev, struct fwnode_handle *fwn,
>  	struct led_classdev_flash *fled_cdev,
> -	struct led_classdev_flash *iled_cdev,
> +	struct led_classdev *iled_cdev,
>  	const struct v4l2_flash_ops *ops,
>  	struct v4l2_flash_config *config)
>  {
> --=20
> 2.1.4
>=20

--qnkw72h6ycc7wl33
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAllCZS0ACgkQ2O7X88g7
+ppmaRAAmiYetGTVZORV+kQvcBSuhEhyneUPsUkJIwVCGtNctHiCQa6Rl+SWaxpm
LqZmFGPmdnKQONu0uv9BRCM2Yo7CYtWTdpya+YTmuH83FzjFEFzFksYVurfa0BLe
/gncBcFE+XuLpBraN0u4W/2EUBoH7KARJ1eSAyQN7gVjCXnnXJDoY0uAL9oSG2qG
YM/Ai2uJtuTDnOferhipyw0HOHuFmY7SNpmfFVVzKobAgxQF+bnoKHH055YnSREK
xgbQO71QTCpU4MipPa7WivjcblyO9QLxGLJ+r5vlpOD2gOQEZ/lnEFveh/PRyR0+
4V71H28QBEM3RsjHdZVSWaeF6a/4MwVB72Wydb5LpvBar9nHQeeD1xdYvwTZ38o+
6s5VdOVcZg7O1PwFEHsf0TXT9T1J1PCzuz8srJS+/716zpNsFlWWlSSzZ//+RSPf
dPDfXfiY1K0U1R3UQpLI6UmB8OMIdNoMpNoXiDlYtM7/eyS0TgxW0ENVKbG3i9ly
Yro7uWYKnzgvTHWrgcIjBuPigy5nnOwao8+7fWTDhGaWtv1g8Cg2O83+xgiHAbiY
gEpebIp086NQAktqcJVZT8Es7qllOXA/N3Yw4OGKeBX/JaONRb0fUIRsznwSkZWy
t3AHGpJrY5iIyk42q1iLZsWG3MiDjlhJo2qryqkYydiQHbqOSVk=
=EC5X
-----END PGP SIGNATURE-----

--qnkw72h6ycc7wl33--
