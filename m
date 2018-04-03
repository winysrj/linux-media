Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36311 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbeDCO3f (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 10:29:35 -0400
Received: by mail-wm0-f65.google.com with SMTP id x82so35627478wmg.1
        for <linux-media@vger.kernel.org>; Tue, 03 Apr 2018 07:29:34 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v4 0/2] media: Introduce Omnivision OV2680 driver
Date: Tue,  3 Apr 2018 15:29:20 +0100
Message-Id: <20180403142922.20972-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add driver and bindings for the OV2680 2 megapixel CMOS 1/5" sensor, which has
a single MIPI lane interface and output format of 10-bit Raw RGB.

Features supported are described in PATCH 2/2.

v3->v4:
Sakari Ailus:
   - remove auto_{exposure|gain}_enable and direct call the set functions
   - add separe control sets to gain and exposure
   - fix number of controls allocated
   - check the exact frequency that it is supported

v2->v3:
Rob Herring:
    - add Reviewed-by tag to dts PATCH 1/1

Sakari Ailus:
    - align register values with bracket
    - redone the {write|read}_reg i2c functions
    - add bayer order handling with flip and mirror controls
    - fix error path in probe release resources
    - remove i2c_device_id and use probe_new

Myself:
    - remove ; at the end of macros
    
v1->v2:
Fabio Estevam:
    - s/OV5640/OV2680 in PATCH 1/2 changelog

Sakari Ailus:
    - add description on endpoint properties in bindings
    - add single endpoint in bindings
    - drop OF dependency
    - cleanup includes
    - fix case in Color Bars
    - remove frame rate selection
    - 8/16/24 bit register access in the same transaction
    - merge _reset and _soft_reset to _enable and rename it to power_on 
    - _gain_set use only the gain value (drop & 0x7ff)
    - _gain_get remove the (0x377)
    - single write/read at _exposure_set/get use write_reg24/read_reg24
    - move mode_set_direct to _mode_set
    - _mode_set set auto exposure/gain based on ctrl value
    - s_frame_interval equal to g_frame_interval
    - use closest match from: v4l: common: Add a function to obtain best size from a list 
    - check v4l2_ctrl_new_std return in _init

    - fix gain manual value in auto_cluster

Cheers,
    Rui


Rui Miguel Silva (2):
  media: ov2680: dt: Add bindings for OV2680
  media: ov2680: Add Omnivision OV2680 sensor driver

 .../devicetree/bindings/media/i2c/ov2680.txt       |   40 +
 drivers/media/i2c/Kconfig                          |   12 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov2680.c                         | 1111 ++++++++++++++++++++
 4 files changed, 1164 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2680.txt
 create mode 100644 drivers/media/i2c/ov2680.c

-- 
2.16.3
