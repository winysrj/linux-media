Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35677 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbdLKTjE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 14:39:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v12 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
Date: Mon, 11 Dec 2017 21:39:05 +0200
Message-ID: <4776473.qEMGVSS1sH@avalon>
In-Reply-To: <20171129193235.25423-3-niklas.soderlund+renesas@ragnatech.se>
References: <20171129193235.25423-1-niklas.soderlund+renesas@ragnatech.se> <20171129193235.25423-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Wednesday, 29 November 2017 21:32:35 EET Niklas S=F6derlund wrote:
> A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> supports the rcar-vin driver on R-Car Gen3 SoCs where separate CSI-2

The driver supports the driver ?

> hardware blocks are connected between the video sources and the video
> grabbers (VIN).
>=20
> Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/Kconfig     |  12 +
>  drivers/media/platform/rcar-vin/Makefile    |   1 +
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 898 ++++++++++++++++++++++=
+++
>  3 files changed, 911 insertions(+)
>  create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c

[snip]

> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> b/drivers/media/platform/rcar-vin/rcar-csi2.c new file mode 100644
> index 0000000000000000..30aafcbb7a3642c6
> --- /dev/null
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -0,0 +1,898 @@
> +/*
> + * Driver for Renesas R-Car MIPI CSI-2 Receiver
> + *
> + * Copyright (C) 2017 Renesas Electronics Corp.
> + *
> + * This program is free software; you can redistribute  it and/or modify=
 it
> + * under  the terms of  the GNU General  Public License as published by
> the
> + * Free Software Foundation;  either version 2 of the  License, or (at y=
our
> + * option) any later version.

Given that copyright headers are replaced by SPDX in the kernel sources, yo=
u=20
might want to get rid of this paragraph and add

// SPDX-License-Identifier: GPL-2.0+

as the first line of the file.

> + */

[snip]

