Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46667 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbeDDP0I (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 11:26:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
Date: Wed, 04 Apr 2018 18:26:17 +0300
Message-ID: <2180075.m4Wkig6IL5@avalon>
In-Reply-To: <20180329113039.4v5whquyrtgf5yaa@flea>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se> <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se> <20180329113039.4v5whquyrtgf5yaa@flea>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Thursday, 29 March 2018 14:30:39 EEST Maxime Ripard wrote:
> On Tue, Feb 13, 2018 at 12:01:32AM +0100, Niklas S=F6derlund wrote:
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
>=20
> I guess you could have a simpler construct here using this:
>=20
> phycnt =3D PHYCNT_ENABLECLK;
>=20
> switch (priv->lanes) {
> case 4:
> 	phycnt |=3D PHYCNT_ENABLE_3 | PHYCNT_ENABLE_2;
> case 2:
> 	phycnt |=3D PHYCNT_ENABLE_1;
> case 1:
> 	phycnt |=3D PHYCNT_ENABLE_0;
> 	break;
>=20
> default:
> 	return -EINVAL;
> }
>=20
> But that's really up to you.

Wouldn't Niklas' version generate simpler code as it uses direct assignment=
s ?

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
>=20
> Is CONFIG_PM mandatory on Renesas SoCs? If not, you end up with the
> device uninitialised at probe, and pm_runtime_get_sync will not
> initialise it either if CONFIG_PM is not enabled. I guess you could
> call your runtime_resume function unconditionally, and mark the device
> as active in runtime_pm using pm_runtime_set_active.
>=20
> Looks good otherwise, once fixed (and if relevant):
> Reviewed-by: Maxime Ripard <maxime.ripard@bootlin.com>

=2D-=20
Regards,

Laurent Pinchart
