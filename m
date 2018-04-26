Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:60762 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754447AbeDZVaM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 17:30:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        jacopo mondi <jacopo@jmondi.org>,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v14 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
Date: Fri, 27 Apr 2018 00:30:25 +0300
Message-ID: <4257407.ajpJjWYCOs@avalon>
In-Reply-To: <20180426202121.27243-3-niklas.soderlund+renesas@ragnatech.se>
References: <20180426202121.27243-1-niklas.soderlund+renesas@ragnatech.se> <20180426202121.27243-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Thursday, 26 April 2018 23:21:21 EEST Niklas S=F6derlund wrote:
> A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> supports the R-Car Gen3 SoCs where separate CSI-2 hardware blocks are
> connected between the video sources and the video grabbers (VIN).
>=20
> Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reviewed-by: Maxime Ripard <maxime.ripard@bootlin.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>=20
> ---
>=20
> * Changes since v13
> - Change return rcar_csi2_formats + i to return &rcar_csi2_formats[i].
> - Add define for PHCLM_STOPSTATECKL.
> - Update spelling in comments.
> - Update calculation in rcar_csi2_calc_phypll() according to
>   https://linuxtv.org/downloads/v4l-dvb-apis/kapi/csi2.html. The one
>   before v14 did not take into account that 2 bits per sample is
>   transmitted.

Just one small comment about this, please see below.

> - Use Geert's suggestion of (1 << priv->lanes) - 1 instead of switch
>   statement to set correct number of lanes to enable.
> - Change hex constants in hsfreqrange_m3w_h3es1[] to lower case to match
>   style of rest of file.
> - Switch to %u instead of 0x%x when printing bus type.
> - Switch to %u instead of %d for priv->lanes which is unsigned.
> - Add MEDIA_BUS_FMT_YUYV8_1X16 to the list of supported formats in
>   rcar_csi2_formats[].
> - Fixed bps for MEDIA_BUS_FMT_YUYV10_2X10 to 20 and not 16.
> - Set INTSTATE after PL-11 is confirmed to match flow chart in
>   datasheet.
> - Change priv->notifier.subdevs =3D=3D NULL to !priv->notifier.subdevs.
> - Add Maxime's and laurent's tags.
> ---
>  drivers/media/platform/rcar-vin/Kconfig     |  12 +
>  drivers/media/platform/rcar-vin/Makefile    |   1 +
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 883 ++++++++++++++++++++
>  3 files changed, 896 insertions(+)
>  create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c

[snip]


> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> b/drivers/media/platform/rcar-vin/rcar-csi2.c new file mode 100644
> index 0000000000000000..49b29d5680f9d80b
> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c

[snip]

> +static int rcar_csi2_calc_phypll(struct rcar_csi2 *priv, unsigned int bp=
p,
> +				 u32 *phypll)
> +{
> +	const struct phypll_hsfreqrange *hsfreq;
> +	struct v4l2_subdev *source;
> +	struct v4l2_ctrl *ctrl;
> +	u64 mbps;
> +
> +	if (!priv->remote)
> +		return -ENODEV;
> +
> +	source =3D priv->remote;
> +
> +	/* Read the pixel rate control from remote */
> +	ctrl =3D v4l2_ctrl_find(source->ctrl_handler, V4L2_CID_PIXEL_RATE);
> +	if (!ctrl) {
> +		dev_err(priv->dev, "no pixel rate control in subdev %s\n",
> +			source->name);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Calculate the phypll in mbps (from v4l2 documentation)
> +	 * link_freq =3D (pixel_rate * bits_per_sample) / (2 * nr_of_lanes)
> +	 */
> +	mbps =3D v4l2_ctrl_g_ctrl_int64(ctrl) * bpp;
> +	do_div(mbps, priv->lanes * 2000000);

pixel rate * bits per sample will give you the overall bit rate, which you=
=20
then divide by the number of lanes to get the bitrate per lane, and then by=
 2=20
as D-PHY is a DDR PHY and transmits 2 bits per clock cycle. You then end up=
=20
with the link frequency, which is thus expressed in MHz, not in Mbps. I wou=
ld=20
thus name the mbps variable freq, and rename the phypll_hsfreqrange mbps fi=
eld=20
to freq (maybe with a small comment right after the field to tell the value=
 is=20
expressed in MHz).

> +	for (hsfreq =3D priv->info->hsfreqrange; hsfreq->mbps !=3D 0; hsfreq++)
> +		if (hsfreq->mbps >=3D mbps)
> +			break;
> +
> +	if (!hsfreq->mbps) {
> +		dev_err(priv->dev, "Unsupported PHY speed (%llu Mbps)", mbps);
> +		return -ERANGE;
> +	}
> +
> +	dev_dbg(priv->dev, "PHY HSFREQRANGE requested %llu got %u Mbps\n", mbps,
> +		hsfreq->mbps);
> +
> +	*phypll =3D PHYPLL_HSFREQRANGE(hsfreq->reg);
> +
> +	return 0;
> +}

[snip]

=2D-=20
Regards,

Laurent Pinchart
