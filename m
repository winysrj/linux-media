Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37313 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751926AbdHDLyZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Aug 2017 07:54:25 -0400
Received: by mail-wm0-f48.google.com with SMTP id t201so17917175wmt.0
        for <linux-media@vger.kernel.org>; Fri, 04 Aug 2017 04:54:24 -0700 (PDT)
Subject: Re: [PATCH v3 04/23] dt-bindings: media: Binding document for
 Qualcomm Camera subsystem driver
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
 <1500287629-23703-5-git-send-email-todor.tomov@linaro.org>
 <20170720101345.eovx5ovuxr7sqpea@valkosipuli.retiisi.org.uk>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <1dc5ab4d-5171-c6df-4300-2abcd0e5483b@linaro.org>
Date: Fri, 4 Aug 2017 14:54:21 +0300
MIME-Version: 1.0
In-Reply-To: <20170720101345.eovx5ovuxr7sqpea@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the review.

On 20.07.2017 13:13, Sakari Ailus wrote:
> Hi Todor,
> 
> On Mon, Jul 17, 2017 at 01:33:30PM +0300, Todor Tomov wrote:
>> Add DT binding document for Qualcomm Camera subsystem driver.
>>
>> CC: Rob Herring <robh+dt@kernel.org>
>> CC: devicetree@vger.kernel.org
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  .../devicetree/bindings/media/qcom,camss.txt       | 191 +++++++++++++++++++++
>>  1 file changed, 191 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/qcom,camss.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/qcom,camss.txt b/Documentation/devicetree/bindings/media/qcom,camss.txt
>> new file mode 100644
>> index 0000000..f698498
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/qcom,camss.txt
>> @@ -0,0 +1,191 @@
>> +Qualcomm Camera Subsystem
>> +
>> +* Properties
>> +
>> +- compatible:
>> +	Usage: required
>> +	Value type: <stringlist>
>> +	Definition: Should contain:
>> +		- "qcom,msm8916-camss"
>> +- reg:
>> +	Usage: required
>> +	Value type: <prop-encoded-array>
>> +	Definition: Register ranges as listed in the reg-names property.
>> +- reg-names:
>> +	Usage: required
>> +	Value type: <stringlist>
>> +	Definition: Should contain the following entries:
>> +		- "csiphy0"
>> +		- "csiphy0_clk_mux"
>> +		- "csiphy1"
>> +		- "csiphy1_clk_mux"
>> +		- "csid0"
>> +		- "csid1"
>> +		- "ispif"
>> +		- "csi_clk_mux"
>> +		- "vfe0"
>> +- interrupts:
>> +	Usage: required
>> +	Value type: <prop-encoded-array>
>> +	Definition: Interrupts as listed in the interrupt-names property.
>> +- interrupt-names:
>> +	Usage: required
>> +	Value type: <stringlist>
>> +	Definition: Should contain the following entries:
>> +		- "csiphy0"
>> +		- "csiphy1"
>> +		- "csid0"
>> +		- "csid1"
>> +		- "ispif"
>> +		- "vfe0"
>> +- power-domains:
>> +	Usage: required
>> +	Value type: <prop-encoded-array>
>> +	Definition: A phandle and power domain specifier pairs to the
>> +		    power domain which is responsible for collapsing
>> +		    and restoring power to the peripheral.
>> +- clocks:
>> +	Usage: required
>> +	Value type: <prop-encoded-array>
>> +	Definition: A list of phandle and clock specifier pairs as listed
>> +		    in clock-names property.
>> +- clock-names:
>> +	Usage: required
>> +	Value type: <stringlist>
>> +	Definition: Should contain the following entries:
>> +                - "camss_top_ahb"
>> +                - "ispif_ahb"
>> +                - "csiphy0_timer"
>> +                - "csiphy1_timer"
>> +                - "csi0_ahb"
>> +                - "csi0"
>> +                - "csi0_phy"
>> +                - "csi0_pix"
>> +                - "csi0_rdi"
>> +                - "csi1_ahb"
>> +                - "csi1"
>> +                - "csi1_phy"
>> +                - "csi1_pix"
>> +                - "csi1_rdi"
>> +                - "camss_ahb"
>> +                - "camss_vfe_vfe"
>> +                - "camss_csi_vfe"
>> +                - "iface"
>> +                - "bus"
>> +- vdda-supply:
>> +	Usage: required
>> +	Value type: <phandle>
>> +	Definition: A phandle to voltage supply for CSI2.
>> +- iommus:
>> +	Usage: required
>> +	Value type: <prop-encoded-array>
>> +	Definition: A list of phandle and IOMMU specifier pairs.
>> +
>> +* Nodes
>> +
>> +- ports:
>> +	Usage: required
>> +	Definition: As described in video-interfaces.txt in same directory.
>> +	Properties:
>> +		- reg:
>> +			Usage: required
>> +			Value type: <u32>
>> +			Definition: Selects CSI2 PHY interface - PHY0 or PHY1.
>> +	Endpoint node properties:
>> +		- clock-lanes:
>> +			Usage: required
>> +			Value type: <u32>
>> +			Definition: The clock lane.
>> +		- data-lanes:
>> +			Usage: required
>> +			Value type: <prop-encoded-array>
>> +			Definition: An array of data lanes.
>> +
>> +* An Example
>> +
>> +	camss: camss@1b00000 {
>> +		compatible = "qcom,msm8916-camss";
>> +		reg = <0x1b0ac00 0x200>,
>> +			<0x1b00030 0x4>,
>> +			<0x1b0b000 0x200>,
>> +			<0x1b00038 0x4>,
>> +			<0x1b08000 0x100>,
>> +			<0x1b08400 0x100>,
>> +			<0x1b0a000 0x500>,
>> +			<0x1b00020 0x10>,
>> +			<0x1b10000 0x1000>;
>> +		reg-names = "csiphy0",
>> +			"csiphy0_clk_mux",
>> +			"csiphy1",
>> +			"csiphy1_clk_mux",
>> +			"csid0",
>> +			"csid1",
>> +			"ispif",
>> +			"csi_clk_mux",
>> +			"vfe0";
>> +		interrupts = <GIC_SPI 78 0>,
>> +			<GIC_SPI 79 0>,
>> +			<GIC_SPI 51 0>,
>> +			<GIC_SPI 52 0>,
>> +			<GIC_SPI 55 0>,
>> +			<GIC_SPI 57 0>;
>> +		interrupt-names = "csiphy0",
>> +			"csiphy1",
>> +			"csid0",
>> +			"csid1",
>> +			"ispif",
>> +			"vfe0";
>> +		power-domains = <&gcc VFE_GDSC>;
>> +		clocks = <&gcc GCC_CAMSS_TOP_AHB_CLK>,
>> +			<&gcc GCC_CAMSS_ISPIF_AHB_CLK>,
>> +			<&gcc GCC_CAMSS_CSI0PHYTIMER_CLK>,
>> +			<&gcc GCC_CAMSS_CSI1PHYTIMER_CLK>,
>> +			<&gcc GCC_CAMSS_CSI0_AHB_CLK>,
>> +			<&gcc GCC_CAMSS_CSI0_CLK>,
>> +			<&gcc GCC_CAMSS_CSI0PHY_CLK>,
>> +			<&gcc GCC_CAMSS_CSI0PIX_CLK>,
>> +			<&gcc GCC_CAMSS_CSI0RDI_CLK>,
>> +			<&gcc GCC_CAMSS_CSI1_AHB_CLK>,
>> +			<&gcc GCC_CAMSS_CSI1_CLK>,
>> +			<&gcc GCC_CAMSS_CSI1PHY_CLK>,
>> +			<&gcc GCC_CAMSS_CSI1PIX_CLK>,
>> +			<&gcc GCC_CAMSS_CSI1RDI_CLK>,
>> +			<&gcc GCC_CAMSS_AHB_CLK>,
>> +			<&gcc GCC_CAMSS_VFE0_CLK>,
>> +			<&gcc GCC_CAMSS_CSI_VFE0_CLK>,
>> +			<&gcc GCC_CAMSS_VFE_AHB_CLK>,
>> +			<&gcc GCC_CAMSS_VFE_AXI_CLK>;
>> +                clock-names = "camss_top_ahb",
>> +                        "ispif_ahb",
>> +                        "csiphy0_timer",
>> +                        "csiphy1_timer",
>> +                        "csi0_ahb",
>> +                        "csi0",
>> +                        "csi0_phy",
>> +                        "csi0_pix",
>> +                        "csi0_rdi",
>> +                        "csi1_ahb",
>> +                        "csi1",
>> +                        "csi1_phy",
>> +                        "csi1_pix",
>> +                        "csi1_rdi",
>> +                        "camss_ahb",
>> +                        "camss_vfe_vfe",
>> +                        "camss_csi_vfe",
>> +                        "iface",
>> +                        "bus";
>> +		vdda-supply = <&pm8916_l2>;
>> +		iommus = <&apps_iommu 3>;
>> +		ports {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			port@0 {
>> +				reg = <0>;
>> +				csiphy0_ep: endpoint {
>> +					clock-lanes = <1>;
>> +					data-lanes = <0 2>;
> 
> Do you support lane mapping? The values suggest "yes". That's something I
> could improve in the documentation: if lane mapping isn't supported, then
> the clock lane should be 0 and the data lanes from 1 to n.

Lane mapping is supported only for the data lanes. The clock lane is always
the physical lane 1. This is why I think it makes sense to keep the value
of the clock lane to 1 as this is the physical lane 1 really. I'll add
explanation in the documentation for this and for the data lanes too so
it is clear.

> 
> Is the split of the lanes between the ports static and specific to the
> hardware?

Each port describes a separate CSIPHY so each has its own set of lanes.

> 
>> +					remote-endpoint = <&ov5645_ep>;
>> +				};
>> +			};
>> +		};
>> +	};
> 

-- 
Best regards,
Todor Tomov
