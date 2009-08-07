Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.156.57]:48856 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755786AbZHGNPH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Aug 2009 09:15:07 -0400
Date: Fri, 7 Aug 2009 08:15:01 -0500
From: Robin Holt <holt@sgi.com>
To: Laurent Desnogues <laurent.desnogues@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Xiao <dxiao@broadcom.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
	get_user_pages() enough to prevent pages from being swapped out ?")
Message-ID: <20090807131501.GD2763@sgi.com>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <20090806222543.GG31579@n2100.arm.linux.org.uk> <1249624766.32621.61.camel@david-laptop> <200908070958.31322.laurent.pinchart@ideasonboard.com> <20090807081041.GB18343@n2100.arm.linux.org.uk> <20090807095426.GI8725@shareable.org> <761ea48b0908070507n5c580455pb86e5240a7cf6c0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <761ea48b0908070507n5c580455pb86e5240a7cf6c0c@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 07, 2009 at 02:07:43PM +0200, Laurent Desnogues wrote:
> On Fri, Aug 7, 2009 at 11:54 AM, Jamie Lokier<jamie@shareable.org> wrote:
> >
> > 1. Does the architecture not prevent speculative instruction
> > prefetches from crossing a page boundary?  It would be handy under the
> > circumstances.
> 
> There's no such restriction in ARMv7 architecture.

Doesn't it prevent them for uncached areas?  I _THOUGHT_ there was an
alloc_consistent (or something like that) call on ARM which gave you
an uncached mapping where you could do DMA.  I also thought there was
a dma_* set of functions which remapped as uncached before DMA begins
and remapped as normal after DMA has been completed.

Sorry for the fuzzy recollection.  I am dredging from 2.6.21 timeframe.

Robin
