Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:43440 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab0JVONP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 10:13:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
Date: Fri, 22 Oct 2010 16:13:35 +0200
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Bastian Hecht <hechtb@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com> <4CADA7ED.5020604@maxwell.research.nokia.com> <4CC197B3.3040208@matrix-vision.de>
In-Reply-To: <4CC197B3.3040208@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221613.35549.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Friday 22 October 2010 15:54:59 Michael Jones wrote:
> Sakari Ailus wrote:
> > Bastian Hecht wrote:
> >> I want to write a sensor driver for the mt9p031 (not mt9t031) camera
> >> chip and start getting confused about the different kernel forks and
> >> architectural changes that happen in V4L2.
> >> A similar problem was discussed in this mailing list at
> >> http://www.mail-archive.com/linux-media@vger.kernel.org/msg19084.html.
> >> 
> >> Currently I don't know which branch to follow. Either
> >> http://gitorious.org/omap3camera from Sakari Ailus or the branch
> >> media-0004-omap3isp at http://git.linuxtv.org/pinchartl/media.git from
> >> Laurent Pinchart. Both have an folder drivers/media/video/isp and are
> >> written for the new media controller architecture if I am right.
> > 
> > Take Laurent's branch it has all the current patches in it. My gitorious
> > tree isn't updated anymore. (I just had forgotten to add a note, it's
> > there now.)
> 
> Will Laurent's media-0004-omap3isp branch at linuxtv.org then continue to
> get updated?  Or will the existing commits be rebased at some point?  I'm
> trying to understand/decide what the best approach is with git if I
> continue doing development on top of the media controller and want to stay
> up to date.

The media-0004-omap3isp branch in the media repository on linuxtv.org will be 
updated regularly until the driver is merged in the mainline Linux kernel (in 
the meantime I will rebase the branch every time a major kernel version comes 
out). Development will then move to mainline.

-- 
Regards,

Laurent Pinchart
