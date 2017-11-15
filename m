Return-path: <linux-media-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:36997 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757762AbdKOLPB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 06:15:01 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 00/10] Renesas Capture Engine Unit (CEU) V4L2 driver
Date: Wed, 15 Nov 2017 11:55:53 +0100
Message-Id: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   this series implementes a modern V4L2 driver for Renesas Capture Engine
Unit (CEU). CEU is currently supported by the soc_camera based driver
drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c

The driver supports capturing images in planar formats (NV12/21 and NV16/61)
and non-planar YUYV422 format.

It had been tested with OV7670/OV7725 images sensor capturing images at
different resolutions (VGA and QVGA)

The series:
- Adds a new driver under drivers/media/platform/renesas-ceu.c and a new driver
  interface under include/media/drv-intf/renesas-ceu.h
- Adds device tree bindings for renesas-ceu
- Adds CEU to Renesas RZ/A1 dtsi
- Ports Migo-R SH4 based platform to make use of the new driver
- Ports image sensor drivers used by Migo-R (ov772x and tw9910) away from
  soc_camera

While this driver aims to replace the existing one, which is the last platform
driver making use of soc_camera framework, this series does not delete any of
the existing code, just because there are other SH4 users of the existing
soc_camera based driver: (mach-ap325rxa, mach-ecovec24, mach-kfr2r09 and
mach-se/7724)

As I only have access to Migo-R board, I have ported that one first, while all
other boards can be compile-ported later, once this new driver will eventually
be accepted mainline.

This series is based on v4.14-rc8 with a few patches applied on top:
https://www.spinics.net/lists/linux-sh/msg51739.html

These patches are required for mainline Migo-R board and sh_mobile_ceu_camera
driver to work properly with SH4 architecture on modern kernels, and I have
based my series on top of them.

A tag with those patches already applied on top of v4.14-rc8 is available at
git://jmondi.org/linux v4.14-rc8-migor-ceu-base

A note on testing:
The CEU IP block is found on both Renesas RZ series devices (single core ARM
platforms) and on older SH4 devices (such as Migo-R).
I have developed and tested the driver on RZ platforms, specifically on
GR-Peach with an OV7670 based camera module. More details on:
https://elinux.org/RZ-A/Boards/GR-PEACH-audiocamerashield

As we aim to replace the soc_camera based driver, I have also tested the
new one on Migo-R, capturing images from the OV7725 sensor installed on
that board (I've not been able to test TW9910 video decoder as the sensor does
not probe on the platform I have access to).
Hans, as you told me, you have a Migo-R and if you eventually would like to
give this series a spin on that platform feel free to ping me, as to run a
modern mainline kernel on SH4 you may need the above mentioned patches and some
attention to configuration option for SH4.

A note on sensor drivers:
As I need ov772x and tw9910 driver to be ported away from soc_camera for testing
on Migo-R, for each of them I have copied the driver first in
drivers/media/i2c/ from drivers/media/i2c/soc_camera without any modification
and then removed soc_camera dependencies in a separate commit to ease review.
As per the soc_camera based CEU platform driver, I have not removed the original
soc_camera based sensor drivers in this series.

Output of v4l2-compliance is available at:
https://paste.debian.net/995838/
I'm slightly confused about what the test application complains for
TRY_FMT/S_FMT but I judged this good enough for a first submission.

Thanks
  j

Jacopo Mondi (10):
  dt-bindings: media: Add Renesas CEU bindings
  include: media: Add Renesas CEU driver interface
  v4l: platform: Add Renesas CEU driver
  ARM: dts: r7s72100: Add Capture Engine Unit (CEU)
  arch: sh: migor: Use new renesas-ceu camera driver
  sh: sh7722: Rename CEU clock
  v4l: i2c: Copy ov772x soc_camera sensor driver
  media: i2c: ov772x: Remove soc_camera dependencies
  v4l: i2c: Copy tw9910 soc_camera sensor driver
  media: i2c: tw9910: Remove soc_camera dependencies

 .../devicetree/bindings/media/renesas,ceu.txt      |   87 +
 arch/arm/boot/dts/r7s72100.dtsi                    |   12 +-
 arch/sh/boards/mach-migor/setup.c                  |  164 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c             |    2 +-
 drivers/media/i2c/Kconfig                          |   21 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/ov772x.c                         | 1156 +++++++++++++
 drivers/media/i2c/tw9910.c                         | 1037 ++++++++++++
 drivers/media/platform/Kconfig                     |    9 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/renesas-ceu.c               | 1766 ++++++++++++++++++++
 include/media/drv-intf/renesas-ceu.h               |   23 +
 include/media/i2c/ov772x.h                         |    3 +
 include/media/i2c/tw9910.h                         |    6 +
 14 files changed, 4199 insertions(+), 91 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt
 create mode 100644 drivers/media/i2c/ov772x.c
 create mode 100644 drivers/media/i2c/tw9910.c
 create mode 100644 drivers/media/platform/renesas-ceu.c
 create mode 100644 include/media/drv-intf/renesas-ceu.h

--
2.7.4
