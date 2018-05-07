Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:38976 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752253AbeEGQ2t (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 12:28:49 -0400
Received: by mail-wr0-f194.google.com with SMTP id q3-v6so29386733wrj.6
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 09:28:48 -0700 (PDT)
References: <20180423134750.30403-1-rui.silva@linaro.org> <20180423134750.30403-9-rui.silva@linaro.org> <20180427190606.ngpootnfzsjwg6ya@rob-hp-laptop>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Rob Herring <robh@kernel.org>
Cc: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v2 08/15] media: dt-bindings: add bindings for i.MX7 media driver
In-reply-to: <20180427190606.ngpootnfzsjwg6ya@rob-hp-laptop>
Date: Mon, 07 May 2018 17:28:45 +0100
Message-ID: <m3o9hr77lu.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,
Thanks for the review and sorry for the late reply.
Meanwhile I have send v3 of this series with some of yours 
comments
incorporated. 

On Fri 27 Apr 2018 at 19:06, Rob Herring wrote:
> On Mon, Apr 23, 2018 at 02:47:43PM +0100, Rui Miguel Silva 
> wrote:
>> Add bindings documentation for i.MX7 media drivers.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>>  .../devicetree/bindings/media/imx7.txt        | 158 
>>  ++++++++++++++++++
>>  1 file changed, 158 insertions(+)
>>  create mode 100644 
>>  Documentation/devicetree/bindings/media/imx7.txt
>> 
>> diff --git a/Documentation/devicetree/bindings/media/imx7.txt 
>> b/Documentation/devicetree/bindings/media/imx7.txt
>> new file mode 100644
>> index 000000000000..7e058ea25102
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/imx7.txt
>> @@ -0,0 +1,158 @@
>> +Freescale i.MX7 Media Video Device
>> +==================================
>> +
>> +Video Media Controller node
>> +---------------------------
>> +
>> +This is the media controller node for video capture support. 
>> It is a
>> +virtual device that lists the camera serial interface nodes 
>> that the
>> +media device will control.
>> +
>> +Required properties:
>> +- compatible : "fsl,imx7-capture-subsystem";
>> +- ports      : Should contain a list of phandles pointing to 
>> camera
>> +		sensor interface port of CSI
>> +
>> +example:
>> +
>> +capture-subsystem {
>> +	compatible = "fsl,imx7-capture-subsystem";
>> +	ports = <&csi>;
>
> Why do you need this node? Just have the driver match on the CSI 
> node.

This is for the parsing of the nodes done in imx media core, see 
also
the imx.txt file.

>
>> +};
>> +
>> +
>> +mipi_csi2 node
>> +--------------
>> +
>> +This is the device node for the MIPI CSI-2 receiver core in 
>> i.MX7 SoC. It is
>> +compatible with previous version of Samsung D-phy.
>
> Compatible with Samsung?
>
>> +
>> +Required properties:
>> +
>> +- compatible    : "fsl,imx7-mipi-csi2";
>> +- reg           : base address and length of the register set 
>> for the device;
>> +- interrupts    : should contain MIPI CSIS interrupt;
>> +- clocks        : list of clock specifiers, see
>> + 
>> Documentation/devicetree/bindings/clock/clock-bindings.txt for 
>> details;
>> +- clock-names   : must contain "mipi" and "phy" entries, 
>> matching entries in the
>> +                  clock property;
>> +- power-domains : a phandle to the power domain, see
>> + 
>> Documentation/devicetree/bindings/power/power_domain.txt for 
>> details.
>> +- reset-names   : should include following entry "mrst";
>> +- resets        : a list of phandle, should contain reset 
>> entry of
>> +                  reset-names;
>> +- phy-supply    : from the generic phy bindings, a phandle to 
>> a regulator that
>> +	          provides power to VBUS;
>
> VBUS? Copy-n-paste from USB something?

yeah, c-n-p error.

>
>> +- bus-width     : maximum number of data lanes supported (SoC 
>> specific);
>
> Don't we have a standard lanes property for CSI (or DSI)? 
> bus-width is 
> for parallel buses and goes in endpoint nodes. (But maybe it got 
> used 
> here too).
>
>> +
>> +Optional properties:
>> +
>> +- clock-frequency : The IP's main (system bus) clock frequency 
>> in Hz, default
>> +		    value when this property is not specified is 
>> 166 MHz;
>> +
>> +port node
>> +---------
>> +
>> +- reg		  : (required) can take the values 0 or 1, 
>> where 0 is the
>> +                     related sink port and port 1 should be 
>> the source one;
>> +
>> +endpoint node
>> +-------------
>> +
>> +- data-lanes    : (required) an array specifying active 
>> physical MIPI-CSI2
>> +		    data input lanes and their mapping to logical 
>> lanes; the
>> +		    array's content is unused, only its length is 
>> meaningful;
>
> Ah yes, like this. :) So why do you need bus-width too?

