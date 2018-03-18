Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:44210 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753643AbeCRMsD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Mar 2018 08:48:03 -0400
Date: Sun, 18 Mar 2018 07:48:00 -0500
From: Rob Herring <robh@kernel.org>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        "Signed-off-by : Bob Ham" <rah@settrans.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Florent Revest <revestflo@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Icenowy Zheng <icenowy@aosc.xyz>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas van Kleef <thomas@vitsch.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 6/9] sunxi-cedrus: Add device tree binding document
Message-ID: <20180318124800.7soqh34fxvwjm7pn@rob-hp-laptop>
References: <20180309100933.15922-3-paul.kocialkowski@bootlin.com>
 <20180309101445.16190-4-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180309101445.16190-4-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 09, 2018 at 11:14:42AM +0100, Paul Kocialkowski wrote:
> From: Florent Revest <florent.revest@free-electrons.com>

"device tree binding document" can all be summarized with the subject 
prefix "dt-bindings: media: ".

Also, email should be updated to @bootlin.com?

> 
> Device Tree bindings for the Allwinner's video engine
> 
> Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
> ---
>  .../devicetree/bindings/media/sunxi-cedrus.txt     | 44 ++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/sunxi-cedrus.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/sunxi-cedrus.txt b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
> new file mode 100644
> index 000000000000..138581113c49
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
> @@ -0,0 +1,44 @@
> +Device-Tree bindings for SUNXI video engine found in sunXi SoC family
> +
> +Required properties:
> +- compatible	    : "allwinner,sun4i-a10-video-engine";
> +- memory-region     : DMA pool for buffers allocation;

Why do you need this linkage? Many drivers use CMA and don't need this.

> +- clocks	    : list of clock specifiers, corresponding to
> +		      entries in clock-names property;
> +- clock-names	    : should contain "ahb", "mod" and "ram" entries;
> +- resets	    : phandle for reset;
> +- interrupts	    : should contain VE interrupt number;
> +- reg		    : should contain register base and length of VE.
> +
> +Example:
> +
> +reserved-memory {
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	ranges;
> +
> +	ve_reserved: cma {
> +		compatible = "shared-dma-pool";
> +		reg = <0x43d00000 0x9000000>;
> +		no-map;
> +		linux,cma-default;
> +	};
> +};
> +
> +video-engine {
> +	compatible = "allwinner,sun4i-a10-video-engine";
> +	memory-region = <&ve_reserved>;
> +
> +	clocks = <&ahb_gates 32>, <&ccu CLK_VE>,
> +		 <&dram_gates 0>;
> +	clock-names = "ahb", "mod", "ram";
> +
> +	assigned-clocks = <&ccu CLK_VE>;
> +	assigned-clock-rates = <320000000>;

Not documented.

> +
> +	resets = <&ccu RST_VE>;
> +
> +	interrupts = <53>;
> +
> +	reg = <0x01c0e000 4096>;
> +};
> -- 
> 2.16.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
