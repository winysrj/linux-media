Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:41040 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753825AbeEaGu1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 02:50:27 -0400
Received: by mail-ua0-f195.google.com with SMTP id a3-v6so14290143uad.8
        for <linux-media@vger.kernel.org>; Wed, 30 May 2018 23:50:26 -0700 (PDT)
Received: from mail-vk0-f51.google.com (mail-vk0-f51.google.com. [209.85.213.51])
        by smtp.gmail.com with ESMTPSA id k196-v6sm784474vkk.56.2018.05.30.23.50.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 May 2018 23:50:25 -0700 (PDT)
Received: by mail-vk0-f51.google.com with SMTP id o138-v6so2594103vkd.3
        for <linux-media@vger.kernel.org>; Wed, 30 May 2018 23:50:25 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-12-stanimir.varbanov@linaro.org> <CAAFQd5BDZztVT5KT_HX8SfPuHRmXaEg2VGVCOabWqL7F9Qq6Ew@mail.gmail.com>
 <3a892dd5-0744-c289-e258-099d531d5abd@linaro.org>
In-Reply-To: <3a892dd5-0744-c289-e258-099d531d5abd@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 31 May 2018 15:50:13 +0900
Message-ID: <CAAFQd5CiBcmOVPJX1x6yWUuHky6WdjSrJDMG8c_uzkbF1ud=uQ@mail.gmail.com>
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

On Mon, May 28, 2018 at 5:47 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Tomasz,
>
> On 05/24/2018 09:11 AM, Tomasz Figa wrote:
> > Hi Stanimir,
> >
> > On Tue, May 15, 2018 at 5:10 PM Stanimir Varbanov <
> > stanimir.varbanov@linaro.org> wrote:
> >
> >> This extends the clocks number to support suspend and resume
> >> on Venus version 4xx.
> >
> >> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> >> ---
> >>   drivers/media/platform/qcom/venus/core.h |  4 +--
> >>   drivers/media/platform/qcom/venus/vdec.c | 42
> > ++++++++++++++++++++++++++------
> >>   drivers/media/platform/qcom/venus/venc.c | 42
> > ++++++++++++++++++++++++++------
> >>   3 files changed, 72 insertions(+), 16 deletions(-)
> >
> >> diff --git a/drivers/media/platform/qcom/venus/core.h
> > b/drivers/media/platform/qcom/venus/core.h
> >> index 8d3e150800c9..b5b9a84e9155 100644
> >> --- a/drivers/media/platform/qcom/venus/core.h
> >> +++ b/drivers/media/platform/qcom/venus/core.h
> >> @@ -92,8 +92,8 @@ struct venus_core {
> >>          void __iomem *base;
> >>          int irq;
> >>          struct clk *clks[VIDC_CLKS_NUM_MAX];
> >> -       struct clk *core0_clk;
> >> -       struct clk *core1_clk;
> >> +       struct clk *core0_clk, *core0_bus_clk;
> >> +       struct clk *core1_clk, *core1_bus_clk;
> >>          struct video_device *vdev_dec;
> >>          struct video_device *vdev_enc;
> >>          struct v4l2_device v4l2_dev;
> >> diff --git a/drivers/media/platform/qcom/venus/vdec.c
> > b/drivers/media/platform/qcom/venus/vdec.c
> >> index 261a51adeef2..c45452634e7e 100644
> >> --- a/drivers/media/platform/qcom/venus/vdec.c
> >> +++ b/drivers/media/platform/qcom/venus/vdec.c
> >> @@ -1081,12 +1081,18 @@ static int vdec_probe(struct platform_device
> > *pdev)
> >>          if (!core)
> >>                  return -EPROBE_DEFER;
> >
> >> -       if (core->res->hfi_version == HFI_VERSION_3XX) {
> >> +       if (IS_V3(core) || IS_V4(core)) {
> >>                  core->core0_clk = devm_clk_get(dev, "core");
> >>                  if (IS_ERR(core->core0_clk))
> >>                          return PTR_ERR(core->core0_clk);
> >>          }
> >
> >> +       if (IS_V4(core)) {
> >> +               core->core0_bus_clk = devm_clk_get(dev, "bus");
> >> +               if (IS_ERR(core->core0_bus_clk))
> >> +                       return PTR_ERR(core->core0_bus_clk);
> >> +       }
> >> +
> >
> > Rather than doing this conditional dance, wouldn't it make more sense to
> > just list all the clocks in variant data struct and use clk_bulk_get()?
>
> Do you mean the same as it is done for venus/core.c ?

I mean clk_bulk_get() as in drivers/clk/clk-bulk.c. I guess
venus/core.c would also benefit from switching to these helpers.

>
> >
> >>          platform_set_drvdata(pdev, core);
> >
> >>          vdev = video_device_alloc();
> >> @@ -1132,12 +1138,23 @@ static __maybe_unused int
> > vdec_runtime_suspend(struct device *dev)
> >>   {
> >>          struct venus_core *core = dev_get_drvdata(dev);
> >
> >> -       if (core->res->hfi_version == HFI_VERSION_1XX)
> >> +       if (IS_V1(core))
> >>                  return 0;
> >
> >> -       writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> >> +       if (IS_V3(core))
> >> +               writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> >> +       else if (IS_V4(core))
> >> +               writel(0, core->base +
> > WRAPPER_VCODEC0_MMCC_POWER_CONTROL);
> >> +
> >> +       if (IS_V4(core))
> >> +               clk_disable_unprepare(core->core0_bus_clk);
> >> +
> >>          clk_disable_unprepare(core->core0_clk);
> >> -       writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> >> +
> >> +       if (IS_V3(core))
> >> +               writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> >> +       else if (IS_V4(core))
> >> +               writel(1, core->base +
> > WRAPPER_VCODEC0_MMCC_POWER_CONTROL);
> >
> > Almost every step here differs between version. I'd suggest splitting this
> > into separate functions for both versions.
>
> I think it will be better to squash this patch with 13/29.

I see. Let me review patch 13 first then.

Best regards,
Tomasz
