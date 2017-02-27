Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:35694 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbdB0Opl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 09:45:41 -0500
Date: Mon, 27 Feb 2017 08:45:39 -0600
From: Rob Herring <robh@kernel.org>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 24/36] [media] add Omnivision OV5640 sensor driver
Message-ID: <20170227144539.3la2veztkurhwa2p@rob-hp-laptop>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-25-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487211578-11360-25-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 15, 2017 at 06:19:26PM -0800, Steve Longerbeam wrote:
> This driver is based on ov5640_mipi.c from Freescale imx_3.10.17_1.0.0_beta
> branch, modified heavily to bring forward to latest interfaces and code
> cleanup.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  .../devicetree/bindings/media/i2c/ov5640.txt       |   43 +

Please split to separate commit.

>  drivers/media/i2c/Kconfig                          |    7 +
>  drivers/media/i2c/Makefile                         |    1 +
>  drivers/media/i2c/ov5640.c                         | 2109 ++++++++++++++++++++
>  4 files changed, 2160 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5640.txt
>  create mode 100644 drivers/media/i2c/ov5640.c
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> new file mode 100644
> index 0000000..4607bbe
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> @@ -0,0 +1,43 @@
> +* Omnivision OV5640 MIPI CSI-2 sensor
> +
> +Required Properties:
> +- compatible: should be "ovti,ov5640"
> +- clocks: reference to the xclk input clock.
> +- clock-names: should be "xclk".
> +- DOVDD-supply: Digital I/O voltage supply, 1.8 volts
> +- AVDD-supply: Analog voltage supply, 2.8 volts
> +- DVDD-supply: Digital core voltage supply, 1.5 volts
> +
> +Optional Properties:
> +- reset-gpios: reference to the GPIO connected to the reset pin, if any.
> +- pwdn-gpios: reference to the GPIO connected to the pwdn pin, if any.

Use powerdown-gpios here as that is a somewhat standard name.

Both need to state what is the active state.

> +
> +The device node must contain one 'port' child node for its digital output
> +video port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +&i2c1 {
> +	ov5640: camera@3c {
> +		compatible = "ovti,ov5640";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_ov5640>;
> +		reg = <0x3c>;
> +		clocks = <&clks IMX6QDL_CLK_CKO>;
> +		clock-names = "xclk";
> +		DOVDD-supply = <&vgen4_reg>; /* 1.8v */
> +		AVDD-supply = <&vgen3_reg>;  /* 2.8v */
> +		DVDD-supply = <&vgen2_reg>;  /* 1.5v */
> +		pwdn-gpios = <&gpio1 19 GPIO_ACTIVE_HIGH>;
> +		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>;
> +
> +		port {
> +			ov5640_to_mipi_csi2: endpoint {
> +				remote-endpoint = <&mipi_csi2_from_ov5640>;
> +				clock-lanes = <0>;
> +				data-lanes = <1 2>;
> +			};
> +		};
> +	};
> +};
