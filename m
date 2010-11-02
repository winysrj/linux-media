Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.22]:44564 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755110Ab0KBHzH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Nov 2010 03:55:07 -0400
Date: Tue, 2 Nov 2010 08:55:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jun Nie <niej0001@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>,
	linux-fbdev@vger.kernel.org
Subject: Re: V4L2 and framebuffer for the same controller
In-Reply-To: <AANLkTikJNdcnRbNwv4j8zfv4TfSqOgB2K=UD4UFfL=q4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1011020821300.3804@axis700.grange>
References: <AANLkTikJNdcnRbNwv4j8zfv4TfSqOgB2K=UD4UFfL=q4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Jun

On Fri, 29 Oct 2010, Jun Nie wrote:

> Hi Guennadi,
>     I find that your idea of "provide a generic framebuffer driver
> that could sit on top of a v4l output driver", which may be a good
> solution of our LCD controller driver, or maybe much more other SOC
> LCD drivers. V4L2 interface support many features than framebuffer for
> video playback usage, such as buffer queue/dequeue, quality control,
> etc. However, framebuffer is common for UI display. Implement two
> drivers for one controller is a challenge for current architecture.
>     I am interested in your idea. Could you elaborate it? Or do you
> think multifunction driver is the right solution for this the
> scenario?

Right, we have discussed this idea at the V4L2/MC mini-summit earlier this 
year, there the outcome was, that the idea is not bad, but it is easy 
enough to create such framebuffer additions on top of specific v4l2 output 
drivers anyway, so, noone was interested enough to start designing and 
implementing such a generic wrapper driver. However, I've heard, that this 
topic has also been scheduled for discussion at another v4l / kernel 
meeting (plumbers?), so, someone might be looking into implementing 
this... If you yourself would like to do that - feel free to propose a 
design on both mailing lists (fbdev added to cc), then we can discuss it, 
and you can implement it;)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
