Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:35409 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751789AbeEXGMA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 02:12:00 -0400
Received: by mail-vk0-f67.google.com with SMTP id g72-v6so283172vke.2
        for <linux-media@vger.kernel.org>; Wed, 23 May 2018 23:12:00 -0700 (PDT)
Received: from mail-vk0-f49.google.com (mail-vk0-f49.google.com. [209.85.213.49])
        by smtp.gmail.com with ESMTPSA id x187-v6sm6243765vkx.19.2018.05.23.23.11.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 May 2018 23:11:58 -0700 (PDT)
Received: by mail-vk0-f49.google.com with SMTP id m144-v6so281822vke.4
        for <linux-media@vger.kernel.org>; Wed, 23 May 2018 23:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org> <20180515075859.17217-12-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-12-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 24 May 2018 15:11:46 +0900
Message-ID: <CAAFQd5BDZztVT5KT_HX8SfPuHRmXaEg2VGVCOabWqL7F9Qq6Ew@mail.gmail.com>
Subject: Re: [PATCH v2 11/29] venus: venc,vdec: adds clocks needed for venus 4xx
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

Hi Stanimir,

On Tue, May 15, 2018 at 5:10 PM Stanimir Varbanov <
stanimir.varbanov@linaro.org> wrote:

> This extends the clocks number to support suspend and resume
> on Venus version 4xx.

> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>   drivers/media/platform/qcom/venus/core.h |  4 +--
>   drivers/media/platform/qcom/venus/vdec.c | 42
++++++++++++++++++++++++++------
>   drivers/media/platform/qcom/venus/venc.c | 42
++++++++++++++++++++++++++------
>   3 files changed, 72 insertions(+), 16 deletions(-)

