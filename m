Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60004 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab1IANpg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 09:45:36 -0400
Date: Thu, 1 Sep 2011 15:45:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/9 v6] V4L: add two new ioctl()s for multi-size videobuffer
 management
In-Reply-To: <201109011535.09789.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1109011544290.6316@axis700.grange>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1109011249430.6316@axis700.grange> <20110901110612.GY12368@valkosipuli.localdomain>
 <201109011535.09789.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 1 Sep 2011, Laurent Pinchart wrote:

> Hi Sakari,
> 
> On Thursday 01 September 2011 13:06:12 Sakari Ailus wrote:

[snip]

> > That's my understanding, but of course someone could just say "no" when we
> > try to do that. I think that if something is marked experimental at least
> > the argument that it can't be changed is a little bit moot since the users
> > have been notified of this beforehand.
> > 
> > There are a few examples of this. At least the V4L2 subdev and MC
> > interfaces are marked experimental. However, we haven't actually tried to
> > use that to make changes which might break user space since we haven't got
> > a need to.
> > 
> > Hans, Laurent: do you have an opinion on this?
> 
> We should of course try to keep the API and ABI compatible across kernel 
> versions, but experimental APIs can be changed. It also depends on how widely 
> the API has been picked up by userspace and how much the changes would break 
> it. Being experimental isn't an excuse for making userspace's life a 
> nightmare.

Right, they deserve it regardless;-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
