Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46655 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751941AbeDDPZP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 11:25:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
Date: Wed, 04 Apr 2018 18:25:23 +0300
Message-ID: <3087271.YPSegSqyCH@avalon>
In-Reply-To: <eb0b92de-cb09-9d72-8d46-80a0359184f2@ideasonboard.com>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se> <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se> <eb0b92de-cb09-9d72-8d46-80a0359184f2@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, 14 March 2018 00:23:49 EEST Kieran Bingham wrote:
> Hi Niklas
>=20
> Thank you for this patch ...
> I know it has been a lot of work getting this and the VIN together!
>=20
> On 13/02/18 00:01, Niklas S=F6derlund wrote:
> > A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> > supports the R-Car Gen3 SoCs where separate CSI-2 hardware blocks are
> > connected between the video sources and the video grabbers (VIN).
> >=20
> > Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
> >=20
> > Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.s=
e>
> > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> I don't think there's actually anything major in the below - so with any
> comments addressed, or specifically ignored you can add my:
>=20
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>=20
> tag if you like.
>=20
> > ---
> >=20
> >  drivers/media/platform/rcar-vin/Kconfig     |  12 +
> >  drivers/media/platform/rcar-vin/Makefile    |   1 +
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 884 ++++++++++++++++++++=
+++
> >  3 files changed, 897 insertions(+)
> >  create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c

[snip]

> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > b/drivers/media/platform/rcar-vin/rcar-csi2.c new file mode 100644
> > index 0000000000000000..c0c2a763151bc928
> > --- /dev/null
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -0,0 +1,884 @@
> > +// SPDX-License-Identifier: GPL-2.0+

Do you intend making it GPL-2.0+ or did you mean GPL-2.0 ?

> > +/*
> > + * Driver for Renesas R-Car MIPI CSI-2 Receiver
> > + *
> > + * Copyright (C) 2018 Renesas Electronics Corp.
> > + */

[snip]

> > +static const struct rcar_csi2_format *rcar_csi2_code_to_fmt(unsigned i=
nt
> > code)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(rcar_csi2_formats); i++)
> > +		if (rcar_csi2_formats[i].code =3D=3D code)
> > +			return rcar_csi2_formats + i;
>=20
> I would have written this as:
> 	return &rcar_csi2_formats[i];  but I think your way is valid too :)

I would have done the same.

> I have a nice 'for_each_entity_in_array' macro I keep meaning to post whi=
ch
> would be nice here too - but hey - for another day.
>=20
> > +
> > +	return NULL;
> > +}

[snip]

