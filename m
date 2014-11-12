Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40429 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbaKLEXX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:23:23 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/8] Astrometa DVB USB support
Date: Wed, 12 Nov 2014 06:23:02 +0200
Message-Id: <1415766190-24482-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is 2 device versions. Other has Panasonic MN88472 demod and
the other Panasonic MN88473 demod.

Both demod drivers will go to staging due to multiple problems.

Antti Palosaari (8):
  r820t: add DVB-C config
  rtl2832: implement PIP mode
  rtl28xxu: enable demod ADC only when needed
  rtl28xxu: add support for Panasonic MN88472 slave demod
  rtl28xxu: add support for Panasonic MN88473 slave demod
  rtl28xxu: rename tuner I2C client pointer
  rtl28xxu: remove unused SDR attach logic
  rtl28xxu: add SDR module for devices having R828D tuner

 drivers/media/dvb-frontends/rtl2832.c   |  42 +++++-
 drivers/media/tuners/r820t.c            |  12 ++
 drivers/media/usb/dvb-usb-v2/Kconfig    |   2 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 239 +++++++++++++++++++++++---------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |   8 +-
 5 files changed, 235 insertions(+), 68 deletions(-)

-- 
http://palosaari.fi/

