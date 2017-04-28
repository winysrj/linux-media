Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:33831 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934260AbdD1LaL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 07:30:11 -0400
Subject: Re: [PATCH 6/8] omapdrm: hdmi4: refcount hdmi_power_on/off_core
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-7-hverkuil@xs4all.nl>
CC: <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <15b0996c-5756-19ac-7393-11c245417ce4@ti.com>
Date: Fri, 28 Apr 2017 14:30:00 +0300
MIME-Version: 1.0
In-Reply-To: <20170414102512.48834-7-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="SiGNW58EET3J2KngjaQktkxuruxfIPvAO"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--SiGNW58EET3J2KngjaQktkxuruxfIPvAO
Content-Type: multipart/mixed; boundary="GcPXQaARv75rChGi8Q8rNTrRtUHqMRQVB";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hans.verkuil@cisco.com>
Message-ID: <15b0996c-5756-19ac-7393-11c245417ce4@ti.com>
Subject: Re: [PATCH 6/8] omapdrm: hdmi4: refcount hdmi_power_on/off_core
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-7-hverkuil@xs4all.nl>
In-Reply-To: <20170414102512.48834-7-hverkuil@xs4all.nl>

--GcPXQaARv75rChGi8Q8rNTrRtUHqMRQVB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 14/04/17 13:25, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> The hdmi_power_on/off_core functions can be called multiple times:
> when the HPD changes and when the HDMI CEC support needs to power
> the HDMI core.
>=20
> So use a counter to know when to really power on or off the HDMI core.
>=20
> Also call hdmi4_core_powerdown_disable() in hdmi_power_on_core() to
> power up the HDMI core (needed for CEC).
>=20
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/omapdrm/dss/hdmi4.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4.c b/drivers/gpu/drm/omap=
drm/dss/hdmi4.c
> index 4a164dc01f15..e371b47ff6ff 100644
> --- a/drivers/gpu/drm/omapdrm/dss/hdmi4.c
> +++ b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
> @@ -124,14 +124,19 @@ static int hdmi_power_on_core(struct omap_dss_dev=
ice *dssdev)
>  {
>  	int r;
> =20
> +	if (hdmi.core.core_pwr_cnt++)
> +		return 0;
> +

How's the locking between the CEC side and the DRM side? Normally these
functions are protected with the DRM modesetting locks, but CEC doesn't
come from there. We have the hdmi.lock, did you check that it's held
when CEC side calls shared functions?

>  	r =3D regulator_enable(hdmi.vdda_reg);
>  	if (r)
> -		return r;
> +		goto err_reg_enable;
> =20
>  	r =3D hdmi_runtime_get();
>  	if (r)
>  		goto err_runtime_get;
> =20
> +	hdmi4_core_powerdown_disable(&hdmi.core);

I'd like to have the powerdown_disable as a separate patch. Also, now
that you call it here, I believe it can be dropped from hdmi4_configure()=
=2E

Hmm, but in hdmi4_configure we call hdmi_core_swreset_assert() before
hdmi4_core_powerdown_disable(). I wonder what exactly that does, and
whether we end up resetting also the CEC parts when we change the videomo=
de.

 Tomi


--GcPXQaARv75rChGi8Q8rNTrRtUHqMRQVB--

--SiGNW58EET3J2KngjaQktkxuruxfIPvAO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJZAye4AAoJEPo9qoy8lh71Ef4P/iO9nd7SjyH9ds5BJ4hq8WAX
ll7SjIJ6Sx3y5HA1yh1FnSd6q51jzbrIrQYPJTbqGg74QgPo2rnYLWYLgBvmif8K
UPhhSXtE7tugFesNDTpDkHeF25ZpQ6Yoez26Oa6ZJjnMUlgiOJjVeUfmeuhCs3Mz
QRkB/+o5tsquYtjeNOai0ughGgVR9z615m0gZ6VEgRCySQ7Pw70i2O5LlpJHQbDh
pAcJywXPxbwwze9zVLW2nC08fpxz4EdxCs+kW1s80karrJ77GIDhAsObTiTIqPqR
/kRVQOcQ1whkxhHEGihOaNucC1uWbgw6fNlYZdyQqJvtb+FBYZUEfbT8nVh3fBs2
g71EnJkpbTB+vnumefd1ZGBBrciB5NbpXsVpDtyE8pvQz+CdIE/iyAFRa2lXHhqk
W3YVZUNITpK6fqnc1YAgo270Bicr7AOMu36yADJYc7Qb6YGzHCntQRIOYx+HQUDs
nNnZ0Bi7sOqYJ3B5AarSgoHqMoBeUmXjb2uNeZCkGJpc0hrZRVb3z0pSjkmibozf
5zYG9MF951qUxALsvKhZ2BGJyiSvxu/Qx4auTg5ZPSIlDcDArbPRi7UaNXDOrZ4v
q06nrO+cOka1bIdxpO9yuu6jxkZ6WhBbc1HU9mSsEMcc5oUfzHCII/w5wjrMruUR
NcprmKff+ypA5ymLlhEr
=BZz2
-----END PGP SIGNATURE-----

--SiGNW58EET3J2KngjaQktkxuruxfIPvAO--
