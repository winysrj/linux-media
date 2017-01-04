Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:36337 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964878AbdADMZ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 07:25:29 -0500
Subject: Re: [PATCH v2 04/19] ARM: dts: imx6-sabrelite: add OV5642 and OV5640
 camera sensors
To: Steve Longerbeam <slongerbeam@gmail.com>, <shawnguo@kernel.org>,
        <kernel@pengutronix.de>, <fabio.estevam@nxp.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linux@armlinux.org.uk>, <mchehab@kernel.org>,
        <gregkh@linuxfoundation.org>, <p.zabel@pengutronix.de>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
 <1483477049-19056-5-git-send-email-steve_longerbeam@mentor.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <0a343705-1d38-9fe2-6419-56ab9bdfb0c2@mentor.com>
Date: Wed, 4 Jan 2017 14:25:17 +0200
MIME-Version: 1.0
In-Reply-To: <1483477049-19056-5-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On 01/03/2017 10:57 PM, Steve Longerbeam wrote:
> Enables the OV5642 parallel-bus sensor, and the OV5640 MIPI CSI-2 sensor.
> Both hang off the same i2c2 bus, so they require different (and non-
> default) i2c slave addresses.
> 
> The OV5642 connects to the parallel-bus mux input port on ipu1_csi0_mux.
> 
> The OV5640 connects to the input port on the MIPI CSI-2 receiver on
> mipi_csi. It is set to transmit over MIPI virtual channel 1.
> 
> Note there is a pin conflict with GPIO6. This pin functions as a power
> input pin to the OV5642, but ENET uses it as the h/w workaround for
> erratum ERR006687, to wake-up the ARM cores on normal RX and TX packet
> done events (see 6261c4c8). So workaround 6261c4c8 is reverted here to
> support the OV5642, and the "fsl,err006687-workaround-present" boolean
> also must be removed. The result is that the CPUidle driver will no longer
> allow entering the deep idle states on the sabrelite.

For me it sounds like a candidate of its own separate change.

> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---

[snip]

>  &audmux {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_audmux>;
> @@ -271,9 +298,6 @@
>  	txd1-skew-ps = <0>;
>  	txd2-skew-ps = <0>;
>  	txd3-skew-ps = <0>;
> -	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
> -			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;

Like you say in the commit message this is a partial revert of 6261c4c8f13e
("ARM: dts: imx6qdl-sabrelite: use GPIO_6 for FEC interrupt.")

> -	fsl,err006687-workaround-present;

This is a partial revert of a28eeb43ee57 ("ARM: dts: imx6: tag boards that
have the HW workaround for ERR006687").

The change should be split and reviewed separately in my opinion, also
cc Gary Bisson <gary.bisson@boundarydevices.com> for SabreLite changes.

>  	status = "okay";
>  };
>  
> @@ -302,6 +326,52 @@
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_i2c2>;
>  	status = "okay";
> +
> +	camera: ov5642@42 {
> +		compatible = "ovti,ov5642";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_ov5642>;
> +		clocks = <&clks IMX6QDL_CLK_CKO2>;
> +		clock-names = "xclk";
> +		reg = <0x42>;
> +		xclk = <24000000>;
> +		reset-gpios = <&gpio1 8 GPIO_ACTIVE_LOW>;
> +		pwdn-gpios = <&gpio1 6 GPIO_ACTIVE_HIGH>;
> +		gp-gpios = <&gpio1 16 GPIO_ACTIVE_HIGH>;
> +
> +		port {
> +			ov5642_to_ipu1_csi0_mux: endpoint {
> +				remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
> +				bus-width = <8>;
> +				hsync-active = <1>;
> +				vsync-active = <1>;
> +			};
> +		};
> +	};
> +
> +	mipi_camera: ov5640@40 {

Please reorder device nodes by address value, also according to ePAPR
node names should be generic, labels can be specific:

	ov5640: camera@40 {
		...
	};

	ov5642: camera@42 {
		...
	};

> +		compatible = "ovti,ov5640_mipi";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_ov5640>;
> +		clocks = <&mipi_xclk>;
> +		clock-names = "xclk";
> +		reg = <0x40>;
> +		xclk = <22000000>;
> +		reset-gpios = <&gpio2 5 GPIO_ACTIVE_LOW>; /* NANDF_D5 */
> +		pwdn-gpios = <&gpio6 9 GPIO_ACTIVE_HIGH>; /* NANDF_WP_B */
> +
> +		port {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			ov5640_to_mipi_csi: endpoint@1 {
> +				reg = <1>;
> +				remote-endpoint = <&mipi_csi_from_mipi_sensor>;
> +				data-lanes = <0 1>;
> +				clock-lanes = <2>;
> +			};
> +		};
> +	};
>  };
>  
>  &i2c3 {
> @@ -374,7 +444,6 @@
>  				MX6QDL_PAD_RGMII_RX_CTL__RGMII_RX_CTL	0x1b030
>  				/* Phy reset */
>  				MX6QDL_PAD_EIM_D23__GPIO3_IO23		0x000b0
> -				MX6QDL_PAD_GPIO_6__ENET_IRQ		0x000b1

Yep.

>  			>;
>  		};
>  
> @@ -449,6 +518,39 @@
>  			>;
>  		};
>  
> +		pinctrl_ov5642: ov5642grp {
> +			fsl,pins = <
> +				MX6QDL_PAD_SD1_DAT0__GPIO1_IO16 0x80000000
> +				MX6QDL_PAD_GPIO_6__GPIO1_IO06   0x80000000
> +				MX6QDL_PAD_GPIO_8__GPIO1_IO08   0x80000000
> +				MX6QDL_PAD_GPIO_3__CCM_CLKO2    0x80000000
> +			>;
> +		};
> +
> +		pinctrl_ipu1_csi0: ipu1grp-csi0 {

Please rename node name to ipu1csi0grp.

> +			fsl,pins = <
> +				MX6QDL_PAD_CSI0_DAT12__IPU1_CSI0_DATA12    0x80000000
> +				MX6QDL_PAD_CSI0_DAT13__IPU1_CSI0_DATA13    0x80000000
> +				MX6QDL_PAD_CSI0_DAT14__IPU1_CSI0_DATA14    0x80000000
> +				MX6QDL_PAD_CSI0_DAT15__IPU1_CSI0_DATA15    0x80000000
> +				MX6QDL_PAD_CSI0_DAT16__IPU1_CSI0_DATA16    0x80000000
> +				MX6QDL_PAD_CSI0_DAT17__IPU1_CSI0_DATA17    0x80000000
> +				MX6QDL_PAD_CSI0_DAT18__IPU1_CSI0_DATA18    0x80000000
> +				MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19    0x80000000
> +				MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK   0x80000000
> +				MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC      0x80000000
> +				MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC     0x80000000
> +				MX6QDL_PAD_CSI0_DATA_EN__IPU1_CSI0_DATA_EN 0x80000000
> +			>;
> +		};
> +
> +                pinctrl_ov5640: ov5640grp {
> +                        fsl,pins = <
> +				MX6QDL_PAD_NANDF_D5__GPIO2_IO05 0x000b0
> +				MX6QDL_PAD_NANDF_WP_B__GPIO6_IO09 0x0b0b0
> +                        >;
> +                };
> +

Indentation issues above, please use tabs instead of spaces.

Also please add new pin control groups preserving the alphanimerical order.

--
With best wishes,
Vladimir
