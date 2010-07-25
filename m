Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38841 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0GYRqX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jul 2010 13:46:23 -0400
Message-ID: <4C4C7889.4000304@infradead.org>
Date: Sun, 25 Jul 2010 14:46:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: figo zhang <figo1802@gmail.com>
CC: hverkuil@xs4all.nl, linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: how to mmap in videobuf-dma-sg.c
References: <1242881164.3824.2.camel@myhost>	<20090521073518.1c0c0a5b@pedra.chehab.org> <AANLkTimExb4hh8K5lRCRiM0IMIgsOpCw69bFvqLlQCDc@mail.gmail.com>
In-Reply-To: <AANLkTimExb4hh8K5lRCRiM0IMIgsOpCw69bFvqLlQCDc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-07-2010 23:31, figo zhang escreveu:
> 
>     Em Thu, 21 May 2009 12:46:04 +0800
>     "Figo.zhang" <figo1802@gmail.com <mailto:figo1802@gmail.com>> escreveu:
> 
>     > hi,all,
>     >  I am puzzle that how to mmap ( V4L2_MEMORY_MMAP) in videobuf-dma-sg.c?
>     >
>     > In this file, it alloc the momery using vmalloc_32() , and put this
>     > momery into sglist table,and then use dma_map_sg() to create sg dma at
>     > __videobuf_iolock() function. but in __videobuf_mmap_mapper(), i canot
>     > understand how it do the mmap?
>     > why it not use the remap_vmalloc_range() to do the mmap?
> 
>     The answer is simple: remap_vmalloc_range() is newer than videobuf code. This
>     part of the code was written back to kernel 2.4, and nobody cared to update it
>     to use those newer functions, and simplify its code.
> 
> 
> thanks, in __videobuf_mmap_mapper(), it define a videobuf_vm_ops->fault, it will alloc a new page for mmaping when it  encounter page fault (do_page_fault),
> so how the mmap() can mmap the vmalloc memory which had allocted before using __videobuf_iolock()/vmalloc_32() ?

Sorry for not answering earlier.

The current videobuf implementation has some problems. Laurent and Pawel are working
on a new implementation that will likely solve such issues. Not sure if they already
submitted the patches, since I just return back from vacations, and I'm still trying
to handle all the backlogs on my inboxes. I haven't look at LMML posts yet.

Cheers,
Mauro.

> 
> Thanks,
> Figo.zhang
>  
> 
> 
>     If you want, feel free to propose some cleanups on it
> 
> 
> 
>     Cheers,
>     Mauro
> 
> 

