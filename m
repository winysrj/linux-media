Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:45587 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312AbZIUPPC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 11:15:02 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MpkbY-0003SI-9G
	for linux-media@vger.kernel.org; Mon, 21 Sep 2009 17:15:04 +0200
Received: from 217.153.235.18 ([217.153.235.18])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 17:15:04 +0200
Received: from m.szyprowski by 217.153.235.18 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 17:15:04 +0200
To: linux-media@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC] Global video buffers pool
Date: Mon, 21 Sep 2009 15:07:05 +0000 (UTC)
Message-ID: <loom.20090921T122131-888@post.gmane.org>
References: <200909161746.39754.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

We have been developing quite simmilar solution for Samsung SoCs multimedia 
drivers that the one mentioned in this RFC.

Our solution bases on the global buffer manager that provides buffers 
(contiguous in physical memory) to user applications. Then the application can 
pass the buffers (as input or output) to different multimedia device drivers. 
Please note that our solution is aimed at UMA systems, where all multimedia 
devices can access system memory directly.

We decided not to use any special buffer identifiers. In our solution 
applications must mmap the buffer (even if they don't plan to read/write it 
directly) and pass the buffer user pointer to the multimedia driver.

To get access to specified buffer we prepared a special layer that checks if 
the passed user pointer points to the buffer that is continuous in physical 
memory, locks properly the buffer memory and returns the buffer physical 
address. More details on this solution can be found here: 
http://thread.gmane.org/gmane.linux.ports.arm.kernel/56879

Using the user pointer access type gave us the possibility to directly 
transfer multimedia data to frame buffer memory and to create an SYSV SHMem 
area from it (by some additional hacks in kernel mm). This gave us the real 
power esspecially in hardware acceleration of XServer - with XSHM extensions 
we were able to blit frames directly from user application's buffer to the 
frame buffer memory.

Our multimedia devices do not use V4L framework currently, but moving towards 
V4L2 is possible.

Now let's get back to the RFC thesis.

The idea behind the global memory pool is really good and especially required 
in embedded-like systems. One of the important features of the buffer manager 
is cache coherency control. User, who allocated a buffer can request the 
buffer should be mapped as cacheable area or not, depending on the aimed use 
case. Queueing non-cacheable buffers is faster of course (no cache flush is 
required), but CPU read access is much slower (note the write-combining here).

A global memory pool should also reduce system memory requirements, however it 
should be kept in mind that some use cases might cause memory fragmentation 
issues. A pluginable memory management should also be considered. With some 
standard allocating methods like all buffers of the same size, first fit, best 
fit, etc in the buffer manager most of the typical usecases can be covered. 
Also some statistics on buffer allocation/deallocation and usage can be easily 
gathered with buffer manager.

However one should consider whether introducing new v4l2 buffer access method 
(V4L2_MEMORY_POOL) is really required. One of the key features of the 
introduced pool buffer identifiers is the much quicker buffer locking, as no 
per-page locking needs to be done. However a simmilar effect can be achieved 
with USERPTR access method. User application can allocate the buffer from the 
buffer manager (global pool), mmap it and pass it to the driver with USERPTR 
method. The driver can quite easily check if the passed user pointer is a 
pointer to the buffer from the pool and then lock it quickly with the simmilar 
method we used in our drivers for SoCs multimedia hardware.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