> +static int rcar_csi2_calc_phypll(struct rcar_csi2 *priv, unsigned int bp=
p,
> +				 u32 *phypll)
> +{
> +
> +	const struct phypll_hsfreqrange *hsfreq;
> +	struct media_pad *pad, *source_pad;
> +	struct v4l2_subdev *source =3D NULL;

No need to initialize this to NULL.

> +	struct v4l2_ctrl *ctrl;
> +	u64 mbps;
> +
> +	/* Get remote subdevice */
> +	pad =3D &priv->subdev.entity.pads[RCAR_CSI2_SINK];
> +	source_pad =3D media_entity_remote_pad(pad);
> +	if (!source_pad) {
> +		dev_err(priv->dev, "Could not find remote source pad\n");
> +		return -ENODEV;
> +	}
> +	source =3D media_entity_to_v4l2_subdev(source_pad->entity);
> +
> +	dev_dbg(priv->dev, "Using source %s pad: %u\n", source->name,
> +		source_pad->index);

Doesn't this duplicate rcar_csi2_sd_info() ?

> +	/* Read the pixel rate control from remote */
> +	ctrl =3D v4l2_ctrl_find(source->ctrl_handler, V4L2_CID_PIXEL_RATE);
> +	if (!ctrl) {
> +		dev_err(priv->dev, "no link freq control in subdev %s\n",

s/link freq/pixel rate/

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

If you ever feel bored you could implement lookup through bisection ;-)

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
> +	u32 phycnt, phypll, tmp;
> +	u32 vcdt =3D 0, vcdt2 =3D 0;
> +	unsigned int i;
> +	int ret;
> +
> +	dev_dbg(priv->dev, "Input size (%ux%u%c)\n",
> +		priv->mf.width, priv->mf.height,
> +		priv->mf.field =3D=3D V4L2_FIELD_NONE ? 'p' : 'i');
> +
> +	/* Code is validated in set_ftm */

s/set_ftm/set_fmt/

> +	format =3D rcar_csi2_code_to_fmt(priv->mf.code);

You could also cache the pointer to the format info structure in the set_fm=
t=20
handler instead of looking it up every time, that's up to you.

> +	/*
> +	 * Enable all Virtual Channels
> +	 *
> +	 * NOTE: It's not possible to get individual datatype for each
> +	 *       source virtual channel. Once this is possible in V4L2
> +	 *       it should be used here.
> +	 */
> +	for (i =3D 0; i < 4; i++) {
> +		tmp =3D VCDT_SEL_VC(i) | VCDT_VCDTN_EN | VCDT_SEL_DTN_ON |
> +			VCDT_SEL_DT(format->datatype);

Could you find a better name than tmp for the variable ? It can also be=20
declared inside the loop as it isn't used outside.

> +
> +		/* Store in correct reg and offset */
> +		if (i < 2)
> +			vcdt |=3D tmp << ((i % 2) * 16);
> +		else
> +			vcdt2 |=3D tmp << ((i % 2) * 16);
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

The number of lanes has been validated at probe time, you don't need to ret=
urn=20
an error here.

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

I'm a bit puzzled here. As the source isn't streaming yet, shouldn't all la=
nes=20
be in LP-11 state already ? Why do you need to wait ? How many iterations o=
f=20
the wait loop are usually needed ?

> +}
> +
> +static void rcar_csi2_stop(struct rcar_csi2 *priv)
> +{
> +	rcar_csi2_write(priv, PHYCNT_REG, 0);
> +
> +	rcar_csi2_reset(priv);
> +}
> +
> +static int rcar_csi2_sd_info(struct rcar_csi2 *priv, struct v4l2_subdev
> **sd)

Wouldn't it be simpler to return the sd pointer (or an ERR_PTR in case of=20
errors) ?

> +{
> +	struct media_pad *pad;
> +
> +	pad =3D media_entity_remote_pad(&priv->pads[RCAR_CSI2_SINK]);
> +	if (!pad) {
> +		dev_err(priv->dev, "Could not find remote pad\n");
> +		return -ENODEV;
> +	}
> +
> +	*sd =3D media_entity_to_v4l2_subdev(pad->entity);
> +	if (!*sd) {
> +		dev_err(priv->dev, "Could not find remote subdevice\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;

I wonder whether you couldn't cache the subdev in the rcar_csi2 structure i=
n=20
the .bound() handler instead of looking it up every time you need it.

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
> +		return -EINVAL;
> +	}
> +
> +	priv->lanes =3D vep->bus.mipi_csi2.num_data_lanes;
> +	if (priv->lanes !=3D 1 && priv->lanes !=3D 2 && priv->lanes !=3D 4) {
> +		dev_err(priv->dev, "Unsupported number of data-lanes: %d\n",
> +			priv->lanes);

The lanes field is unsigned, you should use %u.

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
> +	if (ret)

I think you're leaking a reference to ep here.

> +		return ret;
> +
> +	priv->remote.match.fwnode.fwnode =3D
> +		fwnode_graph_get_remote_endpoint(of_fwnode_handle(ep));
> +	priv->remote.match_type =3D V4L2_ASYNC_MATCH_FWNODE;
> +
> +	of_node_put(ep);
> +
> +	priv->notifier.subdevs =3D devm_kzalloc(priv->dev,
> +					      sizeof(*priv->notifier.subdevs),
> +					      GFP_KERNEL);
> +	if (priv->notifier.subdevs =3D=3D NULL)
> +		return -ENOMEM;
> +
> +	priv->notifier.num_subdevs =3D 1;
> +	priv->notifier.subdevs[0] =3D &priv->remote;
> +	priv->notifier.ops =3D &rcar_csi2_notify_ops;
> +
> +	dev_dbg(priv->dev, "Found '%pOF'\n",
> +		to_of_node(priv->remote.match.fwnode.fwnode));
> +
> +	return v4l2_async_subdev_notifier_register(&priv->subdev,
> +						   &priv->notifier);
> +}
> +
> +/* ---------------------------------------------------------------------=
=2D--
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

Just out of curiosity, do you have plans to use the IRQ later ?

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
> +	ret =3D v4l2_async_register_subdev(&priv->subdev);
> +	if (ret < 0)
> +		goto error;
> +
> +	pm_runtime_enable(&pdev->dev);

I'd enable runtime PM before registering the subdev, as the subdev API coul=
d=20
be called as soon as the subdev is registered.

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

[snip]

> +static struct platform_driver __refdata rcar_csi2_pdrv =3D {
> +	.remove	=3D rcar_csi2_remove,
> +	.probe	=3D rcar_csi2_probe,
> +	.driver	=3D {
> +		.name	=3D "rcar-csi2",
> +		.of_match_table	=3D of_match_ptr(rcar_csi2_of_table),

OF is required, so you could drop of_match_ptr().

> +	},
> +};
> +
> +module_platform_driver(rcar_csi2_pdrv);
> +
> +MODULE_AUTHOR("Niklas S=F6derlund <niklas.soderlund@ragnatech.se>");
> +MODULE_DESCRIPTION("Renesas R-Car MIPI CSI-2 receiver");
> +MODULE_LICENSE("GPL v2");

This contradicts the copyright header at the beginning of the file that sta=
tes=20
GPL v2+ (which would be encoded in MODULE_LICENSE as just "GPL").

=2D-=20
Regards,

Laurent Pinchart
