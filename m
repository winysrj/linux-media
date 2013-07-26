Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40651 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3GZTMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 15:12:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jakub Piotr =?utf-8?B?Q8WCYXBh?= <jpc-ml@zenburn.net>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [omapdss] fault in dispc_write_irqenable [was: Re: [omap3isp] xclk deadlock]
Date: Fri, 26 Jul 2013 21:13:44 +0200
Message-ID: <1478956.6pKyoNTpv1@avalon>
In-Reply-To: <51F2C7CB.9040806@zenburn.net>
References: <51D37796.2000601@zenburn.net> <2345948.CFuZYJZjKT@avalon> <51F2C7CB.9040806@zenburn.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jakub,

On Friday 26 July 2013 21:02:35 Jakub Piotr Cłapa wrote:
> On 26.07.13 17:52, Laurent Pinchart wrote:
> >>> Using omapfb, or...? I hope not
> >>> omap_vout, because that's rather unmaintained =).
> >> 
> >> Laurent's live application is using the V4L2 API for video output (to
> >> get free YUV conversion and DMA) so I guess this unfortunatelly counts
> >> as using omap_vout. Are there any alternatives I should look into? IIUC
> >> to use omapfb I would need to manually copy RGB data into the
> >> framebuffer on each frame.
> > 
> > It should be possible to port the live application to use DRM/KMS with
> > omapdrm for the display side, without requiring any memory copy. That's
> > somewhere on my TODO list, but I won't have time to work on that before
> > way too long.
> I could look into it myself but is there any documentation on omapdrm?
> 
> From what I found libdrm should probably be used but information about it's
> API is really scarce:
> https://dvdhrm.wordpress.com/2012/09/13/linux-drm-mode-setting-api/
> http://dvdhrm.wordpress.com/2012/12/21/advanced-drm-mode-setting-api/
> http://virtuousgeek.org/blog/index.php/jbarnes/2011/10/31/writing_stanalone_
> programs_with_egl_and_
> 
> The last one seems focused on OpenGL so I don't think it applies.
> 
> Are there any good sources to learn about this? Or maybe some pointers on
> where to start with reading source code?

http://events.linuxfoundation.org/sites/events/files/lcjpcojp13_pinchart.pdf

A bit of shameless self-advertising :-)

It would have been clearer with the video, but it seems the talk hasn't been 
recorded :-/ There's also http://www.youtube.com/watch?v=Ja8fM7rTae4 that 
mostly focuses on the kernel side but starts with explanations of the key KMS 
concepts.

As far as KMS is concerned, libdrm is mostly a wrapper, so any documentation 
on the KMS ioctls can help too.

-- 
Regards,

Laurent Pinchart

