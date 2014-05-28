Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10788 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaE1Jqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 05:46:46 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6A00JBI35QCI00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 May 2014 10:46:38 +0100 (BST)
Message-id: <5385B07E.5090709@samsung.com>
Date: Wed, 28 May 2014 11:46:38 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] media: mx2-emmaprp: Add devicetree support
References: <1401176878-7318-1-git-send-email-shc_work@mail.ru>
In-reply-to: <1401176878-7318-1-git-send-email-shc_work@mail.ru>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/05/14 09:47, Alexander Shiyan wrote:
> This patch adds devicetree support for the Freescale enhanced Multimedia
> Accelerator (eMMA) video Pre-processor (PrP).
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/media/platform/mx2_emmaprp.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
> index fa8f7ca..0646bda 100644
> --- a/drivers/media/platform/mx2_emmaprp.c
> +++ b/drivers/media/platform/mx2_emmaprp.c
> @@ -18,6 +18,7 @@
>   */
>  #include <linux/module.h>
>  #include <linux/clk.h>
> +#include <linux/of.h>
>  #include <linux/slab.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> @@ -1005,12 +1006,19 @@ static int emmaprp_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static const struct of_device_id __maybe_unused emmaprp_dt_ids[] = {
> +	{ .compatible = "fsl,imx21-emmaprp", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, emmaprp_dt_ids);
> +
>  static struct platform_driver emmaprp_pdrv = {
>  	.probe		= emmaprp_probe,
>  	.remove		= emmaprp_remove,
>  	.driver		= {
>  		.name	= MEM2MEM_NAME,
>  		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(emmaprp_dt_ids),
>  	},
>  };
>  module_platform_driver(emmaprp_pdrv);


The patch looks good, but the DT binding documentation patch should
normally precede the related driver patch in the series. That way we
could avoid checkpatch warnings like:

WARNING: DT compatible string "fsl,imx21-emmaprp" appears un-documented -- check ./Documentation/devicetree/bindings/
#76: FILE: drivers/media/platform/mx2_emmaprp.c:1010:
+	{ .compatible = "fsl,imx21-emmaprp", },

Wouldn't it make sense to also ad second entry with "fsl,imx27-emmaprp"
compatible ?


Could you also fix the remaining checkpatch warnings:


WARNING: Use a single space after To:
#35: 
To:	linux-media@vger.kernel.org

WARNING: Use a single space after Cc:
#36: 
Cc:	Mauro Carvalho Chehab <m.chehab@samsung.com>,

ERROR: DOS line endings
#67: FILE: drivers/media/platform/mx2_emmaprp.c:21:
+#include <linux/of.h>^M$

ERROR: DOS line endings
#75: FILE: drivers/media/platform/mx2_emmaprp.c:1009:
+static const struct of_device_id __maybe_unused emmaprp_dt_ids[] = {^M$

ERROR: DOS line endings
#76: FILE: drivers/media/platform/mx2_emmaprp.c:1010:
+^I{ .compatible = "fsl,imx21-emmaprp", },^M$

WARNING: DT compatible string "fsl,imx21-emmaprp" appears un-documented -- check ./Documentation/devicetree/bindings/
#76: FILE: drivers/media/platform/mx2_emmaprp.c:1010:
+	{ .compatible = "fsl,imx21-emmaprp", },

ERROR: DOS line endings
#77: FILE: drivers/media/platform/mx2_emmaprp.c:1011:
+^I{ }^M$

ERROR: DOS line endings
#78: FILE: drivers/media/platform/mx2_emmaprp.c:1012:
+};^M$

ERROR: DOS line endings
#79: FILE: drivers/media/platform/mx2_emmaprp.c:1013:
+MODULE_DEVICE_TABLE(of, emmaprp_dt_ids);^M$

ERROR: DOS line endings
#80: FILE: drivers/media/platform/mx2_emmaprp.c:1014:
+^M$

ERROR: DOS line endings
#87: FILE: drivers/media/platform/mx2_emmaprp.c:1021:
+^I^I.of_match_table = of_match_ptr(emmaprp_dt_ids),^M$

total: 8 errors, 3 warnings, 26 lines checked

[PATCH 1_2] media: mx2-emmaprp: Add devicetree support.eml has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

With these fixed feel free to add:

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Thanks,
Sylwester
