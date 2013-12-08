Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57560 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759949Ab3LHWby (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 17:31:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH REVIEW 00/18] M88DS3103 / M88TS2022 / PCTV 461e
Date: Mon,  9 Dec 2013 00:31:17 +0200
Message-Id: <1386541895-8634-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think these patches are now in a rather good shape and I will make PULL request soon.
I decided to convert M88TS2022 RF tuner to Kernel I2C driver model, which is new thing as there is no any other tuner driver using that model.

Testers are still wanted. Git tree is waiting for you:
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/pctv_461e

Antti

Antti Palosaari (18):
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

 MAINTAINERS                                  |   20 +
 drivers/media/dvb-frontends/Kconfig          |    7 +
 drivers/media/dvb-frontends/Makefile         |    1 +
 drivers/media/dvb-frontends/a8293.c          |    2 +
 drivers/media/dvb-frontends/m88ds3103.c      | 1314 ++++++++++++++++++++++++++
 drivers/media/dvb-frontends/m88ds3103.h      |  118 +++
 drivers/media/dvb-frontends/m88ds3103_priv.h |  219 +++++
 drivers/media/tuners/Kconfig                 |    7 +
 drivers/media/tuners/Makefile                |    1 +
 drivers/media/tuners/m88ts2022.c             |  678 +++++++++++++
 drivers/media/tuners/m88ts2022.h             |   58 ++
 drivers/media/tuners/m88ts2022_priv.h        |   38 +
 drivers/media/usb/em28xx/Kconfig             |    2 +
 drivers/media/usb/em28xx/em28xx-cards.c      |   40 +
 drivers/media/usb/em28xx/em28xx-core.c       |    9 +-
 drivers/media/usb/em28xx/em28xx-dvb.c        |   54 ++
 drivers/media/usb/em28xx/em28xx-input.c      |    2 +
 drivers/media/usb/em28xx/em28xx-reg.h        |    1 +
 drivers/media/usb/em28xx/em28xx.h            |    1 +
 19 files changed, 2569 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/m88ds3103.c
 create mode 100644 drivers/media/dvb-frontends/m88ds3103.h
 create mode 100644 drivers/media/dvb-frontends/m88ds3103_priv.h
 create mode 100644 drivers/media/tuners/m88ts2022.c
 create mode 100644 drivers/media/tuners/m88ts2022.h
 create mode 100644 drivers/media/tuners/m88ts2022_priv.h

-- 
1.8.4.2

