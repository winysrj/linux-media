Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752011AbeECDFS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 23:05:18 -0400
Date: Thu, 3 May 2018 11:05:03 +0800
From: Shawn Guo <shawnguo@kernel.org>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v2 10/15] ARM: dts: imx7s: add multiplexer controls
Message-ID: <20180503030501.GQ3443@dragon>
References: <20180423134750.30403-1-rui.silva@linaro.org>
 <20180423134750.30403-11-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180423134750.30403-11-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 23, 2018 at 02:47:45PM +0100, Rui Miguel Silva wrote:
> The IOMUXC General Purpose Register has bitfield to control video bus
> multiplexer to control the CSI input between the MIPI-CSI2 and parallel
> interface. Add that register and mask.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  arch/arm/boot/dts/imx7s.dtsi | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
> index d913c3f9c284..3027d6a62021 100644
> --- a/arch/arm/boot/dts/imx7s.dtsi
> +++ b/arch/arm/boot/dts/imx7s.dtsi
> @@ -534,8 +534,15 @@
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
> +

The newline in between property list is not really necessary.

Shawn

> +					mux-reg-masks = <0x14 0x00000010>;
> +				};
>  			};
>  
>  			ocotp: ocotp-ctrl@30350000 {
> -- 
> 2.17.0
> 
