Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:15923 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751970AbeDQD6q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 23:58:46 -0400
Message-ID: <1523937520.12959.2.camel@mtkswgap22>
Subject: Re: [PATCH] media: rc: mtk-cir: use of_device_get_match_data()
From: Sean Wang <sean.wang@mediatek.com>
To: Ryder Lee <ryder.lee@mediatek.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Date: Tue, 17 Apr 2018 11:58:40 +0800
In-Reply-To: <39601fe0c5daf9bcdbb3e44390b671a12d508e00.1523347340.git.ryder.lee@mediatek.com>
References: <31f944ab8dfcc1d7b6f03b35657a2a34825b5246.1523347340.git.ryder.lee@mediatek.com>
         <39601fe0c5daf9bcdbb3e44390b671a12d508e00.1523347340.git.ryder.lee@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-04-16 at 10:34 +0800, Ryder Lee wrote:
> The usage of of_device_get_match_data() reduce the code size a bit.
> 
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> ---
>  drivers/media/rc/mtk-cir.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/media/rc/mtk-cir.c b/drivers/media/rc/mtk-cir.c
> index e88eb64..e42efd9 100644
> --- a/drivers/media/rc/mtk-cir.c
> +++ b/drivers/media/rc/mtk-cir.c
> @@ -299,8 +299,6 @@ static int mtk_ir_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
>  	struct device_node *dn = dev->of_node;
> -	const struct of_device_id *of_id =
> -		of_match_device(mtk_ir_match, &pdev->dev);
>  	struct resource *res;
>  	struct mtk_ir *ir;
>  	u32 val;
> @@ -312,7 +310,7 @@ static int mtk_ir_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	ir->dev = dev;
> -	ir->data = of_id->data;
> +	ir->data = of_device_get_match_data(dev);
>  
>  	ir->clk = devm_clk_get(dev, "clk");
>  	if (IS_ERR(ir->clk)) {


Acked-by: Sean Wang <sean.wang@mediatek.com>
