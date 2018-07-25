Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35494 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728629AbeGYKqX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 06:46:23 -0400
Received: by mail-wm0-f66.google.com with SMTP id o18-v6so5318392wmc.0
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2018 02:35:31 -0700 (PDT)
Subject: Re: [PATCH v3 1/4] venus: firmware: add routine to reset ARM9
To: Vikash Garodia <vgarodia@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, robh@kernel.org, mark.rutland@arm.com,
        andy.gross@linaro.org, arnd@arndb.de, bjorn.andersson@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
References: <1530731212-30474-1-git-send-email-vgarodia@codeaurora.org>
 <1530731212-30474-2-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <8635f09f-a464-2ec6-a29d-9c2fc7601a36@linaro.org>
Date: Wed, 25 Jul 2018 12:35:25 +0300
MIME-Version: 1.0
In-Reply-To: <1530731212-30474-2-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

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

replace writel_relaxed with writel and drop above mb. The writel has wmb
just before writing so I think using writel here is better choice.

> +}
> +
> +int venus_set_hw_state(struct venus_core *core, bool resume)

s/resume/suspend as it is done in the function prototype in firmware.h.

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
> +
>  int venus_boot(struct device *dev, const char *fwname)
>  {
>  	const struct firmware *mdt;
> diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
> index 428efb5..ff2e70e 100644
> --- a/drivers/media/platform/qcom/venus/firmware.h
> +++ b/drivers/media/platform/qcom/venus/firmware.h
> @@ -18,5 +18,6 @@
>  
>  int venus_boot(struct device *dev, const char *fwname);
>  int venus_shutdown(struct device *dev);
> +int venus_set_hw_state(struct venus_core *core, bool suspend);

could you make two inline functions here, call them
venus_set_hw_state_suspend() and venus_set_hw_state_resume() which just
call venus_set_hw_state with the right state.

>  
>  #endif
> diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
> index 9366dae..5b56925 100644
> --- a/drivers/media/platform/qcom/venus/hfi_venus.c
> +++ b/drivers/media/platform/qcom/venus/hfi_venus.c
> @@ -19,7 +19,6 @@
>  #include <linux/interrupt.h>
>  #include <linux/iopoll.h>
>  #include <linux/kernel.h>
> -#include <linux/qcom_scm.h>
>  #include <linux/slab.h>
>  
>  #include "core.h"
> @@ -27,6 +26,7 @@
>  #include "hfi_msgs.h"
>  #include "hfi_venus.h"
>  #include "hfi_venus_io.h"
> +#include "firmware.h"
>  
>  #define HFI_MASK_QHDR_TX_TYPE		0xff000000
>  #define HFI_MASK_QHDR_RX_TYPE		0x00ff0000
> @@ -55,11 +55,6 @@
>  #define IFACEQ_VAR_LARGE_PKT_SIZE	512
>  #define IFACEQ_VAR_HUGE_PKT_SIZE	(1024 * 12)
>  
> -enum tzbsp_video_state {
> -	TZBSP_VIDEO_STATE_SUSPEND = 0,
> -	TZBSP_VIDEO_STATE_RESUME
> -};
> -
>  struct hfi_queue_table_header {
>  	u32 version;
>  	u32 size;
> @@ -575,7 +570,7 @@ static int venus_power_off(struct venus_hfi_device *hdev)
>  	if (!hdev->power_enabled)
>  		return 0;
>  
> -	ret = qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_SUSPEND, 0);
> +	ret = venus_set_hw_state(hdev->core, false);

... and use venus_set_hw_state_suspend()

>  	if (ret)
>  		return ret;
>  
> @@ -595,7 +590,7 @@ static int venus_power_on(struct venus_hfi_device *hdev)
>  	if (hdev->power_enabled)
>  		return 0;
>  
> -	ret = qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_RESUME, 0);
> +	ret = venus_set_hw_state(hdev->core, true);

... and use venus_set_hw_state_resume()

>  	if (ret)
>  		goto err;
>  
> @@ -608,7 +603,7 @@ static int venus_power_on(struct venus_hfi_device *hdev)
>  	return 0;
>  
>  err_suspend:
> -	qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_SUSPEND, 0);
> +	venus_set_hw_state(hdev->core, false);
>  err:
>  	hdev->power_enabled = false;
>  	return ret;
> diff --git a/drivers/media/platform/qcom/venus/hfi_venus_io.h b/drivers/media/platform/qcom/venus/hfi_venus_io.h
> index def0926..0a4210f 100644
> --- a/drivers/media/platform/qcom/venus/hfi_venus_io.h
> +++ b/drivers/media/platform/qcom/venus/hfi_venus_io.h
> @@ -112,6 +112,11 @@
>  #define WRAPPER_CPU_STATUS			(WRAPPER_BASE + 0x2014)
>  #define WRAPPER_CPU_STATUS_WFI			BIT(0)
>  #define WRAPPER_SW_RESET			(WRAPPER_BASE + 0x3000)
> +#define WRAPPER_CPA_START_ADDR	(WRAPPER_BASE + 0x1020)
> +#define WRAPPER_CPA_END_ADDR		(WRAPPER_BASE + 0x1024)
> +#define WRAPPER_FW_START_ADDR	(WRAPPER_BASE + 0x1028)
> +#define WRAPPER_FW_END_ADDR			(WRAPPER_BASE + 0x102C)
> +#define WRAPPER_A9SS_SW_RESET	(WRAPPER_BASE + 0x3000)

something is wrong with tabs/indentation could you check? seems only
WRAPPER_FW_END_ADDR is fine.

>  
>  /* Venus 4xx */
>  #define WRAPPER_VCODEC0_MMCC_POWER_STATUS	(WRAPPER_BASE + 0x90)
> 

-- 
regards,
Stan
