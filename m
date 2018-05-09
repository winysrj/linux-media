Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56439 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934371AbeEIIxw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 04:53:52 -0400
Message-ID: <1525856026.5888.4.camel@pengutronix.de>
Subject: Re: [PATCH v3 10/14] ARM: dts: imx7: Add video mux, csi and
 mipi_csi and connections
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Date: Wed, 09 May 2018 10:53:46 +0200
In-Reply-To: <20180507162152.2545-11-rui.silva@linaro.org>
References: <20180507162152.2545-1-rui.silva@linaro.org>
         <20180507162152.2545-11-rui.silva@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-05-07 at 17:21 +0100, Rui Miguel Silva wrote:
> This patch adds the device tree nodes for csi, video multiplexer and mipi-csi
> besides the graph connecting the necessary endpoints to make the media capture
> entities to work in imx7 Warp board.
> 
> Also add the pin control related with the mipi_csi in that board.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  arch/arm/boot/dts/imx7s-warp.dts | 78 ++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/imx7s.dtsi     | 28 ++++++++++++
>  2 files changed, 106 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx7s-warp.dts b/arch/arm/boot/dts/imx7s-warp.dts
> index 8a30b148534d..ffd170ae925a 100644
> --- a/arch/arm/boot/dts/imx7s-warp.dts
> +++ b/arch/arm/boot/dts/imx7s-warp.dts
> @@ -310,6 +310,77 @@
>  	status = "okay";
>  };
>  
> +&gpr {
> +	csi_mux {
> +		compatible = "video-mux";
> +		mux-controls = <&mux 0>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		port@0 {
> +			reg = <0>;
> +
> +			csi_mux_from_parallel_sensor: endpoint {
> +			};
> +		};
> +
> +		port@1 {
> +			reg = <1>;
> +
> +			csi_mux_from_mipi_vc0: endpoint {
> +				remote-endpoint = <&mipi_vc0_to_csi_mux>;
> +			};
> +		};
> +
> +		port@2 {
> +			reg = <2>;
> +
> +			csi_mux_to_csi: endpoint {
> +				remote-endpoint = <&csi_from_csi_mux>;
> +			};
> +		};
> +	};
> +};
> +
> +&csi {
> +	status = "okay";
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	port@0 {
> +		reg = <0>;

Same comment as for the binding docs, since the CSI only has one port,
it doesn't have to be numbered.

> +
> +		csi_from_csi_mux: endpoint {
> +			remote-endpoint = <&csi_mux_to_csi>;
> +		};
> +	};
> +};
> +
> +&mipi_csi {
> +	clock-frequency = <166000000>;
> +	status = "okay";
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +	fsl,csis-hs-settle = <3>;
> +
> +	port@0 {
> +		reg = <0>;
> +
> +		mipi_from_sensor: endpoint {
> +			remote-endpoint = <&ov2680_to_mipi>;
> +			data-lanes = <1>;
> +		};
> +	};
> +
> +	port@1 {
> +		reg = <1>;
> +
> +		mipi_vc0_to_csi_mux: endpoint {
> +			remote-endpoint = <&csi_mux_from_mipi_vc0>;
> +		};
> +	};
> +};
> +
>  &wdog1 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_wdog>;
> @@ -357,6 +428,13 @@
>  		>;
>  	};
>  
> +	pinctrl_mipi_csi: mipi_csi {
> +		fsl,pins = <
> +			MX7D_PAD_LPSR_GPIO1_IO03__GPIO1_IO3	0x14

This is the ov2680 reset GPIO? I think this belongs into patch 12.

> +			MX7D_PAD_ENET1_RGMII_TD0__GPIO7_IO6	0x14

What is this GPIO used for?

> +		>;
> +	};
> +
>  	pinctrl_sai1: sai1grp {
>  		fsl,pins = <
>  			MX7D_PAD_SAI1_RX_DATA__SAI1_RX_DATA0	0x1f
> diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
> index 3590dab529f9..0bae41f2944c 100644
> --- a/arch/arm/boot/dts/imx7s.dtsi
> +++ b/arch/arm/boot/dts/imx7s.dtsi
> @@ -46,6 +46,7 @@
>  #include <dt-bindings/gpio/gpio.h>
>  #include <dt-bindings/input/input.h>
>  #include <dt-bindings/interrupt-controller/arm-gic.h>
> +#include <dt-bindings/reset/imx7-reset.h>
>  #include "imx7d-pinfunc.h"
>  
>  / {
> @@ -738,6 +739,17 @@
>  				status = "disabled";
>  			};
>  
> +			csi: csi@30710000 {
> +				compatible = "fsl,imx7-csi";
> +				reg = <0x30710000 0x10000>;
> +				interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clks IMX7D_CLK_DUMMY>,
> +						<&clks IMX7D_CSI_MCLK_ROOT_CLK>,
> +						<&clks IMX7D_CLK_DUMMY>;
> +				clock-names = "axi", "mclk", "dcic";
> +				status = "disabled";
> +			};
> +
>  			lcdif: lcdif@30730000 {
>  				compatible = "fsl,imx7d-lcdif", "fsl,imx28-lcdif";
>  				reg = <0x30730000 0x10000>;
> @@ -747,6 +759,22 @@
>  				clock-names = "pix", "axi";
>  				status = "disabled";
>  			};
> +
> +			mipi_csi: mipi-csi@30750000 {
> +				compatible = "fsl,imx7-mipi-csi2";
> +				reg = <0x30750000 0x10000>;
> +				interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clks IMX7D_IPG_ROOT_CLK>,
> +						<&clks IMX7D_MIPI_CSI_ROOT_CLK>,
> +						<&clks IMX7D_MIPI_DPHY_ROOT_CLK>;
> +				clock-names = "pclk", "wrap", "phy";
> +				power-domains = <&pgc_mipi_phy>;
> +				phy-supply = <&reg_1p0d>;
> +				resets = <&src IMX7_RESET_MIPI_PHY_MRST>;
> +				reset-names = "mrst";
> +				bus-width = <2>;
> +				status = "disabled";
> +			};
>  		};
>  
>  		aips3: aips-bus@30800000 {

regards
Philipp
