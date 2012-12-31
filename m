Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:62995 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2LaQD1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 11:03:27 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 00/15] V4L2 device tree bindings and OF helpers
Date: Mon, 31 Dec 2012 17:02:58 +0100
Message-id: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series includes the updated DT bindings documentation and the V4L2 OF
parser. Changes since v1:

 - renamed 'link' nodes to 'endpoint', remote phandle to 'remote-endpoint'
   in the common bindings documentation file,
 - removed references to V4L2 in the documentation,
 - file v4l2.txt renamed to video-interfaces.txt,
 - dropped patches adding empty function definitions for when CONFIG_OF
   is disabled,
 - v4l2_of_parse_link() function renamed to v4l2_of_parse_endpoint,
 - created separate helpers to parse parallel and MIPI-CSI2 bus properties
   independently.

The bindings documentation patch is almost unchanged since version posted
on 12 Dec [1].

This series also includes patches adding device tree support for Exynos4
SoC camera subsystem drivers. Changes in that part include:

 - code refactoring to not depend on dummy function definitions,
 - updated to use new helpers from drivers/media/v4l2-core/v4l2-of.c,
 - added parsing of nodes corresponding to parallel video bus sensors.

My next steps include testing this on top of the common clock framework
patches for Exynos SoCs, posted recently by Thomas Abraham, and further
adding support for v4l2 asynchronous sub-device registration. However
I'd like to possibly have these patches in mainline first, only except
the "ARM: EXYNOS4: Add OF_DEV_AUXDATA for FIMC, FIMC-LITE and CSIS" one,
which won't be needed when there is common clock support available.

I appreciate any feedback, especially on the documentation and the OF
helpers.

Full tree containing all patches can be browsed at [2].

[1] http://patchwork.linuxtv.org/patch/15911/
[2] http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/v3.7-pq-camera-dt


Guennadi Liakhovetski (2):
  [media] Add common video interfaces OF bindings documentation
  [media] Add a V4L2 OF parser

Sylwester Nawrocki (13):
  s5p-csis: Add device tree support
  s5p-fimc: Support for FIMC devices instantiated from the device tree
  s5p-fimc: Support for FIMC-LITE devices instantiated from the device
    tree
  s5p-fimc: Change platform subdevs registration method
  s5p-fimc: Support camera media device initialization on DT systems
  s5p-fimc: Add device tree based sensors registration
  s5p-fimc: Use pinctrl API for camera ports configuration
  ARM: EXYNOS4: Add OF_DEV_AUXDATA for FIMC, FIMC-LITE and CSIS
  ARM: dts: Add camera node exynos4.dtsi
  ARM: dts: Add ISP power domain node for Exynos4x12
  ARM: dts: Add FIMC and MIPI CSIS device nodes for Exynos4x12
  ARM: dts: Add camera pinctrl nodes for Exynos4x12 SoCs
  ARM: dts: Add camera device nodes nodes for PQ board

 .../devicetree/bindings/media/soc/samsung-fimc.txt |  183 +++++++
 .../bindings/media/soc/samsung-mipi-csis.txt       |   84 ++++
 .../devicetree/bindings/media/video-interfaces.txt |  198 ++++++++
 arch/arm/boot/dts/exynos4.dtsi                     |   64 +++
 arch/arm/boot/dts/exynos4412-slp_pq.dts            |  133 +++++
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi          |   33 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |   52 ++
 arch/arm/mach-exynos/mach-exynos4-dt.c             |   16 +
 drivers/media/platform/s5p-fimc/fimc-capture.c     |    2 +-
 drivers/media/platform/s5p-fimc/fimc-core.c        |   85 ++--
 drivers/media/platform/s5p-fimc/fimc-lite.c        |   65 ++-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |  529 +++++++++++++++-----
 drivers/media/platform/s5p-fimc/fimc-mdevice.h     |   10 +
 drivers/media/platform/s5p-fimc/mipi-csis.c        |  159 ++++--
 drivers/media/platform/s5p-fimc/mipi-csis.h        |    1 +
 drivers/media/v4l2-core/Makefile                   |    3 +
 drivers/media/v4l2-core/v4l2-of.c                  |  249 +++++++++
 include/media/s5p_fimc.h                           |   16 +
 include/media/v4l2-of.h                            |   79 +++
 19 files changed, 1739 insertions(+), 222 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
 create mode 100644 Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
 create mode 100644 Documentation/devicetree/bindings/media/video-interfaces.txt
 create mode 100644 drivers/media/v4l2-core/v4l2-of.c
 create mode 100644 include/media/v4l2-of.h

--
1.7.9.5

