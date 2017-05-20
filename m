Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48548 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdETMgW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 May 2017 08:36:22 -0400
Date: Sat, 20 May 2017 14:36:15 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pavel Machek <pavel@ucw.cz>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v5 2/3] platform: add video-multiplexer subdevice driver
Message-ID: <20170520123615.vhi72kakhlj725ni@earth>
References: <1495034107-21407-1-git-send-email-p.zabel@pengutronix.de>
 <1495034107-21407-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ogsnrmmo6ov63lav"
Content-Disposition: inline
In-Reply-To: <1495034107-21407-2-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ogsnrmmo6ov63lav
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 17, 2017 at 05:15:06PM +0200, Philipp Zabel wrote:
> This driver can handle SoC internal and external video bus multiplexers,
> controlled by mux controllers provided by the mux controller framework,
> such as MMIO register bitfields or GPIOs. The subdevice passes through
> the mbus configuration of the active input to the output side.
>=20
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
> No changes since v4 [1]:
>=20
> This patch depends on the mux subsystem [2] and on the mmio-mux driver [3]
> to work on i.MX6. The follow-up patch will make this usable until the mux
> framework is merged.
>=20
> [1] https://patchwork.kernel.org/patch/9712131/
> [2] https://patchwork.kernel.org/patch/9725911/
> [3] https://patchwork.kernel.org/patch/9725893/
> ---
>  drivers/media/platform/Kconfig     |   6 +
>  drivers/media/platform/Makefile    |   2 +
>  drivers/media/platform/video-mux.c | 295 +++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 303 insertions(+)
>  create mode 100644 drivers/media/platform/video-mux.c
>=20
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kcon=
fig
> index ac026ee1ca074..259c0ff780937 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -74,6 +74,12 @@ config VIDEO_M32R_AR_M64278
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called arv.
> =20
> +config VIDEO_MUX
> +	tristate "Video Multiplexer"
> +	depends on OF && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER && MULTIPLEX=
ER
> +	help
> +	  This driver provides support for N:1 video bus multiplexers.
> +
>  config VIDEO_OMAP3
>  	tristate "OMAP 3 Camera support"
>  	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Mak=
efile
> index 63303d63c64cf..a6363023f981e 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -28,6 +28,8 @@ obj-$(CONFIG_VIDEO_SH_VEU)		+=3D sh_veu.o
> =20
>  obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+=3D m2m-deinterlace.o
> =20
> +obj-$(CONFIG_VIDEO_MUX)			+=3D video-mux.o
> +
>  obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+=3D s3c-camif/
>  obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS4_IS) 	+=3D exynos4-is/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+=3D s5p-jpeg/
> diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/=
video-mux.c
> new file mode 100644
> index 0000000000000..e35ffa18126f3
> --- /dev/null
> +++ b/drivers/media/platform/video-mux.c
> @@ -0,0 +1,295 @@
> +/*
> + * video stream multiplexer controlled via mux control
> + *
> + * Copyright (C) 2013 Pengutronix, Sascha Hauer <kernel@pengutronix.de>
> + * Copyright (C) 2016-2017 Pengutronix, Philipp Zabel <kernel@pengutroni=
x.de>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/mux/consumer.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
> +#include <linux/platform_device.h>
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +
> +struct video_mux {
> +	struct v4l2_subdev subdev;
> +	struct media_pad *pads;
> +	struct v4l2_mbus_framefmt *format_mbus;
> +	struct mux_control *mux;
> +	struct mutex lock;
> +	int active;
> +};
> +
> +static inline struct video_mux *v4l2_subdev_to_video_mux(struct v4l2_sub=
dev *sd)
> +{
> +	return container_of(sd, struct video_mux, subdev);
> +}
> +
> +static int video_mux_link_setup(struct media_entity *entity,
> +				const struct media_pad *local,
> +				const struct media_pad *remote, u32 flags)
> +{
> +	struct v4l2_subdev *sd =3D media_entity_to_v4l2_subdev(entity);
> +	struct video_mux *vmux =3D v4l2_subdev_to_video_mux(sd);
> +	int ret =3D 0;
> +
> +	/*
> +	 * The mux state is determined by the enabled sink pad link.
> +	 * Enabling or disabling the source pad link has no effect.
> +	 */
> +	if (local->flags & MEDIA_PAD_FL_SOURCE)
> +		return 0;
> +
> +	dev_dbg(sd->dev, "link setup '%s':%d->'%s':%d[%d]",
> +		remote->entity->name, remote->index, local->entity->name,
> +		local->index, flags & MEDIA_LNK_FL_ENABLED);
> +
> +	mutex_lock(&vmux->lock);
> +
> +	if (flags & MEDIA_LNK_FL_ENABLED) {
> +		if (vmux->active =3D=3D local->index)
> +			goto out;
> +
> +		if (vmux->active >=3D 0) {
> +			ret =3D -EBUSY;
> +			goto out;
> +		}
> +
> +		dev_dbg(sd->dev, "setting %d active\n", local->index);
> +		ret =3D mux_control_try_select(vmux->mux, local->index);
> +		if (ret < 0)
> +			goto out;
> +		vmux->active =3D local->index;
> +	} else {
> +		if (vmux->active !=3D local->index)
> +			goto out;
> +
> +		dev_dbg(sd->dev, "going inactive\n");
> +		mux_control_deselect(vmux->mux);
> +		vmux->active =3D -1;
> +	}
> +
> +out:
> +	mutex_unlock(&vmux->lock);
> +	return ret;
> +}
> +
> +static struct media_entity_operations video_mux_ops =3D {
> +	.link_setup =3D video_mux_link_setup,
> +	.link_validate =3D v4l2_subdev_link_validate,
> +};
> +
> +static int video_mux_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct video_mux *vmux =3D v4l2_subdev_to_video_mux(sd);
> +	struct v4l2_subdev *upstream_sd;
> +	struct media_pad *pad;
> +
> +	if (vmux->active =3D=3D -1) {
> +		dev_err(sd->dev, "Can not start streaming on inactive mux\n");
> +		return -EINVAL;
> +	}
> +
> +	pad =3D media_entity_remote_pad(&sd->entity.pads[vmux->active]);
> +	if (!pad) {
> +		dev_err(sd->dev, "Failed to find remote source pad\n");
> +		return -ENOLINK;
> +	}
> +
> +	if (!is_media_entity_v4l2_subdev(pad->entity)) {
> +		dev_err(sd->dev, "Upstream entity is not a v4l2 subdev\n");
> +		return -ENODEV;
> +	}
> +
> +	upstream_sd =3D media_entity_to_v4l2_subdev(pad->entity);
> +
> +	return v4l2_subdev_call(upstream_sd, video, s_stream, enable);
> +}
> +
> +static const struct v4l2_subdev_video_ops video_mux_subdev_video_ops =3D=
 {
> +	.s_stream =3D video_mux_s_stream,
> +};
> +
> +static struct v4l2_mbus_framefmt *
> +__video_mux_get_pad_format(struct v4l2_subdev *sd,
> +			   struct v4l2_subdev_pad_config *cfg,
> +			   unsigned int pad, u32 which)
> +{
> +	struct video_mux *vmux =3D v4l2_subdev_to_video_mux(sd);
> +
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_format(sd, cfg, pad);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &vmux->format_mbus[pad];
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static int video_mux_get_format(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_subdev_format *sdformat)
> +{
> +	struct video_mux *vmux =3D v4l2_subdev_to_video_mux(sd);
> +
> +	mutex_lock(&vmux->lock);
> +
> +	sdformat->format =3D *__video_mux_get_pad_format(sd, cfg, sdformat->pad,
> +						   sdformat->which);
> +
> +	mutex_unlock(&vmux->lock);
> +
> +	return 0;
> +}
> +
> +static int video_mux_set_format(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_subdev_format *sdformat)
> +{
> +	struct video_mux *vmux =3D v4l2_subdev_to_video_mux(sd);
> +	struct v4l2_mbus_framefmt *mbusformat;
> +	struct media_pad *pad =3D &vmux->pads[sdformat->pad];
> +
> +	mbusformat =3D __video_mux_get_pad_format(sd, cfg, sdformat->pad,
> +					    sdformat->which);
> +	if (!mbusformat)
> +		return -EINVAL;
> +
> +	mutex_lock(&vmux->lock);
> +
> +	/* Source pad mirrors active sink pad, no limitations on sink pads */
> +	if ((pad->flags & MEDIA_PAD_FL_SOURCE) && vmux->active >=3D 0)
> +		sdformat->format =3D vmux->format_mbus[vmux->active];
> +
> +	*mbusformat =3D sdformat->format;
> +
> +	mutex_unlock(&vmux->lock);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_pad_ops video_mux_pad_ops =3D {
> +	.get_fmt =3D video_mux_get_format,
> +	.set_fmt =3D video_mux_set_format,
> +};
> +
> +static const struct v4l2_subdev_ops video_mux_subdev_ops =3D {
> +	.pad =3D &video_mux_pad_ops,
> +	.video =3D &video_mux_subdev_video_ops,
> +};
> +
> +static int video_mux_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct device *dev =3D &pdev->dev;
> +	struct device_node *ep;
> +	struct video_mux *vmux;
> +	unsigned int num_pads =3D 0;
> +	int ret;
> +	int i;
> +
> +	vmux =3D devm_kzalloc(dev, sizeof(*vmux), GFP_KERNEL);
> +	if (!vmux)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, vmux);
> +
> +	v4l2_subdev_init(&vmux->subdev, &video_mux_subdev_ops);
> +	snprintf(vmux->subdev.name, sizeof(vmux->subdev.name), "%s", np->name);
> +	vmux->subdev.flags |=3D V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	vmux->subdev.dev =3D dev;
> +
> +	/*
> +	 * The largest numbered port is the output port. It determines
> +	 * total number of pads.
> +	 */
> +	for_each_endpoint_of_node(np, ep) {
> +		struct of_endpoint endpoint;
> +
> +		of_graph_parse_endpoint(ep, &endpoint);
> +		num_pads =3D max(num_pads, endpoint.port + 1);
> +	}
> +
> +	if (num_pads < 2) {
> +		dev_err(dev, "Not enough ports %d\n", num_pads);
> +		return -EINVAL;
> +	}
> +
> +	vmux->mux =3D devm_mux_control_get(dev, NULL);
> +	if (IS_ERR(vmux->mux)) {
> +		ret =3D PTR_ERR(vmux->mux);
> +		if (ret !=3D -EPROBE_DEFER)
> +			dev_err(dev, "Failed to get mux: %d\n", ret);
> +		return ret;
> +	}
> +
> +	mutex_init(&vmux->lock);
> +	vmux->active =3D -1;
> +	vmux->pads =3D devm_kcalloc(dev, num_pads, sizeof(*vmux->pads),
> +				  GFP_KERNEL);
> +	vmux->format_mbus =3D devm_kcalloc(dev, num_pads,
> +					 sizeof(*vmux->format_mbus),
> +					 GFP_KERNEL);
> +
> +	for (i =3D 0; i < num_pads - 1; i++)
> +		vmux->pads[i].flags =3D MEDIA_PAD_FL_SINK;
> +	vmux->pads[num_pads - 1].flags =3D MEDIA_PAD_FL_SOURCE;
> +
> +	vmux->subdev.entity.function =3D MEDIA_ENT_F_VID_MUX;
> +	ret =3D media_entity_pads_init(&vmux->subdev.entity, num_pads,
> +				     vmux->pads);
> +	if (ret < 0)
> +		return ret;
> +
> +	vmux->subdev.entity.ops =3D &video_mux_ops;
> +
> +	return v4l2_async_register_subdev(&vmux->subdev);
> +}
> +
> +static int video_mux_remove(struct platform_device *pdev)
> +{
> +	struct video_mux *vmux =3D platform_get_drvdata(pdev);
> +	struct v4l2_subdev *sd =3D &vmux->subdev;
> +
> +	v4l2_async_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id video_mux_dt_ids[] =3D {
> +	{ .compatible =3D "video-mux", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, video_mux_dt_ids);
> +
> +static struct platform_driver video_mux_driver =3D {
> +	.probe		=3D video_mux_probe,
> +	.remove		=3D video_mux_remove,
> +	.driver		=3D {
> +		.of_match_table =3D video_mux_dt_ids,
> +		.name =3D "video-mux",
> +	},
> +};
> +
> +module_platform_driver(video_mux_driver);
> +
> +MODULE_DESCRIPTION("video stream multiplexer");
> +MODULE_AUTHOR("Sascha Hauer, Pengutronix");
> +MODULE_AUTHOR("Philipp Zabel, Pengutronix");
> +MODULE_LICENSE("GPL");
> --=20
> 2.11.0
>=20

--ogsnrmmo6ov63lav
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlkgOD8ACgkQ2O7X88g7
+prA1w//aR8RxwkzaZhABbzlyFfZl33RXWOz14b9/hlsxgHB9hjypD4XUBomLCkr
HKdKmYWd59pOfz4XbRR31hZ8UqunuNntghK82hbaAMyjLdWp80huC06WjISVwRJV
vKQRY4HEeXagrEA6n3wA6rZFe5bjIfTL3TFeLWXcomFXdPPh45kPXns3of0p5BEH
swXtuOF+eSysM0grIMPfjEp4e2cOOZQR2SUP+MnkwHkgN7Y99iQ5hXyWBq3rXfIP
G8RmGemkS8G8gVeofsnVTV9EGc2EEGhBDRj6Yh4mK70AImQspqQRWhOjqB6a435C
gpG1KxxzGz7TNEuKK0ZswC6e708cOI+xFkVRdYCRdbvdrJrtpDlvnkv6+blw+Yd/
DjaE/wTwpba8ZkaLcDLXSH2khHAkSmDuKhhx+5WR1MxoyJBsYa/qm3Sj7Itf5dPF
XuPwXv2BAunC/HqamuZNNS1g0qPd1FGkH10Liuxl8+9mU091dHiQhye5h6tiI6xa
Q7gsYJvZtorudsWMqtaXwnuhnCL+rOuAFF+jexnPj4hvbwG/qoCWSFpe/FYVyacg
aVJzwQEtNRVOft84ymGvidUUcajirpLTIb70odGFod5R/gmSaHoP2j32Ue/0Cm9o
3V/2ThgiTk61YjAY5puyerXu9gJbrdEZyucK1otSIzkCFIPGTro=
=+JFY
-----END PGP SIGNATURE-----

--ogsnrmmo6ov63lav--
