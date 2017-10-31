Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53469 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753342AbdJaQE0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 12:04:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guru Das Srinagesh <gurooodas@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        Paolo Cretaro <melko@frugalware.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        Joe Perches <joe@perches.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        Aishwarya Pant <aishpant@gmail.com>,
        Srishti Sharma <srishtishar@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 0/7] Shut up several smatch warnings with atomisp
Date: Tue, 31 Oct 2017 12:04:13 -0400
Message-Id: <cover.1509465351.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The atomisp alone produces a way more warnings with smatch than all other
media drivers.  That prevents me to identify what's wrong on other drivers.

Cleanup the no-brain ones, in order to reduce the list to something that
would be easier to handle.

Still, after this series, we have several smatch warnings, and some seem to
indicate real issues:

$ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y C=1 W=1 CHECK='/devel/smatch/smatch -p=kernel' M=drivers/staging/media
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/queue/src/queue.c:127 ia_css_queue_enqueue() internal error: sval_binop_signed: MOD by zero
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/queue/src/queue.c:185 ia_css_queue_dequeue() internal error: sval_binop_signed: MOD by zero
drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:421 gmin_v1p2_ctrl() error: we previously assumed 'gs' could be null (see line 419)
drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:455 gmin_v1p8_ctrl() error: we previously assumed 'gs' could be null (see line 453)
drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:491 gmin_v2p8_ctrl() error: we previously assumed 'gs' could be null (see line 489)
drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:667 gmin_get_config_var() warn: impossible condition '(*out_len > (~0)) => (0-u32max > u32max)'
drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/vf/vf_1.0/ia_css_vf.host.c:133 ia_css_vf_configure() warn: variable dereferenced before check 'binary' (see line 129)
drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/output/output_1.0/ia_css_output.host.c:64 ia_css_output_config() warn: variable dereferenced before check 'from->info' (see line 63)
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1445 sh_css_update_host2sp_offline_frame() error: uninitialized symbol 'HIVE_ADDR_host_sp_com'.
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1476 sh_css_update_host2sp_mipi_frame() error: uninitialized symbol 'HIVE_ADDR_host_sp_com'.
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1503 sh_css_update_host2sp_mipi_metadata() error: uninitialized symbol 'HIVE_ADDR_host_sp_com'.
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1523 sh_css_update_host2sp_num_mipi_frames() error: uninitialized symbol 'HIVE_ADDR_host_sp_com'.
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1542 sh_css_update_host2sp_cont_num_raw_frames() error: uninitialized symbol 'HIVE_ADDR_host_sp_com'.
drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/debug/src/ia_css_debug.c:3017 ia_css_debug_pipe_graph_dump_sp_raw_copy() warn: argument 4 to %08lx specifier is cast from pointer
drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h:24:26: warning: function 'mmu_reg_store' with external linkage has definition
drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/mmu_private.h:35:30: warning: function 'mmu_reg_load' with external linkage has definition
drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c:164 ia_css_eed1_8_vmem_encode() warn: assigning (-8192) to unsigned variable 'to->e_dew_enh_y[0][base + j]'
drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c:168 ia_css_eed1_8_vmem_encode() warn: assigning (-8192) to unsigned variable 'to->e_dew_enh_a[0][base + j]'
drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/input_system.c:907 input_system_configure_channel() error: buffer overflow 'config.input_switch_cfg.hsync_data_reg' 8 <= 8
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:3808 sh_css_param_update_isp_params() error: uninitialized symbol 'stage'.
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:4155 sh_css_params_write_to_ddr_internal() warn: '((-(1 << ((14 - 1)))))' 4294959104 can't fit into 32767 'converted_macc_table.data[idx]'
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:4158 sh_css_params_write_to_ddr_internal() warn: '((-(1 << ((14 - 1)))))' 4294959104 can't fit into 32767 'converted_macc_table.data[idx + 1]'
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:4161 sh_css_params_write_to_ddr_internal() warn: '((-(1 << ((14 - 1)))))' 4294959104 can't fit into 32767 'converted_macc_table.data[idx + 2]'
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:4164 sh_css_params_write_to_ddr_internal() warn: '((-(1 << ((14 - 1)))))' 4294959104 can't fit into 32767 'converted_macc_table.data[idx + 3]'
drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c:324 __bo_take_off_handling() error: we previously assumed 'bo->prev' could be null (see line 297)
drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c:776 atomisp_open() error: strncmp() '"ATOMISP ISP ACC"' too small (16 vs 32)
drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c:913 atomisp_release() error: strncmp() '"ATOMISP ISP ACC"' too small (16 vs 32)
drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2746 atomisp_vidioc_default() error: strncmp() '"ATOMISP ISP ACC"' too small (16 vs 32)
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:8094 create_host_regular_capture_pipeline() error: uninitialized symbol 'frm'.



