Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54764 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbbFHTyc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:32 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/26] More DVB Docbook improvements
Date: Mon,  8 Jun 2015 16:53:44 -0300
Message-Id: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add more improvements at the DVB
Docbook.

The first patch makes the Makefile to report if a value defined
on an enum is not documented at frontend.h.

Then, it follows a series of patches that associates the xref links
to the existing entries, and create documentation for the missing
symbols.

After this series, the frontend documentation is fully in sync with
what's there in Kernel.

It then deprecates the usage of typedef for frontends on Kernelspace.
The usage of the frontend types are only allowed on userspace.

The final patches start to do some cleanup at the demux API. Yet,
lots of things to be done there, but I'll do this on a next documentation
patch series yet to be written.

Mauro Carvalho Chehab (26):
  [media] DocBook: handle enums on frontend.h
  [media] DocBook: Add entry IDs for enum fe_caps
  [media] DocBook: add entry IDs for enum fe_sec_mini_cmd
  [media] DocBook: add entry IDs for enum fe_status
  [media] DocBook: add entry IDs for enum fe_sec_tone_mode
  [media] Docbook: add entry IDs for enum fe_sec_voltage
  [media] DocBook: Add entry IDs for the enums defined at
    dvbproperty.xml
  [media] DocBook: Better document DTMB time interleaving
  [media] DocBook: add IDs for enum fe_bandwidth
  [media] DocBook: remove a wrong cut-and-paste data
  [media] DocBook: add placeholders for ATSC M/H properties
  [media] DocBook: Add documentation for ATSC M/H properties
  [media] DocBook: document DVB-S2 pilot in a table
  [media] DocBook: Remove duplicated documentation for SEC_VOLTAGE_*
  [media] DocBook: better document the DVB-S2 rolloff factor
  [media] DocBook: properly document the delivery systems
  [media] DocBook: add xrefs for enum fe_type
  [media] dvb: Get rid of typedev usage for enums
  [media] frontend: Move legacy API enums/structs to the end
  [media] frontend: move legacy typedefs to the end
  [media] DocBook: Remove comments before parsing enum values
  [media] frontend: Fix a typo at the comments
  [media] dvb: frontend.h: improve dvb_frontent_parameters comment
  [media] dvb: frontend.h: add a note for the deprecated enums/structs
  [media] dvb: dmx.h: don't use anonymous enums
  [media] DocBook: Change format for enum dmx_output documentation

 Documentation/DocBook/media/Makefile               |  49 +-
 Documentation/DocBook/media/dvb/demux.xml          |  57 ++-
 Documentation/DocBook/media/dvb/dvbproperty.xml    | 570 ++++++++++++++-------
 .../DocBook/media/dvb/fe-diseqc-send-burst.xml     |   4 +-
 Documentation/DocBook/media/dvb/fe-get-info.xml    |  62 +--
 Documentation/DocBook/media/dvb/fe-read-status.xml |  14 +-
 Documentation/DocBook/media/dvb/fe-set-tone.xml    |   4 +-
 Documentation/DocBook/media/dvb/fe-set-voltage.xml |  30 +-
 .../DocBook/media/dvb/frontend_legacy_api.xml      |  22 +-
 drivers/media/common/b2c2/flexcop-fe-tuner.c       |   7 +-
 drivers/media/common/siano/smsdvb-main.c           |   6 +-
 drivers/media/common/siano/smsdvb.h                |   2 +-
 drivers/media/dvb-core/dvb_frontend.c              |  27 +-
 drivers/media/dvb-core/dvb_frontend.h              |  42 +-
 drivers/media/dvb-frontends/a8293.c                |   2 +-
 drivers/media/dvb-frontends/af9013.c               |   4 +-
 drivers/media/dvb-frontends/af9033.c               |   4 +-
 drivers/media/dvb-frontends/as102_fe.c             |   4 +-
 drivers/media/dvb-frontends/atbm8830.c             |   3 +-
 drivers/media/dvb-frontends/au8522_dig.c           |   4 +-
 drivers/media/dvb-frontends/au8522_priv.h          |   2 +-
 drivers/media/dvb-frontends/bcm3510.c              |   2 +-
 drivers/media/dvb-frontends/cx22700.c              |   9 +-
 drivers/media/dvb-frontends/cx22702.c              |   2 +-
 drivers/media/dvb-frontends/cx24110.c              |  19 +-
 drivers/media/dvb-frontends/cx24116.c              |  38 +-
 drivers/media/dvb-frontends/cx24117.c              |  40 +-
 drivers/media/dvb-frontends/cx24120.c              |  50 +-
 drivers/media/dvb-frontends/cx24123.c              |  18 +-
 drivers/media/dvb-frontends/cxd2820r_c.c           |   2 +-
 drivers/media/dvb-frontends/cxd2820r_core.c        |   4 +-
 drivers/media/dvb-frontends/cxd2820r_priv.h        |   8 +-
 drivers/media/dvb-frontends/cxd2820r_t.c           |   2 +-
 drivers/media/dvb-frontends/cxd2820r_t2.c          |   2 +-
 drivers/media/dvb-frontends/dib3000mb.c            |   7 +-
 drivers/media/dvb-frontends/dib3000mc.c            |   2 +-
 drivers/media/dvb-frontends/dib7000m.c             |   2 +-
 drivers/media/dvb-frontends/dib7000p.c             |   6 +-
 drivers/media/dvb-frontends/dib8000.c              |  10 +-
 drivers/media/dvb-frontends/dib9000.c              |   4 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |   2 +-
 drivers/media/dvb-frontends/drxd_hard.c            |   2 +-
 drivers/media/dvb-frontends/drxk_hard.c            |   2 +-
 drivers/media/dvb-frontends/drxk_hard.h            |   2 +-
 drivers/media/dvb-frontends/ds3000.c               |  13 +-
 drivers/media/dvb-frontends/dvb_dummy_fe.c         |   9 +-
 drivers/media/dvb-frontends/ec100.c                |   2 +-
 drivers/media/dvb-frontends/hd29l2.c               |   2 +-
 drivers/media/dvb-frontends/hd29l2_priv.h          |   2 +-
 drivers/media/dvb-frontends/isl6405.c              |   3 +-
 drivers/media/dvb-frontends/isl6421.c              |   6 +-
 drivers/media/dvb-frontends/l64781.c               |   2 +-
 drivers/media/dvb-frontends/lg2160.c               |   2 +-
 drivers/media/dvb-frontends/lgdt3305.c             |   4 +-
 drivers/media/dvb-frontends/lgdt3306a.c            |   9 +-
 drivers/media/dvb-frontends/lgdt330x.c             |   8 +-
 drivers/media/dvb-frontends/lgs8gl5.c              |   2 +-
 drivers/media/dvb-frontends/lgs8gxx.c              |   3 +-
 drivers/media/dvb-frontends/lnbp21.c               |   4 +-
 drivers/media/dvb-frontends/lnbp22.c               |   3 +-
 drivers/media/dvb-frontends/m88ds3103.c            |   9 +-
 drivers/media/dvb-frontends/m88ds3103_priv.h       |   4 +-
 drivers/media/dvb-frontends/m88rs2000.c            |  19 +-
 drivers/media/dvb-frontends/mb86a16.c              |   7 +-
 drivers/media/dvb-frontends/mb86a16.h              |   3 +-
 drivers/media/dvb-frontends/mb86a20s.c             |   6 +-
 drivers/media/dvb-frontends/mt312.c                |  17 +-
 drivers/media/dvb-frontends/mt352.c                |   2 +-
 drivers/media/dvb-frontends/nxt200x.c              |   2 +-
 drivers/media/dvb-frontends/nxt6000.c              |  11 +-
 drivers/media/dvb-frontends/or51132.c              |   6 +-
 drivers/media/dvb-frontends/or51211.c              |   2 +-
 drivers/media/dvb-frontends/rtl2830.c              |   2 +-
 drivers/media/dvb-frontends/rtl2830_priv.h         |   2 +-
 drivers/media/dvb-frontends/rtl2832.c              |   2 +-
 drivers/media/dvb-frontends/rtl2832_priv.h         |   2 +-
 drivers/media/dvb-frontends/s5h1409.c              |   6 +-
 drivers/media/dvb-frontends/s5h1411.c              |   6 +-
 drivers/media/dvb-frontends/s5h1420.c              |  23 +-
 drivers/media/dvb-frontends/s5h1432.c              |   4 +-
 drivers/media/dvb-frontends/s921.c                 |   6 +-
 drivers/media/dvb-frontends/si2165.c               |   2 +-
 drivers/media/dvb-frontends/si2168.c               |   2 +-
 drivers/media/dvb-frontends/si2168_priv.h          |   4 +-
 drivers/media/dvb-frontends/si21xx.c               |  10 +-
 drivers/media/dvb-frontends/sp8870.c               |   3 +-
 drivers/media/dvb-frontends/sp887x.c               |   2 +-
 drivers/media/dvb-frontends/stb0899_drv.c          |   8 +-
 drivers/media/dvb-frontends/stv0288.c              |  11 +-
 drivers/media/dvb-frontends/stv0297.c              |  11 +-
 drivers/media/dvb-frontends/stv0299.c              |  22 +-
 drivers/media/dvb-frontends/stv0367.c              |  12 +-
 drivers/media/dvb-frontends/stv0367_priv.h         |   2 +-
 drivers/media/dvb-frontends/stv0900_core.c         |   6 +-
 drivers/media/dvb-frontends/stv090x.c              |   5 +-
 drivers/media/dvb-frontends/stv6110.c              |   2 +-
 drivers/media/dvb-frontends/tc90522.c              |  17 +-
 drivers/media/dvb-frontends/tda10021.c             |   7 +-
 drivers/media/dvb-frontends/tda10023.c             |   3 +-
 drivers/media/dvb-frontends/tda10048.c             |   2 +-
 drivers/media/dvb-frontends/tda1004x.c             |   3 +-
 drivers/media/dvb-frontends/tda10071.c             |  10 +-
 drivers/media/dvb-frontends/tda10071_priv.h        |  10 +-
 drivers/media/dvb-frontends/tda10086.c             |   9 +-
 drivers/media/dvb-frontends/tda8083.c              |  38 +-
 drivers/media/dvb-frontends/ves1820.c              |   6 +-
 drivers/media/dvb-frontends/ves1x93.c              |  15 +-
 drivers/media/dvb-frontends/zl10353.c              |   2 +-
 drivers/media/firewire/firedtv-fe.c                |   8 +-
 drivers/media/firewire/firedtv.h                   |   4 +-
 drivers/media/pci/bt8xx/dst.c                      |  25 +-
 drivers/media/pci/bt8xx/dst_common.h               |  12 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |  10 +-
 drivers/media/pci/cx23885/cx23885-f300.c           |   2 +-
 drivers/media/pci/cx23885/cx23885-f300.h           |   2 +-
 drivers/media/pci/cx23885/cx23885.h                |   2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |  12 +-
 drivers/media/pci/cx88/cx88.h                      |   5 +-
 drivers/media/pci/dm1105/dm1105.c                  |   3 +-
 drivers/media/pci/mantis/mantis_vp1034.c           |   2 +-
 drivers/media/pci/mantis/mantis_vp1034.h           |   3 +-
 drivers/media/pci/ngene/ngene.h                    |   2 +-
 drivers/media/pci/pt1/pt1.c                        |   6 +-
 drivers/media/pci/pt1/va1j5jf8007s.c               |   4 +-
 drivers/media/pci/pt1/va1j5jf8007t.c               |   4 +-
 drivers/media/pci/pt3/pt3.c                        |   2 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |   6 +-
 drivers/media/pci/saa7134/saa7134.h                |   3 +-
 drivers/media/pci/ttpci/av7110.c                   |  18 +-
 drivers/media/pci/ttpci/av7110.h                   |  27 +-
 drivers/media/pci/ttpci/budget-core.c              |   3 +-
 drivers/media/pci/ttpci/budget-patch.c             |  15 +-
 drivers/media/pci/ttpci/budget.c                   |  12 +-
 drivers/media/pci/ttpci/budget.h                   |   2 +-
 drivers/media/usb/dvb-usb-v2/af9015.c              |   2 +-
 drivers/media/usb/dvb-usb-v2/af9015.h              |   2 +-
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |  11 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |  10 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c      |  14 +-
 drivers/media/usb/dvb-usb/af9005-fe.c              |   5 +-
 drivers/media/usb/dvb-usb/az6027.c                 |   3 +-
 drivers/media/usb/dvb-usb/cinergyT2-fe.c           |   2 +-
 drivers/media/usb/dvb-usb/dib0700.h                |   2 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |   2 +-
 drivers/media/usb/dvb-usb/dtt200u-fe.c             |   7 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |  13 +-
 drivers/media/usb/dvb-usb/friio-fe.c               |   3 +-
 drivers/media/usb/dvb-usb/gp8psk-fe.c              |  11 +-
 drivers/media/usb/dvb-usb/opera1.c                 |   3 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |   2 +-
 drivers/media/usb/dvb-usb/vp702x-fe.c              |  17 +-
 drivers/media/usb/dvb-usb/vp7045-fe.c              |   3 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  |   9 +-
 drivers/media/usb/ttusb-dec/ttusbdecfe.c           |  10 +-
 drivers/staging/media/mn88472/mn88472.c            |   2 +-
 drivers/staging/media/mn88472/mn88472_priv.h       |   2 +-
 drivers/staging/media/mn88473/mn88473.c            |   2 +-
 drivers/staging/media/mn88473/mn88473_priv.h       |   2 +-
 include/uapi/linux/dvb/dmx.h                       |  10 +-
 include/uapi/linux/dvb/frontend.h                  | 197 ++++---
 160 files changed, 1228 insertions(+), 905 deletions(-)

-- 
2.4.2

