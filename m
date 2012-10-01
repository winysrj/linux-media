Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:59579 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab2JAQxN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 12:53:13 -0400
Message-ID: <5069CA74.7040409@wwwdotorg.org>
Date: Mon, 01 Oct 2012 10:53:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] of: add helper to parse display specs
References: <1348500924-8551-1-git-send-email-s.trumtrar@pengutronix.de> <1348500924-8551-2-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1348500924-8551-2-git-send-email-s.trumtrar@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/24/2012 09:35 AM, Steffen Trumtrar wrote:
> Parse a display-node with timings and hardware-specs from devictree.

> diff --git a/Documentation/devicetree/bindings/video/display b/Documentation/devicetree/bindings/video/display
> new file mode 100644
> index 0000000..722766a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/display

This should be display.txt.

> @@ -0,0 +1,208 @@
> +display bindings
> +==================
> +
> +display-node
> +------------

I'm not personally convinced about the direction this is going. While I
think it's reasonable to define DT bindings for displays, and DT
bindings for display modes, I'm not sure that it's reasonable to couple
them together into a single binding.

I think creating a well-defined timing binding first will be much
simpler than doing so within the context of a display binding; the
scope/content of a general display binding seems much less well-defined
to me at least, for reasons I mentioned before.

> +required properties:
> + - none
> +
> +optional properties:
> + - default-timing: the default timing value
> + - width-mm, height-mm: Display dimensions in mm

> + - hsync-active-high (bool): Hsync pulse is active high
> + - vsync-active-high (bool): Vsync pulse is active high

At least those two properties should exist in the display timing instead
(or perhaps as well). There are certainly cases where different similar
display modes are differentiated by hsync/vsync polarity more than
anything else. This is probably more likely with analog display
connectors than digital, but I see no reason why a DT binding for
display timing shouldn't cover both.

> + - de-active-high (bool): Data-Enable pulse is active high
> + - pixelclk-inverted (bool): pixelclock is inverted

> + - pixel-per-clk

pixel-per-clk is probably something that should either be part of the
timing definition, or something computed internally to the display
driver based on rules for the signal type, rather than something
represented in DT.

The above comment assumes this property is intended to represent DVI's
requirement for pixel clock doubling for low-pixel-clock-rate modes. If
it's something to do with e.g. a single-data-rate vs. double-data-rate
property of the underlying physical connection, that's most likely
something that should be defined in a binding specific to e.g. LVDS,
rather than something generic.

> + - link-width: number of channels (e.g. LVDS)
> + - bpp: bits-per-pixel
> +
> +timings-subnode
> +---------------
> +
> +required properties:
> +subnodes that specify
> + - hactive, vactive: Display resolution
> + - hfront-porch, hback-porch, hsync-len: Horizontal Display timing parameters
> +   in pixels
> +   vfront-porch, vback-porch, vsync-len: Vertical display timing parameters in
> +   lines
> + - clock: displayclock in Hz
> +
> +There are different ways of describing a display and its capabilities. The devicetree
> +representation corresponds to the one commonly found in datasheets for displays.
> +The description of the display and its timing is split in two parts: first the display
> +properties like size in mm and (optionally) multiple subnodes with the supported timings.
> +If a display supports multiple signal timings, the default-timing can be specified.
> +
> +Example:
> +
> +	display@0 {
> +		width-mm = <800>;
> +		height-mm = <480>;
> +		default-timing = <&timing0>;
> +		timings {
> +			timing0: timing@0 {

If you're going to use a unit address ("@0") to ensure that node names
are unique (which is not mandatory), then each node also needs a reg
property with matching value, and #address-cells/#size-cells in the
parent. Instead, you could name the nodes something unique based on the
mode name to avoid this, e.g. 1080p24 { ... }.

