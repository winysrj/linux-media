Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36363 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753292AbcKNREN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 12:04:13 -0500
Date: Mon, 14 Nov 2016 11:04:10 -0600
From: Rob Herring <robh@kernel.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/9] doc: DT: vidc: binding document for Qualcomm
 video driver
Message-ID: <20161114170410.56izii5gcwpofvc4@rob-hp-laptop>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
 <1478540043-24558-2-git-send-email-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478540043-24558-2-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 07, 2016 at 07:33:55PM +0200, Stanimir Varbanov wrote:
> Add binding document for Venus video encoder/decoder driver
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  .../devicetree/bindings/media/qcom,venus.txt       | 98 ++++++++++++++++++++++
>  1 file changed, 98 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/qcom,venus.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
> new file mode 100644
> index 000000000000..b2af347fbce4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
> @@ -0,0 +1,98 @@
> +* Qualcomm Venus video encode/decode accelerator
> +
> +- compatible:
> +	Usage: required
> +	Value type: <stringlist>
> +	Definition: Value should contain one of:
> +		- "qcom,venus-msm8916"
> +		- "qcom,venus-msm8996"

The normal ordering is <vendor>,<soc>-<block>

> +- reg:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: Register ranges as listed in the reg-names property.
> +- reg-names:
> +	Usage: required
> +	Value type: <stringlist>
> +	Definition: Should contain following entries:
> +		- "venus"	Venus register base
> +- reg-names:

I'd prefer these grouped as one entry for reg-names.

> +	Usage: optional for msm8996

Why optional?

> +	Value type: <stringlist>
> +	Definition: Should contain following entries:
> +		- "vmem"	Video memory register base
> +- interrupts:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: Should contain interrupts as listed in the interrupt-names
> +		    property.
> +- interrupt-names:
> +	Usage: required
> +	Value type: <stringlist>
> +	Definition: Should contain following entries:
> +		- "venus"	Venus interrupt line
> +- interrupt-names:
> +	Usage: optional for msm8996
> +	Value type: <stringlist>
> +	Definition: Should contain following entries:
> +		- "vmem"	Video memory interrupt line
> +- clocks:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: A List of phandle and clock specifier pairs as listed
> +		    in clock-names property.
> +- clock-names:
> +	Usage: required
> +	Value type: <stringlist>
> +	Definition: Should contain the following entries:
> +		- "core"	Core video accelerator clock
> +		- "iface"	Video accelerator AHB clock
> +		- "bus"		Video accelerator AXI clock
> +- clock-names:
> +	Usage: required for msm8996

Plus the 3 above?

> +	Value type: <stringlist>
> +	Definition: Should contain the following entries:
> +		- "subcore0"		Subcore0 video accelerator clock
> +		- "subcore1"		Subcore1 video accelerator clock
> +		- "mmssnoc_axi"		Multimedia subsystem NOC AXI clock
> +		- "mmss_mmagic_iface"	Multimedia subsystem MMAGIC AHB clock
> +		- "mmss_mmagic_mbus"	Multimedia subsystem MMAGIC MAXI clock
> +		- "mmagic_video_bus"	MMAGIC video AXI clock
> +		- "video_mbus"		Video MAXI clock
> +- clock-names:
> +	Usage: optional for msm8996

Clocks shouldn't be optional unless you failed to add in an initial 
binding.

> +	Value type: <stringlist>
> +	Definition: Should contain the following entries:
> +		- "vmem_bus"	Video memory MAXI clock
> +		- "vmem_iface"	Video memory AHB clock
> +- power-domains:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: A phandle and power domain specifier pairs to the
> +		    power domain which is responsible for collapsing
> +		    and restoring power to the peripheral.
> +- rproc:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: A phandle to remote processor responsible for
> +		    firmware loading and processor booting.
> +
> +- iommus:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: A list of phandle and IOMMU specifier pairs.
> +
> +* An Example
> +	video-codec@1d00000 {
> +		compatible = "qcom,venus-msm8916";
> +		reg = <0x01d00000 0xff000>;
> +		reg-names = "venus";
> +		interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
> +		interrupt-names = "venus";
> +		clocks = <&gcc GCC_VENUS0_VCODEC0_CLK>,
> +			 <&gcc GCC_VENUS0_AHB_CLK>,
> +			 <&gcc GCC_VENUS0_AXI_CLK>;
> +		clock-names = "core", "iface", "bus";
> +		power-domains = <&gcc VENUS_GDSC>;
> +		rproc = <&venus_rproc>;
> +		iommus = <&apps_iommu 5>;
> +	};
> -- 
> 2.7.4
> 
