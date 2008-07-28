Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6S1ffeZ006910
	for <video4linux-list@redhat.com>; Sun, 27 Jul 2008 21:41:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6S1fRXg025950
	for <video4linux-list@redhat.com>; Sun, 27 Jul 2008 21:41:27 -0400
Date: Sun, 27 Jul 2008 22:41:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080727224104.78b8298d@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.27] V4L/DVB updates
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git for_linus

For the following:

   - API internal improvements on V4L;
   - Two new drivers: dw2102, mxl5007t;
   - removal of the long time broken PlanB driver;
   - added two very old boards to be removed, at feature-removal-schedule;
   - several fixes and new board support and cleanups on drivers: cx18, gspca,
     uvcvideo, cs5345, cx2885, pvrusb2, em28xx, s2255drv, stkwebcam, mt20xx, anysee,
     zr36067, saa7134, saa7134-empress, saa7146, ivtv and tveeprom and pwc;
   - Some cleanups at V4L core.

Cheers,
Mauro.

---

 Documentation/feature-removal-schedule.txt      |   24 +
 Documentation/video4linux/CARDLIST.au0828       |    1 +
 Documentation/video4linux/CARDLIST.em28xx       |   45 +-
 Documentation/video4linux/gspca.txt             |    2 +-
 MAINTAINERS                                     |    6 +
 drivers/media/common/saa7146_fops.c             |    2 +-
 drivers/media/common/saa7146_video.c            |   19 +-
 drivers/media/common/tuners/Kconfig             |   16 +-
 drivers/media/common/tuners/Makefile            |    1 +
 drivers/media/common/tuners/mt20xx.c            |    3 +-
 drivers/media/common/tuners/mxl5007t.c          | 1030 ++++++++++
 drivers/media/common/tuners/mxl5007t.h          |  104 +
 drivers/media/common/tuners/tda9887.c           |    2 +-
 drivers/media/common/tuners/tuner-simple.c      |    2 +-
 drivers/media/dvb/bt8xx/Kconfig                 |    2 -
 drivers/media/dvb/dvb-usb/Kconfig               |   10 +-
 drivers/media/dvb/dvb-usb/Makefile              |    3 +
 drivers/media/dvb/dvb-usb/anysee.c              |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h         |    1 +
 drivers/media/dvb/dvb-usb/dw2102.c              |  425 +++++
 drivers/media/dvb/dvb-usb/dw2102.h              |    9 +
 drivers/media/dvb/frontends/Kconfig             |   24 +-
 drivers/media/dvb/frontends/z0194a.h            |   97 +
 drivers/media/dvb/siano/smscoreapi.c            |   14 +-
 drivers/media/dvb/siano/smsdvb.c                |    4 +-
 drivers/media/dvb/ttpci/Kconfig                 |    4 -
 drivers/media/dvb/ttusb-dec/Kconfig             |    2 -
 drivers/media/radio/dsbr100.c                   |   18 +-
 drivers/media/radio/miropcm20-radio.c           |    3 +-
 drivers/media/radio/radio-aimslab.c             |   14 +-
 drivers/media/radio/radio-aztech.c              |   14 +-
 drivers/media/radio/radio-cadet.c               |   14 +-
 drivers/media/radio/radio-gemtek-pci.c          |   13 +-
 drivers/media/radio/radio-gemtek.c              |   13 +-
 drivers/media/radio/radio-maestro.c             |   12 +-
 drivers/media/radio/radio-maxiradio.c           |   15 +-
 drivers/media/radio/radio-rtrack2.c             |   14 +-
 drivers/media/radio/radio-sf16fmi.c             |   14 +-
 drivers/media/radio/radio-sf16fmr2.c            |   14 +-
 drivers/media/radio/radio-si470x.c              |   22 +-
 drivers/media/radio/radio-terratec.c            |   14 +-
 drivers/media/radio/radio-trust.c               |   14 +-
 drivers/media/radio/radio-typhoon.c             |   14 +-
 drivers/media/radio/radio-zoltrix.c             |   14 +-
 drivers/media/video/Kconfig                     |   19 +-
 drivers/media/video/Makefile                    |    3 +-
 drivers/media/video/arv.c                       |    1 -
 drivers/media/video/au0828/Kconfig              |    1 +
 drivers/media/video/au0828/au0828-cards.c       |   12 +
 drivers/media/video/au0828/au0828-cards.h       |    1 +
 drivers/media/video/au0828/au0828-dvb.c         |   15 +
 drivers/media/video/bt8xx/Kconfig               |    2 -
 drivers/media/video/bt8xx/bttv-driver.c         |   58 +-
 drivers/media/video/bt8xx/bttv-risc.c           |    1 +
 drivers/media/video/bt8xx/bttv-vbi.c            |    1 +
 drivers/media/video/bw-qcam.c                   |    3 +-
 drivers/media/video/c-qcam.c                    |    3 +-
 drivers/media/video/cafe_ccic.c                 |   26 +-
 drivers/media/video/compat_ioctl32.c            |    2 +-
 drivers/media/video/cpia.c                      |    2 -
 drivers/media/video/cpia.h                      |    1 +
 drivers/media/video/cpia2/cpia2_core.c          |    1 +
 drivers/media/video/cpia2/cpia2_v4l.c           |    5 +-
 drivers/media/video/cs5345.c                    |    2 +-
 drivers/media/video/cs53l32a.c                  |    2 +-
 drivers/media/video/cx18/Kconfig                |    2 -
 drivers/media/video/cx18/cx18-av-audio.c        |  111 +-
 drivers/media/video/cx18/cx18-driver.h          |    1 +
 drivers/media/video/cx18/cx18-firmware.c        |   54 +-
 drivers/media/video/cx18/cx18-ioctl.c           |   92 +-
 drivers/media/video/cx18/cx18-streams.c         |    5 +-
 drivers/media/video/cx23885/Kconfig             |    2 -
 drivers/media/video/cx23885/cx23885-417.c       |   19 +-
 drivers/media/video/cx23885/cx23885-cards.c     |   54 +-
 drivers/media/video/cx23885/cx23885-core.c      |  147 ++-
 drivers/media/video/cx23885/cx23885-video.c     |   19 +-
 drivers/media/video/cx25840/Kconfig             |    2 -
 drivers/media/video/cx25840/cx25840-core.c      |    2 +-
 drivers/media/video/cx25840/cx25840-core.h      |    2 -
 drivers/media/video/cx88/Kconfig                |    3 +-
 drivers/media/video/cx88/cx88-blackbird.c       |   15 +-
 drivers/media/video/cx88/cx88-cards.c           |    2 +-
 drivers/media/video/cx88/cx88-core.c            |    3 +-
 drivers/media/video/cx88/cx88-video.c           |   37 +-
 drivers/media/video/cx88/cx88.h                 |    4 +-
 drivers/media/video/em28xx/em28xx-cards.c       |  977 ++++++++++-
 drivers/media/video/em28xx/em28xx-dvb.c         |   13 +-
 drivers/media/video/em28xx/em28xx-video.c       |   61 +-
 drivers/media/video/em28xx/em28xx.h             |   49 +-
 drivers/media/video/et61x251/et61x251_core.c    |    5 +-
 drivers/media/video/gspca/conex.c               |    9 +-
 drivers/media/video/gspca/etoms.c               |   30 +-
 drivers/media/video/gspca/gspca.c               |   43 +-
 drivers/media/video/gspca/mars.c                |    9 +-
 drivers/media/video/gspca/ov519.c               |   33 +-
 drivers/media/video/gspca/pac207.c              |   29 +-
 drivers/media/video/gspca/pac7311.c             |   22 +-
 drivers/media/video/gspca/sonixb.c              |  484 ++----
 drivers/media/video/gspca/sonixj.c              |  492 ++----
 drivers/media/video/gspca/spca500.c             |  139 +--
 drivers/media/video/gspca/spca501.c             |   75 +-
 drivers/media/video/gspca/spca505.c             |  140 +--
 drivers/media/video/gspca/spca506.c             |  121 +-
 drivers/media/video/gspca/spca508.c             |  164 +--
 drivers/media/video/gspca/spca561.c             |   62 +-
 drivers/media/video/gspca/stk014.c              |    9 +-
 drivers/media/video/gspca/sunplus.c             |  355 +---
 drivers/media/video/gspca/t613.c                |   26 +-
 drivers/media/video/gspca/tv8532.c              |   17 +-
 drivers/media/video/gspca/vc032x.c              |   44 +-
 drivers/media/video/gspca/zc3xx.c               |  486 +++---
 drivers/media/video/ivtv/Kconfig                |    2 -
 drivers/media/video/ivtv/ivtv-driver.c          |    5 +-
 drivers/media/video/ivtv/ivtv-driver.h          |    1 +
 drivers/media/video/ivtv/ivtv-ioctl.c           |  130 +-
 drivers/media/video/ivtv/ivtv-streams.c         |    7 +-
 drivers/media/video/m52790.c                    |    2 +-
 drivers/media/video/meye.c                      |   19 +-
 drivers/media/video/msp3400-driver.c            |    2 +-
 drivers/media/video/msp3400-kthreads.c          |    1 -
 drivers/media/video/mt9m001.c                   |    2 +-
 drivers/media/video/ov511.c                     |   38 +-
 drivers/media/video/ov511.h                     |    1 +
 drivers/media/video/planb.c                     | 2309 -----------------------
 drivers/media/video/planb.h                     |  232 ---
 drivers/media/video/pms.c                       |    3 +-
 drivers/media/video/pvrusb2/Kconfig             |    2 -
 drivers/media/video/pvrusb2/pvrusb2-context.h   |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.c   |   11 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.h   |   26 +-
 drivers/media/video/pvrusb2/pvrusb2-fx2-cmd.h   |    2 +
 drivers/media/video/pvrusb2/pvrusb2-hdw.c       |    9 +
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c  |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c      |    6 +-
 drivers/media/video/pwc/pwc-if.c                |   16 +-
 drivers/media/video/pwc/pwc.h                   |    2 +
 drivers/media/video/s2255drv.c                  |  130 +-
 drivers/media/video/saa5246a.c                  |    3 +-
 drivers/media/video/saa5249.c                   |    3 +-
 drivers/media/video/saa7134/Kconfig             |    2 -
 drivers/media/video/saa7134/saa7134-cards.c     |    3 -
 drivers/media/video/saa7134/saa7134-core.c      |   16 +-
 drivers/media/video/saa7134/saa7134-empress.c   |   54 +-
 drivers/media/video/saa7134/saa7134-video.c     |   98 +-
 drivers/media/video/saa7134/saa7134.h           |    7 +-
 drivers/media/video/saa717x.c                   |    1 -
 drivers/media/video/saa7196.h                   |  117 --
 drivers/media/video/se401.c                     |    2 -
 drivers/media/video/se401.h                     |    1 +
 drivers/media/video/sh_mobile_ceu_camera.c      |    1 +
 drivers/media/video/sn9c102/sn9c102.h           |    1 +
 drivers/media/video/sn9c102/sn9c102_core.c      |   62 +-
 drivers/media/video/soc_camera.c                |   68 +-
 drivers/media/video/stk-webcam.c                |   69 +-
 drivers/media/video/stradis.c                   |    2 +-
 drivers/media/video/stv680.c                    |   52 +-
 drivers/media/video/tda7432.c                   |    3 +-
 drivers/media/video/tda9875.c                   |    2 +-
 drivers/media/video/tlv320aic23b.c              |    2 +-
 drivers/media/video/tuner-core.c                |    1 +
 drivers/media/video/tveeprom.c                  |  122 +-
 drivers/media/video/tvp5150.c                   |    2 +-
 drivers/media/video/usbvideo/usbvideo.c         |    4 +-
 drivers/media/video/usbvideo/usbvideo.h         |    1 +
 drivers/media/video/usbvideo/vicam.c            |    3 +-
 drivers/media/video/usbvision/usbvision-core.c  |    2 -
 drivers/media/video/usbvision/usbvision-video.c |  113 +-
 drivers/media/video/uvc/uvc_ctrl.c              |   15 +-
 drivers/media/video/uvc/uvc_driver.c            |    4 +-
 drivers/media/video/uvc/uvc_v4l2.c              |    1 +
 drivers/media/video/v4l1-compat.c               |    1 +
 drivers/media/video/v4l2-common.c               |    2 +-
 drivers/media/video/v4l2-dev.c                  |  422 +++++
 drivers/media/video/v4l2-ioctl.c                | 1875 ++++++++++++++++++
 drivers/media/video/videobuf-dma-contig.c       |    8 +-
 drivers/media/video/videobuf-vmalloc.c          |    2 +-
 drivers/media/video/videodev.c                  | 2262 ----------------------
 drivers/media/video/vino.c                      |    4 +-
 drivers/media/video/vivi.c                      |   18 +-
 drivers/media/video/vp27smpx.c                  |    2 +-
 drivers/media/video/w9966.c                     |    5 +-
 drivers/media/video/w9968cf.c                   |    5 +-
 drivers/media/video/w9968cf.h                   |    2 +-
 drivers/media/video/wm8739.c                    |    2 +-
 drivers/media/video/wm8775.c                    |    2 +-
 drivers/media/video/zc0301/zc0301.h             |    1 +
 drivers/media/video/zc0301/zc0301_core.c        |    2 -
 drivers/media/video/zoran_card.c                |   42 +-
 drivers/media/video/zoran_card.h                |    2 +-
 drivers/media/video/zoran_driver.c              |    7 +-
 drivers/media/video/zr364xx.c                   |   18 +-
 include/linux/videodev.h                        |   15 +
 include/linux/videodev2.h                       |  386 ++---
 include/linux/videotext.h                       |   16 +-
 include/media/audiochip.h                       |   26 -
 include/media/saa7146_vv.h                      |    1 +
 include/media/tveeprom.h                        |    7 +-
 include/media/v4l2-chip-ident.h                 |    7 +-
 include/media/v4l2-common.h                     |   33 +-
 include/media/v4l2-dev.h                        |  325 +---
 include/media/v4l2-ioctl.h                      |  301 +++
 sound/i2c/other/tea575x-tuner.c                 |    2 -
 202 files changed, 7798 insertions(+), 8529 deletions(-)
 create mode 100644 drivers/media/common/tuners/mxl5007t.c
 create mode 100644 drivers/media/common/tuners/mxl5007t.h
 create mode 100644 drivers/media/dvb/dvb-usb/dw2102.c
 create mode 100644 drivers/media/dvb/dvb-usb/dw2102.h
 create mode 100644 drivers/media/dvb/frontends/z0194a.h
 create mode 100644 drivers/media/video/v4l2-dev.c
 create mode 100644 drivers/media/video/v4l2-ioctl.c
 create mode 100644 include/media/v4l2-ioctl.h

