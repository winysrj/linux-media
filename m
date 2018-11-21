Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33620 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbeKURIZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 12:08:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 21 Nov 2018 12:05:13 +0530
From: Sibi Sankar <sibis@codeaurora.org>
To: Malathi Gottam <mgottam@codeaurora.org>
Cc: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        acourbot@chromium.org, vgarodia@codeaurora.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: sdm845: add video nodes
In-Reply-To: <1542708506-12680-1-git-send-email-mgottam@codeaurora.org>
References: <1542708506-12680-1-git-send-email-mgottam@codeaurora.org>
Message-ID: <81d44fc3504854220ef7926bc6f0b580@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malathi,

On 2018-11-20 15:38, Malathi Gottam wrote:
> This adds video nodes to sdm845 based on the examples
> in the bindings.
> 
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  arch/arm64/boot/dts/qcom/sdm845.dtsi | 34 
> ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> index 0c9a2aa..d82487d 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> @@ -84,6 +84,10 @@
>  			reg = <0 0x86200000 0 0x2d00000>;
>  			no-map;
>  		};
> +		venus_region: venus@95800000 {
> +			reg = <0x0 0x95800000 0x0 0x500000>;
> +			no-map;
> +		};

nit: Please make this venus_region: memory@95800000
instead and add a new line before venus_region.

>  	};
> 
>  	cpus {
> @@ -1103,5 +1107,35 @@
>  				status = "disabled";
>  			};
>  		};
> +
> +		video-codec@aa00000 {
> +			compatible = "qcom,sdm845-venus";
> +			reg = <0x0aa00000 0xff000>;
> +			interrupts = <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>;
> +			power-domains = <&videocc VENUS_GDSC>;
> +			clocks = <&videocc VIDEO_CC_VENUS_CTL_CORE_CLK>,
> +				 <&videocc VIDEO_CC_VENUS_AHB_CLK>,
> +				 <&videocc VIDEO_CC_VENUS_CTL_AXI_CLK>;
> +			clock-names = "core", "iface", "bus";
> +			iommus = <&apps_smmu 0x10a0 0x8>,
> +				 <&apps_smmu 0x10b0 0x0>;
> +			memory-region = <&venus_region>;
> +
> +			video-core0 {
> +				compatible = "venus-decoder";
> +				clocks = <&videocc VIDEO_CC_VCODEC0_CORE_CLK>,
> +					 <&videocc VIDEO_CC_VCODEC0_AXI_CLK>;
> +				clock-names = "core", "bus";
> +				power-domains = <&videocc VCODEC0_GDSC>;
> +			};
> +
> +			video-core1 {
> +				compatible = "venus-encoder";
> +				clocks = <&videocc VIDEO_CC_VCODEC1_CORE_CLK>,
> +					 <&videocc VIDEO_CC_VCODEC1_AXI_CLK>;
> +				clock-names = "core", "bus";
> +				power-domains = <&videocc VCODEC1_GDSC>;
> +			};
> +		};
>  	};
>  };

-- 
-- Sibi Sankar --
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project.
