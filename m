Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35839 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752643AbdHNXFk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 19:05:40 -0400
Subject: Re: [PATCH] [media] media: imx: use setup_timer
To: Cihangir Akturk <cakturk@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <1502649578-16754-1-git-send-email-cakturk@gmail.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <d44bd3a2-581b-c428-db02-1f5dd40f46d2@gmail.com>
Date: Mon, 14 Aug 2017 16:05:36 -0700
MIME-Version: 1.0
In-Reply-To: <1502649578-16754-1-git-send-email-cakturk@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks,

Reviewed-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Steve


On 08/13/2017 11:39 AM, Cihangir Akturk wrote:
> Use setup_timer function instead of initializing timer with the
> function and data fields.
>
> Generated by: scripts/coccinelle/api/setup_timer.cocci.
>
> Signed-off-by: Cihangir Akturk <cakturk@gmail.com>
> ---
>   drivers/staging/media/imx/imx-ic-prpencvf.c | 5 ++---
>   drivers/staging/media/imx/imx-media-csi.c   | 5 ++---
>   2 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
> index ed363fe..65f5729 100644
> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
> @@ -1278,9 +1278,8 @@ static int prp_init(struct imx_ic_priv *ic_priv)
>   	priv->ic_priv = ic_priv;
>   
>   	spin_lock_init(&priv->irqlock);
> -	init_timer(&priv->eof_timeout_timer);
> -	priv->eof_timeout_timer.data = (unsigned long)priv;
> -	priv->eof_timeout_timer.function = prp_eof_timeout;
> +	setup_timer(&priv->eof_timeout_timer, prp_eof_timeout,
> +		    (unsigned long)priv);
>   
>   	priv->vdev = imx_media_capture_device_init(&ic_priv->sd,
>   						   PRPENCVF_SRC_PAD);
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index a2d2669..8fef5f1 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -1731,9 +1731,8 @@ static int imx_csi_probe(struct platform_device *pdev)
>   	priv->csi_id = pdata->csi;
>   	priv->smfc_id = (priv->csi_id == 0) ? 0 : 2;
>   
> -	init_timer(&priv->eof_timeout_timer);
> -	priv->eof_timeout_timer.data = (unsigned long)priv;
> -	priv->eof_timeout_timer.function = csi_idmac_eof_timeout;
> +	setup_timer(&priv->eof_timeout_timer, csi_idmac_eof_timeout,
> +		    (unsigned long)priv);
>   	spin_lock_init(&priv->irqlock);
>   
>   	v4l2_subdev_init(&priv->sd, &csi_subdev_ops);