Adrian Bunk (6):
      V4L/DVB (8440): gspca: Makes some needlessly global functions static.
      V4L/DVB (8453): sms1xxx: dvb/siano/: cleanups
      V4L/DVB (8485): v4l-dvb: remove broken PlanB driver
      V4L/DVB (8494): make cx25840_debug static
      V4L/DVB (8495): usb/anysee.c: make struct anysee_usb_mutex static
      V4L/DVB (8534): remove select's of FW_LOADER

Andoni Zubimendi (1):
      V4L/DVB (8457): gspca_sonixb remove some no longer needed sn9c103+ov7630 special cases

Andy Walls (2):
      V4L/DVB (8461): cx18: Fix 32 kHz audio sample output rate for analog tuner SIF input
      V4L/DVB (8462): cx18: Lock the aux PLL to the video pixle rate for analog captures

Aron Szabo (1):
      V4L/DVB (8538): em28xx-cards: Add GrabBeeX+ USB2800 model

Dean Anderson (1):
      V4L/DVB (8490): s2255drv Sensoray 2255 driver fixes

Devin Heitmueller (1):
      V4L/DVB (8492): Add support for the ATI TV Wonder HD 600

Douglas Schilling Landgraf (1):
      V4L/DVB (8539): em28xx-cards: New supported IDs for analog models

