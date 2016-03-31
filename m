Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34094 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbcCaTcT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2016 15:32:19 -0400
From: info@are.ma
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=
	<knightrider@are.ma>, linux-kernel@vger.kernel.org, crope@iki.fi,
	m.chehab@samsung.com, mchehab@osg.samsung.com, hdegoede@redhat.com,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com
Subject: [media 0/8] DVB driver for Earthsoft PT3, PLEX PX-Q3PE ISDB-S/T PCIE cards & PX-BCUD ISDB-S USB dongle
Date: Fri,  1 Apr 2016 04:32:07 +0900
Message-Id: <cover.1459450632.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Буди Романто, AreMa Inc <knightrider@are.ma>

DVB driver for Earthsoft PT3, PLEX PX-Q3PE ISDB-S/T PCIE cards & PX-BCUD ISDB-S USB dongle
==========================================================================================

Status: stable

Features:
1. in addition to the real frequency:
	ISDB-S : freq. channel ID
	ISDB-T : freq# (I/O# +128), ch#, ch# +64 for CATV
2. in addition to TSID:
	ISDB-S : slot#

Supported Cards & Main components:
A. EarthSoft PT3:
1. Altera	EP4CGX15BF14C8N	: customized FPGA PCI bridge
2. Toshiba	TC90522XBG	: quad demodulator (2ch OFDM + 2ch 8PSK)
3. Sharp	VA4M6JC2103	: contains 2 ISDB-S + 2 ISDB-T tuners
	ISDB-S : Sharp QM1D1C0042 RF-IC, chip ver. 0x48
	ISDB-T : MaxLinear CMOS Hybrid TV MxL301RF

B. PLEX PX-Q3PE:
1. ASICEN	ASV5220		: PCI-E bridge
2. Toshiba	TC90522XBG	: quad demodulator (2ch OFDM + 2ch 8PSK)
3. NXP Semiconductors TDA20142	: ISDB-S tuner
4. Newport Media NM120		: ISDB-T tuner
5. ASICEN	ASIE5606X8	: crypting controller

C. PLEX PX-BCUD (ISDB-S USB dongle)
1. Empia	EM28178		: USB I/F (courtesy of Nagahama Satoshi)
2. Toshiba	TC90532		: demodulator (using TC90522 driver)
3. Sharp	QM1D1C0045_2	: ISDB-S RF-IC, chip ver. 0x68

Notes:
This is a complex but smartly polished driver package containing 2 (dual head)
PCI-E bridge I/F drivers, single demodulator frontend, and 4 (quad tail) tuner drivers,
plus, simplified Nagahama's patch for PLEX PX-BCUD (ISDB-S USB dongle).
Generic registration related procedures (subdevices, frontend, etc.) summarized in
ptx_common.c are very useful also for other DVB drivers, and would be very handy if
inserted into the core (e.g. dvb_frontend.c & dvb_frontend.h).

For example, currently, the entity of struct dvb_frontend is created sometimes in
demodulators, some in tuners, or even in the parent (bridge) drivers. IMHO, this entity
should be provided by dvb_core. ptx_register_fe() included in ptx_common.c simplifies
the tasks and in fact, significantly reduces coding & kernel size.

Also, currently dvb_frontend's .demodulator_priv & .tuner_priv are of type (void *).
These should be changed to (struct i2c_client *), IMHO. Private data for demodulator
or tuner should be attached under i2c_client, using i2c_set_clientdata() for instance.

FILENAME	SUPPORTED CHIPS
========	===============
tc90522.c	TC90522XBG, TC90532XBG,...
tda2014x.c	TDA20142
qm1d1c004x.c	QM1D1C0042, QM1D1C0045, QM1D1C0045_2
nm131.c		NM131, NM130, NM120
mxl301rf.c	MxL301RF
pt3_pci.c	EP4CGX15BF14C8N
pxq3pe_pci.c	ASV5220

Full package:
- URL:	https://github.com/knight-rider/ptx

Буди Романто, AreMa Inc (8):
  The current limit is too low for latest cards with 8+ tuners on a
    single slot, change to 64.
  NXP tda2014x & Newport Media nm120/130/131 tuner drivers for PLEX
    PX-Q3PE
  Obsoleted & superseded, please read cover letter for details.
  Toshiba TC905xx demodulator driver for PT3, PX-Q3PE & PX-BCUD
  MaxLinear MxL301RF ISDB-T tuner
  Sharp QM1D1C004x ISDB-S tuner driver for PT3 and PX-BCUD
  PCIE bridge driver for PT3 & PX-Q3PE     Please read cover letter for
    details.
  Support for PLEX PX-BCUD (ISDB-S usb dongle)     Nagahama's patch
    simplified...

 drivers/media/dvb-core/dvbdev.h         |   2 +-
 drivers/media/dvb-frontends/tc90522.c   | 965 +++++++-------------------------
 drivers/media/dvb-frontends/tc90522.h   |  36 +-
 drivers/media/pci/Kconfig               |   2 +-
 drivers/media/pci/Makefile              |   2 +-
 drivers/media/pci/pt3/Kconfig           |  10 -
 drivers/media/pci/pt3/Makefile          |   8 -
 drivers/media/pci/pt3/pt3.c             | 874 -----------------------------
 drivers/media/pci/pt3/pt3.h             | 186 ------
 drivers/media/pci/pt3/pt3_dma.c         | 225 --------
 drivers/media/pci/pt3/pt3_i2c.c         | 240 --------
 drivers/media/pci/ptx/Kconfig           |  21 +
 drivers/media/pci/ptx/Makefile          |   8 +
 drivers/media/pci/ptx/pt3_pci.c         | 425 ++++++++++++++
 drivers/media/pci/ptx/ptx_common.c      | 252 +++++++++
 drivers/media/pci/ptx/ptx_common.h      |  74 +++
 drivers/media/pci/ptx/pxq3pe_pci.c      | 585 +++++++++++++++++++
 drivers/media/tuners/Kconfig            |  21 +-
 drivers/media/tuners/Makefile           |   4 +-
 drivers/media/tuners/mxl301rf.c         | 471 ++++++----------
 drivers/media/tuners/mxl301rf.h         |  19 +-
 drivers/media/tuners/nm131.c            | 248 ++++++++
 drivers/media/tuners/nm131.h            |  13 +
 drivers/media/tuners/qm1d1c0042.c       | 448 ---------------
 drivers/media/tuners/qm1d1c0042.h       |  37 --
 drivers/media/tuners/qm1d1c004x.c       | 242 ++++++++
 drivers/media/tuners/qm1d1c004x.h       |  23 +
 drivers/media/tuners/tda2014x.c         | 342 +++++++++++
 drivers/media/tuners/tda2014x.h         |  13 +
 drivers/media/usb/em28xx/Kconfig        |   2 +
 drivers/media/usb/em28xx/em28xx-cards.c |  27 +
 drivers/media/usb/em28xx/em28xx-dvb.c   |  79 ++-
 drivers/media/usb/em28xx/em28xx.h       |   1 +
 33 files changed, 2752 insertions(+), 3153 deletions(-)
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
 delete mode 100644 drivers/media/tuners/qm1d1c0042.c
 delete mode 100644 drivers/media/tuners/qm1d1c0042.h
 create mode 100644 drivers/media/tuners/qm1d1c004x.c
 create mode 100644 drivers/media/tuners/qm1d1c004x.h
 create mode 100644 drivers/media/tuners/tda2014x.c
 create mode 100644 drivers/media/tuners/tda2014x.h

-- 
2.7.4

