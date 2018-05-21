Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:44984 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751065AbeEUMS5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 08:18:57 -0400
Received: by mail-wr0-f193.google.com with SMTP id y15-v6so15784405wrg.11
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 05:18:57 -0700 (PDT)
Subject: Re: [PATCH v2 08/29] venus: hfi_venus: fix suspend function for venus
 3xx versions
To: Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-9-stanimir.varbanov@linaro.org>
 <CAAFQd5AtfQL3-xz6MPSDOuXkJoZaVYU4PECJL0VOZjqYRoV-wQ@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <46683c10-bd18-b0f0-9b07-acc8cadb98a3@linaro.org>
Date: Mon, 21 May 2018 15:18:54 +0300
MIME-Version: 1.0
In-Reply-To: <CAAFQd5AtfQL3-xz6MPSDOuXkJoZaVYU4PECJL0VOZjqYRoV-wQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 05/18/2018 06:14 PM, Tomasz Figa wrote:
> On Tue, May 15, 2018 at 5:11 PM Stanimir Varbanov <
> stanimir.varbanov@linaro.org> wrote:
> 
>> This fixes the suspend function for Venus 3xx versions by
>> add a check for WFI (wait for interrupt) bit. This bit
>> is on when the ARM9 is idle and entered in low power mode.
> 
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>   drivers/media/platform/qcom/venus/hfi_venus.c    | 59
> ++++++++++++++++--------
>>   drivers/media/platform/qcom/venus/hfi_venus_io.h |  1 +
>>   2 files changed, 41 insertions(+), 19 deletions(-)
> 
>> diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c
> b/drivers/media/platform/qcom/venus/hfi_venus.c
>> index 53546174aab8..aac351f699a0 100644
>> --- a/drivers/media/platform/qcom/venus/hfi_venus.c
>> +++ b/drivers/media/platform/qcom/venus/hfi_venus.c
>> @@ -1447,7 +1447,7 @@ static int venus_suspend_3xx(struct venus_core
> *core)
>>   {
>>          struct venus_hfi_device *hdev = to_hfi_priv(core);
>>          struct device *dev = core->dev;
>> -       u32 ctrl_status, wfi_status;
>> +       u32 ctrl_status, cpu_status;
>>          int ret;
>>          int cnt = 100;
> 
>> @@ -1463,29 +1463,50 @@ static int venus_suspend_3xx(struct venus_core
> *core)
>>                  return -EINVAL;
>>          }
> 
>> -       ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
>> -       if (!(ctrl_status & CPU_CS_SCIACMDARG0_PC_READY)) {
>> -               wfi_status = venus_readl(hdev, WRAPPER_CPU_STATUS);
>> +       /*
>> +        * Power collapse sequence for Venus 3xx and 4xx versions:
>> +        * 1. Check for ARM9 and video core to be idle by checking WFI bit
>> +        *    (bit 0) in CPU status register and by checking Idle (bit
> 30) in
>> +        *    Control status register for video core.
>> +        * 2. Send a command to prepare for power collapse.
>> +        * 3. Check for WFI and PC_READY bits.
>> +        */
>> +
>> +       while (--cnt) {
>> +               cpu_status = venus_readl(hdev, WRAPPER_CPU_STATUS);
>>                  ctrl_status = venus_readl(hdev, CPU_CS_SCIACMDARG0);
> 
>> -               ret = venus_prepare_power_collapse(hdev, false);
>> -               if (ret) {
>> -                       dev_err(dev, "prepare for power collapse fail
> (%d)\n",
>> -                               ret);
>> -                       return ret;
>> -               }
>> +               if (cpu_status & WRAPPER_CPU_STATUS_WFI &&
>> +                   ctrl_status & CPU_CS_SCIACMDARG0_INIT_IDLE_MSG_MASK)
>> +                       break;
> 
>> -               cnt = 100;
>> -               while (cnt--) {
>> -                       wfi_status = venus_readl(hdev,
> WRAPPER_CPU_STATUS);
>> -                       ctrl_status = venus_readl(hdev,
> CPU_CS_SCIACMDARG0);
>> -                       if (ctrl_status & CPU_CS_SCIACMDARG0_PC_READY &&
>> -                           wfi_status & BIT(0))
>> -                               break;
>> -                       usleep_range(1000, 1500);
>> -               }
>> +               usleep_range(1000, 1500);
>>          }
> 
> To avoid opencoding the polling, I'd suggest doing a readx_poll_timeout()
> trick:

I like the idea, will try to rework that and use readx_poll_timeout.

<snip>

-- 
regards,
Stan
