Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95433C10F06
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 18:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6618721872
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 18:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbfBQSlT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 13:41:19 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:58577 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfBQSlT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 13:41:19 -0500
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 93A1D240002;
        Sun, 17 Feb 2019 18:41:15 +0000 (UTC)
Date:   Sun, 17 Feb 2019 19:41:40 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-csi2: Allow configuring of video standard
Message-ID: <20190217184140.3duyiwjpgsswcgbx@uno.localdomain>
References: <20190216225758.7699-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tk34rrgkiernvn2l"
Content-Disposition: inline
In-Reply-To: <20190216225758.7699-1-niklas.soderlund+renesas@ragnatech.se>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--tk34rrgkiernvn2l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,
    where is this patch supposed to be applied on?

I tried master, media master, renesas-drivers and your rcar-csi2 and
v4l2/mux branches, but it fails on all of them :(

What am I doing wrong?

On Sat, Feb 16, 2019 at 11:57:58PM +0100, Niklas S=C3=B6derlund wrote:
> Allow the hardware to to do proper field detection for interlaced field
> formats by implementing s_std() and g_std(). Depending on which video
> standard is selected the driver needs to setup the hardware to correctly
> identify fields.
>
> Later versions of the datasheet have also been updated to make it clear
> that FLD register should be set to 0 when dealing with none interlaced
> field formats.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 33 +++++++++++++++++++--
>  1 file changed, 30 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/=
platform/rcar-vin/rcar-csi2.c
> index f3099f3e536d808a..664d3784be2b9db9 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -361,6 +361,7 @@ struct rcar_csi2 {
>  	struct v4l2_subdev *remote;
>
>  	struct v4l2_mbus_framefmt mf;
> +	v4l2_std_id std;
>
>  	struct mutex lock;
>  	int stream_count;
> @@ -389,6 +390,22 @@ static void rcsi2_write(struct rcar_csi2 *priv, unsi=
gned int reg, u32 data)
>  	iowrite32(data, priv->base + reg);
>  }
>
> +static int rcsi2_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
> +{
> +	struct rcar_csi2 *priv =3D sd_to_csi2(sd);
> +
> +	priv->std =3D std;
> +	return 0;

Nit: (almost) all other functions in the file have an empty line
before return...

> +}
> +
> +static int rcsi2_g_std(struct v4l2_subdev *sd, v4l2_std_id *std)
> +{
> +	struct rcar_csi2 *priv =3D sd_to_csi2(sd);
> +
> +	*std =3D priv->std;

Should priv->std be initialized or STD_UNKNOWN is fine?

> +	return 0;
> +}
> +
>  static void rcsi2_standby_mode(struct rcar_csi2 *priv, int on)
>  {
>  	if (!on) {
> @@ -475,7 +492,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, un=
signed int bpp)
>  static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  {
>  	const struct rcar_csi2_format *format;
> -	u32 phycnt, vcdt =3D 0, vcdt2 =3D 0;
> +	u32 phycnt, vcdt =3D 0, vcdt2 =3D 0, fld =3D 0;
>  	unsigned int i;
>  	int mbps, ret;
>
> @@ -507,6 +524,15 @@ static int rcsi2_start_receiver(struct rcar_csi2 *pr=
iv)
>  			vcdt2 |=3D vcdt_part << ((i % 2) * 16);
>  	}
>
> +	if (priv->mf.field !=3D V4L2_FIELD_NONE) {

I cannot tell where rcsi2_start_receiver() is called, as I don't have
it in my local version, but I suppose it has been break out from
rcsi2_start() has they set the same register. So this is called at
s_stream() time and priv->mf at set_format() time, right?

> +		fld =3D  FLD_FLD_EN4 | FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN;
> +
> +		if (priv->std & V4L2_STD_525_60)
> +			fld |=3D FLD_FLD_NUM(2);
> +		else
> +			fld |=3D FLD_FLD_NUM(1);

I haven't been able to find an explanation on why the field detection
depends on this specific video standard... I guess it is defined in some
standard I'm ignorant of, so I assume this is correct :)

Thanks
   j

> +	}
> +
>  	phycnt =3D PHYCNT_ENABLECLK;
>  	phycnt |=3D (1 << priv->lanes) - 1;
>
> @@ -519,8 +545,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *pri=
v)
>  	rcsi2_write(priv, PHTC_REG, 0);
>
>  	/* Configure */
> -	rcsi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
> -		    FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);
> +	rcsi2_write(priv, FLD_REG, fld);
>  	rcsi2_write(priv, VCDT_REG, vcdt);
>  	if (vcdt2)
>  		rcsi2_write(priv, VCDT2_REG, vcdt2);
> @@ -662,6 +687,8 @@ static int rcsi2_get_pad_format(struct v4l2_subdev *s=
d,
>  }
>
>  static const struct v4l2_subdev_video_ops rcar_csi2_video_ops =3D {
> +	.s_std =3D rcsi2_s_std,
> +	.g_std =3D rcsi2_g_std,
>  	.s_stream =3D rcsi2_s_stream,
>  };
>
> --
> 2.20.1
>

--tk34rrgkiernvn2l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxpquQACgkQcjQGjxah
VjySoQ//WJPwOxAVbRqqvDJdqfGpHJySwQ8JGjrMfT/L4q5BY97fYim9TROC5ZOM
TASorLowLR3NxhH/QeEPs05nI2ZWyG5k3iRv9jKv1T29tSsaHzPdVJPDsSek/jsg
Gv2dnvAcah3nAEBL3yuRyUfWg6nkKjufRueuj204mnd5SNWP71aEtyxTl7xPYcx6
UawGvYbJDSjcaoWRhETDry7SL90APa0W1+VLznK5KlAT/vMx8PDe97CPu3LmIppm
H5Ke+jzVlv4Lpn0XJv1VMWTLV3a31iFeC8kqIiOzxylJ+QTpYNP4D3ISqMSoi2Lj
zZVTsaZgA1p60iiIfKHHf54c2mNopINKoy8Omgu848UO9A/464vheW2PrYLhQ9+u
2MCQm5UE42Ta1eu502Ii/FKKTB2KhhCUQ2esDyKLMaL97EX8OT2rgHxVCxTno9y0
qtYfrbjgK1XZZ9jkIvoLyqawuR4OTMK5MQ7Bhp+QRhM/kT+2nSIbOnDLCI6FJcfV
KeAcKMbyVl6mutUzIZ71qdcxbZJgoqtYm01FUHljQLmmV6UM4WtV4qeADxZeL4EL
yPLQdaEX3WDWi4oTz3KlWIC4YKWYLYTs5NbhTYkTy+H0b2DEvrku0pEBbd3A5W/u
fWMk7SiY2eDccjm/+9h0R7Vz0H8uF0rOmtAB5bSoQN8TVc5Oqt0=
=Q9Wr
-----END PGP SIGNATURE-----

--tk34rrgkiernvn2l--
