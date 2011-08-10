Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1787 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1HJGZh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2011 02:25:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Wed, 10 Aug 2011 08:25:24 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange> <201108090926.30157.hverkuil@xs4all.nl> <20110809233727.GB5926@valkosipuli.localdomain>
In-Reply-To: <20110809233727.GB5926@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108100825.24309.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, August 10, 2011 01:37:27 Sakari Ailus wrote:
> On Tue, Aug 09, 2011 at 09:26:30AM +0200, Hans Verkuil wrote:
> ...
> > > Wouldn't that be a security issue ? Any application with permissions to access 
> > > the video device could DoS the system.
> > 
> > How is this any different from an application that tries to use more memory
> > then there is available? It's an out-of-memory situation, that can happen at
> > any time. Anyone can make an application that runs out of memory.
> > 
> > Out-of-memory is not a security risk AFAIK.
> 
> If you coun availability to security, then it is.
> 
> This might not be an issue in embedded systems which have a single user, but
> think of the availability of the interface in e.g. a server.
> 
> Also, this memory is locked to system physical memory, making it impossible
> to page it out to a block device.

So? Anyone can make a program that allocates and uses a lot of memory causing
an out of memory error. I still don't see how that differs from trying to allocate
these buffers.

If the system has swap space (which I haven't used in years) then it may take
longer before you run out of memory, but the effect is the same.

Out of memory is a normal condition, not a security risk.

The problem I have is that you can't really determine a valid policy here
since that will depend entirely on your use-case and (embedded) device.

Regards,

	Hans

> > Note BTW that in practice kmalloc already has a cap (something like 16 or 32
> > MB, I believe it depends on the kernel .config) and so has CMA (the size of
> 
> This is per a single allocation. A user could create any number of them.

