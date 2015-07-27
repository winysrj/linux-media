Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44602 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbbG0LWq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 07:22:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/6] ZyDAS ZD1301 DVB-T demod + USB IF driver
Date: Mon, 27 Jul 2015 14:22:04 +0300
Message-Id: <1437996130-23735-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ZyDAS ZD1301 is chip having integrated DVB USB interface and DVB-T
demodulator. That is very old chipset, ~10 years or so, having
likely near zero users, so I don't even understand why I wasted time
for this :I It is 2nd DVB device I bought, that time those sticks
very even rather expensive having price ticket near 100 euros. Since
then it has been on my drawer waiting for some spare time... 

Antti

Antti Palosaari (6):
  mt2060: add i2c bindings
  mt2060: add param to split long i2c writes
  zd1301_demod: ZyDAS ZD1301 DVB-T demodulator driver
  MAINTAINERS: add zd1301_demod driver
  zd1301: ZyDAS ZD1301 DVB USB interface driver
  MAINTAINERS: add zd1301 DVB USB interface driver

 MAINTAINERS                                |  20 ++
 drivers/media/dvb-core/dvb-usb-ids.h       |   1 +
 drivers/media/dvb-frontends/Kconfig        |   7 +
 drivers/media/dvb-frontends/Makefile       |   1 +
 drivers/media/dvb-frontends/zd1301_demod.c | 535 +++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/zd1301_demod.h |  55 +++
 drivers/media/tuners/mt2060.c              | 104 +++++-
 drivers/media/tuners/mt2060.h              |  23 ++
 drivers/media/tuners/mt2060_priv.h         |   3 +
 drivers/media/usb/dvb-usb-v2/Kconfig       |   8 +
 drivers/media/usb/dvb-usb-v2/Makefile      |   3 +
 drivers/media/usb/dvb-usb-v2/zd1301.c      | 276 +++++++++++++++
 drivers/media/usb/dvb-usb-v2/zd1301.h      |  36 ++
 13 files changed, 1068 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/zd1301_demod.c
 create mode 100644 drivers/media/dvb-frontends/zd1301_demod.h
 create mode 100644 drivers/media/usb/dvb-usb-v2/zd1301.c
 create mode 100644 drivers/media/usb/dvb-usb-v2/zd1301.h

-- 
http://palosaari.fi/

