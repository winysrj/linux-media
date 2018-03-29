Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:37536 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752154AbeC2Lal (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 07:30:41 -0400
Date: Thu, 29 Mar 2018 13:30:39 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
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
Message-ID: <20180329113039.4v5whquyrtgf5yaa@flea>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se>
 <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sk4fh6bceowq3vfn"
Content-Disposition: inline
In-Reply-To: <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--sk4fh6bceowq3vfn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Tue, Feb 13, 2018 at 12:01:32AM +0100, Niklas S=F6derlund wrote:
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

I guess you could have a simpler construct here using this:

phycnt =3D PHYCNT_ENABLECLK;

switch (priv->lanes) {
case 4:
	phycnt |=3D PHYCNT_ENABLE_3 | PHYCNT_ENABLE_2;
case 2:
	phycnt |=3D PHYCNT_ENABLE_1;
case 1:
	phycnt |=3D PHYCNT_ENABLE_0;
	break;

default:
	return -EINVAL;
}

But that's really up to you.

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

Is CONFIG_PM mandatory on Renesas SoCs? If not, you end up with the
device uninitialised at probe, and pm_runtime_get_sync will not
initialise it either if CONFIG_PM is not enabled. I guess you could
call your runtime_resume function unconditionally, and mark the device
as active in runtime_pm using pm_runtime_set_active.

Looks good otherwise, once fixed (and if relevant):
Reviewed-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--sk4fh6bceowq3vfn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlq8zl4ACgkQ0rTAlCFN
r3SmIg/8DSLOJ0Krg/UsgF8pYiE64XXdQdmpisGs1GzJ0F2j6MdtmOv6/qKue0MO
YXBkHTMIqQ+eH9zy/svzKb1aBdKdek8n4kYpeJXCsGEDVqSXXRK1AzbbFdxf3C1n
RMzLdVQQCjoonUswOOek+UoMwnSWXatTQv45GC/6/FKHitYcjHo1EzuuVRKFGlaU
j/vFy3JbnqSyjOWdGqYGL0qcSUuq6V5qzEVovxqxJwjcukR2swfmdsfas0HgzRj/
2giexc4+unBTLKR6VEN4FszkS/d/HUXFSFwiZIDPZxzSURLx/lJGbtmkc3f384p8
FUjh8cFd3zTdu5blfxBP8NCBn0HTP7/JuuTstpX+uOjY4I0T1ytXgCABLSlO0vDz
+sjxBMWNo8/cziZ6WC9vhKdP+NRAQOq07jzjykGpqfP+UO6kcLfph2bcbfNYXNLv
CEhNtJRzn6ztj36ibEyHl4mtyWfB0XoBms0prd9/j+MqAJ0nB9a0rTmk86Y2d1vA
xPjSDQO8/6eahdcdP1WH7TuwNygx1Zf4Ajsd/gkDb5BEvkrKWIeGMiSU7yIqoBqX
0ckV07Gav6H2gfCttUfffTUZ0ri8jyQCzRHiU8WvT+LiKnIdeP0byeO10FJX9OqU
iF+DD6Kxl5M7qttRj1FTKM+B0qZ0aP7qQ2WvLmdlh5TyPxfJd+w=
=8lI4
-----END PGP SIGNATURE-----

--sk4fh6bceowq3vfn--
