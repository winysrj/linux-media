Return-path: <mchehab@pedra>
Received: from mail.issp.bas.bg ([195.96.236.10]:52584 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab0JJPBL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Oct 2010 11:01:11 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC][PATCH] add dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Date: Sun, 10 Oct 2010 17:36:47 +0300
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de
References: <201008201113.46036.mitov@issp.bas.bg> <201008201450.12585.mitov@issp.bas.bg> <20101010230323B.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20101010230323B.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010101736.54199.mitov@issp.bas.bg>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, October 10, 2010 05:08:22 pm FUJITA Tomonori wrote:
> On Fri, 20 Aug 2010 14:50:12 +0300
> Marin Mitov <mitov@issp.bas.bg> wrote:
> 
> > On Friday, August 20, 2010 11:35:06 am FUJITA Tomonori wrote:
> > > On Fri, 20 Aug 2010 11:13:45 +0300
> > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > 
> > > > > > This tric is already used in drivers/staging/dt3155v4l.c
> > > > > > dt3155_alloc_coherent()/dt3155_free_coherent()
> > > > > > 
> > > > > > Here proposed for general use by popular demand from video4linux folks.
> > > > > > Helps for videobuf-dma-contig framework.
> > > > > 
> > > > > What you guys exactly want to do? If you just want to pre-allocate
> > > > > coherent memory for latter usage,
> > > > 
> > > > Yes, just to preallocate not coherent, but rather contiguous memory for latter usage.
> > > > We use coherent memory because it turns out to be contiguous.
> > > 
> > > Hmm, you don't care about coherency? You just need contiguous memory?
> > 
> > Yes. We just need contiguous memory. Coherency is important as far as when dma
> > transfer finishes user land is able to see the new data. Could be done by something like
> > dma_{,un}map_single()
> 
> Anyone is working on this?

I am not, sorry.

> 
> KAMEZAWA posted a patch to improve the generic page allocator to
> allocate physically contiguous memory. He said that he can push it
> into mainline.

I am waiting for the new videobuf2 framework to become part of the kernel.
Then KAMEZAWA's improvements can help.

Marin Mitov

> 
> The approach enables us to solve this issue without adding any new
> API.
> 
