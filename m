Return-path: <linux-media-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37380 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbZHFTRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 15:17:33 -0400
From: Chetan.Loke@Emulex.Com
To: <dxiao@broadcom.com>, <laurent.pinchart@ideasonboard.com>
CC: <ben-linux@fluff.org>, <hugh.dickins@tiscali.co.uk>,
	<holt@sgi.com>, <linux-kernel@vger.kernel.org>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.arm.linux.org.uk>
Date: Thu, 6 Aug 2009 12:16:35 -0700
Subject: RE: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
 get_user_pages() enough to prevent pages from being swapped out ?")
Message-ID: <412A05BA40734D4887DBC67661F433080D73232D@EXMAIL.ad.emulex.com>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>
 <20090806114619.GW2080@trinity.fluff.org>
 <200908061506.23874.laurent.pinchart@ideasonboard.com>
 <1249584374.29182.20.camel@david-laptop>
In-Reply-To: <1249584374.29182.20.camel@david-laptop>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of David Xiao
> Sent: Thursday, August 06, 2009 2:46 PM
> To: Laurent Pinchart
> Cc: Ben Dooks; Hugh Dickins; Robin Holt; linux-kernel@vger.kernel.org;
> v4l2_linux; linux-arm-kernel@lists.arm.linux.org.uk
> Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
> get_user_pages() enough to prevent pages from being swapped out ?")
> 
> On Thu, 2009-08-06 at 06:06 -0700, Laurent Pinchart wrote:
> > Hi Ben,
> >
> > On Thursday 06 August 2009 13:46:19 Ben Dooks wrote:
> > > On Thu, Aug 06, 2009 at 12:08:21PM +0200, Laurent Pinchart wrote:
> > [snip]
> > > >
> > > > The second problem is to ensure cache coherency. As the userspace
> > > > application will read data from the video buffers, those buffers
> will end
> > > > up being cached in the processor's data cache. The driver does need
> to
> > > > invalidate the cache before starting the DMA operation (userspace
> could
> > > > in theory write to the buffers, but the data will be overwritten by
> DMA
> > > > anyway, so there's no need to clean the cache).
> > >
> > > You'll need to clean the write buffers, otherwise the CPU may have
> data
> > > queued that it has yet to write back to memory.
> >
> > Good points, thanks.
> 
>    I thought this should have been taken care of by the CPU specific
> dma_inv_range routine. However, In arch/arm/mm/cache-v7.c,
> v7_dma_inv_range does not drain the write buffer; and the
> v6_dma_inv_range does that in the end of all the cache maintenance
> operaitons.
>    So this is probably something Russel can clarify.
> 

Something non-related. I haven't used this specific api but ARM1156 has an issue. If you use the clean-cache-block mcr feature then it might result in memory-corruption. So be careful. I'm not sure which of these(ARM1156T2-S or ARM1156T2F-S) variants has that errata. 


Chetan
