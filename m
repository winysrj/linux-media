Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:41455 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751221AbeERQuY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 12:50:24 -0400
Date: Fri, 18 May 2018 11:50:22 -0500
From: Rob Herring <robh@kernel.org>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>, linux-clk@vger.kernel.org
Subject: Re: [PATCH v5 07/12] ARM: dts: imx7s: add mipi phy power domain
Message-ID: <20180518165022.GB21131@rob-hp-laptop>
References: <20180518092806.3829-1-rui.silva@linaro.org>
 <20180518092806.3829-8-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518092806.3829-8-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 18, 2018 at 10:28:01AM +0100, Rui Miguel Silva wrote:
> Add power domain index 0 related with mipi-phy to imx7s.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  arch/arm/boot/dts/imx7s.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
> index 4d42335c0dee..67450ad89940 100644
> --- a/arch/arm/boot/dts/imx7s.dtsi
> +++ b/arch/arm/boot/dts/imx7s.dtsi
> @@ -636,6 +636,12 @@
>  					#address-cells = <1>;
>  					#size-cells = <0>;
>  
> +					pgc_mipi_phy: pgc-power-domain@0 {

power-domain@0

> +						#power-domain-cells = <0>;
> +						reg = <0>;
> +						power-supply = <&reg_1p0d>;
> +					};
> +
>  					pgc_pcie_phy: pgc-power-domain@1 {

ditto.

>  						#power-domain-cells = <0>;
>  						reg = <1>;
> -- 
> 2.17.0
> 
