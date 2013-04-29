Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26291 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab3D2MIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 08:08:42 -0400
Message-id: <517E62C5.8030207@samsung.com>
Date: Mon, 29 Apr 2013 14:08:37 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, shaik.samsung@gmail.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC v2 2/6] fimc-lite: Adding Exynos5 compatibility to fimc-lite
 driver
References: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
 <1366789273-30184-3-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1366789273-30184-3-git-send-email-shaik.ameer@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/24/2013 09:41 AM, Shaik Ameer Basha wrote:
> This patch adds,
> 1] Exynos5 soc compatibility to the fimc-lite driver
> 2] Multiple dma output buffer support as from Exynos5 onwards,
>    fimc-lite h/w ip supports multiple dma buffers.
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> ---
>  drivers/media/platform/exynos4-is/fimc-lite.c |   19 ++++++++++++++++++-
>  drivers/media/platform/exynos4-is/fimc-lite.h |    4 +++-
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
> index 4878089..cb173ec 100644
> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
> @@ -1467,7 +1467,7 @@ static int fimc_lite_probe(struct platform_device *pdev)
>  		fimc->index = pdev->id;
>  	}
>  
> -	if (!drv_data || fimc->index < 0 || fimc->index >= FIMC_LITE_MAX_DEVS)
> +	if (!drv_data || fimc->index < 0 || fimc->index >= drv_data->num_devs)
>  		return -EINVAL;
>  
>  	fimc->dd = drv_data;
> @@ -1625,6 +1625,19 @@ static struct flite_drvdata fimc_lite_drvdata_exynos4 = {
>  	.out_width_align	= 8,
>  	.win_hor_offs_align	= 2,
>  	.out_hor_offs_align	= 8,
> +	.support_multi_dma_buf	= false,
> +	.num_devs = 2,
> +};

Could you include this in your patch:

/**
 * struct flite_drvdata - FIMC-LITE IP variant data structure
 * @max_width: maximum camera interface input width in pixels
 * @max_height: maximum camera interface input height in pixels
 * @out_width_align: minimum output width alignment in pixels
 * @win_hor_offs_align: minimum camera interface crop window horizontal
 * 			offset alignment in pixels
 * @out_hor_offs_align: minimum output DMA compose rectangle horizontal
 * 			offset alignment in pixels
 * @num_out_dma_bufs: number of output DMA buffer start address registers
 */
?
> +/* EXYNOS5250 */
> +static struct flite_drvdata fimc_lite_drvdata_exynos5 = {
> +	.max_width		= 8192,
> +	.max_height		= 8192,
> +	.out_width_align	= 8,
> +	.win_hor_offs_align	= 2,
> +	.out_hor_offs_align	= 8,
> +	.support_multi_dma_buf	= true,

How about changing it to 'num_out_dma_bufs' ? And instead of

if (dd->support_multi_dma_buf)

having

if (dd->num_out_dma_bufs > 1)

?

Otherwise the patch looks good to me. I will make a separate patch
to update the binding documentation.

I've found there is a mistake in the compatible property's documentation.
I would like to fix it in the 3.10-rc cycle, I'm not 100% sure if it
qualifies as the -rc material, but having kernel released with wrongly
documented compatible property would have been bad I think.


Thanks,
Sylwester
