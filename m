Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:42909 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752468AbeDHRkO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 13:40:14 -0400
Received: by mail-pf0-f194.google.com with SMTP id o16so4326983pfk.9
        for <linux-media@vger.kernel.org>; Sun, 08 Apr 2018 10:40:14 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>,
        hiranotaka@zng.info
Subject: [PATCH v3 0/5] dvb/pci/pt1: decompose earth-pt1 into sub drivers
Date: Mon,  9 Apr 2018 02:39:48 +0900
Message-Id: <20180408173953.11076-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Changes since v2:
- dvb-pll,pt1: do not #define chip name constants and use string literals

Changes since v1:
- use new style of specifying pll_desc of the terrestrial tuner

Akihiro Tsukada (5):
  dvb-frontends/dvb-pll: add tda6651 ISDB-T pll_desc
  tuners: add new i2c driver for  Sharp qm1d1b0004 ISDB-S tuner
  dvb: earth-pt1: decompose pt1 driver into sub drivers
  dvb: earth-pt1: add support for suspend/resume
  dvb: earth-pt1:  replace schedule_timeout with usleep_range

 drivers/media/dvb-frontends/dvb-pll.c |  24 +
 drivers/media/dvb-frontends/dvb-pll.h |   1 +
 drivers/media/pci/pt1/Kconfig         |   3 +
 drivers/media/pci/pt1/Makefile        |   3 +-
 drivers/media/pci/pt1/pt1.c           | 470 ++++++++++++-----
 drivers/media/pci/pt1/va1j5jf8007s.c  | 732 --------------------------
 drivers/media/pci/pt1/va1j5jf8007s.h  |  42 --
 drivers/media/pci/pt1/va1j5jf8007t.c  | 532 -------------------
 drivers/media/pci/pt1/va1j5jf8007t.h  |  42 --
 drivers/media/tuners/Kconfig          |   7 +
 drivers/media/tuners/Makefile         |   1 +
 drivers/media/tuners/qm1d1b0004.c     | 264 ++++++++++
 drivers/media/tuners/qm1d1b0004.h     |  24 +
 13 files changed, 676 insertions(+), 1469 deletions(-)
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007s.c
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007s.h
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007t.c
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007t.h
 create mode 100644 drivers/media/tuners/qm1d1b0004.c
 create mode 100644 drivers/media/tuners/qm1d1b0004.h

-- 
2.17.0
