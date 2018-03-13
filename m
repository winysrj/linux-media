Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50424 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751965AbeCMIbh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 04:31:37 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id F0C1E600E8
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 10:31:34 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1evfLK-0005M8-52
        for linux-media@vger.kernel.org; Tue, 13 Mar 2018 10:31:34 +0200
Date: Tue, 13 Mar 2018 10:31:33 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.17] Pile of atomisp patches
Message-ID: <20180313083133.cqcpkri7ejl3sikj@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the usual pile of atomisp driver patches. Along with the usual
cleanups, there's a fix that disables atomisp_compat_ioctl32 as well.


The following changes since commit 3f127ce11353fd1071cae9b65bc13add6aec6b90:

  media: em28xx-cards: fix em28xx_duplicate_dev() (2018-03-08 06:06:51 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git atomisp

for you to fetch changes up to f105c0b9eae0646ed6d05e6a56a29bb1461e6b9f:

  staging: media: Replace "cant" with "can't" (2018-03-09 10:56:05 +0200)

----------------------------------------------------------------
Alona Solntseva (1):
      drivers: staging: media: atomisp: pci: atomisp2: css2400: fix misspellings

Arnd Bergmann (1):
      staging: media: atomisp: remove pointless string copy

Arushi Singhal (1):
      staging: media: Replace "cant" with "can't"

Colin Ian King (1):
      media: staging: atomisp: remove redundant assignments to various variables

Corentin Labbe (3):
      staging: media: remove remains of VIDEO_ATOMISP_OV8858
      staging: media: atomisp2: remove unused headers
      staging: media: atomisp: Remove inclusion of non-existing directories

Hans Verkuil (1):
      atomisp_fops.c: disable atomisp_compat_ioctl32

Jeremy Sowden (1):
      media: atomisp: convert default struct values to use compound-literals with designated initializers.

 drivers/staging/media/atomisp/i2c/Kconfig          |   12 -
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      |    2 +-
 drivers/staging/media/atomisp/i2c/ov8858.c         | 2169 --------------------
 drivers/staging/media/atomisp/i2c/ov8858.h         | 1474 -------------
 drivers/staging/media/atomisp/i2c/ov8858_btns.h    | 1276 ------------
 .../media/atomisp/include/linux/vlv2_plat_clock.h  |   30 -
 .../staging/media/atomisp/pci/atomisp2/Makefile    |   10 -
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |    2 +-
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |    2 +-
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      |    6 +
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |    1 -
 .../css2400/css_2400_system/hrt/gp_regs_defs.h     |   22 -
 .../atomisp2/css2400/css_2400_system/hrt/sp_hrt.h  |   24 -
 .../css_2401_csi2p_system/hrt/gp_regs_defs.h       |   22 -
 .../css2400/css_2401_csi2p_system/hrt/sp_hrt.h     |   24 -
 .../css2400/css_2401_system/hrt/gp_regs_defs.h     |   22 -
 .../atomisp2/css2400/css_2401_system/hrt/sp_hrt.h  |   24 -
 .../atomisp/pci/atomisp2/css2400/css_api_version.h |  673 ------
 .../host/hive_isp_css_ddr_hrt_modified.h           |  148 --
 .../host/hive_isp_css_hrt_modified.h               |   79 -
 .../hive_isp_css_common/input_formatter_global.h   |   16 -
 .../css2400/hive_isp_css_common/resource_global.h  |   35 -
 .../css2400/hive_isp_css_common/xmem_global.h      |   20 -
 .../atomisp2/css2400/hive_isp_css_include/bamem.h  |   46 -
 .../css2400/hive_isp_css_include/bbb_config.h      |   27 -
 .../css2400/hive_isp_css_include/cpu_mem_support.h |   59 -
 .../hive_isp_css_include/host/isp2400_config.h     |   24 -
 .../hive_isp_css_include/host/isp2500_config.h     |   29 -
 .../hive_isp_css_include/host/isp2600_config.h     |   34 -
 .../hive_isp_css_include/host/isp2601_config.h     |   70 -
 .../css2400/hive_isp_css_include/host/isp_config.h |   24 -
 .../css2400/hive_isp_css_include/host/isp_op1w.h   |  844 --------
 .../hive_isp_css_include/host/isp_op1w_types.h     |   54 -
 .../css2400/hive_isp_css_include/host/isp_op2w.h   |  674 ------
 .../hive_isp_css_include/host/isp_op2w_types.h     |   49 -
 .../hive_isp_css_include/host/isp_op_count.h       |  226 --
 .../hive_isp_css_include/host/osys_public.h        |   20 -
 .../hive_isp_css_include/host/pipeline_public.h    |   18 -
 .../hive_isp_css_include/host/ref_vector_func.h    | 1221 -----------
 .../host/ref_vector_func_types.h                   |  385 ----
 .../atomisp2/css2400/hive_isp_css_include/mpmath.h |  329 ---
 .../atomisp2/css2400/hive_isp_css_include/osys.h   |   47 -
 .../css2400/hive_isp_css_include/stream_buffer.h   |   47 -
 .../css2400/hive_isp_css_include/vector_func.h     |   38 -
 .../css2400/hive_isp_css_include/vector_ops.h      |   31 -
 .../atomisp2/css2400/hive_isp_css_include/xmem.h   |   46 -
 .../css2400/hive_isp_css_shared/socket_global.h    |   53 -
 .../hive_isp_css_shared/stream_buffer_global.h     |   26 -
 .../pci/atomisp2/css2400/ia_css_frame_public.h     |   29 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_pipe.h     |  113 +-
 .../pci/atomisp2/css2400/ia_css_pipe_public.h      |  108 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_types.h    |   64 +-
 .../css2400/isp/kernels/aa/aa_2/ia_css_aa2_state.h |   41 -
 .../bayer_ls_1.0/ia_css_bayer_load_param.h         |   20 -
 .../bayer_ls/bayer_ls_1.0/ia_css_bayer_ls_param.h  |   42 -
 .../bayer_ls_1.0/ia_css_bayer_store_param.h        |   21 -
 .../css2400/isp/kernels/bnlm/ia_css_bnlm_state.h   |   31 -
 .../isp/kernels/cnr/cnr_1.0/ia_css_cnr_state.h     |   33 -
 .../isp/kernels/cnr/cnr_2/ia_css_cnr_state.h       |   33 -
 .../isp/kernels/dp/dp_1.0/ia_css_dp_state.h        |   36 -
 .../css2400/isp/kernels/dpc2/ia_css_dpc2_state.h   |   30 -
 .../isp/kernels/eed1_8/ia_css_eed1_8_state.h       |   40 -
 .../io_ls/plane_io_ls/ia_css_plane_io_param.h      |   22 -
 .../io_ls/plane_io_ls/ia_css_plane_io_types.h      |   30 -
 .../io_ls/yuv420_io_ls/ia_css_yuv420_io_param.h    |   22 -
 .../io_ls/yuv420_io_ls/ia_css_yuv420_io_types.h    |   22 -
 .../ipu2_io_ls/plane_io_ls/ia_css_plane_io_param.h |   22 -
 .../ipu2_io_ls/plane_io_ls/ia_css_plane_io_types.h |   30 -
 .../yuv420_io_ls/ia_css_yuv420_io_param.h          |   22 -
 .../yuv420_io_ls/ia_css_yuv420_io_types.h          |   22 -
 .../isp/kernels/norm/norm_1.0/ia_css_norm_types.h  |   21 -
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h     |   50 +-
 .../kernels/s3a_stat_ls/ia_css_s3a_stat_ls_param.h |   45 -
 .../s3a_stat_ls/ia_css_s3a_stat_store_param.h      |   21 -
 .../kernels/scale/scale_1.0/ia_css_scale_param.h   |   20 -
 .../kernels/sdis/common/ia_css_sdis_common_types.h |   31 +-
 .../isp/kernels/sdis/common/ia_css_sdis_param.h    |   22 -
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c   |    3 +-
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis_param.h  |   21 -
 .../isp/kernels/sdis/sdis_2/ia_css_sdis_param.h    |   21 -
 .../xnr/xnr_3.0/ia_css_xnr3_wrapper_param.h        |   20 -
 .../yuv_ls/yuv_ls_1.0/ia_css_yuv_load_param.h      |   20 -
 .../yuv_ls/yuv_ls_1.0/ia_css_yuv_ls_param.h        |   39 -
 .../yuv_ls/yuv_ls_1.0/ia_css_yuv_store_param.h     |   21 -
 .../css2400/isp/modes/interface/isp_exprs.h        |  286 ---
 .../runtime/binary/interface/ia_css_binary.h       |   88 +-
 .../atomisp2/css2400/runtime/binary/src/binary.c   |    3 +-
 .../css2400/runtime/debug/src/ia_css_debug.c       |    8 +-
 .../isp_param/interface/ia_css_isp_param_types.h   |    9 -
 .../runtime/pipeline/interface/ia_css_pipeline.h   |   24 +-
 .../css2400/runtime/pipeline/src/pipeline.c        |    7 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |   49 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_legacy.h   |   11 -
 .../atomisp/pci/atomisp2/css2400/sh_css_metrics.h  |   21 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_bo_dev.h  |  126 --
 .../atomisp/pci/atomisp2/include/mmu/sh_mmu.h      |   72 -
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |    2 +-
 97 files changed, 136 insertions(+), 12272 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/i2c/ov8858.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/ov8858.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/ov8858_btns.h
 delete mode 100644 drivers/staging/media/atomisp/include/linux/vlv2_plat_clock.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/gp_regs_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/sp_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/gp_regs_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/sp_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hrt/gp_regs_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hrt/sp_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_api_version.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/hive_isp_css_ddr_hrt_modified.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/hive_isp_css_hrt_modified.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/resource_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/xmem_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/bamem.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/bbb_config.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/cpu_mem_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp2400_config.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp2500_config.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp2600_config.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp2601_config.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_config.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op1w.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op1w_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op2w.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op2w_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op_count.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/osys_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/pipeline_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/ref_vector_func.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/ref_vector_func_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mpmath.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/osys.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/stream_buffer.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vector_func.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vector_ops.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/xmem.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_shared/socket_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_shared/stream_buffer_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/aa/aa_2/ia_css_aa2_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bayer_ls/bayer_ls_1.0/ia_css_bayer_load_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bayer_ls/bayer_ls_1.0/ia_css_bayer_ls_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bayer_ls/bayer_ls_1.0/ia_css_bayer_store_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/cnr/cnr_1.0/ia_css_cnr_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/cnr/cnr_2/ia_css_cnr_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dp/dp_1.0/ia_css_dp_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/io_ls/plane_io_ls/ia_css_plane_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/io_ls/plane_io_ls/ia_css_plane_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/io_ls/yuv420_io_ls/ia_css_yuv420_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/io_ls/yuv420_io_ls/ia_css_yuv420_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/ipu2_io_ls/plane_io_ls/ia_css_plane_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/ipu2_io_ls/plane_io_ls/ia_css_plane_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/ipu2_io_ls/yuv420_io_ls/ia_css_yuv420_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/ipu2_io_ls/yuv420_io_ls/ia_css_yuv420_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/norm/norm_1.0/ia_css_norm_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a_stat_ls/ia_css_s3a_stat_ls_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a_stat_ls/ia_css_s3a_stat_store_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/scale/scale_1.0/ia_css_scale_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_2/ia_css_sdis_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr_3.0/ia_css_xnr3_wrapper_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/yuv_ls/yuv_ls_1.0/ia_css_yuv_load_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/yuv_ls/yuv_ls_1.0/ia_css_yuv_ls_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/yuv_ls/yuv_ls_1.0/ia_css_yuv_store_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_exprs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo_dev.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/include/mmu/sh_mmu.h

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
