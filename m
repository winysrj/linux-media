Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:11949 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165191AbdD1LeD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 07:34:03 -0400
Subject: Re: [PATCH 2/8] omapdrm: encoder-tpd12s015: keep ls_oe_gpio high if
 CEC is enabled
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-3-hverkuil@xs4all.nl>
CC: <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <8981bcbc-9aa0-d031-9a93-c69999059fdd@ti.com>
Date: Fri, 28 Apr 2017 14:33:50 +0300
MIME-Version: 1.0
In-Reply-To: <20170414102512.48834-3-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="h1Ia1kV36Qj9rn4jkkAKKko0D3dRteklq"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--h1Ia1kV36Qj9rn4jkkAKKko0D3dRteklq
Content-Type: multipart/mixed; boundary="e8e6rjVmSJbXfOeAKohwXJAvs41RFgrxi";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hans.verkuil@cisco.com>
Message-ID: <8981bcbc-9aa0-d031-9a93-c69999059fdd@ti.com>
Subject: Re: [PATCH 2/8] omapdrm: encoder-tpd12s015: keep ls_oe_gpio high if
 CEC is enabled
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-3-hverkuil@xs4all.nl>
In-Reply-To: <20170414102512.48834-3-hverkuil@xs4all.nl>

--e8e6rjVmSJbXfOeAKohwXJAvs41RFgrxi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 14/04/17 13:25, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> When the OMAP4 CEC support is enabled the CEC pin should always
> be on. So keep ls_oe_gpio high when CONFIG_OMAP4_DSS_HDMI_CEC
> is set.
>=20
> Background: even if the HPD is low it should still be possible
> to use CEC. Some displays will set the HPD low when they go into standb=
y or
> when they switch to another input, but CEC is still available and able
> to wake up/change input for such a display.
>=20
> This is explicitly allowed by the CEC standard.
>=20
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c b/dri=
vers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
> index 58276a48112e..757554e6d62f 100644
> --- a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
> +++ b/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
> @@ -46,6 +46,9 @@ static int tpd_connect(struct omap_dss_device *dssdev=
,
>  	dssdev->dst =3D dst;
> =20
>  	gpiod_set_value_cansleep(ddata->ct_cp_hpd_gpio, 1);
> +#ifdef CONFIG_OMAP4_DSS_HDMI_CEC
> +	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 1);
> +#endif
>  	/* DC-DC converter needs at max 300us to get to 90% of 5V */
>  	udelay(300);
> =20
> @@ -64,6 +67,7 @@ static void tpd_disconnect(struct omap_dss_device *ds=
sdev,
>  		return;
> =20
>  	gpiod_set_value_cansleep(ddata->ct_cp_hpd_gpio, 0);
> +	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 0);
> =20
>  	dst->src =3D NULL;
>  	dssdev->dst =3D NULL;
> @@ -146,11 +150,15 @@ static int tpd_read_edid(struct omap_dss_device *=
dssdev,
>  	if (!gpiod_get_value_cansleep(ddata->hpd_gpio))
>  		return -ENODEV;
> =20
> +#ifndef CONFIG_OMAP4_DSS_HDMI_CEC
>  	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 1);
> +#endif
> =20
>  	r =3D in->ops.hdmi->read_edid(in, edid, len);
> =20
> +#ifndef CONFIG_OMAP4_DSS_HDMI_CEC
>  	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 0);
> +#endif
> =20
>  	return r;
>  }
>=20

Optimally, we want to enable LS_OE only when needed, which would be when
reading EDID, using HDCP, or using CEC. But we don't have good means to
convey that information at the moment, and I'd rather leave it for later
when we have done the bigger restructuring of omapdrm.

For now, instead of the ifdef-confusion, I think we should just enable
the LS_OE in tpd_connect and be done with it.

 Tomi


--e8e6rjVmSJbXfOeAKohwXJAvs41RFgrxi--

--h1Ia1kV36Qj9rn4jkkAKKko0D3dRteklq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJZAyieAAoJEPo9qoy8lh71Y4gP/3GUY33xvqcBr6RHaEiU6Qi5
oESqA4THQj46JCEDJzQxI06+w9/MMfQl6IwmhIse4XeaOxGnoSjz+NGfjoBgkkUn
9C3qgWpM0jXtI/+29gI49UbZfbNzq5hi20SmNNVtmmsJCH6LhIA33m+5z2MLQ+By
mBEeSyMjoxue8P3XVv7pcznkPa/od+YronPOAhypWpXegOrPZDuqpoSBaMx/m1pU
0k6v0cQSx3Zz104pNcWuu+1/GmIzHUArIdy68+/E0ukks7AptNkK/bzMWhUFoLeR
dneIm58LMBgW/lSRzEQwf7qVVKYweNE9xB9FM5gS63qhZWUBAXUxOnPiW9OVhEfZ
ZNKtIg2nJSKSN/t5lVgiXL4wxUuVbY+0o/Lb/0zd1guoTXPRc37kJ8FCAXb0zkLX
LIPW9aQ8ogJu1//iZmf2gtqbqRpomfAtEliVavwCUHOiU+e8Pq4rc64pROtmHZDR
JcghosDj8e6F2F4Cz6FfaIusJEqO8NG2ET6MA1uXWoFMe9eUyJQtXje9c1zjPGxZ
kPJsDwf0W8tbADv2dqtijwHeH6OoVBkmjs3GbtiuxjhdZdf7GogSzjg5ETknUdr/
imribFFlhioHXyv0r42JDYwCnOQzRVqRwt8eV8OGwxdpyGFwOIZaiyZRz/dOq64w
gf9XwjLd843AF079HPEx
=cZRz
-----END PGP SIGNATURE-----

--h1Ia1kV36Qj9rn4jkkAKKko0D3dRteklq--
