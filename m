Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:53965 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754579AbdDDPpt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Apr 2017 11:45:49 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Rob Herring <robh@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>
Subject: Re: [PATCH v2 1/8] dt-bindings: Document STM32 DCMI bindings
Date: Tue, 4 Apr 2017 15:45:17 +0000
Message-ID: <6e0b4d39-50de-3f0e-3702-3bbd462473c3@st.com>
References: <1490887667-8880-1-git-send-email-hugues.fruchet@st.com>
 <1490887667-8880-2-git-send-email-hugues.fruchet@st.com>
 <20170403162309.eikbsmfbxw6admdc@rob-hp-laptop>
In-Reply-To: <20170403162309.eikbsmfbxw6admdc@rob-hp-laptop>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <10FBBF3E65F02F40AE0C0977BDBCDA9E@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Rob for review, find answers below.

On 04/03/2017 06:23 PM, Rob Herring wrote:
> On Thu, Mar 30, 2017 at 05:27:40PM +0200, Hugues Fruchet wrote:
>> This adds documentation of device tree bindings for the STM32 DCMI
>> (Digital Camera Memory Interface).
>>
>> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
>> ---
>>  .../devicetree/bindings/media/st,stm32-dcmi.txt    | 85 ++++++++++++++++++++++
>>  1 file changed, 85 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/st,stm32-dcmi.txt b/Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
>> new file mode 100644
>> index 0000000..8180f63
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
>> @@ -0,0 +1,85 @@
>> +STMicroelectronics STM32 Digital Camera Memory Interface (DCMI)
>> +
>> +Required properties:
>> +- compatible: "st,stm32-dcmi"
>
> Same block and same errata on all stm32 variants?

Yes, it is the same IP block on all stm32 variants.

>
>> +- reg: physical base address and length of the registers set for the device
>> +- interrupts: should contain IRQ line for the DCMI
>> +- clocks: list of clock specifiers, corresponding to entries in
>> +          the clock-names property
>> +- clock-names: must contain "mclk", which is the DCMI peripherial clock
>> +- resets: reference to a reset controller
>> +- reset-names: see Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
>> +
>> +DCMI supports a single port node with parallel bus. It should contain one
>> +'port' child node with child 'endpoint' node. Please refer to the bindings
>> +defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +Example:
>> +
>> +Device node example
>> +-------------------
>> +	dcmi: dcmi@50050000 {
>> +		compatible = "st,stm32-dcmi";
>> +		reg = <0x50050000 0x400>;
>> +		interrupts = <78>;
>> +		resets = <&rcc STM32F4_AHB2_RESET(DCMI)>;
>> +		clocks = <&rcc 0 STM32F4_AHB2_CLOCK(DCMI)>;
>> +		clock-names = "mclk";
>
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <&dcmi_pins>;
>
> Not documented.

Fixed in v3.

>
>> +		dmas = <&dma2 1 1 0x414 0x3>;
>> +		dma-names = "tx";
>
> Not documented.

Fixed in v3.

>
>> +		status = "disabled";
>
> Drop status from examples.

Fixed in v3.

>
>> +	};
>> +
>> +Board setup example
>
> Please don't split examples. That's just source level details and not
> part of the ABI.

Fixed in v3.

>
>> +-------------------
>> +This example is extracted from STM32F429-EVAL board devicetree.
>> +Please note that on this board, the camera sensor reset & power-down
>> +line level are inverted (so reset is active high and power-down is
>> +active low).
>> +
>> +/ {
>> +	[...]
>> +	clocks {
>> +		clk_ext_camera: clk-ext-camera {
>> +			#clock-cells = <0>;
>> +			compatible = "fixed-clock";
>> +			clock-frequency = <24000000>;
>> +		};
>> +	};
>> +	[...]
>> +};
>> +
>> +&dcmi {
>> +	status = "okay";
>> +
>> +	port {
>> +		dcmi_0: endpoint@0 {
>> +			remote-endpoint = <&ov2640_0>;
>> +			bus-width = <8>;
>> +			hsync-active = <0>;
>> +			vsync-active = <0>;
>> +			pclk-sample = <1>;
>> +		};
>> +	};
>> +};
>> +
>> +&i2c@1 {
>> +	[...]
>> +	ov2640: camera@30 {
>> +		compatible = "ovti,ov2640";
>> +		reg = <0x30>;
>> +		resetb-gpios = <&stmpegpio 2 GPIO_ACTIVE_HIGH>;
>> +		pwdn-gpios = <&stmpegpio 0 GPIO_ACTIVE_LOW>;
>> +		clocks = <&clk_ext_camera>;
>> +		clock-names = "xvclk";
>> +		status = "okay";
>> +
>> +		port {
>> +			ov2640_0: endpoint {
>> +				remote-endpoint = <&dcmi_0>;
>> +			};
>> +		};
>> +	};
>> +};
>> --
>> 1.9.1
>>
