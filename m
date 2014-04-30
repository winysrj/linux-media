Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50865 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaD3Wsp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 18:48:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 01/26] omap3isp: stat: Rename IS_COHERENT_BUF to ISP_STAT_USES_DMAENGINE
Date: Thu, 01 May 2014 00:48:57 +0200
Message-ID: <1747188.f0Jd97RYvh@avalon>
In-Reply-To: <20140430224547.GT8753@valkosipuli.retiisi.org.uk>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com> <1398083352-8451-2-git-send-email-laurent.pinchart@ideasonboard.com> <20140430224547.GT8753@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 01 May 2014 01:45:47 Sakari Ailus wrote:
> Hi Laurent,
> 
> Thanks for the set! I've been looking forward to see this! :)
> 
> On Mon, Apr 21, 2014 at 02:28:47PM +0200, Laurent Pinchart wrote:
> > The macro is meant to test whether the statistics engine uses an
> > external DMA engine to transfer data or supports DMA directly. As both
> > cases will be supported by DMA coherent buffers rename the macro to
> > ISP_STAT_USES_DMAENGINE for improved clarity.
> 
> Both use DMA, but the ISP just implements its own. How about calling the
> macro ISP_STAT_USES_SYSTEM_DMA instead? Up to you.

DMA engine is the Linux name for the system DMA engine API. It might indeed be 
slightly generic, but I'm not too sure whether ISP_STAT_USES_SYSTEM_DMA would 
be more descriptive. I suppose it depends on the background of the reader :-) 
If you insist I can change it.

-- 
Regards,

Laurent Pinchart

