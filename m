Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42883 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbeDIRXg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Apr 2018 13:23:36 -0400
Date: Mon, 9 Apr 2018 14:23:28 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.17-rc1] media fixes and sparse/smatch cleanups
Message-ID: <20180409142328.200e2b20@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.17-2

For a series of media updates/fixes for Kernel 4.17-rc1.

There are two important core fix patches in this series:

  - A regression fix on Kernel 4.16 with causes it to not work
    with some input devices that depend on media core;
  - A fix at compat32 bits with causes it to OOPS on overlay,
    and affects the Kernels where the CVE-2017-13166 was backported.

The remaining ones are other random fixes at the documentation
and on drivers.

The biggest part of this series is a set of 18 patches for the Intel 
atomisp driver. Currently, it produces hundreds of warnings/errors on 
sparse/smatch, causing me to sometimes ignore new warnings on other
drivers that are not so broken. This driver is on really poor state, 
even for staging standards: it has several layers of abstraction on it, 
and it supports two different hardware. Selecting between them require
to add a define (there isn't even a Kconfig option for such purpose).
Just on this smatch cleanup, I could easily get rid of 8 "do-nothing"
files. So, I'm seriously considering its removal from upstream, if I
don't see any real work on addressing the problems there along this year.

Thanks!
Mauro

-


The following changes since commit 17dec0a949153d9ac00760ba2f5b78cb583e995f:

  Merge branch 'userns-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace (2018-04-03 19:15:32 -0700)

are available in the Git repository at:


for you to fetch changes up to a95845ba184b854106972f5d8f50354c2d272c06:

  media: v4l2-core: fix size of devnode_nums[] bitarray (2018-04-05 06:41:30 -0400)

----------------------------------------------------------------
media updates for v4.17-rc1

----------------------------------------------------------------
Akinobu Mita (2):
      media: ov5645: add missing of_node_put() in error path
      media: ov5640: add missing output pixel format setting

Alexandre Courbot (1):
      media: venus: vdec: fix format enumeration

Arnd Bergmann (1):
      media: imx: work around false-positive warning

Brad Love (1):
      media: cx231xx: Increase USB bridge bandwidth

Chiranjeevi Rapolu (2):
      media: ov5670: Update to SPDX identifier
      media: ov13858: Update to SPDX identifier

Colin Ian King (1):
      media: staging: media: davinci_vpfe: fix spelling of resizer_configure_in_continious_mode

Fabio Estevam (2):
      media: imx-media-csi: Do not propagate the error when pinctrl is not found
      media: ov2685: Remove owner assignment from i2c_driver

Hans Verkuil (6):
      media: v4l2-tpg-core.c: add space after %
      media: pixfmt-v4l2-mplane.rst: fix types
      media: pixfmt-v4l2.rst: fix types
      media: media-ioc-g-topology.rst: fix 'reserved' sizes
      media: media-types.rst: rename media-entity-type to media-entity-functions
      media: extended-controls.rst: transmitter -> receiver

Hugues Fruchet (1):
      media: ov5640: fix get_/set_fmt colorspace related fields

Jasmin Jessich (1):
      media: cec-pin: Fixed ktime_t to ns conversion

Katsuhiro Suzuki (1):
      media: dvb_frontend: fix wrong cast in compat_ioctl

Kieran Bingham (1):
      media: vsp1: Fix BRx conditional path in WPF

Luca Ceresoli (2):
      media: doc: fix ReST link syntax
      media: imx274: fix typo in error message

Mauro Carvalho Chehab (20):
      media: r820t: don't crash if attach fails
      media: staging: atomisp: do some coding style improvements
      media: staging: atomisp: ia_css_output.host: don't use var before check
      media: staging: atomisp: declare static vars as such
      media: staging: atomisp: get rid of stupid statements
      media: staging: atomisp: add a missing include
      media: staging: atomisp: fix endianess issues
      media: staging: atomisp: remove unused set_pd_base()
      media: staging: atomisp: get rid of an unused function
      media: staging: atomisp: Get rid of *default.host.[ch]
      media: staging: atomisp: don't access a NULL var
      media: staging: atomisp: avoid a warning if 32 bits build
      media: staging: atomisp: remove an useless check
      media: staging: atomisp: use %p to print pointers
      media: staging: atomisp: get rid of some static warnings
      media: staging: atomisp: stop mixing enum types
      media: staging: atomisp: get rid of an unused var
      media: staging: atomisp: stop duplicating input format types
      media: v4l2-compat-ioctl32: don't oops on overlay
      media: v4l2-core: fix size of devnode_nums[] bitarray

Niklas Söderlund (1):
      media: i2c: adv748x: afe: fix sparse warning

Rajmohan Mani (1):
      media: dw9714: Update to SPDX license identifier

Ryder Lee (1):
      media: vcodec: fix error return value from mtk_jpeg_clk_init()

Sakari Ailus (1):
      media: v4l: Bring back array_size parameter to v4l2_find_nearest_size

Todor Tomov (1):
      media: ov5645: Use v4l2_find_nearest_size

winton.liu (1):
      media: gspca: fix Kconfig help info

 Documentation/media/kapi/v4l2-dev.rst              |   2 +-
 .../uapi/mediactl/media-ioc-enum-entities.rst      |   2 +-
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |   8 +-
 Documentation/media/uapi/mediactl/media-types.rst  |   4 +-
 Documentation/media/uapi/v4l/extended-controls.rst |   2 +-
 .../media/uapi/v4l/pixfmt-v4l2-mplane.rst          |  36 ++--
 Documentation/media/uapi/v4l/pixfmt-v4l2.rst       |  36 ++--
 drivers/media/cec/cec-pin.c                        |   6 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |   2 +-
 drivers/media/dvb-core/dvb_frontend.c              |   2 +-
 drivers/media/i2c/adv748x/adv748x-afe.c            |   3 +-
 drivers/media/i2c/dw9714.c                         |  14 +-
 drivers/media/i2c/imx274.c                         |   2 +-
 drivers/media/i2c/ov13858.c                        |  19 +-
 drivers/media/i2c/ov2685.c                         |   1 -
 drivers/media/i2c/ov5640.c                         |  38 +++-
 drivers/media/i2c/ov5645.c                         |  29 +--
 drivers/media/i2c/ov5670.c                         |  19 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |   4 +-
 drivers/media/platform/qcom/venus/vdec.c           |  13 +-
 drivers/media/platform/qcom/venus/venc.c           |  13 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   5 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   2 +-
 drivers/media/tuners/r820t.c                       |   4 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |   2 +-
 drivers/media/usb/gspca/Kconfig                    |   2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   4 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |   8 +-
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c |   2 +-
 .../staging/media/atomisp/i2c/atomisp-mt9m114.c    |  25 +--
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c |  18 +-
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c |  18 +-
 drivers/staging/media/atomisp/i2c/gc0310.h         |   3 +-
 drivers/staging/media/atomisp/i2c/ov2722.h         |   2 +-
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      |  28 +--
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h  |   2 +-
 .../media/atomisp/include/linux/atomisp_platform.h |   4 +
 .../staging/media/atomisp/pci/atomisp2/Makefile    |   4 -
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |  42 ++---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.h       |   2 +-
 .../media/atomisp/pci/atomisp2/atomisp_compat.h    |  20 +--
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |  58 ++----
 .../atomisp/pci/atomisp2/atomisp_compat_css20.h    |   3 +-
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.c     |   1 +
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      |  14 +-
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |  10 +-
 .../media/atomisp/pci/atomisp2/atomisp_subdev.c    |  14 +-
 .../media/atomisp/pci/atomisp2/atomisp_subdev.h    |   8 +-
 .../css2400/camera/util/interface/ia_css_util.h    |   6 +-
 .../pci/atomisp2/css2400/camera/util/src/util.c    |  72 ++++----
 .../css2400/css_2401_csi2p_system/system_global.h  |   4 +-
 .../css2400/hive_isp_css_common/host/debug.c       |   2 +-
 .../css2400/hive_isp_css_common/host/gp_timer.c    |   2 +-
 .../hive_isp_css_common/host/input_formatter.c     |   5 +-
 .../hive_isp_css_common/host/input_system.c        |  24 +--
 .../hive_isp_css_common/host/input_system_local.h  |   2 +-
 .../host/input_system_private.h                    |   4 +-
 .../css2400/hive_isp_css_common/system_global.h    |   4 +-
 .../host/input_system_public.h                     |  14 +-
 .../pci/atomisp2/css2400/ia_css_input_port.h       |  20 +--
 .../atomisp/pci/atomisp2/css2400/ia_css_irq.h      |   4 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_metadata.h |   4 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_mipi.h     |   4 +-
 .../pci/atomisp2/css2400/ia_css_stream_format.h    |  71 +-------
 .../pci/atomisp2/css2400/ia_css_stream_public.h    |   8 +-
 .../css2400/isp/kernels/bnlm/ia_css_bnlm.host.h    |   1 -
 .../isp/kernels/bnlm/ia_css_bnlm_default.host.c    |  71 --------
 .../isp/kernels/bnlm/ia_css_bnlm_default.host.h    |  22 ---
 .../css2400/isp/kernels/dpc2/ia_css_dpc2.host.h    |   1 -
 .../isp/kernels/dpc2/ia_css_dpc2_default.host.c    |  26 ---
 .../isp/kernels/dpc2/ia_css_dpc2_default.host.h    |  23 ---
 .../isp/kernels/eed1_8/ia_css_eed1_8.host.h        |   1 -
 .../kernels/eed1_8/ia_css_eed1_8_default.host.c    |  94 ----------
 .../kernels/eed1_8/ia_css_eed1_8_default.host.h    |  22 ---
 .../kernels/output/output_1.0/ia_css_output.host.c |   2 +-
 .../isp/kernels/raw/raw_1.0/ia_css_raw.host.c      |  42 ++---
 .../isp/kernels/raw/raw_1.0/ia_css_raw_types.h     |   2 +-
 .../isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.c      |   2 +-
 .../isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.h      |   1 -
 .../kernels/tdf/tdf_1.0/ia_css_tdf_default.host.c  |  36 ----
 .../kernels/tdf/tdf_1.0/ia_css_tdf_default.host.h  |  23 ---
 .../css2400/isp/kernels/vf/vf_1.0/ia_css_vf.host.c |  10 +-
 .../runtime/binary/interface/ia_css_binary.h       |   8 +-
 .../atomisp2/css2400/runtime/binary/src/binary.c   |   6 +-
 .../pci/atomisp2/css2400/runtime/bufq/src/bufq.c   |   9 +-
 .../css2400/runtime/debug/src/ia_css_debug.c       | 111 ++++++------
 .../pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c |  96 +++++-----
 .../runtime/inputfifo/interface/ia_css_inputfifo.h |   6 +-
 .../css2400/runtime/inputfifo/src/inputfifo.c      |  22 +--
 .../css2400/runtime/isys/interface/ia_css_isys.h   |  20 +--
 .../css2400/runtime/isys/src/csi_rx_rmgr.c         |   4 +-
 .../atomisp2/css2400/runtime/isys/src/isys_init.c  |   4 +-
 .../pci/atomisp2/css2400/runtime/isys/src/rx.c     | 146 ++++++++--------
 .../css2400/runtime/isys/src/virtual_isys.c        |  12 +-
 .../css2400/runtime/pipeline/src/pipeline.c        |   6 +-
 .../atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c  |   8 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 194 ++++++++++-----------
 .../atomisp/pci/atomisp2/css2400/sh_css_mipi.c     |  58 +++---
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |   9 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.c |  25 +--
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.h |   2 +-
 .../pci/atomisp2/css2400/sh_css_stream_format.c    |  58 +++---
 .../pci/atomisp2/css2400/sh_css_stream_format.h    |   2 +-
 .../atomisp/pci/atomisp2/include/mmu/isp_mmu.h     |   4 +-
 .../media/atomisp/pci/atomisp2/mmu/isp_mmu.c       |  13 +-
 .../media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c  |  16 +-
 .../platform/intel-mid/atomisp_gmin_platform.c     |   8 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |   4 +-
 drivers/staging/media/imx/imx-media-csi.c          |   7 +-
 include/media/v4l2-common.h                        |   5 +-
 include/media/v4l2-dev.h                           |  12 +-
 111 files changed, 815 insertions(+), 1249 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm_default.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm_default.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2_default.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2_default.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8_default.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8_default.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf_default.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf_default.host.h
