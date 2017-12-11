Return-path: <linux-media-owner@vger.kernel.org>
Received: from f5out.microchip.com ([198.175.253.81]:50547 "EHLO
        DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751659AbdLKBhc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Dec 2017 20:37:32 -0500
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        <devicetree@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-arm-kernel@lists.infradead.org>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v9 0/2] media: ov7740: Add a V4L2 sensor-level driver
Date: Mon, 11 Dec 2017 09:31:44 +0800
Message-ID: <20171211013146.2497-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a Video4Linux2 sensor-level driver for the OmniVision OV7740
VGA camera image sensor.

Changes in v9:
 - Use the new SPDX ids.

Changes in v8:
 - As the registers are written at stream start, remove the written
   code from the set fmt function.

Changes in v7:
 - Add Acked-by tag.
 - Fix the wrong handle of default register configuration.
 - Add the missed assignment of ov7740->frmsize.

Changes in v6:
 - Remove unnecessary #include <linux/init>.
 - Remove unnecessary comments and extra newline.
 - Add const for some structures.
 - Add the check of the return value from regmap_write().
 - Simplify the calling of __v4l2_ctrl_handler_setup().
 - Add the default format initialization function.
 - Integrate the set_power() and enable/disable the clock into
   one function.

Changes in v5:
 - Squash the driver and MAINTAINERS entry patches to one.
 - Precede the driver patch with the bindings patch.

Changes in v4:
 - Assign 'val' a initial value to avoid warning: 'val' may be
   used uninitialized.
 - Rename REG_REG15 to avoid warning: "REG_REG15" redefined.

Changes in v3:
 - Explicitly document the "remote-endpoint" property.
 - Put the MAINTAINERS change to a separate patch.

Changes in v2:
 - Split off the bindings into a separate patch.
 - Add a new entry to the MAINTAINERS file.

Wenyou Yang (2):
  media: ov7740: Document device tree bindings
  media: i2c: Add the ov7740 image sensor driver

 .../devicetree/bindings/media/i2c/ov7740.txt       |   47 +
 MAINTAINERS                                        |    8 +
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov7740.c                         | 1216 ++++++++++++++++++++
 5 files changed, 1280 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7740.txt
 create mode 100644 drivers/media/i2c/ov7740.c

-- 
2.15.0
