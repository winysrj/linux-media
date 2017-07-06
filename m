Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33780 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbdGFLIV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 07:08:21 -0400
Date: Thu, 6 Jul 2017 13:08:17 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, pavel@ucw.cz,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 4/8] v4l: fwnode: Obtain data bus type from FW
Message-ID: <20170706110817.5ja3y7y4wws6r4on@earth>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
 <20170705230019.5461-5-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qtholofhjb6hncfi"
Content-Disposition: inline
In-Reply-To: <20170705230019.5461-5-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qtholofhjb6hncfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 06, 2017 at 02:00:15AM +0300, Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
>=20
> Just obtain it. It'll actually get used soon with CSI-1/CCP2.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-c=
ore/v4l2-fwnode.c
> index 8df26010d006..d71dd3913cd9 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -28,6 +28,14 @@
> =20
>  #include <media/v4l2-fwnode.h>
> =20
> +enum v4l2_fwnode_bus_type {
> +	V4L2_FWNODE_BUS_TYPE_GUESS =3D 0,
> +	V4L2_FWNODE_BUS_TYPE_CSI2_CPHY,
> +	V4L2_FWNODE_BUS_TYPE_CSI1,
> +	V4L2_FWNODE_BUS_TYPE_CCP2,
> +	NR_OF_V4L2_FWNODE_BUS_TYPE,
> +};
> +
>  static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwn=
ode,
>  					       struct v4l2_fwnode_endpoint *vep)
>  {
> @@ -168,6 +176,7 @@ static void v4l2_fwnode_endpoint_parse_parallel_bus(
>  int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
>  			       struct v4l2_fwnode_endpoint *vep)
>  {
> +	u32 bus_type =3D 0;
>  	int rval;
> =20
>  	fwnode_graph_parse_endpoint(fwnode, &vep->base);
> @@ -176,6 +185,8 @@ int v4l2_fwnode_endpoint_parse(struct fwnode_handle *=
fwnode,
>  	memset(&vep->bus_type, 0, sizeof(*vep) -
>  	       offsetof(typeof(*vep), bus_type));
> =20
> +	fwnode_property_read_u32(fwnode, "bus-type", &bus_type);
> +
>  	rval =3D v4l2_fwnode_endpoint_parse_csi2_bus(fwnode, vep);
>  	if (rval)
>  		return rval;
> --=20
> 2.11.0
>=20

--qtholofhjb6hncfi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlleGiEACgkQ2O7X88g7
+pputA/+ID7r9WK4tKGLlHOq98w4M1QX0g8Y6Vt7GuBfZ/MKnRvqd7KNWIV8O3AK
DqFu1w3RLRnAvrliEmsLfalK+KL2WgObMpP+KSX0ZEzO8rqZKDh+njQUwVZohpeO
iph/OpWnW1MqBf0Gt55kOEKD1TCmBmz6tZi33x0vKaxcDGtDwrxJGufh+i965VDi
Zh65QcvOVr3bOD/08e6EG84eXr+iagurUiL8L/Ks3a+1cdCOQSh0LpNbtLIAenld
pDuStpWYLy6kgpJ3qMHGZ13/J4RN86b6dAgleWxMqZLx89Y2YS62bH+L3z7NZ4ND
w8QLZkCPgJ9eePy38VxGbFwtBXA+D51i1F0/Kgmwm41I02HUR8rKDr+ShHvyVY0o
KibHqlW0/o+vdDog0v+/l4nYYFV20VQeLyYfyculY7AzVmBr+5mVDh0Epl/4FfOm
ZQC9KWHZQGtwWCVpvgdeE/CY5TQ5Get69rS1jUjYt07Lgxew9NeHmSCdpFdSsJ0o
dXU++7s9oWZpccEerX5ulzIjK6VW/6uEZ6YimPWHiRi9yHMXpEH+fpQsSxbHU/9H
2aGy5e7cy8y+TxSJ8jmb67m3v0QWoUfQDPd7BSKxq06BfSu5g3Hm6Mm2oLiBQEmM
TvnJJjozdgZ2L/jKIUEHqYyrnuliKwabO1oOclASlmR0qNGvZeo=
=q8S2
-----END PGP SIGNATURE-----

--qtholofhjb6hncfi--
