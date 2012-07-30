Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab2G3S5f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 14:57:35 -0400
Message-ID: <5016D918.3050404@redhat.com>
Date: Mon, 30 Jul 2012 15:57:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.6-rc1] media updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

This is the first part of the media patches for v3.6. During my 3-weeks vacation
that finished yesterday, I got about 400 patches on my queue. My intention is
to handle at least part of the pending stuff today, sending you another pull
request tomorrow with some other stuff that are mature enough for v3.6.

This patch series contain:
	- new DVB frontend: rtl2832;
	- new video drivers: adv7393;
	- some unused files got removed;
	- a selection API cleanup between V4L2 and V4L2 subdev API's;
	- a major redesign at v4l-ioctl2, in order to clean it up;
	- several driver fixes and improvements.

Thanks!
Mauro

-

Latest commit at the branch: 
c893e7c64e36087dceb4662917976a81d1754fc0 Merge branch 'patches_for_v3.6' into v4l_for_linus
The following changes since commit ec3ed85f926f4e900bc48cec6e72abbe6475321f:

  [media] Revert "[media] V4L: JPEG class documentation corrections" (2012-07-07 00:12:50 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to c893e7c64e36087dceb4662917976a81d1754fc0:

  Merge branch 'patches_for_v3.6' into v4l_for_linus (2012-07-30 14:22:44 -0300)

----------------------------------------------------------------

Albert Wang (1):
      [media] videobuf2: correct the #ifndef text mistake in videobuf2-dma-contig.h

Andy Shevchenko (1):
      [media] media: dvb-usb: print mac address via native %pM

Antti Palosaari (5):
      [media] tda10071: fix DiSEqC message len check
      [media] tda10071: use decimal numbers for indexes and lengths
      [media] tda10071: convert Kernel dev_* logging
      [media] a8293: fix register 00 init value
      [media] a8293: use Kernel dev_* logging

Benoît Thébaudeau (4):
      [media] media: gpio-ir-recv: fix missing udev by-path entry
      [media] media: gpio-ir-recv: add map name
      [media] media: gpio-ir-recv: switch to module_platform_driver
      media: add Analog Devices ADV7393 video encoder driver

Dan Carpenter (3):
      [media] videobuf-dma-contig: use gfp_t for GFP flags
      [media] staging: solo6x10: fix | vs &
      [media] drxk: fix a '&' vs '|' bug

Daniel Glöckner (10):
      [media] tvaudio: fix TDA9873 constants
      [media] tvaudio: fix tda8425_setmode
      [media] tvaudio: use V4L2_TUNER_MODE_SAP for TDA985x SAP
      [media] tvaudio: remove watch_stereo
      [media] tvaudio: don't use thread for TA8874Z
      [media] tvaudio: use V4L2_TUNER_SUB_* for bitfields
      [media] tvaudio: obey V4L2 tuner audio matrix
      [media] tvaudio: support V4L2_TUNER_MODE_LANG1_LANG2
      [media] tvaudio: don't report mono when stereo is received
      [media] tvaudio: rename getmode and setmode

David Dillow (2):
      [media] cx231xx: use TRANSFER_TYPE enum for cleanup
      [media] cx231xx: don't DMA to random addresses

Dmitry Lifshitz (1):
      [media] tvp5150: fix kernel crash if chip is unavailable

Du, Changbin (1):
      [media] media: gpio-ir-recv: add allowed_protos for platform data

Ezequiel García (6):
      [media] em28xx: Make em28xx_ir_change_protocol a static function
      [media] em28xx: Fix wrong AC97 mic register usage
      [media] em28xx: Rename AC97 registers to use sound/ac97_codec.h definitions
      [media] em28xx: Remove unused AC97 register definitions
      [media] em28xx: Make a few drxk_config structs static
      [media] staging: solo6x10: Fix TODO file with proper maintainer

Hans Verkuil (57):
      [media] videodev2.h: add new hwseek capability bits
      [media] v4l2 spec: document the new v4l2_tuner capabilities
      [media] S_HW_FREQ_SEEK: set capability flags and return ENODATA instead of EAGAIN
      [media] V4L2 spec: clarify a few modulator issues
      [media] V4L2 Spec: fix typo: NTSC -> NRSC
      [media] zr364xx: embed video_device and register it at the end of probe
      [media] zr364xx: introduce v4l2_device
      [media] zr364xx: convert to the control framework
      [media] zr364xx: fix querycap and fill in colorspace
      [media] zr364xx: add support for control events
      [media] zr364xx: allow multiple opens
      [media] zr364xx: add suspend/resume support
      [media] v4l2-ioctl.c: move a block of code down, no other changes
      [media] v4l2-ioctl.c: introduce INFO_FL_CLEAR to replace switch
      [media] v4l2-ioctl.c: v4l2-ioctl: add debug and callback/offset functionality
      [media] v4l2-ioctl.c: remove an unnecessary #ifdef
      [media] v4l2-ioctl.c: use the new table for querycap and i/o ioctls
      [media] v4l2-ioctl.c: use the new table for priority ioctls
      [media] v4l2-ioctl.c: use the new table for format/framebuffer ioctls
      [media] v4l2-ioctl.c: use the new table for overlay/streamon/off ioctls
      [media] v4l2-ioctl.c: use the new table for std/tuner/modulator ioctls
      [media] v4l2-ioctl.c: use the new table for queuing/parm ioctls
      [media] v4l2-ioctl.c: use the new table for control ioctls
      [media] v4l2-ioctl.c: use the new table for selection ioctls
      [media] v4l2-ioctl.c: use the new table for compression ioctls
      [media] v4l2-ioctl.c: use the new table for debug ioctls
      [media] v4l2-ioctl.c: use the new table for preset/timings ioctls
      [media] v4l2-ioctl.c: use the new table for the remaining ioctls
      [media] v4l2-ioctl.c: finalize table conversion
      [media] v4l2-dev.c: add debug sysfs entry
      [media] v4l2-ioctl: remove v4l_(i2c_)print_ioctl
      [media] ivtv: don't mess with vfd->debug
      [media] cx18: don't mess with vfd->debug
      [media] vb2-core: refactor reqbufs/create_bufs
      [media] vb2-core: add support for count == 0 in create_bufs
      [media] Spec: document CREATE_BUFS behavior if count == 0
      [media] v4l2-dev/ioctl.c: add vb2_queue support to video_device
      [media] videobuf2-core: add helper functions
      [media] vivi: remove pointless g/s_std support
      [media] vivi: embed struct video_device instead of allocating it
      [media] vivi: use vb2 helper functions
      [media] vivi: add create_bufs/preparebuf support
      [media] v4l2-dev.c: also add debug support for the fops
      [media] pwc: use the new vb2 helpers
      [media] pwc: v4l2-compliance fixes
      [media] v4l2-framework.txt: Update the locking documentation
      [media] cx88: fix querycap
      [media] cx88: first phase to convert cx88 to the control framework
      [media] cx88: each device node gets the right controls
      [media] cx88: convert cx88-blackbird to the control framework
      [media] cx88: remove radio and type from cx8800_fh
      [media] cx88: move fmt, width and height to cx8800_dev
      [media] cx88: add priority support
      [media] cx88: support control events
      [media] cx88: fix a number of v4l2-compliance violations
      [media] cx88: don't use current_norm
      [media] cx88-blackbird: replace ioctl by unlocked_ioctl

Igor M. Liplianin (1):
      [media] Terratec Cinergy S2 USB HD Rev.2

Jarod Wilson (1):
      [media] lirc_sir: make device registration work

Jayakrishnan (1):
      [media] uvcvideo: Fix frame drop in bulk video stream

Jean Delvare (1):
      [media] i2c: Export an unlocked flavor of i2c_transfer

Jean-Francois Moine (1):
      [media] gspca: Maintainer change

Joe Perches (1):
      [media] media: Use pr_info not homegrown pr_reg macro

Klaus Schmidinger (1):
      [media] DVB: stb0899: speed up getting BER values

Laurent Pinchart (5):
      [media] mt9t001: Implement V4L2_CID_PIXEL_RATE control
      [media] mt9p031: Implement V4L2_CID_PIXEL_RATE control
      [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control
      [media] uvcvideo: Document the struct uvc_xu_control_query query field
      [media] uvcvideo: Fix alternate setting selection

Luis Henriques (1):
      [media] ene_ir: Fix driver initialisation

Martin Blumenstingl (5):
      [media] Add support for downloading the firmware of the Terratec Cinergy HTC Stick HD's firmware
      [media] em28xx: Add the DRX-K at I2C address 0x29 to the list of known I2C devices
      [media] em28xx: Improve support for the Terratec Cinergy HTC Stick HD
      [media] drxk: Make the QAM demodulator command parameters configurable
      [media] drxk: Improve logging

Mauro Carvalho Chehab (28):
      Revert "[media] radio-sf16fmi: Use LM7000 driver"
      Revert "[media] radio-aimslab: Use LM7000 driver"
      Revert "[media] radio: Add Sanyo LM7000 tuner driver"
      Merge branch 'v4l_for_linus' into staging/for_v3.6
      [media] drxk: change it to use request_firmware_nowait()
      [media] drxk: pass drxk priv struct instead of I2C adapter to i2c calls
      [media] drxk: Lock I2C bus during firmware load
      [media] drxk: prevent doing something wrong when init is not ok
      [media] tuner-xc2028: use request_firmware_nowait()
      [media] tuner-core: call has_signal for both TV and radio
      [media] tuner-xc2028: Fix signal strength report
      [media] tuner, xc2028: add support for get_afc()
      [media] rtl2832: save some data space by using a macro instead of a table
      [media] xc5000: Add support for DMB-TH and ISDB-T
      [media] videobuf-core.h: remove input fields
      [media] media: reorganize the main Kconfig items
      [media] media: Remove VIDEO_MEDIA Kconfig option
      [media] media: only show V4L devices based on device type selection
      [media] v4l2-compat-ioctl32: fix compilation breakage
      [media] get_dvb_firmware: add logic to get sms1xx-hcw* firmware
      [media] Kconfig: Split the core support options from the driver ones
      [media] rc/Kconfig: Move a LIRC sub-option to the right place
      [media] uvc/Kconfig: Fix INPUT/EVDEV dependencies
      [media] tuner-xc2028: tag the usual firmwares to help dracut
      fixupSigned-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
      [media] [V3] stv090x: variable 'no_signal' set but not used
      media: Revert "[media] Terratec Cinergy S2 USB HD Rev.2"
      Merge branch 'patches_for_v3.6' into v4l_for_linus

Ondrej Zary (6):
      [media] radio: Add Sanyo LM7000 tuner driver
      [media] radio-aimslab: Use LM7000 driver
      [media] radio-sf16fmi: Use LM7000 driver
      [media] radio: Add Sanyo LM7000 tuner driver
      [media] radio-aimslab: Use LM7000 driver
      [media] radio-sf16fmi: Use LM7000 driver

Paul Bolle (1):
      [media] stradis: remove unused V4L1 headers

Peter Meerwald (3):
      [media] [trivial] v4l drivers: typo, change ctruct to struct in comment
      [media] media: remove unused element datawidth from struct mt9m111
      [media] saa7134: fix spelling of detach in label

Peter Senna Tschudin (7):
      [media] saa7146: Variable set but not used
      [media] cx231xx: Paranoic stack memory save
      [media] pvrusb2: Variables set but not used
      [media] saa7164: Variable set but not used
      [media] stv0367: variable 'tps_rcvd' set but not used
      [media] stv090x: variable 'no_signal' set but not used
      [media] s5h1420: Unused variable clock_setting

Sachin Kamat (3):
      [media] s5p-fimc: Add missing static storage class specifiers
      [media] s5p-jpeg: Use module_platform_driver in jpeg-core.c file
      [media] s5p-tv: Use module_i2c_driver in sii9234_drv.c file

Sakari Ailus (9):
      [media] v4l: Correct create_bufs documentation
      [media] v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
      [media] v4l: Remove "_ACTUAL" from subdev selection API target definition names
      [media] v4l: Unify selection targets across V4L2 and V4L2 subdev interfaces
      [media] v4l: Common documentation for selection targets
      [media] v4l: Unify selection flags
      [media] v4l: Unify selection flags documentation
      [media] v4l: Correct conflicting V4L2 subdev selection API documentation
      v4l: Export v4l2-common.h in include/linux/Kbuild

Sylwester Nawrocki (2):
      [media] V4L: Remove "_ACTIVE" from the selection target name definitions
      [media] Feature removal: V4L2 selections API target and flag definitions

Thomas Betker (1):
      [media] bttv-cards.c: Allow radio for CHP05x/CHP06x

Thomas Mair (5):
      [media] RTL2832 DVB-T demodulator driver
      [media] rtl28xxu: support for the rtl2832 demod driver
      [media] rtl28xxu: renamed rtl2831_rd/rtl2831_wr to rtl28xx_rd/rtl28xx_wr
      [media] rtl28xxu: support Delock USB 2.0 DVB-T
      [media] rtl28xxu: support Terratec Noxon DAB/DAB+ stick

Tomasz Moń (1):
      [media] v4l: mem2mem_testdev: Add horizontal and vertical flip

volokh (1):
      [media] media: video: bt8xx: Remove duplicated pixel format entry

 Documentation/DocBook/media/v4l/biblio.xml         |    2 +-
 Documentation/DocBook/media/v4l/common.xml         |   17 +-
 Documentation/DocBook/media/v4l/compat.xml         |   21 +-
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   36 +-
 Documentation/DocBook/media/v4l/io.xml             |   19 +-
 Documentation/DocBook/media/v4l/selection-api.xml  |   34 +-
 .../DocBook/media/v4l/selections-common.xml        |  164 +
 Documentation/DocBook/media/v4l/v4l2.xml           |    5 +
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |    8 +-
 .../DocBook/media/v4l/vidioc-g-frequency.xml       |    6 +
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   86 +-
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |   12 +
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |    9 +-
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |   18 +-
 .../media/v4l/vidioc-subdev-g-selection.xml        |   79 +-
 Documentation/dvb/get_dvb_firmware                 |   42 +-
 Documentation/feature-removal-schedule.txt         |   18 +
 Documentation/video4linux/v4l2-framework.txt       |   73 +-
 MAINTAINERS                                        |    3 +-
 drivers/i2c/i2c-core.c                             |   44 +-
 drivers/media/Kconfig                              |  114 +-
 drivers/media/common/tuners/Kconfig                |   64 +-
 drivers/media/common/tuners/tuner-xc2028.c         |  249 +-
 drivers/media/common/tuners/xc5000.c               |    6 +
 drivers/media/dvb/ddbridge/ddbridge-core.c         |    1 +
 drivers/media/dvb/dvb-core/dvb_frontend.h          |    1 +
 drivers/media/dvb/dvb-usb/Kconfig                  |    3 +
 drivers/media/dvb/dvb-usb/az6007.c                 |    4 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    3 +
 drivers/media/dvb/dvb-usb/rtl28xxu.c               |  516 ++-
 drivers/media/dvb/frontends/Kconfig                |    8 +
 drivers/media/dvb/frontends/Makefile               |    1 +
 drivers/media/dvb/frontends/a8293.c                |   37 +-
 drivers/media/dvb/frontends/drxk.h                 |   11 +-
 drivers/media/dvb/frontends/drxk_hard.c            |  350 ++-
 drivers/media/dvb/frontends/drxk_hard.h            |   17 +-
 drivers/media/dvb/frontends/rtl2832.c              |  789 +++++
 drivers/media/dvb/frontends/rtl2832.h              |   74 +
 drivers/media/dvb/frontends/rtl2832_priv.h         |  260 ++
 drivers/media/dvb/frontends/s5h1420.c              |   20 -
 drivers/media/dvb/frontends/stb0899_drv.c          |   22 +-
 drivers/media/dvb/frontends/stv0367.c              |    5 +-
 drivers/media/dvb/frontends/stv090x.c              |    4 +-
 drivers/media/dvb/frontends/tda10071.c             |  351 ++-
 drivers/media/dvb/frontends/tda10071_priv.h        |   15 +-
 drivers/media/dvb/ngene/ngene-cards.c              |    1 +
 drivers/media/radio/Kconfig                        |    1 +
 drivers/media/radio/lm7000.h                       |   43 +
 drivers/media/radio/radio-aimslab.c                |   66 +-
 drivers/media/radio/radio-mr800.c                  |    5 +-
 drivers/media/radio/radio-sf16fmi.c                |   61 +-
 drivers/media/radio/radio-wl1273.c                 |    3 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |    6 +-
 drivers/media/radio/wl128x/fmdrv_rx.c              |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    4 +-
 drivers/media/rc/Kconfig                           |   49 +-
 drivers/media/rc/ene_ir.c                          |    3 +-
 drivers/media/rc/fintek-cir.c                      |   32 +-
 drivers/media/rc/gpio-ir-recv.c                    |   26 +-
 drivers/media/rc/nuvoton-cir.c                     |  145 +-
 drivers/media/video/Kconfig                        |   85 +-
 drivers/media/video/Makefile                       |    1 +
 drivers/media/video/adv7393.c                      |  487 +++
 drivers/media/video/adv7393_regs.h                 |  188 ++
 drivers/media/video/bt8xx/bttv-cards.c             |    1 +
 drivers/media/video/bt8xx/bttv-driver.c            |    6 -
 drivers/media/video/cpia2/cpia2_v4l.c              |    2 +-
 drivers/media/video/cs8420.h                       |   50 -
 drivers/media/video/cx18/cx18-ioctl.c              |   18 -
 drivers/media/video/cx18/cx18-ioctl.h              |    2 -
 drivers/media/video/cx18/cx18-streams.c            |    4 +-
 drivers/media/video/cx231xx/cx231xx-avcore.c       |   56 +-
 drivers/media/video/cx231xx/cx231xx-cards.c        |   17 +-
 drivers/media/video/cx88/cx88-alsa.c               |   31 +-
 drivers/media/video/cx88/cx88-blackbird.c          |  234 +-
 drivers/media/video/cx88/cx88-cards.c              |   20 +
 drivers/media/video/cx88/cx88-core.c               |    7 +-
 drivers/media/video/cx88/cx88-video.c              |  901 +++---
 drivers/media/video/cx88/cx88.h                    |   68 +-
 drivers/media/video/em28xx/em28xx-audio.c          |   27 +-
 drivers/media/video/em28xx/em28xx-cards.c          |    7 +-
 drivers/media/video/em28xx/em28xx-core.c           |   33 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |   95 +-
 drivers/media/video/em28xx/em28xx-i2c.c            |    1 +
 drivers/media/video/em28xx/em28xx-input.c          |    2 +-
 drivers/media/video/em28xx/em28xx-reg.h            |   51 +-
 drivers/media/video/ibmmpeg2.h                     |   94 -
 drivers/media/video/ivtv/ivtv-ioctl.c              |   12 -
 drivers/media/video/ivtv/ivtv-ioctl.h              |    1 -
 drivers/media/video/ivtv/ivtv-streams.c            |    4 +-
 drivers/media/video/m5mols/Kconfig                 |    1 +
 drivers/media/video/mem2mem_testdev.c              |  135 +-
 drivers/media/video/mt9m001.c                      |    2 +-
 drivers/media/video/mt9m032.c                      |   13 +-
 drivers/media/video/mt9m111.c                      |    1 -
 drivers/media/video/mt9p031.c                      |    5 +-
 drivers/media/video/mt9t001.c                      |   13 +-
 drivers/media/video/mt9v022.c                      |    2 +-
 drivers/media/video/omap3isp/ispccdc.c             |    8 +-
 drivers/media/video/omap3isp/isppreview.c          |    8 +-
 drivers/media/video/omap3isp/ispresizer.c          |    6 +-
 drivers/media/video/pvrusb2/Kconfig                |    1 -
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |   12 +-
 drivers/media/video/pwc/pwc-if.c                   |  171 +-
 drivers/media/video/pwc/pwc-v4l.c                  |  165 +-
 drivers/media/video/pwc/pwc.h                      |    3 -
 drivers/media/video/s5p-fimc/fimc-capture.c        |   34 +-
 drivers/media/video/s5p-fimc/fimc-core.c           |    2 +-
 drivers/media/video/s5p-fimc/fimc-lite-reg.c       |    2 +-
 drivers/media/video/s5p-fimc/fimc-lite.c           |   15 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.c        |    7 +-
 drivers/media/video/s5p-jpeg/jpeg-core.c           |   28 +-
 drivers/media/video/s5p-tv/mixer_video.c           |    8 +-
 drivers/media/video/s5p-tv/sii9234_drv.c           |   12 +-
 drivers/media/video/saa7121.h                      |  132 -
 drivers/media/video/saa7134/saa7134-dvb.c          |   82 +-
 drivers/media/video/saa7146.h                      |  112 -
 drivers/media/video/saa7146reg.h                   |  283 --
 drivers/media/video/saa7164/saa7164-api.c          |   14 -
 drivers/media/video/smiapp/Kconfig                 |    1 +
 drivers/media/video/smiapp/smiapp-core.c           |   40 +-
 drivers/media/video/sn9c102/sn9c102.h              |    2 +-
 drivers/media/video/tuner-core.c                   |   15 +-
 drivers/media/video/tvaudio.c                      |  291 +-
 drivers/media/video/tvp5150.c                      |   95 +-
 drivers/media/video/uvc/Kconfig                    |    1 +
 drivers/media/video/uvc/uvc_v4l2.c                 |    2 +-
 drivers/media/video/uvc/uvc_video.c                |    8 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |    9 +-
 drivers/media/video/v4l2-dev.c                     |   65 +-
 drivers/media/video/v4l2-ioctl.c                   | 3285 ++++++++++----------
 drivers/media/video/v4l2-subdev.c                  |    4 +-
 drivers/media/video/videobuf-core.c                |   16 -
 drivers/media/video/videobuf-dma-contig.c          |    2 +-
 drivers/media/video/videobuf2-core.c               |  417 ++-
 drivers/media/video/vivi.c                         |  194 +-
 drivers/media/video/zr364xx.c                      |  484 ++-
 drivers/staging/media/lirc/lirc_sir.c              |   60 +-
 drivers/staging/media/solo6x10/TODO                |    2 +-
 drivers/staging/media/solo6x10/i2c.c               |    2 +-
 include/linux/Kbuild                               |    1 +
 include/linux/i2c.h                                |    3 +
 include/linux/uvcvideo.h                           |    3 +-
 include/linux/v4l2-common.h                        |   71 +
 include/linux/v4l2-subdev.h                        |   20 +-
 include/linux/videodev2.h                          |   32 +-
 include/media/adv7393.h                            |   28 +
 include/media/gpio-ir-recv.h                       |    6 +-
 include/media/mt9t001.h                            |    1 +
 include/media/v4l2-chip-ident.h                    |    3 +
 include/media/v4l2-dev.h                           |    3 +
 include/media/v4l2-ioctl.h                         |   25 +-
 include/media/videobuf-core.h                      |    2 -
 include/media/videobuf2-core.h                     |   54 +
 include/media/videobuf2-dma-contig.h               |    6 +-
 sound/i2c/other/tea575x-tuner.c                    |    4 +-
 156 files changed, 7584 insertions(+), 5523 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/selections-common.xml
 create mode 100644 drivers/media/dvb/frontends/rtl2832.c
 create mode 100644 drivers/media/dvb/frontends/rtl2832.h
 create mode 100644 drivers/media/dvb/frontends/rtl2832_priv.h
 create mode 100644 drivers/media/radio/lm7000.h
 create mode 100644 drivers/media/video/adv7393.c
 create mode 100644 drivers/media/video/adv7393_regs.h
 delete mode 100644 drivers/media/video/cs8420.h
 delete mode 100644 drivers/media/video/ibmmpeg2.h
 delete mode 100644 drivers/media/video/saa7121.h
 delete mode 100644 drivers/media/video/saa7146.h
 delete mode 100644 drivers/media/video/saa7146reg.h
 create mode 100644 include/linux/v4l2-common.h
 create mode 100644 include/media/adv7393.h

