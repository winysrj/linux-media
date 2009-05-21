Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:8320 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbZEUKsj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 06:48:39 -0400
Received: by wf-out-1314.google.com with SMTP id 26so340623wfd.4
        for <linux-media@vger.kernel.org>; Thu, 21 May 2009 03:48:40 -0700 (PDT)
Subject: Re: how to mmap in  videobuf-dma-sg.c
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
In-Reply-To: <20090521073518.1c0c0a5b@pedra.chehab.org>
References: <1242881164.3824.2.camel@myhost>
	 <20090521073518.1c0c0a5b@pedra.chehab.org>
Content-Type: text/plain
Date: Thu, 21 May 2009 18:48:31 +0800
Message-Id: <1242902911.12072.3.camel@myhost>
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
> 
> 
> 
> Cheers,
> Mauro

hi mauro,
Thank you! 
But i canot found the similar function code of remap_vmalloc_range() in
the videobuf-dma-contig.c file. So i want to know the how is work in
__videobuf_mmap_mapper() function?



