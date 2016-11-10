Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46228 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932267AbcKJCEg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 21:04:36 -0500
Date: Wed, 9 Nov 2016 18:04:34 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 8/9] media: venus: add Makefiles and Kconfig files
Message-ID: <20161110020434.GE16026@codeaurora.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-9-git-send-email-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478540043-24558-9-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/07, Stanimir Varbanov wrote:
> diff --git a/drivers/media/platform/qcom/Kconfig b/drivers/media/platform/qcom/Kconfig
> new file mode 100644
> index 000000000000..bf4d2fcce924
> --- /dev/null
> +++ b/drivers/media/platform/qcom/Kconfig
> @@ -0,0 +1,7 @@
> +
> +menuconfig VIDEO_QCOM_VENUS
> +        tristate "Qualcomm Venus V4L2 encoder/decoder driver"
> +        depends on ARCH_QCOM && VIDEO_V4L2
> +        depends on IOMMU_DMA
> +        depends on QCOM_VENUS_PIL
> +        select VIDEOBUF2_DMA_SG

Can this have some help text?


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
