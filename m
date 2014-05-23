Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3621 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaEWKlU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 May 2014 06:41:20 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id s4NAfEVx004427
	for <linux-media@vger.kernel.org>; Fri, 23 May 2014 12:41:16 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 7300F2A19A6
	for <linux-media@vger.kernel.org>; Fri, 23 May 2014 12:40:50 +0200 (CEST)
Message-ID: <537F25B2.3040608@xs4all.nl>
Date: Fri, 23 May 2014 12:40:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.16] Various fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

For the most part these are assorted fixes. The exception is the patch from
Arun that adds a new V4L2 event type. The addition of that event is long
overdue so I'm happy to see it go in.

Regards,

	Hans

The following changes since commit e899966f626f1f657a4a7bac736c0b9ae5a243ea:

  Merge tag 'v3.15-rc6' into patchwork (2014-05-21 23:03:15 -0300)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git for-v3.16g

for you to fetch changes up to ba9a629032de6d0e8c3ff1448972061e25ef6619:

  media: stk1160: Avoid stack-allocated buffer for control URBs (2014-05-23 12:33:43 +0200)

----------------------------------------------------------------
Arun Kumar K (1):
      v4l: Add source change event

Dan Carpenter (1):
      Staging: dt3155v4l: set error code on failure

Ezequiel Garcia (1):
      media: stk1160: Avoid stack-allocated buffer for control URBs

Ismael Luceno (2):
      solo6x10: Reduce OSD writes to the minimum necessary
      solo6x10: Kconfig: Add supported card list to the SOLO6X10 knob

Laurent Pinchart (3):
      Documentation: media: Remove double 'struct'
      tvp5150: Replace container_of() with to_tvp5150()
      v4l: subdev: Move [gs]_std operation to video ops

Luis R. Rodriguez (2):
      technisat-usb2: rename led enums to be specific to driver
      bt8xx: make driver routines fit into its own namespcae

Pawel Osciak (1):
      s5p-mfc: Add support for resolution change event

