Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49730 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbaGNPoM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 11:44:12 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so5593071pab.32
        for <linux-media@vger.kernel.org>; Mon, 14 Jul 2014 08:44:11 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, james.hogan@imgtec.com
Subject: [PATCH 0/4] dvb: Add support for PT3 ISDB-S/T card
Date: Tue, 15 Jul 2014 00:43:43 +0900
Message-Id: <1405352627-22677-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Hi,

This patch series adds support for "PT3" ISDB-S/T receiver cards.
It contains a PCI bridge driver, a dvb-frontend driver and
two tuner drivers.
I know "Bud R" had already posted ones to this mailing list,
(as in 1400629035-32487-1-git-send-email-knightrider@are.ma ), 
but it seems that he stopped updating his patch and does not agree
on splitting the single large patch into smaller, separate ones.
This series is another version written independently by me.

Akihiro Tsukada (4):
  mxl301rf: add driver for MaxLinear MxL301RF OFDM tuner
  qm1d1c0042: add driver for Sharp QM1D1C0042 8PSK tuner
  tc90522: add driver for Toshiba TC90522 quad demodulator
  pt3: add support for Earthsoft PT3 ISDB-S/T receiver card

 drivers/media/dvb-frontends/Kconfig   |   8 +
 drivers/media/dvb-frontends/Makefile  |   1 +
 drivers/media/dvb-frontends/tc90522.c | 843 ++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/tc90522.h |  63 +++
 drivers/media/pci/Kconfig             |   1 +
 drivers/media/pci/Makefile            |   1 +
 drivers/media/pci/pt3/Kconfig         |  10 +
 drivers/media/pci/pt3/Makefile        |   8 +
 drivers/media/pci/pt3/pt3.c           | 750 ++++++++++++++++++++++++++++++
 drivers/media/pci/pt3/pt3.h           | 179 ++++++++
 drivers/media/pci/pt3/pt3_dma.c       | 225 +++++++++
 drivers/media/pci/pt3/pt3_i2c.c       | 239 ++++++++++
 drivers/media/tuners/Kconfig          |  14 +
 drivers/media/tuners/Makefile         |   2 +
 drivers/media/tuners/mxl301rf.c       | 331 +++++++++++++
 drivers/media/tuners/mxl301rf.h       |  40 ++
 drivers/media/tuners/qm1d1c0042.c     | 417 +++++++++++++++++
 drivers/media/tuners/qm1d1c0042.h     |  51 ++
 18 files changed, 3183 insertions(+)
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
2.0.1

