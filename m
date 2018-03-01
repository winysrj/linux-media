Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45571 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964841AbeCAIff (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 03:35:35 -0500
Message-ID: <1519893326.3034.1.camel@pengutronix.de>
Subject: Re: [PATCH] staging/imx: Fix inconsistent IS_ERR and PTR_ERR
From: Philipp Zabel <p.zabel@pengutronix.de>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Date: Thu, 01 Mar 2018 09:35:26 +0100
In-Reply-To: <20180301040939.GA13274@embeddedgus>
References: <20180301040939.GA13274@embeddedgus>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-02-28 at 22:09 -0600, Gustavo A. R. Silva wrote:
> Fix inconsistent IS_ERR and PTR_ERR in imx_csi_probe.
> The proper pointer to be passed as argument is pinctrl
> instead of priv->vdev.
> 
> This issue was detected with the help of Coccinelle.
> 
> Fixes: 52e17089d185 ("media: imx: Don't initialize vars that won't be used")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 5a195f8..4f290a0 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -1798,7 +1798,7 @@ static int imx_csi_probe(struct platform_device *pdev)
>  	priv->dev->of_node = pdata->of_node;
>  	pinctrl = devm_pinctrl_get_select_default(priv->dev);
>  	if (IS_ERR(pinctrl)) {
> -		ret = PTR_ERR(priv->vdev);
> +		ret = PTR_ERR(pinctrl);
>  		goto free;
>  	}

Thanks,
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
