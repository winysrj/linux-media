Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:52171 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935216AbaH0Pbg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 11:31:36 -0400
Received: by mail-pa0-f43.google.com with SMTP id lf10so508109pab.2
        for <linux-media@vger.kernel.org>; Wed, 27 Aug 2014 08:31:35 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [PATCH v2 0/5] dvb: Add support for PT3 ISDB-S/T card
Date: Thu, 28 Aug 2014 00:29:11 +0900
Message-Id: <1409153356-1887-1-git-send-email-tskd08@gmail.com>
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

Changes in v2:
- added a new tuner ops (get_signal_strength_dbm()) for DVBv5
- improved kthread handling on remove,suspend,resume
- added support for suspend/resume
- moved static const tables out of function scope
- renamed badly named variables
- changed symbol_rate calculation
- other small fixes pointed out in the last review by mauro

Akihiro Tsukada (5):
  dvb-core: add a new tuner ops to dvb_frontend for APIv5
  mxl301rf: add driver for MaxLinear MxL301RF OFDM tuner
  qm1d1c0042: add driver for Sharp QM1D1C0042 ISDB-S tuner
  tc90522: add driver for Toshiba TC90522 quad demodulator
  pt3: add support for Earthsoft PT3 ISDB-S/T receiver card

 drivers/media/dvb-core/dvb_frontend.h |   2 +
 drivers/media/dvb-frontends/Kconfig   |   8 +
 drivers/media/dvb-frontends/Makefile  |   1 +
 drivers/media/dvb-frontends/tc90522.c | 857 ++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/tc90522.h |  63 +++
 drivers/media/pci/Kconfig             |   1 +
 drivers/media/pci/Makefile            |   1 +
 drivers/media/pci/pt3/Kconfig         |  10 +
 drivers/media/pci/pt3/Makefile        |   8 +
 drivers/media/pci/pt3/pt3.c           | 817 ++++++++++++++++++++++++++++++++
 drivers/media/pci/pt3/pt3.h           | 179 +++++++
 drivers/media/pci/pt3/pt3_dma.c       | 225 +++++++++
 drivers/media/pci/pt3/pt3_i2c.c       | 239 ++++++++++
 drivers/media/tuners/Kconfig          |  14 +
 drivers/media/tuners/Makefile         |   2 +
 drivers/media/tuners/mxl301rf.c       | 334 +++++++++++++
 drivers/media/tuners/mxl301rf.h       |  40 ++
 drivers/media/tuners/qm1d1c0042.c     | 422 +++++++++++++++++
 drivers/media/tuners/qm1d1c0042.h     |  50 ++
 19 files changed, 3273 insertions(+)
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

