Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:42019 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbeAPJWI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 04:22:08 -0500
From: Shunqian Zheng <zhengsq@rock-chips.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org,
        Shunqian Zheng <zhengsq@rock-chips.com>
Subject: [PATCH v6 0/4] Add supports for OV2685 and OV5695 sensors
Date: Tue, 16 Jan 2018 17:21:57 +0800
Message-Id: <1516094521-22708-1-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds the OV2685 and OV5695 sensor supports.

Changes of v6 are mainly addressing comments from Jacopo@
 - Fix the node/lable name inverted in Doc.
 - Guard the source code with IS_ENABLED(CONFIG_OF)
 - Move the __v4l2_ctrl_handler_setup() into ov2685_s_stream()

Changes of v5,
 - Squash the MAINTAINERS entry to driver patch

Mainly changes of v4 are addressing the comments from Sakari,
including,
 - Put dt binding before driver in series
 - Add MAINTAINERS entries
 - Use regulator_bulk_*()
 - Fix the pm_runtime_* in probe()
 - Fix the typo of 2685 0x3008/0x3010 regs

Shunqian Zheng (4):
  dt-bindings: media: Add bindings for OV5695
  media: ov5695: add support for OV5695 sensor
  dt-bindings: media: Add bindings for OV2685
  media: ov2685: add support for OV2685 sensor

 .../devicetree/bindings/media/i2c/ov2685.txt       |   41 +
 .../devicetree/bindings/media/i2c/ov5695.txt       |   41 +
 MAINTAINERS                                        |   14 +
 drivers/media/i2c/Kconfig                          |   23 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/ov2685.c                         |  845 ++++++++++++
 drivers/media/i2c/ov5695.c                         | 1399 ++++++++++++++++++++
 7 files changed, 2365 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2685.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5695.txt
 create mode 100644 drivers/media/i2c/ov2685.c
 create mode 100644 drivers/media/i2c/ov5695.c

-- 
1.9.1
