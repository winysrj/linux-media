Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48912 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab2JTJyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 05:54:05 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so360973eaa.19
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2012 02:54:04 -0700 (PDT)
Message-ID: <508274B9.5000401@gmail.com>
Date: Sat, 20 Oct 2012 11:54:01 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	patches@linaro.org
Subject: Re: [PATCH 5/8] [media] exynos-gsc: Use clk_prepare_enable and clk_disable_unprepare
References: <1350472311-9748-1-git-send-email-sachin.kamat@linaro.org> <1350472311-9748-5-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1350472311-9748-5-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/17/2012 01:11 PM, Sachin Kamat wrote:
> Replace clk_enable/clk_disable with clk_prepare_enable/clk_disable_unprepare
> as required by the common clock framework.
> 
> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> ---
>   drivers/media/platform/exynos-gsc/gsc-core.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
> index bfec9e6..d11668b 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
> @@ -1009,7 +1009,7 @@ static int gsc_clk_get(struct gsc_dev *gsc)
>   	if (IS_ERR(gsc->clock))
>   		goto err_print;
> 
> -	ret = clk_prepare(gsc->clock);
> +	ret = clk_prepare_enable(gsc->clock);

This is not right, gsc->clock is being enabled somewhere else.
And as you can see this driver has already taken care of preparing/
unpreparing the clock.

