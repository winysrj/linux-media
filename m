Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:43506 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753057AbeFDNuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 09:50:32 -0400
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: [PATCH v2 2/5] media: venus: add a routine to set venus state
To: Vikash Garodia <vgarodia@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, robh@kernel.org, mark.rutland@arm.com,
        andy.gross@linaro.org, bjorn.andersson@linaro.org,
        stanimir.varbanov@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-3-git-send-email-vgarodia@codeaurora.org>
Message-ID: <be5cc865-608b-dabb-2a3c-b5864c387d64@mm-sol.com>
Date: Mon, 4 Jun 2018 16:50:24 +0300
MIME-Version: 1.0
In-Reply-To: <1527884768-22392-3-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

Thanks for the patch!

On  1.06.2018 23:26, Vikash Garodia wrote:
> Add a new routine which abstracts the TZ call to

Actually the new routine abstracts Venus CPU state, Isn't it?

> set the video hardware state.
> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>   drivers/media/platform/qcom/venus/core.h      |  5 +++++
>   drivers/media/platform/qcom/venus/firmware.c  | 28 +++++++++++++++++++++++++++
>   drivers/media/platform/qcom/venus/firmware.h  |  1 +
>   drivers/media/platform/qcom/venus/hfi_venus.c | 13 ++++---------
>   4 files changed, 38 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> index 85e66e2..e7bfb63 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -35,6 +35,11 @@ struct reg_val {
>   	u32 value;
>   };
>   
> +enum tzbsp_video_state {
> +	TZBSP_VIDEO_SUSPEND = 0,
> +	TZBSP_VIDEO_RESUME
> +};

please move this in firmware.c, for more see below.

> +
>   struct venus_resources {
>   	u64 dma_mask;
>   	const struct freq_tbl *freq_tbl;
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index 7d89b5a..b4664ed 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -53,6 +53,34 @@ static void venus_reset_hw(struct venus_core *core)
>   	/* Bring Arm9 out of reset */
>   	writel_relaxed(0, reg_base + WRAPPER_A9SS_SW_RESET);
>   }
> +
> +int venus_set_hw_state(enum tzbsp_video_state state, struct venus_core *core)

can we put this function this way:

venus_set_state(struct venus_core *core, bool on)

so we set the state to On when we are power-up the venus CPU and Off
when we power-down.

by this way we really abstract the state, IMO.

> +{
> +	int ret;
> +	struct device *dev = core->dev;
> +	void __iomem *reg_base = core->base;

just 'base' should be enough.

> +
> +	switch (state) {
> +	case TZBSP_VIDEO_SUSPEND:
> +		if (qcom_scm_is_available())

You really shouldn't rely on this function (see the comment from Bjorn
on first version of this patch series).

I think we have to replace qcom_scm_is_available() with some flag which
is reflecting does the firmware subnode is exist or not. In case it is
not exist the we have to go with TZ scm calls.

> +			ret = qcom_scm_set_remote_state(TZBSP_VIDEO_SUSPEND, 0);
> +		else
> +			writel_relaxed(1, reg_base + WRAPPER_A9SS_SW_RESET);
> +		break;
> +	case TZBSP_VIDEO_RESUME:
> +		if (qcom_scm_is_available())
> +			ret = qcom_scm_set_remote_state(TZBSP_VIDEO_RESUME, 0);
> +		else
> +			venus_reset_hw(core);
> +		break;
> +	default:
> +		dev_err(dev, "invalid state\n");
> +		break;
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(venus_set_hw_state);
> +

regards,
Stan
