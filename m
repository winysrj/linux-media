Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:36543 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1KGSme (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 13:42:34 -0500
Date: Mon, 7 Nov 2011 21:43:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: re: [media] V4L: soc-camera: make (almost) all client drivers
 re-usable outside of the framework
Message-ID: <20111107184310.GY4682@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1fZJyN7nFm/tosmV"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--1fZJyN7nFm/tosmV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guennadi,

Gcc complains about 2f0babb7e432 "[media] V4L: soc-camera: make
(almost) all client drivers re-usable outside of the framework"

include/media/soc_camera.h: In function =E2=80=98soc_camera_i2c_to_vdev=E2=
=80=99:
include/media/soc_camera.h:257:34: warning: cast to pointer from integer of=
 different size [-Wint-to-pointer-cast]

--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -253,14 +253,14 @@ unsigned long soc_camera_apply_board_flags(struct soc=
_camera_link *icl,
 #include <linux/i2c.h>
  static inline struct video_device *soc_camera_i2c_to_vdev(const struct i2=
c_client *client)
   {
   -       struct soc_camera_device *icd =3D client->dev.platform_data;
   +       struct v4l2_subdev *sd =3D i2c_get_clientdata(client);
   +       struct soc_camera_device *icd =3D (struct soc_camera_device *)sd=
->grp_id;
           return icd ? icd->vdev : NULL;

sd->grp_id is a u32 so this doesn't work on 64 bit systems.

regards,
dan carpenter

--1fZJyN7nFm/tosmV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuCa9AAoJEOnZkXI/YHqR/WEQAKCK13ASl0sNYG9PAIfGIxBL
oZRyiwqJJ8p8lm6ERcvrdVUy5HkN8piIow7r47qqrPLymbHOZ1JHhwm+PQOTKylB
lgk2Dx9rz/IUJTC8Uhsb0Z8rgn5euqXBxX/cxHHCOfeNLe1z5WldLrJTkkmhzv4V
DvkUtq5dylCycs/Y1t46hlGzQ/ZkAB5Vg25Ug2Go6o5jqrx6yPkf8TYuDK7ZcD+E
hToGk0JdtoxmkIXQdbs1tT+edp9lJzFHty6tRkGpjSMxVChelvfvunTU+8RZIHDI
894C1H+kEueTcfgm5CJLpaM1PieabNWxresdGrWu0WiCibdi8AG/5L1/e6XDaMWk
1PIYAplcNUe5jIZT1fXXcEIXVz0CJ5Bc4pL+CZOb2tQzNIEPK2PQo6SI/vMfFnx3
WwEo3mGjdcVvWRkt/C7kuFFh5Wr6Ew0IDpftY0r+BiLejqvmymwJR9wcjEpFhY6U
VQat18nRGOUtSp9L56PjlRhOfy45tZKGcAamQutvCctDEIZ3+vGjZBOAc285LRTp
wMmwTXnIMt03PMqR/tXwyGoVVHNyZ2V5vx2pfXovx2ac06G1K6H5y8qfEKV0DVLV
6X78t7gzkzKqd/3nMJQKR/hLb+cb5nAINwxB6CK0bKTwb3rbPsXrZxd6VJgUHRp1
6U/2O+247VW8feBPPuyF
=hNYQ
-----END PGP SIGNATURE-----

--1fZJyN7nFm/tosmV--
