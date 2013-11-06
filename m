Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39494 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab3KFOs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 09:48:28 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVU00FE3JREALB0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Nov 2013 14:48:26 +0000 (GMT)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MVU00ARAJSQFC70@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Nov 2013 14:48:26 +0000 (GMT)
Message-id: <527A56B4.9010805@samsung.com>
Date: Wed, 06 Nov 2013 15:48:20 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL v2]  Exynos5 SoC FIMC-IS imaging subsystem driver
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This change set adds a V4L2 driver for the Exynos5 SoC series camera subsystem.
It also includes a minimal v4l2 subdev driver for s5k4e5 raw image sensor.
Comparing to the original pull request, the DT binding documentation is on
separate patches and some DT binding maintainer acks were added. There were
also some minor cleanups addressing comments from further reviews. I commented
on some further issues [1], I'd like to possibly have them addressed in follow
up patches.

The following changes since commit 80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:

  [media] media: st-rc: Add ST remote control driver (2013-10-31 08:20:08 -0200)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v3.13-2

for you to fetch changes up to 1f950a5331ce0297d7549dab3a4827d736f953a4:

  V4L: Add s5k4e5 sensor driver (2013-11-06 00:44:57 +0100)

----------------------------------------------------------------
Arun Kumar K (12):
      exynos5-fimc-is: Add Exynos5 FIMC-IS device tree bindings documentation
      exynos5-fimc-is: Add driver core files
      exynos5-fimc-is: Add common driver header files
      exynos5-fimc-is: Add register definition and context header
      exynos5-fimc-is: Add isp subdev
      exynos5-fimc-is: Add scaler subdev
      exynos5-fimc-is: Add sensor interface
      exynos5-fimc-is: Add the hardware pipeline control
      exynos5-fimc-is: Add the hardware interface module
      exynos5-is: Add Kconfig and Makefile
      V4L: Add DT binding doc for s5k4e5 image sensor
      V4L: Add s5k4e5 sensor driver

Shaik Ameer Basha (2):
      exynos5-is: Add DT binding documentation
      exynos5-is: Add media device driver for exynos5 SoCs camera subsystem

 .../devicetree/bindings/media/exynos5-fimc-is.txt  |  113 ++
 .../bindings/media/exynos5250-camera.txt           |  126 ++
 .../devicetree/bindings/media/samsung-s5k4e5.txt   |   45 +
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/s5k4e5.c                         |  344 ++++
 drivers/media/platform/Kconfig                     |    1 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/exynos5-is/Kconfig          |   20 +
 drivers/media/platform/exynos5-is/Makefile         |    7 +
 drivers/media/platform/exynos5-is/exynos5-mdev.c   | 1210 ++++++++++++++
 drivers/media/platform/exynos5-is/exynos5-mdev.h   |  126 ++
 drivers/media/platform/exynos5-is/fimc-is-cmd.h    |  187 +++
 drivers/media/platform/exynos5-is/fimc-is-core.c   |  387 +++++
 drivers/media/platform/exynos5-is/fimc-is-core.h   |  117 ++
 drivers/media/platform/exynos5-is/fimc-is-err.h    |  257 +++
 .../media/platform/exynos5-is/fimc-is-interface.c  |  810 ++++++++++
 .../media/platform/exynos5-is/fimc-is-interface.h  |  124 ++
 drivers/media/platform/exynos5-is/fimc-is-isp.c    |  533 ++++++
 drivers/media/platform/exynos5-is/fimc-is-isp.h    |   90 ++
 .../media/platform/exynos5-is/fimc-is-metadata.h   |  767 +++++++++
 drivers/media/platform/exynos5-is/fimc-is-param.h  | 1159 +++++++++++++
 .../media/platform/exynos5-is/fimc-is-pipeline.c   | 1699 ++++++++++++++++++++
 .../media/platform/exynos5-is/fimc-is-pipeline.h   |  129 ++
 drivers/media/platform/exynos5-is/fimc-is-regs.h   |  105 ++
 drivers/media/platform/exynos5-is/fimc-is-scaler.c |  475 ++++++
 drivers/media/platform/exynos5-is/fimc-is-scaler.h |  106 ++
 drivers/media/platform/exynos5-is/fimc-is-sensor.c |   45 +
 drivers/media/platform/exynos5-is/fimc-is-sensor.h |   65 +
 drivers/media/platform/exynos5-is/fimc-is.h        |  160 ++
 30 files changed, 9217 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
 create mode 100644 Documentation/devicetree/bindings/media/exynos5250-camera.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k4e5.txt
 create mode 100644 drivers/media/i2c/s5k4e5.c
 create mode 100644 drivers/media/platform/exynos5-is/Kconfig
 create mode 100644 drivers/media/platform/exynos5-is/Makefile
 create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
 create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-cmd.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-core.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-core.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-err.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-interface.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-interface.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-metadata.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-param.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-pipeline.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-pipeline.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-regs.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-scaler.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-scaler.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.h
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is.h

[1] https://patchwork.linuxtv.org/patch/20609/

--
Regards,
Sylwester
