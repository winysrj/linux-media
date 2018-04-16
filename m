Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43469 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754945AbeDPNRA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 09:17:00 -0400
Message-ID: <1523884614.5918.12.camel@pengutronix.de>
Subject: Re: [PATCH v3 1/2] media: imx-media-csi: Fix inconsistent IS_ERR
 and PTR_ERR
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>, mchehab@kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: slongerbeam@gmail.com, gustavo@embeddedor.com,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Date: Mon, 16 Apr 2018 15:16:54 +0200
In-Reply-To: <1520081790-3437-1-git-send-email-festevam@gmail.com>
References: <1520081790-3437-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sat, 2018-03-03 at 09:56 -0300, Fabio Estevam wrote:
> From: Gustavo A. R. Silva <gustavo@embeddedor.com>
> 
> Fix inconsistent IS_ERR and PTR_ERR in imx_csi_probe.
> The proper pointer to be passed as argument is pinctrl
> instead of priv->vdev.
> 
> This issue was detected with the help of Coccinelle.
> 
> Fixes: 52e17089d185 ("media: imx: Don't initialize vars that won't be used")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v2:
> - None
> Changes since v1:
> - None
> 
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

The second patch is applied now, but this part is still missing in
v4.17-rc1, causing the CSI subdev probe to fail:

  imx-ipuv3-csi: probe of imx-ipuv3-csi.0 failed with error -1369528304
  imx-ipuv3-csi: probe of imx-ipuv3-csi.1 failed with error -1369528304
  imx-ipuv3-csi: probe of imx-ipuv3-csi.5 failed with error -1369528304
  imx-ipuv3-csi: probe of imx-ipuv3-csi.6 failed with error -1369528304

regards
Philipp
