Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42252 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3HWQBj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 12:01:39 -0400
Message-id: <5217875F.2030307@samsung.com>
Date: Fri, 23 Aug 2013 18:01:35 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Mark Rutland <Mark.Rutland@arm.com>,
	Kumar Gala <galak@codeaurora.org>,
	Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] s5p-jpeg: Add initial device tree support for
 S5PV210/Exynos4210 SoCs
References: <1376856867-17771-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1376856867-17771-1-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/18/2013 10:14 PM, Sylwester Nawrocki wrote:
> This patch enables the JPEG codec on S5PV210 and Exynos4210 SoCs. There are
> some differences in newer versions of the JPEG codec IP on SoCs like Exynos4x12
> and Exynos5 series and support for them will be added in subsequent patches.
> 
> Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Could a DT maintainer review/Ack the binding in this patch ?

> ---
>  .../bindings/media/exynos-jpeg-codec.txt           |   11 +++++++++++
>  drivers/media/platform/s5p-jpeg/jpeg-core.c        |   12 +++++++++++-
>  2 files changed, 22 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
> new file mode 100644
> index 0000000..937b755
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt
> @@ -0,0 +1,11 @@
> +Samsung S5P/EXYNOS SoC series JPEG codec
> +
> +Required properties:
> +
> +- compatible	: should be one of:
> +		  "samsung,s5pv210-jpeg", "samsung,exynos4210-jpeg";
> +- reg		: address and length of the JPEG codec IP register set;
> +- interrupts	: specifies the JPEG codec IP interrupt;
> +- clocks	: should contain the JPEG codec IP gate clock specifier, from the
> +		  common clock bindings;
> +- clock-names	: should contain "jpeg" entry.
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 15d2396..88c5beb 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -17,6 +17,7 @@
>  #include <linux/io.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
> @@ -1513,10 +1514,20 @@ static const struct dev_pm_ops s5p_jpeg_pm_ops = {
>  	.runtime_resume	 = s5p_jpeg_runtime_resume,
>  };
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id s5p_jpeg_of_match[] = {
> +	{ .compatible = "samsung,s5pv210-jpeg" },
> +	{ .compatible = "samsung,exynos4210-jpeg" },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, s5p_jpeg_of_match);
> +#endif
> +
>  static struct platform_driver s5p_jpeg_driver = {
>  	.probe = s5p_jpeg_probe,
>  	.remove = s5p_jpeg_remove,
>  	.driver = {
> +		.of_match_table = of_match_ptr(s5p_jpeg_of_match),
>  		.owner = THIS_MODULE,
>  		.name = S5P_JPEG_M2M_NAME,
>  		.pm = &s5p_jpeg_pm_ops,
> @@ -1528,4 +1539,3 @@ module_platform_driver(s5p_jpeg_driver);
>  MODULE_AUTHOR("Andrzej Pietrasiewicz <andrzej.p@samsung.com>");
>  MODULE_DESCRIPTION("Samsung JPEG codec driver");
>  MODULE_LICENSE("GPL");
