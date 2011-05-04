Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:39693 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981Ab1EDUyT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 16:54:19 -0400
Message-ID: <4DC1BCF9.4040302@iki.fi>
Date: Wed, 04 May 2011 23:54:17 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Steve Kerrison <steve@stevekerrison.com>
Subject: [GIT PULL FOR 2.6.40] PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moikka Mauro,

PULL following patches for the 2.6.40. I want these master as soon as 
possible to get some test reports before Kernel 2.6.40 merge.

This patch series add support PCTV nanoStick T2 290e stick, which is 
first DVB-T2 capable computer receiver.

Main part of this patch series is new demod driver for Sony CXD2820R. 
Other big part is multi frontend (MFE) support for em28xx driver. I 
don't have any other MFE device, so I cannot say if it is implemented 
correctly or not. At least it seems to work. MFE locking is done in 
demod driver. If there is some problems let me know and I will try to 
fix those - I think there is no such big major problems still.

I didn't implemented proper DVB-T2 support for DVB API, since it seems 
to be rather complex and needs some learning. Thus, I made it working 
automatically something like try DVB-T, if no lock, fall-back to DVB-T2. 
Error and trial. And some abuse :i

Special thanks to Steve Kerrison for his help, testing, talking, 
reviewing code and improving driver!

t. Antti


The following changes since commit d9954d8547181f9a6a23f835cc1413732700b785:

   Merge branch 'linus' into staging/for_v2.6.40 (2011-04-04 16:04:30 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git pctv_290e_new

Antti Palosaari (7):
       tda18271: add DVB-C support
       em28xx: Multi Frontend (MFE) support
       em28xx: add support for EM28174 chip
       Sony CXD2820R DVB-T/T2/C demodulator driver
       Add support for PCTV nanoStick T2 290e [2013:024f]
       cxd2820r: whitespace fix
       cxd2820r: switch automatically between DVB-T and DVB-T2

Steve Kerrison (2):
       cxd2820r: make C, T, T2 and core components as linked objects
       em28xx: Disable audio for EM28174

  drivers/media/common/tuners/tda18271-fe.c   |    4 +
  drivers/media/dvb/frontends/Kconfig         |    7 +
  drivers/media/dvb/frontends/Makefile        |    3 +
  drivers/media/dvb/frontends/cxd2820r.h      |  118 ++++
  drivers/media/dvb/frontends/cxd2820r_c.c    |  338 ++++++++++
  drivers/media/dvb/frontends/cxd2820r_core.c |  914 
+++++++++++++++++++++++++++
  drivers/media/dvb/frontends/cxd2820r_priv.h |  178 ++++++
  drivers/media/dvb/frontends/cxd2820r_t.c    |  449 +++++++++++++
  drivers/media/dvb/frontends/cxd2820r_t2.c   |  423 +++++++++++++
  drivers/media/video/em28xx/Kconfig          |    1 +
  drivers/media/video/em28xx/em28xx-cards.c   |   28 +
  drivers/media/video/em28xx/em28xx-core.c    |    9 +-
  drivers/media/video/em28xx/em28xx-dvb.c     |  140 +++-
  drivers/media/video/em28xx/em28xx-i2c.c     |    2 +-
  drivers/media/video/em28xx/em28xx-reg.h     |    1 +
  drivers/media/video/em28xx/em28xx.h         |    1 +
  16 files changed, 2578 insertions(+), 38 deletions(-)
  create mode 100644 drivers/media/dvb/frontends/cxd2820r.h
  create mode 100644 drivers/media/dvb/frontends/cxd2820r_c.c
  create mode 100644 drivers/media/dvb/frontends/cxd2820r_core.c
  create mode 100644 drivers/media/dvb/frontends/cxd2820r_priv.h
  create mode 100644 drivers/media/dvb/frontends/cxd2820r_t.c
  create mode 100644 drivers/media/dvb/frontends/cxd2820r_t2.c


-- 
http://palosaari.fi/