>   	if (ret<  0) {
>   		clk_put(gsc->clock);
>   		gsc->clock = NULL;
> @@ -1186,7 +1186,7 @@ static int gsc_runtime_suspend(struct device *dev)
> 
>   	ret = gsc_m2m_suspend(gsc);
>   	if (!ret)
> -		clk_disable(gsc->clock);
> +		clk_disable_unprepare(gsc->clock);

No, that will result in unbalanced clk_prepare/unprepare. Please
don't do that.
 
> 
>   	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
>   	return ret;

This driver should already inter-work fine with the common clock
framework, just look how it handles the clock:

# git grep -n -7 clk_ -- exynos-gsc

exynos-gsc/gsc-core.c:993:static void gsc_clk_put(struct gsc_dev *gsc)
exynos-gsc/gsc-core.c-994-{
exynos-gsc/gsc-core.c-995-	if (IS_ERR_OR_NULL(gsc->clock))
exynos-gsc/gsc-core.c-996-		return;
exynos-gsc/gsc-core.c-997-
exynos-gsc/gsc-core.c:998:	clk_unprepare(gsc->clock);
exynos-gsc/gsc-core.c:999:	clk_put(gsc->clock);
exynos-gsc/gsc-core.c-1000-	gsc->clock = NULL;
exynos-gsc/gsc-core.c-1001-}
exynos-gsc/gsc-core.c-1002-
exynos-gsc/gsc-core.c:1003:static int gsc_clk_get(struct gsc_dev *gsc)
exynos-gsc/gsc-core.c-1004-{
exynos-gsc/gsc-core.c-1005-	int ret;
exynos-gsc/gsc-core.c-1006-
exynos-gsc/gsc-core.c:1007:	dev_dbg(&gsc->pdev->dev, "gsc_clk_get Called\n");
exynos-gsc/gsc-core.c-1008-
exynos-gsc/gsc-core.c:1009:	gsc->clock = clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
exynos-gsc/gsc-core.c-1010-	if (IS_ERR(gsc->clock))
exynos-gsc/gsc-core.c-1011-		goto err_print;
exynos-gsc/gsc-core.c-1012-
exynos-gsc/gsc-core.c:1013:	ret = clk_prepare(gsc->clock);
exynos-gsc/gsc-core.c-1014-	if (ret < 0) {
exynos-gsc/gsc-core.c:1015:		clk_put(gsc->clock);
exynos-gsc/gsc-core.c-1016-		gsc->clock = NULL;
exynos-gsc/gsc-core.c-1017-		goto err;
exynos-gsc/gsc-core.c-1018-	}
exynos-gsc/gsc-core.c-1019-
exynos-gsc/gsc-core.c-1020-	return 0;
exynos-gsc/gsc-core.c-1021-
exynos-gsc/gsc-core.c-1022-err:
exynos-gsc/gsc-core.c-1023-	dev_err(&gsc->pdev->dev, "clock prepare failed for clock: %s\n",
exynos-gsc/gsc-core.c-1024-					GSC_CLOCK_GATE_NAME);
exynos-gsc/gsc-core.c:1025:	gsc_clk_put(gsc);
exynos-gsc/gsc-core.c-1026-err_print:
exynos-gsc/gsc-core.c-1027-	dev_err(&gsc->pdev->dev, "failed to get clock~~~: %s\n",
exynos-gsc/gsc-core.c-1028-					GSC_CLOCK_GATE_NAME);
exynos-gsc/gsc-core.c-1029-	return -ENXIO;
exynos-gsc/gsc-core.c-1030-}
--
exynos-gsc/gsc-core.c-1105-
exynos-gsc/gsc-core.c-1106-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
exynos-gsc/gsc-core.c-1107-	if (!res) {
exynos-gsc/gsc-core.c-1108-		dev_err(dev, "failed to get IRQ resource\n");
exynos-gsc/gsc-core.c-1109-		return -ENXIO;
exynos-gsc/gsc-core.c-1110-	}
exynos-gsc/gsc-core.c-1111-
exynos-gsc/gsc-core.c:1112:	ret = gsc_clk_get(gsc);
exynos-gsc/gsc-core.c-1113-	if (ret)
exynos-gsc/gsc-core.c-1114-		return ret;
--
exynos-gsc/gsc-core.c-1142-	pm_runtime_put(dev);
exynos-gsc/gsc-core.c-1143-	return 0;
exynos-gsc/gsc-core.c-1144-err_pm:
exynos-gsc/gsc-core.c-1145-	pm_runtime_put(dev);
exynos-gsc/gsc-core.c-1146-err_m2m:
exynos-gsc/gsc-core.c-1147-	gsc_unregister_m2m_device(gsc);
exynos-gsc/gsc-core.c-1148-err_clk:
exynos-gsc/gsc-core.c:1149:	gsc_clk_put(gsc);
exynos-gsc/gsc-core.c-1150-	return ret;
exynos-gsc/gsc-core.c-1151-}
--
exynos-gsc/gsc-core.c-1166-static int gsc_runtime_resume(struct device *dev)
exynos-gsc/gsc-core.c-1167-{
exynos-gsc/gsc-core.c-1168-	struct gsc_dev *gsc = dev_get_drvdata(dev);
exynos-gsc/gsc-core.c-1169-	int ret = 0;
exynos-gsc/gsc-core.c-1170-
exynos-gsc/gsc-core.c-1171-	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
exynos-gsc/gsc-core.c-1172-
exynos-gsc/gsc-core.c:1173:	ret = clk_enable(gsc->clock);
exynos-gsc/gsc-core.c-1174-	if (ret)
exynos-gsc/gsc-core.c-1175-		return ret;
exynos-gsc/gsc-core.c-1176-
exynos-gsc/gsc-core.c-1177-	gsc_hw_set_sw_reset(gsc);
exynos-gsc/gsc-core.c-1178-	gsc_wait_reset(gsc);
exynos-gsc/gsc-core.c-1179-
exynos-gsc/gsc-core.c-1180-	return gsc_m2m_resume(gsc);
--
exynos-gsc/gsc-core.c-1183-static int gsc_runtime_suspend(struct device *dev)
exynos-gsc/gsc-core.c-1184-{
exynos-gsc/gsc-core.c-1185-	struct gsc_dev *gsc = dev_get_drvdata(dev);
exynos-gsc/gsc-core.c-1186-	int ret = 0;
exynos-gsc/gsc-core.c-1187-
exynos-gsc/gsc-core.c-1188-	ret = gsc_m2m_suspend(gsc);
exynos-gsc/gsc-core.c-1189-	if (!ret)
exynos-gsc/gsc-core.c:1190:		clk_disable(gsc->clock);
exynos-gsc/gsc-core.c-1191-
exynos-gsc/gsc-core.c-1192-	pr_debug("gsc%d: state: 0x%lx", gsc->id, gsc->state);
exynos-gsc/gsc-core.c-1193-	return ret;
exynos-gsc/gsc-core.c-1194-}

--
Regards,
Sylwester
