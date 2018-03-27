Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36372 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752086AbeC0PQ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 11:16:27 -0400
Received: by mail-pg0-f66.google.com with SMTP id 201so3271410pgg.3
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 08:16:27 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hiranotaka@zng.info,
        Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 0/5] dvb/pci/pt1: decompose earth-pt1 into sub drivers
Date: Wed, 28 Mar 2018 00:15:57 +0900
Message-Id: <20180327151602.12250-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Akihiro Tsukada (5):
  dvb-frontends/dvb-pll: add tda6651 ISDB-T pll_desc
  tuners: add new i2c driver for Sharp qm1d1b0004 ISDB-S tuner
  dvb: earth-pt1: decompose pt1 driver into sub drivers
  dvb: earth-pt1: add support for suspend/resume
  dvb: earth-pt1: replace schedule_timeout with usleep_range

 drivers/media/dvb-frontends/dvb-pll.c |  23 ++
 drivers/media/dvb-frontends/dvb-pll.h |   1 +
 drivers/media/pci/pt1/Kconfig         |   3 +
 drivers/media/pci/pt1/Makefile        |   3 +-
 drivers/media/pci/pt1/pt1.c           | 476 ++++++++++++++++------
 drivers/media/pci/pt1/va1j5jf8007s.c  | 732 ----------------------------------
 drivers/media/pci/pt1/va1j5jf8007s.h  |  42 --
 drivers/media/pci/pt1/va1j5jf8007t.c  | 532 ------------------------
 drivers/media/pci/pt1/va1j5jf8007t.h  |  42 --
 drivers/media/tuners/Kconfig          |   7 +
 drivers/media/tuners/Makefile         |   1 +
 drivers/media/tuners/qm1d1b0004.c     | 264 ++++++++++++
 drivers/media/tuners/qm1d1b0004.h     |  24 ++
 13 files changed, 681 insertions(+), 1469 deletions(-)
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007s.c
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007s.h
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007t.c
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007t.h
 create mode 100644 drivers/media/tuners/qm1d1b0004.c
 create mode 100644 drivers/media/tuners/qm1d1b0004.h

-- 
2.16.3