> > +static int rcar_csi2_wait_phy_start(struct rcar_csi2 *priv)
> > +{
> > +	int timeout;
> > +
> > +	/* Wait for the clock and data lanes to enter LP-11 state. */
> > +	for (timeout =3D 100; timeout > 0; timeout--) {
> > +		const u32 lane_mask =3D (1 << priv->lanes) - 1;
> > +
> > +		if ((rcar_csi2_read(priv, PHCLM_REG) & 1) =3D=3D 1 &&
>=20
> The '1' is not very clear here.. Could this be:
>=20
> 		if ((rcar_csi2_read(priv, PHCLM_REG) & PHCLM_STOPSTATE) &&

That reads a bit better, yes.

> > +		    (rcar_csi2_read(priv, PHDLM_REG) & lane_mask) =3D=3D lane_mask)
> > +			return 0;
> > +
> > +		msleep(20);
> > +	}
> > +
> > +	dev_err(priv->dev, "Timeout waiting for LP-11 state\n");
>=20
> Does LP =3D=3D ULP ? I presume these mean 'low power' / 'ultra low power'=
 ?
> Although the PHCLM lane mask refers to the STOPSTATE, so I guess this is
> also waiting for the lanes to be idle.

LP-11 refers to the low-power single-ended state where both the + and - lan=
es=20
are at high level. It is the bus idle state for D-PHY. The ultra-low power=
=20
state is ULPS and is different (if I remember correctly the lines go to the=
=20
LP-00 state).

> > +
> > +	return -ETIMEDOUT;
> > +}

[snip]

> > +static int rcar_csi2_start(struct rcar_csi2 *priv)
> > +{
> > +	const struct rcar_csi2_format *format;
> > +	u32 phycnt, phypll, vcdt =3D 0, vcdt2 =3D 0;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	dev_dbg(priv->dev, "Input size (%ux%u%c)\n",
> > +		priv->mf.width, priv->mf.height,
> > +		priv->mf.field =3D=3D V4L2_FIELD_NONE ? 'p' : 'i');
> > +
> > +	/* Code is validated in set_fmt */
> > +	format =3D rcar_csi2_code_to_fmt(priv->mf.code);
> > +
> > +	/*
> > +	 * Enable all Virtual Channels
> > +	 *
> > +	 * NOTE: It's not possible to get individual datatype for each
> > +	 *       source virtual channel. Once this is possible in V4L2
> > +	 *       it should be used here.
> > +	 */
> > +	for (i =3D 0; i < 4; i++) {
>=20
> Does 4 represent the maximum number of lanes? or can we have 4 VCs on a
> single lane ?

Virtual channels and data lanes are independent. Of course the more virtual=
=20
channels you need to carry the more bandwidth you will likely need, so you=
=20
might need more data lanes, but there's no direct correlation.

> > +		u32 vcdt_part;
> > +
> > +		vcdt_part =3D VCDT_SEL_VC(i) | VCDT_VCDTN_EN | VCDT_SEL_DTN_ON |
> > +			VCDT_SEL_DT(format->datatype);
> > +
> > +		/* Store in correct reg and offset */
> > +		if (i < 2)
> > +			vcdt |=3D vcdt_part << ((i % 2) * 16);
> > +		else
> > +			vcdt2 |=3D vcdt_part << ((i % 2) * 16);
> > +	}
> > +
> > +	switch (priv->lanes) {
> > +	case 1:
> > +		phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_0;
> > +		break;
> > +	case 2:
> > +		phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
> > +		break;
> > +	case 4:
> > +		phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_3 | PHYCNT_ENABLE_2 |
> > +			PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	ret =3D rcar_csi2_calc_phypll(priv, format->bpp, &phypll);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Clear Ultra Low Power interrupt */
> > +	if (priv->info->clear_ulps)
> > +		rcar_csi2_write(priv, INTSTATE_REG,
> > +				INTSTATE_INT_ULPS_START |
> > +				INTSTATE_INT_ULPS_END);
> > +
> > +	/* Init */
> > +	rcar_csi2_write(priv, TREF_REG, TREF_TREF);
> > +	rcar_csi2_reset(priv);
> > +	rcar_csi2_write(priv, PHTC_REG, 0);
> > +
> > +	/* Configure */
> > +	rcar_csi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
> > +			FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);
> > +	rcar_csi2_write(priv, VCDT_REG, vcdt);
> > +	rcar_csi2_write(priv, VCDT2_REG, vcdt2);
> > +	/* Lanes are zero indexed */
> > +	rcar_csi2_write(priv, LSWAP_REG,
> > +			LSWAP_L0SEL(priv->lane_swap[0] - 1) |
> > +			LSWAP_L1SEL(priv->lane_swap[1] - 1) |
> > +			LSWAP_L2SEL(priv->lane_swap[2] - 1) |
> > +			LSWAP_L3SEL(priv->lane_swap[3] - 1));
> > +
> > +	if (priv->info->init_phtw) {
> > +		/*
> > +		 * This is for H3 ES2.0
> > +		 *
> > +		 * NOTE: Additional logic is needed here when
> > +		 * support for V3H and/or M3-N is added
> > +		 */
> > +		rcar_csi2_write(priv, PHTW_REG, 0x01cc01e2);
> > +		rcar_csi2_write(priv, PHTW_REG, 0x010101e3);
> > +		rcar_csi2_write(priv, PHTW_REG, 0x010101e4);
> > +		rcar_csi2_write(priv, PHTW_REG, 0x01100104);
> > +		rcar_csi2_write(priv, PHTW_REG, 0x01030100);
> > +		rcar_csi2_write(priv, PHTW_REG, 0x01800100);
>=20
> Voodoo magic ?
>=20
> I think just say yes here and move on  ...
> I've looked at the flow chart in 25.3.9 ... I think I'll just believe this
> works :D especially as I've seen it working, but does it matter that the
> values aren't read back?
>=20
> Perhaps these could be moved to a (set of) table(s) and a loop to support
> the V3H/M3-N later (but not now)

I think we can fix this later, yes.

> > +	}
> > +
> > +	/* Start */
> > +	rcar_csi2_write(priv, PHYPLL_REG, phypll);
> > +
> > +	/* Set frequency range if we have it */
> > +	if (priv->info->csi0clkfreqrange)
> > +		rcar_csi2_write(priv, CSI0CLKFCPR_REG,
> > +				CSI0CLKFREQRANGE(priv->info->csi0clkfreqrange));
> > +
> > +	rcar_csi2_write(priv, PHYCNT_REG, phycnt);
> > +	rcar_csi2_write(priv, LINKCNT_REG, LINKCNT_MONITOR_EN |
> > +			LINKCNT_REG_MONI_PACT_EN | LINKCNT_ICLK_NONSTOP);
> > +	rcar_csi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ);
> > +	rcar_csi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ |
> > +			PHYCNT_RSTZ);
> > +
> > +	return rcar_csi2_wait_phy_start(priv);
> > +}

