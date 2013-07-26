Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39637 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab3GZPvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 11:51:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jakub Piotr =?utf-8?B?Q8WCYXBh?= <jpc-ml@zenburn.net>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [omapdss] fault in dispc_write_irqenable [was: Re: [omap3isp] xclk deadlock]
Date: Fri, 26 Jul 2013 17:52:51 +0200
Message-ID: <2345948.CFuZYJZjKT@avalon>
In-Reply-To: <51F297C0.1080501@zenburn.net>
References: <51D37796.2000601@zenburn.net> <51F22A58.9030208@ti.com> <51F297C0.1080501@zenburn.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jakub,

On Friday 26 July 2013 17:37:36 Jakub Piotr Cłapa wrote:
> Dear Tomi,
> 
> Thanks for your reply.
> 
> On 26.07.13 09:50, Tomi Valkeinen wrote:
> > Sounds like something is enabling/disabling dispc interrupts after the
> > clocks have already been turned off.
> > 
> > So what's the context here? What kernel?
> 
> This was on 3.10 from Laurent's board/beagle/mt9p031 branch. I am in the
> middle of doing some "bisecting" to figure out some unrelated problems
> with omap3isp so in a couple days I may have more data about which
> versions work and which do not.
> 
> > Using omapfb, or...? I hope not
> > omap_vout, because that's rather unmaintained =).
> 
> Laurent's live application is using the V4L2 API for video output (to
> get free YUV conversion and DMA) so I guess this unfortunatelly counts
> as using omap_vout. Are there any alternatives I should look into? IIUC
> to use omapfb I would need to manually copy RGB data into the
> framebuffer on each frame.

It should be possible to port the live application to use DRM/KMS with omapdrm 
for the display side, without requiring any memory copy. That's somewhere on 
my TODO list, but I won't have time to work on that before way too long.

-- 
Regards,

Laurent Pinchart

