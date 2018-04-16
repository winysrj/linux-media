Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:44399 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbeDPCwN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Apr 2018 22:52:13 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v2 00/10] media: ov772x: support media controller, device tree probing, etc.
Date: Mon, 16 Apr 2018 11:51:41 +0900
Message-Id: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset includes support media controller, device tree probing and
other miscellanuous changes for ov772x driver.

* v2 (thanks to Jacopo Mondi)
- Replace the implementation of ov772x_read() instead of adding an
  alternative method
- Assign the ov772x_read() return value to pid and ver directly
- Do the same for MIDH and MIDL
- Move video_probe() before the entity initialization and remove the #ifdef
  around the media_entity_cleanup()
- Use generic names for reset and powerdown gpios (New)
- Add "dt-bindings:" in the subject
- Add a brief description of the sensor
- Update the GPIO names
- Indicate the GPIO active level
- Add missing NULL checks for priv->info
- Leave the check for the missing platform data if legacy platform data
  probe is used.
- Handle nested s_power() calls (New)
- Reconstruct s_frame_interval() (New)
- Avoid accessing registers under power saving mode (New)

Akinobu Mita (10):
  media: ov772x: allow i2c controllers without
    I2C_FUNC_PROTOCOL_MANGLING
  media: ov772x: add checks for register read errors
  media: ov772x: create subdevice device node
  media: ov772x: add media controller support
  media: ov772x: use generic names for reset and powerdown gpios
  media: dt-bindings: ov772x: add device tree binding
  media: ov772x: support device tree probing
  media: ov772x: handle nested s_power() calls
  media: ov772x: reconstruct s_frame_interval()
  media: ov772x: avoid accessing registers under power saving mode

 .../devicetree/bindings/media/i2c/ov772x.txt       |  42 ++++
 MAINTAINERS                                        |   1 +
 arch/sh/boards/mach-migor/setup.c                  |   5 +-
 drivers/media/i2c/ov772x.c                         | 275 ++++++++++++++++-----
 4 files changed, 255 insertions(+), 68 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov772x.txt

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Rob Herring <robh+dt@kernel.org>
-- 
2.7.4
