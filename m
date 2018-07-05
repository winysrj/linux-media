Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43082 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753123AbeGECrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 22:47:06 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Antti Palosaari <crope@iki.fi>,
        Jemma Denson <jdenson@gmail.com>,
        Sergey Kozlov <serjk@netup.ru>, Michael Buesch <m@bues.ch>,
        Abylay Ospan <aospan@netup.ru>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Olli Salonen <olli.salonen@iki.fi>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net,
        Matthias Schwarzott <zzam@gentoo.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Daniel Scheller <d.scheller.oss@gmail.com>
Subject: [PATCH 0/2] DVB: represent frequencies at tuner/frontend .info in Hz
Date: Wed,  4 Jul 2018 23:46:55 -0300
Message-Id: <cover.1530740760.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a long standing issue that affect newer devices whose
tuner and frontend are capable of supporting both satellite and
non-satellite delivery standards.

Compile-tested only.

I intend to run some tests later this week with some random hardware,
but I'd appreciate any tests and feedback, as it is not hard to
break something, but we can't cook an omelet without breaking
some eggs.

Mauro Carvalho Chehab (2):
  media: dvb: convert tuner_info frequencies to Hz
  media: dvb: represent min/max/step/tolerance freqs in Hz

 drivers/media/common/siano/smsdvb-main.c      |  6 +-
 drivers/media/dvb-core/dvb_frontend.c         | 63 +++++++++++++++----
 drivers/media/dvb-frontends/af9013.c          |  7 +--
 drivers/media/dvb-frontends/af9033.c          |  7 +--
 drivers/media/dvb-frontends/as102_fe.c        |  6 +-
 drivers/media/dvb-frontends/ascot2e.c         |  6 +-
 drivers/media/dvb-frontends/atbm8830.c        |  6 +-
 drivers/media/dvb-frontends/au8522_dig.c      |  6 +-
 drivers/media/dvb-frontends/bcm3510.c         |  6 +-
 drivers/media/dvb-frontends/cx22700.c         |  6 +-
 drivers/media/dvb-frontends/cx22702.c         |  6 +-
 drivers/media/dvb-frontends/cx24110.c         |  8 +--
 drivers/media/dvb-frontends/cx24113.c         |  8 +--
 drivers/media/dvb-frontends/cx24116.c         |  8 +--
 drivers/media/dvb-frontends/cx24117.c         |  8 +--
 drivers/media/dvb-frontends/cx24120.c         |  8 +--
 drivers/media/dvb-frontends/cx24123.c         |  8 +--
 drivers/media/dvb-frontends/cxd2820r_t.c      |  4 +-
 drivers/media/dvb-frontends/cxd2820r_t2.c     |  4 +-
 drivers/media/dvb-frontends/cxd2841er.c       |  9 ++-
 .../media/dvb-frontends/cxd2880/cxd2880_top.c |  6 +-
 drivers/media/dvb-frontends/dib0070.c         |  8 +--
 drivers/media/dvb-frontends/dib0090.c         | 12 ++--
 drivers/media/dvb-frontends/dib3000mb.c       |  6 +-
 drivers/media/dvb-frontends/dib3000mc.c       |  6 +-
 drivers/media/dvb-frontends/dib7000m.c        |  6 +-
 drivers/media/dvb-frontends/dib7000p.c        |  6 +-
 drivers/media/dvb-frontends/dib8000.c         |  6 +-
 drivers/media/dvb-frontends/dib9000.c         |  6 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c   |  6 +-
 drivers/media/dvb-frontends/drxd_hard.c       |  7 +--
 drivers/media/dvb-frontends/drxk_hard.c       |  8 +--
 drivers/media/dvb-frontends/ds3000.c          |  8 +--
 drivers/media/dvb-frontends/dvb-pll.c         | 16 ++++-
 drivers/media/dvb-frontends/dvb_dummy_fe.c    | 24 +++----
 drivers/media/dvb-frontends/gp8psk-fe.c       |  6 +-
 drivers/media/dvb-frontends/helene.c          | 12 ++--
 drivers/media/dvb-frontends/horus3a.c         |  6 +-
 drivers/media/dvb-frontends/itd1000.c         |  8 +--
 drivers/media/dvb-frontends/ix2505v.c         |  8 +--
 drivers/media/dvb-frontends/l64781.c          |  7 +--
 drivers/media/dvb-frontends/lg2160.c          | 12 ++--
 drivers/media/dvb-frontends/lgdt3305.c        | 12 ++--
 drivers/media/dvb-frontends/lgdt3306a.c       |  6 +-
 drivers/media/dvb-frontends/lgdt330x.c        | 12 ++--
 drivers/media/dvb-frontends/lgs8gl5.c         |  7 +--
 drivers/media/dvb-frontends/lgs8gxx.c         |  6 +-
 drivers/media/dvb-frontends/m88ds3103.c       |  6 +-
 drivers/media/dvb-frontends/m88rs2000.c       |  8 +--
 drivers/media/dvb-frontends/mb86a16.c         |  7 +--
 drivers/media/dvb-frontends/mb86a20s.c        |  6 +-
 drivers/media/dvb-frontends/mt312.c           | 10 +--
 drivers/media/dvb-frontends/mt352.c           |  7 +--
 drivers/media/dvb-frontends/mxl5xx.c          |  6 +-
 drivers/media/dvb-frontends/nxt200x.c         |  6 +-
 drivers/media/dvb-frontends/nxt6000.c         |  6 +-
 drivers/media/dvb-frontends/or51132.c         |  6 +-
 drivers/media/dvb-frontends/or51211.c         |  8 +--
 drivers/media/dvb-frontends/rtl2830.c         |  4 +-
 drivers/media/dvb-frontends/rtl2832.c         | 10 +--
 drivers/media/dvb-frontends/s5h1409.c         |  6 +-
 drivers/media/dvb-frontends/s5h1411.c         |  6 +-
 drivers/media/dvb-frontends/s5h1420.c         |  8 +--
 drivers/media/dvb-frontends/s5h1432.c         |  6 +-
 drivers/media/dvb-frontends/s921.c            |  7 +--
 drivers/media/dvb-frontends/si2165.c          |  2 +-
 drivers/media/dvb-frontends/si21xx.c          |  7 +--
 drivers/media/dvb-frontends/sp8870.c          |  6 +-
 drivers/media/dvb-frontends/sp887x.c          |  6 +-
 drivers/media/dvb-frontends/stb0899_drv.c     |  6 +-
 drivers/media/dvb-frontends/stb6000.c         |  4 +-
 drivers/media/dvb-frontends/stb6100.c         |  5 +-
 drivers/media/dvb-frontends/stv0288.c         |  7 +--
 drivers/media/dvb-frontends/stv0297.c         |  6 +-
 drivers/media/dvb-frontends/stv0299.c         |  7 +--
 drivers/media/dvb-frontends/stv0367.c         | 20 +++---
 drivers/media/dvb-frontends/stv0900_core.c    |  7 +--
 drivers/media/dvb-frontends/stv090x.c         |  6 +-
 drivers/media/dvb-frontends/stv0910.c         |  6 +-
 drivers/media/dvb-frontends/stv6110.c         |  6 +-
 drivers/media/dvb-frontends/stv6110x.c        |  7 +--
 drivers/media/dvb-frontends/stv6111.c         |  5 +-
 drivers/media/dvb-frontends/tc90522.c         | 10 +--
 drivers/media/dvb-frontends/tda10021.c        | 10 +--
 drivers/media/dvb-frontends/tda10023.c        |  6 +-
 drivers/media/dvb-frontends/tda10048.c        |  6 +-
 drivers/media/dvb-frontends/tda1004x.c        | 12 ++--
 drivers/media/dvb-frontends/tda10071.c        | 10 +--
 drivers/media/dvb-frontends/tda10086.c        |  6 +-
 drivers/media/dvb-frontends/tda18271c2dd.c    |  6 +-
 drivers/media/dvb-frontends/tda665x.c         |  6 +-
 drivers/media/dvb-frontends/tda8083.c         |  7 +--
 drivers/media/dvb-frontends/tda8261.c         |  9 ++-
 drivers/media/dvb-frontends/tda826x.c         |  4 +-
 drivers/media/dvb-frontends/ts2020.c          |  4 +-
 drivers/media/dvb-frontends/tua6100.c         |  6 +-
 drivers/media/dvb-frontends/ves1820.c         |  6 +-
 drivers/media/dvb-frontends/ves1x93.c         |  8 +--
 drivers/media/dvb-frontends/zl10036.c         |  8 +--
 drivers/media/dvb-frontends/zl10353.c         |  7 +--
 drivers/media/firewire/firedtv-fe.c           | 26 ++++----
 drivers/media/pci/bt8xx/dst.c                 | 26 ++++----
 drivers/media/pci/bt8xx/dvb-bt8xx.c           |  8 +--
 drivers/media/pci/ddbridge/ddbridge-mci.c     |  6 +-
 drivers/media/pci/mantis/mantis_vp3030.c      |  4 +-
 drivers/media/tuners/e4000.c                  |  6 +-
 drivers/media/tuners/fc0011.c                 |  6 +-
 drivers/media/tuners/fc0012.c                 |  7 +--
 drivers/media/tuners/fc0013.c                 |  7 +--
 drivers/media/tuners/fc2580.c                 |  6 +-
 drivers/media/tuners/it913x.c                 |  6 +-
 drivers/media/tuners/m88rs6000t.c             |  6 +-
 drivers/media/tuners/max2165.c                |  8 +--
 drivers/media/tuners/mc44s803.c               |  8 +--
 drivers/media/tuners/mt2060.c                 |  8 +--
 drivers/media/tuners/mt2063.c                 |  7 +--
 drivers/media/tuners/mt2131.c                 |  8 +--
 drivers/media/tuners/mt2266.c                 |  8 +--
 drivers/media/tuners/mxl301rf.c               |  4 +-
 drivers/media/tuners/mxl5005s.c               |  8 +--
 drivers/media/tuners/mxl5007t.c               |  2 -
 drivers/media/tuners/qm1d1b0004.c             |  4 +-
 drivers/media/tuners/qm1d1c0042.c             |  4 +-
 drivers/media/tuners/qt1010.c                 |  8 +--
 drivers/media/tuners/qt1010_priv.h            | 14 +++--
 drivers/media/tuners/r820t.c                  |  6 +-
 drivers/media/tuners/si2157.c                 |  6 +-
 drivers/media/tuners/tda18212.c               |  8 +--
 drivers/media/tuners/tda18218.c               |  8 +--
 drivers/media/tuners/tda18250.c               |  6 +-
 drivers/media/tuners/tda18271-fe.c            |  6 +-
 drivers/media/tuners/tda827x.c                | 12 ++--
 drivers/media/tuners/tua9001.c                |  6 +-
 drivers/media/tuners/tuner-xc2028.c           |  6 +-
 drivers/media/tuners/xc4000.c                 | 12 ++--
 drivers/media/tuners/xc5000.c                 | 12 ++--
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c |  6 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c |  6 +-
 drivers/media/usb/dvb-usb/af9005-fe.c         |  6 +-
 drivers/media/usb/dvb-usb/cinergyT2-fe.c      |  6 +-
 drivers/media/usb/dvb-usb/dtt200u-fe.c        |  6 +-
 drivers/media/usb/dvb-usb/friio-fe.c          | 11 ++--
 drivers/media/usb/dvb-usb/vp702x-fe.c         |  7 +--
 drivers/media/usb/dvb-usb/vp7045-fe.c         |  6 +-
 drivers/media/usb/ttusb-dec/ttusbdecfe.c      | 12 ++--
 include/media/dvb_frontend.h                  | 49 ++++++++++++---
 146 files changed, 621 insertions(+), 577 deletions(-)

-- 
2.17.1
