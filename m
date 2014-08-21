Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28418 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbaHUW4G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 18:56:06 -0400
Date: Fri, 22 Aug 2014 06:55:54 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 498/499] ERROR: "omapdss_compat_init"
 undefined!
Message-ID: <53f678fa.xHewYZEdCq2Io7qg%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   2558eeda5cd75649a1159aadca530a990b81c4ee
commit: ace9078f1c07b94332e37a5017bb34097e082e54 [498/499] [media] enable COMPILE_TEST for OMAP2 vout
config: make ARCH=mips allmodconfig

All error/warnings:

>> ERROR: "omapdss_compat_init" undefined!
>> ERROR: "omap_dss_get_overlay_manager" undefined!
>> ERROR: "omap_dss_get_num_overlay_managers" undefined!
>> ERROR: "omap_dss_get_overlay" undefined!
>> ERROR: "omapdss_is_initialized" undefined!
>> ERROR: "omap_dispc_register_isr" undefined!
>> ERROR: "omapdss_get_version" undefined!
>> ERROR: "omap_dss_put_device" undefined!
>> ERROR: "omap_dss_get_next_device" undefined!
>> ERROR: "omap_dispc_unregister_isr" undefined!
>> ERROR: "omapdss_compat_uninit" undefined!
>> ERROR: "omap_dss_get_device" undefined!
>> ERROR: "omap_dss_get_num_overlays" undefined!
--
   In file included from arch/mips/include/asm/page.h:238:0,
                    from include/linux/mmzone.h:20,
                    from include/linux/gfp.h:5,
                    from include/linux/kmod.h:22,
                    from include/linux/module.h:13,
                    from drivers/media/platform/omap/omap_voutlib.c:21:
   drivers/media/platform/omap/omap_voutlib.c: In function 'omap_vout_alloc_buffer':
   arch/mips/include/asm/page.h:226:50: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast
    #define virt_to_page(kaddr) pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
                                                     ^
   include/asm-generic/memory_model.h:30:41: note: in definition of macro '__pfn_to_page'
    #define __pfn_to_page(pfn) (mem_map + ((pfn) - ARCH_PFN_OFFSET))
                                            ^
   arch/mips/include/asm/page.h:226:41: note: in expansion of macro 'PFN_DOWN'
    #define virt_to_page(kaddr) pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
                                            ^
>> drivers/media/platform/omap/omap_voutlib.c:313:20: note: in expansion of macro 'virt_to_page'
       SetPageReserved(virt_to_page(addr));
                       ^
   In file included from arch/mips/include/asm/page.h:178:0,
                    from include/linux/mmzone.h:20,
                    from include/linux/gfp.h:5,
                    from include/linux/kmod.h:22,
                    from include/linux/module.h:13,
                    from drivers/media/platform/omap/omap_voutlib.c:21:
   arch/mips/include/asm/io.h:119:29: note: expected 'const volatile void *' but argument is of type 'long unsigned int'
    static inline unsigned long virt_to_phys(volatile const void *address)
                                ^
   In file included from arch/mips/include/asm/page.h:238:0,
                    from include/linux/mmzone.h:20,
                    from include/linux/gfp.h:5,
                    from include/linux/kmod.h:22,
                    from include/linux/module.h:13,
                    from drivers/media/platform/omap/omap_voutlib.c:21:
   drivers/media/platform/omap/omap_voutlib.c: In function 'omap_vout_free_buffer':
   arch/mips/include/asm/page.h:226:50: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast
    #define virt_to_page(kaddr) pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
                                                     ^
   include/asm-generic/memory_model.h:30:41: note: in definition of macro '__pfn_to_page'
    #define __pfn_to_page(pfn) (mem_map + ((pfn) - ARCH_PFN_OFFSET))
                                            ^
   arch/mips/include/asm/page.h:226:41: note: in expansion of macro 'PFN_DOWN'
    #define virt_to_page(kaddr) pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
                                            ^
>> drivers/media/platform/omap/omap_voutlib.c:334:21: note: in expansion of macro 'virt_to_page'
      ClearPageReserved(virt_to_page(addr));
                        ^
   In file included from arch/mips/include/asm/page.h:178:0,
                    from include/linux/mmzone.h:20,
                    from include/linux/gfp.h:5,
                    from include/linux/kmod.h:22,
                    from include/linux/module.h:13,
                    from drivers/media/platform/omap/omap_voutlib.c:21:
   arch/mips/include/asm/io.h:119:29: note: expected 'const volatile void *' but argument is of type 'long unsigned int'
    static inline unsigned long virt_to_phys(volatile const void *address)
                                ^

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
