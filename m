Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:42793 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753277AbeFDNSs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 09:18:48 -0400
Received: by mail-ua0-f194.google.com with SMTP id x18-v6so15328196uaj.9
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 06:18:47 -0700 (PDT)
Received: from mail-ua0-f173.google.com (mail-ua0-f173.google.com. [209.85.217.173])
        by smtp.gmail.com with ESMTPSA id n134-v6sm4069456vkf.7.2018.06.04.06.18.46
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Jun 2018 06:18:46 -0700 (PDT)
Received: by mail-ua0-f173.google.com with SMTP id m21-v6so754134uan.0
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 06:18:46 -0700 (PDT)
MIME-Version: 1.0
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org> <1527884768-22392-6-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1527884768-22392-6-git-send-email-vgarodia@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 4 Jun 2018 22:18:34 +0900
Message-ID: <CAAFQd5D39CkA=GucUs7YOHwsdj0gbk55BiY_gSvArY_RH4uDkg@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] venus: register separate driver for firmware device
To: vgarodia@codeaurora.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, andy.gross@linaro.org,
        bjorn.andersson@linaro.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On Sat, Jun 2, 2018 at 5:27 AM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> A separate child device is added for video firmware.
> This is needed to
> [1] configure the firmware context bank with the desired SID.
> [2] ensure that the iova for firmware region is from 0x0.
>
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  .../devicetree/bindings/media/qcom,venus.txt       |  8 +++-
>  drivers/media/platform/qcom/venus/core.c           | 48 +++++++++++++++++++---
>  drivers/media/platform/qcom/venus/firmware.c       | 20 ++++++++-
>  drivers/media/platform/qcom/venus/firmware.h       |  2 +
>  4 files changed, 71 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
> index 00d0d1b..701cbe8 100644
> --- a/Documentation/devicetree/bindings/media/qcom,venus.txt
> +++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
> @@ -53,7 +53,7 @@
>
>  * Subnodes
>  The Venus video-codec node must contain two subnodes representing
> -video-decoder and video-encoder.
> +video-decoder and video-encoder, one optional firmware subnode.
>
>  Every of video-encoder or video-decoder subnode should have:
>
> @@ -79,6 +79,8 @@ Every of video-encoder or video-decoder subnode should have:
>                     power domain which is responsible for collapsing
>                     and restoring power to the subcore.
>
> +The firmware sub node must contain the iommus specifiers for ARM9.

Please document the compatible string here as well.

> +
>  * An Example
>         video-codec@1d00000 {
>                 compatible = "qcom,msm8916-venus";
> @@ -105,4 +107,8 @@ Every of video-encoder or video-decoder subnode should have:
>                         clock-names = "core";
>                         power-domains = <&mmcc VENUS_CORE1_GDSC>;
>                 };
> +               venus-firmware {
> +                       compatible = "qcom,venus-firmware-no-tz";

I don't think "-no-tz" should be mentioned here in DT, since it's a
firmware/software detail.

> +                       iommus = <&apps_smmu 0x10b2 0x0>;
> +               }
>         };
> diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
> index 101612b..5cfb3c2 100644
> --- a/drivers/media/platform/qcom/venus/core.c
> +++ b/drivers/media/platform/qcom/venus/core.c
> @@ -179,6 +179,19 @@ static u32 to_v4l2_codec_type(u32 codec)
>         }
>  }
>
> +static int store_firmware_dev(struct device *dev, void *data)
> +{
> +       struct venus_core *core = data;
> +
> +       if (!core)
> +               return -EINVAL;
> +

No need to check this AFAICT.

> +       if (of_device_is_compatible(dev->of_node, "qcom,venus-firmware-no-tz"))
> +               core->fw.dev = dev;
> +
> +       return 0;
> +}
> +
>  static int venus_enumerate_codecs(struct venus_core *core, u32 type)
>  {
>         const struct hfi_inst_ops dummy_ops = {};
> @@ -279,6 +292,13 @@ static int venus_probe(struct platform_device *pdev)
>         if (ret < 0)
>                 goto err_runtime_disable;
>
> +       ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
> +       if (ret)
> +               goto err_runtime_disable;
> +
> +       /* Attempt to store firmware device */
> +       device_for_each_child(dev, core, store_firmware_dev);
> +
>         ret = venus_boot(core);
>         if (ret)
>                 goto err_runtime_disable;
> @@ -303,10 +323,6 @@ static int venus_probe(struct platform_device *pdev)
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
> @@ -483,7 +499,29 @@ static __maybe_unused int venus_runtime_resume(struct device *dev)
>                 .pm = &venus_pm_ops,
>         },
>  };
> -module_platform_driver(qcom_venus_driver);
> +
> +static int __init venus_init(void)
> +{
> +       int ret;
> +
> +       ret = platform_driver_register(&qcom_video_firmware_driver);
> +       if (ret)
> +               return ret;

Do we really need this firmware driver? As far as I can see, the
approach used here should work even without any driver bound to the
firmware device.

Best regards,
Tomasz