[snip]

> > +static int rcar_csi2_s_stream(struct v4l2_subdev *sd, int enable)
> > +{
> > +	struct rcar_csi2 *priv =3D sd_to_csi2(sd);
> > +	struct v4l2_subdev *nextsd;
> > +	int ret =3D 0;
> > +
> > +	mutex_lock(&priv->lock);
> > +
> > +	if (!priv->remote) {
> > +		ret =3D -ENODEV;
> > +		goto out;
> > +	}
> > +
> > +	nextsd =3D priv->remote;
> > +
> > +	if (enable && priv->stream_count =3D=3D 0) {
> > +		pm_runtime_get_sync(priv->dev);
> > +
> > +		ret =3D rcar_csi2_start(priv);
> > +		if (ret) {
> > +			pm_runtime_put(priv->dev);
> > +			goto out;
> > +		}
> > +
> > +		ret =3D v4l2_subdev_call(nextsd, video, s_stream, 1);
>=20
> Would it be nicer to pass 'enable' through instead of the '1'? (of course
> enable=3D=3D1 here)

The caller shouldn't set enable to a value other than 0 or 1, but in case i=
t=20
does, 1 seems better to me (and I find it more readable too).

> > +		if (ret) {
> > +			rcar_csi2_stop(priv);
> > +			pm_runtime_put(priv->dev);
> > +			goto out;
> > +		}
> > +	} else if (!enable && priv->stream_count =3D=3D 1) {
> > +		rcar_csi2_stop(priv);
> > +		v4l2_subdev_call(nextsd, video, s_stream, 0);
>=20
> likewise here...

Likewise, I find 0 more readable :-)

> > +		pm_runtime_put(priv->dev);
> > +	}
>=20
> What's the 'nextsd' in this instance? We only call the s_stream on nextsd=
 if
> it is the first one to be started, or the last one to be stopped...
>=20
> I can understand this logic for calling rcar_csi2_stop/rcar_csi2_start ...
> but shouldn't we always call :
> 	v4l2_subdev_call(nextsd, video, s_stream, enable); ?
>=20
> in GMSL context, I guess 'nextsd' is the MAX9286?
> At which point - it would be called for start/stop, priv->stream_count
> times, and would also have to provide it's own call balancing...
>=20
> Call me crazy and ignore me here if you like :-)

