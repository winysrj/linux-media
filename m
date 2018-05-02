Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34232 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbeEBGHD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2018 02:07:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 02 May 2018 11:37:02 +0530
From: vgarodia@codeaurora.org
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 08/28] venus: hfi_venus: add suspend function for 4xx
 version
In-Reply-To: <20180424124436.26955-9-stanimir.varbanov@linaro.org>
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
 <20180424124436.26955-9-stanimir.varbanov@linaro.org>
Message-ID: <8f26cd748f283043b32da05b39f29348@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Stanimir,

On 2018-04-24 18:14, Stanimir Varbanov wrote:
> This adds suspend (power collapse) function with slightly
> different order of calls comparing with Venus 3xx.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/hfi_venus.c | 52 
> +++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c
> b/drivers/media/platform/qcom/venus/hfi_venus.c
> index 53546174aab8..f61d34bf61b4 100644
> --- a/drivers/media/platform/qcom/venus/hfi_venus.c
> +++ b/drivers/media/platform/qcom/venus/hfi_venus.c
> @@ -1443,6 +1443,55 @@ static int venus_suspend_1xx(struct venus_core 
> *core)
>  	return 0;
>  }
> 
> +static int venus_suspend_4xx(struct venus_core *core)
> +{
> +	struct venus_hfi_device *hdev = to_hfi_priv(core);
> +	struct device *dev = core->dev;
> +	u32 val;
> +	int ret;
> +
> +	if (!hdev->power_enabled || hdev->suspended)
> +		return 0;
> +
> +	mutex_lock(&hdev->lock);
> +	ret = venus_is_valid_state(hdev);
> +	mutex_unlock(&hdev->lock);
> +
> +	if (!ret) {
> +		dev_err(dev, "bad state, cannot suspend\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = venus_prepare_power_collapse(hdev, false);
> +	if (ret) {
> +		dev_err(dev, "prepare for power collapse fail (%d)\n", ret);
> +		return ret;
> +	}
> +
> +	ret = readl_poll_timeout(core->base + CPU_CS_SCIACMDARG0, val,
> +				 val & CPU_CS_SCIACMDARG0_PC_READY,
> +				 POLL_INTERVAL_US, 100000);
> +	if (ret) {
> +		dev_err(dev, "Polling power collapse ready timed out\n");
> +		return ret;
> +	}
> +
> +	mutex_lock(&hdev->lock);
> +
> +	ret = venus_power_off(hdev);
> +	if (ret) {
> +		dev_err(dev, "venus_power_off (%d)\n", ret);
> +		mutex_unlock(&hdev->lock);
> +		return ret;
> +	}
> +
> +	hdev->suspended = true;
> +
> +	mutex_unlock(&hdev->lock);
> +
> +	return 0;
> +}
> +
>  static int venus_suspend_3xx(struct venus_core *core)
>  {
>  	struct venus_hfi_device *hdev = to_hfi_priv(core);
> @@ -1507,6 +1556,9 @@ static int venus_suspend(struct venus_core *core)
>  	if (core->res->hfi_version == HFI_VERSION_3XX)
>  		return venus_suspend_3xx(core);
> 
> +	if (core->res->hfi_version == HFI_VERSION_4XX)
> +		return venus_suspend_4xx(core);
> +
>  	return venus_suspend_1xx(core);
>  }

Let me brief on the power collapse sequence for Venus_4xx
1. Host checks for ARM9 and Video core to be idle.
    This can be done by checking for WFI bit (bit 0) in CPU status 
register for ARM9 and by checking bit 30 in Control status reg for video 
core/s.
2. Host then sends command to ARM9 to prepare for power collapse.
3. Host then checks for WFI bit and PC_READY bit before withdrawing 
going for power off.

As per this patch, host is preparing for power collapse without checking 
for #1.
Update the code to handle #3.

Thanks
Vikash
