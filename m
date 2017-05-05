Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38912 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753292AbdEEJKV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 05:10:21 -0400
Date: Fri, 5 May 2017 11:10:17 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz
Subject: Re: [RFC v2 3/3] dt: bindings: Add a binding for referencing EEPROM
 from camera sensors
Message-ID: <20170505091017.3z7tu32a7ubrfsxk@earth>
References: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493974110-26510-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="evfdzugpiahk5lk6"
Content-Disposition: inline
In-Reply-To: <1493974110-26510-4-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--evfdzugpiahk5lk6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, May 05, 2017 at 11:48:30AM +0300, Sakari Ailus wrote:
> Many camera sensor devices contain EEPROM chips that describe the
> properties of a given unit --- the data is specific to a given unit can
> thus is not stored e.g. in user space or the driver.
>=20
> Some sensors embed the EEPROM chip and it can be accessed through the
> sensor's I2C interface. This property is to be used for devices where the
> EEPROM chip is accessed through a different I2C address than the sensor.
>=20
> The intent is to later provide this information to the user space.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt=
 b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 0a33240..38e3916 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -79,6 +79,9 @@ Optional properties
> =20
>  - lens-focus: A phandle to the node of the focus lens controller.
> =20
> +- eeprom: A phandle to the node of the EEPROM describing the camera sens=
or
> +  (i.e. device specific calibration data), in case it differs from the
> +  sensor node.
> =20
>  Optional endpoint properties
>  ----------------------------

-- Sebastian

--evfdzugpiahk5lk6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlkMQXkACgkQ2O7X88g7
+pr0zA/+NQ7TvQX1dzqsuvXJEnD6xSoUZykgYjEVpvX0GxdFt23iW1jwfEspDx+1
JqiFNDLc1gOIppDpPtR6214nDOLW3F/6y02Hv1y8UniJ5J/1j5y6yjdKuApyoDR1
G7JvzuYhNy2uwj4BMrB+N+fTHcmFvU7TiHkPqxYgh8GESn/UJPNcMpAe+If3fqD8
ANUdZWOhrdzr0YJ0k+s4BgQbNvHz4aBwFRAKc7zJKWTP3oO8MVoDRpnci323SV+n
YL4x6sgxJAbSypsclATuH320xVFvnCwYEDGzR08u0dr7H80KxRXdAT1nLXuViB0V
jH1phLGr+A7kvoeKW6Xl+Cj9UTeg4Q4pr0jIbQMqy+NnQu9/5X9HfHR/XtqjkH4G
5j2DlQlZLElxRZMd65I3ysX6CldxsQLkPpE2QKCZYK3g6zB945EWjsgtgVqsmGzA
0O9HJ8Vd1ZF1/0WrWgPSFgfR/0J3fI1irguT2Am1TMKPnRw3RbOUR40gHQYyTxG7
cI9ojrMDAmBzScxY64SNBXNS7yORkejgTTHoQ46MfWW9DsFASC4g9afEBuiZppH3
joSnm99dxWuI8Cs/K6e4vkSjyZmojJMrHSQMGieiCotvV1kxgfG2f60LgWu3qGYm
3sucOqW+tuYpe8DrLQD0SuJYblzcewq1+cgzoDqrW8PQHBa6wBU=
=u3aX
-----END PGP SIGNATURE-----

--evfdzugpiahk5lk6--
