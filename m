Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34601 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755423AbeDWPqk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 11:46:40 -0400
Message-ID: <1524498393.3396.4.camel@pengutronix.de>
Subject: Re: [PATCH v2 11/15] ARM: dts: imx7: Add video mux, csi and
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
Date: Mon, 23 Apr 2018 17:46:33 +0200
In-Reply-To: <20180423134750.30403-12-rui.silva@linaro.org>
References: <20180423134750.30403-1-rui.silva@linaro.org>
         <20180423134750.30403-12-rui.silva@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-04-23 at 14:47 +0100, Rui Miguel Silva wrote:
> This patch adds the device tree nodes for csi, video multiplexer and mipi-csi
> besides the graph connecting the necessary endpoints to make the media capture
> entities to work in imx7 Warp board.
> 
> Also add the pin control related with the mipi_csi in that board.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  arch/arm/boot/dts/imx7s-warp.dts | 80 ++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/imx7s.dtsi     | 27 +++++++++++
>  2 files changed, 107 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx7s-warp.dts b/arch/arm/boot/dts/imx7s-warp.dts
> index 8a30b148534d..91d06adf7c24 100644
> --- a/arch/arm/boot/dts/imx7s-warp.dts
> +++ b/arch/arm/boot/dts/imx7s-warp.dts
> @@ -310,6 +310,79 @@
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
> +
> +	port@0 {
> +		reg = <0>;
> +
> +		mipi_from_sensor: endpoint {
> +			remote-endpoint = <&ov2680_to_mipi>;
> +			data-lanes = <1>;
> +			csis-hs-settle = <3>;
> +			csis-clk-settle = <0>;
> +			csis-wclk;

Why is this an endpoint property? Under which condition would a board
designer choose PCLK instead of WRAP_CLK as pixel clock source?

I'd naively assume that the driver should set this bit automatically
whenever a "wrap" clock is provided via device tree.

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
> @@ -357,6 +430,13 @@
>  		>;
>  	};
>  
> +	pinctrl_mipi_csi: mipi_csi {
> +		fsl,pins = <
> +			MX7D_PAD_LPSR_GPIO1_IO03__GPIO1_IO3	0x14
> +			MX7D_PAD_ENET1_RGMII_TD0__GPIO7_IO6	0x14
> +		>;
> +	};
> +

Unrelated change?

>  	pinctrl_sai1: sai1grp {
>  		fsl,pins = <
>  			MX7D_PAD_SAI1_RX_DATA__SAI1_RX_DATA0	0x1f
> diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
> index 3027d6a62021..6b49b73053f9 100644
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
> @@ -753,6 +754,17 @@
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
> @@ -762,6 +774,21 @@
>  				clock-names = "pix", "axi";
>  				status = "disabled";
>  			};
> +
> +			mipi_csi: mipi-csi@30750000 {
> +				compatible = "fsl,imx7-mipi-csi2";
> +				reg = <0x30750000 0x10000>;
> +				interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clks IMX7D_MIPI_CSI_ROOT_CLK>,
> +						<&clks IMX7D_MIPI_DPHY_ROOT_CLK>;
> +				clock-names = "mipi", "phy";

The i.MX7Dual and i.MX7Solo reference manuals mention three clock inputs
to the MIPI CSI: mipi_csi.ipg_clk_s, mipi_csi.I_PCLK, and
mipi.csi.I_WRAP_CLK (all three gated by CCGR100).
The MIPI_CSI2 chapters mention I_PCLK and I_WRAP_CLK again. Shouldn't at
least those two be used in place of just "mipi"?

> +				power-domains = <&pgc_mipi_phy>;
> +				phy-supply = <&reg_1p0d>;
> +				resets = <&src IMX7_RESET_MIPI_PHY_MRST>;
> +				reset-names = "mrst";
> +				bus-width = <4>;

It looks to me like both i.MX7Dual and i.MX7Solo only have two data
lanes connected.

> +				status = "disabled";
> +			};
>  		};
>  
>  		aips3: aips-bus@30800000 {

regards
Philipp
