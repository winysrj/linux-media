Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:35234 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZEUEqL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 00:46:11 -0400
Subject: how to mmap in  videobuf-dma-sg.c
From: "Figo.zhang" <figo1802@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Thu, 21 May 2009 12:46:04 +0800
Message-Id: <1242881164.3824.2.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi,all,
 I am puzzle that how to mmap ( V4L2_MEMORY_MMAP) in videobuf-dma-sg.c?

In this file, it alloc the momery using vmalloc_32() , and put this
momery into sglist table,and then use dma_map_sg() to create sg dma at
__videobuf_iolock() function. but in __videobuf_mmap_mapper(), i canot
understand how it do the mmap? 
why it not use the remap_vmalloc_range() to do the mmap?

Thanks ,

