Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:45940 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1HIXhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 19:37:31 -0400
Date: Wed, 10 Aug 2011 02:37:27 +0300
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
Message-ID: <20110809233727.GB5926@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
 <201108081440.27488.hansverk@cisco.com>
 <201108090006.11075.laurent.pinchart@ideasonboard.com>
 <201108090926.30157.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108090926.30157.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 09, 2011 at 09:26:30AM +0200, Hans Verkuil wrote:
...
> > Wouldn't that be a security issue ? Any application with permissions to access 
> > the video device could DoS the system.
> 
> How is this any different from an application that tries to use more memory
> then there is available? It's an out-of-memory situation, that can happen at
> any time. Anyone can make an application that runs out of memory.
> 
> Out-of-memory is not a security risk AFAIK.

If you coun availability to security, then it is.

This might not be an issue in embedded systems which have a single user, but
think of the availability of the interface in e.g. a server.

Also, this memory is locked to system physical memory, making it impossible
to page it out to a block device.

> Note BTW that in practice kmalloc already has a cap (something like 16 or 32
> MB, I believe it depends on the kernel .config) and so has CMA (the size of

This is per a single allocation. A user could create any number of them.

-- 
Sakari Ailus
sakari.ailus@iki.fi
