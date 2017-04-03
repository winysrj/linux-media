Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35936 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbdDCQXM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 12:23:12 -0400
Date: Mon, 3 Apr 2017 11:23:10 -0500
From: Rob Herring <robh@kernel.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
Subject: Re: [PATCH v2 1/8] dt-bindings: Document STM32 DCMI bindings
Message-ID: <20170403162309.eikbsmfbxw6admdc@rob-hp-laptop>
References: <1490887667-8880-1-git-send-email-hugues.fruchet@st.com>
 <1490887667-8880-2-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490887667-8880-2-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 30, 2017 at 05:27:40PM +0200, Hugues Fruchet wrote:
> This adds documentation of device tree bindings for the STM32 DCMI
> (Digital Camera Memory Interface).
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  .../devicetree/bindings/media/st,stm32-dcmi.txt    | 85 ++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/st,stm32-dcmi.txt b/Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
> new file mode 100644
> index 0000000..8180f63
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
> @@ -0,0 +1,85 @@
> +STMicroelectronics STM32 Digital Camera Memory Interface (DCMI)
> +
> +Required properties:
> +- compatible: "st,stm32-dcmi"

Same block and same errata on all stm32 variants?

> +- reg: physical base address and length of the registers set for the device
> +- interrupts: should contain IRQ line for the DCMI
> +- clocks: list of clock specifiers, corresponding to entries in
> +          the clock-names property
> +- clock-names: must contain "mclk", which is the DCMI peripherial clock
> +- resets: reference to a reset controller
> +- reset-names: see Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
> +
> +DCMI supports a single port node with parallel bus. It should contain one
> +'port' child node with child 'endpoint' node. Please refer to the bindings
> +defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +Device node example
> +-------------------
> +	dcmi: dcmi@50050000 {
> +		compatible = "st,stm32-dcmi";
> +		reg = <0x50050000 0x400>;
> +		interrupts = <78>;
> +		resets = <&rcc STM32F4_AHB2_RESET(DCMI)>;
> +		clocks = <&rcc 0 STM32F4_AHB2_CLOCK(DCMI)>;
> +		clock-names = "mclk";

> +		pinctrl-names = "default";
> +		pinctrl-0 = <&dcmi_pins>;

Not documented.

> +		dmas = <&dma2 1 1 0x414 0x3>;
> +		dma-names = "tx";

Not documented.

> +		status = "disabled";

Drop status from examples.

> +	};
> +
> +Board setup example

Please don't split examples. That's just source level details and not 
part of the ABI.

> +-------------------
> +This example is extracted from STM32F429-EVAL board devicetree.
> +Please note that on this board, the camera sensor reset & power-down
> +line level are inverted (so reset is active high and power-down is
> +active low).
> +
> +/ {
> +	[...]
> +	clocks {
> +		clk_ext_camera: clk-ext-camera {
> +			#clock-cells = <0>;
> +			compatible = "fixed-clock";
> +			clock-frequency = <24000000>;
> +		};
> +	};
> +	[...]
> +};
> +
> +&dcmi {
> +	status = "okay";
> +
> +	port {
> +		dcmi_0: endpoint@0 {
> +			remote-endpoint = <&ov2640_0>;
> +			bus-width = <8>;
> +			hsync-active = <0>;
> +			vsync-active = <0>;
> +			pclk-sample = <1>;
> +		};
> +	};
> +};
> +
> +&i2c@1 {
> +	[...]
> +	ov2640: camera@30 {
> +		compatible = "ovti,ov2640";
> +		reg = <0x30>;
> +		resetb-gpios = <&stmpegpio 2 GPIO_ACTIVE_HIGH>;
> +		pwdn-gpios = <&stmpegpio 0 GPIO_ACTIVE_LOW>;
> +		clocks = <&clk_ext_camera>;
> +		clock-names = "xvclk";
> +		status = "okay";
> +
> +		port {
> +			ov2640_0: endpoint {
> +				remote-endpoint = <&dcmi_0>;
> +			};
> +		};
> +	};
> +};
> -- 
> 1.9.1
> 
