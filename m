Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:12709 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab3AWTbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 14:31:51 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, myungjoo.ham@samsung.com,
	sw0312.kim@samsung.com, prabhakar.lad@ti.com,
	devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v3 00/14] V4L2 device tree bindings and OF helpers
Date: Wed, 23 Jan 2013 20:31:15 +0100
Message-id: <1358969489-20420-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series includes the updated device tree bindings documentation and
the V4L2 OF parser (v4). There were just couple minor changes since v3:
     - improved clock-lanes property description,
     - grammar corrections of the example dts snippet description,
     - minor comments corrections.

This series also includes patches adding device tree support for Exynos4
SoC camera subsystem. Changes in this part include:
 - dropped patch adding OF_DEV_AUXDATA entries as this series has
   been tested with the new Exynos4 clocks driver;
 - max-data-lanes property of the CSIS device node replaced with bus-width;
 - added clock-frequency property to FIMC device nodes;
 - corrected FIMC-LITE devices registration (the code didn't consider
   they are child nodes of the fimc-is node);
 - removed the "inactive" camera port pinctrl state, it is now optional
   and handling of it wasn't implemeted at the driver yet anyway;

I have also tested this patch set with the FIMC-IS (the camera ISP
subsystem with a dedicated ARM MCU) driver.

For the media patches 01..09/14 I intend to send a pull request within
a few days. Patches 10..13/14 I'd like to be applied by the Samsung
platforms maintainer.

Patch 14/14 is an example only.

Thank you for all reviews!

Guennadi Liakhovetski (2):
  [media] Add common video interfaces OF bindings documentation
  [media] Add a V4L2 OF parser

Sylwester Nawrocki (12):
  s5p-csis: Add device tree support
  s5p-fimc: Add device tree support for FIMC devices
  s5p-fimc: Add device tree support for FIMC-LITE devices
  s5p-fimc: Change platform subdevs registration method
  s5p-fimc: Add device tree support for the main media device driver
  s5p-fimc: Add device tree based sensors registration
  s5p-fimc: Use pinctrl API for camera ports configuration
  ARM: dts: Add camera to node exynos4.dtsi
  ARM: dts: Add ISP power domain node for Exynos4x12
  ARM: dts: Add FIMC and MIPI CSIS device nodes for Exynos4x12
  ARM: dts: Add camera pinctrl nodes for Exynos4x12 SoCs
  ARM: dts: Add camera device nodes nodes for PQ board

 .../devicetree/bindings/media/soc/samsung-fimc.txt |  184 +++++++
 .../bindings/media/soc/samsung-mipi-csis.txt       |   82 +++
 .../devicetree/bindings/media/video-interfaces.txt |  204 ++++++++
 arch/arm/boot/dts/exynos4.dtsi                     |   64 +++
 arch/arm/boot/dts/exynos4412-slp_pq.dts            |  169 +++++++
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi          |   33 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |   52 ++
 drivers/media/platform/s5p-fimc/fimc-capture.c     |    2 +-
 drivers/media/platform/s5p-fimc/fimc-core.c        |   94 ++--
 drivers/media/platform/s5p-fimc/fimc-lite.c        |   65 ++-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |  526 +++++++++++++++-----
 drivers/media/platform/s5p-fimc/fimc-mdevice.h     |    6 +
 drivers/media/platform/s5p-fimc/mipi-csis.c        |  158 ++++--
 drivers/media/platform/s5p-fimc/mipi-csis.h        |    1 +
 drivers/media/v4l2-core/Makefile                   |    3 +
 drivers/media/v4l2-core/v4l2-of.c                  |  253 ++++++++++
 include/media/s5p_fimc.h                           |   17 +
 include/media/v4l2-of.h                            |   79 +++
 18 files changed, 1771 insertions(+), 221 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
 create mode 100644 Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
 create mode 100644 Documentation/devicetree/bindings/media/video-interfaces.txt
 create mode 100644 drivers/media/v4l2-core/v4l2-of.c
 create mode 100644 include/media/v4l2-of.h

--
1.7.9.5

