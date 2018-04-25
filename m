Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:53208 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755348AbeDYQVJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 12:21:09 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hverkuil@xs4all.nl, sakari.ailus@iki.fi,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 0/2] Add support for ov7251 camera sensor
Date: Wed, 25 Apr 2018 19:20:44 +0300
Message-Id: <1524673246-14175-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov7251 sensor is a 1/7.5-Inch B&W VGA (640x480) CMOS Digital Image
Sensor from Omnivision.

--------------------------------------------------------------------------

Version 4:
- remove OF dependency;
- use only stack memory in ov7251_write_seq_regs();
- use DIV_ROUND_UP to round up sleep interval after gpio config;
- minor style changes.

--------------------------------------------------------------------------

Version 3:
- DT binding: added that there shall be a single endpoint node in the port node;
- added a comment for regulator enable order;
- set exposure and gain with a single i2c transaction;
- caclulate sleep after gpio config from external clock frequency;
- use MEDIA_BUS_FMT_Y10_1X10 format code;
- lock for power state, controls, mode and start streaming;
- remove regulator_set_voltage();
- use probe_new();
- remove i2c_device_id table;
- change of_property_read_u32 to fwnode_property_read_u32;
- few corrections from checkpatch --strict.

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

 .../devicetree/bindings/media/i2c/ov7251.txt       |   52 +
 drivers/media/i2c/Kconfig                          |   12 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov7251.c                         | 1503 ++++++++++++++++++++
 4 files changed, 1568 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7251.txt
 create mode 100644 drivers/media/i2c/ov7251.c

-- 
2.7.4
