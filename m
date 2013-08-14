Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:45651 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3HNEqE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Aug 2013 00:46:04 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: s.nawrocki@samsung.com, hverkuil@xs4all.nl, swarren@wwwdotorg.org,
	a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v5 00/13] Exynos5 IS driver
Date: Wed, 14 Aug 2013 10:16:01 +0530
Message-Id: <1376455574-15560-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch series add support for Exynos5 camera subsystem. It
re-uses mipi-csis and fimc-lite from exynos4-is and adds a new
media device and fimc-is device drivers for exynos5.
The media device supports asynchronos subdev registration for the
fimc-is sensors and is tested on top of the patch series from Sylwester
for exynos4-is [1].

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg64653.html

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
  V4L: s5k6a3: Change sensor min/max resolutions
  V4L: Add driver for s5k4e5 image sensor

Shaik Ameer Basha (1):
  [media] exynos5-is: Adding media device driver for exynos5

 .../devicetree/bindings/media/exynos5-fimc-is.txt  |   47 +
 .../devicetree/bindings/media/exynos5-mdev.txt     |  130 ++
 .../devicetree/bindings/media/i2c/s5k4e5.txt       |   43 +
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/s5k4e5.c                         |  361 +++++
 drivers/media/i2c/s5k6a3.c                         |   19 +-
 drivers/media/platform/Kconfig                     |    1 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/exynos5-is/Kconfig          |   20 +
 drivers/media/platform/exynos5-is/Makefile         |    7 +
 drivers/media/platform/exynos5-is/exynos5-mdev.c   | 1218 ++++++++++++++
 drivers/media/platform/exynos5-is/exynos5-mdev.h   |  160 ++
 drivers/media/platform/exynos5-is/fimc-is-cmd.h    |  187 +++
 drivers/media/platform/exynos5-is/fimc-is-core.c   |  413 +++++
 drivers/media/platform/exynos5-is/fimc-is-core.h   |  132 ++
 drivers/media/platform/exynos5-is/fimc-is-err.h    |  257 +++
 .../media/platform/exynos5-is/fimc-is-interface.c  |  810 ++++++++++
 .../media/platform/exynos5-is/fimc-is-interface.h  |  125 ++
 drivers/media/platform/exynos5-is/fimc-is-isp.c    |  534 ++++++
 drivers/media/platform/exynos5-is/fimc-is-isp.h    |   90 ++
 .../media/platform/exynos5-is/fimc-is-metadata.h   |  767 +++++++++
 drivers/media/platform/exynos5-is/fimc-is-param.h  | 1159 ++++++++++++++
 .../media/platform/exynos5-is/fimc-is-pipeline.c   | 1692 ++++++++++++++++++++
 .../media/platform/exynos5-is/fimc-is-pipeline.h   |  128 ++
 drivers/media/platform/exynos5-is/fimc-is-regs.h   |  105 ++
 drivers/media/platform/exynos5-is/fimc-is-scaler.c |  472 ++++++
 drivers/media/platform/exynos5-is/fimc-is-scaler.h |  106 ++
 drivers/media/platform/exynos5-is/fimc-is-sensor.c |   45 +
 drivers/media/platform/exynos5-is/fimc-is-sensor.h |   65 +
 drivers/media/platform/exynos5-is/fimc-is.h        |  160 ++
 31 files changed, 9255 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-mdev.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
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

-- 
1.7.9.5

