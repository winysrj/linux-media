Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:60816 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab0FZCDG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jun 2010 22:03:06 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 25 Jun 2010 21:02:51 -0500
Subject: [omap3camera] Kernel broken when building rx51 with camera
Message-ID: <A24693684029E5489D1D202277BE894456225272@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_A24693684029E5489D1D202277BE894456225272dlee02entticom_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_A24693684029E5489D1D202277BE894456225272dlee02entticom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Laurent/Sakari,

Not sure what is exactly happening, but I can't get the kernel
to build with latest omap3camera gitorious devel branch.

Attached is the .config I'm using (rx51_defconfig + usual camera options),
and also here's the error that I see during build:

WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=3Dy'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/arm/kernel/built-in.o: In function `arch_reset':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/include/plat/s=
ystem.h:48: undefined reference to `omap_prcm_arch_reset'
arch/arm/mach-omap2/built-in.o: In function `rx51_mmc2_remux':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/board-rx51-pe=
ripherals.c:277: undefined reference to `omap_mux_write_array'
arch/arm/mach-omap2/built-in.o: In function `hsmmc23_before_set_reg':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/hsmmc.c:190: =
undefined reference to `omap_ctrl_readl'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/hsmmc.c:192: =
undefined reference to `omap_ctrl_writel'
arch/arm/mach-omap2/built-in.o: In function `omap_hsmmc1_before_set_reg':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/hsmmc.c:76: u=
ndefined reference to `omap_ctrl_readl'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/hsmmc.c:78: u=
ndefined reference to `omap_ctrl_writel'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/hsmmc.c:81: u=
ndefined reference to `omap_ctrl_readl'
arch/arm/mach-omap2/built-in.o: In function `is_omap363x':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/include/plat/c=
pu.h:117: undefined reference to `omap_rev'
arch/arm/mach-omap2/built-in.o: In function `omap_hsmmc1_before_set_reg':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/hsmmc.c:84: u=
ndefined reference to `omap_ctrl_readl'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/hsmmc.c:86: u=
ndefined reference to `omap_ctrl_writel'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/hsmmc.c:93: u=
ndefined reference to `omap_ctrl_readl'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/hsmmc.c:95: u=
ndefined reference to `omap_ctrl_writel'
arch/arm/mach-omap2/built-in.o: In function `omap_hsmmc1_after_set_reg':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/hsmmc.c:108: =
undefined reference to `omap_ctrl_readl'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/hsmmc.c:116: =
undefined reference to `omap_ctrl_readl'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/hsmmc.c:119: =
undefined reference to `omap_ctrl_writel'
arch/arm/mach-omap2/built-in.o: In function `omap2_onenand_set_async_mode':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:59: undefined reference to `gpmc_round_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:60: undefined reference to `gpmc_round_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:61: undefined reference to `gpmc_round_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:62: undefined reference to `gpmc_round_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:63: undefined reference to `gpmc_round_ns_to_ticks'
arch/arm/mach-omap2/built-in.o:/home/x0091359/omapzoom/linux-omap-camera/ar=
ch/arm/mach-omap2/gpmc-onenand.c:64: more undefined references to `gpmc_rou=
nd_ns_to_ticks' follow
arch/arm/mach-omap2/built-in.o: In function `omap2_onenand_set_async_mode':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:80: undefined reference to `gpmc_cs_write_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:84: undefined reference to `gpmc_cs_set_timings'
arch/arm/mach-omap2/built-in.o: In function `omap2_onenand_set_sync_mode':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:206: undefined reference to `gpmc_ticks_to_ns'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:207: undefined reference to `gpmc_cs_calc_divider'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:208: undefined reference to `gpmc_ticks_to_ns'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:223: undefined reference to `gpmc_cs_read_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:225: undefined reference to `gpmc_cs_write_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:226: undefined reference to `gpmc_cs_read_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:228: undefined reference to `gpmc_cs_write_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:229: undefined reference to `gpmc_cs_read_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:234: undefined reference to `gpmc_cs_read_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:236: undefined reference to `gpmc_cs_write_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:237: undefined reference to `gpmc_cs_read_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:239: undefined reference to `gpmc_cs_write_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:240: undefined reference to `gpmc_cs_read_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:243: undefined reference to `gpmc_cs_write_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:251: undefined reference to `gpmc_round_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:252: undefined reference to `gpmc_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:256: undefined reference to `gpmc_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:256: undefined reference to `gpmc_ticks_to_ns'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:257: undefined reference to `gpmc_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:257: undefined reference to `gpmc_ticks_to_ns'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:258: undefined reference to `gpmc_ticks_to_ns'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:259: undefined reference to `gpmc_round_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:261: undefined reference to `gpmc_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:262: undefined reference to `gpmc_ticks_to_ns'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:273: undefined reference to `gpmc_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:273: undefined reference to `gpmc_ticks_to_ns'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:279: undefined reference to `gpmc_round_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:281: undefined reference to `gpmc_round_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:282: undefined reference to `gpmc_round_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:283: undefined reference to `gpmc_round_ns_to_ticks'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:284: undefined reference to `gpmc_round_ns_to_ticks'
arch/arm/mach-omap2/built-in.o:/home/x0091359/omapzoom/linux-omap-camera/ar=
ch/arm/mach-omap2/gpmc-onenand.c:287: more undefined references to `gpmc_ro=
und_ns_to_ticks' follow
arch/arm/mach-omap2/built-in.o: In function `omap2_onenand_set_sync_mode':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:292: undefined reference to `gpmc_cs_write_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-onenand.=
c:307: undefined reference to `gpmc_cs_set_timings'
arch/arm/mach-omap2/built-in.o: In function `smc91c96_gpmc_retime':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-smc91x.c=
:105: undefined reference to `gpmc_cs_write_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-smc91x.c=
:117: undefined reference to `gpmc_cs_set_timings'
arch/arm/mach-omap2/built-in.o: In function `omap2_i2c_mux_pins':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/i2c.c:48: und=
efined reference to `omap_mux_init_signal'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/i2c.c:50: und=
efined reference to `omap_mux_init_signal'
arch/arm/mach-omap2/built-in.o: In function `rx51_camera_init':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/board-rx51-ca=
mera.c:636: undefined reference to `omap3isp_device'
arch/arm/mach-omap2/built-in.o: In function `rx51_init':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/board-rx51.c:=
132: undefined reference to `omap3_mux_init'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/board-rx51.c:=
133: undefined reference to `omap_serial_init'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/board-rx51.c:=
138: undefined reference to `omap_mux_init_signal'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/board-rx51.c:=
139: undefined reference to `omap_mux_init_signal'
arch/arm/mach-omap2/built-in.o: In function `rx51_init_irq':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/board-rx51.c:=
109: undefined reference to `omap2_init_common_hw'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/board-rx51.c:=
110: undefined reference to `omap_init_irq'
arch/arm/mach-omap2/built-in.o: In function `rx51_map_io':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/board-rx51.c:=
148: undefined reference to `omap34xx_map_common_io'
arch/arm/mach-omap2/built-in.o: In function `board_smc91x_init':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/board-rx51-pe=
ripherals.c:824: undefined reference to `omap_mux_init_gpio'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/board-rx51-pe=
ripherals.c:825: undefined reference to `omap_mux_init_gpio'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/board-rx51-pe=
ripherals.c:826: undefined reference to `omap_mux_init_gpio'
arch/arm/mach-omap2/built-in.o: In function `rx51_video_init':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/board-rx51-vi=
deo.c:78: undefined reference to `omap_mux_init_gpio'
arch/arm/mach-omap2/built-in.o: In function `is_omap3517':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/include/plat/c=
pu.h:253: undefined reference to `omap_rev'
arch/arm/mach-omap2/built-in.o: In function `is_omap3505':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/include/plat/c=
pu.h:252: undefined reference to `omap_rev'
arch/arm/mach-omap2/built-in.o: In function `is_omap363x':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/include/plat/c=
pu.h:117: undefined reference to `omap_rev'
arch/arm/mach-omap2/built-in.o: In function `omap2_hsmmc_init':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/hsmmc.c:344: =
undefined reference to `omap2_init_mmc'
arch/arm/mach-omap2/built-in.o: In function `gpmc_smc91x_init':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-smc91x.c=
:135: undefined reference to `gpmc_cs_request'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/mach-omap2/gpmc-smc91x.c=
:188: undefined reference to `gpmc_cs_free'
arch/arm/mach-omap2/built-in.o:(.arch.info.init+0x30): undefined reference =
to `omap_timer'
arch/arm/mach-omap2/built-in.o:(.data+0x2f0): undefined reference to `omap3=
isp_device'
arch/arm/plat-omap/built-in.o: In function `omap3_sram_restore_context':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/sram.c:421: un=
defined reference to `omap_push_sram_idle'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/sram.c:421: un=
defined reference to `omap3_sram_configure_core_dpll_sz'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/sram.c:421: un=
defined reference to `omap3_sram_configure_core_dpll'
arch/arm/plat-omap/built-in.o: In function `omap_dma_global_context_restore=
':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/dma.c:2031: un=
defined reference to `omap_type'
arch/arm/plat-omap/built-in.o: In function `omap_device_enable_clocks':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/omap_device.c:=
728: undefined reference to `omap_hwmod_enable_clocks'
arch/arm/plat-omap/built-in.o: In function `omap_device_disable_clocks':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/omap_device.c:=
709: undefined reference to `omap_hwmod_disable_clocks'
arch/arm/plat-omap/built-in.o: In function `omap_device_idle_hwmods':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/omap_device.c:=
690: undefined reference to `omap_hwmod_idle'
arch/arm/plat-omap/built-in.o: In function `omap_device_enable_hwmods':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/omap_device.c:=
672: undefined reference to `omap_hwmod_enable'
arch/arm/plat-omap/built-in.o: In function `omap_device_get_pwrdm':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/omap_device.c:=
652: undefined reference to `omap_hwmod_get_pwrdm'
arch/arm/plat-omap/built-in.o: In function `omap_device_shutdown':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/omap_device.c:=
575: undefined reference to `omap_hwmod_shutdown'
arch/arm/plat-omap/built-in.o: In function `omap_device_fill_resources':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/omap_device.c:=
294: undefined reference to `omap_hwmod_fill_resources'
arch/arm/plat-omap/built-in.o: In function `omap_device_count_resources':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/omap_device.c:=
262: undefined reference to `omap_hwmod_count_resources'
arch/arm/plat-omap/built-in.o: In function `omap_st_off':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/mcbsp.c:269: u=
ndefined reference to `cm_read_mod_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/mcbsp.c:271: u=
ndefined reference to `cm_write_mod_reg'
arch/arm/plat-omap/built-in.o: In function `omap_st_on':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/mcbsp.c:240: u=
ndefined reference to `cm_read_mod_reg'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/mcbsp.c:242: u=
ndefined reference to `cm_write_mod_reg'
arch/arm/plat-omap/built-in.o: In function `__omap2_set_globals':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/common.c:256: =
undefined reference to `omap2_set_globals_tap'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/common.c:257: =
undefined reference to `omap2_set_globals_sdrc'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/common.c:258: =
undefined reference to `omap2_set_globals_control'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/common.c:259: =
undefined reference to `omap2_set_globals_prcm'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/common.c:260: =
undefined reference to `omap2_set_globals_uart'
arch/arm/plat-omap/built-in.o: In function `omap34xx_sram_init':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/sram.c:430: un=
defined reference to `omap_push_sram_idle'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/sram.c:432: un=
defined reference to `omap3_sram_configure_core_dpll_sz'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/sram.c:432: un=
defined reference to `omap3_sram_configure_core_dpll'
arch/arm/plat-omap/built-in.o: In function `omap_detect_sram':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/sram.c:139: un=
defined reference to `omap_type'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/sram.c:139: un=
defined reference to `omap_type'
arch/arm/plat-omap/built-in.o: In function `omap_init_dma':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/dma.c:2179: un=
defined reference to `omap_type'
drivers/built-in.o: In function `omap_vrfb_setup':
/home/x0091359/omapzoom/linux-omap-camera/drivers/video/omap2/vrfb.c:202: u=
ndefined reference to `omap2_sms_write_rot_physical_ba'
/home/x0091359/omapzoom/linux-omap-camera/drivers/video/omap2/vrfb.c:203: u=
ndefined reference to `omap2_sms_write_rot_size'
/home/x0091359/omapzoom/linux-omap-camera/drivers/video/omap2/vrfb.c:204: u=
ndefined reference to `omap2_sms_write_rot_control'
drivers/built-in.o: In function `restore_hw_context':
/home/x0091359/omapzoom/linux-omap-camera/drivers/video/omap2/vrfb.c:77: un=
defined reference to `omap2_sms_write_rot_control'
/home/x0091359/omapzoom/linux-omap-camera/drivers/video/omap2/vrfb.c:78: un=
defined reference to `omap2_sms_write_rot_size'
/home/x0091359/omapzoom/linux-omap-camera/drivers/video/omap2/vrfb.c:79: un=
defined reference to `omap2_sms_write_rot_physical_ba'
drivers/built-in.o: In function `is_omap363x':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/include/plat/c=
pu.h:117: undefined reference to `omap_rev'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/include/plat/c=
pu.h:117: undefined reference to `omap_rev'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/include/plat/c=
pu.h:117: undefined reference to `omap_rev'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/include/plat/c=
pu.h:117: undefined reference to `omap_rev'
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/include/plat/c=
pu.h:117: undefined reference to `omap_rev'
drivers/built-in.o:/home/x0091359/omapzoom/linux-omap-camera/drivers/video/=
omap2/dss/dispc.c:2114: more undefined references to `omap_rev' follow
drivers/built-in.o: In function `smia_power_on':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:411: undefined reference to `smia_reglist_find_type'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:430: undefined reference to `smia_i2c_write_regs'
drivers/built-in.o: In function `smia_set_pad_format':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:640: undefined reference to `smia_reglist_find_mode_fmt'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:642: undefined reference to `smia_reglist_to_mbus'
drivers/built-in.o: In function `smia_enum_frame_ival':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:589: undefined reference to `smia_reglist_enum_frame_ival'
drivers/built-in.o: In function `smia_enum_frame_size':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:580: undefined reference to `smia_reglist_enum_frame_size'
drivers/built-in.o: In function `smia_enum_mbus_code':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:571: undefined reference to `smia_reglist_enum_mbus_code'
drivers/built-in.o: In function `smia_set_frame_interval':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:668: undefined reference to `smia_reglist_find_mode_ival'
drivers/built-in.o: In function `smia_set_exposure':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:275: undefined reference to `smia_i2c_write_reg'
drivers/built-in.o: In function `smia_set_gain':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:250: undefined reference to `smia_i2c_write_reg'
drivers/built-in.o: In function `smia_configure':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:349: undefined reference to `smia_i2c_write_regs'
drivers/built-in.o: In function `smia_s_stream':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:384: undefined reference to `smia_i2c_write_reg'
drivers/built-in.o: In function `smia_get_ctrl':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:742: undefined reference to `smia_mode_g_ctrl'
drivers/built-in.o: In function `smia_query_ctrl':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:717: undefined reference to `smia_ctrl_query'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:719: undefined reference to `smia_mode_query'
drivers/built-in.o: In function `smia_dev_init':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:455: undefined reference to `smia_i2c_read_reg'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:455: undefined reference to `smia_i2c_read_reg'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:455: undefined reference to `smia_i2c_read_reg'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:455: undefined reference to `smia_i2c_read_reg'
drivers/built-in.o: In function `smia_read_frame_fmt':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:146: undefined reference to `smia_i2c_read_reg'
drivers/built-in.o:/home/x0091359/omapzoom/linux-omap-camera/drivers/media/=
video/smia-sensor.c:155: more undefined references to `smia_i2c_read_reg' f=
ollow
drivers/built-in.o: In function `smia_dev_init':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:513: undefined reference to `smia_reglist_import'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/smia-sensor.c=
:522: undefined reference to `smia_reglist_find_type'
drivers/built-in.o: In function `is_omap363x':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/include/plat/c=
pu.h:117: undefined reference to `omap_rev'
drivers/built-in.o: In function `isp_power_settings':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/isp/isp.c:251=
: undefined reference to `omap_rev'
drivers/built-in.o: In function `et8ek8_power_on':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:379:=
 undefined reference to `smia_i2c_reglist_find_write'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:387:=
 undefined reference to `smia_i2c_read_reg'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:396:=
 undefined reference to `smia_i2c_write_reg'
drivers/built-in.o: In function `et8ek8_s_stream':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:337:=
 undefined reference to `smia_i2c_write_reg'
drivers/built-in.o: In function `et8ek8_set_test_pattern':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:239:=
 undefined reference to `smia_i2c_write_reg'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:243:=
 undefined reference to `smia_i2c_write_reg'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:247:=
 undefined reference to `smia_i2c_write_reg'
drivers/built-in.o:/home/x0091359/omapzoom/linux-omap-camera/drivers/media/=
video/et8ek8.c:251: more undefined references to `smia_i2c_write_reg' follo=
w
drivers/built-in.o: In function `et8ek8_configure':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:314:=
 undefined reference to `smia_i2c_write_regs'
drivers/built-in.o: In function `et8ek8_set_pad_format':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:517:=
 undefined reference to `smia_reglist_find_mode_fmt'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:519:=
 undefined reference to `smia_reglist_to_mbus'
drivers/built-in.o: In function `et8ek8_enum_frame_ival':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:469:=
 undefined reference to `smia_reglist_enum_frame_ival'
drivers/built-in.o: In function `et8ek8_enum_frame_size':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:460:=
 undefined reference to `smia_reglist_enum_frame_size'
drivers/built-in.o: In function `et8ek8_enum_mbus_code':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:451:=
 undefined reference to `smia_reglist_enum_mbus_code'
drivers/built-in.o: In function `et8ek8_set_frame_interval':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:545:=
 undefined reference to `smia_reglist_find_mode_ival'
drivers/built-in.o: In function `et8ek8_get_ctrl':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:877:=
 undefined reference to `smia_mode_g_ctrl'
drivers/built-in.o: In function `et8ek8_query_ctrl':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:824:=
 undefined reference to `smia_ctrl_query'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:826:=
 undefined reference to `smia_mode_query'
drivers/built-in.o: In function `et8ek8_dev_init':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:649:=
 undefined reference to `smia_i2c_read_reg'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:649:=
 undefined reference to `smia_i2c_read_reg'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:676:=
 undefined reference to `smia_reglist_import'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:684:=
 undefined reference to `smia_reglist_find_type'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:695:=
 undefined reference to `smia_i2c_reglist_find_write'
drivers/built-in.o: In function `et8ek8_g_priv_mem':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:578:=
 undefined reference to `smia_i2c_write_reg'
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:588:=
 undefined reference to `smia_i2c_read_reg'
drivers/built-in.o: In function `et8ek8_set_exposure':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/et8ek8.c:201:=
 undefined reference to `smia_i2c_write_reg'
drivers/built-in.o: In function `ad5820_query_ctrl':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/ad5820.c:234:=
 undefined reference to `smia_ctrl_query'
drivers/built-in.o: In function `adp1653_query_ctrl':
/home/x0091359/omapzoom/linux-omap-camera/drivers/media/video/adp1653.c:250=
: undefined reference to `smia_ctrl_query'
drivers/built-in.o: In function `is_omap3430':
/home/x0091359/omapzoom/linux-omap-camera/arch/arm/plat-omap/include/plat/c=
pu.h:251: undefined reference to `omap_rev'
drivers/built-in.o: In function `omap2_onenand_probe':
/home/x0091359/omapzoom/linux-omap-camera/drivers/mtd/onenand/omap2.c:620: =
undefined reference to `gpmc_cs_request'
/home/x0091359/omapzoom/linux-omap-camera/drivers/mtd/onenand/omap2.c:755: =
undefined reference to `gpmc_cs_free'
drivers/built-in.o: In function `omap2_onenand_remove':
/home/x0091359/omapzoom/linux-omap-camera/drivers/mtd/onenand/omap2.c:788: =
undefined reference to `gpmc_cs_free'
make: *** [.tmp_vmlinux1] Error 1

