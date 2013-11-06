Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33211 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab3KFR5r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 12:57:47 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/8] PCTV DVB-S2 Stick (461e) [2013:0258] driver
Date: Wed,  6 Nov 2013 19:57:27 +0200
Message-Id: <1383760655-11388-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch serie adds support for PCTV Systems latest DVB-S/S2 USB
stick, model numbered as 461e.

I found only German version of product page [1], maybe English is
coming soon as this is quite young device. Device looks 100% similar
than older PCTV DVB-S2 Stick 460e, but internally demodulator and tuner
are different.

There is two new Linux drivers for demod and tuner.
Montage M88DS3103 DVB-S/S2 demodulator driver
Montage M88TS2022 silicon tuner driver

M88DS3103 requires firmware which is available my LinuxTV project page [2].

That driver could be downloaded from my LinuxTV.org Git tree [3].

Feel free to test!

[1] http://www.pctvsystems.com/Products/ProductsEuropeAsia/Satelliteproducts/PCTVDVBS2Stick/tabid/236/language/de-DE/Default.aspx
[2] http://palosaari.fi/linux/v4l-dvb/firmware/M88DS3103/
[3] http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/pctv_461e


regards
Antti

Antti Palosaari (8):
  em28xx: add support for Empia EM28178
  a8293: add small sleep in order to settle LNB voltage
  Montage M88DS3103 DVB-S/S2 demodulator driver
  Montage M88TS2022 silicon tuner driver
  em28xx: add support for PCTV DVB-S2 Stick (461e) [2013:0258]
  m88ds3103: add parent for I2C adapter
  MAINTAINERS: add M88DS3103
  MAINTAINERS: add M88TS2022

 MAINTAINERS                                  |   20 +
 drivers/media/dvb-frontends/Kconfig          |    7 +
 drivers/media/dvb-frontends/Makefile         |    1 +
 drivers/media/dvb-frontends/a8293.c          |    2 +
 drivers/media/dvb-frontends/m88ds3103.c      | 1294 ++++++++++++++++++++++++++
 drivers/media/dvb-frontends/m88ds3103.h      |  108 +++
 drivers/media/dvb-frontends/m88ds3103_priv.h |  218 +++++
 drivers/media/tuners/Kconfig                 |    7 +
 drivers/media/tuners/Makefile                |    1 +
 drivers/media/tuners/m88ts2022.c             |  664 +++++++++++++
 drivers/media/tuners/m88ts2022.h             |   72 ++
 drivers/media/tuners/m88ts2022_priv.h        |   38 +
 drivers/media/usb/em28xx/Kconfig             |    2 +
 drivers/media/usb/em28xx/em28xx-cards.c      |   40 +
 drivers/media/usb/em28xx/em28xx-core.c       |    9 +-
 drivers/media/usb/em28xx/em28xx-dvb.c        |   49 +
 drivers/media/usb/em28xx/em28xx-input.c      |    2 +
 drivers/media/usb/em28xx/em28xx-reg.h        |    1 +
 drivers/media/usb/em28xx/em28xx.h            |    1 +
 19 files changed, 2533 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/m88ds3103.c
 create mode 100644 drivers/media/dvb-frontends/m88ds3103.h
 create mode 100644 drivers/media/dvb-frontends/m88ds3103_priv.h
 create mode 100644 drivers/media/tuners/m88ts2022.c
 create mode 100644 drivers/media/tuners/m88ts2022.h
 create mode 100644 drivers/media/tuners/m88ts2022_priv.h

-- 
1.8.4.2

