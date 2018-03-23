Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:37782 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751175AbeCWEOi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 00:14:38 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v2 0/2] Add support for ov7251 camera sensor
Date: Fri, 23 Mar 2018 12:14:18 +0800
Message-Id: <1521778460-8717-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov7251 sensor is a 1/7.5-Inch B&W VGA (640x480) CMOS Digital Image
Sensor from Omnivision.

--------------------------------------------------------------------------

Version 2:
- changed ov7251 node's name in DT binding example;
- SPDX licence identifier;
- better names for register value defines;
- remove power reference counting and leave a power state only;
- use v4l2_find_nearest_size() to find sensor mode by requested size;
- set ycbcr_enc, quantization and xfer_func in set_fmt;
- use struct fwnode_handle instead of struct device_node;
- add comment in driver about external clock value.

--------------------------------------------------------------------------

Todor Tomov (2):
  dt-bindings: media: Binding document for OV7251 camera sensor
  media: Add a driver for the ov7251 camera sensor

 .../devicetree/bindings/media/i2c/ov7251.txt       |   51 +
 drivers/media/i2c/Kconfig                          |   13 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov7251.c                         | 1494 ++++++++++++++++++++
 4 files changed, 1559 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7251.txt
 create mode 100644 drivers/media/i2c/ov7251.c

-- 
2.7.4
