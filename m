Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:37397 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164Ab1DMKMG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 06:12:06 -0400
Message-ID: <4DA576F1.5040602@iki.fi>
Date: Wed, 13 Apr 2011 13:12:01 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [GIT PULL FOR 2.6.40] Anysee
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moikka Mauro,

PULL following patches for the 2.6.40.
There is new silicon tuner driver for NXP TDA18212HN.

This basically adds support for two Anysee models:
1. E30 Combo Plus (new revision, TDA18212 tuner)
2. E7 TC



t. Antti


The following changes since commit d9954d8547181f9a6a23f835cc1413732700b785:

   Merge branch 'linus' into staging/for_v2.6.40 (2011-04-04 16:04:30 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git anysee

Antti Palosaari (12):
       NXP TDA18212HN silicon tuner driver
       anysee: I2C address fix
       anysee: fix multibyte I2C read
       anysee: change some messages
       anysee: reimplement demod and tuner attach
       anysee: add support for TDA18212 based E30 Combo Plus
       anysee: add support for Anysee E7 TC
       anysee: fix E30 Combo Plus TDA18212 GPIO
       anysee: fix E30 Combo Plus TDA18212 DVB-T
       anysee: enhance demod and tuner attach
       anysee: add support for two byte I2C address
       anysee: add more info about known board configs

  drivers/media/common/tuners/Kconfig         |    8 +
  drivers/media/common/tuners/Makefile        |    1 +
  drivers/media/common/tuners/tda18212.c      |  265 ++++++++++++++
  drivers/media/common/tuners/tda18212.h      |   48 +++
  drivers/media/common/tuners/tda18212_priv.h |   44 +++
  drivers/media/dvb/dvb-usb/Kconfig           |    1 +
  drivers/media/dvb/dvb-usb/anysee.c          |  519 
+++++++++++++++++++++-----
  drivers/media/dvb/dvb-usb/anysee.h          |   22 +-
  8 files changed, 806 insertions(+), 102 deletions(-)
  create mode 100644 drivers/media/common/tuners/tda18212.c
  create mode 100644 drivers/media/common/tuners/tda18212.h
  create mode 100644 drivers/media/common/tuners/tda18212_priv.h



-- 
http://palosaari.fi/
