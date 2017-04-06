Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:33248 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934813AbdDFOUg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Apr 2017 10:20:36 -0400
Subject: Re: [PATCH] [media] imx: csi: retain current field order and
 colorimetry setting as default
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <1490661656-10318-22-git-send-email-steve_longerbeam@mentor.com>
 <1491486929.2392.29.camel@pengutronix.de>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0f9690f8-c7f6-59ff-9e3e-123af9972d4b@xs4all.nl>
Date: Thu, 6 Apr 2017 16:20:21 +0200
MIME-Version: 1.0
In-Reply-To: <1491486929.2392.29.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/06/2017 03:55 PM, Philipp Zabel wrote:
> If the the field order is set to ANY in set_fmt, choose the currently
> set field order. If the colorspace is set to DEFAULT, choose the current
> colorspace.  If any of xfer_func, ycbcr_enc or quantization are set to
> DEFAULT, either choose the current setting, or the default setting for the
> new colorspace, if non-DEFAULT colorspace was given.
> 
> This allows to let field order and colorimetry settings be propagated
> from upstream by calling media-ctl on the upstream entity source pad,
> and then call media-ctl on the sink pad to manually set the input frame
> interval, without changing the already set field order and colorimetry
> information.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> This is based on imx-media-staging-md-v14, and it is supposed to allow
> configuring the pipeline with media-ctl like this:
> 
> 1) media-ctl --set-v4l2 "'tc358743 1-000f':0[fmt:UYVY8_1X16/1920x1080]"
> 2) media-ctl --set-v4l2 "'imx6-mipi-csi2':1[fmt:UYVY8_1X16/1920x108]"
> 3) media-ctl --set-v4l2 "'ipu1_csi0_mux':2[fmt:UYVY8_1X16/1920x1080]"
> 4) media-ctl --set-v4l2 "'ipu1_csi0':0[fmt:UYVY8_1X16/1920x1080@1/60]"
> 5) media-ctl --set-v4l2 "'ipu1_csi0':2[fmt:AYUV32/1920x1080@1/30]"
> 
> Without having step 4) overwrite the colorspace and field order set on
> 'ipu1_csi0':0 by the propagation in step 3).
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 34 +++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 64dc454f6b371..d94ce1de2bf05 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -1325,6 +1325,40 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
>  	csi_try_fmt(priv, sensor, cfg, sdformat, crop, compose, &cc);
>  
>  	fmt = __csi_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
> +
> +	/* Retain current field setting as default */
> +	if (sdformat->format.field == V4L2_FIELD_ANY)
> +		sdformat->format.field = fmt->field;

sdformat->format.field should never be FIELD_ANY. If it is, then that's a
subdev bug and I'm pretty sure FIELD_NONE was intended.

> +
> +	/* Retain current colorspace setting as default */
> +	if (sdformat->format.colorspace == V4L2_COLORSPACE_DEFAULT) {
> +		sdformat->format.colorspace = fmt->colorspace;

No! Subdevs should never return COLORSPACE_DEFAULT. If they do, then fix
them. If this happens a lot (I'm not sure how reliably subdevs fill this
in) you could set it to COLORSPACE_RAW. Perhaps with a WARN_ON_ONCE.

> +		if (sdformat->format.xfer_func == V4L2_XFER_FUNC_DEFAULT)
> +			sdformat->format.xfer_func = fmt->xfer_func;
> +		if (sdformat->format.ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
> +			sdformat->format.ycbcr_enc = fmt->ycbcr_enc;
> +		if (sdformat->format.quantization == V4L2_QUANTIZATION_DEFAULT)
> +			sdformat->format.quantization = fmt->quantization;

Nack. This is meaningless.

> +	} else {
> +		if (sdformat->format.xfer_func == V4L2_XFER_FUNC_DEFAULT) {
> +			sdformat->format.xfer_func =
> +				V4L2_MAP_XFER_FUNC_DEFAULT(
> +						sdformat->format.colorspace);
> +		}
> +		if (sdformat->format.ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT) {
> +			sdformat->format.ycbcr_enc =
> +				V4L2_MAP_YCBCR_ENC_DEFAULT(
> +						sdformat->format.colorspace);
> +		}
> +		if (sdformat->format.quantization == V4L2_QUANTIZATION_DEFAULT) {
> +			sdformat->format.quantization =
> +				V4L2_MAP_QUANTIZATION_DEFAULT(
> +						cc->cs != IPUV3_COLORSPACE_YUV,
> +						sdformat->format.colorspace,
> +						sdformat->format.ycbcr_enc);
> +		}

This isn't wrong, but it is perfectly fine to keep the DEFAULT here and let
the application call V4L2_MAP_.

I get the feeling this patch is a workaround for subdev errors. Either that,
or the commit log doesn't give me enough information to really understand the
problem that's being addressed here.

Regards,

	Hans

> +	}
> +
>  	*fmt = sdformat->format;
>  
>  	if (sdformat->pad == CSI_SINK_PAD) {
> 
