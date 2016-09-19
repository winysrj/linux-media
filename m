Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37681 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755883AbcISKfe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 06:35:34 -0400
Subject: Re: [PATCH v2 7/8] media: vidc: add Makefiles and Kconfig files
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
 <1473248229-5540-8-git-send-email-stanimir.varbanov@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a07f0a70-1500-c6aa-b42d-dd97fe8d06cb@xs4all.nl>
Date: Mon, 19 Sep 2016 12:35:23 +0200
MIME-Version: 1.0
In-Reply-To: <1473248229-5540-8-git-send-email-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2016 01:37 PM, Stanimir Varbanov wrote:
> Makefile and Kconfig files to build the video codec driver.
> 
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/Kconfig       |  8 ++++++++
>  drivers/media/platform/qcom/Makefile      |  6 ++++++
>  drivers/media/platform/qcom/vidc/Makefile | 15 +++++++++++++++
>  3 files changed, 29 insertions(+)
>  create mode 100644 drivers/media/platform/qcom/Kconfig
>  create mode 100644 drivers/media/platform/qcom/Makefile
>  create mode 100644 drivers/media/platform/qcom/vidc/Makefile
> 
> diff --git a/drivers/media/platform/qcom/Kconfig b/drivers/media/platform/qcom/Kconfig
> new file mode 100644
> index 000000000000..4bad5c0f68e4
> --- /dev/null
> +++ b/drivers/media/platform/qcom/Kconfig
> @@ -0,0 +1,8 @@
> +comment "Qualcomm V4L2 drivers"
> +
> +menuconfig QCOM_VIDC
> +        tristate "Qualcomm V4L2 encoder/decoder driver"
> +        depends on ARCH_QCOM && VIDEO_V4L2
> +        depends on IOMMU_DMA
> +        depends on QCOM_VENUS_PIL
> +        select VIDEOBUF2_DMA_SG

If at all possible, please depend on COMPILE_TEST as well!

Also missing: a patch adding an entry to the MAINTAINERS file.

Regards,

	Hans

> diff --git a/drivers/media/platform/qcom/Makefile b/drivers/media/platform/qcom/Makefile
> new file mode 100644
> index 000000000000..150892f6533b
> --- /dev/null
> +++ b/drivers/media/platform/qcom/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for the QCOM spcific video device drivers
> +# based on V4L2.
> +#
> +
> +obj-$(CONFIG_QCOM_VIDC)     += vidc/
> diff --git a/drivers/media/platform/qcom/vidc/Makefile b/drivers/media/platform/qcom/vidc/Makefile
> new file mode 100644
> index 000000000000..f8b5f9a438ee
> --- /dev/null
> +++ b/drivers/media/platform/qcom/vidc/Makefile
> @@ -0,0 +1,15 @@
> +# Makefile for Qualcomm vidc driver
> +
> +vidc-objs += \
> +		core.o \
> +		helpers.o \
> +		vdec.o \
> +		vdec_ctrls.o \
> +		venc.o \
> +		venc_ctrls.o \
> +		hfi_venus.o \
> +		hfi_msgs.o \
> +		hfi_cmds.o \
> +		hfi.o \
> +
> +obj-$(CONFIG_QCOM_VIDC) += vidc.o

I recommend renaming the module to qcom-vidc. 'vidc' is too generic.

Regards,

	Hans

> 
