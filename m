Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:50344 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754061AbeE1IrT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 04:47:19 -0400
Received: by mail-wm0-f66.google.com with SMTP id t11-v6so30106976wmt.0
        for <linux-media@vger.kernel.org>; Mon, 28 May 2018 01:47:18 -0700 (PDT)
Subject: Re: [PATCH v2 11/29] venus: venc,vdec: adds clocks needed for venus
 4xx
To: Tomasz Figa <tfiga@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-12-stanimir.varbanov@linaro.org>
 <CAAFQd5BDZztVT5KT_HX8SfPuHRmXaEg2VGVCOabWqL7F9Qq6Ew@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <3a892dd5-0744-c289-e258-099d531d5abd@linaro.org>
Date: Mon, 28 May 2018 11:47:15 +0300
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BDZztVT5KT_HX8SfPuHRmXaEg2VGVCOabWqL7F9Qq6Ew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 05/24/2018 09:11 AM, Tomasz Figa wrote:
> Hi Stanimir,
> 
> On Tue, May 15, 2018 at 5:10 PM Stanimir Varbanov <
> stanimir.varbanov@linaro.org> wrote:
> 
>> This extends the clocks number to support suspend and resume
>> on Venus version 4xx.
> 
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>   drivers/media/platform/qcom/venus/core.h |  4 +--
>>   drivers/media/platform/qcom/venus/vdec.c | 42
> ++++++++++++++++++++++++++------
>>   drivers/media/platform/qcom/venus/venc.c | 42
> ++++++++++++++++++++++++++------
>>   3 files changed, 72 insertions(+), 16 deletions(-)
> 
>> diff --git a/drivers/media/platform/qcom/venus/core.h
> b/drivers/media/platform/qcom/venus/core.h
>> index 8d3e150800c9..b5b9a84e9155 100644
>> --- a/drivers/media/platform/qcom/venus/core.h
>> +++ b/drivers/media/platform/qcom/venus/core.h
>> @@ -92,8 +92,8 @@ struct venus_core {
>>          void __iomem *base;
>>          int irq;
>>          struct clk *clks[VIDC_CLKS_NUM_MAX];
>> -       struct clk *core0_clk;
>> -       struct clk *core1_clk;
>> +       struct clk *core0_clk, *core0_bus_clk;
>> +       struct clk *core1_clk, *core1_bus_clk;
>>          struct video_device *vdev_dec;
>>          struct video_device *vdev_enc;
>>          struct v4l2_device v4l2_dev;
>> diff --git a/drivers/media/platform/qcom/venus/vdec.c
> b/drivers/media/platform/qcom/venus/vdec.c
>> index 261a51adeef2..c45452634e7e 100644
>> --- a/drivers/media/platform/qcom/venus/vdec.c
>> +++ b/drivers/media/platform/qcom/venus/vdec.c
>> @@ -1081,12 +1081,18 @@ static int vdec_probe(struct platform_device
> *pdev)
>>          if (!core)
>>                  return -EPROBE_DEFER;
> 
>> -       if (core->res->hfi_version == HFI_VERSION_3XX) {
>> +       if (IS_V3(core) || IS_V4(core)) {
>>                  core->core0_clk = devm_clk_get(dev, "core");
>>                  if (IS_ERR(core->core0_clk))
>>                          return PTR_ERR(core->core0_clk);
>>          }
> 
>> +       if (IS_V4(core)) {
>> +               core->core0_bus_clk = devm_clk_get(dev, "bus");
>> +               if (IS_ERR(core->core0_bus_clk))
>> +                       return PTR_ERR(core->core0_bus_clk);
>> +       }
>> +
> 
> Rather than doing this conditional dance, wouldn't it make more sense to
> just list all the clocks in variant data struct and use clk_bulk_get()?

Do you mean the same as it is done for venus/core.c ?

> 
>>          platform_set_drvdata(pdev, core);
> 
>>          vdev = video_device_alloc();
>> @@ -1132,12 +1138,23 @@ static __maybe_unused int
> vdec_runtime_suspend(struct device *dev)
>>   {
>>          struct venus_core *core = dev_get_drvdata(dev);
> 
>> -       if (core->res->hfi_version == HFI_VERSION_1XX)
>> +       if (IS_V1(core))
>>                  return 0;
> 
>> -       writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
>> +       if (IS_V3(core))
>> +               writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
>> +       else if (IS_V4(core))
>> +               writel(0, core->base +
> WRAPPER_VCODEC0_MMCC_POWER_CONTROL);
>> +
>> +       if (IS_V4(core))
>> +               clk_disable_unprepare(core->core0_bus_clk);
>> +
>>          clk_disable_unprepare(core->core0_clk);
>> -       writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
>> +
>> +       if (IS_V3(core))
>> +               writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
>> +       else if (IS_V4(core))
>> +               writel(1, core->base +
> WRAPPER_VCODEC0_MMCC_POWER_CONTROL);
> 
> Almost every step here differs between version. I'd suggest splitting this
> into separate functions for both versions.

I think it will be better to squash this patch with 13/29.


-- 
regards,
Stan
