Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:55972 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab3GZPhj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 11:37:39 -0400
Received: by mail-ee0-f41.google.com with SMTP id d17so1145657eek.28
        for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 08:37:38 -0700 (PDT)
Message-ID: <51F297C0.1080501@zenburn.net>
Date: Fri, 26 Jul 2013 17:37:36 +0200
From: =?UTF-8?B?SmFrdWIgUGlvdHIgQ8WCYXBh?= <jpc-ml@zenburn.net>
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: [omapdss] fault in dispc_write_irqenable [was: Re: [omap3isp] xclk
 deadlock]
References: <51D37796.2000601@zenburn.net> <1604535.2Z0SUEyxcF@avalon> <51E0165C.5000401@zenburn.net> <3227918.6DpNM0vnE9@avalon> <51F22A58.9030208@ti.com>
In-Reply-To: <51F22A58.9030208@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Tomi,

Thanks for your reply.

On 26.07.13 09:50, Tomi Valkeinen wrote:
> Sounds like something is enabling/disabling dispc interrupts after the
> clocks have already been turned off.
>
> So what's the context here? What kernel?

This was on 3.10 from Laurent's board/beagle/mt9p031 branch. I am in the 
middle of doing some "bisecting" to figure out some unrelated problems 
with omap3isp so in a couple days I may have more data about which 
versions work and which do not.

> Using omapfb, or...? I hope not
> omap_vout, because that's rather unmaintained =).

Laurent's live application is using the V4L2 API for video output (to 
get free YUV conversion and DMA) so I guess this unfortunatelly counts 
as using omap_vout. Are there any alternatives I should look into? IIUC 
to use omapfb I would need to manually copy RGB data into the 
framebuffer on each frame.

-- 
regards,
Jakub Piotr Cłapa
LoEE.pl
