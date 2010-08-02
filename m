Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:45615 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0HBPKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 11:10:35 -0400
Received: by pxi14 with SMTP id 14so1377727pxi.19
        for <linux-media@vger.kernel.org>; Mon, 02 Aug 2010 08:10:35 -0700 (PDT)
Subject: Re: [PATCH v2]Resend:videobuf_dma_sg: a new implementation for mmap
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
In-Reply-To: <1280489980.2648.12.camel@localhost.localdomain>
References: <1280448482.2648.2.camel@localhost.localdomain>
	 <201007301131.17638.laurent.pinchart@ideasonboard.com>
	 <1280489980.2648.12.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 23:08:51 +0800
Message-ID: <1280761731.2664.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-07-30 at 19:39 +0800, Figo.zhang wrote:
> On Fri, 2010-07-30 at 11:31 +0200, Laurent Pinchart wrote:
> > Hi,
> > 
> > On Friday 30 July 2010 02:08:02 Figo.zhang wrote:
> > > a mmap issue for videobuf-dma-sg: it will alloc a new page for mmaping when
> > > it encounter page fault at video_vm_ops->fault(). pls see
> > > http://www.spinics.net/lists/linux-media/msg21243.html
> > > 
> > > a new implementation for mmap, it translate to vmalloc to page at
> > > video_vm_ops->fault().
> > > 
> > > in v2, if mem->dma.vmalloc is NULL at video_vm_ops->fault(), it will alloc
> > > memory by vmlloc_32().
> > 
> > You're replacing allocation in videobuf_vm_fault by allocationg in 
> > videobuf_vm_fault. I don't see the point. videobuf_vm_fault needs to go away 
> > completely.
> in now videobuf code, the mmap alloc a new buf, the capture dma buffer
> using vmalloc() alloc buffer, how is
> relationship with them? in usrspace , the mmap region will not the
> actual capture dma data, how is work? 


hmm, I understand with some mistake before.for mmap in videobuf-sg, it
is not call vmalloc_32() to alloc memory, it call
videobuf_dma_init_user_locked()->get_user_pages(), and the end, it will
handle_mm_fault()-> vm_ops->fault(). Because in mmap(), it have assigned
vaule for "baddr" variable.

it is too obscure for videobuf-sg, hope for videbuf2. ~~


