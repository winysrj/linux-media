Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39631 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbcBGTzJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2016 14:55:09 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Benjamin Larsson <benjamin@southpole.se>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/4] move mn88473 out of staging
Date: Sun,  7 Feb 2016 21:54:46 +0200
Message-Id: <1454874890-10724-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches are available also:
http://git.linuxtv.org/anttip/media_tree.git/log/?h=astrometa

Firmware:
http://palosaari.fi/linux/v4l-dvb/firmware/MN88473/01/

Antti

Antti Palosaari (4):
  mn88473: move out of staging
  mn88473: finalize driver
  rtl2832: improve slave TS control
  rtl2832: move stats polling to read status

 MAINTAINERS                                  |   4 +-
 drivers/media/dvb-frontends/Kconfig          |   8 +
 drivers/media/dvb-frontends/Makefile         |   1 +
 drivers/media/dvb-frontends/mn88473.c        | 606 +++++++++++++++++++++++++++
 drivers/media/dvb-frontends/mn88473.h        |  14 +-
 drivers/media/dvb-frontends/mn88473_priv.h   |  36 ++
 drivers/media/dvb-frontends/rtl2832.c        | 151 ++++---
 drivers/media/dvb-frontends/rtl2832.h        |   4 +-
 drivers/media/dvb-frontends/rtl2832_priv.h   |   1 -
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c      |  24 +-
 drivers/staging/media/Kconfig                |   2 -
 drivers/staging/media/Makefile               |   1 -
 drivers/staging/media/mn88473/Kconfig        |   7 -
 drivers/staging/media/mn88473/Makefile       |   5 -
 drivers/staging/media/mn88473/TODO           |  21 -
 drivers/staging/media/mn88473/mn88473.c      | 522 -----------------------
 drivers/staging/media/mn88473/mn88473_priv.h |  37 --
 17 files changed, 743 insertions(+), 701 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/mn88473.c
 create mode 100644 drivers/media/dvb-frontends/mn88473_priv.h
 delete mode 100644 drivers/staging/media/mn88473/Kconfig
 delete mode 100644 drivers/staging/media/mn88473/Makefile
 delete mode 100644 drivers/staging/media/mn88473/TODO
 delete mode 100644 drivers/staging/media/mn88473/mn88473.c
 delete mode 100644 drivers/staging/media/mn88473/mn88473_priv.h

-- 
http://palosaari.fi/

