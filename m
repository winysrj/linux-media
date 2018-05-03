Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58083 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751261AbeECQkw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 12:40:52 -0400
Message-ID: <1525365651.3408.3.camel@pengutronix.de>
Subject: Re: [PATCH] media: imx-csi: fix burst size for 16 bit
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jan Luebbe <jlu@pengutronix.de>, linux-media@vger.kernel.org
Cc: slongerbeam@gmail.com
Date: Thu, 03 May 2018 18:40:51 +0200
In-Reply-To: <20180503163200.12214-1-jlu@pengutronix.de>
References: <20180503163200.12214-1-jlu@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-05-03 at 18:32 +0200, Jan Luebbe wrote:
> A burst_size of 4 does not work for the 16 bit passthrough formats, so
> we use 8 instead.
> 
> Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 1112d8f67a18..08b636084286 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -410,7 +410,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>  	case V4L2_PIX_FMT_SGRBG16:
>  	case V4L2_PIX_FMT_SRGGB16:
>  	case V4L2_PIX_FMT_Y16:
> -		burst_size = 4;
> +		burst_size = 8;

This seems to be the equivalent to commit 37ea9830139b3 ("media: imx-
csi: fix burst size"), but for 16-bit formats.

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
