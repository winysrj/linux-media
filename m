Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:36760 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753946AbeEaHeq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 03:34:46 -0400
Received: by mail-ua0-f196.google.com with SMTP id c23-v6so7822417uan.3
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 00:34:46 -0700 (PDT)
Received: from mail-vk0-f42.google.com (mail-vk0-f42.google.com. [209.85.213.42])
        by smtp.gmail.com with ESMTPSA id a9-v6sm7980514vke.23.2018.05.31.00.34.44
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 May 2018 00:34:44 -0700 (PDT)
Received: by mail-vk0-f42.google.com with SMTP id e67-v6so12738192vke.7
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 00:34:44 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org> <20180515075859.17217-14-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-14-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 31 May 2018 16:34:32 +0900
Message-ID: <CAAFQd5A=P_X1eVagw_wEvq+_9nDR5iVxFHxLk-fcSKA=SWCz1A@mail.gmail.com>
Subject: Re: [PATCH v2 13/29] venus: helpers: make a commmon function for power_enable
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

On Tue, May 15, 2018 at 5:06 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Make common function which will enable power when enabling/disabling
> clocks and also covers Venus 3xx/4xx versions.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 51 +++++++++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/helpers.h |  2 ++
>  drivers/media/platform/qcom/venus/vdec.c    | 25 ++++----------
>  drivers/media/platform/qcom/venus/venc.c    | 25 ++++----------
>  4 files changed, 67 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index d9065cc8a7d3..2b21f6ed7502 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -13,6 +13,7 @@
>   *
>   */
>  #include <linux/clk.h>
> +#include <linux/iopoll.h>
>  #include <linux/list.h>
>  #include <linux/mutex.h>
>  #include <linux/pm_runtime.h>
> @@ -24,6 +25,7 @@
>  #include "core.h"
>  #include "helpers.h"
>  #include "hfi_helper.h"
> +#include "hfi_venus_io.h"
>
>  struct intbuf {
>         struct list_head list;
> @@ -781,3 +783,52 @@ void venus_helper_init_instance(struct venus_inst *inst)
>         }
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_init_instance);
> +
> +int venus_helper_power_enable(struct venus_core *core, u32 session_type,
> +                             bool enable)
> +{
> +       void __iomem *ctrl, *stat;
> +       u32 val;
> +       int ret;
> +
> +       if (!IS_V3(core) && !IS_V4(core))
> +               return -EINVAL;
> +
> +       if (IS_V3(core)) {
> +               if (session_type == VIDC_SESSION_TYPE_DEC)
> +                       ctrl = core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL;
> +               else
> +                       ctrl = core->base + WRAPPER_VENC_VCODEC_POWER_CONTROL;
> +               if (enable)
> +                       writel(0, ctrl);
> +               else
> +                       writel(1, ctrl);

nit: The value written is just !enable, but no strong preference.

> +
> +               return 0;
> +       }
> +
> +       if (session_type == VIDC_SESSION_TYPE_DEC) {
> +               ctrl = core->base + WRAPPER_VCODEC0_MMCC_POWER_CONTROL;
> +               stat = core->base + WRAPPER_VCODEC0_MMCC_POWER_STATUS;
> +       } else {
> +               ctrl = core->base + WRAPPER_VCODEC1_MMCC_POWER_CONTROL;
> +               stat = core->base + WRAPPER_VCODEC1_MMCC_POWER_STATUS;
> +       }
> +
> +       if (enable) {
> +               writel(0, ctrl);
> +
> +               ret = readl_poll_timeout(stat, val, val & BIT(1), 1, 100);
> +               if (ret)
> +                       return ret;
> +       } else {
> +               writel(1, ctrl);
> +
> +               ret = readl_poll_timeout(stat, val, !(val & BIT(1)), 1, 100);
> +               if (ret)
> +                       return ret;
> +       }

nit: The if/else could be just folded into code like below, but no
strong preference:

writel(!enable, ctrl);
ret = readl_poll_timeout(stat, val, !!(val & BIT(1)) == enable, 1, 100);
if (ret)
        return ret;

> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(venus_helper_power_enable);
> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
> index 971392be5df5..0e64aa95624a 100644
> --- a/drivers/media/platform/qcom/venus/helpers.h
> +++ b/drivers/media/platform/qcom/venus/helpers.h
> @@ -43,4 +43,6 @@ int venus_helper_set_color_format(struct venus_inst *inst, u32 fmt);
>  void venus_helper_acquire_buf_ref(struct vb2_v4l2_buffer *vbuf);
>  void venus_helper_release_buf_ref(struct venus_inst *inst, unsigned int idx);
>  void venus_helper_init_instance(struct venus_inst *inst);
> +int venus_helper_power_enable(struct venus_core *core, u32 session_type,
> +                             bool enable);
>  #endif
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 3b38bd1241b0..2bd81de6328a 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -1123,26 +1123,21 @@ static int vdec_remove(struct platform_device *pdev)
>  static __maybe_unused int vdec_runtime_suspend(struct device *dev)
>  {
>         struct venus_core *core = dev_get_drvdata(dev);
> +       int ret;
>
>         if (IS_V1(core))
>                 return 0;
>
> -       if (IS_V3(core))
> -               writel(0, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> -       else if (IS_V4(core))
> -               writel(0, core->base + WRAPPER_VCODEC0_MMCC_POWER_CONTROL);
> +       ret = venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, true);
>
>         if (IS_V4(core))
>                 clk_disable_unprepare(core->core0_bus_clk);
>
>         clk_disable_unprepare(core->core0_clk);
>
> -       if (IS_V3(core))
> -               writel(1, core->base + WRAPPER_VDEC_VCODEC_POWER_CONTROL);
> -       else if (IS_V4(core))
> -               writel(1, core->base + WRAPPER_VCODEC0_MMCC_POWER_CONTROL);
> +       ret |= venus_helper_power_enable(core, VIDC_SESSION_TYPE_DEC, false);

If both calls return different error codes, the value of ret would
become garbage. (Same for rest of the patch.)

Best regards,
Tomasz
