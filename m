Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.198]:59350 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaGMNwg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jul 2014 09:52:36 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 0/6] [0b48:3014] TechnoTrend TVStick CT2-4400
Date: Sun, 13 Jul 2014 16:52:16 +0300
Message-Id: <1405259542-32529-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TechnoTrend TVStick CT2-4400 is a USB 2.0 DVB C/T/T2 tuner with the
following components.

USB bridge: Cypress FX2
Demodulator: Silicon Labs Si2168-A30
Tuner: Silicon Labs Si2158-A20

Both the demodulator and the tuner need a firmware. These can be
extracted from TT drivers.

Download: http://www.tt-downloads.de/bda-treiber_4.2.0.0.zip

Extract firmware from file ttTVStick4400_64.sys in the zip (MD5 sum below):
0276023ce027bab05c2e7053033e2182  ttTVStick4400_64.sys

dd if=ttTVStick4400_64.sys ibs=1 skip=211216 count=17576 of=dvb-demod-si2168-30-01.fw
dd if=ttTVStick4400_64.sys ibs=1 skip=200816 count=3944 of=dvb-tuner-si2158-20-01.fw

Olli Salonen (6):
  si2168: Small typo fix (SI2157 -> SI2168)
  si2168: Add handling for different chip revisions and firmwares
  si2157: Move chip initialization to si2157_init
  si2157: Add support for Si2158 chip
  si2157: Set delivery system and bandwidth before tuning
  cxusb: TechnoTrend CT2-4400 USB DVB-T2/C tuner support

 drivers/media/dvb-core/dvb-usb-ids.h      |   1 +
 drivers/media/dvb-frontends/si2168.c      |  34 +++++-
 drivers/media/dvb-frontends/si2168_priv.h |   8 +-
 drivers/media/tuners/si2157.c             | 161 +++++++++++++++++++------
 drivers/media/tuners/si2157.h             |   2 +-
 drivers/media/tuners/si2157_priv.h        |   5 +-
 drivers/media/usb/dvb-usb/Kconfig         |   3 +
 drivers/media/usb/dvb-usb/cxusb.c         | 191 +++++++++++++++++++++++++++++-
 drivers/media/usb/dvb-usb/cxusb.h         |   2 +
 9 files changed, 357 insertions(+), 50 deletions(-)

-- 
1.9.1

