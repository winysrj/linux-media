Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f180.google.com ([209.85.210.180]:35990 "EHLO
        mail-wj0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032673AbdAIOdX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2017 09:33:23 -0500
Received: by mail-wj0-f180.google.com with SMTP id ew7so52463544wjc.3
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2017 06:33:22 -0800 (PST)
Subject: Re: [PATCH 01/10] doc: DT: camss: Binding document for Qualcomm
 Camera subsystem driver
To: Rob Herring <robh@kernel.org>
References: <1480085813-28235-1-git-send-email-todor.tomov@linaro.org>
 <20161130220350.q37rbo2biaeg2sad@rob-hp-laptop>
Cc: mchehab@kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, bjorn.andersson@linaro.org,
        srinivas.kandagatla@linaro.org
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <58739F2D.5020607@linaro.org>
Date: Mon, 9 Jan 2017 16:33:17 +0200
MIME-Version: 1.0
In-Reply-To: <20161130220350.q37rbo2biaeg2sad@rob-hp-laptop>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Happy new year,
And thank you for the review.

On 12/01/2016 12:03 AM, Rob Herring wrote:
> On Fri, Nov 25, 2016 at 04:56:53PM +0200, Todor Tomov wrote:
>> Add DT binding document for Qualcomm Camera subsystem driver.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  .../devicetree/bindings/media/qcom,camss.txt       | 196 +++++++++++++++++++++
>>  1 file changed, 196 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/qcom,camss.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/qcom,camss.txt b/Documentation/devicetree/bindings/media/qcom,camss.txt
>> new file mode 100644
>> index 0000000..76ad89a
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/qcom,camss.txt
>> @@ -0,0 +1,196 @@
>> +Qualcomm Camera Subsystem
>> +
>> +* Properties
>> +
>> +- compatible:
>> +	Usage: required
>> +	Value type: <stringlist>
>> +	Definition: Should contain:
>> +		- "qcom,8x16-camss"
> 
> Don't use wildcards in compatible strings. One string per SoC.

Ok, I'll fix this.

> 
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
> 
> Kind of looks like the phy's should be separate nodes since each phy has 
> its own register range, irq, clocks, etc.

Yes, there are a lot of hardware resources here.
I have decided to keep everything into a single platform device as this
represents it better from system point of view.

> 
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
>> +		- "camss_top_ahb_clk"
>> +		- "ispif_ahb_clk"
>> +		- "csiphy0_timer_clk"
>> +		- "csiphy1_timer_clk"
>> +		- "csi0_ahb_clk"
>> +		- "csi0_clk"
>> +		- "csi0_phy_clk"
>> +		- "csi0_pix_clk"
>> +		- "csi0_rdi_clk"
>> +		- "csi1_ahb_clk"
>> +		- "csi1_clk"
>> +		- "csi1_phy_clk"
>> +		- "csi1_pix_clk"
>> +		- "csi1_rdi_clk"
>> +		- "camss_ahb_clk"
>> +		- "camss_vfe_vfe_clk"
>> +		- "camss_csi_vfe_clk"
>> +		- "iface_clk"
>> +		- "bus_clk"
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
>> +		- qcom,settle-cnt:
> 
> This should go in phy node ideally.
> 
>> +			Usage: required
>> +			Value type: <u32>
>> +			Definition: The settle count parameter for CSI PHY.
>> +
>> +* An Example
>> +
>> +	camss: camss@1b00000 {
>> +		compatible = "qcom,8x16-camss";
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
>> +		clock-names = "camss_top_ahb_clk",
>> +			"ispif_ahb_clk",
>> +			"csiphy0_timer_clk",
>> +			"csiphy1_timer_clk",
>> +			"csi0_ahb_clk",
>> +			"csi0_clk",
>> +			"csi0_phy_clk",
>> +			"csi0_pix_clk",
>> +			"csi0_rdi_clk",
>> +			"csi1_ahb_clk",
>> +			"csi1_clk",
>> +			"csi1_phy_clk",
>> +			"csi1_pix_clk",
>> +			"csi1_rdi_clk",
>> +			"camss_ahb_clk",
>> +			"camss_vfe_vfe_clk",
>> +			"camss_csi_vfe_clk",
>> +			"iface_clk",
>> +			"bus_clk";
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
>> +					qcom,settle-cnt = <0xe>;
>> +					remote-endpoint = <&ov5645_ep>;
>> +				};
>> +			};
>> +		};
>> +	};
>> -- 
>> 1.9.1
>>

-- 
Best regards,
Todor Tomov
