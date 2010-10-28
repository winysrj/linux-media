Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:38049 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab0J1NY1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 09:24:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
Date: Thu, 28 Oct 2010 15:24:59 +0200
Cc: "Eino-Ville Talvala" <talvala@stanford.edu>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sung Hee Park <shpark7@stanford.edu>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com> <201010140058.47236.laurent.pinchart@ideasonboard.com> <4CC9505E.8020004@matrix-vision.de>
In-Reply-To: <4CC9505E.8020004@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010281524.59584.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Thursday 28 October 2010 12:28:46 Michael Jones wrote:
> Laurent Pinchart wrote:
> > First of all, you need to get the latest OMAP3 ISP driver sources.
> > 
> > The most recent OMAP3 ISP driver for the N900 can be found in the
> > omap3isp- rx51 git tree on gitorious.org (devel branch from
> > http://meego.gitorious.org/maemo-multimedia/omap3isp-rx51). This is the
> > tree used by MeeGo for the OMAP3 ISP camera driver. The driver has been
> > ported to the media controller framework, but the latest changes to the
> > framework are not present in that tree as they break the driver ABI and
> > API. This should be fixed in the future, but I can't give you any time
> > estimate at the moment.
> > 
> > The most recent OMAP3 ISP driver and media controller framework can be
> > found in the pinchartl/media git tree on linuxtv.org
> > (media-0004-omap3isp branch from
> > http://git.linuxtv.org/pinchartl/media.git). This is the tree used for
> > upstream submission of the media controller and OMAP3 ISP driver. The
> > OMAP3 ISP driver implements the latest media controller API, but the
> > tree doesn't contain RX51 camera support.
> 
> You say "the most recent OMAP3 ISP driver for the N900" is on gitorious but
> "the most recent OMAP3 ISP driver and media controller framework" is your
> branch. I'm confused about where I find "the most recent OMAP3 ISP driver".

The OMAP3 ISP driver on linuxtv is the most recent one, but doesn't support 
the N900 as it lacks sensor drivers and board code. The gitorious tree has 
full N900 camera support but is based on 2.6.35 and on an older media 
controller API.

> To take a concrete example, in media-0004-omap3isp, media_device_register()
> WARNs if mdev doesn't have a model name (I get the warning).  On the Meego
> branch, it WARNs only if it's missing both a model name and a parent dev
> pointer. If I understood you correctly above, media-0004-omap3isp has the
> newer framework, so the newer framework requires a model name?

That's correct.

> I don't need RX51 camera support, but I would like to have a reasonably
> up-to-date OMAP3 ISP driver.

Then go for the linuxtv tree.

> Laurent said before that media-0004-omap3isp will be updated regularly.  Do
> these updates come from a cherry-pick of the gitorious branch?

Both the gitorious and the linuxtv tree are updated from an internal 
development tree.

> I anticipate sending a patch based on media-0004-omap3isp someday (like one
> addressing my WARN_ON issue) and getting as a reply, "yeah, we already did
> that on meego.gitorious.org".

It would be the other way around, patches against the gitorious tree could fix 
problems already fixed on linuxtv.

> I appreciate your help so far.

You're welcome.

-- 
Regards,

Laurent Pinchart
