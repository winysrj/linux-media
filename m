Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:48734 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754754Ab0JJSVc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Oct 2010 14:21:32 -0400
Date: Sun, 10 Oct 2010 20:21:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marin Mitov <mitov@issp.bas.bg>
cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	linux-kernel@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC][PATCH] add dma_reserve_coherent_memory()/dma_free_reserved_memory()
 API
In-Reply-To: <201010101736.54199.mitov@issp.bas.bg>
Message-ID: <Pine.LNX.4.64.1010102018270.10713@axis700.grange>
References: <201008201113.46036.mitov@issp.bas.bg> <201008201450.12585.mitov@issp.bas.bg>
 <20101010230323B.fujita.tomonori@lab.ntt.co.jp> <201010101736.54199.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 10 Oct 2010, Marin Mitov wrote:

> On Sunday, October 10, 2010 05:08:22 pm FUJITA Tomonori wrote:
> > On Fri, 20 Aug 2010 14:50:12 +0300
> > Marin Mitov <mitov@issp.bas.bg> wrote:
> > 
> > > On Friday, August 20, 2010 11:35:06 am FUJITA Tomonori wrote:
> > > > On Fri, 20 Aug 2010 11:13:45 +0300
> > > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > > 
> > > > > > > This tric is already used in drivers/staging/dt3155v4l.c
> > > > > > > dt3155_alloc_coherent()/dt3155_free_coherent()
> > > > > > > 
> > > > > > > Here proposed for general use by popular demand from video4linux folks.
> > > > > > > Helps for videobuf-dma-contig framework.
> > > > > > 
> > > > > > What you guys exactly want to do? If you just want to pre-allocate
> > > > > > coherent memory for latter usage,
> > > > > 
> > > > > Yes, just to preallocate not coherent, but rather contiguous memory for latter usage.
> > > > > We use coherent memory because it turns out to be contiguous.
> > > > 
> > > > Hmm, you don't care about coherency? You just need contiguous memory?
> > > 
> > > Yes. We just need contiguous memory. Coherency is important as far as when dma
> > > transfer finishes user land is able to see the new data. Could be done by something like
> > > dma_{,un}map_single()
> > 
> > Anyone is working on this?
> 
> I am not, sorry.
> 
> > 
> > KAMEZAWA posted a patch to improve the generic page allocator to
> > allocate physically contiguous memory. He said that he can push it
> > into mainline.
> 
> I am waiting for the new videobuf2 framework to become part of the kernel.
> Then KAMEZAWA's improvements can help.

You probably have seen this related thread: 
http://marc.info/?t=128644473600004&r=1&w=2

Thanks
Guennadi

> Marin Mitov
> 
> > 
> > The approach enables us to solve this issue without adding any new
> > API.
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
