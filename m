Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33775 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbdGFLHy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 07:07:54 -0400
Date: Thu, 6 Jul 2017 13:07:45 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 3/8] v4l: fwnode: Call CSI2 bus csi2, not csi
Message-ID: <20170706110745.2qpfeh2dkfxfxynw@earth>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
 <20170705230019.5461-4-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="v55s26rpecmb4fxd"
Content-Disposition: inline
In-Reply-To: <20170705230019.5461-4-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--v55s26rpecmb4fxd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 06, 2017 at 02:00:14AM +0300, Sakari Ailus wrote:
> The function to parse CSI2 bus parameters was called
> v4l2_fwnode_endpoint_parse_csi_bus(), rename it as
> v4l2_fwnode_endpoint_parse_csi2_bus() in anticipation of CSI1/CCP2
> support.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-c=
ore/v4l2-fwnode.c
> index 153c53ca3925..8df26010d006 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -28,8 +28,8 @@
> =20
>  #include <media/v4l2-fwnode.h>
> =20
> -static int v4l2_fwnode_endpoint_parse_csi_bus(struct fwnode_handle *fwno=
de,
> -					      struct v4l2_fwnode_endpoint *vep)
> +static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwn=
ode,
> +					       struct v4l2_fwnode_endpoint *vep)
>  {
>  	struct v4l2_fwnode_bus_mipi_csi2 *bus =3D &vep->bus.mipi_csi2;
>  	bool have_clk_lane =3D false;
> @@ -176,7 +176,7 @@ int v4l2_fwnode_endpoint_parse(struct fwnode_handle *=
fwnode,
>  	memset(&vep->bus_type, 0, sizeof(*vep) -
>  	       offsetof(typeof(*vep), bus_type));
> =20
> -	rval =3D v4l2_fwnode_endpoint_parse_csi_bus(fwnode, vep);
> +	rval =3D v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
>  	if (rval)
>  		return rval;
>  	/*
> --=20
> 2.11.0
>=20

--v55s26rpecmb4fxd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlleGf0ACgkQ2O7X88g7
+poYoxAAp5YvZRXHSnIXcqgPOD/iBa2X9tlg1D/ejvtIYo+nJs65K3tjaFKmBj5g
Z8y3ZHZSwT1JEwYV+e7E5UQrrKRn5JL8w159OISEmhOsILKfvbvsXEClGJEY0KdG
NXJryLcVNtlo7o3q8Iz8MykqicVKL9pHnIo9ykyBp/F9M4GuEQiI1mu+ckSF+Qpe
Uu/MLe6Rye3Muo02SU58JRqvubarkwqKXsnsYe4dC2eMuTPwnxYdVQXE8pXzeeEj
c/R8BPhPCQ1tWgFP7Vw6ozVFYRPcYmnbA+CmwQYnvBoVphzfmMt3pH9S1bNeIJ9L
VMRNlw2Pt/0wg+0GEMH5nkUt/EKSanOoiOKzJTw/JqFfrW0axm0/tG7sxBO6nRbx
KhswMLvzWkFXMtrJjeqDOEwxAeWdX+6jEDbqoxr7M41nXMKzn4NaEdeKSiYGsRHa
/j5Wwaxf8OF9YW75I0ma76CpSIBYXB/cxuYufu/b+RueasFCRWQuMBetGHMPa2lK
TZoxPN5wrOOTDZ/D7IJcLxXHNsJTm77TR/vEdW/EkpnxTHbJOdypAc0e32+53rAY
ZiduD7tNXsLftaSfdBAMeqKYz9MviSlegK1JrItYVsYmdb4b5w8znaM84D2PlBtx
EFIHOWT4Xvq81vyYeKm06IvNdx7FMiqHzODPGGVyQ/C8FToT9as=
=qKAJ
-----END PGP SIGNATURE-----

--v55s26rpecmb4fxd--
