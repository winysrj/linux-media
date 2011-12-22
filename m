Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217Ab1LVLUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 06:20:23 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBMBKMQN006749
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 06:20:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC v3 00/27] DVBv5 improvements at the drivers
Date: Thu, 22 Dec 2011 09:19:48 -0200
Message-Id: <1324552816-25704-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series were originated from Manu's changes to add support
for DELSYS. It contains two parts.

The first part (5 patches) adds a better way to support DVB-C Annex C, as
proposed by Manu: to use a separate delivery system for Annex C.

At the second part, all tuner drivers were changed to use the
DVBv5 properties instead of the old DVBv3 properties that has
limited support for the new delivery systems.

Tuners implement a callback called set_params(), used to set
the tuner properties. This struct works fine for ATSC, DVB-T/C/S,
but it is not prepared for any other delivery system.

This is bad, as it requires a somewhat complex logic at the
dvb core in order to fake the new delivery systems in order to
behave like the 4 original ones.

It also requires that demod drivers for the new delivery systems
to fill a wrong value at dvb_frontend_ops::info::type.

On this patch series, the demods are kept untouched (well, except
for one patch that renames the set_frontend callback to another
name, in order to help migrating demods to the new way).

What is there is a series of patches that change all tuners to
work directly with the DVBv5 way. This shouldn't be a problem for
applications calling via DVBv3, as the dvb core will handle the
compatibility bits.

As a side effect of this change, several tuners will now support
DVB-T2, ISDB-T, etc, making easier to add support for those new
delivery systems at the bridge drivers for the demods that support it.

Please review.

Regards,
Mauro


Manu Abraham (1):
  [media] DVB: Use a unique delivery system identifier for DVBC_ANNEX_C

