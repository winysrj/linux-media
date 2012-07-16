Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61856 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2GPJNV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 05:13:21 -0400
Date: Mon, 16 Jul 2012 11:13:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com,
	Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [RFC/PATCH 05/13] media: s5p-fimc: Add device tree support for
 FIMC devices
In-Reply-To: <1337975573-27117-5-git-send-email-s.nawrocki@samsung.com>
Message-ID: <Pine.LNX.4.64.1207161110430.12302@axis700.grange>
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
 <1337975573-27117-5-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 May 2012, Sylwester Nawrocki wrote:

> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

>From the documentation below I think, I understand what it does, but why 
is it needed? It doesn't describe your video subsystem topology, right? 
How various subdevices are connected. It just lists them all in one 
node... A description for this patch would be very welcome IMHO and, 
maybe, such a node can be completely avoided?

Thanks
Guennadi

> ---
>  .../bindings/camera/soc/samsung-fimc.txt           |   66 ++++
>  drivers/media/video/s5p-fimc/fimc-capture.c        |    2 +-
>  drivers/media/video/s5p-fimc/fimc-core.c           |  410 +++++++++++---------
>  drivers/media/video/s5p-fimc/fimc-core.h           |    2 -
>  drivers/media/video/s5p-fimc/fimc-mdevice.c        |    8 +-
>  5 files changed, 291 insertions(+), 197 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
> 
> diff --git a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
> new file mode 100644
> index 0000000..1ec48e9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
> @@ -0,0 +1,66 @@
> +Samsung S5P/EXYNOS SoC Camera Subsystem (FIMC)
> +----------------------------------------------
> +
> +The Exynos Camera subsystem uses a dedicated device node associated with
> +top level device driver that manages common properties of the whole subsystem,
> +like common camera port pins or clocks for external image sensors. This
> +aggregate node references related platform sub-devices - FIMC, FIMC-LITE,
> +MIPI-CSIS [1], and it also contains nodes describing image sensors wired to
> +the host SoC's video port and using I2C or SPI as the control bus.
> +
> +
> +Common 'camera' node
> +--------------------
> +
> +Required properties:
> +
> +- compatible	   : must be "samsung,fimc"
> +- fimc-controllers : an array of phandles to 'fimc' device nodes,
> +		     size of this array must be at least 1;
> +
> +Optional properties:
> +
> +- csi-rx-controllers : an array of phandles to 'csis' device nodes,
> +		       it is required for sensors with MIPI-CSI2 bus;
> +
> +'fimc' device node
> +------------------
> +
> +Required properties:
> +
> +- compatible : should be one of:
> +		"samsung,s5pv210-fimc"
> +		"samsung,exynos4210-fimc";
> +		"samsung,exynos4412-fimc";
> +- reg	     : physical base address and size of the device memory mapped
> +	       registers;
> +- interrupts : FIMC interrupt to the CPU should be described here;
> +- cell-index : FIMC IP instance index, the number of available instances
> +	       depends on the SoC revision. For S5PV210 valid values are:
> +	       0...2, for Exynos4x1x: 0...3.
> +
> +Example:
> +
> +	fimc0: fimc@11800000 {
> +		compatible = "samsung,exynos4210-fimc";
> +		reg = <0x11800000 0x1000>;
> +		interrupts = <0 85 0>;
> +		cell-index = <0>;
> +	};
> +
> +	csis0: csis@11880000 {
> +		compatible = "samsung,exynos4210-csis";
> +		reg = <0x11880000 0x1000>;
> +		interrupts = <0 78 0>;
> +		cell-index = <0>;
> +	};
> +
> +	camera {
> +		compatible = "samsung,fimc";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		fimc-controllers = <&fimc0>;
> +		csi-rx-controllers = <&csis0>;
> +	};
> +
> +[1] Documentation/devicetree/bindings/video/samsung-mipi-csis.txt
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
