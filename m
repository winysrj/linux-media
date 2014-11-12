Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38745 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933981AbaKLETk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:19:40 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/9] Panasonic MN88473 DVB-T/T2/C demod driver
Date: Wed, 12 Nov 2014 06:19:22 +0200
Message-Id: <1415765971-24378-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reverse-engineered driver, which I moved to staging, due to
quality issues. Chip documentation would be nice. Any help to
pressure Panasonic to release documentation is welcome.


Here is device internals:
http://blog.palosaari.fi/2014/09/naked-hardware-18-astrometa-amdvb-t2-v2.html


Antti Palosaari (9):
  mn88473: Panasonic MN88473 DVB-T/T2/C demod driver
  mn88473: add support for DVB-T2
  mn88473: implement DVB-T mode
  mn88473: improve IF frequency and BW handling
  mn88473: convert driver to I2C binding
  mn88473: convert to RegMap API
  mn88473: move to staging
  mn88473: add staging TODO
  MAINTAINERS: add mn88473 (Panasonic MN88473)

 MAINTAINERS                                  |  11 +
 drivers/media/dvb-frontends/mn88473.h        |  38 +++
 drivers/staging/media/Kconfig                |   2 +
 drivers/staging/media/Makefile               |   1 +
 drivers/staging/media/mn88473/Kconfig        |   7 +
 drivers/staging/media/mn88473/Makefile       |   5 +
 drivers/staging/media/mn88473/TODO           |  21 ++
 drivers/staging/media/mn88473/mn88473.c      | 464 +++++++++++++++++++++++++++
 drivers/staging/media/mn88473/mn88473_priv.h |  36 +++
 9 files changed, 585 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/mn88473.h
 create mode 100644 drivers/staging/media/mn88473/Kconfig
 create mode 100644 drivers/staging/media/mn88473/Makefile
 create mode 100644 drivers/staging/media/mn88473/TODO
 create mode 100644 drivers/staging/media/mn88473/mn88473.c
 create mode 100644 drivers/staging/media/mn88473/mn88473_priv.h

-- 
http://palosaari.fi/

