Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:10388 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732349AbeHBOvq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Aug 2018 10:51:46 -0400
Date: Thu, 2 Aug 2018 16:00:27 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>, linux-clk@vger.kernel.org
Subject: Re: [PATCH v6 07/13] media: dt-bindings: add bindings for i.MX7
 media driver
Message-ID: <20180802130027.yltizjaagt7q3vqu@paasikivi.fi.intel.com>
References: <20180522145245.3143-1-rui.silva@linaro.org>
 <20180522145245.3143-8-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180522145245.3143-8-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rui,

On Tue, May 22, 2018 at 03:52:39PM +0100, Rui Miguel Silva wrote:
> Add bindings documentation for i.MX7 media drivers.
> The imx7 MIPI CSI2 and imx7 CMOS Sensor Interface.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  .../devicetree/bindings/media/imx7-csi.txt    | 44 ++++++++++
>  .../bindings/media/imx7-mipi-csi2.txt         | 82 +++++++++++++++++++
>  2 files changed, 126 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/imx7-csi.txt
>  create mode 100644 Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/imx7-csi.txt b/Documentation/devicetree/bindings/media/imx7-csi.txt
> new file mode 100644
> index 000000000000..aab4f5d72390
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/imx7-csi.txt
> @@ -0,0 +1,44 @@
> +Freescale i.MX7 CMOS Sensor Interface
> +=====================================
> +
> +csi node
> +--------
> +
> +This is device node for the CMOS Sensor Interface (CSI) which enables the chip
> +to connect directly to external CMOS image sensors.
> +
> +Required properties:
> +
> +- compatible    : "fsl,imx7-csi";
> +- reg           : base address and length of the register set for the device;
> +- interrupts    : should contain CSI interrupt;
> +- clocks        : list of clock specifiers, see
> +        Documentation/devicetree/bindings/clock/clock-bindings.txt for details;
> +- clock-names   : must contain "axi", "mclk" and "dcic" entries, matching
> +                 entries in the clock property;
> +
> +The device node should contain one 'port' child node with one child 'endpoint'

"should" or "shall"?

> +node, according to the bindings defined in Documentation/devicetree/bindings/
> +media/video-interfaces.txt. In the following example a remote endpoint is a

I wouldn't split the path as it breaks copy-paste; up to you.

> +video multiplexer.
> +
> +example:
> +
> +                csi: csi@30710000 {
> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
> +
> +                        compatible = "fsl,imx7-csi";
> +                        reg = <0x30710000 0x10000>;
> +                        interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
> +                        clocks = <&clks IMX7D_CLK_DUMMY>,
> +                                        <&clks IMX7D_CSI_MCLK_ROOT_CLK>,
> +                                        <&clks IMX7D_CLK_DUMMY>;
> +                        clock-names = "axi", "mclk", "dcic";
> +
> +                        port {
> +                                csi_from_csi_mux: endpoint {
> +                                        remote-endpoint = <&csi_mux_to_csi>;
> +                                };
> +                        };
> +                };
> diff --git a/Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt b/Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
> new file mode 100644
> index 000000000000..7c5f20863724
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
> @@ -0,0 +1,82 @@
> +Freescale i.MX7 Mipi CSI2
> +=========================
> +
> +mipi_csi2 node
> +--------------
> +
> +This is the device node for the MIPI CSI-2 receiver core in i.MX7 SoC. It is
> +compatible with previous version of Samsung D-phy.
> +
> +Required properties:
> +
> +- compatible    : "fsl,imx7-mipi-csi2";
> +- reg           : base address and length of the register set for the device;
> +- interrupts    : should contain MIPI CSIS interrupt;
> +- clocks        : list of clock specifiers, see
> +        Documentation/devicetree/bindings/clock/clock-bindings.txt for details;
> +- clock-names   : must contain "pclk", "wrap" and "phy" entries, matching
> +                  entries in the clock property;
> +- power-domains : a phandle to the power domain, see
> +          Documentation/devicetree/bindings/power/power_domain.txt for details.
> +- reset-names   : should include following entry "mrst";
> +- resets        : a list of phandle, should contain reset entry of
> +                  reset-names;
> +- phy-supply    : from the generic phy bindings, a phandle to a regulator that
> +	          provides power to MIPI CSIS core;
> +
> +Optional properties:
> +
> +- clock-frequency : The IP's main (system bus) clock frequency in Hz, default
> +		    value when this property is not specified is 166 MHz;
> +- fsl,csis-hs-settle : differential receiver (HS-RX) settle time;
> +
> +port node
> +---------
> +
> +- reg		  : (required) can take the values 0 or 1, where 0 is the
> +                     related sink port and port 1 should be the source one;

Should and is -> shall?

I think you should also elaborate whether or not the port (as well as the
endpoint) nodes themselves are mandatory.

> +
> +endpoint node
> +-------------
> +
> +- data-lanes    : (required) an array specifying active physical MIPI-CSI2
> +		    data input lanes and their mapping to logical lanes; the
> +		    array's content is unused, only its length is meaningful;

If this is for port 0 only, please document that. Which values (length) are
allowed?

> +
> +example:
> +
> +        mipi_csi: mipi-csi@30750000 {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                compatible = "fsl,imx7-mipi-csi2";
> +                reg = <0x30750000 0x10000>;
> +                interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
> +                clocks = <&clks IMX7D_IPG_ROOT_CLK>,
> +                                <&clks IMX7D_MIPI_CSI_ROOT_CLK>,
> +                                <&clks IMX7D_MIPI_DPHY_ROOT_CLK>;
> +                clock-names = "pclk", "wrap", "phy";
> +                clock-frequency = <166000000>;
> +                power-domains = <&pgc_mipi_phy>;
> +                phy-supply = <&reg_1p0d>;
> +                resets = <&src IMX7_RESET_MIPI_PHY_MRST>;
> +                reset-names = "mrst";
> +                fsl,csis-hs-settle = <3>;
> +
> +                port@0 {
> +                        reg = <0>;
> +
> +                        mipi_from_sensor: endpoint {
> +                                remote-endpoint = <&ov2680_to_mipi>;
> +                                data-lanes = <1>;
> +                        };
> +                };
> +
> +                port@1 {
> +                        reg = <1>;
> +
> +                        mipi_vc0_to_csi_mux: endpoint {
> +                                remote-endpoint = <&csi_mux_from_mipi_vc0>;
> +                        };
> +                };
> +        };

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
