Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:33169 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbZG2JVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 05:21:47 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-kernel@vger.kernel.org,
	"v4l2_linux" <linux-media@vger.kernel.org>
Subject: Is get_user_pages() enough to prevent pages from being swapped out ?
Date: Wed, 29 Jul 2009 11:23:12 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907291123.12811.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

I'm trying to debug a video acquisition device driver and found myself having 
to dive deep into the memory management subsystem.

The driver uses videobuf-dma-sg to manage video buffers. videobuf-dma-sg gets 
pointers to buffers from userspace and calls get_user_pages() to retrieve the 
list of pages underlying those buffers. The page list is used to build a 
scatter-gather list that is given to the hardware. The device then performs 
DMA directly to the memory.

Pages underlying the buffers must obviously not be swapped out during DMA. The 
get_user_pages() (mm/memory.c) documentation seems to imply that returned 
pages are pinned to memory (my understanding of "pinned" is that they will not 
be swapped out):

/**
 * get_user_pages() - pin user pages in memory
 * @tsk:        task_struct of target task
 * @mm:         mm_struct of target mm
 * @start:      starting user address
 * @len:        number of pages from start to pin
 * @write:      whether pages will be written to by the caller
 * @force:      whether to force write access even if user mapping is
 *              readonly. This will result in the page being COWed even
 *              in MAP_SHARED mappings. You do not want this.
 * @pages:      array that receives pointers to the pages pinned.
 *              Should be at least nr_pages long. Or NULL, if caller
 *              only intends to ensure the pages are faulted in.
 * @vmas:       array of pointers to vmas corresponding to each page.
 *              Or NULL if the caller does not require them.

However, all is seems to do for that purpose is incrementing the page 
reference count using get_page().

I had a look through the memory management subsystem code and it seems to me 
that incrementing the reference count is not sufficient to make sure the page 
won't be swapped out. To ensure that, it should instead be marked as 
unevictable, either directly or by marking an associated VMA as VM_LOCKED. 
This is what the mlock() syscall does, in addition to calling 
get_user_pages().

The MM subsystem is quite complex and my understanding might not be correct, 
so I'd appreciate if someone could shed light on the issue. Does 
get_user_pages() really pin pages to memory and prevent them from being 
swapped out in all circumstances ? If so, how does it do so ? If not, what's 
the proper way to make sure the pages won't disappear during DMA ?

Please CC me on answers.

Regards,

Laurent Pinchart

