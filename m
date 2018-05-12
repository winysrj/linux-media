Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50066 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbeELIEX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 04:04:23 -0400
Subject: Re: [PATCH v2] media: i2c: adv748x: Fix pixel rate values
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-renesas-soc@vger.kernel.org
References: <20180511140434.19274-1-niklas.soderlund+renesas@ragnatech.se>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <2585299a-07a7-5596-7df2-fe476b695dcb@ideasonboard.com>
Date: Sat, 12 May 2018 09:04:18 +0100
MIME-Version: 1.0
In-Reply-To: <20180511140434.19274-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="MUYJ1SV37YUyOJohlz1DPw3fZKwDoU2FO"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MUYJ1SV37YUyOJohlz1DPw3fZKwDoU2FO
Content-Type: multipart/mixed; boundary="pTQTzrVjGub1bRz4QNBkAWM3gJ9RhRTzn";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
 <niklas.soderlund+renesas@ragnatech.se>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 linux-media@vger.kernel.org
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
 linux-renesas-soc@vger.kernel.org
Message-ID: <2585299a-07a7-5596-7df2-fe476b695dcb@ideasonboard.com>
Subject: Re: [PATCH v2] media: i2c: adv748x: Fix pixel rate values
References: <20180511140434.19274-1-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180511140434.19274-1-niklas.soderlund+renesas@ragnatech.se>

--pTQTzrVjGub1bRz4QNBkAWM3gJ9RhRTzn
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Niklas, Laurent,

Thanks for the updated patch and detailed investigation to get this right=
=2E

On 11/05/18 15:04, Niklas S=C3=B6derlund wrote:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>=20
> The pixel rate, as reported by the V4L2_CID_PIXEL_RATE control, must
> include both horizontal and vertical blanking. Both the AFE and HDMI
> receiver program it incorrectly:
>=20
> - The HDMI receiver goes to the trouble of removing blanking to compute=

