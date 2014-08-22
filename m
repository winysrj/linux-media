Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:40153 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaHVAiJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 20:38:09 -0400
Date: Fri, 22 Aug 2014 08:37:35 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 499/499] warning: (VIDEO_TIMBERDALE) selects TIMB_DMA which has unmet direct dependencies (DMADEVICES && ..)
Message-ID: <53f690cf.jzKEXKaoyQsstgq9%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   2558eeda5cd75649a1159aadca530a990b81c4ee
commit: 2558eeda5cd75649a1159aadca530a990b81c4ee [499/499] [media] enable COMPILE_TEST for media drivers
config: make ARCH=s390 allmodconfig

All error/warnings:

warning: (VIDEO_TIMBERDALE) selects TIMB_DMA which has unmet direct dependencies (DMADEVICES && MFD_TIMBERDALE)
   drivers/media/platform/exynos-gsc/gsc-core.c: In function 'gsc_prepare_addr':
>> drivers/media/platform/exynos-gsc/gsc-core.c:855:2: warning: format '%X' expects argument of type 'unsigned int', but argument 3 has type 'dma_addr_t' [-Wformat=]
     pr_debug("ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
     ^
>> drivers/media/platform/exynos-gsc/gsc-core.c:855:2: warning: format '%X' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t' [-Wformat=]
>> drivers/media/platform/exynos-gsc/gsc-core.c:855:2: warning: format '%X' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
--
   drivers/media/platform/exynos-gsc/gsc-regs.c: In function 'gsc_hw_set_input_addr':
>> drivers/media/platform/exynos-gsc/gsc-regs.c:93:2: warning: format '%X' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t' [-Wformat=]
     pr_debug("src_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X", index,
     ^
>> drivers/media/platform/exynos-gsc/gsc-regs.c:93:2: warning: format '%X' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
>> drivers/media/platform/exynos-gsc/gsc-regs.c:93:2: warning: format '%X' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
   drivers/media/platform/exynos-gsc/gsc-regs.c: In function 'gsc_hw_set_output_addr':
>> drivers/media/platform/exynos-gsc/gsc-regs.c:104:2: warning: format '%X' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t' [-Wformat=]
     pr_debug("dst_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X",
     ^
>> drivers/media/platform/exynos-gsc/gsc-regs.c:104:2: warning: format '%X' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
>> drivers/media/platform/exynos-gsc/gsc-regs.c:104:2: warning: format '%X' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
--
   drivers/media/platform/s3c-camif/camif-capture.c: In function 'camif_prepare_addr':
>> drivers/media/platform/s3c-camif/camif-capture.c:283:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
     pr_debug("DMA address: y: %#x  cb: %#x cr: %#x\n",
     ^
>> drivers/media/platform/s3c-camif/camif-capture.c:283:2: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
>> drivers/media/platform/s3c-camif/camif-capture.c:283:2: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
--
   drivers/media/platform/s3c-camif/camif-regs.c: In function 'camif_hw_set_output_addr':
>> drivers/media/platform/s3c-camif/camif-regs.c:217:2: warning: format '%X' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
     pr_debug("dst_buf[%d]: %#X, cb: %#X, cr: %#X\n",
     ^
>> drivers/media/platform/s3c-camif/camif-regs.c:217:2: warning: format '%X' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
>> drivers/media/platform/s3c-camif/camif-regs.c:217:2: warning: format '%X' expects argument of type 'unsigned int', but argument 8 has type 'dma_addr_t' [-Wformat=]
--
   drivers/media/platform/soc_camera/atmel-isi.c: In function 'start_streaming':
   drivers/media/platform/soc_camera/atmel-isi.c:397:26: warning: large integer implicitly truncated to unsigned type [-Woverflow]
     isi_writel(isi, ISI_INTDIS, ~0UL);
                             ^
   drivers/media/platform/soc_camera/atmel-isi.c: In function 'atmel_isi_probe':
>> drivers/media/platform/soc_camera/atmel-isi.c:981:26: warning: passing argument 3 of 'dma_alloc_coherent' from incompatible pointer type
     isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
                             ^
   In file included from include/linux/dma-mapping.h:82:0,
                    from include/linux/dma-buf.h:31,
                    from include/media/videobuf2-core.h:19,
                    from include/media/soc_camera.h:21,
                    from drivers/media/platform/soc_camera/atmel-isi.c:26:
   arch/s390/include/asm/dma-mapping.h:59:92: note: expected 'dma_addr_t *' but argument is of type 'u32 *'
    static inline void *dma_alloc_coherent(struct device *dev, size_t size,
                                                                                               ^
--
>> ERROR: "omap_stop_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
>> ERROR: "omap_start_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
>> ERROR: "omap_dma_link_lch" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
>> ERROR: "omap_set_dma_dest_burst_mode" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
>> ERROR: "omap_set_dma_src_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
>> ERROR: "omap_request_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
>> ERROR: "omap_set_dma_transfer_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
>> ERROR: "omap_set_dma_dest_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
>> ERROR: "omap_free_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
   ERROR: "omapdss_compat_init" [drivers/media/platform/omap/omap-vout.ko] undefined!
   ERROR: "omap_dss_get_overlay_manager" [drivers/media/platform/omap/omap-vout.ko] undefined!
   ERROR: "omap_dss_get_num_overlay_managers" [drivers/media/platform/omap/omap-vout.ko] undefined!
   ERROR: "omap_dss_get_overlay" [drivers/media/platform/omap/omap-vout.ko] undefined!
   ERROR: "omapdss_is_initialized" [drivers/media/platform/omap/omap-vout.ko] undefined!
   ERROR: "omap_dispc_register_isr" [drivers/media/platform/omap/omap-vout.ko] undefined!
   ERROR: "omapdss_get_version" [drivers/media/platform/omap/omap-vout.ko] undefined!
   ERROR: "omap_dss_put_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
   ERROR: "omap_dss_get_next_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
   ERROR: "omap_dispc_unregister_isr" [drivers/media/platform/omap/omap-vout.ko] undefined!
   ERROR: "omapdss_compat_uninit" [drivers/media/platform/omap/omap-vout.ko] undefined!
   ERROR: "omap_dss_get_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
   ERROR: "omap_dss_get_num_overlays" [drivers/media/platform/omap/omap-vout.ko] undefined!
>> ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_display.ko] undefined!
>> ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_capture.ko] undefined!

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
