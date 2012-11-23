Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:65369 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759041Ab2KWJbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 04:31:14 -0500
Received: from eusync3.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDX007TSP4FLG90@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Nov 2012 09:31:27 +0000 (GMT)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MDX008SNP3ZEI80@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Nov 2012 09:31:12 +0000 (GMT)
Message-id: <50AF425E.9030203@samsung.com>
Date: Fri, 23 Nov 2012 10:31:10 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, patches@linaro.org,
	Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: Re: [PATCH 1/4] [media] exynos-gsc: Rearrange error messages for valid
 prints
References: <1353645902-7467-1-git-send-email-sachin.kamat@linaro.org>
 <1353645902-7467-2-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1353645902-7467-2-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thanks for the patches.

On 11/23/2012 05:44 AM, Sachin Kamat wrote:
> In case of clk_prepare failure, the function gsc_clk_get also prints
> "failed to get clock" which is not correct. Hence move the error
> messages to their respective blocks. While at it, also renamed the labels
> meaningfully.
> 
> Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/exynos-gsc/gsc-core.c |   19 ++++++++++---------
>  1 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
> index 6d6f65d..45bcfa7 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
> @@ -1017,25 +1017,26 @@ static int gsc_clk_get(struct gsc_dev *gsc)
>  	dev_dbg(&gsc->pdev->dev, "gsc_clk_get Called\n");
>  
>  	gsc->clock = clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
> -	if (IS_ERR(gsc->clock))
> -		goto err_print;
> +	if (IS_ERR(gsc->clock)) {
> +		dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
> +			GSC_CLOCK_GATE_NAME);
> +		goto err_clk_get;

You could also just return PTR_ERR(gsc->clock) here and remove
err_clk_get label entirely.		

> +	}
>  
>  	ret = clk_prepare(gsc->clock);
>  	if (ret < 0) {
> +		dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
> +			GSC_CLOCK_GATE_NAME);
>  		clk_put(gsc->clock);
>  		gsc->clock = NULL;
> -		goto err;
> +		goto err_clk_prepare;
>  	}
>  
>  	return 0;
>  
> -err:
> -	dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
> -					GSC_CLOCK_GATE_NAME);
> +err_clk_prepare:
>  	gsc_clk_put(gsc);

This call can be removed too. I would remove all labels and gotos in
this function. Since there is only one clock, you need to only call
clk_put when clk_prepare() fails, there is no need for gsc_clk_put().

> -err_print:
> -	dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
> -					GSC_CLOCK_GATE_NAME);
> +err_clk_get:
>  	return -ENXIO;
>  }

As a general remark, I think changes like in this series have to be
validated before we can think of applying it. I guess Shaik or
somebody else would need to test it. I still have no board I could
test Exynos5 Gscaler IP.

--

Regards,
Sylwester
