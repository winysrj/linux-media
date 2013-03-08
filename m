Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:26539 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3CHOju (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 09:39:50 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC 00/12] Exynos5 FIMC-IS driver
Date: Fri, 08 Mar 2013 09:59:13 -0500
Message-id: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds a new driver for the FIMC-IS IP available in
Samsung Exynos5 SoC onwards. The camera subsystem in Exynos5 is significantly
different from that of Exynos4 and before. 
In Exynos4, the FIMC-IS is a sub component of the camera subsystem which
takes input from fimc-lite and does post processing of the image and passes
it to the fimc-capture which writes to the output DMA.

But in case of Exynos5, the fimc-capture IP is removed and instead a more 
powerful fimc-is takes the role of giving scaled image output via DMA.
FIMC-IS internally has two scalers for this in addition to other
post-processing components like dynamic range compression,
optical distortion correction, digital image stabilization, 3D noise reduction
and face detection.

FIMC-IS also has capability to directly control certain sensors and the
sensors compatible with the fimc-is will be termed as fimc-is sensors.
This patchset adds support for two such fimc-is sensors - s5k4e5 and s5k6a3.
These sensors are controlled exclusively by the fimc-is firmware.
They provide only SRGB unscaled output which will reach fimc-is
via mipi-csis and fimc-lite. The color space conversion, scaling and all other
post processing will be then done by the fimc-is IP components.

The fimc-is driver operates in the following manner:
The sensor subdevice created by this driver will be used by the exynos5
media-device's pipeline0 which connects it with mipi-csis and fimc-lite.

|fimc-is-sensor|--->|mipi-csis|--->|fimc-lite|--->|Memory|

The output bayer image dumped by the fimc-lite subdev into memory is fed
into the ISP subdev of fimc-is driver. For that the pipeline1 of exynos5
media-device will look like this:

|Memory|--->|fimc-is-isp|--->|fimc-is-scaler-codec|--->|fimc-is-scaler-preview|

The isp subdev accepts bayer input buffer at its OUTPUT_MPLANE. It will
do a set of post processing operations and passes it on-the-fly to the
scalers. The two scalers can give two different scaled outputs which can
be used for recording and preview simultaneously. Both scaler-codec and
scaler-preview dumps DMA data out through its CAPTURE_MPLANE.

This first RFC contains the basic version of the driver which accepts
bayer input data and provides 2 different scaled outputs with most of
the post processing blocks disabled.

This has to be applied on exynos5 media device patchset posted by
Shaik Ameer Basha [1] and its based on media-tree v3.9.

[1] http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg16191.html

Arun Kumar K (12):
  exynos-fimc-is: Adding device tree nodes
  exynos-fimc-is: Adding ARCH support for fimc-is
  exynos-fimc-is: Adds fimc-is driver core files
  exynos-fimc-is: Adds common driver header files
  exynos-fimc-is: Adds the register definition and context header
  exynos-fimc-is: Adds the sensor subdev
  exynos-fimc-is: Adds isp subdev
  exynos-fimc-is: Adds scaler subdev
  exynos-fimc-is: Adds the hardware pipeline control
  exynos-fimc-is: Adds the hardware interface module
  exynos-fimc-is: Adds the Kconfig and Makefile
  mipi-csis: Enable all interrupts for fimc-is usage

 .../devicetree/bindings/media/soc/exynos5-is.txt   |   81 +
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi          |   60 +
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   54 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |    8 +
 arch/arm/mach-exynos/clock-exynos5.c               |  129 ++
 arch/arm/mach-exynos/include/mach/map.h            |    2 +
 arch/arm/mach-exynos/include/mach/regs-clock.h     |    7 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    2 +
 drivers/media/platform/exynos5-is/Kconfig          |   12 +
 drivers/media/platform/exynos5-is/Makefile         |    3 +
 drivers/media/platform/exynos5-is/fimc-is-cmd.h    |  211 ++
 drivers/media/platform/exynos5-is/fimc-is-core.c   |  421 ++++
 drivers/media/platform/exynos5-is/fimc-is-core.h   |  140 ++
 drivers/media/platform/exynos5-is/fimc-is-err.h    |  258 +++
 .../media/platform/exynos5-is/fimc-is-interface.c  | 1003 +++++++++
 .../media/platform/exynos5-is/fimc-is-interface.h  |  130 ++
 drivers/media/platform/exynos5-is/fimc-is-isp.c    |  546 +++++
 drivers/media/platform/exynos5-is/fimc-is-isp.h    |   88 +
 .../media/platform/exynos5-is/fimc-is-metadata.h   |  771 +++++++
 drivers/media/platform/exynos5-is/fimc-is-param.h  | 2163 ++++++++++++++++++++
 .../media/platform/exynos5-is/fimc-is-pipeline.c   | 1961 ++++++++++++++++++
 .../media/platform/exynos5-is/fimc-is-pipeline.h   |  129 ++
 drivers/media/platform/exynos5-is/fimc-is-regs.h   |  352 ++++
 drivers/media/platform/exynos5-is/fimc-is-scaler.c |  595 ++++++
 drivers/media/platform/exynos5-is/fimc-is-scaler.h |  107 +
 drivers/media/platform/exynos5-is/fimc-is-sensor.c |  337 +++
 drivers/media/platform/exynos5-is/fimc-is-sensor.h |  170 ++
 drivers/media/platform/exynos5-is/fimc-is.h        |  151 ++
 drivers/media/platform/s5p-fimc/mipi-csis.c        |    2 +-
 29 files changed, 9890 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/soc/exynos5-is.txt
 mode change 100644 => 100755 arch/arm/boot/dts/exynos5250-smdk5250.dts
 mode change 100644 => 100755 arch/arm/boot/dts/exynos5250.dtsi
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

