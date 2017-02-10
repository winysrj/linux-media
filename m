Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:39119 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751326AbdBJDf0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2017 22:35:26 -0500
Message-ID: <1486697713.3862.6.camel@mtksdaap41>
Subject: Re: [PATCH -next] [media] mtk-vcodec: remove redundant return value
 check of platform_get_resource()
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Wei Yongjun" <weiyongjun1@huawei.com>,
        <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Date: Fri, 10 Feb 2017 11:35:13 +0800
In-Reply-To: <20170207151620.12711-1-weiyj.lk@gmail.com>
References: <20170207151620.12711-1-weiyj.lk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-02-07 at 15:16 +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Remove unneeded error handling on the result of a call
> to platform_get_resource() when the value is passed to
> devm_ioremap_resource().
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by:Tiffany Lin <tiffany.lin@mediatek.com>

> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> index aa81f3c..83f859e 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> @@ -269,11 +269,6 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
>  
>  	for (i = VENC_SYS, j = 0; i < NUM_MAX_VCODEC_REG_BASE; i++, j++) {
>  		res = platform_get_resource(pdev, IORESOURCE_MEM, j);
> -		if (res == NULL) {
> -			dev_err(&pdev->dev, "get memory resource failed.");
> -			ret = -ENXIO;
> -			goto err_res;
> -		}
>  		dev->reg_base[i] = devm_ioremap_resource(&pdev->dev, res);
>  		if (IS_ERR((__force void *)dev->reg_base[i])) {
>  			ret = PTR_ERR((__force void *)dev->reg_base[i]);
> 
> 
> 


