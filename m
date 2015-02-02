Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.netup.ru ([77.72.80.15]:50185 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932937AbbBBJhs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 04:37:48 -0500
From: Kozlov Sergey <serjk@netup.ru>
Date: Mon, 02 Feb 2015 12:22:32 +0300
Subject: [PATCH 0/5] [media] NetUP Universal DVB PCIe card support
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, aospan1@gmail.com
Message-Id: <20150202092738.7CF0D1BC32CD@debian>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This patch adds support for NetUP Universal Dual DVB-CI PCIe board.
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

Also we have a copy of http://git.linuxtv.org/cgit.cgi/linux.git/
repository with our patches at http://git.netup.tv/linux-netup-unidvb.git


Kozlov Sergey (5):
  [media] horus3a: Sony Horus3A DVB-S/S2 tuner driver
  [media] ascot2e: Sony Ascot2e DVB-C/T/T2 tuner driver
  [media] lnbh25: LNBH25 SEC controller driver
  [media] cxd2841er: Sony CXD2841ER DVB-S/S2/T/T2/C demodulator driver
  [media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card
    driver

 MAINTAINERS                                  |   45 +
 drivers/media/dvb-frontends/Kconfig          |   29 +
 drivers/media/dvb-frontends/Makefile         |    4 +
 drivers/media/dvb-frontends/ascot2e.c        |  551 +++++
 drivers/media/dvb-frontends/ascot2e.h        |   53 +
 drivers/media/dvb-frontends/cxd2841er.c      | 2778 ++++++++++++++++++++++++++
 drivers/media/dvb-frontends/cxd2841er.h      |   64 +
 drivers/media/dvb-frontends/cxd2841er_priv.h |   44 +
 drivers/media/dvb-frontends/horus3a.c        |  429 ++++
 drivers/media/dvb-frontends/horus3a.h        |   53 +
 drivers/media/dvb-frontends/lnbh25.c         |  182 ++
 drivers/media/dvb-frontends/lnbh25.h         |   56 +
 drivers/media/pci/Kconfig                    |    1 +
 drivers/media/pci/Makefile                   |    3 +-
 drivers/media/pci/netup/Kconfig              |   12 +
 drivers/media/pci/netup/Makefile             |    9 +
 drivers/media/pci/netup/netup_unidvb.h       |  232 +++
 drivers/media/pci/netup/netup_unidvb_ci.c    |  248 +++
 drivers/media/pci/netup/netup_unidvb_core.c  |  919 +++++++++
 drivers/media/pci/netup/netup_unidvb_i2c.c   |  350 ++++
 drivers/media/pci/netup/netup_unidvb_spi.c   |  272 +++
 21 files changed, 6333 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/dvb-frontends/ascot2e.c
 create mode 100644 drivers/media/dvb-frontends/ascot2e.h
 create mode 100644 drivers/media/dvb-frontends/cxd2841er.c
 create mode 100644 drivers/media/dvb-frontends/cxd2841er.h
 create mode 100644 drivers/media/dvb-frontends/cxd2841er_priv.h
 create mode 100644 drivers/media/dvb-frontends/horus3a.c
 create mode 100644 drivers/media/dvb-frontends/horus3a.h
 create mode 100644 drivers/media/dvb-frontends/lnbh25.c
 create mode 100644 drivers/media/dvb-frontends/lnbh25.h
 create mode 100644 drivers/media/pci/netup/Kconfig
 create mode 100644 drivers/media/pci/netup/Makefile
 create mode 100644 drivers/media/pci/netup/netup_unidvb.h
 create mode 100644 drivers/media/pci/netup/netup_unidvb_ci.c
 create mode 100644 drivers/media/pci/netup/netup_unidvb_core.c
 create mode 100644 drivers/media/pci/netup/netup_unidvb_i2c.c
 create mode 100644 drivers/media/pci/netup/netup_unidvb_spi.c

-- 
1.7.10.4

