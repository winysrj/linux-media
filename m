Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55215 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2LKIhv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 03:37:51 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so2108452wib.1
        for <linux-media@vger.kernel.org>; Tue, 11 Dec 2012 00:37:50 -0800 (PST)
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC 01/12] s5p-csis: Add device tree support
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, rob.herring@calxeda.com,
	thomas.abraham@linaro.org, t.figa@samsung.com,
	sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
In-Reply-To: <1355168766-6068-2-git-send-email-s.nawrocki@samsung.com>
References: <1355168766-6068-1-git-send-email-s.nawrocki@samsung.com> <1355168766-6068-2-git-send-email-s.nawrocki@samsung.com>
Date: Tue, 11 Dec 2012 08:36:58 +0000
Message-Id: <20121211083658.8AEA23E076D@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 10 Dec 2012 20:45:55 +0100, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> s5p-csis is platform device driver for MIPI-CSI frontend to the FIMC
> (camera host interface DMA engine and image processor). This patch
> adds support for instantiating the MIPI-CSIS devices from DT and
> parsing all SoC and board specific properties from device tree.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../bindings/media/soc/samsung-mipi-csis.txt       |   82 +++++++++++
>  drivers/media/platform/s5p-fimc/mipi-csis.c        |  155 +++++++++++++++-----
>  drivers/media/platform/s5p-fimc/mipi-csis.h        |    1 +
>  3 files changed, 202 insertions(+), 36 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt b/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
> new file mode 100644
> index 0000000..f57cbdc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
> @@ -0,0 +1,82 @@
> +Samsung S5P/EXYNOS SoC MIPI-CSI2 receiver (MIPI CSIS)
> +-----------------------------------------------------
> +
> +Required properties:
> +
> +- compatible	  : "samsung,s5pv210-csis" for S5PV210 SoCs,
> +		    "samsung,exynos4210-csis" for Exynos4210 and later SoCs;
> +- reg		  : physical base address and size of the device memory mapped
> +		    registers;
> +- interrupts      : should contain MIPI CSIS interrupt; the format of the
> +		    interrupt specifier depends on the interrupt controller;
> +- max-data-lanes  : maximum number of data lanes supported (SoC specific);
> +- vddio-supply    : MIPI CSIS I/O and PLL voltage supply (e.g. 1.8V);
> +- vddcore-supply  : MIPI CSIS Core voltage supply (e.g. 1.1V).
> +
> +Optional properties:
> +
> +- clock-frequency : The IP's main (system bus) clock frequency in Hz, default
> +		    value when this property is not specified is 166 MHz;
> +- samsung,csis,wclk : CSI-2 wrapper clock selection. If this property is present
> +		    external clock from CMU will be used, if not bus clock will
> +		    be selected.
> +
> +The device node should contain one 'port' child node with one child 'endpoint'
> +node, as outlined in the common media bindings specification. See
> +Documentation/devicetree/bindings/media/v4l2.txt for details. The following are
> +properties specific to those nodes. (TODO: update the file path)
> +
> +port node
> +---------
> +
> +- reg		  : (required) must be 2 for camera C input (CSIS0) or 3 for
> +		    camera D input (CSIS1);

'reg' has a very specific definition. If you're going to use a reg
property here, then the parent nodes need to have
#address-cells=<1>;#size-cells=<0>; properties to define the address
specifier format.

However since you're identifying port numbers that aren't really
addresses I would suggest simply changing this property to something
like 'port-num'.

Otherwise the binding looks good.

g.

