Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52598 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbeI1TQU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 15:16:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: hyun.kwon@xilinx.com, mchehab@kernel.org, michal.simek@xilinx.com,
        linux-media@vger.kernel.org, Mirco Di Salvo <mirco.disalvo@iit.it>
Subject: Re: [PATCH] [media] v4l: xilinx: fix typo in formats table
Date: Fri, 28 Sep 2018 15:52:55 +0300
Message-ID: <1859576.n3v8JWS4oW@avalon>
In-Reply-To: <20180928073213.10022-1-andrea.merello@gmail.com>
References: <20180928073213.10022-1-andrea.merello@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrea,

Thank you for the patch.

On Friday, 28 September 2018 10:32:13 EEST Andrea Merello wrote:
> In formats table the entry for CFA pattern "rggb" has GRBG fourcc.
> This patch fixes it.
> 
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Mirco Di Salvo <mirco.disalvo@iit.it>
> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Michal, should I take the patch in my tree ?

> ---
>  drivers/media/platform/xilinx/xilinx-vip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-vip.c
> b/drivers/media/platform/xilinx/xilinx-vip.c index
> 311259129504..e9567cdfb89b 100644
> --- a/drivers/media/platform/xilinx/xilinx-vip.c
> +++ b/drivers/media/platform/xilinx/xilinx-vip.c
> @@ -36,7 +36,7 @@ static const struct xvip_video_format xvip_video_formats[]
> = { { XVIP_VF_MONO_SENSOR, 8, "mono", MEDIA_BUS_FMT_Y8_1X8,
>  	  1, V4L2_PIX_FMT_GREY, "Greyscale 8-bit" },
>  	{ XVIP_VF_MONO_SENSOR, 8, "rggb", MEDIA_BUS_FMT_SRGGB8_1X8,
> -	  1, V4L2_PIX_FMT_SGRBG8, "Bayer 8-bit RGGB" },
> +	  1, V4L2_PIX_FMT_SRGGB8, "Bayer 8-bit RGGB" },
>  	{ XVIP_VF_MONO_SENSOR, 8, "grbg", MEDIA_BUS_FMT_SGRBG8_1X8,
>  	  1, V4L2_PIX_FMT_SGRBG8, "Bayer 8-bit GRBG" },
>  	{ XVIP_VF_MONO_SENSOR, 8, "gbrg", MEDIA_BUS_FMT_SGBRG8_1X8,

-- 
Regards,

Laurent Pinchart
