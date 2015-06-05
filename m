Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:37669 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877AbbFEO4y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 10:56:54 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 50DE32A0085
	for <linux-media@vger.kernel.org>; Fri,  5 Jun 2015 16:56:43 +0200 (CEST)
Message-ID: <5571B8AB.1090602@xs4all.nl>
Date: Fri, 05 Jun 2015 16:56:43 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] New ST driver, various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a bunch of various fixes and a new bdisp driver for ST.

Regards,

	Hans

The following changes since commit c1c3c85ddf60a6d97c122d57d385b4929fcec4b3:

  [media] DocBook: fix FE_SET_PROPERTY ioctl arguments (2015-06-01 06:10:15 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2o

for you to fetch changes up to febaafbd27c975a7a92ef99af31f06170c231129:

  v4l2-ioctl: log buffer type 0 correctly (2015-06-05 16:55:51 +0200)

----------------------------------------------------------------
Fabian Frederick (1):
      omap_vout: use swap() in omapvid_init()

Fabien Dessenne (3):
      bdisp: add DT bindings documentation
      bdisp: 2D blitter driver using v4l2 mem2mem framework
      bdisp: add debug file system

Fabio Estevam (1):
      radio-si470x-i2c: Pass the IRQF_ONESHOT flag

Hans Verkuil (6):
      vivid: move video loopback control to the capture device
      stk1160: add DMABUF support
      vivid-tpg: improve Y16 color setup
      v4l2-ioctl: clear the reserved field of v4l2_create_buffers
      DocBook media: correct description of reserved fields
      v4l2-ioctl: log buffer type 0 correctly

Juergen Gier (1):
      saa7134: switch tuner FMD1216ME_MK3 to analog

Nikhil Devshatwar (1):
      v4l: of: Correct pclk-sample for BT656 bus

 Documentation/DocBook/media/v4l/io.xml                         |   12 +-
 Documentation/DocBook/media/v4l/pixfmt.xml                     |    8 +-
 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml         |    3 +-
 Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml |    3 +-
 Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml     |    3 +-
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml              |    3 +-
 Documentation/DocBook/media/v4l/vidioc-g-selection.xml         |    2 +-
 Documentation/DocBook/media/v4l/vidioc-querybuf.xml            |    3 +-
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml             |    4 +-
 Documentation/devicetree/bindings/media/st,stih4xx.txt         |   32 ++
 Documentation/video4linux/vivid.txt                            |    2 +-
 drivers/media/pci/saa7134/saa7134-cards.c                      |   17 +-
 drivers/media/platform/Kconfig                                 |   10 +
 drivers/media/platform/Makefile                                |    2 +
 drivers/media/platform/omap/omap_vout.c                        |   10 +-
 drivers/media/platform/sti/bdisp/Kconfig                       |    9 +
 drivers/media/platform/sti/bdisp/Makefile                      |    3 +
 drivers/media/platform/sti/bdisp/bdisp-debug.c                 |  668 ++++++++++++++++++++++++++++
 drivers/media/platform/sti/bdisp/bdisp-filter.h                |  346 +++++++++++++++
 drivers/media/platform/sti/bdisp/bdisp-hw.c                    |  823 +++++++++++++++++++++++++++++++++++
 drivers/media/platform/sti/bdisp/bdisp-reg.h                   |  235 ++++++++++
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                  | 1420 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/sti/bdisp/bdisp.h                       |  216 +++++++++
 drivers/media/platform/vivid/vivid-core.h                      |    2 +-
 drivers/media/platform/vivid/vivid-ctrls.c                     |   81 ++--
 drivers/media/platform/vivid/vivid-tpg.c                       |   11 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c                  |    3 +-
 drivers/media/usb/stk1160/stk1160-v4l.c                        |    3 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                           |    3 +
 drivers/media/v4l2-core/v4l2-of.c                              |    8 +-
 30 files changed, 3866 insertions(+), 79 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/st,stih4xx.txt
 create mode 100644 drivers/media/platform/sti/bdisp/Kconfig
 create mode 100644 drivers/media/platform/sti/bdisp/Makefile
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-debug.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-filter.h
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-hw.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-reg.h
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-v4l2.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp.h
