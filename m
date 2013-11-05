Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42957 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3KEGMy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 01:12:54 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, hverkuil@xs4all.nl, swarren@wwwdotorg.org,
	mark.rutland@arm.com, Pawel.Moll@arm.com, galak@codeaurora.org,
	a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v11 00/12] Exynos5 IS driver
Date: Tue,  5 Nov 2013 11:42:31 +0530
Message-Id: <1383631964-26514-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch series adds support for exynos5 fimc-is driver and a
new sensor s5k4e5. The media driver part is omitted form this series
as it is already applied.

Changes from v10
---------------
- Addressed DT binding review comments from Mark Rutland
https://www.mail-archive.com/linux-media@vger.kernel.org/msg67806.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg67808.html

Changes from v9
---------------
- Addressed review comments from Hans and Sylwester
http://www.mail-archive.com/linux-media@vger.kernel.org/msg67102.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg67624.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg67623.html
- Skipped already applied media driver

Changes from v8
---------------
- Moved i2c-isp device nodes into the fimc-is node as suggested
  by Sylwester
- Addressed comments given by Sylwester and Philipp Zabel

Changes from v7
---------------
- Addressed few DT related review comments from Sylwester
  http://www.mail-archive.com/linux-media@vger.kernel.org/msg66403.html
- Few fixes added after some regression testing

Changes from v6
---------------
- Addressed DT binding doc review comments from Sylwester
  http://www.mail-archive.com/linux-media@vger.kernel.org/msg65771.html
  http://www.mail-archive.com/linux-media@vger.kernel.org/msg65772.html

Changes from v5
---------------
- Addressed review comments from Sylwester
  http://www.mail-archive.com/linux-media@vger.kernel.org/msg65578.html
  http://www.mail-archive.com/linux-media@vger.kernel.org/msg65605.html

Changes from v4
---------------
- Addressed all review comments from Sylwester
- Added separate PMU node as suggested by Stephen Warren
- Added phandle based discovery of subdevs instead of node name

Changes from v3
---------------
- Dropped the RFC tag
- Addressed all review comments from Sylwester and Sachin
- Removed clock provider for media dev
- Added s5k4e5 sensor devicetree binding doc

Changes from v2
---------------
- Added exynos5 media device driver from Shaik to this series
- Added ISP pipeline support in media device driver
- Based on Sylwester's latest exynos4-is development
- Asynchronos registration of sensor subdevs
- Made independent IS-sensor support
- Add s5k4e5 sensor driver
- Addressed review comments from Sylwester, Hans, Andrzej, Sachin

Changes from v1
---------------
- Addressed all review comments from Sylwester
- Made sensor subdevs as independent i2c devices
- Lots of cleanup
- Debugfs support added
- Removed PMU global register access

Arun Kumar K (12):
  [media] exynos5-fimc-is: Add Exynos5 FIMC-IS device tree bindings
    documentation
  [media] exynos5-fimc-is: Add driver core files
  [media] exynos5-fimc-is: Add common driver header files
  [media] exynos5-fimc-is: Add register definition and context header
  [media] exynos5-fimc-is: Add isp subdev
  [media] exynos5-fimc-is: Add scaler subdev
  [media] exynos5-fimc-is: Add sensor interface
  [media] exynos5-fimc-is: Add the hardware pipeline control
  [media] exynos5-fimc-is: Add the hardware interface module
  [media] exynos5-is: Add Kconfig and Makefile
  V4L: Add DT binding doc for s5k4e5 image sensor
  V4L: Add s5k4e5 sensor driver

 .../devicetree/bindings/media/exynos5-fimc-is.txt  |  113 ++
 .../devicetree/bindings/media/samsung-s5k4e5.txt   |   45 +
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/s5k4e5.c                         |  344 ++++
 drivers/media/platform/Kconfig                     |    1 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/exynos5-is/Kconfig          |   20 +
 drivers/media/platform/exynos5-is/Makefile         |    7 +
 drivers/media/platform/exynos5-is/fimc-is-cmd.h    |  187 +++
 drivers/media/platform/exynos5-is/fimc-is-core.c   |  410 +++++
 drivers/media/platform/exynos5-is/fimc-is-core.h   |  132 ++
 drivers/media/platform/exynos5-is/fimc-is-err.h    |  257 +++
 .../media/platform/exynos5-is/fimc-is-interface.c  |  810 ++++++++++
 .../media/platform/exynos5-is/fimc-is-interface.h  |  124 ++
 drivers/media/platform/exynos5-is/fimc-is-isp.c    |  534 ++++++
 drivers/media/platform/exynos5-is/fimc-is-isp.h    |   90 ++
 .../media/platform/exynos5-is/fimc-is-metadata.h   |  767 +++++++++
 drivers/media/platform/exynos5-is/fimc-is-param.h  | 1159 +++++++++++++
 .../media/platform/exynos5-is/fimc-is-pipeline.c   | 1699 ++++++++++++++++++++
 .../media/platform/exynos5-is/fimc-is-pipeline.h   |  129 ++
 drivers/media/platform/exynos5-is/fimc-is-regs.h   |  105 ++
 drivers/media/platform/exynos5-is/fimc-is-scaler.c |  476 ++++++
 drivers/media/platform/exynos5-is/fimc-is-scaler.h |  106 ++
 drivers/media/platform/exynos5-is/fimc-is-sensor.c |   45 +
 drivers/media/platform/exynos5-is/fimc-is-sensor.h |   65 +
 drivers/media/platform/exynos5-is/fimc-is.h        |  160 ++
 27 files changed, 7795 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k4e5.txt
 create mode 100644 drivers/media/i2c/s5k4e5.c
 create mode 100644 drivers/media/platform/exynos5-is/Kconfig
 create mode 100644 drivers/media/platform/exynos5-is/Makefile
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

-- 
1.7.9.5

