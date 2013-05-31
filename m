Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:52876 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab3EaMkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 08:40:22 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MNN0025NXV8B9K0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 21:40:20 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, kilyeon.im@samsung.com,
	shaik.ameer@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC v2 00/10] Exynos5 FIMC-IS driver
Date: Fri, 31 May 2013 18:33:18 +0530
Message-id: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes from v1
---------------
- Addressed all review comments from Sylwester
- Made sensor subdevs as independent i2c devices
- Lots of cleanup
- Debugfs support added
- Removed PMU global register access

Description
-----------
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

FIMC-IS firmware can directly control certain sensors and the
sensors compatible with the fimc-is will be termed as fimc-is sensors.
This patchset adds support for two such fimc-is sensors - s5k4e5 and s5k6a3.
These sensors are controlled exclusively by the fimc-is firmware at present.
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

This patchset adds basic version of the driver which accepts
bayer input data and provides 2 different scaled outputs with most of
the post processing blocks disabled.


Arun Kumar K (10):
  exynos5-fimc-is: Add Exynos5 FIMC-IS device tree bindings
    documentation
  exynos5-fimc-is: Adds fimc-is driver core files
  exynos5-fimc-is: Adds common driver header files
  exynos5-fimc-is: Adds the register definition and context header
  exynos5-fimc-is: Adds the sensor subdev
  exynos5-fimc-is: Adds isp subdev
  exynos5-fimc-is: Adds scaler subdev
  exynos5-fimc-is: Adds the hardware pipeline control
  exynos5-fimc-is: Adds the hardware interface module
  exynos5-fimc-is: Adds the Kconfig and Makefile

 .../devicetree/bindings/media/exynos5-fimc-is.txt  |   41 +
 drivers/media/platform/exynos5-is/Kconfig          |   12 +
 drivers/media/platform/exynos5-is/Makefile         |    3 +
 drivers/media/platform/exynos5-is/fimc-is-cmd.h    |  201 ++
 drivers/media/platform/exynos5-is/fimc-is-core.c   |  304 +++
 drivers/media/platform/exynos5-is/fimc-is-core.h   |  126 ++
 drivers/media/platform/exynos5-is/fimc-is-err.h    |  261 +++
 .../media/platform/exynos5-is/fimc-is-interface.c  | 1025 ++++++++++
 .../media/platform/exynos5-is/fimc-is-interface.h  |  131 ++
 drivers/media/platform/exynos5-is/fimc-is-isp.c    |  438 +++++
 drivers/media/platform/exynos5-is/fimc-is-isp.h    |   89 +
 .../media/platform/exynos5-is/fimc-is-metadata.h   |  771 ++++++++
 drivers/media/platform/exynos5-is/fimc-is-param.h  | 1259 +++++++++++++
 .../media/platform/exynos5-is/fimc-is-pipeline.c   | 1959 ++++++++++++++++++++
 .../media/platform/exynos5-is/fimc-is-pipeline.h   |  129 ++
 drivers/media/platform/exynos5-is/fimc-is-regs.h   |  107 ++
 drivers/media/platform/exynos5-is/fimc-is-scaler.c |  492 +++++
 drivers/media/platform/exynos5-is/fimc-is-scaler.h |  107 ++
 drivers/media/platform/exynos5-is/fimc-is-sensor.c |  463 +++++
 drivers/media/platform/exynos5-is/fimc-is-sensor.h |  168 ++
 drivers/media/platform/exynos5-is/fimc-is.h        |  151 ++
 21 files changed, 8237 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
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

