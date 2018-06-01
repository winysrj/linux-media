Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:44991 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751354AbeFAWQD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 18:16:03 -0400
Received: by mail-wr0-f195.google.com with SMTP id y15-v6so37606061wrg.11
        for <linux-media@vger.kernel.org>; Fri, 01 Jun 2018 15:16:02 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] media: venus: add a routine to reset ARM9
To: Vikash Garodia <vgarodia@codeaurora.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, robh@kernel.org, mark.rutland@arm.com,
        andy.gross@linaro.org, bjorn.andersson@linaro.org,
        stanimir.varbanov@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-2-git-send-email-vgarodia@codeaurora.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <894ab678-bc1d-da04-b552-d53301bd3980@linaro.org>
Date: Sat, 2 Jun 2018 01:15:59 +0300
MIME-Version: 1.0
In-Reply-To: <1527884768-22392-2-git-send-email-vgarodia@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On  1.06.2018 23:26, Vikash Garodia wrote:
> Add a new routine to reset the ARM9 and brings it
> out of reset. This is in preparation to add PIL
> functionality in venus driver.

please squash this patch with 4/5. I don't see a reason to add a 
function which is not used. Shouldn't this produce gcc warnings?

> 
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>   drivers/media/platform/qcom/venus/firmware.c     | 26 ++++++++++++++++++++++++
>   drivers/media/platform/qcom/venus/hfi_venus_io.h |  5 +++++
>   2 files changed, 31 insertions(+)
> 
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index 521d4b3..7d89b5a 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -14,6 +14,7 @@
>   
>   #include <linux/device.h>
>   #include <linux/firmware.h>
> +#include <linux/delay.h>
>   #include <linux/kernel.h>
>   #include <linux/io.h>
>   #include <linux/of.h>
> @@ -22,11 +23,36 @@
>   #include <linux/sizes.h>
>   #include <linux/soc/qcom/mdt_loader.h>
>   
> +#include "core.h"
>   #include "firmware.h"
> +#include "hfi_venus_io.h"
>   
>   #define VENUS_PAS_ID			9
>   #define VENUS_FW_MEM_SIZE		(6 * SZ_1M)
>   
> +static void venus_reset_hw(struct venus_core *core)

can we rename this to venus_reset_cpu? reset_hw sounds like we reset 
vcodec IPs, so I think we can be more exact here.

> +{
> +	void __iomem *reg_base = core->base;

just 'base', please.

> +
> +	writel(0, reg_base + WRAPPER_FW_START_ADDR);
> +	writel(VENUS_FW_MEM_SIZE, reg_base + WRAPPER_FW_END_ADDR);
> +	writel(0, reg_base + WRAPPER_CPA_START_ADDR);
> +	writel(VENUS_FW_MEM_SIZE, reg_base + WRAPPER_CPA_END_ADDR);
> +	writel(0x0, reg_base + WRAPPER_CPU_CGC_DIS);
> +	writel(0x0, reg_base + WRAPPER_CPU_CLOCK_CONFIG);
> +
> +	/* Make sure all register writes are committed. */
> +	mb();

the comment says "register writes" hence shouldn't this be wmb? Also if 
we are going to have explicit memory barrier why not use writel_relaxed?

> +
> +	/*
> +	 * Need to wait 10 cycles of internal clocks before bringing ARM9

Do we know what is the minimum frequency of the internal ARM9 clocks? 
I.e does 1us is enough for all venus versions.

> +	 * out of reset.
> +	 */
> +	udelay(1);
> +
> +	/* Bring Arm9 out of reset */

ARM9

> +	writel_relaxed(0, reg_base + WRAPPER_A9SS_SW_RESET);

in my opinion we should have a wmb here too

regards,
Stan