Guennadi Liakhovetski (2):
      V4L/DVB (8425): v4l: fix checkpatch errors introduced by recent commits
      V4L/DVB (8488a): Add myself as a maintainer of the soc-camera subsystem

Hans Verkuil (22):
      V4L/DVB (8423): cx18: remove firmware size check
      V4L/DVB (8427): videodev: split off the ioctl handling into v4l2-ioctl.c
      V4L/DVB (8428): videodev: rename 'dev' to 'parent'
      V4L/DVB (8429): videodev: renamed 'class_dev' to 'dev'
      V4L/DVB (8430): videodev: move some functions from v4l2-dev.h to v4l2-common.h or v4l2-ioctl.h
      V4L/DVB (8422): cs5345: fix incorrect mask with VIDIOC_DBG_S_REGISTER
      V4L/DVB (8477): v4l: remove obsolete audiochip.h
      V4L/DVB (8479): tveeprom/ivtv: fix usage of has_ir field
      V4L/DVB (8482): videodev: move all ioctl callbacks to a new v4l2_ioctl_ops struct
      V4L/DVB (8483): Remove obsolete owner field from video_device struct.
      V4L/DVB (8484): videodev: missed two more usages of the removed 'owner' field.
      V4L/DVB (8487): videodev: replace videodev.h includes by videodev2.h where possible
      V4L/DVB (8488): videodev: remove some CONFIG_VIDEO_V4L1_COMPAT code from v4l2-dev.h
      V4L/DVB (8504): s2255drv: add missing header
      V4L/DVB (8505): saa7134-empress.c: fix deadlock
      V4L/DVB (8506): empress: fix control handling oops
      V4L/DVB (8523): v4l2-dev: remove unused type and type2 field from video_device
      V4L/DVB (8524): videodev: copy the VID_TYPE defines to videodev.h
      V4L/DVB (8525): fix a few assorted spelling mistakes.
      V4L/DVB (8526): saa7146: fix VIDIOC_ENUM_FMT
      V4L/DVB (8546): saa7146: fix read from uninitialized memory
      V4L/DVB (8546): add tuner-3036 and dpc7146 drivers to feature-removal-schedule.txt

