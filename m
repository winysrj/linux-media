Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:52613 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3EOWcm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 May 2013 18:32:42 -0400
Message-ID: <51940D04.7050001@gmail.com>
Date: Thu, 16 May 2013 00:32:36 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: George Joseph <george.jp@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	s.nawrocki@samsung.com, a.hajda@samsung.com, ym.song@samsung.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [RFC PATCH 2/3] [media] s5p-jpeg: Add DT support to JPEG driver
References: <1368532420-21555-1-git-send-email-george.jp@samsung.com> <1368532420-21555-3-git-send-email-george.jp@samsung.com>
In-Reply-To: <1368532420-21555-3-git-send-email-george.jp@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2013 01:53 PM, George Joseph wrote:
> From: George Joseph Palathingal<george.jp@samsung.com>
>
> Adding DT support to the driver. Driver supports Exynos 4210, 4412 and 5250.
>
> Signed-off-by: George Joseph Palathingal<george.jp@samsung.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.c |   36 +++++++++++++++++++++++++--
>   1 file changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index f964566..b2bf412 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -970,6 +970,8 @@ const struct jpeg_vb2 jpeg_vb2_dma = {
>   	.plane_addr	= vb2_dma_contig_plane_dma_addr,
>   };
>
> +static void *jpeg_get_drv_data(struct platform_device *pdev);

How about putting definition of the jpeg_get_drv_data() function and
the exynos_jpeg_match array above jpeg_probe() to avoid this forward
declaration ?

>   static int jpeg_probe(struct platform_device *pdev)
>   {
>   	struct jpeg_dev *dev;
> @@ -982,8 +984,7 @@ static int jpeg_probe(struct platform_device *pdev)
>   		return -ENOMEM;
>
>   	dev->plat_dev = pdev;
> -	dev->variant = (struct s5p_jpeg_variant *)
> -				platform_get_device_id(pdev)->driver_data;
> +	dev->variant = (struct s5p_jpeg_variant *)jpeg_get_drv_data(pdev);

Casting is not needed here.

>   	spin_lock_init(&dev->slock);
>
>   	/* setup jpeg control */
> @@ -1232,6 +1233,36 @@ static struct platform_device_id jpeg_driver_ids[] = {
>
>   MODULE_DEVICE_TABLE(platform, jpeg_driver_ids);
>
> +static const struct of_device_id exynos_jpeg_match[] = {
> +	{
> +		.compatible = "samsung,s5pv210-jpeg",
> +		.data =&jpeg_drvdata_v1,
> +	}, {
> +		.compatible = "samsung,exynos4212-jpeg",
> +		.data =&jpeg_drvdata_v2,
> +	},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, exynos_jpeg_match);
> +
> +static void *jpeg_get_drv_data(struct platform_device *pdev)
> +{
> +	struct s5p_jpeg_variant *driver_data = NULL;

Unnecessary NULL assignment.

> +	if (pdev->dev.of_node) {
> +		const struct of_device_id *match;
> +		match = of_match_node(of_match_ptr(exynos_jpeg_match),
> +					 pdev->dev.of_node);
> +		if (match)
> +			driver_data = (struct s5p_jpeg_variant *)match->data;
> +		} else {

Indentation is wrong here.

> +			driver_data = (struct s5p_jpeg_variant *)
> +				platform_get_device_id(pdev)->driver_data;
> +		}
> +	return driver_data;
> +}

How about rewriting this function to something like:

static const void *jpeg_get_drv_data(struct platform_device *pdev)
{
	struct device_node *node = pdev->dev.of_node;
	const struct of_device_id *match;

	if (node) {
		match = of_match_node(exynos_jpeg_match, node);
		return match ? match->data : NULL;
	}

	return (void *)platform_get_device_id(pdev)->driver_data;
}

?
>   static struct platform_driver jpeg_driver = {
>   	.probe		= jpeg_probe,
>   	.remove		= jpeg_remove,
> @@ -1241,6 +1272,7 @@ static struct platform_driver jpeg_driver = {
>   	.driver	= {
>   		.owner			= THIS_MODULE,
>   		.name			= JPEG_NAME,
> +		.of_match_table		= exynos_jpeg_match,
>   		.pm			= NULL,
>   	},
>   };

Thanks,
Sylwester
