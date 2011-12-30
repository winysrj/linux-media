Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1L3PJP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:15 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9F9U026482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:15 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 00/94] Only use DVBv5 internally on frontend drivers
Date: Fri, 30 Dec 2011 13:06:57 -0200
Message-Id: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series comes after the previous series of 47 patches.
Basically, changes all DVB frontend drivers to work directly with
the DVBv5 structure. This warrants that all drivers will be
getting/setting frontend parameters on a consistent way, and opens
space for improving the DVB core, in order to avoid copying data
from/to the DVBv3 structs without need.

Most of the patches on this series are trivial changes. Yet, it
would be great to test them, in order to be sure that nothing broke.

The last patch in this series hide the DVBv3 parameters struct from the
frontend drivers, keeping them visible only to the dvb_core.
This helps to warrant that everything were ported, and that newer
patches won't re-introduce DVBv3 structs by mistake.

There aren't many cleanups inside the dvb_frontend.c yet. 

Before cleaning up the core, I intend to do some tests with a some
devices, in order to be sure that nothing broke with all those changes.

Test reports are welcome.

---
version 2:
- Improve descriptions of patches 1, 3 and 24, based on the
  Andreas feedback;

- Added 3 patches to the series:

  3e737d9 [media] s921: Properly report the delivery system
     Trivial fix. Without this one, the driver return SYS_UNDEFINED
     to a get_frontend() call.
	
  9d0bb55 dvb_frontend: Fix inversion breakage due to DVBv5 conversion
     Fixes inversion handling. The current code doesn't update the
     DVBv5 inside some tuning logic (frequency drifts aren't updated,
     nor inversion logic).

  c89c2e7 [media] dvb: don't require a parameter for get_frontend
     Just like set_frontend(), uses the DVBv5 cache for get fops.

