Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:46869 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754144AbeAGQyn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 Jan 2018 11:54:43 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v2 0/2] media: ov9650: support device tree probing
Date: Mon,  8 Jan 2018 01:54:22 +0900
Message-Id: <1515344064-23156-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds device tree probing for ov9650 driver. This contains
an actual driver change and a newly added binding documentation part.

* Changelog v2
- Split binding documentation, suggested by Rob Herring and Jacopo Mondi
- Improve the wording for compatible property in the binding documentation,
  suggested by Jacopo Mondi
- Improve the description for the device node in the binding documentation,
  suggested by Sakari Ailus
- Remove ov965x_gpio_set() helper and open-code it, suggested by Jacopo Mondi
  and Sakari Ailus
- Call clk_prepare_enable() in s_power callback instead of probe, suggested
  by Sakari Ailus
- Unify clk and gpio configuration in a single if-else block and, also add
  a check either platform data or fwnode is actually specified, suggested
  by Jacopo Mondi
- Add CONFIG_OF guards, suggested by Jacopo Mondi

Akinobu Mita (2):
  media: ov9650: support device tree probing
  media: ov9650: add device tree binding

 .../devicetree/bindings/media/i2c/ov9650.txt       |  36 ++++++
 drivers/media/i2c/ov9650.c                         | 130 +++++++++++++++------
 2 files changed, 128 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov9650.txt

Cc: Jacopo Mondi <jacopo@jmondi.org>
Cc: H. Nikolaus Schaller <hns@goldelico.com>
Cc: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Rob Herring <robh@kernel.org>
-- 
2.7.4
