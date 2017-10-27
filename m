Return-path: <linux-media-owner@vger.kernel.org>
Received: from f5out.microchip.com ([198.175.253.81]:54456 "EHLO
        DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751170AbdJ0Hpx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 03:45:53 -0400
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
Subject: [PATCH v2 0/2] media: ov7740: Add a V4L2 sensor-level driver
Date: Fri, 27 Oct 2017 15:42:18 +0800
Message-ID: <20171027074220.23839-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a Video4Linux2 sensor-level driver for the OmniVision OV7740
VGA camera image sensor.

Changes in v2:
 - Split off the bindings into a separate patch.
 - Add a new entry to the MAINTAINERS file.

Wenyou Yang (2):
  media: i2c: Add the ov7740 image sensor driver
  media: ov7740: Document device tree bindings

 .../devicetree/bindings/media/i2c/ov7740.txt       |   43 +
 MAINTAINERS                                        |    8 +
 drivers/media/i2c/Kconfig                          |    8 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov7740.c                         | 1220 ++++++++++++++++++++
 5 files changed, 1280 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7740.txt
 create mode 100644 drivers/media/i2c/ov7740.c

-- 
2.13.0