Hans de Goede (3):
      V4L/DVB (8455): gspca_sonixb sn9c103 + ov7630 autoexposure and cleanup
      V4L/DVB (8456): gspca_sonixb remove non working ovXXXX contrast, hue and saturation ctrls
      V4L/DVB (8458): gspca_sonixb remove one more no longer needed special case from the code

Igor M Liplianin (1):
      V4L/DVB (8421): Adds support for Dvbworld DVB-S 2102 USB card

Jaime Velasco Juan (1):
      V4L/DVB (8491): stkwebcam: Always reuse last queued buffer

Jean Delvare (1):
      V4L/DVB (8499): zr36067: Rework device memory allocation

Jean-Francois Moine (14):
      V4L/DVB (8435): gspca: Delay after reset for ov7660 and USB traces in sonixj.
      V4L/DVB (8436): gspca: Version number only in the main driver.
      V4L/DVB (8438): gspca: Lack of matrix for zc3xx - tas5130c (vf0250).
      V4L/DVB (8441): gspca: Bad handling of start of frames in sonixj.
      V4L/DVB (8442): gspca: Remove the version from the subdrivers.
      V4L/DVB (8511): gspca: Get the card name of QUERYCAP from the usb product name.
      V4L/DVB (8512): gspca: Do not use the driver_info field of usb_device_id.
      V4L/DVB (8513): gspca: Set the specific per webcam information in driver_info.
      V4L/DVB (8515): gspca: Webcam 0c45:6143 added in sonixj.
      V4L/DVB (8517): gspca: Bad sensor for some webcams in zc3xx since 28b8203a830e.
      V4L/DVB (8518): gspca: Remove the remaining frame decoding functions from the subdrivers.
      V4L/DVB (8519): gspca: Set the specific per webcam information in driver_info for sonixb.
      V4L/DVB (8520): gspca: Bad webcam information in some modules since 28b8203a830e.
      V4L/DVB (8521): gspca: Webcams with Sonix bridge and sensor ov7630 are VGA.