To guarantee that the active lanes are not bigger that the ones
supported in the specific SoC. So, the bus-width defines the lanes
supported and this the active ones.

>
>> +
>> +- csis-hs-settle : (optional) differential receiver (HS-RX) 
>> settle time;
>
> units?
>
>> +- csis-clk-settle : (optional) D-PHY control register;
>> +- csis-wclk     : CSI-2 wrapper clock selection. If this 
>> property is present
>> +		  external clock from CMU will be used, or the bus 
>> clock if
>> +		  if it's not specified.
>
> boolean?

I dropped this in v3.

>
> These 3 need vendor properties.

Sure, added in v3

>
>> +
>> +example:
>> +
>> +	mipi_csi: mipi-csi@30750000 {
>> +                clock-frequency = <166000000>;
>> +                status = "okay";
>> +                #address-cells = <1>;
>> +                #size-cells = <0>;
>> +
>> +		compatible = "fsl,imx7-mipi-csi2";
>> +		reg = <0x30750000 0x10000>;
>> +		interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
>> +		clocks = <&clks IMX7D_MIPI_CSI_ROOT_CLK>,
>> +				<&clks IMX7D_MIPI_DPHY_ROOT_CLK>;
>> +		clock-names = "mipi", "phy";
>> +		power-domains = <&pgc_mipi_phy>;
>> +		phy-supply = <&reg_1p0d>;
>> +		resets = <&src IMX7_RESET_MIPI_PHY_MRST>;
>> +		reset-names = "mrst";
>> +		bus-width = <4>;
>> +		status = "disabled";
>> +
>> +                port@0 {
>> +                        reg = <0>;
>> +
>> +                        mipi_from_sensor: endpoint {
>> +                                remote-endpoint = 
>> <&ov2680_to_mipi>;
>> +                                data-lanes = <1>;
>> +                                csis-hs-settle = <3>;
>> +                                csis-clk-settle = <0>;
>> +                                csis-wclk;
>> +                        };
>> +                };
>> +
>> +                port@1 {
>> +                        reg = <1>;
>> +
>> +                        mipi_vc0_to_csi_mux: endpoint {
>> +                                remote-endpoint = 
>> <&csi_mux_from_mipi_vc0>;
>> +                        };
>> +                };
>> +	};
>> +
>> +
>> +csi node
>> +--------
>> +
>> +This is device node for the CMOS Sensor Interface (CSI) which 
>> enables the chip
>> +to connect directly to external CMOS image sensors.
>> +
>> +Required properties:
>> +
>> +- compatible    : "fsl,imx7-csi";
>> +- reg           : base address and length of the register set 
>> for the device;
>> +- interrupts    : should contain CSI interrupt;
>> +- clocks        : list of clock specifiers, see
>> + 
>> Documentation/devicetree/bindings/clock/clock-bindings.txt for 
>> details;
>> +- clock-names   : must contain "axi", "mclk" and "dcic" 
>> entries, matching
>> +                 entries in the clock property;
>> +
>> +port node
>> +---------
>> +
>> +- reg		  : (required) should be 0 for the sink 
>> port;
>> +
>> +example:
>> +
>> +		csi: csi@30710000 {
>> +                        #address-cells = <1>;
>> +                        #size-cells = <0>;
>
> Something wrong with indentation here.

Fixed the indentation.

>
>> +
>> +			compatible = "fsl,imx7-csi";
>> +			reg = <0x30710000 0x10000>;
>> +			interrupts = <GIC_SPI 7 
>> IRQ_TYPE_LEVEL_HIGH>;
>> +			clocks = <&clks IMX7D_CLK_DUMMY>,
>> +					<&clks 
>> IMX7D_CSI_MCLK_ROOT_CLK>,
>> +					<&clks IMX7D_CLK_DUMMY>;
>> +			clock-names = "axi", "mclk", "dcic";
>> +			status = "disabled";
>
> Don't show status in examples.

yeah, you are right. fixed.

>
>> +
>> +                        port@0 {
>
> And the indentation here...
>
>
> Same issues in the 1st example, too.

ditto.

---
Cheers,
	Rui
