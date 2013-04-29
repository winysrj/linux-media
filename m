Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22631 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3D2PO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 11:14:58 -0400
Message-id: <517E8E6D.3000504@samsung.com>
Date: Mon, 29 Apr 2013 17:14:53 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, shaik.samsung@gmail.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC v2 5/6] media: s5p-csis: Adding Exynos5250 compatibility
References: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
 <1366789273-30184-6-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1366789273-30184-6-git-send-email-shaik.ameer@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/24/2013 09:41 AM, Shaik Ameer Basha wrote:
> FIMC-IS firmware needs all the MIPI-CSIS interrupts to be enabled.
> This patch enables all those MIPI interrupts and adds the Exynos5
> compatible string.
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> ---
>  drivers/media/platform/exynos4-is/mipi-csis.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
> index 8636bcd..51ad9b2 100644
> --- a/drivers/media/platform/exynos4-is/mipi-csis.c
> +++ b/drivers/media/platform/exynos4-is/mipi-csis.c
> @@ -66,7 +66,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
>  
>  /* Interrupt mask */
>  #define S5PCSIS_INTMSK			0x10
> -#define S5PCSIS_INTMSK_EN_ALL		0xf000103f
> +#define S5PCSIS_INTMSK_EN_ALL		0xfc00103f

I'm a bit reluctant to apply this patch as is. These interrupts should not
be enabled if are not required. I'll try to make some patch to allow a media
device driver to enable/disable the frame start/end interrupts when needed.
But it would presumably be on top of this patch.

>  #define S5PCSIS_INTMSK_EVEN_BEFORE	(1 << 31)
>  #define S5PCSIS_INTMSK_EVEN_AFTER	(1 << 30)
>  #define S5PCSIS_INTMSK_ODD_BEFORE	(1 << 29)
> @@ -1003,6 +1003,7 @@ static const struct dev_pm_ops s5pcsis_pm_ops = {
>  static const struct of_device_id s5pcsis_of_match[] = {
>  	{ .compatible = "samsung,s5pv210-csis" },
>  	{ .compatible = "samsung,exynos4210-csis" },
> +	{ .compatible = "samsung,exynos5250-csis" },
>  	{ /* sentinel */ },
>  };

Regards,
Sylwester

