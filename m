Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43714 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbeJQQoX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 12:44:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id n1-v6so28669026wrt.10
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2018 01:49:42 -0700 (PDT)
Subject: Re: [PATCH v11 1/5] venus: firmware: add routine to reset ARM9
To: Vikash Garodia <vgarodia@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org
References: <1539005572-803-1-git-send-email-vgarodia@codeaurora.org>
 <1539005572-803-2-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <fffd5b1f-73b5-81d5-a95b-a2dc9db1961d@linaro.org>
Date: Wed, 17 Oct 2018 11:49:39 +0300
MIME-Version: 1.0
In-Reply-To: <1539005572-803-2-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On 10/08/2018 04:32 PM, Vikash Garodia wrote:
> Add routine to reset the ARM9 and brings it out of reset. Also
> abstract the Venus CPU state handling with a new function. This
> is in preparation to add PIL functionality in venus driver.
> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/core.h         |  2 ++
>  drivers/media/platform/qcom/venus/firmware.c     | 33 ++++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/firmware.h     | 11 ++++++++
>  drivers/media/platform/qcom/venus/hfi_venus.c    | 13 +++-------
>  drivers/media/platform/qcom/venus/hfi_venus_io.h |  7 +++++
>  5 files changed, 57 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> index 2f02365..385e309 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -98,6 +98,7 @@ struct venus_caps {
>   * @dev:		convenience struct device pointer
>   * @dev_dec:	convenience struct device pointer for decoder device
>   * @dev_enc:	convenience struct device pointer for encoder device
> + * @use_tz:	a flag that suggests presence of trustzone
>   * @lock:	a lock for this strucure
>   * @instances:	a list_head of all instances
>   * @insts_count:	num of instances
> @@ -129,6 +130,7 @@ struct venus_core {
>  	struct device *dev;
>  	struct device *dev_dec;
>  	struct device *dev_enc;
> +	bool use_tz;

could you make it unsigned? For more info please run checkpatch --strict.

I know that we have structure members of type bool already - that should
be fixed with follow-up patches, I guess.

-- 
regards,
Stan
