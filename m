Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:35365 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbaHUXTI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 19:19:08 -0400
Date: Fri, 22 Aug 2014 07:17:46 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 499/499]
 drivers/media/platform/davinci/vpif_display.c:1214:5: warning: cast from
 pointer to integer of different size
Message-ID: <53f67e1a.0HrZvnF5S1LVESYf%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   2558eeda5cd75649a1159aadca530a990b81c4ee
commit: 2558eeda5cd75649a1159aadca530a990b81c4ee [499/499] [media] enable COMPILE_TEST for media drivers
config: make ARCH=ia64 allmodconfig

All warnings:

   In file included from include/media/v4l2-subdev.h:28:0,
                    from include/media/v4l2-device.h:25,
                    from drivers/media/platform/davinci/vpif_display.h:21,
                    from drivers/media/platform/davinci/vpif_display.c:26:
   drivers/media/platform/davinci/vpif_display.c: In function 'vpif_probe_complete':
>> drivers/media/platform/davinci/vpif_display.c:1214:5: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
        (int)ch, (int)&ch->video_dev);
        ^
   include/media/v4l2-common.h:62:44: note: in definition of macro 'v4l2_printk'
     printk(level "%s: " fmt, (dev)->name , ## arg)
                                               ^
>> drivers/media/platform/davinci/vpif_display.c:36:3: note: in expansion of macro 'v4l2_dbg'
      v4l2_dbg(level, debug, &vpif_obj.v4l2_dev, fmt, ## arg)
      ^
>> drivers/media/platform/davinci/vpif_display.c:1213:3: note: in expansion of macro 'vpif_dbg'
      vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
      ^
>> drivers/media/platform/davinci/vpif_display.c:1214:14: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
        (int)ch, (int)&ch->video_dev);
                 ^
   include/media/v4l2-common.h:62:44: note: in definition of macro 'v4l2_printk'
     printk(level "%s: " fmt, (dev)->name , ## arg)
                                               ^
>> drivers/media/platform/davinci/vpif_display.c:36:3: note: in expansion of macro 'v4l2_dbg'
      v4l2_dbg(level, debug, &vpif_obj.v4l2_dev, fmt, ## arg)
      ^
>> drivers/media/platform/davinci/vpif_display.c:1213:3: note: in expansion of macro 'vpif_dbg'
      vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
      ^
--
   In file included from drivers/media/platform/davinci/vpfe_capture.c:74:0:
   drivers/media/platform/davinci/vpfe_capture.c: In function 'vpfe_probe':
>> drivers/media/platform/davinci/vpfe_capture.c:1917:21: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      "video_dev=%x\n", (int)&vpfe_dev->video_dev);
                        ^
   include/media/v4l2-common.h:62:44: note: in definition of macro 'v4l2_printk'
     printk(level "%s: " fmt, (dev)->name , ## arg)
                                               ^
>> drivers/media/platform/davinci/vpfe_capture.c:1916:2: note: in expansion of macro 'v4l2_dbg'
     v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
     ^
--
   drivers/media/platform/davinci/dm644x_ccdc.c: In function 'ccdc_update_raw_params':
>> drivers/media/platform/davinci/dm644x_ccdc.c:254:17: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     fpc_physaddr = (unsigned int *)config_params->fault_pxl.fpc_table_addr;
                    ^
   In file included from include/linux/uaccess.h:5:0,
                    from drivers/media/platform/davinci/dm644x_ccdc.c:38:
>> drivers/media/platform/davinci/dm644x_ccdc.c:289:4: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
       (void __user *)raw_params->fault_pxl.fpc_table_addr,
       ^
   arch/ia64/include/asm/uaccess.h:268:34: note: in definition of macro 'copy_from_user'
     const void __user *__cu_from = (from);      \
                                     ^
>> drivers/media/platform/davinci/dm644x_ccdc.c:294:44: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     config_params->fault_pxl.fpc_table_addr = (unsigned int)fpc_physaddr;
                                               ^
   drivers/media/platform/davinci/dm644x_ccdc.c: In function 'ccdc_close':
>> drivers/media/platform/davinci/dm644x_ccdc.c:304:17: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     fpc_physaddr = (unsigned int *)config_params->fault_pxl.fpc_table_addr;
                    ^
--
   In file included from include/linux/printk.h:257:0,
                    from include/linux/kernel.h:13,
                    from include/asm-generic/bug.h:13,
                    from arch/ia64/include/asm/bug.h:12,
                    from include/linux/bug.h:4,
                    from include/linux/thread_info.h:11,
                    from include/asm-generic/preempt.h:4,
                    from arch/ia64/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:18,
                    from include/linux/spinlock.h:50,
                    from include/linux/seqlock.h:35,
                    from include/linux/time.h:5,
                    from include/linux/stat.h:18,
                    from include/linux/module.h:10,
                    from drivers/media/platform/exynos-gsc/gsc-core.c:13:
   drivers/media/platform/exynos-gsc/gsc-core.c: In function 'gsc_prepare_addr':
>> include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 3 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/exynos-gsc/gsc-core.c:855:2: note: in expansion of macro 'pr_debug'
     pr_debug("ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
     ^
>> include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/exynos-gsc/gsc-core.c:855:2: note: in expansion of macro 'pr_debug'
     pr_debug("ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
     ^
>> include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/exynos-gsc/gsc-core.c:855:2: note: in expansion of macro 'pr_debug'
     pr_debug("ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
     ^
--
   In file included from include/linux/printk.h:257:0,
                    from include/linux/kernel.h:13,
                    from include/linux/unaligned/packed_struct.h:4,
                    from include/linux/unaligned/le_struct.h:4,
                    from arch/ia64/include/asm/unaligned.h:4,
                    from arch/ia64/include/asm/io.h:22,
                    from include/linux/io.h:22,
                    from drivers/media/platform/exynos-gsc/gsc-regs.c:13:
   drivers/media/platform/exynos-gsc/gsc-regs.c: In function 'gsc_hw_set_input_addr':
>> include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/exynos-gsc/gsc-regs.c:93:2: note: in expansion of macro 'pr_debug'
     pr_debug("src_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X", index,
     ^
>> include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/exynos-gsc/gsc-regs.c:93:2: note: in expansion of macro 'pr_debug'
     pr_debug("src_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X", index,
     ^
>> include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/exynos-gsc/gsc-regs.c:93:2: note: in expansion of macro 'pr_debug'
     pr_debug("src_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X", index,
     ^
   drivers/media/platform/exynos-gsc/gsc-regs.c: In function 'gsc_hw_set_output_addr':
>> include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/exynos-gsc/gsc-regs.c:104:2: note: in expansion of macro 'pr_debug'
     pr_debug("dst_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X",
     ^
>> include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/exynos-gsc/gsc-regs.c:104:2: note: in expansion of macro 'pr_debug'
     pr_debug("dst_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X",
     ^
>> include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/exynos-gsc/gsc-regs.c:104:2: note: in expansion of macro 'pr_debug'
     pr_debug("dst_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X",
     ^
--
   In file included from include/linux/printk.h:257:0,
                    from include/linux/kernel.h:13,
                    from include/linux/delay.h:10,
                    from drivers/media/platform/s3c-camif/camif-regs.c:13:
   drivers/media/platform/s3c-camif/camif-regs.c: In function 'camif_hw_set_output_addr':
>> include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/s3c-camif/camif-regs.c:217:2: note: in expansion of macro 'pr_debug'
     pr_debug("dst_buf[%d]: %#X, cb: %#X, cr: %#X\n",
     ^
>> include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/s3c-camif/camif-regs.c:217:2: note: in expansion of macro 'pr_debug'
     pr_debug("dst_buf[%d]: %#X, cb: %#X, cr: %#X\n",
     ^
>> include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 8 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/s3c-camif/camif-regs.c:217:2: note: in expansion of macro 'pr_debug'
     pr_debug("dst_buf[%d]: %#X, cb: %#X, cr: %#X\n",
     ^
--
   In file included from include/linux/printk.h:257:0,
                    from include/linux/kernel.h:13,
                    from include/asm-generic/bug.h:13,
                    from arch/ia64/include/asm/bug.h:12,
                    from include/linux/bug.h:4,
                    from drivers/media/platform/s3c-camif/camif-capture.c:16:
   drivers/media/platform/s3c-camif/camif-capture.c: In function 'camif_prepare_addr':
   include/linux/dynamic_debug.h:64:16: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/s3c-camif/camif-capture.c:283:2: note: in expansion of macro 'pr_debug'
     pr_debug("DMA address: y: %#x  cb: %#x cr: %#x\n",
     ^
   include/linux/dynamic_debug.h:64:16: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/s3c-camif/camif-capture.c:283:2: note: in expansion of macro 'pr_debug'
     pr_debug("DMA address: y: %#x  cb: %#x cr: %#x\n",
     ^
   include/linux/dynamic_debug.h:64:16: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/s3c-camif/camif-capture.c:283:2: note: in expansion of macro 'pr_debug'
     pr_debug("DMA address: y: %#x  cb: %#x cr: %#x\n",
     ^
--
   In file included from drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:29:0:
   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c: In function 's5p_mfc_dec_init':
>> drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1224:4: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
       (unsigned int)ctx->src_fmt, (unsigned int)ctx->dst_fmt);
       ^
   drivers/media/platform/s5p-mfc/s5p_mfc_debug.h:27:27: note: in definition of macro 'mfc_debug'
        __func__, __LINE__, ##args); \
                              ^
>> drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1224:32: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
       (unsigned int)ctx->src_fmt, (unsigned int)ctx->dst_fmt);
                                   ^
   drivers/media/platform/s5p-mfc/s5p_mfc_debug.h:27:27: note: in definition of macro 'mfc_debug'
        __func__, __LINE__, ##args); \
                              ^
--
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c: In function 'check_vb_with_fmt':
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1778:3: warning: format '%zx' expects argument of type 'size_t', but argument 6 has type 'dma_addr_t' [-Wformat=]
      mfc_debug(2, "index: %d, plane[%d] cookie: 0x%08zx\n",
      ^
   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c: In function 's5p_mfc_buf_prepare':
>> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1900:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' [-Wformat=]
      mfc_debug(2, "plane size: %ld, dst size: %d\n",
      ^
..

vim +1214 drivers/media/platform/davinci/vpif_display.c

a2b235cb Lad, Prabhakar 2014-05-16  1207  			goto probe_out;
a2b235cb Lad, Prabhakar 2014-05-16  1208  		}
a2b235cb Lad, Prabhakar 2014-05-16  1209  
a2b235cb Lad, Prabhakar 2014-05-16  1210  		INIT_LIST_HEAD(&common->dma_queue);
a2b235cb Lad, Prabhakar 2014-05-16  1211  
4b8a531e Lad, Prabhakar 2013-06-25  1212  		/* register video device */
4b8a531e Lad, Prabhakar 2013-06-25 @1213  		vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
4b8a531e Lad, Prabhakar 2013-06-25 @1214  			 (int)ch, (int)&ch->video_dev);
4b8a531e Lad, Prabhakar 2013-06-25  1215  
76c4c2be Lad, Prabhakar 2014-05-16  1216  		/* Initialize the video_device structure */
4be2153c Lad, Prabhakar 2014-05-16  1217  		vdev = ch->video_dev;

:::::: The code at line 1214 was first introduced by commit
:::::: 4b8a531e6bb0686203e9cf82a54dfe189de7d5c2 [media] media: davinci: vpif: display: add V4L2-async support

:::::: TO: Lad, Prabhakar <prabhakar.csengg@gmail.com>
:::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
