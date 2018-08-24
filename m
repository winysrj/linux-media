Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36109 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbeHXLMl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 07:12:41 -0400
Received: by mail-it0-f68.google.com with SMTP id p16-v6so951458itp.1
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 00:39:17 -0700 (PDT)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com. [209.85.223.171])
        by smtp.gmail.com with ESMTPSA id t4-v6sm2525805iof.55.2018.08.24.00.39.15
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Aug 2018 00:39:15 -0700 (PDT)
Received: by mail-io0-f171.google.com with SMTP id q5-v6so3200505iop.3
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 00:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org> <1535034528-11590-3-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1535034528-11590-3-git-send-email-vgarodia@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 24 Aug 2018 16:39:03 +0900
Message-ID: <CAPBb6MXydrrfbWOps-xV4eRzgN6n6pT45B2C=H5tuF2pZOesZQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/4] venus: firmware: move load firmware in a separate function
To: vgarodia@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, robh@kernel.org,
        mark.rutland@arm.com, Andy Gross <andy.gross@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 23, 2018 at 11:29 PM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> Separate firmware loading part into a new function.
>
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/core.c     |  4 +-
>  drivers/media/platform/qcom/venus/firmware.c | 55 ++++++++++++++++++----------
>  drivers/media/platform/qcom/venus/firmware.h |  2 +-
>  3 files changed, 38 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
> index bb6add9..75b9785 100644
> --- a/drivers/media/platform/qcom/venus/core.c
> +++ b/drivers/media/platform/qcom/venus/core.c
> @@ -84,7 +84,7 @@ static void venus_sys_error_handler(struct work_struct *work)
>
>         pm_runtime_get_sync(core->dev);
>
> -       ret |= venus_boot(core->dev, core->res->fwname);
> +       ret |= venus_boot(core);
>
>         ret |= hfi_core_resume(core, true);
>
> @@ -284,7 +284,7 @@ static int venus_probe(struct platform_device *pdev)
>         if (ret < 0)
>                 goto err_runtime_disable;
>
> -       ret = venus_boot(dev, core->res->fwname);
> +       ret = venus_boot(core);
>         if (ret)
>                 goto err_runtime_disable;
>
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index a9d042e..34224eb 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -60,20 +60,18 @@ int venus_set_hw_state(struct venus_core *core, bool resume)
>         return 0;
>  }
>
> -int venus_boot(struct device *dev, const char *fwname)
> +static int venus_load_fw(struct venus_core *core, const char *fwname,
> +                        phys_addr_t *mem_phys, size_t *mem_size)

Following the remarks of the previous patch, you would have mem_phys
and mem_size as members of venus_core (probably renamed as fw_mem_addr
and fw_mem_size).

>  {
>         const struct firmware *mdt;
>         struct device_node *node;
> -       phys_addr_t mem_phys;
> +       struct device *dev;
>         struct resource r;
>         ssize_t fw_size;
> -       size_t mem_size;
>         void *mem_va;
>         int ret;
>
> -       if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER) || !qcom_scm_is_available())
> -               return -EPROBE_DEFER;

!IS_ENABLED(CONFIG_QCOM_MDT_LOADER) is not a condition that can change
at runtime, and returning -EPROBE_DEFER in that case seems erroneous
to me. Instead, wouldn't it make more sense to make the driver depend
on QCOM_MDT_LOADER?

> -
> +       dev = core->dev;
>         node = of_parse_phandle(dev->of_node, "memory-region", 0);
>         if (!node) {
>                 dev_err(dev, "no memory-region specified\n");
> @@ -84,16 +82,16 @@ int venus_boot(struct device *dev, const char *fwname)
>         if (ret)
>                 return ret;
>
> -       mem_phys = r.start;
> -       mem_size = resource_size(&r);
> +       *mem_phys = r.start;
> +       *mem_size = resource_size(&r);
>
> -       if (mem_size < VENUS_FW_MEM_SIZE)
> +       if (*mem_size < VENUS_FW_MEM_SIZE)
>                 return -EINVAL;
>
> -       mem_va = memremap(r.start, mem_size, MEMREMAP_WC);
> +       mem_va = memremap(r.start, *mem_size, MEMREMAP_WC);
>         if (!mem_va) {
>                 dev_err(dev, "unable to map memory region: %pa+%zx\n",
> -                       &r.start, mem_size);
> +                       &r.start, *mem_size);
>                 return -ENOMEM;
>         }
>
> @@ -108,23 +106,40 @@ int venus_boot(struct device *dev, const char *fwname)
>                 goto err_unmap;
>         }
>
> -       ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va, mem_phys,
> -                           mem_size, NULL);
> +       if (core->no_tz)
> +               ret = qcom_mdt_load_no_init(dev, mdt, fwname, VENUS_PAS_ID,
> +                                           mem_va, *mem_phys, *mem_size, NULL);
> +       else
> +               ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID,
> +                                   mem_va, *mem_phys, *mem_size, NULL);
>
>         release_firmware(mdt);
>
> -       if (ret)
> -               goto err_unmap;
> -
> -       ret = qcom_scm_pas_auth_and_reset(VENUS_PAS_ID);
> -       if (ret)
> -               goto err_unmap;
> -
>  err_unmap:
>         memunmap(mem_va);
>         return ret;
>  }
>
> +int venus_boot(struct venus_core *core)
> +{
> +       struct device *dev = core->dev;
> +       phys_addr_t mem_phys;
> +       size_t mem_size;
> +       int ret;
> +
> +       if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER) ||
> +           (!core->no_tz && !qcom_scm_is_available()))
> +               return -EPROBE_DEFER;

Same remark as above here.
