Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41384 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbeFAVcl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 17:32:41 -0400
Date: Fri, 1 Jun 2018 15:32:36 -0600
From: Jordan Crouse <jcrouse@codeaurora.org>
To: Vikash Garodia <vgarodia@codeaurora.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org
Subject: Re: [PATCH v2 5/5] venus: register separate driver for firmware
 device
Message-ID: <20180601213236.GG11565@jcrouse-lnx.qualcomm.com>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-6-git-send-email-vgarodia@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527884768-22392-6-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 02, 2018 at 01:56:08AM +0530, Vikash Garodia wrote:
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
>  		    power domain which is responsible for collapsing
>  		    and restoring power to the subcore.
>  
> +The firmware sub node must contain the iommus specifiers for ARM9.
> +
>  * An Example
>  	video-codec@1d00000 {
>  		compatible = "qcom,msm8916-venus";
> @@ -105,4 +107,8 @@ Every of video-encoder or video-decoder subnode should have:
>  			clock-names = "core";
>  			power-domains = <&mmcc VENUS_CORE1_GDSC>;
>  		};
> +		venus-firmware {
> +			compatible = "qcom,venus-firmware-no-tz";
> +			iommus = <&apps_smmu 0x10b2 0x0>;
> +		}
>  	};
> diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
> index 101612b..5cfb3c2 100644
> --- a/drivers/media/platform/qcom/venus/core.c
> +++ b/drivers/media/platform/qcom/venus/core.c
> @@ -179,6 +179,19 @@ static u32 to_v4l2_codec_type(u32 codec)
>  	}
>  }
>  
> +static int store_firmware_dev(struct device *dev, void *data)
> +{
> +	struct venus_core *core = data;
> +
> +	if (!core)
> +		return -EINVAL;

Core is not going to be null here - you don't need to check it.

<snip>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
