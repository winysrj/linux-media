Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36611 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751922AbeGBOBV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 10:01:21 -0400
Received: by mail-wm0-f67.google.com with SMTP id s14-v6so1775203wmc.1
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 07:01:20 -0700 (PDT)
Subject: Re: [PATCH v4 11/27] venus: core,helpers: add two more clocks found
 in Venus 4xx
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org,
        Tomasz Figa <tfiga@chromium.org>
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
 <20180627152725.9783-12-stanimir.varbanov@linaro.org>
 <CAPBb6MVToYzWhmbjU-M6g2CjwMzWyF97k2WqcUBFA+zTq6uhdg@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <e5b99cec-6401-32ee-57d2-7feafaaa5a11@linaro.org>
Date: Mon, 2 Jul 2018 17:01:17 +0300
MIME-Version: 1.0
In-Reply-To: <CAPBb6MVToYzWhmbjU-M6g2CjwMzWyF97k2WqcUBFA+zTq6uhdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

Thanks for the review!

On 07/02/2018 11:45 AM, Alexandre Courbot wrote:
> On Thu, Jun 28, 2018 at 12:34 AM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> Add two more clocks for Venus 4xx in core structure and create
>> a new power enable function to handle it for 3xx/4xx versions.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/core.h    |  4 +++
>>  drivers/media/platform/qcom/venus/helpers.c | 51 +++++++++++++++++++++++++++++
>>  drivers/media/platform/qcom/venus/helpers.h |  2 ++
>>  drivers/media/platform/qcom/venus/vdec.c    | 44 ++++++++++++++++++++-----
>>  drivers/media/platform/qcom/venus/venc.c    | 44 ++++++++++++++++++++-----
>>  5 files changed, 129 insertions(+), 16 deletions(-)
>>

<snip>

>> @@ -1131,15 +1137,21 @@ static int vdec_remove(struct platform_device *pdev)
>>  static __maybe_unused int vdec_runtime_suspend(struct device *dev)
>>  {
>>         struct venus_core *core = dev_get_drvdata(dev);
>> +       int ret;
>>
>> -       if (core->res->hfi_version == HFI_VERSION_1XX)
>> +       if (IS_V1(core))
>>                 return 0;
>>
>> -       writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
>> +       ret = venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, true);
>> +
>> +       if (IS_V4(core))
>> +               clk_disable_unprepare(core->core0_bus_clk);
>> +
>>         clk_disable_unprepare(core->core0_clk);
>> -       writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
>>
>> -       return 0;
>> +       ret |= venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, false);
> 
> Is it safe to OR two potentially different error messages, at the risk
> of getting a third one that is different?

venus_helper_power_enable can return zero or ETIMEDOUT, but ...

> 
> If venus_helper_power_enable() fails, shouldn't we just exit early and
> signify that the suspend operation failed?
> 

I had the same comment from Tomasz, hence maybe I'm wrong :) so I will
re-work that and will exit early if error.

-- 
regards,
Stan
