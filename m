Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:45623 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab0J1K2t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 06:28:49 -0400
Message-ID: <4CC9505E.8020004@matrix-vision.de>
Date: Thu, 28 Oct 2010 12:28:46 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Eino-Ville Talvala <talvala@stanford.edu>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sung Hee Park <shpark7@stanford.edu>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com> <AANLkTimzU8rR2a0=gTLX8UOxGZaiY0gxx4zTr2VH-iMa@mail.gmail.com> <4CB62CB5.9000706@stanford.edu> <201010140058.47236.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201010140058.47236.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

Laurent Pinchart wrote:

> 
> First of all, you need to get the latest OMAP3 ISP driver sources.
> 
> The most recent OMAP3 ISP driver for the N900 can be found in the omap3isp-
> rx51 git tree on gitorious.org (devel branch from 
> http://meego.gitorious.org/maemo-multimedia/omap3isp-rx51). This is the tree 
> used by MeeGo for the OMAP3 ISP camera driver. The driver has been ported to 
> the media controller framework, but the latest changes to the framework are 
> not present in that tree as they break the driver ABI and API. This should be 
> fixed in the future, but I can't give you any time estimate at the moment.
> 
> The most recent OMAP3 ISP driver and media controller framework can be found 
> in the pinchartl/media git tree on linuxtv.org (media-0004-omap3isp branch 
> from http://git.linuxtv.org/pinchartl/media.git). This is the tree used for 
> upstream submission of the media controller and OMAP3 ISP driver. The OMAP3 
> ISP driver implements the latest media controller API, but the tree doesn't 
> contain RX51 camera support.
>

You say "the most recent OMAP3 ISP driver for the N900" is on gitorious but "the most recent OMAP3 ISP driver and media controller framework" is your branch.  I'm confused about where I find "the most recent OMAP3 ISP driver".  To take a concrete example, in media-0004-omap3isp, media_device_register() WARNs if mdev doesn't have a model name (I get the warning).  On the Meego branch, it WARNs only if it's missing both a model name and a parent dev pointer.  If I understood you correctly above, media-0004-omap3isp has the newer framework, so the newer framework requires a model name?

I don't need RX51 camera support, but I would like to have a reasonably up-to-date OMAP3 ISP driver.  Laurent said before that media-0004-omap3isp will be updated regularly.  Do these updates come from a cherry-pick of the gitorious branch?  I anticipate sending a patch based on media-0004-omap3isp someday (like one addressing my WARN_ON issue) and getting as a reply, "yeah, we already did that on meego.gitorious.org".

I appreciate your help so far.

-- 
Michael Jones

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
