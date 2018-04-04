Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46631 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbeDDPPH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 11:15:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
Date: Wed, 04 Apr 2018 18:15:16 +0300
Message-ID: <5149348.Rp98f1K5qJ@avalon>
In-Reply-To: <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se> <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday, 13 February 2018 01:01:32 EEST Niklas S=F6derlund wrote:
> A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> supports the R-Car Gen3 SoCs where separate CSI-2 hardware blocks are
> connected between the video sources and the video grabbers (VIN).
>=20
> Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/Kconfig     |  12 +
>  drivers/media/platform/rcar-vin/Makefile    |   1 +
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 884 ++++++++++++++++++++++=
+++
>  3 files changed, 897 insertions(+)
>  create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c

[snip]

> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> b/drivers/media/platform/rcar-vin/rcar-csi2.c new file mode 100644
> index 0000000000000000..c0c2a763151bc928
> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c

[snip]

> +static const struct phypll_hsfreqrange hsfreqrange_m3w_h3es1[] =3D {
> +	{ .mbps =3D   80,	.reg =3D 0x00 },
> +	{ .mbps =3D   90,	.reg =3D 0x10 },
> +	{ .mbps =3D  100,	.reg =3D 0x20 },
> +	{ .mbps =3D  110,	.reg =3D 0x30 },
> +	{ .mbps =3D  120,	.reg =3D 0x01 },
> +	{ .mbps =3D  130,	.reg =3D 0x11 },
> +	{ .mbps =3D  140,	.reg =3D 0x21 },
> +	{ .mbps =3D  150,	.reg =3D 0x31 },
> +	{ .mbps =3D  160,	.reg =3D 0x02 },
> +	{ .mbps =3D  170,	.reg =3D 0x12 },
> +	{ .mbps =3D  180,	.reg =3D 0x22 },
> +	{ .mbps =3D  190,	.reg =3D 0x32 },
> +	{ .mbps =3D  205,	.reg =3D 0x03 },
> +	{ .mbps =3D  220,	.reg =3D 0x13 },
> +	{ .mbps =3D  235,	.reg =3D 0x23 },
> +	{ .mbps =3D  250,	.reg =3D 0x33 },
> +	{ .mbps =3D  275,	.reg =3D 0x04 },
> +	{ .mbps =3D  300,	.reg =3D 0x14 },
> +	{ .mbps =3D  325,	.reg =3D 0x05 },
> +	{ .mbps =3D  350,	.reg =3D 0x15 },
> +	{ .mbps =3D  400,	.reg =3D 0x25 },
> +	{ .mbps =3D  450,	.reg =3D 0x06 },
> +	{ .mbps =3D  500,	.reg =3D 0x16 },
> +	{ .mbps =3D  550,	.reg =3D 0x07 },
> +	{ .mbps =3D  600,	.reg =3D 0x17 },
> +	{ .mbps =3D  650,	.reg =3D 0x08 },
> +	{ .mbps =3D  700,	.reg =3D 0x18 },
> +	{ .mbps =3D  750,	.reg =3D 0x09 },
> +	{ .mbps =3D  800,	.reg =3D 0x19 },
> +	{ .mbps =3D  850,	.reg =3D 0x29 },
> +	{ .mbps =3D  900,	.reg =3D 0x39 },
> +	{ .mbps =3D  950,	.reg =3D 0x0A },
> +	{ .mbps =3D 1000,	.reg =3D 0x1A },
> +	{ .mbps =3D 1050,	.reg =3D 0x2A },
> +	{ .mbps =3D 1100,	.reg =3D 0x3A },
> +	{ .mbps =3D 1150,	.reg =3D 0x0B },
> +	{ .mbps =3D 1200,	.reg =3D 0x1B },
> +	{ .mbps =3D 1250,	.reg =3D 0x2B },
> +	{ .mbps =3D 1300,	.reg =3D 0x3B },
> +	{ .mbps =3D 1350,	.reg =3D 0x0C },
> +	{ .mbps =3D 1400,	.reg =3D 0x1C },
> +	{ .mbps =3D 1450,	.reg =3D 0x2C },
> +	{ .mbps =3D 1500,	.reg =3D 0x3C },

All the other hex values in the file are lowercase, I'd do the same here.

> +	/* guard */
> +	{ .mbps =3D   0,	.reg =3D 0x00 },
> +};

[snip]

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

You could store the format pointer iin the rcar_csi2 structure to avoid=20
looking it up here.

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
> +	default:
> +		return -EINVAL;
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
> +	rcar_csi2_write(priv, VCDT_REG, vcdt);
> +	rcar_csi2_write(priv, VCDT2_REG, vcdt2);
> +	/* Lanes are zero indexed */
> +	rcar_csi2_write(priv, LSWAP_REG,
> +			LSWAP_L0SEL(priv->lane_swap[0] - 1) |
> +			LSWAP_L1SEL(priv->lane_swap[1] - 1) |
> +			LSWAP_L2SEL(priv->lane_swap[2] - 1) |
> +			LSWAP_L3SEL(priv->lane_swap[3] - 1));
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
> +
> +	return rcar_csi2_wait_phy_start(priv);
> +}

[snip]

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

I think you can print this in decimal with %u.

> +		return -EINVAL;
> +	}
> +
> +	priv->lanes =3D vep->bus.mipi_csi2.num_data_lanes;
> +	if (priv->lanes !=3D 1 && priv->lanes !=3D 2 && priv->lanes !=3D 4) {
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

[snip]

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

You don't seem to use the IRQ. Is this meant to catch invalid DT that don't=
=20
specify an IRQ, to make sure we'll always have one available when we'll nee=
d=20
to later ?

> +	return 0;
> +}

[snip]

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

priv->lanes is unsigned you should use %u.

> +
> +	return 0;
> +
> +error:
> +	v4l2_async_notifier_unregister(&priv->notifier);
> +	v4l2_async_notifier_cleanup(&priv->notifier);
> +
> +	return ret;
> +}

[snip]

With these small issues fixed and Kieran's and Maxime's comments addressed =
as=20
you see fit,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

=2D-=20
Regards,

Laurent Pinchart
