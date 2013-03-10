Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:50552 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3CJUkH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 16:40:07 -0400
Message-ID: <513CEFA1.3030809@gmail.com>
Date: Sun, 10 Mar 2013 21:40:01 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, s.nawrocki@samsung.com,
	shaik.samsung@gmail.com
Subject: Re: [RFC 04/12] s5p-csis: Adding Exynos5250 compatibility
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com> <1362570838-4737-5-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-5-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/06/2013 12:53 PM, Shaik Ameer Basha wrote:

Please don't leave the change log empty. I'll apply this patch.
I'm just wondering, if there aren't any further changes needed
to make the driver really working on exynos5250 ?

> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
> ---
>   drivers/media/platform/s5p-fimc/mipi-csis.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
> index df4411c..debda7c 100644
> --- a/drivers/media/platform/s5p-fimc/mipi-csis.c
> +++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
> @@ -1002,6 +1002,7 @@ static const struct dev_pm_ops s5pcsis_pm_ops = {
>   static const struct of_device_id s5pcsis_of_match[] __devinitconst = {
>   	{ .compatible = "samsung,exynos3110-csis" },
>   	{ .compatible = "samsung,exynos4210-csis" },
> +	{ .compatible = "samsung,exynos5250-csis" },
>   	{ /* sentinel */ },
>   };
>   MODULE_DEVICE_TABLE(of, s5pcsis_of_match);
