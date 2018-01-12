Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:52361 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933582AbeALOEa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 09:04:30 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/9] Renesas Capture Engine Unit (CEU) V4L2 driver
Date: Fri, 12 Jan 2018 15:04:00 +0100
Message-Id: <1515765849-10345-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   (hopefully) last round for CEU driver.

Changelog is quite thin, I have updated CEU driver MODULE_LICENSE to match
SPDX identifier, added Rob's and Laurent's Reviewed-by tags to bindings, and
made variables of "struct ceu_data" type static in the driver.

All of the patches are now Reviewed/Acked. Time to have this series included?

Thanks
   j

v4->v5:
- Added Rob's and Laurent's Reviewed-by tag to DT bindings
- Change CEU driver module license to "GPL v2" to match SPDX identifier as
  suggested by Philippe Ombredanne
- Make struct ceu_data static as suggested by Laurent and add his
  Reviewed-by to CEU driver.

v3->v4:
- Drop generic fallback compatible string "renesas,ceu"
- Addressed Laurent's comments on [3/9]
  - Fix error messages on irq get/request
  - Do not leak ceudev if irq_get fails
  - Make irq_mask a const field

v2->v3:
- Improved DT bindings removing standard properties (pinctrl- ones and
  remote-endpoint) not specific to this driver and improved description of
  compatible strings
- Remove ov772x's xlkc_rate property and set clock rate in Migo-R board file
- Made 'xclk' clock private to ov772x driver in Migo-R board file
- Change 'rstb' GPIO active output level and changed ov772x and tw9910 drivers
  accordingly as suggested by Fabio
- Minor changes in CEU driver to address Laurent's comments
- Moved Migo-R setup patch to the end of the series to silence 0-day bot
- Renamed tw9910 clock to 'xti' as per video decoder manual
- Changed all SPDX identifiers to GPL-2.0 from previous GPL-2.0+

v1->v2:
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

Jacopo Mondi (9):
  dt-bindings: media: Add Renesas CEU bindings
  include: media: Add Renesas CEU driver interface
  v4l: platform: Add Renesas CEU driver
  ARM: dts: r7s72100: Add Capture Engine Unit (CEU)
  v4l: i2c: Copy ov772x soc_camera sensor driver
  media: i2c: ov772x: Remove soc_camera dependencies
  v4l: i2c: Copy tw9910 soc_camera sensor driver
  media: i2c: tw9910: Remove soc_camera dependencies
  arch: sh: migor: Use new renesas-ceu camera driver

 .../devicetree/bindings/media/renesas,ceu.txt      |   81 +
 arch/arm/boot/dts/r7s72100.dtsi                    |   15 +-
 arch/sh/boards/mach-migor/setup.c                  |  225 ++-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c             |    2 +-
 drivers/media/i2c/Kconfig                          |   20 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/ov772x.c                         | 1181 ++++++++++++++
 drivers/media/i2c/tw9910.c                         | 1039 ++++++++++++
 drivers/media/platform/Kconfig                     |    9 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/renesas-ceu.c               | 1648 ++++++++++++++++++++
 include/media/drv-intf/renesas-ceu.h               |   26 +
 include/media/i2c/ov772x.h                         |    6 +-
 include/media/i2c/tw9910.h                         |    9 +
 14 files changed, 4133 insertions(+), 131 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt
 create mode 100644 drivers/media/i2c/ov772x.c
 create mode 100644 drivers/media/i2c/tw9910.c
 create mode 100644 drivers/media/platform/renesas-ceu.c
 create mode 100644 include/media/drv-intf/renesas-ceu.h

--
2.7.4
