Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56382 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755313AbZEORbj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 13:31:39 -0400
Date: Fri, 15 May 2009 19:31:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 00/10 v2] soc-camera conversions
In-Reply-To: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
Message-ID: <Pine.LNX.4.64.0905151929120.4658@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 May 2009, Guennadi Liakhovetski wrote:

> Hi all,
> 
> this is the next round of soc-camera conversions. Run-tested on i.MX31, 
> PXA270, SH7722, compile-tested only for i.MX1. It should have been a 
> "straight-forward" port of the previous version to a more current tree, 
> but then I started converting soc_camera_platform, and things became a bit 
> more complex... As a bonus, now soc-camera can handle not only i2c 
> subdevices, and we can even drop the CONFIG_I2C dependency again. I'll 
> also upload a comlpete stack somewhere a bit later, for example for those, 
> wishing to test it on i.MX31, otherwise the series will not apply cleanly. 

All available at

http://download.open-technology.de/soc-camera/20090515/

As you can see from 0000-base it is still based on next of 20090507, i.e., 
9 days ago:-( If you take a newer tree, some of those patches will already 
be there, so, I think, the easiest would be to base your tests on the same 
base.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
