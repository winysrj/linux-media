Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34239 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbcBOJ1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 04:27:41 -0500
From: info@are.ma
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD?=
	 =?UTF-8?q?=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>,
	linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
	mchehab@osg.samsung.com, hdegoede@redhat.com,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com
Subject: [media 0/7] Driver bundle for PT3 & PX-Q3PE
Date: Mon, 15 Feb 2016 18:27:30 +0900
Message-Id: <cover.1455528251.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Буди Романто, AreMa Inc <knightrider@are.ma>

Polished driver bundle for PT3 & PX-Q3PE, two of the most powerful ISDB-S/ISDB-T receiver cards
currently available in Japan. Useless features are removed.

Main Components:
A. PT3 (2 ISDB-S + 2 ISDB-T receiver)
 1. Altera	EP4CGX15BF14C8N	: customized FPGA PCI bridge
 2. Toshiba	TC90522XBG	: quad demodulator (2ch OFDM + 2ch 8PSK)
 3. Sharp	VA4M6JC2103	: contains 2 ISDB-S + 2 ISDB-T tuners
	ISDB-S : Sharp QM1D1C0042 RF-IC
	ISDB-T : MaxLinear CMOS Hybrid TV MxL301RF

B. PX-Q3PE (4 ISDB-S + 4 ISDB-T receiver)
 1. ASICEN	ASV5220		: PCI-E bridge
 2. Toshiba	TC90522XBG	: quad demodulator (2ch OFDM + 2ch 8PSK)
 3. NXP Semiconductors TDA20142	: ISDB-S tuner
 4. Newport Media NM120		: ISDB-T tuner

Буди Романто, AreMa Inc (7):
  raise adapter number limit
  add NXP tda2014x & Newport Media nm120/130/131 tuners
  drop backstabbing drivers
  Toshiba TC90522XBG quad demod (2ch OFDM + 2ch 8PSK) for PT3 & PXQ3PE
  MaxLinear MxL301RF ISDB-T tuner
  Sharp QM1D1C0042 ISDB-S tuner
  PCI bridge driver for PT3 & PXQ3PE

 drivers/media/dvb-core/dvbdev.h       |   2 +-
 drivers/media/dvb-frontends/tc90522.c | 960 +++++++---------------------------
 drivers/media/dvb-frontends/tc90522.h |  36 +-
 drivers/media/pci/Kconfig             |   2 +-
 drivers/media/pci/Makefile            |   2 +-
 drivers/media/pci/pt3/Kconfig         |  10 -
 drivers/media/pci/pt3/Makefile        |   8 -
 drivers/media/pci/pt3/pt3.c           | 873 -------------------------------
 drivers/media/pci/pt3/pt3.h           | 186 -------
 drivers/media/pci/pt3/pt3_dma.c       | 225 --------
 drivers/media/pci/pt3/pt3_i2c.c       | 240 ---------
 drivers/media/pci/ptx/Kconfig         |  21 +
 drivers/media/pci/ptx/Makefile        |   8 +
 drivers/media/pci/ptx/pt3_pci.c       | 509 ++++++++++++++++++
 drivers/media/pci/ptx/ptx_common.c    | 215 ++++++++
 drivers/media/pci/ptx/ptx_common.h    |  69 +++
 drivers/media/pci/ptx/pxq3pe_pci.c    | 607 +++++++++++++++++++++
 drivers/media/tuners/Kconfig          |  14 +
 drivers/media/tuners/Makefile         |   2 +
 drivers/media/tuners/mxl301rf.c       | 468 +++++++----------
 drivers/media/tuners/mxl301rf.h       |  19 +-
 drivers/media/tuners/nm131.c          | 272 ++++++++++
 drivers/media/tuners/nm131.h          |  13 +
 drivers/media/tuners/qm1d1c0042.c     | 566 +++++++-------------
 drivers/media/tuners/qm1d1c0042.h     |  30 +-
 drivers/media/tuners/tda2014x.c       | 356 +++++++++++++
 drivers/media/tuners/tda2014x.h       |  13 +
 27 files changed, 2691 insertions(+), 3035 deletions(-)
 delete mode 100644 drivers/media/pci/pt3/Kconfig
 delete mode 100644 drivers/media/pci/pt3/Makefile
 delete mode 100644 drivers/media/pci/pt3/pt3.c
 delete mode 100644 drivers/media/pci/pt3/pt3.h
 delete mode 100644 drivers/media/pci/pt3/pt3_dma.c
 delete mode 100644 drivers/media/pci/pt3/pt3_i2c.c
 create mode 100644 drivers/media/pci/ptx/Kconfig
 create mode 100644 drivers/media/pci/ptx/Makefile
 create mode 100644 drivers/media/pci/ptx/pt3_pci.c
 create mode 100644 drivers/media/pci/ptx/ptx_common.c
 create mode 100644 drivers/media/pci/ptx/ptx_common.h
 create mode 100644 drivers/media/pci/ptx/pxq3pe_pci.c
 create mode 100644 drivers/media/tuners/nm131.c
 create mode 100644 drivers/media/tuners/nm131.h
 create mode 100644 drivers/media/tuners/tda2014x.c
 create mode 100644 drivers/media/tuners/tda2014x.h

-- 
2.3.10

