Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:47291 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751211AbdAPPEW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 10:04:22 -0500
Message-ID: <1484578988.8415.160.camel@pengutronix.de>
Subject: Re: [PATCH v3 17/24] media: imx: Add CSI subdev driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Mon, 16 Jan 2017 16:03:08 +0100
In-Reply-To: <1483755102-24785-18-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1483755102-24785-18-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-01-06 at 18:11 -0800, Steve Longerbeam wrote:
> This is a media entity subdevice for the i.MX Camera
> Serial Interface module.

s/Serial/Sensor/

> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/Kconfig   |  13 +
>  drivers/staging/media/imx/Makefile  |   2 +
>  drivers/staging/media/imx/imx-csi.c | 644 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 659 insertions(+)
>  create mode 100644 drivers/staging/media/imx/imx-csi.c
> 
> diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
> index bfde58d..ce2d2c8 100644
> --- a/drivers/staging/media/imx/Kconfig
> +++ b/drivers/staging/media/imx/Kconfig
> @@ -6,3 +6,16 @@ config VIDEO_IMX_MEDIA
>  	  Say yes here to enable support for video4linux media controller
>  	  driver for the i.MX5/6 SOC.
>  
> +if VIDEO_IMX_MEDIA
> +menu "i.MX5/6 Media Sub devices"
> +
> +config VIDEO_IMX_CAMERA

s/CAMERA/CSI/ ?

> +	tristate "i.MX5/6 Camera driver"

i.MX5/6 Camera Sensor Interface driver

> +	depends on VIDEO_IMX_MEDIA && VIDEO_DEV && I2C
> +	select VIDEOBUF2_DMA_CONTIG
> +	default y
> +	---help---
> +	  A video4linux camera capture driver for i.MX5/6.
> +
> +endmenu
> +endif
> diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
> index ef9f11b..133672a 100644
> --- a/drivers/staging/media/imx/Makefile
> +++ b/drivers/staging/media/imx/Makefile
> @@ -4,3 +4,5 @@ imx-media-objs := imx-media-dev.o imx-media-fim.o imx-media-internal-sd.o \
>  obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media.o
>  obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-common.o
>  
> +obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-csi.o
> +
> diff --git a/drivers/staging/media/imx/imx-csi.c b/drivers/staging/media/imx/imx-csi.c
> new file mode 100644
> index 0000000..64ef862
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-csi.c
> @@ -0,0 +1,644 @@
> +/*
> + * V4L2 Capture CSI Subdev for Freescale i.MX5/6 SOC
> + *
> + * Copyright (c) 2014-2016 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <video/imx-ipu-v3.h>
> +#include "imx-media.h"
> +
> +#define CSI_NUM_PADS 2
> +
> +struct csi_priv {
> +	struct device *dev;
> +	struct ipu_soc *ipu;
> +	struct imx_media_dev *md;
> +	struct v4l2_subdev sd;
> +	struct media_pad pad[CSI_NUM_PADS];
> +	struct v4l2_mbus_framefmt format_mbus[CSI_NUM_PADS];
> +	struct v4l2_mbus_config sensor_mbus_cfg;
> +	struct v4l2_rect crop;
> +	struct ipu_csi *csi;
> +	int csi_id;
> +	int input_pad;
> +	int output_pad;
> +	bool power_on;  /* power is on */
> +	bool stream_on; /* streaming is on */
> +
> +	/* the sink for the captured frames */
> +	struct v4l2_subdev *sink_sd;
> +	enum ipu_csi_dest dest;
> +	struct v4l2_subdev *src_sd;

src_sd is not used except that its presence marks an enabled input link.
-> could be changed to bool.

