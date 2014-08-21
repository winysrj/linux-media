Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37129 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938AbaHUWLc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 18:11:32 -0400
Date: Fri, 22 Aug 2014 06:10:04 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 498/499]
 drivers/media/platform/omap/omap_vout.c:209:23: warning: cast to pointer
 from integer of different size
Message-ID: <53f66e3c.ojG3YRThX0uS1Tvh%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   2558eeda5cd75649a1159aadca530a990b81c4ee
commit: ace9078f1c07b94332e37a5017bb34097e082e54 [498/499] [media] enable COMPILE_TEST for OMAP2 vout
config: make ARCH=ia64 allmodconfig

All warnings:

   drivers/media/platform/omap/omap_vout.c: In function 'omap_vout_uservirt_to_phys':
>> drivers/media/platform/omap/omap_vout.c:209:23: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      return virt_to_phys((void *) virtp);
                          ^
   drivers/media/platform/omap/omap_vout.c: In function 'omapvid_setup_overlay':
>> drivers/media/platform/omap/omap_vout.c:422:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
     v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev,
     ^
   drivers/media/platform/omap/omap_vout.c: In function 'omap_vout_buffer_prepare':
>> drivers/media/platform/omap/omap_vout.c:796:34: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      vout->queued_buf_addr[vb->i] = (u8 *)
                                     ^
   In file included from arch/ia64/include/asm/dma-mapping.h:56:0,
                    from include/linux/dma-mapping.h:82,
                    from drivers/media/platform/omap/omap_vout.c:40:
>> drivers/media/platform/omap/omap_vout.c:805:58: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      dma_addr = dma_map_single(vout->vid_dev->v4l2_dev.dev, (void *) addr,
                                                             ^
   include/asm-generic/dma-mapping-common.h:174:60: note: in definition of macro 'dma_map_single'
    #define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, NULL)
                                                               ^

vim +209 drivers/media/platform/omap/omap_vout.c

5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  193  
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  194  	return bpp;
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  195  }
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  196  
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  197  /*
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  198   * omap_vout_uservirt_to_phys: This inline function is used to convert user
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  199   * space virtual address to physical address.
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  200   */
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  201  static u32 omap_vout_uservirt_to_phys(u32 virtp)
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  202  {
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  203  	unsigned long physp = 0;
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  204  	struct vm_area_struct *vma;
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  205  	struct mm_struct *mm = current->mm;
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  206  
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  207  	/* For kernel direct-mapped memory, take the easy way */
55ee64b3 drivers/media/platform/omap/omap_vout.c Al Viro          2012-12-16  208  	if (virtp >= PAGE_OFFSET)
55ee64b3 drivers/media/platform/omap/omap_vout.c Al Viro          2012-12-16 @209  		return virt_to_phys((void *) virtp);
55ee64b3 drivers/media/platform/omap/omap_vout.c Al Viro          2012-12-16  210  
55ee64b3 drivers/media/platform/omap/omap_vout.c Al Viro          2012-12-16  211  	down_read(&current->mm->mmap_sem);
55ee64b3 drivers/media/platform/omap/omap_vout.c Al Viro          2012-12-16  212  	vma = find_vma(mm, virtp);
55ee64b3 drivers/media/platform/omap/omap_vout.c Al Viro          2012-12-16  213  	if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  214  		/* this will catch, kernel-allocated, mmaped-to-usermode
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  215  		   addresses */
5c7ab634 drivers/media/video/omap/omap_vout.c    Vaibhav Hiremath 2010-04-11  216  		physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start);
55ee64b3 drivers/media/platform/omap/omap_vout.c Al Viro          2012-12-16  217  		up_read(&current->mm->mmap_sem);

:::::: The code at line 209 was first introduced by commit
:::::: 55ee64b30a38d688232e5eb2860467dddc493573 [media] omap_vout: find_vma() needs ->mmap_sem held

:::::: TO: Al Viro <viro@ZenIV.linux.org.uk>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
