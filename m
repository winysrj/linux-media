Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38159
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751582AbdHEM64 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 Aug 2017 08:58:56 -0400
Date: Sat, 5 Aug 2017 09:58:47 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.13-rc4] media fixes
Message-ID: <20170805095847.602e3ca1@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.13-2

For several fixes:
  - some fixes at atomisp staging driver;
  - several gcc 7 warning fixes;
  - Cleanup media SVG files, in order to fix PDF build on some distros;
  - Fix random Kconfig build of venus driver;
  - Some fixes at the venus driver.
  - Some changes from semaphone to mutex on ngene's driver;
  - some locking fixes at dib0700 driver;
  - several fixes on ngene's driver and frontends to make it properly
    support some new boards added on Kernel 4.13;
  - Some fixes at CEC drivers;
  - omap_vout: vrfb: Convert to dmaengine;
  - docs-rst: Document EBUSY for VIDIOC_S_FMT

Please notice that the big diffstat changes here are at the SVG files. 
Visually, the images look the same, but the file size is now a lot
smaller than before, and they don't use some XML tags that would cause
them to be badly parsed by some ImageMagick versions, or to require
a lot of memory by TeTex, with would break PDF output on some
distributions.

This series is larger than I would like to submit for -rc4. My original
intent were to sent it to either -rc2 or -rc3. Unfortunately, due to 
my vacations, I got a lot of pending stuff after my return, and had to
do some biz trips, with prevented me to send this earlier.

Thanks,
Mauro