Laurent Pinchart (2):
      V4L/DVB (8497): uvcvideo: Make the auto-exposure menu control V4L2 compliant
      V4L/DVB (8498): uvcvideo: Return sensible min and max values when querying a boolean control.

Martin Samuelsson (1):
      V4L/DVB (8500): zr36067: Load the avs6eyes chip drivers automatically

Mauro Carvalho Chehab (12):
      V4L/DVB (8433): Fix macro name at z0194a.h
      V4L/DVB (8434): Fix x86_64 compilation and move some macros to v4l2-ioctl.h
      V4L/DVB (8234a): uvcvideo: Fix build for uvc input
      V4L/DVB (8451): dw2102: fix in-kernel compilation
      V4L/DVB (8500a): videotext.h: whitespace cleanup
      V4L/DVB (8502): videodev2.h: CodingStyle cleanups
      V4L/DVB (8522): videodev2: Fix merge conflict
      V4L/DVB (8541): em28xx: HVR-950 entry is duplicated.
      V4L/DVB (8542): em28xx: AMD ATI TV Wonder HD 600 entry at cards struct is duplicated
      V4L/DVB (8543): em28xx: Rename #define for Compro VideoMate ForYou/Stereo
      V4L/DVB (8548): pwc: Fix compilation
      V4L/DVB (8549): mxl5007: Fix an error at include file

