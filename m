Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59101 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752901AbZKQI2D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 03:28:03 -0500
Date: Tue, 17 Nov 2009 09:28:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Uwe Taeubert <u.taeubert@road.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problem on RJ54N1CB0C
In-Reply-To: <200911160807.25160.u.taeubert@road.de>
Message-ID: <Pine.LNX.4.64.0911170909440.4504@axis700.grange>
References: <200911130950.30581.u.taeubert@road.de>
 <Pine.LNX.4.64.0911131015260.4601@axis700.grange> <200911160807.25160.u.taeubert@road.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Uwe

On Mon, 16 Nov 2009, Uwe Taeubert wrote:

> Hi Guennadi
> You will find the driver sources for our Sharp module in lz0p39ha.c and the 
> initialization data in lz0p39ha_init.c. In lz0p35du_set_fmt_cap() you can see 
> the resolution depending change of the divider. In our system we get correct 
> pictures in all resolution mensioned there. But FYI, if no flashlight is 
> desired, we do not switch to still mode - only still mode generates flash 
> controll signals.
> We are working with the Technical Manual Ver. 2.2C, also under NDA.

May I ask you if you have an English or a Japanese version?:-) I've got a 
2.3C Japanese...

> Concerning the exposure control, I know the use of the registers 0x04d8 and 
> 0x04d9 is more a hack but a solution. And the result is unsatisfying - it was 
> a try.
> 
> At the moment I'm checking the influence of RAMPCLK- TGCLK-ratio. I was able 
> to get higher exposer by changing RAMPCLK but I wasn't able to calculate a 
> well doing relation between all clocks and to have a fast frame rate.
> 
> The driver content is in a preliminary state. I'm working on 
> lz0p35du_set_fmt_cap function. We do not diffenrentialte between preview and 
> still mode. It makes it easier to handle buffers in VFL at the moment.

Thanks for the code. I looked briefly at it and one essential difference 
that occurred to me is, that you're setting the RESIZE registers at the 
beginning of the format-change function (lz0p35du_set_fmt_cap()), and I am 
doing this following code examples, that I had in the end, followed by a 
killer delay of 230ms... You might try to do that in the end, but it might 
only become worse, because, as I said, my version of the driver has 
problems with bigger images.

My driver also doesn't set autofocus ATM, as there had been errors in 
examples that I had and I didn't have time to experiment with those 
values. I'm also relying on the automatic exposure area selection (0x58c 
bit 7) instead of setting it automatically. You also don't seem to 
dynamically adjust INC_USE_SEL registers, instead you just initialise them 
to 0xff. And in my experience that register does make a difference, so, 
you might try to play with it a bit. Have a look at my driver, although, I 
don't think values I configure there are perfect either.

In fact, it might indeed become a problem for you, that you're updating 
the RESIZE registers too early and not pausing after that.

Unfortunately, I do not have time now to look at the driver in detail ATM, 
let me know your results when you fix your problem.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
