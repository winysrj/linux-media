Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:41234 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbeAUPPb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Jan 2018 10:15:31 -0500
Received: by mail-pg0-f68.google.com with SMTP id 136so5091912pgd.8
        for <linux-media@vger.kernel.org>; Sun, 21 Jan 2018 07:15:31 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v3 0/3] media: ov9650: support device tree probing
Date: Mon, 22 Jan 2018 00:14:13 +0900
Message-Id: <1516547656-3879-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds device tree probing for ov9650 driver. This contains
an actual driver change and a newly added binding documentation part.

* Changelog v3
- Add Reviewed-by: tags
- Add MAINTAINERS entry

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

Akinobu Mita (3):
  media: ov9650: support device tree probing
  media: MAINTAINERS: add entry for ov9650 driver
  media: ov9650: add device tree binding

 .../devicetree/bindings/media/i2c/ov9650.txt       |  36 ++++++
 MAINTAINERS                                        |  10 ++
 drivers/media/i2c/ov9650.c                         | 130 +++++++++++++++------
 3 files changed, 138 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov9650.txt

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacopo Mondi <jacopo@jmondi.org>
Cc: H. Nikolaus Schaller <hns@goldelico.com>
Cc: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Rob Herring <robh@kernel.org>
-- 
2.7.4
