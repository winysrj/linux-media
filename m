Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:43375 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3GZTCi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 15:02:38 -0400
Received: by mail-ea0-f173.google.com with SMTP id g10so1738572eak.4
        for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 12:02:37 -0700 (PDT)
Message-ID: <51F2C7CB.9040806@zenburn.net>
Date: Fri, 26 Jul 2013 21:02:35 +0200
From: =?UTF-8?B?SmFrdWIgUGlvdHIgQ8WCYXBh?= <jpc-ml@zenburn.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [omapdss] fault in dispc_write_irqenable [was: Re: [omap3isp]
 xclk deadlock]
References: <51D37796.2000601@zenburn.net> <51F22A58.9030208@ti.com> <51F297C0.1080501@zenburn.net> <2345948.CFuZYJZjKT@avalon>
In-Reply-To: <2345948.CFuZYJZjKT@avalon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26.07.13 17:52, Laurent Pinchart wrote:
>>> Using omapfb, or...? I hope not
>>> omap_vout, because that's rather unmaintained =).
>>
>> Laurent's live application is using the V4L2 API for video output (to
>> get free YUV conversion and DMA) so I guess this unfortunatelly counts
>> as using omap_vout. Are there any alternatives I should look into? IIUC
>> to use omapfb I would need to manually copy RGB data into the
>> framebuffer on each frame.
>
> It should be possible to port the live application to use DRM/KMS with omapdrm
> for the display side, without requiring any memory copy. That's somewhere on
> my TODO list, but I won't have time to work on that before way too long.

I could look into it myself but is there any documentation on omapdrm?

 From what I found libdrm should probably be used but information about 
it's API is really scarce:
https://dvdhrm.wordpress.com/2012/09/13/linux-drm-mode-setting-api/
http://dvdhrm.wordpress.com/2012/12/21/advanced-drm-mode-setting-api/
http://virtuousgeek.org/blog/index.php/jbarnes/2011/10/31/writing_stanalone_programs_with_egl_and_

The last one seems focused on OpenGL so I don't think it applies.

Are there any good sources to learn about this? Or maybe some pointers 
on where to start with reading source code?

-- 
regards,
Jakub Piotr Cłapa
LoEE.pl