I'll let Niklas explain :-)

> > +
> > +	priv->stream_count +=3D enable ? 1 : -1;
> > +out:
> > +	mutex_unlock(&priv->lock);
> > +
> > +	return ret;
> > +}

[snip]

> > +static const struct rcar_csi2_info rcar_csi2_info_r8a7795 =3D {
> > +	.hsfreqrange =3D hsfreqrange_h3_v3h_m3n,
> > +	.clear_ulps =3D true,
> > +	.init_phtw =3D true,
> > +	.csi0clkfreqrange =3D 0x20,
>=20
> 	0x20 ?

The datasheet states that the field should be set to 0x20 and doesn't offer=
=20
any other explanation :-/

> > +};

[snip]

> > +static int rcar_csi2_probe(struct platform_device *pdev)
> > +{
> > +	const struct soc_device_attribute *attr;
> > +	struct rcar_csi2 *priv;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	priv =3D devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> > +	if (!priv)
> > +		return -ENOMEM;
> > +
> > +	priv->info =3D of_device_get_match_data(&pdev->dev);
> > +
> > +	/* r8a7795 ES1.x behaves different then ES2.0+ but no own compat */
>=20
> /*
>  * r8a7795 ES1.x behaves differently than the ES2.0+ but doesn't have it's
> own
>  * compatible string
>  */

With a period at the end of the sentence if would be perfect :-)

> > +	attr =3D soc_device_match(r8a7795es1);
> > +	if (attr)
> > +		priv->info =3D attr->data;
> > +
> > +	priv->dev =3D &pdev->dev;
> > +
> > +	mutex_init(&priv->lock);
> > +	priv->stream_count =3D 0;
> > +
> > +	ret =3D rcar_csi2_probe_resources(priv, pdev);
> > +	if (ret) {
> > +		dev_err(priv->dev, "Failed to get resources\n");
> > +		return ret;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, priv);
> > +
> > +	ret =3D rcar_csi2_parse_dt(priv);
> > +	if (ret)
> > +		return ret;
> > +
> > +	priv->subdev.owner =3D THIS_MODULE;
> > +	priv->subdev.dev =3D &pdev->dev;
> > +	v4l2_subdev_init(&priv->subdev, &rcar_csi2_subdev_ops);
> > +	v4l2_set_subdevdata(&priv->subdev, &pdev->dev);
> > +	snprintf(priv->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s %s",
> > +		 KBUILD_MODNAME, dev_name(&pdev->dev));
> > +	priv->subdev.flags =3D V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +
> > +	priv->subdev.entity.function =3D MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATT=
ER;
> > +	priv->subdev.entity.ops =3D &rcar_csi2_entity_ops;
> > +
> > +	priv->pads[RCAR_CSI2_SINK].flags =3D MEDIA_PAD_FL_SINK;
> > +	for (i =3D RCAR_CSI2_SOURCE_VC0; i < NR_OF_RCAR_CSI2_PAD; i++)
> > +		priv->pads[i].flags =3D MEDIA_PAD_FL_SOURCE;
> > +
> > +	ret =3D media_entity_pads_init(&priv->subdev.entity, NR_OF_RCAR_CSI2_=
PAD,
> > +				     priv->pads);
> > +	if (ret)
> > +		goto error;
> > +
> > +	pm_runtime_enable(&pdev->dev);
> > +
> > +	ret =3D v4l2_async_register_subdev(&priv->subdev);
> > +	if (ret < 0)
> > +		goto error;
> > +
> > +	dev_info(priv->dev, "%d lanes found\n", priv->lanes);
> > +
> > +	return 0;
> > +
> > +error:
> > +	v4l2_async_notifier_unregister(&priv->notifier);
> > +	v4l2_async_notifier_cleanup(&priv->notifier);
> > +
> > +	return ret;
> > +}

[snip]

> Well ... phew ... done :) I can go to bed.

I wish I could do the same :-)

=2D-=20
Regards,

Laurent Pinchart
