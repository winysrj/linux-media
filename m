Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:39156 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbdGLSm5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 14:42:57 -0400
From: Eric Anholt <eric@anholt.net>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        boris.brezillon@free-electrons.com
Subject: Re: [PATCH 2/4] drm/vc4: prepare for CEC support
In-Reply-To: <20170711112021.38525-3-hverkuil@xs4all.nl>
References: <20170711112021.38525-1-hverkuil@xs4all.nl> <20170711112021.38525-3-hverkuil@xs4all.nl>
Date: Wed, 12 Jul 2017 11:42:53 -0700
Message-ID: <87fue1h4ya.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hans Verkuil <hverkuil@xs4all.nl> writes:

> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> In order to support CEC the hsm clock needs to be enabled in
> vc4_hdmi_bind(), not in vc4_hdmi_encoder_enable(). Otherwise you wouldn't
> be able to support CEC when there is no hotplug detect signal, which is
> required by some monitors that turn off the HPD when in standby, but keep
> the CEC bus alive so they can be woken up.
>
> The HDMI core also has to be enabled in vc4_hdmi_bind() for the same
> reason.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Ccing Boris, I'd love to see what he thinks of this and if we can do any
better.

Hans, is it true that CEC needs to be on always, or could it only be
enabled when somebody is listening to messages?

>  drivers/gpu/drm/vc4/vc4_hdmi.c | 59 +++++++++++++++++++++---------------=
------
>  1 file changed, 29 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdm=
i.c
> index ed63d4e85762..e0104f96011e 100644
> --- a/drivers/gpu/drm/vc4/vc4_hdmi.c
> +++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
> @@ -463,11 +463,6 @@ static void vc4_hdmi_encoder_disable(struct drm_enco=
der *encoder)
>  	HD_WRITE(VC4_HD_VID_CTL,
>  		 HD_READ(VC4_HD_VID_CTL) & ~VC4_HD_VID_CTL_ENABLE);
>=20=20
> -	HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_SW_RST);
> -	udelay(1);
> -	HD_WRITE(VC4_HD_M_CTL, 0);
> -
> -	clk_disable_unprepare(hdmi->hsm_clock);
>  	clk_disable_unprepare(hdmi->pixel_clock);
>=20=20
>  	ret =3D pm_runtime_put(&hdmi->pdev->dev);
> @@ -509,16 +504,6 @@ static void vc4_hdmi_encoder_enable(struct drm_encod=
er *encoder)
>  		return;
>  	}
>=20=20
> -	/* This is the rate that is set by the firmware.  The number
> -	 * needs to be a bit higher than the pixel clock rate
> -	 * (generally 148.5Mhz).
> -	 */
> -	ret =3D clk_set_rate(hdmi->hsm_clock, 163682864);
> -	if (ret) {
> -		DRM_ERROR("Failed to set HSM clock rate: %d\n", ret);
> -		return;
> -	}
> -
>  	ret =3D clk_set_rate(hdmi->pixel_clock,
>  			   mode->clock * 1000 *
>  			   ((mode->flags & DRM_MODE_FLAG_DBLCLK) ? 2 : 1));
> @@ -533,20 +518,6 @@ static void vc4_hdmi_encoder_enable(struct drm_encod=
er *encoder)
>  		return;
>  	}
>=20=20
> -	ret =3D clk_prepare_enable(hdmi->hsm_clock);
> -	if (ret) {
> -		DRM_ERROR("Failed to turn on HDMI state machine clock: %d\n",
> -			  ret);
> -		clk_disable_unprepare(hdmi->pixel_clock);
> -		return;
> -	}
> -
> -	HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_SW_RST);
> -	udelay(1);
> -	HD_WRITE(VC4_HD_M_CTL, 0);
> -
> -	HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_ENABLE);
> -
>  	HDMI_WRITE(VC4_HDMI_SW_RESET_CONTROL,
>  		   VC4_HDMI_SW_RESET_HDMI |
>  		   VC4_HDMI_SW_RESET_FORMAT_DETECT);
> @@ -1205,6 +1176,23 @@ static int vc4_hdmi_bind(struct device *dev, struc=
t device *master, void *data)
>  		return -EPROBE_DEFER;
>  	}
>=20=20
> +	/* This is the rate that is set by the firmware.  The number
> +	 * needs to be a bit higher than the pixel clock rate
> +	 * (generally 148.5Mhz).
> +	 */
> +	ret =3D clk_set_rate(hdmi->hsm_clock, 163682864);
> +	if (ret) {
> +		DRM_ERROR("Failed to set HSM clock rate: %d\n", ret);
> +		goto err_put_i2c;
> +	}
> +
> +	ret =3D clk_prepare_enable(hdmi->hsm_clock);
> +	if (ret) {
> +		DRM_ERROR("Failed to turn on HDMI state machine clock: %d\n",
> +			  ret);
> +		goto err_put_i2c;
> +	}
> +
>  	/* Only use the GPIO HPD pin if present in the DT, otherwise
>  	 * we'll use the HDMI core's register.
>  	 */
> @@ -1216,7 +1204,7 @@ static int vc4_hdmi_bind(struct device *dev, struct=
 device *master, void *data)
