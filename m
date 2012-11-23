Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11695 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030282Ab2KWJvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 04:51:14 -0500
Received: from eusync3.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDX00H09Q1SWY10@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Nov 2012 09:51:28 +0000 (GMT)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MDX00CP2Q1C4040@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Nov 2012 09:51:12 +0000 (GMT)
Message-id: <50AF470F.5090805@samsung.com>
Date: Fri, 23 Nov 2012 10:51:11 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org, Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: Re: [PATCH 2/4] [media] exynos-gsc: Remove gsc_clk_put call from
 gsc_clk_get
References: <1353645902-7467-1-git-send-email-sachin.kamat@linaro.org>
 <1353645902-7467-3-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1353645902-7467-3-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/23/2012 05:45 AM, Sachin Kamat wrote:
> Since this function just returns (since gsc->clock is NULL),
> remove it and make the exit code simpler.
> 
> Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/exynos-gsc/gsc-core.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
> index 45bcfa7..99ee1a9 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
> @@ -1020,7 +1020,7 @@ static int gsc_clk_get(struct gsc_dev *gsc)
>  	if (IS_ERR(gsc->clock)) {
>  		dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
>  			GSC_CLOCK_GATE_NAME);
> -		goto err_clk_get;
> +		goto err;
>  	}
>  
>  	ret = clk_prepare(gsc->clock);
> @@ -1029,14 +1029,12 @@ static int gsc_clk_get(struct gsc_dev *gsc)
>  			GSC_CLOCK_GATE_NAME);
>  		clk_put(gsc->clock);
>  		gsc->clock = NULL;
> -		goto err_clk_prepare;
> +		goto err;
>  	}
>  
>  	return 0;
>  
> -err_clk_prepare:
> -	gsc_clk_put(gsc);
> -err_clk_get:

Hmm, ok, here come the remaining part of the cleanup..
I think this patch can be folded into the previous one.

> +err:
>  	return -ENXIO;
>  }
