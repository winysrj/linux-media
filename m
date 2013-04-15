Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18841 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab3DOPVv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 11:21:51 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLA00AP5YKWXQC0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Apr 2013 16:21:49 +0100 (BST)
Message-id: <516C1B0B.4010806@samsung.com>
Date: Mon, 15 Apr 2013 17:21:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH 1/1] [media] exynos4-is: Fix potential null pointer
 dereferencing
References: <1366027438-4560-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1366027438-4560-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 04/15/2013 02:03 PM, Sachin Kamat wrote:
> If fimc->drv_data is NULL, then fimc->drv_data->num_entities would
> cause NULL pointer dereferencing.
> While at it also remove the check for fimc->id being negative as 'id' is
> unsigned variable and can't be less than 0.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/exynos4-is/fimc-core.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
> index f25807d..d388832 100644
> --- a/drivers/media/platform/exynos4-is/fimc-core.c
> +++ b/drivers/media/platform/exynos4-is/fimc-core.c
> @@ -953,10 +953,9 @@ static int fimc_probe(struct platform_device *pdev)
>  		fimc->drv_data = fimc_get_drvdata(pdev);
>  		fimc->id = pdev->id;
>  	}
> -	if (!fimc->drv_data || fimc->id >= fimc->drv_data->num_entities ||
> -	    fimc->id < 0) {
> -		dev_err(dev, "Invalid driver data or device id (%d/%d)\n",
> -			fimc->id, fimc->drv_data->num_entities);
> +	if (!fimc->drv_data || fimc->id >= fimc->drv_data->num_entities) {
> +		dev_err(dev, "Invalid driver data or device id (%d)\n",
> +			fimc->id);
>  		return -EINVAL;

Thanks for the patch. To make it more explicit I would prefer to change
id type to 'int', and to leave the check for negative value. There is
a similar issue in fimc-lite.c that could be addressed in same patch.
Could you also fix this and resend ?

Regards,
Sylwester
