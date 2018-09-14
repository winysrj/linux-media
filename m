Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33422 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbeIODMq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 23:12:46 -0400
Subject: Re: [PATCH] media: imx-pxp: fix compilation on i386 or x86_64
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@pengutronix.de
References: <20180914071056.28752-1-p.zabel@pengutronix.de>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0245b7b8-8826-27ab-cc36-8bf5f9107a7b@infradead.org>
Date: Fri, 14 Sep 2018 14:56:18 -0700
MIME-Version: 1.0
In-Reply-To: <20180914071056.28752-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/14/18 12:10 AM, Philipp Zabel wrote:
> Include the missing interrupt.h header to fix compilation on i386 or
> x86_64:
> 
>  ../drivers/media/platform/imx-pxp.c:988:1: error: unknown type name 'irqreturn_t'
>   static irqreturn_t pxp_irq_handler(int irq, void *dev_id)
>   ^
>  ../drivers/media/platform/imx-pxp.c: In function 'pxp_irq_handler':
>  ../drivers/media/platform/imx-pxp.c:1012:9: error: 'IRQ_HANDLED' undeclared (first use in this function)
>    return IRQ_HANDLED;
>           ^
>  ../drivers/media/platform/imx-pxp.c:1012:9: note: each undeclared identifier is reported only once for each function it appears in
>  ../drivers/media/platform/imx-pxp.c: In function 'pxp_probe':
>  ../drivers/media/platform/imx-pxp.c:1660:2: error: implicit declaration of function 'devm_request_threaded_irq' [-Werror=implicit-function-declaration]
>    ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, pxp_irq_handler,
>    ^
>  ../drivers/media/platform/imx-pxp.c:1661:4: error: 'IRQF_ONESHOT' undeclared (first use in this function)
>      IRQF_ONESHOT, dev_name(&pdev->dev), dev);
> 
> Fixes: 51abcf7fdb70 ("media: imx-pxp: add i.MX Pixel Pipeline driver")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Thanks.  You can choose/add:
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Build-tested-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/media/platform/imx-pxp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
> index 68ecfed7098b..229c23ae4029 100644
> --- a/drivers/media/platform/imx-pxp.c
> +++ b/drivers/media/platform/imx-pxp.c
> @@ -13,6 +13,7 @@
>  #include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/iopoll.h>
>  #include <linux/module.h>
> 


-- 
~Randy
