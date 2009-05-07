Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41925 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752918AbZEGPyA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2009 11:54:00 -0400
Date: Thu, 7 May 2009 17:54:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Agustin Ferrin Pozuelo <agustin.ferrin@yahoo.com>
cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: Solved? - Re: soc-camera: timing out during capture - Re: Testing
 latest mx3_camera.c
In-Reply-To: <155119.7889.qm@web32103.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0905071750050.9460@axis700.grange>
References: <155119.7889.qm@web32103.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 7 May 2009, Agustin Ferrin Pozuelo wrote:

> Holy cow...

mu-u-u-u-u-u?:-)

> After checking out every single bit in CSI and IDMAC to be correct 
> according to reference and the same I had in the previous/working 
> version...
> 
> I thought about the fact that I was only queuing one buffer, and that 
> this might be a corner case as sample code uses a lot of them. And that 
> in the older code that funny things could happen in the handler if we 
> ran out of buffers, though they didn't happen.
> 
> So I have queued an extra buffer and voila, got it working.
> 
> So thanks again!
> 
> However, this could be a bug in ipu_idmac (or some other point), as 
> using a single buffer is very plausible, specially when grabbing huge 
> stills.

Great, thanks for testing and debugging! Ok, so, I will have to test this 
case some time...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
