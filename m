Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43991 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757186AbZFNTAR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 15:00:17 -0400
Date: Sun, 14 Jun 2009 21:00:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Muralidharan Karicheri <m-karicheri2@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Magnus Damm <magnus.damm@gmail.com>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: Re: [PATCH] adding support for setting bus parameters in sub device
In-Reply-To: <200906141917.25328.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0906142042380.3407@axis700.grange>
References: <62904.62.70.2.252.1244810776.squirrel@webmail.xs4all.nl>
 <200906121800.51177.hverkuil@xs4all.nl> <Pine.LNX.4.64.0906141719510.4412@axis700.grange>
 <200906141917.25328.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 14 Jun 2009, Hans Verkuil wrote:

> The point I'm making here is that since the autoconf part is done in software
> it *can* be changed. And while just looking at the code there is no reason why
> choosing a positive vs. negative polarity makes any difference if both host
> and i2c device support it, from a hardware standpoint it *can* make a
> difference.
> 
> In practice you verify and certify your hardware using specific bus settings.
> An autoconf algorithm just obfuscates those settings. And relying on it to
> always return the same settings in the future seems also wishful thinking.

Ok, I think, now I get it. Your real concern is the only case when both 
parties can be configured in software for either polarity. And whereas we 
think (ok, make it "I think") this means, both configurations should work, 
in practice only one of them is guaranteed to. And you think having an 
optional board preference flag is not enough, it should be mandatory.

I see your point now. I am still not positive this case alone is enough to 
force all boards to specify all polarities. How about, we use 
autonegotiation where there's only one valid configuration. If both 
possibilities and no preference is set - ok, we can decide. Either we 
complain loudly in the log and try our luck, or we complain and fail. 
Let's see:

	hs hi  hs lo  vs hi  vs lo  pclk rise  pclk fall  d hi  d lo  master  slave

mt9v022   x      x      x      x        x          x       x     -      x       x

mt9m001   x      -      x      -        -          x       x     -      x       -

mt9m111   x      -      x      -        x          -       x     -      x       -

mt9t031   x      -      x      -        x          x       x     -      x       -

ov772x    x      -      x      -        x          -       x     -      x       -

tw9910    x      -      x      -        x          -       x     -      x       -

(hs = hsync, vs = vsync, pclk = pixel clock, d = data) So, as you see, 
this free choice is not so often.

> > In  
> > any case, I am adding authors, maintainers and major contributors to 
> > various soc-camera host drivers to CC and asking them to express their 
> > opinion on this matter. I will not add anything else here to avoid any 
> > "unfair competition":-) they will have to go a couple emails back in this 
> > thread to better understand what is being discussed here.
> 
> It will definitely be interesting to see what others think.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
