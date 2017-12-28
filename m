Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:50744 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbdL1OBg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 09:01:36 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] Renesas Capture Engine Unit (CEU) V4L2 driver
Date: Thu, 28 Dec 2017 15:01:12 +0100
Message-Id: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
  second round for Renesas CEU driver.

I have closed review comments received on v1 and tested again on RZ and SH4
platforms to capture images in all available output formats (NV16/61, NV12/21
and YUYV).

The patch is now based on v4.15-rc4, with a few patches on top to help testing
on Migo-R and GR-Peach platforms. A base tag is available at:
git://jmondi.org/linux tag:v4.15-rc4-ceu-v2-base for the interested ones.

As per v1, this patch series aims to add a modern CEU driver to replace the
soc_camera-based sh_mobile_ceu_camera one, and port a first test platform
(Migo-R) to use the new driver. Other SH4 based boards are currently using the
old ceu driver in mainline, once this patch gets in we can port those
platforms to use the new driver and start removing soc_camera completely.

As per v1, I have not removed any soc_camera-based code in this series and I
won't until we haven't ported all platforms to use the new driver.

Quite a long change log:

v1->v2
 - DT
 -- Addressed Geert's comments and added clocks for CEU to mstp6 clock source
 -- Specified supported generic video iterfaces properties in dt-bindings and
    simplified example

 - CEU driver
 -- Re-worked interrupt handler, interrupt management, reset(*) and capture
    start operation
 -- Re-worked querycap/enum_input/enum_frameintervals to fix some
    v4l2_compliance failures
 -- Removed soc_camera legacy operations g/s_mbus_format
 -- Update to new notifier implementation
 -- Fixed several comments from Hans, Laurent and Sakari

 - Migo-R
 -- Register clocks and gpios for sensor drivers in Migo-R setup
 -- Updated sensors (tw9910 and ov772x) drivers headers and drivers to close
    remarks from Hans and Laurent:
 --- Removed platform callbacks and handle clocks and gpios from sensor drivers
 --- Remove g/s_mbus_config operations

Thanks
   j

[*]: Laurent, I still haven't measured reset latencies during capture operations
     so I'm still giving reset function a hundred cycles as upper limit, even if
     I have made sure a single loop is enough during normal operations to
     reset the interface properly.

Jacopo Mondi (9):
  dt-bindings: media: Add Renesas CEU bindings
  include: media: Add Renesas CEU driver interface
  v4l: platform: Add Renesas CEU driver
  ARM: dts: r7s72100: Add Capture Engine Unit (CEU)
  arch: sh: migor: Use new renesas-ceu camera driver
  v4l: i2c: Copy ov772x soc_camera sensor driver
  media: i2c: ov772x: Remove soc_camera dependencies
  v4l: i2c: Copy tw9910 soc_camera sensor driver
  media: i2c: tw9910: Remove soc_camera dependencies

 .../devicetree/bindings/media/renesas,ceu.txt      |   85 +
 arch/arm/boot/dts/r7s72100.dtsi                    |   15 +-
 arch/sh/boards/mach-migor/setup.c                  |  213 ++-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c             |    2 +-
 drivers/media/i2c/Kconfig                          |   20 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/ov772x.c                         | 1179 ++++++++++++++
 drivers/media/i2c/tw9910.c                         | 1035 ++++++++++++
 drivers/media/platform/Kconfig                     |    9 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/renesas-ceu.c               | 1661 ++++++++++++++++++++
 include/media/drv-intf/renesas-ceu.h               |   20 +
 include/media/i2c/ov772x.h                         |    8 +-
 include/media/i2c/tw9910.h                         |    9 +
 14 files changed, 4128 insertions(+), 131 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt
 create mode 100644 drivers/media/i2c/ov772x.c
 create mode 100644 drivers/media/i2c/tw9910.c
 create mode 100644 drivers/media/platform/renesas-ceu.c
 create mode 100644 include/media/drv-intf/renesas-ceu.h

--
2.7.4
