Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60429 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbbERGVT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 02:21:19 -0400
Received: from [192.168.1.106] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 089CB2A007E
	for <linux-media@vger.kernel.org>; Mon, 18 May 2015 08:21:00 +0200 (CEST)
Message-ID: <555984D9.1010300@xs4all.nl>
Date: Mon, 18 May 2015 08:21:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Add cobalt driver
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unchanged (except for rebasing) to:

http://www.spinics.net/lists/linux-media/msg89635.html

See the same link for the background info for this driver.

Regards,

	Hans

The following changes since commit 0fae1997f09796aca8ada5edc028aef587f6716c:

  [media] dib0700: avoid the risk of forgetting to add the adapter's size (2015-05-14 19:31:34 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cobalt

for you to fetch changes up to 0bc0666d37eb69e1fbd4c38edac56b941776be9e:

  cobalt: add new driver (2015-05-18 08:11:28 +0200)

----------------------------------------------------------------
Hans Verkuil (4):
      adv7842: Make output format configurable through pad format operations
      vb2: allow requeuing buffers while streaming
      adv7604/adv7842: replace FMT_CHANGED by V4L2_DEVICE_NOTIFY_EVENT
      cobalt: add new driver

jean-michel.hautbois@vodalys.com (1):
      v4l2-subdev: allow subdev to send an event to the v4l2_device notify function

 Documentation/video4linux/v4l2-framework.txt                        |    4 +
 MAINTAINERS                                                         |    8 +
 drivers/media/i2c/adv7604.c                                         |   12 +-
 drivers/media/i2c/adv7842.c                                         |  280 ++++++-
 drivers/media/pci/Kconfig                                           |    1 +
 drivers/media/pci/Makefile                                          |    1 +
 drivers/media/pci/cobalt/Kconfig                                    |   18 +
 drivers/media/pci/cobalt/Makefile                                   |    5 +
 drivers/media/pci/cobalt/cobalt-alsa-main.c                         |  162 ++++
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c                          |  603 +++++++++++++++
 drivers/media/pci/cobalt/cobalt-alsa-pcm.h                          |   22 +
 drivers/media/pci/cobalt/cobalt-alsa.h                              |   41 ++
 drivers/media/pci/cobalt/cobalt-cpld.c                              |  341 +++++++++
 drivers/media/pci/cobalt/cobalt-cpld.h                              |   29 +
 drivers/media/pci/cobalt/cobalt-driver.c                            |  821 +++++++++++++++++++++
 drivers/media/pci/cobalt/cobalt-driver.h                            |  377 ++++++++++
 drivers/media/pci/cobalt/cobalt-flash.c                             |  132 ++++
 drivers/media/pci/cobalt/cobalt-flash.h                             |   29 +
 drivers/media/pci/cobalt/cobalt-i2c.c                               |  396 ++++++++++
 drivers/media/pci/cobalt/cobalt-i2c.h                               |   25 +
 drivers/media/pci/cobalt/cobalt-irq.c                               |  254 +++++++
 drivers/media/pci/cobalt/cobalt-irq.h                               |   25 +
 drivers/media/pci/cobalt/cobalt-omnitek.c                           |  341 +++++++++
 drivers/media/pci/cobalt/cobalt-omnitek.h                           |   62 ++
 drivers/media/pci/cobalt/cobalt-v4l2.c                              | 1260 ++++++++++++++++++++++++++++++++
 drivers/media/pci/cobalt/cobalt-v4l2.h                              |   22 +
 drivers/media/pci/cobalt/m00233_video_measure_memmap_package.h      |  115 +++
 drivers/media/pci/cobalt/m00235_fdma_packer_memmap_package.h        |   44 ++
 drivers/media/pci/cobalt/m00389_cvi_memmap_package.h                |   59 ++
 drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h              |   44 ++
 drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h          |   57 ++
 drivers/media/pci/cobalt/m00479_clk_loss_detector_memmap_package.h  |   53 ++
 drivers/media/pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h |   88 +++
 drivers/media/v4l2-core/videobuf2-core.c                            |   11 +-
 include/media/adv7604.h                                             |    1 -
 include/media/adv7842.h                                             |   92 +--
 include/media/v4l2-subdev.h                                         |    2 +
 37 files changed, 5743 insertions(+), 94 deletions(-)
 create mode 100644 drivers/media/pci/cobalt/Kconfig
 create mode 100644 drivers/media/pci/cobalt/Makefile
 create mode 100644 drivers/media/pci/cobalt/cobalt-alsa-main.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-alsa-pcm.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-alsa-pcm.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-alsa.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-cpld.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-cpld.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-driver.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-driver.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-flash.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-flash.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-i2c.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-i2c.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-irq.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-irq.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-omnitek.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-omnitek.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-v4l2.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-v4l2.h
 create mode 100644 drivers/media/pci/cobalt/m00233_video_measure_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00235_fdma_packer_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00389_cvi_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00479_clk_loss_detector_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h
