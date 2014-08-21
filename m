Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49910 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbaHUVaG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 17:30:06 -0400
Date: Fri, 22 Aug 2014 05:29:33 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 496/499]
 drivers/media/platform/ti-vpe/vpdma.c:332:10: warning: cast from pointer to integer of different size
Message-ID: <53f664bd.+HWNK/FbFCGVOkJ2%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   2558eeda5cd75649a1159aadca530a990b81c4ee
commit: 3a29cde494f90301499ea7ed318643982f812f7f [496/499] [media] enable COMPILE_TEST for ti-vbe
config: make ARCH=x86_64 allmodconfig

All warnings:

   In file included from arch/x86/include/asm/bug.h:35:0,
                    from include/linux/bug.h:4,
                    from include/linux/cpumask.h:12,
                    from arch/x86/include/asm/cpumask.h:4,
                    from arch/x86/include/asm/msr.h:10,
                    from arch/x86/include/asm/processor.h:20,
                    from arch/x86/include/asm/atomic.h:6,
                    from include/linux/atomic.h:4,
                    from include/linux/debug_locks.h:5,
                    from include/linux/lockdep.h:23,
                    from include/linux/spinlock_types.h:18,
                    from include/linux/mutex.h:15,
                    from include/linux/kernfs.h:13,
                    from include/linux/sysfs.h:15,
                    from include/linux/kobject.h:21,
                    from include/linux/device.h:17,
                    from include/linux/dma-mapping.h:5,
                    from drivers/media/platform/ti-vpe/vpdma.c:16:
   drivers/media/platform/ti-vpe/vpdma.c: In function 'vpdma_alloc_desc_buf':
>> drivers/media/platform/ti-vpe/vpdma.c:332:10: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     WARN_ON((u32) buf->addr & VPDMA_DESC_ALIGN);
             ^
   include/asm-generic/bug.h:86:25: note: in definition of macro 'WARN_ON'
     int __ret_warn_on = !!(condition);    \
                            ^
   In file included from include/linux/printk.h:257:0,
                    from include/linux/kernel.h:13,
                    from include/linux/delay.h:10,
                    from drivers/media/platform/ti-vpe/vpdma.c:15:
   drivers/media/platform/ti-vpe/vpdma.c: In function 'dump_dtd':
   include/linux/dynamic_debug.h:64:16: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/ti-vpe/vpdma.c:587:2: note: in expansion of macro 'pr_debug'
     pr_debug("word2: start_addr = 0x%08x\n", dtd->start_addr);
     ^

vim +332 drivers/media/platform/ti-vpe/vpdma.c

9262e5a2 Archit Taneja 2013-10-16  316  	DUMPREG(VIP_UP_Y_CSTAT);
9262e5a2 Archit Taneja 2013-10-16  317  	DUMPREG(VIP_UP_UV_CSTAT);
9262e5a2 Archit Taneja 2013-10-16  318  	DUMPREG(VPI_CTL_CSTAT);
9262e5a2 Archit Taneja 2013-10-16  319  }
9262e5a2 Archit Taneja 2013-10-16  320  
9262e5a2 Archit Taneja 2013-10-16  321  /*
9262e5a2 Archit Taneja 2013-10-16  322   * Allocate a DMA buffer
9262e5a2 Archit Taneja 2013-10-16  323   */
9262e5a2 Archit Taneja 2013-10-16  324  int vpdma_alloc_desc_buf(struct vpdma_buf *buf, size_t size)
9262e5a2 Archit Taneja 2013-10-16  325  {
9262e5a2 Archit Taneja 2013-10-16  326  	buf->size = size;
9262e5a2 Archit Taneja 2013-10-16  327  	buf->mapped = false;
9262e5a2 Archit Taneja 2013-10-16  328  	buf->addr = kzalloc(size, GFP_KERNEL);
9262e5a2 Archit Taneja 2013-10-16  329  	if (!buf->addr)
9262e5a2 Archit Taneja 2013-10-16  330  		return -ENOMEM;
9262e5a2 Archit Taneja 2013-10-16  331  
9262e5a2 Archit Taneja 2013-10-16 @332  	WARN_ON((u32) buf->addr & VPDMA_DESC_ALIGN);
9262e5a2 Archit Taneja 2013-10-16  333  
9262e5a2 Archit Taneja 2013-10-16  334  	return 0;
9262e5a2 Archit Taneja 2013-10-16  335  }
9262e5a2 Archit Taneja 2013-10-16  336  
9262e5a2 Archit Taneja 2013-10-16  337  void vpdma_free_desc_buf(struct vpdma_buf *buf)
9262e5a2 Archit Taneja 2013-10-16  338  {
9262e5a2 Archit Taneja 2013-10-16  339  	WARN_ON(buf->mapped);
9262e5a2 Archit Taneja 2013-10-16  340  	kfree(buf->addr);

:::::: The code at line 332 was first introduced by commit
:::::: 9262e5a2253ad055d465fcf0905a5b5f160ce6f8 [media] v4l: ti-vpe: Create a vpdma helper library

:::::: TO: Archit Taneja <archit@ti.com>
:::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