Have you seen this?

Regards,
Sergio

--_002_A24693684029E5489D1D202277BE894456225272dlee02entticom_
Content-Type: application/octet-stream; name="config_rx51_fail"
Content-Description: config_rx51_fail
Content-Disposition: attachment; filename="config_rx51_fail"; size=56339;
	creation-date="Fri, 25 Jun 2010 20:55:42 GMT";
	modification-date="Fri, 25 Jun 2010 20:55:42 GMT"
Content-Transfer-Encoding: base64

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMgTGlu
dXgga2VybmVsIHZlcnNpb246IDIuNi4zNS1yYzIKIyBGcmkgSnVuIDI1IDIwOjM3OjIxIDIwMTAK
IwpDT05GSUdfQVJNPXkKQ09ORklHX1NZU19TVVBQT1JUU19BUE1fRU1VTEFUSU9OPXkKQ09ORklH
X0dFTkVSSUNfR1BJTz15CkNPTkZJR19HRU5FUklDX1RJTUU9eQojIENPTkZJR19BUkNIX1VTRVNf
R0VUVElNRU9GRlNFVCBpcyBub3Qgc2V0CkNPTkZJR19HRU5FUklDX0NMT0NLRVZFTlRTPXkKQ09O
RklHX0hBVkVfUFJPQ19DUFU9eQpDT05GSUdfR0VORVJJQ19IQVJESVJRUz15CkNPTkZJR19TVEFD
S1RSQUNFX1NVUFBPUlQ9eQpDT05GSUdfSEFWRV9MQVRFTkNZVE9QX1NVUFBPUlQ9eQpDT05GSUdf
TE9DS0RFUF9TVVBQT1JUPXkKQ09ORklHX1RSQUNFX0lSUUZMQUdTX1NVUFBPUlQ9eQpDT05GSUdf
SEFSRElSUVNfU1dfUkVTRU5EPXkKQ09ORklHX0dFTkVSSUNfSVJRX1BST0JFPXkKQ09ORklHX1JX
U0VNX0dFTkVSSUNfU1BJTkxPQ0s9eQpDT05GSUdfQVJDSF9IQVNfQ1BVRlJFUT15CkNPTkZJR19H
RU5FUklDX0hXRUlHSFQ9eQpDT05GSUdfR0VORVJJQ19DQUxJQlJBVEVfREVMQVk9eQpDT05GSUdf
TkVFRF9ETUFfTUFQX1NUQVRFPXkKQ09ORklHX0dFTkVSSUNfSEFSRElSUVNfTk9fX0RPX0lSUT15
CkNPTkZJR19BUk1fTDFfQ0FDSEVfU0hJRlRfNj15CkNPTkZJR19WRUNUT1JTX0JBU0U9MHhmZmZm
MDAwMApDT05GSUdfREVGQ09ORklHX0xJU1Q9Ii9saWIvbW9kdWxlcy8kVU5BTUVfUkVMRUFTRS8u
Y29uZmlnIgpDT05GSUdfQ09OU1RSVUNUT1JTPXkKCiMKIyBHZW5lcmFsIHNldHVwCiMKQ09ORklH
X0VYUEVSSU1FTlRBTD15CkNPTkZJR19CUk9LRU5fT05fU01QPXkKQ09ORklHX0lOSVRfRU5WX0FS
R19MSU1JVD0zMgpDT05GSUdfQ1JPU1NfQ09NUElMRT0iIgpDT05GSUdfTE9DQUxWRVJTSU9OPSIi
CkNPTkZJR19MT0NBTFZFUlNJT05fQVVUTz15CkNPTkZJR19IQVZFX0tFUk5FTF9HWklQPXkKQ09O
RklHX0hBVkVfS0VSTkVMX0xaTUE9eQpDT05GSUdfSEFWRV9LRVJORUxfTFpPPXkKQ09ORklHX0tF
Uk5FTF9HWklQPXkKIyBDT05GSUdfS0VSTkVMX0JaSVAyIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VS
TkVMX0xaTUEgaXMgbm90IHNldAojIENPTkZJR19LRVJORUxfTFpPIGlzIG5vdCBzZXQKQ09ORklH
X1NXQVA9eQpDT05GSUdfU1lTVklQQz15CkNPTkZJR19TWVNWSVBDX1NZU0NUTD15CkNPTkZJR19Q
T1NJWF9NUVVFVUU9eQpDT05GSUdfUE9TSVhfTVFVRVVFX1NZU0NUTD15CkNPTkZJR19CU0RfUFJP
Q0VTU19BQ0NUPXkKIyBDT05GSUdfQlNEX1BST0NFU1NfQUNDVF9WMyBpcyBub3Qgc2V0CiMgQ09O
RklHX1RBU0tTVEFUUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FVRElUIGlzIG5vdCBzZXQKCiMKIyBS
Q1UgU3Vic3lzdGVtCiMKQ09ORklHX1RSRUVfUkNVPXkKIyBDT05GSUdfVFJFRV9QUkVFTVBUX1JD
VSBpcyBub3Qgc2V0CiMgQ09ORklHX1RJTllfUkNVIGlzIG5vdCBzZXQKIyBDT05GSUdfUkNVX1RS
QUNFIGlzIG5vdCBzZXQKQ09ORklHX1JDVV9GQU5PVVQ9MzIKIyBDT05GSUdfUkNVX0ZBTk9VVF9F
WEFDVCBpcyBub3Qgc2V0CiMgQ09ORklHX1RSRUVfUkNVX1RSQUNFIGlzIG5vdCBzZXQKIyBDT05G
SUdfSUtDT05GSUcgaXMgbm90IHNldApDT05GSUdfTE9HX0JVRl9TSElGVD0xNwojIENPTkZJR19D
R1JPVVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lTRlNfREVQUkVDQVRFRF9WMiBpcyBub3Qgc2V0
CiMgQ09ORklHX1JFTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfTkFNRVNQQUNFUyBpcyBub3Qgc2V0
CkNPTkZJR19CTEtfREVWX0lOSVRSRD15CkNPTkZJR19JTklUUkFNRlNfU09VUkNFPSIiCkNPTkZJ
R19SRF9HWklQPXkKIyBDT05GSUdfUkRfQlpJUDIgaXMgbm90IHNldAojIENPTkZJR19SRF9MWk1B
IGlzIG5vdCBzZXQKIyBDT05GSUdfUkRfTFpPIGlzIG5vdCBzZXQKQ09ORklHX0NDX09QVElNSVpF
X0ZPUl9TSVpFPXkKQ09ORklHX1NZU0NUTD15CkNPTkZJR19BTk9OX0lOT0RFUz15CkNPTkZJR19F
TUJFRERFRD15CkNPTkZJR19VSUQxNj15CiMgQ09ORklHX1NZU0NUTF9TWVNDQUxMIGlzIG5vdCBz
ZXQKQ09ORklHX0tBTExTWU1TPXkKQ09ORklHX0tBTExTWU1TX0FMTD15CkNPTkZJR19LQUxMU1lN
U19FWFRSQV9QQVNTPXkKQ09ORklHX0hPVFBMVUc9eQpDT05GSUdfUFJJTlRLPXkKQ09ORklHX0JV
Rz15CkNPTkZJR19FTEZfQ09SRT15CkNPTkZJR19CQVNFX0ZVTEw9eQpDT05GSUdfRlVURVg9eQpD
T05GSUdfRVBPTEw9eQpDT05GSUdfU0lHTkFMRkQ9eQpDT05GSUdfVElNRVJGRD15CkNPTkZJR19F
VkVOVEZEPXkKQ09ORklHX1NITUVNPXkKQ09ORklHX0FJTz15CkNPTkZJR19IQVZFX1BFUkZfRVZF
TlRTPXkKQ09ORklHX1BFUkZfVVNFX1ZNQUxMT0M9eQoKIwojIEtlcm5lbCBQZXJmb3JtYW5jZSBF
dmVudHMgQW5kIENvdW50ZXJzCiMKIyBDT05GSUdfUEVSRl9FVkVOVFMgaXMgbm90IHNldAojIENP
TkZJR19QRVJGX0NPVU5URVJTIGlzIG5vdCBzZXQKQ09ORklHX1ZNX0VWRU5UX0NPVU5URVJTPXkK
Q09ORklHX0NPTVBBVF9CUks9eQpDT05GSUdfU0xBQj15CiMgQ09ORklHX1NMVUIgaXMgbm90IHNl
dAojIENPTkZJR19TTE9CIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPRklMSU5HIGlzIG5vdCBzZXQK
Q09ORklHX0hBVkVfT1BST0ZJTEU9eQpDT05GSUdfS1BST0JFUz15CkNPTkZJR19LUkVUUFJPQkVT
PXkKQ09ORklHX0hBVkVfS1BST0JFUz15CkNPTkZJR19IQVZFX0tSRVRQUk9CRVM9eQpDT05GSUdf
SEFWRV9DTEs9eQoKIwojIEdDT1YtYmFzZWQga2VybmVsIHByb2ZpbGluZwojCiMgQ09ORklHX0dD
T1ZfS0VSTkVMIGlzIG5vdCBzZXQKIyBDT05GSUdfU0xPV19XT1JLIGlzIG5vdCBzZXQKQ09ORklH
X0hBVkVfR0VORVJJQ19ETUFfQ09IRVJFTlQ9eQpDT05GSUdfU0xBQklORk89eQpDT05GSUdfUlRf
TVVURVhFUz15CkNPTkZJR19CQVNFX1NNQUxMPTAKQ09ORklHX01PRFVMRVM9eQpDT05GSUdfTU9E
VUxFX0ZPUkNFX0xPQUQ9eQpDT05GSUdfTU9EVUxFX1VOTE9BRD15CkNPTkZJR19NT0RVTEVfRk9S
Q0VfVU5MT0FEPXkKQ09ORklHX01PRFZFUlNJT05TPXkKQ09ORklHX01PRFVMRV9TUkNWRVJTSU9O
X0FMTD15CkNPTkZJR19CTE9DSz15CkNPTkZJR19MQkRBRj15CiMgQ09ORklHX0JMS19ERVZfQlNH
IGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9JTlRFR1JJVFkgaXMgbm90IHNldAoKIwojIElP
IFNjaGVkdWxlcnMKIwpDT05GSUdfSU9TQ0hFRF9OT09QPXkKIyBDT05GSUdfSU9TQ0hFRF9ERUFE
TElORSBpcyBub3Qgc2V0CkNPTkZJR19JT1NDSEVEX0NGUT15CiMgQ09ORklHX0RFRkFVTFRfREVB
RExJTkUgaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9DRlE9eQojIENPTkZJR19ERUZBVUxUX05P
T1AgaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9JT1NDSEVEPSJjZnEiCiMgQ09ORklHX0lOTElO
RV9TUElOX1RSWUxPQ0sgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfU1BJTl9UUllMT0NLX0JI
IGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklH
X0lOTElORV9TUElOX0xPQ0tfQkggaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfU1BJTl9MT0NL
X0lSUSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElOX0xPQ0tfSVJRU0FWRSBpcyBub3Qg
c2V0CiMgQ09ORklHX0lOTElORV9TUElOX1VOTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElO
RV9TUElOX1VOTE9DS19CSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElOX1VOTE9DS19J
UlEgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfU1BJTl9VTkxPQ0tfSVJRUkVTVE9SRSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lOTElORV9SRUFEX1RSWUxPQ0sgaXMgbm90IHNldAojIENPTkZJR19J
TkxJTkVfUkVBRF9MT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURfTE9DS19CSCBp
cyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9SRUFEX0xPQ0tfSVJRIGlzIG5vdCBzZXQKIyBDT05G
SUdfSU5MSU5FX1JFQURfTE9DS19JUlFTQVZFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JF
QURfVU5MT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURfVU5MT0NLX0JIIGlzIG5v
dCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURfVU5MT0NLX0lSUSBpcyBub3Qgc2V0CiMgQ09ORklH
X0lOTElORV9SRUFEX1VOTE9DS19JUlFSRVNUT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5F
X1dSSVRFX1RSWUxPQ0sgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfTE9DSyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklURV9MT0NLX0JIIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5MSU5FX1dSSVRFX0xPQ0tfSVJRIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1dSSVRFX0xP
Q0tfSVJRU0FWRSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklURV9VTkxPQ0sgaXMgbm90
IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVfVU5MT0NLX0JIIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5MSU5FX1dSSVRFX1VOTE9DS19JUlEgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfV1JJVEVf
VU5MT0NLX0lSUVJFU1RPUkUgaXMgbm90IHNldAojIENPTkZJR19NVVRFWF9TUElOX09OX09XTkVS
IGlzIG5vdCBzZXQKQ09ORklHX0ZSRUVaRVI9eQoKIwojIFN5c3RlbSBUeXBlCiMKQ09ORklHX01N
VT15CiMgQ09ORklHX0FSQ0hfQUFFQzIwMDAgaXMgbm90IHNldAojIENPTkZJR19BUkNIX0lOVEVH
UkFUT1IgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1JFQUxWSUVXIGlzIG5vdCBzZXQKIyBDT05G
SUdfQVJDSF9WRVJTQVRJTEUgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1ZFWFBSRVNTIGlzIG5v
dCBzZXQKIyBDT05GSUdfQVJDSF9BVDkxIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9CQ01SSU5H
IGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9DTFBTNzExWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FS
Q0hfQ05TM1hYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfR0VNSU5JIGlzIG5vdCBzZXQKIyBD
T05GSUdfQVJDSF9FQlNBMTEwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9FUDkzWFggaXMgbm90
IHNldAojIENPTkZJR19BUkNIX0ZPT1RCUklER0UgaXMgbm90IHNldAojIENPTkZJR19BUkNIX01Y
QyBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfU1RNUDNYWFggaXMgbm90IHNldAojIENPTkZJR19B
UkNIX05FVFggaXMgbm90IHNldAojIENPTkZJR19BUkNIX0g3MjBYIGlzIG5vdCBzZXQKIyBDT05G
SUdfQVJDSF9JT1AxM1hYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9JT1AzMlggaXMgbm90IHNl
dAojIENPTkZJR19BUkNIX0lPUDMzWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfSVhQMjNYWCBp
cyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfSVhQMjAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hf
SVhQNFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9MNzIwMCBpcyBub3Qgc2V0CiMgQ09ORklH
X0FSQ0hfRE9WRSBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfS0lSS1dPT0QgaXMgbm90IHNldAoj
IENPTkZJR19BUkNIX0xPS0kgaXMgbm90IHNldAojIENPTkZJR19BUkNIX01WNzhYWDAgaXMgbm90
IHNldAojIENPTkZJR19BUkNIX09SSU9ONVggaXMgbm90IHNldAojIENPTkZJR19BUkNIX01NUCBp
cyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfS1M4Njk1IGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9O
UzlYWFggaXMgbm90IHNldAojIENPTkZJR19BUkNIX1c5MFg5MDAgaXMgbm90IHNldAojIENPTkZJ
R19BUkNIX05VQzkzWCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUE5YNDAwOCBpcyBub3Qgc2V0
CiMgQ09ORklHX0FSQ0hfUFhBIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9NU00gaXMgbm90IHNl
dAojIENPTkZJR19BUkNIX1NITU9CSUxFIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9SUEMgaXMg
bm90IHNldAojIENPTkZJR19BUkNIX1NBMTEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUzND
MjQxMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUzNDNjRYWCBpcyBub3Qgc2V0CiMgQ09ORklH
X0FSQ0hfUzVQNjQ0MCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUzVQNjQ0MiBpcyBub3Qgc2V0
CiMgQ09ORklHX0FSQ0hfUzVQQzEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfUzVQVjIxMCBp
cyBub3Qgc2V0CiMgQ09ORklHX0FSQ0hfU0hBUksgaXMgbm90IHNldAojIENPTkZJR19BUkNIX0xI
N0E0MFggaXMgbm90IHNldAojIENPTkZJR19BUkNIX1UzMDAgaXMgbm90IHNldAojIENPTkZJR19B
UkNIX1U4NTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDSF9OT01BRElLIGlzIG5vdCBzZXQKIyBD
T05GSUdfQVJDSF9EQVZJTkNJIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfT01BUD15CiMgQ09ORklH
X1BMQVRfU1BFQVIgaXMgbm90IHNldAoKIwojIFRJIE9NQVAgSW1wbGVtZW50YXRpb25zCiMKQ09O
RklHX0FSQ0hfT01BUF9PVEc9eQojIENPTkZJR19BUkNIX09NQVAxIGlzIG5vdCBzZXQKQ09ORklH
X0FSQ0hfT01BUDJQTFVTPXkKIyBDT05GSUdfQVJDSF9PTUFQMiBpcyBub3Qgc2V0CkNPTkZJR19B
UkNIX09NQVAzPXkKIyBDT05GSUdfQVJDSF9PTUFQNCBpcyBub3Qgc2V0CgojCiMgT01BUCBGZWF0
dXJlIFNlbGVjdGlvbnMKIwpDT05GSUdfT01BUF9SRVNFVF9DTE9DS1M9eQpDT05GSUdfT01BUF9N
VVg9eQpDT05GSUdfT01BUF9NVVhfREVCVUc9eQpDT05GSUdfT01BUF9NVVhfV0FSTklOR1M9eQpD
T05GSUdfT01BUF9NQ0JTUD15CiMgQ09ORklHX09NQVBfTUJPWF9GV0sgaXMgbm90IHNldApDT05G
SUdfT01BUF9JT01NVT15CiMgQ09ORklHX09NQVBfSU9NTVVfREVCVUcgaXMgbm90IHNldAojIENP
TkZJR19PTUFQX01QVV9USU1FUiBpcyBub3Qgc2V0CkNPTkZJR19PTUFQXzMyS19USU1FUj15CiMg
Q09ORklHX09NQVAzX0wyX0FVWF9TRUNVUkVfU0FWRV9SRVNUT1JFIGlzIG5vdCBzZXQKQ09ORklH
X09NQVBfMzJLX1RJTUVSX0haPTEyOApDT05GSUdfT01BUF9ETV9USU1FUj15CiMgQ09ORklHX09N
QVBfUE1fTk9ORSBpcyBub3Qgc2V0CkNPTkZJR19PTUFQX1BNX05PT1A9eQpDT05GSUdfQVJDSF9P
TUFQMzQzMD15CkNPTkZJR19PTUFQX1BBQ0tBR0VfQ0JCPXkKCiMKIyBPTUFQIEJvYXJkIFR5cGUK
IwojIENPTkZJR19NQUNIX09NQVAzX0JFQUdMRSBpcyBub3Qgc2V0CiMgQ09ORklHX01BQ0hfREVW
S0lUODAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX01BQ0hfT01BUF9MRFAgaXMgbm90IHNldAojIENP
TkZJR19NQUNIX09WRVJPIGlzIG5vdCBzZXQKIyBDT05GSUdfTUFDSF9PTUFQM0VWTSBpcyBub3Qg
c2V0CiMgQ09ORklHX01BQ0hfT01BUDM1MTdFVk0gaXMgbm90IHNldAojIENPTkZJR19NQUNIX09N
QVAzX1BBTkRPUkEgaXMgbm90IHNldAojIENPTkZJR19NQUNIX09NQVAzX1RPVUNIQk9PSyBpcyBu
b3Qgc2V0CiMgQ09ORklHX01BQ0hfT01BUF8zNDMwU0RQIGlzIG5vdCBzZXQKQ09ORklHX01BQ0hf
Tk9LSUFfUlg1MT15CkNPTkZJR19WSURFT19NQUNIX1JYNTE9eQojIENPTkZJR19NQUNIX09NQVBf
Wk9PTTIgaXMgbm90IHNldAojIENPTkZJR19NQUNIX09NQVBfWk9PTTMgaXMgbm90IHNldAojIENP
TkZJR19NQUNIX0NNX1QzNSBpcyBub3Qgc2V0CiMgQ09ORklHX01BQ0hfSUdFUDAwMjAgaXMgbm90
IHNldAojIENPTkZJR19NQUNIX1NCQzM1MzAgaXMgbm90IHNldAojIENPTkZJR19NQUNIX09NQVBf
MzYzMFNEUCBpcyBub3Qgc2V0CiMgQ09ORklHX09NQVAzX0VNVSBpcyBub3Qgc2V0CiMgQ09ORklH
X09NQVAzX1NEUkNfQUNfVElNSU5HIGlzIG5vdCBzZXQKCiMKIyBQcm9jZXNzb3IgVHlwZQojCkNP
TkZJR19DUFVfMzJ2Nks9eQpDT05GSUdfQ1BVX1Y3PXkKQ09ORklHX0NQVV8zMnY3PXkKQ09ORklH
X0NQVV9BQlJUX0VWNz15CkNPTkZJR19DUFVfUEFCUlRfVjc9eQpDT05GSUdfQ1BVX0NBQ0hFX1Y3
PXkKQ09ORklHX0NQVV9DQUNIRV9WSVBUPXkKQ09ORklHX0NQVV9DT1BZX1Y2PXkKQ09ORklHX0NQ
VV9UTEJfVjc9eQpDT05GSUdfQ1BVX0hBU19BU0lEPXkKQ09ORklHX0NQVV9DUDE1PXkKQ09ORklH
X0NQVV9DUDE1X01NVT15CgojCiMgUHJvY2Vzc29yIEZlYXR1cmVzCiMKQ09ORklHX0FSTV9USFVN
Qj15CiMgQ09ORklHX0FSTV9USFVNQkVFIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1BVX0lDQUNIRV9E
SVNBQkxFIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1BVX0RDQUNIRV9ESVNBQkxFIGlzIG5vdCBzZXQK
IyBDT05GSUdfQ1BVX0JQUkVESUNUX0RJU0FCTEUgaXMgbm90IHNldApDT05GSUdfSEFTX1RMU19S
RUc9eQpDT05GSUdfQVJNX0wxX0NBQ0hFX1NISUZUPTYKQ09ORklHX0FSTV9ETUFfTUVNX0JVRkZF
UkFCTEU9eQpDT05GSUdfQ1BVX0hBU19QTVU9eQojIENPTkZJR19BUk1fRVJSQVRBXzQzMDk3MyBp
cyBub3Qgc2V0CiMgQ09ORklHX0FSTV9FUlJBVEFfNDU4NjkzIGlzIG5vdCBzZXQKIyBDT05GSUdf
QVJNX0VSUkFUQV80NjAwNzUgaXMgbm90IHNldApDT05GSUdfQ09NTU9OX0NMS0RFVj15CgojCiMg
QnVzIHN1cHBvcnQKIwojIENPTkZJR19QQ0lfU1lTQ0FMTCBpcyBub3Qgc2V0CiMgQ09ORklHX0FS
Q0hfU1VQUE9SVFNfTVNJIGlzIG5vdCBzZXQKIyBDT05GSUdfUENDQVJEIGlzIG5vdCBzZXQKCiMK
IyBLZXJuZWwgRmVhdHVyZXMKIwpDT05GSUdfVElDS19PTkVTSE9UPXkKQ09ORklHX05PX0haPXkK
Q09ORklHX0hJR0hfUkVTX1RJTUVSUz15CkNPTkZJR19HRU5FUklDX0NMT0NLRVZFTlRTX0JVSUxE
PXkKQ09ORklHX1ZNU1BMSVRfM0c9eQojIENPTkZJR19WTVNQTElUXzJHIGlzIG5vdCBzZXQKIyBD
T05GSUdfVk1TUExJVF8xRyBpcyBub3Qgc2V0CkNPTkZJR19QQUdFX09GRlNFVD0weEMwMDAwMDAw
CkNPTkZJR19QUkVFTVBUX05PTkU9eQojIENPTkZJR19QUkVFTVBUX1ZPTFVOVEFSWSBpcyBub3Qg
c2V0CiMgQ09ORklHX1BSRUVNUFQgaXMgbm90IHNldApDT05GSUdfSFo9MTI4CiMgQ09ORklHX1RI
VU1CMl9LRVJORUwgaXMgbm90IHNldApDT05GSUdfQUVBQkk9eQojIENPTkZJR19PQUJJX0NPTVBB
VCBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX0hBU19IT0xFU19NRU1PUllNT0RFTD15CiMgQ09ORklH
X0FSQ0hfU1BBUlNFTUVNX0RFRkFVTFQgaXMgbm90IHNldAojIENPTkZJR19BUkNIX1NFTEVDVF9N
RU1PUllfTU9ERUwgaXMgbm90IHNldAojIENPTkZJR19ISUdITUVNIGlzIG5vdCBzZXQKQ09ORklH
X1NFTEVDVF9NRU1PUllfTU9ERUw9eQpDT05GSUdfRkxBVE1FTV9NQU5VQUw9eQojIENPTkZJR19E
SVNDT05USUdNRU1fTUFOVUFMIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BBUlNFTUVNX01BTlVBTCBp
cyBub3Qgc2V0CkNPTkZJR19GTEFUTUVNPXkKQ09ORklHX0ZMQVRfTk9ERV9NRU1fTUFQPXkKQ09O
RklHX1BBR0VGTEFHU19FWFRFTkRFRD15CkNPTkZJR19TUExJVF9QVExPQ0tfQ1BVUz05OTk5OTkK
IyBDT05GSUdfUEhZU19BRERSX1RfNjRCSVQgaXMgbm90IHNldApDT05GSUdfWk9ORV9ETUFfRkxB
Rz0wCkNPTkZJR19WSVJUX1RPX0JVUz15CiMgQ09ORklHX0tTTSBpcyBub3Qgc2V0CkNPTkZJR19E
RUZBVUxUX01NQVBfTUlOX0FERFI9NDA5NgojIENPTkZJR19MRURTIGlzIG5vdCBzZXQKQ09ORklH
X0FMSUdOTUVOVF9UUkFQPXkKIyBDT05GSUdfVUFDQ0VTU19XSVRIX01FTUNQWSBpcyBub3Qgc2V0
CgojCiMgQm9vdCBvcHRpb25zCiMKQ09ORklHX1pCT09UX1JPTV9URVhUPTB4MApDT05GSUdfWkJP
T1RfUk9NX0JTUz0weDAKQ09ORklHX0NNRExJTkU9ImluaXQ9L3NiaW4vcHJlaW5pdCB1YmkubXRk
PXJvb3RmcyByb290PXViaTA6cm9vdGZzIHJvb3Rmc3R5cGU9dWJpZnMgcm9vdGZsYWdzPWJ1bGtf
cmVhZCxub19jaGtfZGF0YV9jcmMgcncgY29uc29sZT10dHlNVEQsbG9nIGNvbnNvbGU9dHR5MCBj
b25zb2xlPXR0eVMyLDExNTIwMG44IgojIENPTkZJR19DTURMSU5FX0ZPUkNFIGlzIG5vdCBzZXQK
IyBDT05GSUdfWElQX0tFUk5FTCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWEVDIGlzIG5vdCBzZXQK
CiMKIyBDUFUgUG93ZXIgTWFuYWdlbWVudAojCiMgQ09ORklHX0NQVV9GUkVRIGlzIG5vdCBzZXQK
IyBDT05GSUdfQ1BVX0lETEUgaXMgbm90IHNldAoKIwojIEZsb2F0aW5nIHBvaW50IGVtdWxhdGlv
bgojCgojCiMgQXQgbGVhc3Qgb25lIGVtdWxhdGlvbiBtdXN0IGJlIHNlbGVjdGVkCiMKQ09ORklH
X1ZGUD15CkNPTkZJR19WRlB2Mz15CkNPTkZJR19ORU9OPXkKCiMKIyBVc2Vyc3BhY2UgYmluYXJ5
IGZvcm1hdHMKIwpDT05GSUdfQklORk1UX0VMRj15CiMgQ09ORklHX0NPUkVfRFVNUF9ERUZBVUxU
X0VMRl9IRUFERVJTIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQU9VVD15CiMgQ09ORklHX0JJTkZN
VF9BT1VUIGlzIG5vdCBzZXQKQ09ORklHX0JJTkZNVF9NSVNDPXkKCiMKIyBQb3dlciBtYW5hZ2Vt
ZW50IG9wdGlvbnMKIwpDT05GSUdfUE09eQpDT05GSUdfUE1fREVCVUc9eQojIENPTkZJR19QTV9B
RFZBTkNFRF9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1BNX1ZFUkJPU0UgaXMgbm90IHNldApD
T05GSUdfQ0FOX1BNX1RSQUNFPXkKQ09ORklHX1BNX1NMRUVQPXkKQ09ORklHX1NVU1BFTkQ9eQpD
T05GSUdfU1VTUEVORF9GUkVFWkVSPXkKIyBDT05GSUdfQVBNX0VNVUxBVElPTiBpcyBub3Qgc2V0
CkNPTkZJR19QTV9SVU5USU1FPXkKQ09ORklHX1BNX09QUz15CkNPTkZJR19BUkNIX1NVU1BFTkRf
UE9TU0lCTEU9eQpDT05GSUdfTkVUPXkKCiMKIyBOZXR3b3JraW5nIG9wdGlvbnMKIwpDT05GSUdf
UEFDS0VUPXkKQ09ORklHX1VOSVg9eQpDT05GSUdfWEZSTT15CiMgQ09ORklHX1hGUk1fVVNFUiBp
cyBub3Qgc2V0CiMgQ09ORklHX1hGUk1fU1VCX1BPTElDWSBpcyBub3Qgc2V0CiMgQ09ORklHX1hG
Uk1fTUlHUkFURSBpcyBub3Qgc2V0CiMgQ09ORklHX1hGUk1fU1RBVElTVElDUyBpcyBub3Qgc2V0
CkNPTkZJR19ORVRfS0VZPXkKIyBDT05GSUdfTkVUX0tFWV9NSUdSQVRFIGlzIG5vdCBzZXQKQ09O
RklHX0lORVQ9eQojIENPTkZJR19JUF9NVUxUSUNBU1QgaXMgbm90IHNldAojIENPTkZJR19JUF9B
RFZBTkNFRF9ST1VURVIgaXMgbm90IHNldApDT05GSUdfSVBfRklCX0hBU0g9eQpDT05GSUdfSVBf
UE5QPXkKQ09ORklHX0lQX1BOUF9ESENQPXkKQ09ORklHX0lQX1BOUF9CT09UUD15CkNPTkZJR19J
UF9QTlBfUkFSUD15CiMgQ09ORklHX05FVF9JUElQIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0lQ
R1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJQRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NZTl9DT09L
SUVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVF9BSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRf
RVNQIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVF9JUENPTVAgaXMgbm90IHNldAojIENPTkZJR19J
TkVUX1hGUk1fVFVOTkVMIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVF9UVU5ORUwgaXMgbm90IHNl
dApDT05GSUdfSU5FVF9YRlJNX01PREVfVFJBTlNQT1JUPXkKQ09ORklHX0lORVRfWEZSTV9NT0RF
X1RVTk5FTD15CkNPTkZJR19JTkVUX1hGUk1fTU9ERV9CRUVUPXkKIyBDT05GSUdfSU5FVF9MUk8g
aXMgbm90IHNldApDT05GSUdfSU5FVF9ESUFHPXkKQ09ORklHX0lORVRfVENQX0RJQUc9eQojIENP
TkZJR19UQ1BfQ09OR19BRFZBTkNFRCBpcyBub3Qgc2V0CkNPTkZJR19UQ1BfQ09OR19DVUJJQz15
CkNPTkZJR19ERUZBVUxUX1RDUF9DT05HPSJjdWJpYyIKIyBDT05GSUdfVENQX01ENVNJRyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lQVjYgaXMgbm90IHNldAojIENPTkZJR19ORVRMQUJFTCBpcyBub3Qg
c2V0CiMgQ09ORklHX05FVFdPUktfU0VDTUFSSyBpcyBub3Qgc2V0CkNPTkZJR19ORVRGSUxURVI9
eQojIENPTkZJR19ORVRGSUxURVJfREVCVUcgaXMgbm90IHNldApDT05GSUdfTkVURklMVEVSX0FE
VkFOQ0VEPXkKCiMKIyBDb3JlIE5ldGZpbHRlciBDb25maWd1cmF0aW9uCiMKIyBDT05GSUdfTkVU
RklMVEVSX05FVExJTktfUVVFVUUgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJfTkVUTElO
S19MT0cgaXMgbm90IHNldAojIENPTkZJR19ORl9DT05OVFJBQ0sgaXMgbm90IHNldApDT05GSUdf
TkVURklMVEVSX1hUQUJMRVM9bQoKIwojIFh0YWJsZXMgY29tYmluZWQgbW9kdWxlcwojCiMgQ09O
RklHX05FVEZJTFRFUl9YVF9NQVJLIGlzIG5vdCBzZXQKCiMKIyBYdGFibGVzIHRhcmdldHMKIwoj
IENPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX0NMQVNTSUZZIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkVURklMVEVSX1hUX1RBUkdFVF9NQVJLIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVURklMVEVSX1hU
X1RBUkdFVF9ORkxPRyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfTkZR
VUVVRSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfUkFURUVTVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfVEVFIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkVURklMVEVSX1hUX1RBUkdFVF9UQ1BNU1MgaXMgbm90IHNldAoKIwojIFh0YWJsZXMgbWF0
Y2hlcwojCiMgQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9DT01NRU5UIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVURklMVEVSX1hUX01BVENIX0RDQ1AgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxU
RVJfWFRfTUFUQ0hfRFNDUCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9F
U1AgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfSEFTSExJTUlUIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0hMIGlzIG5vdCBzZXQKIyBDT05GSUdf
TkVURklMVEVSX1hUX01BVENIX0lQUkFOR0UgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJf
WFRfTUFUQ0hfTEVOR1RIIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0xJ
TUlUIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX01BQyBpcyBub3Qgc2V0
CiMgQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9NQVJLIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVU
RklMVEVSX1hUX01BVENIX01VTFRJUE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9Y
VF9NQVRDSF9PV05FUiBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9QT0xJ
Q1kgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfUEtUVFlQRSBpcyBub3Qg
c2V0CiMgQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9RVU9UQSBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVEZJTFRFUl9YVF9NQVRDSF9SQVRFRVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVURklMVEVS
X1hUX01BVENIX1JFQUxNIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1JF
Q0VOVCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9TQ1RQIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1NUQVRJU1RJQyBpcyBub3Qgc2V0CiMgQ09O
RklHX05FVEZJTFRFUl9YVF9NQVRDSF9TVFJJTkcgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxU
RVJfWFRfTUFUQ0hfVENQTVNTIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVURklMVEVSX1hUX01BVENI
X1RJTUUgaXMgbm90IHNldAojIENPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfVTMyIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSVBfVlMgaXMgbm90IHNldAoKIwojIElQOiBOZXRmaWx0ZXIgQ29uZmlndXJh
dGlvbgojCiMgQ09ORklHX05GX0RFRlJBR19JUFY0IGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfTkZf
UVVFVUUgaXMgbm90IHNldApDT05GSUdfSVBfTkZfSVBUQUJMRVM9bQojIENPTkZJR19JUF9ORl9N
QVRDSF9BRERSVFlQRSBpcyBub3Qgc2V0CiMgQ09ORklHX0lQX05GX01BVENIX0FIIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSVBfTkZfTUFUQ0hfRUNOIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfTkZfTUFU
Q0hfVFRMIGlzIG5vdCBzZXQKQ09ORklHX0lQX05GX0ZJTFRFUj1tCiMgQ09ORklHX0lQX05GX1RB
UkdFVF9SRUpFQ1QgaXMgbm90IHNldAojIENPTkZJR19JUF9ORl9UQVJHRVRfTE9HIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSVBfTkZfVEFSR0VUX1VMT0cgaXMgbm90IHNldAojIENPTkZJR19JUF9ORl9N
QU5HTEUgaXMgbm90IHNldAojIENPTkZJR19JUF9ORl9UQVJHRVRfVFRMIGlzIG5vdCBzZXQKIyBD
T05GSUdfSVBfTkZfUkFXIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfTkZfU0VDVVJJVFkgaXMgbm90
IHNldAojIENPTkZJR19JUF9ORl9BUlBUQUJMRVMgaXMgbm90IHNldAojIENPTkZJR19JUF9EQ0NQ
IGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfU0NUUCBpcyBub3Qgc2V0CiMgQ09ORklHX1JEUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RJUEMgaXMgbm90IHNldAojIENPTkZJR19BVE0gaXMgbm90IHNldAoj
IENPTkZJR19MMlRQIGlzIG5vdCBzZXQKIyBDT05GSUdfQlJJREdFIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkVUX0RTQSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZMQU5fODAyMVEgaXMgbm90IHNldAojIENP
TkZJR19ERUNORVQgaXMgbm90IHNldAojIENPTkZJR19MTEMyIGlzIG5vdCBzZXQKIyBDT05GSUdf
SVBYIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRBTEsgaXMgbm90IHNldAojIENPTkZJR19YMjUgaXMg
bm90IHNldAojIENPTkZJR19MQVBCIGlzIG5vdCBzZXQKIyBDT05GSUdfRUNPTkVUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfV0FOX1JPVVRFUiBpcyBub3Qgc2V0CkNPTkZJR19QSE9ORVQ9eQojIENPTkZJ
R19JRUVFODAyMTU0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1NDSEVEIGlzIG5vdCBzZXQKIyBD
T05GSUdfRENCIGlzIG5vdCBzZXQKCiMKIyBOZXR3b3JrIHRlc3RpbmcKIwojIENPTkZJR19ORVRf
UEtUR0VOIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1RDUFBST0JFIGlzIG5vdCBzZXQKIyBDT05G
SUdfSEFNUkFESU8gaXMgbm90IHNldAojIENPTkZJR19DQU4gaXMgbm90IHNldAojIENPTkZJR19J
UkRBIGlzIG5vdCBzZXQKQ09ORklHX0JUPW0KQ09ORklHX0JUX0wyQ0FQPW0KIyBDT05GSUdfQlRf
TDJDQVBfRVhUX0ZFQVRVUkVTIGlzIG5vdCBzZXQKQ09ORklHX0JUX1NDTz1tCkNPTkZJR19CVF9S
RkNPTU09bQpDT05GSUdfQlRfUkZDT01NX1RUWT15CkNPTkZJR19CVF9CTkVQPW0KQ09ORklHX0JU
X0JORVBfTUNfRklMVEVSPXkKQ09ORklHX0JUX0JORVBfUFJPVE9fRklMVEVSPXkKQ09ORklHX0JU
X0hJRFA9bQoKIwojIEJsdWV0b290aCBkZXZpY2UgZHJpdmVycwojCiMgQ09ORklHX0JUX0hDSUJU
VVNCIGlzIG5vdCBzZXQKIyBDT05GSUdfQlRfSENJQlRTRElPIGlzIG5vdCBzZXQKIyBDT05GSUdf
QlRfSENJVUFSVCBpcyBub3Qgc2V0CiMgQ09ORklHX0JUX0hDSUJDTTIwM1ggaXMgbm90IHNldAoj
IENPTkZJR19CVF9IQ0lCUEExMFggaXMgbm90IHNldAojIENPTkZJR19CVF9IQ0lCRlVTQiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JUX0hDSVZIQ0kgaXMgbm90IHNldAojIENPTkZJR19CVF9NUlZMIGlz
IG5vdCBzZXQKIyBDT05GSUdfQUZfUlhSUEMgaXMgbm90IHNldApDT05GSUdfV0lSRUxFU1M9eQpD
T05GSUdfV0VYVF9DT1JFPXkKQ09ORklHX1dFWFRfUFJPQz15CkNPTkZJR19DRkc4MDIxMT15CiMg
Q09ORklHX05MODAyMTFfVEVTVE1PREUgaXMgbm90IHNldAojIENPTkZJR19DRkc4MDIxMV9ERVZF
TE9QRVJfV0FSTklOR1MgaXMgbm90IHNldAojIENPTkZJR19DRkc4MDIxMV9SRUdfREVCVUcgaXMg
bm90IHNldApDT05GSUdfQ0ZHODAyMTFfREVGQVVMVF9QUz15CiMgQ09ORklHX0NGRzgwMjExX0RF
QlVHRlMgaXMgbm90IHNldAojIENPTkZJR19DRkc4MDIxMV9JTlRFUk5BTF9SRUdEQiBpcyBub3Qg
c2V0CkNPTkZJR19DRkc4MDIxMV9XRVhUPXkKQ09ORklHX1dJUkVMRVNTX0VYVF9TWVNGUz15CiMg
Q09ORklHX0xJQjgwMjExIGlzIG5vdCBzZXQKQ09ORklHX01BQzgwMjExPW0KQ09ORklHX01BQzgw
MjExX0hBU19SQz15CkNPTkZJR19NQUM4MDIxMV9SQ19QSUQ9eQojIENPTkZJR19NQUM4MDIxMV9S
Q19NSU5TVFJFTCBpcyBub3Qgc2V0CkNPTkZJR19NQUM4MDIxMV9SQ19ERUZBVUxUX1BJRD15CiMg
Q09ORklHX01BQzgwMjExX1JDX0RFRkFVTFRfTUlOU1RSRUwgaXMgbm90IHNldApDT05GSUdfTUFD
ODAyMTFfUkNfREVGQVVMVD0icGlkIgojIENPTkZJR19NQUM4MDIxMV9NRVNIIGlzIG5vdCBzZXQK
IyBDT05GSUdfTUFDODAyMTFfTEVEUyBpcyBub3Qgc2V0CiMgQ09ORklHX01BQzgwMjExX0RFQlVH
RlMgaXMgbm90IHNldAojIENPTkZJR19NQUM4MDIxMV9ERUJVR19NRU5VIGlzIG5vdCBzZXQKIyBD
T05GSUdfV0lNQVggaXMgbm90IHNldAojIENPTkZJR19SRktJTEwgaXMgbm90IHNldAojIENPTkZJ
R19ORVRfOVAgaXMgbm90IHNldAojIENPTkZJR19DQUlGIGlzIG5vdCBzZXQKCiMKIyBEZXZpY2Ug
RHJpdmVycwojCgojCiMgR2VuZXJpYyBEcml2ZXIgT3B0aW9ucwojCkNPTkZJR19VRVZFTlRfSEVM
UEVSX1BBVEg9Ii9zYmluL2hvdHBsdWciCiMgQ09ORklHX0RFVlRNUEZTIGlzIG5vdCBzZXQKQ09O
RklHX1NUQU5EQUxPTkU9eQpDT05GSUdfUFJFVkVOVF9GSVJNV0FSRV9CVUlMRD15CkNPTkZJR19G
V19MT0FERVI9eQpDT05GSUdfRklSTVdBUkVfSU5fS0VSTkVMPXkKQ09ORklHX0VYVFJBX0ZJUk1X
QVJFPSIiCiMgQ09ORklHX0RFQlVHX0RSSVZFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0RF
VlJFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NZU19IWVBFUlZJU09SIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ09OTkVDVE9SIGlzIG5vdCBzZXQKQ09ORklHX01URD15CiMgQ09ORklHX01URF9ERUJVRyBp
cyBub3Qgc2V0CiMgQ09ORklHX01URF9URVNUUyBpcyBub3Qgc2V0CkNPTkZJR19NVERfQ09OQ0FU
PXkKQ09ORklHX01URF9QQVJUSVRJT05TPXkKIyBDT05GSUdfTVREX1JFREJPT1RfUEFSVFMgaXMg
bm90IHNldApDT05GSUdfTVREX0NNRExJTkVfUEFSVFM9eQojIENPTkZJR19NVERfQUZTX1BBUlRT
IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX0FSN19QQVJUUyBpcyBub3Qgc2V0CgojCiMgVXNlciBN
b2R1bGVzIEFuZCBUcmFuc2xhdGlvbiBMYXllcnMKIwpDT05GSUdfTVREX0NIQVI9eQpDT05GSUdf
TVREX0JMS0RFVlM9eQpDT05GSUdfTVREX0JMT0NLPXkKIyBDT05GSUdfRlRMIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkZUTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORlRMIGlzIG5vdCBzZXQKIyBDT05G
SUdfUkZEX0ZUTCBpcyBub3Qgc2V0CiMgQ09ORklHX1NTRkRDIGlzIG5vdCBzZXQKIyBDT05GSUdf
U01fRlRMIGlzIG5vdCBzZXQKQ09ORklHX01URF9PT1BTPXkKCiMKIyBSQU0vUk9NL0ZsYXNoIGNo
aXAgZHJpdmVycwojCkNPTkZJR19NVERfQ0ZJPXkKIyBDT05GSUdfTVREX0pFREVDUFJPQkUgaXMg
bm90IHNldApDT05GSUdfTVREX0dFTl9QUk9CRT15CiMgQ09ORklHX01URF9DRklfQURWX09QVElP
TlMgaXMgbm90IHNldApDT05GSUdfTVREX01BUF9CQU5LX1dJRFRIXzE9eQpDT05GSUdfTVREX01B
UF9CQU5LX1dJRFRIXzI9eQpDT05GSUdfTVREX01BUF9CQU5LX1dJRFRIXzQ9eQojIENPTkZJR19N
VERfTUFQX0JBTktfV0lEVEhfOCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9NQVBfQkFOS19XSURU
SF8xNiBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9NQVBfQkFOS19XSURUSF8zMiBpcyBub3Qgc2V0
CkNPTkZJR19NVERfQ0ZJX0kxPXkKQ09ORklHX01URF9DRklfSTI9eQojIENPTkZJR19NVERfQ0ZJ
X0k0IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX0NGSV9JOCBpcyBub3Qgc2V0CkNPTkZJR19NVERf
Q0ZJX0lOVEVMRVhUPXkKIyBDT05GSUdfTVREX0NGSV9BTURTVEQgaXMgbm90IHNldAojIENPTkZJ
R19NVERfQ0ZJX1NUQUEgaXMgbm90IHNldApDT05GSUdfTVREX0NGSV9VVElMPXkKIyBDT05GSUdf
TVREX1JBTSBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9ST00gaXMgbm90IHNldAojIENPTkZJR19N
VERfQUJTRU5UIGlzIG5vdCBzZXQKCiMKIyBNYXBwaW5nIGRyaXZlcnMgZm9yIGNoaXAgYWNjZXNz
CiMKIyBDT05GSUdfTVREX0NPTVBMRVhfTUFQUElOR1MgaXMgbm90IHNldAojIENPTkZJR19NVERf
UEhZU01BUCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9BUk1fSU5URUdSQVRPUiBpcyBub3Qgc2V0
CiMgQ09ORklHX01URF9QTEFUUkFNIGlzIG5vdCBzZXQKCiMKIyBTZWxmLWNvbnRhaW5lZCBNVEQg
ZGV2aWNlIGRyaXZlcnMKIwojIENPTkZJR19NVERfREFUQUZMQVNIIGlzIG5vdCBzZXQKIyBDT05G
SUdfTVREX00yNVA4MCBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9TU1QyNUwgaXMgbm90IHNldAoj
IENPTkZJR19NVERfU0xSQU0gaXMgbm90IHNldAojIENPTkZJR19NVERfUEhSQU0gaXMgbm90IHNl
dAojIENPTkZJR19NVERfTVREUkFNIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX0JMT0NLMk1URCBp
cyBub3Qgc2V0CgojCiMgRGlzay1Pbi1DaGlwIERldmljZSBEcml2ZXJzCiMKIyBDT05GSUdfTVRE
X0RPQzIwMDAgaXMgbm90IHNldAojIENPTkZJR19NVERfRE9DMjAwMSBpcyBub3Qgc2V0CiMgQ09O
RklHX01URF9ET0MyMDAxUExVUyBpcyBub3Qgc2V0CiMgQ09ORklHX01URF9OQU5EIGlzIG5vdCBz
ZXQKQ09ORklHX01URF9PTkVOQU5EPXkKIyBDT05GSUdfTVREX09ORU5BTkRfVkVSSUZZX1dSSVRF
IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX09ORU5BTkRfR0VORVJJQyBpcyBub3Qgc2V0CkNPTkZJ
R19NVERfT05FTkFORF9PTUFQMj15CiMgQ09ORklHX01URF9PTkVOQU5EX09UUCBpcyBub3Qgc2V0
CiMgQ09ORklHX01URF9PTkVOQU5EXzJYX1BST0dSQU0gaXMgbm90IHNldAojIENPTkZJR19NVERf
T05FTkFORF9TSU0gaXMgbm90IHNldAoKIwojIExQRERSIGZsYXNoIG1lbW9yeSBkcml2ZXJzCiMK
IyBDT05GSUdfTVREX0xQRERSIGlzIG5vdCBzZXQKCiMKIyBVQkkgLSBVbnNvcnRlZCBibG9jayBp
bWFnZXMKIwpDT05GSUdfTVREX1VCST15CkNPTkZJR19NVERfVUJJX1dMX1RIUkVTSE9MRD00MDk2
CkNPTkZJR19NVERfVUJJX0JFQl9SRVNFUlZFPTEKIyBDT05GSUdfTVREX1VCSV9HTFVFQkkgaXMg
bm90IHNldAoKIwojIFVCSSBkZWJ1Z2dpbmcgb3B0aW9ucwojCiMgQ09ORklHX01URF9VQklfREVC
VUcgaXMgbm90IHNldAojIENPTkZJR19QQVJQT1JUIGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVY9
eQojIENPTkZJR19CTEtfREVWX0NPV19DT01NT04gaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9M
T09QPXkKIyBDT05GSUdfQkxLX0RFVl9DUllQVE9MT09QIGlzIG5vdCBzZXQKCiMKIyBEUkJEIGRp
c2FibGVkIGJlY2F1c2UgUFJPQ19GUywgSU5FVCBvciBDT05ORUNUT1Igbm90IHNlbGVjdGVkCiMK
IyBDT05GSUdfQkxLX0RFVl9OQkQgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1VCIGlzIG5v
dCBzZXQKQ09ORklHX0JMS19ERVZfUkFNPXkKQ09ORklHX0JMS19ERVZfUkFNX0NPVU5UPTE2CkNP
TkZJR19CTEtfREVWX1JBTV9TSVpFPTQwOTYKIyBDT05GSUdfQkxLX0RFVl9YSVAgaXMgbm90IHNl
dAojIENPTkZJR19DRFJPTV9QS1RDRFZEIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRBX09WRVJfRVRI
IGlzIG5vdCBzZXQKIyBDT05GSUdfTUdfRElTSyBpcyBub3Qgc2V0CkNPTkZJR19NSVNDX0RFVklD
RVM9eQojIENPTkZJR19BRDUyNVhfRFBPVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lDUzkzMlM0MDEg
aXMgbm90IHNldAojIENPTkZJR19FTkNMT1NVUkVfU0VSVklDRVMgaXMgbm90IHNldAojIENPTkZJ
R19JU0wyOTAwMyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVFNMMjU1MCBpcyBub3Qgc2V0
CiMgQ09ORklHX0RTMTY4MiBpcyBub3Qgc2V0CiMgQ09ORklHX1RJX0RBQzc1MTIgaXMgbm90IHNl
dAojIENPTkZJR19DMlBPUlQgaXMgbm90IHNldAoKIwojIEVFUFJPTSBzdXBwb3J0CiMKIyBDT05G
SUdfRUVQUk9NX0FUMjQgaXMgbm90IHNldAojIENPTkZJR19FRVBST01fQVQyNSBpcyBub3Qgc2V0
CiMgQ09ORklHX0VFUFJPTV9MRUdBQ1kgaXMgbm90IHNldAojIENPTkZJR19FRVBST01fTUFYNjg3
NSBpcyBub3Qgc2V0CiMgQ09ORklHX0VFUFJPTV85M0NYNiBpcyBub3Qgc2V0CiMgQ09ORklHX0lX
TUMzMjAwVE9QIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfSURFPXkKIyBDT05GSUdfSURFIGlzIG5v
dCBzZXQKCiMKIyBTQ1NJIGRldmljZSBzdXBwb3J0CiMKQ09ORklHX1NDU0lfTU9EPW0KIyBDT05G
SUdfUkFJRF9BVFRSUyBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJPW0KQ09ORklHX1NDU0lfRE1BPXkK
IyBDT05GSUdfU0NTSV9UR1QgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX05FVExJTksgaXMgbm90
IHNldApDT05GSUdfU0NTSV9QUk9DX0ZTPXkKCiMKIyBTQ1NJIHN1cHBvcnQgdHlwZSAoZGlzaywg
dGFwZSwgQ0QtUk9NKQojCkNPTkZJR19CTEtfREVWX1NEPW0KIyBDT05GSUdfQ0hSX0RFVl9TVCBp
cyBub3Qgc2V0CiMgQ09ORklHX0NIUl9ERVZfT1NTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19E
RVZfU1IgaXMgbm90IHNldAojIENPTkZJR19DSFJfREVWX1NHIGlzIG5vdCBzZXQKIyBDT05GSUdf
Q0hSX0RFVl9TQ0ggaXMgbm90IHNldApDT05GSUdfU0NTSV9NVUxUSV9MVU49eQojIENPTkZJR19T
Q1NJX0NPTlNUQU5UUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfTE9HR0lORyBpcyBub3Qgc2V0
CkNPTkZJR19TQ1NJX1NDQU5fQVNZTkM9eQpDT05GSUdfU0NTSV9XQUlUX1NDQU49bQoKIwojIFND
U0kgVHJhbnNwb3J0cwojCiMgQ09ORklHX1NDU0lfU1BJX0FUVFJTIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0NTSV9GQ19BVFRSUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfSVNDU0lfQVRUUlMgaXMg
bm90IHNldAojIENPTkZJR19TQ1NJX1NBU19MSUJTQVMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJ
X1NSUF9BVFRSUyBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJX0xPV0xFVkVMPXkKIyBDT05GSUdfSVND
U0lfVENQIGlzIG5vdCBzZXQKIyBDT05GSUdfTElCRkMgaXMgbm90IHNldAojIENPTkZJR19MSUJG
Q09FIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1ND
U0lfREggaXMgbm90IHNldAojIENPTkZJR19TQ1NJX09TRF9JTklUSUFUT1IgaXMgbm90IHNldAoj
IENPTkZJR19BVEEgaXMgbm90IHNldAojIENPTkZJR19NRCBpcyBub3Qgc2V0CkNPTkZJR19ORVRE
RVZJQ0VTPXkKIyBDT05GSUdfRFVNTVkgaXMgbm90IHNldAojIENPTkZJR19CT05ESU5HIGlzIG5v
dCBzZXQKIyBDT05GSUdfTUFDVkxBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0VRVUFMSVpFUiBpcyBu
b3Qgc2V0CkNPTkZJR19UVU49bQojIENPTkZJR19WRVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfUEhZ
TElCIGlzIG5vdCBzZXQKQ09ORklHX05FVF9FVEhFUk5FVD15CkNPTkZJR19NSUk9bQojIENPTkZJ
R19BWDg4Nzk2IGlzIG5vdCBzZXQKQ09ORklHX1NNQzkxWD1tCiMgQ09ORklHX1RJX0RBVklOQ0lf
RU1BQyBpcyBub3Qgc2V0CiMgQ09ORklHX0RNOTAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0VOQzI4
SjYwIGlzIG5vdCBzZXQKIyBDT05GSUdfRVRIT0MgaXMgbm90IHNldAojIENPTkZJR19TTUM5MTFY
IGlzIG5vdCBzZXQKIyBDT05GSUdfU01TQzkxMVggaXMgbm90IHNldAojIENPTkZJR19ETkVUIGlz
IG5vdCBzZXQKIyBDT05GSUdfSUJNX05FV19FTUFDX1pNSUkgaXMgbm90IHNldAojIENPTkZJR19J
Qk1fTkVXX0VNQUNfUkdNSUkgaXMgbm90IHNldAojIENPTkZJR19JQk1fTkVXX0VNQUNfVEFIIGlz
IG5vdCBzZXQKIyBDT05GSUdfSUJNX05FV19FTUFDX0VNQUM0IGlzIG5vdCBzZXQKIyBDT05GSUdf
SUJNX05FV19FTUFDX05PX0ZMT1dfQ1RSTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTV9ORVdfRU1B
Q19NQUxfQ0xSX0lDSU5UU1RBVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTV9ORVdfRU1BQ19NQUxf
Q09NTU9OX0VSUiBpcyBub3Qgc2V0CiMgQ09ORklHX0I0NCBpcyBub3Qgc2V0CiMgQ09ORklHX0tT
ODg0MiBpcyBub3Qgc2V0CiMgQ09ORklHX0tTODg1MSBpcyBub3Qgc2V0CiMgQ09ORklHX0tTODg1
MV9NTEwgaXMgbm90IHNldAojIENPTkZJR19ORVRERVZfMTAwMCBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVERFVl8xMDAwMCBpcyBub3Qgc2V0CkNPTkZJR19XTEFOPXkKIyBDT05GSUdfTElCRVJUQVNf
VEhJTkZJUk0gaXMgbm90IHNldAojIENPTkZJR19BVDc2QzUwWF9VU0IgaXMgbm90IHNldAojIENP
TkZJR19VU0JfWkQxMjAxIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX05FVF9STkRJU19XTEFOIGlz
IG5vdCBzZXQKIyBDT05GSUdfUlRMODE4NyBpcyBub3Qgc2V0CiMgQ09ORklHX01BQzgwMjExX0hX
U0lNIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRIX0NPTU1PTiBpcyBub3Qgc2V0CiMgQ09ORklHX0I0
MyBpcyBub3Qgc2V0CiMgQ09ORklHX0I0M0xFR0FDWSBpcyBub3Qgc2V0CiMgQ09ORklHX0hPU1RB
UCBpcyBub3Qgc2V0CiMgQ09ORklHX0lXTSBpcyBub3Qgc2V0CiMgQ09ORklHX0xJQkVSVEFTIGlz
IG5vdCBzZXQKIyBDT05GSUdfUDU0X0NPTU1PTiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUMlgwMCBp
cyBub3Qgc2V0CiMgQ09ORklHX1dMMTJYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1pEMTIxMVJXIGlz
IG5vdCBzZXQKCiMKIyBFbmFibGUgV2lNQVggKE5ldHdvcmtpbmcgb3B0aW9ucykgdG8gc2VlIHRo
ZSBXaU1BWCBkcml2ZXJzCiMKCiMKIyBVU0IgTmV0d29yayBBZGFwdGVycwojCiMgQ09ORklHX1VT
Ql9DQVRDIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0tBV0VUSCBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9QRUdBU1VTIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1JUTDgxNTAgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfVVNCTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NEQ19QSE9ORVQgaXMg
bm90IHNldAojIENPTkZJR19VU0JfSVBIRVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfV0FOIGlzIG5v
dCBzZXQKIyBDT05GSUdfUFBQIGlzIG5vdCBzZXQKIyBDT05GSUdfU0xJUCBpcyBub3Qgc2V0CiMg
Q09ORklHX05FVENPTlNPTEUgaXMgbm90IHNldAojIENPTkZJR19ORVRQT0xMIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkVUX1BPTExfQ09OVFJPTExFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lTRE4gaXMg
bm90IHNldAojIENPTkZJR19QSE9ORSBpcyBub3Qgc2V0CgojCiMgSW5wdXQgZGV2aWNlIHN1cHBv
cnQKIwpDT05GSUdfSU5QVVQ9eQojIENPTkZJR19JTlBVVF9GRl9NRU1MRVNTIGlzIG5vdCBzZXQK
IyBDT05GSUdfSU5QVVRfUE9MTERFViBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1NQQVJTRUtN
QVAgaXMgbm90IHNldAoKIwojIFVzZXJsYW5kIGludGVyZmFjZXMKIwojIENPTkZJR19JTlBVVF9N
T1VTRURFViBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0pPWURFViBpcyBub3Qgc2V0CkNPTkZJ
R19JTlBVVF9FVkRFVj15CiMgQ09ORklHX0lOUFVUX0VWQlVHIGlzIG5vdCBzZXQKCiMKIyBJbnB1
dCBEZXZpY2UgRHJpdmVycwojCkNPTkZJR19JTlBVVF9LRVlCT0FSRD15CiMgQ09ORklHX0tFWUJP
QVJEX0FEUDU1ODggaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9BVEtCRCBpcyBub3Qgc2V0
CiMgQ09ORklHX1FUMjE2MCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX0xLS0JEIGlzIG5v
dCBzZXQKQ09ORklHX0tFWUJPQVJEX0dQSU89bQojIENPTkZJR19LRVlCT0FSRF9UQ0E2NDE2IGlz
IG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTUFUUklYIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZ
Qk9BUkRfTE04MzIzIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTUFYNzM1OSBpcyBub3Qg
c2V0CiMgQ09ORklHX0tFWUJPQVJEX05FV1RPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJE
X09QRU5DT1JFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1NUT1dBV0FZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfS0VZQk9BUkRfU1VOS0JEIGlzIG5vdCBzZXQKQ09ORklHX0tFWUJPQVJEX1RX
TDQwMzA9eQojIENPTkZJR19LRVlCT0FSRF9YVEtCRCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVU
X01PVVNFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfSk9ZU1RJQ0sgaXMgbm90IHNldAojIENP
TkZJR19JTlBVVF9UQUJMRVQgaXMgbm90IHNldApDT05GSUdfSU5QVVRfVE9VQ0hTQ1JFRU49eQoj
IENPTkZJR19UT1VDSFNDUkVFTl9BRFM3ODQ2IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JF
RU5fQUQ3ODc3IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQUQ3ODc5X0kyQyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0FENzg3OV9TUEkgaXMgbm90IHNldAojIENPTkZJ
R19UT1VDSFNDUkVFTl9BRDc4NzkgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9EWU5B
UFJPIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fSEFNUFNISVJFIGlzIG5vdCBzZXQK
IyBDT05GSUdfVE9VQ0hTQ1JFRU5fRUVUSSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVO
X0ZVSklUU1UgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9HVU5aRSBpcyBub3Qgc2V0
CiMgQ09ORklHX1RPVUNIU0NSRUVOX0VMTyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVO
X1dBQ09NX1c4MDAxIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fTUNTNTAwMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX01UT1VDSCBpcyBub3Qgc2V0CiMgQ09ORklHX1RP
VUNIU0NSRUVOX0lORVhJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX01LNzEyIGlz
IG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fUEVOTU9VTlQgaXMgbm90IHNldAojIENPTkZJ
R19UT1VDSFNDUkVFTl9UT1VDSFJJR0hUIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5f
VE9VQ0hXSU4gaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9VU0JfQ09NUE9TSVRFIGlz
IG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVE9VQ0hJVDIxMyBpcyBub3Qgc2V0CiMgQ09O
RklHX1RPVUNIU0NSRUVOX1RTQzIwMDcgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9X
OTBYOTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVFBTNjUwN1ggaXMgbm90IHNl
dApDT05GSUdfSU5QVVRfTUlTQz15CiMgQ09ORklHX0lOUFVUX0FENzE0WCBpcyBub3Qgc2V0CiMg
Q09ORklHX0lOUFVUX0FUSV9SRU1PVEUgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9BVElfUkVN
T1RFMiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0tFWVNQQU5fUkVNT1RFIGlzIG5vdCBzZXQK
IyBDT05GSUdfSU5QVVRfUE9XRVJNQVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfWUVBTElO
SyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0NNMTA5IGlzIG5vdCBzZXQKQ09ORklHX0lOUFVU
X1RXTDQwMzBfUFdSQlVUVE9OPXkKIyBDT05GSUdfSU5QVVRfVFdMNDAzMF9WSUJSQSBpcyBub3Qg
c2V0CkNPTkZJR19JTlBVVF9VSU5QVVQ9bQojIENPTkZJR19JTlBVVF9QQ0Y4NTc0IGlzIG5vdCBz
ZXQKIyBDT05GSUdfSU5QVVRfR1BJT19ST1RBUllfRU5DT0RFUiBpcyBub3Qgc2V0CgojCiMgSGFy
ZHdhcmUgSS9PIHBvcnRzCiMKIyBDT05GSUdfU0VSSU8gaXMgbm90IHNldAojIENPTkZJR19HQU1F
UE9SVCBpcyBub3Qgc2V0CgojCiMgQ2hhcmFjdGVyIGRldmljZXMKIwpDT05GSUdfVlQ9eQpDT05G
SUdfQ09OU09MRV9UUkFOU0xBVElPTlM9eQpDT05GSUdfVlRfQ09OU09MRT15CkNPTkZJR19IV19D
T05TT0xFPXkKIyBDT05GSUdfVlRfSFdfQ09OU09MRV9CSU5ESU5HIGlzIG5vdCBzZXQKQ09ORklH
X0RFVktNRU09eQojIENPTkZJR19TRVJJQUxfTk9OU1RBTkRBUkQgaXMgbm90IHNldAojIENPTkZJ
R19OX0dTTSBpcyBub3Qgc2V0CgojCiMgU2VyaWFsIGRyaXZlcnMKIwpDT05GSUdfU0VSSUFMXzgy
NTA9eQpDT05GSUdfU0VSSUFMXzgyNTBfQ09OU09MRT15CkNPTkZJR19TRVJJQUxfODI1MF9OUl9V
QVJUUz00CkNPTkZJR19TRVJJQUxfODI1MF9SVU5USU1FX1VBUlRTPTQKIyBDT05GSUdfU0VSSUFM
XzgyNTBfRVhURU5ERUQgaXMgbm90IHNldAoKIwojIE5vbi04MjUwIHNlcmlhbCBwb3J0IHN1cHBv
cnQKIwojIENPTkZJR19TRVJJQUxfTUFYMzEwMCBpcyBub3Qgc2V0CkNPTkZJR19TRVJJQUxfQ09S
RT15CkNPTkZJR19TRVJJQUxfQ09SRV9DT05TT0xFPXkKIyBDT05GSUdfU0VSSUFMX1RJTUJFUkRB
TEUgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfQUxURVJBX0pUQUdVQVJUIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VSSUFMX0FMVEVSQV9VQVJUIGlzIG5vdCBzZXQKQ09ORklHX1VOSVg5OF9QVFlT
PXkKIyBDT05GSUdfREVWUFRTX01VTFRJUExFX0lOU1RBTkNFUyBpcyBub3Qgc2V0CiMgQ09ORklH
X0xFR0FDWV9QVFlTIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBNSV9IQU5ETEVSIGlzIG5vdCBzZXQK
Q09ORklHX0hXX1JBTkRPTT1tCiMgQ09ORklHX0hXX1JBTkRPTV9USU1FUklPTUVNIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUjM5NjQgaXMgbm90IHNldAojIENPTkZJR19SQVdfRFJJVkVSIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVENHX1RQTSBpcyBub3Qgc2V0CiMgQ09ORklHX1JBTU9PUFMgaXMgbm90IHNl
dApDT05GSUdfSTJDPXkKQ09ORklHX0kyQ19CT0FSRElORk89eQpDT05GSUdfSTJDX0NPTVBBVD15
CkNPTkZJR19JMkNfQ0hBUkRFVj15CkNPTkZJR19JMkNfSEVMUEVSX0FVVE89eQoKIwojIEkyQyBI
YXJkd2FyZSBCdXMgc3VwcG9ydAojCgojCiMgSTJDIHN5c3RlbSBidXMgZHJpdmVycyAobW9zdGx5
IGVtYmVkZGVkIC8gc3lzdGVtLW9uLWNoaXApCiMKIyBDT05GSUdfSTJDX0RFU0lHTldBUkUgaXMg
bm90IHNldAojIENPTkZJR19JMkNfR1BJTyBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19PQ09SRVMg
aXMgbm90IHNldApDT05GSUdfSTJDX09NQVA9eQojIENPTkZJR19JMkNfUENBX1BMQVRGT1JNIGlz
IG5vdCBzZXQKIyBDT05GSUdfSTJDX1NJTVRFQyBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19YSUxJ
TlggaXMgbm90IHNldAoKIwojIEV4dGVybmFsIEkyQy9TTUJ1cyBhZGFwdGVyIGRyaXZlcnMKIwoj
IENPTkZJR19JMkNfUEFSUE9SVF9MSUdIVCBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19UQU9TX0VW
TSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19USU5ZX1VTQiBpcyBub3Qgc2V0CgojCiMgT3RoZXIg
STJDL1NNQnVzIGJ1cyBkcml2ZXJzCiMKIyBDT05GSUdfSTJDX1NUVUIgaXMgbm90IHNldAojIENP
TkZJR19JMkNfREVCVUdfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19ERUJVR19BTEdPIGlz
IG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFQlVHX0JVUyBpcyBub3Qgc2V0CkNPTkZJR19TUEk9eQoj
IENPTkZJR19TUElfREVCVUcgaXMgbm90IHNldApDT05GSUdfU1BJX01BU1RFUj15CgojCiMgU1BJ
IE1hc3RlciBDb250cm9sbGVyIERyaXZlcnMKIwojIENPTkZJR19TUElfQklUQkFORyBpcyBub3Qg
c2V0CiMgQ09ORklHX1NQSV9HUElPIGlzIG5vdCBzZXQKQ09ORklHX1NQSV9PTUFQMjRYWD15CiMg
Q09ORklHX1NQSV9YSUxJTlggaXMgbm90IHNldAojIENPTkZJR19TUElfREVTSUdOV0FSRSBpcyBu
b3Qgc2V0CgojCiMgU1BJIFByb3RvY29sIE1hc3RlcnMKIwojIENPTkZJR19TUElfU1BJREVWIGlz
IG5vdCBzZXQKIyBDT05GSUdfU1BJX1RMRTYyWDAgaXMgbm90IHNldAoKIwojIFBQUyBzdXBwb3J0
CiMKIyBDT05GSUdfUFBTIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfUkVRVUlSRV9HUElPTElCPXkK
Q09ORklHX0dQSU9MSUI9eQojIENPTkZJR19ERUJVR19HUElPIGlzIG5vdCBzZXQKQ09ORklHX0dQ
SU9fU1lTRlM9eQoKIwojIE1lbW9yeSBtYXBwZWQgR1BJTyBleHBhbmRlcnM6CiMKIyBDT05GSUdf
R1BJT19JVDg3NjFFIGlzIG5vdCBzZXQKCiMKIyBJMkMgR1BJTyBleHBhbmRlcnM6CiMKIyBDT05G
SUdfR1BJT19NQVg3MzAwIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19NQVg3MzJYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfR1BJT19QQ0E5NTNYIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19QQ0Y4NTdY
IGlzIG5vdCBzZXQKQ09ORklHX0dQSU9fVFdMNDAzMD15CiMgQ09ORklHX0dQSU9fQURQNTU4OCBp
cyBub3Qgc2V0CgojCiMgUENJIEdQSU8gZXhwYW5kZXJzOgojCgojCiMgU1BJIEdQSU8gZXhwYW5k
ZXJzOgojCiMgQ09ORklHX0dQSU9fTUFYNzMwMSBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fTUNQ
MjNTMDggaXMgbm90IHNldAojIENPTkZJR19HUElPX01DMzM4ODAgaXMgbm90IHNldAoKIwojIEFD
OTcgR1BJTyBleHBhbmRlcnM6CiMKCiMKIyBNT0RVTGJ1cyBHUElPIGV4cGFuZGVyczoKIwojIENP
TkZJR19XMSBpcyBub3Qgc2V0CiMgQ09ORklHX1BPV0VSX1NVUFBMWSBpcyBub3Qgc2V0CkNPTkZJ
R19IV01PTj15CiMgQ09ORklHX0hXTU9OX1ZJRCBpcyBub3Qgc2V0CiMgQ09ORklHX0hXTU9OX0RF
QlVHX0NISVAgaXMgbm90IHNldAoKIwojIE5hdGl2ZSBkcml2ZXJzCiMKIyBDT05GSUdfU0VOU09S
U19BRDc0MTQgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FENzQxOCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfQURDWFggaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FETTEwMjEg
aXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FETTEwMjUgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX0FETTEwMjYgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FETTEwMjkgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX0FETTEwMzEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X0FETTkyNDAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FEVDc0MTEgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX0FEVDc0NjIgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FEVDc0
NzAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FEVDc0NzUgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0FTQzc2MjEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FUWFAxIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19EUzE2MjEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X0Y3MTgwNUYgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0Y3MTg4MkZHIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19GNzUzNzVTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19HNzYw
QSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfR0w1MThTTSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfR0w1MjBTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSVQ4NyBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfTE02MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03
MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfTE03NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE03NyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfTE03OCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04MCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
TE04NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE04NyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfTE05MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTE05MiBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfTE05MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTFRDNDIx
NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTFRDNDI0NSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfTE05NTI0MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYMTExMSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYMTYxOSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfTUFYNjY1MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfUEM4NzM2MCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfUEM4NzQyNyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfUENG
ODU5MSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0hUMTUgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0RNRTE3MzcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0VNQzE0MDMgaXMg
bm90IHNldAojIENPTkZJR19TRU5TT1JTX1NNU0M0N00xIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19TTVNDNDdNMTkyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19TTVNDNDdCMzk3IGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFM3ODI4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19BRFM3ODcxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BTUM2ODIxIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19USE1DNTAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1RN
UDEwMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVE1QNDAxIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19UTVA0MjEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1ZUMTIxMSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzgxRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfVzgzNzkxRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzkyRCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfVzgzNzkzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19XODNM
Nzg1VFMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4M0w3ODZORyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfVzgzNjI3SEYgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4MzYy
N0VIRiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTElTM19TUEkgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0xJUzNfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfVEhFUk1BTCBpcyBub3Qg
c2V0CkNPTkZJR19XQVRDSERPRz15CiMgQ09ORklHX1dBVENIRE9HX05PV0FZT1VUIGlzIG5vdCBz
ZXQKCiMKIyBXYXRjaGRvZyBEZXZpY2UgRHJpdmVycwojCiMgQ09ORklHX1NPRlRfV0FUQ0hET0cg
aXMgbm90IHNldApDT05GSUdfT01BUF9XQVRDSERPRz1tCkNPTkZJR19UV0w0MDMwX1dBVENIRE9H
PW0KIyBDT05GSUdfTUFYNjNYWF9XQVRDSERPRyBpcyBub3Qgc2V0CgojCiMgVVNCLWJhc2VkIFdh
dGNoZG9nIENhcmRzCiMKIyBDT05GSUdfVVNCUENXQVRDSERPRyBpcyBub3Qgc2V0CkNPTkZJR19T
U0JfUE9TU0lCTEU9eQoKIwojIFNvbmljcyBTaWxpY29uIEJhY2twbGFuZQojCiMgQ09ORklHX1NT
QiBpcyBub3Qgc2V0CkNPTkZJR19NRkRfU1VQUE9SVD15CiMgQ09ORklHX01GRF9DT1JFIGlzIG5v
dCBzZXQKIyBDT05GSUdfTUZEXzg4UE04NjBYIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1NNNTAx
IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX0FTSUMzIGlzIG5vdCBzZXQKIyBDT05GSUdfSFRDX0VH
UElPIGlzIG5vdCBzZXQKIyBDT05GSUdfSFRDX1BBU0lDMyBpcyBub3Qgc2V0CiMgQ09ORklHX0hU
Q19JMkNQTEQgaXMgbm90IHNldAojIENPTkZJR19UUFM2NTAxMCBpcyBub3Qgc2V0CiMgQ09ORklH
X1RQUzY1MDdYIGlzIG5vdCBzZXQKQ09ORklHX1RXTDQwMzBfQ09SRT15CiMgQ09ORklHX1RXTDQw
MzBfUE9XRVIgaXMgbm90IHNldAojIENPTkZJR19UV0w0MDMwX0NPREVDIGlzIG5vdCBzZXQKIyBD
T05GSUdfTUZEX1RDMzU4OTIgaXMgbm90IHNldAojIENPTkZJR19NRkRfVE1JTyBpcyBub3Qgc2V0
CiMgQ09ORklHX01GRF9UN0w2NlhCIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1RDNjM4N1hCIGlz
IG5vdCBzZXQKIyBDT05GSUdfTUZEX1RDNjM5M1hCIGlzIG5vdCBzZXQKIyBDT05GSUdfUE1JQ19E
QTkwM1ggaXMgbm90IHNldAojIENPTkZJR19QTUlDX0FEUDU1MjAgaXMgbm90IHNldAojIENPTkZJ
R19NRkRfTUFYODkyNSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9XTTg0MDAgaXMgbm90IHNldAoj
IENPTkZJR19NRkRfV004MzFYIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1dNODM1MF9JMkMgaXMg
bm90IHNldAojIENPTkZJR19NRkRfV004OTk0IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1BDRjUw
NjMzIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX01DMTM3ODMgaXMgbm90IHNldAojIENPTkZJR19B
Qlg1MDBfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX0VaWF9QQ0FQIGlzIG5vdCBzZXQKIyBDT05G
SUdfQUI4NTAwX0NPUkUgaXMgbm90IHNldApDT05GSUdfUkVHVUxBVE9SPXkKIyBDT05GSUdfUkVH
VUxBVE9SX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX0RVTU1ZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUkVHVUxBVE9SX0ZJWEVEX1ZPTFRBR0UgaXMgbm90IHNldAojIENPTkZJR19S
RUdVTEFUT1JfVklSVFVBTF9DT05TVU1FUiBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9V
U0VSU1BBQ0VfQ09OU1VNRVIgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfQlEyNDAyMiBp
cyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9NQVgxNTg2IGlzIG5vdCBzZXQKIyBDT05GSUdf
UkVHVUxBVE9SX01BWDg2NDkgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfTUFYODY2MCBp
cyBub3Qgc2V0CkNPTkZJR19SRUdVTEFUT1JfVFdMNDAzMD15CiMgQ09ORklHX1JFR1VMQVRPUl9M
UDM5NzEgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfVFBTNjUwMjMgaXMgbm90IHNldAoj
IENPTkZJR19SRUdVTEFUT1JfVFBTNjUwN1ggaXMgbm90IHNldApDT05GSUdfTUVESUFfU1VQUE9S
VD15CgojCiMgTXVsdGltZWRpYSBjb3JlIHN1cHBvcnQKIwpDT05GSUdfVklERU9fREVWPXkKQ09O
RklHX1ZJREVPX1Y0TDJfQ09NTU9OPXkKQ09ORklHX1ZJREVPX0FMTE9XX1Y0TDE9eQpDT05GSUdf
VklERU9fVjRMMV9DT01QQVQ9eQojIENPTkZJR19EVkJfQ09SRSBpcyBub3Qgc2V0CkNPTkZJR19W
SURFT19NRURJQT15CgojCiMgTXVsdGltZWRpYSBkcml2ZXJzCiMKQ09ORklHX0lSX0NPUkU9eQpD
T05GSUdfVklERU9fSVI9eQojIENPTkZJR19SQ19NQVAgaXMgbm90IHNldAojIENPTkZJR19JUl9O
RUNfREVDT0RFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSX1JDNV9ERUNPREVSIGlzIG5vdCBzZXQK
IyBDT05GSUdfSVJfUkM2X0RFQ09ERVIgaXMgbm90IHNldAojIENPTkZJR19JUl9KVkNfREVDT0RF
UiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSX1NPTllfREVDT0RFUiBpcyBub3Qgc2V0CiMgQ09ORklH
X0lSX0lNT04gaXMgbm90IHNldAojIENPTkZJR19NRURJQV9BVFRBQ0ggaXMgbm90IHNldApDT05G
SUdfTUVESUFfVFVORVI9eQojIENPTkZJR19NRURJQV9UVU5FUl9DVVNUT01JU0UgaXMgbm90IHNl
dApDT05GSUdfTUVESUFfVFVORVJfU0lNUExFPXkKQ09ORklHX01FRElBX1RVTkVSX1REQTgyOTA9
eQpDT05GSUdfTUVESUFfVFVORVJfVERBOTg4Nz15CkNPTkZJR19NRURJQV9UVU5FUl9URUE1NzYx
PXkKQ09ORklHX01FRElBX1RVTkVSX1RFQTU3Njc9eQpDT05GSUdfTUVESUFfVFVORVJfTVQyMFhY
PXkKQ09ORklHX01FRElBX1RVTkVSX1hDMjAyOD15CkNPTkZJR19NRURJQV9UVU5FUl9YQzUwMDA9
eQpDT05GSUdfTUVESUFfVFVORVJfTUM0NFM4MDM9eQpDT05GSUdfVklERU9fVjRMMj15CkNPTkZJ
R19WSURFT19WNEwxPXkKQ09ORklHX1ZJREVPX0NBUFRVUkVfRFJJVkVSUz15CiMgQ09ORklHX1ZJ
REVPX0FEVl9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0ZJWEVEX01JTk9SX1JBTkdF
UyBpcyBub3Qgc2V0CkNPTkZJR19WSURFT19IRUxQRVJfQ0hJUFNfQVVUTz15CkNPTkZJR19WSURF
T19JUl9JMkM9eQpDT05GSUdfVklERU9fRVQ4RUs4PXkKQ09ORklHX1ZJREVPX0FENTgyMD15CkNP
TkZJR19WSURFT19BRFAxNjUzPXkKQ09ORklHX1ZJREVPX1NNSUFfU0VOU09SPXkKIyBDT05GSUdf
VklERU9fQ1BJQSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJREVPX0NQSUEyIGlzIG5vdCBzZXQKIyBD
T05GSUdfVklERU9fU0FBNTI0NkEgaXMgbm90IHNldAojIENPTkZJR19WSURFT19TQUE1MjQ5IGlz
IG5vdCBzZXQKQ09ORklHX1ZJREVPX09NQVAzPXkKIyBDT05GSUdfVklERU9fU01JQVJFR1MgaXMg
bm90IHNldAojIENPTkZJR19TT0NfQ0FNRVJBIGlzIG5vdCBzZXQKIyBDT05GSUdfVjRMX1VTQl9E
UklWRVJTIGlzIG5vdCBzZXQKIyBDT05GSUdfVjRMX01FTTJNRU1fRFJJVkVSUyBpcyBub3Qgc2V0
CiMgQ09ORklHX1JBRElPX0FEQVBURVJTIGlzIG5vdCBzZXQKIyBDT05GSUdfREFCIGlzIG5vdCBz
ZXQKCiMKIyBHcmFwaGljcyBzdXBwb3J0CiMKIyBDT05GSUdfVkdBU1RBVEUgaXMgbm90IHNldAoj
IENPTkZJR19WSURFT19PVVRQVVRfQ09OVFJPTCBpcyBub3Qgc2V0CkNPTkZJR19GQj15CiMgQ09O
RklHX0ZJUk1XQVJFX0VESUQgaXMgbm90IHNldAojIENPTkZJR19GQl9EREMgaXMgbm90IHNldAoj
IENPTkZJR19GQl9CT09UX1ZFU0FfU1VQUE9SVCBpcyBub3Qgc2V0CkNPTkZJR19GQl9DRkJfRklM
TFJFQ1Q9eQpDT05GSUdfRkJfQ0ZCX0NPUFlBUkVBPXkKQ09ORklHX0ZCX0NGQl9JTUFHRUJMSVQ9
eQojIENPTkZJR19GQl9DRkJfUkVWX1BJWEVMU19JTl9CWVRFIGlzIG5vdCBzZXQKIyBDT05GSUdf
RkJfU1lTX0ZJTExSRUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1lTX0NPUFlBUkVBIGlzIG5v
dCBzZXQKIyBDT05GSUdfRkJfU1lTX0lNQUdFQkxJVCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0ZP
UkVJR05fRU5ESUFOIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU1lTX0ZPUFMgaXMgbm90IHNldAoj
IENPTkZJR19GQl9TVkdBTElCIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfTUFDTU9ERVMgaXMgbm90
IHNldAojIENPTkZJR19GQl9CQUNLTElHSFQgaXMgbm90IHNldAojIENPTkZJR19GQl9NT0RFX0hF
TFBFUlMgaXMgbm90IHNldAojIENPTkZJR19GQl9USUxFQkxJVFRJTkcgaXMgbm90IHNldAoKIwoj
IEZyYW1lIGJ1ZmZlciBoYXJkd2FyZSBkcml2ZXJzCiMKIyBDT05GSUdfRkJfUzFEMTNYWFggaXMg
bm90IHNldAojIENPTkZJR19GQl9WSVJUVUFMIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfTUVUUk9O
T01FIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfTUI4NjJYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZC
X0JST0FEU0hFRVQgaXMgbm90IHNldAojIENPTkZJR19GQl9PTUFQX0JPT1RMT0FERVJfSU5JVCBp
cyBub3Qgc2V0CkNPTkZJR19PTUFQMl9WUkFNPXkKQ09ORklHX09NQVAyX1ZSRkI9eQpDT05GSUdf
T01BUDJfRFNTPXkKQ09ORklHX09NQVAyX1ZSQU1fU0laRT0wCiMgQ09ORklHX09NQVAyX0RTU19E
RUJVR19TVVBQT1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfT01BUDJfRFNTX0RQSSBpcyBub3Qgc2V0
CiMgQ09ORklHX09NQVAyX0RTU19SRkJJIGlzIG5vdCBzZXQKIyBDT05GSUdfT01BUDJfRFNTX1ZF
TkMgaXMgbm90IHNldApDT05GSUdfT01BUDJfRFNTX1NEST15CiMgQ09ORklHX09NQVAyX0RTU19E
U0kgaXMgbm90IHNldAojIENPTkZJR19PTUFQMl9EU1NfRkFLRV9WU1lOQyBpcyBub3Qgc2V0CkNP
TkZJR19PTUFQMl9EU1NfTUlOX0ZDS19QRVJfUENLPTAKQ09ORklHX0ZCX09NQVAyPXkKQ09ORklH
X0ZCX09NQVAyX0RFQlVHX1NVUFBPUlQ9eQpDT05GSUdfRkJfT01BUDJfTlVNX0ZCUz0zCgojCiMg
T01BUDIvMyBEaXNwbGF5IERldmljZSBEcml2ZXJzCiMKIyBDT05GSUdfUEFORUxfR0VORVJJQyBp
cyBub3Qgc2V0CiMgQ09ORklHX1BBTkVMX1NIQVJQX0xTMDM3VjdEVzAxIGlzIG5vdCBzZXQKIyBD
T05GSUdfUEFORUxfU0hBUlBfTFEwNDNUMURHMDEgaXMgbm90IHNldAojIENPTkZJR19QQU5FTF9U
T1BQT0xZX1RETzM1UyBpcyBub3Qgc2V0CiMgQ09ORklHX1BBTkVMX1RQT19URDA0M01URUExIGlz
IG5vdCBzZXQKQ09ORklHX1BBTkVMX0FDWDU2NUFLTT15CiMgQ09ORklHX0JBQ0tMSUdIVF9MQ0Rf
U1VQUE9SVCBpcyBub3Qgc2V0CkNPTkZJR19CQUNLTElHSFRfQ0xBU1NfREVWSUNFPXkKCiMKIyBE
aXNwbGF5IGRldmljZSBzdXBwb3J0CiMKQ09ORklHX0RJU1BMQVlfU1VQUE9SVD15CgojCiMgRGlz
cGxheSBoYXJkd2FyZSBkcml2ZXJzCiMKCiMKIyBDb25zb2xlIGRpc3BsYXkgZHJpdmVyIHN1cHBv
cnQKIwojIENPTkZJR19WR0FfQ09OU09MRSBpcyBub3Qgc2V0CkNPTkZJR19EVU1NWV9DT05TT0xF
PXkKQ09ORklHX0ZSQU1FQlVGRkVSX0NPTlNPTEU9eQojIENPTkZJR19GUkFNRUJVRkZFUl9DT05T
T0xFX0RFVEVDVF9QUklNQVJZIGlzIG5vdCBzZXQKIyBDT05GSUdfRlJBTUVCVUZGRVJfQ09OU09M
RV9ST1RBVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZPTlRTIGlzIG5vdCBzZXQKQ09ORklHX0ZP
TlRfOHg4PXkKQ09ORklHX0ZPTlRfOHgxNj15CkNPTkZJR19MT0dPPXkKQ09ORklHX0xPR09fTElO
VVhfTU9OTz15CkNPTkZJR19MT0dPX0xJTlVYX1ZHQTE2PXkKQ09ORklHX0xPR09fTElOVVhfQ0xV
VDIyND15CkNPTkZJR19TT1VORD15CiMgQ09ORklHX1NPVU5EX09TU19DT1JFIGlzIG5vdCBzZXQK
Q09ORklHX1NORD15CkNPTkZJR19TTkRfVElNRVI9eQpDT05GSUdfU05EX1BDTT15CkNPTkZJR19T
TkRfSkFDSz15CiMgQ09ORklHX1NORF9TRVFVRU5DRVIgaXMgbm90IHNldAojIENPTkZJR19TTkRf
TUlYRVJfT1NTIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1BDTV9PU1MgaXMgbm90IHNldAojIENP
TkZJR19TTkRfSFJUSU1FUiBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9EWU5BTUlDX01JTk9SUyBp
cyBub3Qgc2V0CkNPTkZJR19TTkRfU1VQUE9SVF9PTERfQVBJPXkKQ09ORklHX1NORF9WRVJCT1NF
X1BST0NGUz15CiMgQ09ORklHX1NORF9WRVJCT1NFX1BSSU5USyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9SQVdNSURJX1NFUSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NORF9PUEwzX0xJQl9TRVEgaXMgbm90IHNldAojIENPTkZJR19TTkRfT1BMNF9M
SUJfU0VRIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NCQVdFX1NFUSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9FTVUxMEsxX1NFUSBpcyBub3Qgc2V0CkNPTkZJR19TTkRfRFJJVkVSUz15CiMgQ09O
RklHX1NORF9EVU1NWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9NVFBBViBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9TRVJJQUxfVTE2NTUwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX01QVTQwMSBp
cyBub3Qgc2V0CkNPTkZJR19TTkRfQVJNPXkKQ09ORklHX1NORF9TUEk9eQojIENPTkZJR19TTkRf
VVNCIGlzIG5vdCBzZXQKQ09ORklHX1NORF9TT0M9eQpDT05GSUdfU05EX09NQVBfU09DPXkKIyBD
T05GSUdfU05EX09NQVBfU09DX1JYNTEgaXMgbm90IHNldApDT05GSUdfU05EX1NPQ19JMkNfQU5E
X1NQST15CiMgQ09ORklHX1NORF9TT0NfQUxMX0NPREVDUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NP
VU5EX1BSSU1FIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9TVVBQT1JUPXkKQ09ORklHX0hJRD1tCiMg
Q09ORklHX0hJRFJBVyBpcyBub3Qgc2V0CgojCiMgVVNCIElucHV0IERldmljZXMKIwpDT05GSUdf
VVNCX0hJRD1tCiMgQ09ORklHX0hJRF9QSUQgaXMgbm90IHNldAojIENPTkZJR19VU0JfSElEREVW
IGlzIG5vdCBzZXQKCiMKIyBVU0IgSElEIEJvb3QgUHJvdG9jb2wgZHJpdmVycwojCiMgQ09ORklH
X1VTQl9LQkQgaXMgbm90IHNldAojIENPTkZJR19VU0JfTU9VU0UgaXMgbm90IHNldAoKIwojIFNw
ZWNpYWwgSElEIGRyaXZlcnMKIwojIENPTkZJR19ISURfM01fUENUIGlzIG5vdCBzZXQKQ09ORklH
X0hJRF9BNFRFQ0g9bQpDT05GSUdfSElEX0FQUExFPW0KQ09ORklHX0hJRF9CRUxLSU49bQojIENP
TkZJR19ISURfQ0FORE8gaXMgbm90IHNldApDT05GSUdfSElEX0NIRVJSWT1tCkNPTkZJR19ISURf
Q0hJQ09OWT1tCiMgQ09ORklHX0hJRF9QUk9ESUtFWVMgaXMgbm90IHNldApDT05GSUdfSElEX0NZ
UFJFU1M9bQojIENPTkZJR19ISURfRFJBR09OUklTRSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9F
R0FMQVggaXMgbm90IHNldApDT05GSUdfSElEX0VaS0VZPW0KIyBDT05GSUdfSElEX0tZRSBpcyBu
b3Qgc2V0CkNPTkZJR19ISURfR1lSQVRJT049bQojIENPTkZJR19ISURfVFdJTkhBTiBpcyBub3Qg
c2V0CiMgQ09ORklHX0hJRF9LRU5TSU5HVE9OIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9MT0dJVEVD
SD1tCiMgQ09ORklHX0xPR0lURUNIX0ZGIGlzIG5vdCBzZXQKIyBDT05GSUdfTE9HSVJVTUJMRVBB
RDJfRkYgaXMgbm90IHNldAojIENPTkZJR19MT0dJRzk0MF9GRiBpcyBub3Qgc2V0CiMgQ09ORklH
X0hJRF9NQUdJQ01PVVNFIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9NSUNST1NPRlQ9bQojIENPTkZJ
R19ISURfTU9TQVJUIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9NT05URVJFWT1tCiMgQ09ORklHX0hJ
RF9OVFJJRyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9PUlRFSyBpcyBub3Qgc2V0CkNPTkZJR19I
SURfUEFOVEhFUkxPUkQ9bQojIENPTkZJR19QQU5USEVSTE9SRF9GRiBpcyBub3Qgc2V0CkNPTkZJ
R19ISURfUEVUQUxZTlg9bQojIENPTkZJR19ISURfUElDT0xDRCBpcyBub3Qgc2V0CiMgQ09ORklH
X0hJRF9RVUFOVEEgaXMgbm90IHNldAojIENPTkZJR19ISURfUk9DQ0FUIGlzIG5vdCBzZXQKIyBD
T05GSUdfSElEX1JPQ0NBVF9LT05FIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9TQU1TVU5HPW0KQ09O
RklHX0hJRF9TT05ZPW0KIyBDT05GSUdfSElEX1NUQU5UVU0gaXMgbm90IHNldApDT05GSUdfSElE
X1NVTlBMVVM9bQojIENPTkZJR19ISURfR1JFRU5BU0lBIGlzIG5vdCBzZXQKIyBDT05GSUdfSElE
X1NNQVJUSk9ZUExVUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9UT1BTRUVEIGlzIG5vdCBzZXQK
IyBDT05GSUdfSElEX1RIUlVTVE1BU1RFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9XQUNPTSBp
cyBub3Qgc2V0CiMgQ09ORklHX0hJRF9aRVJPUExVUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9a
WURBQ1JPTiBpcyBub3Qgc2V0CkNPTkZJR19VU0JfU1VQUE9SVD15CkNPTkZJR19VU0JfQVJDSF9I
QVNfSENEPXkKQ09ORklHX1VTQl9BUkNIX0hBU19PSENJPXkKQ09ORklHX1VTQl9BUkNIX0hBU19F
SENJPXkKQ09ORklHX1VTQj15CkNPTkZJR19VU0JfREVCVUc9eQpDT05GSUdfVVNCX0FOTk9VTkNF
X05FV19ERVZJQ0VTPXkKCiMKIyBNaXNjZWxsYW5lb3VzIFVTQiBvcHRpb25zCiMKQ09ORklHX1VT
Ql9ERVZJQ0VGUz15CkNPTkZJR19VU0JfREVWSUNFX0NMQVNTPXkKIyBDT05GSUdfVVNCX0RZTkFN
SUNfTUlOT1JTIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9TVVNQRU5EPXkKQ09ORklHX1VTQl9PVEc9
eQpDT05GSUdfVVNCX09UR19XSElURUxJU1Q9eQpDT05GSUdfVVNCX09UR19CTEFDS0xJU1RfSFVC
PXkKQ09ORklHX1VTQl9NT049eQojIENPTkZJR19VU0JfV1VTQiBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9XVVNCX0NCQUYgaXMgbm90IHNldAoKIwojIFVTQiBIb3N0IENvbnRyb2xsZXIgRHJpdmVy
cwojCiMgQ09ORklHX1VTQl9DNjdYMDBfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0VIQ0lf
SENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX09YVTIxMEhQX0hDRCBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9JU1AxMTZYX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU1AxNzYwX0hDRCBp
cyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU1AxMzYyX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9PSENJX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TTDgxMV9IQ0QgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfUjhBNjY1OTdfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0hXQV9IQ0Qg
aXMgbm90IHNldApDT05GSUdfVVNCX01VU0JfSERSQz15CkNPTkZJR19VU0JfTVVTQl9TT0M9eQoK
IwojIE9NQVAgMzQzeCBoaWdoIHNwZWVkIFVTQiBzdXBwb3J0CiMKIyBDT05GSUdfVVNCX01VU0Jf
SE9TVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9NVVNCX1BFUklQSEVSQUwgaXMgbm90IHNldApD
T05GSUdfVVNCX01VU0JfT1RHPXkKQ09ORklHX1VTQl9HQURHRVRfTVVTQl9IRFJDPXkKQ09ORklH
X1VTQl9NVVNCX0hEUkNfSENEPXkKIyBDT05GSUdfTVVTQl9QSU9fT05MWSBpcyBub3Qgc2V0CkNP
TkZJR19VU0JfSU5WRU5UUkFfRE1BPXkKIyBDT05GSUdfVVNCX1RJX0NQUElfRE1BIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX01VU0JfREVCVUcgaXMgbm90IHNldAoKIwojIFVTQiBEZXZpY2UgQ2xh
c3MgZHJpdmVycwojCiMgQ09ORklHX1VTQl9BQ00gaXMgbm90IHNldAojIENPTkZJR19VU0JfUFJJ
TlRFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9XRE0gaXMgbm90IHNldAojIENPTkZJR19VU0Jf
VE1DIGlzIG5vdCBzZXQKCiMKIyBOT1RFOiBVU0JfU1RPUkFHRSBkZXBlbmRzIG9uIFNDU0kgYnV0
IEJMS19ERVZfU0QgbWF5CiMKCiMKIyBhbHNvIGJlIG5lZWRlZDsgc2VlIFVTQl9TVE9SQUdFIEhl
bHAgZm9yIG1vcmUgaW5mbwojCkNPTkZJR19VU0JfU1RPUkFHRT1tCiMgQ09ORklHX1VTQl9TVE9S
QUdFX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfREFUQUZBQiBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0ZSRUVDT00gaXMgbm90IHNldAojIENPTkZJR19VU0Jf
U1RPUkFHRV9JU0QyMDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9VU0JBVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX1NERFIwOSBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9TVE9SQUdFX1NERFI1NSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0pVTVBTSE9U
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfQUxBVURBIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX1NUT1JBR0VfT05FVE9VQ0ggaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9L
QVJNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0NZUFJFU1NfQVRBQ0IgaXMgbm90
IHNldApDT05GSUdfVVNCX0xJQlVTVUFMPXkKCiMKIyBVU0IgSW1hZ2luZyBkZXZpY2VzCiMKIyBD
T05GSUdfVVNCX01EQzgwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9NSUNST1RFSyBpcyBub3Qg
c2V0CgojCiMgVVNCIHBvcnQgZHJpdmVycwojCiMgQ09ORklHX1VTQl9TRVJJQUwgaXMgbm90IHNl
dAoKIwojIFVTQiBNaXNjZWxsYW5lb3VzIGRyaXZlcnMKIwojIENPTkZJR19VU0JfRU1JNjIgaXMg
bm90IHNldAojIENPTkZJR19VU0JfRU1JMjYgaXMgbm90IHNldAojIENPTkZJR19VU0JfQURVVFVY
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFVlNFRyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9S
SU81MDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfTEVHT1RPV0VSIGlzIG5vdCBzZXQKIyBDT05G
SUdfVVNCX0xDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRUQgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfQ1lQUkVTU19DWTdDNjMgaXMgbm90IHNldAojIENPTkZJR19VU0JfQ1lUSEVSTSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9JRE1PVVNFIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0ZURElf
RUxBTiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9BUFBMRURJU1BMQVkgaXMgbm90IHNldAojIENP
TkZJR19VU0JfU0lTVVNCVkdBIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0xEIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX1RSQU5DRVZJQlJBVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lPV0FS
UklPUiBpcyBub3Qgc2V0CkNPTkZJR19VU0JfVEVTVD1tCiMgQ09ORklHX1VTQl9JU0lHSFRGVyBp
cyBub3Qgc2V0CkNPTkZJR19VU0JfR0FER0VUPW0KQ09ORklHX1VTQl9HQURHRVRfREVCVUc9eQpD
T05GSUdfVVNCX0dBREdFVF9ERUJVR19GSUxFUz15CkNPTkZJR19VU0JfR0FER0VUX0RFQlVHX0ZT
PXkKQ09ORklHX1VTQl9HQURHRVRfVkJVU19EUkFXPTIKQ09ORklHX1VTQl9HQURHRVRfU0VMRUNU
RUQ9eQojIENPTkZJR19VU0JfR0FER0VUX0FUOTEgaXMgbm90IHNldAojIENPTkZJR19VU0JfR0FE
R0VUX0FUTUVMX1VTQkEgaXMgbm90IHNldAojIENPTkZJR19VU0JfR0FER0VUX0ZTTF9VU0IyIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX0dBREdFVF9MSDdBNDBYIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX0dBREdFVF9PTUFQIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dBREdFVF9QWEEyNVggaXMg
bm90IHNldAojIENPTkZJR19VU0JfR0FER0VUX1I4QTY2NTk3IGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX0dBREdFVF9QWEEyN1ggaXMgbm90IHNldAojIENPTkZJR19VU0JfR0FER0VUX1MzQ19IU09U
RyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HQURHRVRfSU1YIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX0dBREdFVF9TM0MyNDEwIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dBREdFVF9NNjY1OTIg
aXMgbm90IHNldAojIENPTkZJR19VU0JfR0FER0VUX0FNRDU1MzZVREMgaXMgbm90IHNldAojIENP
TkZJR19VU0JfR0FER0VUX0ZTTF9RRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HQURHRVRfQ0kx
M1hYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HQURHRVRfTkVUMjI4MCBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9HQURHRVRfR09LVSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HQURHRVRfTEFO
R1dFTEwgaXMgbm90IHNldAojIENPTkZJR19VU0JfR0FER0VUX0RVTU1ZX0hDRCBpcyBub3Qgc2V0
CkNPTkZJR19VU0JfR0FER0VUX0RVQUxTUEVFRD15CkNPTkZJR19VU0JfWkVSTz1tCiMgQ09ORklH
X1VTQl9aRVJPX0hOUFRFU1QgaXMgbm90IHNldAojIENPTkZJR19VU0JfQVVESU8gaXMgbm90IHNl
dAojIENPTkZJR19VU0JfRVRIIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0dBREdFVEZTIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX0ZVTkNUSU9ORlMgaXMgbm90IHNldApDT05GSUdfVVNCX0ZJTEVf
U1RPUkFHRT1tCiMgQ09ORklHX1VTQl9GSUxFX1NUT1JBR0VfVEVTVCBpcyBub3Qgc2V0CiMgQ09O
RklHX1VTQl9NQVNTX1NUT1JBR0UgaXMgbm90IHNldAojIENPTkZJR19VU0JfR19TRVJJQUwgaXMg
bm90IHNldAojIENPTkZJR19VU0JfTUlESV9HQURHRVQgaXMgbm90IHNldAojIENPTkZJR19VU0Jf
R19QUklOVEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NEQ19DT01QT1NJVEUgaXMgbm90IHNl
dApDT05GSUdfVVNCX0dfTk9LSUE9bQojIENPTkZJR19VU0JfR19NVUxUSSBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9HX0hJRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9HX1dFQkNBTSBpcyBub3Qg
c2V0CgojCiMgT1RHIGFuZCByZWxhdGVkIGluZnJhc3RydWN0dXJlCiMKQ09ORklHX1VTQl9PVEdf
VVRJTFM9eQojIENPTkZJR19VU0JfR1BJT19WQlVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSVNQMTMw
MV9PTUFQIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1VMUEkgaXMgbm90IHNldApDT05GSUdfVFdM
NDAzMF9VU0I9eQojIENPTkZJR19OT1BfVVNCX1hDRUlWIGlzIG5vdCBzZXQKQ09ORklHX01NQz1t
CiMgQ09ORklHX01NQ19ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX01NQ19VTlNBRkVfUkVTVU1F
IGlzIG5vdCBzZXQKCiMKIyBNTUMvU0QvU0RJTyBDYXJkIERyaXZlcnMKIwpDT05GSUdfTU1DX0JM
T0NLPW0KIyBDT05GSUdfTU1DX0JMT0NLX0JPVU5DRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NESU9f
VUFSVCBpcyBub3Qgc2V0CiMgQ09ORklHX01NQ19URVNUIGlzIG5vdCBzZXQKCiMKIyBNTUMvU0Qv
U0RJTyBIb3N0IENvbnRyb2xsZXIgRHJpdmVycwojCiMgQ09ORklHX01NQ19TREhDSSBpcyBub3Qg
c2V0CiMgQ09ORklHX01NQ19PTUFQIGlzIG5vdCBzZXQKQ09ORklHX01NQ19PTUFQX0hTPW0KIyBD
T05GSUdfTU1DX1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX01FTVNUSUNLIGlzIG5vdCBzZXQKQ09O
RklHX05FV19MRURTPXkKQ09ORklHX0xFRFNfQ0xBU1M9bQoKIwojIExFRCBkcml2ZXJzCiMKIyBD
T05GSUdfTEVEU19QQ0E5NTMyIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19HUElPIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTEVEU19MUDM5NDQgaXMgbm90IHNldAojIENPTkZJR19MRURTX1BDQTk1NVgg
aXMgbm90IHNldAojIENPTkZJR19MRURTX0RBQzEyNFMwODUgaXMgbm90IHNldAojIENPTkZJR19M
RURTX1JFR1VMQVRPUiBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfQkQyODAyIGlzIG5vdCBzZXQK
IyBDT05GSUdfTEVEU19MVDM1OTMgaXMgbm90IHNldAojIENPTkZJR19MRURTX1RSSUdHRVJTIGlz
IG5vdCBzZXQKIyBDT05GSUdfQUNDRVNTSUJJTElUWSBpcyBub3Qgc2V0CkNPTkZJR19SVENfTElC
PXkKQ09ORklHX1JUQ19DTEFTUz1tCgojCiMgUlRDIGludGVyZmFjZXMKIwpDT05GSUdfUlRDX0lO
VEZfU1lTRlM9eQpDT05GSUdfUlRDX0lOVEZfUFJPQz15CkNPTkZJR19SVENfSU5URl9ERVY9eQoj
IENPTkZJR19SVENfSU5URl9ERVZfVUlFX0VNVUwgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJW
X1RFU1QgaXMgbm90IHNldAoKIwojIEkyQyBSVEMgZHJpdmVycwojCiMgQ09ORklHX1JUQ19EUlZf
RFMxMzA3IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzEzNzQgaXMgbm90IHNldAojIENP
TkZJR19SVENfRFJWX0RTMTY3MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTUFYNjkwMCBp
cyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlM1QzM3MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JU
Q19EUlZfSVNMMTIwOCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfWDEyMDUgaXMgbm90IHNl
dAojIENPTkZJR19SVENfRFJWX1BDRjg1NjMgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1BD
Rjg1ODMgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX000MVQ4MCBpcyBub3Qgc2V0CiMgQ09O
RklHX1JUQ19EUlZfQlEzMksgaXMgbm90IHNldApDT05GSUdfUlRDX0RSVl9UV0w0MDMwPW0KIyBD
T05GSUdfUlRDX0RSVl9TMzUzOTBBIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9GTTMxMzAg
aXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1JYODU4MSBpcyBub3Qgc2V0CiMgQ09ORklHX1JU
Q19EUlZfUlg4MDI1IGlzIG5vdCBzZXQKCiMKIyBTUEkgUlRDIGRyaXZlcnMKIwojIENPTkZJR19S
VENfRFJWX000MVQ5NCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxMzA1IGlzIG5vdCBz
ZXQKIyBDT05GSUdfUlRDX0RSVl9EUzEzOTAgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX01B
WDY5MDIgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1I5NzAxIGlzIG5vdCBzZXQKIyBDT05G
SUdfUlRDX0RSVl9SUzVDMzQ4IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzMyMzQgaXMg
bm90IHNldAojIENPTkZJR19SVENfRFJWX1BDRjIxMjMgaXMgbm90IHNldAoKIwojIFBsYXRmb3Jt
IFJUQyBkcml2ZXJzCiMKIyBDT05GSUdfUlRDX0RSVl9DTU9TIGlzIG5vdCBzZXQKIyBDT05GSUdf
UlRDX0RSVl9EUzEyODYgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTUxMSBpcyBub3Qg
c2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxNTUzIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9E
UzE3NDIgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1NUSzE3VEE4IGlzIG5vdCBzZXQKIyBD
T05GSUdfUlRDX0RSVl9NNDhUODYgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX000OFQzNSBp
cyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTTQ4VDU5IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRD
X0RSVl9NU002MjQyIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9CUTQ4MDIgaXMgbm90IHNl
dAojIENPTkZJR19SVENfRFJWX1JQNUMwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfVjMw
MjAgaXMgbm90IHNldAoKIwojIG9uLUNQVSBSVEMgZHJpdmVycwojCiMgQ09ORklHX0RNQURFVklD
RVMgaXMgbm90IHNldAojIENPTkZJR19BVVhESVNQTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfVUlP
IGlzIG5vdCBzZXQKIyBDT05GSUdfU1RBR0lORyBpcyBub3Qgc2V0CgojCiMgQ0JVUyBzdXBwb3J0
CiMKIyBDT05GSUdfQ0JVUyBpcyBub3Qgc2V0CgojCiMgRmlsZSBzeXN0ZW1zCiMKQ09ORklHX0VY
VDJfRlM9bQojIENPTkZJR19FWFQyX0ZTX1hBVFRSIGlzIG5vdCBzZXQKIyBDT05GSUdfRVhUMl9G
U19YSVAgaXMgbm90IHNldApDT05GSUdfRVhUM19GUz1tCiMgQ09ORklHX0VYVDNfREVGQVVMVFNf
VE9fT1JERVJFRCBpcyBub3Qgc2V0CiMgQ09ORklHX0VYVDNfRlNfWEFUVFIgaXMgbm90IHNldAoj
IENPTkZJR19FWFQ0X0ZTIGlzIG5vdCBzZXQKQ09ORklHX0pCRD1tCiMgQ09ORklHX0pCRF9ERUJV
RyBpcyBub3Qgc2V0CiMgQ09ORklHX1JFSVNFUkZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSkZT
X0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfRlNfUE9TSVhfQUNMIGlzIG5vdCBzZXQKIyBDT05GSUdf
WEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfR0ZTMl9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX09D
RlMyX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQlRSRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19O
SUxGUzJfRlMgaXMgbm90IHNldApDT05GSUdfRklMRV9MT0NLSU5HPXkKQ09ORklHX0ZTTk9USUZZ
PXkKQ09ORklHX0ROT1RJRlk9eQpDT05GSUdfSU5PVElGWT15CkNPTkZJR19JTk9USUZZX1VTRVI9
eQpDT05GSUdfUVVPVEE9eQojIENPTkZJR19RVU9UQV9ORVRMSU5LX0lOVEVSRkFDRSBpcyBub3Qg
c2V0CkNPTkZJR19QUklOVF9RVU9UQV9XQVJOSU5HPXkKIyBDT05GSUdfUVVPVEFfREVCVUcgaXMg
bm90IHNldApDT05GSUdfUVVPVEFfVFJFRT15CiMgQ09ORklHX1FGTVRfVjEgaXMgbm90IHNldApD
T05GSUdfUUZNVF9WMj15CkNPTkZJR19RVU9UQUNUTD15CiMgQ09ORklHX0FVVE9GU19GUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FVVE9GUzRfRlMgaXMgbm90IHNldApDT05GSUdfRlVTRV9GUz1tCiMg
Q09ORklHX0NVU0UgaXMgbm90IHNldAoKIwojIENhY2hlcwojCiMgQ09ORklHX0ZTQ0FDSEUgaXMg
bm90IHNldAoKIwojIENELVJPTS9EVkQgRmlsZXN5c3RlbXMKIwojIENPTkZJR19JU085NjYwX0ZT
IGlzIG5vdCBzZXQKIyBDT05GSUdfVURGX0ZTIGlzIG5vdCBzZXQKCiMKIyBET1MvRkFUL05UIEZp
bGVzeXN0ZW1zCiMKQ09ORklHX0ZBVF9GUz1tCkNPTkZJR19NU0RPU19GUz1tCkNPTkZJR19WRkFU
X0ZTPW0KQ09ORklHX0ZBVF9ERUZBVUxUX0NPREVQQUdFPTQzNwpDT05GSUdfRkFUX0RFRkFVTFRf
SU9DSEFSU0VUPSJpc284ODU5LTEiCiMgQ09ORklHX05URlNfRlMgaXMgbm90IHNldAoKIwojIFBz
ZXVkbyBmaWxlc3lzdGVtcwojCkNPTkZJR19QUk9DX0ZTPXkKQ09ORklHX1BST0NfU1lTQ1RMPXkK
Q09ORklHX1BST0NfUEFHRV9NT05JVE9SPXkKQ09ORklHX1NZU0ZTPXkKQ09ORklHX1RNUEZTPXkK
IyBDT05GSUdfVE1QRlNfUE9TSVhfQUNMIGlzIG5vdCBzZXQKIyBDT05GSUdfSFVHRVRMQl9QQUdF
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ09ORklHRlNfRlMgaXMgbm90IHNldApDT05GSUdfTUlTQ19G
SUxFU1lTVEVNUz15CiMgQ09ORklHX0FERlNfRlMgaXMgbm90IHNldAojIENPTkZJR19BRkZTX0ZT
IGlzIG5vdCBzZXQKIyBDT05GSUdfSEZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSEZTUExVU19G
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0JFRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19CRlNfRlMg
aXMgbm90IHNldAojIENPTkZJR19FRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19KRkZTMl9GUyBp
cyBub3Qgc2V0CkNPTkZJR19VQklGU19GUz15CiMgQ09ORklHX1VCSUZTX0ZTX1hBVFRSIGlzIG5v
dCBzZXQKIyBDT05GSUdfVUJJRlNfRlNfQURWQU5DRURfQ09NUFIgaXMgbm90IHNldApDT05GSUdf
VUJJRlNfRlNfTFpPPXkKQ09ORklHX1VCSUZTX0ZTX1pMSUI9eQojIENPTkZJR19VQklGU19GU19E
RUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0xPR0ZTIGlzIG5vdCBzZXQKQ09ORklHX0NSQU1GUz15
CiMgQ09ORklHX1NRVUFTSEZTIGlzIG5vdCBzZXQKIyBDT05GSUdfVlhGU19GUyBpcyBub3Qgc2V0
CiMgQ09ORklHX01JTklYX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfT01GU19GUyBpcyBub3Qgc2V0
CiMgQ09ORklHX0hQRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19RTlg0RlNfRlMgaXMgbm90IHNl
dAojIENPTkZJR19ST01GU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NZU1ZfRlMgaXMgbm90IHNl
dAojIENPTkZJR19VRlNfRlMgaXMgbm90IHNldApDT05GSUdfTkVUV09SS19GSUxFU1lTVEVNUz15
CkNPTkZJR19ORlNfRlM9bQpDT05GSUdfTkZTX1YzPXkKIyBDT05GSUdfTkZTX1YzX0FDTCBpcyBu
b3Qgc2V0CkNPTkZJR19ORlNfVjQ9eQojIENPTkZJR19ORlNfVjRfMSBpcyBub3Qgc2V0CiMgQ09O
RklHX05GU0QgaXMgbm90IHNldApDT05GSUdfTE9DS0Q9bQpDT05GSUdfTE9DS0RfVjQ9eQpDT05G
SUdfTkZTX0NPTU1PTj15CkNPTkZJR19TVU5SUEM9bQpDT05GSUdfU1VOUlBDX0dTUz1tCkNPTkZJ
R19SUENTRUNfR1NTX0tSQjU9bQojIENPTkZJR19SUENTRUNfR1NTX1NQS00zIGlzIG5vdCBzZXQK
IyBDT05GSUdfU01CX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0VQSF9GUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0NJRlMgaXMgbm90IHNldAojIENPTkZJR19OQ1BfRlMgaXMgbm90IHNldAojIENPTkZJ
R19DT0RBX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQUZTX0ZTIGlzIG5vdCBzZXQKCiMKIyBQYXJ0
aXRpb24gVHlwZXMKIwpDT05GSUdfUEFSVElUSU9OX0FEVkFOQ0VEPXkKIyBDT05GSUdfQUNPUk5f
UEFSVElUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfT1NGX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMg
Q09ORklHX0FNSUdBX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0FUQVJJX1BBUlRJVElP
TiBpcyBub3Qgc2V0CiMgQ09ORklHX01BQ19QQVJUSVRJT04gaXMgbm90IHNldApDT05GSUdfTVNE
T1NfUEFSVElUSU9OPXkKIyBDT05GSUdfQlNEX0RJU0tMQUJFTCBpcyBub3Qgc2V0CiMgQ09ORklH
X01JTklYX1NVQlBBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NPTEFSSVNfWDg2X1BBUlRJ
VElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1VOSVhXQVJFX0RJU0tMQUJFTCBpcyBub3Qgc2V0CiMg
Q09ORklHX0xETV9QQVJUSVRJT04gaXMgbm90IHNldAojIENPTkZJR19TR0lfUEFSVElUSU9OIGlz
IG5vdCBzZXQKIyBDT05GSUdfVUxUUklYX1BBUlRJVElPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NV
Tl9QQVJUSVRJT04gaXMgbm90IHNldAojIENPTkZJR19LQVJNQV9QQVJUSVRJT04gaXMgbm90IHNl
dAojIENPTkZJR19FRklfUEFSVElUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lTVjY4X1BBUlRJ
VElPTiBpcyBub3Qgc2V0CkNPTkZJR19OTFM9eQpDT05GSUdfTkxTX0RFRkFVTFQ9Imlzbzg4NTkt
MSIKQ09ORklHX05MU19DT0RFUEFHRV80Mzc9eQojIENPTkZJR19OTFNfQ09ERVBBR0VfNzM3IGlz
IG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzc3NSBpcyBub3Qgc2V0CiMgQ09ORklHX05M
U19DT0RFUEFHRV84NTAgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODUyIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1NSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19D
T0RFUEFHRV84NTcgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODYwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RF
UEFHRV84NjIgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODYzIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkxTX0NPREVQQUdFXzg2NCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFH
RV84NjUgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODY2IGlzIG5vdCBzZXQKIyBD
T05GSUdfTkxTX0NPREVQQUdFXzg2OSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV85
MzYgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTUwIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkxTX0NPREVQQUdFXzkzMiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV85NDkg
aXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODc0IGlzIG5vdCBzZXQKIyBDT05GSUdf
TkxTX0lTTzg4NTlfOCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV8xMjUwIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzEyNTEgaXMgbm90IHNldAojIENPTkZJR19OTFNf
QVNDSUkgaXMgbm90IHNldApDT05GSUdfTkxTX0lTTzg4NTlfMT15CiMgQ09ORklHX05MU19JU084
ODU5XzIgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV8zIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkxTX0lTTzg4NTlfNCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzUgaXMgbm90
IHNldAojIENPTkZJR19OTFNfSVNPODg1OV82IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4
NTlfNyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzkgaXMgbm90IHNldAojIENPTkZJ
R19OTFNfSVNPODg1OV8xMyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5XzE0IGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMTUgaXMgbm90IHNldAojIENPTkZJR19OTFNfS09J
OF9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0tPSThfVSBpcyBub3Qgc2V0CiMgQ09ORklHX05M
U19VVEY4IGlzIG5vdCBzZXQKIyBDT05GSUdfRExNIGlzIG5vdCBzZXQKCiMKIyBLZXJuZWwgaGFj
a2luZwojCkNPTkZJR19QUklOVEtfVElNRT15CkNPTkZJR19FTkFCTEVfV0FSTl9ERVBSRUNBVEVE
PXkKQ09ORklHX0VOQUJMRV9NVVNUX0NIRUNLPXkKQ09ORklHX0ZSQU1FX1dBUk49MTAyNApDT05G
SUdfTUFHSUNfU1lTUlE9eQojIENPTkZJR19TVFJJUF9BU01fU1lNUyBpcyBub3Qgc2V0CiMgQ09O
RklHX1VOVVNFRF9TWU1CT0xTIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX0ZTPXkKIyBDT05GSUdf
SEVBREVSU19DSEVDSyBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19LRVJORUw9eQojIENPTkZJR19E
RUJVR19TSElSUSBpcyBub3Qgc2V0CkNPTkZJR19ERVRFQ1RfU09GVExPQ0tVUD15CiMgQ09ORklH
X0JPT1RQQVJBTV9TT0ZUTE9DS1VQX1BBTklDIGlzIG5vdCBzZXQKQ09ORklHX0JPT1RQQVJBTV9T
T0ZUTE9DS1VQX1BBTklDX1ZBTFVFPTAKQ09ORklHX0RFVEVDVF9IVU5HX1RBU0s9eQojIENPTkZJ
R19CT09UUEFSQU1fSFVOR19UQVNLX1BBTklDIGlzIG5vdCBzZXQKQ09ORklHX0JPT1RQQVJBTV9I
VU5HX1RBU0tfUEFOSUNfVkFMVUU9MApDT05GSUdfU0NIRURfREVCVUc9eQojIENPTkZJR19TQ0hF
RFNUQVRTIGlzIG5vdCBzZXQKQ09ORklHX1RJTUVSX1NUQVRTPXkKIyBDT05GSUdfREVCVUdfT0JK
RUNUUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1NMQUIgaXMgbm90IHNldAojIENPTkZJR19E
RUJVR19LTUVNTEVBSyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1JUX01VVEVYRVMgaXMgbm90
IHNldAojIENPTkZJR19SVF9NVVRFWF9URVNURVIgaXMgbm90IHNldApDT05GSUdfREVCVUdfU1BJ
TkxPQ0s9eQpDT05GSUdfREVCVUdfTVVURVhFUz15CkNPTkZJR19ERUJVR19MT0NLX0FMTE9DPXkK
Q09ORklHX1BST1ZFX0xPQ0tJTkc9eQojIENPTkZJR19QUk9WRV9SQ1UgaXMgbm90IHNldApDT05G
SUdfTE9DS0RFUD15CkNPTkZJR19MT0NLX1NUQVQ9eQojIENPTkZJR19ERUJVR19MT0NLREVQIGlz
IG5vdCBzZXQKQ09ORklHX1RSQUNFX0lSUUZMQUdTPXkKQ09ORklHX0RFQlVHX1NQSU5MT0NLX1NM
RUVQPXkKIyBDT05GSUdfREVCVUdfTE9DS0lOR19BUElfU0VMRlRFU1RTIGlzIG5vdCBzZXQKQ09O
RklHX1NUQUNLVFJBQ0U9eQojIENPTkZJR19ERUJVR19LT0JKRUNUIGlzIG5vdCBzZXQKIyBDT05G
SUdfREVCVUdfQlVHVkVSQk9TRSBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19JTkZPPXkKIyBDT05G
SUdfREVCVUdfVk0gaXMgbm90IHNldAojIENPTkZJR19ERUJVR19XUklURUNPVU5UIGlzIG5vdCBz
ZXQKIyBDT05GSUdfREVCVUdfTUVNT1JZX0lOSVQgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19M
SVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfU0cgaXMgbm90IHNldAojIENPTkZJR19ERUJV
R19OT1RJRklFUlMgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19DUkVERU5USUFMUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0JPT1RfUFJJTlRLX0RFTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfUkNVX1RP
UlRVUkVfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1JDVV9DUFVfU1RBTExfREVURUNUT1IgaXMg
bm90IHNldAojIENPTkZJR19LUFJPQkVTX1NBTklUWV9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdf
QkFDS1RSQUNFX1NFTEZfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0JMT0NLX0VYVF9E
RVZUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfRk9SQ0VfV0VBS19QRVJfQ1BVIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTEtEVE0gaXMgbm90IHNldAojIENPTkZJR19GQVVMVF9JTkpFQ1RJT04gaXMg
bm90IHNldAojIENPTkZJR19MQVRFTkNZVE9QIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lTQ1RMX1NZ
U0NBTExfQ0hFQ0sgaXMgbm90IHNldAojIENPTkZJR19QQUdFX1BPSVNPTklORyBpcyBub3Qgc2V0
CkNPTkZJR19IQVZFX0ZVTkNUSU9OX1RSQUNFUj15CkNPTkZJR19UUkFDSU5HX1NVUFBPUlQ9eQpD
T05GSUdfRlRSQUNFPXkKIyBDT05GSUdfRlVOQ1RJT05fVFJBQ0VSIGlzIG5vdCBzZXQKIyBDT05G
SUdfSVJRU09GRl9UUkFDRVIgaXMgbm90IHNldAojIENPTkZJR19TQ0hFRF9UUkFDRVIgaXMgbm90
IHNldAojIENPTkZJR19FTkFCTEVfREVGQVVMVF9UUkFDRVJTIGlzIG5vdCBzZXQKIyBDT05GSUdf
Qk9PVF9UUkFDRVIgaXMgbm90IHNldApDT05GSUdfQlJBTkNIX1BST0ZJTEVfTk9ORT15CiMgQ09O
RklHX1BST0ZJTEVfQU5OT1RBVEVEX0JSQU5DSEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPRklM
RV9BTExfQlJBTkNIRVMgaXMgbm90IHNldAojIENPTkZJR19TVEFDS19UUkFDRVIgaXMgbm90IHNl
dAojIENPTkZJR19LTUVNVFJBQ0UgaXMgbm90IHNldAojIENPTkZJR19XT1JLUVVFVUVfVFJBQ0VS
IGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9JT19UUkFDRSBpcyBub3Qgc2V0CiMgQ09ORklH
X0RZTkFNSUNfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19BVE9NSUM2NF9TRUxGVEVTVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NBTVBMRVMgaXMgbm90IHNldApDT05GSUdfSEFWRV9BUkNIX0tHREI9
eQojIENPTkZJR19LR0RCIGlzIG5vdCBzZXQKQ09ORklHX0FSTV9VTldJTkQ9eQojIENPTkZJR19E
RUJVR19VU0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfRVJST1JTIGlzIG5vdCBzZXQKIyBD
T05GSUdfREVCVUdfU1RBQ0tfVVNBR0UgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19MTCBpcyBu
b3Qgc2V0CiMgQ09ORklHX09DX0VUTSBpcyBub3Qgc2V0CgojCiMgU2VjdXJpdHkgb3B0aW9ucwoj
CiMgQ09ORklHX0tFWVMgaXMgbm90IHNldApDT05GSUdfU0VDVVJJVFk9eQojIENPTkZJR19TRUNV
UklUWUZTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VDVVJJVFlfTkVUV09SSyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFQ1VSSVRZX1BBVEggaXMgbm90IHNldAojIENPTkZJR19TRUNVUklUWV9UT01PWU8g
aXMgbm90IHNldAojIENPTkZJR19JTUEgaXMgbm90IHNldAojIENPTkZJR19ERUZBVUxUX1NFQ1VS
SVRZX1NFTElOVVggaXMgbm90IHNldAojIENPTkZJR19ERUZBVUxUX1NFQ1VSSVRZX1NNQUNLIGlz
IG5vdCBzZXQKIyBDT05GSUdfREVGQVVMVF9TRUNVUklUWV9UT01PWU8gaXMgbm90IHNldApDT05G
SUdfREVGQVVMVF9TRUNVUklUWV9EQUM9eQpDT05GSUdfREVGQVVMVF9TRUNVUklUWT0iIgpDT05G
SUdfQ1JZUFRPPXkKCiMKIyBDcnlwdG8gY29yZSBvciBoZWxwZXIKIwpDT05GSUdfQ1JZUFRPX0FM
R0FQST15CkNPTkZJR19DUllQVE9fQUxHQVBJMj15CkNPTkZJR19DUllQVE9fQUVBRDI9eQpDT05G
SUdfQ1JZUFRPX0JMS0NJUEhFUj15CkNPTkZJR19DUllQVE9fQkxLQ0lQSEVSMj15CkNPTkZJR19D
UllQVE9fSEFTSD15CkNPTkZJR19DUllQVE9fSEFTSDI9eQpDT05GSUdfQ1JZUFRPX1JORzI9eQpD
T05GSUdfQ1JZUFRPX1BDT01QPXkKQ09ORklHX0NSWVBUT19NQU5BR0VSPXkKQ09ORklHX0NSWVBU
T19NQU5BR0VSMj15CiMgQ09ORklHX0NSWVBUT19HRjEyOE1VTCBpcyBub3Qgc2V0CiMgQ09ORklH
X0NSWVBUT19OVUxMIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19XT1JLUVVFVUU9eQojIENPTkZJ
R19DUllQVE9fQ1JZUFREIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0FVVEhFTkMgaXMgbm90
IHNldAojIENPTkZJR19DUllQVE9fVEVTVCBpcyBub3Qgc2V0CgojCiMgQXV0aGVudGljYXRlZCBF
bmNyeXB0aW9uIHdpdGggQXNzb2NpYXRlZCBEYXRhCiMKIyBDT05GSUdfQ1JZUFRPX0NDTSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NSWVBUT19HQ00gaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fU0VR
SVYgaXMgbm90IHNldAoKIwojIEJsb2NrIG1vZGVzCiMKQ09ORklHX0NSWVBUT19DQkM9eQojIENP
TkZJR19DUllQVE9fQ1RSIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0NUUyBpcyBub3Qgc2V0
CkNPTkZJR19DUllQVE9fRUNCPXkKIyBDT05GSUdfQ1JZUFRPX0xSVyBpcyBub3Qgc2V0CkNPTkZJ
R19DUllQVE9fUENCQz1tCiMgQ09ORklHX0NSWVBUT19YVFMgaXMgbm90IHNldAoKIwojIEhhc2gg
bW9kZXMKIwojIENPTkZJR19DUllQVE9fSE1BQyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19Y
Q0JDIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1ZNQUMgaXMgbm90IHNldAoKIwojIERpZ2Vz
dAojCkNPTkZJR19DUllQVE9fQ1JDMzJDPXkKIyBDT05GSUdfQ1JZUFRPX0dIQVNIIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ1JZUFRPX01ENCBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fTUQ1PXkKIyBD
T05GSUdfQ1JZUFRPX01JQ0hBRUxfTUlDIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1JNRDEy
OCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19STUQxNjAgaXMgbm90IHNldAojIENPTkZJR19D
UllQVE9fUk1EMjU2IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1JNRDMyMCBpcyBub3Qgc2V0
CiMgQ09ORklHX0NSWVBUT19TSEExIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NIQTI1NiBp
cyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19TSEE1MTIgaXMgbm90IHNldAojIENPTkZJR19DUllQ
VE9fVEdSMTkyIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1dQNTEyIGlzIG5vdCBzZXQKCiMK
IyBDaXBoZXJzCiMKQ09ORklHX0NSWVBUT19BRVM9eQojIENPTkZJR19DUllQVE9fQU5VQklTIGlz
IG5vdCBzZXQKQ09ORklHX0NSWVBUT19BUkM0PXkKIyBDT05GSUdfQ1JZUFRPX0JMT1dGSVNIIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0NBTUVMTElBIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZ
UFRPX0NBU1Q1IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0NBU1Q2IGlzIG5vdCBzZXQKQ09O
RklHX0NSWVBUT19ERVM9eQojIENPTkZJR19DUllQVE9fRkNSWVBUIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ1JZUFRPX0tIQVpBRCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19TQUxTQTIwIGlzIG5v
dCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NFRUQgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fU0VS
UEVOVCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19URUEgaXMgbm90IHNldAojIENPTkZJR19D
UllQVE9fVFdPRklTSCBpcyBub3Qgc2V0CgojCiMgQ29tcHJlc3Npb24KIwpDT05GSUdfQ1JZUFRP
X0RFRkxBVEU9eQojIENPTkZJR19DUllQVE9fWkxJQiBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9f
TFpPPXkKCiMKIyBSYW5kb20gTnVtYmVyIEdlbmVyYXRpb24KIwojIENPTkZJR19DUllQVE9fQU5T
SV9DUFJORyBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fSFc9eQojIENPTkZJR19DUllQVE9fREVW
X09NQVBfU0hBTSBpcyBub3Qgc2V0CiMgQ09ORklHX0JJTkFSWV9QUklOVEYgaXMgbm90IHNldAoK
IwojIExpYnJhcnkgcm91dGluZXMKIwpDT05GSUdfQklUUkVWRVJTRT15CkNPTkZJR19HRU5FUklD
X0ZJTkRfTEFTVF9CSVQ9eQpDT05GSUdfQ1JDX0NDSVRUPXkKQ09ORklHX0NSQzE2PXkKIyBDT05G
SUdfQ1JDX1QxMERJRiBpcyBub3Qgc2V0CiMgQ09ORklHX0NSQ19JVFVfVCBpcyBub3Qgc2V0CkNP
TkZJR19DUkMzMj15CkNPTkZJR19DUkM3PW0KQ09ORklHX0xJQkNSQzMyQz15CkNPTkZJR19aTElC
X0lORkxBVEU9eQpDT05GSUdfWkxJQl9ERUZMQVRFPXkKQ09ORklHX0xaT19DT01QUkVTUz15CkNP
TkZJR19MWk9fREVDT01QUkVTUz15CkNPTkZJR19ERUNPTVBSRVNTX0daSVA9eQpDT05GSUdfSEFT
X0lPTUVNPXkKQ09ORklHX0hBU19JT1BPUlQ9eQpDT05GSUdfSEFTX0RNQT15CkNPTkZJR19IQVZF
X0xNQj15CkNPTkZJR19OTEFUVFI9eQo=

--_002_A24693684029E5489D1D202277BE894456225272dlee02entticom_--
