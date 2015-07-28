Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.netup.ru ([77.72.80.15]:56754 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627AbbG1O5c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 10:57:32 -0400
From: serjk@netup.ru
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, aospan1@gmail.com,
	Kozlov Sergey <serjk@netup.ru>
Subject: [PATCH v3 0/5] [media] NetUP Universal DVB PCIe card support
Date: Tue, 28 Jul 2015 17:32:59 +0300
Message-Id: <cover.1438090209.git.serjk@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kozlov Sergey <serjk@netup.ru>

Add support for NetUP Universal Dual DVB-CI PCIe board.
The board has:

    - two CI slots

    - Altera FPGA-based PCIe bridge

    - two independent multistandard DTV demodulators based on
      Sony CXD2841ER chip

    - two Sony Horus3a DVB-S/S2 tuner chips

    - two Sony Ascot2e DVB-T/T2/C/C2 tuner chips

    - two LNBH25 SEC controller chips

DVB-C2 is supported by hardware but not yet implemented in the driver.
Product webpages are
http://www.netup.tv/en-EN/netup-universal-dual-dvb-ci (official)
http://linuxtv.org/wiki/index.php/NetUP_Dual_Universal_CI (LinuxTV WIKI)

Kozlov Sergey (5):
  [media] horus3a: Sony Horus3A DVB-S/S2 tuner driver
  [media] ascot2e: Sony Ascot2e DVB-C/T/T2 tuner driver
  [media] lnbh25: LNBH25 SEC controller driver
  [media] cxd2841er: Sony CXD2841ER DVB-S/S2/T/T2/C demodulator driver
  [media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card
    driver

 MAINTAINERS                                        |   45 +
 drivers/media/dvb-frontends/Kconfig                |   29 +
 drivers/media/dvb-frontends/Makefile               |    4 +
 drivers/media/dvb-frontends/ascot2e.c              |  540 ++++
 drivers/media/dvb-frontends/ascot2e.h              |   58 +
 drivers/media/dvb-frontends/cxd2841er.c            | 2719 ++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2841er.h            |   65 +
 drivers/media/dvb-frontends/cxd2841er_priv.h       |   43 +
 drivers/media/dvb-frontends/horus3a.c              |  421 +++
 drivers/media/dvb-frontends/horus3a.h              |   58 +
 drivers/media/dvb-frontends/lnbh25.c               |  189 ++
 drivers/media/dvb-frontends/lnbh25.h               |   56 +
 drivers/media/pci/Kconfig                          |    1 +
 drivers/media/pci/Makefile                         |    3 +-
 drivers/media/pci/netup_unidvb/Kconfig             |   12 +
 drivers/media/pci/netup_unidvb/Makefile            |    9 +
 drivers/media/pci/netup_unidvb/netup_unidvb.h      |  133 +
 drivers/media/pci/netup_unidvb/netup_unidvb_ci.c   |  248 ++
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c | 1001 +++++++
 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c  |  381 +++
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c  |  252 ++
 21 files changed, 6266 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/dvb-frontends/ascot2e.c
 create mode 100644 drivers/media/dvb-frontends/ascot2e.h
 create mode 100644 drivers/media/dvb-frontends/cxd2841er.c
 create mode 100644 drivers/media/dvb-frontends/cxd2841er.h
 create mode 100644 drivers/media/dvb-frontends/cxd2841er_priv.h
 create mode 100644 drivers/media/dvb-frontends/horus3a.c
 create mode 100644 drivers/media/dvb-frontends/horus3a.h
 create mode 100644 drivers/media/dvb-frontends/lnbh25.c
 create mode 100644 drivers/media/dvb-frontends/lnbh25.h
 create mode 100644 drivers/media/pci/netup_unidvb/Kconfig
 create mode 100644 drivers/media/pci/netup_unidvb/Makefile
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb.h
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb_ci.c
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb_core.c
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c

-- 
1.7.10.4

