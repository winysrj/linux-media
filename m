Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36582 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753095AbcLMSw5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 13:52:57 -0500
Date: Tue, 13 Dec 2016 12:52:54 -0600
From: Rob Herring <robh@kernel.org>
To: Michael Tretter <m.tretter@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v2 1/7] ARM: dts: imx6qdl: Add VDOA compatible and clocks
 properties
Message-ID: <20161213185254.ztedtt3bpod2hbci@rob-hp-laptop>
References: <20161209165903.1293-1-m.tretter@pengutronix.de>
 <20161209165903.1293-2-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161209165903.1293-2-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 09, 2016 at 05:58:57PM +0100, Michael Tretter wrote:
> From: Philipp Zabel <philipp.zabel@gmail.com>
> 
> This adds a compatible property and the correct clock for the
> i.MX6Q Video Data Order Adapter.

This comment matches the dts change, but not the binding change.
 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
> ---
>  .../devicetree/bindings/media/fsl-vdoa.txt          | 21 +++++++++++++++++++++
>  arch/arm/boot/dts/imx6qdl.dtsi                      |  2 ++
>  2 files changed, 23 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/fsl-vdoa.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/fsl-vdoa.txt b/Documentation/devicetree/bindings/media/fsl-vdoa.txt
> new file mode 100644
> index 0000000..5e45f9b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/fsl-vdoa.txt
> @@ -0,0 +1,21 @@
> +Freescale Video Data Order Adapter
> +==================================
> +
> +The Video Data Order Adapter (VDOA) is present on the i.MX6q. Its sole purpose
> +it to to reorder video data from the macroblock tiled order produced by the

s/it to/is/

> +CODA 960 VPU to the conventional raster-scan order for scanout.
> +
> +Required properties:
> +- compatible: must be "fsl,imx6q-vdoa"
> +- reg: the register base and size for the device registers
> +- interrupts: the VDOA interrupt
> +- clocks: the vdoa clock
> +
> +Example:
> +
> +vdoa@021e4000 {

Drop the leading 0.

> +        compatible = "fsl,imx6q-vdoa";
> +        reg = <0x021e4000 0x4000>;
> +        interrupts = <0 18 IRQ_TYPE_LEVEL_HIGH>;
> +        clocks = <&clks IMX6QDL_CLK_VDOA>;
> +};
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> index b13b0b2..69e3668 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -1153,8 +1153,10 @@
>  			};
>  
>  			vdoa@021e4000 {
> +				compatible = "fsl,imx6q-vdoa";
>  				reg = <0x021e4000 0x4000>;
>  				interrupts = <0 18 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clks IMX6QDL_CLK_VDOA>;
>  			};
>  
>  			uart2: serial@021e8000 {
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
