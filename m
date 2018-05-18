Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46511 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752026AbeERQJH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 12:09:07 -0400
Message-ID: <1526659737.3948.19.camel@pengutronix.de>
Subject: Re: [PATCH v5 06/12] media: dt-bindings: add bindings for i.MX7
 media driver
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
        Ryan Harkin <ryan.harkin@linaro.org>, linux-clk@vger.kernel.org
Date: Fri, 18 May 2018 18:08:57 +0200
In-Reply-To: <20180518092806.3829-7-rui.silva@linaro.org>
References: <20180518092806.3829-1-rui.silva@linaro.org>
         <20180518092806.3829-7-rui.silva@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-05-18 at 10:28 +0100, Rui Miguel Silva wrote:
> Add bindings documentation for i.MX7 media drivers.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  .../devicetree/bindings/media/imx7.txt        | 125 ++++++++++++++++++
>  1 file changed, 125 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/imx7.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/imx7.txt b/Documentation/devicetree/bindings/media/imx7.txt
> new file mode 100644
> index 000000000000..a26372630377
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/imx7.txt
> @@ -0,0 +1,125 @@
> +Freescale i.MX7 Media Video Device
> +==================================
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
> +- bus-width     : maximum number of data lanes supported (SoC specific);
> +
> +Optional properties:
> +
> +- clock-frequency : The IP's main (system bus) clock frequency in Hz, default
> +		    value when this property is not specified is 166 MHz;

Could this be obtained from one of the clock inputs via clk_get_rate?

regards
Philipp
