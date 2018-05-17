Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52056 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752448AbeEQP5m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 11:57:42 -0400
Date: Thu, 17 May 2018 09:57:38 -0600
From: Jordan Crouse <jcrouse@codeaurora.org>
To: Vikash Garodia <vgarodia@codeaurora.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        acourbot@google.com
Subject: Re: [PATCH 2/4] media: venus: add a routine to reset ARM9
Message-ID: <20180517155737.GI4995@jcrouse-lnx.qualcomm.com>
References: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
 <1526556740-25494-3-git-send-email-vgarodia@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1526556740-25494-3-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 17, 2018 at 05:02:18PM +0530, Vikash Garodia wrote:
> Add a new routine to reset the ARM9 and brings it
> out of reset. This is in preparation to add PIL
> functionality in venus driver.
> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/firmware.c     | 26 ++++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/firmware.h     |  1 +
>  drivers/media/platform/qcom/venus/hfi_venus_io.h |  5 +++++
>  3 files changed, 32 insertions(+)
> 
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index c4a5778..8f25375 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -14,6 +14,7 @@
>  
>  #include <linux/device.h>
>  #include <linux/firmware.h>
> +#include <linux/delay.h>
>  #include <linux/kernel.h>
>  #include <linux/io.h>
>  #include <linux/of.h>
> @@ -22,11 +23,36 @@
>  #include <linux/sizes.h>
>  #include <linux/soc/qcom/mdt_loader.h>
>  
> +#include "core.h"
>  #include "firmware.h"
> +#include "hfi_venus_io.h"
>  
>  #define VENUS_PAS_ID			9
>  #define VENUS_FW_MEM_SIZE		(6 * SZ_1M)
>  
> +void venus_reset_hw(struct venus_core *core)
> +{
> +	void __iomem *reg_base = core->base;
> +
> +	writel(0, reg_base + WRAPPER_FW_START_ADDR);
> +	writel(VENUS_FW_MEM_SIZE, reg_base + WRAPPER_FW_END_ADDR);
> +	writel(0, reg_base + WRAPPER_CPA_START_ADDR);
> +	writel(VENUS_FW_MEM_SIZE, reg_base + WRAPPER_CPA_END_ADDR);
> +	writel(0x0, reg_base + WRAPPER_CPU_CGC_DIS);
> +	writel(0x0, reg_base + WRAPPER_CPU_CLOCK_CONFIG);

If you are going to have a bunch of writel() functions followed by a barrier it
wouldn't hurt to use writel_relaxed() instead.

Jordan

> +	/* Make sure all register writes are committed. */
> +	mb();
> +
> +	/*
> +	 * Need to wait 10 cycles of internal clocks before bringing ARM9
> +	 * out of reset.
> +	 */
> +	udelay(1);
> +
> +	/* Bring Arm9 out of reset */
> +	writel_relaxed(0, reg_base + WRAPPER_A9SS_SW_RESET);
> +}
>  int venus_boot(struct device *dev, const char *fwname)
>  {
>  	const struct firmware *mdt;
> diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
> index 428efb5..d56f5b2 100644
> --- a/drivers/media/platform/qcom/venus/firmware.h
> +++ b/drivers/media/platform/qcom/venus/firmware.h
> @@ -18,5 +18,6 @@
>  
>  int venus_boot(struct device *dev, const char *fwname);
>  int venus_shutdown(struct device *dev);
> +void venus_reset_hw(struct venus_core *core);
>  
>  #endif
> diff --git a/drivers/media/platform/qcom/venus/hfi_venus_io.h b/drivers/media/platform/qcom/venus/hfi_venus_io.h
> index 76f4793..39afa5d 100644
> --- a/drivers/media/platform/qcom/venus/hfi_venus_io.h
> +++ b/drivers/media/platform/qcom/venus/hfi_venus_io.h
> @@ -109,6 +109,11 @@
>  #define WRAPPER_CPU_CGC_DIS			(WRAPPER_BASE + 0x2010)
>  #define WRAPPER_CPU_STATUS			(WRAPPER_BASE + 0x2014)
>  #define WRAPPER_SW_RESET			(WRAPPER_BASE + 0x3000)
> +#define WRAPPER_CPA_START_ADDR		(WRAPPER_BASE + 0x1020)
> +#define WRAPPER_CPA_END_ADDR		(WRAPPER_BASE + 0x1024)
> +#define WRAPPER_FW_START_ADDR		(WRAPPER_BASE + 0x1028)
> +#define WRAPPER_FW_END_ADDR			(WRAPPER_BASE + 0x102C)
> +#define WRAPPER_A9SS_SW_RESET		(WRAPPER_BASE + 0x3000)
>  
>  /* Venus 4xx */
>  #define WRAPPER_VCODEC0_MMCC_POWER_STATUS	(WRAPPER_BASE + 0x90)

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
