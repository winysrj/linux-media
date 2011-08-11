Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:54941 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1HKLJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 07:09:51 -0400
Date: Thu, 11 Aug 2011 14:09:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size
 videobuffer management
Message-ID: <20110811110946.GG5926@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
 <201108090926.30157.hverkuil@xs4all.nl>
 <20110809233727.GB5926@valkosipuli.localdomain>
 <201108100825.24309.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108100825.24309.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 10, 2011 at 08:25:24AM +0200, Hans Verkuil wrote:
> On Wednesday, August 10, 2011 01:37:27 Sakari Ailus wrote:
> > On Tue, Aug 09, 2011 at 09:26:30AM +0200, Hans Verkuil wrote:
> > ...
> > > > Wouldn't that be a security issue ? Any application with permissions to access 
> > > > the video device could DoS the system.
> > > 
> > > How is this any different from an application that tries to use more memory
> > > then there is available? It's an out-of-memory situation, that can happen at
> > > any time. Anyone can make an application that runs out of memory.
> > > 
> > > Out-of-memory is not a security risk AFAIK.
> > 
> > If you coun availability to security, then it is.
> > 
> > This might not be an issue in embedded systems which have a single user, but
> > think of the availability of the interface in e.g. a server.
> > 
> > Also, this memory is locked to system physical memory, making it impossible
> > to page it out to a block device.
> 
> So? Anyone can make a program that allocates and uses a lot of memory causing
> an out of memory error. I still don't see how that differs from trying to allocate
> these buffers.

The difference is between physical and virtual memory. Reserving buffers
pinned in physical memory will starve all the other users very efficiently.

> Out of memory is a normal condition, not a security risk.

Administrators of largish servers with thousands of users might disagree. I
have to admit I don't know their usage patterns very well so I have no
demands on the issue. ulimit is being used in those systems as is quota,
that I know.

On the other hand, those systems typically do not contain V4L2 devices
either.

> The problem I have is that you can't really determine a valid policy here
> since that will depend entirely on your use-case and (embedded) device.

This is quite similar case as with the CMA in my opinion. The proposal (by
Arnd, if my memory serves me correctly) was to limit the CMA allocations
under certain percentage of the system memory address space. The limit could
be overriddend e.g. in board code.

-- 
Sakari Ailus
sakari.ailus@iki.fi