Mauro Carvalho Chehab (27):
  [media] Update documentation to reflect DVB-C Annex A/C support
  [media] Remove Annex A/C selection via roll-off factor
  [media] drx-k: report the supported delivery systems
  [media] tda10023: Don't use a magic numbers for QAM modulation
  [media] tda10023: add support for DVB-C Annex C
  [media] tda10021: Don't use a magic numbers for QAM modulation
  [media] tda10021: Add support for DVB-C Annex C
  [media] Rename set_frontend fops to set_frontend_legacy
  [media] dvb_core: estimate bw for all non-terrestial systems
  [media] qt1010: remove fake implementaion of get_bandwidth()
  [media] mt2060: remove fake implementaion of get_bandwidth()
  [media] mt2031: remove fake implementaion of get_bandwidth()
  [media] mc44s803: use DVBv5 parameters
  [media] max2165: use DVBv5 parameters
  [media] mt2266: use DVBv5 parameters
  [media] mxl5005s: use DVBv5 parameters
  [media] mxl5005s: fix: don't discard bandwidth changes
  [media] mxl5007t: use DVBv5 parameters
  [media] tda18218: use DVBv5 parameters
  [media] tda18271: add support for QAM 7 MHz map
  [media] tda18271-fe: use DVBv5 parameters
  [media] tda827x: use DVBv5 parameters
  [media] tuner-xc2028: use DVBv5 parameters
  [media] xc4000: use DVBv5 parameters
  [media] tuner-simple: get rid of DVBv3 params at set_params call
  [media] dvb-bt8xx: use DVBv5 parameters
  [media] dvb-pll: use DVBv5 parameters

 Documentation/DocBook/media/dvb/dvbproperty.xml |   11 +-
 Documentation/DocBook/media/dvb/frontend.xml    |    4 +-
 drivers/media/common/tuners/max2165.c           |   60 ++++++----
 drivers/media/common/tuners/mc44s803.c          |    7 +-
 drivers/media/common/tuners/mt2060.c            |   12 +--
 drivers/media/common/tuners/mt2060_priv.h       |    1 -
 drivers/media/common/tuners/mt2131.c            |   17 +---
 drivers/media/common/tuners/mt2131_priv.h       |    1 -
 drivers/media/common/tuners/mt2266.c            |   20 ++--
 drivers/media/common/tuners/mxl5005s.c          |   65 +++++------
 drivers/media/common/tuners/mxl5007t.c          |   53 ++++-----
 drivers/media/common/tuners/qt1010.c            |   16 +--
 drivers/media/common/tuners/qt1010_priv.h       |    1 -
 drivers/media/common/tuners/tda18218.c          |   15 +--
 drivers/media/common/tuners/tda18271-fe.c       |   74 ++++++-------
 drivers/media/common/tuners/tda18271-maps.c     |    4 +
 drivers/media/common/tuners/tda18271.h          |    1 +
 drivers/media/common/tuners/tda827x.c           |   49 +++++----
 drivers/media/common/tuners/tuner-simple.c      |   63 ++++++++---
 drivers/media/common/tuners/tuner-xc2028.c      |   83 ++++++--------
 drivers/media/common/tuners/xc4000.c            |   97 +++++++---------
 drivers/media/common/tuners/xc5000.c            |  137 +++++++++-------------
 drivers/media/dvb/bt8xx/dst.c                   |    8 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c             |   31 +++---
 drivers/media/dvb/dvb-core/dvb_frontend.c       |   52 ++++++++-
 drivers/media/dvb/dvb-core/dvb_frontend.h       |    3 +-
 drivers/media/dvb/dvb-usb/af9005-fe.c           |    2 +-
 drivers/media/dvb/dvb-usb/cinergyT2-fe.c        |    2 +-
 drivers/media/dvb/dvb-usb/dtt200u-fe.c          |    2 +-
 drivers/media/dvb/dvb-usb/friio-fe.c            |    2 +-
 drivers/media/dvb/dvb-usb/gp8psk-fe.c           |    2 +-
 drivers/media/dvb/dvb-usb/mxl111sf-demod.c      |    2 +-
 drivers/media/dvb/dvb-usb/vp702x-fe.c           |    2 +-
 drivers/media/dvb/dvb-usb/vp7045-fe.c           |    2 +-
 drivers/media/dvb/firewire/firedtv-fe.c         |    2 +-
 drivers/media/dvb/frontends/af9013.c            |    2 +-
 drivers/media/dvb/frontends/atbm8830.c          |    2 +-
 drivers/media/dvb/frontends/au8522_dig.c        |    2 +-
 drivers/media/dvb/frontends/bcm3510.c           |    2 +-
 drivers/media/dvb/frontends/cx22700.c           |    2 +-
 drivers/media/dvb/frontends/cx22702.c           |    2 +-
 drivers/media/dvb/frontends/cx24110.c           |    2 +-
 drivers/media/dvb/frontends/cx24116.c           |    2 +-
 drivers/media/dvb/frontends/cx24123.c           |    2 +-
 drivers/media/dvb/frontends/cxd2820r_core.c     |    2 +-
 drivers/media/dvb/frontends/dib3000mb.c         |    2 +-
 drivers/media/dvb/frontends/dib3000mc.c         |    2 +-
 drivers/media/dvb/frontends/dib7000m.c          |    2 +-
 drivers/media/dvb/frontends/dib7000p.c          |    2 +-
 drivers/media/dvb/frontends/dib8000.c           |    2 +-
 drivers/media/dvb/frontends/dib9000.c           |    2 +-
 drivers/media/dvb/frontends/drxd_hard.c         |    2 +-
 drivers/media/dvb/frontends/drxk_hard.c         |   47 +++++++-
 drivers/media/dvb/frontends/ds3000.c            |    2 +-
 drivers/media/dvb/frontends/dvb-pll.c           |   61 ++++++-----
 drivers/media/dvb/frontends/dvb_dummy_fe.c      |    6 +-
 drivers/media/dvb/frontends/ec100.c             |    2 +-
 drivers/media/dvb/frontends/it913x-fe.c         |    2 +-
 drivers/media/dvb/frontends/l64781.c            |    2 +-
 drivers/media/dvb/frontends/lgdt3305.c          |    4 +-
 drivers/media/dvb/frontends/lgdt330x.c          |    4 +-
 drivers/media/dvb/frontends/lgs8gl5.c           |    2 +-
 drivers/media/dvb/frontends/lgs8gxx.c           |    2 +-
 drivers/media/dvb/frontends/mb86a20s.c          |    2 +-
 drivers/media/dvb/frontends/mt312.c             |    2 +-
 drivers/media/dvb/frontends/mt352.c             |    2 +-
 drivers/media/dvb/frontends/nxt200x.c           |    2 +-
 drivers/media/dvb/frontends/nxt6000.c           |    2 +-
 drivers/media/dvb/frontends/or51132.c           |    2 +-
 drivers/media/dvb/frontends/or51211.c           |    2 +-
 drivers/media/dvb/frontends/s5h1409.c           |    2 +-
 drivers/media/dvb/frontends/s5h1411.c           |    2 +-
 drivers/media/dvb/frontends/s5h1420.c           |    2 +-
 drivers/media/dvb/frontends/s5h1432.c           |    2 +-
 drivers/media/dvb/frontends/s921.c              |    2 +-
 drivers/media/dvb/frontends/si21xx.c            |    2 +-
 drivers/media/dvb/frontends/sp8870.c            |    2 +-
 drivers/media/dvb/frontends/sp887x.c            |    2 +-
 drivers/media/dvb/frontends/stv0288.c           |    2 +-
 drivers/media/dvb/frontends/stv0297.c           |    2 +-
 drivers/media/dvb/frontends/stv0299.c           |    2 +-
 drivers/media/dvb/frontends/stv0367.c           |    4 +-
 drivers/media/dvb/frontends/tda10021.c          |  108 ++++++++++++++-----
 drivers/media/dvb/frontends/tda10023.c          |  100 +++++++++++++----
 drivers/media/dvb/frontends/tda10048.c          |    2 +-
 drivers/media/dvb/frontends/tda1004x.c          |    4 +-
 drivers/media/dvb/frontends/tda10071.c          |    2 +-
 drivers/media/dvb/frontends/tda10086.c          |    2 +-
 drivers/media/dvb/frontends/tda18271c2dd.c      |   44 +++----
 drivers/media/dvb/frontends/tda8083.c           |    2 +-
 drivers/media/dvb/frontends/ves1820.c           |    2 +-
 drivers/media/dvb/frontends/ves1x93.c           |    2 +-
 drivers/media/dvb/frontends/zl10353.c           |    2 +-
 drivers/media/dvb/siano/smsdvb.c                |    2 +-
 drivers/media/dvb/ttpci/av7110.c                |    2 +-
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c        |    4 +-
 drivers/media/video/tlg2300/pd-dvb.c            |    2 +-
 drivers/staging/media/as102/as102_fe.c          |    2 +-
 include/linux/dvb/frontend.h                    |    9 +-
 99 files changed, 766 insertions(+), 636 deletions(-)

-- 
1.7.8.352.g876a6

