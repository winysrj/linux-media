Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:45078 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeERPPJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 11:15:09 -0400
Received: by mail-vk0-f65.google.com with SMTP id n134-v6so5015228vke.12
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 08:15:09 -0700 (PDT)
Received: from mail-vk0-f43.google.com (mail-vk0-f43.google.com. [209.85.213.43])
        by smtp.gmail.com with ESMTPSA id 79-v6sm2627735ual.3.2018.05.18.08.15.07
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 May 2018 08:15:07 -0700 (PDT)
Received: by mail-vk0-f43.google.com with SMTP id 131-v6so5030195vkf.8
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 08:15:07 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org> <20180515075859.17217-9-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-9-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Sat, 19 May 2018 00:14:54 +0900
Message-ID: <CAAFQd5AtfQL3-xz6MPSDOuXkJoZaVYU4PECJL0VOZjqYRoV-wQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/29] venus: hfi_venus: fix suspend function for venus
 3xx versions
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 15, 2018 at 5:11 PM Stanimir Varbanov <
stanimir.varbanov@linaro.org> wrote:

> This fixes the suspend function for Venus 3xx versions by
> add a check for WFI (wait for interrupt) bit. This bit
> is on when the ARM9 is idle and entered in low power mode.

> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>   drivers/media/platform/qcom/venus/hfi_venus.c    | 59
++++++++++++++++--------
>   drivers/media/platform/qcom/venus/hfi_venus_io.h |  1 +
>   2 files changed, 41 insertions(+), 19 deletions(-)

> diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c
b/drivers/media/platform/qcom/venus/hfi_venus.c
> index 53546174aab8..aac351f699a0 100644
> --- a/drivers/media/platform/qcom/venus/hfi_venus.c
> +++ b/drivers/media/platform/qcom/venus/hfi_venus.c
> @@ -1447,7 +1447,7 @@ static int venus_suspend_3xx(struct venus_core
*core)
>   {
>          struct venus_hfi_device *hdev = to_hfi_priv(core);
>          struct device *dev = core->dev;
> -       u32 ctrl_status, wfi_status;
> +       u32 ctrl_status, cpu_status;
>          int ret;
>          int cnt = 100;

> @@ -1463,29 +1463,50 @@ static int venus_suspend_3xx(struct venus_core
*core)
>                  return -EINVAL;
>          }

> -       ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
> -       if (!(ctrl_status & CPU_CS_SCIACMDARG0_PC_READY)) {
> -               wfi_status = venus_readl(hdev, WRAPPER_CPU_STATUS);
> +       /*
> +        * Power collapse sequence for Venus 3xx and 4xx versions:
> +        * 1. Check for ARM9 and video core to be idle by checking WFI bit
> +        *    (bit 0) in CPU status register and by checking Idle (bit
30) in
> +        *    Control status register for video core.
> +        * 2. Send a command to prepare for power collapse.
> +        * 3. Check for WFI and PC_READY bits.
> +        */
> +
> +       while (--cnt) {
> +               cpu_status = venus_readl(hdev, WRAPPER_CPU_STATUS);
>                  ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);

> -               ret = venus_prepare_power_collapse(hdev, false);
> -               if (ret) {
> -                       dev_err(dev, "prepare for power collapse fail
(%d)\n",
> -                               ret);
> -                       return ret;
> -               }
> +               if (cpu_status & WRAPPER_CPU_STATUS_WFI &&
> +                   ctrl_status & CPU_CS_SCIACMDARG0_INIT_IDLE_MSG_MASK)
> +                       break;

> -               cnt = 100;
> -               while (cnt--) {
> -                       wfi_status = venus_readl(hdev,
WRAPPER_CPU_STATUS);
> -                       ctrl_status = venus_readl(hdev,
CPU_CS_SCIACMDARG0);
> -                       if (ctrl_status & CPU_CS_SCIACMDARG0_PC_READY &&
> -                           wfi_status & BIT(0))
> -                               break;
> -                       usleep_range(1000, 1500);
> -               }
> +               usleep_range(1000, 1500);
>          }

To avoid opencoding the polling, I'd suggest doing a readx_poll_timeout()
trick:

static bool venus_arm9_and_video_core_idle(struct venus_hfi_device *hdev)
{
         // Read both registers and return true if both have the right bits
set
}

static int venus_suspend_3xx(struct venus_core *core)
{
         bool val;
         int ret;
         // ...
         ret = readx_poll_timeout(venus_arm9_and_video_core_idle, hdev, val,
val, 1500, 100 * 1500);
         if (ret)
                 return ret;
         // ...
}


> +       if (!cnt)
> +               return -ETIMEDOUT;
> +
> +       ret = venus_prepare_power_collapse(hdev, false);
> +       if (ret) {
> +               dev_err(dev, "prepare for power collapse fail (%d)\n",
ret);
> +               return ret;
> +       }
> +
> +       cnt = 100;
> +       while (--cnt) {
> +               cpu_status = venus_readl(hdev, WRAPPER_CPU_STATUS);
> +               ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
> +
> +               if (cpu_status & WRAPPER_CPU_STATUS_WFI &&
> +                   ctrl_status & CPU_CS_SCIACMDARG0_PC_READY)
> +                       break;
> +
> +               usleep_range(1000, 1500);
> +       }
> +
> +       if (!cnt)
> +               return -ETIMEDOUT;

Same readx_poll_timeout() trick can be used here, with different helper
function, e.g. venus_arm9_idle_and_pc_ready().

Best regards,
Tomasz
