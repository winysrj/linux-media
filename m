Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55021 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932651AbcIEKcs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 06:32:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 00/12] Fix ISDB-T tuning on PV SBTVD Hybrid
Date: Mon,  5 Sep 2016 07:32:28 -0300
Message-Id: <cover.1473071468.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fix a series of bugs and issues related to PV SBTVD device
while tuning to ISDB-T channels found in Brazil.

Mauro Carvalho Chehab (12):
  [media] cx231xx: don't return error on success
  [media] cx231xx: fix GPIOs for Pixelview SBTVD hybrid
  [media] cx231xx: prints error code if can't switch TV mode
  [media] mb86a20s: fix the locking logic
  [media] cx231xx: fix PV SBTVD Hybrid AGC GPIO pin
  [media] mb86a20s: fix demod settings
  [media] cx231xx-core: fix GPIO comments
  [media] cx231xx-i2c: handle errors with cx231xx_get_i2c_adap()
  [media] cx231xx: can't proceed if I2C bus register fails
  [media] cx231xx-cards: unregister IR earlier
  [media] tda18271: use prefix on all printk messages
  [media] tea5767: use module prefix on printed messages

 drivers/media/dvb-frontends/mb86a20s.c     | 104 +++++++++++++++--------------
 drivers/media/tuners/tda18271-fe.c         |  11 +--
 drivers/media/tuners/tda18271-priv.h       |   2 +
 drivers/media/tuners/tea5767.c             |   9 ++-
 drivers/media/usb/cx231xx/cx231xx-avcore.c |   5 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c  |   6 +-
 drivers/media/usb/cx231xx/cx231xx-core.c   |  44 +++++++++---
 drivers/media/usb/cx231xx/cx231xx-i2c.c    |   2 +-
 8 files changed, 108 insertions(+), 75 deletions(-)

-- 
2.7.4


