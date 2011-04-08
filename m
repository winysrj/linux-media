Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33995 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1DHNcZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 09:32:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: v4l: Buffer pools
Date: Fri, 8 Apr 2011 15:32:14 +0200
Cc: Willy POISSON <willy.poisson@stericsson.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <757395B8DE5A844B80F3F4BE9867DDB652374B2340@EXDCVYMBSTM006.EQ1STM.local> <201104010150.44097.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1104071340420.26842@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1104071340420.26842@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104081532.19854.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Thursday 07 April 2011 13:51:12 Guennadi Liakhovetski wrote:
> On Fri, 1 Apr 2011, Laurent Pinchart wrote:
> 
> [snip]
> 
> > - Cache management (ISP and DSS)
> > 
> > Cache needs to be synchronized between userspace applications, kernel
> > space and hardware. Synchronizing the cache is an expensive operation
> > and should be avoided when possible. Userspace applications don't need
> > to select memory mapping cache attributes, but should be able to either
> > handle cache synchronization explicitly, or override the drivers'
> > default behaviour.
> 
> So, what cache attributes are currently used by the driver? Presumably, it
> is some cacheable variant?

When using MMAP, memory is allocated by the driver from system memory and is 
mapped as normal cacheable memory. When using USERPTR, mapping cache 
attributes are not touched by the driver.

> And which way should the application be able to override the driver's
> behaviour? One of these overrides would probably be "skip cache invalidate
> (input) / flush (output)," right? Anything else?

Those are the operations I was thinking about.

-- 
Regards,

Laurent Pinchart
