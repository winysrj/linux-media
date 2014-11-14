Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44133 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933977AbaKNBwP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Nov 2014 20:52:15 -0500
Received: from dyn3-82-128-184-234.psoas.suomi.net ([82.128.184.234] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1Xp63Z-0006f0-Mv
	for linux-media@vger.kernel.org; Fri, 14 Nov 2014 03:52:13 +0200
Message-ID: <5465604D.4090003@iki.fi>
Date: Fri, 14 Nov 2014 03:52:13 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] Panasonic MN8847 and MN88473
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit dd0a6fe2bc3055cd61e369f97982c88183b1f0a0:

   [media] dvb-usb-dvbsky: fix i2c adapter for sp2 device (2014-11-11 
12:55:32 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git astrometa

for you to fetch changes up to 9e0d9707648a6ef3def5a468ac57047bf8632d29:

   rtl28xxu: add SDR module for devices having R828D tuner (2014-11-12 
05:58:07 +0200)

----------------------------------------------------------------
Antti Palosaari (28):
       mn88472: Panasonic MN88472 demod driver (DVB-C only)
       mn88472: correct attach symbol name
       mn88472: add small delay to wait DVB-C lock
       mn88472: rename mn88472_c.c => mn88472.c
       mn88472: rename state to dev
       mn88472: convert driver to I2C client
       mn88472: Convert driver to I2C RegMap API
       mn88472: implement DVB-T and DVB-T2
       mn88472: move to staging
       mn88472: add staging TODO
       MAINTAINERS: add mn88472 (Panasonic MN88472)
       mn88473: Panasonic MN88473 DVB-T/T2/C demod driver
       mn88473: add support for DVB-T2
       mn88473: implement DVB-T mode
       mn88473: improve IF frequency and BW handling
       mn88473: convert driver to I2C binding
       mn88473: convert to RegMap API
       mn88473: move to staging
       mn88473: add staging TODO
       MAINTAINERS: add mn88473 (Panasonic MN88473)
       r820t: add DVB-C config
       rtl2832: implement PIP mode
       rtl28xxu: enable demod ADC only when needed
       rtl28xxu: add support for Panasonic MN88472 slave demod
       rtl28xxu: add support for Panasonic MN88473 slave demod
       rtl28xxu: rename tuner I2C client pointer
       rtl28xxu: remove unused SDR attach logic
       rtl28xxu: add SDR module for devices having R828D tuner

  MAINTAINERS                                  |  22 +++++++
  drivers/media/dvb-frontends/mn88472.h        |  38 ++++++++++++
  drivers/media/dvb-frontends/mn88473.h        |  38 ++++++++++++
  drivers/media/dvb-frontends/rtl2832.c        |  42 ++++++++++++-
  drivers/media/tuners/r820t.c                 |  12 ++++
  drivers/media/usb/dvb-usb-v2/Kconfig         |   2 +
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c      | 239 
++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
  drivers/media/usb/dvb-usb-v2/rtl28xxu.h      |   8 ++-
  drivers/staging/media/Kconfig                |   4 ++
  drivers/staging/media/Makefile               |   2 +
  drivers/staging/media/mn88472/Kconfig        |   7 +++
  drivers/staging/media/mn88472/Makefile       |   5 ++
  drivers/staging/media/mn88472/TODO           |  21 +++++++
  drivers/staging/media/mn88472/mn88472.c      | 523 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/staging/media/mn88472/mn88472_priv.h |  36 +++++++++++
  drivers/staging/media/mn88473/Kconfig        |   7 +++
  drivers/staging/media/mn88473/Makefile       |   5 ++
  drivers/staging/media/mn88473/TODO           |  21 +++++++
  drivers/staging/media/mn88473/mn88473.c      | 464 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/staging/media/mn88473/mn88473_priv.h |  36 +++++++++++
  20 files changed, 1464 insertions(+), 68 deletions(-)
  create mode 100644 drivers/media/dvb-frontends/mn88472.h
  create mode 100644 drivers/media/dvb-frontends/mn88473.h
  create mode 100644 drivers/staging/media/mn88472/Kconfig
  create mode 100644 drivers/staging/media/mn88472/Makefile
  create mode 100644 drivers/staging/media/mn88472/TODO
  create mode 100644 drivers/staging/media/mn88472/mn88472.c
  create mode 100644 drivers/staging/media/mn88472/mn88472_priv.h
  create mode 100644 drivers/staging/media/mn88473/Kconfig
  create mode 100644 drivers/staging/media/mn88473/Makefile
  create mode 100644 drivers/staging/media/mn88473/TODO
  create mode 100644 drivers/staging/media/mn88473/mn88473.c
  create mode 100644 drivers/staging/media/mn88473/mn88473_priv.h

-- 
http://palosaari.fi/
