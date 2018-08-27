Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbeH0Kpl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 06:45:41 -0400
Date: Mon, 27 Aug 2018 14:59:29 +0800
From: Shawn Guo <shawnguo@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH 2/3] ARM: dts: imx6ull: add pxp support
Message-ID: <20180827065927.GE3850@dragon>
References: <20180810151822.18650-1-p.zabel@pengutronix.de>
 <20180810151822.18650-3-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180810151822.18650-3-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 10, 2018 at 05:18:21PM +0200, Philipp Zabel wrote:
> Add the device node for the i.MX6ULL Pixel Pipeline (PXP).
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  arch/arm/boot/dts/imx6ul.dtsi  | 8 ++++++++
>  arch/arm/boot/dts/imx6ull.dtsi | 6 ++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
> index 47a3453a4211..e80a660c14f2 100644
> --- a/arch/arm/boot/dts/imx6ul.dtsi
> +++ b/arch/arm/boot/dts/imx6ul.dtsi
> @@ -928,6 +928,14 @@
>  				};
>  			};
>  
> +			pxp: pxp@21cc000 {
> +				compatible = "fsl,imx6ul-pxp";
> +				reg = <0x021cc000 0x4000>;
> +				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
> +				clock-names = "axi";
> +				clocks = <&clks IMX6UL_CLK_PXP>;
> +			};
> +
>  			lcdif: lcdif@21c8000 {

In order of unit-address, pxp@21cc000 should go after lcdif@21c8000.

Shawn

>  				compatible = "fsl,imx6ul-lcdif", "fsl,imx28-lcdif";
>  				reg = <0x021c8000 0x4000>;
> diff --git a/arch/arm/boot/dts/imx6ull.dtsi b/arch/arm/boot/dts/imx6ull.dtsi
> index ebc25c98e5e1..91d2b6dd9b1b 100644
> --- a/arch/arm/boot/dts/imx6ull.dtsi
> +++ b/arch/arm/boot/dts/imx6ull.dtsi
> @@ -75,3 +75,9 @@
>  		};
>  	};
>  };
> +
> +&pxp {
> +	compatible = "fsl,imx6ull-pxp";
> +	interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
> +		     <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
> +};
> -- 
> 2.18.0
> 
