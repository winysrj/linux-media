Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:8199 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750789AbeCXCHb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 22:07:31 -0400
Message-ID: <1521857244.3372.12.camel@mediatek.com>
Subject: Re: [PATCH] [media] vcodec: fix error return value from
 mtk_jpeg_clk_init()
From: Rick Chang <rick.chang@mediatek.com>
To: Ryder Lee <ryder.lee@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
CC: <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Bin Liu <bin.liu@mediatek.com>
Date: Fri, 23 Mar 2018 19:07:24 -0700
In-Reply-To: <f9295ecafa4c845ef5d9414fca47b2dc0fc6640d.1521776018.git.ryder.lee@mediatek.com>
References: <f9295ecafa4c845ef5d9414fca47b2dc0fc6640d.1521776018.git.ryder.lee@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-03-23 at 11:44 +0800, Ryder Lee wrote:
> The error return value should be fixed as it may return EPROBE_DEFER.
> 
> Cc: Rick Chang <rick.chang@mediatek.com>
> Cc: Bin Liu <bin.liu@mediatek.com>
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> ---
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
> b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
> index 226f908..af17aaa 100644
> --- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
> +++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
> @@ -1081,11 +1081,11 @@ static int mtk_jpeg_clk_init(struct
> mtk_jpeg_dev *jpeg)
>  
>  	jpeg->clk_jdec = devm_clk_get(jpeg->dev, "jpgdec");
>  	if (IS_ERR(jpeg->clk_jdec))
> -		return -EINVAL;
> +		return PTR_ERR(jpeg->clk_jdec);
>  
>  	jpeg->clk_jdec_smi = devm_clk_get(jpeg->dev, "jpgdec-smi");
>  	if (IS_ERR(jpeg->clk_jdec_smi))
> -		return -EINVAL;
> +		return PTR_ERR(jpeg->clk_jdec_smi);
>  
>  	return 0;
>  }

Acked-by: Rick Chang <rick.chang@mediatek.com>
