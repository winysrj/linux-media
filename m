Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:46394 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaIGMl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Sep 2014 08:41:59 -0400
Received: by mail-pd0-f180.google.com with SMTP id ft15so2992775pdb.39
        for <linux-media@vger.kernel.org>; Sun, 07 Sep 2014 05:41:59 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [PATCH v3 0/4] dvb: Add support for PT3 ISDB-S/T card
Date: Sun,  7 Sep 2014 21:41:26 +0900
Message-Id: <1410093690-5674-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This patch series adds support for "PT3" ISDB-S/T receiver cards.
It contains a PCI bridge driver, a dvb-frontend driver and
two tuner drivers.
I know "Bud R" had already posted ones to this mailing list,
(as in 1400629035-32487-1-git-send-email-knightrider@are.ma ), 
but it seems that he stopped updating his patch and does not agree
on splitting the single large patch into smaller, separate ones.
This series is another version written independently by me.

Changes in v3:
- changed to use I2C binding model for demod/tuner drivers.
- removed use of fe->callback and set fe->ops.xxx in the PCI driver.
- small improvements (prototype,return values) in reg read/write.

Akihiro Tsukada (4):
  mxl301rf: add driver for MaxLinear MxL301RF OFDM tuner
  qm1d1c0042: add driver for Sharp QM1D1C0042 ISDB-S tuner
  tc90522: add driver for Toshiba TC90522 quad demodulator
  pt3: add support for Earthsoft PT3 ISDB-S/T receiver card

 drivers/media/dvb-frontends/Kconfig   |   8 +
 drivers/media/dvb-frontends/Makefile  |   1 +
 drivers/media/dvb-frontends/tc90522.c | 841 ++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/tc90522.h |  42 ++
 drivers/media/pci/Kconfig             |   1 +
 drivers/media/pci/Makefile            |   1 +
 drivers/media/pci/pt3/Kconfig         |  10 +
 drivers/media/pci/pt3/Makefile        |   8 +
 drivers/media/pci/pt3/pt3.c           | 881 ++++++++++++++++++++++++++++++++++
 drivers/media/pci/pt3/pt3.h           | 185 +++++++
 drivers/media/pci/pt3/pt3_dma.c       | 225 +++++++++
 drivers/media/pci/pt3/pt3_i2c.c       | 240 +++++++++
 drivers/media/tuners/Kconfig          |  14 +
 drivers/media/tuners/Makefile         |   2 +
 drivers/media/tuners/mxl301rf.c       | 383 +++++++++++++++
 drivers/media/tuners/mxl301rf.h       |  28 ++
 drivers/media/tuners/qm1d1c0042.c     | 456 ++++++++++++++++++
 drivers/media/tuners/qm1d1c0042.h     |  38 ++
 18 files changed, 3364 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/tc90522.c
 create mode 100644 drivers/media/dvb-frontends/tc90522.h
 create mode 100644 drivers/media/pci/pt3/Kconfig
 create mode 100644 drivers/media/pci/pt3/Makefile
 create mode 100644 drivers/media/pci/pt3/pt3.c
 create mode 100644 drivers/media/pci/pt3/pt3.h
 create mode 100644 drivers/media/pci/pt3/pt3_dma.c
 create mode 100644 drivers/media/pci/pt3/pt3_i2c.c
 create mode 100644 drivers/media/tuners/mxl301rf.c
 create mode 100644 drivers/media/tuners/mxl301rf.h
 create mode 100644 drivers/media/tuners/qm1d1c0042.c
 create mode 100644 drivers/media/tuners/qm1d1c0042.h

-- 
2.1.0