Mauro Carvalho Chehab (7):
  media: atomisp: fix ident for assert/return
  media: atomisp: fix spatch warnings at sh_css.c
  media: atomisp: fix switch coding style at input_system.c
  media: atomisp: fix other inconsistent identing
  media: atomisp: get rid of wrong stddef.h include
  media: atomisp: get rid of storage_class.h
  media: atomisp: make function calls cleaner

 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c |  8 +-
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      |  4 +-
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |  6 +-
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |  2 +-
 .../base/circbuf/interface/ia_css_circbuf.h        | 39 +++++-----
 .../base/circbuf/interface/ia_css_circbuf_desc.h   | 15 ++--
 .../pci/atomisp2/css2400/camera/util/src/util.c    |  2 +-
 .../css_2401_csi2p_system/host/csi_rx_private.h    | 18 ++---
 .../css2400/hive_isp_css_common/host/dma.c         |  2 +-
 .../hive_isp_css_common/host/event_fifo_private.h  |  2 +-
 .../hive_isp_css_common/host/fifo_monitor.c        |  8 +-
 .../host/fifo_monitor_private.h                    | 28 +++----
 .../css2400/hive_isp_css_common/host/gdc.c         | 16 ++--
 .../css2400/hive_isp_css_common/host/gp_device.c   |  2 +-
 .../hive_isp_css_common/host/gp_device_private.h   | 16 ++--
 .../hive_isp_css_common/host/gpio_private.h        |  4 +-
 .../hive_isp_css_common/host/hmem_private.h        |  4 +-
 .../host/input_formatter_private.h                 | 16 ++--
 .../hive_isp_css_common/host/input_system.c        | 80 +++++++++----------
 .../host/input_system_private.h                    | 64 +++++++--------
 .../css2400/hive_isp_css_common/host/irq.c         | 42 +++++-----
 .../css2400/hive_isp_css_common/host/irq_private.h | 12 +--
 .../css2400/hive_isp_css_common/host/isp.c         |  4 +-
 .../css2400/hive_isp_css_common/host/mmu.c         |  6 +-
 .../css2400/hive_isp_css_common/host/mmu_private.h | 12 +--
 .../css2400/hive_isp_css_common/host/sp_private.h  | 60 +++++++-------
 .../css2400/hive_isp_css_include/assert_support.h  |  3 +-
 .../atomisp2/css2400/hive_isp_css_include/bamem.h  |  7 +-
 .../atomisp2/css2400/hive_isp_css_include/csi_rx.h |  5 --
 .../atomisp2/css2400/hive_isp_css_include/debug.h  |  7 +-
 .../atomisp2/css2400/hive_isp_css_include/dma.h    |  7 +-
 .../css2400/hive_isp_css_include/event_fifo.h      |  7 +-
 .../css2400/hive_isp_css_include/fifo_monitor.h    |  7 +-
 .../css2400/hive_isp_css_include/gdc_device.h      |  7 +-
 .../css2400/hive_isp_css_include/gp_device.h       |  7 +-
 .../css2400/hive_isp_css_include/gp_timer.h        |  7 +-
 .../atomisp2/css2400/hive_isp_css_include/gpio.h   |  7 +-
 .../atomisp2/css2400/hive_isp_css_include/hmem.h   |  7 +-
 .../hive_isp_css_include/host/csi_rx_public.h      | 18 ++---
 .../css2400/hive_isp_css_include/host/gdc_public.h |  6 +-
 .../hive_isp_css_include/host/hmem_public.h        |  4 +-
 .../css2400/hive_isp_css_include/host/isp_op1w.h   |  9 +--
 .../css2400/hive_isp_css_include/host/isp_op2w.h   |  9 +--
 .../css2400/hive_isp_css_include/host/mmu_public.h |  8 +-
 .../hive_isp_css_include/host/ref_vector_func.h    |  9 +--
 .../css2400/hive_isp_css_include/ibuf_ctrl.h       |  7 +-
 .../css2400/hive_isp_css_include/input_formatter.h |  7 +-
 .../css2400/hive_isp_css_include/input_system.h    |  7 +-
 .../atomisp2/css2400/hive_isp_css_include/irq.h    |  7 +-
 .../atomisp2/css2400/hive_isp_css_include/isp.h    |  7 +-
 .../css2400/hive_isp_css_include/isys_dma.h        |  7 +-
 .../css2400/hive_isp_css_include/isys_irq.h        |  9 +--
 .../hive_isp_css_include/isys_stream2mmio.h        |  7 +-
 .../css2400/hive_isp_css_include/math_support.h    | 25 +++---
 .../css2400/hive_isp_css_include/mmu_device.h      |  7 +-
 .../atomisp2/css2400/hive_isp_css_include/mpmath.h |  9 +--
 .../atomisp2/css2400/hive_isp_css_include/osys.h   |  7 +-
 .../css2400/hive_isp_css_include/pixelgen.h        |  7 +-
 .../hive_isp_css_include/platform_support.h        |  1 -
 .../css2400/hive_isp_css_include/print_support.h   |  3 +-
 .../atomisp2/css2400/hive_isp_css_include/queue.h  |  7 +-
 .../css2400/hive_isp_css_include/resource.h        |  7 +-
 .../atomisp2/css2400/hive_isp_css_include/socket.h |  7 +-
 .../pci/atomisp2/css2400/hive_isp_css_include/sp.h |  7 +-
 .../css2400/hive_isp_css_include/storage_class.h   | 34 --------
 .../css2400/hive_isp_css_include/stream_buffer.h   |  7 +-
 .../css2400/hive_isp_css_include/string_support.h  |  7 +-
 .../atomisp2/css2400/hive_isp_css_include/tag.h    |  7 +-
 .../css2400/hive_isp_css_include/timed_ctrl.h      |  7 +-
 .../css2400/hive_isp_css_include/type_support.h    | 42 ----------
 .../atomisp2/css2400/hive_isp_css_include/vamem.h  |  7 +-
 .../css2400/hive_isp_css_include/vector_func.h     |  7 +-
 .../css2400/hive_isp_css_include/vector_ops.h      |  7 +-
 .../atomisp2/css2400/hive_isp_css_include/vmem.h   |  7 +-
 .../atomisp2/css2400/hive_isp_css_include/xmem.h   |  7 +-
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c      |  2 +-
 .../atomisp2/css2400/runtime/binary/src/binary.c   | 12 +--
 .../pci/atomisp2/css2400/runtime/bufq/src/bufq.c   |  2 +-
 .../css2400/runtime/debug/interface/ia_css_debug.h |  2 +-
 .../css2400/runtime/inputfifo/src/inputfifo.c      | 28 +++----
 .../css2400/runtime/pipeline/src/pipeline.c        |  2 +-
 .../css2400/runtime/rmgr/interface/ia_css_rmgr.h   |  7 +-
 .../atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c  |  2 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 91 +++++++++++-----------
 .../atomisp/pci/atomisp2/css2400/sh_css_hrt.c      |  2 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_internal.h |  4 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   | 48 ++++++------
 drivers/staging/media/imx/imx-media-capture.c      |  2 +-
 88 files changed, 490 insertions(+), 611 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/storage_class.h

-- 
2.13.6
