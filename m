Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57335 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371AbaKLELg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:11:36 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 00/11] Panasonic MN88472 DVB-T/T2/C demod driver
Date: Wed, 12 Nov 2014 06:11:06 +0200
Message-Id: <1415765477-23153-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reverse-engineered driver, which I moved to staging, due to
quality issues. Chip documentation would be nice. Any help to
pressure Panasonic to release documentation is welcome.


MS recently released Xbox One Digital TV Tuner is build upon that same demod chip.
https://tvheadend.org/boards/5/topics/13685


Here is device internals:
http://blog.palosaari.fi/2013/10/naked-hardware-14-dvb-t2-usb-tv-stick.html



Antti Palosaari (11):
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

 MAINTAINERS                                  |  11 +
 drivers/media/dvb-frontends/mn88472.h        |  38 ++
 drivers/staging/media/Kconfig                |   2 +
 drivers/staging/media/Makefile               |   1 +
 drivers/staging/media/mn88472/Kconfig        |   7 +
 drivers/staging/media/mn88472/Makefile       |   5 +
 drivers/staging/media/mn88472/TODO           |  21 ++
 drivers/staging/media/mn88472/mn88472.c      | 523 +++++++++++++++++++++++++++
 drivers/staging/media/mn88472/mn88472_priv.h |  36 ++
 9 files changed, 644 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/mn88472.h
 create mode 100644 drivers/staging/media/mn88472/Kconfig
 create mode 100644 drivers/staging/media/mn88472/Makefile
 create mode 100644 drivers/staging/media/mn88472/TODO
 create mode 100644 drivers/staging/media/mn88472/mn88472.c
 create mode 100644 drivers/staging/media/mn88472/mn88472_priv.h

-- 
http://palosaari.fi/

