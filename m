Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:40845 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbeHUP3S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 11:29:18 -0400
Received: by mail-wm0-f65.google.com with SMTP id y9-v6so2631434wma.5
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 05:09:23 -0700 (PDT)
Subject: Re: [PATCH v4 1/4] venus: firmware: add routine to reset ARM9
To: Vikash Garodia <vgarodia@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, robh@kernel.org, mark.rutland@arm.com,
        andy.gross@linaro.org, arnd@arndb.de, bjorn.andersson@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
References: <1533562085-8773-1-git-send-email-vgarodia@codeaurora.org>
 <1533562085-8773-2-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <16018b76-ac65-828c-9fe3-e87b41f9bbe1@linaro.org>
Date: Tue, 21 Aug 2018 15:09:21 +0300
MIME-Version: 1.0
In-Reply-To: <1533562085-8773-2-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On 08/06/2018 04:28 PM, Vikash Garodia wrote:
> Add routine to reset the ARM9 and brings it out of reset. Also
> abstract the Venus CPU state handling with a new function. This
> is in preparation to add PIL functionality in venus driver.
> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/core.h         |  1 +
>  drivers/media/platform/qcom/venus/firmware.c     | 31 ++++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/firmware.h     | 11 +++++++++
>  drivers/media/platform/qcom/venus/hfi_venus.c    | 13 +++-------
>  drivers/media/platform/qcom/venus/hfi_venus_io.h |  5 ++++
>  5 files changed, 52 insertions(+), 9 deletions(-)
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
> index c4a5778..3aa6b37 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -22,10 +22,41 @@
>  #include <linux/sizes.h>
>  #include <linux/soc/qcom/mdt_loader.h>
>  
> +#include "core.h"
>  #include "firmware.h"
> +#include "hfi_venus_io.h"
>  
>  #define VENUS_PAS_ID			9
>  #define VENUS_FW_MEM_SIZE		(6 * SZ_1M)
> +#define VENUS_FW_START_ADDR		0x0
> +
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
> +	/* Bring ARM9 out of reset */
> +	writel(0, base + WRAPPER_A9SS_SW_RESET);
> +}
> +
> +int venus_set_hw_state(struct venus_core *core, bool resume)
> +{
> +	if (!core->no_tz)
> +		return qcom_scm_set_remote_state(resume, 0);
> +
> +	if (resume)
> +		venus_reset_cpu(core);
> +	else
> +		writel(1, core->base + WRAPPER_A9SS_SW_RESET);
> +
> +	return 0;
> +}
>  
>  int venus_boot(struct device *dev, const char *fwname)
>  {
> diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
> index 428efb5..efa449a 100644
> --- a/drivers/media/platform/qcom/venus/firmware.h
> +++ b/drivers/media/platform/qcom/venus/firmware.h
> @@ -18,5 +18,16 @@
>  
>  int venus_boot(struct device *dev, const char *fwname);
>  int venus_shutdown(struct device *dev);
> +int venus_set_hw_state(struct venus_core *core, bool suspend);
> +
> +static inline int venus_set_hw_state_suspend(struct venus_core *core)
> +{
> +	return venus_set_hw_state(core, 0);

venus_set_hw_state(core, false);

> +}
> +
> +static inline int venus_set_hw_state_resume(struct venus_core *core)
> +{
> +	return venus_set_hw_state(core, 1);

venus_set_hw_state(core, true);

<snip>

-- 
regards,
Stan
