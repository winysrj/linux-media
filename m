Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36689 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbeBQPDd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Feb 2018 10:03:33 -0500
Received: by mail-wm0-f67.google.com with SMTP id f3so7881402wmc.1
        for <linux-media@vger.kernel.org>; Sat, 17 Feb 2018 07:03:32 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH v2 0/7] cxd2099: convert to regmap API and move out of staging
Date: Sat, 17 Feb 2018 16:03:21 +0100
Message-Id: <20180217150328.686-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Patch series done by Jasmin and me.

This patch series, besides one little cosmetic fix in ddbridge, converts
the cxd2099 CI controller driver to the regmap API and thus makes it a
proper I2C client driver. This not only moves it away from the legacy/
"proprietary" DVB attach way of using I2C drivers, but also adds a
cleanup function through the I2C remove callback (such functionality is
seemingly currently missing from the DVB EN50221 API). Both ddbridge and
ngene (as users of the driver) are updated separately. No regressions
were spotted when used in conjuntion with VDR's and TVHeadend's CI
support. Testing with an ngene card revealed that I2C_FUNC_I2C needs
to be reported in .functionality, else things will fail starting at
the CAM detection.

In addition, this series moves the cxd2099 driver out of staging right
into dvb-frontends/ as it serves as a DVB (EN50221) frontend driver.
What's written in the TODO file in the staging dir simply doesn't apply
to the driver (see the commit message of that specific patch for details)
and it got quite polished up lately, so it's just inappropriate to keep
it in staging.

Lastly, Jasmin opted to take over maintainership of the driver, so the
last patch adds her into the MAINTAINERS file for the cxd2099 driver.

Please pick this series up in this merge window so it'll be part of the
4.17 kernel release.

Changes since v1:
- ngene's I2C interface also reports I2C_FUNC_I2C in .functionality

Daniel Scheller (6):
  [media] ddbridge/ci: further deduplicate code/logic in ddb_ci_attach()
  [media] staging/cxd2099: convert to regmap API
  [media] ddbridge: adapt cxd2099 attach to new i2c_client way
  [media] ngene: adapt cxd2099 attach to the new i2c_client way
  [media] staging/cxd2099: remove remainders from old attach way
  [media] cxd2099: move driver out of staging into dvb-frontends

Jasmin Jessich (1):
  [media] MAINTAINERS: add entry for cxd2099

 MAINTAINERS                                        |   8 +
 drivers/media/dvb-frontends/Kconfig                |  12 ++
 drivers/media/dvb-frontends/Makefile               |   1 +
 .../cxd2099 => media/dvb-frontends}/cxd2099.c      | 209 ++++++++++-----------
 .../cxd2099 => media/dvb-frontends}/cxd2099.h      |  19 +-
 drivers/media/pci/ddbridge/Kconfig                 |   1 +
 drivers/media/pci/ddbridge/Makefile                |   3 -
 drivers/media/pci/ddbridge/ddbridge-ci.c           |  72 +++++--
 drivers/media/pci/ddbridge/ddbridge.h              |   1 +
 drivers/media/pci/ngene/Kconfig                    |   1 +
 drivers/media/pci/ngene/Makefile                   |   3 -
 drivers/media/pci/ngene/ngene-core.c               |  41 +++-
 drivers/media/pci/ngene/ngene-i2c.c                |   2 +-
 drivers/media/pci/ngene/ngene.h                    |   1 +
 drivers/staging/media/Kconfig                      |   2 -
 drivers/staging/media/Makefile                     |   1 -
 drivers/staging/media/cxd2099/Kconfig              |  12 --
 drivers/staging/media/cxd2099/Makefile             |   4 -
 drivers/staging/media/cxd2099/TODO                 |  12 --
 19 files changed, 230 insertions(+), 175 deletions(-)
 rename drivers/{staging/media/cxd2099 => media/dvb-frontends}/cxd2099.c (78%)
 rename drivers/{staging/media/cxd2099 => media/dvb-frontends}/cxd2099.h (62%)
 delete mode 100644 drivers/staging/media/cxd2099/Kconfig
 delete mode 100644 drivers/staging/media/cxd2099/Makefile
 delete mode 100644 drivers/staging/media/cxd2099/TODO

-- 
2.13.6
