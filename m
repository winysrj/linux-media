Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51206 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbbJDQur (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2015 12:50:47 -0400
Date: Sun, 4 Oct 2015 18:50:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 4/5] media: atmel-isi: setup YCC_SWAP correctly when
 using preview path
In-Reply-To: <1442898875-7147-5-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1510041849370.26834@axis700.grange>
References: <1442898875-7147-1-git-send-email-josh.wu@atmel.com>
 <1442898875-7147-5-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 22 Sep 2015, Josh Wu wrote:

> The preview path only can convert UYVY format to RGB data.
> 
> To make preview path work correctly, we need to set up YCC_SWAP
> according to sensor output and convert them to UYVY.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index bbf6449..e87d354 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -127,6 +127,22 @@ static u32 setup_cfg2_yuv_swap(struct atmel_isi *isi,
>  			cfg2_yuv_swap = ISI_CFG2_YCC_SWAP_MODE_1;
>  			break;
>  		}
> +	} else if (xlate->host_fmt->fourcc == V4L2_PIX_FMT_RGB565) {
> +		/* Preview path is enabled, it will convert UYVY to RGB format.
> +		 * But if sensor output format is not UYVY, we need to set
> +		 * YCC_SWAP_MODE to convert it as UYVY.
> +		 */

Please, fix multiline comment style:

		/*
		 * ...
		 * ...
		 */

> +		switch (xlate->code) {
> +		case MEDIA_BUS_FMT_VYUY8_2X8:
> +			cfg2_yuv_swap = ISI_CFG2_YCC_SWAP_MODE_1;
> +			break;
> +		case MEDIA_BUS_FMT_YUYV8_2X8:
> +			cfg2_yuv_swap = ISI_CFG2_YCC_SWAP_MODE_2;
> +			break;
> +		case MEDIA_BUS_FMT_YVYU8_2X8:
> +			cfg2_yuv_swap = ISI_CFG2_YCC_SWAP_MODE_3;
> +			break;
> +		}
>  	}
>  
>  	return cfg2_yuv_swap;
> -- 
> 1.9.1
> 
