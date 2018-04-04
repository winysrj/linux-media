Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60468 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751516AbeDDUOB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Apr 2018 16:14:01 -0400
Date: Wed, 4 Apr 2018 23:13:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180404201357.kx7e4dbqurn5zx2r@valkosipuli.retiisi.org.uk>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se>
 <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
 <20180329113039.4v5whquyrtgf5yaa@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180329113039.4v5whquyrtgf5yaa@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime and Niklas,

On Thu, Mar 29, 2018 at 01:30:39PM +0200, Maxime Ripard wrote:
> Hi Niklas,
> 
> On Tue, Feb 13, 2018 at 12:01:32AM +0100, Niklas Söderlund wrote:
> > +	switch (priv->lanes) {
> > +	case 1:
> > +		phycnt = PHYCNT_ENABLECLK | PHYCNT_ENABLE_0;
> > +		break;
> > +	case 2:
> > +		phycnt = PHYCNT_ENABLECLK | PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
> > +		break;
> > +	case 4:
> > +		phycnt = PHYCNT_ENABLECLK | PHYCNT_ENABLE_3 | PHYCNT_ENABLE_2 |
> > +			PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> 
> I guess you could have a simpler construct here using this:
> 
> phycnt = PHYCNT_ENABLECLK;
> 
> switch (priv->lanes) {
> case 4:
> 	phycnt |= PHYCNT_ENABLE_3 | PHYCNT_ENABLE_2;
> case 2:
> 	phycnt |= PHYCNT_ENABLE_1;
> case 1:
> 	phycnt |= PHYCNT_ENABLE_0;
> 	break;
> 
> default:
> 	return -EINVAL;
> }
> 
> But that's really up to you.
> 
> > +static int rcar_csi2_probe(struct platform_device *pdev)
> > +{
> > +	const struct soc_device_attribute *attr;
> > +	struct rcar_csi2 *priv;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> > +	if (!priv)
> > +		return -ENOMEM;
> > +
> > +	priv->info = of_device_get_match_data(&pdev->dev);
> > +
> > +	/* r8a7795 ES1.x behaves different then ES2.0+ but no own compat */
> > +	attr = soc_device_match(r8a7795es1);
> > +	if (attr)
> > +		priv->info = attr->data;
> > +
> > +	priv->dev = &pdev->dev;
> > +
> > +	mutex_init(&priv->lock);
> > +	priv->stream_count = 0;
> > +
> > +	ret = rcar_csi2_probe_resources(priv, pdev);
> > +	if (ret) {
> > +		dev_err(priv->dev, "Failed to get resources\n");
> > +		return ret;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, priv);
> > +
> > +	ret = rcar_csi2_parse_dt(priv);
> > +	if (ret)
> > +		return ret;
> > +
> > +	priv->subdev.owner = THIS_MODULE;
> > +	priv->subdev.dev = &pdev->dev;
> > +	v4l2_subdev_init(&priv->subdev, &rcar_csi2_subdev_ops);
> > +	v4l2_set_subdevdata(&priv->subdev, &pdev->dev);
> > +	snprintf(priv->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s %s",
> > +		 KBUILD_MODNAME, dev_name(&pdev->dev));
> > +	priv->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +
> > +	priv->subdev.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
> > +	priv->subdev.entity.ops = &rcar_csi2_entity_ops;
> > +
> > +	priv->pads[RCAR_CSI2_SINK].flags = MEDIA_PAD_FL_SINK;
> > +	for (i = RCAR_CSI2_SOURCE_VC0; i < NR_OF_RCAR_CSI2_PAD; i++)
> > +		priv->pads[i].flags = MEDIA_PAD_FL_SOURCE;
> > +
> > +	ret = media_entity_pads_init(&priv->subdev.entity, NR_OF_RCAR_CSI2_PAD,
> > +				     priv->pads);
> > +	if (ret)
> > +		goto error;
> > +
> > +	pm_runtime_enable(&pdev->dev);
> 
> Is CONFIG_PM mandatory on Renesas SoCs? If not, you end up with the
> device uninitialised at probe, and pm_runtime_get_sync will not
> initialise it either if CONFIG_PM is not enabled. I guess you could
> call your runtime_resume function unconditionally, and mark the device
> as active in runtime_pm using pm_runtime_set_active.

There doesn't seem to be any runtime_resume function. Was there supposed
to be one?

Assuming runtime PM would actually do something here, you might add
pm_runtime_idle() to power the device off after probing.

I guess pm_runtime_set_active() should precede pm_runtime_enable().

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
