Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab2AAULY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jan 2012 15:11:24 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q01KBNua021905
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 1 Jan 2012 15:11:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/9] dvb_frontend: Don't rely on drivers filling ops->info.type
Date: Sun,  1 Jan 2012 18:11:09 -0200
Message-Id: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is likely the last patch series from my series of DVB cleanups.
I still intend to work on DRX-K frontend merge patch, but this will
need to wait until my return to my home town. Of course, if you're
hurry with this, patches are welcome.

This series changes dvb_frontend to use ops->delsys instead of ops->info.type,
as the source for the frontend support. With this series:

1) the first delivery system is reported as info.type for DVBv3 apps;
2) all subsequent checks are made against the current delivery system
   (c->delivery_system);
3) An attempt to use an un-suported delivery system will either return
   an error, or enter into the emulation mode, if the frontend is
   using a newer delivery system.
4) Lots of cleanup at the cache sync logic. Now, a pure DVBv5 call
   shouldn't fill the DVBv3 structs. Still, as events are generated,
   the event will dynamically generate a DVBv3 compat struct.

The emulation logic is not perfect (but it were not perfect before this
patch series). The emulation will work worse for devices that have
support for different "ops->info.type", as there's no way for a DVBv3
application to work properly with those devices.

TODO:

There are a few things left to do, with regards to DVB frontend cleanup.
They're more related to the DVBv5 API, so they were out of the scope
of this series. Maybe some work for this upcoming year!

They are:

	1) Fix the capabilities flags. There are several capabilities
not reported, like several modulations, etc. There are not enough flags
for them. It was suggested that the delivery system (DTV_ENUM_DELSYS)
would be enough, but it doesn't seem so. For example, there are several
SYS_ATSC devices that only support VSB_8. So, we'll end by needing to
either extend the current way (but we lack bits) or to implement a DVBv5
way for that;

	2) The DVBv3 events call (FE_GET_EVENT) is not ok for
newer delivery system. We'll likely need to replace it by a DVBv5 way;

	3) The stats API needs to be extended. Delivery systems like
ISDB can report a per-layer set of statistics. This is currently not
supported. Also, it is desirable to get the stats together with a
set of other properties.

I think that both (2) and (3) could be solved by adding some new DVBv5
properties. So, we need a proposal for that. I did one for stats in the
past. Maybe it is time to return with that proposal.

So, application developers are warned to migrate to DVBv5. As a reference,
I've ported an existing zap application to use DVBv5, on my experimental
test tree:

	http://git.linuxtv.org/mchehab/experimental-v4l-utils.git/shortlog/refs/heads/dvb-utils

Anyway, this patch series is short ;)

Please test.

Happy New Year!
Mauro

