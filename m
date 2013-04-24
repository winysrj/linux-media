Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34875 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab3DXHmP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 03:42:15 -0400
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com,
	arunkk.samsung@gmail.com
Subject: [RFC v2 0/6] Adding media device driver for Exynos5 imaging subsystem
Date: Wed, 24 Apr 2013 13:11:07 +0530
Message-Id: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patchset features:

1] Creating a common pipeline framework which can be used by all
Exynos series SoCs for developing media device drivers.
2] Modified the existing fimc-mdevice for exynos4 to use the common
pipeline framework.
3] Adding of media device driver for Exynos5 Imaging subsystem.
4] Upgrading mipi-csis and fimc-lite drivers for Exynos5 SoCs.

Current changes are not tested on exynos4 series SoCs. Current media
device driver only support one pipeline (pipeline0) which consists of
        Sensor --> MIPI-CSIS --> FIMC-LITE
        Sensor --> FIMC-LITE
G-Scaler support to pipeline0 will be added later.

Once the fimc-is device driver is posted, one more pipeline (pipeline1)
will be added for exynos5 media device driver for fimc-is sub-devices.

This patchset is rebased on:
git://linuxtv.org/snawrocki/samsung.git:for_v3.10_2

Shaik Ameer Basha (6):
  media: exynos4-is: modify existing mdev to use common pipeline
  fimc-lite: Adding Exynos5 compatibility to fimc-lite driver
  media: fimc-lite: Adding support for Exynos5
  media: fimc-lite: Fix for DMA output corruption
  media: s5p-csis: Adding Exynos5250 compatibility
  media: exynos5-is: Adding media device driver for exynos5

 .../devicetree/bindings/media/exynos5-mdev.txt     |  153 +++
 drivers/media/platform/Kconfig                     |    1 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/exynos4-is/fimc-capture.c   |   47 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |   16 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.h  |   41 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   45 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |    4 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  179 +++-
 drivers/media/platform/exynos4-is/media-dev.h      |   16 +
 drivers/media/platform/exynos4-is/mipi-csis.c      |    3 +-
 drivers/media/platform/exynos5-is/Kconfig          |    7 +
 drivers/media/platform/exynos5-is/Makefile         |    4 +
 drivers/media/platform/exynos5-is/exynos5-mdev.c   | 1131 ++++++++++++++++++++
 drivers/media/platform/exynos5-is/exynos5-mdev.h   |  120 +++
 include/media/s5p_fimc.h                           |   46 +-
 16 files changed, 1757 insertions(+), 57 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-mdev.txt
 create mode 100644 drivers/media/platform/exynos5-is/Kconfig
 create mode 100644 drivers/media/platform/exynos5-is/Makefile
 create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
 create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h

-- 
1.7.9.5