Mauro Carvalho Chehab (94):
  [media] dvb-core: allow demods to specify the supported delsys
  [media] Rename set_frontend fops to set_frontend_legacy
  [media] dvb-core: add support for a DVBv5 get_frontend() callback
  [media] af9013: convert set_fontend to use DVBv5 parameters
  [media] atbm8830: convert set_fontend to new way and fix delivery
    system
  [media] au8522_dig: convert set_fontend to use DVBv5 parameters
  [media] bcm3510: convert set_fontend to use DVBv5 parameters
  [media] cx22700: convert set_fontend to use DVBv5 parameters
  [media] cx22702: convert set_fontend to use DVBv5 parameters
  [media] cx24110: convert set_fontend to use DVBv5 parameters
  [media] cx24116: report delivery system and cleanups
  [media] cx23123: remove an unused argument from
    cx24123_pll_writereg()
  [media] av7110: convert set_fontend to use DVBv5 parameters
  [media] cx23123: convert set_fontend to use DVBv5 parameters
  [media] cxd2820r: report delivery system and cleanups
  [media] dibx000: convert set_fontend to use DVBv5 parameters
  [media] dib9000: remove unused parameters
  [media] cx24113: cleanup: remove unused init
  [media] dib9000: Get rid of the remaining DVBv3 legacy stuff
  [media] dib3000mb: convert set_fontend to use DVBv5 parameters
  [media] dib8000: Remove the old DVBv3 struct from it and add delsys
  [media] dib9000: get rid of unused dvb_frontend_parameters
  [media] zl10353: convert set_fontend to use DVBv5 parameters
  [media] em28xx-dvb: don't initialize drx-d non-used fields with zero
  [media] drxd: convert set_fontend to use DVBv5 parameters
  [media] drxk: convert set_fontend to use DVBv5 parameters
  [media] ds3000: convert set_fontend to use DVBv5 parameters
  [media] dvb_dummy_fe: convert set_fontend to use DVBv5 parameters
  [media] ec100: convert set_fontend to use DVBv5 parameters
  [media] it913x-fe: convert set_fontend to use DVBv5 parameters
  [media] l64781: convert set_fontend to use DVBv5 parameters
  [media] lgs8gl5: convert set_fontend to use DVBv5 parameters
  [media] lgdt330x: convert set_fontend to use DVBv5 parameters
  [media] lgdt3305: convert set_fontend to use DVBv5 parameters
  [media] lgs8gxx: convert set_fontend to use DVBv5 parameters
  [media] vez1x93: convert set_fontend to use DVBv5 parameters
  [media] mb86a16: Add delivery system type at fe struct
  [media] mb86a20s: convert set_fontend to use DVBv5 parameters
  [media] mt352: convert set_fontend to use DVBv5 parameters
  [media] nxt6000: convert set_fontend to use DVBv5 parameters
  [media] s5h1432: convert set_fontend to use DVBv5 parameters
  [media] sp8870: convert set_fontend to use DVBv5 parameters
  [media] sp887x: convert set_fontend to use DVBv5 parameters
  [media] stv0367: convert set_fontend to use DVBv5 parameters
  [media] tda10048: convert set_fontend to use DVBv5 parameters
  [media] tda1004x: convert set_fontend to use DVBv5 parameters
  [media] s921: convert set_fontend to use DVBv5 parameters
  [media] mt312: convert set_fontend to use DVBv5 parameters
  [media] s5h1420: convert set_fontend to use DVBv5 parameters
  [media] si21xx: convert set_fontend to use DVBv5 parameters
  [media] stb0899: convert get_frontend to the new struct
  [media] stb6100: use get_frontend, instead of get_frontend_legacy()
  [media] stv0288: convert set_fontend to use DVBv5 parameters
  [media] stv0297: convert set_fontend to use DVBv5 parameters
  [media] stv0299: convert set_fontend to use DVBv5 parameters
  [media] stv900: convert set_fontend to use DVBv5 parameters
  [media] stv090x: use .delsys property, instead of get_property()
  [media] tda10021: convert set_fontend to use DVBv5 parameters
  [media] tda10023: convert set_fontend to use DVBv5 parameters
  [media] tda10071: convert set_fontend to use DVBv5 parameters
  [media] tda10086: convert set_fontend to use DVBv5 parameters
  [media] nxt200x: convert set_fontend to use DVBv5 parameters
  [media] or51132: convert set_fontend to use DVBv5 parameters
  [media] or51211: convert set_fontend to use DVBv5 parameters
  [media] s5h1409: convert set_fontend to use DVBv5 parameters
  [media] s55h1411: convert set_fontend to use DVBv5 parameters
  [media] tda8083: convert set_fontend to use DVBv5 parameters
  [media] vez1820: convert set_fontend to use DVBv5 parameters
  [media] staging/as102: convert set_fontend to use DVBv5 parameters
  [media] dst: convert set_fontend to use DVBv5 parameters
  [media] af9005-fe: convert set_fontend to use DVBv5 parameters
  [media] cinergyT2-fe: convert set_fontend to use DVBv5 parameters
  [media] dtt200u-fe: convert set_fontend to use DVBv5 parameters
  [media] friio-fe: convert set_fontend to use DVBv5 parameters
  [media] gp8psk-fe: convert set_fontend to use DVBv5 parameters
  [media] mxl111sf-demod: convert set_fontend to use DVBv5 parameters
  [media] vp702x-fe: convert set_fontend to use DVBv5 parameters
  [media] vp7045-fe: convert set_fontend to use DVBv5 parameters
  [media] firedtv: convert set_fontend to use DVBv5 parameters
  [media] siano: convert set_fontend to use DVBv5 parameters
  [media] ttusb-dec: convert set_fontend to use DVBv5 parameters
  [media] tlg2300: convert set_fontend to use DVBv5 parameters
  [media] dvb-core: remove get|set_frontend_legacy
  [media] dvb: simplify get_tune_settings() struct
  [media] dvb-core: Don't pass DVBv3 parameters on tune() fops
  [media] dvb: don't pass a DVBv3 parameter for search() fops
  [media] dvb: remove the track() fops
  [media] dvb-core: don't use fe_bandwidth_t on driver
  [media] dvb: don't use DVBv3 bandwidth macros
  cx23885-dvb: Remove a dirty hack that would require DVBv3
  [media] dvb-core: be sure that drivers won't use DVBv3 internally
  [media] s921: Properly report the delivery system
  dvb_frontend: Fix inversion breakage due to DVBv5 conversion
  [media] dvb: don't require a parameter for get_frontend

 drivers/media/common/tuners/mt2266.c         |    4 +-
 drivers/media/common/tuners/mxl5007t.c       |    5 +-
 drivers/media/common/tuners/tda18271-fe.c    |    7 +-
 drivers/media/common/tuners/tda827x.c        |   14 +--
 drivers/media/common/tuners/tuner-simple.c   |   12 +--
 drivers/media/common/tuners/xc4000.c         |   11 +--
 drivers/media/common/tuners/xc5000.c         |   12 +--
 drivers/media/dvb/bt8xx/dst.c                |   67 ++++++------
 drivers/media/dvb/bt8xx/dst_common.h         |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c    |  154 ++++++++++++++++----------
 drivers/media/dvb/dvb-core/dvb_frontend.h    |   22 +++-
 drivers/media/dvb/dvb-usb/af9005-fe.c        |  101 +++++++++---------
 drivers/media/dvb/dvb-usb/cinergyT2-fe.c     |   32 +++---
 drivers/media/dvb/dvb-usb/dtt200u-fe.c       |   22 ++--
 drivers/media/dvb/dvb-usb/friio-fe.c         |   28 +++---
 drivers/media/dvb/dvb-usb/gp8psk-fe.c        |   23 +----
 drivers/media/dvb/dvb-usb/mxl111sf-demod.c   |   39 +++----
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c   |    5 +-
 drivers/media/dvb/dvb-usb/vp702x-fe.c        |   19 +--
 drivers/media/dvb/dvb-usb/vp7045-fe.c        |   21 +---
 drivers/media/dvb/firewire/firedtv-avc.c     |   95 ++++++++--------
 drivers/media/dvb/firewire/firedtv-fe.c      |   31 ++----
 drivers/media/dvb/firewire/firedtv.h         |    4 +-
 drivers/media/dvb/frontends/af9013.c         |  110 +++++++++---------
 drivers/media/dvb/frontends/af9013_priv.h    |   26 ++--
 drivers/media/dvb/frontends/atbm8830.c       |   24 ++--
 drivers/media/dvb/frontends/au8522_dig.c     |   24 ++--
 drivers/media/dvb/frontends/bcm3510.c        |   17 ++-
 drivers/media/dvb/frontends/cx22700.c        |   48 +++++----
 drivers/media/dvb/frontends/cx22702.c        |   68 ++++++------
 drivers/media/dvb/frontends/cx24110.c        |   17 ++--
 drivers/media/dvb/frontends/cx24113.c        |    2 -
 drivers/media/dvb/frontends/cx24116.c        |   35 ++----
 drivers/media/dvb/frontends/cx24123.c        |   53 +++++-----
 drivers/media/dvb/frontends/cxd2820r_c.c     |    6 +-
 drivers/media/dvb/frontends/cxd2820r_core.c  |   36 +++---
 drivers/media/dvb/frontends/cxd2820r_priv.h  |   15 +--
 drivers/media/dvb/frontends/cxd2820r_t.c     |    6 +-
 drivers/media/dvb/frontends/cxd2820r_t2.c    |    6 +-
 drivers/media/dvb/frontends/dib3000mb.c      |  110 +++++++++----------
 drivers/media/dvb/frontends/dib3000mb_priv.h |    2 +-
 drivers/media/dvb/frontends/dib3000mc.c      |  129 +++++++++++----------
 drivers/media/dvb/frontends/dib7000m.c       |  133 ++++++++++++-----------
 drivers/media/dvb/frontends/dib7000p.c       |  121 +++++++++++----------
 drivers/media/dvb/frontends/dib8000.c        |    9 +-
 drivers/media/dvb/frontends/dib9000.c        |   35 +++---
 drivers/media/dvb/frontends/dibx000_common.h |   10 +--
 drivers/media/dvb/frontends/drxd.h           |    2 -
 drivers/media/dvb/frontends/drxd_hard.c      |   56 ++++------
 drivers/media/dvb/frontends/drxk_hard.c      |  123 +++++++--------------
 drivers/media/dvb/frontends/drxk_hard.h      |    2 +-
 drivers/media/dvb/frontends/ds3000.c         |   35 ++-----
 drivers/media/dvb/frontends/dvb-pll.c        |    7 +-
 drivers/media/dvb/frontends/dvb_dummy_fe.c   |   13 ++-
 drivers/media/dvb/frontends/ec100.c          |   17 ++--
 drivers/media/dvb/frontends/it913x-fe-priv.h |   64 ++++++------
 drivers/media/dvb/frontends/it913x-fe.c      |   77 +++++++------
 drivers/media/dvb/frontends/l64781.c         |  112 ++++++++++---------
 drivers/media/dvb/frontends/lgdt3305.c       |   91 ++++++++--------
 drivers/media/dvb/frontends/lgdt330x.c       |   22 ++--
 drivers/media/dvb/frontends/lgs8gl5.c        |   26 ++--
 drivers/media/dvb/frontends/lgs8gxx.c        |   23 ++--
 drivers/media/dvb/frontends/mb86a16.c        |    7 +-
 drivers/media/dvb/frontends/mb86a20s.c       |   28 +++--
 drivers/media/dvb/frontends/mt312.c          |   34 +++---
 drivers/media/dvb/frontends/mt352.c          |   60 +++++-----
 drivers/media/dvb/frontends/nxt200x.c        |   14 +-
 drivers/media/dvb/frontends/nxt6000.c        |   22 ++--
 drivers/media/dvb/frontends/or51132.c        |   32 +++---
 drivers/media/dvb/frontends/or51211.c        |   10 +-
 drivers/media/dvb/frontends/s5h1409.c        |   14 +-
 drivers/media/dvb/frontends/s5h1411.c        |   14 +-
 drivers/media/dvb/frontends/s5h1420.c        |   66 ++++++------
 drivers/media/dvb/frontends/s5h1432.c        |   27 ++---
 drivers/media/dvb/frontends/s921.c           |   22 ++--
 drivers/media/dvb/frontends/si21xx.c         |   19 +---
 drivers/media/dvb/frontends/sp8870.c         |   25 ++--
 drivers/media/dvb/frontends/sp887x.c         |   47 +++++---
 drivers/media/dvb/frontends/stb0899_drv.c    |   34 +-----
 drivers/media/dvb/frontends/stb6100.c        |    6 +-
 drivers/media/dvb/frontends/stv0288.c        |    7 +-
 drivers/media/dvb/frontends/stv0297.c        |   32 +++---
 drivers/media/dvb/frontends/stv0299.c        |   29 +++--
 drivers/media/dvb/frontends/stv0367.c        |  150 ++++++++++++-------------
 drivers/media/dvb/frontends/stv0900_core.c   |   45 +-------
 drivers/media/dvb/frontends/stv090x.c        |   27 +----
 drivers/media/dvb/frontends/tda10021.c       |   34 ++----
 drivers/media/dvb/frontends/tda10023.c       |   32 ++----
 drivers/media/dvb/frontends/tda10048.c       |   78 ++++++--------
 drivers/media/dvb/frontends/tda1004x.c       |  109 +++++++++---------
 drivers/media/dvb/frontends/tda10071.c       |    8 +-
 drivers/media/dvb/frontends/tda10086.c       |   59 +++++-----
 drivers/media/dvb/frontends/tda8083.c        |   16 ++-
 drivers/media/dvb/frontends/ves1820.c        |   20 ++--
 drivers/media/dvb/frontends/ves1x93.c        |   20 ++--
 drivers/media/dvb/frontends/zl10353.c        |  111 ++++++++----------
 drivers/media/dvb/pt1/va1j5jf8007s.c         |    4 +-
 drivers/media/dvb/pt1/va1j5jf8007t.c         |    4 +-
 drivers/media/dvb/siano/smsdvb.c             |   32 ++++--
 drivers/media/dvb/ttpci/av7110.c             |   11 +-
 drivers/media/dvb/ttpci/av7110.h             |    3 +-
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c     |   12 +-
 drivers/media/video/cx23885/cx23885-dvb.c    |   41 ++-----
 drivers/media/video/em28xx/em28xx-dvb.c      |   10 +-
 drivers/media/video/tlg2300/pd-common.h      |    2 +-
 drivers/media/video/tlg2300/pd-dvb.c         |   21 ++--
 drivers/staging/media/as102/as102_fe.c       |   74 ++++++------
 drivers/staging/media/as102/as10x_cmd.c      |    4 +-
 drivers/staging/media/as102/as10x_types.h    |    4 +-
 include/linux/dvb/frontend.h                 |    6 +-
 110 files changed, 1858 insertions(+), 2070 deletions(-)

-- 
1.7.8.352.g876a6

