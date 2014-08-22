Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25586 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbaHVAoK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 20:44:10 -0400
Date: Fri, 22 Aug 2014 08:43:35 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [linuxtv-media:devel] 2558eeda5cd75649a1159aadca530a990b81c4ee
 BUILD DONE
Message-ID: <53f69237.HqeDFN50NeLSHUBE%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

git://linuxtv.org/media_tree.git  devel
2558eeda5cd75649a1159aadca530a990b81c4ee  [media] enable COMPILE_TEST for media drivers

ERROR: "__bad_ndelay" undefined!
ERROR: "omap_dispc_register_isr" [drivers/media/platform/omap/omap-vout.ko] undefined!
ERROR: "omap_dispc_register_isr" undefined!
ERROR: "omap_dispc_unregister_isr" [drivers/media/platform/omap/omap-vout.ko] undefined!
ERROR: "omap_dispc_unregister_isr" undefined!
ERROR: "omap_dma_link_lch" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
ERROR: "omap_dma_link_lch" undefined!
ERROR: "omap_dss_get_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
ERROR: "omap_dss_get_device" undefined!
ERROR: "omap_dss_get_next_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
ERROR: "omap_dss_get_next_device" undefined!
ERROR: "omap_dss_get_num_overlay_managers" [drivers/media/platform/omap/omap-vout.ko] undefined!
ERROR: "omap_dss_get_num_overlay_managers" undefined!
ERROR: "omap_dss_get_num_overlays" [drivers/media/platform/omap/omap-vout.ko] undefined!
ERROR: "omap_dss_get_num_overlays" undefined!
ERROR: "omap_dss_get_overlay" [drivers/media/platform/omap/omap-vout.ko] undefined!
ERROR: "omap_dss_get_overlay" undefined!
ERROR: "omap_dss_get_overlay_manager" [drivers/media/platform/omap/omap-vout.ko] undefined!
ERROR: "omap_dss_get_overlay_manager" undefined!
ERROR: "omap_dss_put_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
ERROR: "omap_dss_put_device" undefined!
ERROR: "omap_free_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
ERROR: "omap_free_dma" undefined!
ERROR: "omap_request_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
ERROR: "omap_request_dma" undefined!
ERROR: "omap_set_dma_dest_burst_mode" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
ERROR: "omap_set_dma_dest_burst_mode" undefined!
ERROR: "omap_set_dma_dest_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
ERROR: "omap_set_dma_dest_params" undefined!
ERROR: "omap_set_dma_src_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
ERROR: "omap_set_dma_src_params" undefined!
ERROR: "omap_set_dma_transfer_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
ERROR: "omap_set_dma_transfer_params" undefined!
ERROR: "omap_start_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
ERROR: "omap_start_dma" undefined!
ERROR: "omap_stop_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
ERROR: "omap_stop_dma" undefined!
ERROR: "omapdss_compat_init" [drivers/media/platform/omap/omap-vout.ko] undefined!
ERROR: "omapdss_compat_init" undefined!
ERROR: "omapdss_compat_uninit" [drivers/media/platform/omap/omap-vout.ko] undefined!
ERROR: "omapdss_compat_uninit" undefined!
ERROR: "omapdss_get_version" [drivers/media/platform/omap/omap-vout.ko] undefined!
ERROR: "omapdss_get_version" undefined!
ERROR: "omapdss_is_initialized" [drivers/media/platform/omap/omap-vout.ko] undefined!
ERROR: "omapdss_is_initialized" undefined!
ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_display.ko] undefined!
ERROR: "vpif_lock" undefined!
arch/ia64/include/asm/dma-mapping.h:26:37: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type
drivers/media/platform/davinci/dm644x_ccdc.c:294:44: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/media/platform/davinci/dm644x_ccdc.c:304:17: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
drivers/media/platform/davinci/vpfe_capture.c:1916:2: note: in expansion of macro 'v4l2_dbg'
drivers/media/platform/davinci/vpfe_capture.c:1917:21: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/media/platform/davinci/vpif_display.c:36:3: note: in expansion of macro 'v4l2_dbg'
drivers/media/platform/davinci/vpif_display.c:1213:3: note: in expansion of macro 'vpif_dbg'
drivers/media/platform/davinci/vpif_display.c:1214:14: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/media/platform/exynos-gsc/gsc-core.c:855:2: note: in expansion of macro 'pr_debug'
drivers/media/platform/exynos-gsc/gsc-core.c:855:2: warning: format '%X' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
drivers/media/platform/exynos-gsc/gsc-regs.c:104:2: note: in expansion of macro 'pr_debug'
drivers/media/platform/exynos-gsc/gsc-regs.c:104:2: warning: format '%X' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
drivers/media/platform/omap/omap_vout.c:805:58: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
drivers/media/platform/omap/omap_vout.c:422:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
drivers/media/platform/omap/omap_voutlib.c:334:21: note: in expansion of macro 'virt_to_page'
drivers/media/platform/s3c-camif/camif-capture.c:283:2: note: in expansion of macro 'pr_debug'
drivers/media/platform/s3c-camif/camif-capture.c:283:2: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
drivers/media/platform/s3c-camif/camif-regs.c:217:2: note: in expansion of macro 'pr_debug'
drivers/media/platform/s3c-camif/camif-regs.c:217:2: warning: format '%X' expects argument of type 'unsigned int', but argument 8 has type 'dma_addr_t' [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:195:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1224:32: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1900:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_opr.c:44:2: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_opr.c:53:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:665:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:492:2: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:484:4: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1898:8: note: in expansion of macro 'READL'
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1888:2: note: in expansion of macro 'WRITEL'
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2045:3: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1898:14: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:108:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:601:2: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:495:4: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat=]
drivers/media/platform/soc_camera/atmel-isi.c:981:26: note: in expansion of macro 'dma_alloc_coherent'
drivers/media/platform/soc_camera/atmel-isi.c:397:30: warning: large integer implicitly truncated to unsigned type [-Woverflow]
drivers/media/platform/soc_camera/atmel-isi.c:981:26: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type
drivers/media/platform/soc_camera/atmel-isi.c:981:26: warning: passing argument 3 of 'dma_alloc_coherent' from incompatible pointer type
drivers/media/platform/ti-vpe/vpdma.c:587:2: note: in expansion of macro 'pr_debug'
drivers/media/platform/ti-vpe/vpdma.c:332:10: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/media/platform/ti-vpe/vpdma.c:587:21: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'dma_addr_t' [-Wformat=]
include/linux/dynamic_debug.h:64:16: warning: format '%X' expects argument of type 'unsigned int', but argument 8 has type 'dma_addr_t' [-Wformat=]
drivers/built-in.o:(.bss+0xc7ee2c): multiple definition of `debug'
warning: (VIDEO_TIMBERDALE) selects TIMB_DMA which has unmet direct dependencies (DMADEVICES && MFD_TIMBERDALE)

elapsed time: 257m

configs tested: 113

parisc                        c3000_defconfig
parisc                         b180_defconfig
parisc                              defconfig
alpha                               defconfig
parisc                            allnoconfig
arm                       omap2plus_defconfig
arm                                    sa1100
arm                              allmodconfig
arm                          prima2_defconfig
arm                         at91_dt_defconfig
arm                               allnoconfig
arm                                   samsung
arm                       spear13xx_defconfig
arm                         s3c2410_defconfig
arm                                  iop-adma
arm                       imx_v6_v7_defconfig
arm                                       mmp
arm                           tegra_defconfig
arm                                      arm5
arm                          marzen_defconfig
arm                                  at_hdmac
arm                                    ep93xx
arm                                        sh
arm                                     arm67
i386                              allnoconfig
i386                                defconfig
i386                             allmodconfig
i386                             alldefconfig
mips                             allmodconfig
mips                                   jz4740
mips                              allnoconfig
mips                      fuloong2e_defconfig
mips                                     txx9
x86_64                            allnoconfig
x86_64                                    lkp
x86_64                                   rhel
sh                            titan_defconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                                allnoconfig
i386                   randconfig-c0-08220513
i386                   randconfig-c1-08220513
x86_64                     randconfig-c0-0822
x86_64                     randconfig-c2-0822
x86_64                     randconfig-c3-0822
x86_64                     randconfig-c1-0822
powerpc                      chroma_defconfig
powerpc                 linkstation_defconfig
powerpc                               powerpc
powerpc                         wii_defconfig
powerpc                    gamecube_defconfig
powerpc               corenet64_smp_defconfig
powerpc                               mpc512x
powerpc                                ppc44x
x86_64                     randconfig-j1-0822
x86_64                     randconfig-j0-0822
i386                      randconfig-ha4-0822
i386                      randconfig-ha2-0822
i386                      randconfig-ha0-0822
i386                      randconfig-ha5-0822
i386                      randconfig-ha3-0822
i386                      randconfig-ha1-0822
ia64                             allmodconfig
ia64                              allnoconfig
ia64                                defconfig
ia64                             alldefconfig
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
microblaze                       allyesconfig
i386                             allyesconfig
x86_64              randconfig-hsxa0-08220703
x86_64              randconfig-hsxa1-08220703
x86_64              randconfig-hsxa2-08220703
x86_64                                    lkp
x86_64                                   rhel
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
xtensa                       common_defconfig
m32r                       m32104ut_defconfig
xtensa                          iss_defconfig
m32r                         opsput_defconfig
m32r                           usrv_defconfig
m32r                     mappi3.smp_defconfig
cris                 etrax-100lx_v2_defconfig
blackfin                  TCM-BF537_defconfig
blackfin            BF561-EZKIT-SMP_defconfig
blackfin                BF533-EZKIT_defconfig
blackfin                BF526-EZBRD_defconfig
i386                       randconfig-r2-0822
i386                       randconfig-r0-0822
i386                       randconfig-r1-0822
i386                       randconfig-r3-0822
s390                             allmodconfig
s390                              allnoconfig
s390                                defconfig
x86_64                 randconfig-s0-08220740
x86_64                 randconfig-s1-08220740
mn10300                     asb2364_defconfig
openrisc                    or1ksim_defconfig
um                           x86_64_defconfig
um                             i386_defconfig
avr32                      atngw100_defconfig
frv                                 defconfig
avr32                     atstk1006_defconfig
tile                         tilegx_defconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot

Thanks,
Fengguang