> +	struct v4l2_ctrl_handler ctrl_hdlr;
> +	struct imx_media_fim *fim;
> +
> +	/* the attached sensor at stream on */
> +	struct imx_media_subdev *sensor;
> +};
> +
> +static inline struct csi_priv *sd_to_dev(struct v4l2_subdev *sdev)
> +{
> +	return container_of(sdev, struct csi_priv, sd);
> +}
> +
> +/* Update the CSI whole sensor and active windows */
> +static int csi_setup(struct csi_priv *priv)
> +{
> +	struct v4l2_mbus_framefmt infmt;
> +
> +	ipu_csi_set_window(priv->csi, &priv->crop);
> +
> +	/*
> +	 * the ipu-csi doesn't understand ALTERNATE, but it only
> +	 * needs to know whether the stream is interlaced, so set
> +	 * to INTERLACED if infmt field is ALTERNATE.
> +	 */
> +	infmt = priv->format_mbus[priv->input_pad];
> +	if (infmt.field == V4L2_FIELD_ALTERNATE)
> +		infmt.field = V4L2_FIELD_INTERLACED;

That should be SEQ_TB/BT depending on video standard.

> +	ipu_csi_init_interface(priv->csi, &priv->sensor_mbus_cfg, &infmt);
> +
> +	ipu_csi_set_dest(priv->csi, priv->dest);
> +
> +	ipu_csi_dump(priv->csi);
> +
> +	return 0;
> +}
> +
> +static int csi_start(struct csi_priv *priv)
> +{
> +	int ret;
> +
> +	if (!priv->sensor) {
> +		v4l2_err(&priv->sd, "no sensor attached\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = csi_setup(priv);
> +	if (ret)
> +		return ret;
> +
> +	/* start the frame interval monitor */
> +	if (priv->fim) {
> +		ret = imx_media_fim_set_stream(priv->fim, priv->sensor, true);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ret = ipu_csi_enable(priv->csi);
> +	if (ret) {
> +		v4l2_err(&priv->sd, "CSI enable error: %d\n", ret);
> +		goto fim_off;
> +	}
> +
> +	return 0;
> +
> +fim_off:
> +	if (priv->fim)
> +		imx_media_fim_set_stream(priv->fim, priv->sensor, false);
> +	return ret;
> +}
> +
> +static void csi_stop(struct csi_priv *priv)
> +{
> +	/* stop the frame interval monitor */
> +	if (priv->fim)
> +		imx_media_fim_set_stream(priv->fim, priv->sensor, false);
> +
> +	ipu_csi_disable(priv->csi);
> +}
> +
> +static int csi_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
> +	int ret = 0;
> +
> +	if (!priv->src_sd || !priv->sink_sd)
> +		return -EPIPE;
> +
> +	v4l2_info(sd, "stream %s\n", enable ? "ON" : "OFF");

These could be silenced a bit.

[...]
> +static int csi_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
> +	int ret = 0;
> +
> +	v4l2_info(sd, "power %s\n", on ? "ON" : "OFF");
> +
> +	if (priv->fim && on != priv->power_on)
> +		ret = imx_media_fim_set_power(priv->fim, on);
> +
> +	if (!ret)
> +		priv->power_on = on;
> +	return ret;
> +}

Is this called multiple times? I'd expect a poweron during open and a
poweroff during close, so no need for priv->power_on.

> +static int csi_link_setup(struct media_entity *entity,
> +			  const struct media_pad *local,
> +			  const struct media_pad *remote, u32 flags)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
> +	struct v4l2_subdev *remote_sd;
> +
> +	dev_dbg(priv->dev, "link setup %s -> %s", remote->entity->name,
> +		local->entity->name);
> +
> +	remote_sd = media_entity_to_v4l2_subdev(remote->entity);
> +
> +	if (local->flags & MEDIA_PAD_FL_SINK) {
> +		if (flags & MEDIA_LNK_FL_ENABLED) {
> +			if (priv->src_sd)
> +				return -EBUSY;
> +			priv->src_sd = remote_sd;
> +		} else {
> +			priv->src_sd = NULL;
> +		}
> +
> +		return 0;
> +	}
> +
> +	if (flags & MEDIA_LNK_FL_ENABLED) {
> +		if (priv->sink_sd)
> +			return -EBUSY;
> +		priv->sink_sd = remote_sd;
> +	} else {
> +		priv->sink_sd = NULL;
> +		return 0;
> +	}
> +
> +	/* set CSI destination */
> +	switch (remote_sd->grp_id) {
> +	case IMX_MEDIA_GRP_ID_SMFC0:
> +	case IMX_MEDIA_GRP_ID_SMFC1:
> +	case IMX_MEDIA_GRP_ID_SMFC2:
> +	case IMX_MEDIA_GRP_ID_SMFC3:

With removal of the SMFC entities, CSI0 could be fixed to SMFC0 and CSI1
to the SMFC2 channel.

[...]
> +static int csi_set_fmt(struct v4l2_subdev *sd,
> +		       struct v4l2_subdev_pad_config *cfg,
> +		       struct v4l2_subdev_format *sdformat)
> +{
> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
> +	struct v4l2_mbus_framefmt *infmt, *outfmt;
> +	struct v4l2_rect crop;
> +	int ret;
> +
> +	if (sdformat->pad >= CSI_NUM_PADS)
> +		return -EINVAL;
> +
> +	if (priv->stream_on)
> +		return -EBUSY;
> +
> +	infmt = &priv->format_mbus[priv->input_pad];
> +	outfmt = &priv->format_mbus[priv->output_pad];
> +
> +	if (sdformat->pad == priv->output_pad) {
> +		sdformat->format.code = infmt->code;
> +		sdformat->format.field = infmt->field;
> +		crop.left = priv->crop.left;
> +		crop.top = priv->crop.top;
> +		crop.width = sdformat->format.width;
> +		crop.height = sdformat->format.height;
> +		ret = csi_try_crop(priv, &crop);
> +		if (ret)
> +			return ret;
> +		sdformat->format.width = crop.width;
> +		sdformat->format.height = crop.height;
> +	}
> +
> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {

Should there be some limitations on the format here?

regards
Philipp

