Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:45015 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbeEETmn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 15:42:43 -0400
Received: by mail-pg0-f68.google.com with SMTP id 82-v6so17585272pge.11
        for <linux-media@vger.kernel.org>; Sat, 05 May 2018 12:42:43 -0700 (PDT)
Subject: Re: [PATCH] media: imx: add 16-bit grayscale support
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Jan Luebbe <jlu@pengutronix.de>
References: <20180503150606.13216-1-p.zabel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <7ec1d870-7bd1-1aa8-b6d0-3f8812da8bf1@gmail.com>
Date: Sat, 5 May 2018 12:42:40 -0700
MIME-Version: 1.0
In-Reply-To: <20180503150606.13216-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>


On 05/03/2018 08:06 AM, Philipp Zabel wrote:
> Since commit 50b0f0aee839 ("gpu: ipu-csi: add 10/12-bit grayscale
> support to mbus_code_to_bus_cfg") the IPU CSI can be configured to
> capture 10-bit and 12-bit grayscale formats, expanded to 16-bit
> grayscale, in bayer/generic data mode.
> This patch adds support for V4L2_PIX_FMT_Y16 captured from sensors
> that provide MEDIA_BUS_FMT_Y10_1X10 or MEDIA_BUS_FMT_Y12_1X12 data.
>
> Cc: Jan Luebbe <jlu@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>   drivers/staging/media/imx/imx-media-csi.c   | 1 +
>   drivers/staging/media/imx/imx-media-utils.c | 9 +++++++++
>   2 files changed, 10 insertions(+)
>
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 16cab40156ca..1112d8f67a18 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -409,6 +409,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>   	case V4L2_PIX_FMT_SGBRG16:
>   	case V4L2_PIX_FMT_SGRBG16:
>   	case V4L2_PIX_FMT_SRGGB16:
> +	case V4L2_PIX_FMT_Y16:
>   		burst_size = 4;
>   		passthrough = true;
>   		passthrough_bits = 16;
> diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
> index fab98fc0d6a0..7ec2db84451c 100644
> --- a/drivers/staging/media/imx/imx-media-utils.c
> +++ b/drivers/staging/media/imx/imx-media-utils.c
> @@ -168,6 +168,15 @@ static const struct imx_media_pixfmt rgb_formats[] = {
>   		.cs     = IPUV3_COLORSPACE_RGB,
>   		.bpp    = 8,
>   		.bayer  = true,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_Y16,
> +		.codes = {
> +			MEDIA_BUS_FMT_Y10_1X10,
> +			MEDIA_BUS_FMT_Y12_1X12,
> +		},
> +		.cs     = IPUV3_COLORSPACE_RGB,
> +		.bpp    = 16,
> +		.bayer  = true,
>   	},
>   	/***
>   	 * non-mbus RGB formats start here. NOTE! when adding non-mbus
