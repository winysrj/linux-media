Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60829 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbeDEJKH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 05:10:07 -0400
Date: Thu, 5 Apr 2018 11:10:01 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180405091001.GI20945@w540>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se>
 <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CgTrtGVSVGoxAIFj"
Content-Disposition: inline
In-Reply-To: <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--CgTrtGVSVGoxAIFj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,
        thanks for the VIN and CSI-2 effort!

On Tue, Feb 13, 2018 at 12:01:32AM +0100, Niklas S=C3=B6derlund wrote:
> A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> supports the R-Car Gen3 SoCs where separate CSI-2 hardware blocks are
> connected between the video sources and the video grabbers (VIN).
>
> Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/Kconfig     |  12 +
>  drivers/media/platform/rcar-vin/Makefile    |   1 +
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 884 ++++++++++++++++++++++=
++++++
>  3 files changed, 897 insertions(+)
>  create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c
>

[snip]

> +
> +static const struct rcar_csi2_format rcar_csi2_formats[] =3D {
> +	{ .code =3D MEDIA_BUS_FMT_RGB888_1X24,	.datatype =3D 0x24, .bpp =3D 24 =
},
> +	{ .code =3D MEDIA_BUS_FMT_UYVY8_1X16,	.datatype =3D 0x1e, .bpp =3D 16 },
> +	{ .code =3D MEDIA_BUS_FMT_UYVY8_2X8,	.datatype =3D 0x1e, .bpp =3D 16 },
> +	{ .code =3D MEDIA_BUS_FMT_YUYV10_2X10,	.datatype =3D 0x1e, .bpp =3D 16 =
},

Shouldn't YUYV10_2X10 format have 20 bits per pixel?

> +};
> +
> +static const struct rcar_csi2_format *rcar_csi2_code_to_fmt(unsigned int=
 code)
