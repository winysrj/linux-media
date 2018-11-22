Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36235 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389946AbeKVUUu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 15:20:50 -0500
Received: by mail-wr1-f65.google.com with SMTP id t3so8549280wrr.3
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 01:42:06 -0800 (PST)
References: <20181121111558.10838-1-rui.silva@linaro.org> <20181121111558.10838-6-rui.silva@linaro.org> <20181121221613.qg66c5fxm5i7vip2@mara.localdomain>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v8 05/12] media: dt-bindings: add bindings for i.MX7 media driver
In-reply-to: <20181121221613.qg66c5fxm5i7vip2@mara.localdomain>
Date: Thu, 22 Nov 2018 09:42:04 +0000
Message-ID: <m31s7dmosz.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
On Wed 21 Nov 2018 at 22:16, Sakari Ailus wrote:
> Hi Rui,
>
> On Wed, Nov 21, 2018 at 11:15:51AM +0000, Rui Miguel Silva 
> wrote:
>> Add bindings documentation for i.MX7 media drivers.
>> The imx7 MIPI CSI2 and imx7 CMOS Sensor Interface.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> Reviewed-by: Rob Herring <robh@kernel.org>
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  .../devicetree/bindings/media/imx7-csi.txt    | 45 ++++++++++
>>  .../bindings/media/imx7-mipi-csi2.txt         | 90 
>>  +++++++++++++++++++
>>  2 files changed, 135 insertions(+)
>>  create mode 100644 
>>  Documentation/devicetree/bindings/media/imx7-csi.txt
>>  create mode 100644 
>>  Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/media/imx7-csi.txt 
>> b/Documentation/devicetree/bindings/media/imx7-csi.txt
>> new file mode 100644
>> index 000000000000..171b089ee91f
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/imx7-csi.txt
>> @@ -0,0 +1,45 @@
>> +Freescale i.MX7 CMOS Sensor Interface
>> +=====================================
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
>> +The device node shall contain one 'port' child node with one 
>> child 'endpoint'
>> +node, according to the bindings defined in:
>> + Documentation/devicetree/bindings/media/video-interfaces.txt.
>> + 
>> +In the following example a remote endpoint is a video 
>> multiplexer.
>> +
>> +example:
>> +
>> +                csi: csi@30710000 {
>> +                        #address-cells = <1>;
>> +                        #size-cells = <0>;
>> +
>> +                        compatible = "fsl,imx7-csi";
>> +                        reg = <0x30710000 0x10000>;
>> +                        interrupts = <GIC_SPI 7 
>> IRQ_TYPE_LEVEL_HIGH>;
>> +                        clocks = <&clks IMX7D_CLK_DUMMY>,
>> +                                        <&clks 
>> IMX7D_CSI_MCLK_ROOT_CLK>,
>> +                                        <&clks 
>> IMX7D_CLK_DUMMY>;
>> +                        clock-names = "axi", "mclk", "dcic";
>> +
>> +                        port {
>> +                                csi_from_csi_mux: endpoint {
>> +                                        remote-endpoint = 
>> <&csi_mux_to_csi>;
>> +                                };
>> +                        };
>> +                };
>> diff --git 
>> a/Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt 
>> b/Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
>> new file mode 100644
>> index 000000000000..71fd74ed3ec8
>> --- /dev/null
>> +++ 
>> b/Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
>> @@ -0,0 +1,90 @@
>> +Freescale i.MX7 Mipi CSI2
>> +=========================
>> +
>> +mipi_csi2 node
>> +--------------
>> +
>> +This is the device node for the MIPI CSI-2 receiver core in 
>> i.MX7 SoC. It is
>> +compatible with previous version of Samsung D-phy.
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
>> +- clock-names   : must contain "pclk", "wrap" and "phy" 
>> entries, matching
>> +                  entries in the clock property;
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
>> +	          provides power to MIPI CSIS core;
>> +
>> +Optional properties:
>> +
>> +- clock-frequency : The IP's main (system bus) clock frequency 
>> in Hz, default
>> +		    value when this property is not specified is 
>> 166 MHz;
>> +- fsl,csis-hs-settle : differential receiver (HS-RX) settle 
>> time;
>> +
>> +The device node should contain two 'port' child nodes with one 
>> child 'endpoint'
>> +node, according to the bindings defined in:
>> + Documentation/devicetree/bindings/ 
>> media/video-interfaces.txt.
>
> Extra space. The two lines are also prefixed by a space; is that 
> intended?

Yes, that will be fix by going over the checkpatch strict.

>
>> + The following are properties specific to those nodes.
>> +
>> +port node
>> +---------
>> +
>> +- reg		  : (required) can take the values 0 or 1, 
>> where 0 shall be
>> +                     related to the sink port and port 1 shall 
>> be the source
>> +                     one;
>> +
>> +endpoint node
>> +-------------
>> +
>> +- data-lanes    : (required) an array specifying active 
>> physical MIPI-CSI2
>> +		    data input lanes and their mapping to logical 
>> lanes; this
>> +                    shall only be applied to port 0 (sink 
>> port), the array's
>> +                    content is unused only its length is 
>> meaningful,
>> +                    in this case the maximum length supported 
>> is 2;
>
> How about the port 1? Is there anything to configure there (I'm 
> not saying
> there is, just wondering)?

maybe the virtual channel, but for now only 0 is supported. if 
late we
get to support more, maybe use the same schema as imx6, one port 
per vc.

---
Cheers,
	Rui

>
>> +
>> +example:
>> +
>> +        mipi_csi: mipi-csi@30750000 {
>> +                #address-cells = <1>;
>> +                #size-cells = <0>;
>> +
>> +                compatible = "fsl,imx7-mipi-csi2";
>> +                reg = <0x30750000 0x10000>;
>> +                interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
>> +                clocks = <&clks IMX7D_IPG_ROOT_CLK>,
>> +                                <&clks 
>> IMX7D_MIPI_CSI_ROOT_CLK>,
>> +                                <&clks 
>> IMX7D_MIPI_DPHY_ROOT_CLK>;
>> +                clock-names = "pclk", "wrap", "phy";
>> +                clock-frequency = <166000000>;
>> +                power-domains = <&pgc_mipi_phy>;
>> +                phy-supply = <&reg_1p0d>;
>> +                resets = <&src IMX7_RESET_MIPI_PHY_MRST>;
>> +                reset-names = "mrst";
>> +                fsl,csis-hs-settle = <3>;
>> +
>> +                port@0 {
>> +                        reg = <0>;
>> +
>> +                        mipi_from_sensor: endpoint {
>> +                                remote-endpoint = 
>> <&ov2680_to_mipi>;
>> +                                data-lanes = <1>;
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
>> +        };
