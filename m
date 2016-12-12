Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:57079 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752188AbcLLPzY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 10:55:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>
Subject: [PATCH 00/15] atmel-isi/ov7670/ov2640: convert to standalone drivers
Date: Mon, 12 Dec 2016 16:55:05 +0100
Message-Id: <20161212155520.41375-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series converts the soc-camera atmel-isi to a standalone V4L2
driver.

The same is done for the ov7670 and ov2640 sensor drivers: the ov7670 was
used to test the atmel-isi driver. The ov2640 is needed because the em28xx
driver has a soc_camera include dependency. Both ov7670 and ov2640 sensors
have been tested with the atmel-isi driver.

The first 6 patches improve the ov7670 sensor driver, mostly adding modern
features such as MC and DT support.

The next three convert the atmel-isi and move it out of soc_camera.

The following 3 patches convert ov2640 and drop the soc_camera dependency
in em28xx (untested!). I'll ask Frank Schaefer who authored this if he
can test this em28xx code.

The last two patches add isi support to the DT: the first for the ov7670
sensor, the second modifies it for the ov2640 sensor.

These two final patches are for demonstration purposes only, I do not plan
on merging them.

Tested with my sama5d3-Xplained board, the ov2640 sensor and two ov7670
sensors: one with and one without reset/pwdn pins.

I believe I have addressed all comments made by Laurent and Sakari for my
original RFC patch series.

Regards,

	Hans

Hans Verkuil (15):
  ov7670: add media controller support
  ov7670: call v4l2_async_register_subdev
  ov7670: fix g/s_parm
  ov7670: get xclk
  ov7670: add devicetree support
  ov7670: document device tree bindings
  atmel-isi: remove dependency of the soc-camera framework
  atmel-isi: move out of soc_camera to atmel
  atmel-isi: document device tree bindings
  ov2640: convert from soc-camera to a standard subdev sensor driver.
  ov2640: enable clock, fix power/reset and add MC support
  ov2640 bindings update
  em28xx: drop last soc_camera link
  sama5d3 dts: enable atmel-isi
  at91-sama5d3_xplained.dts: select ov2640

 .../devicetree/bindings/media/atmel-isi.txt        |   91 +-
 .../devicetree/bindings/media/i2c/ov2640.txt       |   22 +-
 .../devicetree/bindings/media/i2c/ov7670.txt       |   44 +
 MAINTAINERS                                        |    1 +
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |   61 +-
 arch/arm/boot/dts/sama5d3.dtsi                     |    4 +-
 drivers/media/i2c/Kconfig                          |   11 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/{soc_camera => }/ov2640.c        |  182 +--
 drivers/media/i2c/ov7670.c                         |   98 +-
 drivers/media/i2c/soc_camera/Kconfig               |    6 -
 drivers/media/i2c/soc_camera/Makefile              |    1 -
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/atmel/Kconfig               |   11 +-
 drivers/media/platform/atmel/Makefile              |    1 +
 drivers/media/platform/atmel/atmel-isi.c           | 1413 ++++++++++++++++++++
 .../platform/{soc_camera => atmel}/atmel-isi.h     |    0
 drivers/media/platform/soc_camera/Kconfig          |   11 -
 drivers/media/platform/soc_camera/Makefile         |    1 -
 drivers/media/platform/soc_camera/atmel-isi.c      | 1167 ----------------
 drivers/media/usb/em28xx/em28xx-camera.c           |    9 -
 21 files changed, 1751 insertions(+), 1385 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7670.txt
 rename drivers/media/i2c/{soc_camera => }/ov2640.c (90%)
 create mode 100644 drivers/media/platform/atmel/atmel-isi.c
 rename drivers/media/platform/{soc_camera => atmel}/atmel-isi.h (100%)
 delete mode 100644 drivers/media/platform/soc_camera/atmel-isi.c

-- 
2.10.2

