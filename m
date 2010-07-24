Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61884 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0GXNov (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jul 2010 09:44:51 -0400
Received: by pvc7 with SMTP id 7so3909864pvc.19
        for <linux-media@vger.kernel.org>; Sat, 24 Jul 2010 06:44:50 -0700 (PDT)
Subject: Re: how to mmap in  videobuf-dma-sg.c
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
In-Reply-To: <20090521073518.1c0c0a5b@pedra.chehab.org>
References: <1242881164.3824.2.camel@myhost>
	 <20090521073518.1c0c0a5b@pedra.chehab.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Jul 2010 21:43:20 +0800
Message-ID: <1279979000.2666.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-05-21 at 07:35 -0300, Mauro Carvalho Chehab wrote:
> Em Thu, 21 May 2009 12:46:04 +0800
> "Figo.zhang" <figo1802@gmail.com> escreveu:
> 
> > hi,all,
> >  I am puzzle that how to mmap ( V4L2_MEMORY_MMAP) in videobuf-dma-sg.c?
> > 
> > In this file, it alloc the momery using vmalloc_32() , and put this
> > momery into sglist table,and then use dma_map_sg() to create sg dma at
> > __videobuf_iolock() function. but in __videobuf_mmap_mapper(), i canot
> > understand how it do the mmap? 
> > why it not use the remap_vmalloc_range() to do the mmap?
> 
> The answer is simple: remap_vmalloc_range() is newer than videobuf code. This
> part of the code was written back to kernel 2.4, and nobody cared to update it
> to use those newer functions, and simplify its code.
> 
> If you want, feel free to propose some cleanups on it
thanks, in __videobuf_mmap_mapper(), it define a videobuf_vm_ops->fault,
it
will alloc a new page for mmaping when it  encounter page fault
(do_page_fault),
so how the mmap() can mmap the vmalloc memory which had allocted before
using __videobuf_iolock()/vmalloc_
32() ?

Thanks,
Figo.zhang

> 
> 
> 
> Cheers,
> Mauro


