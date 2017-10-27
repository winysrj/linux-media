Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751263AbdJ0Or2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 10:47:28 -0400
Date: Fri, 27 Oct 2017 16:47:25 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 11/32] omap3isp: Fix check for our own sub-devices
Message-ID: <20171027144725.y7rtlq5kyj4yz37l@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-12-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5h5nqqtb2ria5tjw"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-12-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5h5nqqtb2ria5tjw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:21AM +0300, Sakari Ailus wrote:
> We only want to link sub-devices that were bound to the async notifier the
> isp driver registered but there may be other sub-devices in the
> v4l2_device as well. Check for the correct async notifier.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/platform/omap3isp/isp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platfo=
rm/omap3isp/isp.c
> index 97a5206b6ddc..4afd7ba4fad6 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2155,7 +2155,7 @@ static int isp_subdev_notifier_complete(struct v4l2=
_async_notifier *async)
>  		return ret;
> =20
>  	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
> -		if (!sd->asd)
> +		if (sd->notifier !=3D &isp->notifier)
>  			continue;
> =20
>  		ret =3D isp_link_entity(isp, &sd->entity,
> --=20
> 2.11.0
>=20

--5h5nqqtb2ria5tjw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlnzRv0ACgkQ2O7X88g7
+pouxQ/+PPpU+CgRA2Xl2ZFWexKcaFEOqcDf87tWSl2+qRm50hdXdku1l2G7I6GO
WRko3onjLNDLppVetbIf5iNk1b/T+XiOtcm8AIGuZldUy2D2bcJFkxwVdNzTcgiy
QcKu8so1G5DQsoh96ZQTbchWzsISuHCDRsl0ViZF56sUxPEkNb8dyBhviKkIR/kO
lbvNMZ4EMpNkR4AC7Rjpi1KIMAovPozjJRXsHyvA2y/cOIpGXz7aQIim1f+SVNR0
8hvWap8DsD+jnJ9uJSc5AYguN4aSOQd8nZ2f+Dz9oIdJXNSuDANk7P1aiPv8Xz9p
gfHabWrtVNZZvYxJsbDmh8rDxmr/xM8rubPcTdkcH5elDDDADqIT4DkV2UpX8GT8
+TC6XnjoC4IegBGmzgOTM9GNMjgwawgNHVy2CPt9XeFhNVrOhk75+sN+z/ZtIqyK
DDjGPxgSp2aatnj5QJ1NonByoYOIgKZCK5HP/Q2WBKsfTj0kb8z942bVV4+b2W+S
GId6qSODbaHba9oJQ3efty2UiFts8U9f+Y0ZtzUzWU/ztX1R3sHMs0yrzZwbDvWy
OJPbPsDZoaHYQZlVHuKthPBM55IhAxJ2yvgTstseaoulLtIjIjjvfIGb9q/4goPE
Pb9SIZ040sx7Rb0fLLv4VzgbJHluFB9Gr0EJjK/jozm73tEIX4k=
=m/PO
-----END PGP SIGNATURE-----

--5h5nqqtb2ria5tjw--
