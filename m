Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39241 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508AbcBDP6r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 10:58:47 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/7] Don't let G_PROPERTY interfere at tuner locking
Date: Thu,  4 Feb 2016 13:57:25 -0200
Message-Id: <cover.1454600641.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yesterday, I used an old hardware to test a VB2 issue with DVB. On the
tests, I noticed that some very old drivers don't play nice if either
G_PROPERTY or GET_FRONTEND is called while the driver didn't lock.

The driver simply overrides the tuning cache with some random data,
causing tune to fail. This is wrong, and frontend drivers should be fixed
with patches like this one:
	https://patchwork.linuxtv.org/patch/32813/

Yet, the core should be smarter to not let the driver to not tune due to
such driver bugs.

So, make the core more robust by passing a separate DTV properties
struct to the drivers on get_frontend(). This way, if the driver updates
it with bogus values, it won't interere with digital TV zig-zag routines.

Please also notice that drivers may simply update the cache either
at set_frontend(), at get_status() or via some driver kthread. This
should work too with the new logic.

Tested on my device with tda1004x with the fix reverted, and with 
the fix applied.

Mauro Carvalho Chehab (7):
  [media] dvb_frontend: add props argument to dtv_get_frontend()
  [media] siano: remove get_frontend stub
  [media] friio-fe: remove get_frontend() callback
  [media] lgs8gxx: don't export get_frontend() callback
  [media] mb86a20s: get rid of dummy get_frontend()
  [media] dvb_frontend: pass the props cache to get_frontend() as arg
  [media] dvb_frontend: Don't let drivers to trash data at cache

 drivers/media/common/siano/smsdvb-main.c      |  7 ---
 drivers/media/dvb-core/dvb_frontend.c         | 55 +++++++++++++-------
 drivers/media/dvb-core/dvb_frontend.h         |  3 +-
 drivers/media/dvb-frontends/af9013.c          |  4 +-
 drivers/media/dvb-frontends/af9033.c          |  4 +-
 drivers/media/dvb-frontends/as102_fe.c        |  4 +-
 drivers/media/dvb-frontends/atbm8830.c        |  4 +-
 drivers/media/dvb-frontends/au8522_dig.c      |  4 +-
 drivers/media/dvb-frontends/cx22700.c         |  4 +-
 drivers/media/dvb-frontends/cx22702.c         |  4 +-
 drivers/media/dvb-frontends/cx24110.c         |  4 +-
 drivers/media/dvb-frontends/cx24117.c         |  4 +-
 drivers/media/dvb-frontends/cx24120.c         |  4 +-
 drivers/media/dvb-frontends/cx24123.c         |  4 +-
 drivers/media/dvb-frontends/cxd2820r_c.c      |  4 +-
 drivers/media/dvb-frontends/cxd2820r_core.c   |  9 ++--
 drivers/media/dvb-frontends/cxd2820r_priv.h   |  9 ++--
 drivers/media/dvb-frontends/cxd2820r_t.c      |  4 +-
 drivers/media/dvb-frontends/cxd2820r_t2.c     |  6 +--
 drivers/media/dvb-frontends/cxd2841er.c       |  4 +-
 drivers/media/dvb-frontends/dib3000mb.c       |  9 ++--
 drivers/media/dvb-frontends/dib3000mc.c       |  6 +--
 drivers/media/dvb-frontends/dib7000m.c        |  6 +--
 drivers/media/dvb-frontends/dib7000p.c        |  6 +--
 drivers/media/dvb-frontends/dib8000.c         | 75 ++++++++++++++-------------
 drivers/media/dvb-frontends/dib9000.c         | 23 ++++----
 drivers/media/dvb-frontends/dvb_dummy_fe.c    |  7 ++-
 drivers/media/dvb-frontends/hd29l2.c          |  4 +-
 drivers/media/dvb-frontends/l64781.c          |  4 +-
 drivers/media/dvb-frontends/lg2160.c          | 62 +++++++++++-----------
 drivers/media/dvb-frontends/lgdt3305.c        |  4 +-
 drivers/media/dvb-frontends/lgdt3306a.c       |  4 +-
 drivers/media/dvb-frontends/lgdt330x.c        |  5 +-
 drivers/media/dvb-frontends/lgs8gl5.c         |  5 +-
 drivers/media/dvb-frontends/lgs8gxx.c         | 13 +----
 drivers/media/dvb-frontends/m88ds3103.c       |  4 +-
 drivers/media/dvb-frontends/m88rs2000.c       |  5 +-
 drivers/media/dvb-frontends/mb86a20s.c        | 11 ----
 drivers/media/dvb-frontends/mt312.c           |  4 +-
 drivers/media/dvb-frontends/mt352.c           |  4 +-
 drivers/media/dvb-frontends/or51132.c         |  4 +-
 drivers/media/dvb-frontends/rtl2830.c         |  4 +-
 drivers/media/dvb-frontends/rtl2832.c         |  4 +-
 drivers/media/dvb-frontends/s5h1409.c         |  4 +-
 drivers/media/dvb-frontends/s5h1411.c         |  4 +-
 drivers/media/dvb-frontends/s5h1420.c         |  4 +-
 drivers/media/dvb-frontends/s921.c            |  4 +-
 drivers/media/dvb-frontends/stb0899_drv.c     |  4 +-
 drivers/media/dvb-frontends/stb6100.c         |  2 +-
 drivers/media/dvb-frontends/stv0297.c         |  4 +-
 drivers/media/dvb-frontends/stv0299.c         |  4 +-
 drivers/media/dvb-frontends/stv0367.c         |  8 +--
 drivers/media/dvb-frontends/stv0900_core.c    |  4 +-
 drivers/media/dvb-frontends/tc90522.c         | 10 ++--
 drivers/media/dvb-frontends/tda10021.c        |  4 +-
 drivers/media/dvb-frontends/tda10023.c        |  4 +-
 drivers/media/dvb-frontends/tda10048.c        |  4 +-
 drivers/media/dvb-frontends/tda1004x.c        |  4 +-
 drivers/media/dvb-frontends/tda10071.c        |  4 +-
 drivers/media/dvb-frontends/tda10086.c        |  4 +-
 drivers/media/dvb-frontends/tda8083.c         |  4 +-
 drivers/media/dvb-frontends/ves1820.c         |  4 +-
 drivers/media/dvb-frontends/ves1x93.c         |  4 +-
 drivers/media/dvb-frontends/zl10353.c         |  4 +-
 drivers/media/pci/bt8xx/dst.c                 |  4 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c |  4 +-
 drivers/media/usb/dvb-usb/af9005-fe.c         |  4 +-
 drivers/media/usb/dvb-usb/dtt200u-fe.c        |  5 +-
 drivers/media/usb/dvb-usb/friio-fe.c          | 37 ++++++-------
 69 files changed, 281 insertions(+), 283 deletions(-)

-- 
2.5.0


