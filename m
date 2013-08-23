Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:31394 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3HWNO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 09:14:56 -0400
Message-ID: <5217604B.8080600@cisco.com>
Date: Fri, 23 Aug 2013 15:14:51 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com
Subject: [GIT PULL FOR v3.12] Matrix and Motion Detection support, move solo/go7007
 out of staging
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request adds the motion detection and matrix API, implements it in the
solo6x10 and go7007 drivers and moves both drivers out of staging.

This pull request builds on top of my v3.12 pull request:

https://patchwork.linuxtv.org/patch/19898/

The only thing missing is enabling support for the WIS-Voyager saa7134 card that uses
the go7007 driver. I want to test that first to make sure nothing is broken since the
last time I used it. That may take some time before I can get around that, but that
board is very rare so there is no hurry with that.

Whether or not this can go in for 3.12 depends on your review of the new API elements.

Regards,

	Hans

The following changes since commit 72230f27e0c7668e14dbcbd8abc1ed1c08451931:

  MAINTAINERS: add entries for adv7511 and adv7842. (2013-08-23 14:12:44 +0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git md

for you to fetch changes up to 342b0b7b8864b6e27cd013e94cf687649083ac33:

  go7007: move out of staging into drivers/media/usb. (2013-08-23 14:49:57 +0200)

----------------------------------------------------------------
Hans Verkuil (12):
      v4l2-controls: add motion detection controls.
      v4l2: add matrix support.
      v4l2-compat-ioctl32: add g/s_matrix support
      solo: implement the new matrix ioctls instead of the custom ones.
      v4l2: add a motion detection event.
      solo6x10: implement motion detection events and controls.
      DocBook: add the new v4l detection class controls.
      DocBook: document new v4l motion detection event.
      DocBook: document the new v4l2 matrix ioctls.
      go7007: add motion detection support.
      solo6x10: move out of staging into drivers/media/pci.
      go7007: move out of staging into drivers/media/usb.

 Documentation/DocBook/media/v4l/controls.xml                      |  69 +++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml                          |   2 +
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml                |  40 ++++++
 Documentation/DocBook/media/v4l/vidioc-g-matrix.xml               | 108 ++++++++++++++++
 Documentation/DocBook/media/v4l/vidioc-query-matrix.xml           | 180 +++++++++++++++++++++++++++
 Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml        |   8 ++
 drivers/media/pci/Kconfig                                         |   1 +
 drivers/media/pci/Makefile                                        |   1 +
 drivers/{staging/media => media/pci}/solo6x10/Kconfig             |   2 +-
 drivers/{staging/media => media/pci}/solo6x10/Makefile            |   2 +-
 drivers/{staging/media => media/pci}/solo6x10/TODO                |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-core.c     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-disp.c     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-eeprom.c   |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-enc.c      |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-g723.c     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-gpio.c     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-i2c.c      |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-jpeg.h     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-offsets.h  |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-p2m.c      |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-regs.h     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.c     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.h     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2-enc.c | 219 ++++++++++++++++++++++++---------
 drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2.c     |   0
 drivers/{staging/media => media/pci}/solo6x10/solo6x10.h          |  19 +--
 drivers/media/usb/Kconfig                                         |   1 +
 drivers/media/usb/Makefile                                        |   1 +
 drivers/{staging/media => media/usb}/go7007/Kconfig               |   0
 drivers/{staging/media => media/usb}/go7007/Makefile              |   0
 drivers/{staging/media => media/usb}/go7007/README                |   0
 drivers/{staging/media => media/usb}/go7007/go7007-driver.c       | 119 +++++++++++++-----
 drivers/{staging/media => media/usb}/go7007/go7007-fw.c           |  28 +++--
 drivers/{staging/media => media/usb}/go7007/go7007-i2c.c          |   0
 drivers/{staging/media => media/usb}/go7007/go7007-loader.c       |   0
 drivers/{staging/media => media/usb}/go7007/go7007-priv.h         |  16 +++
 drivers/{staging/media => media/usb}/go7007/go7007-usb.c          |   0
 drivers/{staging/media => media/usb}/go7007/go7007-v4l2.c         | 382 ++++++++++++++++++++++++++++++++++++++++++---------------
 drivers/{staging/media => media/usb}/go7007/go7007.txt            |   0
 drivers/{staging/media => media/usb}/go7007/s2250-board.c         |   0
 drivers/{staging/media => media/usb}/go7007/saa7134-go7007.c      |   1 -
 drivers/{staging/media => media/usb}/go7007/snd-go7007.c          |   0
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c                     |  50 +++++++-
 drivers/media/v4l2-core/v4l2-ctrls.c                              |  31 ++++-
 drivers/media/v4l2-core/v4l2-dev.c                                |   3 +
 drivers/media/v4l2-core/v4l2-ioctl.c                              |  23 +++-
 drivers/staging/media/Kconfig                                     |   4 -
 drivers/staging/media/Makefile                                    |   2 -
 drivers/staging/media/go7007/go7007.h                             |  40 ------
 include/media/v4l2-ioctl.h                                        |   8 ++
 include/uapi/linux/v4l2-controls.h                                |  14 +++
 include/uapi/linux/videodev2.h                                    |  73 +++++++++++
 53 files changed, 1174 insertions(+), 273 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-matrix.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-query-matrix.xml
 rename drivers/{staging/media => media/pci}/solo6x10/Kconfig (93%)
 rename drivers/{staging/media => media/pci}/solo6x10/Makefile (82%)
 rename drivers/{staging/media => media/pci}/solo6x10/TODO (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-core.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-disp.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-eeprom.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-enc.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-g723.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-gpio.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-i2c.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-jpeg.h (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-offsets.h (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-p2m.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-regs.h (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-tw28.h (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2-enc.c (88%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10-v4l2.c (100%)
 rename drivers/{staging/media => media/pci}/solo6x10/solo6x10.h (93%)
 rename drivers/{staging/media => media/usb}/go7007/Kconfig (100%)
 rename drivers/{staging/media => media/usb}/go7007/Makefile (100%)
 rename drivers/{staging/media => media/usb}/go7007/README (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-driver.c (88%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-fw.c (97%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-i2c.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-loader.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-priv.h (90%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-usb.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/go7007-v4l2.c (77%)
 rename drivers/{staging/media => media/usb}/go7007/go7007.txt (100%)
 rename drivers/{staging/media => media/usb}/go7007/s2250-board.c (100%)
 rename drivers/{staging/media => media/usb}/go7007/saa7134-go7007.c (99%)
 rename drivers/{staging/media => media/usb}/go7007/snd-go7007.c (100%)
 delete mode 100644 drivers/staging/media/go7007/go7007.h
