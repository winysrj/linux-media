Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:37388 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753396AbdADMeL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 07:34:11 -0500
Subject: Re: [PATCH v2 05/19] ARM: dts: imx6-sabresd: add OV5642 and OV5640
 camera sensors
To: Steve Longerbeam <slongerbeam@gmail.com>, <shawnguo@kernel.org>,
        <kernel@pengutronix.de>, <fabio.estevam@nxp.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linux@armlinux.org.uk>, <mchehab@kernel.org>,
        <gregkh@linuxfoundation.org>, <p.zabel@pengutronix.de>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
 <1483477049-19056-6-git-send-email-steve_longerbeam@mentor.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <c8c09060-dd6b-f495-da7d-b1f9fad79b89@mentor.com>
Date: Wed, 4 Jan 2017 14:33:07 +0200
MIME-Version: 1.0
In-Reply-To: <1483477049-19056-6-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2017 10:57 PM, Steve Longerbeam wrote:
> Enables the OV5642 parallel-bus sensor, and the OV5640 MIPI CSI-2 sensor.
> 
> The OV5642 connects to the parallel-bus mux input port on ipu1_csi0_mux.
> 
> The OV5640 connects to the input port on the MIPI CSI-2 receiver on
> mipi_csi. It is set to transmit over MIPI virtual channel 1.
> 
> Until the OV5652 sensor module compatible with the SabreSD becomes
> available for testing, the ov5642 node is currently disabled.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---

[snip]

> +
> +	camera: ov5642@3c {

ov5642: camera@3c

> +		compatible = "ovti,ov5642";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_ov5642>;
> +		clocks = <&clks IMX6QDL_CLK_CKO>;
> +		clock-names = "xclk";
> +		reg = <0x3c>;
> +		xclk = <24000000>;
> +		DOVDD-supply = <&vgen4_reg>; /* 1.8v */
> +		AVDD-supply = <&vgen5_reg>;  /* 2.8v, rev C board is VGEN3
> +						rev B board is VGEN5 */
> +		DVDD-supply = <&vgen2_reg>;  /* 1.5v*/
> +		pwdn-gpios = <&gpio1 16 GPIO_ACTIVE_HIGH>; /* SD1_DAT0 */
> +		reset-gpios = <&gpio1 17 GPIO_ACTIVE_LOW>; /* SD1_DAT1 */

Comments about SD1_* pad names are redundant.

> +		status = "disabled";

Why is it disabled here?

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
>  };
>  
>  &i2c2 {
> @@ -322,6 +376,34 @@
>  			};
>  		};
>  	};
> +
> +	mipi_camera: ov5640@3c {

ov5640: camera@3c

> +		compatible = "ovti,ov5640_mipi";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_ov5640>;
> +		reg = <0x3c>;
> +		clocks = <&clks IMX6QDL_CLK_CKO>;
> +		clock-names = "xclk";
> +		xclk = <24000000>;
> +		DOVDD-supply = <&vgen4_reg>; /* 1.8v */
> +		AVDD-supply = <&vgen5_reg>;  /* 2.8v, rev C board is VGEN3
> +						rev B board is VGEN5 */
> +		DVDD-supply = <&vgen2_reg>;  /* 1.5v*/
> +		pwdn-gpios = <&gpio1 19 GPIO_ACTIVE_HIGH>; /* SD1_DAT2 */
> +		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>; /* SD1_CLK */

Comments about SD1_* pad names are redundant.

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
> @@ -426,6 +508,36 @@
>  			>;
>  		};
>  
> +		pinctrl_ov5640: ov5640grp {
> +			fsl,pins = <
> +				MX6QDL_PAD_SD1_DAT2__GPIO1_IO19 0x80000000
> +				MX6QDL_PAD_SD1_CLK__GPIO1_IO20  0x80000000
> +			>;
> +		};
> +
> +		pinctrl_ov5642: ov5642grp {
> +			fsl,pins = <
> +				MX6QDL_PAD_SD1_DAT0__GPIO1_IO16 0x80000000
> +				MX6QDL_PAD_SD1_DAT1__GPIO1_IO17 0x80000000
> +			>;
> +		};
> +
> +		pinctrl_ipu1_csi0: ipu1grp-csi0 {

Please rename the node name to ipu1csi0grp.

Please add new pin control groups preserving the alphanimerical order.

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
> +			>;
> +		};
> +
>  		pinctrl_pcie: pciegrp {
>  			fsl,pins = <
>  				MX6QDL_PAD_GPIO_17__GPIO7_IO12	0x1b0b0
> 

--
With best wishes,
Vladimir
