Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38035 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934007AbeEII7V (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 04:59:21 -0400
Message-ID: <1525856353.5888.6.camel@pengutronix.de>
Subject: Re: [PATCH v3 09/14] ARM: dts: imx7s: add multiplexer controls
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
Date: Wed, 09 May 2018 10:59:13 +0200
In-Reply-To: <20180507162152.2545-10-rui.silva@linaro.org>
References: <20180507162152.2545-1-rui.silva@linaro.org>
         <20180507162152.2545-10-rui.silva@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-05-07 at 17:21 +0100, Rui Miguel Silva wrote:
> The IOMUXC General Purpose Register has bitfield to control video bus
> multiplexer to control the CSI input between the MIPI-CSI2 and parallel
> interface. Add that register and mask.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  arch/arm/boot/dts/imx7s.dtsi | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
> index 67450ad89940..3590dab529f9 100644
> --- a/arch/arm/boot/dts/imx7s.dtsi
> +++ b/arch/arm/boot/dts/imx7s.dtsi
> @@ -520,8 +520,14 @@
>  
>  			gpr: iomuxc-gpr@30340000 {
>  				compatible = "fsl,imx7d-iomuxc-gpr",
> -					"fsl,imx6q-iomuxc-gpr", "syscon";
> +					"fsl,imx6q-iomuxc-gpr", "syscon", "simple-mfd";
>  				reg = <0x30340000 0x10000>;
> +
> +				mux: mux-controller {
> +					compatible = "mmio-mux";
> +					#mux-control-cells = <1>;
> +					mux-reg-masks = <0x14 0x00000010>;
> +				};
>  			};
>  
>  			ocotp: ocotp-ctrl@30350000 {

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
