Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54464 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbaDOJcG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 05:32:06 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 00/10] [2013:025f] PCTV tripleStick (292e)
Date: Tue, 15 Apr 2014 12:31:36 +0300
Message-Id: <1397554306-14561-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

http://blog.palosaari.fi/2014/04/naked-hardware-15-pctv-triplestick-292e.html


Antti

Antti Palosaari (10):
  si2157: Silicon Labs Si2157 silicon tuner driver
  si2168: Silicon Labs Si2168 DVB-T/T2/C demod driver
  em28xx: add [2013:025f] PCTV tripleStick (292e)
  si2168: add support for DVB-T2
  si2157: extend frequency range for DVB-C
  si2168: add support for DVB-C (annex A version)
  si2157: add copyright and license
  si2168: add copyright and license
  MAINTAINERS: add si2168 driver
  MAINTAINERS: add si2157 driver

 MAINTAINERS                               |  20 +
 drivers/media/dvb-frontends/Kconfig       |   7 +
 drivers/media/dvb-frontends/Makefile      |   1 +
 drivers/media/dvb-frontends/si2168.c      | 763 ++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/si2168.h      |  39 ++
 drivers/media/dvb-frontends/si2168_priv.h |  46 ++
 drivers/media/tuners/Kconfig              |   7 +
 drivers/media/tuners/Makefile             |   1 +
 drivers/media/tuners/si2157.c             | 260 ++++++++++
 drivers/media/tuners/si2157.h             |  34 ++
 drivers/media/tuners/si2157_priv.h        |  37 ++
 drivers/media/usb/em28xx/Kconfig          |   2 +
 drivers/media/usb/em28xx/em28xx-cards.c   |  25 +
 drivers/media/usb/em28xx/em28xx-dvb.c     |  73 +++
 drivers/media/usb/em28xx/em28xx.h         |   1 +
 15 files changed, 1316 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/si2168.c
 create mode 100644 drivers/media/dvb-frontends/si2168.h
 create mode 100644 drivers/media/dvb-frontends/si2168_priv.h
 create mode 100644 drivers/media/tuners/si2157.c
 create mode 100644 drivers/media/tuners/si2157.h
 create mode 100644 drivers/media/tuners/si2157_priv.h

-- 
1.9.0

