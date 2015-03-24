Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44721 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbbCXVNJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 17:13:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/8] migrate ts2022 driver to ts2020
Date: Tue, 24 Mar 2015 23:12:05 +0200
Message-Id: <1427231533-4277-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add TS2022 support to TS2020 driver. Relative small changes were
needed. Add I2C binding to TS2020. Switch TS2022 users to TS2020
and finally drop obsolete TS2022.

Antti Palosaari (8):
  ts2020: add support for TS2022
  ts2020: implement I2C client bindings
  em28xx: switch PCTV 461e to ts2020 driver
  cx23885: switch ts2022 to ts2020 driver
  smipcie: switch ts2022 to ts2020 driver
  dvbsky: switch ts2022 to ts2020 driver
  m88ts2022: remove obsolete driver
  ts2020: do not use i2c_transfer() on sleep()

 MAINTAINERS                             |  10 -
 drivers/media/dvb-frontends/ts2020.c    | 302 +++++++++++++++--
 drivers/media/dvb-frontends/ts2020.h    |  25 +-
 drivers/media/pci/cx23885/Kconfig       |   1 -
 drivers/media/pci/cx23885/cx23885-dvb.c |  30 +-
 drivers/media/pci/smipcie/Kconfig       |   2 +-
 drivers/media/pci/smipcie/smipcie.c     |  12 +-
 drivers/media/tuners/Kconfig            |   8 -
 drivers/media/tuners/m88ts2022.c        | 579 --------------------------------
 drivers/media/tuners/m88ts2022.h        |  54 ---
 drivers/media/tuners/m88ts2022_priv.h   |  35 --
 drivers/media/usb/dvb-usb-v2/Kconfig    |   2 +-
 drivers/media/usb/dvb-usb-v2/dvbsky.c   |  26 +-
 drivers/media/usb/em28xx/Kconfig        |   2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c   |  13 +-
 15 files changed, 331 insertions(+), 770 deletions(-)
 delete mode 100644 drivers/media/tuners/m88ts2022.c
 delete mode 100644 drivers/media/tuners/m88ts2022.h
 delete mode 100644 drivers/media/tuners/m88ts2022_priv.h

-- 
http://palosaari.fi/

