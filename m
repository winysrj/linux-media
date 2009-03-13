Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47686 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760100AbZCMQox (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 12:44:53 -0400
Date: Fri, 13 Mar 2009 13:43:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: [GIT PATCHES for 2.6.29-rc8] V4L/DVB fixes
Message-ID: <20090313134333.563c0565@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

With the following fixes for 2.6.29-rc8:

   - dst: Report tuning algorithm correctly.
   - m5602-s5k4aa: Split up the initial sensor probe in chunks to avoid breakage;
   - stb0899: fix a bug on stb0899_send_diseqc_burst by using Diseqc 3/3 mode to send data;
   - stb0899: Bug: by using signed types, Offsets and range can be negative;
   - stb0899: Bug: For legacy applications, stv0899 performs search only first time after insmod;
   - stb6100: init fix, the call to stb6100_set_bandwidth needs an argument;
   - tvaudio: Avoid breakage with tda9874a, due to the access of a shadow register
	      that would otherwise be out of range;
   - zl10353: i2c_gate_ctrl bug fix;
   - zoran Kconfig: auto-select bt866 needed for AverMedia 6 Eyes;

Cheers,
Mauro.

---

 drivers/media/dvb/bt8xx/dst.c                  |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c      |    7 ++++---
 drivers/media/dvb/frontends/stb0899_algo.c     |   14 +++++++-------
 drivers/media/dvb/frontends/stb0899_drv.c      |    2 +-
 drivers/media/dvb/frontends/stb0899_priv.h     |   12 ++++--------
 drivers/media/dvb/frontends/stb6100.c          |    4 ++--
 drivers/media/dvb/frontends/zl10353.c          |    2 +-
 drivers/media/dvb/frontends/zl10353.h          |    3 +++
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c |    6 +++++-
 drivers/media/video/saa7134/saa7134-dvb.c      |    1 +
 drivers/media/video/tvaudio.c                  |    2 +-
 drivers/media/video/zoran/Kconfig              |    1 +
 12 files changed, 31 insertions(+), 25 deletions(-)

Antti Palosaari (1):
      V4L/DVB (10972): zl10353: i2c_gate_ctrl bug fix

Gregory Lardiere (1):
      V4L/DVB (10789): m5602-s5k4aa: Split up the initial sensor probe in chunks.

Hans Werner (1):
      V4L/DVB (10977): STB6100 init fix, the call to stb6100_set_bandwidth needs an argument

Igor M. Liplianin (1):
      V4L/DVB (10976): Bug fix: For legacy applications stv0899 performs search only first time after insmod.

Manu Abraham (1):
      V4L/DVB (10975): Bug: Use signed types, Offsets and range can be negative

Matthias Schwarzzot (1):
      V4L/DVB (10978): Report tuning algorith correctly

Mauro Carvalho Chehab (1):
      V4L/DVB (10834): zoran: auto-select bt866 for AverMedia 6 Eyes

Sigmund Augdal (1):
      V4L/DVB (10974): Use Diseqc 3/3 mode to send data

Vitaly Wool (1):
      V4L/DVB (10832): tvaudio: Avoid breakage with tda9874a

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
