Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33152 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751691AbeCWRTH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 13:19:07 -0400
Subject: Re: [PATCH] [media] vcodec: fix error return value from
 mtk_jpeg_clk_init()
To: Ryder Lee <ryder.lee@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Bin Liu <bin.liu@mediatek.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <f9295ecafa4c845ef5d9414fca47b2dc0fc6640d.1521776018.git.ryder.lee@mediatek.com>
From: Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <6431ba94-5e7d-0df5-40bb-04f9af203586@gmail.com>
Date: Fri, 23 Mar 2018 18:19:03 +0100
MIME-Version: 1.0
In-Reply-To: <f9295ecafa4c845ef5d9414fca47b2dc0fc6640d.1521776018.git.ryder.lee@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/23/2018 04:44 AM, Ryder Lee wrote:
> The error return value should be fixed as it may return EPROBE_DEFER.
> 
> Cc: Rick Chang <rick.chang@mediatek.com>
> Cc: Bin Liu <bin.liu@mediatek.com>
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>

Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>

> ---
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
> index 226f908..af17aaa 100644
> --- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
> +++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
> @@ -1081,11 +1081,11 @@ static int mtk_jpeg_clk_init(struct mtk_jpeg_dev *jpeg)
>  
>  	jpeg->clk_jdec = devm_clk_get(jpeg->dev, "jpgdec");
>  	if (IS_ERR(jpeg->clk_jdec))
> -		return -EINVAL;
> +		return PTR_ERR(jpeg->clk_jdec);
>  
>  	jpeg->clk_jdec_smi = devm_clk_get(jpeg->dev, "jpgdec-smi");
>  	if (IS_ERR(jpeg->clk_jdec_smi))
> -		return -EINVAL;
> +		return PTR_ERR(jpeg->clk_jdec_smi);
>  
>  	return 0;
>  }
> 
