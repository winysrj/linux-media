Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46328 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751325AbaEALPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 1 May 2014 07:15:47 -0400
Date: Thu, 1 May 2014 14:15:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 01/26] omap3isp: stat: Rename IS_COHERENT_BUF to
 ISP_STAT_USES_DMAENGINE
Message-ID: <20140501111542.GU8753@valkosipuli.retiisi.org.uk>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1398083352-8451-2-git-send-email-laurent.pinchart@ideasonboard.com>
 <20140430224547.GT8753@valkosipuli.retiisi.org.uk>
 <1747188.f0Jd97RYvh@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1747188.f0Jd97RYvh@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 01, 2014 at 12:48:57AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Thursday 01 May 2014 01:45:47 Sakari Ailus wrote:
> > Hi Laurent,
> > 
> > Thanks for the set! I've been looking forward to see this! :)
> > 
> > On Mon, Apr 21, 2014 at 02:28:47PM +0200, Laurent Pinchart wrote:
> > > The macro is meant to test whether the statistics engine uses an
> > > external DMA engine to transfer data or supports DMA directly. As both
> > > cases will be supported by DMA coherent buffers rename the macro to
> > > ISP_STAT_USES_DMAENGINE for improved clarity.
> > 
> > Both use DMA, but the ISP just implements its own. How about calling the
> > macro ISP_STAT_USES_SYSTEM_DMA instead? Up to you.
> 
> DMA engine is the Linux name for the system DMA engine API. It might indeed be 

The documentation does not use that term at least. It speaks of DMA mapping
instead. The DMA being used for the transfers in that case is OMAP system
DMA, not ISP DMA.

> slightly generic, but I'm not too sure whether ISP_STAT_USES_SYSTEM_DMA would 
> be more descriptive. I suppose it depends on the background of the reader :-) 
> If you insist I can change it.

I think ISP_STAT_USES_SYSTEM_DMA is simply better. Up to you.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
