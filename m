Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:55266 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752179AbdIVWVY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 18:21:24 -0400
Received: by mail-pg0-f50.google.com with SMTP id c137so1269332pga.11
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 15:21:24 -0700 (PDT)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 0/4] RFC: TDA1997x HDMI video receiver
Date: Fri, 22 Sep 2017 15:24:09 -0700
Message-Id: <1506119053-21828-1-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an RFC for a driver supporting the TDA1997x HDMI video receiver.

I've tested this on a Gateworks GW54xx with an IMX6Q which uses the TDA19971
with 16bits connected to the IMX6 CSI. For this configuration I've tested
both 16bit YUV422 and 8bit BT656 mode. While the driver should support the
TDA1993 I do not have one for testing.

Further potential development efforts include:
 - AUDIO codec support (working on this next)
 - EDID read/write support
 - CEC support
 - HDCP support
 - mbus format selection support for bus widths that support multiple formats
 - TDA19972 support (2 inputs)

Tim Harvey (4):
  MAINTAINERS: add entry for NXP TDA1997x driver
  media: dt-bindings: Add bindings for TDA1997X
  media: i2c: Add TDA1997x HDMI receiver driver
  ARM: DTS: imx: ventana: add TDA19971 HDMI Receiver to GW54xx

 .../devicetree/bindings/media/i2c/tda1997x.txt     |  159 +
 MAINTAINERS                                        |    8 +
 arch/arm/boot/dts/imx6q-gw54xx.dts                 |   85 +
 drivers/media/i2c/Kconfig                          |    9 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/tda1997x.c                       | 3065 ++++++++++++++++++++
 include/dt-bindings/media/tda1997x.h               |   78 +
 include/media/i2c/tda1997x.h                       |   53 +
 8 files changed, 3458 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tda1997x.txt
 create mode 100644 drivers/media/i2c/tda1997x.c
 create mode 100644 include/dt-bindings/media/tda1997x.h
 create mode 100644 include/media/i2c/tda1997x.h

-- 
2.7.4
