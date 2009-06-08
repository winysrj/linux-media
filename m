Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42515 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751386AbZFHTTw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2009 15:19:52 -0400
Date: Mon, 8 Jun 2009 21:19:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paul Mundt <lethal@linux-sh.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: Re: [PATCH 00/10 v2] soc-camera conversions
In-Reply-To: <20090519030536.GA20195@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0906082113390.4396@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
 <20090519030536.GA20195@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 19 May 2009, Paul Mundt wrote:

> On Fri, May 15, 2009 at 07:18:45PM +0200, Guennadi Liakhovetski wrote:
> > this is the next round of soc-camera conversions. Run-tested on i.MX31, 
> > PXA270, SH7722, compile-tested only for i.MX1. It should have been a 
> > "straight-forward" port of the previous version to a more current tree, 
> > but then I started converting soc_camera_platform, and things became a bit 
> > more complex... As a bonus, now soc-camera can handle not only i2c 
> > subdevices, and we can even drop the CONFIG_I2C dependency again. I'll 
> > also upload a comlpete stack somewhere a bit later, for example for those, 
> > wishing to test it on i.MX31, otherwise the series will not apply cleanly. 
> > 
> > I'd like to push the first 8 of them asap, 9 and 10 will still have to be 
> > reworked
> > 
> > Paul, I put you on "cc" on all patches, because, unfortunately, several of 
> > them affect arch/sh. But I'll mention it explicitly in each such patch.
> > 
> Looks ok to me, there shouldn't be any problems with taking these all
> through the v4l tree. Feel free to add my Acked-by if you like. I guess
> we will find out in -next if there are any conflicts or not :-)

Yes, can do this, thanks, but first these 3 patches (including Magnus' 
ack) have to be applied to sh: 
http://www.mail-archive.com/linux-media@vger.kernel.org/msg05223.html
which in turn depend on
http://www.mail-archive.com/linux-media@vger.kernel.org/msg04724.html
and the latter one is already in the next tree. Would you like me to also 
merge and pull the above three patches via v4l or would you be applying 
them yourself?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
