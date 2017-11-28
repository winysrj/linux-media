Return-path: <linux-media-owner@vger.kernel.org>
Received: from f5out.microchip.com ([198.175.253.81]:29155 "EHLO
        DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750839AbdK1F2F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 00:28:05 -0500
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
Subject: [PATCH v5 0/2] media: ov7740: Add a V4L2 sensor-level driver
Date: Tue, 28 Nov 2017 13:22:57 +0800
Message-ID: <20171128052259.4957-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a Video4Linux2 sensor-level driver for the OmniVision OV7740
VGA camera image sensor.

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
 drivers/media/i2c/ov7740.c                         | 1220 ++++++++++++++++++++
 5 files changed, 1284 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7740.txt
 create mode 100644 drivers/media/i2c/ov7740.c

-- 
2.15.0
