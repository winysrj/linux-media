Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37086 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbeFAVVW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 17:21:22 -0400
Date: Fri, 1 Jun 2018 15:21:17 -0600
From: Jordan Crouse <jcrouse@codeaurora.org>
To: Vikash Garodia <vgarodia@codeaurora.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
Subject: Re: [PATCH v2 2/5] media: venus: add a routine to set venus state
Message-ID: <20180601212117.GD11565@jcrouse-lnx.qualcomm.com>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-3-git-send-email-vgarodia@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527884768-22392-3-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 02, 2018 at 01:56:05AM +0530, Vikash Garodia wrote:
> Add a new routine which abstracts the TZ call to
> set the video hardware state.
> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/core.h      |  5 +++++
>  drivers/media/platform/qcom/venus/firmware.c  | 28 +++++++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/firmware.h  |  1 +
>  drivers/media/platform/qcom/venus/hfi_venus.c | 13 ++++---------
>  4 files changed, 38 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> index 85e66e2..e7bfb63 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -35,6 +35,11 @@ struct reg_val {
>  	u32 value;
>  };
>  
> +enum tzbsp_video_state {
> +	TZBSP_VIDEO_SUSPEND = 0,
> +	TZBSP_VIDEO_RESUME

You should put a comma after the last item to reduce future patch sizes.

> +};
> +
>  struct venus_resources {
>  	u64 dma_mask;
>  	const struct freq_tbl *freq_tbl;
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index 7d89b5a..b4664ed 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -53,6 +53,34 @@ static void venus_reset_hw(struct venus_core *core)
>  	/* Bring Arm9 out of reset */
>  	writel_relaxed(0, reg_base + WRAPPER_A9SS_SW_RESET);
>  }
> +
> +int venus_set_hw_state(enum tzbsp_video_state state, struct venus_core *core)
> +{
> +	int ret;
> +	struct device *dev = core->dev;

If you get rid of the log message as you should, you don't need this.

> +	void __iomem *reg_base = core->base;
> +
> +	switch (state) {
> +	case TZBSP_VIDEO_SUSPEND:
> +		if (qcom_scm_is_available())
> +			ret = qcom_scm_set_remote_state(TZBSP_VIDEO_SUSPEND, 0);
> +		else
> +			writel_relaxed(1, reg_base + WRAPPER_A9SS_SW_RESET);

You can just use core->base here and not bother making a local variable for it.

> +		break;
> +	case TZBSP_VIDEO_RESUME:
> +		if (qcom_scm_is_available())
> +			ret = qcom_scm_set_remote_state(TZBSP_VIDEO_RESUME, 0);
> +		else
> +			venus_reset_hw(core);
> +		break;
> +	default:
> +		dev_err(dev, "invalid state\n");

state is a enum - you are highly unlikely to be calling it in your own code with
a random value.  It is smart to have the default, but you don't need the log
message - that is just wasted space in the binary.

> +		break;
> +	}

There are three paths in the switch statement that could end up with 'ret' being
uninitialized here.  Set it to 0 when you declare it.

> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(venus_set_hw_state);
> +
>  int venus_boot(struct device *dev, const char *fwname)
>  {
>  	const struct firmware *mdt;
> diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
> index 428efb5..1336729 100644
> --- a/drivers/media/platform/qcom/venus/firmware.h
> +++ b/drivers/media/platform/qcom/venus/firmware.h
> @@ -18,5 +18,6 @@
>  
>  int venus_boot(struct device *dev, const char *fwname);
>  int venus_shutdown(struct device *dev);
> +int venus_set_hw_state(enum tzbsp_video_state, struct venus_core *core);
>  
>  #endif
> diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
> index f61d34b..797a9f5 100644
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
> @@ -574,7 +569,7 @@ static int venus_power_off(struct venus_hfi_device *hdev)
>  	if (!hdev->power_enabled)
>  		return 0;
>  
> -	ret = qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_SUSPEND, 0);
> +	ret = venus_set_hw_state(TZBSP_VIDEO_SUSPEND, hdev->core);
>  	if (ret)
>  		return ret;
>  
> @@ -594,7 +589,7 @@ static int venus_power_on(struct venus_hfi_device *hdev)
>  	if (hdev->power_enabled)
>  		return 0;
>  
> -	ret = qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_RESUME, 0);
> +	ret = venus_set_hw_state(TZBSP_VIDEO_RESUME, hdev->core);
>  	if (ret)
>  		goto err;
>  
> @@ -607,7 +602,7 @@ static int venus_power_on(struct venus_hfi_device *hdev)
>  	return 0;
>  
>  err_suspend:
> -	qcom_scm_set_remote_state(TZBSP_VIDEO_STATE_SUSPEND, 0);
> +	venus_set_hw_state(TZBSP_VIDEO_SUSPEND, hdev->core);
>  err:
>  	hdev->power_enabled = false;
>  	return ret;

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
