Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36280 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2LKQ4I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 11:56:08 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so2579796wgb.1
        for <linux-media@vger.kernel.org>; Tue, 11 Dec 2012 08:56:06 -0800 (PST)
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC 01/12] s5p-csis: Add device tree support
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
In-Reply-To: <50C717E7.10801@samsung.com>
References: <1355168766-6068-1-git-send-email-s.nawrocki@samsung.com> <1355168766-6068-2-git-send-email-s.nawrocki@samsung.com> <20121211083658.8AEA23E076D@localhost> <50C717E7.10801@samsung.com>
Date: Tue, 11 Dec 2012 16:55:50 +0000
Message-Id: <20121211165550.14BDD3E0C3E@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 11 Dec 2012 12:24:23 +0100, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hello Grant,
> 
> On 12/11/2012 09:36 AM, Grant Likely wrote:
> > On Mon, 10 Dec 2012 20:45:55 +0100, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> >> s5p-csis is platform device driver for MIPI-CSI frontend to the FIMC
> >> (camera host interface DMA engine and image processor). This patch
> >> adds support for instantiating the MIPI-CSIS devices from DT and
> >> parsing all SoC and board specific properties from device tree.
> >>
> >> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >>  .../bindings/media/soc/samsung-mipi-csis.txt       |   82 +++++++++++
> >>  drivers/media/platform/s5p-fimc/mipi-csis.c        |  155 +++++++++++++++-----
> >>  drivers/media/platform/s5p-fimc/mipi-csis.h        |    1 +
> >>  3 files changed, 202 insertions(+), 36 deletions(-)
> >>  create mode 100644 Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt b/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
> >> new file mode 100644
> >> index 0000000..f57cbdc
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
> >> @@ -0,0 +1,82 @@
> >> +Samsung S5P/EXYNOS SoC MIPI-CSI2 receiver (MIPI CSIS)
> >> +-----------------------------------------------------
> >> +
> >> +Required properties:
> >> +
> >> +- compatible	  : "samsung,s5pv210-csis" for S5PV210 SoCs,
> >> +		    "samsung,exynos4210-csis" for Exynos4210 and later SoCs;
> >> +- reg		  : physical base address and size of the device memory mapped
> >> +		    registers;
> >> +- interrupts      : should contain MIPI CSIS interrupt; the format of the
> >> +		    interrupt specifier depends on the interrupt controller;
> >> +- max-data-lanes  : maximum number of data lanes supported (SoC specific);
> >> +- vddio-supply    : MIPI CSIS I/O and PLL voltage supply (e.g. 1.8V);
> >> +- vddcore-supply  : MIPI CSIS Core voltage supply (e.g. 1.1V).
> >> +
> >> +Optional properties:
> >> +
> >> +- clock-frequency : The IP's main (system bus) clock frequency in Hz, default
> >> +		    value when this property is not specified is 166 MHz;
> >> +- samsung,csis,wclk : CSI-2 wrapper clock selection. If this property is present
> >> +		    external clock from CMU will be used, if not bus clock will
> >> +		    be selected.
> >> +
> >> +The device node should contain one 'port' child node with one child 'endpoint'
> >> +node, as outlined in the common media bindings specification. See
> >> +Documentation/devicetree/bindings/media/v4l2.txt for details. The following are
> >> +properties specific to those nodes. (TODO: update the file path)
> >> +
> >> +port node
> >> +---------
> >> +
> >> +- reg		  : (required) must be 2 for camera C input (CSIS0) or 3 for
> >> +		    camera D input (CSIS1);
> > 
> > 'reg' has a very specific definition. If you're going to use a reg
> > property here, then the parent nodes need to have
> > #address-cells=<1>;#size-cells=<0>; properties to define the address
> > specifier format.
> > 
> > However since you're identifying port numbers that aren't really
> > addresses I would suggest simply changing this property to something
> > like 'port-num'.
> > 
> > Otherwise the binding looks good.
> 
> Thank you for the review. Indeed I should have said about #address-cells,
> #size-cells here. I thought using 'reg' was agreed during previous discussions
> on the mailing lists (e.g. [1]), so I just carried on with 'reg'.
> I should just have addressed the comments from Stephen and Rob, instead of
> just resending same version of the documentation. I'll try to take care of
> it in the next post. i.e. rename 'link' node to 'endpoint' and 'remote'
> phandle to 'remote-endpoint'.

Could be. I can't remember what has been discussed from one day to the
next.  :-)  If you've got #address/#size-cells in the binding, then reg is
fine. If that's what you've already got, then just leave it. As long as
the conventions are intact.

g.
