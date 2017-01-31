Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:50141 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750897AbdAaPvx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 10:51:53 -0500
Message-ID: <1485877882.2932.70.camel@pengutronix.de>
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
Date: Tue, 31 Jan 2017 16:51:22 +0100
In-Reply-To: <1483755102-24785-18-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1483755102-24785-18-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-01-06 at 18:11 -0800, Steve Longerbeam wrote:
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

This is the wrong way around, see also below.

Here the the output sdformat->format.width/height should be set to the
priv->crop.width/height (or priv->crop.width/height / 2, to enable
downscaling). The crop rectangle should not be changed by an output pad
set_fmt.

> +		if (ret)
> +			return ret;
> +		sdformat->format.width = crop.width;
> +		sdformat->format.height = crop.height;
> +	}
> +
> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		cfg->try_fmt = sdformat->format;
> +	} else {
> +		priv->format_mbus[sdformat->pad] = sdformat->format;
> +		/* Update the crop window if this is output pad  */
> +		if (sdformat->pad == priv->output_pad)
> +			priv->crop = crop;

The crop rectangle instead should be reset to the full input frame when
the input pad format is set.

regards
Philipp

