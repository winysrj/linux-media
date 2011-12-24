Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab1LXPvF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:05 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp41m009924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 00/47] DVB tuners: remove dvb_frontend_parameters from set_params()
Date: Sat, 24 Dec 2011 13:50:05 -0200
Message-Id: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a big series of patches, but most stuff are trivial:
instead of using the DVBv3 way (explicitly passing a 
struct dvb_frontend_parameters to set_parms), use the DVBv5
way (e. g. fe->dtv_property_cache). This makes the drivers more
consistent, as newer drivers (DVB-T2/S2, ISDB-T, DMTB, DVB turbo,
etc) can't use the DVBv3 parameters, as they don't have the
parameters needed by those systems.

I'm working on a further patch series that will do the same thing
for the DVB demods.

After having both applied, the DVB core functions can be
simplified, as they won't need to sync with DVBv3 parameters
for DVBv5 calls. This will help to solve a series of bugs
with newer delivery systems due to the sync issues.

Mauro Carvalho Chehab (47):
  [media] dvb: replace SYS_DVBC_ANNEX_AC by the right delsys
  [media] dvb_core: estimate bw for all non-terrestial systems
  [media] qt1010: remove fake implementaion of get_bandwidth()
  [media] mt2060: remove fake implementaion of get_bandwidth()
  [media] mt2031: remove fake implementaion of get_bandwidth()
  [media] mc44s803: use DVBv5 parameters on set_params()
  [media] max2165: use DVBv5 parameters on set_params()
  [media] mt2266: use DVBv5 parameters for set_params()
  [media] mxl5005s: use DVBv5 parameters on set_params()
  [media] mxl5005s: fix: don't discard bandwidth changes
  [media] mxl5007t: use DVBv5 parameters on set_params()
  [media] tda18218: use DVBv5 parameters on set_params()
  [media] tda18271: add support for QAM 7 MHz map
  [media] tda18271-fe: use DVBv5 parameters on set_params()
  [media] tda827x: use DVBv5 parameters on set_params()
  [media] tuner-xc2028: use DVBv5 parameters on set_params()
  [media] xc4000: use DVBv5 parameters on set_params()
  [media] cx24113: use DVBv5 parameters on set_params()
  [media] zl10039: use DVBv5 parameters on set_params()
  [media] av7110: use DVBv5 parameters on set_params()
  [media] budget-ci: use DVBv5 parameters on set_params()
  [media] budget-patch: use DVBv5 parameters on set_params()
  [media] saa7134: use DVBv5 parameters on set_params()
  [media] cx88: use DVBv5 parameters on set_params()
  [media] tua6100: use DVBv5 parameters on set_params()
  [media] itd1000: use DVBv5 parameters on set_params()
  [media] bsbe1, bsru6, tdh1: use DVBv5 parameters on set_params()
  [media] ix2505v: use DVBv5 parameters on set_params()
  [media] stb6000: use DVBv5 parameters on set_params()
  [media] tda826x: use DVBv5 parameters on set_params()
  [media] mxl111sf-tuner: use DVBv5 parameters on set_params()
  [media] mantis_vp1033: use DVBv5 parameters on set_params()
  [media] mantis_vp2033: use DVBv5 parameters on set_params()
  [media] mantis_vp2040: use DVBv5 parameters on set_params()
  [media] pluto2: use DVBv5 parameters on set_params()
  [media] dvb-ttusb-budget: use DVBv5 parameters on set_params()
  [media] tuner-simple: use DVBv5 parameters on set_params()
  [media] dvb-bt8xx: use DVBv5 parameters on set_params()
  [media] dvb-pll: use DVBv5 parameters on set_params()
  [media] zl10036: use DVBv5 parameters on set_params()
  [media] dib0070: Remove unused dvb_frontend_parameters
  [media] cxusb: use DVBv5 parameters on set_params()
  [media] dib0700_devices: use DVBv5 parameters on set_params()
  [media] budget-av: use DVBv5 parameters on set_params()
  [media] budget: use DVBv5 parameters on set_params()
  [media] dvb: remove dvb_frontend_parameters from calc_regs()
  [media] tuners: remove dvb_frontend_parameters from set_params()

 drivers/media/common/tuners/max2165.c             |   39 +++-----
 drivers/media/common/tuners/mc44s803.c            |   10 +-
 drivers/media/common/tuners/mt2060.c              |   14 +---
 drivers/media/common/tuners/mt2060_priv.h         |    1 -
 drivers/media/common/tuners/mt2131.c              |   20 +----
 drivers/media/common/tuners/mt2131_priv.h         |    1 -
 drivers/media/common/tuners/mt2266.c              |   27 +++---
 drivers/media/common/tuners/mxl5005s.c            |   69 +++++++--------
 drivers/media/common/tuners/mxl5007t.c            |   54 +++++------
 drivers/media/common/tuners/qt1010.c              |   22 ++----
 drivers/media/common/tuners/qt1010_priv.h         |    1 -
 drivers/media/common/tuners/tda18212.c            |    6 +-
 drivers/media/common/tuners/tda18218.c            |   18 ++---
 drivers/media/common/tuners/tda18271-fe.c         |   77 +++++++---------
 drivers/media/common/tuners/tda18271-maps.c       |    4 +
 drivers/media/common/tuners/tda18271.h            |    1 +
 drivers/media/common/tuners/tda827x.c             |   55 ++++++-----
 drivers/media/common/tuners/tuner-simple.c        |   69 ++++++++++-----
 drivers/media/common/tuners/tuner-xc2028.c        |   86 ++++++++----------
 drivers/media/common/tuners/xc4000.c              |  100 +++++++++------------
 drivers/media/common/tuners/xc5000.c              |    3 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c               |  101 +++++++++++----------
 drivers/media/dvb/dvb-core/dvb_frontend.c         |   37 ++++++--
 drivers/media/dvb/dvb-core/dvb_frontend.h         |    4 +-
 drivers/media/dvb/dvb-usb/af9005-fe.c             |    2 +-
 drivers/media/dvb/dvb-usb/cxusb.c                 |   11 +--
 drivers/media/dvb/dvb-usb/dib0700_devices.c       |   49 +++++-----
 drivers/media/dvb/dvb-usb/digitv.c                |    4 +-
 drivers/media/dvb/dvb-usb/mxl111sf-demod.c        |    2 +-
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c        |   49 +++++------
 drivers/media/dvb/frontends/af9013.c              |    2 +-
 drivers/media/dvb/frontends/atbm8830.c            |    2 +-
 drivers/media/dvb/frontends/au8522_dig.c          |    2 +-
 drivers/media/dvb/frontends/bsbe1.h               |    7 +-
 drivers/media/dvb/frontends/bsru6.h               |    9 +-
 drivers/media/dvb/frontends/cx22700.c             |    2 +-
 drivers/media/dvb/frontends/cx22702.c             |    2 +-
 drivers/media/dvb/frontends/cx24110.c             |    2 +-
 drivers/media/dvb/frontends/cx24113.c             |    8 +-
 drivers/media/dvb/frontends/cx24123.c             |    2 +-
 drivers/media/dvb/frontends/cxd2820r_c.c          |    6 +-
 drivers/media/dvb/frontends/cxd2820r_t.c          |    2 +-
 drivers/media/dvb/frontends/cxd2820r_t2.c         |    2 +-
 drivers/media/dvb/frontends/dib0070.c             |   10 +-
 drivers/media/dvb/frontends/dib0090.c             |    2 +-
 drivers/media/dvb/frontends/dib3000mb.c           |    2 +-
 drivers/media/dvb/frontends/dib3000mc.c           |    2 +-
 drivers/media/dvb/frontends/dib7000m.c            |    2 +-
 drivers/media/dvb/frontends/dib7000p.c            |    2 +-
 drivers/media/dvb/frontends/dib8000.c             |    2 +-
 drivers/media/dvb/frontends/drxd_hard.c           |    2 +-
 drivers/media/dvb/frontends/drxk_hard.c           |    2 +-
 drivers/media/dvb/frontends/dvb-pll.c             |   68 +++++++-------
 drivers/media/dvb/frontends/dvb_dummy_fe.c        |    2 +-
 drivers/media/dvb/frontends/ec100.c               |    2 +-
 drivers/media/dvb/frontends/it913x-fe.c           |    2 +-
 drivers/media/dvb/frontends/itd1000.c             |    7 +-
 drivers/media/dvb/frontends/ix2505v.c             |    8 +-
 drivers/media/dvb/frontends/l64781.c              |    2 +-
 drivers/media/dvb/frontends/lgdt3305.c            |    4 +-
 drivers/media/dvb/frontends/lgdt330x.c            |    2 +-
 drivers/media/dvb/frontends/lgs8gl5.c             |    2 +-
 drivers/media/dvb/frontends/lgs8gxx.c             |    2 +-
 drivers/media/dvb/frontends/mb86a20s.c            |    2 +-
 drivers/media/dvb/frontends/mt312.c               |    2 +-
 drivers/media/dvb/frontends/mt352.c               |    4 +-
 drivers/media/dvb/frontends/nxt200x.c             |    2 +-
 drivers/media/dvb/frontends/nxt6000.c             |    2 +-
 drivers/media/dvb/frontends/or51132.c             |    2 +-
 drivers/media/dvb/frontends/or51211.c             |    2 +-
 drivers/media/dvb/frontends/s5h1409.c             |    2 +-
 drivers/media/dvb/frontends/s5h1411.c             |    2 +-
 drivers/media/dvb/frontends/s5h1420.c             |    4 +-
 drivers/media/dvb/frontends/s5h1432.c             |    6 +-
 drivers/media/dvb/frontends/sp8870.c              |    2 +-
 drivers/media/dvb/frontends/sp887x.c              |    2 +-
 drivers/media/dvb/frontends/stb6000.c             |    8 +-
 drivers/media/dvb/frontends/stv0288.c             |    2 +-
 drivers/media/dvb/frontends/stv0297.c             |    2 +-
 drivers/media/dvb/frontends/stv0299.c             |    2 +-
 drivers/media/dvb/frontends/stv0367.c             |    4 +-
 drivers/media/dvb/frontends/stv6110.c             |    3 +-
 drivers/media/dvb/frontends/tda10021.c            |    2 +-
 drivers/media/dvb/frontends/tda10023.c            |    2 +-
 drivers/media/dvb/frontends/tda10048.c            |    2 +-
 drivers/media/dvb/frontends/tda1004x.c            |    2 +-
 drivers/media/dvb/frontends/tda10086.c            |    2 +-
 drivers/media/dvb/frontends/tda18271c2dd.c        |    3 +-
 drivers/media/dvb/frontends/tda8083.c             |    2 +-
 drivers/media/dvb/frontends/tda826x.c             |    7 +-
 drivers/media/dvb/frontends/tdhd1.h               |   11 ++-
 drivers/media/dvb/frontends/tua6100.c             |   18 ++--
 drivers/media/dvb/frontends/ves1820.c             |    2 +-
 drivers/media/dvb/frontends/ves1x93.c             |    2 +-
 drivers/media/dvb/frontends/zl10036.c             |   10 +-
 drivers/media/dvb/frontends/zl10039.c             |   10 +-
 drivers/media/dvb/frontends/zl10353.c             |    4 +-
 drivers/media/dvb/mantis/mantis_vp1033.c          |    8 +-
 drivers/media/dvb/mantis/mantis_vp2033.c          |    9 +-
 drivers/media/dvb/mantis/mantis_vp2040.c          |    9 +-
 drivers/media/dvb/pluto2/pluto2.c                 |    6 +-
 drivers/media/dvb/ttpci/av7110.c                  |   69 ++++++++-------
 drivers/media/dvb/ttpci/budget-av.c               |   50 ++++++-----
 drivers/media/dvb/ttpci/budget-ci.c               |   48 +++++-----
 drivers/media/dvb/ttpci/budget-patch.c            |   20 +++--
 drivers/media/dvb/ttpci/budget.c                  |   49 ++++++-----
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |   62 ++++++++------
 drivers/media/video/cx88/cx88-dvb.c               |    8 +-
 drivers/media/video/saa7134/saa7134-dvb.c         |   33 ++++----
 109 files changed, 806 insertions(+), 810 deletions(-)

-- 
1.7.8.352.g876a6

