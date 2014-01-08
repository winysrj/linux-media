Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:15340 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaAHEWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 23:22:12 -0500
From: Jingoo Han <jg1.han@samsung.com>
To: 'Sylwester Nawrocki' <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Jingoo Han' <jg1.han@samsung.com>
References: <1389132528-21281-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1389132528-21281-1-git-send-email-s.nawrocki@samsung.com>
Subject: Re: [PATCH] exynos4-is: Compile runtime PM callbacks in conditionally
Date: Wed, 08 Jan 2014 13:22:10 +0900
Message-id: <000001cf0c29$32cb7220$98625660$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, January 08, 2014 7:09 AM, Sylwester Nawrocki wrote:
> 
> Enclose the runtime PM helpers in #ifdef CONFIG_PM_RUNTIME/#endif
> to avoid following compile warning when CONFIG_PM_RUNTIME is disabled:
> 
>  CC      drivers/media/platform/exynos4-is/fimc-core.o
> drivers/media/platform/exynos4-is/fimc-core.c:1040:12: warning: ‘fimc_runtime_resume’ defined but not
> used
> drivers/media/platform/exynos4-is/fimc-core.c:1057:12: warning: ‘fimc_runtime_suspend’ defined but not
> used
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Right, '#ifdef CONFIG_PM_RUNTIME' should be used in order to
fix the compile warning.

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/media/platform/exynos4-is/fimc-core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-
> core.c
> index dcbea59..da2fc86 100644
> --- a/drivers/media/platform/exynos4-is/fimc-core.c
> +++ b/drivers/media/platform/exynos4-is/fimc-core.c
> @@ -1037,6 +1037,7 @@ err_sclk:
>  	return ret;
>  }
> 
> +#ifdef CONFIG_PM_RUNTIME
>  static int fimc_runtime_resume(struct device *dev)
>  {
>  	struct fimc_dev *fimc =	dev_get_drvdata(dev);
> @@ -1069,6 +1070,7 @@ static int fimc_runtime_suspend(struct device *dev)
>  	dbg("fimc%d: state: 0x%lx", fimc->id, fimc->state);
>  	return ret;
>  }
> +#endif
> 
>  #ifdef CONFIG_PM_SLEEP
>  static int fimc_resume(struct device *dev)
> --
> 1.7.4.1

