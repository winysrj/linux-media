Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:43205 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab3CJUgv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 16:36:51 -0400
Message-ID: <513CEEDF.4010304@gmail.com>
Date: Sun, 10 Mar 2013 21:36:47 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, s.nawrocki@samsung.com,
	shaik.samsung@gmail.com
Subject: Re: [RFC 02/12] fimc-lite: Adding Exynos5 compatibility to fimc-lite
 driver
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com> <1362570838-4737-3-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-3-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/06/2013 12:53 PM, Shaik Ameer Basha wrote:
> This patch adds the Exynos5 soc compatibility to the fimc-lite driver.
> It also adds a version checking to deal with the changes between
> different fimc-lite hardware versions.

Is there really anything different between the Exynos4 and Exynos5
FIMC-LITE IPs except the maximum number of buffer descriptors in
the output DMA queue ?

> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
> ---
>   drivers/media/platform/s5p-fimc/fimc-lite.c |   23 +++++++++++++++++++++++
>   drivers/media/platform/s5p-fimc/fimc-lite.h |    7 ++++++-
>   2 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
> index 122cf95..eb64f87 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-lite.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
> @@ -1653,6 +1653,16 @@ static struct flite_variant fimc_lite0_variant_exynos4 = {
>   	.out_width_align	= 8,
>   	.win_hor_offs_align	= 2,
>   	.out_hor_offs_align	= 8,
> +	.version		= FLITE_VER_EXYNOS4,
> +};
> +
> +static struct flite_variant fimc_lite0_variant_exynos5 = {
> +	.max_width		= 8192,
> +	.max_height		= 8192,
> +	.out_width_align	= 8,
> +	.win_hor_offs_align	= 2,
> +	.out_hor_offs_align	= 8,

Please see my comment to patch 03/12.

> +	.version		= FLITE_VER_EXYNOS5,
>   };
>
>   /* EXYNOS4212, EXYNOS4412 */
> @@ -1663,6 +1673,15 @@ static struct flite_drvdata fimc_lite_drvdata_exynos4 = {
>   	},
>   };
>
> +/* EXYNOS5250 */
> +static struct flite_drvdata fimc_lite_drvdata_exynos5 = {
> +	.variant = {
> +		[0] =&fimc_lite0_variant_exynos5,
> +		[1] =&fimc_lite0_variant_exynos5,
> +		[2] =&fimc_lite0_variant_exynos5,
> +	},
> +};
> +
>   static struct platform_device_id fimc_lite_driver_ids[] = {
>   	{
>   		.name		= "exynos-fimc-lite",
> @@ -1677,6 +1696,10 @@ static const struct of_device_id flite_of_match[] = {
>   		.compatible = "samsung,exynos4212-fimc-lite",
>   		.data =&fimc_lite_drvdata_exynos4,
>   	},
> +	{
> +		.compatible = "samsung,exynos5250-fimc-lite",
> +		.data =&fimc_lite_drvdata_exynos5,
> +	},
>   	{ /* sentinel */ },
>   };
>   MODULE_DEVICE_TABLE(of, flite_of_match);
> diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.h b/drivers/media/platform/s5p-fimc/fimc-lite.h
> index 66d6eeb..ef43fe0 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-lite.h
> +++ b/drivers/media/platform/s5p-fimc/fimc-lite.h
> @@ -28,7 +28,7 @@
>
>   #define FIMC_LITE_DRV_NAME	"exynos-fimc-lite"
>   #define FLITE_CLK_NAME		"flite"
> -#define FIMC_LITE_MAX_DEVS	2
> +#define FIMC_LITE_MAX_DEVS	3
>   #define FLITE_REQ_BUFS_MIN	2
>
>   /* Bit index definitions for struct fimc_lite::state */
> @@ -49,12 +49,17 @@ enum {
>   #define FLITE_SD_PAD_SOURCE_ISP	2
>   #define FLITE_SD_PADS_NUM	3
>
> +#define FLITE_VER_EXYNOS4	0
> +#define FLITE_VER_EXYNOS5	1

I would prefer not using explicit version and rather put each
quirk in the driver data structure, so we can avoid those
multiple if (version == ...) checks all over in the code, should
more revision of this IP come in future SoCs.
