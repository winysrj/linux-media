Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42795 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbcEJLg4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2016 07:36:56 -0400
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
CC: <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <5731C7D2.4090807@ti.com>
Date: Tue, 10 May 2016 14:36:50 +0300
MIME-Version: 1.0
In-Reply-To: <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="a7GwQBSJuHeQvLR5nTWADES1SXqew47sn"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--a7GwQBSJuHeQvLR5nTWADES1SXqew47sn
Content-Type: multipart/mixed; boundary="ujVXbJqW6xonJAViRmxpbTkOPeNd8piDb"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hans.verkuil@cisco.com>
Message-ID: <5731C7D2.4090807@ti.com>
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>

--ujVXbJqW6xonJAViRmxpbTkOPeNd8piDb
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On 29/04/16 12:39, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> As long as there is a valid physical address in the EDID and the omap
> CEC support is enabled, then we keep ls_oe_gpio on to ensure the CEC
> signal is passed through the tpd12s015.
>=20
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Suggested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> ---
>  drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c | 13 ++++++++++++=
-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c b/dri=
vers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
> index 916a899..efbba23 100644
> --- a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
> +++ b/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
> @@ -16,6 +16,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/gpio/consumer.h>
> =20
> +#include <media/cec-edid.h>
>  #include <video/omapdss.h>
>  #include <video/omap-panel-data.h>
> =20
> @@ -65,6 +66,7 @@ static void tpd_disconnect(struct omap_dss_device *ds=
sdev,
>  		return;
> =20
>  	gpiod_set_value_cansleep(ddata->ct_cp_hpd_gpio, 0);
> +	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 0);
> =20
>  	dst->src =3D NULL;
>  	dssdev->dst =3D NULL;
> @@ -142,6 +144,7 @@ static int tpd_read_edid(struct omap_dss_device *ds=
sdev,
>  {
>  	struct panel_drv_data *ddata =3D to_panel_data(dssdev);
>  	struct omap_dss_device *in =3D ddata->in;
> +	bool valid_phys_addr =3D 0;
>  	int r;
> =20
>  	if (!gpiod_get_value_cansleep(ddata->hpd_gpio))
> @@ -151,7 +154,15 @@ static int tpd_read_edid(struct omap_dss_device *d=
ssdev,
> =20
>  	r =3D in->ops.hdmi->read_edid(in, edid, len);
> =20
> -	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 0);
> +#ifdef CONFIG_OMAP2_DSS_HDMI_CEC
> +	/*
> +	 * In order to support CEC this pin should remain high
> +	 * as long as the EDID has a valid physical address.
> +	 */
> +	valid_phys_addr =3D
> +		cec_get_edid_phys_addr(edid, r, NULL) !=3D CEC_PHYS_ADDR_INVALID;
> +#endif
> +	gpiod_set_value_cansleep(ddata->ls_oe_gpio, valid_phys_addr);
> =20
>  	return r;
>  }

I think this works, but... Maybe it would be cleaner to have the LS_OE
enabled if a cable is connected. That's actually what we had earlier,
but I removed that due to a race issue:

a87a6d6b09de3118e5679c2057b99b7791b7673b ("OMAPDSS: encoder-tpd12s015:
Fix race issue with LS_OE"). Now, with CEC, there's need to have LS_OE
enabled even after reading the EDID, so I think it's better to go back
to the old model (after fixing the race issue, of course =3D).

 Tomi


--ujVXbJqW6xonJAViRmxpbTkOPeNd8piDb--

--a7GwQBSJuHeQvLR5nTWADES1SXqew47sn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXMcfSAAoJEPo9qoy8lh71wyAQAJRHBF4tPbyqblEqaaVQKDXQ
dRaEG3WVv5yG40RLJZzYOIx30aIXsVyjmLGGPUKXXhKRw+VXN+SR6FClsMolZl9w
oEcLFIkLH6N46wYCHuUgAznPxVsUWvwthtj3TE7tBSlV648k+GnVq1RGhv98r4UK
eCah953gTMV8AOETlm9PKpcNEj1dxVCk/8SgOtZufYgbFqKeHq0ZGLIFv+1bnRZn
6qT0tJZIXUBQEGaXEA4FjdwJGwZ1EOWMN6HQ9C8of1jLV6sdVXHYUuRNrmtwHUhb
gFP5O3jbmz7iuXkZIyc97JKP8SaszONncb1swssNEvMI3TI3bKpVMxksyHuFurVR
xjskOvmoB+7cWcsxO4rL2TAW0pKMxVcvvO3QuoIucK51Ctlh5WVJItI0yRmK/kTh
Hyg32uVzNbclheAEbscYrQ7YUoDM8EC7eK+mreNmOuIYfQEPeSlZppLY5Fm3C8lV
OMJS18dubKnb6r+yGXjyFHnWW4ZHsUMz2mhkX8AvwCoj0rlCPN3/qD1VgO0PXREZ
srQqpzVhqnHxzKHbyOEMoTwDOBOEN/HjUlr7gBhS1fhWuYTeue0NDrvq4CP1m20g
u6g9ULPNW7YbFGAfqv8R7SWnoK3VSNabSD0sdqvL6B+tcqiw3YXOdR5/aunakSOr
arOgAXio6fvFpcoN1J1w
=S1tQ
-----END PGP SIGNATURE-----

--a7GwQBSJuHeQvLR5nTWADES1SXqew47sn--
