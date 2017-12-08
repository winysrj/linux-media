Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56201 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754099AbdLHP45 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 10:56:57 -0500
Date: Fri, 8 Dec 2017 13:56:50 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.15-rc3] media fixes
Message-ID: <20171208135650.3f385c45@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.15-2

For a series of fixes for the media subsytem:

- The largest amount of fixes in this series is with regards to comments
  that aren't kernel-doc, but start with "/**". A new check added for
  4.15 makes it to produce a *huge* amount of new warnings (I'm compiling
  here with W=1). Most of the patches in this series fix those. No code
  changes - just comment changes at the source files;
- rc: some fixed in order to better handle RC repetition codes;
- v4l-async: use the v4l2_dev from the root notifier when matching sub-devices;
- v4l2-fwnode: Check subdev count after checking port
- ov 13858 and et8ek8: compilation fix with randconfigs;
- usbtv: a trivial new USB ID addition;
- dibusb-common: don't do DMA on stack on firmware load;
- imx274: Fix error handling, add MAINTAINERS entry;
- sir_ir: detect presence of port.

The following changes since commit 4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323:

  Linux 4.15-rc1 (2017-11-26 16:01:47 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.15-2

for you to fetch changes up to 781b045baefdabf7e0bc9f33672ca830d3db9f27:

  media: imx274: Fix error handling, add MAINTAINERS entry (2017-11-30 04:45:12 -0500)

----------------------------------------------------------------
media fixes for v4.15-rc3

----------------------------------------------------------------
Arnd Bergmann (1):
      media: et8ek8: select V4L2_FWNODE

Icenowy Zheng (1):
      media: usbtv: add a new usbid

Laurent Caumont (1):
      media: dvb: i2c transfers over usb cannot be done from stack

Mauro Carvalho Chehab (42):
      Merge tag 'v4.15-rc1' into patchwork
      media: dvb_ca_en50221: fix lots of documentation warnings
      media: rc: fix lots of documentation warnings
      media: siano: get rid of documentation warnings
      media: img-ir-hw: fix one kernel-doc comment
      media: drxj and drxk: don't produce kernel-doc warnings
      media: vpif: don't generate a kernel-doc warning on a constant
      media: dvb_frontend fix kernel_doc markups
      media: rc-ir-raw: cleanup kernel-doc markups
      media: dvb_net: stop abusing /** for comments
      media: ir-nec-decoder: fix kernel-doc parameters
      media: imon: don't use kernel-doc "/**" markups
      media: videobuf2: don't use kernel-doc "/**" markups
      media: atomisp: stop producing hundreds of kernel-doc warnings
      media: rc: fix kernel-doc parameter names
      media: v4l2-core: Fix kernel-doc markups
      media: davinci: fix kernel-doc warnings
      media: venc: don't use kernel-doc for undescribed enums
      media: exynos4-is: fix kernel-doc warnings
      media: m5mols: fix some kernel-doc markups
      media: sta2x11: document missing function parameters
      media: pxa_camera: get rid of kernel_doc warnings
      media: tw68: fix kernel-doc markups
      media: ix2505v: get rid of /** comments
      media: radio-si476x: fix kernel-doc markups
      media: s5k6a3: document some fields at struct s5k6a3
      media: s5k6aa: describe some function parameters
      media: netup_unidvb: fix a bad kernel-doc markup
      media: tvp514x: fix kernel-doc parameters
      media: vdec: fix some kernel-doc warnings
      media: mtk-vpu: add description for wdt fields at struct mtk_vpu
      media: s3c-camif: add missing description at s3c_camif_find_format()
      media: radio-wl1273: fix a parameter name at kernel-doc macro
      media: mt2063: fix some kernel-doc warnings
      media: soc_camera: fix a kernel-doc markup
      media: vsp1: add a missing kernel-doc parameter
      media: rcar_jpu: fix two kernel-doc markups
      media: lm3560: add a missing kernel-doc parameter
      media: drivers: remove "/**" from non-kernel-doc comments
      media: dvb_frontends: fix kernel-doc macros
      media: docs: add documentation for frontend attach info
      media: dvb-frontends: complete kernel-doc markups

Niklas Söderlund (1):
      media: v4l: async: use the v4l2_dev from the root notifier when matching sub-devices

Sakari Ailus (2):
      media: ov13858: Select V4L2_FWNODE
      media: imx274: Fix error handling, add MAINTAINERS entry

Sean Young (2):
      media: rc: sir_ir: detect presence of port
      media: rc: partial revert of "media: rc: per-protocol repeat period"

Tomasz Figa (1):
      media: v4l2-fwnode: Check subdev count after checking port

 Documentation/media/dvb-drivers/frontends.rst      |  30 +
 Documentation/media/dvb-drivers/index.rst          |   1 +
 MAINTAINERS                                        |   8 +
 drivers/media/common/siano/smscoreapi.c            |  66 +-
 drivers/media/dvb-core/dvb_ca_en50221.c            |  68 +-
 drivers/media/dvb-core/dvb_frontend.c              |  13 +-
 drivers/media/dvb-core/dvb_net.c                   |  15 +-
 drivers/media/dvb-frontends/af9013.h               |  24 +-
 drivers/media/dvb-frontends/ascot2e.h              |   9 +
 drivers/media/dvb-frontends/cxd2820r.h             |  24 +-
 drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h     |  12 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  | 878 ++++++++++-----------
 drivers/media/dvb-frontends/drx39xyj/drxj.c        | 248 +++---
 drivers/media/dvb-frontends/drx39xyj/drxj.h        | 220 +++---
 drivers/media/dvb-frontends/drxk.h                 |  13 +-
 drivers/media/dvb-frontends/drxk_hard.c            |  32 +-
 drivers/media/dvb-frontends/dvb-pll.h              |  13 +-
 drivers/media/dvb-frontends/helene.h               |  30 +-
 drivers/media/dvb-frontends/horus3a.h              |   9 +
 drivers/media/dvb-frontends/ix2505v.c              |   6 +-
 drivers/media/dvb-frontends/ix2505v.h              |  28 +-
 drivers/media/dvb-frontends/l64781.c               |   2 +-
 drivers/media/dvb-frontends/m88ds3103.h            | 155 ++--
 drivers/media/dvb-frontends/mb86a20s.h             |  17 +-
 drivers/media/dvb-frontends/mn88472.h              |  16 +-
 drivers/media/dvb-frontends/rtl2830.h              |   1 -
 drivers/media/dvb-frontends/rtl2832.h              |   1 -
 drivers/media/dvb-frontends/rtl2832_sdr.h          |   6 +-
 drivers/media/dvb-frontends/sp887x.c               |   6 +-
 drivers/media/dvb-frontends/stb6000.h              |  11 +-
 drivers/media/dvb-frontends/stv0299.c              |   2 +-
 drivers/media/dvb-frontends/tda10071.h             |   1 -
 drivers/media/dvb-frontends/tda826x.h              |  11 +-
 drivers/media/dvb-frontends/tua6100.c              |   2 +-
 drivers/media/dvb-frontends/tua6100.h              |   2 +-
 drivers/media/dvb-frontends/zd1301_demod.h         |  13 +-
 drivers/media/dvb-frontends/zl10036.c              |   8 +-
 drivers/media/dvb-frontends/zl10036.h              |  16 +-
 drivers/media/i2c/Kconfig                          |   1 +
 drivers/media/i2c/et8ek8/Kconfig                   |   1 +
 drivers/media/i2c/imx274.c                         |   5 +-
 drivers/media/i2c/lm3560.c                         |   1 +
 drivers/media/i2c/m5mols/m5mols_capture.c          |   5 +
 drivers/media/i2c/m5mols/m5mols_controls.c         |   1 +
 drivers/media/i2c/m5mols/m5mols_core.c             |  20 +-
 drivers/media/i2c/ov5647.c                         |   4 +-
 drivers/media/i2c/s5k6a3.c                         |   3 +
 drivers/media/i2c/s5k6aa.c                         |   5 +
 drivers/media/i2c/tvp514x.c                        |  12 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |   8 +-
 drivers/media/pci/solo6x10/solo6x10-enc.c          |   2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |  11 +
 drivers/media/pci/tw68/tw68-risc.c                 |  33 +-
 drivers/media/platform/davinci/vpif.c              |   3 +-
 drivers/media/platform/davinci/vpif_capture.c      |  27 +-
 drivers/media/platform/davinci/vpif_display.c      |  16 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   3 +
 drivers/media/platform/exynos4-is/media-dev.c      |  11 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   2 +-
 .../media/platform/mtk-vcodec/vdec/vdec_h264_if.c  |   1 +
 .../media/platform/mtk-vcodec/vdec/vdec_vp8_if.c   |   1 -
 .../media/platform/mtk-vcodec/venc/venc_h264_if.c  |   4 +-
 .../media/platform/mtk-vcodec/venc/venc_vp8_if.c   |   2 +-
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |   3 +-
 drivers/media/platform/pxa_camera.c                |   9 +-
 drivers/media/platform/rcar_fdp1.c                 |   2 +-
 drivers/media/platform/rcar_jpu.c                  |   4 +-
 drivers/media/platform/s3c-camif/camif-core.c      |   1 +
 drivers/media/platform/sh_veu.c                    |   2 +-
 drivers/media/platform/soc_camera/soc_scale_crop.c |  21 +-
 drivers/media/platform/sti/hva/hva-h264.c          |  18 +-
 drivers/media/platform/ti-vpe/vpe.c                |   2 +-
 drivers/media/platform/vim2m.c                     |   2 +-
 drivers/media/platform/vsp1/vsp1_dl.c              |   1 +
 drivers/media/radio/radio-si476x.c                 |  18 +-
 drivers/media/radio/radio-wl1273.c                 |   2 +-
 drivers/media/rc/img-ir/img-ir-hw.c                |   2 +-
 drivers/media/rc/imon.c                            |  40 +-
 drivers/media/rc/ir-jvc-decoder.c                  |   2 +-
 drivers/media/rc/ir-lirc-codec.c                   |   4 +-
 drivers/media/rc/ir-nec-decoder.c                  |   3 +-
 drivers/media/rc/ir-sanyo-decoder.c                |   2 +-
 drivers/media/rc/ir-sharp-decoder.c                |   2 +-
 drivers/media/rc/ir-xmp-decoder.c                  |   2 +-
 drivers/media/rc/rc-ir-raw.c                       |   2 +-
 drivers/media/rc/rc-main.c                         |  78 +-
 drivers/media/rc/sir_ir.c                          |  40 +-
 drivers/media/rc/st_rc.c                           |   6 +-
 drivers/media/rc/streamzap.c                       |   6 +-
 drivers/media/tuners/mt2063.c                      |   6 +-
 drivers/media/usb/dvb-usb/cinergyT2-fe.c           |   2 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |   8 +-
 drivers/media/usb/dvb-usb/dibusb-common.c          |  16 +-
 drivers/media/usb/dvb-usb/friio-fe.c               |   2 +-
 drivers/media/usb/dvb-usb/friio.c                  |   2 +-
 drivers/media/usb/gspca/ov519.c                    |   2 +-
 drivers/media/usb/pwc/pwc-dec23.c                  |   7 +-
 drivers/media/usb/siano/smsusb.c                   |   4 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  |   6 +-
 drivers/media/usb/usbtv/usbtv-core.c               |   1 +
 drivers/media/v4l2-core/tuner-core.c               |   4 +-
 drivers/media/v4l2-core/v4l2-async.c               |   3 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  10 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |  10 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   2 +
 drivers/media/v4l2-core/videobuf-core.c            |   2 +-
 drivers/media/v4l2-core/videobuf2-core.c           |  56 +-
 drivers/media/v4l2-core/videobuf2-memops.c         |   2 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c           |  10 +-
 .../staging/media/atomisp/include/linux/atomisp.h  |  34 +-
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |   2 +-
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |   2 +-
 .../atomisp/pci/atomisp2/atomisp_compat_ioctl32.h  |  16 +-
 .../media/atomisp/pci/atomisp2/atomisp_subdev.h    |   2 +-
 .../atomisp2/css2400/base/circbuf/src/circbuf.c    |  26 +-
 .../camera/pipe/interface/ia_css_pipe_binarydesc.h |  34 +-
 .../camera/pipe/interface/ia_css_pipe_util.h       |   2 +-
 .../css2400/camera/util/interface/ia_css_util.h    |  18 +-
 .../css_2401_csi2p_system/host/csi_rx_private.h    |   2 +-
 .../css_2401_csi2p_system/host/ibuf_ctrl_private.h |   4 +-
 .../css2400/css_2401_csi2p_system/host/isys_irq.c  |   2 +-
 .../css_2401_csi2p_system/host/isys_irq_private.h  |   4 +-
 .../host/isys_stream2mmio_private.h                |   4 +-
 .../css_2401_csi2p_system/host/pixelgen_private.h  |   2 +-
 .../css_2401_csi2p_system/isys_dma_global.h        |   4 +-
 .../css_2401_csi2p_system/pixelgen_global.h        |   2 +-
 .../css2400/css_2401_csi2p_system/system_global.h  |   8 +-
 .../atomisp/pci/atomisp2/css2400/css_api_version.h |   2 +-
 .../css2400/hive_isp_css_common/host/gp_timer.c    |   2 +-
 .../hive_isp_css_include/host/csi_rx_public.h      |   4 +-
 .../hive_isp_css_include/host/ibuf_ctrl_public.h   |   4 +-
 .../css2400/hive_isp_css_include/host/isp_op1w.h   |  98 +--
 .../css2400/hive_isp_css_include/host/isp_op2w.h   |  78 +-
 .../host/isys_stream2mmio_public.h                 |   4 +-
 .../hive_isp_css_include/host/pixelgen_public.h    |   4 +-
 .../hive_isp_css_include/host/ref_vector_func.h    | 144 ++--
 .../css2400/hive_isp_css_include/math_support.h    |   2 +-
 .../css2400/hive_isp_css_include/string_support.h  |   8 +-
 .../css2400/hive_isp_css_shared/host/tag.c         |   4 +-
 .../media/atomisp/pci/atomisp2/css2400/ia_css.h    |   2 +-
 .../media/atomisp/pci/atomisp2/css2400/ia_css_3a.h |  38 +-
 .../pci/atomisp2/css2400/ia_css_acc_types.h        | 216 ++---
 .../atomisp/pci/atomisp2/css2400/ia_css_buffer.h   |  32 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_control.h  |  22 +-
 .../pci/atomisp2/css2400/ia_css_device_access.h    |   2 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_dvs.h      |  52 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_env.h      |  40 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_err.h      |  18 +-
 .../pci/atomisp2/css2400/ia_css_event_public.h     |  68 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_firmware.h |  14 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_frac.h     |  10 +-
 .../pci/atomisp2/css2400/ia_css_frame_format.h     |  62 +-
 .../pci/atomisp2/css2400/ia_css_frame_public.h     | 120 +--
 .../pci/atomisp2/css2400/ia_css_input_port.h       |  32 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_irq.h      | 112 +--
 .../atomisp/pci/atomisp2/css2400/ia_css_metadata.h |  24 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_mipi.h     |  10 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_mmu.h      |   4 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_morph.h    |   6 +-
 .../pci/atomisp2/css2400/ia_css_pipe_public.h      | 128 +--
 .../atomisp/pci/atomisp2/css2400/ia_css_prbs.h     |  12 +-
 .../pci/atomisp2/css2400/ia_css_properties.h       |   6 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_shading.h  |   6 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_stream.h   |   4 +-
 .../pci/atomisp2/css2400/ia_css_stream_format.h    |  90 +--
 .../pci/atomisp2/css2400/ia_css_stream_public.h    | 148 ++--
 .../atomisp/pci/atomisp2/css2400/ia_css_timer.h    |  30 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_tpg.h      |   8 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_types.h    | 258 +++---
 .../atomisp/pci/atomisp2/css2400/ia_css_version.h  |   6 +-
 .../css2400/isp/kernels/aa/aa_2/ia_css_aa2_types.h |   6 +-
 .../isp/kernels/anr/anr_1.0/ia_css_anr_types.h     |   6 +-
 .../isp/kernels/anr/anr_2/ia_css_anr2_types.h      |   4 +-
 .../isp/kernels/anr/anr_2/ia_css_anr_param.h       |   2 +-
 .../bayer_ls/bayer_ls_1.0/ia_css_bayer_ls_param.h  |   2 +-
 .../css2400/isp/kernels/bh/bh_2/ia_css_bh_types.h  |   4 +-
 .../css2400/isp/kernels/bnlm/ia_css_bnlm_types.h   |  36 +-
 .../isp/kernels/bnr/bnr2_2/ia_css_bnr2_2_types.h   |  34 +-
 .../isp/kernels/cnr/cnr_2/ia_css_cnr2_types.h      |  20 +-
 .../conversion_1.0/ia_css_conversion_types.h       |   8 +-
 .../isp/kernels/crop/crop_1.0/ia_css_crop_param.h  |   2 +-
 .../isp/kernels/crop/crop_1.0/ia_css_crop_types.h  |   2 +-
 .../isp/kernels/csc/csc_1.0/ia_css_csc_types.h     |   8 +-
 .../isp/kernels/ctc/ctc2/ia_css_ctc2_param.h       |  12 +-
 .../isp/kernels/ctc/ctc2/ia_css_ctc2_types.h       |  10 +-
 .../isp/kernels/ctc/ctc_1.0/ia_css_ctc_types.h     |  38 +-
 .../isp/kernels/de/de_1.0/ia_css_de_types.h        |  10 +-
 .../css2400/isp/kernels/de/de_2/ia_css_de2_types.h |  10 +-
 .../isp/kernels/dp/dp_1.0/ia_css_dp_types.h        |   8 +-
 .../css2400/isp/kernels/dpc2/ia_css_dpc2_types.h   |   6 +-
 .../isp/kernels/dvs/dvs_1.0/ia_css_dvs_param.h     |   2 +-
 .../isp/kernels/dvs/dvs_1.0/ia_css_dvs_types.h     |   2 +-
 .../isp/kernels/eed1_8/ia_css_eed1_8_types.h       |  82 +-
 .../isp/kernels/fc/fc_1.0/ia_css_formats_types.h   |   6 +-
 .../isp/kernels/fpn/fpn_1.0/ia_css_fpn_types.h     |  14 +-
 .../isp/kernels/gc/gc_1.0/ia_css_gc_types.h        |  32 +-
 .../css2400/isp/kernels/gc/gc_2/ia_css_gc2_types.h |  14 +-
 .../css2400/isp/kernels/hdr/ia_css_hdr_types.h     |  26 +-
 .../ipu2_io_ls/bayer_io_ls/ia_css_bayer_io.host.c  |   2 +-
 .../yuv444_io_ls/ia_css_yuv444_io.host.c           |   2 +-
 .../kernels/macc/macc1_5/ia_css_macc1_5_types.h    |  16 +-
 .../isp/kernels/macc/macc_1.0/ia_css_macc_types.h  |  12 +-
 .../css2400/isp/kernels/ob/ob2/ia_css_ob2_types.h  |  12 +-
 .../isp/kernels/ob/ob_1.0/ia_css_ob_types.h        |  26 +-
 .../output/output_1.0/ia_css_output_param.h        |   2 +-
 .../output/output_1.0/ia_css_output_types.h        |   8 +-
 .../kernels/qplane/qplane_2/ia_css_qplane_types.h  |   2 +-
 .../isp/kernels/raw/raw_1.0/ia_css_raw_types.h     |   2 +-
 .../isp/kernels/ref/ref_1.0/ia_css_ref_param.h     |   2 +-
 .../isp/kernels/ref/ref_1.0/ia_css_ref_types.h     |   2 +-
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h     |  98 +--
 .../kernels/s3a_stat_ls/ia_css_s3a_stat_ls_param.h |   2 +-
 .../css2400/isp/kernels/sc/sc_1.0/ia_css_sc.host.h |   4 +-
 .../isp/kernels/sc/sc_1.0/ia_css_sc_types.h        |  42 +-
 .../kernels/sdis/common/ia_css_sdis_common_types.h | 104 +--
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis_types.h  |  20 +-
 .../isp/kernels/sdis/sdis_2/ia_css_sdis2_types.h   |  40 +-
 .../isp/kernels/tdf/tdf_1.0/ia_css_tdf_types.h     |  38 +-
 .../isp/kernels/tnr/tnr3/ia_css_tnr3_types.h       |  26 +-
 .../isp/kernels/tnr/tnr_1.0/ia_css_tnr_types.h     |  10 +-
 .../isp/kernels/vf/vf_1.0/ia_css_vf_param.h        |   4 +-
 .../isp/kernels/vf/vf_1.0/ia_css_vf_types.h        |   4 +-
 .../isp/kernels/wb/wb_1.0/ia_css_wb_types.h        |  14 +-
 .../isp/kernels/xnr/xnr_1.0/ia_css_xnr.host.c      |   2 +-
 .../isp/kernels/xnr/xnr_1.0/ia_css_xnr_param.h     |   2 +-
 .../isp/kernels/xnr/xnr_1.0/ia_css_xnr_types.h     |  20 +-
 .../isp/kernels/xnr/xnr_3.0/ia_css_xnr3_types.h    |  30 +-
 .../isp/kernels/ynr/ynr_1.0/ia_css_ynr_types.h     |  28 +-
 .../isp/kernels/ynr/ynr_2/ia_css_ynr2_types.h      |  40 +-
 .../yuv_ls/yuv_ls_1.0/ia_css_yuv_ls_param.h        |   2 +-
 .../atomisp/pci/atomisp2/css2400/memory_realloc.c  |   2 +-
 .../runtime/binary/interface/ia_css_binary.h       |   2 +-
 .../atomisp2/css2400/runtime/binary/src/binary.c   |   2 +-
 .../pci/atomisp2/css2400/runtime/bufq/src/bufq.c   |   2 +-
 .../css2400/runtime/debug/interface/ia_css_debug.h |  30 +-
 .../css2400/runtime/debug/src/ia_css_debug.c       |  10 +-
 .../pci/atomisp2/css2400/runtime/event/src/event.c |   4 +-
 .../atomisp2/css2400/runtime/eventq/src/eventq.c   |   2 +-
 .../css2400/runtime/frame/interface/ia_css_frame.h |  22 +-
 .../pci/atomisp2/css2400/runtime/frame/src/frame.c |   2 +-
 .../pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c |   2 +-
 .../css2400/runtime/inputfifo/src/inputfifo.c      |   2 +-
 .../isp_param/interface/ia_css_isp_param_types.h   |   6 +-
 .../css2400/runtime/isp_param/src/isp_param.c      |   2 +-
 .../css2400/runtime/isys/interface/ia_css_isys.h   |   6 +-
 .../css2400/runtime/isys/src/csi_rx_rmgr.c         |   2 +-
 .../css2400/runtime/isys/src/ibuf_ctrl_rmgr.c      |   2 +-
 .../css2400/runtime/isys/src/isys_dma_rmgr.c       |   2 +-
 .../atomisp2/css2400/runtime/isys/src/isys_init.c  |   2 +-
 .../runtime/isys/src/isys_stream2mmio_rmgr.c       |   2 +-
 .../pci/atomisp2/css2400/runtime/isys/src/rx.c     |   2 +-
 .../css2400/runtime/isys/src/virtual_isys.c        |   8 +-
 .../runtime/pipeline/interface/ia_css_pipeline.h   |  28 +-
 .../css2400/runtime/pipeline/src/pipeline.c        |   8 +-
 .../css2400/runtime/queue/interface/ia_css_queue.h |  22 +-
 .../css2400/runtime/queue/src/queue_access.c       |   2 +-
 .../pci/atomisp2/css2400/runtime/rmgr/src/rmgr.c   |   4 +-
 .../atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c  |  26 +-
 .../runtime/spctrl/interface/ia_css_spctrl.h       |  20 +-
 .../runtime/spctrl/interface/ia_css_spctrl_comm.h  |  14 +-
 .../atomisp2/css2400/runtime/spctrl/src/spctrl.c   |   4 +-
 .../pci/atomisp2/css2400/runtime/timer/src/timer.c |   2 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |  68 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_internal.h |  22 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_legacy.h   |   2 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_mipi.c     |   4 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_params.h   |   4 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.c |  18 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_struct.h   |   2 +-
 269 files changed, 3169 insertions(+), 2951 deletions(-)
 create mode 100644 Documentation/media/dvb-drivers/frontends.rst
