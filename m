Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:32975 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbeIZTux (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 15:50:53 -0400
Date: Wed, 26 Sep 2018 15:37:38 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: imx-pxp: include linux/interrupt.h
Message-ID: <20180926133738.GA19690@pengutronix.de>
References: <20180926130139.2320343-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180926130139.2320343-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Wed, Sep 26, 2018 at 03:01:26PM +0200, Arnd Bergmann wrote:
> The newly added driver fails to build in some configurations due to a
> missing header inclusion:

Thank you, did you see this error on an older kernel version and rebase
the patch afterwards?

> drivers/media/platform/imx-pxp.c:988:8: error: unknown type name 'irqreturn_t'
>  static irqreturn_t pxp_irq_handler(int irq, void *dev_id)
>         ^~~~~~~~~~~
> drivers/media/platform/imx-pxp.c: In function 'pxp_irq_handler':
> drivers/media/platform/imx-pxp.c:1012:9: error: 'IRQ_HANDLED' undeclared (first use in this function); did you mean 'IRQ_MODE'?
>   return IRQ_HANDLED;
>          ^~~~~~~~~~~
>          IRQ_MODE
> drivers/media/platform/imx-pxp.c:1012:9: note: each undeclared identifier is reported only once for each function it appears in
> drivers/media/platform/imx-pxp.c: In function 'pxp_probe':
> drivers/media/platform/imx-pxp.c:1660:8: error: implicit declaration of function 'devm_request_threaded_irq'; did you mean 'devm_request_region'? [-Werror=implicit-function-declaration]
>   ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, pxp_irq_handler,
>         ^~~~~~~~~~~~~~~~~~~~~~~~~
>         devm_request_region
> drivers/media/platform/imx-pxp.c:1661:4: error: 'IRQF_ONESHOT' undeclared (first use in this function); did you mean 'SA_ONESHOT'?
>     IRQF_ONESHOT, dev_name(&pdev->dev), dev);
>
> Fixes: 51abcf7fdb70 ("media: imx-pxp: add i.MX Pixel Pipeline driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/platform/imx-pxp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
> index 229c23ae4029..b76cd0e8313c 100644
> --- a/drivers/media/platform/imx-pxp.c
> +++ b/drivers/media/platform/imx-pxp.c
> @@ -16,6 +16,7 @@
>  #include <linux/interrupt.h>

This line was recently added in commit b4fbf423cef9 ("media: imx-pxp:
fix compilation on i386 or x86_64")

>  #include <linux/io.h>
>  #include <linux/iopoll.h>
> +#include <linux/interrupt.h>

So this should not be necessary anymore.

>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/sched.h>
> -- 
> 2.18.0
> 
> 

regards
Philipp
