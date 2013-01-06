Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63260 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab3AFOsK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2013 09:48:10 -0500
Message-ID: <50E98EA5.6050806@gmail.com>
Date: Sun, 06 Jan 2013 15:48:05 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, k.debski@samsung.com,
	s.nawrocki@samsung.com, patches@linaro.org,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 3/3] [media] s5p-mfc: Use of_match_ptr and CONFIG_OF
References: <1356689908-6866-1-git-send-email-sachin.kamat@linaro.org> <1356689908-6866-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1356689908-6866-3-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 12/28/2012 11:18 AM, Sachin Kamat wrote:
> This builds the code only if DT is enabled.

Since the driver this patch touches is for platforms that in (not distant)
future will be DT only I don't really see an advantage of applying it,
only to need to revert it after few kernel releases.

I realize this exynos_mfc_match[] array's size is ~400 B, but still I'd
prefer to avoid such #ifdefs.

> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> ---
>   drivers/media/platform/s5p-mfc/s5p_mfc.c |    4 +++-
>   1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 3930177..65ed603 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1405,6 +1405,7 @@ static struct platform_device_id mfc_driver_ids[] = {
>   };
>   MODULE_DEVICE_TABLE(platform, mfc_driver_ids);
>
> +#ifdef CONFIG_OF
>   static const struct of_device_id struct of_device_id[] = {
>   	{
>   		.compatible = "samsung,mfc-v5",
> @@ -1416,6 +1417,7 @@ static const struct of_device_id exynos_mfc_match[] = {
>   	{},
>   };
>   MODULE_DEVICE_TABLE(of, exynos_mfc_match);
> +#endif


>   static void *mfc_get_drv_data(struct platform_device *pdev)
>   {
> @@ -1442,7 +1444,7 @@ static struct platform_driver s5p_mfc_driver = {
>   		.name	= S5P_MFC_NAME,
>   		.owner	= THIS_MODULE,
>   		.pm	=&s5p_mfc_pm_ops,
> -		.of_match_table = exynos_mfc_match,
> +		.of_match_table = of_match_ptr(exynos_mfc_match),
>   	},
>   };
>

Thanks,
Sylwester