> +{
> +	unsigned int i;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(rcar_csi2_formats); i++)
> +		if (rcar_csi2_formats[i].code =3D=3D code)
> +			return rcar_csi2_formats + i;
> +
> +	return NULL;
> +}
> +
> +enum rcar_csi2_pads {
> +	RCAR_CSI2_SINK,
> +	RCAR_CSI2_SOURCE_VC0,
> +	RCAR_CSI2_SOURCE_VC1,
> +	RCAR_CSI2_SOURCE_VC2,
> +	RCAR_CSI2_SOURCE_VC3,
> +	NR_OF_RCAR_CSI2_PAD,
> +};
> +
> +struct rcar_csi2_info {
> +	const struct phypll_hsfreqrange *hsfreqrange;
> +	unsigned int csi0clkfreqrange;
> +	bool clear_ulps;
> +	bool init_phtw;
> +};
> +
> +struct rcar_csi2 {
> +	struct device *dev;
> +	void __iomem *base;
> +	const struct rcar_csi2_info *info;
> +
> +	struct v4l2_subdev subdev;
> +	struct media_pad pads[NR_OF_RCAR_CSI2_PAD];
> +
> +	struct v4l2_async_notifier notifier;
> +	struct v4l2_async_subdev asd;
> +	struct v4l2_subdev *remote;
> +
> +	struct v4l2_mbus_framefmt mf;
> +
> +	struct mutex lock;
> +	int stream_count;
> +
> +	unsigned short lanes;
> +	unsigned char lane_swap[4];
> +};
> +
> +static inline struct rcar_csi2 *sd_to_csi2(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct rcar_csi2, subdev);
> +}
> +
> +static inline struct rcar_csi2 *notifier_to_csi2(struct v4l2_async_notif=
ier *n)
> +{
> +	return container_of(n, struct rcar_csi2, notifier);
> +}
> +
> +static u32 rcar_csi2_read(struct rcar_csi2 *priv, unsigned int reg)
> +{
> +	return ioread32(priv->base + reg);
> +}
> +
> +static void rcar_csi2_write(struct rcar_csi2 *priv, unsigned int reg, u3=
2 data)
> +{
> +	iowrite32(data, priv->base + reg);
> +}
> +
> +static void rcar_csi2_reset(struct rcar_csi2 *priv)
> +{
> +	rcar_csi2_write(priv, SRST_REG, SRST_SRST);
> +	usleep_range(100, 150);
> +	rcar_csi2_write(priv, SRST_REG, 0);
> +}
> +
> +static int rcar_csi2_wait_phy_start(struct rcar_csi2 *priv)
> +{
> +	int timeout;
> +
> +	/* Wait for the clock and data lanes to enter LP-11 state. */
> +	for (timeout =3D 100; timeout > 0; timeout--) {
> +		const u32 lane_mask =3D (1 << priv->lanes) - 1;
> +
> +		if ((rcar_csi2_read(priv, PHCLM_REG) & 1) =3D=3D 1 &&

Nitpicking:
		if ((rcar_csi2_read(priv, PHCLM_REG) & 0x01) &&

Don't you prefer to provide defines also for bit fields instead of
using magic values? In this case something like
PHCLM_REG_STOPSTATE_CLK would do.

Also, from tables 25.[17-20] it seems to me that for H3 and V3 you
have to set INSTATE to an hardcoded value after having validated PHDLM.
Maybe it is not necessary, just pointing it out.

> +		    (rcar_csi2_read(priv, PHDLM_REG) & lane_mask) =3D=3D lane_mask)
> +			return 0;
> +
> +		msleep(20);
> +	}
> +
> +	dev_err(priv->dev, "Timeout waiting for LP-11 state\n");
> +
> +	return -ETIMEDOUT;
> +}
> +
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
> +	/* Calculate the phypll */
> +	mbps =3D v4l2_ctrl_g_ctrl_int64(ctrl) * bpp;
> +	do_div(mbps, priv->lanes * 1000000);
> +
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
> +
> +static int rcar_csi2_start(struct rcar_csi2 *priv)
> +{
> +	const struct rcar_csi2_format *format;
> +	u32 phycnt, phypll, vcdt =3D 0, vcdt2 =3D 0;
> +	unsigned int i;
> +	int ret;
> +
> +	dev_dbg(priv->dev, "Input size (%ux%u%c)\n",
> +		priv->mf.width, priv->mf.height,
> +		priv->mf.field =3D=3D V4L2_FIELD_NONE ? 'p' : 'i');
> +
> +	/* Code is validated in set_fmt */
> +	format =3D rcar_csi2_code_to_fmt(priv->mf.code);
> +
> +	/*
> +	 * Enable all Virtual Channels
> +	 *
> +	 * NOTE: It's not possible to get individual datatype for each
> +	 *       source virtual channel. Once this is possible in V4L2
> +	 *       it should be used here.
> +	 */
> +	for (i =3D 0; i < 4; i++) {
> +		u32 vcdt_part;
> +
> +		vcdt_part =3D VCDT_SEL_VC(i) | VCDT_VCDTN_EN | VCDT_SEL_DTN_ON |
> +			VCDT_SEL_DT(format->datatype);
> +
> +		/* Store in correct reg and offset */
> +		if (i < 2)
> +			vcdt |=3D vcdt_part << ((i % 2) * 16);
> +		else
> +			vcdt2 |=3D vcdt_part << ((i % 2) * 16);
> +	}
> +
> +	switch (priv->lanes) {
> +	case 1:
> +		phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_0;
> +		break;
> +	case 2:
> +		phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
> +		break;
> +	case 4:
> +		phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_3 | PHYCNT_ENABLE_2 |
> +			PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
> +		break;

Even simpler this could be written as

                phycnt =3D PHYCNT_ENABLECLK | (1 << priv->lanes) - 1;

> +	default:
> +		return -EINVAL;

Can this happen? You have validated priv->lanes already when parsing
DT

> +	}
> +
> +	ret =3D rcar_csi2_calc_phypll(priv, format->bpp, &phypll);
> +	if (ret)
> +		return ret;
> +
> +	/* Clear Ultra Low Power interrupt */
> +	if (priv->info->clear_ulps)
> +		rcar_csi2_write(priv, INTSTATE_REG,
> +				INTSTATE_INT_ULPS_START |
> +				INTSTATE_INT_ULPS_END);
> +
> +	/* Init */
> +	rcar_csi2_write(priv, TREF_REG, TREF_TREF);
> +	rcar_csi2_reset(priv);
> +	rcar_csi2_write(priv, PHTC_REG, 0);
> +
> +	/* Configure */
> +	rcar_csi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
> +			FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);

On the FLD_FLD_NUM(2) mask. Why 2?
I read on the datasheet "the register must not be changed from default
value" and I read defaul to be 0x0000

Also, please consider a make as all other fields are enabled
unconditionally.

> +	rcar_csi2_write(priv, VCDT_REG, vcdt);
> +	rcar_csi2_write(priv, VCDT2_REG, vcdt2);
> +	/* Lanes are zero indexed */
> +	rcar_csi2_write(priv, LSWAP_REG,
> +			LSWAP_L0SEL(priv->lane_swap[0] - 1) |
> +			LSWAP_L1SEL(priv->lane_swap[1] - 1) |
> +			LSWAP_L2SEL(priv->lane_swap[2] - 1) |
> +			LSWAP_L3SEL(priv->lane_swap[3] - 1));

EDIT:
(This comment is way too long for the real value it has, but since I
already wrote it, and my initial doubt clarified while I was writing,
resulting in a much less serious issues, I'm gonna keep it all anyway.
Sorry about this :)

Why - 1 ?
Is this because it is assumed clock lane is in position 0? Is this
fixed by design?

What I read in datasheet for LSWAP_REG is:
L[0-3]SEL       0 =3D Use PHY lane 0
                1 =3D Use PHY lane 1
                2 =3D Use PHY lane 2
                3 =3D Use PHY lane 3

priv->lane_swap[i] is collected parsing 'data_lanes' property and
should reflect the actual physical lane value assigned to logical lane
numbers. If 'data_lanes' is, say <1 2> I expect

priv->lane_swap[0] =3D 1;
priv->lane_swap[1] =3D 2;
priv->lane_swap[1] =3D 3; //assigned by your parsing routine
priv->lane_swap[1] =3D 4; //assigned by your parsing routine

And I understand LSWAP counts instead from [0-3] so, ok, I get why you
subtract one. But now I wonder what happens if instead, lane position
is specified counting from 0 in DT. Ah, I see you refuse lane_swap
values < 1! So It should be assumed clock is by HW design on lane 0,
so wouldn't you need to mention in DT bindings that the HW has clock
lanes fixed in position 0 and the accepted values for the 'data_lanes'
property ranges in the [1-4] interval?

> +
> +	if (priv->info->init_phtw) {
> +		/*
> +		 * This is for H3 ES2.0
> +		 *
> +		 * NOTE: Additional logic is needed here when
> +		 * support for V3H and/or M3-N is added
> +		 */
> +		rcar_csi2_write(priv, PHTW_REG, 0x01cc01e2);
> +		rcar_csi2_write(priv, PHTW_REG, 0x010101e3);
> +		rcar_csi2_write(priv, PHTW_REG, 0x010101e4);
> +		rcar_csi2_write(priv, PHTW_REG, 0x01100104);
> +		rcar_csi2_write(priv, PHTW_REG, 0x01030100);
> +		rcar_csi2_write(priv, PHTW_REG, 0x01800100);
> +	}
> +
> +	/* Start */
> +	rcar_csi2_write(priv, PHYPLL_REG, phypll);
> +
> +	/* Set frequency range if we have it */
> +	if (priv->info->csi0clkfreqrange)
> +		rcar_csi2_write(priv, CSI0CLKFCPR_REG,
> +				CSI0CLKFREQRANGE(priv->info->csi0clkfreqrange));
> +
> +	rcar_csi2_write(priv, PHYCNT_REG, phycnt);
> +	rcar_csi2_write(priv, LINKCNT_REG, LINKCNT_MONITOR_EN |
> +			LINKCNT_REG_MONI_PACT_EN | LINKCNT_ICLK_NONSTOP);
> +	rcar_csi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ);
> +	rcar_csi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ |
> +			PHYCNT_RSTZ);

