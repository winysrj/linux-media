Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56853 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229AbbKCPr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 10:47:27 -0500
Date: Tue, 3 Nov 2015 13:47:20 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [GIT PULL for v4.4-rc1] media updates
Message-ID: <20151103134720.714e5049@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.4-1

For the media updates, including:
- Lots of improvements at the kABI documentation;
- Split of Videobuf2 into a common part and a V4L2 specific one;
- Split of the VB2 tracing events into a separate header file;
- s5p-mfc got support for Exynos 5433;
- v4l2 fixes for 64-bits alignment when running 32 bits userspace on ARM;
- Added support for SDR radio transmitter at core, vivid and hackrf drivers;
- Some y2038 fixups;
- Some improvements at V4L2 colorspace support;
- saa7164 converted to use the V4L2 core control framework;
- several new boards additions, cleanups and fixups.

Thanks!
Mauro

PS.: There are two patches for scripts/kernel-doc that are needed by the
documentation patches on Media. Jon is OK on merging those via my tree.

---

The following changes since commit 6ff33f3902c3b1c5d0db6b1e2c70b6d76fba357f:

  Linux 4.3-rc1 (2015-09-12 16:35:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.4-1

for you to fetch changes up to 79f5b6ae960d380c829fb67d5dadcd1d025d2775:

  [media] c8sectpfe: Remove select on CONFIG_FW_LOADER_USER_HELPER_FALLBACK (2015-10-20 16:02:41 -0200)

----------------------------------------------------------------
media updates for v4.4-rc1

----------------------------------------------------------------
Alexander Kuleshov (1):
      [media] media/pci/cobalt: Use %*ph to print small buffers

Andrew Milkovich (1):
      [media] Staging: media: bcm2048: warnings for uninitialized variables fixed

Andrzej Hajda (6):
      [media] v4l2-compat-ioctl32: fix alignment for ARM64
      [media] cx231xx: fix handling cx231xx_read_i2c_data result
      [media] staging: media: omap4iss: fix handling platform_get_irq result
      [media] media: am437x-vpfe: fix handling platform_get_irq result
      [media] s5p-mfc: end-of-stream handling for newer encoders
      [media] s5p-mfc: use MFC_BUF_FLAG_EOS to identify last buffers in decoder capture queue

Andrzej Pietrasiewicz (2):
      [media] s5p-jpeg: add support for 5433
      [media] MAINTAINERS: add exynos jpeg codec maintainers

Antonio Ospite (1):
      [media] media/v4l2-ctrls: fix setting autocluster to manual with VIDIOC_S_CTRL

Antti Palosaari (15):
      [media] vivid: SDR cap: add control for FM deviation
      [media] vivid: sdr cap: few enhancements
      [media] v4l2: rename V4L2_TUNER_ADC to V4L2_TUNER_SDR
      [media] v4l2: add RF gain control
      [media] DocBook: document tuner RF gain control
      [media] v4l2: add support for SDR transmitter
      [media] DocBook: document SDR transmitter
      [media] v4l: add type field to v4l2_modulator struct
      [media] DocBook: add modulator type field
      [media] hackrf: add control for RF amplifier
      [media] hackrf: switch to single function which configures everything
      [media] hackrf: add support for transmitter
      [media] hackrf: do not set human readable name for formats
      [media] DocBook: add SDR specific info to G_TUNER / S_TUNER
      [media] DocBook: add SDR specific info to G_MODULATOR / S_MODULATOR

Arnd Bergmann (2):
      [media] exynos4-is: use monotonic timestamps as advertized
      [media] use v4l2_get_timestamp where possible

Benoit Parrot (1):
      [media] media: v4l2-ctrls: Fix 64bit support in get_ctrl()

Darek Zielski (1):
      [media] saa7134: add Leadtek Winfast TV2100 FM card support

Erik Andresen (1):
      [media] Add Terratec H7 Revision 4 to DVBSky driver

Ezequiel Garcia (2):
      [media] vivid: Fix iteration in driver removal path
      [media] vivid: Add an option to configure the maximum number of devices

Fengguang Wu (1):
      [media] i2c: fix platform_no_drv_owner.cocci warnings

Geert Uytterhoeven (3):
      [media] rcar_vin: Remove obsolete r8a779x-vin platform_device_id entries
      [media] atmel-isi: Protect PM-only functions to kill warning
      [media] VIDEO_RENESAS_JPU should depend on HAS_DMA

Geliang Tang (1):
      [media] media: fix kernel-doc warnings in v4l2-dv-timings.h

Graham Eccleston (1):
      [media] Compro U650F support

Hans Verkuil (26):
      [media] v4l2-compat-ioctl32: replace pr_warn by pr_debug
      [media] vivid: use ARRAY_SIZE to calculate max control value
      [media] vivid: use Bradford method when converting Rec. 709 to NTSC 1953
      [media] videodev2.h: add support for the DCI-P3 colorspace
      [media] DocBook media: document the new DCI-P3 colorspace
      [media] vivid-tpg: support the DCI-P3 colorspace
      [media] vivid: add support for the DCI-P3 colorspace
      [media] videodev2.h: add SMPTE 2084 transfer function define
      [media] vivid-tpg: add support for SMPTE 2084 transfer function
      [media] vivid: add support for SMPTE 2084 transfer function
      [media] DocBook media: Document the SMPTE 2084 transfer function
      [media] vim2m: small cleanup: use assignment instead of memcpy
      [media] v4l2-compat-ioctl32: add missing SDR support
      [media] vivid: add 10 and 12 bit Bayer formats
      [media] saa7164: convert to the control framework
      [media] saa7164: add v4l2_fh support
      [media] saa7164: fix poll bugs
      [media] saa7164: add support for control events
      [media] saa7164: fix format ioctls
      [media] saa7164: remove unused videobuf references
      [media] saa7164: fix input and tuner compliance problems
      [media] saa7164: video and vbi ports share the same input/tuner/std
      [media] v4l2-ctrls: arrays are also considered compound controls
      [media] DocBook/media: clarify control documentation
      [media] cobalt: fix Kconfig dependency
      [media] DocBook media: update copyright/version numbers

Ingi Kim (1):
      [media] s5p-mfc: fix spelling errors

Jan Kara (1):
      [media] ivtv: Convert to get_user_pages_unlocked()

Javier Martinez Canillas (4):
      [media] s5c73m3: Export OF module alias information
      [media] go7007: Fix returned errno code in gen_mjpeghdr_to_package()
      [media] tvp5150: add support for asynchronous probing
      [media] smiapp: Export OF module alias information

Jean-Michel Hautbois (1):
      [media] DocBook media: Fix a typo in encoder cmd

Joe Perches (1):
      [media] s5p-mfc: Correct misuse of %0x<decimal>

Josh Wu (6):
      [media] soc-camera: increase the length of clk_name on soc_of_bind()
      [media] atmel-isi: increase timeout to disable/enable isi
      [media] atmel-isi: setup the ISI_CFG2 register directly
      [media] atmel-isi: move configure_geometry() to start_streaming()
      [media] atmel-isi: add sanity check for supported formats in try/set_fmt()
      [media] atmel-isi: parse the DT parameters for vsync/hsync/pixclock polarity

Junghak Sung (6):
      [media] media: videobuf2: Replace videobuf2-core with videobuf2-v4l2
      [media] media: videobuf2: Restructure vb2_buffer
      [media] media: videobuf2: Change queue_setup argument
      [media] media: videobuf2: Replace v4l2-specific data with vb2 data
      [media] media: videobuf2: Prepare to divide videobuf2
      [media] media: videobuf2: Move v4l2-specific stuff to videobuf2-v4l2

Laurent Pinchart (4):
      [media] uvcvideo: Disable hardware timestamps by default
      [media] v4l: atmel-isi: Simplify error handling during DT parsing
      [media] v4l: atmel-isi: Remove support for platform data
      [media] v4l: atmel-isi: Remove unused platform data fields

Luis de Bethencourt (1):
      [media] cx25821, cx88, tm6000: use SNDRV_DEFAULT_ENABLE_PNP

Maciek Borzecki (2):
      [media] staging: lirc: lirc_serial: use dynamic debugs
      [media] staging: lirc: fix indentation

Marek Szyprowski (1):
      [media] s5p-jpeg: generalize clocks handling

Mauro Carvalho Chehab (42):
      Merge tag 'v4.3-rc1' into patchwork
      [media] s5p-jpeg: remove unused var
      [media] DocBook: add the new videobuf2-v4l2 header
      [media] dvbdev: Remove two cut-and-paste errors
      [media] DocBook: Fix documentation for struct v4l2_dv_timings
      [media] DocBook: fix most of warnings at videobuf2-core.h
      [media] DocBook: Remove a warning at videobuf2-v4l2.h
      Revert "[media] rcar_vin: call g_std() instead of querystd()"
      [media] media-entity.c: get rid of var length arrays
      [media] s5c73m3: fix a sparse warning
      [media] netup_unidvb: remove most of the sparse warnings
      [media] netup_unidvb_ci: Fix dereference of noderef expression
      [media] mipi-csis: make sparse happy
      [media] c8sectpfe: fix namespace on memcpy/memset
      [media] rcar_jpu: Fix namespace for two __be16 vars
      [media] DocBook: Fix remaining issues with VB2 core documentation
      [media] DocBook: Document include/media/tuner.h
      [media] tuner.h: Make checkpatch.pl happier
      [media] DocBook: convert struct tuner_parms to doc-nano format
      [media] DocBook: add documentation for tuner-types.h
      [media] tveeprom: Remove two unused fields from struct
      [media] DocBook: Document tveeprom.h
      [media] DocBook: Convert struct lirc_driver to doc-nano format
      [media] lirc_dev.h: Make checkpatch happy
      [media] DocBook: document struct dvb_ca_en50221
      [media] dvb_ca_en50221.h: Make checkpatch.pl happy
      [media] DocBook: Move struct dmx_demux kABI doc to demux.h
      [media] DocBook: update documented fields at struct dmx_demux
      [media] dvb: don't keep support for undocumented features
      [media] DocBook: finish documenting struct dmx_demux
      [media] dvb: get rid of enum dmx_success
      [media] dvb: Remove unused frontend sources at demux.h and sync doc
      [media] DocBook: document the other structs/enums of demux.h
      [media] demux.h: make checkpatch.ph happy
      kernel-doc: Add a parser for function typedefs
      kernel-doc: better format typedef function output
      [media] DocBook: document typedef dmx_ts_cb at demux.h
      [media] DocBook: document typedef dmx_section_cb at demux.h
      [media] demux.h: Convert TS filter type into enum
      [media] demux.h: Convert MPEG-TS demux caps to an enum
      [media] DocBook: Add documentation about the demux API
      [media] DocBook: Remove kdapi.xml

Nicolas Sugino (1):
      [media] ivtv-alsa: Add index to specify device number

Rasmus Villemoes (1):
      [media] drxd: use kzalloc in drxd_attach()

Ricardo Ribalda Delgado (2):
      [media] videodev2.h: Fix typo in comment
      [media] media/v4l2-compat-ioctl32: Simple stylechecks

Salva Peiró (1):
      [media] media/vivid-osd: fix info leak in ioctl

Sergei Shtylyov (3):
      [media] rcar_vin: propagate querystd() error upstream
      [media] rcar_vin: call g_std() instead of querystd()
      [media] ml86v7667: implement g_std() method

Takashi Iwai (1):
      [media] c8sectpfe: Remove select on CONFIG_FW_LOADER_USER_HELPER_FALLBACK

Tiffany Lin (2):
      [media] media: vb2 dma-contig: Fully cache synchronise buffers in prepare and finish
      [media] media: vb2 dma-sg: Fully cache synchronise buffers in prepare and finish

Zahari Doychev (1):
      [media] m2m: fix bad unlock balance

 Documentation/DocBook/device-drivers.tmpl                        |   81 +-
 Documentation/DocBook/media/dvb/dvbapi.xml                       |    3 -
 Documentation/DocBook/media/dvb/kdapi.xml                        | 2309 --
 Documentation/DocBook/media/v4l/biblio.xml                       |   18 +
 Documentation/DocBook/media/v4l/compat.xml                       |   20 +
 Documentation/DocBook/media/v4l/controls.xml                     |   14 +
 Documentation/DocBook/media/v4l/dev-sdr.xml                      |   32 +-
 Documentation/DocBook/media/v4l/io.xml                           |   10 +-
 Documentation/DocBook/media/v4l/pixfmt.xml                       |  111 +-
 Documentation/DocBook/media/v4l/v4l2.xml                         |   13 +-
 Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml           |    2 +-
 Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml           |    7 +
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml                 |    2 +-
 Documentation/DocBook/media/v4l/vidioc-g-modulator.xml           |   14 +-
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml               |   16 +
 Documentation/DocBook/media/v4l/vidioc-querycap.xml              |    6 +
 Documentation/DocBook/media/v4l/vidioc-queryctrl.xml             |   21 +-
 Documentation/DocBook/media_api.tmpl                             |    2 +-
 Documentation/devicetree/bindings/media/exynos-jpeg-codec.txt    |    3 +-
 Documentation/video4linux/CARDLIST.saa7134                       |    1 +
 Documentation/video4linux/v4l2-pci-skeleton.c                    |    4 +-
 MAINTAINERS                                                      |    8 +
 drivers/input/touchscreen/sur40.c                                |   20 +-
 drivers/media/dvb-core/demux.h                                   |  619 +-
 drivers/media/dvb-core/dmxdev.c                                  |   10 +-
 drivers/media/dvb-core/dvb-usb-ids.h                             |    1 +
 drivers/media/dvb-core/dvb_ca_en50221.h                          |   99 +-
 drivers/media/dvb-core/dvb_demux.c                               |   11 +-
 drivers/media/dvb-core/dvb_net.c                                 |    5 +-
 drivers/media/dvb-core/dvbdev.h                                  |    4 -
 drivers/media/dvb-frontends/drxd_hard.c                          |    3 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c                        |   23 +-
 drivers/media/i2c/ml86v7667.c                                    |   11 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c                         |    2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c                          |    1 +
 drivers/media/i2c/smiapp/smiapp-core.c                           |    1 +
 drivers/media/i2c/tvp5150.c                                      |   14 +-
 drivers/media/media-entity.c                                     |    4 +-
 drivers/media/pci/bt8xx/bttv-driver.c                            |    5 +-
 drivers/media/pci/cobalt/Kconfig                                 |    2 +-
 drivers/media/pci/cobalt/cobalt-cpld.c                           |    8 +-
 drivers/media/pci/cobalt/cobalt-driver.h                         |    6 +-
 drivers/media/pci/cobalt/cobalt-irq.c                            |    7 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c                           |   24 +-
 drivers/media/pci/cx18/cx18-mailbox.c                            |    2 +-
 drivers/media/pci/cx23885/cx23885-417.c                          |   13 +-
 drivers/media/pci/cx23885/cx23885-core.c                         |   24 +-
 drivers/media/pci/cx23885/cx23885-dvb.c                          |   11 +-
 drivers/media/pci/cx23885/cx23885-vbi.c                          |   18 +-
 drivers/media/pci/cx23885/cx23885-video.c                        |   29 +-
 drivers/media/pci/cx23885/cx23885.h                              |    2 +-
 drivers/media/pci/cx25821/cx25821-alsa.c                         |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c                        |   24 +-
 drivers/media/pci/cx25821/cx25821.h                              |    3 +-
 drivers/media/pci/cx88/cx88-alsa.c                               |    2 +-
 drivers/media/pci/cx88/cx88-blackbird.c                          |   15 +-
 drivers/media/pci/cx88/cx88-core.c                               |    8 +-
 drivers/media/pci/cx88/cx88-dvb.c                                |   13 +-
 drivers/media/pci/cx88/cx88-mpeg.c                               |   14 +-
 drivers/media/pci/cx88/cx88-vbi.c                                |   19 +-
 drivers/media/pci/cx88/cx88-video.c                              |   21 +-
 drivers/media/pci/cx88/cx88.h                                    |    2 +-
 drivers/media/pci/dt3155/dt3155.c                                |   20 +-
 drivers/media/pci/dt3155/dt3155.h                                |    3 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c                          |   14 +-
 drivers/media/pci/ivtv/ivtv-yuv.c                                |   12 +-
 drivers/media/pci/netup_unidvb/netup_unidvb.h                    |    4 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_ci.c                 |   10 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c               |   35 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c                |    2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c                |    4 +-
 drivers/media/pci/saa7134/saa7134-cards.c                        |   43 +
 drivers/media/pci/saa7134/saa7134-core.c                         |   14 +-
 drivers/media/pci/saa7134/saa7134-input.c                        |    7 +
 drivers/media/pci/saa7134/saa7134-ts.c                           |   16 +-
 drivers/media/pci/saa7134/saa7134-vbi.c                          |   12 +-
 drivers/media/pci/saa7134/saa7134-video.c                        |   23 +-
 drivers/media/pci/saa7134/saa7134.h                              |    5 +-
 drivers/media/pci/saa7164/Kconfig                                |    1 -
 drivers/media/pci/saa7164/saa7164-encoder.c                      |  653 +-
 drivers/media/pci/saa7164/saa7164-vbi.c                          |  629 +-
 drivers/media/pci/saa7164/saa7164.h                              |   26 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c                   |   48 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c                       |   21 +-
 drivers/media/pci/solo6x10/solo6x10.h                            |    4 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c                          |   28 +-
 drivers/media/pci/ttpci/av7110.c                                 |    9 +-
 drivers/media/pci/ttpci/av7110_av.c                              |    6 +-
 drivers/media/pci/tw68/tw68-video.c                              |   22 +-
 drivers/media/pci/tw68/tw68.h                                    |    3 +-
 drivers/media/platform/Kconfig                                   |    2 +-
 drivers/media/platform/am437x/am437x-vpfe.c                      |   43 +-
 drivers/media/platform/am437x/am437x-vpfe.h                      |    3 +-
 drivers/media/platform/blackfin/bfin_capture.c                   |   37 +-
 drivers/media/platform/coda/coda-bit.c                           |  135 +-
 drivers/media/platform/coda/coda-common.c                        |   26 +-
 drivers/media/platform/coda/coda-jpeg.c                          |    6 +-
 drivers/media/platform/coda/coda.h                               |    8 +-
 drivers/media/platform/coda/trace.h                              |   18 +-
 drivers/media/platform/davinci/vpbe_display.c                    |   34 +-
 drivers/media/platform/davinci/vpif_capture.c                    |   33 +-
 drivers/media/platform/davinci/vpif_capture.h                    |    2 +-
 drivers/media/platform/davinci/vpif_display.c                    |   42 +-
 drivers/media/platform/davinci/vpif_display.h                    |    2 +-
 drivers/media/platform/exynos-gsc/gsc-core.h                     |    4 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c                      |   25 +-
 drivers/media/platform/exynos4-is/fimc-capture.c                 |   33 +-
 drivers/media/platform/exynos4-is/fimc-core.c                    |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.h                    |    4 +-
 drivers/media/platform/exynos4-is/fimc-is.h                      |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c               |   18 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.h               |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp.h                     |    4 +-
 drivers/media/platform/exynos4-is/fimc-lite.c                    |   25 +-
 drivers/media/platform/exynos4-is/fimc-lite.h                    |    4 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c                     |   23 +-
 drivers/media/platform/exynos4-is/mipi-csis.c                    |    3 +-
 drivers/media/platform/m2m-deinterlace.c                         |   25 +-
 drivers/media/platform/marvell-ccic/mcam-core.c                  |   46 +-
 drivers/media/platform/marvell-ccic/mcam-core.h                  |    2 +-
 drivers/media/platform/mx2_emmaprp.c                             |   17 +-
 drivers/media/platform/omap3isp/ispstat.c                        |    5 +-
 drivers/media/platform/omap3isp/ispstat.h                        |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c                       |   27 +-
 drivers/media/platform/omap3isp/ispvideo.h                       |    4 +-
 drivers/media/platform/rcar_jpu.c                                |   68 +-
 drivers/media/platform/s3c-camif/camif-capture.c                 |   26 +-
 drivers/media/platform/s3c-camif/camif-core.c                    |    2 +-
 drivers/media/platform/s3c-camif/camif-core.h                    |    4 +-
 drivers/media/platform/s5p-g2d/g2d.c                             |   19 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c                      |  475 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.h                      |   41 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c                |   80 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.h                |   11 +-
 drivers/media/platform/s5p-jpeg/jpeg-regs.h                      |   85 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c                         |  106 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h                  |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c                     |   40 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c                     |   75 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c                  |   46 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c                  |   68 +-
 drivers/media/platform/s5p-tv/mixer.h                            |    4 +-
 drivers/media/platform/s5p-tv/mixer_grp_layer.c                  |    2 +-
 drivers/media/platform/s5p-tv/mixer_reg.c                        |    2 +-
 drivers/media/platform/s5p-tv/mixer_video.c                      |   13 +-
 drivers/media/platform/s5p-tv/mixer_vp_layer.c                   |    5 +-
 drivers/media/platform/sh_veu.c                                  |   22 +-
 drivers/media/platform/sh_vou.c                                  |   29 +-
 drivers/media/platform/soc_camera/atmel-isi.c                    |  153 +-
 {include/media => drivers/media/platform/soc_camera}/atmel-isi.h |    7 +-
 drivers/media/platform/soc_camera/mx2_camera.c                   |   24 +-
 drivers/media/platform/soc_camera/mx3_camera.c                   |   30 +-
 drivers/media/platform/soc_camera/rcar_vin.c                     |   64 +-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c         |   63 +-
 drivers/media/platform/soc_camera/soc_camera.c                   |    4 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                    |   26 +-
 drivers/media/platform/sti/c8sectpfe/Kconfig                     |    1 -
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c            |    4 +-
 drivers/media/platform/ti-vpe/vpe.c                              |   44 +-
 drivers/media/platform/vim2m.c                                   |   57 +-
 drivers/media/platform/vivid/Kconfig                             |    8 +
 drivers/media/platform/vivid/vivid-core.c                        |    7 +-
 drivers/media/platform/vivid/vivid-core.h                        |    6 +-
 drivers/media/platform/vivid/vivid-ctrls.c                       |   55 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c                 |   73 +-
 drivers/media/platform/vivid/vivid-kthread-out.c                 |   34 +-
 drivers/media/platform/vivid/vivid-osd.c                         |    1 +
 drivers/media/platform/vivid/vivid-sdr-cap.c                     |   83 +-
 drivers/media/platform/vivid/vivid-tpg-colors.c                  |  328 +-
 drivers/media/platform/vivid/vivid-tpg-colors.h                  |    4 +-
 drivers/media/platform/vivid/vivid-tpg.c                         |   91 +
 drivers/media/platform/vivid/vivid-vbi-cap.c                     |   40 +-
 drivers/media/platform/vivid/vivid-vbi-out.c                     |   20 +-
 drivers/media/platform/vivid/vivid-vid-cap.c                     |   18 +-
 drivers/media/platform/vivid/vivid-vid-common.c                  |   56 +
 drivers/media/platform/vivid/vivid-vid-out.c                     |   18 +-
 drivers/media/platform/vsp1/vsp1_rpf.c                           |    4 +-
 drivers/media/platform/vsp1/vsp1_video.c                         |   23 +-
 drivers/media/platform/vsp1/vsp1_video.h                         |    8 +-
 drivers/media/platform/vsp1/vsp1_wpf.c                           |    4 +-
 drivers/media/platform/xilinx/xilinx-dma.c                       |   29 +-
 drivers/media/platform/xilinx/xilinx-dma.h                       |    2 +-
 drivers/media/usb/airspy/airspy.c                                |   26 +-
 drivers/media/usb/au0828/au0828-vbi.c                            |   10 +-
 drivers/media/usb/au0828/au0828-video.c                          |   48 +-
 drivers/media/usb/au0828/au0828.h                                |    3 +-
 drivers/media/usb/cx231xx/cx231xx-video.c                        |    3 +-
 drivers/media/usb/dvb-usb-v2/dvbsky.c                            |    4 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c                          |    2 +
 drivers/media/usb/em28xx/em28xx-vbi.c                            |   10 +-
 drivers/media/usb/em28xx/em28xx-video.c                          |   37 +-
 drivers/media/usb/em28xx/em28xx.h                                |    3 +-
 drivers/media/usb/go7007/go7007-driver.c                         |   29 +-
 drivers/media/usb/go7007/go7007-fw.c                             |    6 +-
 drivers/media/usb/go7007/go7007-priv.h                           |    4 +-
 drivers/media/usb/go7007/go7007-v4l2.c                           |   22 +-
 drivers/media/usb/gspca/gspca.c                                  |    4 +-
 drivers/media/usb/hackrf/hackrf.c                                | 1086 +-
 drivers/media/usb/msi2500/msi2500.c                              |   19 +-
 drivers/media/usb/pwc/pwc-if.c                                   |   35 +-
 drivers/media/usb/pwc/pwc-uncompress.c                           |    6 +-
 drivers/media/usb/pwc/pwc.h                                      |    4 +-
 drivers/media/usb/s2255/s2255drv.c                               |   29 +-
 drivers/media/usb/stk1160/stk1160-v4l.c                          |   17 +-
 drivers/media/usb/stk1160/stk1160-video.c                        |   12 +-
 drivers/media/usb/stk1160/stk1160.h                              |    4 +-
 drivers/media/usb/tm6000/tm6000-alsa.c                           |    2 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c                          |   12 +-
 drivers/media/usb/usbtv/usbtv-video.c                            |   24 +-
 drivers/media/usb/usbtv/usbtv.h                                  |    3 +-
 drivers/media/usb/uvc/uvc_driver.c                               |    3 +
 drivers/media/usb/uvc/uvc_queue.c                                |   29 +-
 drivers/media/usb/uvc/uvc_video.c                                |   23 +-
 drivers/media/usb/uvc/uvcvideo.h                                 |    7 +-
 drivers/media/v4l2-core/Makefile                                 |    4 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c                    |   51 +-
 drivers/media/v4l2-core/v4l2-ctrls.c                             |   14 +-
 drivers/media/v4l2-core/v4l2-dev.c                               |   14 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                             |   51 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c                           |   33 +-
 drivers/media/v4l2-core/v4l2-trace.c                             |   10 +-
 drivers/media/v4l2-core/vb2-trace.c                              |    9 +
 drivers/media/v4l2-core/videobuf-core.c                          |    4 +-
 drivers/media/v4l2-core/videobuf2-core.c                         | 2038 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c                   |    7 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c                       |    7 +-
 drivers/media/v4l2-core/videobuf2-internal.h                     |  161 +
 drivers/media/v4l2-core/videobuf2-memops.c                       |    2 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c                         | 1661 +
 drivers/media/v4l2-core/videobuf2-vmalloc.c                      |    2 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c                    |   20 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c                  |   45 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.h                  |    3 +-
 drivers/staging/media/lirc/lirc_sasem.c                          |    2 +-
 drivers/staging/media/lirc/lirc_serial.c                         |   32 +-
 drivers/staging/media/omap4iss/iss.c                             |    5 +-
 drivers/staging/media/omap4iss/iss_video.c                       |   26 +-
 drivers/staging/media/omap4iss/iss_video.h                       |    6 +-
 drivers/usb/gadget/function/uvc_queue.c                          |   28 +-
 drivers/usb/gadget/function/uvc_queue.h                          |    4 +-
 include/media/davinci/vpbe_display.h                             |    3 +-
 include/media/lirc_dev.h                                         |  120 +-
 include/media/media-entity.h                                     |    7 +
 include/media/soc_camera.h                                       |    2 +-
 include/media/tuner-types.h                                      |  182 +-
 include/media/tuner.h                                            |  152 +-
 include/media/tveeprom.h                                         |   83 +-
 include/media/v4l2-dv-timings.h                                  |   34 +-
 include/media/v4l2-ioctl.h                                       |    8 +
 include/media/v4l2-mem2mem.h                                     |   11 +-
 include/media/videobuf2-core.h                                   |  235 +-
 include/media/videobuf2-dma-contig.h                             |    2 +-
 include/media/videobuf2-dma-sg.h                                 |    2 +-
 include/media/videobuf2-dvb.h                                    |    8 +-
 include/media/videobuf2-memops.h                                 |    2 +-
 include/media/videobuf2-v4l2.h                                   |  149 +
 include/media/videobuf2-vmalloc.h                                |    2 +-
 include/trace/events/v4l2.h                                      |   63 +-
 include/trace/events/vb2.h                                       |   65 +
 include/uapi/linux/v4l2-controls.h                               |    1 +
 include/uapi/linux/videodev2.h                                   |   34 +-
 scripts/kernel-doc                                               |   25 +
 262 files changed, 7846 insertions(+), 7866 deletions(-)
 delete mode 100644 Documentation/DocBook/media/dvb/kdapi.xml
 rename {include/media => drivers/media/platform/soc_camera}/atmel-isi.h (95%)
 create mode 100644 drivers/media/v4l2-core/vb2-trace.c
 create mode 100644 drivers/media/v4l2-core/videobuf2-internal.h
 create mode 100644 drivers/media/v4l2-core/videobuf2-v4l2.c
 create mode 100644 include/media/videobuf2-v4l2.h
 create mode 100644 include/trace/events/vb2.h

