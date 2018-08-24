Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:39997 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727702AbeHXLMs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 07:12:48 -0400
Received: by mail-io0-f193.google.com with SMTP id l14-v6so6418909iob.7
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 00:39:23 -0700 (PDT)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com. [209.85.223.170])
        by smtp.gmail.com with ESMTPSA id w8-v6sm334781itb.0.2018.08.24.00.39.21
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Aug 2018 00:39:21 -0700 (PDT)
Received: by mail-io0-f170.google.com with SMTP id l14-v6so6418846iob.7
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 00:39:21 -0700 (PDT)
MIME-Version: 1.0
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org> <1535034528-11590-5-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1535034528-11590-5-git-send-email-vgarodia@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 24 Aug 2018 16:39:09 +0900
Message-ID: <CAPBb6MW8uN5_ghxx7h3g0TjmULUpvNSDn8g=trTC5fOegHP1QQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] venus: firmware: register separate platform_device
 for firmware loader
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
> From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>
> This registers a firmware platform_device and associate it with
> video-firmware DT subnode. Then calls dma configure to initialize
> dma and iommu.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  .../devicetree/bindings/media/qcom,venus.txt       | 13 +++++-
>  drivers/media/platform/qcom/venus/core.c           | 14 +++++--
>  drivers/media/platform/qcom/venus/firmware.c       | 49 ++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/firmware.h       |  2 +
>  4 files changed, 73 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
> index 00d0d1b..7e04586 100644
> --- a/Documentation/devicetree/bindings/media/qcom,venus.txt
> +++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
> @@ -53,7 +53,7 @@
>
>  * Subnodes
>  The Venus video-codec node must contain two subnodes representing
> -video-decoder and video-encoder.
> +video-decoder and video-encoder, and one optional firmware subnode.

Just noticed that the document does not explain in which case the
firmware subnode must be used. Maybe we should have a sentence
explaining that without it we will be using TrustZone to load the
firmware?

>
>  Every of video-encoder or video-decoder subnode should have:
>
> @@ -79,6 +79,13 @@ Every of video-encoder or video-decoder subnode should have:
>                     power domain which is responsible for collapsing
>                     and restoring power to the subcore.
>
> +The firmware subnode must have:
> +
> +- iommus:
> +       Usage: required
> +       Value type: <prop-encoded-array>
> +       Definition: A list of phandle and IOMMU specifier pairs.
> +
>  * An Example
>         video-codec@1d00000 {
>                 compatible = "qcom,msm8916-venus";
> @@ -105,4 +112,8 @@ Every of video-encoder or video-decoder subnode should have:
>                         clock-names = "core";
>                         power-domains = <&mmcc VENUS_CORE1_GDSC>;
>                 };
> +
> +               video-firmware {
> +                       iommus = <&apps_iommu 0x10b2 0x0>;
> +               };
>         };
> diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
> index 393994e..3bd3b8a 100644
> --- a/drivers/media/platform/qcom/venus/core.c
> +++ b/drivers/media/platform/qcom/venus/core.c
> @@ -284,6 +284,14 @@ static int venus_probe(struct platform_device *pdev)
>         if (ret < 0)
>                 goto err_runtime_disable;
>
> +       ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
> +       if (ret)
> +               goto err_runtime_disable;
> +
> +       ret = venus_firmware_init(core);
> +       if (ret)
> +               goto err_runtime_disable;
> +
>         ret = venus_boot(core);
>         if (ret)
>                 goto err_runtime_disable;
> @@ -308,10 +316,6 @@ static int venus_probe(struct platform_device *pdev)
>         if (ret)
>                 goto err_core_deinit;
>
> -       ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
> -       if (ret)
> -               goto err_dev_unregister;
> -
>         ret = pm_runtime_put_sync(dev);
>         if (ret)
>                 goto err_dev_unregister;
> @@ -347,6 +351,8 @@ static int venus_remove(struct platform_device *pdev)
>         venus_shutdown(core);
>         of_platform_depopulate(dev);
>
> +       venus_firmware_deinit(core);
> +
>         pm_runtime_put_sync(dev);
>         pm_runtime_disable(dev);
>
> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
> index 79b3858..86a26fb 100644
> --- a/drivers/media/platform/qcom/venus/firmware.c
> +++ b/drivers/media/platform/qcom/venus/firmware.c
> @@ -20,6 +20,7 @@
>  #include <linux/of.h>
>  #include <linux/of_address.h>
>  #include <linux/platform_device.h>
> +#include <linux/of_device.h>
>  #include <linux/qcom_scm.h>
>  #include <linux/sizes.h>
>  #include <linux/soc/qcom/mdt_loader.h>
> @@ -228,3 +229,51 @@ int venus_shutdown(struct venus_core *core)
>
>         return ret;
>  }
> +
> +int venus_firmware_init(struct venus_core *core)
> +{
> +       struct platform_device_info info;
> +       struct platform_device *pdev;
> +       struct device_node *np;
> +       int ret;
> +
> +       np = of_get_child_by_name(core->dev->of_node, "video-firmware");
> +       if (!np)
> +               return 0;
> +
> +       memset(&info, 0, sizeof(info));
> +       info.fwnode = &np->fwnode;
> +       info.parent = core->dev;
> +       info.name = np->name;
> +       info.dma_mask = DMA_BIT_MASK(32);
> +
> +       pdev = platform_device_register_full(&info);
> +       if (IS_ERR(pdev)) {
> +               of_node_put(np);
> +               return PTR_ERR(pdev);
> +       }
> +
> +       pdev->dev.of_node = np;
> +
> +       ret = of_dma_configure(&pdev->dev, np);
> +       if (ret)
> +               dev_err(core->dev, "dma configure fail\n");
> +
> +       of_node_put(np);
> +
> +       if (ret)
> +               return ret;
> +
> +       core->no_tz = true;
> +       core->fw.dev = &pdev->dev;
> +
> +       return 0;
> +}
> +
> +void venus_firmware_deinit(struct venus_core *core)
> +{
> +       if (!core->fw.dev)
> +               return;
> +
> +       platform_device_unregister(to_platform_device(core->fw.dev));
> +}
> diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
> index f41b615..119a9a4 100644
> --- a/drivers/media/platform/qcom/venus/firmware.h
> +++ b/drivers/media/platform/qcom/venus/firmware.h
> @@ -16,6 +16,8 @@
>
>  struct device;
>
> +int venus_firmware_init(struct venus_core *core);
> +void venus_firmware_deinit(struct venus_core *core);
>  int venus_boot(struct venus_core *core);
>  int venus_shutdown(struct venus_core *core);
>  int venus_set_hw_state(struct venus_core *core, bool suspend);
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
