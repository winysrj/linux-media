Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60062 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752740AbZEORSc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 13:18:32 -0400
Date: Fri, 15 May 2009 19:18:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 00/10 v2] soc-camera conversions
Message-ID: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

this is the next round of soc-camera conversions. Run-tested on i.MX31, 
PXA270, SH7722, compile-tested only for i.MX1. It should have been a 
"straight-forward" port of the previous version to a more current tree, 
but then I started converting soc_camera_platform, and things became a bit 
more complex... As a bonus, now soc-camera can handle not only i2c 
subdevices, and we can even drop the CONFIG_I2C dependency again. I'll 
also upload a comlpete stack somewhere a bit later, for example for those, 
wishing to test it on i.MX31, otherwise the series will not apply cleanly. 

I'd like to push the first 8 of them asap, 9 and 10 will still have to be 
reworked

Paul, I put you on "cc" on all patches, because, unfortunately, several of 
them affect arch/sh. But I'll mention it explicitly in each such patch.

Have fun.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
