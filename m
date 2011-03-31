Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:51209 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1CaB74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 21:59:56 -0400
Received: from epmmp2 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LIW00AYRG7SQUD0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Mar 2011 10:59:53 +0900 (KST)
Received: from JONGHUNHA11 ([12.23.103.140])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIW006ICG7SPM@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Mar 2011 10:59:53 +0900 (KST)
Date: Thu, 31 Mar 2011 10:59:43 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: RE: v4l: Buffer pools
In-reply-to: <757395B8DE5A844B80F3F4BE9867DDB652374B2340@EXDCVYMBSTM006.EQ1STM.local>
To: linux-media@vger.kernel.org
Cc: =?ks_c_5601-1987?B?J7bzsaTH9ic=?= <nala.la@samsung.com>,
	=?ks_c_5601-1987?B?sei787n8L1MvVyBTb2x1dGlvbrCzud/GwChTLkxTSSkvRQ==?=
	 =?ks_c_5601-1987?B?NSjDpcDTKS+777y6wPzA2g==?=
	<sbkim73@samsung.com>,
	=?ks_c_5601-1987?B?seixucH4L1MvVyBTb2x1dGlvbrCzud/GwChTLkxTSSkvRQ==?=
	 =?ks_c_5601-1987?B?NSjDpcDTKS+777y6wPzA2g==?=
	<kgene.kim@samsung.com>,
	=?ks_c_5601-1987?B?J7DtwOe47Sc=?= <jemings@samsung.com>,
	=?ks_c_5601-1987?B?J8DMwM/Ioyc=?= <ilho215.lee@samsung.com>,
	=?ks_c_5601-1987?B?J8DMu/PH9ic=?= <sanghyun75.lee@samsung.com>,
	=?ks_c_5601-1987?B?wbaw5sijL1MvVyBTb2x1dGlvbrCzud/GwChTLkxTSSkvRQ==?=
	 =?ks_c_5601-1987?B?NCi8scDTKS+777y6wPzA2g==?=
	<pullip.cho@samsung.com>
Message-id: <000001cbef47$532066e0$f96134a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: ko
Content-transfer-encoding: 7BIT
References: <757395B8DE5A844B80F3F4BE9867DDB652374B2340@EXDCVYMBSTM006.EQ1STM.local>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi all,

The followings are Samsung S.LSI requirement for memory provider.

1. User space API
1.1. New memory management(MM) features should includes followings 
     to the user space.: UMP
A. user space API for memory allocation from system memory: UMP
   Any user process can allocate memory from kernel space by new MM model.
B. user space API for cache operations: flush, clean, invalidate
   Any user process can do cache operation on the allocated memory.
C. user space API for mapping memory attribute as cacheable
   When the system memory mapped into the user space,
   user process can set its property as cacheable.
D. user space API for mapping memory attribute as non-cacheable
   When the system memory mapped into the user space,
   user process can set its property as non-cacheable.

1.2. Inter-process memory sharing: UMP
New MM features should provide memory sharing between user process.

A. Memory allocated by user space can be shared between user processes.
B. Memory allocated by kernel space can be shared between user processes.

2. Kernel space API
New MM features should includes followings to the kernel space.: CMA, VCMM

2-1. Physically memory allocator
A. kernel space API for contiguous memory allocation: CMA(*)
B. kernel space API for non-contiguous memory allocation: VCMM (*)
C. start address alignment: CMA, VCMM
D. selectable allocating region: CMA
*refer to the bottom's extension.

2-2. Device virtual address management: VCMM
New MM features should provide 
the way of managing device virtual memory address as like followings:

A. IOMMU(System MMU) support
   IOMMU is a kind of memory MMU, but IOMMU is dedicated for each device.
B. device virtual address mapping for each device
C. virtual memory allocation
D. mapping / remapping between phys and device virtual address
E. dedicated device virtual address space for each device
F. address translation between address space

	     U.V
	    /   \
	  K.V - P.A
	   \    /
	     D.V

	U.V: User space address
	K.A: Kernel space address
	P.A: Physical address
	D.V: Device virtual address