Michael Krufky (6):
      V4L/DVB (8509): pvrusb2: fix device descriptions for HVR-1900 & HVR-1950
      V4L/DVB (8528): add support for MaxLinear MxL5007T silicon tuner
      V4L/DVB (8529): mxl5007t: enable _init and _sleep power management functionality
      V4L/DVB (8530): au0828: add support for new revision of HVR950Q
      V4L/DVB (8531): mxl5007t: move i2c gate handling outside of mutex protected code blocks
      V4L/DVB (8532): mxl5007t: remove excessive locks

Mike Isely (2):
      V4L/DVB (8474): pvrusb2: Enable IR chip on HVR-1900 class devices
      V4L/DVB (8475): pvrusb2: Cosmetic macro fix (benign)

Oliver Neukum (1):
      V4L/DVB (8544): gspca: probe/open race.

Simon Arlott (1):
      V4L/DVB (8496): saa7134: Copy tuner data earlier in init to avoid overwriting manual tuner type

Steven Toth (9):
      V4L/DVB (8464): cx23885: Bugfix for concurrent use of /dev/video0 and /dev/video1
      V4L/DVB (8465): cx23885: Ensure PAD_CTRL is always reset to a sensible default
      V4L/DVB (8466): cx23885: Bugfix - DVB Transport cards using DVB port VIDB/TS1 did not stream.
      V4L/DVB (8467): cx23885: Minor cleanup to the debuging output for a specific register.
      V4L/DVB (8468): cx23885: Ensure the second transport port is enabled for streaming.
      V4L/DVB (8469): cx23885: FusionHDTV7 Dual Express toggle reset.
      V4L/DVB (8470): cx23885: Add DViCO HDTV7 Dual Express tuner callback support.
      V4L/DVB (8471): cx23885: Reallocated the sram to avoid concurrent VIDB/C issues.
      V4L/DVB (8472): cx23885: SRAM changes for the 885 and 887 silicon parts.

Vitaly Wool (1):
      V4L/DVB (8540): em28xx-cards: Add Compro VideoMate ForYou/Stereo model

reinhard schwab (1):
      V4L/DVB (8489): add dvb-t support for terratec cinergy hybrid T usb xs

roel kluin (1):
      V4L/DVB (8493): mt20xx: test below 0 on unsigned lo1a and lo2a

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
