Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59056 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751362AbeENBxi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 21:53:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        jacopo mondi <jacopo@jmondi.org>
Subject: Re: [PATCH v15 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
Date: Mon, 14 May 2018 04:53:54 +0300
Message-ID: <2422354.hk5qNoArOc@avalon>
In-Reply-To: <20180513191917.20681-3-niklas.soderlund+renesas@ragnatech.se>
References: <20180513191917.20681-1-niklas.soderlund+renesas@ragnatech.se> <20180513191917.20681-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Sunday, 13 May 2018 22:19:17 EEST Niklas S=F6derlund wrote:
> A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> supports the R-Car Gen3 SoCs where separate CSI-2 hardware blocks are
> connected between the video sources and the video grabbers (VIN).
>=20
> Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
>=20
> ---
>=20
> * Changes since v14
> - Data sheet update changed init sequence for PHY forcing a restructure
>   of the driver. The restructure was so big I felt compel to drop all
>   review tags :-(
> - The change was that the Renesas H3 procedure was aligned with other
>   SoC in the Gen3 family procedure. I had kept the rework as separate
>   patches and was planing to post once original driver with H3 and M3-W
>   support where merged. As review tags are dropped I chosen to squash
>   those patches into 2/2.
> - Add support for Gen3 V3M.
> - Add support for Gen3 M3-N.
> - Set PHTC_TESTCLR when stopping the PHY.
> - Revert back to the v12 and earlier phypll calculation as it turns out
>   it was correct after all.
>=20
> * Changes since v13
> - Change return rcar_csi2_formats + i to return &rcar_csi2_formats[i].
> - Add define for PHCLM_STOPSTATECKL.
> - Update spelling in comments.
> - Update calculation in rcar_csi2_calc_phypll() according to
>   https://linuxtv.org/downloads/v4l-dvb-apis/kapi/csi2.html. The one
>   before v14 did not take into account that 2 bits per sample is
>   transmitted.
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
>  drivers/media/platform/rcar-vin/Kconfig     |   12 +
>  drivers/media/platform/rcar-vin/Makefile    |    1 +
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 1101 +++++++++++++++++++
>  3 files changed, 1114 insertions(+)
>  create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c

[snip]

> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> b/drivers/media/platform/rcar-vin/rcar-csi2.c new file mode 100644
> index 0000000000000000..b19374f1516464dc
> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c

[snip]

> +struct phtw_value {
> +	u16 data;
> +	u16 code;
> +};
> +
> +struct phtw_mbps {
> +	u16 mbps;
> +	u16 data;
> +};

[snip]

> +struct phypll_hsfreqrange {
> +	u16 mbps;
> +	u16 reg;
> +};

Would it make sense to merge the phypll_hsfreqrange and phtw_mbps structure=
s=20
(not the data tables themselves, just the structure definitions) ? They bot=
h=20
map a frequency to a register value.

[snip]

> +static int rcsi2_wait_phy_start(struct rcar_csi2 *priv)
> +{
> +	int timeout;
> +
> +	/* Wait for the clock and data lanes to enter LP-11 state. */
> +	for (timeout =3D 100; timeout > 0; timeout--) {
> +		const u32 lane_mask =3D (1 << priv->lanes) - 1;
> +
> +		if ((rcsi2_read(priv, PHCLM_REG) & PHCLM_STOPSTATECKL)  &&
> +		    (rcsi2_read(priv, PHDLM_REG) & lane_mask) =3D=3D lane_mask)
> +			return 0;
> +
> +		msleep(20);
> +	}

Could you check how long this typically takes ? I would expect the lanes to=
=20
all be in LP-11 already, so this should be a matter if getting the PHY to=20
initialize properly to detect the lane state, which shouldn't take very lon=
g.

> +
> +	dev_err(priv->dev, "Timeout waiting for LP-11 state\n");
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int rcsi2_set_phypll(struct rcar_csi2 *priv, unsigned int mbps)
> +{
> +	const struct phypll_hsfreqrange *hsfreq;
> +
> +	for (hsfreq =3D priv->info->hsfreqrange; hsfreq->mbps !=3D 0; hsfreq++)
> +		if (hsfreq->mbps >=3D mbps)
> +			break;
> +
> +	if (!hsfreq->mbps) {
> +		dev_err(priv->dev, "Unsupported PHY speed (%u Mbps)", mbps);
> +		return -ERANGE;
> +	}
> +
> +	dev_dbg(priv->dev, "PHY HSFREQRANGE requested %u got %u Mbps\n", mbps,
> +		hsfreq->mbps);

I think you can drop this message.

> +	rcsi2_write(priv, PHYPLL_REG, PHYPLL_HSFREQRANGE(hsfreq->reg));
> +
> +	return 0;
> +}
> +
> +static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
> +{
> +	struct v4l2_subdev *source;
> +	struct v4l2_ctrl *ctrl;
> +	u64 mbps;
> +
> +	if (!priv->remote)
> +		return -ENODEV;
> +
> +	source =3D priv->remote;
> +
> +	/* Read the pixel rate control from remote. */
> +	ctrl =3D v4l2_ctrl_find(source->ctrl_handler, V4L2_CID_PIXEL_RATE);
> +	if (!ctrl) {
> +		dev_err(priv->dev, "no pixel rate control in subdev %s\n",
> +			source->name);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Calculate the phypll in mbps (from v4l2 documentation).

I'd say from the CSI-2 specification, as this isn't V4L2-specific (or I'd j=
ust=20
drop the part in parentheses).

> +	 * link_freq =3D (pixel_rate * bits_per_sample) / (2 * nr_of_lanes)
> +	 * bps =3D link_freq * 2
> +	 */
> +	mbps =3D v4l2_ctrl_g_ctrl_int64(ctrl) * bpp;
> +	do_div(mbps, priv->lanes * 1000000);
> +
> +	return mbps;
> +}

[snip]

> +/* ---------------------------------------------------------------------=
=2D--
> + * PHTW unitizing sequences.

Unitizing ?

> + *
> + * NOTE: Magic values are from the datasheet and lack documentation.
> + */
> +
> +static int rcsi2_phtw_write(struct rcar_csi2 *priv, u16 data, u16 code)
> +{
> +	unsigned int timeout;
> +
> +	rcsi2_write(priv, PHTW_REG,
> +		    PHTW_DWEN | PHTW_TESTDIN_DATA(data) |
> +		    PHTW_CWEN | PHTW_TESTDIN_CODE(code));
> +
> +	/* Wait for DWEN and CWEN to be cleared by hardware. */
> +	for (timeout =3D 100; timeout > 0; timeout--) {
> +		if (!(rcsi2_read(priv, PHTW_REG) & (PHTW_DWEN | PHTW_CWEN)))
> +			return 0;
> +		msleep(20);

That's a very long sleep. I don't expect the hardware to need 20ms, I assum=
e=20
that if the condition is false at the first iteration you will only need to=
=20
wait for a very short time. Could you experiment with smaller delays and se=
e=20
how long is typically needed ?

> +	}
> +
> +	dev_err(priv->dev, "Timeout waiting for PHTW_DWEN and/or PHTW_CWEN\n");
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int rcsi2_phtw_write_array(struct rcar_csi2 *priv,
> +				  const struct phtw_value *values)
> +{
> +	const struct phtw_value *value;
> +	int ret;
> +
> +	for (value =3D values; (value->data || value->code); value++) {

No need for the inner parentheses.

You could also operate on the values argument directly without using a valu=
e=20
local variable. Up to you.

> +		ret =3D rcsi2_phtw_write(priv, value->data, value->code);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rcsi2_phtw_write_mbps(struct rcar_csi2 *priv, unsigned int mb=
ps,
> +				 const struct phtw_mbps *values, u16 code)
> +{
> +	const struct phtw_mbps *value;
> +
> +	for (value =3D values; value->mbps; value++)
> +		if (value->mbps >=3D mbps)
> +			break;
> +
> +	if (!value->mbps) {
> +		dev_err(priv->dev, "Unsupported PHY speed (%u Mbps)", mbps);
> +		return -ERANGE;
> +	}
> +
> +	dev_dbg(priv->dev, "PHTW requested %u got %u Mbps\n", mbps,
> +		value->mbps);

I think you can drop this debug statement.

> +	return rcsi2_phtw_write(priv, value->data, code);
> +}
> +
> +static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2 *priv, unsigned i=
nt
> mbps)
> +{
> +	static const struct phtw_value step1[] =3D {
> +		{ .data =3D 0xcc, .code =3D 0xe2 },
> +		{ .data =3D 0x01, .code =3D 0xe3 },
> +		{ .data =3D 0x11, .code =3D 0xe4 },
> +		{ .data =3D 0x01, .code =3D 0xe5 },
> +		{ .data =3D 0x10, .code =3D 0x04 },
> +		{ /* sentinel */ },
> +	};
> +
> +	static const struct phtw_value step2[] =3D {
> +		{ .data =3D 0x38, .code =3D 0x08 },
> +		{ .data =3D 0x01, .code =3D 0x00 },
> +		{ .data =3D 0x4b, .code =3D 0xac },
> +		{ .data =3D 0x03, .code =3D 0x00 },
> +		{ .data =3D 0x80, .code =3D 0x07 },
> +		{ /* sentinel */ },
> +	};
> +
> +	int ret;
> +
> +	ret =3D rcsi2_phtw_write_array(priv, step1);
> +	if (ret)
> +		return ret;
> +
> +	if (mbps <=3D 250) {

This worries me. I wonder what will happen if we use the CSI-2 receiver wit=
h a=20
frequency below 250 MHz, and then with a frequency above. Is there a risk t=
hat=20
the PHTW settings for the first run will be retained ? You're following the=
=20
datasheet so I have no objection, but I would appreciate if you could doubl=
e-
check this with Renesas.

Update: following our IRC conversation, the rcsi2_write(priv, PHTC_REG,=20
PHTC_TESTCLR) call in rcsi2_stop() should reset the PHY, so there should be=
 no=20
issue here. A brief comment in this function to explain that could be nice.

> +		ret =3D rcsi2_phtw_write(priv, 0x39, 0x05);
> +		if (ret)
> +			return ret;
> +
> +		ret =3D rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_h3_v3h_m3n,
> +					    0xf1);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return rcsi2_phtw_write_array(priv, step2);
> +}

[snip]

> +static struct platform_driver __refdata rcar_csi2_pdrv =3D {

Do you need __refdata ?

> +	.remove	=3D rcsi2_remove,
> +	.probe	=3D rcsi2_probe,
> +	.driver	=3D {
> +		.name	=3D "rcar-csi2",
> +		.of_match_table	=3D rcar_csi2_of_table,
> +	},
> +};
> +
> +module_platform_driver(rcar_csi2_pdrv);
> +
> +MODULE_AUTHOR("Niklas S=F6derlund <niklas.soderlund@ragnatech.se>");
> +MODULE_DESCRIPTION("Renesas R-Car MIPI CSI-2 receiver");

Nitpicking, should this be "Renesas R-Car MIPI CSI-2 receiver driver" ?

> +MODULE_LICENSE("GPL");

All these are small issues, they're not blocking.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

=2D-=20
Regards,

Laurent Pinchart
