Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2801 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab0I3JjF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 05:39:05 -0400
Received: from tschai.localnet (186.84-48-119.nextgentel.com [84.48.119.186])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id o8U9cqpD089681
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Sep 2010 11:39:03 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] Rename video_device et al to v4l2_devnode
Date: Thu, 30 Sep 2010 11:38:52 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009301138.52360.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Most of the v4l2 framework has a prefix that starts with v4l2_ except for
struct video_device in v4l2-dev.c. This name is becoming very confusing since
it closely resembles struct v4l2_device. Since video_device really represents
a v4l2 device node I propose to rename it to v4l2_devnode and rename the
v4l2-dev.[ch] to v4l2-devnode.[ch].
 
To make the transition easier I created a v4l2-dev.h that includes the new
v4l2-devnode.h and #defines the old names to the new names. This header is
removed once the full conversion is finished.
 
I also updated the documentation to reflect the new header and naming convention.

Now that the v2.6.36 cycle is nearing the end I think it is a good time to apply
this patch so that it has the least impact.

This patch requires that the bkl patch I posted earlier ("Move V4L2 locking into
the core framework") is applied first.

Regards,

	Hans


The following changes since commit af9c9bdd595ec0a2077f1ebd298d8a3a1db01b57:
  Hans Verkuil (1):
        radio-mr800: remove BKL

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git devnode

Hans Verkuil (19):
      v4l2-devnode: renamed from v4l2-dev
      videodev2.h: update comment
      v4l2 core: use v4l2-devnode.h instead of v4l2-dev.h
      v4l2: rename to_video_device to v4l2_devnode_from_device
      v4l2: rename video_device_alloc to v4l2_devnode_alloc
      v4l2: rename video_device_release_empty to v4l2_devnode_release_empty
      v4l2: rename video_device_release to v4l2_devnode_release
      v4l2: rename video_device_node_name to v4l2_devnode_name
      v4l2: rename video_register_device to v4l2_devnode_register
      v4l2: rename video_unregister_device to v4l2_devnode_unregister
      v4l2: rename video_is_registered to v4l2_devnode_is_registered
      v4l2: rename video_get/set_drvdata to v4l2_devnode_get/set_drvdata
      v4l2: rename video_devdata to v4l2_devnode_from_file
      v4l2: rename video_drvdata to v4l2_drvdata_from_file
      v4l2: rename video_device to v4l2_devnode
      tea575x: convert to v4l2-devnode.h
      v4l2: include v4l2-devnode.h instead of v4l2-dev.h
      gadget/uvc.h: remove the temporary v4l2-dev.h include
      v4l2-dev.h: remove obsolete header

 Documentation/DocBook/v4l/videodev2.h.xml        |    2 +-
 Documentation/video4linux/v4l2-controls.txt      |   10 +-
 Documentation/video4linux/v4l2-framework.txt     |   91 ++--
 drivers/media/common/saa7146_fops.c              |   26 +-
 drivers/media/dvb/ngene/ngene.h                  |    2 +-
 drivers/media/dvb/ttpci/av7110.h                 |    4 +-
 drivers/media/dvb/ttpci/budget-av.c              |    2 +-
 drivers/media/radio/dsbr100.c                    |   30 +-
 drivers/media/radio/radio-aimslab.c              |   20 +-
 drivers/media/radio/radio-aztech.c               |   20 +-
 drivers/media/radio/radio-cadet.c                |   30 +-
 drivers/media/radio/radio-gemtek-pci.c           |   22 +-
 drivers/media/radio/radio-gemtek.c               |   20 +-
 drivers/media/radio/radio-maestro.c              |   24 +-
 drivers/media/radio/radio-maxiradio.c            |   22 +-
 drivers/media/radio/radio-miropcm20.c            |   18 +-
 drivers/media/radio/radio-mr800.c                |   18 +-
 drivers/media/radio/radio-rtrack2.c              |   20 +-
 drivers/media/radio/radio-sf16fmi.c              |   20 +-
 drivers/media/radio/radio-sf16fmr2.c             |   22 +-
 drivers/media/radio/radio-si4713.c               |   22 +-
 drivers/media/radio/radio-tea5764.c              |   36 +-
 drivers/media/radio/radio-terratec.c             |   20 +-
 drivers/media/radio/radio-timb.c                 |   28 +-
 drivers/media/radio/radio-trust.c                |   22 +-
 drivers/media/radio/radio-typhoon.c              |   20 +-
 drivers/media/radio/radio-zoltrix.c              |   20 +-
 drivers/media/radio/si470x/radio-si470x-common.c |   24 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c    |   14 +-
 drivers/media/radio/si470x/radio-si470x-usb.c    |   18 +-
 drivers/media/radio/si470x/radio-si470x.h        |    4 +-
 drivers/media/video/Makefile                     |    2 +-
 drivers/media/video/arv.c                        |   26 +-
 drivers/media/video/au0828/au0828-video.c        |   32 +-
 drivers/media/video/au0828/au0828.h              |    4 +-
 drivers/media/video/bt8xx/bttv-driver.c          |   62 +-
 drivers/media/video/bt8xx/bttvp.h                |    6 +-
 drivers/media/video/bw-qcam.c                    |   22 +-
 drivers/media/video/c-qcam.c                     |   24 +-
 drivers/media/video/cafe_ccic.c                  |   14 +-
 drivers/media/video/cpia.c                       |   38 +-
 drivers/media/video/cpia.h                       |    2 +-
 drivers/media/video/cpia2/cpia2.h                |    2 +-
 drivers/media/video/cpia2/cpia2_v4l.c            |   40 +-
 drivers/media/video/cx18/cx18-driver.h           |    2 +-
 drivers/media/video/cx18/cx18-fileops.c          |    6 +-
 drivers/media/video/cx18/cx18-ioctl.c            |    4 +-
 drivers/media/video/cx18/cx18-ioctl.h            |    2 +-
 drivers/media/video/cx18/cx18-streams.c          |   28 +-
 drivers/media/video/cx231xx/cx231xx-cards.c      |    2 +-
 drivers/media/video/cx231xx/cx231xx-video.c      |   76 ++--
 drivers/media/video/cx231xx/cx231xx.h            |    6 +-
 drivers/media/video/cx23885/cx23885-417.c        |   26 +-
 drivers/media/video/cx23885/cx23885-video.c      |   32 +-
 drivers/media/video/cx23885/cx23885.h            |    8 +-
 drivers/media/video/cx88/cx88-blackbird.c        |   20 +-
 drivers/media/video/cx88/cx88-core.c             |   10 +-
 drivers/media/video/cx88/cx88-video.c            |   48 +-
 drivers/media/video/cx88/cx88.h                  |   12 +-
 drivers/media/video/davinci/vpfe_capture.c       |   74 ++--
 drivers/media/video/davinci/vpif_capture.c       |   22 +-
 drivers/media/video/davinci/vpif_capture.h       |    2 +-
 drivers/media/video/davinci/vpif_display.c       |   24 +-
 drivers/media/video/davinci/vpif_display.h       |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c        |    2 +-
 drivers/media/video/em28xx/em28xx-video.c        |   70 ++--
 drivers/media/video/em28xx/em28xx.h              |    6 +-
 drivers/media/video/et61x251/et61x251.h          |    2 +-
 drivers/media/video/et61x251/et61x251_core.c     |   71 ++--
 drivers/media/video/fsl-viu.c                    |   26 +-
 drivers/media/video/gspca/gl860/gl860.c          |    2 +-
 drivers/media/video/gspca/gspca.c                |   18 +-
 drivers/media/video/gspca/gspca.h                |    2 +-
 drivers/media/video/hdpvr/hdpvr-core.c           |   10 +-
 drivers/media/video/hdpvr/hdpvr-video.c          |   24 +-
 drivers/media/video/hdpvr/hdpvr.h                |    2 +-
 drivers/media/video/hexium_gemini.c              |    2 +-
 drivers/media/video/hexium_orion.c               |    2 +-
 drivers/media/video/ivtv/ivtv-driver.h           |    2 +-
 drivers/media/video/ivtv/ivtv-fileops.c          |   10 +-
 drivers/media/video/ivtv/ivtv-ioctl.c            |    4 +-
 drivers/media/video/ivtv/ivtv-ioctl.h            |    2 +-
 drivers/media/video/ivtv/ivtv-streams.c          |   22 +-
 drivers/media/video/mem2mem_testdev.c            |   24 +-
 drivers/media/video/meye.c                       |   16 +-
 drivers/media/video/meye.h                       |    2 +-
 drivers/media/video/mt9t031.c                    |    4 +-
 drivers/media/video/mx1_camera.c                 |    2 +-
 drivers/media/video/mx2_camera.c                 |    2 +-
 drivers/media/video/mx3_camera.c                 |    2 +-
 drivers/media/video/mxb.c                        |    4 +-
 drivers/media/video/omap/omap_vout.c             |   36 +-
 drivers/media/video/omap/omap_voutdef.h          |    2 +-
 drivers/media/video/omap24xxcam.c                |   22 +-
 drivers/media/video/omap24xxcam.h                |    2 +-
 drivers/media/video/pms.c                        |   30 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c       |   23 +-
 drivers/media/video/pwc/pwc-if.c                 |   64 +-
 drivers/media/video/pwc/pwc-v4l.c                |    4 +-
 drivers/media/video/pwc/pwc.h                    |    2 +-
 drivers/media/video/pxa_camera.c                 |    2 +-
 drivers/media/video/s2255drv.c                   |   40 +-
 drivers/media/video/s5p-fimc/fimc-core.c         |   18 +-
 drivers/media/video/s5p-fimc/fimc-core.h         |    2 +-
 drivers/media/video/saa7134/saa7134-core.c       |   42 +-
 drivers/media/video/saa7134/saa7134-empress.c    |   22 +-
 drivers/media/video/saa7134/saa7134-video.c      |   10 +-
 drivers/media/video/saa7134/saa7134.h            |   14 +-
 drivers/media/video/saa7146.h                    |    2 +-
 drivers/media/video/se401.c                      |   22 +-
 drivers/media/video/se401.h                      |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c       |    2 +-
 drivers/media/video/sh_mobile_csi2.c             |    2 +-
 drivers/media/video/sh_vou.c                     |   86 ++--
 drivers/media/video/sn9c102/sn9c102.h            |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c       |   75 ++--
 drivers/media/video/soc_camera.c                 |   18 +-
 drivers/media/video/stk-webcam.c                 |   36 +-
 drivers/media/video/stk-webcam.h                 |    2 +-
 drivers/media/video/stradis.c                    |   14 +-
 drivers/media/video/tlg2300/pd-common.h          |   12 +-
 drivers/media/video/tlg2300/pd-radio.c           |   18 +-
 drivers/media/video/tlg2300/pd-video.c           |   40 +-
 drivers/media/video/usbvideo/usbvideo.c          |   18 +-
 drivers/media/video/usbvideo/usbvideo.h          |    6 +-
 drivers/media/video/usbvideo/vicam.c             |   20 +-
 drivers/media/video/usbvision/usbvision-cards.c  |    2 +-
 drivers/media/video/usbvision/usbvision-video.c  |  162 +++---
 drivers/media/video/usbvision/usbvision.h        |    4 +-
 drivers/media/video/uvc/uvc_driver.c             |   20 +-
 drivers/media/video/uvc/uvc_v4l2.c               |    4 +-
 drivers/media/video/uvc/uvcvideo.h               |    2 +-
 drivers/media/video/v4l2-ctrls.c                 |    2 +-
 drivers/media/video/v4l2-devnode.c               |  673 ++++++++++++++++++++++
 drivers/media/video/v4l2-event.c                 |    4 +-
 drivers/media/video/v4l2-fh.c                    |    4 +-
 drivers/media/video/v4l2-ioctl.c                 |   10 +-
 drivers/media/video/vino.c                       |   80 ++--
 drivers/media/video/vivi.c                       |   68 ++--
 drivers/media/video/w9966.c                      |   24 +-
 drivers/media/video/zoran/zoran.h                |    2 +-
 drivers/media/video/zoran/zoran_card.c           |   10 +-
 drivers/media/video/zoran/zoran_card.h           |    4 +-
 drivers/media/video/zoran/zoran_driver.c         |    4 +-
 drivers/media/video/zr364xx.c                    |   58 +-
 drivers/staging/cx25821/cx25821-core.c           |    2 +-
 drivers/staging/cx25821/cx25821-video.c          |   46 +-
 drivers/staging/cx25821/cx25821-video.h          |    2 +-
 drivers/staging/cx25821/cx25821.h                |   14 +-
 drivers/staging/dream/camera/msm_v4l2.c          |   28 +-
 drivers/staging/dt3155v4l/dt3155v4l.c            |   50 +-
 drivers/staging/dt3155v4l/dt3155v4l.h            |    4 +-
 drivers/staging/go7007/go7007-priv.h             |    2 +-
 drivers/staging/go7007/go7007-v4l2.c             |   24 +-
 drivers/staging/go7007/saa7134-go7007.c          |    6 +-
 drivers/staging/tm6000/tm6000-video.c            |   28 +-
 drivers/staging/tm6000/tm6000.h                  |    2 +-
 drivers/usb/gadget/f_uvc.c                       |   16 +-
 drivers/usb/gadget/uvc.h                         |    2 +-
 drivers/usb/gadget/uvc_v4l2.c                    |   22 +-
 drivers/usb/gadget/uvc_video.c                   |    2 +-
 include/linux/videodev2.h                        |    2 +-
 include/media/davinci/vpfe_capture.h             |    4 +-
 include/media/saa7146_vv.h                       |    4 +-
 include/media/soc_camera.h                       |    6 +-
 include/media/v4l2-common.h                      |    2 +-
 include/media/v4l2-ctrls.h                       |    2 +-
 include/media/{v4l2-dev.h => v4l2-devnode.h}     |   73 ++--
 include/media/v4l2-event.h                       |    4 +-
 include/media/v4l2-fh.h                          |    8 +-
 include/media/v4l2-int-device.h                  |    2 +-
 include/sound/tea575x-tuner.h                    |    4 +-
 sound/i2c/other/tea575x-tuner.c                  |   28 +-
 173 files changed, 2289 insertions(+), 1615 deletions(-)
 create mode 100644 drivers/media/video/v4l2-devnode.c
 rename include/media/{v4l2-dev.h => v4l2-devnode.h} (59%)

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
