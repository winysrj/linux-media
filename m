Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53975 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946359Ab2JDVfn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 17:35:43 -0400
Date: Thu, 4 Oct 2012 23:35:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: =?UTF-8?q?=5BPATCH=201/2=20v6=5D=20of=3A=20add=20helper=20to=20parse=20display=20timings?=
In-Reply-To: <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1210042307300.3744@axis700.grange>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
 <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steffen

Sorry for chiming in so late in the game, but I've long been wanting to 
have a look at this and compare with what we do for V4L2, so, this seems a 
great opportunity to me:-)

On Thu, 4 Oct 2012, Steffen Trumtrar wrote:

> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
>  .../devicetree/bindings/video/display-timings.txt  |  222 ++++++++++++++++++++
>  drivers/of/Kconfig                                 |    5 +
>  drivers/of/Makefile                                |    1 +
>  drivers/of/of_display_timings.c                    |  183 ++++++++++++++++
>  include/linux/of_display_timings.h                 |   85 ++++++++
>  5 files changed, 496 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/display-timings.txt
>  create mode 100644 drivers/of/of_display_timings.c
>  create mode 100644 include/linux/of_display_timings.h
> 
> diff --git a/Documentation/devicetree/bindings/video/display-timings.txt b/Documentation/devicetree/bindings/video/display-timings.txt
> new file mode 100644
> index 0000000..45e39bd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/display-timings.txt
> @@ -0,0 +1,222 @@
> +display-timings bindings
> +==================
> +
> +display-timings-node
> +------------
> +
> +required properties:
> + - none
> +
> +optional properties:
> + - default-timing: the default timing value
> +
> +timings-subnode
> +---------------
> +
> +required properties:
> + - hactive, vactive: Display resolution
> + - hfront-porch, hback-porch, hsync-len: Horizontal Display timing parameters
> +   in pixels
> +   vfront-porch, vback-porch, vsync-len: Vertical display timing parameters in
> +   lines
> + - clock: displayclock in Hz

You're going to hate me for this, but eventually we want to actually 
reference clock objects in our DT bindings. For now, even if you don't 
want to actually add clock phandles and stuff here, I think, using the 
standard "clock-frequency" property would be much better!

> +
> +optional properties:
> + - hsync-active-high (bool): Hsync pulse is active high
> + - vsync-active-high (bool): Vsync pulse is active high

For the above two we also considered using bool properties but eventually 
settled down with integer ones:

- hsync-active = <1>

for active-high and 0 for active low. This has the added advantage of 
being able to omit this property in the .dts, which then doesn't mean, 
that the polarity is active low, but rather, that the hsync line is not 
used on this hardware. So, maybe it would be good to use the same binding 
here too?

> + - de-active-high (bool): Data-Enable pulse is active high
> + - pixelclk-inverted (bool): pixelclock is inverted

We don't (yet) have a de-active property in V4L, don't know whether we'll 
ever have to distingsuish between what some datasheets call "HREF" and 
HSYNC in DT, but maybe similarly to the above an integer would be 
preferred. As for pixclk, we call the property "pclk-sample" and it's also 
an integer.

> + - interlaced (bool)

Is "interlaced" a property of the hardware, i.e. of the board? Can the 
same display controller on one board require interlaced data and on 
another board - progressive? BTW, I'm not very familiar with display 
interfaces, but for interlaced you probably sometimes use a field signal, 
whose polarity you also want to specify here? We use a "field-even-active" 
integer property for it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
