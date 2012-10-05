Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:44405 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663Ab2JEQR7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 12:17:59 -0400
Message-ID: <506F0833.1090704@wwwdotorg.org>
Date: Fri, 05 Oct 2012 10:17:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de> <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de> <Pine.LNX.4.64.1210042307300.3744@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210042307300.3744@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/04/2012 03:35 PM, Guennadi Liakhovetski wrote:
> Hi Steffen
> 
> Sorry for chiming in so late in the game, but I've long been wanting to 
> have a look at this and compare with what we do for V4L2, so, this seems a 
> great opportunity to me:-)
> 
> On Thu, 4 Oct 2012, Steffen Trumtrar wrote:

>> diff --git a/Documentation/devicetree/bindings/video/display-timings.txt b/Documentation/devicetree/bindings/video/display-timings.txt

>> +timings-subnode
>> +---------------
>> +
>> +required properties:
>> + - hactive, vactive: Display resolution
>> + - hfront-porch, hback-porch, hsync-len: Horizontal Display timing parameters
>> +   in pixels
>> +   vfront-porch, vback-porch, vsync-len: Vertical display timing parameters in
>> +   lines
>> + - clock: displayclock in Hz
> 
> You're going to hate me for this, but eventually we want to actually 
> reference clock objects in our DT bindings. For now, even if you don't 
> want to actually add clock phandles and stuff here, I think, using the 
> standard "clock-frequency" property would be much better!

In a definition of a display timing, we will never need to use the clock
binding; the clock binding would be used by the HW module that is
generating a timing, not by the timing definition itself.

That said, your comment about renaming the property to avoid any kind of
conceptual conflict is still quite valid. This is bike-shedding, but
"pixel-clock" might be more in line with typical video mode terminology,
although there's certainly preference in DT for using the generic term
clock-frequency that you proposed. Either is fine by me.

>> +optional properties:
>> + - hsync-active-high (bool): Hsync pulse is active high
>> + - vsync-active-high (bool): Vsync pulse is active high
> 
> For the above two we also considered using bool properties but eventually 
> settled down with integer ones:
> 
> - hsync-active = <1>
> 
> for active-high and 0 for active low. This has the added advantage of 
> being able to omit this property in the .dts, which then doesn't mean, 
> that the polarity is active low, but rather, that the hsync line is not 
> used on this hardware. So, maybe it would be good to use the same binding 
> here too?

I agree. This also covers the case where analog display connectors often
use polarity to differentiate similar modes, yet digital connectors
often always use a fixed polarity since the receiving device can
"measure" the signal in more complete ways.

If the board HW inverts these lines, the same property names can exist
in the display controller itself, and the two values XORd together to
yield the final output polarity.

>> + - de-active-high (bool): Data-Enable pulse is active high
>> + - pixelclk-inverted (bool): pixelclock is inverted
> 
> We don't (yet) have a de-active property in V4L, don't know whether we'll 
> ever have to distingsuish between what some datasheets call "HREF" and 
> HSYNC in DT, but maybe similarly to the above an integer would be 
> preferred. As for pixclk, we call the property "pclk-sample" and it's also 
> an integer.

Thinking about this more: de-active-high is likely to be a
board-specific property and hence something in the display controller,
not in the mode definition?

>> + - interlaced (bool)
> 
> Is "interlaced" a property of the hardware, i.e. of the board? Can the 
> same display controller on one board require interlaced data and on 
> another board - progressive?

Interlace is a property of a display mode. It's quite possible for a
particular display controller to switch between interlace and
progressive output at run-time. For example, reconfiguring the output
between 480i, 720p, 1080i, 1080p modes. Admittedly, if you're talking to
a built-in LCD display, you're probably always going to be driving the
single mode required by the panel, and that mode will likely always be
progressive. However, since this binding attempts to describe any
display timing, I think we still need this property per mode.

> BTW, I'm not very familiar with display 
> interfaces, but for interlaced you probably sometimes use a field signal, 
> whose polarity you also want to specify here? We use a "field-even-active" 
> integer property for it.

I think that's a property of the display controller itself, rather than
an individual mode, although I'm not 100% certain. My assertion is that
the physical interface that the display controller is driving will
determine whether embedded or separate sync is used, and in the separate
sync case, how the field signal is defined, and that all interlace modes
driven over that interface will use the same field signal definition.
