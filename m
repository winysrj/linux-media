Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:16228 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3ENLuX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 07:50:23 -0400
From: George Joseph <george.jp@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, ym.song@samsung.com
Subject: [RFC PATCH 0/3] [media] s5p-jpeg: Add support for Exynos4x12 and 5250
Date: Tue, 14 May 2013 17:23:37 +0530
Message-id: <1368532420-21555-1-git-send-email-george.jp@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: George Joseph Palathingal <george.jp@samsung.com>

This patch series refactors the JPEG driver to add code to support Exynos4x12
and Exynos5250 JPEG IPs and makes the driver DT and CCF compliant.

Exynos4210 JPEG driver supports only single planar image formats.
The JPEG IP on Exynos4412 and 5250 supports multiplanar image formats as well.
So the existing JPEG driver is refactored to support the JPEG h/w on all
the three SoCs. The encoder/decoder functionalities are separated to
two different files for better modularity.

The encoder/decoder functionalities have been tested on Origen 4210, 4412 and SMDK 5250
boards. There is currently an issue with the Exynos 4210 JPEG encoder which will be
fixed in subsequent patches.

The patch series is based on linux-next tree (20130514).

George Joseph Palathingal (2):
  [media] s5p-jpeg: Add support for Exynos4x12 and 5250
  [media] s5p-jpeg: Add DT support to JPEG driver

Sylwester Nawrocki (1):
  ARM: dts: Add documentation for Samsung JPEG driver bindings

 .../devicetree/bindings/media/samsung-s5p-jpeg.txt |   21 +
 drivers/media/platform/s5p-jpeg/Makefile           |    4 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 2041 +++++++++-----------
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |  428 ++--
 drivers/media/platform/s5p-jpeg/jpeg-dec.c         |  489 +++++
 drivers/media/platform/s5p-jpeg/jpeg-enc.c         |  521 +++++
 drivers/media/platform/s5p-jpeg/jpeg-hw-v1.h       |  528 +++++
 drivers/media/platform/s5p-jpeg/jpeg-hw-v2.c       |  614 ++++++
 drivers/media/platform/s5p-jpeg/jpeg-hw-v2.h       |   47 +
 drivers/media/platform/s5p-jpeg/jpeg-hw.h          |  357 ----
 drivers/media/platform/s5p-jpeg/jpeg-regs-v1.h     |  171 ++
 drivers/media/platform/s5p-jpeg/jpeg-regs-v2.h     |  191 ++
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  170 --
 13 files changed, 3787 insertions(+), 1795 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5p-jpeg.txt
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-dec.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-enc.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-v1.h
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-v2.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-v2.h
 delete mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw.h
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-regs-v1.h
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-regs-v2.h
 delete mode 100644 drivers/media/platform/s5p-jpeg/jpeg-regs.h

-- 
1.7.9.5

