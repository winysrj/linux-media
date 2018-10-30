Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:56352 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbeJ3V7r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 17:59:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Yong Deng <yong.deng@magewell.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v12 1/2] dt-bindings: media: Add Allwinner V3s Camera Sensor Interface (CSI)
Date: Tue, 30 Oct 2018 15:06:24 +0200
Message-ID: <308184907.pMD7ZDI2dr@avalon>
In-Reply-To: <1540887143-27904-1-git-send-email-yong.deng@magewell.com>
References: <1540887143-27904-1-git-send-email-yong.deng@magewell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

Thank you for the patch.

On Tuesday, 30 October 2018 10:12:23 EET Yong Deng wrote:
> Add binding documentation for Allwinner V3s CSI.
> 
> Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Yong Deng <yong.deng@magewell.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  .../devicetree/bindings/media/sun6i-csi.txt        | 56 +++++++++++++++++++
>  1 file changed, 56 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt
> b/Documentation/devicetree/bindings/media/sun6i-csi.txt new file mode
> 100644
> index 000000000000..443e18c181b3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> @@ -0,0 +1,56 @@
> +Allwinner V3s Camera Sensor Interface
> +-------------------------------------
> +
> +Allwinner V3s SoC features a CSI module(CSI1) with parallel interface.
> +
> +Required properties:
> +  - compatible: value must be "allwinner,sun8i-v3s-csi"
> +  - reg: base address and size of the memory-mapped region.
> +  - interrupts: interrupt associated to this IP
> +  - clocks: phandles to the clocks feeding the CSI
> +    * bus: the CSI interface clock
> +    * mod: the CSI module clock
> +    * ram: the CSI DRAM clock
> +  - clock-names: the clock names mentioned above
> +  - resets: phandles to the reset line driving the CSI
> +
> +The CSI node should contain one 'port' child node with one child 'endpoint'
> +node, according to the bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Endpoint node properties for CSI
> +---------------------------------
> +See the video-interfaces.txt for a detailed description of these
> properties. +- remote-endpoint	: (required) a phandle to the bus receiver's
> endpoint +			   node
> +- bus-width:		: (required) must be 8, 10, 12 or 16
> +- pclk-sample		: (optional) (default: sample on falling edge)
> +- hsync-active		: (required; parallel-only)
> +- vsync-active		: (required; parallel-only)
> +
> +Example:
> +
> +csi1: csi@1cb4000 {
> +	compatible = "allwinner,sun8i-v3s-csi";
> +	reg = <0x01cb4000 0x1000>;
> +	interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
> +	clocks = <&ccu CLK_BUS_CSI>,
> +		 <&ccu CLK_CSI1_SCLK>,
> +		 <&ccu CLK_DRAM_CSI>;
> +	clock-names = "bus", "mod", "ram";
> +	resets = <&ccu RST_BUS_CSI>;
> +
> +	port {
> +		/* Parallel bus endpoint */
> +		csi1_ep: endpoint {
> +			remote-endpoint = <&adv7611_ep>;
> +			bus-width = <16>;
> +
> +			/* If hsync-active/vsync-active are missing,
> +			   embedded BT.656 sync is used */
> +			hsync-active = <0>; /* Active low */
> +			vsync-active = <0>; /* Active low */
> +			pclk-sample = <1>;  /* Rising */
> +		};
> +	};
> +};


-- 
Regards,

Laurent Pinchart
