Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:52067 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932188AbcGLL0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 07:26:03 -0400
Message-ID: <1468322758.2462.9.camel@mtksdaap41>
Subject: Re: [PATCH -next] [media] mtk-vcodec: remove redundant dev_err call
 in mtk_vcodec_probe()
From: tiffany lin <tiffany.lin@mediatek.com>
To: <weiyj_lk@163.com>
CC: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Wei Yongjun" <yongjun_wei@trendmicro.com.cn>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>
Date: Tue, 12 Jul 2016 19:25:58 +0800
In-Reply-To: <1468321379-16133-1-git-send-email-weiyj_lk@163.com>
References: <1468321379-16133-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Tiffany Lin <tiffany.lin@mediatek.com>

On Tue, 2016-07-12 at 11:02 +0000, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> index 9c10cc2..b33a931 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> @@ -279,8 +279,6 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
>  		}
>  		dev->reg_base[i] = devm_ioremap_resource(&pdev->dev, res);
>  		if (IS_ERR((__force void *)dev->reg_base[i])) {
> -			dev_err(&pdev->dev,
> -				"devm_ioremap_resource %d failed.", i);
>  			ret = PTR_ERR((__force void *)dev->reg_base[i]);
>  			goto err_res;
>  		}
> 
> 


