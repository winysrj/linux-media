Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:36703 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753970AbdBPL3t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 06:29:49 -0500
Message-ID: <1487244551.2377.35.camel@pengutronix.de>
Subject: Re: [PATCH v4 30/36] media: imx: update capture dev format on IDMAC
 output pad set_fmt
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
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 16 Feb 2017 12:29:11 +0100
In-Reply-To: <1487211578-11360-31-git-send-email-steve_longerbeam@mentor.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
         <1487211578-11360-31-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-02-15 at 18:19 -0800, Steve Longerbeam wrote:
> When configuring the IDMAC output pad formats (in ipu_csi,
> ipu_ic_prpenc, and ipu_ic_prpvf subdevs), the attached capture
> device format must also be updated.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/staging/media/imx/imx-ic-prpencvf.c | 9 +++++++++
>  drivers/staging/media/imx/imx-media-csi.c   | 9 +++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
> index 2be8845..6e45975 100644
> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
> @@ -739,6 +739,7 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
>  		       struct v4l2_subdev_format *sdformat)
>  {
>  	struct prp_priv *priv = sd_to_priv(sd);
> +	struct imx_media_video_dev *vdev = priv->vdev;
>  	const struct imx_media_pixfmt *cc;
>  	struct v4l2_mbus_framefmt *infmt;
>  	u32 code;
> @@ -800,6 +801,14 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
>  	} else {
>  		priv->format_mbus[sdformat->pad] = sdformat->format;
>  		priv->cc[sdformat->pad] = cc;
> +		if (sdformat->pad == PRPENCVF_SRC_PAD) {
> +			/*
> +			 * update the capture device format if this is
> +			 * the IDMAC output pad
> +			 */
> +			imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix,
> +						      &sdformat->format, cc);
> +		}

This is replaced again by patch 36. These should probably be squashed
together.

regards
Philipp
