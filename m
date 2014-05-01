Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55935 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaEAQIA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 May 2014 12:08:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 01/26] omap3isp: stat: Rename IS_COHERENT_BUF to ISP_STAT_USES_DMAENGINE
Date: Thu, 01 May 2014 18:08:14 +0200
Message-ID: <5488015.H7sDT3oUL9@avalon>
In-Reply-To: <20140501111542.GU8753@valkosipuli.retiisi.org.uk>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com> <1747188.f0Jd97RYvh@avalon> <20140501111542.GU8753@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 01 May 2014 14:15:42 Sakari Ailus wrote:
> On Thu, May 01, 2014 at 12:48:57AM +0200, Laurent Pinchart wrote:
> > Hi Sakari,
> > 
> > On Thursday 01 May 2014 01:45:47 Sakari Ailus wrote:
> > > Hi Laurent,
> > > 
> > > Thanks for the set! I've been looking forward to see this! :)
> > > 
> > > On Mon, Apr 21, 2014 at 02:28:47PM +0200, Laurent Pinchart wrote:
> > > > The macro is meant to test whether the statistics engine uses an
> > > > external DMA engine to transfer data or supports DMA directly. As both
> > > > cases will be supported by DMA coherent buffers rename the macro to
> > > > ISP_STAT_USES_DMAENGINE for improved clarity.
> > > 
> > > Both use DMA, but the ISP just implements its own. How about calling the
> > > macro ISP_STAT_USES_SYSTEM_DMA instead? Up to you.
> > 
> > DMA engine is the Linux name for the system DMA engine API. It might
> > indeed be
>
> The documentation does not use that term at least. It speaks of DMA mapping
> instead. The DMA being used for the transfers in that case is OMAP system
> DMA, not ISP DMA.

DMA mapping and DMA engine are actually two different things. The former 
manages DMA memory, while the latter handles the DMA engine hardware. Only the 
former is documented in the kernel at the moment though (but I expect that to 
change soon).

> > slightly generic, but I'm not too sure whether ISP_STAT_USES_SYSTEM_DMA
> > would be more descriptive. I suppose it depends on the background of the
> > reader :-) If you insist I can change it.
> 
> I think ISP_STAT_USES_SYSTEM_DMA is simply better. Up to you.

-- 
Regards,

Laurent Pinchart

