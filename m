Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36514 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757357AbcIPOTp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 10:19:45 -0400
Date: Fri, 16 Sep 2016 09:19:39 -0500
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
Subject: Re: [PATCH v2 1/8] doc: DT: vidc: binding document for Qualcomm
 video driver
Message-ID: <20160916141939.GA2320@rob-hp-laptop>
References: <1473248229-5540-1-git-send-email-stanimir.varbanov@linaro.org>
 <1473248229-5540-2-git-send-email-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473248229-5540-2-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 07, 2016 at 02:37:02PM +0300, Stanimir Varbanov wrote:
> Adds binding document for vidc video encoder/decoder driver
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  .../devicetree/bindings/media/qcom,vidc.txt        | 61 ++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/qcom,vidc.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/qcom,vidc.txt b/Documentation/devicetree/bindings/media/qcom,vidc.txt
> new file mode 100644
> index 000000000000..0d50a7b2e3ed
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/qcom,vidc.txt
> @@ -0,0 +1,61 @@
> +* Qualcomm video encoder/decoder accelerator
> +
> +- compatible:
> +	Usage: required
> +	Value type: <stringlist>
> +	Definition: Value should contain

... one of:

> +			- "qcom,vidc-msm8916"
> +			- "qcom,vidc-msm8996"
> +- reg:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: Register ranges as listed in the reg-names property
> +
> +- interrupts:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition:

How many interrupts?

> +
> +- power-domains:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: A phandle and power domain specifier pairs to the
> +		    power domain which is responsible for collapsing
> +		    and restoring power to the peripheral

How many power domains?

> +
> +- clocks:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: List of phandle and clock specifier pairs as listed
> +		    in clock-names property
> +- clock-names:
> +	Usage: required
> +	Value type: <stringlist>
> +	Definition: Should contain the following entries
> +			- "core"  Core video accelerator clock
> +			- "iface" Video accelerator AHB clock
> +			- "bus"	  Video accelerator AXI clock
> +- rproc:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: A phandle to remote processor responsible for
> +		    firmware loading
> +
> +- iommus:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: A list of phandle and IOMMU specifier pairs
> +
> +* An Example
> +	qcom,vidc@1d00000 {

node names should be generic: video-codec@

> +		compatible = "qcom,vidc-msm8916";
> +		reg = <0x01d00000 0xff000>;
> +		clocks = <&gcc GCC_VENUS0_VCODEC0_CLK>,
> +			 <&gcc GCC_VENUS0_AHB_CLK>,
> +			 <&gcc GCC_VENUS0_AXI_CLK>;
> +		clock-names = "core", "iface", "bus";
> +		interrupts = <GIC_SPI 44 0>;
> +		power-domains = <&gcc VENUS_GDSC>;
> +		rproc = <&vidc_rproc>;
> +		iommus = <&apps_iommu 5>;
> +	};
> -- 
> 2.7.4
> 
