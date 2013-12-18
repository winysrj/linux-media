Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38737 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab3LRP7p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 10:59:45 -0500
Received: from dyn3-82-128-185-139.psoas.suomi.net ([82.128.185.139] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1VtJXE-0007iE-QC
	for linux-media@vger.kernel.org; Wed, 18 Dec 2013 17:59:44 +0200
Message-ID: <52B1C670.6020700@iki.fi>
Date: Wed, 18 Dec 2013 17:59:44 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL v2] PCTV 461e / M88DS3103 / M88TS2022
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is just same PULL request than earlier, but now with a 2 new patches 
to correct some brand new checkpatch.pl checks...

regards
Antti


The following changes since commit 675722b0e3917c6c917f1aa5f6d005cd3a0479f5:

   Merge branch 'upstream-fixes' into patchwork (2013-12-13 05:04:00 -0200)

are available in the git repository at:


   git://linuxtv.org/anttip/media_tree.git pctv_461e

for you to fetch changes up to 569a6ed6e1c047ec87a66190ace174f40aade168:

   m88ts2022: fix some style issues reported by checkpatch.pl 
(2013-12-18 17:46:45 +0200)

----------------------------------------------------------------
Antti Palosaari (20):
       em28xx: add support for Empia EM28178
       a8293: add small sleep in order to settle LNB voltage
       Montage M88DS3103 DVB-S/S2 demodulator driver
       Montage M88TS2022 silicon tuner driver
       em28xx: add support for PCTV DVB-S2 Stick (461e) [2013:0258]
       MAINTAINERS: add M88DS3103
       MAINTAINERS: add M88TS2022
       m88ts2022: do not use dynamic stack allocation
       m88ds3103: do not use dynamic stack allocation
       m88ds3103: use I2C mux for tuner I2C adapter
       m88ds3103: use kernel macro to round division
       m88ds3103: fix TS mode config
       m88ts2022: reimplement synthesizer calculations
       m88ds3103: remove unneeded AGC from inittab
       m88ds3103: add default value for reg 56
       m88ds3103: I/O optimize inittab write
       m88ts2022: convert to Kernel I2C driver model
       m88ds3103: fix possible i2c deadlock
       m88ds3103: fix some style issues reported by checkpatch.pl
       m88ts2022: fix some style issues reported by checkpatch.pl

  MAINTAINERS                                  |   20 ++
  drivers/media/dvb-frontends/Kconfig          |    7 +
  drivers/media/dvb-frontends/Makefile         |    1 +
  drivers/media/dvb-frontends/a8293.c          |    2 +
  drivers/media/dvb-frontends/m88ds3103.c      | 1311 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/dvb-frontends/m88ds3103.h      |  114 ++++++++++++
  drivers/media/dvb-frontends/m88ds3103_priv.h |  215 ++++++++++++++++++++++
  drivers/media/tuners/Kconfig                 |    7 +
  drivers/media/tuners/Makefile                |    1 +
  drivers/media/tuners/m88ts2022.c             |  674 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/tuners/m88ts2022.h             |   54 ++++++
  drivers/media/tuners/m88ts2022_priv.h        |   34 ++++
  drivers/media/usb/em28xx/Kconfig             |    2 +
  drivers/media/usb/em28xx/em28xx-cards.c      |   40 ++++
  drivers/media/usb/em28xx/em28xx-core.c       |    9 +-
  drivers/media/usb/em28xx/em28xx-dvb.c        |   54 ++++++
  drivers/media/usb/em28xx/em28xx-input.c      |    2 +
  drivers/media/usb/em28xx/em28xx-reg.h        |    1 +
  drivers/media/usb/em28xx/em28xx.h            |    1 +
  19 files changed, 2546 insertions(+), 3 deletions(-)
  create mode 100644 drivers/media/dvb-frontends/m88ds3103.c
  create mode 100644 drivers/media/dvb-frontends/m88ds3103.h
  create mode 100644 drivers/media/dvb-frontends/m88ds3103_priv.h
  create mode 100644 drivers/media/tuners/m88ts2022.c
  create mode 100644 drivers/media/tuners/m88ts2022.h
  create mode 100644 drivers/media/tuners/m88ts2022_priv.h

-- 
http://palosaari.fi/
