Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:36946 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935371AbdCJK0T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 05:26:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org
Subject: [PATCHv4 00/15] atmel-isi/ov7670/ov2640: convert to standalone drivers
Date: Fri, 10 Mar 2017 11:25:59 +0100
Message-Id: <20170310102614.20922-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series converts the soc-camera atmel-isi to a standalone V4L2
driver.

The same is done for the ov7670 and ov2640 sensor drivers: the ov7670 was
used to test the atmel-isi driver. The ov2640 is needed because the em28xx
driver has a soc_camera include dependency. Both ov7670 and ov2640 sensors
have been tested with the atmel-isi driver.

The first 5 patches improve the ov7670 sensor driver, mostly adding modern
features such as DT support.

The next three convert the atmel-isi and move it out of soc_camera.

The following 5 patches convert ov2640 and drop the soc_camera dependency
in em28xx. I have tested that this works with my 'SpeedLink Vicious And
Divine Laplace webcam'.

The last two patches add isi support to the DT: the first for the ov7670
sensor, the second modifies it for the ov2640 sensor.

These two final patches are for demonstration purposes only, I do not plan
on merging them.

Tested with my sama5d3-Xplained board, the ov2640 sensor and two ov7670
sensors: one with and one without reset/pwdn pins. Also tested with my
em28xx-based webcam.

I'd like to get this in for 4.12. Fingers crossed.

Regards,

	Hans

Changes since v3:
- ov2640/ov7670: call clk_disable_unprepare where needed. I assumed this was
  done by the devm_clk_get cleanup, but that wasn't the case.
- bindings: be even more explicit about which properties are mandatory.
- ov2640/ov7670: drop unused bus-width from the dts binding examples and from
  the actual dts patches.

Changes since v2:
- Incorporated Sakari's and Rob's device tree bindings comments.
- ov2640: dropped the reset/power changes. These actually broke the em28xx
  and there was really nothing wrong with it.
- merged the "ov2640: allow use inside em28xx" into patches 10 and 11.
  It really shouldn't have been a separate patch in the first place.
- rebased on top of 4.11-rc1.

Changes since v1:

- Dropped MC support from atmel-isi and ov7670: not needed to make this
  work. Only for the ov2640 was it kept since the em28xx driver requires it.
- Use devm_clk_get instead of clk_get.
- The ov7670 lower limit of the clock speed is 10 MHz instead of 12. Adjust
  accordingly.

Hans Verkuil (15):
  ov7670: document device tree bindings
  ov7670: call v4l2_async_register_subdev
  ov7670: fix g/s_parm
  ov7670: get xclk
  ov7670: add devicetree support
  atmel-isi: document device tree bindings
  atmel-isi: remove dependency of the soc-camera framework
  atmel-isi: move out of soc_camera to atmel
  ov2640: update bindings
  ov2640: convert from soc-camera to a standard subdev sensor driver.
  ov2640: use standard clk and enable it.
  ov2640: add MC support
  em28xx: drop last soc_camera link
  sama5d3 dts: enable atmel-isi
  at91-sama5d3_xplained.dts: select ov2640

 .../devicetree/bindings/media/atmel-isi.txt        |   96 +-
 .../devicetree/bindings/media/i2c/ov2640.txt       |   23 +-
 .../devicetree/bindings/media/i2c/ov7670.txt       |   43 +
 MAINTAINERS                                        |    1 +
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |   59 +-
 arch/arm/boot/dts/sama5d3.dtsi                     |    4 +-
 drivers/media/i2c/Kconfig                          |   11 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/{soc_camera => }/ov2640.c        |  152 +--
 drivers/media/i2c/ov7670.c                         |   75 +-
 drivers/media/i2c/soc_camera/Kconfig               |    6 -
 drivers/media/i2c/soc_camera/Makefile              |    1 -
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/atmel/Kconfig               |   11 +-
 drivers/media/platform/atmel/Makefile              |    1 +
 drivers/media/platform/atmel/atmel-isi.c           | 1398 ++++++++++++++++++++
 .../platform/{soc_camera => atmel}/atmel-isi.h     |    0
 drivers/media/platform/soc_camera/Kconfig          |   11 -
 drivers/media/platform/soc_camera/Makefile         |    1 -
 drivers/media/platform/soc_camera/atmel-isi.c      | 1167 ----------------
 drivers/media/usb/em28xx/em28xx-camera.c           |    9 -
 21 files changed, 1704 insertions(+), 1367 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7670.txt
 rename drivers/media/i2c/{soc_camera => }/ov2640.c (92%)
 create mode 100644 drivers/media/platform/atmel/atmel-isi.c
 rename drivers/media/platform/{soc_camera => atmel}/atmel-isi.h (100%)
 delete mode 100644 drivers/media/platform/soc_camera/atmel-isi.c

-- 
2.11.0
