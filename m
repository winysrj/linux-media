Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35806 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757031AbZKEUiR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Nov 2009 15:38:17 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1N6965-0002l3-Cs
	for linux-media@vger.kernel.org; Thu, 05 Nov 2009 21:38:21 +0100
Date: Thu, 5 Nov 2009 21:38:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Capturing video and still images using one driver
Message-ID: <Pine.LNX.4.64.0911052138040.5620@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(forwarding to the new v4l list)

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

---------- Forwarded message ----------
Date: Thu, 5 Nov 2009 21:37:46 +0100 (CET)
From: Guennadi Liakhovetski <lyakh@axis700.grange>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Neil Johnson <realdealneil@gmail.com>, video4linux-list@redhat.com
Subject: Re: Capturing video and still images using one driver

On Wed, 4 Nov 2009, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > I came across the same problem when working on the rj54n1cb0c driver. 
> > What's even more exciting with that sensor, is that it has separate 
> > frame-size settings for preview (video) and still capture.
> 
> It seems this behaviour is generic across several sensors. As far as I know, the
> mt9m111 has 2 modes : low power low resolution, and high power high resolution,
> and both are programmable apart (in terms of resolution, zoom, etc ...)
> 
> What this makes me think is that a sensor could provide several "contexts" of
> use, as :
>  - full resolution still image context
>  - low resolution still image context
>  - full resolution video context
>  - low resolution video context

Why fixed resolutions? Just make it possible to issue S_FMT for video or 
for still imaging... That would work seamlessly with several inputs 
(S_INPUT, S_FMT...).

> Then, a new/existing v4l2 call would switch the context (perhaps based on buffer
> type ?) of the sensor.

...on a second thought, it doesn't seem that smart to me any more to tie 
the streaming vs. still mode distinction to a specific buffer type...

> Well, that's just some junk I've been thinking over lately.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
