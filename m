Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21646 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2K1KNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 05:13:22 -0500
Received: from eusync1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME700I2Y0EN7K50@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Nov 2012 10:13:35 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0ME700MHI0E0RM70@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Nov 2012 10:13:20 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, patches@linaro.org
References: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
 <1353671443-2978-7-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1353671443-2978-7-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 6/6] [media] s5p-mfc: Use devm_clk_get APIs
Date: Wed, 28 Nov 2012 11:13:13 +0100
Message-id: <008101cdcd50$f9db0290$ed9107b0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

The comments from Sylwester also apply to the patches you have sent to MFC
and G2D.

I don't see the benefit of switching to devm_clk_get(), it does some
allocations and hence uses more resources. Leaving that aside there is no
support for devm_clk_prepare and I would rather wait until it is included in
the kernel.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sachin Kamat
> Sent: Friday, November 23, 2012 12:51 PM
> To: linux-media@vger.kernel.org
> Cc: s.nawrocki@samsung.com; sachin.kamat@linaro.org;
> patches@linaro.org; Kamil Debski
> Subject: [PATCH 6/6] [media] s5p-mfc: Use devm_clk_get APIs
> 
> devm_clk_get() is device managed function and makes error handling and
> exit code a bit simpler.
> 
> Cc: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_pm.c |   14 ++++----------
>  1 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> index 2895333..4864d93 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> @@ -37,7 +37,7 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
> 
>  	pm = &dev->pm;
>  	p_dev = dev;
> -	pm->clock_gate = clk_get(&dev->plat_dev->dev, MFC_GATE_CLK_NAME);
> +	pm->clock_gate = devm_clk_get(&dev->plat_dev->dev,
> MFC_GATE_CLK_NAME);
>  	if (IS_ERR(pm->clock_gate)) {
>  		mfc_err("Failed to get clock-gating control\n");
>  		ret = PTR_ERR(pm->clock_gate);
> @@ -47,10 +47,10 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
>  	ret = clk_prepare(pm->clock_gate);
>  	if (ret) {
>  		mfc_err("Failed to preapre clock-gating control\n");
> -		goto err_p_ip_clk;
> +		goto err_g_ip_clk;
>  	}
> 
> -	pm->clock = clk_get(&dev->plat_dev->dev, dev->variant-
> >mclk_name);
> +	pm->clock = devm_clk_get(&dev->plat_dev->dev,
> +dev->variant->mclk_name);
>  	if (IS_ERR(pm->clock)) {
>  		mfc_err("Failed to get MFC clock\n");
>  		ret = PTR_ERR(pm->clock);
> @@ -60,7 +60,7 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
>  	ret = clk_prepare(pm->clock);
>  	if (ret) {
>  		mfc_err("Failed to prepare MFC clock\n");
> -		goto err_p_ip_clk_2;
> +		goto err_g_ip_clk_2;
>  	}
> 
>  	atomic_set(&pm->power, 0);
> @@ -72,12 +72,8 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
>  	atomic_set(&clk_ref, 0);
>  #endif
>  	return 0;
> -err_p_ip_clk_2:
> -	clk_put(pm->clock);
>  err_g_ip_clk_2:
>  	clk_unprepare(pm->clock_gate);
> -err_p_ip_clk:
> -	clk_put(pm->clock_gate);
>  err_g_ip_clk:
>  	return ret;
>  }
> @@ -85,9 +81,7 @@ err_g_ip_clk:
>  void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)  {
>  	clk_unprepare(pm->clock_gate);
> -	clk_put(pm->clock_gate);
>  	clk_unprepare(pm->clock);
> -	clk_put(pm->clock);
>  #ifdef CONFIG_PM_RUNTIME
>  	pm_runtime_disable(pm->device);
>  #endif
> --
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html


