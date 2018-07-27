Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49948 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbeG0Kpi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 06:45:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-csi2: update stream start for V3M
Date: Fri, 27 Jul 2018 12:25:13 +0300
Message-ID: <2085902.EcbZgA7qhr@avalon>
In-Reply-To: <20180726223657.26340-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180726223657.26340-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 27 July 2018 01:36:57 EEST Niklas S=F6derlund wrote:
> Latest errata document updates the start procedure for V3M. This change
> in addition to adhering to the datasheet update fixes capture on early
> revisions of V3M.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>=20
> ---
>=20
> Hi Hans, Mauro and Sakari
>=20
> I know this is late for v4.19 but if possible can it be considered? It
> fixes a real issue on R-Car V3M boards. I'm sorry for the late
> submission, the errata document accesses unfortunate did not align with
> the release schedule.
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> b/drivers/media/platform/rcar-vin/rcar-csi2.c index
> daef72d410a3425d..dc5ae8025832ab6e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -339,6 +339,7 @@ enum rcar_csi2_pads {
>=20
>  struct rcar_csi2_info {
>  	int (*init_phtw)(struct rcar_csi2 *priv, unsigned int mbps);
> +	int (*confirm_start)(struct rcar_csi2 *priv);
>  	const struct rcsi2_mbps_reg *hsfreqrange;
>  	unsigned int csi0clkfreqrange;
>  	bool clear_ulps;
> @@ -545,6 +546,13 @@ static int rcsi2_start(struct rcar_csi2 *priv)
>  	if (ret)
>  		return ret;
>=20
> +	/* Confirm start */
> +	if (priv->info->confirm_start) {
> +		ret =3D priv->info->confirm_start(priv);
> +		if (ret)
> +			return ret;
> +	}
> +

While PHTW has to be written in the "Confirmation of PHY start" sequence, t=
he=20
operation doesn't seem to be related to confirmation of PHY start, it inste=
ad=20
looks like a shuffle of the configuration sequence. I would thus not name t=
he=20
operation .confirm_start() as that's not what it does.

>  	/* Clear Ultra Low Power interrupt. */
>  	if (priv->info->clear_ulps)
>  		rcsi2_write(priv, INTSTATE_REG,
> @@ -880,6 +888,11 @@ static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_cs=
i2
> *priv, unsigned int mbps) }
>=20
>  static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int
> mbps)
> +{
> +	return rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
> +}
> +
> +static int rcsi2_confirm_start_v3m_e3(struct rcar_csi2 *priv)
>  {
>  	static const struct phtw_value step1[] =3D {
>  		{ .data =3D 0xed, .code =3D 0x34 },
> @@ -890,12 +903,6 @@ static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2
> *priv, unsigned int mbps) { /* sentinel */ },
>  	};
>=20
> -	int ret;
> -
> -	ret =3D rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
> -	if (ret)
> -		return ret;
> -

There's something I don't get here. According to the errata, it's the step1=
=20
array write sequence that need to be moved from "Start of PHY" to=20
"Confirmation of PHY start". This patch moves the PHTW frequency configurat=
ion=20
instead.

>  	return rcsi2_phtw_write_array(priv, step1);
>  }
>=20
> @@ -949,6 +956,7 @@ static const struct rcar_csi2_info
> rcar_csi2_info_r8a77965 =3D {
>=20
>  static const struct rcar_csi2_info rcar_csi2_info_r8a77970 =3D {
>  	.init_phtw =3D rcsi2_init_phtw_v3m_e3,
> +	.confirm_start =3D rcsi2_confirm_start_v3m_e3,
>  };
>=20
>  static const struct of_device_id rcar_csi2_of_table[] =3D {

=2D-=20
Regards,

Laurent Pinchart