Nit: from tables 25.[17-20] it seems to me you do not have to re-issue
PHYCNT_SHUTDOWNZ when writing PHYCNT_RSTZ to PHYCNT_REG.

> +
> +	return rcar_csi2_wait_phy_start(priv);
> +}
> +
> +static void rcar_csi2_stop(struct rcar_csi2 *priv)
> +{
> +	rcar_csi2_write(priv, PHYCNT_REG, 0);
> +
> +	rcar_csi2_reset(priv);
> +}
> +
> +static int rcar_csi2_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct rcar_csi2 *priv =3D sd_to_csi2(sd);
> +	struct v4l2_subdev *nextsd;
> +	int ret =3D 0;
> +
> +	mutex_lock(&priv->lock);
> +
> +	if (!priv->remote) {
> +		ret =3D -ENODEV;
> +		goto out;
> +	}

Can this happen?

The 'bind' callback sets priv->remote and it gets assigned back to
NULL only on 'unbind'. Wouldn't it be better to remove the link in the
media graph and let the system return an EPIPE before calling this?

> +
> +	nextsd =3D priv->remote;
> +
> +	if (enable && priv->stream_count =3D=3D 0) {
> +		pm_runtime_get_sync(priv->dev);
> +
> +		ret =3D rcar_csi2_start(priv);
> +		if (ret) {
> +			pm_runtime_put(priv->dev);
> +			goto out;
> +		}
> +
> +		ret =3D v4l2_subdev_call(nextsd, video, s_stream, 1);
> +		if (ret) {
> +			rcar_csi2_stop(priv);
> +			pm_runtime_put(priv->dev);
> +			goto out;
> +		}
> +	} else if (!enable && priv->stream_count =3D=3D 1) {
> +		rcar_csi2_stop(priv);
> +		v4l2_subdev_call(nextsd, video, s_stream, 0);
> +		pm_runtime_put(priv->dev);
> +	}
> +
> +	priv->stream_count +=3D enable ? 1 : -1;
> +out:
> +	mutex_unlock(&priv->lock);
> +
> +	return ret;
> +}
> +
> +static int rcar_csi2_set_pad_format(struct v4l2_subdev *sd,
> +				    struct v4l2_subdev_pad_config *cfg,
> +				    struct v4l2_subdev_format *format)
> +{
> +	struct rcar_csi2 *priv =3D sd_to_csi2(sd);
> +	struct v4l2_mbus_framefmt *framefmt;
> +
> +	if (!rcar_csi2_code_to_fmt(format->format.code))
> +		return -EINVAL;
> +
> +	if (format->which =3D=3D V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		priv->mf =3D format->format;
> +	} else {
> +		framefmt =3D v4l2_subdev_get_try_format(sd, cfg, 0);
> +		*framefmt =3D format->format;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rcar_csi2_get_pad_format(struct v4l2_subdev *sd,
> +				    struct v4l2_subdev_pad_config *cfg,
> +				    struct v4l2_subdev_format *format)
> +{
> +	struct rcar_csi2 *priv =3D sd_to_csi2(sd);
> +
> +	if (format->which =3D=3D V4L2_SUBDEV_FORMAT_ACTIVE)
> +		format->format =3D priv->mf;
> +	else
> +		format->format =3D *v4l2_subdev_get_try_format(sd, cfg, 0);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops rcar_csi2_video_ops =3D {
> +	.s_stream =3D rcar_csi2_s_stream,
> +};
> +
> +static const struct v4l2_subdev_pad_ops rcar_csi2_pad_ops =3D {
> +	.set_fmt =3D rcar_csi2_set_pad_format,
> +	.get_fmt =3D rcar_csi2_get_pad_format,
> +};
> +
> +static const struct v4l2_subdev_ops rcar_csi2_subdev_ops =3D {
> +	.video	=3D &rcar_csi2_video_ops,
> +	.pad	=3D &rcar_csi2_pad_ops,
> +};
> +
> +/* ---------------------------------------------------------------------=
--------
> + * Async and registered of subdevices and links
> + */
> +
> +static int rcar_csi2_notify_bound(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_subdev *subdev,
> +				   struct v4l2_async_subdev *asd)
> +{
> +	struct rcar_csi2 *priv =3D notifier_to_csi2(notifier);
> +	int pad;
> +
> +	pad =3D media_entity_get_fwnode_pad(&subdev->entity, asd->match.fwnode,
> +					  MEDIA_PAD_FL_SOURCE);
> +	if (pad < 0) {
> +		dev_err(priv->dev, "Failed to find pad for %s\n", subdev->name);
> +		return pad;
> +	}
> +
> +	priv->remote =3D subdev;
> +
> +	dev_dbg(priv->dev, "Bound %s pad: %d\n", subdev->name, pad);
> +
> +	return media_create_pad_link(&subdev->entity, pad,
> +				     &priv->subdev.entity, 0,
> +				     MEDIA_LNK_FL_ENABLED |
> +				     MEDIA_LNK_FL_IMMUTABLE);
> +}
> +
> +static void rcar_csi2_notify_unbind(struct v4l2_async_notifier *notifier,
> +				       struct v4l2_subdev *subdev,
> +				       struct v4l2_async_subdev *asd)
> +{
> +	struct rcar_csi2 *priv =3D notifier_to_csi2(notifier);
> +
> +	priv->remote =3D NULL;
> +
> +	dev_dbg(priv->dev, "Unbind %s\n", subdev->name);
> +}
> +
> +static const struct v4l2_async_notifier_operations rcar_csi2_notify_ops =
=3D {
> +	.bound =3D rcar_csi2_notify_bound,
> +	.unbind =3D rcar_csi2_notify_unbind,
> +};
> +
> +static int rcar_csi2_parse_v4l2(struct rcar_csi2 *priv,
> +				struct v4l2_fwnode_endpoint *vep)
> +{
> +	unsigned int i;
> +
> +	/* Only port 0 endpoint 0 is valid */
> +	if (vep->base.port || vep->base.id)
> +		return -ENOTCONN;
> +
> +	if (vep->bus_type !=3D V4L2_MBUS_CSI2) {
> +		dev_err(priv->dev, "Unsupported bus: 0x%x\n", vep->bus_type);
> +		return -EINVAL;
> +	}
> +
> +	priv->lanes =3D vep->bus.mipi_csi2.num_data_lanes;
> +	if (priv->lanes !=3D 1 && priv->lanes !=3D 2 && priv->lanes !=3D 4) {

Is this an HW limitation? Like the 'data_lanes' comment, if it is,
shouldn't you mention in bindings that the accepted lane numbers is
limited to the [1,2,4] values.

> +		dev_err(priv->dev, "Unsupported number of data-lanes: %u\n",
> +			priv->lanes);
> +		return -EINVAL;
> +	}
> +
> +	for (i =3D 0; i < ARRAY_SIZE(priv->lane_swap); i++) {
> +		priv->lane_swap[i] =3D i < priv->lanes ?
> +			vep->bus.mipi_csi2.data_lanes[i] : i;
> +
> +		/* Check for valid lane number */
> +		if (priv->lane_swap[i] < 1 || priv->lane_swap[i] > 4) {
> +			dev_err(priv->dev, "data-lanes must be in 1-4 range\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int rcar_csi2_parse_dt(struct rcar_csi2 *priv)
> +{
> +	struct device_node *ep;
> +	struct v4l2_fwnode_endpoint v4l2_ep;
> +	int ret;
> +
> +	ep =3D of_graph_get_endpoint_by_regs(priv->dev->of_node, 0, 0);
> +	if (!ep) {
> +		dev_err(priv->dev, "Not connected to subdevice\n");
> +		return -EINVAL;
> +	}
> +
> +	ret =3D v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
> +	if (ret) {
> +		dev_err(priv->dev, "Could not parse v4l2 endpoint\n");
> +		of_node_put(ep);
> +		return -EINVAL;
> +	}
> +
> +	ret =3D rcar_csi2_parse_v4l2(priv, &v4l2_ep);
> +	if (ret) {
> +		of_node_put(ep);
> +		return ret;
> +	}
> +
> +	priv->asd.match.fwnode =3D
> +		fwnode_graph_get_remote_endpoint(of_fwnode_handle(ep));
> +	priv->asd.match_type =3D V4L2_ASYNC_MATCH_FWNODE;
> +
> +	of_node_put(ep);
> +
> +	priv->notifier.subdevs =3D devm_kzalloc(priv->dev,
> +					      sizeof(*priv->notifier.subdevs),
> +					      GFP_KERNEL);
> +	if (priv->notifier.subdevs =3D=3D NULL)

Nit:
you can use ! for NULL comparison. I think checkpatch --strict
complains for this.

> +		return -ENOMEM;
> +
> +	priv->notifier.num_subdevs =3D 1;
> +	priv->notifier.subdevs[0] =3D &priv->asd;
> +	priv->notifier.ops =3D &rcar_csi2_notify_ops;
> +
> +	dev_dbg(priv->dev, "Found '%pOF'\n",
> +		to_of_node(priv->asd.match.fwnode));
> +
> +	return v4l2_async_subdev_notifier_register(&priv->subdev,
> +						   &priv->notifier);
> +}
> +
> +/* ---------------------------------------------------------------------=
--------
> + * Platform Device Driver
> + */
> +
> +static const struct media_entity_operations rcar_csi2_entity_ops =3D {
> +	.link_validate =3D v4l2_subdev_link_validate,
> +};
> +
> +static int rcar_csi2_probe_resources(struct rcar_csi2 *priv,
> +				     struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	int irq;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	priv->base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);
> +
> +	irq =3D platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return irq;
> +
> +	return 0;
> +}
> +
> +static const struct rcar_csi2_info rcar_csi2_info_r8a7795 =3D {
> +	.hsfreqrange =3D hsfreqrange_h3_v3h_m3n,
> +	.clear_ulps =3D true,
> +	.init_phtw =3D true,
> +	.csi0clkfreqrange =3D 0x20,
> +};
> +
> +static const struct rcar_csi2_info rcar_csi2_info_r8a7795es1 =3D {
> +	.hsfreqrange =3D hsfreqrange_m3w_h3es1,
> +};
> +
> +static const struct rcar_csi2_info rcar_csi2_info_r8a7796 =3D {
> +	.hsfreqrange =3D hsfreqrange_m3w_h3es1,
> +};
> +
> +static const struct of_device_id rcar_csi2_of_table[] =3D {
> +	{
> +		.compatible =3D "renesas,r8a7795-csi2",
> +		.data =3D &rcar_csi2_info_r8a7795,
> +	},
> +	{
> +		.compatible =3D "renesas,r8a7796-csi2",
> +		.data =3D &rcar_csi2_info_r8a7796,
> +	},
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, rcar_csi2_of_table);
> +
> +static const struct soc_device_attribute r8a7795es1[] =3D {
> +	{
> +		.soc_id =3D "r8a7795", .revision =3D "ES1.*",
> +		.data =3D &rcar_csi2_info_r8a7795es1,
> +	},
> +	{ /* sentinel */}
> +};
> +
> +static int rcar_csi2_probe(struct platform_device *pdev)
> +{
> +	const struct soc_device_attribute *attr;
> +	struct rcar_csi2 *priv;
> +	unsigned int i;
> +	int ret;
> +
> +	priv =3D devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->info =3D of_device_get_match_data(&pdev->dev);
> +
> +	/* r8a7795 ES1.x behaves different then ES2.0+ but no own compat */
> +	attr =3D soc_device_match(r8a7795es1);
> +	if (attr)
> +		priv->info =3D attr->data;
> +
> +	priv->dev =3D &pdev->dev;
> +
> +	mutex_init(&priv->lock);
> +	priv->stream_count =3D 0;
> +
> +	ret =3D rcar_csi2_probe_resources(priv, pdev);
> +	if (ret) {
> +		dev_err(priv->dev, "Failed to get resources\n");
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, priv);
> +
> +	ret =3D rcar_csi2_parse_dt(priv);
> +	if (ret)
> +		return ret;
> +
> +	priv->subdev.owner =3D THIS_MODULE;
> +	priv->subdev.dev =3D &pdev->dev;
> +	v4l2_subdev_init(&priv->subdev, &rcar_csi2_subdev_ops);
> +	v4l2_set_subdevdata(&priv->subdev, &pdev->dev);
> +	snprintf(priv->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s %s",
> +		 KBUILD_MODNAME, dev_name(&pdev->dev));
> +	priv->subdev.flags =3D V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	priv->subdev.entity.function =3D MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
> +	priv->subdev.entity.ops =3D &rcar_csi2_entity_ops;
> +
> +	priv->pads[RCAR_CSI2_SINK].flags =3D MEDIA_PAD_FL_SINK;
> +	for (i =3D RCAR_CSI2_SOURCE_VC0; i < NR_OF_RCAR_CSI2_PAD; i++)
> +		priv->pads[i].flags =3D MEDIA_PAD_FL_SOURCE;
> +
> +	ret =3D media_entity_pads_init(&priv->subdev.entity, NR_OF_RCAR_CSI2_PA=
D,
> +				     priv->pads);
> +	if (ret)
> +		goto error;
> +
> +	pm_runtime_enable(&pdev->dev);
> +
> +	ret =3D v4l2_async_register_subdev(&priv->subdev);
> +	if (ret < 0)
> +		goto error;
> +
> +	dev_info(priv->dev, "%d lanes found\n", priv->lanes);
> +
> +	return 0;
> +
> +error:
> +	v4l2_async_notifier_unregister(&priv->notifier);
> +	v4l2_async_notifier_cleanup(&priv->notifier);
> +
> +	return ret;
> +}
> +
> +static int rcar_csi2_remove(struct platform_device *pdev)
> +{
> +	struct rcar_csi2 *priv =3D platform_get_drvdata(pdev);
> +
> +	v4l2_async_notifier_unregister(&priv->notifier);
> +	v4l2_async_notifier_cleanup(&priv->notifier);
> +	v4l2_async_unregister_subdev(&priv->subdev);
> +
> +	pm_runtime_disable(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver __refdata rcar_csi2_pdrv =3D {
> +	.remove	=3D rcar_csi2_remove,
> +	.probe	=3D rcar_csi2_probe,
> +	.driver	=3D {
> +		.name	=3D "rcar-csi2",
> +		.of_match_table	=3D rcar_csi2_of_table,
> +	},
> +};
> +
> +module_platform_driver(rcar_csi2_pdrv);
> +
> +MODULE_AUTHOR("Niklas S=C3=B6derlund <niklas.soderlund@ragnatech.se>");
> +MODULE_DESCRIPTION("Renesas R-Car MIPI CSI-2 receiver");
> +MODULE_LICENSE("GPL");

"GPL v2" ?

No serious issues though. So when fixed/clarified feel free to append my
Reviewed-by tag, if relevant at all.

Thanks
   j

> --
> 2.16.1
>

--CgTrtGVSVGoxAIFj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJaxefpAAoJEHI0Bo8WoVY8W4oP/RS3yCPLueLF25q20LpUseH/
O7Hmps2YQM/CzKHIMM/8BjUqcVfY23bvk4Ef+ZbYmD8VTgtchC4IBaAZUUEnajRF
Y6ydCgwNFhJLIHqzbcqvE8kG8E6P8QjuZy379vtijPOLxPcrZPGVrBLS7itJ5mhw
z+WHIQKWs9I9NAlIZJImhG7mlLShL1EggCHWs97EtMEcOKsoWHyu40bbYoGYGUO6
E6NUKNmj+z+d+haEBTsFv0gAUYKK4yDADvkx07tciGUpgeu/d8MHXzIQXhzaILIQ
MaXb6C6HCIxVzIHcnOF3gPimlpdlBXy7H4JgY0q6PEbC7wKFAA5nk2mWfFN3Lslb
p3LK6fIlbLC9Ba87RcQCBj7bYPjQpjGGUoHplJjrDaWgjfeiI+Uy8ZOFydndLwlT
XjfobVjXY5vEQ8s5dJwDJmGrTRZuVapovylTWAI9HkHTlF3wXxTHgv9A0UYJ0wwC
tKhnxEURTwmKj0mHeZHsJmD1e6BWbAo9zN4/fX/M3Jcb3X8BNg3PL4pB1bM6p0rO
I3o/M94xZEio/CdAsmCmuYs6kkxgB4+H1CC7sc5PKtibtMkln/xltFkUM8wM9R3S
aHBNfzBTrwKbRFISB7expbviSRTGxLy7s/eWuvpJUufdLKJ89RVzIgJKOdmQKWv/
C1iovC31YueaGEdmhOcN
=0I1T
-----END PGP SIGNATURE-----

--CgTrtGVSVGoxAIFj--
