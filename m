Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:42106 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754710AbeDWLz3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 07:55:29 -0400
Received: by mail-ot0-f195.google.com with SMTP id q10-v6so12128545oth.9
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 04:55:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1523899736-31360-1-git-send-email-festevam@gmail.com>
References: <1523899736-31360-1-git-send-email-festevam@gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 23 Apr 2018 08:55:28 -0300
Message-ID: <CAOMZO5AfQY+W-64uL-pn=9BwDZLZaO=3T6F-_=zHGYvZGUd-cg@mail.gmail.com>
Subject: Re: [PATCH v2] media: imx-media-csi: Fix inconsistent IS_ERR and PTR_ERR
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Unfortunately this one missed to be applied into 4.17-rc and now the
imx-media-csi driver does not probe.

Please consider applying it for 4.17-rc3 to avoid the regression.

Thanks

On Mon, Apr 16, 2018 at 2:28 PM, Fabio Estevam <festevam@gmail.com> wrote:
> From: From: Gustavo A. R. Silva <gustavo@embeddedor.com>
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
> Changes since v1:
> - Rebased against 4.17-rc1
>
>  drivers/staging/media/imx/imx-media-csi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 16cab40..aeab05f 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -1799,7 +1799,7 @@ static int imx_csi_probe(struct platform_device *pdev)
>         priv->dev->of_node = pdata->of_node;
>         pinctrl = devm_pinctrl_get_select_default(priv->dev);
>         if (IS_ERR(pinctrl)) {
> -               ret = PTR_ERR(priv->vdev);
> +               ret = PTR_ERR(pinctrl);
>                 dev_dbg(priv->dev,
>                         "devm_pinctrl_get_select_default() failed: %d\n", ret);
>                 if (ret != -ENODEV)
> --
> 2.7.4
>