> diff --git a/drivers/media/platform/qcom/venus/core.h
b/drivers/media/platform/qcom/venus/core.h
> index 8d3e150800c9..b5b9a84e9155 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -92,8 +92,8 @@ struct venus_core {
>          void __iomem *base;
>          int irq;
>          struct clk *clks[VIDC_CLKS_NUM_MAX];
> -       struct clk *core0_clk;
> -       struct clk *core1_clk;
> +       struct clk *core0_clk, *core0_bus_clk;
> +       struct clk *core1_clk, *core1_bus_clk;
>          struct video_device *vdev_dec;
>          struct video_device *vdev_enc;
>          struct v4l2_device v4l2_dev;
> diff --git a/drivers/media/platform/qcom/venus/vdec.c
b/drivers/media/platform/qcom/venus/vdec.c
> index 261a51adeef2..c45452634e7e 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -1081,12 +1081,18 @@ static int vdec_probe(struct platform_device
*pdev)
>          if (!core)
>                  return -EPROBE_DEFER;

> -       if (core->res->hfi_version == HFI_VERSION_3XX) {
> +       if (IS_V3(core) || IS_V4(core)) {
>                  core->core0_clk = devm_clk_get(dev, "core");
>                  if (IS_ERR(core->core0_clk))
>                          return PTR_ERR(core->core0_clk);
>          }

> +       if (IS_V4(core)) {
> +               core->core0_bus_clk = devm_clk_get(dev, "bus");
> +               if (IS_ERR(core->core0_bus_clk))
> +                       return PTR_ERR(core->core0_bus_clk);
> +       }
> +

Rather than doing this conditional dance, wouldn't it make more sense to
just list all the clocks in variant data struct and use clk_bulk_get()?

>          platform_set_drvdata(pdev, core);

>          vdev = video_device_alloc();
> @@ -1132,12 +1138,23 @@ static __maybe_unused int
vdec_runtime_suspend(struct device *dev)
>   {
>          struct venus_core *core = dev_get_drvdata(dev);

> -       if (core->res->hfi_version == HFI_VERSION_1XX)
> +       if (IS_V1(core))
>                  return 0;

> -       writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> +       if (IS_V3(core))
> +               writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> +       else if (IS_V4(core))
> +               writel(0, core->base +
WRAPPER_VCODEC0_MMCC_POWER_CONTROL);
> +
> +       if (IS_V4(core))
> +               clk_disable_unprepare(core->core0_bus_clk);
> +
>          clk_disable_unprepare(core->core0_clk);
> -       writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> +
> +       if (IS_V3(core))
> +               writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> +       else if (IS_V4(core))
> +               writel(1, core->base +
WRAPPER_VCODEC0_MMCC_POWER_CONTROL);

Almost every step here differs between version. I'd suggest splitting this
into separate functions for both versions.


>          return 0;
>   }
> @@ -1147,12 +1164,23 @@ static __maybe_unused int
vdec_runtime_resume(struct device *dev)
>          struct venus_core *core = dev_get_drvdata(dev);
>          int ret;

> -       if (core->res->hfi_version == HFI_VERSION_1XX)
> +       if (IS_V1(core))
>                  return 0;

> -       writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> +       if (IS_V3(core))
> +               writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> +       else if (IS_V4(core))
> +               writel(0, core->base +
WRAPPER_VCODEC0_MMCC_POWER_CONTROL);
> +
>          ret = clk_prepare_enable(core->core0_clk);
> -       writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> +
> +       if (IS_V4(core))
> +               ret |= clk_prepare_enable(core->core0_bus_clk);

Please don't OR error codes. If both calls end up with different errors,
the resulting value would be meaningless.

> +
> +       if (IS_V3(core))
> +               writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> +       else if (IS_V4(core))
> +               writel(1, core->base +
WRAPPER_VCODEC0_MMCC_POWER_CONTROL);

>          return ret;
>   }

Same for this function. I'd see separate function for each version.

> diff --git a/drivers/media/platform/qcom/venus/venc.c
b/drivers/media/platform/qcom/venus/venc.c
> index 947001170a77..bc8c2e7a8d2c 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -1225,12 +1225,18 @@ static int venc_probe(struct platform_device
*pdev)
>          if (!core)
>                  return -EPROBE_DEFER;

> -       if (core->res->hfi_version == HFI_VERSION_3XX) {
> +       if (IS_V3(core) || IS_V4(core)) {
>                  core->core1_clk = devm_clk_get(dev, "core");
>                  if (IS_ERR(core->core1_clk))
>                          return PTR_ERR(core->core1_clk);
>          }

> +       if (IS_V4(core)) {
> +               core->core1_bus_clk = devm_clk_get(dev, "bus");
> +               if (IS_ERR(core->core1_bus_clk))
> +                       return PTR_ERR(core->core1_bus_clk);
> +       }
> +

Same as for corresponding function of vdec.

>          platform_set_drvdata(pdev, core);

>          vdev = video_device_alloc();
> @@ -1276,12 +1282,23 @@ static __maybe_unused int
venc_runtime_suspend(struct device *dev)
>   {
>          struct venus_core *core = dev_get_drvdata(dev);

> -       if (core->res->hfi_version == HFI_VERSION_1XX)
> +       if (IS_V1(core))
>                  return 0;

> -       writel(0, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
> +       if (IS_V3(core))
> +               writel(0, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
> +       else if (IS_V4(core))
> +               writel(0, core->base +
WRAPPER_VCODEC1_MMCC_POWER_CONTROL);
> +
> +       if (IS_V4(core))
> +               clk_disable_unprepare(core->core1_bus_clk);
> +
>          clk_disable_unprepare(core->core1_clk);
> -       writel(1, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
> +
> +       if (IS_V3(core))
> +               writel(1, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
> +       else if (IS_V4(core))
> +               writel(1, core->base +
WRAPPER_VCODEC1_MMCC_POWER_CONTROL);

>          return 0;
>   }

Same as for vdec.

> @@ -1291,12 +1308,23 @@ static __maybe_unused int
venc_runtime_resume(struct device *dev)
>          struct venus_core *core = dev_get_drvdata(dev);
>          int ret;

> -       if (core->res->hfi_version == HFI_VERSION_1XX)
> +       if (IS_V1(core))
>                  return 0;

> -       writel(0, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
> +       if (IS_V3(core))
> +               writel(0, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
> +       else if (IS_V4(core))
> +               writel(0, core->base +
WRAPPER_VCODEC1_MMCC_POWER_CONTROL);
> +
>          ret = clk_prepare_enable(core->core1_clk);
> -       writel(1, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
> +
> +       if (IS_V4(core))
> +               ret |= clk_prepare_enable(core->core1_bus_clk);
> +
> +       if (IS_V3(core))
> +               writel(1, core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL);
> +       else if (IS_V4(core))
> +               writel(1, core->base +
WRAPPER_VCODEC1_MMCC_POWER_CONTROL);

>          return ret;
>   }

Same as for vdec.

Best regards,
Tomasz
