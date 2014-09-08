Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48252 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbaIHRVF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Sep 2014 13:21:05 -0400
Received: by mail-pa0-f53.google.com with SMTP id rd3so2916989pab.12
        for <linux-media@vger.kernel.org>; Mon, 08 Sep 2014 10:21:04 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [PATCH v4 0/4] dvb: Add support for PT3 ISDB-S/T card
Date: Tue,  9 Sep 2014 02:20:39 +0900
Message-Id: <1410196843-26168-1-git-send-email-tskd08@gmail.com>
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

Changes in v4:
- removed unnecessary fe->ops.tuner_ops.get_status() and its use.
- moved initial freq settings from tuner drivers to the bridge driver
- added a comment to notice the driver's incompleteness
- improved I2C transaction in mxl301rf

Akihiro Tsukada (4):
  mxl301rf: add driver for MaxLinear MxL301RF OFDM tuner
  qm1d1c0042: add driver for Sharp QM1D1C0042 ISDB-S tuner
  tc90522: add driver for Toshiba TC90522 quad demodulator
  pt3: add support for Earthsoft PT3 ISDB-S/T receiver card

 drivers/media/dvb-frontends/Kconfig   |   8 +
 drivers/media/dvb-frontends/Makefile  |   1 +
 drivers/media/dvb-frontends/tc90522.c | 839 ++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/tc90522.h |  42 ++
 drivers/media/pci/Kconfig             |   1 +
 drivers/media/pci/Makefile            |   1 +
 drivers/media/pci/pt3/Kconfig         |  10 +
 drivers/media/pci/pt3/Makefile        |   8 +
 drivers/media/pci/pt3/pt3.c           | 877 ++++++++++++++++++++++++++++++++++
 drivers/media/pci/pt3/pt3.h           | 186 +++++++
 drivers/media/pci/pt3/pt3_dma.c       | 225 +++++++++
 drivers/media/pci/pt3/pt3_i2c.c       | 240 ++++++++++
 drivers/media/tuners/Kconfig          |  14 +
 drivers/media/tuners/Makefile         |   2 +
 drivers/media/tuners/mxl301rf.c       | 349 ++++++++++++++
 drivers/media/tuners/mxl301rf.h       |  26 +
 drivers/media/tuners/qm1d1c0042.c     | 445 +++++++++++++++++
 drivers/media/tuners/qm1d1c0042.h     |  37 ++
 18 files changed, 3311 insertions(+)
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

