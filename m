Return-path: <linux-media-owner@vger.kernel.org>
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41516 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZESDFj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 23:05:39 -0400
Date: Tue, 19 May 2009 12:05:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: Re: [PATCH 00/10 v2] soc-camera conversions
Message-ID: <20090519030536.GA20195@linux-sh.org>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 15, 2009 at 07:18:45PM +0200, Guennadi Liakhovetski wrote:
> this is the next round of soc-camera conversions. Run-tested on i.MX31, 
> PXA270, SH7722, compile-tested only for i.MX1. It should have been a 
> "straight-forward" port of the previous version to a more current tree, 
> but then I started converting soc_camera_platform, and things became a bit 
> more complex... As a bonus, now soc-camera can handle not only i2c 
> subdevices, and we can even drop the CONFIG_I2C dependency again. I'll 
> also upload a comlpete stack somewhere a bit later, for example for those, 
> wishing to test it on i.MX31, otherwise the series will not apply cleanly. 
> 
> I'd like to push the first 8 of them asap, 9 and 10 will still have to be 
> reworked
> 
> Paul, I put you on "cc" on all patches, because, unfortunately, several of 
> them affect arch/sh. But I'll mention it explicitly in each such patch.
> 
Looks ok to me, there shouldn't be any problems with taking these all
through the v4l tree. Feel free to add my Acked-by if you like. I guess
we will find out in -next if there are any conflicts or not :-)