3. Extensions
A. extension for custom physical memory allocator
B. extension for custom MMU controller

-------------------------------------------------------------------------
You can find the implementation in the following git repository.
http://git.kernel.org/?p=linux/kernel/git/kki_ap/linux-2.6-
samsung.git;a=tree;hb=refs/heads/2.6.36-samsung

1. UMP (Unified Memory Provider)
- The UMP is an auxiliary component which enables memory to be shared
  across different applications, drivers and hardware components.
- http://blogs.arm.com/multimedia/249-making-the-mali-gpu-device-driver-
open-source/page__cid__133__show__newcomment/
- Suggested by ARM, Not submitted yet.
- implementation
  drivers/media/video/samsung/ump/*

2. VCMM (Virtual Contiguous Memory Manager)
- The VCMM is a framework to deal with multiple IOMMUs in a system
  with intuitive and abstract objects
- Submitted by Michal Nazarewicz @Samsung-SPRC
- Also submitted by KyongHo Cho @Samsung-SYS.LSI
- http://article.gmane.org/gmane.linux.kernel.mm/56912/match=vcm
- implementation
  include/linux/vcm.h
  include/linux/vcm-drv.h
  mm/vcm.c
  arch/arm/plat-s5p/s5p-vcm.c
  arch/amr/plat-s5p/include/plat/s5p-vcm.h

3. CMA (Contiguous Memory Allocator)
- The Contiguous Memory Allocator (CMA) is a framework, which allows
  setting up a machine-specific configuration for physically-contiguous
  memory management. Memory for devices is then allocated according
  to that configuration.
- http://lwn.net/Articles/396702/
- http://www.spinics.net/lists/linux-media/msg26486.html
- Submitted by Michal Nazarewicz @Samsung-SPRC
- implementation
  mm/cma.c
  include/linux/cma.h

4. SYS.MMU
- System MMU supports address transition from VA to PA.
- http://thread.gmane.org/gmane.linux.kernel.samsung-soc/3909
- Submitted by Sangbeom Kim
- Merged by Kukjin Kim, ARM/S5P ARM ARCHITECTURES maintainer
- implementation
  arch/arm/plat-s5p/sysmmu.c
  arch/arm/plat-s5p/include/plat/sysmmu.h

Best regards,
Jonghun Han

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Willy POISSON
> Sent: Tuesday, March 29, 2011 11:02 PM
> To: linux-media@vger.kernel.org
> Subject: v4l: Buffer pools
> 
> Hi all,
> 	Following to the Warsaw mini-summit action point, I would like to
open
> the thread to gather buffer pool & memory manager requirements.
> The list of requirement for buffer pool may contain:
> -	Support physically contiguous and virtual memory
> -	Support IPC, import/export handles (between
> processes/drivers/userland/etc)
> -	Security(access rights in order to secure no one unauthorized is
> allowed to access buffers)
> -	Cache flush management (by using setdomain and optimize when
flushing
> is needed)
> -	Pin/unpin in order to get the actual address to be able to do
> defragmentation
> -	Support pinning in user land in order to allow defragmentation while
> buffer is mmapped but not pined.
> -	Both a user API and a Kernel API is needed for this module. (Kernel
> drivers needs to be able to resolve buffer handles as well from the memory
> manager module, and pin/unpin)
> -	be able to support any platform specific allocator (Separate memory
> allocation from management as allocator is platform dependant)
> -	Support multiple region domain (Allow to allocate from several
memory
> domain ex: DDR1, DDR2, Embedded SRAM to make for ex bandwidth load
> balancing ...)
> Another idea, but not so linked to memory management (more usage of
buffers),
> would be to have a common data container (structure to access data)
shared by
> several media (Imaging, video/still codecs, graphics, Display...) to ease
> usage of the data. This container could  embed data type (video frames,
> Access Unit) , frames format, pixel format, width, height, pixel aspect
ratio,
> region of interest, CTS (composition time stamp),  ColorSpace,
transparency
> (opaque, alpha, color key...), pointer on buffer(s) handle)...
> Regards,
> 	Willy.
> =============
> Willy Poisson
> ST-Ericsson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

