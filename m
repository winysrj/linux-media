Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3280 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2IQILv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 04:11:51 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id q8H8BmiS025946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 10:11:49 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id D5A6735C012A
	for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 10:11:46 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] API fixes from the 2012 Media Workshop
Date: Mon, 17 Sep 2012 10:11:47 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209171011.47261.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the pull request for the API fixes that were discussed during the 2012
Media Workshop.

Changes since RFCv3:

- Dropped the monotonic clock changes from this series: Sakari will pick this up
  as a separate project.
- Removed V4L2_BUF_TYPE_PRIVATE from cx18 and ivtv (was only ever used as an
  internal placeholder, and after looking at the code it turned out that it wasn't
  actually used anymore).
- Documented VFL_DIR_RX in v4l2-framework.txt.

Regards,

	Hans


The following changes since commit 36aee5ff9098a871bda38dbbdad40ad59f6535cf:

  [media] ir-rx51: Adjust dependencies (2012-09-15 19:44:30 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git api4

for you to fetch changes up to f1af139bfba9be21cb57c28d3361c4d174558fea:

  Add vfl_dir field documentation. (2012-09-17 10:06:33 +0200)

----------------------------------------------------------------
Hans Verkuil (29):
      videodev2.h: split off controls into v4l2-controls.h
      DocBook: improve STREAMON/OFF documentation.
      DocBook: make the G/S/TRY_FMT specification more strict.
      DocBook: bus_info can no longer be empty.
      vivi/mem2mem_testdev: update to latest bus_info specification.
      v4l2-core: deprecate V4L2_BUF_TYPE_PRIVATE
      cx18/ivtv: Remove usage of V4L2_BUF_TYPE_PRIVATE
      DocBook: deprecate V4L2_BUF_TYPE_PRIVATE.
      v4l2: remove experimental tag from a number of old drivers.
      DocBook: document when to return ENODATA.
      v4l2-core: tvnorms may be 0 for a given input, handle that case.
      Rename V4L2_(IN|OUT)_CAP_CUSTOM_TIMINGS.
      Feature removal: Remove CUSTOM_TIMINGS defines in 3.9.
      DocBook: fix awkward language and fix the documented return value.
      DocBook: clarify that sequence is also set for output devices.
      DocBook: Mark CROPCAP as optional instead of as compulsory.
      v4l2: make vidioc_s_fbuf const.
      v4l2: make vidioc_s_jpegcomp const.
      v4l2: make vidioc_s_freq_hw_seek const.
      v4l2: make vidioc_(un)subscribe_event const.
      v4l2: make vidioc_s_audio const.
      v4l2: make vidioc_s_audout const.
      v4l2: make vidioc_s_modulator const.
      v4l2: make vidioc_s_crop const.
      v4l2-dev: add new VFL_DIR_ defines.
      Set vfl_dir for all display or m2m drivers.
      v4l2-dev: improve ioctl validity checks.
      v4l2-dev: reorder checks into blocks of ioctls with similar properties.
      Add vfl_dir field documentation.

Sakari Ailus (1):
      v4l: Remove experimental tag from certain API elements

 Documentation/DocBook/media/v4l/common.xml                  |   30 ++-
 Documentation/DocBook/media/v4l/compat.xml                  |   25 +--
 Documentation/DocBook/media/v4l/dev-osd.xml                 |    7 -
 Documentation/DocBook/media/v4l/io.xml                      |   21 +-
 Documentation/DocBook/media/v4l/vidioc-cropcap.xml          |   12 +-
 Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml      |    7 -
 Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml      |    7 -
 Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml  |    6 +
 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml  |    6 +
 Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml         |    9 +-
 Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml  |    7 -
 Documentation/DocBook/media/v4l/vidioc-enuminput.xml        |    2 +-
 Documentation/DocBook/media/v4l/vidioc-enumoutput.xml       |    2 +-
 Documentation/DocBook/media/v4l/vidioc-enumstd.xml          |    6 +
 Documentation/DocBook/media/v4l/vidioc-g-crop.xml           |    6 +-
 Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml      |    9 +-
 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml     |   13 +-
 Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml      |    7 -
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml            |   13 +-
 Documentation/DocBook/media/v4l/vidioc-g-parm.xml           |    4 +-
 Documentation/DocBook/media/v4l/vidioc-g-std.xml            |   10 +-
 Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml  |    9 +
 Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml |    6 +
 Documentation/DocBook/media/v4l/vidioc-querycap.xml         |   10 +-
 Documentation/DocBook/media/v4l/vidioc-querystd.xml         |    8 +
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml          |    5 +-
 Documentation/DocBook/media/v4l/vidioc-streamon.xml         |    7 +-
 Documentation/feature-removal-schedule.txt                  |    9 +
 Documentation/video4linux/v4l2-framework.txt                |   10 +-
 drivers/media/common/saa7146/saa7146_video.c                |    2 +-
 drivers/media/i2c/Kconfig                                   |    4 +-
 drivers/media/i2c/soc_camera/mt9m001.c                      |    2 +-
 drivers/media/i2c/soc_camera/mt9m111.c                      |    2 +-
 drivers/media/i2c/soc_camera/mt9t031.c                      |    2 +-
 drivers/media/i2c/soc_camera/mt9t112.c                      |    4 +-
 drivers/media/i2c/soc_camera/mt9v022.c                      |    2 +-
 drivers/media/i2c/soc_camera/ov5642.c                       |   20 +-
 drivers/media/i2c/soc_camera/ov6650.c                       |   32 +--
 drivers/media/i2c/soc_camera/rj54n1cb0c.c                   |    4 +-
 drivers/media/i2c/tvp5150.c                                 |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c                       |   16 +-
 drivers/media/pci/cx18/Kconfig                              |    4 +-
 drivers/media/pci/cx18/cx18-ioctl.c                         |    4 +-
 drivers/media/pci/cx18/cx18-streams.c                       |   15 +-
 drivers/media/pci/cx23885/cx23885-video.c                   |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c                   |    2 +-
 drivers/media/pci/cx25821/cx25821-video.h                   |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                         |   16 +-
 drivers/media/pci/ivtv/ivtv-streams.c                       |   22 +-
 drivers/media/pci/saa7134/saa7134-video.c                   |   38 ++--
 drivers/media/pci/saa7146/mxb.c                             |    2 +-
 drivers/media/pci/ttpci/av7110_v4l.c                        |    2 +-
 drivers/media/pci/zoran/Kconfig                             |    4 +-
 drivers/media/pci/zoran/zoran_card.c                        |    4 +
 drivers/media/pci/zoran/zoran_driver.c                      |    8 +-
 drivers/media/platform/coda.c                               |    1 +
 drivers/media/platform/davinci/vpbe_display.c               |    3 +-
 drivers/media/platform/davinci/vpfe_capture.c               |    2 +-
 drivers/media/platform/davinci/vpif_display.c               |    1 +
 drivers/media/platform/fsl-viu.c                            |    2 +-
 drivers/media/platform/m2m-deinterlace.c                    |    1 +
 drivers/media/platform/mem2mem_testdev.c                    |    4 +-
 drivers/media/platform/mx2_emmaprp.c                        |    1 +
 drivers/media/platform/omap/omap_vout.c                     |    5 +-
 drivers/media/platform/omap3isp/ispccdc.c                   |    4 +-
 drivers/media/platform/omap3isp/ispstat.c                   |    4 +-
 drivers/media/platform/omap3isp/ispstat.h                   |    4 +-
 drivers/media/platform/omap3isp/ispvideo.c                  |    1 +
 drivers/media/platform/s5p-fimc/fimc-m2m.c                  |    3 +-
 drivers/media/platform/s5p-g2d/g2d.c                        |    3 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c                 |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c                    |    1 +
 drivers/media/platform/s5p-tv/mixer_video.c                 |    1 +
 drivers/media/platform/sh_vou.c                             |    3 +-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c    |    4 +-
 drivers/media/platform/soc_camera/soc_camera.c              |    6 +-
 drivers/media/platform/vino.c                               |    2 +-
 drivers/media/platform/vivi.c                               |    3 +-
 drivers/media/radio/radio-keene.c                           |    2 +-
 drivers/media/radio/radio-miropcm20.c                       |    2 +-
 drivers/media/radio/radio-mr800.c                           |    2 +-
 drivers/media/radio/radio-sf16fmi.c                         |    2 +-
 drivers/media/radio/radio-si4713.c                          |    4 +-
 drivers/media/radio/radio-tea5764.c                         |    2 +-
 drivers/media/radio/radio-tea5777.c                         |   32 +--
 drivers/media/radio/radio-timb.c                            |    2 +-
 drivers/media/radio/radio-wl1273.c                          |    6 +-
 drivers/media/radio/si470x/radio-si470x-common.c            |    4 +-
 drivers/media/radio/si4713-i2c.c                            |    4 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c                     |    6 +-
 drivers/media/tuners/Kconfig                                |    5 +-
 drivers/media/usb/au0828/au0828-video.c                     |    2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c                         |    5 +-
 drivers/media/usb/cx231xx/cx231xx-video.c                   |    4 +-
 drivers/media/usb/dvb-usb/Kconfig                           |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c                     |    4 +-
 drivers/media/usb/gspca/gspca.c                             |    2 +-
 drivers/media/usb/gspca/gspca.h                             |    8 +-
 drivers/media/usb/gspca/jeilinj.c                           |    2 +-
 drivers/media/usb/gspca/ov519.c                             |    2 +-
 drivers/media/usb/gspca/topro.c                             |    2 +-
 drivers/media/usb/gspca/zc3xx.c                             |    9 +-
 drivers/media/usb/hdpvr/hdpvr-video.c                       |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c                    |    4 +-
 drivers/media/usb/s2255/s2255drv.c                          |    2 +-
 drivers/media/usb/stkwebcam/Kconfig                         |    2 +-
 drivers/media/usb/tlg2300/pd-radio.c                        |    2 +-
 drivers/media/usb/tlg2300/pd-video.c                        |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c                     |    2 +-
 drivers/media/usb/usbvision/usbvision-video.c               |    2 +-
 drivers/media/usb/uvc/uvc_driver.c                          |    2 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c               |    8 -
 drivers/media/v4l2-core/v4l2-ctrls.c                        |    2 +-
 drivers/media/v4l2-core/v4l2-dev.c                          |  226 +++++++++++---------
 drivers/media/v4l2-core/v4l2-event.c                        |    4 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                        |  221 ++++++++++---------
 drivers/staging/media/go7007/go7007-v4l2.c                  |    4 +-
 include/linux/Kbuild                                        |    1 +
 include/linux/v4l2-controls.h                               |  761 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/videodev2.h                                   |  704 +-----------------------------------------------------------
 include/media/soc_camera.h                                  |    4 +-
 include/media/v4l2-ctrls.h                                  |    2 +-
 include/media/v4l2-dev.h                                    |    9 +-
 include/media/v4l2-event.h                                  |    4 +-
 include/media/v4l2-ioctl.h                                  |   26 +--
 include/media/v4l2-subdev.h                                 |    4 +-
 sound/i2c/other/tea575x-tuner.c                             |    2 +-
 127 files changed, 1398 insertions(+), 1269 deletions(-)
 create mode 100644 include/linux/v4l2-controls.h
