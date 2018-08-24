Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:51884 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbeHXLMo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 07:12:44 -0400
Received: by mail-it0-f65.google.com with SMTP id e14-v6so980314itf.1
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 00:39:20 -0700 (PDT)
Received: from mail-it0-f46.google.com (mail-it0-f46.google.com. [209.85.214.46])
        by smtp.gmail.com with ESMTPSA id 125-v6sm318126itm.29.2018.08.24.00.39.18
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Aug 2018 00:39:19 -0700 (PDT)
Received: by mail-it0-f46.google.com with SMTP id 139-v6so955383itf.0
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 00:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org> <1535034528-11590-4-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1535034528-11590-4-git-send-email-vgarodia@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 24 Aug 2018 16:39:06 +0900
Message-ID: <CAPBb6MV1jjksgbSaCuUcY_ZbjfGeK-GaQ_+OZ7LWUv4ehA3dGQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] venus: firmware: add no TZ boot and shutdown routine
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
> Video hardware is mainly comprised of vcodec subsystem and video
> control subsystem. Video control has ARM9 which executes the video
> firmware instructions whereas vcodec does the video frame processing.
> This change adds support to load the video firmware and bring ARM9
> out of reset for platforms which does not have trustzone.
>
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/core.c         |  6 +-
>  drivers/media/platform/qcom/venus/core.h         |  7 ++
>  drivers/media/platform/qcom/venus/firmware.c     | 90 +++++++++++++++++++++++-
>  drivers/media/platform/qcom/venus/firmware.h     |  2 +-
>  drivers/media/platform/qcom/venus/hfi_venus_io.h |  1 +
>  5 files changed, 99 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
> index 75b9785..393994e 100644
> --- a/drivers/media/platform/qcom/venus/core.c
> +++ b/drivers/media/platform/qcom/venus/core.c
> @@ -76,7 +76,7 @@ static void venus_sys_error_handler(struct work_struct *work)
>         hfi_core_deinit(core, true);
>         hfi_destroy(core);
>         mutex_lock(&core->lock);
> -       venus_shutdown(core->dev);
> +       venus_shutdown(core);
>
>         pm_runtime_put_sync(core->dev);
>
> @@ -323,7 +323,7 @@ static int venus_probe(struct platform_device *pdev)
>  err_core_deinit:
>         hfi_core_deinit(core, false);
>  err_venus_shutdown:
> -       venus_shutdown(dev);
> +       venus_shutdown(core);
>  err_runtime_disable:
>         pm_runtime_set_suspended(dev);
>         pm_runtime_disable(dev);
> @@ -344,7 +344,7 @@ static int venus_remove(struct platform_device *pdev)
>         WARN_ON(ret);
>
>         hfi_destroy(core);
> -       venus_shutdown(dev);
> +       venus_shutdown(core);
>         of_platform_depopulate(dev);
>
>         pm_runtime_put_sync(dev);
> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> index dfd5c10..b2cb359 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -81,6 +81,11 @@ struct venus_caps {
>         bool valid;     /* used only for Venus v1xx */
>  };
>
> +struct video_firmware {
> +       struct device *dev;
> +       struct iommu_domain *iommu_domain;
> +};
> +
>  /**
>   * struct venus_core - holds core parameters valid for all instances
>   *
> @@ -98,6 +103,7 @@ struct venus_caps {
>   * @dev:               convenience struct device pointer
>   * @dev_dec:   convenience struct device pointer for decoder device
>   * @dev_enc:   convenience struct device pointer for encoder device
> + * @fw:                a struct for venus firmware info
>   * @no_tz:     a flag that suggests presence of trustzone
>   * @lock:      a lock for this strucure
>   * @instances: a list_head of all instances
> @@ -130,6 +136,7 @@ struct venus_core {
>         struct device *dev;
>         struct device *dev_dec;
>         struct device *dev_enc;
> +       struct video_firmware fw;

Since struct video_firmware is only used here I think you can declare
it inline, i.e.

    struct {
        struct device *dev;
        struct iommu_domain *iommu_domain;
    } fw;

This structure is actually a good candidate to hold the firmware
memory area start address and size.

>         bool no_tz;
>         struct mutex lock;
>         struct list_head instances;
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index 34224eb..79b3858 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -15,9 +15,11 @@
>  #include <linux/device.h>
>  #include <linux/firmware.h>
>  #include <linux/kernel.h>
> +#include <linux/iommu.h>
>  #include <linux/io.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> +#include <linux/platform_device.h>
>  #include <linux/qcom_scm.h>
>  #include <linux/sizes.h>
>  #include <linux/soc/qcom/mdt_loader.h>
> @@ -120,6 +122,76 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
>         return ret;
>  }
>
> +static int venus_boot_no_tz(struct venus_core *core, phys_addr_t mem_phys,
> +                           size_t mem_size)

After moving the firmware address and size into venus_core you won't
need the last two arguments.

> +{
> +       struct iommu_domain *iommu_dom;
> +       struct device *dev;
> +       int ret;
> +
> +       dev = core->fw.dev;
> +       if (!dev)
> +               return -EPROBE_DEFER;
> +
> +       iommu_dom = iommu_domain_alloc(&platform_bus_type);
> +       if (!iommu_dom) {
> +               dev_err(dev, "Failed to allocate iommu domain\n");
> +               return -ENOMEM;
> +       }
> +
> +       ret = iommu_attach_device(iommu_dom, dev);
> +       if (ret) {
> +               dev_err(dev, "could not attach device\n");
> +               goto err_attach;
> +       }

I think like the above belongs more in venus_firmware_init()
(introduced in patch 4/4) than here. There is no reason to
detach/reattach the iommu if we stop the firmware.

> +
> +       ret = iommu_map(iommu_dom, VENUS_FW_START_ADDR, mem_phys, mem_size,
> +                       IOMMU_READ | IOMMU_WRITE | IOMMU_PRIV);
> +       if (ret) {
> +               dev_err(dev, "could not map video firmware region\n");
> +               goto err_map;
> +       }

Maybe this too?

> +
> +       core->fw.iommu_domain = iommu_dom;
> +       venus_reset_cpu(core);
> +
> +       return 0;
> +
> +err_map:
> +       iommu_detach_device(iommu_dom, dev);
> +err_attach:
> +       iommu_domain_free(iommu_dom);
> +       return ret;
> +}
> +
> +static int venus_shutdown_no_tz(struct venus_core *core)
> +{
> +       struct iommu_domain *iommu;
> +       size_t unmapped;
> +       u32 reg;
> +       struct device *dev = core->fw.dev;
> +       void __iomem *base = core->base;
> +
> +       /* Assert the reset to ARM9 */
> +       reg = readl_relaxed(base + WRAPPER_A9SS_SW_RESET);
> +       reg |= WRAPPER_A9SS_SW_RESET_BIT;
> +       writel_relaxed(reg, base + WRAPPER_A9SS_SW_RESET);
> +
> +       /* Make sure reset is asserted before the mapping is removed */
> +       mb();
> +
> +       iommu = core->fw.iommu_domain;
> +
> +       unmapped = iommu_unmap(iommu, VENUS_FW_START_ADDR, VENUS_FW_MEM_SIZE);
> +       if (unmapped != VENUS_FW_MEM_SIZE)
> +               dev_err(dev, "failed to unmap firmware\n");
> +
> +       iommu_detach_device(iommu, dev);
> +       iommu_domain_free(iommu);

Accordingly, this would also be moved into venus_firmware_deinit().