Victor Lambret (1):
      videobuf2-core: remove duplicated code

 Documentation/DocBook/media/v4l/io.xml                     |  2 +-
 Documentation/DocBook/media/v4l/media-ioc-enum-links.xml   |  8 ++++----
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml         | 33 +++++++++++++++++++++++++++++++++
 Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml | 20 ++++++++++++++++++++
 drivers/media/i2c/adv7180.c                                |  2 +-
 drivers/media/i2c/adv7183.c                                |  4 ++--
 drivers/media/i2c/adv7842.c                                |  4 ++--
 drivers/media/i2c/bt819.c                                  |  2 +-
 drivers/media/i2c/cx25840/cx25840-core.c                   |  4 ++--
 drivers/media/i2c/ks0127.c                                 |  6 +-----
 drivers/media/i2c/ml86v7667.c                              |  2 +-
 drivers/media/i2c/msp3400-driver.c                         |  2 +-
 drivers/media/i2c/saa6752hs.c                              |  2 +-
 drivers/media/i2c/saa7110.c                                |  2 +-
 drivers/media/i2c/saa7115.c                                |  2 +-
 drivers/media/i2c/saa717x.c                                |  2 +-
 drivers/media/i2c/saa7191.c                                |  2 +-
 drivers/media/i2c/soc_camera/tw9910.c                      |  4 ++--
 drivers/media/i2c/sony-btf-mpx.c                           | 10 +++++-----
 drivers/media/i2c/tvaudio.c                                |  6 +++++-
 drivers/media/i2c/tvp514x.c                                |  2 +-
 drivers/media/i2c/tvp5150.c                                |  6 +++---
 drivers/media/i2c/tw2804.c                                 |  2 +-
 drivers/media/i2c/tw9903.c                                 |  2 +-
 drivers/media/i2c/tw9906.c                                 |  2 +-
 drivers/media/i2c/vp27smpx.c                               |  6 +++++-
 drivers/media/i2c/vpx3220.c                                |  2 +-
 drivers/media/pci/bt8xx/bttv-driver.c                      |  2 +-
 drivers/media/pci/bt8xx/dst.c                              | 20 ++++++++++----------
 drivers/media/pci/cx18/cx18-av-core.c                      |  2 +-
 drivers/media/pci/cx18/cx18-fileops.c                      |  2 +-
 drivers/media/pci/cx18/cx18-gpio.c                         |  6 +++++-
 drivers/media/pci/cx18/cx18-ioctl.c                        |  2 +-
 drivers/media/pci/cx23885/cx23885-video.c                  |  4 ++--
 drivers/media/pci/cx88/cx88-core.c                         |  2 +-
 drivers/media/pci/ivtv/ivtv-fileops.c                      |  2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                        |  2 +-
 drivers/media/pci/saa7134/saa7134-video.c                  |  4 ++--
 drivers/media/pci/saa7146/mxb.c                            | 14 +++++++-------
 drivers/media/pci/sta2x11/sta2x11_vip.c                    |  4 ++--
 drivers/media/pci/zoran/zoran_device.c                     |  2 +-
 drivers/media/pci/zoran/zoran_driver.c                     |  2 +-
 drivers/media/platform/blackfin/bfin_capture.c             |  4 ++--
 drivers/media/platform/davinci/vpfe_capture.c              |  2 +-
 drivers/media/platform/davinci/vpif_capture.c              |  2 +-
 drivers/media/platform/davinci/vpif_display.c              |  2 +-
 drivers/media/platform/fsl-viu.c                           |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c                   |  8 ++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c               |  2 ++
 drivers/media/platform/soc_camera/soc_camera.c             |  4 ++--
 drivers/media/platform/timblogiw.c                         |  2 +-
 drivers/media/platform/vino.c                              |  6 +++---
 drivers/media/usb/au0828/au0828-video.c                    |  4 ++--
 drivers/media/usb/cx231xx/cx231xx-417.c                    |  2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c                  |  6 +++---
 drivers/media/usb/dvb-usb/technisat-usb2.c                 | 28 ++++++++++++++--------------
 drivers/media/usb/em28xx/em28xx-video.c                    |  4 ++--
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                    |  2 +-
 drivers/media/usb/stk1160/stk1160-core.c                   | 10 +++++++++-
 drivers/media/usb/stk1160/stk1160-v4l.c                    |  4 ++--
 drivers/media/usb/stk1160/stk1160.h                        |  1 -
 drivers/media/usb/tm6000/tm6000-cards.c                    |  2 +-
 drivers/media/usb/tm6000/tm6000-video.c                    |  2 +-
 drivers/media/usb/usbvision/usbvision-video.c              |  2 +-
 drivers/media/v4l2-core/tuner-core.c                       |  6 +++++-
 drivers/media/v4l2-core/v4l2-event.c                       | 36 ++++++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/videobuf2-core.c                   |  4 ----
 drivers/staging/media/davinci_vpfe/vpfe_video.c            |  2 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c                |  4 +++-
 drivers/staging/media/go7007/go7007-v4l2.c                 |  2 +-
 drivers/staging/media/go7007/s2250-board.c                 |  2 +-
 drivers/staging/media/go7007/saa7134-go7007.c              |  4 ++++
 drivers/staging/media/solo6x10/Kconfig                     | 12 +++++++++---
 drivers/staging/media/solo6x10/solo6x10-enc.c              | 31 ++++++++++++++-----------------
 drivers/staging/media/solo6x10/solo6x10-offsets.h          |  2 ++
 include/media/v4l2-event.h                                 |  4 ++++
 include/media/v4l2-subdev.h                                |  6 +++---
 include/uapi/linux/videodev2.h                             |  8 ++++++++
 78 files changed, 286 insertions(+), 149 deletions(-)