> the rate of active pixels. This is easy to fix by removing the
> computation and returning the incoming pixel clock rate directly.
>=20
> - The AFE performs similar calculation, while it should simply return
> the fixed pixel rate for analog sources, mandated by the ADV748x to be
> 14.3180180 MHz.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.=
com>
> [Niklas: Update AFE fixed pixel rate]
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatec=
h.se>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Does this still require changes to the CSI2 driver to be synchronised?
(or does it not matter as the CSI2 isn't upstream yet)...

--
Kieran


> ---
>=20
> * Changes since v1
> - Update AFE fixed pixel rate.
> ---
>  drivers/media/i2c/adv748x/adv748x-afe.c  | 12 ++++++------
>  drivers/media/i2c/adv748x/adv748x-hdmi.c |  8 +-------
>  2 files changed, 7 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2=
c/adv748x/adv748x-afe.c
> index 61514bae7e5ceb42..edd25e895e5dec3c 100644
> --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> @@ -321,17 +321,17 @@ static const struct v4l2_subdev_video_ops adv748x=
_afe_video_ops =3D {
>  static int adv748x_afe_propagate_pixelrate(struct adv748x_afe *afe)
>  {
>  	struct v4l2_subdev *tx;
> -	unsigned int width, height, fps;
> =20
>  	tx =3D adv748x_get_remote_sd(&afe->pads[ADV748X_AFE_SOURCE]);
>  	if (!tx)
>  		return -ENOLINK;
> =20
> -	width =3D 720;
> -	height =3D afe->curr_norm & V4L2_STD_525_60 ? 480 : 576;
> -	fps =3D afe->curr_norm & V4L2_STD_525_60 ? 30 : 25;
> -
> -	return adv748x_csi2_set_pixelrate(tx, width * height * fps);
> +	/*
> +	 * The ADV748x ADC sampling frequency is twice the externally supplie=
d
> +	 * clock whose frequency is required to be 28.63636 MHz. It oversampl=
es
> +	 * with a factor of 4 resulting in a pixel rate of 14.3180180 MHz.
> +	 */
> +	return adv748x_csi2_set_pixelrate(tx, 14318180);
>  }
> =20
>  static int adv748x_afe_enum_mbus_code(struct v4l2_subdev *sd,
> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i=
2c/adv748x/adv748x-hdmi.c
> index 10d229a4f08868f7..aecc2a84dfecbec8 100644
> --- a/drivers/media/i2c/adv748x/adv748x-hdmi.c
> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> @@ -402,8 +402,6 @@ static int adv748x_hdmi_propagate_pixelrate(struct =
adv748x_hdmi *hdmi)
>  {
>  	struct v4l2_subdev *tx;
>  	struct v4l2_dv_timings timings;
> -	struct v4l2_bt_timings *bt =3D &timings.bt;
> -	unsigned int fps;
> =20
>  	tx =3D adv748x_get_remote_sd(&hdmi->pads[ADV748X_HDMI_SOURCE]);
>  	if (!tx)
> @@ -411,11 +409,7 @@ static int adv748x_hdmi_propagate_pixelrate(struct=
 adv748x_hdmi *hdmi)
> =20
>  	adv748x_hdmi_query_dv_timings(&hdmi->sd, &timings);
> =20
> -	fps =3D DIV_ROUND_CLOSEST_ULL(bt->pixelclock,
> -				    V4L2_DV_BT_FRAME_WIDTH(bt) *
> -				    V4L2_DV_BT_FRAME_HEIGHT(bt));
> -
> -	return adv748x_csi2_set_pixelrate(tx, bt->width * bt->height * fps);
> +	return adv748x_csi2_set_pixelrate(tx, timings.bt.pixelclock);
>  }
> =20
>  static int adv748x_hdmi_enum_mbus_code(struct v4l2_subdev *sd,
>=20


--pTQTzrVjGub1bRz4QNBkAWM3gJ9RhRTzn--

--MUYJ1SV37YUyOJohlz1DPw3fZKwDoU2FO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlr2oAIACgkQoR5GchCk
Yf3g1hAApKMYxrAd0j/DsCsZh914Es6IbQnJ7xI37yeIiM5lNPe8IO6gG0L8oDgk
V2qKTpIgI0O+H73YKJmA89ID7JyHsBJR4O0PGn77DBWccJX8Jltz+N2bn4nIEZWX
TKq2+UMIwffrvXYN7K54rwRapJGOpG3g+PjGxgcqSmt1E/R53WDetKbggDdJ7Gtx
OMCoOX6IAMO8trnJ6ikxX94rSFQTH8e2QlQObfGt6nZ+YMKQ4BqBWWFDhapU56Hr
YWw7oAWFbBi9Wxm8osXSTrDOizdk1iwGtJ70enEh+F0RujHsLQpkWUZOWFWiGWSD
N3Hvz9JaNeEYnJ5L7tuK9Ws9QhlyFu4sdPHgEBv0co7N/VMxfI9cQT/PQ05ds5Tm
KAFHACLomQaHcIuXATjJCDEIZ47K5goUxEARDPbruSjs4bRTHZxI/2pe6SAfkY6z
LIFOAonoQ1hAZ0Ao8DQc4DRW49MioocBvJrZTs+JTl4POYrtVB15gN/z/1QrfLHY
Y1AkJDI5NuoOaTBVK8/ruVJ2MXAVZdlmiHYYnqOnBTVWLIbSCz2t/tOt2uHiRHHv
14mLGP8dnJRrXaHUWX6unPL2iflIcrdZix6joj6+9TgvAV773HZW1drbwLKE+rm3
1L/Mja8myIVcnmKYVZeNqJfUIjsGfeQO1hy9tilElXU+bPeu7AU=
=TK9k
-----END PGP SIGNATURE-----

--MUYJ1SV37YUyOJohlz1DPw3fZKwDoU2FO--