The following changes since commit 5771a8c08880cdca3bfb4a3fc6d309d6bba20877:

  Linux v4.13-rc1 (2017-07-15 15:22:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.13-2

for you to fetch changes up to 8033120f36c0b7212825f621a54e2d0f5ce72f72:

  media: atomisp2: array underflow in imx_enum_frame_size() (2017-07-26 08:26:21 -0400)

----------------------------------------------------------------
media fixes for v4.13-rc2

----------------------------------------------------------------
Arnd Bergmann (4):
      media: Revert "[media] et8ek8: Export OF device ID as module aliases"
      media: rainshadow-cec: avoid -Wmaybe-uninitialized warning again
      media: venus: mark PM functions as __maybe_unused
      media: venus: fix compile-test build on non-qcom ARM platform

Binoy Jayan (3):
      media: ngene: Replace semaphore cmd_mutex with mutex
      media: ngene: Replace semaphore stream_mutex with mutex
      media: ngene: Replace semaphore i2c_switch_mutex with mutex

Colin Ian King (1):
      media: venus: fix loop wrap in cleanup of clks

Dan Carpenter (6):
      media: dib0700: fix locking in dib0700_i2c_xfer_new()
      media: dib0700: fix error handling in dib0700_i2c_xfer_legacy()
      media: staging: atomisp: array underflow in ioctl
      media: atomisp2: Array underflow in atomisp_enum_input()
      media: atomisp2: array underflow in ap1302_enum_frame_size()
      media: atomisp2: array underflow in imx_enum_frame_size()

Daniel Scheller (11):
      media: ddbridge: make (ddb)readl in while-loops fail-safe
      media: ddbridge: use dev_* macros in favor of printk
      media: dvb-frontends/stv0367: deduplicate DDB dvb_frontend_ops caps
      media: dvb-frontends/lnbh25: improve kernellog output
      media: dvb-frontends/stv0367: initial DDB DVBv5 stats, implement ucblocks
      media: dvb-frontends/stv0367: split SNR determination into functions
      media: ddbridge: dev_* logging fixup
      media: dvb-frontends/cxd2841er: require STATE_ACTIVE_* for agc readout
      media: dvb-frontends/stv0367: SNR DVBv5 statistics for DVB-C and T
      media: dvb-frontends/stv0367: update UCB readout condition logic
      media: dvb-frontends/stv0367: DVB-C signal strength statistics

Gustavo A. R. Silva (4):
      media: radio: wl1273: add check on core->write() return value
      media: tuners: mxl5005s: remove useless variable assignments
      media: dvb-usb-v2: lmedm04: remove unnecessary variable in lme2510_stream_restart()
      media: i2c: tvp5150: remove useless variable assignment in tvp5150_set_vbi()

Hans Verkuil (3):
      media: cec: cec_transmit_attempt_done: ignore CEC_TX_STATUS_MAX_RETRIES
      media: pulse8-cec: persistent_config should be off by default
      media: cec-notifier: small improvements

Jasmin Jessich (2):
      media: staging: cxd2099: Removed printing in write_block
      media: staging: cxd2099: Activate cxd2099 buffer mode

Javier Martinez Canillas (1):
      media: vimc: set id_table for platform drivers

Joe Perches (2):
      media: stkwebcam: Use more common logging styles
      media: tuner-core: Remove unused #define PREFIX

Markus Elfring (1):
      media: bdisp-debug: Replace a seq_puts() call by seq_putc() in seven functions

Martin Kepplinger (1):
      media: dvb-frontends: drx39xyj: remove obsolete sign extend macros

Mauro Carvalho Chehab (16):
      media: dtv-core.rst: explain how to get DVBv5 statistics
      media: imx.rst: add it to v4l-drivers book
      media: em28xx: Ignore errors while reading from eeprom
      media: em28xx: add support for new of Terratec H6
      media: Replace initalized ->initialized
      media: tw5864, fc0011: better handle WARN_ON()
      media: stv0367: prevent division by zero
      media: dvb-frontends/stv0367: Improve DVB-C/T frontend status
      media: dtv-core.rst: add an introduction to FE kAPI
      media: dtv-core.rst: complete description of a demod driver
      Merge tag 'v4.13-rc1' into patchwork
      media: davinci: variable 'common' set but not used
      media: staging: atomisp: disable warnings with cc-disable-warning
      media: selection.svg: simplify the SVG file
      media: svg files: simplify files
      media: svg: avoid too long lines

Peter Ujfalusi (1):
      media: v4l: omap_vout: vrfb: Convert to dmaengine

Philipp Zabel (2):
      media: coda: ctx->codec is not NULL in coda_alloc_framebuffers
      media: coda: rename the picture run timeout error handler

Prabhakar Lad (2):
      media: platform: davinci: return -EINVAL for VPFE_CMD_S_CCDC_RAW_PARAMS ioctl
      media: platform: davinci: drop VPFE_CMD_S_CCDC_RAW_PARAMS

Ralph Metzler (5):
      media: dvb_ca_en50221: State UNINITIALISED instead of INVALID
      media: dvb_ca_en50221: Increase timeout for link init
      media: dvb_ca_en50221: Add block read/write functions
      media: staging: cxd2099: Fixed buffer mode
      media: staging: cxd2099: Removed useless printing in cxd2099 driver

Rob Clark (1):
      media: venus: hfi: fix error handling in hfi_sys_init_done()

Sakari Ailus (1):
      media: docs-rst: Document EBUSY for VIDIOC_S_FMT

Sean Young (1):
      media: lirc: LIRC_GET_REC_RESOLUTION should return microseconds

Stanimir Varbanov (1):
      media: venus: don't abuse dma_alloc for non-DMA allocations

 Documentation/media/kapi/dtv-core.rst              |  443 +-
 Documentation/media/typical_media_device.svg       | 3054 +--------
 Documentation/media/uapi/dvb/dvbstb.svg            |  668 +-
 Documentation/media/uapi/v4l/bayer.svg             | 1013 +--
 Documentation/media/uapi/v4l/constraints.svg       |  356 +-
 Documentation/media/uapi/v4l/crop.svg              |  253 +-
 Documentation/media/uapi/v4l/fieldseq_bt.svg       |  170 +-
 Documentation/media/uapi/v4l/fieldseq_tb.svg       |  175 +-
 Documentation/media/uapi/v4l/nv12mt.svg            |  764 +--
 Documentation/media/uapi/v4l/nv12mt_example.svg    | 2474 +++----
 Documentation/media/uapi/v4l/selection.svg         | 6957 ++++----------------
 .../uapi/v4l/subdev-image-processing-crop.svg      |   10 +-
 .../uapi/v4l/subdev-image-processing-full.svg      |   10 +-
 ...ubdev-image-processing-scaling-multi-source.svg |   10 +-
 Documentation/media/uapi/v4l/vbi_525.svg           |  614 +-
 Documentation/media/uapi/v4l/vbi_625.svg           |  388 +-
 Documentation/media/uapi/v4l/vbi_hsync.svg         |  238 +-
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |    6 +
 Documentation/media/v4l-drivers/imx.rst            |    7 +-
 Documentation/media/v4l-drivers/index.rst          |    1 +
 drivers/media/cec/cec-adap.c                       |    2 +-
 drivers/media/cec/cec-notifier.c                   |    6 +
 drivers/media/dvb-core/dvb_ca_en50221.c            |  143 +-
 drivers/media/dvb-core/dvb_ca_en50221.h            |    7 +
 drivers/media/dvb-frontends/cxd2841er.c            |    5 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  |   15 +-
 drivers/media/dvb-frontends/lnbh25.c               |    6 +-
 drivers/media/dvb-frontends/stv0367.c              |  210 +-
 drivers/media/i2c/et8ek8/et8ek8_driver.c           |    1 -
 drivers/media/i2c/tvp5150.c                        |   25 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |  102 +-
 drivers/media/pci/ngene/ngene-core.c               |   32 +-
 drivers/media/pci/ngene/ngene-i2c.c                |    6 +-
 drivers/media/pci/ngene/ngene.h                    |    6 +-
 drivers/media/pci/tw5864/tw5864-video.c            |    1 +
 drivers/media/platform/Kconfig                     |    4 +-
 drivers/media/platform/coda/coda-bit.c             |    8 +-
 drivers/media/platform/coda/coda-common.c          |    4 +-
 drivers/media/platform/coda/coda.h                 |    2 +-
 drivers/media/platform/davinci/ccdc_hw_device.h    |   10 -
 drivers/media/platform/davinci/dm355_ccdc.c        |   92 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |  151 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   93 -
 drivers/media/platform/davinci/vpif_capture.c      |    2 -
 drivers/media/platform/davinci/vpif_display.c      |    2 -
 drivers/media/platform/omap/omap_vout_vrfb.c       |  133 +-
 drivers/media/platform/omap/omap_voutdef.h         |    6 +-
 drivers/media/platform/qcom/venus/core.c           |   18 +-
 drivers/media/platform/qcom/venus/core.h           |    1 -
 drivers/media/platform/qcom/venus/firmware.c       |   76 +-
 drivers/media/platform/qcom/venus/firmware.h       |    5 +-
 drivers/media/platform/qcom/venus/hfi_msgs.c       |   11 +-
 drivers/media/platform/sti/bdisp/bdisp-debug.c     |   14 +-
 drivers/media/platform/vimc/vimc-capture.c         |   15 +-
 drivers/media/platform/vimc/vimc-debayer.c         |   15 +-
 drivers/media/platform/vimc/vimc-scaler.c          |   15 +-
 drivers/media/platform/vimc/vimc-sensor.c          |   15 +-
 drivers/media/radio/radio-wl1273.c                 |   15 +-
 drivers/media/rc/ir-lirc-codec.c                   |    2 +-
 drivers/media/tuners/fc0011.c                      |    1 +
 drivers/media/tuners/mxl5005s.c                    |    2 -
 drivers/media/usb/au0828/au0828-input.c            |    2 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |   10 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |   38 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   18 +
 drivers/media/usb/em28xx/em28xx-dvb.c              |    1 +
 drivers/media/usb/em28xx/em28xx-i2c.c              |    2 -
 drivers/media/usb/em28xx/em28xx-input.c            |    2 +-
 drivers/media/usb/em28xx/em28xx.h                  |    1 +
 drivers/media/usb/pulse8-cec/pulse8-cec.c          |    2 +-
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c  |   18 +-
 drivers/media/usb/stkwebcam/stk-sensor.c           |   32 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |   70 +-
 drivers/media/usb/stkwebcam/stk-webcam.h           |    6 -
 drivers/media/v4l2-core/tuner-core.c               |    2 -
 drivers/staging/media/atomisp/i2c/ap1302.h         |    4 +-
 drivers/staging/media/atomisp/i2c/gc0310.h         |    2 +-
 drivers/staging/media/atomisp/i2c/gc2235.h         |    2 +-
 drivers/staging/media/atomisp/i2c/imx/imx.h        |    2 +-
 drivers/staging/media/atomisp/i2c/ov2680.h         |    3 +-
 drivers/staging/media/atomisp/i2c/ov2722.h         |    2 +-
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h  |    2 +-
 drivers/staging/media/atomisp/i2c/ov8858.h         |    2 +-
 drivers/staging/media/atomisp/i2c/ov8858_btns.h    |    2 +-
 .../staging/media/atomisp/pci/atomisp2/Makefile    |   10 +-
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |    2 +-
 drivers/staging/media/cxd2099/cxd2099.c            |  165 +-
 drivers/staging/media/cxd2099/cxd2099.h            |    6 +-
 include/media/cec-notifier.h                       |   15 +
 include/media/davinci/dm644x_ccdc.h                |   12 -
 include/media/davinci/vpfe_capture.h               |   10 -
 91 files changed, 5162 insertions(+), 14173 deletions(-)
