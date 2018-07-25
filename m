Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38209 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728499AbeGYM0G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 08:26:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id v14-v6so7043249wro.5
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2018 04:14:53 -0700 (PDT)
Subject: Re: [PATCH v3 1/4] venus: firmware: add routine to reset ARM9
To: Vikash Garodia <vgarodia@codeaurora.org>,
        stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, robh@kernel.org, mark.rutland@arm.com,
        andy.gross@linaro.org, arnd@arndb.de, bjorn.andersson@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
References: <1530731212-30474-1-git-send-email-vgarodia@codeaurora.org>
 <1530731212-30474-2-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <a9e7aee2-7320-affa-4887-c090b3ce289d@linaro.org>
Date: Wed, 25 Jul 2018 14:14:47 +0300
MIME-Version: 1.0
In-Reply-To: <1530731212-30474-2-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/04/2018 10:06 PM, Vikash Garodia wrote:
> Add routine to reset the ARM9 and brings it out of reset. Also
> abstract the Venus CPU state handling with a new function. This
> is in preparation to add PIL functionality in venus driver.
> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/core.h         |  1 +
>  drivers/media/platform/qcom/venus/firmware.c     | 36 ++++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/firmware.h     |  1 +
>  drivers/media/platform/qcom/venus/hfi_venus.c    | 13 +++------
>  drivers/media/platform/qcom/venus/hfi_venus_io.h |  5 ++++
>  5 files changed, 47 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> index 2f02365..eb5ee66 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -129,6 +129,7 @@ struct venus_core {
>  	struct device *dev;
>  	struct device *dev_dec;
>  	struct device *dev_enc;
> +	bool no_tz;
>  	struct mutex lock;
>  	struct list_head instances;
>  	atomic_t insts_count;
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index 521d4b3..3968553d 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -22,11 +22,47 @@
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
> +static void venus_reset_cpu(struct venus_core *core)
> +{
> +	void __iomem *base = core->base;
> +
> +	writel(0, base + WRAPPER_FW_START_ADDR);
> +	writel(VENUS_FW_MEM_SIZE, base + WRAPPER_FW_END_ADDR);
> +	writel(0, base + WRAPPER_CPA_START_ADDR);
> +	writel(VENUS_FW_MEM_SIZE, base + WRAPPER_CPA_END_ADDR);
> +	writel(0x0, base + WRAPPER_CPU_CGC_DIS);
> +	writel(0x0, base + WRAPPER_CPU_CLOCK_CONFIG);
> +
> +	/* Make sure all register writes are committed. */
> +	mb();
> +
> +	/* Bring ARM9 out of reset */
> +	writel_relaxed(0, base + WRAPPER_A9SS_SW_RESET);
> +}
> +
> +int venus_set_hw_state(struct venus_core *core, bool resume)
> +{
> +	void __iomem *base = core->base;
> +
> +	if (!core->no_tz)
> +		return qcom_scm_set_remote_state(resume, 0);
> +
> +	if (resume)
> +		venus_reset_cpu(core);
> +	else
> +		writel(1, base + WRAPPER_A9SS_SW_RESET);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(venus_set_hw_state);

This export_symbol shouldn't be needed

-- 
regards,
Stan
