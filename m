Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59095 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbZEUKfW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 06:35:22 -0400
Date: Thu, 21 May 2009 07:35:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: how to mmap in  videobuf-dma-sg.c
Message-ID: <20090521073518.1c0c0a5b@pedra.chehab.org>
In-Reply-To: <1242881164.3824.2.camel@myhost>
References: <1242881164.3824.2.camel@myhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 May 2009 12:46:04 +0800
"Figo.zhang" <figo1802@gmail.com> escreveu:

> hi,all,
>  I am puzzle that how to mmap ( V4L2_MEMORY_MMAP) in videobuf-dma-sg.c?
> 
> In this file, it alloc the momery using vmalloc_32() , and put this
> momery into sglist table,and then use dma_map_sg() to create sg dma at
> __videobuf_iolock() function. but in __videobuf_mmap_mapper(), i canot
> understand how it do the mmap? 
> why it not use the remap_vmalloc_range() to do the mmap?

The answer is simple: remap_vmalloc_range() is newer than videobuf code. This
part of the code was written back to kernel 2.4, and nobody cared to update it
to use those newer functions, and simplify its code.

If you want, feel free to propose some cleanups on it



Cheers,
Mauro
