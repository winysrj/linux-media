Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57025 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2GPIz7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 04:55:59 -0400
Date: Mon, 16 Jul 2012 10:55:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 02/13] media: s5p-csis: Add device tree support
In-Reply-To: <1337975573-27117-2-git-send-email-s.nawrocki@samsung.com>
Message-ID: <Pine.LNX.4.64.1207161031000.12302@axis700.grange>
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
 <1337975573-27117-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

Thanks for your comments to my RFC and for pointing out to this your 
earlier patch series. Unfortunately, I missed in in May, let me try to 
provide some thoughts about this, we should really try to converge our 
proposals. Maybe a discussion at KS would help too.

On Fri, 25 May 2012, Sylwester Nawrocki wrote:

> s5p-csis is platform device driver for MIPI-CSI frontend to the FIMC
> (camera host interface DMA engine and image processor). This patch
> adds support for instantiating the MIPI-CSIS devices from DT and
> parsing all SoC and board specific properties from device tree.
> The MIPI DPHY control callback is now called directly from within
> the driver, the platform code must ensure this callback does the
> right thing for each SoC.
> 
> The cell-index property is used to ensure proper signal routing,
> from physical camera port, through MIPI-CSI2 receiver to the DMA
> engine (FIMC?). It's also helpful in exposing the device topology
> in user space at /dev/media? devnode (Media Controller API).
> 
> This patch also defines a common property ("data-lanes") for MIPI-CSI
> receivers and transmitters.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/devicetree/bindings/video/mipi.txt   |    5 +
>  .../bindings/video/samsung-mipi-csis.txt           |   47 ++++++++++
>  drivers/media/video/s5p-fimc/mipi-csis.c           |   97 +++++++++++++++-----
>  drivers/media/video/s5p-fimc/mipi-csis.h           |    1 +
>  4 files changed, 126 insertions(+), 24 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/video/mipi.txt
>  create mode 100644 Documentation/devicetree/bindings/video/samsung-mipi-csis.txt
> 
> diff --git a/Documentation/devicetree/bindings/video/mipi.txt b/Documentation/devicetree/bindings/video/mipi.txt
> new file mode 100644
> index 0000000..5aed285
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/mipi.txt
> @@ -0,0 +1,5 @@
> +Common properties of MIPI-CSI1 and MIPI-CSI2 receivers and transmitters
> +
> + - data-lanes : number of differential data lanes wired and actively used in
> +		communication between the transmitter and the receiver, this
> +		excludes the clock lane;

Wouldn't it be better to use the standard "bus-width" DT property?

> diff --git a/Documentation/devicetree/bindings/video/samsung-mipi-csis.txt b/Documentation/devicetree/bindings/video/samsung-mipi-csis.txt
> new file mode 100644
> index 0000000..7bce6f4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/samsung-mipi-csis.txt
> @@ -0,0 +1,47 @@
> +Samsung S5P/EXYNOS SoC MIPI-CSI2 receiver (MIPI CSIS)
> +-----------------------------------------------------
> +
> +Required properties:
> +
> +- compatible - one of :
> +		"samsung,s5pv210-csis",
> +		"samsung,exynos4210-csis",
> +		"samsung,exynos4212-csis",
> +		"samsung,exynos4412-csis";
> +- reg : physical base address and size of the device memory mapped registers;
> +- interrupts      : should contain MIPI CSIS interrupt; the format of the
> +		    interrupt specifier depends on the interrupt controller;
> +- cell-index      : the hardware instance index;

Not sure whether this is absolutely needed... Wouldn't it be sufficient to 
just enumerate them during probing?

> +- clock-frequency : The IP's main (system bus) clock frequency in Hz, the default
> +		    value when this property is not specified is 166 MHz;
> +- data-lanes      : number of physical MIPI-CSI2 lanes used;

ditto - bus-width?

> +- samsung,csis-hs-settle : differential receiver (HS-RX) settle time;
> +- vddio-supply    : MIPI CSIS I/O and PLL voltage supply (e.g. 1.8V);
> +- vddcore-supply  : MIPI CSIS Core voltage supply (e.g. 1.1V).
> +
> +Example:
> +
> +	reg0: regulator@0 {
> +	};
> +
> +	reg1: regulator@1 {
> +	};
> +
> +/* SoC properties */
> +
> +	csis@11880000 {
> +		compatible = "samsung,exynos4210-csis";
> +		reg = <0x11880000 0x1000>;
> +		interrupts = <0 78 0>;
> +		cell-index = <0>;
> +	};
> +
> +/* Board properties */
> +
> +	csis@11880000 {
> +		clock-frequency = <166000000>;
> +		data-lanes = <2>;
> +		samsung,csis-hs-settle = <12>;
> +		vddio-supply = <&reg0>;
> +		vddcore-supply = <&reg1>;
> +	};

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
