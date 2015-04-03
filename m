Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:48681 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702AbbDCLVi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2015 07:21:38 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 3C5542A009F
	for <linux-media@vger.kernel.org>; Fri,  3 Apr 2015 13:21:06 +0200 (CEST)
Message-ID: <551E77A2.90405@xs4all.nl>
Date: Fri, 03 Apr 2015 13:21:06 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.1] Various fixes and improvements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Add V4L2_DV_FL_IS_CE_VIDEO flag
- Various cx18 v4l2-compliance fixes
- More 'embed video_device' patches (tested with actual hardware)
- Add CVT/GTF timings support to vivid
- Add V4L2_CTRL_FLAG_EXECUTE_ON_WRITE support
- Improve gpiod use

Regards,

	Hans

The following changes since commit a5562f65b1371a0988b707c10c44fcc2bba56990:

  [media] v4l: xilinx: Add Test Pattern Generator driver (2015-04-03 01:04:18 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1q

for you to fetch changes up to e97e1fd392564dafd1f03a6280a8713864e3bc72:

  uvc: embed video_device (2015-04-03 13:16:17 +0200)

----------------------------------------------------------------
Hans Verkuil (12):
      videodev2.h/v4l2-dv-timings.h: add V4L2_DV_FL_IS_CE_VIDEO flag
      v4l2-dv-timings: log new V4L2_DV_FL_IS_CE_VIDEO flag
      DocBook media: document the new V4L2_DV_FL_IS_CE_VIDEO flag
      adv: use V4L2_DV_FL_IS_CE_VIDEO instead of V4L2_DV_BT_STD_CEA861.
      vivid: use V4L2_DV_FL_IS_CE_VIDEO instead of V4L2_DV_BT_STD_CEA861.
      cx18: add support for control events
      cx18: fix VIDIOC_ENUMINPUT: wrong std value
      cx18: replace cropping ioctls by selection ioctls.
      cx88: embed video_device
      bttv: embed video_device
      em28xx: embed video_device
      uvc: embed video_device

Prashant Laddha (2):
      vivid: add CVT,GTF standards to vivid dv timings caps
      vivid: add support to set CVT, GTF timings

Ricardo Ribalda (5):
      media/v4l2-ctrls: volatiles should not generate CH_VALUE
      media: New flag V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
      media/v4l2-ctrls: Add execute flags to write_only controls
      media/v4l2-ctrls: Always execute EXECUTE_ON_WRITE ctrls
      media/Documentation: New flag EXECUTE_ON_WRITE

Uwe Kleine-König (1):
      media: radio-si4713: improve usage of gpiod API

 Documentation/DocBook/media/v4l/vidioc-dqevent.xml      |   6 ++--
 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml |   9 ++++++
 Documentation/DocBook/media/v4l/vidioc-queryctrl.xml    |  12 ++++++-
 Documentation/video4linux/v4l2-controls.txt             |   4 ++-
 drivers/media/i2c/ad9389b.c                             |  10 +++---
 drivers/media/i2c/adv7511.c                             |  10 +++---
 drivers/media/i2c/adv7604.c                             |   5 +--
 drivers/media/i2c/adv7842.c                             |   5 +--
 drivers/media/pci/bt8xx/bttv-driver.c                   |  73 +++++++++++++-----------------------------
 drivers/media/pci/bt8xx/bttvp.h                         |   6 ++--
 drivers/media/pci/cx18/cx18-fileops.c                   |  25 ++++++++++-----
 drivers/media/pci/cx18/cx18-ioctl.c                     |  47 +++++++++++++++------------
 drivers/media/pci/cx18/cx18-streams.c                   |   6 +++-
 drivers/media/pci/cx88/cx88-blackbird.c                 |  22 +++++--------
 drivers/media/pci/cx88/cx88-core.c                      |  18 ++++-------
 drivers/media/pci/cx88/cx88-video.c                     |  61 +++++++++++++----------------------
 drivers/media/pci/cx88/cx88.h                           |  17 +++++-----
 drivers/media/platform/vivid/vivid-ctrls.c              |   2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c            |  68 +++++++++++++++++++++++++++++++++++++--
 drivers/media/platform/vivid/vivid-vid-common.c         |   5 +--
 drivers/media/platform/vivid/vivid-vid-out.c            |   4 +--
 drivers/media/radio/si4713/si4713.c                     |  18 ++++-------
 drivers/media/usb/em28xx/em28xx-video.c                 | 119 +++++++++++++++++++++++++++++---------------------------------------
 drivers/media/usb/em28xx/em28xx.h                       |   6 ++--
 drivers/media/usb/uvc/uvc_driver.c                      |  22 +++----------
 drivers/media/usb/uvc/uvc_v4l2.c                        |   2 +-
 drivers/media/usb/uvc/uvcvideo.h                        |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c                    |  22 +++++++++++--
 drivers/media/v4l2-core/v4l2-dv-timings.c               |   6 ++--
 include/uapi/linux/v4l2-dv-timings.h                    |  64 ++++++++++++++++++++++---------------
 include/uapi/linux/videodev2.h                          |   7 ++++
 31 files changed, 367 insertions(+), 316 deletions(-)