>  							 &hpd_gpio_flags);
>  		if (hdmi->hpd_gpio < 0) {
>  			ret =3D hdmi->hpd_gpio;
> -			goto err_put_i2c;
> +			goto err_unprepare_hsm;
>  		}
>=20=20
>  		hdmi->hpd_active_low =3D hpd_gpio_flags & OF_GPIO_ACTIVE_LOW;
> @@ -1224,6 +1212,14 @@ static int vc4_hdmi_bind(struct device *dev, struc=
t device *master, void *data)
>=20=20
>  	vc4->hdmi =3D hdmi;
>=20=20
> +	/* HDMI core must be enabled. */
> +	if (!(HD_READ(VC4_HD_M_CTL) & VC4_HD_M_ENABLE)) {
> +		HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_SW_RST);
> +		udelay(1);
> +		HD_WRITE(VC4_HD_M_CTL, 0);
> +
> +		HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_ENABLE);
> +	}

I'm wondering if there's any impact from leaving VC4_HD_M_ENABLE on
while the HDMI power domain is off.  I don't quite understand the role
of the power domain, and I've fired off an email internally to check if
there are any experts on this hardware still around.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAllmba0ACgkQtdYpNtH8
nuiC3A//aldYCoyP9jl+z7pI1mU0GlnowZCsr3OAB4Mdxvxime1g28ZWIxCmp+5d
M98APQvJwuU/3DYKOoE9CrBdMN4pmgd/l6Scg0z4hLU+PWbazxRtxZfUSuGD+Dih
EopeQcgk770CSbtaoMSvrZjgK37PUl/hmbcsIVOIq7rrY0yPZY1IKyrQ2CZhj9j/
qGiVldoiRhZvAoHyYt3O+Fq5L/kg5mPESHFahl6AnRrPzbNN+q0SmRDQuGSQfrvI
pej2EpgusfYAFd0WPQ3AymcpovsKZosxcapiHLv7XX3RLto0nHqzD+TDAu/T4Y2E
WrEFTM84dZH7nMjC0kBJmphE8MqW8ddHqH+chWnbZcWIl6pKj0lixugEXKjRpLwF
YBdcr4/IQ++3s6YWFgZ/rt7YdiLsOC1I4KLcuuLYZSNzfd3omonooM3guoS5tuxE
eCOIoValIXrZ0O4NWU/pbpZ4itTuZphVOejrGsbcnXEBLx0q9UPdLiNXcXKGWUYD
9ZbngA1KxJqEkVUPMdrJrg7dpOjE6ymaDAsJ+7e/ytFyt5kD5uUPMlMMyD9vsKbo
EoFql6vHOEu93GPEtjVHw+A96dIx+xp9ddC1m5VKfaqug+Ak6YSFic8ydCHZgRPD
BC9iJ8cKnfzMeS7xPFuIJvigwqRkBCIWYgpxmrcFPc1Cs4vNjBc=
=Y4nP
-----END PGP SIGNATURE-----
--=-=-=--