Mauro Carvalho Chehab (9):
  [media] dvb: Initialize all cache values
  [media] dvb_frontend: Handle all possible DVBv3 values for bandwidth
  [media] dvb: move dvb_set_frontend logic into a separate routine
  [media] dvb_frontend: Don't use ops->info.type anymore
  [media] dvb_frontend: Fix DVBv3 emulation
  [media] dvb-core: Fix ISDB-T defaults
  [media] dvb: get rid of fepriv->parameters_in
  [media] dvb: deprecate the usage of ops->info.type
  [media] dvb: Remove ops->info.type from frontends

 Documentation/DocBook/media/dvb/frontend.xml |    4 +
 drivers/media/dvb/bt8xx/dst.c                |    5 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c    |  853 +++++++++++++++-----------
 drivers/media/dvb/dvb-usb/af9005-fe.c        |    1 -
 drivers/media/dvb/dvb-usb/cinergyT2-fe.c     |    1 -
 drivers/media/dvb/dvb-usb/dtt200u-fe.c       |    1 -
 drivers/media/dvb/dvb-usb/friio-fe.c         |    1 -
 drivers/media/dvb/dvb-usb/gp8psk-fe.c        |    1 -
 drivers/media/dvb/dvb-usb/mxl111sf-demod.c   |    1 -
 drivers/media/dvb/dvb-usb/vp702x-fe.c        |    1 -
 drivers/media/dvb/dvb-usb/vp7045-fe.c        |    1 -
 drivers/media/dvb/frontends/af9013.c         |    1 -
 drivers/media/dvb/frontends/atbm8830.c       |    1 -
 drivers/media/dvb/frontends/au8522_dig.c     |    1 -
 drivers/media/dvb/frontends/bcm3510.c        |    1 -
 drivers/media/dvb/frontends/cx22700.c        |    1 -
 drivers/media/dvb/frontends/cx22702.c        |    1 -
 drivers/media/dvb/frontends/cx24110.c        |    1 -
 drivers/media/dvb/frontends/cx24116.c        |    1 -
 drivers/media/dvb/frontends/cx24123.c        |    1 -
 drivers/media/dvb/frontends/cxd2820r_core.c  |    2 -
 drivers/media/dvb/frontends/dib3000mb.c      |    1 -
 drivers/media/dvb/frontends/dib3000mc.c      |    1 -
 drivers/media/dvb/frontends/dib7000m.c       |    1 -
 drivers/media/dvb/frontends/dib7000p.c       |    1 -
 drivers/media/dvb/frontends/dib8000.c        |    1 -
 drivers/media/dvb/frontends/dib9000.c        |    1 -
 drivers/media/dvb/frontends/drxd_hard.c      |    1 -
 drivers/media/dvb/frontends/drxk_hard.c      |    2 -
 drivers/media/dvb/frontends/ds3000.c         |    1 -
 drivers/media/dvb/frontends/dvb_dummy_fe.c   |    3 -
 drivers/media/dvb/frontends/ec100.c          |    1 -
 drivers/media/dvb/frontends/it913x-fe.c      |    1 -
 drivers/media/dvb/frontends/l64781.c         |    1 -
 drivers/media/dvb/frontends/lgdt3305.c       |    3 +-
 drivers/media/dvb/frontends/lgdt330x.c       |    2 -
 drivers/media/dvb/frontends/lgs8gl5.c        |    1 -
 drivers/media/dvb/frontends/lgs8gxx.c        |    1 -
 drivers/media/dvb/frontends/mb86a16.c        |    1 -
 drivers/media/dvb/frontends/mb86a20s.c       |    1 -
 drivers/media/dvb/frontends/mt312.c          |    1 -
 drivers/media/dvb/frontends/mt352.c          |    1 -
 drivers/media/dvb/frontends/nxt200x.c        |    1 -
 drivers/media/dvb/frontends/nxt6000.c        |    1 -
 drivers/media/dvb/frontends/or51132.c        |    1 -
 drivers/media/dvb/frontends/or51211.c        |    1 -
 drivers/media/dvb/frontends/s5h1409.c        |    1 -
 drivers/media/dvb/frontends/s5h1411.c        |    1 -
 drivers/media/dvb/frontends/s5h1420.c        |    1 -
 drivers/media/dvb/frontends/s5h1432.c        |    1 -
 drivers/media/dvb/frontends/s921.c           |    1 -
 drivers/media/dvb/frontends/si21xx.c         |    1 -
 drivers/media/dvb/frontends/sp8870.c         |    1 -
 drivers/media/dvb/frontends/sp887x.c         |    1 -
 drivers/media/dvb/frontends/stb0899_drv.c    |   20 +-
 drivers/media/dvb/frontends/stv0288.c        |    8 -
 drivers/media/dvb/frontends/stv0297.c        |    1 -
 drivers/media/dvb/frontends/stv0299.c        |    1 -
 drivers/media/dvb/frontends/stv0367.c        |    2 -
 drivers/media/dvb/frontends/stv0900_core.c   |    1 -
 drivers/media/dvb/frontends/stv090x.c        |    1 -
 drivers/media/dvb/frontends/tda10021.c       |    1 -
 drivers/media/dvb/frontends/tda10023.c       |    1 -
 drivers/media/dvb/frontends/tda10048.c       |    1 -
 drivers/media/dvb/frontends/tda1004x.c       |    2 -
 drivers/media/dvb/frontends/tda10071.c       |    1 -
 drivers/media/dvb/frontends/tda10086.c       |    1 -
 drivers/media/dvb/frontends/tda8083.c        |    1 -
 drivers/media/dvb/frontends/ves1820.c        |    1 -
 drivers/media/dvb/frontends/ves1x93.c        |    1 -
 drivers/media/dvb/frontends/zl10353.c        |    1 -
 drivers/media/dvb/pt1/va1j5jf8007s.c         |    1 -
 drivers/media/dvb/pt1/va1j5jf8007t.c         |    1 -
 drivers/media/dvb/siano/smsdvb.c             |    1 -
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c     |    2 -
 drivers/media/video/tlg2300/pd-dvb.c         |    1 -
 include/linux/dvb/frontend.h                 |    2 +-
 77 files changed, 508 insertions(+), 465 deletions(-)

-- 
1.7.8.352.g876a6

