Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35054 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752769AbeAIOsi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 09:48:38 -0500
From: Shunqian Zheng <zhengsq@rock-chips.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org,
        Shunqian Zheng <zhengsq@rock-chips.com>
Subject: [PATCH v4 0/5] Add supports for OV2685 and OV5695 sensors
Date: Tue,  9 Jan 2018 22:48:19 +0800
Message-Id: <1515509304-15941-1-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds the OV2685 and OV5695 sensor supports.

Mainly changes of v4 are addressing the comments from Sakari,
including,
 - Put dt binding before driver in series
 - Add MAINTAINERS entries
 - Use regulator_bulk_*()
 - Fix the pm_runtime_* in probe()
 - Fix the typo of 2685 0x3008/0x3010 regs

Shunqian Zheng (5):
  dt-bindings: media: Add bindings for OV5695
  media: ov5695: add support for OV5695 sensor
  dt-bindings: media: Add bindings for OV2685
  media: ov2685: add support for OV2685 sensor
  [media] MAINTAINERS: add entries for OV2685/OV5695 sensor drivers

 .../devicetree/bindings/media/i2c/ov2685.txt       |   41 +
 .../devicetree/bindings/media/i2c/ov5695.txt       |   41 +
 MAINTAINERS                                        |   14 +
 drivers/media/i2c/Kconfig                          |   23 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/ov2685.c                         |  842 ++++++++++++
 drivers/media/i2c/ov5695.c                         | 1396 ++++++++++++++++++++
 7 files changed, 2359 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2685.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5695.txt
 create mode 100644 drivers/media/i2c/ov2685.c
 create mode 100644 drivers/media/i2c/ov5695.c

-- 
1.9.1
