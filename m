Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:39342 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755012AbcJGTCh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 15:02:37 -0400
Subject: Re: [PATCH 18/22] [media] imx-ipuv3-csi: support downsizing
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
 <20161007160107.5074-19-p.zabel@pengutronix.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@pengutronix.de
From: Marek Vasut <marex@denx.de>
Message-ID: <51b1da71-720f-1c82-a42b-74be35992054@denx.de>
Date: Fri, 7 Oct 2016 21:01:30 +0200
MIME-Version: 1.0
In-Reply-To: <20161007160107.5074-19-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/2016 06:01 PM, Philipp Zabel wrote:
> Add support for the CSI internal horizontal and vertical downsizing.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/imx/imx-ipuv3-csi.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/imx/imx-ipuv3-csi.c b/drivers/media/platform/imx/imx-ipuv3-csi.c
> index 699460e6..e8a6a7b 100644
> --- a/drivers/media/platform/imx/imx-ipuv3-csi.c
> +++ b/drivers/media/platform/imx/imx-ipuv3-csi.c
> @@ -167,8 +167,16 @@ static int ipucsi_subdev_set_format(struct v4l2_subdev *sd,
>  		width = clamp_t(unsigned int, sdformat->format.width, 16, 8192);
>  		height = clamp_t(unsigned int, sdformat->format.height, 16, 4096);
>  	} else {
> -		width = ipucsi->format_mbus[0].width;
> -		height = ipucsi->format_mbus[0].height;
> +		if (sdformat->format.width <
> +		    (ipucsi->format_mbus[0].width * 3 / 4))
> +			width = ipucsi->format_mbus[0].width / 2;
> +		else
> +			width = ipucsi->format_mbus[0].width;
> +		if (sdformat->format.height <
> +		    (ipucsi->format_mbus[0].height * 3 / 4))
> +			height = ipucsi->format_mbus[0].height / 2;
> +		else
> +			height = ipucsi->format_mbus[0].height;
>  	}
>  
>  	mbusformat = __ipucsi_get_pad_format(sd, cfg, sdformat->pad,
> @@ -212,14 +220,14 @@ static int ipucsi_subdev_s_stream(struct v4l2_subdev *sd, int enable)
>  		window.width = fmt[0].width;
>  		window.height = fmt[0].height;
>  		ipu_csi_set_window(ipucsi->csi, &window);
> +		ipu_csi_set_downsize(ipucsi->csi,
> +				     fmt[0].width == 2 * fmt[1].width,
> +				     fmt[0].height == 2 * fmt[1].height);
>  
>  		/* Is CSI data source MCT (MIPI)? */
>  		mux_mct = (mbus_config.type == V4L2_MBUS_CSI2);
> -
>  		ipu_set_csi_src_mux(ipucsi->ipu, ipucsi->id, mux_mct);
> -		if (mux_mct)
> -			ipu_csi_set_mipi_datatype(ipucsi->csi, /*VC*/ 0,
> -						  &fmt[0]);
> +		ipu_csi_set_mipi_datatype(ipucsi->csi, /*VC*/ 0, &fmt[0]);

This probably needs fixing , so that the correct VC is passed in ?

>  		ret = ipu_csi_init_interface(ipucsi->csi, &mbus_config,
>  					     &fmt[0]);
> 


-- 
Best regards,
Marek Vasut
